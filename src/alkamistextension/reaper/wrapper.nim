import
  std/math,
  apitypes, apifunctions

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

const peakBlockSamples = 128

template toSamples(time: float, sampleRate: int): int =
  (time * sampleRate.toFloat).toInt

template toTime(numSamples, sampleRate: int): float =
  numSamples.toFloat / sampleRate.toFloat

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

proc getPeakBlock(source: Source,
                  startTime: float,
                  sampleRate, numChannels: int,
                  memory: pointer): seq[array[peakBlockSamples, float64]] =
  result = newSeq[array[peakBlockSamples, float64]](numChannels)

  discard PCM_Source_GetPeaks(
    src = source.reaperPtr,
    peakrate = sampleRate.cdouble,
    starttime = startTime,
    numchannels = numChannels.cint,
    numsamplesperchannel = peakBlockSamples.cint,
    want_extra_type = 0,
    buf = cast[ptr cdouble](memory),
  )

  var buffer = cast[ptr UncheckedArray[cdouble]](memory)

  for sampleId in 0 ..< peakBlockSamples:
    for channelId in 0 ..< numChannels:
      result[channelId][sampleId] = buffer[numChannels * sampleId + channelId]

{.pop.}

proc peaks*(source: Source, start, length: float): seq[seq[float64]] =
  let
    sampleRate = source.sampleRate
    numChannels = source.numChannels
    lengthSamples = length.toSamples(sampleRate)
    numPeakBlocks = (lengthSamples / peakBlockSamples).ceil.int

  result = newSeq[seq[float64]](numChannels)

  const
    bytesPerCDouble = 8
    maxReaperBlocksPerPeakRequest = 3

  let bytesToAlloc = bytesPerCDouble * peakBlockSamples *
                     numChannels * maxReaperBlocksPerPeakRequest

  var
    seekSample = start.toSamples(sampleRate)
    memory = alloc(bytesToAlloc)

  for _ in 0 ..< numPeakBlocks - 1:
    let
      seekTime = seekSample.toTime(sampleRate)
      peaks = source.getPeakBlock(seekTime, sampleRate, numChannels, memory)

    for channelId, channelBuffer in peaks:
      for sampleId, sample in channelBuffer:
        result[channelId].add(sample)

    seekSample += peakBlockSamples

  let
    samplesLeftOver = lengthSamples mod peakBlockSamples
    seekTime = seekSample.toTime(sampleRate)
    finalBlock = source.getPeakBlock(seekTime, sampleRate, numChannels, memory)

  for channelId, channelBuffer in finalBlock:
    for sampleId, sample in channelBuffer:
      if sampleId >= samplesLeftOver:
        break
      result[channelId].add(sample)

  dealloc(memory)