import
  std/[threadpool, options],
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

proc toMonoPeaks*(peaks: Peaks): MonoPeaks {.inline.} =
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

  const maxReaperPeakBlocks = 3
  let cDoublesToAlloc = lengthSamples * numChannels * maxReaperPeakBlocks

  var memory = createU(cdouble, cDoublesToAlloc)

  let info = PCM_Source_GetPeaks(
    src = source.reaperPtr,
    peakrate = sampleRate,
    starttime = startSeconds,
    numchannels = numChannels.cint,
    numsamplesperchannel = lengthSamples.cint,
    want_extra_type = 0,
    buf = memory,
  )

  # let samplesWrote = info and 0x000fffff

  # For some absurd reason this function will write all zeros
  # to the buffer unless I concatenate a string afterward.
  let weirdFix = "weird" & "fix"

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
  let peaks = source.peaks(startSeconds, lengthSeconds, sampleRate).toMonoPeaks

  var audioBuffer = newSeq[float64](peaks.len)
  for sampleId, peakSample in peaks:
    audioBuffer[sampleId] = 0.5 * (peakSample.minimum + peakSample.maximum)

  let minRms = dbToAmplitude(-60.0)

  var frequencies: seq[(float, float)]
  for start, buffer in audioBuffer.windowStep(sampleRate):
    if buffer.rms > minRms:
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
  let peaks = source.peaks(startSeconds, lengthSeconds, sampleRate).toMonoPeaks

  var audioBuffer = newSeq[float64](peaks.len)
  for sampleId, peakSample in peaks:
    audioBuffer[sampleId] = 0.5 * (peakSample.minimum + peakSample.maximum)

  let minRms = dbToAmplitude(-60.0)

  var flowFrequencies: seq[(float, FlowVar[Option[float]])]
  for start, buffer in audioBuffer.windowStep(sampleRate):
    if buffer.rms > minRms:
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

proc zeroPoint*(time: float): EnvelopePoint {.inline.} =
  result.time = time
  result.shape = Linear

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

proc len*(envelope: Envelope): int {.inline.} =
  CountEnvelopePoints(envelope.reaperPtr)

proc clearTimeRange*(envelope: Envelope,
                     startSeconds, endSeconds: float) {.inline.} =
  discard DeleteEnvelopePointRange(envelope.reaperPtr, startSeconds, endSeconds)

proc clear*(envelope: Envelope) {.inline.} =
  for i in 0 ..< envelope.len:
    var
      time: cdouble
      noSort = true
    discard SetEnvelopePoint(envelope.reaperPtr, i.cint, time.addr, nil, nil, nil, nil, noSort.addr)
  envelope.clearTimeRange(-0.01, 0.01)

proc sort*(envelope: Envelope) {.inline.} =
  discard Envelope_SortPoints(envelope.reaperPtr)

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

proc numStretchMarkers*(take: Take): int {.inline.} =
  GetTakeNumStretchMarkers(take.reaperPtr)

proc playRate*(take: Take): float {.inline.} =
  GetMediaItemTakeInfo_Value(take.reaperPtr, "D_PLAYRATE")

# This will screw up slanted stretch markers.
proc toSourceTime*(take: Take, takeTime: float): float {.inline.} =
  let tempMarkerIndex = SetTakeStretchMarker(take.reaperPtr, -1, takeTime * take.playRate, nil)
  var
    unused: cdouble
    srcTime: cdouble
  discard GetTakeStretchMarker(take.reaperPtr, tempMarkerIndex, unused.addr, srcTime.addr)
  discard DeleteTakeStretchMarkers(take.reaperPtr, tempMarkerIndex, nil)
  srcTime

# This will screw up slanted stretch markers.
proc toTakeTime*(take: Take, sourceTime: float): float {.inline.} =
  if take.numStretchMarkers < 1:
    return (sourceTime - take.toSourceTime(0.0)) / take.playRate

  const tolerance = 0.000001

  var
    guessTime = 0.0
    guessSourceTime = take.toSourceTime(guessTime)
    loopCount = 0

  while true:
    let error = sourceTime - guessSourceTime
    if error.abs < tolerance:
      break

    let
      testGuessSourceTime = take.toSourceTime(guessTime + error)
      seekRatio = (error / (testGuessSourceTime - guessSourceTime)).abs

    guessTime = guessTime + error * seekRatio
    guessSourceTime = take.toSourceTime(guessTime)

    loopCount = loopCount + 1
    if loopCount > 100:
      break

  guessTime

proc correctPitch*(take: Take,
                   pitchPoints: seq[tuple[time, pitch: float]],
                   corrections: seq[tuple[time, pitch, driftStrength, modStrength: float, isActive: bool]]) =
  template lerp(x1, x2, ratio): untyped =
    (1.0 - ratio) * x1 + ratio * x2

  let
    envelope = take.pitchEnvelope
    playRate = take.playRate

  const
    zeroPointGapLength = 0.200
    zeroPointDistance = 0.005

  envelope.clear()

  var
    isFirstActiveCorrection = true
    firstActiveCorrectionTime: Option[float]
    lastCorrectionWithActiveCorrectionBeforeItTime: Option[float]

  for correctionId, correction in corrections:
    let correctionTime = take.toTakeTime(correction.time) * playRate

    if correctionId > corrections.low:
      let previousCorrection = corrections[correctionId - 1]
      if previousCorrection.isActive:
        lastCorrectionWithActiveCorrectionBeforeItTime = some(correctionTime)

    if correctionId < corrections.high:
      if correction.isActive:
        if correctionId > corrections.low:
          let previousCorrection = corrections[correctionId - 1]
          if not previousCorrection.isActive:
            envelope.add zeroPoint(correctionTime - zeroPointDistance)

        if isFirstActiveCorrection:
          firstActiveCorrectionTime = some(correctionTime)
          isFirstActiveCorrection = false

        let
          nextCorrection = corrections[correctionId + 1]
          nextCorrectionTime = take.toTakeTime(nextCorrection.time) * playRate
          correctionLength = nextCorrectionTime - correctionTime

        for pointId, point in pitchPoints:
          let
            pointTime = take.toTakeTime(point.time) * playRate
            pointIsInCorrection =
              pointTime >= correctionTime and
              pointTime <= nextCorrectionTime

          if pointIsInCorrection:
            let
              timeRatio = (pointTime - correctionTime) / correctionLength
              targetPitch = lerp(correction.pitch, nextCorrection.pitch, timeRatio)
              pitchAdjustment = correction.driftStrength * (targetPitch - point.pitch)

            envelope.add EnvelopePoint(
              time: pointTime,
              value: pitchAdjustment,
              shape: Linear,
            )

            let
              hasPreviousPoint = pointId > pitchPoints.low
              hasNextPoint = pointId < pitchPoints.high

            if hasPreviousPoint:
              let
                previousPoint = pitchPoints[pointId - 1]
                gap = pointTime - take.toTakeTime(previousPoint.time) * playRate
              if gap > zeroPointGapLength:
                envelope.add zeroPoint(pointTime - zeroPointDistance)
            else:
              envelope.add zeroPoint(pointTime - zeroPointDistance)

            if hasNextPoint:
              let
                nextPoint = pitchPoints[pointId + 1]
                gap = take.toTakeTime(nextPoint.time) * playRate - pointTime
              if gap > zeroPointGapLength:
                envelope.add zeroPoint(pointTime + zeroPointDistance)
            else:
              envelope.add zeroPoint(pointTime + zeroPointDistance)
      else:
        let nextCorrection = corrections[correctionId + 1]
        if nextCorrection.isActive and not correction.isActive:
          envelope.add zeroPoint(correctionTime + zeroPointDistance)

  if firstActiveCorrectionTime.isSome:
    envelope.add zeroPoint(firstActiveCorrectionTime.get - zeroPointDistance)

  if lastCorrectionWithActiveCorrectionBeforeItTime.isSome:
    envelope.add zeroPoint(lastCorrectionWithActiveCorrectionBeforeItTime.get + zeroPointDistance)

  envelope.sort()