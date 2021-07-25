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