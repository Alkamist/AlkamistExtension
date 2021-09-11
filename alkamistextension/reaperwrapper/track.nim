import reaper
import types

proc `isSelected=`*(track: Track, selected: bool) =
  SetTrackSelected(track, selected)

proc setOnlySelected*(track: Track) =
  SetOnlyTrackSelected(track)

proc number*(track: Track): int =
  GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER").int