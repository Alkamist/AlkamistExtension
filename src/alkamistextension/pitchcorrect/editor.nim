import
  std/[math, options, random],
  ../reaper/[window, mouse, keyboard, lice],
  viewaxis

export viewaxis

func getWhiteKeyNumbers(): seq[int] =
  const whiteKeyMultiples = [0, 2, 3, 5, 7, 8, 10]
  for i in 0 .. 10:
    for multiple in whiteKeyMultiples:
      result.add i * 12 + multiple

const whiteKeyNumbers = getWhiteKeyNumbers()

type
  PitchPoint* = object
    time*: float
    pitch*: float

  PitchCorrection* = object
    points*: seq[PitchPoint]

  PitchEditor* = ref object
    x*, y*: int
    bitmap*: Bitmap
    numPitches*: int
    timeLength*: float
    xView*: ViewAxis
    yView*: ViewAxis
    backgroundColor*: Color
    blackKeyColor*: Color
    whiteKeyColor*: Color
    correctionPointSelectionDistance*: float
    correctionPointVisualRadius*: float
    mouseMiddleWasPressedInside: bool
    corrections: seq[PitchCorrection]

func width*(editor: PitchEditor): int =
  editor.xView.scale.round.int

func height*(editor: PitchEditor): int =
  editor.yView.scale.round.int

proc resize*(editor: var PitchEditor, width, height: int) =
  editor.xView.scale = width.float
  editor.yView.scale = height.float
  editor.bitmap.resize(width, height)

proc `width=`*(editor: var PitchEditor, value: int) =
  editor.resize(value, editor.height)

proc `height=`*(editor: var PitchEditor, value: int) =
  editor.resize(editor.width, value)

func xToTime*(editor: PitchEditor, x: float): float =
  editor.timeLength * (editor.xView.pan + x / (editor.width.float * editor.xView.zoom))

func yToPitch*(editor: PitchEditor, y: float): float =
  editor.numPitches.float * (1.0 - (editor.yView.pan + y / (editor.height.float * editor.yView.zoom))) - 0.5

func timeToX*(editor: PitchEditor, time: float): float =
  editor.xView.zoom * editor.width.float * (time / editor.timeLength - editor.xView.pan)

func pitchToY*(editor: PitchEditor, pitch: float): float =
  editor.yView.zoom * editor.height.float * ((1.0 - (0.5 + pitch) / editor.numPitches.float) - editor.yView.pan)

proc newPitchEditor*(x, y, width, height: int): PitchEditor =
  result = PitchEditor()
  result.timeLength = 10.0
  result.numPitches = 128
  result.xView = initViewAxis()
  result.yView = initViewAxis()
  result.resize(width, height)
  result.bitmap = initBitmap(width, height)
  result.backgroundColor = rgb(16, 16, 16)
  result.blackKeyColor = rgb(60, 60, 60, 1.0)
  result.whiteKeyColor = rgb(110, 110, 110, 1.0)
  result.correctionPointSelectionDistance = 5.0
  result.correctionPointVisualRadius = 3.0

  for correctionId in 0 ..< 10:
    var correction = PitchCorrection()

    for pointId in 0 ..< 5:
      let pointNumber = 5 * correctionId + pointId
      correction.points.add PitchPoint(
        time: pointNumber.float,
        pitch: rand(128).float,
      )

    result.corrections.add correction

func positionIsInside*(editor: PitchEditor, x, y: int): bool =
  x >= editor.x and
  x <= editor.x + editor.width and
  y >= editor.y and
  y <= editor.y + editor.height

# func calculateClosestPointToMouse(editor: var PitchEditor, window: Window) =
#   editor.closestPointToMouse = none(ptr PitchPoint)

#   var closestX, closestY, closestDistance: float

#   for point in editor.correctionPoints.mitems:
#     let
#       mouseX = window.mouseX.float
#       mouseY = window.mouseY.float
#       pointX = editor.timeToX(point.time)
#       pointY = editor.pitchToY(point.pitch)
#       mouseDistance = sqrt(pow(mouseY - pointY, 2) + pow(mouseX - pointX, 2))
#       mouseIsInside = mouseDistance <= editor.correctionPointSelectionDistance

#     if mouseIsInside:
#       if editor.closestPointToMouse.isSome:
#         if mouseDistance < closestDistance:
#           editor.closestPointToMouse = some(point.addr)
#           closestX = pointX
#           closestY = pointY
#           closestDistance = mouseDistance
#       else:
#         editor.closestPointToMouse = some(point.addr)
#         closestX = pointX
#         closestY = pointY
#         closestDistance = mouseDistance

func onMousePress*(editor: var PitchEditor, window: Window, button: MouseButton) =
  case button:
  of Middle:
    if editor.positionIsInside(window.mouseX, window.mouseY):
      editor.mouseMiddleWasPressedInside = true
      editor.xView.target = -window.mouseX.float
      editor.yView.target = -window.mouseY.float
  else: discard

func onMouseRelease*(editor: var PitchEditor, window: Window, button: MouseButton) =
  case button:
  of Middle:
    editor.mouseMiddleWasPressedInside = false
  else: discard

func onMouseMove*(editor: var PitchEditor, window: Window, x, y, xPrevious, yPrevious: int) =
  let
    xChange = (x - xPrevious).float
    yChange = (y - yPrevious).float

  # editor.calculateClosestPointToMouse(window)

  if editor.mouseMiddleWasPressedInside and
     window.mouseButtonIsPressed(Middle):
    if window.keyIsPressed(Shift):
      editor.xView.changeZoom(xChange)
      editor.yView.changeZoom(yChange)
    else:
      editor.xView.changePan(-xChange)
      editor.yView.changePan(-yChange)

    window.redraw()

func onResize*(editor: var PitchEditor, window: Window) =
  editor.resize(window.width, window.height)
  window.redraw()

func drawKeys(editor: PitchEditor) =
  var
    keyEndPrevious = editor.pitchToY(editor.numPitches.float + 0.5)
    keyColorPrevious: Option[Color]

  for pitchId in 0 ..< editor.numPitches:
    let
      keyEnd = editor.pitchToY(editor.numPitches.float - (pitchId + 1).float + 0.5)
      keyHeight = keyEnd - keyEndPrevious
      keyColor =
        if whiteKeyNumbers.contains(pitchId):
          editor.whiteKeyColor
        else:
          editor.blackKeyColor

    editor.bitmap.fillRectangle(0, keyEnd.round.int, editor.width, keyHeight.round.int + 1, keyColor)

    if keyColorPrevious.isSome and keyColorPrevious.get == editor.whiteKeyColor:
      editor.bitmap.drawLine(0.0, keyEnd, editor.width.float, keyEnd, editor.blackKeyColor)

    keyEndPrevious = keyEnd
    keyColorPrevious = some(keyColor)

func drawPitchCorrections(editor: PitchEditor, window: Window) =
  let color = rgb(109, 186, 191)

  for correction in editor.corrections:
    let lastPointId = correction.points.len - 1

    for i, point in correction.points:
      let
        x = editor.timeToX(point.time)
        y = editor.pitchToY(point.pitch)
        r = editor.correctionPointVisualRadius

      if i < lastPointId:
        let
          nextPoint = correction.points[i + 1]
          nextX = editor.timeToX(nextPoint.time)
          nextY = editor.pitchToY(nextPoint.pitch)
        editor.bitmap.drawLine(x, y, nextX, nextY, color)

      editor.bitmap.fillCircle(x, y, r, rgb(29, 81, 84))
      editor.bitmap.drawCircle(x, y, r, color)

      # if editor.closestPointToMouse.isSome and
      #   point.addr == editor.closestPointToMouse.get:
      #   editor.bitmap.fillCircle(x, y, r, rgb(255, 255, 255, 0.35))

func updateBitmap*(editor: PitchEditor, window: Window) =
  editor.bitmap.clear(editor.backgroundColor)
  editor.drawKeys()
  editor.drawPitchCorrections(window)