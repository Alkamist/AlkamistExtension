import
  ../lice, ../input, ../view, ../vector,
  ../reaper/functions,
  whitekeys, boxselect, pitchline

type
  PitchEditorColorScheme* = object
    background*: Color
    blackKeys*: Color
    whiteKeys*: Color
    centerLine*: Color

  PitchEditor* = ref object
    timeLength*: float
    image*: Image
    colorScheme*: PitchEditorColorScheme
    shouldRedraw*: bool
    position: (float, float)
    input: Input
    view: View
    mouseMiddleWasPressedInside: bool
    mouseRightWasPressedInside: bool
    boxSelect: BoxSelect
    correctionLine: PitchLine

defineInputProcs(PitchEditor, position)

{.push inline.}

func x*(editor: PitchEditor): float = editor.position.x
func x*(editor: var PitchEditor): var float = editor.position.x
func y*(editor: PitchEditor): float = editor.position.y
func y*(editor: var PitchEditor): var float = editor.position.y
func width*(editor: PitchEditor): float = editor.view.x.externalSize
func height*(editor: PitchEditor): float = editor.view.y.externalSize
func dimensions*(editor: PitchEditor): (float, float) = (editor.width, editor.height)
func dpi*(editor: PitchEditor): float = editor.image.dpi
func position*(editor: PitchEditor): (float, float) = editor.position

func `position=`*(editor: PitchEditor, value: (float, float)) =
  editor.position = value
  editor.correctionLine.parentPosition = value

func defaultPitchEditorColorScheme*(): PitchEditorColorScheme =
  result.background = rgb(16, 16, 16)
  result.blackKeys = rgb(48, 48, 48, 1.0)
  result.whiteKeys = rgb(76, 76, 76, 1.0)
  result.centerLine = rgb(255, 255, 255, 0.10)

func zoomOutXToFull*(editor: var PitchEditor) =
  editor.view.x.zoom = editor.width / editor.timeLength

func zoomOutYToFull*(editor: var PitchEditor) =
  editor.view.y.zoom = editor.height / numKeys.toFloat

func resize*(editor: var PitchEditor, dimensions: (float, float)) =
  editor.view.resize(dimensions)
  editor.correctionLine.updateVisualPositions()
  editor.image.resize(dimensions)

func mouseIsInside*(editor: PitchEditor): bool =
  editor.mousePosition.x >= 0.0 and
  editor.mousePosition.x <= editor.width and
  editor.mousePosition.y >= 0.0 and
  editor.mousePosition.y <= editor.height

func redraw*(editor: var PitchEditor) =
  editor.shouldRedraw = true

{.pop.}

func onMousePress*(editor: var PitchEditor) =
  if editor.mouseIsInside:
    case editor.lastMousePress:
    of Left:
      editor.correctionLine.onLeftPress()
      editor.redraw()
    of Middle:
      editor.mouseMiddleWasPressedInside = true
      editor.view.setZoomTargetExternally(editor.mousePosition)
    of Right:
      editor.mouseRightWasPressedInside = true
      editor.boxSelect.isActive = true
      editor.boxSelect.bounds = (editor.mousePosition, (0.0, 0.0))
    else:
      discard

  # let mouseInternal = editor.view.convertToInternal(editor.mousePosition)
  # ShowConsoleMsg($mouseInternal & "\n")
  # ShowConsoleMsg($editor.view.convertToExternal(mouseInternal) & "\n")

func onMouseRelease*(editor: var PitchEditor) =
  case editor.lastMouseRelease:
  of Left:
    editor.correctionLine.onLeftRelease()
    editor.redraw()
  of Middle:
    editor.mouseMiddleWasPressedInside = false
  of Right:
    editor.correctionLine.onRightRelease()
    editor.mouseRightWasPressedInside = false
    editor.boxSelect.isActive = false
  else:
    discard

func onMouseMove*(editor: var PitchEditor) =
  editor.correctionLine.onMouseMove()

  if editor.mouseRightWasPressedInside and editor.isPressed(Right):
    editor.boxSelect.points[1] = editor.mousePosition

  if editor.mouseMiddleWasPressedInside and editor.isPressed(Middle):
    if editor.isPressed(Shift): editor.view.changeZoom(editor.mouseDelta)
    else: editor.view.changePanExternally(-editor.mouseDelta)

  editor.redraw()

func onKeyPress*(editor: var PitchEditor) =
  case editor.lastKeyPress:
  of Delete:
    editor.correctionLine.deleteSelection()
    editor.redraw()
  else: discard

func onResize*(editor: var PitchEditor, dimensions: (float, float)) =
  editor.resize(dimensions)
  editor.redraw()

func drawKeys(editor: PitchEditor) {.inline.} =
  var keyColorPrevious = editor.colorScheme.blackKeys

  for pitchId in 0 ..< numKeys:
    let
      keyCenter = pitchId.toFloat
      keyBottom = keyCenter - 0.5
      keyTop = keyCenter + 0.5

      keyLeftInches = 0.0
      keyCenterInches = editor.view.y.convertToExternal(keyCenter)
      keyBottomInches = editor.view.y.convertToExternal(keyBottom)
      keyTopInches = editor.view.y.convertToExternal(keyTop) - (1.0 / 96.0)
      keyWidthInches = editor.width
      keyHeightInches = abs(keyTopInches - keyBottomInches)

      keyColor =
        if isWhiteKey(pitchId):
          editor.colorScheme.whiteKeys
        else:
          editor.colorScheme.blackKeys

    editor.image.fillRectangle(
      (keyLeftInches, keyTopInches),
      (keyWidthInches, keyHeightInches),
      keyColor,
    )

    if pitchId > 0 and
       keyColor == editor.colorScheme.whiteKeys and
       keyColorPrevious == editor.colorScheme.whiteKeys:
      editor.image.drawLine(
        (keyLeftInches, keyBottomInches),
        (keyWidthInches, keyBottomInches),
        editor.colorScheme.blackKeys,
      )

    if keyHeightInches * editor.dpi > 16.0:
      editor.image.drawLine(
        (keyLeftInches, keyCenterInches),
        (keyWidthInches, keyCenterInches),
        editor.colorScheme.centerLine,
      )

    keyColorPrevious = keyColor

func updateImage*(editor: PitchEditor) =
  editor.image.clear(editor.colorScheme.background)
  editor.drawKeys()
  editor.correctionLine.drawWithCirclePoints(editor.image)
  editor.boxSelect.draw(editor.image)

func newPitchEditor*(position: (float, float),
                     dimensions: (float, float),
                     dpi: float,
                     input: Input): PitchEditor =
  result = PitchEditor()
  result.input = input
  result.timeLength = 10.0
  result.view = newView()
  result.view.y.isInverted = true
  result.image = initImage(dpi, dimensions)
  result.colorScheme = defaultPitchEditorColorScheme()
  result.boxSelect = newBoxSelect()
  result.correctionLine = newPitchLine(position,
                                       result.view,
                                       result.input,
                                       result.boxSelect)
  result.position = position
  result.resize(dimensions)
  result.zoomOutXToFull()
  result.zoomOutYToFull()
  result.redraw()