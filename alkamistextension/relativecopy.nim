import reaperwrapper
import chunkpatch

type
  StretchMarkerCopyInfo = object
    positionBeats: float
    sourcePositionTime: float

  TakeCopyInfo = object
    playrate: float
    pitch: float
    stretchMarkers: seq[StretchMarkerCopyInfo]

  ItemCopyInfo = object
    track: Track
    kind: ItemKind
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
    stateChunk: string
    takes: seq[TakeCopyInfo]

var relativeCopyInfo: seq[ItemCopyInfo]

proc relativeCopyItems*(project: Project, positionTime: float) =
  if project.selectedItemCount < 1:
    return

  relativeCopyInfo = @[]

  for item in project.selectedItems:
    var info = ItemCopyInfo()
    let project = item.project
    let positionBeats = project.timeToBeats(positionTime)
    let itemSnapPositionTime = item.snapPositionTime
    let itemSnapPositionBeats = item.snapPositionBeats
    info.track = item.track
    info.kind = item.kind
    info.startOffsetTime = itemSnapPositionTime - positionTime
    info.startOffsetBeats = itemSnapPositionBeats - positionBeats
    info.lengthTime = item.lengthTime
    info.lengthBeats = item.lengthBeats
    info.snapOffsetTime = item.snapOffsetTime
    info.snapOffsetBeats = item.snapOffsetBeats
    info.fadeInTime = item.fadeInTime
    info.fadeInBeats = item.fadeInBeats
    info.fadeOutTime = item.fadeOutTime
    info.fadeOutBeats = item.fadeOutBeats
    info.autoFadeInTime = item.autoFadeInTime
    info.autoFadeInBeats = item.autoFadeInBeats
    info.autoFadeOutTime = item.autoFadeOutTime
    info.autoFadeOutBeats = item.autoFadeOutBeats
    info.averageTempo = item.averageTempo
    info.stateChunk = item.stateChunk.patch(
      removeAll("GUID"),
      removeAll("IGUID"),
      removeAll("IID"),
    )

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

      info.takes.add takeInfo

    relativeCopyInfo.add info

# proc adjustUsingTime(project: Project,
#                      item: Item,
#                      itemInfo: ItemCopyInfo,
#                      positionTime: float,
#                      playrate: float) =
#   let itemSnapPositionTime = positionTime + itemInfo.startOffsetTime / playrate
#   let itemLengthTime = itemInfo.lengthTime / playrate
#   let itemSnapOffsetTime = itemInfo.snapOffsetTime / playrate
#   let itemLeftBoundTime = itemSnapPositionTime - itemSnapOffsetTime
#   let itemFadeInTime = itemInfo.fadeInTime / playrate
#   let itemFadeOutTime = itemInfo.fadeOutTime / playrate
#   let itemAutoFadeInTime = itemInfo.autoFadeInTime / playrate
#   let itemAutoFadeOutTime = itemInfo.autoFadeOutTime / playrate

#   item.positionTime = itemLeftBoundTime
#   item.lengthTime = itemLengthTime
#   item.snapOffsetTime = itemSnapOffsetTime
#   item.fadeInTime = itemFadeInTime
#   item.fadeOutTime = itemFadeOutTime
#   item.autoFadeInTime = itemAutoFadeInTime
#   item.autoFadeOutTime = itemAutoFadeOutTime

#   var takeId = 0
#   for take in item.takes:
#     let takeInfo = itemInfo.takes[takeId]
#     take.playrate = takeInfo.playrate * playrate
#     inc takeId

# proc adjustUsingBeatsPosition(project: Project,
#                               item: Item,
#                               itemInfo: ItemCopyInfo,
#                               positionTime: float,
#                               positionBeats: float,
#                               playrate: float) =
#   let itemSnapPositionBeats = positionBeats + itemInfo.startOffsetBeats / playrate
#   # No need to scale with playrate since the item doesn't scale
#   let itemSnapOffsetTime = itemInfo.snapOffsetTime
#   let itemLeftBoundTime = project.beatsToTime(itemSnapPositionBeats) - itemSnapOffsetTime

#   if item.kind == ItemKind.Midi:
#     item.positionTime = itemLeftBoundTime
#     item.lengthTime = itemInfo.lengthTime
#     item.snapOffsetTime = itemSnapOffsetTime
#   else:
#     item.positionTime = itemLeftBoundTime

# proc adjustUsingBeatsPositionLengthRate(project: Project,
#                                         item: Item,
#                                         itemInfo: ItemCopyInfo,
#                                         positionTime: float,
#                                         positionBeats: float,
#                                         playrate: float) =
#   let itemSnapPositionBeats = positionBeats + itemInfo.startOffsetBeats / playrate
#   let itemLengthBeats = itemInfo.lengthBeats / playrate
#   let itemSnapOffsetBeats = itemInfo.snapOffsetBeats / playrate
#   let itemLeftBoundBeats = itemSnapPositionBeats - itemSnapOffsetBeats
#   let itemFadeInBeats = itemInfo.fadeInBeats / playrate
#   let itemFadeOutBeats = itemInfo.fadeOutBeats / playrate
#   let itemAutoFadeInBeats = itemInfo.autoFadeInBeats / playrate
#   let itemAutoFadeOutBeats = itemInfo.autoFadeOutBeats / playrate

#   item.positionBeats = itemLeftBoundBeats
#   item.lengthBeats = itemLengthBeats
#   item.snapOffsetBeats = itemSnapOffsetBeats
#   item.fadeInBeats = itemFadeInBeats
#   item.fadeOutBeats = itemFadeOutBeats
#   item.autoFadeInBeats = itemAutoFadeInBeats
#   item.autoFadeOutBeats = itemAutoFadeOutBeats

#   let tempoRatio = block:
#     if item.kind in [ItemKind.Empty, ItemKind.Midi]:
#       1.0
#     else:
#       item.averageTempo / itemInfo.averageTempo

#   var takeId = 0
#   for take in item.takes:
#     let takeInfo = itemInfo.takes[takeId]
#     let markerCount = take.stretchMarkerCount

#     if markerCount <= 0:
#       take.playrate = takeInfo.playrate * tempoRatio * playrate
#     else:
#       let takePlayrate = takeInfo.playrate * playrate
#       take.playrate = takePlayrate

#       # Delete and re-add all stretch markers in the correct positions
#       take.deleteStretchMarker(0, markerCount)

#       for markerId in 0 ..< takeInfo.stretchMarkers.len:
#         let markerInfo = takeInfo.stretchMarkers[markerId]
#         let positionTime = project.beatsToTime(item.snapPositionBeats + markerInfo.positionBeats / playrate) - item.snapPositionTime
#         let sourceTime = markerInfo.sourcePositionTime
#         take.addStretchMarker(positionTime * takePlayrate, some sourceTime)

#     inc takeId

proc relativePasteItems*(project: Project, positionTime, playrate, pitch: float) =
  let positionBeats = project.timeToBeats(positionTime)

  for itemInfo in relativeCopyInfo:
    let track = itemInfo.track
    let item = track.newItem()

    let itemSnapPositionBeats = positionBeats + itemInfo.startOffsetBeats / playrate
    let itemSnapOffsetBeats = itemInfo.snapOffsetBeats / playrate
    let itemLeftBoundBeats = itemSnapPositionBeats - itemSnapOffsetBeats
    let itemLeftBoundTime = project.beatsToTime(itemLeftBoundBeats)
    let itemLengthBeats = itemInfo.lengthBeats / playrate
    let itemLengthTime = project.beatsToTime(itemLeftBoundBeats + itemLengthBeats) - itemLeftBoundTime
    let itemRightBoundBeats = itemLeftBoundBeats + itemLengthBeats
    let itemRightBoundTime = itemLeftBoundTime + itemLengthTime
    let itemSnapOffsetTime = project.beatsToTime(itemLeftBoundBeats + itemSnapOffsetBeats) - itemLeftBoundTime
    let itemFadeInBeats = itemInfo.fadeInBeats / playrate
    let itemFadeInTime = project.beatsToTime(itemLeftBoundBeats + itemFadeInBeats) - itemLeftBoundTime
    let itemFadeOutBeats = itemInfo.fadeOutBeats / playrate
    let itemFadeOutTime = itemRightBoundTime - project.beatsToTime(itemRightBoundBeats - itemFadeOutBeats)
    # let itemAutoFadeInBeats = itemInfo.autoFadeInBeats / playrate
    # let itemAutoFadeInTime = project.beatsToTime(itemLeftBoundBeats + itemAutoFadeInBeats) - itemLeftBoundTime
    # let itemAutoFadeOutBeats = itemInfo.autoFadeOutBeats / playrate
    # let itemAutoFadeOutTime = itemRightBoundTime - project.beatsToTime(itemRightBoundBeats - itemAutoFadeOutBeats)

    let tempoRatio = block:
      if itemInfo.kind in [ItemKind.Empty, ItemKind.Midi]:
        1.0
      else:
        project.averageTempoOfTimeRange(itemLeftBoundTime, itemRightBoundTime) / itemInfo.averageTempo

    var patchCommands = @[
      updateField(@[("ITEM", 0)], "POSITION", itemLeftBoundTime),
      updateField(@[("ITEM", 0)], "LENGTH", itemLengthTime),
      updateField(@[("ITEM", 0)], "SNAPOFFS", itemSnapOffsetTime),
      updateField(@[("ITEM", 0)], "FADEIN", (1, itemFadeInTime)),
      updateField(@[("ITEM", 0)], "FADEOUT", (1, itemFadeOutTime)),
    ]

    for takeId, takeInfo in itemInfo.takes:
      let takeLocation = @[("ITEM", 0), ("TAKE", takeId)]
      let markerCount = takeInfo.stretchMarkers.len

      if markerCount <= 0:
        let takePlayrate = takeInfo.playrate * tempoRatio * playrate
        patchCommands.add updateField(takeLocation, "PLAYRATE", takePlayrate)
      else:
        let takePlayrate = takeInfo.playrate * playrate
        patchCommands.add updateField(takeLocation, "PLAYRATE", takePlayrate)

    let itemStateChunk = itemInfo.stateChunk.patch(patchCommands)
    item.stateChunk = itemStateChunk

# proc relativePasteItems*(project: Project, positionTime, playrate, pitch: float) =
#   let items = block:
#     var res: seq[Item]
#     for info in relativeCopyInfo:
#       let pastedItem = newItem(info.track)
#       pastedItem.stateChunk = info.stateChunk
#       res.add pastedItem
#     res

#   if items.len != relativeCopyInfo.len:
#     showMessageBox("Relative Paste Warning:", "The number of items copied does not equal the number of items pasted.")
#     return

#   let positionBeats = project.timeToBeats(positionTime)
#   let projectTimebase = project.timebase

#   for itemId, itemInfo in relativeCopyInfo.pairs:
#     let item = items[itemId]
#     let track = item.track

#     let trackTimebase = block:
#       let res = track.timebase
#       if res.isSome:
#         res.get
#       else:
#         projectTimebase

#     let itemTimebase = block:
#       let res = item.timebase
#       if res.isSome:
#         res.get
#       else:
#         trackTimebase

#     # Adjust item bounds, playrates, and stretch markers based on timebase
#     case itemTimebase:
#     of Timebase.Time:
#       project.adjustUsingTime(item, itemInfo, positionTime, playrate)
#     of Timebase.BeatsPositionLengthRate:
#       project.adjustUsingBeatsPositionLengthRate(item, itemInfo, positionTime, positionBeats, playrate)
#     of Timebase.BeatsPosition:
#       project.adjustUsingBeatsPosition(item, itemInfo, positionTime, positionBeats, playrate)

#     # Adjust take pitches
#     var takeId = 0
#     for take in item.takes:
#       let takeInfo = itemInfo.takes[takeId]
#       take.pitch = takeInfo.pitch + pitch
#       inc takeId