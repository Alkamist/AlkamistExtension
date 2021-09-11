import std/options
import reaperwrapper

type
  Region* = object
    position*: float
    project*: Project
    items*: seq[Item]
    topmostTrack: Option[Track]
    leftmostItem: Option[Item]

proc unselectAll = mainCommand(40769)
proc unselectItems = mainCommand(40289)
proc copyItems = mainCommand(40698)
proc pasteItems = mainCommand(41072)

proc reset*(region: var Region) =
  region.position = 0.0
  region.items = @[]
  region.topmostTrack = none Track
  region.leftmostItem = none Item

proc copyContent*(region: var Region) =
  assert region.items.len > 0
  unselectAll()

  for i, item in region.items:
    let track = item.track

    if region.topmostTrack.isNone:
      region.topmostTrack = some track
    else:
      if track.number < region.topmostTrack.get.number:
        region.topmostTrack = some track

    if region.leftmostItem.isNone:
      region.leftmostItem = some item
    else:
      if item.left < region.leftmostItem.get.left:
        region.leftmostItem = some item

    item.isSelected = true

  copyItems()
  unselectItems()

proc pasteContent*(region: Region, position: float) =
  if region.topmostTrack.isSome and
     region.leftmostItem.isSome:
    unselectAll()
    region.topmostTrack.get.setOnlySelected()
    let offset = region.position - region.leftmostItem.get.left
    region.project.setEditCursor(position - offset, false, false)
    pasteItems()