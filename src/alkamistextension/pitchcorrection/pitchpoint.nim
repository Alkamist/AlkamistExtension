import
  std/algorithm,
  ../units, ../geometry, ../view, ../lice

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
    previous*, next*: PitchPoint
    view*: View[Seconds, Semitones, Inches]

{.push inline.}

func time*(a: PitchPoint): Seconds = a.position[0]
func pitch*(a: PitchPoint): Semitones = a.position[1]
func isFirstPoint*(a: PitchPoint): bool = a.previous == nil
func isLastPoint*(a: PitchPoint): bool = a.next == nil

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

template loopForward*(startPoint: PitchPoint, code: untyped): untyped =
  var point {.inject.} = startPoint
  while true:
    code
    if point.isLastPoint: break
    point = point.next

template loopForward*(startPoint: var PitchPoint, code: untyped): untyped =
  var point {.inject.} = startPoint
  while true:
    code
    if point.isLastPoint: break
    point = point.next

func firstPoint*(points: openArray[PitchPoint]): PitchPoint =
  for point in points:
    if result == nil:
      result = point
    else:
      if point.time < result.time:
        result = point

func lastPoint*(points: openArray[PitchPoint]): PitchPoint =
  for point in points:
    if result == nil:
      result = point
    else:
      if point.time > result.time:
        result = point

func becomePrevious*(point: var PitchPoint, ofPoint: var PitchPoint) =
  var
    a = ofPoint
    b = point
    c = ofPoint.previous
    d = point.next
    e = point.previous
  a.previous = b
  b.next = a
  b.previous = c
  if c != nil: c.next = b
  if d != nil: d.previous = e
  if e != nil: e.next = d

func becomeNext*(point: var PitchPoint, ofPoint: var PitchPoint) =
  var
    a = ofPoint
    b = point
    c = ofPoint.next
    d = point.previous
    e = point.next
  a.next = b
  b.previous = a
  b.next = c
  if c != nil: c.previous = b
  if d != nil: d.next = e
  if e != nil: e.previous = d

func timeSortPrevious*(point: var PitchPoint) =
  if point.previous == nil:
    return

  if point.time < point.previous.time:
    var check = point.previous.previous

    while true:
      if check == nil:
        point.becomePrevious(point.previous)
        return

      elif point.time >= check.time:
        point.becomeNext(check)
        return

      check = check.previous

func timeSortNext*(point: var PitchPoint) =
  if point.next == nil:
    return

  if point.time > point.next.time:
    var check = point.next.next

    while true:
      if check == nil:
        point.becomeNext(point.next)
        return

      elif point.time <= check.time:
        point.becomePrevious(check)
        return

      check = check.next

func timeSort*(point: var PitchPoint) {.inline.} =
  point.timeSortPrevious()
  point.timeSortNext()

func timeSort*(points: var openArray[PitchPoint]) =
  points.sort(proc (x, y: PitchPoint): int =
    if x.time > y.time: -1
    elif x.time == y.time: 0
    else: 1
  )

  for point in points.mitems:
    point.timeSortNext()

  points.sort(proc (x, y: PitchPoint): int =
    if x.time < y.time: -1
    elif x.time == y.time: 0
    else: 1
  )

  for point in points.mitems:
    point.timeSortPrevious()

func calculateVisualPositions*(start: var PitchPoint) =
  start.loopForward:
    point.visualPosition = point.view.convert(point.position)

func calculateMouseOvers*(start: var PitchPoint,
                          mousePosition: (Inches, Inches),
                          maxDistance: Inches): PitchPoint =
  var
    closestPoint: PitchPoint
    closestSegment: (PitchPoint, PitchPoint)
    closestPointDistance: Inches
    closestSegmentDistance: Inches

  start.loopForward:
    point.mouseOver = None

    if point.next != nil:
      let distanceToSegment = mousePosition.distance((point.visualPosition,
                                                      point.next.visualPosition))

      if point.isFirstPoint:
        closestSegment = (point, point.next)
        closestSegmentDistance = distanceToSegment
      elif distanceToSegment < closestSegmentDistance:
        closestSegment = (point, point.next)
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
  start.loopForward:
    point.editOffset = point.position - point.view.convert(position)

func draw*(start: PitchPoint, image: Image) =
  let
    r = (3.0 / 96.0).Inches
    color = rgb(109, 186, 191)

  start.loopForward:
    if not point.isLastPoint:
      image.drawLine(
        point.visualPosition,
        point.next.visualPosition,
        color,
      )

      if point.mouseOver == Segment:
        image.drawLine(
          point.visualPosition,
          point.next.visualPosition,
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