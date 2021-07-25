import
  std/[math, options, random, decls],
  ../reaper/[window, mouse, keyboard, lice],
  viewaxis, math2d

export viewaxis

const numKeys = 128

func getWhiteKeyNumbers(): seq[int] {.compileTime.} =
  const whiteKeyMultiples = [0, 2, 3, 5, 7, 8, 10]
  for i in 0 .. 10:
    for multiple in whiteKeyMultiples:
      result.add i * 12 + multiple

func getIsWhiteKeyArray(): array[numKeys, bool] {.compileTime.} =
  let whiteKeyNumbers = getWhiteKeyNumbers()
  for i in 0 ..< numKeys:
    result[i] = whiteKeyNumbers.contains(i)

const isWhiteKeyArray = getIsWhiteKeyArray()

func isWhiteKey(index: int): bool =
  isWhiteKeyArray[index]

type
  PitchEditor* = ref object
    x*, y*: int
    bitmap*: Bitmap
    timeLength*: float
    xView*: ViewAxis
    yView*: ViewAxis
    backgroundColor*: Color
    blackKeyColor*: Color
    whiteKeyColor*: Color
    correctionEditDistance*: float
    correctionPointVisualRadius*: float
    mouseMiddleWasPressedInside: bool
    corrections: PolyLineGroup2d
    mouseIsNearCorrectionPoint: bool
    mouseIsNearCorrectionSegment: bool

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
  numKeys.float * (1.0 - (editor.yView.pan + y / (editor.height.float * editor.yView.zoom))) - 0.5

func timeToX*(editor: PitchEditor, time: float): float =
  editor.xView.zoom * editor.width.float * (time / editor.timeLength - editor.xView.pan)

func pitchToY*(editor: PitchEditor, pitch: float): float =
  editor.yView.zoom * editor.height.float * ((1.0 - (0.5 + pitch) / numKeys.float) - editor.yView.pan)

proc newPitchEditor*(x, y, width, height: int): PitchEditor =
  result = PitchEditor()
  result.timeLength = 10.0
  result.xView = initViewAxis()
  result.yView = initViewAxis()
  result.resize(width, height)
  result.bitmap = initBitmap(width, height)
  result.backgroundColor = rgb(16, 16, 16)
  result.blackKeyColor = rgb(60, 60, 60, 1.0)
  result.whiteKeyColor = rgb(110, 110, 110, 1.0)
  result.correctionEditDistance = 5.0
  result.correctionPointVisualRadius = 3.0

  result.corrections = newPolyLineGroup2d()

  for correctionId in 0 ..< 5:
    var correction = newPolyLine2d()

    for pointId in 0 ..< 5:
      let pointNumber = 5 * correctionId + pointId
      correction.points.add (
        x: pointNumber.float,
        y: rand(numKeys).float,
      )

    result.corrections.lines.add correction

func positionIsInside*(editor: PitchEditor, x, y: int): bool =
  x >= editor.x and
  x <= editor.x + editor.width and
  y >= editor.y and
  y <= editor.y + editor.height

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

  editor.corrections.calculateEditPointAndSegment(
    (editor.xToTime(x.float), editor.yToPitch(y.float))
  )

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
    keyEndPrevious = editor.pitchToY(numKeys.float + 0.5)
    keyColorPrevious: Option[Color]

  for pitchId in 0 ..< numKeys:
    let
      keyEnd = editor.pitchToY(numKeys.float - (pitchId + 1).float + 0.5)
      keyHeight = keyEnd - keyEndPrevious
      keyColor =
        if isWhiteKey(pitchId):
          editor.whiteKeyColor
        else:
          editor.blackKeyColor

    editor.bitmap.fillRectangle(0, keyEnd.round.int, editor.width, keyHeight.round.int + 1, keyColor)

    if keyColorPrevious.isSome and keyColorPrevious.get == editor.whiteKeyColor:
      editor.bitmap.drawLine(0.0, keyEnd, editor.width.float, keyEnd, editor.blackKeyColor)

    keyEndPrevious = keyEnd
    keyColorPrevious = some(keyColor)

func drawPitchCorrections(editor: PitchEditor, window: Window) =
  let
    r = editor.correctionPointVisualRadius
    color = rgb(109, 186, 191)
    highlightColor = rgb(255, 255, 255, 0.35)

  for correction in editor.corrections.lines.mitems:
    let lastPointId = correction.points.len - 1

    for i, point in correction.points.mpairs:
      let
        x = editor.timeToX(point.x)
        y = editor.pitchToY(point.y)

      if i < lastPointId:
        var nextPoint {.byaddr.} = correction.points[i + 1]

        let
          nextX = editor.timeToX(nextPoint.x)
          nextY = editor.pitchToY(nextPoint.y)

        editor.bitmap.drawLine(x, y, nextX, nextY, color)

        # if editor.corrections.editIsSegment and
        #    editor.corrections.editSegment[0] == point.addr and
        #    editor.corrections.editSegment[1] == nextPoint.addr:
        if correction.editIsSegment and
           correction.editSegment[0] == point.addr and
           correction.editSegment[1] == nextPoint.addr:
          editor.bitmap.drawLine(x, y, nextX, nextY, highlightColor)

      editor.bitmap.fillCircle(x, y, r, rgb(29, 81, 84))
      editor.bitmap.drawCircle(x, y, r, color)

      # if editor.corrections.editIsPoint and
      #    editor.corrections.editPoint == point.addr:
      #   editor.bitmap.fillCircle(x, y, r, highlightColor)

func updateBitmap*(editor: PitchEditor, window: Window) =
  editor.bitmap.clear(editor.backgroundColor)
  editor.drawKeys()
  editor.drawPitchCorrections(window)