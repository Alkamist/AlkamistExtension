const inchesPerMeter = 39.37007874

type
  Dpi* = distinct float
  Pixels* = distinct float
  Inches* = distinct float
  Meters* = distinct float

  SomeDistance* = Inches | Meters

  Position2d*[T: SomeNumber|SomeDistance] = object
    x*, y*: T

  Vector2d*[T: SomeNumber|SomeDistance] = object
    x*, y*: T

  Semitones* = distinct float
  Seconds* = distinct float

func toInt*(a: Dpi): int {.borrow.}
func toInt*(a: Pixels): int {.borrow.}
func toInt*(a: Inches): int {.borrow.}

func toFloat*(a: Dpi): float {.inline.} = a.float
func toFloat*(a: Pixels): float {.inline.} = a.float
func toFloat*(a: SomeDistance): float {.inline.} = a.float

func `*`*(a: Dpi, b: Inches): Pixels {.borrow.}
func `*`*(a: Inches, b: Dpi): Pixels {.borrow.}
func `/`*(a: Pixels, b: Dpi): Inches {.borrow.}

func `+`*[T: SomeDistance](a, b: T): T {.inline.} = (a.toFloat + b.toFloat).T
func `-`*[T: SomeDistance](a, b: T): T {.inline.} = (a.toFloat - b.toFloat).T

func `+`*[T: SomeDistance](a: T): T {.inline.} = +a.float
func `-`*[T: SomeDistance](a: T): T {.inline.} = -a.float

func `<`*[T: SomeDistance](a, b: T): bool {.inline.} = a.toFloat < b.toFloat
func `<=`*[T: SomeDistance](a, b: T): bool {.inline.} = a.toFloat < b.toFloat
func `==`*[T: SomeDistance](a, b: T): bool {.inline.} = a.toFloat < b.toFloat

func `*`*[T: SomeDistance](a: T, b: SomeNumber): T {.inline.} = (a.toFloat * b).T
func `/`*[T: SomeDistance](a: T, b: SomeNumber): T {.inline.} = (a.toFloat / b).T

func `/`*[T: SomeDistance](a, b: T): float {.inline.} = a.toFloat / b.toFloat

func abs*[T: SomeDistance](a: T): T {.inline.} = a.toFloat.abs.T

converter toInches*(a: Meters): Inches {.inline.} = (a * inchesPerMeter).Inches
converter toMeters*(a: Inches): Meters {.inline.} = (a / inchesPerMeter).Meters

func `+`*[A, B: SomeDistance](a: Position2d[A], b: Position2d[B]): Vector2d[A] {.inline.} =
  Vector2d[A](x: a.x + b.x, y: a.y + b.y)
func `-`*[A, B: SomeDistance](a: Position2d[A], b: Position2d[B]): Vector2d[A] {.inline.} =
  Vector2d[A](x: a.x - b.x, y: a.y - b.y)

func `$`*[T: SomeDistance](a: T): string {.inline.} = $a.float

let
  a = Position2d[Meters](x: 1.Meters, y: 5.Meters)
  b = Position2d[Inches](x: 10.Inches, y: 10.Inches)

echo a + b