import
  std/math,
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
  KeyEditor* = object
    x*, y*: int
    bitmap*: Bitmap
    numPitches*: int
    timeLength*: float
    xView*: ViewAxis
    yView*: ViewAxis
    backgroundColor*: Color
    blackKeyColor*: Color
    whiteKeyColor*: Color
    mouseMiddleWasPressedInside*: bool

func width*(editor: KeyEditor): int =
  editor.xView.scale.round.int

func height*(editor: KeyEditor): int =
  editor.yView.scale.round.int

proc resize*(editor: var KeyEditor, width, height: int) =
  editor.xView.scale = width.float
  editor.yView.scale = height.float
  editor.bitmap.resize(width, height)

proc `width=`*(editor: var KeyEditor, value: int) =
  editor.resize(value, editor.height)

proc `height=`*(editor: var KeyEditor, value: int) =
  editor.resize(editor.width, value)

func xToTime*(editor: KeyEditor, x: float): float =
  editor.timeLength * (editor.xView.pan + x / (editor.width.float * editor.xView.zoom))

func yToPitch*(editor: KeyEditor, y: float): float =
  editor.numPitches.float * (1.0 - (editor.yView.pan + y / (editor.height.float * editor.yView.zoom))) - 0.5

func timeToX*(editor: KeyEditor, time: float): float =
  editor.xView.zoom * editor.width.float * (time / editor.timeLength - editor.xView.pan)

func pitchToY*(editor: KeyEditor, pitch: float): float =
  editor.yView.zoom * editor.height.float * ((1.0 - (0.5 + pitch) / editor.numPitches.float) - editor.yView.pan)

func initKeyEditor*(x, y, width, height: int): KeyEditor =
  result.numPitches = 128
  result.xView = initViewAxis()
  result.yView = initViewAxis()
  result.resize(width, height)
  result.bitmap = newBitmap(width, height)
  result.backgroundColor = rgb(16, 16, 16)
  result.blackKeyColor = rgb(60, 60, 60, 1.0)
  result.whiteKeyColor = rgb(110, 110, 110, 1.0)

func positionIsInside*(editor: KeyEditor, x, y: int): bool =
  x >= editor.x and
  x <= editor.x + editor.width and
  y >= editor.y and
  y <= editor.y + editor.height

func onMousePress*(editor: var KeyEditor, window: Window, button: MouseButton) =
  case button:
  of Middle:
    if editor.positionIsInside(window.mouseX, window.mouseY):
      editor.mouseMiddleWasPressedInside = true
      editor.xView.target = window.mouseX.float
      editor.yView.target = -window.mouseY.float
  else: discard

func onMouseRelease*(editor: var KeyEditor, window: Window, button: MouseButton) =
  case button:
  of Middle:
    editor.mouseMiddleWasPressedInside = false
  else: discard

func onMouseMove*(editor: var KeyEditor, window: Window, x, y, xPrevious, yPrevious: int) =
  let
    xChange = (x - xPrevious).float
    yChange = (y - yPrevious).float

  if editor.mouseMiddleWasPressedInside and
     window.mouseButtonIsPressed(Middle):
    if window.keyIsPressed(Shift):
      editor.xView.changeZoom(xChange)
      editor.yView.changeZoom(yChange)
    else:
      editor.xView.changePan(xChange)
      editor.yView.changePan(-yChange)

    window.redraw()

func onResize*(editor: var KeyEditor, window: Window) =
  editor.resize(window.width, window.height)
  window.redraw()

func updateBitmap*(editor: KeyEditor) =
  editor.bitmap.clear(editor.backgroundColor)

  var keyEndPrevious = editor.pitchToY(editor.numPitches.float + 0.5)

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

    keyEndPrevious = keyEnd