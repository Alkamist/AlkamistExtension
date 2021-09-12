import std/options
import reaper
import types, project

proc project*(item: Item): Project =
  GetItemProjectContext(item)

proc track*(item: Item): Track =
  GetMediaItem_Track(item)

proc length*(item: Item): float =
  GetMediaItemInfo_Value(item, "D_LENGTH")

proc snapOffset*(item: Item): float =
  GetMediaItemInfo_Value(item, "D_SNAPOFFSET")

proc left*(item: Item): float =
  GetMediaItemInfo_Value(item, "D_POSITION")

proc fadeInLength*(item: Item): float =
  GetMediaItemInfo_Value(item, "D_FADEINLEN")

proc fadeOutLength*(item: Item): float =
  GetMediaItemInfo_Value(item, "D_FADEOUTLEN")

proc autoFadeInLength*(item: Item): float =
  GetMediaItemInfo_Value(item, "D_FADEINLEN_AUTO")

proc autoFadeOutLength*(item: Item): float =
  GetMediaItemInfo_Value(item, "D_FADEOUTLEN_AUTO")

proc isSelected*(item: Item): bool =
  IsMediaItemSelected(item)

proc `isSelected=`*(item: Item, selected: bool) =
  SetMediaItemSelected(item, selected)

proc takeCount*(item: Item): int =
  GetMediaItemNumTakes(item)

proc take*(item: Item, index: int): Option[Take] =
  if index >= 0 and index < item.takeCount:
    return some GetMediaItemTake(item, index.cint)

iterator takes*(item: Item): Take =
  for i in 0 ..< item.takeCount:
    yield GetMediaItemTake(item, i.cint)

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