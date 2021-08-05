import
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

template toSamples(time, sampleRate: float): int = (time * sampleRate).toInt

{.push inline.}

func currentProject*(): Project =
  result.reaperPtr = EnumProjects(-1, nil, 0)

func selectedItem*(index: int): Item =
  result.reaperPtr = GetSelectedMediaItem(nil, index.cint)

func selectedItem*(project: Project, index: int): Item =
  result.reaperPtr = GetSelectedMediaItem(project.reaperPtr, index.cint)

func activeTake*(item: Item): Take =
  result.reaperPtr = GetActiveTake(item.reaperPtr)

func kind*(take: Take): TakeKind =
  if TakeIsMIDI(take.reaperPtr): Midi
  else: Audio

func source*(take: Take): Source =
  result.reaperPtr = GetMediaItemTake_Source(take.reaperPtr)

func sampleRate*(source: Source): int =
  GetMediaSourceSampleRate(source.reaperPtr)

func numChannels*(source: Source): int =
  GetMediaSourceNumChannels(source.reaperPtr)

func timeLength*(source: Source): float =
  var lengthIsInQuarterNotes: ptr bool
  GetMediaSourceLength(source.reaperPtr, lengthIsInQuarterNotes)
  #if lengthIsInQuarterNotes:
    # Fix here

func numChannels*(peaks: Peaks): int =
  peaks.len

func sampleLength*(peaks: Peaks): int =
  if peaks.len > 0:
    peaks[0].len
  else:
    0

{.pop.}

func toMono*(peaks: Peaks): MonoPeaks =
  result = newSeq[PeakSample](peaks.sampleLength)

  for channelBuffer in peaks:
    for sampleId, sample in channelBuffer:
      result[sampleId].minimum += sample.minimum
      result[sampleId].maximum += sample.maximum

  let numChannels = peaks.numChannels
  for sample in result.mitems:
    sample.minimum /= numChannels.toFloat
    sample.maximum /= numChannels.toFloat

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

# proc analyzePitch*(take: Take): seq[tuple[time, pitch: float]] =
#   if take.kind == Audio:
#     let
#       source = take.source
#       sampleRate = 8000.0
#       lengthSeconds = 5.0
#       peaks = source.peaks(0.0, lengthSeconds, sampleRate).toMono

#     var audioBuffer = initAudioBuffer(peaks.len, sampleRate)
#     for sampleId, peakSample in peaks:
#       audioBuffer[sampleId] = 0.5 * (peakSample.minimum + peakSample.maximum)

    # var frequencyBuffer: seq[(float, float)]
    # for step in audioBuffer.windowStep:
    #   if step.buffer.rms > dbToAmplitude(-60.0):
    #     let frequency = step.buffer.calculateFrequency(80.0, 5000.0)
    #     if frequency.isSome:
    #       let time = step.start.toSeconds(sampleRate)
    #       frequencyBuffer.add((time, frequency.get))

    # for value in frequencyBuffer:
    #   reaperEcho $value[1].toPitch

    # for value in frequencyBuffer:
    #   result.add((value[0], value[1].toPitch))