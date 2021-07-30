import ../units, ../geometry, ../lice

type
  BoxSelect* = ref object
    x1*, y1*, x2*, y2*: Inches
    isActive*: bool

{.push inline.}

func left*(a: BoxSelect): Inches = min(a.x2, a.x1)
func right*(a: BoxSelect): Inches = max(a.x2, a.x1)
func bottom*(a: BoxSelect): Inches = max(a.y2, a.y1)
func top*(a: BoxSelect): Inches = min(a.y2, a.y1)
func width*(a: BoxSelect): Inches = (a.x2 - a.x1).abs
func height*(a: BoxSelect): Inches = (a.y2 - a.y1).abs

func positionIsInside*(boxSelect: BoxSelect, position: (Inches, Inches)): bool =
  position.x >= boxSelect.left and
  position.x <= boxSelect.left + boxSelect.width and
  position.y >= boxSelect.top and
  position.y <= boxSelect.top + boxSelect.height

func draw(box: BoxSelect, image: Image) =
  if box.isActive:
    image.fillRectangle(
      box.left, box.top, box.width, box.height,
      rgb(0, 0, 0, 0.3),
    )
    image.drawRectangle(
      box.left, box.top, box.width, box.height,
      rgb(255, 255, 255, 0.6),
    )

{.pop.}