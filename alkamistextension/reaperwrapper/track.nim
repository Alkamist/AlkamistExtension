import std/options
import reaper
import types

proc project*(track: Track): Project =
  var retval = GetMediaTrackInfo_Value(track, "P_PROJECT")
  cast[Project](retval)

proc `isSelected=`*(track: Track, selected: bool) =
  SetTrackSelected(track, selected)

proc setOnlySelected*(track: Track) =
  SetOnlyTrackSelected(track)

proc number*(track: Track): int =
  GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER").int

proc timebase*(track: Track): Option[Timebase] =
  let retval = GetMediaTrackInfo_Value(track, "C_BEATATTACHMODE")
  case retval:
  of 0: result = some Timebase.Time
  of 1: result = some Timebase.BeatsPositionLengthRate
  of 2: result = some Timebase.BeatsPosition

proc newItem*(track: Track): Item =
  AddMediaItemToTrack(track)