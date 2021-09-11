import reaper
import types

proc setEditCursor*(project: Project, time: float, moveView: bool, seekPlay: bool) =
  SetEditCurPos2(project, time.cdouble, moveView, seekPlay)

proc editCursorPosition*(project: Project): float =
  GetCursorPosition()

proc selectedTrackCount*(project: Project): int =
  CountSelectedTracks(project)

proc selectedTrack*(project: Project, index: int): Track =
  result.reaperPtr = GetSelectedTrack(project, index.cint)

iterator selectedTracks*(project: Project): Track =
  for i in 0 ..< project.selectedTrackCount:
    yield project.selectedTrack(i)

proc selectedItemCount*(project: Project): int =
  CountSelectedMediaItems(project)

proc selectedItem*(project: Project, index: int): Item =
  result.reaperPtr = GetSelectedMediaItem(project, index.cint)

iterator selectedItems*(project: Project): Item =
  for i in 0 ..< project.selectedItemCount:
    yield project.selectedItem(i)

proc timeToBeats*(project: Project, time: float): float =
  var fullBeats: cdouble
  discard TimeMap2_timeToBeats(project, time.cdouble, nil, nil, fullBeats.addr, nil)
  fullBeats

proc beatsToTime*(project: Project, beats: float): float =
  TimeMap2_beatsToTime(project, beats, nil)