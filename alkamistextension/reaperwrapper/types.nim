import reaper

type
  Project* = ReaProject
  Track* = MediaTrack
  Item* = MediaItem
  Take* = MediaItem_Take
  Source* = PCM_source

  StretchMarker* = object
    take*: Take
    index*: int
    position*: float
    sourcePosition*: float
    slope*: float

  TimeSignatureMarker* = object
    project*: Project
    index*: int
    position*: float
    measure*: int
    beat*: float
    bpm*: float
    numerator*: int
    denominator*: int
    isLinear*: bool

  TimeSelectionBounds* = object
    left*, right*: float

  LoopBounds* = object
    left*, right*: float

  ItemKind* {.pure.} = enum
    Empty, Audio, Midi,

  Timebase* {.pure.} = enum
    Time,
    BeatsPositionLengthRate,
    BeatsPosition,

  MessageBoxKind* {.pure.} = enum
    Ok = 0, OkCancel = 1, AbortRetryIgnore = 2,
    YesNoCancel = 3, YesNo = 4, RetryCancel = 5,

template defineGetStateChunkProc*(chunkApiFunction, pointerType): untyped =
  proc stateChunk*(p: pointerType): string =
    result = newString(1024)
    while true:
      let chunkLength = result.len
      discard chunkApiFunction(p, result, chunkLength.cint, false)

      let endPos = result.find('\0')
      if endPos < chunkLength - 1:
        result.setLen(endPos)
        return result

      if chunkLength > 100 shl 20:
        raise newException(IOError, "The chunk size exceeded the 100 MiB limit.")

      result.setLen(chunkLength * 2)