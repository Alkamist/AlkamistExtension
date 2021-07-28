import ../view, ../units, ../lice

type
  PitchPoint* = ref object
    time*: Seconds
    pitch*: Semitones

  PitchSegment* = tuple[a, b: PitchPoint]

  PitchCorrection* = ref object
    points*: seq[PitchPoint]

  PitchPointEditState* = enum
    None,
    Point,
    Segment,

  PitchPointEdit* = ref object
    state*: PitchPointEditState
    point*: PitchPoint
    pointDistance*: Inches
    pointCorrection*: PitchCorrection
    segment*: PitchSegment
    segmentDistance*: Inches
    segmentCorrection*: PitchCorrection