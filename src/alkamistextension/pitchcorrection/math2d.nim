import std/[math, decls]

type
  Point2d* = tuple
    x, y: float

#   PolyLine2d* = ref object
#     points*: seq[Point2d]
#     editIsPoint*: bool
#     editIsSegment*: bool
#     editDistance*: float
#     editPoint*: ptr Point2d
#     editPointDistance*: float
#     editSegment*: (ptr Point2d, ptr Point2d)
#     editSegmentDistance*: float

#   PolyLineGroup2d* = ref object
#     lines*: seq[PolyLine2d]
#     editIsPoint*: bool
#     editIsSegment*: bool
#     editDistance*: float
#     editPoint*: ptr Point2d
#     editPointDistance*: float
#     editSegment*: (ptr Point2d, ptr Point2d)
#     editSegmentDistance*: float

# func newPolyLine2d*(): PolyLine2d =
#   result = PolyLine2d()
#   result.editDistance = 5.0

# func newPolyLineGroup2d*(): PolyLineGroup2d =
#   result = PolyLineGroup2d()

func distance*(a: Point2d, b: Point2d): float =
  let
    dx = a.x - b.x
    dy = a.y - b.y
  sqrt(dx * dx + dy * dy)

func distance*(point: Point2d, segment: (Point2d, Point2d)): float =
  let
    a = point.x - segment[0].x
    b = point.y - segment[0].y
    c = segment[1].x - segment[0].x
    d = segment[1].y - segment[0].y
    dotProduct = a * c + b * d
    lengthSquared = c * c + d * d

  var
    param = -1.0
    xx, yy: float

  if lengthSquared != 0.0:
    param = dotProduct / lengthSquared

  if param < 0.0:
    xx = segment[0].x
    yy = segment[0].y

  elif param > 1.0:
    xx = segment[1].x
    yy = segment[1].y

  else:
    xx = segment[0].x + param * c
    yy = segment[0].y + param * d

  let
    dx = point.x - xx
    dy = point.y - yy

  sqrt(dx * dx + dy * dy)

# proc calculateEditPointAndSegment*(line: var PolyLine2d, toPoint: Point2d) =
#   line.editPoint = nil
#   line.editPointDistance = 0.0
#   line.editSegment = (nil, nil)
#   line.editSegmentDistance = 0.0

#   let lastPointIndex = line.points.len - 1

#   for i, point in line.points.mpairs:
#     let distanceToPoint = toPoint.distance(point)

#     if i < lastPointIndex:
#       var nextPoint {.byaddr.} = line.points[i + 1]
#       let distanceToSegment = toPoint.distance((point, nextPoint))

#       if line.editSegment == (nil, nil):
#         line.editSegment = (point.addr, nextPoint.addr)
#         line.editSegmentDistance = distanceToSegment
#       else:
#         if distanceToSegment < line.editSegmentDistance:
#           line.editSegment = (point.addr, nextPoint.addr)
#           line.editSegmentDistance = distanceToSegment

#     if line.editPoint == nil:
#       line.editPoint = point.addr
#       line.editPointDistance = distanceToPoint
#     else:
#       if distanceToPoint < line.editPointDistance:
#         line.editPoint = point.addr
#         line.editPointDistance = distanceToPoint

#   line.editIsPoint = line.editPointDistance <= line.editDistance
#   line.editIsSegment = line.editSegmentDistance <= line.editDistance and not line.editIsPoint

# proc calculateEditPointAndSegment*(group: PolyLineGroup2d, toPoint: Point2d) =
#   group.editPoint = nil
#   group.editPointDistance = 0.0
#   group.editSegment = (nil, nil)
#   group.editSegmentDistance = 0.0

#   for line in group.lines.mitems:
#     line.calculateEditPointAndSegment(toPoint)

#     if line.editPointDistance <= group.editDistance:
#       if group.editPoint == nil:
#         group.editPoint = line.editPoint
#         group.editPointDistance = line.editPointDistance
#       else:
#         if line.editPointDistance < group.editPointDistance:
#           group.editPoint = line.editPoint
#           group.editPointDistance = line.editPointDistance

#     if line.editSegmentDistance <= group.editDistance:
#       if group.editSegment == (nil, nil):
#         group.editSegment = line.editSegment
#         group.editSegmentDistance = line.editSegmentDistance
#       else:
#         if line.editSegmentDistance < group.editSegmentDistance:
#           group.editSegment = line.editSegment
#           group.editSegmentDistance = line.editSegmentDistance

#   group.editIsPoint = group.editPointDistance <= group.editDistance
#   group.editIsSegment = group.editSegmentDistance <= group.editDistance and not group.editIsPoint