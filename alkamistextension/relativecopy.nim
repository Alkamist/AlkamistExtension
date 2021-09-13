# import std/options
import reaperwrapper

# proc leftmostSelectedItem(project: Project): Option[Item] =
#   for item in project.selectedItems:
#     if result.isNone:
#       result = some item
#     else:
#       if item.left < result.get.left:
#         result = some item

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

    for itemId, info in relativeCopyInfo.pairs:
      let item = items[itemId]
      let itemSnapPositionBeats = positionBeats + info.startOffsetBeats / playrate
      let itemLengthBeats = info.lengthBeats / playrate
      let itemSnapOffsetBeats = info.snapOffsetBeats / playrate
      let itemLeftBoundBeats = itemSnapPositionBeats - itemSnapOffsetBeats
      let itemFadeInBeats = info.fadeInBeats / playrate
      let itemFadeOutBeats = info.fadeOutBeats / playrate
      let itemAutoFadeInBeats = info.autoFadeInBeats / playrate
      let itemAutoFadeOutBeats = info.autoFadeOutBeats / playrate

      item.positionBeats = itemLeftBoundBeats
      item.lengthBeats = itemLengthBeats
      item.snapOffsetBeats = itemSnapOffsetBeats
      item.fadeInBeats = itemFadeInBeats
      item.fadeOutBeats = itemFadeOutBeats
      item.autoFadeInBeats = itemAutoFadeInBeats
      item.autoFadeOutBeats = itemAutoFadeOutBeats

      let tempoRatio = 1.0
      # if getItemType(items[i]) == "audio":
      #   let newItemAverageTempo = getAverageTempoOfItem(items[i])
      #   tempoRatio = newItemAverageTempo / copiedItemStats[i].averageTempo

      var takeId = 0
      for take in item.takes:
        let takeInfo = info.takes[takeId]
        let markerCount = take.stretchMarkerCount

        if markerCount <= 0:
          take.playrate = info.takes[takeId].playrate * tempoRatio * playrate
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

    project.setEditCursorTime(cursorTime, false, false)