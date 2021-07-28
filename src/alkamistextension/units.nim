import std/math

type
  Dpi* = distinct float
  Pixels* = distinct float
  Semitones* = distinct float
  Seconds* = distinct float
  Inches* = distinct float
  Meters* = distinct float

template defineFloatType(typ: typedesc): untyped =
  func toInt*(a: typ): int {.borrow.}

  {.push inline.}

  func toFloat*(a: typ): float = a.float
  func `+`*(a: typ): typ = (a.toFloat).typ
  func `-`*(a: typ): typ = (-a.toFloat).typ
  func `+`*(a, b: typ): typ = (a.toFloat + b.toFloat).typ
  func `+=`*(a: var typ, b: typ) = a = a + b
  func `-`*(a, b: typ): typ = (a.toFloat - b.toFloat).typ
  func `-=`*(a: var typ, b: typ) = a = a - b
  func `<`*(a, b: typ): bool = a.toFloat < b.toFloat
  func `<=`*(a, b: typ): bool = a.toFloat < b.toFloat
  func `==`*(a, b: typ): bool = a.toFloat < b.toFloat
  func `*`*(a: typ, b: SomeNumber): typ = (a.float * b).typ
  func `*=`*(a: var typ, b: SomeNumber) = a = a * b
  func `/`*(a: typ, b: SomeNumber): typ = (a.float / b).typ
  func `/=`*(a: var typ, b: SomeNumber) = a = a / b
  func `/`*(a, b: typ): float = a.toFloat / b.toFloat
  func abs*(a: typ): typ = a.toFloat.abs.typ
  func round*(a: typ): typ = a.toFloat.round.typ
  func `$`*(a: typ): string = $a.toFloat

  {.pop.}

defineFloatType(Dpi)
defineFloatType(Pixels)
defineFloatType(Semitones)
defineFloatType(Seconds)
defineFloatType(Inches)
defineFloatType(Meters)

{.push inline.}

func `*`*(a: Dpi, b: Inches): Pixels {.borrow.}
func `*`*(a: Inches, b: Dpi): Pixels {.borrow.}
func `/`*(a: Pixels, b: Dpi): Inches {.borrow.}

const inchesPerMeter = 39.37007874
converter toInches*(a: Meters): Inches {.inline.} = (a * inchesPerMeter).Inches
converter toMeters*(a: Inches): Meters {.inline.} = (a / inchesPerMeter).Meters

{.pop.}