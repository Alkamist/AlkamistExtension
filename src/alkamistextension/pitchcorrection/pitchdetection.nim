import std/[math, options]

export options

const yinThreshold = 0.2

template toPitch*(frequency: untyped): untyped =
  69.0 + 12.0 * ln(frequency / 440.0) / ln(2.0)

template toSamples(time, sampleRate: untyped): untyped =
  (time * sampleRate).floor.int

template dbToAmplitude(dB: untyped): untyped =
  exp(dB * 0.11512925464970228420089957273422)

{.push inline.}

func rootMeanSquare[T](buffer: openArray[T]): T =
  for sample in buffer:
    result += sample.abs
  result /= buffer.len.toFloat

func parabolicInterpolation[T](buffer: openArray[T], index: int): T =
  let
    i1 = index - 1
    x1 = i1.T
    y1 = buffer[i1]
    x2 = index.T
    y2 = buffer[index]
    i3 = index + 1
    x3 = i3.T
    y3 = buffer[i3]
    denominator = (x1 - x2) * (x1 - x3) * (x2 - x3)
    a = (x3 * (y2 - y1) + x2 * (y1 - y3) + x1 * (y3 - y2)) / denominator
    b = (x3 * x3 * (y1 - y2) + x2 * x2 * (y3 - y1) + x1 * x1 * (y2 - y3)) / denominator
    # c = (x2 * x3 * (x2 - x3) * y1 + x3 * x1 * (x3 - x1) * y2 + x1 * x2 * (x1 - x2) * y3) / denominator
  -b / (2.0 * a)

# http://audition.ens.fr/adc/pdf/2002_JASA_YIN.pdf Figure (6)
func difference[T](buffer: openArray[T], tau: int): T =
  for i in 0 ..< buffer.len - tau:
    result += (buffer[i] - buffer[i + tau]).pow(2)

# http://audition.ens.fr/adc/pdf/2002_JASA_YIN.pdf Figure (8)
func cumulativeMeanNormalizedDifference[T](buffer: openArray[T], tau: int): T =
  if tau == 0:
    1.T
  else:
    var sum: T
    for i in 0 ..< tau:
      sum += buffer.difference(i)
    sum /= tau.T
    buffer.difference(tau) / sum

func locationOfFirstMinimum[T](buffer: openArray[T]): Option[T] =
  var
    location: Option[int]
    minValue = yinThreshold

  for i in 1 ..< buffer.high:
    let value = buffer[i]
    if value < yinThreshold:
      if value > minValue:
        break
      minValue = value
      location = some(i)

  if location.isSome:
    return some(buffer.parabolicInterpolation(location.get))

iterator windowStep*[T](buffer: openArray[T],
                        sampleRate: float,
                        windowSeconds = 0.04,
                        windowOverlap = 2.0,
                        minRms = -60.0): (T, seq[T]) =
  let
    startSeconds = 0.0
    lengthSeconds = buffer.len.float / sampleRate
    minRmsAmp = minRms.dbToAmplitude
    windowSamples = windowSeconds.toSamples(sampleRate)

  var seekSeconds = startSeconds

  while true:
    let
      seekSamples = seekSeconds.toSamples(sampleRate)
      seekEnd = min(buffer.high, seekSamples + windowSamples)

    var windowBuffer = buffer[seekSamples .. seekEnd]

    let rms = windowBuffer.rootMeanSquare
    if rms >= minRmsAmp:
      yield (seekSeconds, windowBuffer)

    seekSeconds += windowSeconds / windowOverlap

    if seekSeconds >= startSeconds + lengthSeconds:
      break

func windowBuffers*[T](buffer: openArray[T],
                       sampleRate: float,
                       windowSeconds = 0.04,
                       windowOverlap = 2.0,
                       minRms = -60.0): seq[(T, seq[T])] =
  for windowInfo in buffer.windowStep(sampleRate, windowSeconds, windowOverlap, minRms):
    result.add(windowInfo)

func calculateFrequency*[T](buffer: openArray[T],
                            sampleRate: float,
                            minFrequency, maxFrequency: float): Option[T] =
  let
    minLook = floor(sampleRate / maxFrequency).toInt
    maxLook = floor(min(sampleRate / minFrequency, buffer.len.float)).toInt

  var cmnds: seq[T]

  for tau in minLook .. maxLook:
    cmnds.add(buffer.cumulativeMeanNormalizedDifference(tau))

  let location = cmnds.locationOfFirstMinimum
  if location.isSome:
    return some(sampleRate / (minLook.T + location.get))

{.pop.}

when isMainModule:
  import std/[times, threadpool]
  {.experimental: "parallel".}

  template bench(title: string, code: untyped): untyped =
    block:
      let t = cpuTime()
      code
      echo(title & ": " & $(cpuTime() - t))

  func createSineWave(sampleRate, lengthSeconds, frequency: float): seq[float64] =
    let
      lengthSamples = lengthSeconds.toSamples(sampleRate)
      periodSamples = sampleRate / frequency

    result = newSeq[float64](lengthSamples)

    for i in 0 ..< lengthSamples:
      let phase = 2.0 * PI * i.toFloat / periodSamples
      result[i] = sin(phase)

  let sampleRate = 8000.0
  var sineWave = createSineWave(sampleRate, 30.0, 441.0)

  bench("Normal"):
    var frequencies: seq[Option[float64]]
    for windowStart, windowBuffer in sineWave.windowStep(sampleRate):
      frequencies.add(windowBuffer.calculateFrequency(sampleRate, 80.0, 8000.0))

  bench("Spawn"):
    var frequencies: seq[FlowVar[Option[float64]]]

    for windowStart, windowBuffer in sineWave.windowStep(sampleRate):
      let frequency = spawn(windowBuffer.calculateFrequency(sampleRate, 80.0, 8000.0))
      frequencies.add(frequency)

    sync()

  bench("Parallel"):
    let buffers = sineWave.windowBuffers(sampleRate)
    var frequencies: seq[Option[float64]]

    parallel:
      for buffer in buffers:
        let frequency = spawn(buffer[1].calculateFrequency(sampleRate, 80.0, 8000.0))
        frequencies.add(frequency)