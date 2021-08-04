type
  Sample* = float64

  AudioBuffer* = object
    samples*: seq[Sample]
    sampleRate*: float

func initAudioBuffer*(sampleLength = 0, sampleRate = 44100.0): AudioBuffer =
  result.sampleRate = sampleRate
  result.samples = newSeq[Sample](sampleLength)

template `[]`*[A, B](buffer: AudioBuffer, slice: HSlice[A, B]): untyped =
  AudioBuffer(
    sampleRate: buffer.sampleRate,
    samples: buffer.samples[slice],
  )

template `[]`*[T](buffer: AudioBuffer, i: T): untyped = buffer.samples[i]
template `[]`*[T](buffer: var AudioBuffer, i: T): untyped = buffer.samples[i]
template `[]=`*[T](buffer: var AudioBuffer, i: T, v: Sample) = buffer.samples[i] = v

template low*(buffer: AudioBuffer): untyped = buffer.samples.low
template high*(buffer: AudioBuffer): untyped = buffer.samples.high
template len*(buffer: AudioBuffer): untyped = buffer.samples.len

template items*(buffer: AudioBuffer): untyped = buffer.samples.items
template mitems*(buffer: var AudioBuffer): untyped = buffer.samples.mitems
template pairs*(buffer: AudioBuffer): untyped = buffer.samples.pairs
template mpairs*(buffer: var AudioBuffer): untyped = buffer.samples.mpairs

template add*(buffer: var AudioBuffer, value: Sample): untyped = buffer.samples.add(value)