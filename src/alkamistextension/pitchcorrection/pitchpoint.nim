import
  std/algorithm,
  ../view, ../lice, ../vector

type
  PitchPointMouseOver* = enum
    None,
    Point,
    Segment,

  PitchPoint* = ref object
    position*: (float, float)
    editOffset*: (float, float)
    visualPosition*: (float, float)
    isSelected*: bool
    isActive*: bool
    mouseOver*: PitchPointMouseOver
    previous*, next*: PitchPoint
    view*: View

{.push inline.}

func time*(a: PitchPoint): float = a.position[0]
func time*(a: var PitchPoint): var float = a.position[0]
func `time=`*(a: var PitchPoint, value: float) = a.position[0] = value
func pitch*(a: PitchPoint): float = a.position[1]
func pitch*(a: var PitchPoint): var float = a.position[1]
func `pitch=`*(a: var PitchPoint, value: float) = a.position[1] = value

func time*(a: (float, float)): float = a[0]
func time*(a: var (float, float)): var float = a[0]
func `time=`*(a: var (float, float), value: float) = a[0] = value
func pitch*(a: (float, float)): float = a[1]
func pitch*(a: var (float, float)): var float = a[1]
func `pitch=`*(a: var (float, float), value: float) = a[1] = value

{.pop.}

func newPitchPoint*(position: (float, float), view: View): PitchPoint =
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
  for i, point in points:
    if i > 0: point.previous = points[i - 1]
    if i < lastId: point.next = points[i + 1]

func calculateVisualPositions*(points: openArray[PitchPoint]) =
  for point in points:
    point.visualPosition = point.view.convertToExternal(point.position)

func calculateMouseOvers*(points: openArray[PitchPoint],
                          mousePosition: (float, float),
                          maxDistance: float): PitchPoint =
  let lastId = points.len - 1
  var
    closestPoint: PitchPoint
    closestSegment: (PitchPoint, PitchPoint)
    closestPointDistance: float
    closestSegmentDistance: float

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

func calculateEditOffsets*(points: openArray[PitchPoint], externalPosition: (float, float)) =
  for point in points:
    point.editOffset = point.position - point.view.convertToInternal(externalPosition)

func drawWithCirclePoints*(points: openArray[PitchPoint],
                           image: Image,
                           activeColor, inactiveColor: Color) =
  let
    r = (3.0 / 96.0).float
    lastId = points.len - 1
    activeColorDark = (activeColor * 0.3).redistribute
    inactiveColorDark = (inactiveColor * 0.3).redistribute
    highlight = rgb(255, 255, 255, 0.5)

  for i, point in points:
    if point.isActive and i < lastId:
      let next = points[i + 1]

      image.drawLine(
        point.visualPosition,
        next.visualPosition,
        activeColor,
      )

      if point.mouseOver == Segment:
        image.drawLine(
          point.visualPosition,
          next.visualPosition,
          highlight,
        )

    if point.isSelected:
      if point.isActive:
        image.fillCircle(point.visualPosition, r, activeColor)
      else:
        image.fillCircle(point.visualPosition, r, inactiveColor)
    else:
      if point.isActive:
        image.fillCircle(point.visualPosition, r, activeColorDark)
        image.drawCircle(point.visualPosition, r, activeColor)
      else:
        image.fillCircle(point.visualPosition, r, inactiveColorDark)
        image.drawCircle(point.visualPosition, r, inactiveColor)

    if point.mouseOver == Point:
      image.fillCircle(point.visualPosition, r, highlight)