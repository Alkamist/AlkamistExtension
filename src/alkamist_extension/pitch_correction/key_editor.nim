import
  std/math,
  ../reaper

func getWhiteKeyNumbers(): seq[int] =
  const whiteKeyMultiples = [1, 3, 4, 6, 8, 9, 11]
  for i in 0 .. 10:
    for multiple in whiteKeyMultiples:
      result.add i * 12 + multiple

const
  numPitches = 128
  whiteKeyNumbers = getWhiteKeyNumbers()

##########################################################
# ViewAxis
##########################################################

type
  ViewAxis* = object
    scale*: float
    zoom*: float
    pan*: float
    target*: float
    sensitivity*: float

proc initViewAxis*(): ViewAxis =
  result.scale = 1.0
  result.zoom = 1.0
  result.pan = 0.0
  result.target = 0.0
  result.sensitivity = 0.01

proc changePan*(axis: var ViewAxis, value: float) =
  let change = value / axis.scale
  axis.pan += change / axis.zoom

proc changeZoom*(axis: var ViewAxis, value: float) =
  let
    target = axis.target / axis.scale
    change = pow(2.0, axis.sensitivity * value)
  axis.zoom *= change
  axis.pan -= (change - 1.0) * target / axis.zoom

proc transform*(axis: ViewAxis, value: float): float =
  axis.scale * axis.zoom * (value + axis.pan)

##########################################################
# KeyEditor
##########################################################

type
  KeyEditor* = object
    x*: float
    y*: float
    width*: float
    height*: float
    timeLength*: float
    xView*: ViewAxis
    yView*: ViewAxis
    blackKeyColor*: Color
    whiteKeyColor*: Color

# proc editorXToTime(x: float, editor: KeyEditor, window: Window): float =
#   editor.timeLength * (editor.xScroll + x / (editor.width * editor.xZoom))

# proc editorYToPitch(y: float, editor: KeyEditor, window: Window): float =
#   numPitches.float * (1.0 - (editor.yScroll + y / (editor.height * editor.yZoom))) - 0.5

# proc timeToEditorX(time: float, editor: KeyEditor, window: Window): float =
#   editor.xZoom * editor.width * (time / editor.timeLength - editor.xScroll)

proc pitchToEditorY(pitch: float, editor: KeyEditor, window: Window): float =
  editor.yView.zoom * editor.height * ((1.0 - (0.5 + pitch) / numPitches.float) - editor.yView.pan)

proc initKeyEditor*(): KeyEditor =
  result.width = 800.0
  result.height = 600.0
  result.xView = initViewAxis()
  result.yView = initViewAxis()
  result.blackKeyColor = initColor(60, 60, 60)
  result.whiteKeyColor = initColor(130, 130, 130)

proc draw*(editor: var KeyEditor, window: var Window) =
  var keyEndPrevious = pitchToEditorY(numPitches + 0.5, editor, window)

  for pitchId in 0 ..< numPitches:
    let
      keyEnd = pitchToEditorY(numPitches - (pitchId + 1).float + 0.5, editor, window)
      keyHeight = keyEnd - keyEndPrevious

    if whiteKeyNumbers.contains(pitchId):
      window.updatePenColor(editor.whiteKeyColor)
      window.updateBrushColor(editor.whiteKeyColor)
    else:
      window.updatePenColor(editor.blackKeyColor)
      window.updateBrushColor(editor.blackKeyColor)

    window.drawRectangle(editor.x, editor.y + keyEnd, editor.width, keyHeight + 1)

    keyEndPrevious = keyEnd