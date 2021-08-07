import std/math

func toPitch*[T](frequency: T): T =
  69.0 + 12.0 * ln(frequency / 440.0) / ln(2.0)

func toSamples*[A, B](timeSeconds: A, sampleRate: B): int =
  (timeSeconds * sampleRate).floor.int

func toSeconds*[A, B](samples: A, sampleRate: B): float =
  samples.float / sampleRate

func dbToAmplitude*[T](dB: T): T =
  exp(dB * ln(10.0) / 20.0)

func parabolicInterpolation*[A, B](buffer: openArray[A], index: B): A =
  assert index > buffer.low
  assert index < buffer.high

  let
    i1 = index - 1
    i3 = index + 1

    x1 = i1.A
    x2 = index.A
    x3 = i3.A

    y1 = buffer[i1]
    y2 = buffer[index]
    y3 = buffer[i3]

    denominator = (x1 - x2) * (x1 - x3) * (x2 - x3)

    a = (x3 * (y2 - y1) + x2 * (y1 - y3) + x1 * (y3 - y2)) / denominator
    b = (x3 * x3 * (y1 - y2) + x2 * x2 * (y3 - y1) + x1 * x1 * (y2 - y3)) / denominator

    # c = (x2 * x3 * (x2 - x3) * y1 + x3 * x1 * (x3 - x1) * y2 + x1 * x2 * (x1 - x2) * y3) / denominator

  -b / (2.0 * a)

func rms*[T](buffer: openArray[T]): T =
  for sample in buffer:
    result += sample.abs
  result /= buffer.len.T

func createSineWave*(sampleRate, lengthSeconds, frequency: float): seq[float64] =
    let
      lengthSamples = lengthSeconds.toSamples(sampleRate)
      periodSamples = sampleRate / frequency

    result = newSeq[float64](lengthSamples)

    for i in 0 ..< lengthSamples:
      let phase = 2.0 * PI * i.toFloat / periodSamples
      result[i] = sin(phase)