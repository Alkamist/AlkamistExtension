import std/math, units

type
  Vector2d[T] = (T, T)
  Segment2d[T] = ((T, T), (T, T))
  Bounds2d[T] = ((T, T), (T, T))

{.push inline.}

func a*[T](a: Vector2d[T]): T = a[0]
func `a=`*[T](a: var Vector2d[T], value: T) = a[0] = value
func b*[T](a: Vector2d[T]): T = a[1]
func `b=`*[T](a: var Vector2d[T], value: T) = a[1] = value

func x*[T](a: Vector2d[T]): T = a[0]
func `x=`*[T](a: var Vector2d[T], value: T) = a[0] = value
func y*[T](a: Vector2d[T]): T = a[1]
func `y=`*[T](a: var Vector2d[T], value: T) = a[1] = value

func width*[T](a: Vector2d[T]): T = a[0]
func `width=`*[T](a: var Vector2d[T], value: T) = a[0] = value
func height*[T](a: Vector2d[T]): T = a[1]
func `height=`*[T](a: var Vector2d[T], value: T) = a[1] = value

func position*[T](a: Bounds2d[T]): Vector2d[T] = a[0]
func `position=`*[T](a: var Bounds2d[T], value: Vector2d[T]) = a[0] = value
func dimensions*[T](a: Bounds2d[T]): Vector2d[T] = a[1]
func `dimensions=`*[T](a: var Bounds2d[T], value: Vector2d[T]) = a[1] = value

func `+`*[A, B](a: Vector2d[A], b: Vector2d[B]): Vector2d[A] = (a[0] + b[0], a[1] + b[1])
func `+=`*[A, B](a: var Vector2d[A], b: Vector2d[B]) = a = a + b
func `-`*[A, B](a: Vector2d[A], b: Vector2d[B]): Vector2d[A] = (a[0] - b[0], a[1] - b[1])
func `-=`*[A, B](a: var Vector2d[A], b: Vector2d[B]) = a = a - b
func `-`*[T](a: Vector2d[T]): Vector2d[T] = (-a[0], -a[1])

func distance*[T](a, b: Vector2d[T]): T =
  let
    dx = (a[0] - b[0]).toFloat
    dy = (a[1] - b[1]).toFloat
  sqrt(dx * dx + dy * dy).T

func distance*[T](point: Vector2d[T], segment: Segment2d[T]): T =
  let
    pX = point[0].toFloat
    pY = point[1].toFloat
    x1 = segment[0][0].toFloat
    y1 = segment[0][1].toFloat
    x2 = segment[1][0].toFloat
    y2 = segment[1][1].toFloat
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