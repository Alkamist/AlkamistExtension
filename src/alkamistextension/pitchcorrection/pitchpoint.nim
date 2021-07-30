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

func calculateMouseOvers*(start: var PitchPoint,
                          mousePosition: (Inches, Inches),
                          maxDistance: Inches): PitchPoint =
  var
    closestPoint: PitchPoint
    closestSegment: (PitchPoint, PitchPoint)
    closestPointDistance: Inches
    closestSegmentDistance: Inches

  start.throughLastPoint:
    point.mouseOver = None

    if point.nextPoint != nil:
      let distanceToSegment = mousePosition.distance((point.visualPosition,
                                                      point.nextPoint.visualPosition))

      if point.isFirstPoint:
        closestSegment = (point, point.nextPoint)
        closestSegmentDistance = distanceToSegment
      elif distanceToSegment < closestSegmentDistance:
        closestSegment = (point, point.nextPoint)
        closestSegmentDistance = distanceToSegment

    let distanceToPoint = mousePosition.distance(point.visualPosition)

    if point.isFirstPoint:
      closestPoint = point
      closestPointDistance = distanceToPoint
    elif distanceToPoint < closestPointDistance:
      closestPoint = point
      closestPointDistance = distanceToPoint

  let
    isPoint = closestPointDistance <= maxDistance
    isSegment = closestSegmentDistance <= maxDistance and not isPoint

  if isPoint:
    if closestPoint != nil:
      closestPoint.mouseOver = Point
      result = closestPoint

  elif isSegment:
    if closestSegment[0] != nil:
      closestSegment[0].mouseOver = Segment
      result = closestSegment[0]

func calculateEditOffsets*(start: var PitchPoint, position: (Inches, Inches)) =
  start.throughLastPoint:
    point.editOffset = point.position - point.view.convert(position)

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