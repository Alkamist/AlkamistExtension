import std/math

func `+`*[A, B, C, D](a: (A, B), b: (C, D)): (A, B) = (a[0] + b[0], a[1] + b[1])
func `+=`*[A, B, C, D](a: var (A, B), b: (C, D)) = a = a + b
func `-`*[A, B, C, D](a: (A, B), b: (C, D)): (A, B) = (a[0] - b[0], a[1] - b[1])
func `-=`*[A, B, C, D](a: var (A, B), b: (C, D)) = a = a - b
func `+`*[A, B](vec: (A, B)): (A, B) = vec
func `-`*[A, B](vec: (A, B)): (A, B) = (-vec[0], -vec[1])

func distance*[A, B](a, b: (A, B)): A =
  let
    dx = (a[0] - b[0]).float
    dy = (a[1] - b[1]).float
  sqrt(dx * dx + dy * dy).A

func distance*[A, B](point: (A, B), segment: ((A, B), (A, B))): A =
  let
    pX = point[0].float
    pY = point[1].float
    x1 = segment[0][0].float
    y1 = segment[0][1].float
    x2 = segment[1][0].float
    y2 = segment[1][1].float
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

  sqrt(dx * dx + dy * dy).A