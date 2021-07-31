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
    isActive*: bool
    mouseOver*: PitchPointMouseOver
    previous*, next*: PitchPoint
    view*: View[Seconds, Semitones, Inches]

{.push inline.}

func time*(a: PitchPoint): Seconds = a.position[0]
func time*(a: var PitchPoint): var Seconds = a.position[0]
func pitch*(a: PitchPoint): Semitones = a.position[1]
func pitch*(a: var PitchPoint): var Semitones = a.position[1]

func `time=`*(a: var PitchPoint, value: Seconds) = a.position[0] = value
func `pitch=`*(a: var PitchPoint, value: Semitones) = a.position[1] = value

func time*(a: (Seconds, Semitones)): Seconds = a[0]
func time*(a: var (Seconds, Semitones)): var Seconds = a[0]
func pitch*(a: (Seconds, Semitones)): Semitones = a[1]
func pitch*(a: var (Seconds, Semitones)): var Semitones = a[1]

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
  result.isActive = true
  result.view = view

func compareTime*(x, y: PitchPoint): int =
  if x.time < y.time: -1
  elif x.time == y.time: 0
  else: 1

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

func timeSort*(points: var openArray[PitchPoint]) =
  points.sort(compareTime)
  let lastId = points.len - 1
  for i in 1 ..< lastId:
    points[i].previous = points[i - 1]
    points[i].next = points[i + 1]

func calculateVisualPositions*(points: openArray[PitchPoint]) =
  for point in points:
    point.visualPosition = point.view.convert(point.position)

func calculateMouseOvers*(points: openArray[PitchPoint],
                          mousePosition: (Inches, Inches),
                          maxDistance: Inches): PitchPoint =
  let lastId = points.len - 1
  var
    closestPoint: PitchPoint
    closestSegment: (PitchPoint, PitchPoint)
    closestPointDistance: Inches
    closestSegmentDistance: Inches

  for i, point in points:
    point.mouseOver = None

    if point.isActive and i < lastId:
      let
        next = points[i + 1]
        distanceToSegment = mousePosition.distance((point.visualPosition,
                                                    next.visualPosition))

      if closestSegment[0] == nil:
        closestSegment = (point, next)
        closestSegmentDistance = distanceToSegment
      elif distanceToSegment < closestSegmentDistance:
        closestSegment = (point, next)
        closestSegmentDistance = distanceToSegment

    let distanceToPoint = mousePosition.distance(point.visualPosition)

    if closestPoint == nil:
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

func calculateEditOffsets*(points: openArray[PitchPoint], position: (Inches, Inches)) =
  for point in points:
    point.editOffset = point.position - point.view.convert(position)

func draw*(points: openArray[PitchPoint], image: Image) =
  let
    r = (3.0 / 96.0).Inches
    color = rgb(109, 186, 191)
    lastId = points.len - 1

  for i, point in points:
    if point.isActive and i < lastId:
      let next = points[i + 1]

      image.drawLine(
        point.visualPosition,
        next.visualPosition,
        color,
      )

      if point.mouseOver == Segment:
        image.drawLine(
          point.visualPosition,
          next.visualPosition,
          rgb(255, 255, 255, 0.5)
        )

    image.fillCircle(point.visualPosition, r, rgb(29, 81, 84))
    image.drawCircle(point.visualPosition, r, color)

    if point.isSelected:
      image.fillCircle(point.visualPosition, r, rgb(255, 255, 255, 0.5))

    if point.mouseOver == Point:
      image.fillCircle(point.visualPosition, r, rgb(255, 255, 255, 0.5))