import ../reaper, view_axis

func getWhiteKeyNumbers(): seq[int] =
  const whiteKeyMultiples = [1, 3, 4, 6, 8, 9, 11]
  for i in 0 .. 10:
    for multiple in whiteKeyMultiples:
      result.add i * 12 + multiple

const
  numPitches = 128
  whiteKeyNumbers = getWhiteKeyNumbers()

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

proc editorXToTime(x: float, editor: KeyEditor, window: Window): float =
  editor.timeLength * (editor.xView.pan + x / (editor.width * editor.xView.zoom))

proc editorYToPitch(y: float, editor: KeyEditor, window: Window): float =
  numPitches.float * (1.0 - (editor.yView.pan + y / (editor.height * editor.yView.zoom))) - 0.5

proc timeToEditorX(time: float, editor: KeyEditor, window: Window): float =
  editor.xView.zoom * editor.width * (time / editor.timeLength - editor.xView.pan)

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