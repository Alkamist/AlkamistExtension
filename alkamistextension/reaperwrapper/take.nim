import std/options
import reaper
import types

proc source*(take: Take): Source =
  GetMediaItemTake_Source(take)

proc isMidi*(take: Take): bool =
  TakeIsMIDI(take)

proc playrate*(take: Take): float =
  GetMediaItemTakeInfo_Value(take, "D_PLAYRATE")

proc `playrate=`*(take: Take, value: float) =
  discard SetMediaItemTakeInfo_Value(take, "D_PLAYRATE", value)

proc pitch*(take: Take): float =
  GetMediaItemTakeInfo_Value(take, "D_PITCH")

proc `pitch=`*(take: Take, value: float) =
  discard SetMediaItemTakeInfo_Value(take, "D_PITCH", value)

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

proc deleteStretchMarker*(take: Take, index, count: int) =
  var countIn = count.cint
  discard DeleteTakeStretchMarkers(take, index.cint, countIn.addr)

proc addStretchMarker*(take: Take, time: float, sourceTime = none(float)) =
  if sourceTime.isSome:
    var srcPosIn = sourceTime.get.cdouble
    discard SetTakeStretchMarker(take, -1, time.cdouble, srcPosIn.addr)
  else:
    discard SetTakeStretchMarker(take, -1, time.cdouble, nil)