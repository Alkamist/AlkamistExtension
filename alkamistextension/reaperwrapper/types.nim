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