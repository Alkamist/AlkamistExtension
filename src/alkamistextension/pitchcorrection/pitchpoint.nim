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

func time*(point: PitchPoint): float = point.position[0]
func time*(point: var PitchPoint): var float = point.position[0]
func `time=`*(point: PitchPoint, value: float) = point.position[0] = value
func pitch*(point: PitchPoint): float = point.position[1]
func pitch*(point: var PitchPoint): var float = point.position[1]
func `pitch=`*(point: PitchPoint, value: float) = point.position[1] = value

func newPitchPoint*(): PitchPoint =
  result = PitchPoint()
  result.isActive = true

func compareTime*(x, y: PitchPoint): int =
  if x.time < y.time: -1
  elif x.time == y.time: 0
  else: 1