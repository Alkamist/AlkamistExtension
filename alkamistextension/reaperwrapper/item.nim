import reaper
import types
import project

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

proc take*(item: Item, index: int): Take =
  GetMediaItemTake(item, index.cint)

proc takeCount*(item: Item): int =
  GetMediaItemNumTakes(item)

iterator takes*(item: Item): Take =
  for i in 0 ..< item.takeCount:
    yield item.take(i)

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