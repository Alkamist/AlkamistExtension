import std/math

const yinThreshold = 0.2

{.push inline.}

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

func calculateFrequency*[T](buffer: openArray[T], sampleRate, minFrequency, maxFrequency: float): T =
  let
    minLook = floor(sampleRate / maxFrequency).toInt
    maxLook = floor(min(sampleRate / minFrequency, buffer.len.float)).toInt

  var cmnds: seq[T]

  for tau in minLook .. maxLook:
    cmnds.add(buffer.cumulativeMeanNormalizedDifference(tau))

  let location = cmnds.locationOfFirstMinimum
  if location > -1:
    return sampleRate / (minLook.T + location)



# timeWindow = 0.04
# windowOverlap = 2.0
# lowRMSLimitdB = -60.0
# lowRMSLimit = exp(lowRMSLimitdB * 0.11512925464970228420089957273422)

when isMainModule:
  let
    sampleRate = 44100.0
    sineFrequency = 441.0
    sineSampleLength = sampleRate / sineFrequency

  var sineWave: seq[float]

  for i in 0 ..< 1000:
    let phase = 2.0 * PI * i.toFloat / sineSampleLength
    sineWave.add(sin(phase))

  echo sineWave.calculateFrequency(sampleRate, 80.0, 1000.0)