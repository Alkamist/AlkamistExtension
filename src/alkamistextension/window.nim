import
  std/[tables, options],
  winapi, units, lice, input

type
  Window* = ref object
    image*: Image
    backgroundColor*: Color
    input*: Input
    dpi*: Dpi
    onUpdate*: proc()
    onDraw*: proc()
    onResize*: proc()
    onMove*: proc()
    onMouseMove*: proc()
    onMousePress*: proc()
    onMouseRelease*: proc()
    onKeyPress*: proc()
    onKeyRelease*: proc()
    hasUpdateLoop: bool
    hdc: HDC
    paintStruct: PAINTSTRUCT
    hInstance: HINSTANCE
    hWnd: HWND
    parent: HWND
    rect: RECT
    title: string

var hWndWindows = initTable[HWND, Window]()

{.push inline.}

func title*(window: Window): string =
  window.title

func `title=`*(window: var Window, value: string) =
  window.title = value
  discard SetWindowText(window.hWnd, value)

func left*(window: Window): Inches =
  window.rect.left.Pixels / window.dpi

func right*(window: Window): Inches =
  window.rect.right.Pixels / window.dpi

func top*(window: Window): Inches =
  window.rect.top.Pixels / window.dpi

func bottom*(window: Window): Inches =
  window.rect.bottom.Pixels / window.dpi

func x*(window: Window): Inches =
  window.left

func y*(window: Window): Inches =
  window.top

func position*(window: Window): Position2d[Inches] =
  result.x = window.x
  result.y = window.y

func width*(window: Window): Inches =
  abs(window.right - window.left)

func height*(window: Window): Inches =
  abs(window.bottom - window.top)

{.pop.}

func setBounds*(window: Window, x, y, width, height: Inches) =
  template toCint(inches: Inches): cint =
    (inches * window.dpi).cint
  discard SetWindowPos(window.hWnd, HWND_TOP, x.toCint, y.toCint, width.toCint, height.toCint, SWP_NOZORDER)

func enableUpdateLoop*(window: var Window, loopEvery: UINT) =
  discard SetTimer(window.hWnd, 1, loopEvery, nil)
  window.hasUpdateLoop = true

func disableUpdateLoop*(window: var Window) =
  if window.hasUpdateLoop:
    discard KillTimer(window.hWnd, 1)
    window.hasUpdateLoop = false

func redraw*(window: Window) =
  discard InvalidateRect(window.hWnd, nil, 1)

template updateBounds(window: var Window): untyped =
  discard GetWindowRect(window.hWnd, addr window.rect)

proc windowProc(hWnd: HWND, msg: UINT, wParam: WPARAM, lParam: LPARAM): INT_PTR {.stdcall.} =
  template ifWindow(code: untyped): untyped =
    if hWndWindows.contains(hWnd):
      var window {.inject.} = hWndWindows[hWnd]
      code

  template getMouseButtonKind(): untyped =
    case msg:
    of WM_LBUTTONDOWN, WM_LBUTTONUP, WM_LBUTTONDBLCLK: some(Left)
    of WM_MBUTTONDOWN, WM_MBUTTONUP, WM_MBUTTONDBLCLK: some(Middle)
    of WM_RBUTTONDOWN, WM_RBUTTONUP, WM_RBUTTONDBLCLK: some(Right)
    of WM_XBUTTONDOWN, WM_XBUTTONUP, WM_XBUTTONDBLCLK:
      if HIWORD(wParam) == 1: some(Side1)
      else: some(Side2)
    else: none(MouseButton)

  case msg:

  of WM_ERASEBKGND:
    ifWindow:
      window.image.clear(window.backgroundColor)
      window.redraw()
      return 1

  of WM_MOUSEMOVE:
    ifWindow:
      window.input.previousMousePosition.x = window.input.mousePosition.x
      window.input.previousMousePosition.y = window.input.mousePosition.y
      window.input.mousePosition.x = GET_X_LPARAM(lParam).Pixels / window.dpi
      window.input.mousePosition.y = GET_Y_LPARAM(lParam).Pixels / window.dpi
      if window.onMouseMove != nil:
        window.onMouseMove()

  of WM_TIMER:
    ifWindow:
      if window.onUpdate != nil:
        window.onUpdate()

  of WM_SIZE:
    ifWindow:
      window.updateBounds()
      window.image.resize(window.width * window.dpi,
                          window.height * window.dpi)
      if window.onResize != nil:
        window.onResize()

  of WM_MOVE:
    ifWindow:
      window.updateBounds()
      if window.onMove != nil:
        window.onMove()

  of WM_PAINT:
    ifWindow:
      window.paintStruct = PAINTSTRUCT()
      window.hdc = window.hWnd.BeginPaint(addr window.paintStruct)
      if window.onDraw != nil:
          window.onDraw()
      let context = window.image.context
      if context.isSome:
        discard BitBlt(
          window.hdc,
          0, 0,
          (window.width * window.dpi).cint,
          (window.height * window.dpi).cint,
          context.get,
          0, 0,
          SRCCOPY,
        )
      discard window.hWnd.EndPaint(addr window.paintStruct)

  of WM_CLOSE:
    ifWindow:
      window.disableUpdateLoop()
    discard DestroyWindow(hWnd)
    hWndWindows.del(hWnd)
    return 0

  of WM_LBUTTONDOWN, WM_LBUTTONDBLCLK,
     WM_MBUTTONDOWN, WM_MBUTTONDBLCLK,
     WM_RBUTTONDOWN, WM_RBUTTONDBLCLK,
     WM_XBUTTONDOWN, WM_XBUTTONDBLCLK:
    ifWindow:
      let button = getMouseButtonKind()
      if button.isSome:
        discard SetCapture(window.hWnd)
        window.input.mouseButtonStates[button.get] = true
        if window.onMousePress != nil:
          window.input.lastMousePress = button.get
          window.onMousePress()

  of WM_LBUTTONUP, WM_MBUTTONUP, WM_RBUTTONUP, WM_XBUTTONUP:
    ifWindow:
      let button = getMouseButtonKind()
      if button.isSome:
        discard ReleaseCapture()
        window.input.mouseButtonStates[button.get] = false
        if window.onMouseRelease != nil:
          window.input.lastMouseRelease = button.get
          window.onMouseRelease()

  of WM_KEYDOWN, WM_SYSKEYDOWN:
    ifWindow:
      let key = wParam.int.toKeyboardKey
      if key.isSome:
        window.input.keyStates[key.get] = true
        if window.onKeyPress != nil:
          window.input.lastKeyPress = key.get
          window.onKeyPress()

  of WM_KEYUP, WM_SYSKEYUP:
    ifWindow:
      let key = wParam.int.toKeyboardKey
      if key.isSome:
        window.input.keyStates[key.get] = false
        if window.onKeyRelease != nil:
          window.input.lastKeyRelease = key.get
          window.onKeyRelease()

  else:
    discard

proc newWindow*(hInstance: HINSTANCE, parent: HWND): Window =
  result = Window(hWnd: CreateDialog(hInstance, MAKEINTRESOURCE(100), parent, windowProc))

  if result.hWnd != nil:
    result.title = "Unnamed Window"
    result.updateBounds()
    result.backgroundColor = rgb(0, 0, 0)
    result.image = initImage(0.Pixels, 0.Pixels)
    result.input = newInput()
    result.dpi = 96.0.Dpi
    hWndWindows[result.hWnd] = result
    discard ShowWindow(result.hWnd, SW_SHOW)