import
  std/[math, algorithm, random],
  ../lice, ../units, ../input, ../view, ../geometry,
  whitekeys

type
  BoxSelect* = ref object
    x1*, y1*, x2*, y2*: Inches
    isActive*: bool

  PitchEditState = enum
    None,
    Point,
    Segment,

  PitchPoint* = ref object
    position*: (Seconds, Semitones)
    visualPosition*: (Inches, Inches)
    isSelected*: bool
    editState*: PitchEditState
    nextPoint*, previousPoint*: PitchPoint

  PitchEditorColorScheme* = object
    background*: Color
    blackKeys*: Color
    whiteKeys*: Color
    centerLine*: Color

  PitchEditor* = object
    position*: (Inches, Inches)
    image*: Image
    dpi*: Dpi
    timeLength*: Seconds
    colorScheme*: PitchEditorColorScheme
    correctionEditDistance*: Inches
    correctionPointVisualRadius*: Inches
    shouldRedraw*: bool
    viewX: ViewAxis[Seconds, Inches]
    viewY: ViewAxis[Semitones, Inches]
    isEditingCorrection: bool
    mouseMiddleWasPressedInside: bool
    mouseRightWasPressedInside: bool
    corrections: seq[PitchPoint]
    boxSelect: BoxSelect

{.push inline.}

func time*(a: PitchPoint): Seconds = a.position[0]
func `time=`*(a: var PitchPoint, value: Seconds) = a.position[0] = value
func pitch*(a: PitchPoint): Semitones = a.position[1]
func `pitch=`*(a: var PitchPoint, value: Semitones) = a.position[1] = value

func time*(a: (Seconds, Semitones)): Seconds = a[0]
func `time=`*(a: var (Seconds, Semitones), value: Seconds) = a[0] = value
func pitch*(a: (Seconds, Semitones)): Semitones = a[1]
func `pitch=`*(a: var (Seconds, Semitones), value: Semitones) = a[1] = value
func `+`*(a, b: (Seconds, Semitones)): (Seconds, Semitones) = (a[0] + b[0], a[1] + b[1])
func `+=`*(a: var (Seconds, Semitones), b: (Seconds, Semitones)) = a = a + b
func `-`*(a, b: (Seconds, Semitones)): (Seconds, Semitones) = (a[0] - b[0], a[1] - b[1])
func `-=`*(a: var (Seconds, Semitones), b: (Seconds, Semitones)) = a = a - b
func `-`*(a: (Seconds, Semitones)): (Seconds, Semitones) = (-a[0], -a[1])

func left*(a: BoxSelect): Inches = min(a.x2, a.x1)
func right*(a: BoxSelect): Inches = max(a.x2, a.x1)
func bottom*(a: BoxSelect): Inches = max(a.y2, a.y1)
func top*(a: BoxSelect): Inches = min(a.y2, a.y1)
func width*(a: BoxSelect): Inches = (a.x2 - a.x1).abs
func height*(a: BoxSelect): Inches = (a.y2 - a.y1).abs

{.pop.}

proc comparePitchPoint*(x, y: PitchPoint): int =
  if x.time < y.time: -1
  else: 1

{.push inline.}

func defaultPitchEditorColorScheme*(): PitchEditorColorScheme =
  result.background = rgb(16, 16, 16)
  result.blackKeys = rgb(60, 60, 60, 1.0)
  result.whiteKeys = rgb(110, 110, 110, 1.0)
  result.centerLine = rgb(255, 255, 255, 0.15)

func redraw*(editor: var PitchEditor) =
  for point in editor.corrections:
    point.visualPosition = (editor.viewX.convert point.time,
                            editor.viewY.convert point.pitch)
  editor.shouldRedraw = true

func resize*(editor: var PitchEditor, width, height: Inches) =
  editor.viewX.externalSize = width
  editor.viewY.externalSize = height
  editor.image.resize(width * editor.dpi,height * editor.dpi)

func x*(editor: PitchEditor): Inches = editor.position.x
func y*(editor: PitchEditor): Inches = editor.position.y
func width*(editor: PitchEditor): Inches = editor.viewX.externalSize
func height*(editor: PitchEditor): Inches = editor.viewY.externalSize
func `width=`*(editor: var PitchEditor, value: Inches) = editor.resize(value, editor.height)
func `height=`*(editor: var PitchEditor, value: Inches) = editor.resize(editor.width, value)

func mousePosition*(editor: PitchEditor, input: Input): (Seconds, Semitones) =
  (editor.viewX.convert input.mousePosition.x,
   editor.viewY.convert input.mousePosition.y)

func mouseDelta*(editor: PitchEditor, input: Input): (Seconds, Semitones) =
  (editor.viewX.scale input.mouseDelta.x,
   editor.viewY.scale -input.mouseDelta.y)

func zoomOutXToFull*(editor: var PitchEditor) =
  editor.viewX.zoom = editor.width.toFloat / editor.timeLength.toFloat

func zoomOutYToFull*(editor: var PitchEditor) =
  editor.viewY.zoom = editor.height.toFloat / numKeys.toFloat

func positionIsInside*(editor: PitchEditor, position: (Inches, Inches)): bool =
  position.x >= 0.Inches and
  position.x <= editor.width and
  position.y >= 0.Inches and
  position.y <= editor.height

func positionIsInside*(boxSelect: BoxSelect, position: (Inches, Inches)): bool =
  position.x >= boxSelect.left and
  position.x <= boxSelect.left + boxSelect.width and
  position.y >= boxSelect.top and
  position.y <= boxSelect.top + boxSelect.height

{.pop.}

proc initPitchEditor*(position: (Inches, Inches),
                      width, height: Inches,
                      dpi: Dpi): PitchEditor =
  result.position = position
  result.timeLength = 10.Seconds
  result.viewX = initViewAxis[Seconds, Inches]()
  result.viewY = initViewAxis[Semitones, Inches]()
  result.viewY.isInverted = true
  result.resize(width, height)
  result.zoomOutXToFull()
  result.zoomOutYToFull()
  result.dpi = dpi
  result.image = initImage(width * dpi, height * dpi)
  result.colorScheme = defaultPitchEditorColorScheme()
  result.correctionPointVisualRadius = (3.0 / 96.0).Inches
  result.correctionEditDistance = (5.0 / 96.0).Inches
  result.boxSelect = BoxSelect()

  var previousPoint: PitchPoint

  for pointId in 0 ..< 50:
    var point = PitchPoint()

    if previousPoint != nil:
      previousPoint.nextPoint = point

    point.time = pointId.Seconds
    point.pitch = rand(numKeys).Semitones
    point.previousPoint = previousPoint
    result.corrections.add point

    previousPoint = point

  result.redraw()

func calculatePointEditStates(editor: var PitchEditor, input: Input) =
  let mouse = input.mousePosition

  var
    closestPoint: PitchPoint
    closestSegment: (PitchPoint, PitchPoint)
    closestPointDistance: Inches
    closestSegmentDistance: Inches

  for i, point in editor.corrections:
    point.editState = PitchEditState.None

    if point.nextPoint != nil:
      let distanceToSegment = mouse.distance (point.visualPosition, point.nextPoint.visualPosition)

      if i == 0:
        closestSegment = (point, point.nextPoint)
        closestSegmentDistance = distanceToSegment
      elif distanceToSegment < closestSegmentDistance:
        closestSegment = (point, point.nextPoint)
        closestSegmentDistance = distanceToSegment

    let distanceToPoint = mouse.distance point.visualPosition

    if i == 0:
      closestPoint = point
      closestPointDistance = distanceToPoint
    elif distanceToPoint < closestPointDistance:
      closestPoint = point
      closestPointDistance = distanceToPoint

  let
    isPoint = closestPointDistance <= editor.correctionEditDistance
    isSegment = closestSegmentDistance <= editor.correctionEditDistance and not isPoint

  if isPoint:
    if closestPoint != nil:
      closestPoint.editState = PitchEditState.Point

  elif isSegment:
    if closestSegment[0] != nil:
      closestSegment[0].editState = PitchEditState.Segment

func handleClickSelectLogic(editor: var PitchEditor, input: Input) =
  editor.calculatePointEditStates(input)

  for point in editor.corrections.mitems:
    case point.editState:

    of PitchEditState.Point:
      if input.isPressed(Control) and not input.isPressed(Shift):
        point.isSelected = not point.isSelected
      else:
        point.isSelected = true

    of PitchEditState.Segment:
      if input.isPressed(Control) and not input.isPressed(Shift):
        point.isSelected = not point.isSelected
        if point.nextPoint != nil:
          point.nextPoint.isSelected = not point.nextPoint.isSelected
      else:
        point.isSelected = true
        if point.nextPoint != nil:
          point.nextPoint.isSelected = true

    else:
      if not (input.isPressed(Shift) or input.isPressed(Control)):
        if point.previousPoint != nil and
           point.previousPoint.editState != PitchEditState.Segment:
          point.isSelected = false

func onMousePress*(editor: var PitchEditor, input: Input) =
  case input.lastMousePress:
  of Left:
    if editor.positionIsInside(input.mousePosition):
      editor.handleClickSelectLogic(input)
  of Middle:
    if editor.positionIsInside(input.mousePosition):
      let mouse = editor.mousePosition(input)
      editor.mouseMiddleWasPressedInside = true
      editor.viewX.zoomTarget = mouse.time
      editor.viewY.zoomTarget = mouse.pitch
  of Right:
    if editor.positionIsInside(input.mousePosition):
      editor.mouseRightWasPressedInside = true
      editor.boxSelect.isActive = true
      editor.boxSelect.x1 = input.mousePosition.x
      editor.boxSelect.y1 = input.mousePosition.y
      editor.boxSelect.x2 = input.mousePosition.x
      editor.boxSelect.y2 = input.mousePosition.y
  else: discard

func handleBoxSelectLogic(editor: var PitchEditor, input: Input) =
  for point in editor.corrections.mitems:
    if editor.boxSelect.positionIsInside point.visualPosition:
      if input.isPressed(Control) and not input.isPressed(Shift):
        point.isSelected = not point.isSelected
      else:
        point.isSelected = true
    else:
      if not (input.isPressed(Shift) or input.isPressed(Control)):
        point.isSelected = false

func onMouseRelease*(editor: var PitchEditor, input: Input) =
  case input.lastMouseRelease:
  of Left: editor.isEditingCorrection = false
  of Middle: editor.mouseMiddleWasPressedInside = false
  of Right:
    editor.handleBoxSelectLogic(input)
    editor.mouseRightWasPressedInside = false
    editor.boxSelect.isActive = false
  else: discard

func handleViewMovement*(editor: var PitchEditor, input: Input) =
  let
    xChange = input.mouseDelta.x
    yChange = input.mouseDelta.y

  if input.isPressed(Shift):
    editor.viewX.changeZoom xChange
    editor.viewY.changeZoom yChange
  else:
    editor.viewX.changePan -xChange
    editor.viewY.changePan yChange

# func handleEditMovement(editor: var PitchEditor, input: Input) =
#   let
#     mouse = editor.mousePosition input
#     editStart = editor.correctionEdit.editStart
#     editDelta = mouse - editStart

#   if input.isPressed Shift:
#     for point in editor.correctionSelection.mitems:
#       point[] = editStart + editDelta
#   else:
#     let editDeltaRounded = (editDelta.time, editDelta.pitch.round)
#     for point in editor.correctionSelection.mitems:
#       point[] = editStart + editDeltaRounded

#   # editor.corrections[].sort comparePitchPoint
#   editor.updateVisualCorrections()

func onMouseMove*(editor: var PitchEditor, input: Input) =
  # if editor.isEditingCorrection:
  #   editor.handleEditMovement input
  # else:
  #   editor.calculateCorrectionEdit input

  editor.calculatePointEditStates(input)

  if editor.mouseRightWasPressedInside and input.isPressed Right:
    editor.boxSelect.x2 = input.mousePosition.x
    editor.boxSelect.y2 = input.mousePosition.y
    editor.redraw()

  if editor.mouseMiddleWasPressedInside and input.isPressed Middle:
    editor.handleViewMovement input
    editor.redraw()

func onResize*(editor: var PitchEditor, width, height: Inches) =
  editor.resize(width, height)
  editor.redraw()

func drawKeys(editor: PitchEditor) =
  template toPixels(inches: Inches): Pixels =
    inches * editor.dpi

  var keyColorPrevious = editor.colorScheme.blackKeys

  for pitchId in 0 ..< numKeys:
    let
      keyCenterSemitones = pitchId.Semitones
      keyCenterInches = editor.viewY.convert keyCenterSemitones
      keyBottomSemitones = keyCenterSemitones - 0.5.Semitones
      keyBottomInches = editor.viewY.convert keyBottomSemitones
      keyTopSemitones = keyCenterSemitones + 0.5.Semitones
      keyTopInches = editor.viewY.convert keyTopSemitones
      keyLeftPixels = 0.Pixels
      keyCenterPixels = keyCenterInches.toPixels
      keyTopPixels = keyTopInches.toPixels - 1.Pixels
      keyBottomPixels = keyBottomInches.toPixels
      keyWidthPixels = editor.width.toPixels
      keyHeightPixels = (keyTopPixels - keyBottomPixels).abs
      keyColor =
        if isWhiteKey(pitchId):
          editor.colorScheme.whiteKeys
        else:
          editor.colorScheme.blackKeys

    editor.image.fillRectangle(
      keyLeftPixels, keyTopPixels,
      keyWidthPixels, keyHeightPixels,
      keyColor,
    )

    if pitchId > 0 and
       keyColor == editor.colorScheme.whiteKeys and
       keyColorPrevious == editor.colorScheme.whiteKeys:
      editor.image.drawLine(
        keyLeftPixels, keyBottomPixels,
        keyWidthPixels, keyBottomPixels,
        editor.colorScheme.blackKeys,
      )

    editor.image.drawLine(
      keyLeftPixels, keyCenterPixels,
      keyWidthPixels, keyCenterPixels,
      editor.colorScheme.centerLine,
    )

    keyColorPrevious = keyColor

func drawPitchCorrections(editor: PitchEditor) =
  template toPixels(inches: Inches): Pixels =
    inches * editor.dpi

  let
    r = editor.correctionPointVisualRadius.toPixels
    color = rgb(109, 186, 191)

  for point in editor.corrections:
    let
      x = point.visualPosition.x.toPixels
      y = point.visualPosition.y.toPixels

    if point.nextPoint != nil:
      let
        nextX = point.nextPoint.visualPosition.x.toPixels
        nextY = point.nextPoint.visualPosition.y.toPixels

      editor.image.drawLine(x, y, nextX, nextY, color)

      if point.editState == PitchEditState.Segment:
        editor.image.drawLine(x, y, nextX, nextY, rgb(255, 255, 255, 0.5))

    editor.image.fillCircle(x, y, r, rgb(29, 81, 84))
    editor.image.drawCircle(x, y, r, color)

    if point.isSelected:
      editor.image.fillCircle(x, y, r, rgb(255, 255, 255, 0.5))

    if point.editState == PitchEditState.Point:
      editor.image.fillCircle(x, y, r, rgb(255, 255, 255, 0.5))

func drawBoxSelect(editor: PitchEditor) =
  template toPixels(inches: Inches): Pixels =
    inches * editor.dpi

  if editor.boxSelect.isActive:
    let
      x = editor.boxSelect.left.toPixels
      y = editor.boxSelect.top.toPixels
      width = editor.boxSelect.width.toPixels
      height = editor.boxSelect.height.toPixels

    editor.image.fillRectangle(
      x, y,
      width, height,
      rgb(0, 0, 0, 0.3),
    )
    editor.image.drawRectangle(
      x, y,
      width, height,
      rgb(255, 255, 255, 0.6),
    )

func updateImage*(editor: PitchEditor) =
  editor.image.clear(editor.colorScheme.background)
  editor.drawKeys()
  editor.drawPitchCorrections()
  editor.drawBoxSelect()