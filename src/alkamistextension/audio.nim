import audio/[types, utility, pitchdetection]

export types, utility, pitchdetection

when isMainModule:
  import std/[options, times, threadpool]
  {.experimental: "parallel".}

  template bench(title: string, code: untyped): untyped =
    block:
      let t = cpuTime()
      code
      echo(title & ": " & $(cpuTime() - t))

  let sineWave = createSineWave(44100.0, 10.0, 441.0)

  bench("Parallel"):
    var frequencies: seq[Option[float]]
    parallel:
      for step in sineWave.windowStep:
        let frequency = spawn(step.buffer.calculateFrequency(80.0, 1000.0))
        frequencies.add(frequency)

    for frequency in frequencies:
      if frequency.isSome:
        echo frequency.get