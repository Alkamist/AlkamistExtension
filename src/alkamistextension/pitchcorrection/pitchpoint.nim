import ../vector

export vector

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

{.push inline.}

func time*(point: (float, float)): float = point.x
func time*(point: var (float, float)): var float = point.x
func `time=`*(point: var (float, float), value: float) = point.x = value
func pitch*(point: (float, float)): float = point.y
func pitch*(point: var (float, float)): var float = point.y
func `pitch=`*(point: var (float, float), value: float) = point.y = value

func time*(point: PitchPoint): float = point.position.time
func time*(point: var PitchPoint): var float = point.position.time
func `time=`*(point: PitchPoint, value: float) = point.position.time = value
func pitch*(point: PitchPoint): float = point.position.pitch
func pitch*(point: var PitchPoint): var float = point.position.pitch
func `pitch=`*(point: PitchPoint, value: float) = point.position.pitch = value

{.pop.}

func newPitchPoint*(): PitchPoint =
  result = PitchPoint()
  result.isActive = true

func compareTime*(x, y: PitchPoint): int =
  if x.time < y.time: -1
  elif x.time == y.time: 0
  else: 1