import ../units, ../geometry, ../view, ../lice

type
  PitchPointMouseOver* = enum
    None,
    Point,
    Segment,

  PitchPoint* = ref object
    position*: (Seconds, Semitones)
    editOffset*: (Seconds, Semitones)
    visualPosition*: (Inches, Inches)
    isSelected*: bool
    mouseOver*: PitchPointMouseOver
    previousPoint*, nextPoint*: PitchPoint
    view*: View[Seconds, Semitones, Inches]

{.push inline.}

func time*(a: PitchPoint): Seconds = a.position[0]
func pitch*(a: PitchPoint): Semitones = a.position[1]
func isFirstPoint*(a: PitchPoint): bool = a.previousPoint == nil
func isLastPoint*(a: PitchPoint): bool = a.nextPoint == nil

func `time=`*(a: var PitchPoint, value: Seconds) = a.position[0] = value
func `pitch=`*(a: var PitchPoint, value: Semitones) = a.position[1] = value

func time*(a: (Seconds, Semitones)): Seconds = a[0]
func pitch*(a: (Seconds, Semitones)): Semitones = a[1]

func `time=`*(a: var (Seconds, Semitones), value: Seconds) = a[0] = value
func `pitch=`*(a: var (Seconds, Semitones), value: Semitones) = a[1] = value
func `+`*(a, b: (Seconds, Semitones)): (Seconds, Semitones) = (a[0] + b[0], a[1] + b[1])
func `+=`*(a: var (Seconds, Semitones), b: (Seconds, Semitones)) = a = a + b
func `-`*(a, b: (Seconds, Semitones)): (Seconds, Semitones) = (a[0] - b[0], a[1] - b[1])
func `-=`*(a: var (Seconds, Semitones), b: (Seconds, Semitones)) = a = a - b
func `-`*(a: (Seconds, Semitones)): (Seconds, Semitones) = (-a[0], -a[1])

{.pop.}

func newPitchPoint*(position: (Seconds, Semitones),
                    view: View[Seconds, Semitones, Inches]): PitchPoint =
  result = PitchPoint()
  result.position = position
  result.view = view

template throughLastPoint*(startPoint: PitchPoint, code: untyped): untyped =
  var point {.inject.} = startPoint
  while true:
    code
    if point.isLastPoint: break
    point = point.nextPoint

template throughLastPoint*(startPoint: var PitchPoint, code: untyped): untyped =
  var point {.inject.} = startPoint
  while true:
    code
    if point.isLastPoint: break
    point = point.nextPoint

proc comparePitchPoint*(x, y: PitchPoint): int =
  if x.time < y.time: -1
  else: 1

func calculateVisualPositions*(start: var PitchPoint) =
  start.throughLastPoint:
    point.visualPosition = point.view.convert(point.position)

func draw*(start: PitchPoint, image: Image) =
  let
    r = (3.0 / 96.0).Inches
    color = rgb(109, 186, 191)

  start.throughLastPoint:
    if not point.isLastPoint:
      image.drawLine(
        point.visualPosition,
        point.nextPoint.visualPosition,
        color,
      )

      if point.mouseOver == Segment:
        image.drawLine(
          point.visualPosition,
          point.nextPoint.visualPosition,
          rgb(255, 255, 255, 0.5)
        )

    image.fillCircle(point.visualPosition, r, rgb(29, 81, 84))
    image.drawCircle(point.visualPosition, r, color)

    if point.isSelected:
      image.fillCircle(point.visualPosition, r, rgb(255, 255, 255, 0.5))

    if point.mouseOver == Point:
      image.fillCircle(point.visualPosition, r, rgb(255, 255, 255, 0.5))







# func handleEditMovement(points: var openArray[PitchPoint],
#                         snapStart: var (Seconds, Semitones),
#                         view: View[Seconds, Semitones],
#                         mousePosition: (Inches, Inches),
#                         disableSnap: bool) =
#   let
#     mouse = view.convert mousePosition
#     editStart = editor.editSnapStart
#     editDelta = mouse - editStart

#   for point in points:
#     if point.isSelected:
#       if disableSnap:
#         point.position.time = point.editOffset.time + editStart.time + editDelta.time
#         point.position.pitch = point.editOffset.pitch + editStart.pitch + editDelta.pitch
#         snapStart = editor.mousePosition input
#       else:
#         point.position.time = point.editOffset.time + editStart.time + editDelta.time
#         point.position.pitch = point.editOffset.pitch + editStart.pitch + editDelta.pitch.round

#   editor.redraw()

# func handleBoxSelectLogic(editor: var PitchEditor, input: Input) =
#   for point in editor.corrections.mitems:
#     if editor.boxSelect.positionIsInside point.visualPosition:
#       if input.isPressed(Control) and not input.isPressed(Shift):
#         point.isSelected = not point.isSelected
#       else:
#         point.isSelected = true
#     else:
#       if not (input.isPressed(Shift) or input.isPressed(Control)):
#         point.isSelected = false

# func calculatePointEditOffsets(editor: var PitchEditor, input: Input) =
#   let mouse = editor.mousePosition input
#   for point in editor.corrections:
#     point.editOffset = point.position - mouse

# func calculatePointEditStates(editor: var PitchEditor, input: Input) =
#   let mouse = input.mousePosition

#   editor.editPoint = nil

#   var
#     closestPoint: PitchPoint
#     closestSegment: (PitchPoint, PitchPoint)
#     closestPointDistance: Inches
#     closestSegmentDistance: Inches

#   for i, point in editor.corrections:
#     point.editState = PitchEditState.None

#     if point.nextPoint != nil:
#       let distanceToSegment = mouse.distance (point.visualPosition, point.nextPoint.visualPosition)

#       if i == 0:
#         closestSegment = (point, point.nextPoint)
#         closestSegmentDistance = distanceToSegment
#       elif distanceToSegment < closestSegmentDistance:
#         closestSegment = (point, point.nextPoint)
#         closestSegmentDistance = distanceToSegment

#     let distanceToPoint = mouse.distance point.visualPosition

#     if i == 0:
#       closestPoint = point
#       closestPointDistance = distanceToPoint
#     elif distanceToPoint < closestPointDistance:
#       closestPoint = point
#       closestPointDistance = distanceToPoint

#   let
#     isPoint = closestPointDistance <= editor.correctionEditDistance
#     isSegment = closestSegmentDistance <= editor.correctionEditDistance and not isPoint

#   if isPoint:
#     if closestPoint != nil:
#       closestPoint.editState = PitchEditState.Point
#       editor.editPoint = closestPoint

#   elif isSegment:
#     if closestSegment[0] != nil:
#       closestSegment[0].editState = PitchEditState.Segment
#       editor.editPoint = closestSegment[0]

# func handleClickSelectLogic(editor: var PitchEditor, input: Input) =
#   editor.calculatePointEditStates(input)

#   var editingUnselectedPoint = false

#   if editor.editPoint != nil:
#     case editor.editPoint.editState:

#     of PitchEditState.Point:
#       if not editor.editPoint.isSelected:
#         editingUnselectedPoint = true

#       if input.isPressed(Control) and not input.isPressed(Shift):
#         editor.editPoint.isSelected = not editor.editPoint.isSelected
#       else:
#         editor.editPoint.isSelected = true

#     of PitchEditState.Segment:
#       if input.isPressed(Control) and not input.isPressed(Shift):
#         editor.editPoint.isSelected = not editor.editPoint.isSelected
#         if editor.editPoint.nextPoint != nil:
#           editor.editPoint.nextPoint.isSelected = not editor.editPoint.nextPoint.isSelected
#       else:
#         editor.editPoint.isSelected = true
#         if editor.editPoint.nextPoint != nil:
#           editor.editPoint.nextPoint.isSelected = true

#     else: discard

#   for point in editor.corrections.mitems:
#     if point.editState == PitchEditState.None:
#       let
#         neitherShiftNorControl = not (input.isPressed(Shift) or input.isPressed(Control))
#         previousIsNotSegment = point.previousPoint != nil and point.previousPoint.editState != PitchEditState.Segment

#       if neitherShiftNorControl and previousIsNotSegment and editingUnselectedPoint:
#         point.isSelected = false