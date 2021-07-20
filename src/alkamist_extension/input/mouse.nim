import button

type
  MouseButtonKind* = enum
    Left,
    Middle,
    Right,
    Side1,
    Side2,

  Mouse* = object
    x*, xPrevious*, y*, yPrevious*: int
    buttons*: array[MouseButtonKind, Button]

{.push inline.}

func xJustMoved*(mouse: Mouse): bool =
  mouse.x != mouse.xPrevious

func yJustMoved*(mouse: Mouse): bool =
  mouse.y != mouse.yPrevious

func justMoved*(mouse: Mouse): bool =
  mouse.xJustMoved or mouse.yJustMoved

func `[]`*(mouse: var Mouse, kind: MouseButtonKind): var Button =
  return mouse.buttons[kind]

func update*(mouse: var Mouse) =
  mouse.xPrevious = mouse.x
  mouse.yPrevious = mouse.y
  for button in mouse.buttons.mitems:
    button.update()

{.pop.}