import std/math, units

{.push inline.}

func a*[A, B](a: (A, B)): A = a[0]
func b*[A, B](a: (A, B)): B = a[1]
func x*[A, B](a: (A, B)): A = a[0]
func y*[A, B](a: (A, B)): B = a[1]
func width*[A, B](a: (A, B)): A = a[0]
func height*[A, B](a: (A, B)): B = a[1]

func `a=`*[A, B](a: var (A, B), value: A) = a[0] = value
func `b=`*[A, B](a: var (A, B), value: B) = a[1] = value
func `x=`*[A, B](a: var (A, B), value: A) = a[0] = value
func `y=`*[A, B](a: var (A, B), value: B) = a[1] = value
func `width=`*[A, B](a: var (A, B), value: A) = a[0] = value
func `height=`*[A, B](a: var (A, B), value: B) = a[1] = value

func `+`*[A, B, C, D](a: (A, B), b: (C, D)): (A, B) = (a[0] + b[0], a[1] + b[1])
func `+=`*[A, B, C, D](a: var (A, B), b: (C, D)) = a = a + b
func `-`*[A, B, C, D](a: (A, B), b: (C, D)): (A, B) = (a[0] - b[0], a[1] - b[1])
func `-=`*[A, B, C, D](a: var (A, B), b: (C, D)) = a = a - b
func `-`*[A, B](a: (A, B)): (A, B) = (-a[0], -a[1])

func position*[A, B](a: ((A, B), (A, B))): (A, B) = a[0]
func dimensions*[A, B](a: ((A, B), (A, B))): (A, B) = a[1]

func `position=`*[A, B](a: var ((A, B), (A, B)), value: (A, B)) = a[0] = value
func `dimensions=`*[A, B](a: var ((A, B), (A, B)), value: (A, B)) = a[1] = value

func distance*[T](a, b: (T, T)): T =
  let
    dx = (a[0] - b[0]).toFloat
    dy = (a[1] - b[1]).toFloat
  sqrt(dx * dx + dy * dy).T

func distance*[T](point: (T, T), segment: ((T, T), (T, T))): T =
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