import
  std/[tables, options],
  winapi, lice, input, vector

export lice, input, vector

type
  Window* = ref object
    image*: Image
    backgroundColor*: Color
    input*: Input
    dpi*: float
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
    clientRect: RECT
    title: string

var hWndWindows = initTable[HWND, Window]()

{.push inline.}

func title*(window: Window): string = window.title
func left*(window: Window): float = window.rect.left.float / window.dpi
func right*(window: Window): float = window.rect.right.float / window.dpi
func top*(window: Window): float = window.rect.top.float / window.dpi
func bottom*(window: Window): float = window.rect.bottom.float / window.dpi
func x*(window: Window): float = window.left
func y*(window: Window): float = window.top
func position*(window: Window): (float, float) = (window.x, window.y)
func width*(window: Window): float = abs(window.right - window.left)
func height*(window: Window): float = abs(window.bottom - window.top)
func dimensions*(window: Window): (float, float) = (window.width, window.height)
func bounds*(window: Window): ((float, float), (float, float)) = (window.position, window.dimensions)
func clientLeft*(window: Window): float = window.clientRect.left.float / window.dpi
func clientRight*(window: Window): float = window.clientRect.right.float / window.dpi
func clientTop*(window: Window): float = window.clientRect.top.float / window.dpi
func clientBottom*(window: Window): float = window.clientRect.bottom.float / window.dpi
func clientX*(window: Window): float = window.clientLeft
func clientY*(window: Window): float = window.clientRight
func clientPosition*(window: Window): (float, float) = (window.clientX, window.clientY)
func clientWidth*(window: Window): float = abs(window.clientRight - window.clientLeft)
func clientHeight*(window: Window): float = abs(window.clientBottom - window.clientTop)
func clientDimensions*(window: Window): (float, float) = (window.clientWidth, window.clientHeight)
func clientBounds*(window: Window): ((float, float), (float, float)) = (window.clientPosition, window.clientDimensions)

func `title=`*(window: var Window, value: string) =
  window.title = value
  discard SetWindowText(window.hWnd, value)
func `bounds=`*(window: Window, value: ((float, float), (float, float))) =
  template toNative(inches: float): cint =
    (inches * window.dpi).cint
  discard SetWindowPos(
    window.hWnd, HWND_TOP,
    value.position.x.toNative,
    value.position.y.toNative,
    value.dimensions.width.toNative,
    value.dimensions.height.toNative,
    SWP_NOZORDER,
  )

{.pop.}

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
  discard GetClientRect(window.hWnd, addr window.clientRect)
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
      window.input.mousePosition.x = GET_X_LPARAM(lParam).float / window.dpi
      window.input.mousePosition.y = GET_Y_LPARAM(lParam).float / window.dpi
      if window.onMouseMove != nil:
        window.onMouseMove()

  of WM_TIMER:
    ifWindow:
      if window.onUpdate != nil:
        window.onUpdate()

  of WM_SIZE:
    ifWindow:
      window.updateBounds()
      window.image.resize((window.clientWidth, window.clientHeight))
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
          window.input.lastMousePressWasDoubleClick = msg in [WM_LBUTTONDBLCLK,
                                                              WM_MBUTTONDBLCLK,
                                                              WM_RBUTTONDBLCLK,
                                                              WM_XBUTTONDBLCLK]
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
    result.input = newInput()
    result.dpi = 96.0
    result.image = initImage(result.dpi, (0.0, 0.0))
    hWndWindows[result.hWnd] = result
    discard ShowWindow(result.hWnd, SW_SHOW)