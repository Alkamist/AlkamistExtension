import
  # std/[math, random, sequtils],
  ../lice, ../input, ../view, ../vector,
  # ../reaper/functions,
  whitekeys, boxselect#, pitchpoint

type
  PitchEditorColorScheme* = object
    background*: Color
    blackKeys*: Color
    whiteKeys*: Color
    centerLine*: Color

  PitchEditor* = ref object
    position*: (float, float)
    timeLength*: float
    image*: Image
    colorScheme*: PitchEditorColorScheme
    correctionEditDistance*: float
    correctionPointVisualRadius*: float
    shouldRedraw*: bool
    input: Input
    view: View
    isEditingCorrection: bool
    mouseMiddleWasPressedInside: bool
    mouseRightWasPressedInside: bool
    boxSelect: BoxSelect
    # corrections: seq[PitchPoint]
    # correctionSelection: seq[PitchPoint]
    # correctionMouseOver: PitchPoint
    # correctionSnapStart: (Seconds, Semitones)

{.push inline.}

func x*(editor: PitchEditor): float = editor.position.x
func x*(editor: var PitchEditor): var float = editor.position.x
func y*(editor: PitchEditor): float = editor.position.y
func y*(editor: var PitchEditor): var float = editor.position.y
func width*(editor: PitchEditor): float = editor.view.x.externalSize
func height*(editor: PitchEditor): float = editor.view.y.externalSize
func dimensions*(editor: PitchEditor): (float, float) = (editor.width, editor.height)
func dpi*(editor: PitchEditor): float = editor.image.dpi

func mousePosition*(editor: PitchEditor): (float, float) = editor.input.mousePosition - editor.position
func previousMousePosition*(editor: PitchEditor): (float, float) = editor.input.previousMousePosition - editor.position
func mouseDelta*(editor: PitchEditor): (float, float) = editor.input.mouseDelta
func lastKeyPress*(editor: PitchEditor): KeyboardKey = editor.input.lastKeyPress
func lastKeyRelease*(editor: PitchEditor): KeyboardKey = editor.input.lastKeyRelease
func lastMousePress*(editor: PitchEditor): MouseButton = editor.input.lastMousePress
func lastMouseRelease*(editor: PitchEditor): MouseButton = editor.input.lastMouseRelease
func isPressed*(editor: PitchEditor, key: KeyboardKey): bool = editor.input.isPressed(key)
func isPressed*(editor: PitchEditor, button: MouseButton): bool = editor.input.isPressed(button)

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
  editor.view.x.externalSize = dimensions.width
  editor.view.y.externalSize = dimensions.height
  editor.image.resize(dimensions)

func positionIsInside*(editor: PitchEditor, position: (float, float)): bool =
  position.x >= 0.0 and
  position.x <= editor.width and
  position.y >= 0.0 and
  position.y <= editor.height

func redraw*(editor: var PitchEditor) =
  # editor.corrections.calculateVisualPositions()
  editor.shouldRedraw = true

# func setCorrectionPointSelectionState(editor: var PitchEditor,
#                                       point: PitchPoint,
#                                       state: bool) =
#   if point != nil:
#     if state:
#       if not point.isSelected:
#         point.isSelected = true
#         editor.correctionSelection.add(point)
#     else:
#       point.isSelected = false

# func cleanCorrectionSelection(editor: var PitchEditor) =
#   editor.correctionSelection.keepIf(proc(x: PitchPoint): bool =
#     x.isSelected
#   )
#   editor.correctionSelection = editor.correctionSelection.deduplicate()

# func unselectAllCorrections(editor: var PitchEditor) =
#   for point in editor.correctionSelection:
#     point.isSelected = false
#   editor.correctionSelection = @[]

# func deleteCorrectionSelection(editor: var PitchEditor) =
#   editor.correctionSelection = @[]
#   editor.corrections.keepIf(proc(x: PitchPoint): bool =
#     not x.isSelected
#   )
#   editor.corrections.timeSort()

# func toggleCorrectionPointActivations(editor: var PitchEditor) =
#   for point in editor.correctionSelection.mitems:
#     point.isActive = not point.isActive
#   editor.redraw()

# func handleEditMovement(editor: var PitchEditor) =
#   let
#     mouse = editor.view.convert(editor.mousePosition)
#     editStart = editor.correctionSnapStart
#     editDelta = mouse - editStart

#   for point in editor.correctionSelection.mitems:
#     if point.isSelected:
#       if editor.isPressed(Shift):
#         point.time = point.editOffset.time + editStart.time + editDelta.time
#         point.pitch = point.editOffset.pitch + editStart.pitch + editDelta.pitch
#         editor.correctionSnapStart = mouse
#       else:
#         point.time = point.editOffset.time + editStart.time + editDelta.time
#         point.pitch = point.editOffset.pitch + editStart.pitch + editDelta.pitch.round

#   editor.corrections.timeSort()
#   editor.redraw()

# func handleClickSelectLogic(editor: var PitchEditor) =
#   template mouse: untyped = editor.correctionMouseOver

#   let
#     editingSelectedPoint = mouse != nil and mouse.mouseOver == Point and mouse.isSelected
#     editingSelectedSegment = mouse != nil and mouse.mouseOver == Segment and mouse.isSelected and
#                              mouse.next != nil and mouse.next.isSelected
#     editingSelected = editingSelectedPoint or editingSelectedSegment

#   var
#     previous: PitchPoint
#     lastId = editor.corrections.len - 1

#   for i, point in editor.corrections.mpairs:
#     case point.mouseOver:

#     of Point:
#       if editor.isPressed(Control) and not editor.isPressed(Shift):
#         editor.setCorrectionPointSelectionState(point, not point.isSelected)
#       else:
#         editor.setCorrectionPointSelectionState(point, true)

#     of Segment:
#       if i < lastId:
#         let next = editor.corrections[i + 1]

#         if editor.isPressed(Control) and not editor.isPressed(Shift):
#           editor.setCorrectionPointSelectionState(point, not point.isSelected)
#           if not editor.isPressed(Alt):
#             editor.setCorrectionPointSelectionState(next, not next.isSelected)
#         else:
#           editor.setCorrectionPointSelectionState(point, true)
#           if not editor.isPressed(Alt):
#             editor.setCorrectionPointSelectionState(next, true)

#     of PitchPointMouseOver.None:
#       let
#         neitherShiftNorControl = not (editor.isPressed(Shift) or editor.isPressed(Control))
#         previousIsNotSegment = previous == nil or previous != nil and previous.mouseOver != Segment

#       if neitherShiftNorControl and previousIsNotSegment and not editingSelected:
#         editor.setCorrectionPointSelectionState(point, false)

#     previous = point

#   editor.cleanCorrectionSelection()

# func handleBoxSelectLogic(editor: var PitchEditor) =
#   for point in editor.corrections:
#     if point.visualPosition.isInside(editor.boxSelect):
#       if editor.isPressed(Control) and not editor.isPressed(Shift):
#         editor.setCorrectionPointSelectionState(point, not point.isSelected)
#       else:
#         editor.setCorrectionPointSelectionState(point, true)
#     else:
#       if not (editor.isPressed(Shift) or editor.isPressed(Control)):
#         editor.setCorrectionPointSelectionState(point, false)

#   editor.cleanCorrectionSelection()

# func handleDoubleClick(editor: var PitchEditor) =
#   template mouse: untyped = editor.correctionMouseOver
#   if mouse != nil:
#     let pitchChange = mouse.pitch.round - mouse.pitch
#     for point in editor.correctionSelection.mitems:
#       point.pitch += pitchChange
#     editor.redraw()

# func handleCorrectionPointMouseCreation(editor: var PitchEditor) =
#   let mouse = editor.view.convert(editor.mousePosition)

#   editor.unselectAllCorrections()

#   var point = PitchPoint()

#   point.view = editor.view
#   point.isActive = true

#   if editor.isPressed(Shift):
#     point.position = mouse
#   else:
#     point.position = (mouse.time, mouse.pitch.round)

#   editor.corrections.add(point)
#   editor.corrections.timeSort()

#   if editor.isPressed(Alt) and point.previous != nil:
#     point.previous.isActive = false

#   editor.setCorrectionPointSelectionState(point, true)
#   editor.redraw()

{.pop.}

proc newPitchEditor*(position: (float, float),
                     dimensions: (float, float),
                     dpi: float,
                     input: Input): PitchEditor =
  result = PitchEditor()
  result.input = input
  result.position = position
  result.timeLength = 10.0
  result.view = newView()
  result.view.y.isInverted = true
  result.resize(dimensions)
  result.zoomOutXToFull()
  result.zoomOutYToFull()
  result.image = initImage(dpi, dimensions)
  result.colorScheme = defaultPitchEditorColorScheme()
  result.correctionPointVisualRadius = 3.0 / 96.0
  result.correctionEditDistance = 5.0 / 96.0
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

func onMousePress*(editor: var PitchEditor) =
  if editor.positionIsInside(editor.mousePosition):
    case editor.lastMousePress:

    # of Left:
    #   editor.handleClickSelectLogic(input)

    #   if editor.correctionMouseOver != nil:
    #     if input.isPressed(Alt):
    #       editor.toggleCorrectionPointActivations()
    #     elif input.lastMousePressWasDoubleClick:
    #       editor.handleDoubleClick(input)

    #   else:
    #     editor.handleCorrectionPointMouseCreation(input)

    #   editor.correctionSnapStart = editor.view.convert(editor.mousePosition)
    #   editor.corrections.calculateEditOffsets(editor.mousePosition)
    #   editor.isEditingCorrection = true

    of Middle:
      editor.mouseMiddleWasPressedInside = true
      editor.view.setZoomTargetExternally(editor.mousePosition)

    of Right:
      editor.mouseRightWasPressedInside = true
      editor.boxSelect.isActive = true
      editor.boxSelect.bounds = (editor.mousePosition, (0.0, 0.0))

    else: discard

func onMouseRelease*(editor: var PitchEditor) =
  case editor.lastMouseRelease:

  # of Left:
  #   if not editor.isEditingCorrection:
  #     editor.unselectAllCorrections()
  #   editor.isEditingCorrection = false

  of Middle:
    editor.mouseMiddleWasPressedInside = false

  of Right:
    # editor.handleBoxSelectLogic(input)
    editor.mouseRightWasPressedInside = false
    editor.boxSelect.isActive = false

  else: discard

func onMouseMove*(editor: var PitchEditor) =
  # if editor.isEditingCorrection:
  #   editor.handleEditMovement()
  # else:
  #   editor.correctionMouseOver = editor.corrections.calculateMouseOvers(
  #     editor.mousePosition,
  #     editor.correctionEditDistance,
  #   )

  if editor.mouseRightWasPressedInside and editor.isPressed(Right):
    editor.boxSelect.points[1] = editor.mousePosition
    editor.redraw()

  if editor.mouseMiddleWasPressedInside and editor.isPressed(Middle):
    if editor.isPressed(Shift): editor.view.changeZoom(editor.mouseDelta)
    else: editor.view.changePanExternally(-editor.mouseDelta)
    editor.redraw()

func onKeyPress*(editor: var PitchEditor) =
  case editor.lastKeyPress:
  # of Delete: editor.deleteCorrectionSelection()
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
  # editor.corrections.drawWithCirclePoints(editor.image,
  #                                         rgb(51, 214, 255),
  #                                         rgb(255, 46, 112))
  editor.boxSelect.draw(editor.image)