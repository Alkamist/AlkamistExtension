# import std/options
import reaperwrapper

# template unselectAll = mainCommand(40769)
# template unselectItems = mainCommand(40289)
# template copyItems = mainCommand(40698)
# template pasteItems = mainCommand(41072)

type
  StretchMarkerCopyInfo = object
    positionBeats: float
    sourcePositionTime: float

  TakeCopyInfo = object
    playrate: float
    pitch: float
    stretchMarkers: seq[StretchMarkerCopyInfo]

  ItemCopyInfo = object
    startOffsetBeats: float
    startOffsetTime: float
    lengthBeats: float
    unscaledLengthTime: float
    lengthTime: float
    snapOffsetBeats: float
    snapOffsetPercent: float
    fadeIn: float
    fadeInBeats: float
    fadeOut: float
    fadeOutBeats: float
    autoFadeIn: float
    autoFadeInBeats: float
    autoFadeOut: float
    autoFadeOutBeats: float
    takes: seq[TakeCopyInfo]

proc copyInfo(item: Item, start, playrate, pitch: float): ItemCopyInfo =
  let project = item.project
  let startBeats = project.timeToBeats(start)

  let itemLeft = item.left
  let itemLeftBeats = project.timeToBeats(itemLeft)
  let itemSnapOffset = item.snapOffset
  let itemSnapStart = itemLeft + itemSnapOffset
  let itemSnapStartBeats = project.timeToBeats(itemSnapStart)
  let itemLength = item.length
  let itemRight = itemLeft + itemLength
  let itemRightBeats = project.timeToBeats(itemRight)
  let itemLengthBeats = itemRightBeats - itemLeftBeats

  result.startOffsetBeats = (itemSnapStartBeats - startBeats) * playrate
  result.startOffsetTime = (itemSnapStart - start) * playrate
  result.lengthBeats = itemLengthBeats * playrate
  result.unscaledLengthTime = itemLength
  result.lengthTime = itemLength * playrate
  result.snapOffsetBeats = (itemSnapStartBeats - itemLeftBeats) * playrate
  result.snapOffsetPercent = itemSnapOffset / itemLength

  let itemFadeIn = item.fadeInLength
  let itemFadeInBeats = project.timeToBeats(itemFadeIn + itemLeft) - itemLeftBeats
  let itemFadeOut = item.fadeOutLength
  let itemFadeOutBeats = itemRightBeats - project.timeToBeats(itemRight - itemFadeOut)
  result.fadeIn = itemFadeIn * playrate
  result.fadeInBeats = itemFadeInBeats * playrate
  result.fadeOut = itemFadeOut * playrate
  result.fadeOutBeats = itemFadeOutBeats * playrate

  let itemAutoFadeIn = item.autoFadeInLength
  let itemAutoFadeInBeats = project.timeToBeats(itemAutoFadeIn + itemLeft) - itemLeftBeats
  let itemAutoFadeOut = item.autoFadeOutLength
  let itemAutoFadeOutBeats = itemRightBeats - project.timeToBeats(itemRight - itemAutoFadeOut)
  result.autoFadeIn = itemAutoFadeIn * playrate
  result.autoFadeInBeats = itemAutoFadeInBeats * playrate
  result.autoFadeOut = itemAutoFadeOut * playrate
  result.autoFadeOutBeats = itemAutoFadeOutBeats * playrate

  for take in item.takes:
    let takePlayrate = take.playrate

    var takeInfo = TakeCopyInfo()
    takeInfo.playrate = take.playrate / playrate
    takeInfo.pitch = take.pitch - pitch

    for marker in take.stretchMarkers:
      var markerInfo = StretchMarkerCopyInfo()
      markerInfo.positionBeats = (project.timeToBeats(itemSnapStart + marker.position / takePlayrate) - itemSnapStartBeats) * playrate
      markerInfo.sourcePositionTime = marker.sourcePosition
      takeInfo.stretchMarkers.add markerInfo

    result.takes.add takeInfo

# proc leftmostSelectedItem(project: Project): Option[Item] =
#   for item in project.selectedItems:
#     if result.isNone:
#       result = some item
#     else:
#       if item.left < result.get.left:
#         result = some item

proc relativeCopyItems*(project: Project, position: float) =
  if project.selectedItemCount < 1:
    return

  recho project.selectedItem(0).get.copyInfo(position, 1.0, 0.0)

  # noUiRefresh:
  #   copyItems()

# proc relativePasteItems*(project: Project, position: float) =
#   noUiRefresh:
#     let previousEditPosition = project.editCursorPosition
#     project.setEditCursor(position - pasteOffset, false, false)
#     pasteItems()
#     project.setEditCursor(previousEditPosition, false, false)