import reaper
import types
import project

proc project*(item: Item): Project =
  result.reaperPtr = GetItemProjectContext(item)

proc track*(item: Item): Track =
  result.reaperPtr = GetMediaItem_Track(item)

proc length*(item: Item): float =
  GetMediaItemInfo_Value(item, "D_LENGTH")

proc snapOffset*(item: Item): float =
  GetMediaItemInfo_Value(item, "D_SNAPOFFSET")

proc left*(item: Item): float =
  GetMediaItemInfo_Value(item, "D_POSITION")

proc leftBeats*(item: Item): float =
  item.project.timeToBeats(item.left)

proc snapStart*(item: Item): float =
  item.left + item.snapOffset

proc right*(item: Item): float =
  item.left + item.length

proc rightBeats*(item: Item): float =
  item.project.timeToBeats(item.right)

proc lengthBeats*(item: Item): float =
  item.rightBeats - item.leftBeats

proc `isSelected=`*(item: Item, selected: bool) =
  SetMediaItemSelected(item, selected)