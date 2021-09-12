import std/options
import reaper
import types

proc playrate*(take: Take): float =
  GetMediaItemTakeInfo_Value(take, "D_PLAYRATE")

proc pitch*(take: Take): float =
  GetMediaItemTakeInfo_Value(take, "D_PITCH")

proc stretchMarkerCount*(take: Take): int =
  GetTakeNumStretchMarkers(take)

proc stretchMarker*(take: Take, index: int): Option[StretchMarker] =
  var position, sourcePosition: cdouble
  let retval = GetTakeStretchMarker(take, index.cint, position.addr, sourcePosition.addr)
  let markerIsValid = retval != -1
  if markerIsValid:
    var marker = StretchMarker()
    marker.take = take
    marker.index = index
    marker.position = position
    marker.sourcePosition = sourcePosition
    marker.slope = GetTakeStretchMarkerSlope(take, index.cint)
    return some marker

iterator stretchMarkers*(take: Take): StretchMarker =
  for i in 0 ..< take.stretchMarkerCount:
    yield take.stretchMarker(i).get