import std/math

const numKeys* = 128

func getWhiteKeyNumbers(): seq[int] {.compileTime.} =
  const whiteKeyMultiples = [0, 2, 3, 5, 7, 8, 10]
  for i in 0 .. 10:
    for multiple in whiteKeyMultiples:
      result.add i * 12 + multiple

func getIsWhiteKeyArray(): array[numKeys, bool] {.compileTime.} =
  let whiteKeyNumbers = getWhiteKeyNumbers()
  for i in 0 ..< numKeys:
    result[i] = whiteKeyNumbers.contains(i)

const isWhiteKeyArray = getIsWhiteKeyArray()

func isWhiteKey*(index: int): bool =
  isWhiteKeyArray[index]

func pointDistance*(x1, y1, x2, y2: float): float =
  let
    dx = x1 - x2
    dy = y1 - y2
  sqrt(dx * dx + dy * dy)

func pointLineDistance*(pointX, pointY, lineX1, lineY1, lineX2, lineY2: float): float =
  let
    a = pointX - lineX1
    b = pointY - lineY1
    c = lineX2 - lineX1
    d = lineY2 - lineY1
    dotProduct = a * c + b * d
    lengthSquared = c * c + d * d

  var
    param = -1.0
    xx, yy: float

  if lengthSquared != 0.0:
    param = dotProduct / lengthSquared

  if param < 0.0:
    xx = lineX1
    yy = lineY1

  elif param > 1.0:
    xx = lineX2
    yy = lineY2

  else:
    xx = lineX1 + param * c
    yy = lineY1 + param * d

  let
    dx = pointX - xx
    dy = pointY - yy

  sqrt(dx * dx + dy * dy)