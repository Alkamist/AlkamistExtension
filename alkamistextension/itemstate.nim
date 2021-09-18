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

# HASDATA 1 5120 QN
# CCINTERP 32
# POOLEDEVTS {0D40D209-55F9-498A-996D-24039F742A7A}
# E 2560 90 37 60
# E 1280 90 3f 60
# E 1280 80 37 00
# E 1280 80 3f 00
# e 2560 90 35 60
# e 2560 80 35 00
# E 1280 b0 7b 00
# CCINTERP 32
# CHASE_CC_TAKEOFFS 1
# GUID {BF21BC0F-CEBC-451F-AE9D-924EF7AC02C1}
# IGNTEMPO 0 120 4 4
# SRCCOLOR 113
# VELLANE -1 135 6
# CFGEDITVIEW 0 0.029141 61 12 0 -1 0 0 0 0.5
# KEYSNAP 0
# TRACKSEL 311
# EVTFILTER 0 -1 -1 -1 -1 0 0 0 0 -1 -1 -1 -1 0 -1 0 -1 -1
# CFGEDIT 1 1 0 0 0 0 1 0 1 1 1 0.25 550 252 2438 1277 1 0 0 0 0.5 0 0 0 0 0.5 0 0 1 64

# TAKE
# NAME Interlude-005.wav
# TAKEVOLPAN 0 1 -1
# SOFFS -0.9375
# PLAYRATE 1 1 0 -1 0 0.0025
# CHANMODE 0
# GUID {CB416764-1248-4CBD-944C-AA9C1E486DA2}
# <SOURCE WAVE
# FILE "F:\Corey's Music\Clients\BusinessSoundalike\Interlude-005.wav"
# >

# <ITEM
#   POSITION 18.75
#   SNAPOFFS 0
#   LENGTH 1.875
#   LOOP 0
#   ALLTAKES 0
#   FADEIN 0 0 0 0 0 0 0
#   FADEOUT 0 0 0 0 0 0 0
#   MUTE 0 0
#   SEL 1
#   IGUID {54018701-31CA-47BC-B9E2-B6C80AB43AFE}
#   IID 2
#   NAME "untitled MIDI item-glued"
#   VOLPAN 1 0 1 -1
#   SOFFS 0 0
#   PLAYRATE 1 1 0 -1 0 0.0025
#   CHANMODE 0
#   GUID {56799207-6D3F-4C21-8132-83E1CF2CBCA3}
#   <SOURCE MIDI
#     HASDATA 1 5120 QN
#     CCINTERP 32
#     POOLEDEVTS {E429A158-441D-4D4A-93F1-46F913DDEA9A}
#     E 0 90 3c 60
#     E 2560 80 3c 00
#     E 2560 90 3c 60
#     E 2560 80 3c 00
#     E 2560 90 3c 60
#     E 2560 80 3c 00
#     E 2560 90 3c 60
#     E 2560 80 3c 00
#     E 2560 b0 7b 00
#     CCINTERP 32
#     CHASE_CC_TAKEOFFS 1
#     GUID {67CDD837-BB7E-4DCB-B059-DAFDFB4D1A69}
#     IGNTEMPO 0 120 4 4
#     SRCCOLOR 40
#     VELLANE -1 135 6
#     CFGEDITVIEW -3763.339804 0.032302 59 12 0 -1 0 0 0 0.5
#     KEYSNAP 0
#     TRACKSEL 311
#     EVTFILTER 0 -1 -1 -1 -1 0 0 0 0 -1 -1 -1 -1 0 -1 0 -1 -1
#     CFGEDIT 1 1 0 0 0 0 1 0 1 1 1 0.25 550 252 2438 1277 1 0 0 0 0.5 0 0 0 0 0.5 0 0 1 64
#   >
# >