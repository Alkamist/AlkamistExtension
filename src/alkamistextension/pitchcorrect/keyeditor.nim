import ../reaper, viewaxis

export viewaxis

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
    timeLength*: float
    xView*: ViewAxis
    yView*: ViewAxis
    blackKeyColor*: Color
    whiteKeyColor*: Color
    width: float
    height: float

proc `width=`*(editor: var KeyEditor, value: float) =
  editor.xView.scale = value
  editor.width = value

proc width*(editor: KeyEditor): float =
  editor.width

proc `height=`*(editor: var KeyEditor, value: float) =
  editor.yView.scale = value
  editor.height = value

proc height*(editor: KeyEditor): float =
  editor.height

proc editorXToTime*(editor: KeyEditor, x: float): float =
  editor.timeLength * (editor.xView.pan + x / (editor.width * editor.xView.zoom))

proc editorYToPitch*(editor: KeyEditor, y: float): float =
  numPitches.float * (1.0 - (editor.yView.pan + y / (editor.height * editor.yView.zoom))) - 0.5

proc timeToEditorX*(editor: KeyEditor, time: float): float =
  editor.xView.zoom * editor.width * (time / editor.timeLength - editor.xView.pan)

proc pitchToEditorY*(editor: KeyEditor, pitch: float): float =
  editor.yView.zoom * editor.height * ((1.0 - (0.5 + pitch) / numPitches.float) - editor.yView.pan)

proc initKeyEditor*(): KeyEditor =
  result.width = 800.0
  result.height = 600.0
  result.xView = initViewAxis()
  result.yView = initViewAxis()
  result.blackKeyColor = initColor(60, 60, 60)
  result.whiteKeyColor = initColor(130, 130, 130)

proc draw*(editor: var KeyEditor, window: var Window) =
  var keyEndPrevious = editor.pitchToEditorY(numPitches + 0.5)

  for pitchId in 0 ..< numPitches:
    let
      keyEnd = editor.pitchToEditorY(numPitches - (pitchId + 1).float + 0.5)
      keyHeight = keyEnd - keyEndPrevious

    if whiteKeyNumbers.contains(pitchId):
      window.updateColor(editor.whiteKeyColor)
    else:
      window.updateColor(editor.blackKeyColor)

    window.drawRectangle(editor.x, editor.y + keyEnd, editor.width, keyHeight + 1)

    keyEndPrevious = keyEnd