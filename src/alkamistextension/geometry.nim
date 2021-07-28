import std/math, units

type
  Vector2d*[T] = tuple[x: T, y: T]
  Segment2d*[T] = tuple[a: Vector2d[T], b: Vector2d[T]]

  PolyLine2d*[T] = seq[Vector2d[T]]
  PolyLine2dDistanceInfo*[T] = tuple
    closestPointIndex: int
    closestSegmentIndex: int
    closestPointDistance: T
    closestSegmentDistance: T

  PolyLineGroup2d*[T] = seq[PolyLine2d[T]]
  PolyLineGroup2dDistanceInfo*[T] = tuple
    closestPointIndex: int
    closestSegmentIndex: int
    closestPointPolyLineIndex: int
    closestSegmentPolyLineIndex: int
    closestPointDistance: T
    closestSegmentDistance: T

{.push inline.}

func `+`*[A, B](a: Vector2d[A], b: Vector2d[B]): Vector2d[A] {.inline.} =
  (x: a.x + b.x, y: a.y + b.y)
func `+=`*[A, B](a: var Vector2d[A], b: Vector2d[B]) {.inline.} =
  a = a + b

func `-`*[A, B](a: Vector2d[A], b: Vector2d[B]): Vector2d[A] {.inline.} =
  (x: a.x - b.x, y: a.y - b.y)
func `-=`*[A, B](a: var Vector2d[A], b: Vector2d[B]) {.inline.} =
  a = a - b

func `-`*[T](a: Vector2d[T]): Vector2d[T] {.inline.} =
  (x: -a.x, y: -a.y)

func distance*[T](a, b: Vector2d[T]): T =
  let
    dx = (a.x - b.x).toFloat
    dy = (a.y - b.y).toFloat
  sqrt(dx * dx + dy * dy).T

{.pop.}

func distance*[T](point: Vector2d[T], segment: Segment2d[T]): T =
  let
    pX = point.x.toFloat
    pY = point.y.toFloat
    x1 = segment[0].x.toFloat
    y1 = segment[0].y.toFloat
    x2 = segment[1].x.toFloat
    y2 = segment[1].y.toFloat
    a = pX - x1
    b = pY - y1
    c = x2 - x1
    d = y2 - y1
    dotProduct = a * c + b * d
    lengthSquared = c * c + d * d

  var
    param = -1.0
    xx, yy: float

  if lengthSquared != 0.0:
    param = dotProduct / lengthSquared

  if param < 0.0:
    xx = x1
    yy = y1

  elif param > 1.0:
    xx = x2
    yy = y2

  else:
    xx = x1 + param * c
    yy = y1 + param * d

  let
    dx = pX - xx
    dy = pY - yy

  sqrt(dx * dx + dy * dy).T

func distanceInfo*[T](line: PolyLine2d[T], toPoint: Vector2d[T]): PolyLine2dDistanceInfo[T] =
  let lastPointIndex = line.len - 1

  for i, point in line:
    if i < lastPointIndex:
      let
        nextPoint = line[i + 1]
        distanceToSegment = toPoint.distance (point, nextPoint)

      if i == 0:
        result.closestSegmentIndex = 0
        result.closestSegmentDistance = distanceToSegment
      elif distanceToSegment < result.closestSegmentDistance:
        result.closestSegmentIndex = i
        result.closestSegmentDistance = distanceToSegment

    let distanceToPoint = toPoint.distance point

    if i == 0:
      result.closestPointIndex = 0
      result.closestPointDistance = distanceToPoint
    elif distanceToPoint < result.closestPointDistance:
      result.closestPointIndex = i
      result.closestPointDistance = distanceToPoint

func distanceInfo*[T](group: PolyLineGroup2d[T], toPoint: Vector2d[T]): PolyLineGroup2dDistanceInfo[T] =
  for i, line in group:
    let info = line.distanceInfo toPoint

    if i == 0:
      result.closestPointIndex = info.closestPointIndex
      result.closestPointPolyLineIndex = i
      result.closestPointDistance = info.closestPointDistance
      result.closestSegmentIndex = info.closestSegmentIndex
      result.closestSegmentPolyLineIndex = i
      result.closestSegmentDistance = info.closestSegmentDistance
    else:
      if info.closestPointDistance < result.closestPointDistance:
        result.closestPointIndex = info.closestPointIndex
        result.closestPointPolyLineIndex = i
        result.closestPointDistance = info.closestPointDistance

      if info.closestSegmentDistance < result.closestSegmentDistance:
        result.closestSegmentIndex = info.closestSegmentIndex
        result.closestSegmentPolyLineIndex = i
        result.closestSegmentDistance = info.closestSegmentDistance