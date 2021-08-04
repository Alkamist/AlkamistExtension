import
  std/[math, options],
  types, utility

export options

const yinThreshold = 0.2

# http://audition.ens.fr/adc/pdf/2002_JASA_YIN.pdf Figure (6)
func yinDifference(buffer: AudioBuffer, tau: int): Sample =
  for i in 0 ..< buffer.len - tau:
    result += (buffer[i] - buffer[i + tau]).pow(2)

# http://audition.ens.fr/adc/pdf/2002_JASA_YIN.pdf Figure (8)
func cumulativeMeanNormalizedDifference(buffer: AudioBuffer, tau: int): Sample =
  if tau > 0:
    for i in 1 .. tau:
      result += buffer.yinDifference(i)
    result /= tau.Sample
    buffer.yinDifference(tau) / result
  else:
    1.0

func locationOfFirstMinimum(samples: openArray[Sample]): Option[float] =
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

func calculateFrequency*(buffer: AudioBuffer, minFrequency, maxFrequency: float): Option[float] =
  let
    minLook = (buffer.sampleRate / maxFrequency).floor.toInt
    maxLook = (min(buffer.sampleRate / minFrequency, buffer.len.toFloat)).floor.toInt

  var differences = newSeq[Sample]()

  for tau in minLook .. maxLook:
    differences.add(buffer.cumulativeMeanNormalizedDifference(tau))

  let location = differences.locationOfFirstMinimum
  if location.isSome:
    return some(buffer.sampleRate / (minLook.toFloat + location.get))

func windowStep*(buffer: AudioBuffer,
                 windowSeconds = 0.04,
                 windowOverlap = 2.0): seq[tuple[start: int, buffer: AudioBuffer]] =
  let
    windowSamples = windowSeconds.toSamples(buffer.sampleRate)
    windowMove = (windowSamples.toFloat / windowOverlap).toInt

  var seekSamples = 0

  while true:
    let seekEnd = seekSamples + windowSamples

    if seekSamples > buffer.high or
       seekEnd > buffer.high:
      break

    result.add((
      start: seekSamples,
      buffer: buffer[seekSamples .. seekEnd],
    ))

    seekSamples += windowMove