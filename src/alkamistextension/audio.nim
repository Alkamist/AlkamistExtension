import audio/[utility, pitchdetection]

export utility, pitchdetection

when isMainModule:
  import std/[options, times, threadpool]
  {.experimental: "parallel".}

  template bench(title: string, code: untyped): untyped =
    block:
      let t = cpuTime()
      code
      echo(title & ": " & $(cpuTime() - t))

  let
    sampleRate = 44100.0
    sineWave = createSineWave(sampleRate, 1.0, 441.0)

  # bench("Series"):
  #   var frequencies: seq[Option[float]]
  #   for start, buffer in sineWave.windowStep(sampleRate):
  #     let frequency = buffer.calculateFrequency(sampleRate, 80.0, 4000.0)
  #     frequencies.add(frequency)

  #   for frequency in frequencies:
  #     if frequency.isSome:
  #       echo frequency.get

  # bench("Spawn"):
  #   var flowVars: seq[FlowVar[Option[float]]]
  #   for start, buffer in sineWave.windowStep(sampleRate):
  #     let frequency = spawn buffer.calculateFrequency(sampleRate, 80.0, 4000.0)
  #     flowVars.add(frequency)

  #   sync()

  #   for flowVar in flowVars:
  #     let frequency = ^flowVar
  #     if frequency.isSome:
  #       echo frequency.get

  bench("Parallel"):
    var frequencies: seq[Option[float]]
    parallel:
      for start, buffer in sineWave.windowStep(sampleRate):
        let frequency = spawn buffer.calculateFrequency(sampleRate, 80.0, 4000.0)
        frequencies.add(frequency)

    for frequency in frequencies:
      if frequency.isSome:
        echo frequency.get