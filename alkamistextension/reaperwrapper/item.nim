import std/options
import reaper
import types, project, take

defineGetStateChunkProc(GetItemStateChunk, Item)

proc `stateChunk=`*(item: Item, chunk: string) =
  discard SetItemStateChunk(item, chunk, false)

proc project*(item: Item): Project = GetItemProjectContext(item)
proc track*(item: Item): Track = GetMediaItem_Track(item)

proc takeCount*(item: Item): int = GetMediaItemNumTakes(item)

proc take*(item: Item, index: int): Option[Take] =
  if index >= 0 and index < item.takeCount:
    return some GetMediaItemTake(item, index.cint)

iterator takes*(item: Item): Take =
  for i in 0 ..< item.takeCount:
    yield GetMediaItemTake(item, i.cint)

proc positionTime*(item: Item): float =
  GetMediaItemInfo_Value(item, "D_POSITION")

proc `positionTime=`*(item: Item, value: float) =
  discard SetMediaItemPosition(item, value, true)

proc positionBeats*(item: Item): float =
  item.project.timeToBeats(item.positionTime)

proc `positionBeats=`*(item: Item, value: float) =
  item.positionTime = item.project.beatsToTime(value)

proc lengthTime*(item: Item): float =
  GetMediaItemInfo_Value(item, "D_LENGTH")

proc `lengthTime=`*(item: Item, value: float) =
  discard SetMediaItemLength(item, value, true)

proc lengthBeats*(item: Item): float =
  item.project.timeToBeats(item.positionTime + item.lengthTime) - item.positionBeats

proc `lengthBeats=`*(item: Item, value: float) =
  item.lengthTime = item.project.beatsToTime(item.positionBeats + value) - item.positionTime

proc rightTime*(item: Item): float =
  item.positionTime + item.lengthTime

proc `rightTime=`*(item: Item, value: float) =
  item.lengthTime = value - item.positionTime

proc rightBeats*(item: Item): float =
  item.positionBeats + item.lengthBeats

proc `rightBeats=`*(item: Item, value: float) =
  item.rightTime = item.project.beatsToTime(value)

proc snapOffsetTime*(item: Item): float =
  GetMediaItemInfo_Value(item, "D_SNAPOFFSET")

proc `snapOffsetTime=`*(item: Item, value: float) =
  discard SetMediaItemInfo_Value(item, "D_SNAPOFFSET", value)

proc snapOffsetBeats*(item: Item): float =
  item.project.timeToBeats(item.positionTime + item.snapOffsetTime) - item.positionBeats

proc `snapOffsetBeats=`*(item: Item, value: float) =
  item.snapOffsetTime = item.project.beatsToTime(item.positionBeats + value) - item.positionTime

proc snapPositionTime*(item: Item): float =
  item.positionTime + item.snapOffsetTime

proc `snapPositionTime=`*(item: Item, value: float) =
  item.positionTime = value - item.snapOffsetTime

proc snapPositionBeats*(item: Item): float =
  item.project.timeToBeats(item.snapPositionTime)

proc `snapPositionBeats=`*(item: Item, value: float) =
  item.snapPositionTime = item.project.beatsToTime(value)

proc fadeInTime*(item: Item): float =
  GetMediaItemInfo_Value(item, "D_FADEINLEN")

proc `fadeInTime=`*(item: Item, value: float) =
  discard SetMediaItemInfo_Value(item, "D_FADEINLEN", value)

proc fadeInBeats*(item: Item): float =
  item.project.timeToBeats(item.positionTime + item.fadeInTime) - item.positionBeats

proc `fadeInBeats=`*(item: Item, value: float) =
  item.fadeInTime = item.project.beatsToTime(item.positionBeats + value) - item.positionTime

proc fadeOutTime*(item: Item): float =
  GetMediaItemInfo_Value(item, "D_FADEOUTLEN")

proc `fadeOutTime=`*(item: Item, value: float) =
  discard SetMediaItemInfo_Value(item, "D_FADEOUTLEN", value)

proc fadeOutBeats*(item: Item): float =
  item.rightBeats - item.project.timeToBeats(item.rightTime - item.fadeOutTime)

proc `fadeOutBeats=`*(item: Item, value: float) =
  item.fadeOutTime = item.rightTime - item.project.beatsToTime(item.rightBeats - value)

proc autoFadeInTime*(item: Item): float =
  GetMediaItemInfo_Value(item, "D_FADEINLEN_AUTO")

proc `autoFadeInTime=`*(item: Item, value: float) =
  discard SetMediaItemInfo_Value(item, "D_FADEINLEN_AUTO", value)

proc autoFadeInBeats*(item: Item): float =
  item.project.timeToBeats(item.positionTime + item.autoFadeInTime) - item.positionBeats

proc `autoFadeInBeats=`*(item: Item, value: float) =
  item.autoFadeInTime = item.project.beatsToTime(item.positionBeats + value) - item.positionTime

proc autoFadeOutTime*(item: Item): float =
  GetMediaItemInfo_Value(item, "D_FADEOUTLEN_AUTO")

proc `autoFadeOutTime=`*(item: Item, value: float) =
  discard SetMediaItemInfo_Value(item, "D_FADEOUTLEN_AUTO", value)

proc autoFadeOutBeats*(item: Item): float =
  item.rightBeats - item.project.timeToBeats(item.rightTime - item.autoFadeOutTime)

proc `autoFadeOutBeats=`*(item: Item, value: float) =
  item.autoFadeOutTime = item.rightTime - item.project.beatsToTime(item.rightBeats - value)

proc isSelected*(item: Item): bool =
  IsMediaItemSelected(item)

proc `isSelected=`*(item: Item, selected: bool) =
  SetMediaItemSelected(item, selected)

proc averageTempo*(item: Item): float =
  item.project.averageTempoOfTimeRange(item.positionTime, item.rightTime)

proc kind*(item: Item): ItemKind =
  result = ItemKind.Empty
  let take = item.take(0)
  if take.isSome:
    if take.get.isMidi:
      return ItemKind.Midi
    else:
      return ItemKind.Audio

proc timebase*(item: Item): Option[Timebase] =
  let retval = GetMediaItemInfo_Value(item, "C_BEATATTACHMODE")
  case retval:
  of 0: result = some Timebase.Time
  of 1: result = some Timebase.BeatsPositionLengthRate
  of 2: result = some Timebase.BeatsPosition