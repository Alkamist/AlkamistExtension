import apitypes, apifunctions

type
  Project* = object
    reaperPtr*: ptr ReaProject

  Item* = object
    reaperPtr*: ptr MediaItem

  TakeKind* = enum
    Audio,
    Midi,

  Take* = object
    reaperPtr*: ptr MediaItem_Take

  Source* = object
    reaperPtr*: ptr PCM_source

  PeakSample* = tuple[minimum, maximum: float64]
  PeakChannelBuffer* = seq[PeakSample]
  MonoPeaks* = PeakChannelBuffer
  Peaks* = seq[PeakChannelBuffer]

template toSamples(time, sampleRate: float): int =
  (time * sampleRate).toInt

# template toTime(numSamples: int, sampleRate: float): float =
#   numSamples.toFloat / sampleRate

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