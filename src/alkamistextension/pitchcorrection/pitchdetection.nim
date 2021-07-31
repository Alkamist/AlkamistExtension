import std/math

const yinThreshold = 0.2

{.push inline.}

func toPitch(frequency: float): float =
  69.0 + 12.0 * ln(frequency / 440.0) / ln(2.0)

func toSamples(time, sampleRate: float): int =
  (time * sampleRate).floor.int

func dbToAmplitude(dB: float): float =
  exp(dB * 0.11512925464970228420089957273422)

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

func locationOfFirstMinimum[T](buffer: openArray[T]): T =
  var
    minValue = yinThreshold
    location = -1

  for i in 1 ..< buffer.len - 1:
    let value = buffer[i]
    if value < yinThreshold:
      if value > minValue:
        break
      minValue = value
      location = i

  if location == -1:
    -1.T
  else:
    buffer.parabolicInterpolation(location)

{.pop.}

func calculateFrequency*[T](buffer: openArray[T],
                            sampleRate: float,
                            minFrequency, maxFrequency: float): T =
  let
    minLook = floor(sampleRate / maxFrequency).toInt
    maxLook = floor(min(sampleRate / minFrequency, buffer.len.float)).toInt

  var cmnds: seq[T]

  for tau in minLook .. maxLook:
    cmnds.add(buffer.cumulativeMeanNormalizedDifference(tau))

  let location = cmnds.locationOfFirstMinimum
  if location > -1:
    return sampleRate / (minLook.T + location)

func detectPitch*[T](buffer: openArray[T],
                     sampleRate: float,
                     minFrequency, maxFrequency: float,
                     timeWindow: float,
                     startTime = 0.0,
                     windowStep = 0.04, windowOverlap = 2.0,
                     minRms = -60.0): seq[(T, T)] =
  let
    minRmsAmp = minRms.dbToAmplitude
    windowSamples = windowStep.toSamples(sampleRate)
    bufferEnd = buffer.len - 1

  var seekTime = startTime

  while true:
    let
      seekSamples = seekTime.toSamples(sampleRate)
      seekEnd = min(bufferEnd, seekSamples + windowSamples)

    var subBuffer = buffer[seekSamples .. seekEnd]

    let rms = subBuffer.rootMeanSquare
    if rms >= minRmsAmp:
      let frequency = subBuffer.calculateFrequency(sampleRate, minFrequency, maxFrequency)

      if frequency > 0.0:
        let pitch = frequency.toPitch
        result.add((seekTime, pitch))

    seekTime += windowStep / windowOverlap

    if seekTime >= startTime + timeWindow:
      break

when isMainModule:
  import std/times

  let
    sampleRate = 8000.0
    sineFrequency = 441.0
    sineSampleLength = sampleRate / sineFrequency

  var sineWave: seq[float]

  for i in 0 ..< 44100:
    let phase = 2.0 * PI * i.toFloat / sineSampleLength
    sineWave.add(sin(phase))

  let t0 = cpuTime()
  let points = sineWave.detectPitch(sampleRate, 80.0, 1000.0, 1.0)
  let t1 = cpuTime()

  for point in points:
    echo "t: " & $point[0] & " " & "p: " & $point[1]

  echo "Total time: " & $(t1 - t0)