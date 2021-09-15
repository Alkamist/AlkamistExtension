import reaperwrapper

# template unselectAll = mainCommand(40769)
template unselectItems = mainCommand(40289)
template copyItems = mainCommand(40698)
template pasteItems = mainCommand(41072)

type
  StretchMarkerCopyInfo = object
    positionBeats: float
    sourcePositionTime: float

  TakeCopyInfo = object
    playrate: float
    pitch: float
    stretchMarkers: seq[StretchMarkerCopyInfo]

  ItemCopyInfo = object
    startOffsetTime: float
    startOffsetBeats: float
    lengthTime: float
    lengthBeats: float
    snapOffsetTime: float
    snapOffsetBeats: float
    fadeInTime: float
    fadeInBeats: float
    fadeOutTime: float
    fadeOutBeats: float
    autoFadeInTime: float
    autoFadeInBeats: float
    autoFadeOutTime: float
    autoFadeOutBeats: float
    averageTempo: float
    takes: seq[TakeCopyInfo]

proc copyInfo(item: Item, positionTime: float): ItemCopyInfo =
  let project = item.project
  let positionBeats = project.timeToBeats(positionTime)
  let itemSnapPositionTime = item.snapPositionTime
  let itemSnapPositionBeats = item.snapPositionBeats
  result.startOffsetTime = itemSnapPositionTime - positionTime
  result.startOffsetBeats = itemSnapPositionBeats - positionBeats
  result.lengthTime = item.lengthTime
  result.lengthBeats = item.lengthBeats
  result.snapOffsetTime = item.snapOffsetTime
  result.snapOffsetBeats = item.snapOffsetBeats
  result.fadeInTime = item.fadeInTime
  result.fadeInBeats = item.fadeInBeats
  result.fadeOutTime = item.fadeOutTime
  result.fadeOutBeats = item.fadeOutBeats
  result.autoFadeInTime = item.autoFadeInTime
  result.autoFadeInBeats = item.autoFadeInBeats
  result.autoFadeOutTime = item.autoFadeOutTime
  result.autoFadeOutBeats = item.autoFadeOutBeats
  result.averageTempo = item.averageTempo

  for take in item.takes:
    let takePlayrate = take.playrate

    var takeInfo = TakeCopyInfo()
    takeInfo.playrate = take.playrate
    takeInfo.pitch = take.pitch

    for marker in take.stretchMarkers:
      var markerInfo = StretchMarkerCopyInfo()
      markerInfo.positionBeats = (project.timeToBeats(itemSnapPositionTime + marker.position / takePlayrate) - itemSnapPositionBeats)
      markerInfo.sourcePositionTime = marker.sourcePosition
      takeInfo.stretchMarkers.add markerInfo

    result.takes.add takeInfo

var relativeCopyInfo: seq[ItemCopyInfo]

proc relativeCopyItems*(project: Project, positionTime: float) =
  if project.selectedItemCount < 1:
    return

  relativeCopyInfo = @[]

  noUiRefresh:
    for item in project.selectedItems:
      relativeCopyInfo.add item.copyInfo(positionTime)
    copyItems()

proc adjustUsingTime(project: Project,
                     item: Item,
                     itemInfo: ItemCopyInfo,
                     positionTime: float,
                     playrate: float) =
  let itemSnapPositionTime = positionTime + itemInfo.startOffsetTime / playrate
  let itemLengthTime = itemInfo.lengthTime / playrate
  let itemSnapOffsetTime = itemInfo.snapOffsetTime / playrate
  let itemLeftBoundTime = itemSnapPositionTime - itemSnapOffsetTime
  let itemFadeInTime = itemInfo.fadeInTime / playrate
  let itemFadeOutTime = itemInfo.fadeOutTime / playrate
  let itemAutoFadeInTime = itemInfo.autoFadeInTime / playrate
  let itemAutoFadeOutTime = itemInfo.autoFadeOutTime / playrate

  item.positionTime = itemLeftBoundTime
  item.lengthTime = itemLengthTime
  item.snapOffsetTime = itemSnapOffsetTime
  item.fadeInTime = itemFadeInTime
  item.fadeOutTime = itemFadeOutTime
  item.autoFadeInTime = itemAutoFadeInTime
  item.autoFadeOutTime = itemAutoFadeOutTime

  var takeId = 0
  for take in item.takes:
    let takeInfo = itemInfo.takes[takeId]
    take.playrate = takeInfo.playrate * playrate
    inc takeId

proc adjustUsingBeatsPosition(project: Project,
                              item: Item,
                              itemInfo: ItemCopyInfo,
                              positionTime: float,
                              positionBeats: float,
                              playrate: float) =
  let itemSnapPositionBeats = positionBeats + itemInfo.startOffsetBeats / playrate
  let itemSnapOffsetBeats = itemInfo.snapOffsetBeats / playrate
  let itemLeftBoundBeats = itemSnapPositionBeats - itemSnapOffsetBeats

  item.positionBeats = itemLeftBoundBeats

  # if item.kind == ItemKind.Midi:
  #   let itemLengthTime = itemInfo.lengthTime
  #   let snapOffsetPercent = itemInfo.snapOffsetTime / itemLengthTime
  #   item.lengthTime = itemLengthTime
    # item.snapOffsetTime = itemLengthTime * snapOffsetPercent

proc adjustUsingBeatsPositionLengthRate(project: Project,
                                        item: Item,
                                        itemInfo: ItemCopyInfo,
                                        positionTime: float,
                                        positionBeats: float,
                                        playrate: float) =
  let itemSnapPositionBeats = positionBeats + itemInfo.startOffsetBeats / playrate
  let itemLengthBeats = itemInfo.lengthBeats / playrate
  let itemSnapOffsetBeats = itemInfo.snapOffsetBeats / playrate
  let itemLeftBoundBeats = itemSnapPositionBeats - itemSnapOffsetBeats
  let itemFadeInBeats = itemInfo.fadeInBeats / playrate
  let itemFadeOutBeats = itemInfo.fadeOutBeats / playrate
  let itemAutoFadeInBeats = itemInfo.autoFadeInBeats / playrate
  let itemAutoFadeOutBeats = itemInfo.autoFadeOutBeats / playrate

  item.positionBeats = itemLeftBoundBeats
  item.lengthBeats = itemLengthBeats
  item.snapOffsetBeats = itemSnapOffsetBeats
  item.fadeInBeats = itemFadeInBeats
  item.fadeOutBeats = itemFadeOutBeats
  item.autoFadeInBeats = itemAutoFadeInBeats
  item.autoFadeOutBeats = itemAutoFadeOutBeats

  let tempoRatio = block:
    if item.kind in [ItemKind.Empty, ItemKind.Midi]:
      1.0
    else:
      item.averageTempo / itemInfo.averageTempo

  var takeId = 0
  for take in item.takes:
    let takeInfo = itemInfo.takes[takeId]
    let markerCount = take.stretchMarkerCount

    if markerCount <= 0:
      take.playrate = takeInfo.playrate * tempoRatio * playrate
    else:
      let takePlayrate = takeInfo.playrate * playrate
      take.playrate = takePlayrate

      # Delete and re-add all stretch markers in the correct positions.
      take.deleteStretchMarker(0, markerCount)

      for markerId in 0 ..< takeInfo.stretchMarkers.len:
        let markerInfo = takeInfo.stretchMarkers[markerId]
        let positionTime = project.beatsToTime(item.snapPositionBeats + markerInfo.positionBeats / playrate) - item.snapPositionTime
        let sourceTime = markerInfo.sourcePositionTime
        take.addStretchMarker(positionTime * takePlayrate, some sourceTime)

    inc takeId

proc relativePasteItems*(project: Project, positionTime, playrate, pitch: float) =
  noUiRefresh:
    let cursorTime = project.editCursorTime

    unselectItems()
    pasteItems()

    let items = block:
      var res: seq[Item]
      for item in project.selectedItems:
        res.add item
      res

    let positionBeats = project.timeToBeats(positionTime)
    let projectTimebase = project.timebase

    for itemId, itemInfo in relativeCopyInfo.pairs:
      let item = items[itemId]
      let track = item.track

      let trackTimebase = block:
        let res = track.timebase
        if res.isSome:
          res.get
        else:
          projectTimebase

      let itemTimebase = block:
        let res = item.timebase
        if res.isSome:
          res.get
        else:
          trackTimebase

      case itemTimebase:
      of Timebase.Time:
        project.adjustUsingTime(item, itemInfo, positionTime, playrate)
      of Timebase.BeatsPositionLengthRate:
        project.adjustUsingBeatsPositionLengthRate(item, itemInfo, positionTime, positionBeats, playrate)
      of Timebase.BeatsPosition:
        project.adjustUsingBeatsPosition(item, itemInfo, positionTime, positionBeats, playrate)

    project.setEditCursorTime(cursorTime, false, false)