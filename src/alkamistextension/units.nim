import std/math

type
  Dpi* = distinct float
  Pixels* = distinct float

  Semitones* = distinct float
  Seconds* = distinct float

  Inches* = distinct float
  Meters* = distinct float

  Vector2d*[T] = tuple[x: T, y: T]
  Segment2d*[T] = tuple[a: Vector2d[T], b: Vector2d[T]]

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
  func `$`*(a: typ): string = $a.toFloat

  {.pop.}

defineFloatType(Dpi)
defineFloatType(Pixels)
defineFloatType(Semitones)
defineFloatType(Seconds)
defineFloatType(Inches)
defineFloatType(Meters)

{.push inline.}

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

func distance*[T](a, b: Vector2d[T]): T =
  let
    dx = (a.x - b.x).toFloat
    dy = (a.y - b.y).toFloat
  sqrt(dx * dx + dy * dy).T

func distance*[T](point: Vector2d[T], segment: Segment2d[T]): T =
  let
    pX = point.x.toFloat
    pY = point.y.toFloat
    x1 = segment[0].x.toFloat
    y1 = segment[0].y.toFloat
    x2 = segment[1].x.toFloat
    y2 = segment[1].y.toFloat
    a = pX - x1
    b = pY - y1
    c = x2 - x1
    d = y2 - y1
    dotProduct = a * c + b * d
    lengthSquared = c * c + d * d

  var
    param = -1.0
    xx, yy: float

  if lengthSquared != 0.0:
    param = dotProduct / lengthSquared

  if param < 0.0:
    xx = x1
    yy = y1

  elif param > 1.0:
    xx = x2
    yy = y2

  else:
    xx = x1 + param * c
    yy = y1 + param * d

  let
    dx = pX - xx
    dy = pY - yy

  sqrt(dx * dx + dy * dy).T

{.pop.}