import reaper
import types

proc playrate*(take: Take): float =
  GetMediaItemTakeInfo_Value(take, "D_PLAYRATE")

proc pitch*(take: Take): float =
  GetMediaItemTakeInfo_Value(take, "D_PITCH")

proc stretchMarkerCount*(take: Take): int =
  GetTakeNumStretchMarkers(take)

proc stretchMarker*(take: Take, index: int): StretchMarker =
  var position, sourcePosition: cdouble
  discard GetTakeStretchMarker(take, index.cint, position.addr, sourcePosition.addr)
  result.take = take
  result.index = index
  result.position = position
  result.sourcePosition = sourcePosition
  result.slope = GetTakeStretchMarkerSlope(take, index.cint)

iterator stretchMarkers*(take: Take): StretchMarker =
  for i in 0 ..< take.stretchMarkerCount:
    yield take.stretchMarker(i)