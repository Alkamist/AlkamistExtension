type
  Dpi* = distinct float
  Pixels* = distinct float

  Semitones* = distinct float
  Seconds* = distinct float

  Inches* = distinct float
  Meters* = distinct float

  Vector2d*[T] = tuple[x: T, y: T]

template defineFloatType(typ: typedesc): untyped =
  func toInt*(a: typ): int {.borrow.}
  func toFloat*(a: typ): float {.inline.} = a.float
  func `+`*(a: typ): typ {.inline.} = (a.toFloat).typ
  func `-`*(a: typ): typ {.inline.} = (-a.toFloat).typ
  func `+`*(a, b: typ): typ {.inline.} = (a.toFloat + b.toFloat).typ
  func `+=`*(a: var typ, b: typ) {.inline.} = a = a + b
  func `-`*(a, b: typ): typ {.inline.} = (a.toFloat - b.toFloat).typ
  func `-=`*(a: var typ, b: typ) {.inline.} = a = a - b
  func `<`*(a, b: typ): bool {.inline.} = a.toFloat < b.toFloat
  func `<=`*(a, b: typ): bool {.inline.} = a.toFloat < b.toFloat
  func `==`*(a, b: typ): bool {.inline.} = a.toFloat < b.toFloat
  func `*`*(a: typ, b: SomeNumber): typ {.inline.} = (a.float * b).typ
  func `*=`*(a: var typ, b: SomeNumber) {.inline.} = a = a * b
  func `/`*(a: typ, b: SomeNumber): typ {.inline.} = (a.float / b).typ
  func `/=`*(a: var typ, b: SomeNumber) {.inline.} = a = a / b
  func `/`*(a, b: typ): float {.inline.} = a.toFloat / b.toFloat
  func abs*(a: typ): typ {.inline.} = a.toFloat.abs.typ
  func `$`*(a: typ): string {.inline.} = $a.toFloat

defineFloatType(Dpi)
defineFloatType(Pixels)
defineFloatType(Semitones)
defineFloatType(Seconds)
defineFloatType(Inches)
defineFloatType(Meters)

func `+`*[A, B](a: Vector2d[A], b: Vector2d[B]): Vector2d[A] {.inline.} =
  (x: a.x + b.x, y: a.y + b.y)
func `+=`*[A, B](a: var Vector2d[A], b: Vector2d[B]) {.inline.} =
  a = a + b

func `-`*[A, B](a: Vector2d[A], b: Vector2d[B]): Vector2d[A] {.inline.} =
  (x: a.x - b.x, y: a.y - b.y)
func `-=`*[A, B](a: var Vector2d[A], b: Vector2d[B]) {.inline.} =
  a = a - b

func `-`*[T](a: Vector2d[T]): Vector2d[T] {.inline.} =
  (x: -a.x, y: -a.y)

func `*`*(a: Dpi, b: Inches): Pixels {.borrow.}
func `*`*(a: Inches, b: Dpi): Pixels {.borrow.}
func `/`*(a: Pixels, b: Dpi): Inches {.borrow.}

const inchesPerMeter = 39.37007874
converter toInches*(a: Meters): Inches {.inline.} = (a * inchesPerMeter).Inches
converter toMeters*(a: Inches): Meters {.inline.} = (a / inchesPerMeter).Meters