import
  ../lice, ../input, ../view, ../reaper,
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
    pitchLine: PitchLine
    correctionLine: PitchLine
    isAnalyzingPitch: bool

defineInputProcs(PitchEditor, position)

func x*(editor: PitchEditor): float = editor.position[0]
func x*(editor: var PitchEditor): var float = editor.position[0]
func y*(editor: PitchEditor): float = editor.position[1]
func y*(editor: var PitchEditor): var float = editor.position[1]
func width*(editor: PitchEditor): float = editor.view.x.externalSize
func height*(editor: PitchEditor): float = editor.view.y.externalSize
func dimensions*(editor: PitchEditor): (float, float) = (editor.width, editor.height)
func dpi*(editor: PitchEditor): float = editor.image.dpi
func position*(editor: PitchEditor): (float, float) = editor.position

func `position=`*(editor: PitchEditor, value: (float, float)) =
  editor.position = value
  editor.pitchLine.parentPosition = value
  editor.correctionLine.parentPosition = value

func defaultPitchEditorColorScheme*(): PitchEditorColorScheme =
  result.background = rgb(16, 16, 16)
  result.blackKeys = rgb(48, 48, 48, 1.0)
  result.whiteKeys = rgb(76, 76, 76, 1.0)
  result.centerLine = rgb(255, 255, 255, 0.10)

func zoomOutXToFull*(editor: PitchEditor) =
  editor.view.x.zoom = editor.width / editor.timeLength

func zoomOutYToFull*(editor: PitchEditor) =
  editor.view.y.zoom = editor.height / numKeys.toFloat

func resize*(editor: PitchEditor, dimensions: (float, float)) =
  editor.view.resize(dimensions)
  editor.pitchLine.updateVisualPositions()
  editor.correctionLine.updateVisualPositions()
  editor.image.resize(dimensions)

func mouseIsInside*(editor: PitchEditor): bool =
  editor.mousePosition[0] >= 0.0 and
  editor.mousePosition[0] <= editor.width and
  editor.mousePosition[1] >= 0.0 and
  editor.mousePosition[1] <= editor.height

func redraw*(editor: PitchEditor) =
  editor.shouldRedraw = true

proc analyzePitch(editor: PitchEditor) =
  let
    source = currentProject().selectedItem(0).activeTake.source
    pitchBuffer = source.analyzePitch(0.0, source.timeLength)

  editor.pitchLine.addPoints(pitchBuffer)
  editor.pitchLine.deactivatePointsSpreadByTime(0.05)

  editor.redraw()

proc correctPitch(editor: PitchEditor) =
  var pitchPoints = newSeq[tuple[time, pitch: float]](editor.pitchLine.points.len)
  for i, point in editor.pitchLine.points:
    pitchPoints[i] = (point.time, point.pitch)

  var corrections = newSeq[tuple[time, pitch, driftStrength, modStrength: float, isActive: bool]](editor.correctionLine.points.len)
  for i, correction in editor.correctionLine.points:
    corrections[i] = (
      correction.time, correction.pitch,
      1.0, 1.0,
      correction.isActive,
    )

  preventUiRefresh(true)

  let
    take = currentProject().selectedItem(0).activeTake
    envelope = take.pitchEnvelope

  envelope.clear()
  envelope.correctPitch(pitchPoints, corrections)
  envelope.sort()

  preventUiRefresh(false)
  updateArrange()

func onMousePress*(editor: PitchEditor) =
  if editor.mouseIsInside:
    case editor.lastMousePress:
    of Left:
      editor.pitchLine.onLeftPress()
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

func onMouseRelease*(editor: PitchEditor) =
  case editor.lastMouseRelease:
  of Left:
    editor.pitchLine.onLeftRelease()
    editor.correctionLine.onLeftRelease()
    editor.redraw()
  of Middle:
    editor.mouseMiddleWasPressedInside = false
  of Right:
    editor.pitchLine.onRightRelease()
    editor.correctionLine.onRightRelease()
    editor.mouseRightWasPressedInside = false
    editor.boxSelect.isActive = false
  else:
    discard

func onMouseMove*(editor: PitchEditor) =
  editor.pitchLine.onMouseMove()
  editor.correctionLine.onMouseMove()

  if editor.mouseRightWasPressedInside and editor.isPressed(Right):
    editor.boxSelect.points[1] = editor.mousePosition

  if editor.mouseMiddleWasPressedInside and editor.isPressed(Middle):
    if editor.isPressed(Shift): editor.view.changeZoom(editor.mouseDelta)
    else: editor.view.changePanExternally(-editor.mouseDelta)

  editor.redraw()

proc onKeyPress*(editor: PitchEditor) =
  case editor.lastKeyPress:
  of R: editor.analyzePitch()
  of E: editor.correctPitch()
  of Delete:
    if editor.pitchLine.editingIsEnabled:
      editor.pitchLine.deleteSelection()
    if editor.correctionLine.editingIsEnabled:
      editor.correctionLine.deleteSelection()
    editor.redraw()
  else: discard

func onResize*(editor: PitchEditor, dimensions: (float, float)) =
  editor.resize(dimensions)
  editor.redraw()

func drawKeys(editor: PitchEditor) =
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
  editor.pitchLine.drawWithSquarePoints(editor.image)
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
  result.correctionLine.editingIsEnabled = true
  result.correctionLine.editingActivationsIsEnabled = true
  result.correctionLine.activeColor = rgb(51, 214, 255)
  result.correctionLine.inactiveColor = rgb(255, 46, 112)

  result.pitchLine = newPitchLine(position,
                                  result.view,
                                  result.input,
                                  result.boxSelect)
  result.pitchLine.activeColor = rgb(41, 148, 25)
  result.pitchLine.inactiveColor = result.pitchLine.activeColor

  result.position = position
  result.resize(dimensions)
  result.zoomOutXToFull()
  result.zoomOutYToFull()
  result.redraw()