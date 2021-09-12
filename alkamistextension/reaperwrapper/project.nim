import std/options
import reaper
import types

proc validate*(project: Project, track: Track): bool =
  ValidatePtr2(project, cast[pointer](track), "MediaTrack*")

proc validate*(project: Project, item: Item): bool =
  ValidatePtr2(project, cast[pointer](item), "MediaItem*")

proc setEditCursor*(project: Project, time: float, moveView: bool, seekPlay: bool) =
  SetEditCurPos2(project, time.cdouble, moveView, seekPlay)

proc editCursorPosition*(project: Project): float =
  GetCursorPosition()

proc selectedTrackCount*(project: Project): int =
  CountSelectedTracks(project)

proc selectedTrack*(project: Project, index: int): Option[Track] =
  let track = GetSelectedTrack(project, index.cint)
  if project.validate(track):
    return some track

iterator selectedTracks*(project: Project): Track =
  for i in 0 ..< project.selectedTrackCount:
    yield GetSelectedTrack(project, i.cint)

proc selectedItemCount*(project: Project): int =
  CountSelectedMediaItems(project)

proc selectedItem*(project: Project, index: int): Option[Item] =
  let item = GetSelectedMediaItem(project, index.cint)
  if project.validate(item):
    return some item

iterator selectedItems*(project: Project): Item =
  for i in 0 ..< project.selectedItemCount:
    yield GetSelectedMediaItem(project, i.cint)

proc timeToBeats*(project: Project, time: float): float =
  var fullBeats: cdouble
  discard TimeMap2_timeToBeats(project, time.cdouble, nil, nil, fullBeats.addr, nil)
  fullBeats

proc beatsToTime*(project: Project, beats: float): float =
  TimeMap2_beatsToTime(project, beats, nil)

proc timeSignatureMarkerCount*(project: Project): int =
  CountTempoTimeSigMarkers(project)

proc timeSignatureMarker*(project: Project, index: int): Option[TimeSignatureMarker] =
  var position: cdouble
  var measure: cint
  var beat: cdouble
  var bpm: cdouble
  var numerator: cint
  var denominator: cint
  var isLinear: bool
  let markerIsValid = GetTempoTimeSigMarker(
    project,
    index.cint,
    position.addr,
    measure.addr,
    beat.addr,
    bpm.addr,
    numerator.addr,
    denominator.addr,
    isLinear.addr,
  )
  if markerIsValid:
    var marker = TimeSignatureMarker()
    marker.index = index
    marker.position = position
    marker.measure = measure
    marker.beat = beat
    marker.bpm = bpm
    marker.numerator = numerator
    marker.denominator = denominator
    marker.isLinear = isLinear
    return some marker

iterator timeSignatureMarkers*(project: Project): TimeSignatureMarker =
  for i in 0 ..< project.timeSignatureMarkerCount:
    yield project.timeSignatureMarker(i).get

proc effectiveTimeSignatureMarkerIndex*(project: Project, time: float): int =
  FindTempoTimeSigMarker(project, time)

proc timeRangeContainsTempoChange*(project: Project, left, right: float): bool =
  if project.timeSignatureMarkerCount <= 1:
    return false

  let leftmostMarkerIndex = project.effectiveTimeSignatureMarkerIndex(left)
  let rightmostMarkerIndex = project.effectiveTimeSignatureMarkerIndex(right)
  let markersInOrBeforeRange = rightmostMarkerIndex - leftmostMarkerIndex
  let markerCount = markersInOrBeforeRange + 1

  var previousMarker: TimeSignatureMarker
  for i in 0 .. markerCount:
    if i == 0:
      previousMarker = project.timeSignatureMarker(leftmostMarkerIndex).get
    else:
      let marker = project.timeSignatureMarker(leftmostMarkerIndex + i)
      if marker.isNone:
        return false

      if marker.get.bpm != previousMarker.bpm:
        # The last marker, even if outside the time range, affects
        # the tempo in the time range if it is linear.
        if i == markerCount:
          if previousMarker.isLinear:
            return true
        else:
          return true

      previousMarker = marker.get

proc timeSelectionBounds*(project: Project): Option[TimeSelectionBounds] =
  var left, right: cdouble
  GetSet_LoopTimeRange2(project, false, false, left.addr, right.addr, false)
  if left > 0.0 or right > 0.0:
    return some TimeSelectionBounds(left: left, right: right)

proc loopBounds*(project: Project): Option[LoopBounds] =
  var left, right: cdouble
  GetSet_LoopTimeRange2(project, false, true, left.addr, right.addr, false)
  if left > 0.0 or right > 0.0:
    return some LoopBounds(left: left, right: right)