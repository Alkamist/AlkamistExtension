import ../lice, ../vector

type
  BoxSelect* = ref object
    isActive*: bool
    points*: ((float, float), (float, float))

template p0: untyped = box.points[0]
template p1: untyped = box.points[1]

{.push inline.}

func left*(box: BoxSelect): float = min(p1.x, p0.x)
func right*(box: BoxSelect): float = max(p1.x, p0.x)
func bottom*(box: BoxSelect): float = max(p1.y, p0.y)
func top*(box: BoxSelect): float = min(p1.y, p0.y)
func x*(box: BoxSelect): float = box.left
func y*(box: BoxSelect): float = box.top
func width*(box: BoxSelect): float = (p1.x - p0.x).abs
func height*(box: BoxSelect): float = (p1.y - p0.y).abs
func position*(box: BoxSelect): (float, float) = (box.left, box.top)
func dimensions*(box: BoxSelect): (float, float) = (box.width, box.height)
func bounds*(box: BoxSelect): ((float, float), (float, float)) = (box.position, box.dimensions)

func `left=`*(box: BoxSelect, value: float) =
  if p0.x <= p1.x:
    p0.x = value
  else:
    p1.x = value

func `right=`*(box: BoxSelect, value: float) =
  if p0.x > p1.x:
    p0.x = value
  else:
    p1.x = value

func `bottom=`*(box: BoxSelect, value: float) =
  if p0.y >= p1.y:
    p0.y = value
  else:
    p1.y = value

func `top=`*(box: BoxSelect, value: float) =
  if p0.y < p1.y:
    p0.y = value
  else:
    p1.y = value

func `x=`*(box: BoxSelect, value: float) =
  let width = box.width
  p0.x = value
  p1.x = value + width

func `y=`*(box: BoxSelect, value: float) =
  let height = box.height
  p0.y = value
  p1.y = value + height

func `width=`*(box: BoxSelect, value: float) =
  if p0.x <= p1.x:
    p1.x = p0.x + value
  else:
    p0.x = p1.x + value

func `height=`*(box: BoxSelect, value: float) =
  if p0.y >= p1.y:
    p0.y = p1.y + value
  else:
    p1.y = p0.y + value

func `position=`*(box: BoxSelect, value: (float, float)) =
  box.x = value.x
  box.y = value.y

func `dimensions=`*(box: BoxSelect, value: (float, float)) =
  box.width = value.width
  box.height = value.height

func `bounds=`*(box: BoxSelect, value: ((float, float), (float, float))) =
  box.position = value.position
  box.dimensions = value.dimensions

func isInside*(point: (float, float), box: BoxSelect): bool =
  point.x >= box.left and
  point.x <= box.left + box.width and
  point.y >= box.top and
  point.y <= box.top + box.height

func draw*(box: BoxSelect, image: Image) =
  if box.isActive:
    image.fillRectangle(box.position, box.dimensions, rgb(0, 0, 0, 0.3))
    image.drawRectangle(box.position, box.dimensions, rgb(255, 255, 255, 0.6))

func newBoxSelect*(): BoxSelect =
  BoxSelect()

{.pop.}