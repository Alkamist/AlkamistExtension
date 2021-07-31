import
  std/[math, random, sequtils],
  ../lice, ../units, ../input, ../view, ../geometry,
  ../reaper/functions,
  whitekeys, boxselect, pitchpoint

type
  PitchEditorColorScheme* = object
    background*: Color
    blackKeys*: Color
    whiteKeys*: Color
    centerLine*: Color

  PitchEditor* = ref object
    position*: (Inches, Inches)
    image*: Image
    timeLength*: Seconds
    colorScheme*: PitchEditorColorScheme
    correctionEditDistance*: Inches
    correctionPointVisualRadius*: Inches
    shouldRedraw*: bool
    view: View[Seconds, Semitones, Inches]
    isEditingCorrection: bool
    mouseMiddleWasPressedInside: bool
    mouseRightWasPressedInside: bool
    boxSelect: BoxSelect
    corrections: seq[PitchPoint]
    correctionSelection: seq[PitchPoint]
    correctionMouseOver: PitchPoint
    correctionSnapStart: (Seconds, Semitones)

{.push inline.}

func x*(editor: PitchEditor): Inches = editor.position.x
func y*(editor: PitchEditor): Inches = editor.position.y
func width*(editor: PitchEditor): Inches = editor.view.x.externalSize
func height*(editor: PitchEditor): Inches = editor.view.y.externalSize
func dimensions*(editor: PitchEditor): (Inches, Inches) = (editor.width, editor.height)
func dpi*(editor: PitchEditor): Dpi = editor.image.dpi

func defaultPitchEditorColorScheme*(): PitchEditorColorScheme =
  result.background = rgb(16, 16, 16)
  result.blackKeys = rgb(48, 48, 48, 1.0)
  result.whiteKeys = rgb(76, 76, 76, 1.0)
  result.centerLine = rgb(255, 255, 255, 0.10)

func zoomOutXToFull*(editor: var PitchEditor) =
  editor.view.x.zoom = editor.width.toFloat / editor.timeLength.toFloat

func zoomOutYToFull*(editor: var PitchEditor) =
  editor.view.y.zoom = editor.height.toFloat / numKeys.toFloat

func resize*(editor: var PitchEditor, dimensions: (Inches, Inches)) =
  editor.view.x.externalSize = dimensions.width
  editor.view.y.externalSize = dimensions.height
  editor.image.resize(dimensions)

func positionIsInside*(editor: PitchEditor, position: (Inches, Inches)): bool =
  position.x >= 0.Inches and
  position.x <= editor.width and
  position.y >= 0.Inches and
  position.y <= editor.height

func redraw*(editor: var PitchEditor) =
  editor.corrections.calculateVisualPositions()
  editor.shouldRedraw = true

func setCorrectionPointSelectionState(editor: var PitchEditor,
                                      point: PitchPoint,
                                      state: bool) =
  if point != nil:
    if state:
      if not point.isSelected:
        point.isSelected = true
        editor.correctionSelection.add(point)
    else:
      point.isSelected = false

func cleanCorrectionSelection(editor: var PitchEditor) =
  editor.correctionSelection.keepIf(proc(x: PitchPoint): bool =
    x.isSelected
  )
  editor.correctionSelection = editor.correctionSelection.deduplicate()

func unselectAllCorrections(editor: var PitchEditor) =
  for point in editor.correctionSelection:
    point.isSelected = false
  editor.correctionSelection = @[]

func deleteCorrectionSelection(editor: var PitchEditor) =
  editor.correctionSelection = @[]
  editor.corrections.keepIf(proc(x: PitchPoint): bool =
    not x.isSelected
  )
  editor.corrections.timeSort()

func toggleCorrectionPointActivations(editor: var PitchEditor) =
  for point in editor.correctionSelection.mitems:
    point.isActive = not point.isActive
  editor.redraw()

func handleEditMovement(editor: var PitchEditor, input: Input) =
  let
    mouse = editor.view.convert(input.mousePosition)
    editStart = editor.correctionSnapStart
    editDelta = mouse - editStart

  for point in editor.correctionSelection.mitems:
    if point.isSelected:
      if input.isPressed(Shift):
        point.time = point.editOffset.time + editStart.time + editDelta.time
        point.pitch = point.editOffset.pitch + editStart.pitch + editDelta.pitch
        editor.correctionSnapStart = mouse
      else:
        point.time = point.editOffset.time + editStart.time + editDelta.time
        point.pitch = point.editOffset.pitch + editStart.pitch + editDelta.pitch.round

  editor.corrections.timeSort()
  editor.redraw()

func handleClickSelectLogic(editor: var PitchEditor, input: Input) =
  template mouse: untyped = editor.correctionMouseOver

  let
    editingSelectedPoint = mouse != nil and mouse.mouseOver == Point and mouse.isSelected
    editingSelectedSegment = mouse != nil and mouse.mouseOver == Segment and mouse.isSelected and
                             mouse.next != nil and mouse.next.isSelected
    editingSelected = editingSelectedPoint or editingSelectedSegment

  var
    previous: PitchPoint
    lastId = editor.corrections.len - 1

  for i, point in editor.corrections.mpairs:
    case point.mouseOver:

    of Point:
      if input.isPressed(Control) and not input.isPressed(Shift):
        editor.setCorrectionPointSelectionState(point, not point.isSelected)
      else:
        editor.setCorrectionPointSelectionState(point, true)

    of Segment:
      if i < lastId:
        let next = editor.corrections[i + 1]

        if input.isPressed(Control) and not input.isPressed(Shift):
          editor.setCorrectionPointSelectionState(point, not point.isSelected)
          if not input.isPressed(Alt):
            editor.setCorrectionPointSelectionState(next, not next.isSelected)
        else:
          editor.setCorrectionPointSelectionState(point, true)
          if not input.isPressed(Alt):
            editor.setCorrectionPointSelectionState(next, true)

    of PitchPointMouseOver.None:
      let
        neitherShiftNorControl = not (input.isPressed(Shift) or input.isPressed(Control))
        previousIsNotSegment = previous == nil or previous != nil and previous.mouseOver != Segment

      if neitherShiftNorControl and previousIsNotSegment and not editingSelected:
        editor.setCorrectionPointSelectionState(point, false)

    previous = point

  editor.cleanCorrectionSelection()

func handleBoxSelectLogic(editor: var PitchEditor, input: Input) =
  for point in editor.corrections:
    if point.visualPosition.isInside(editor.boxSelect):
      if input.isPressed(Control) and not input.isPressed(Shift):
        editor.setCorrectionPointSelectionState(point, not point.isSelected)
      else:
        editor.setCorrectionPointSelectionState(point, true)
    else:
      if not (input.isPressed(Shift) or input.isPressed(Control)):
        editor.setCorrectionPointSelectionState(point, false)

  editor.cleanCorrectionSelection()

func handleDoubleClick(editor: var PitchEditor, input: Input) =
  template mouse: untyped = editor.correctionMouseOver
  if mouse != nil:
    let pitchChange = mouse.pitch.round - mouse.pitch
    for point in editor.correctionSelection.mitems:
      point.pitch += pitchChange
    editor.redraw()

func handleCorrectionPointMouseCreation(editor: var PitchEditor, input: Input) =
  let mouse = editor.view.convert(input.mousePosition)

  editor.unselectAllCorrections()

  var point = PitchPoint()

  point.view = editor.view
  point.isActive = true

  if input.isPressed(Shift):
    point.position = mouse
  else:
    point.position = (mouse.time, mouse.pitch.round)

  editor.corrections.add(point)
  editor.corrections.timeSort()

  if input.isPressed(Alt) and point.previous != nil:
    point.previous.isActive = false

  editor.setCorrectionPointSelectionState(point, true)
  editor.redraw()

{.pop.}

proc newPitchEditor*(position: (Inches, Inches),
                     dimensions: (Inches, Inches),
                     dpi: Dpi): PitchEditor =
  result = PitchEditor()
  result.position = position
  result.timeLength = 10.Seconds
  result.view = newView[Seconds, Semitones, Inches]()
  result.view.y.isInverted = true
  result.resize(dimensions)
  result.zoomOutXToFull()
  result.zoomOutYToFull()
  result.image = initImage(dpi, dimensions)
  result.colorScheme = defaultPitchEditorColorScheme()
  result.correctionPointVisualRadius = (3.0 / 96.0).Inches
  result.correctionEditDistance = (5.0 / 96.0).Inches
  result.boxSelect = newBoxSelect()

  # var previous: PitchPoint
  # for pointId in 0 ..< 10000:
  #   var point = newPitchPoint(
  #     (pointId.Seconds, rand(numKeys).Semitones),
  #     result.view,
  #   )

  #   point.isActive = rand(1.0) > 0.5

  #   if previous != nil:
  #     previous.next = point
  #   point.previous = previous

  #   result.corrections.add(point)

  #   previous = point

  result.redraw()

func onMousePress*(editor: var PitchEditor, input: Input) =
  if editor.positionIsInside(input.mousePosition):
    case input.lastMousePress:

    of Left:
      editor.handleClickSelectLogic(input)

      if editor.correctionMouseOver != nil:
        if input.isPressed(Alt):
          editor.toggleCorrectionPointActivations()
        elif input.lastMousePressWasDoubleClick:
          editor.handleDoubleClick(input)

      else:
        editor.handleCorrectionPointMouseCreation(input)

      editor.correctionSnapStart = editor.view.convert(input.mousePosition)
      editor.corrections.calculateEditOffsets(input.mousePosition)
      editor.isEditingCorrection = true

    of Middle:
      editor.mouseMiddleWasPressedInside = true
      editor.view.zoomTarget = input.mousePosition

    of Right:
      editor.mouseRightWasPressedInside = true
      editor.boxSelect.isActive = true
      editor.boxSelect.bounds = (input.mousePosition, (0.Inches, 0.Inches))

    else: discard

func onMouseRelease*(editor: var PitchEditor, input: Input) =
  case input.lastMouseRelease:

  of Left:
    if not editor.isEditingCorrection:
      editor.unselectAllCorrections()
    editor.isEditingCorrection = false

  of Middle:
    editor.mouseMiddleWasPressedInside = false

  of Right:
    editor.handleBoxSelectLogic(input)
    editor.mouseRightWasPressedInside = false
    editor.boxSelect.isActive = false

  else: discard

func onMouseMove*(editor: var PitchEditor, input: Input) =
  if editor.isEditingCorrection:
    editor.handleEditMovement(input)
  else:
    editor.correctionMouseOver = editor.corrections.calculateMouseOvers(
      input.mousePosition,
      editor.correctionEditDistance,
    )

  if editor.mouseRightWasPressedInside and input.isPressed(Right):
    editor.boxSelect.points[1] = input.mousePosition
    editor.redraw()

  if editor.mouseMiddleWasPressedInside and input.isPressed(Middle):
    if input.isPressed(Shift): editor.view.changeZoom(input.mouseDelta)
    else: editor.view.changePan(-input.mouseDelta)
    editor.redraw()

func onKeyPress*(editor: var PitchEditor, input: Input) =
  case input.lastKeyPress:
  of Delete: editor.deleteCorrectionSelection()
  else: discard

func onResize*(editor: var PitchEditor, dimensions: (Inches, Inches)) =
  editor.resize(dimensions)
  editor.redraw()

func drawKeys(editor: PitchEditor) {.inline.} =
  var keyColorPrevious = editor.colorScheme.blackKeys

  for pitchId in 0 ..< numKeys:
    let
      keyCenterSemitones = pitchId.Semitones
      keyBottomSemitones = keyCenterSemitones - 0.5.Semitones
      keyTopSemitones = keyCenterSemitones + 0.5.Semitones

      keyLeftInches = 0.Inches
      keyCenterInches = editor.view.y.convert(keyCenterSemitones)
      keyBottomInches = editor.view.y.convert(keyBottomSemitones)
      keyTopInches = editor.view.y.convert(keyTopSemitones) - (1.0 / 96.0).Inches
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

    if keyHeightInches * editor.dpi > 16.Pixels:
      editor.image.drawLine(
        (keyLeftInches, keyCenterInches),
        (keyWidthInches, keyCenterInches),
        editor.colorScheme.centerLine,
      )

    keyColorPrevious = keyColor

func updateImage*(editor: PitchEditor) =
  editor.image.clear(editor.colorScheme.background)
  editor.drawKeys()
  editor.corrections.drawWithCirclePoints(editor.image,
                                          rgb(51, 214, 255),
                                          rgb(255, 46, 112))
  editor.boxSelect.draw(editor.image)