import reaperwrapper/types

type
  ItemFadeShape* {.pure.} = enum
    Linear, Shape2, Shape3,
    Shape4, Shape5, Shape6,
    Shape7,

  ItemFade* = object
    length*: float
    curve*: float
    shape*: ItemFadeShape

  AudioSourceState* = object
    length*: float
    isReversed*: bool
    sectionIsEnabled*: bool
    startPosition*: float
    overlap*: float
    fileName*: string
    # Markers
    # Stretch markers
    # Transient markers
    # Fx
    # Envelopes

  MidiSourceState* = object
    hasData*: bool
    resolution*: int
    shouldIgnoreProjectTempo*: bool
    laneType*: int
    laneHeight*: int
    inlineLaneHeight*: int
    bankFileName*: string
    # Midi notes
    # CFGEDITVIEW 3787.8 0.1 0 48 0 0 0
    # CFGEDIT 1 1 0 1 1 16 1 1 1 1 1 0.06250000 0 0 1024 768 0 2 0 0 0.00000000 0 0
    # EVTFILTER 0 -1 -1 -1 -1 0 1

  TakeChannelMode* {.pure.} = enum
    Normal = 0, ReverseStereo = 1,
    MonoDownmix = 2, MonoLeft = 3, MonoRight = 4,

  TakeStateKind* {.pure.} = enum
    Midi, Audio,

  TakeState* = object
    isSelected*: bool
    name*: string
    pan*: float
    volume*: float
    panLaw*: float
    sourceOffset*: float
    playrate*: float
    shouldPreservePitch*: bool
    pitch*: float
    stretchAlgorithm*: int
    channelMode*: TakeChannelMode
    guid*: string
    case kind*: TakeStateKind
    of TakeStateKind.Midi:
      midiSourceState*: MidiSourceState
    of TakeStateKind.Audio:
      audioSourceState*: AudioSourceState

  ItemState* = object
    position*: float
    snapOffset*: float
    length*: float
    shouldLoop*: bool
    shouldPlayAllTakes*: bool
    # color*: Color
    timebase*: Timebase
    isSelected*: bool
    fadeIn*: ItemFade
    fadeOut*: ItemFade
    isMuted*: bool
    fadeFlags*: int
    groupNumber*: int
    guid*: string
    iid*: int
    notes*: string
    notesImageFileName*: string
    imageResourceFlags*: int
    trim*: float
    takeStates*: seq[TakeState]