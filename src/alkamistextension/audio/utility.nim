import std/math, types

template toPitch*(frequency: untyped): untyped =
  69.0 + 12.0 * ln(frequency / 440.0) / ln(2.0)

template toSamples*(timeSeconds, sampleRate: untyped): untyped =
  (timeSeconds * sampleRate).floor.int

template toSeconds*(samples, sampleRate: untyped): untyped =
  samples.float / sampleRate

template dbToAmplitude*(dB: untyped): untyped =
  exp(dB * 0.11512925464970228420089957273422)

template parabolicInterpolation*(buffer, index: untyped): untyped =
  block:
    assert index > buffer.low
    assert index < buffer.high

    let
      i1 = index - 1
      i3 = index + 1

      x1 = i1.toFloat
      x2 = index.toFloat
      x3 = i3.toFloat

      y1 = buffer[i1]
      y2 = buffer[index]
      y3 = buffer[i3]

      denominator = (x1 - x2) * (x1 - x3) * (x2 - x3)

      a = (x3 * (y2 - y1) + x2 * (y1 - y3) + x1 * (y3 - y2)) / denominator
      b = (x3 * x3 * (y1 - y2) + x2 * x2 * (y3 - y1) + x1 * x1 * (y2 - y3)) / denominator

      # c = (x2 * x3 * (x2 - x3) * y1 + x3 * x1 * (x3 - x1) * y2 + x1 * x2 * (x1 - x2) * y3) / denominator

    -b / (2.0 * a)

func rms*(buffer: AudioBuffer): Sample {.inline.} =
  for sample in buffer:
    result += sample.abs
  result /= buffer.len.Sample

func createSineWave*(sampleRate, lengthSeconds, frequency: float): AudioBuffer =
    let
      lengthSamples = lengthSeconds.toSamples(sampleRate)
      periodSamples = sampleRate / frequency

    result.sampleRate = sampleRate
    result.samples = newSeq[Sample](lengthSamples)

    for i in 0 ..< lengthSamples:
      let phase = 2.0 * PI * i.toFloat / periodSamples
      result.samples[i] = sin(phase)