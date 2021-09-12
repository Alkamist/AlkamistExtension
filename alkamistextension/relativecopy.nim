# import std/options
import reaperwrapper

# template unselectAll = mainCommand(40769)
# template unselectItems = mainCommand(40289)
# template copyItems = mainCommand(40698)
# template pasteItems = mainCommand(41072)

type
  StretchMarkerCopyInfo = object
    positionBeats: float
    sourcePosition: float

  TakeCopyInfo = object
    playrate: float
    pitch: float
    stretchMarkers: seq[StretchMarkerCopyInfo]

  ItemCopyInfo = object
    startOffsetBeats: float
    startOffset: float
    lengthBeats: float
    length: float
    snapOffsetBeats: float
    fadeIn: float
    fadeInBeats: float
    fadeOut: float
    fadeOutBeats: float
    autoFadeIn: float
    autoFadeInBeats: float
    autoFadeOut: float
    autoFadeOutBeats: float
    takes: seq[TakeCopyInfo]

proc copyInfo(item: Item, start: float): ItemCopyInfo =
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

  result.startOffsetBeats = (itemSnapStartBeats - startBeats)
  result.startOffset = (itemSnapStart - start)
  result.lengthBeats = itemLengthBeats
  result.length = itemLength
  result.snapOffsetBeats = (itemSnapStartBeats - itemLeftBeats)

  let itemFadeIn = item.fadeInLength
  let itemFadeInBeats = project.timeToBeats(itemFadeIn + itemLeft) - itemLeftBeats
  let itemFadeOut = item.fadeOutLength
  let itemFadeOutBeats = itemRightBeats - project.timeToBeats(itemRight - itemFadeOut)
  result.fadeIn = itemFadeIn
  result.fadeInBeats = itemFadeInBeats
  result.fadeOut = itemFadeOut
  result.fadeOutBeats = itemFadeOutBeats

  let itemAutoFadeIn = item.autoFadeInLength
  let itemAutoFadeInBeats = project.timeToBeats(itemAutoFadeIn + itemLeft) - itemLeftBeats
  let itemAutoFadeOut = item.autoFadeOutLength
  let itemAutoFadeOutBeats = itemRightBeats - project.timeToBeats(itemRight - itemAutoFadeOut)
  result.autoFadeIn = itemAutoFadeIn
  result.autoFadeInBeats = itemAutoFadeInBeats
  result.autoFadeOut = itemAutoFadeOut
  result.autoFadeOutBeats = itemAutoFadeOutBeats

  for take in item.takes:
    let takePlayrate = take.playrate

    var takeInfo = TakeCopyInfo()
    takeInfo.playrate = take.playrate
    takeInfo.pitch = take.pitch

    for marker in take.stretchMarkers:
      var markerInfo = StretchMarkerCopyInfo()
      markerInfo.positionBeats = (project.timeToBeats(itemSnapStart + marker.position / takePlayrate) - itemSnapStartBeats)
      markerInfo.sourcePosition = marker.sourcePosition
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

  recho project.selectedItem(0).get.copyInfo(position)

  # noUiRefresh:
  #   copyItems()

# proc relativePasteItems*(project: Project, position: float) =
#   noUiRefresh:
#     let previousEditPosition = project.editCursorPosition
#     project.setEditCursor(position - pasteOffset, false, false)
#     pasteItems()
#     project.setEditCursor(previousEditPosition, false, false)