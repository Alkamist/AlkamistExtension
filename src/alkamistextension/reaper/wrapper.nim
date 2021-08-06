import
  std/threadpool,
  ../audio,
  apitypes, apifunctions

type
  Project* = object
    rawPtr*: pointer

  Item* = object
    rawPtr*: pointer

  TakeKind* = enum
    Audio,
    Midi,

  Take* = object
    rawPtr*: pointer

  Source* = object
    rawPtr*: pointer

  Envelope* = object
    rawPtr*: pointer

  EnvelopePointShape* = enum
    Linear,
    Square,
    SlowStartEnd,
    FastStart,
    FastEnd,
    Bezier,

  EnvelopePoint* = object
    time*, value*: float
    tension*: float
    shape*: EnvelopePointShape
    isSelected*: bool

  PeakSample* = tuple[minimum, maximum: float64]
  PeakChannelBuffer* = seq[PeakSample]
  MonoPeaks* = PeakChannelBuffer
  Peaks* = seq[PeakChannelBuffer]

template reaperPtr*(s: Project): ptr ReaProject = cast[ptr ReaProject](s.rawPtr)
template `reaperPtr=`*(s: var Project, v: ptr ReaProject) = s.rawPtr = cast[pointer](v)

template reaperPtr*(s: Item): ptr MediaItem = cast[ptr MediaItem](s.rawPtr)
template `reaperPtr=`*(s: var Item, v: ptr MediaItem) = s.rawPtr = cast[pointer](v)

template reaperPtr*(s: Take): ptr MediaItem_Take = cast[ptr MediaItem_Take](s.rawPtr)
template `reaperPtr=`*(s: var Take, v: ptr MediaItem_Take) = s.rawPtr = cast[pointer](v)

template reaperPtr*(s: Source): ptr PCM_Source = cast[ptr PCM_Source](s.rawPtr)
template `reaperPtr=`*(s: var Source, v: ptr PCM_Source) = s.rawPtr = cast[pointer](v)

template reaperPtr*(s: Envelope): ptr TrackEnvelope = cast[ptr TrackEnvelope](s.rawPtr)
template `reaperPtr=`*(s: var Envelope, v: ptr TrackEnvelope) = s.rawPtr = cast[pointer](v)

#############################################################
# General

proc updateArrange*() {.inline.} =
  UpdateArrange()

var uiRefreshPrevented = false
proc preventUiRefresh*(shouldPrevent: bool) {.inline.} =
  if shouldPrevent and not uiRefreshPrevented:
    PreventUIRefresh(1)
    uiRefreshPrevented = true
  elif not shouldPrevent and uiRefreshPrevented:
    PreventUIRefresh(-1)
    uiRefreshPrevented = false

proc mainCommand*(id: int) {.inline.} =
  Main_OnCommand(id.cint, 0)

proc mainCommand*(id: string) {.inline.} =
  Main_OnCommand(NamedCommandLookup(id), 0)

proc currentProject*(): Project {.inline.} =
  result.reaperPtr = EnumProjects(-1, nil, 0)

proc selectedItem*(index: int): Item {.inline.} =
  result.reaperPtr = GetSelectedMediaItem(nil, index.cint)

#############################################################
# Project

proc selectedItem*(project: Project, index: int): Item {.inline.} =
  result.reaperPtr = GetSelectedMediaItem(project.reaperPtr, index.cint)

#############################################################
# Item

proc activeTake*(item: Item): Take {.inline.} =
  result.reaperPtr = GetActiveTake(item.reaperPtr)

#############################################################
# Peaks

proc numChannels*(peaks: Peaks): int {.inline.} =
  peaks.len

proc sampleLength*(peaks: Peaks): int {.inline.} =
  if peaks.len > 0:
    peaks[0].len
  else:
    0

proc toMono*(peaks: Peaks): MonoPeaks {.inline.} =
  result = newSeq[PeakSample](peaks.sampleLength)

  for channelBuffer in peaks:
    for sampleId, sample in channelBuffer:
      result[sampleId].minimum += sample.minimum
      result[sampleId].maximum += sample.maximum

  let numChannels = peaks.numChannels
  for sample in result.mitems:
    sample.minimum /= numChannels.toFloat
    sample.maximum /= numChannels.toFloat

#############################################################
# Source

proc sampleRate*(source: Source): int {.inline.} =
  GetMediaSourceSampleRate(source.reaperPtr)

proc numChannels*(source: Source): int {.inline.} =
  GetMediaSourceNumChannels(source.reaperPtr)

proc timeLength*(source: Source): float {.inline.} =
  var
    offset: cdouble = 0.0
    length: cdouble = 0.0
    reverse = false
  discard PCM_Source_GetSectionInfo(source.reaperPtr, offset.addr, length.addr, reverse.addr)
  length

proc peaks*(source: Source,
            startSeconds, lengthSeconds: float,
            sampleRate: float): Peaks =
  let
    numChannels = source.numChannels
    lengthSamples = lengthSeconds.toSamples(sampleRate)

  for _ in 0 ..< numChannels:
    result.add(newSeq[PeakSample](lengthSamples))

  const
    bytesPerCDouble = 8
    maxReaperPeakBlocks = 3

  let bytesToAlloc = lengthSamples * bytesPerCDouble *
                     numChannels * maxReaperPeakBlocks

  var memory = alloc(bytesToAlloc)

  discard PCM_Source_GetPeaks(
    src = source.reaperPtr,
    peakrate = sampleRate.cdouble,
    starttime = startSeconds,
    numchannels = numChannels.cint,
    numsamplesperchannel = lengthSamples.cint,
    want_extra_type = 0,
    buf = cast[ptr cdouble](memory),
  )

  var rawBuffer = cast[ptr UncheckedArray[cdouble]](memory)

  for channelId, channelBuffer in result.mpairs:
    for sampleId in 0 ..< lengthSamples:
      let
        readOffset = numChannels * sampleId + channelId
        blockOffset = numChannels * lengthSamples
      channelBuffer[sampleId] = (
        minimum: rawBuffer[blockOffset + readOffset],
        maximum: rawBuffer[readOffset].float64,
      )

  dealloc(memory)

proc analyzePitchSingleCore*(source: Source,
                             startSeconds, lengthSeconds: float,
                             sampleRate = 8000.0,
                             minFrequency = 80.0,
                             maxFrequency = 4000.0): seq[tuple[time, pitch: float]] =
  let peaks = source.peaks(startSeconds, lengthSeconds, sampleRate).toMono

  var audioBuffer = newSeq[float64](peaks.len)
  for sampleId, peakSample in peaks:
    audioBuffer[sampleId] = 0.5 * (peakSample.minimum + peakSample.maximum)

  var frequencies: seq[(float, float)]
  for start, buffer in audioBuffer.windowStep(sampleRate):
    if buffer.rms > dbToAmplitude(-60.0):
      let frequency = buffer.calculateFrequency(sampleRate, minFrequency, maxFrequency)
      if frequency.isSome:
        let time = start.toSeconds(sampleRate)
        frequencies.add((time, frequency.get))

  for value in frequencies:
    result.add((value[0], value[1].toPitch))

proc analyzePitch*(source: Source,
                   startSeconds, lengthSeconds: float,
                   sampleRate = 8000.0,
                   minFrequency = 80.0,
                   maxFrequency = 4000.0): seq[tuple[time, pitch: float]] =
  let peaks = source.peaks(startSeconds, lengthSeconds, sampleRate).toMono

  var audioBuffer = newSeq[float64](peaks.len)
  for sampleId, peakSample in peaks:
    audioBuffer[sampleId] = 0.5 * (peakSample.minimum + peakSample.maximum)

  var flowFrequencies: seq[(float, FlowVar[Option[float]])]
  for start, buffer in audioBuffer.windowStep(sampleRate):
    if buffer.rms > dbToAmplitude(-60.0):
      let
        time = start.toSeconds(sampleRate)
        frequency = spawn buffer.calculateFrequency(sampleRate, minFrequency, maxFrequency)
      flowFrequencies.add((time, frequency))

  sync()

  for flowValue in flowFrequencies:
    let frequency = ^flowValue[1]
    if frequency.isSome:
      result.add((flowValue[0], frequency.get.toPitch))

#############################################################
# Envelope

proc toInt*(shape: EnvelopePointShape): int {.inline.} =
  case shape:
  of Linear: 0
  of Square: 1
  of SlowStartEnd: 2
  of FastStart: 3
  of FastEnd: 4
  of Bezier: 5

proc add*(envelope: Envelope, point: EnvelopePoint) {.inline.} =
  var noSort = true
  discard InsertEnvelopePoint(
    envelope.reaperPtr,
    point.time, point.value,
    point.shape.toInt.cint, point.tension,
    point.isSelected,
    noSort.addr,
  )

proc clearTimeRange*(envelope: Envelope,
                     startSeconds, endSeconds: float) {.inline.} =
  discard DeleteEnvelopePointRange(envelope.reaperPtr, startSeconds, endSeconds)

proc sort*(envelope: Envelope) {.inline.} =
  discard Envelope_SortPoints(envelope.reaperPtr)

proc correctPitch*(envelope: Envelope,
                   pitchPoints: seq[tuple[time, pitch: float]],
                   corrections: seq[tuple[time, pitch, driftStrength, modStrength: float, isActive: bool]]) =
  template lerp(x1, x2, ratio): untyped =
    (1.0 - ratio) * x1 + ratio * x2

  for correctionId, correction in corrections:
    if correction.isActive and correctionId < corrections.high:
      let
        nextCorrection = corrections[correctionId + 1]
        correctionLength = nextCorrection.time - correction.time
      for point in pitchPoints:
        if point.time >= correction.time and
           point.time <= nextCorrection.time:
          let
            timeRatio = (point.time - correction.time) / correctionLength
            targetPitch = lerp(correction.pitch, nextCorrection.pitch, timeRatio)
            pitchAdjustment = correction.driftStrength * (targetPitch - point.pitch)

          envelope.add EnvelopePoint(
            time: point.time,
            value: pitchAdjustment,
            shape: Linear,
          )

#############################################################
# Take

proc kind*(take: Take): TakeKind {.inline.} =
  if TakeIsMIDI(take.reaperPtr): Midi
  else: Audio

proc pitchEnvelope*(take: Take): Envelope {.inline.} =
  var envelopePtr = GetTakeEnvelopeByName(take.reaperPtr, "Pitch")
  if envelopePtr == nil:
    mainCommand("_S&M_TAKEENV10") # Show and unbypass take pitch envelope
    envelopePtr = GetTakeEnvelopeByName(take.reaperPtr, "Pitch")
    # mainCommand("_S&M_TAKEENVSHOW8") # Hide take pitch envelope
  result.reaperPtr = envelopePtr

proc source*(take: Take): Source {.inline.} =
  result.reaperPtr = GetMediaItemTake_Source(take.reaperPtr)