type
  Button* = object
    isPressed*: bool
    wasPressed*: bool

{.push inline.}

func isReleased*(button: Button): bool =
  not button.isPressed

func wasReleased*(button: Button): bool =
  not button.wasPressed

func justPressed*(button: Button): bool =
  button.isPressed and not button.wasPressed

func justReleased*(button: Button): bool =
  button.wasPressed and not button.isPressed

func update*(button: var Button) =
  button.wasPressed = button.isPressed

func update*(button: var Button, state: bool) =
  button.wasPressed = button.isPressed
  button.isPressed = state

func press*(button: var Button) =
  button.isPressed = true

func pressUpdate*(button: var Button) =
  button.update()
  button.isPressed = true

func release*(button: var Button) =
  button.isPressed = false

func releaseUpdate*(button: var Button) =
  button.update()
  button.isPressed = false

{.pop.}