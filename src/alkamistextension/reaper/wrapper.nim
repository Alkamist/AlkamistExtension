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

proc analyzePitchSingleCore*(take: Take): seq[(float, float)] =
  if take.kind == Audio:
    let
      source = take.source
      sampleRate = 8000.0
      lengthSeconds = 5.0
      peaks = source.peaks(0.0, lengthSeconds, sampleRate).toMono

    var audioBuffer = newSeq[float64](peaks.len)
    for sampleId, peakSample in peaks:
      audioBuffer[sampleId] = 0.5 * (peakSample.minimum + peakSample.maximum)

    var frequencies: seq[(float, float)]
    for start, buffer in audioBuffer.windowStep(sampleRate):
      if buffer.rms > dbToAmplitude(-60.0):
        let frequency = buffer.calculateFrequency(sampleRate, 80.0, 4000.0)
        if frequency.isSome:
          let time = start.toSeconds(sampleRate)
          frequencies.add((time, frequency.get))

    for value in frequencies:
      result.add((value[0], value[1].toPitch))

proc analyzePitch*(take: Take): seq[(float, float)] =
  if take.kind == Audio:
    let
      source = take.source
      sampleRate = 8000.0
      lengthSeconds = 15.0
      peaks = source.peaks(0.0, lengthSeconds, sampleRate).toMono

    var audioBuffer = newSeq[float64](peaks.len)
    for sampleId, peakSample in peaks:
      audioBuffer[sampleId] = 0.5 * (peakSample.minimum + peakSample.maximum)

    var flowFrequencies: seq[(float, FlowVar[Option[float]])]
    for start, buffer in audioBuffer.windowStep(sampleRate):
      if buffer.rms > dbToAmplitude(-60.0):
        let
          time = start.toSeconds(sampleRate)
          frequency = spawn buffer.calculateFrequency(sampleRate, 80.0, 4000.0)
        flowFrequencies.add((time, frequency))

    sync()

    for flowValue in flowFrequencies:
      let frequency = ^flowValue[1]
      if frequency.isSome:
        result.add((flowValue[0], frequency.get.toPitch))