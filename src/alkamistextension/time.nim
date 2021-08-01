import std/[math, times]

export times

{.push inline.}

func secondsFloat*(duration: Duration): float =
  duration.inNanoseconds.int / 1000000000

func secondsToDuration*(seconds: float): Duration =
  let
    s = seconds.floor
    ns = ((seconds - s) * 1000000000).round
  initDuration(seconds = s.int64, nanoseconds = ns.int64)

{.pop.}