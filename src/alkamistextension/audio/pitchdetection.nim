import
  std/[math, options],
  utility

export options

const yinThreshold = 0.2

# http://audition.ens.fr/adc/pdf/2002_JASA_YIN.pdf Figure (6)
func yinDifference[T](buffer: openArray[T], tau: int): T =
  for i in 0 ..< buffer.len - tau:
    result += (buffer[i] - buffer[i + tau]).pow(2)

# http://audition.ens.fr/adc/pdf/2002_JASA_YIN.pdf Figure (8)
func cumulativeMeanNormalizedDifference[T](buffer: openArray[T], tau: int): T =
  if tau > 0:
    for i in 1 .. tau:
      result += buffer.yinDifference(i)
    result /= tau.T
    buffer.yinDifference(tau) / result
  else:
    1.0.T

func locationOfFirstMinimum[T](samples: openArray[T]): Option[float] =
  block:
    var
      location: Option[int]
      minValue = yinThreshold

    for i in 1 ..< samples.high:
      let value = samples[i]
      if value < yinThreshold:
        if value > minValue:
          break
        minValue = value
        location = some(i)

    if location.isSome:
      some(samples.parabolicInterpolation(location.get))
    else:
      none(float)

func calculateFrequency*[T](buffer: openArray[T],
                            sampleRate: float,
                            minFrequency, maxFrequency: float): Option[float] =
  let
    minLook = (sampleRate / maxFrequency).floor.int
    maxLook = (min(sampleRate / minFrequency, buffer.len.float)).floor.int

  var differences = newSeq[T]()

  for tau in minLook .. maxLook:
    differences.add(buffer.cumulativeMeanNormalizedDifference(tau))

  let location = differences.locationOfFirstMinimum
  if location.isSome:
    return some(sampleRate / (minLook.float + location.get))

iterator windowStep*[T](buffer: openArray[T],
                        sampleRate: float,
                        windowSeconds = 0.04,
                        windowOverlap = 2.0): (int, seq[T]) =
  let
    windowSamples = windowSeconds.toSamples(sampleRate)
    windowMove = (windowSamples.float / windowOverlap).toInt

  var seek = buffer.low

  while true:
    let
      seekEnd = seek + windowSamples
      seekInBounds = seek >= buffer.low and
                     seek <= buffer.high
      seekEndInBounds = seekEnd >= buffer.low and
                        seekEnd <= buffer.high

    if seekInBounds and seekEndInBounds and seekEnd > seek:
      yield (seek, buffer[seek .. seekEnd])
      seek += windowMove
    else:
      break