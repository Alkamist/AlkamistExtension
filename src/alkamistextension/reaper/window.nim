import
  std/[tables, options],
  winapi, lice, keyboard, mouse

type
  Window* = ref object
    onUpdate*: proc()
    onDraw*: proc()
    onResize*: proc()
    onMove*: proc()
    onMouseMove*: proc(x, y, xPrevious, yPrevious: int)
    onMousePress*: proc(button: MouseButton)
    onMouseRelease*: proc(button: MouseButton)
    onKeyPress*: proc(key: KeyboardKey)
    onKeyRelease*: proc(key: KeyboardKey)
    mouseX, mouseY: int
    mouseXPrevious, mouseYPrevious: int
    keyStates: array[KeyboardKey, bool]
    mouseButtonStates: array[MouseButton, bool]
    mainBitmap: Bitmap
    backgroundColor: Color
    hasUpdateLoop: bool
    hdc: HDC
    paintStruct: PAINTSTRUCT
    hInstance: HINSTANCE
    hWnd: HWND
    parent: HWND
    bounds: RECT
    title: string

var hWndWindows = initTable[HWND, Window]()

func setBounds*(window: var Window, x, y, width, height: int) =
  discard SetWindowPos(window.hWnd, HWND_TOP, x, y, width, height, SWP_NOZORDER)

func mouseX*(window: Window): int =
  window.mouseX

func mouseY*(window: Window): int =
  window.mouseY

func keyIsPressed*(window: Window, key: KeyboardKey): bool =
  window.keyStates[key]

func mouseButtonIsPressed*(window: Window, button: MouseButton): bool =
  window.mouseButtonStates[button]

func title*(window: Window): string =
  window.title

func `title=`*(window: var Window, value: string) =
  window.title = value
  discard SetWindowText(window.hWnd, value)

func left*(window: Window): int =
  window.bounds.left

func right*(window: Window): int =
  window.bounds.right

func top*(window: Window): int =
  window.bounds.top

func bottom*(window: Window): int =
  window.bounds.bottom

func width*(window: Window): int =
  abs(window.right - window.left)

func height*(window: Window): int =
  abs(window.bottom - window.top)

func drawRectangle*(window: Window, x, y, width, height: int) =
  discard

func drawRectangle*(window: Window, x, y, width, height: float) =
  discard

func fillBackground(window: var Window) =
  window.mainBitmap.clear(window.backgroundColor)

func updateBounds(window: var Window) =
  discard GetWindowRect(window.hWnd, addr window.bounds)

func enableUpdateLoop*(window: var Window, loopEvery: UINT) =
  discard SetTimer(window.hWnd, 1, loopEvery, nil)
  window.hasUpdateLoop = true

func disableUpdateLoop*(window: var Window) =
  if window.hasUpdateLoop:
    discard KillTimer(window.hWnd, 1)
    window.hasUpdateLoop = false

proc captureMouse(window: var Window) =
  discard SetCapture(window.hWnd)

proc releaseMouse(window: var Window) =
  discard ReleaseCapture()

proc blitMainBitmap(window: var Window) =
  discard BitBlt(
    window.hdc,
    0, 0, window.width, window.height,
    window.mainBitmap.context,
    0, 0,
    SRCCOPY,
  )

proc redraw*(window: var Window) =
  discard InvalidateRect(window.hWnd, nil, 1)

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
      window.fillBackground()
      window.redraw()
      return 1

  of WM_MOUSEMOVE:
    ifWindow:
      window.mouseXPrevious = window.mouseX
      window.mouseYPrevious = window.mouseY
      window.mouseX = GET_X_LPARAM(lParam)
      window.mouseY = GET_Y_LPARAM(lParam)
      if window.onMouseMove != nil:
        window.onMouseMove(
          window.mouseX, window.mouseY,
          window.mouseXPrevious, window.mouseYPrevious
        )

  of WM_TIMER:
    ifWindow:
      if window.onUpdate != nil:
        window.onUpdate()

  of WM_SIZE:
    ifWindow:
      window.updateBounds()
      window.mainBitmap.resize(window.width, window.height)
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
      blitMainBitmap(window)
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
      let buttonKind = getMouseButtonKind()
      if buttonKind.isSome:
        window.captureMouse()
        window.mouseButtonStates[buttonKind.get] = true
        if window.onMousePress != nil:
          window.onMousePress(buttonKind.get)

  of WM_LBUTTONUP, WM_MBUTTONUP, WM_RBUTTONUP, WM_XBUTTONUP:
    ifWindow:
      let buttonKind = getMouseButtonKind()
      if buttonKind.isSome:
        window.releaseMouse()
        window.mouseButtonStates[buttonKind.get] = false
        if window.onMouseRelease != nil:
          window.onMouseRelease(buttonKind.get)

  of WM_KEYDOWN, WM_SYSKEYDOWN:
    ifWindow:
      let key = wParam.int.toKeyboardKey
      if key.isSome:
        window.keyStates[key.get] = true
        if window.onKeyPress != nil:
          window.onKeyPress(key.get)

  of WM_KEYUP, WM_SYSKEYUP:
    ifWindow:
      let key = wParam.int.toKeyboardKey
      if key.isSome:
        window.keyStates[key.get] = false
        if window.onKeyRelease != nil:
          window.onKeyRelease(key.get)

  else:
    discard

proc newWindow*(hInstance: HINSTANCE, parent: HWND): Window =
  result = Window(hWnd: CreateDialog(hInstance, MAKEINTRESOURCE(100), parent, windowProc))

  if result.hWnd != nil:
    result.title = "Unnamed Window"
    result.updateBounds()
    result.backgroundColor = rgb(16, 16, 16, 1.0)
    result.mainBitmap = newBitmap(0, 0)
    hWndWindows[result.hWnd] = result
    discard ShowWindow(result.hWnd, SW_SHOW)