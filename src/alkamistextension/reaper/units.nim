type
  Dpi* = distinct float
  Pixels* = distinct float
  Inches* = distinct float

  VisualPosition* = object
    x*, y*: Inches

  VisualVector* = object
    x*, y*: Inches

  WindowPosition* {.borrow: `.`.} = distinct VisualPosition

func `*`*(a: Dpi, b: Inches): Pixels {.borrow.}
func `*`*(a: Inches, b: Dpi): Pixels {.borrow.}
func toInt*(a: Pixels): int {.borrow.}

# func `/`*(a: SomeInteger, b: Dpi): Inches {.inline.} = (a.float / b.float).Inches
# func `/`*(a: SomeFloat, b: Dpi): Inches {.inline.} = (a / b.float).Inches
func `/`*(a: SomeFloat, b: Dpi): Inches {.borrow.}
func `/`*(a: Pixels, b: Dpi): Inches {.borrow.}
func `/`*(a, b: Inches): Inches {.borrow.}
func `+`*(a, b: Inches): Inches {.borrow.}
func `-`*(a, b: Inches): Inches {.borrow.}
func `<`*(a, b: Inches): bool {.borrow.}
func `<=`*(a, b: Inches): bool {.borrow.}
func `==`*(a, b: Inches): bool {.borrow.}
func abs*(a: Inches): Inches {.borrow.}
func toInt*(a: Inches): int {.borrow.}

func `+`*(a, b: VisualPosition): VisualVector {.inline.} =
  VisualVector(x: a.x - b.x, y: a.y - b.y)
func `+`*(a, b: WindowPosition): VisualVector {.borrow.}

func `-`*(a, b: VisualPosition): VisualVector {.inline.} =
  VisualVector(x: a.x - b.x, y: a.y - b.y)
func `-`*(a, b: WindowPosition): VisualVector {.borrow.}