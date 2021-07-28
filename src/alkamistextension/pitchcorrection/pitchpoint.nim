import ../units, ../geometry

type
  PitchPoint* = tuple[time: Seconds, pitch: Semitones]
  PitchSegment* = tuple[a, b: PitchPoint]
  PitchPolyLine* = seq[PitchPoint]

  PitchPolyLineEditState* = enum
    None,
    Point,
    Segment,

  PitchPolyLineEdit* = object
    state*: PitchPolyLineEditState
    point*: ptr PitchPoint
    segment*: ptr PitchSegment
    pointDistance*: Inches
    segmentDistance*: Inches
    pointPolyLine*: ptr PitchPolyLine
    segmentPolyLine*: ptr PitchPolyLine

proc comparePitchPoint*(x, y: PitchPoint): int =
  if x.time < y.time: -1
  else: 1

{.push inline.}

# func `[]`*(correction: PitchPolyLine, i: int): PitchPoint =
#   return correction.points[i]
# func `[]=`*(correction: PitchPolyLine, i: int, point: PitchPoint) =
#   correction.points[i] = point
# iterator items*(correction: PitchPolyLine): PitchPoint =
#   for point in correction.points:
#     yield point
# iterator pairs*(correction: PitchPolyLine): (int, PitchPoint) =
#   for i, point in correction.points:
#     yield (i, point)
# func len*(correction: PitchPolyLine): int =
#   correction.points.len
# func add*(correction: var PitchPolyLine, point: PitchPoint) =
#   correction.points.add point
# func sort*(correction: var PitchPolyLine, cmp: proc (x, y: PitchPoint): int) =
#   correction.points.sort cmp

{.pop.}

func getEdit(lines: var PitchPolyLine, toPoint: Vector2d[Inches]): PitchPolyLineEdit =

# func calculateEdit*(group: var PitchPolyLineGroup, toPoint: Vector2d[Inches]): PitchPolyLineEdit =
#   for line in group.lines:
#     let lastPointIndex = line.len - 1

#     for i, point in line:
#       let
#         pointInches = line.toVisualPoint point
#         distanceToPoint = toPoint.distance pointInches

#       if i < lastPointIndex:
#         let
#           nextPoint = correction[i + 1]
#           nextPointInches = line.toVisualPoint nextPoint
#           distanceToSegment = toPoint.distance (pointInches, nextPointInches)

#         if line.correctionEditSegment == (nil, nil):
#           line.correctionEditSegment = (point, nextPoint)
#           line.correctionEditSegmentDistance = distanceToSegment
#           line.correctionEditSegmentCorrection = correction
#         else:
#           if distanceToSegment < line.correctionEditSegmentDistance:
#             line.correctionEditSegment = (point, nextPoint)
#             line.correctionEditSegmentDistance = distanceToSegment
#             line.correctionEditSegmentCorrection = correction

#       if line.correctionEdit.point == nil:
#         line.correctionEdit.point = point
#         line.correctionEdit.pointDistance = distanceToPoint
#         line.correctionEditPointCorrection = correction
#       else:
#         if distanceToPoint < line.correctionEdit.pointDistance:
#           line.correctionEdit.point = point
#           line.correctionEdit.pointDistance = distanceToPoint
#           line.correctionEditPointCorrection = correction

#   line.correctionEditIsPoint = line.correctionEdit.pointDistance <= line.correctionEditDistance
#   line.correctionEditIsSegment = line.correctionEditSegmentDistance <= line.correctionEditDistance and not line.correctionEditIsPoint