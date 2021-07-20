import
  std/[tables, math, options],
  ../input/[keyboard, mouse],
  winapi

type
  Window* = ref object
    mouse*: Mouse
    keyboard*: Keyboard
    onMouseMove*: proc()
    onUpdate*: proc()
    onDraw*: proc()
    onResize*: proc()
    onMove*: proc()
    penColor*: Color
    penThickness*: int
    penStyle*: PenStyle
    brushColor*: Color
    backgroundColor*: Color
    hasUpdateLoop: bool
    ctx: HDC
    paintStruct: PAINTSTRUCT
    hInstance: HINSTANCE
    hWnd: HWND
    parent: HWND
    pen: HPEN
    brush: HBRUSH
    bounds: RECT
    title: string

  Color* = object
    r*, g*, b*: int

  PenStyle* {.pure.} = enum
    Cosmetic,
    EndcapRound,
    JoinRound,
    Solid,
    Dash,
    Dot,
    DashDot,
    DashDotDot,
    Null,
    InsideFrame,
    UserStyle,
    Alternate,
    EndcapSquare,
    EndcapFlat,
    JoinBevel,
    JoinMiter,
    Geometric,

var hWndWindows = initTable[HWND, Window]()

func initColor*(r, g, b: int): Color =
  Color(r: r, g: g, b: b)

func toInt*(ps: PenStyle): int =
  case ps:
  of Cosmetic: PS_COSMETIC
  of EndcapRound: PS_ENDCAP_ROUND
  of JoinRound: PS_JOIN_ROUND
  of Solid: PS_SOLID
  of Dash: PS_DASH
  of Dot: PS_DOT
  of DashDot: PS_DASHDOT
  of DashDotDot: PS_DASHDOTDOT
  of Null: PS_NULL
  of InsideFrame: PS_INSIDEFRAME
  of UserStyle: PS_USERSTYLE
  of Alternate: PS_ALTERNATE
  of EndcapSquare: PS_ENDCAP_SQUARE
  of EndcapFlat: PS_ENDCAP_FLAT
  of JoinBevel: PS_JOIN_BEVEL
  of JoinMiter: PS_JOIN_MITER
  of Geometric: PS_GEOMETRIC

func setBounds*(window: var Window, x, y, width, height: int) =
  discard SetWindowPos(window.hWnd, HWND_TOP, x, y, width, height, SWP_NOZORDER)

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

func updatePen*(window: var Window) =
  discard DeleteObject(window.pen)
  window.pen = CreatePen(
    window.penStyle.toInt,
    window.penThickness,
    RGB(window.penColor.r, window.penColor.g, window.penColor.b)
  )
  discard window.ctx.SelectObject(window.pen)

func updatePenColor*(window: var Window, color: Color) =
  window.penColor = color
  window.updatePen()

func updateBrush*(window: var Window) =
  discard DeleteObject(window.brush)
  window.brush = CreateSolidBrush(
    RGB(window.brushColor.r, window.brushColor.g, window.brushColor.b)
  )
  discard window.ctx.SelectObject(window.brush)

func updateBrushColor*(window: var Window, color: Color) =
  window.brushColor = color
  window.updateBrush()

func updateColor*(window: var Window, color: Color) =
  window.updatePenColor(color)
  window.updateBrushColor(color)

func drawRectangle*(window: Window, x, y, width, height: int) =
  discard window.ctx.Rectangle(x, y, x + width, y + height)

func drawRectangle*(window: Window, x, y, width, height: float) =
  let
    xRound = x.round.int
    yRound = y.round.int
  discard window.ctx.Rectangle(xRound, yRound, xRound + width.round.int, yRound + height.round.int)

func fillBackground*(window: var Window) =
  let
    penColorPrevious = window.penColor
    brushColorPrevious = window.brushColor

  window.updatePenColor window.backgroundColor
  window.updateBrushColor window.backgroundColor

  window.drawRectangle(0, 0, window.width, window.height)

  window.updatePenColor penColorPrevious
  window.updateBrushColor brushColorPrevious

func updateBounds(window: var Window) =
  discard GetWindowRect(window.hWnd, addr window.bounds)

func enableUpdateLoop(window: var Window, loopEvery: UINT) =
  discard SetTimer(window.hWnd, 1, loopEvery, nil)
  window.hasUpdateLoop = true

func disableUpdateLoop(window: var Window) =
  if window.hasUpdateLoop:
    discard KillTimer(window.hWnd, 1)
    window.hasUpdateLoop = false

proc repaint(window: var Window) =
  if window.onDraw == nil: return
  window.paintStruct = PAINTSTRUCT()
  window.ctx = window.hWnd.BeginPaint(addr window.paintStruct)
  discard window.ctx.SelectObject(window.pen)
  window.onDraw()
  discard window.hWnd.EndPaint(addr window.paintStruct)

proc redraw*(window: var Window) =
  discard InvalidateRect(window.hWnd, nil, 1)

proc windowProc(hWnd: HWND, msg: UINT, wParam: WPARAM, lParam: LPARAM): INT_PTR {.stdcall.} =
  template ifWindow(code: untyped): untyped =
    if hWndWindows.contains(hWnd):
      var window {.inject.} = hWndWindows[hWnd]
      code

  template callIfNotNil(fn: untyped): untyped =
    if fn != nil:
      fn()

  template getMouseButtonKind(): untyped =
    case msg:
    of WM_LBUTTONDOWN, WM_LBUTTONUP, WM_LBUTTONDBLCLK: some(Left)
    of WM_MBUTTONDOWN, WM_MBUTTONUP, WM_MBUTTONDBLCLK: some(Middle)
    of WM_RBUTTONDOWN, WM_RBUTTONUP, WM_RBUTTONDBLCLK: some(Right)
    of WM_XBUTTONDOWN, WM_XBUTTONUP, WM_XBUTTONDBLCLK:
      if HIWORD(wParam) == 1: some(Side1)
      else: some(Side2)
    else: none(MouseButtonKind)

  case msg:

  of WM_MOUSEMOVE:
    ifWindow:
      window.mouse.update()
      window.mouse.x = GET_X_LPARAM(lParam)
      window.mouse.y = GET_Y_LPARAM(lParam)
      window.onMouseMove()

  of WM_TIMER:
    ifWindow:
      # var mousePoint = POINT()
      # discard GetCursorPos(addr mousePoint)
      # window.mouse.x = mousePoint.x
      # window.mouse.y = mousePoint.y
      callIfNotNil(window.onUpdate)
      # window.mouse.update()
      window.keyboard.update()

  of WM_SIZE, WM_MOVE:
    ifWindow:
      window.updateBounds()
      case msg:
      of WM_SIZE: callIfNotNil(window.onResize)
      of WM_MOVE: callIfNotNil(window.onMove)
      else: discard

  of WM_PAINT:
    ifWindow:
      window.repaint()

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
        window.mouse[buttonKind.get].isPressed = true

  of WM_LBUTTONUP, WM_MBUTTONUP, WM_RBUTTONUP, WM_XBUTTONUP:
    ifWindow:
      let buttonKind = getMouseButtonKind()
      if buttonKind.isSome:
        window.mouse[buttonKind.get].isPressed = false

  of WM_KEYDOWN, WM_SYSKEYDOWN:
    ifWindow:
      let keyKind = wParam.int.toKeyKind
      if keyKind.isSome:
        window.keyboard[keyKind.get].isPressed = true

  of WM_KEYUP, WM_SYSKEYUP:
    ifWindow:
      let keyKind = wParam.int.toKeyKind
      if keyKind.isSome:
        window.keyboard[keyKind.get].isPressed = false

  else:
    discard

proc newWindow*(hInstance: HINSTANCE, parent: HWND): Window =
  result = Window(hWnd: CreateDialog(hInstance, MAKEINTRESOURCE(100), parent, windowProc))

  if result.hWnd != nil:
    result.title = "Unnamed Window"
    result.updateBounds()
    result.backgroundColor = initColor(0, 0, 0)
    result.penColor = initColor(0, 0, 0)
    result.penThickness = 1
    result.penStyle = Solid
    result.pen = CreatePen(
      result.penStyle.toInt,
      result.penThickness,
      RGB(result.penColor.r, result.penColor.g, result.penColor.b)
    )

    result.brushColor = initColor(0, 0, 0)
    result.brush = CreateSolidBrush(
      RGB(result.brushColor.r, result.brushColor.g, result.brushColor.b)
    )

    hWndWindows[result.hWnd] = result

    discard ShowWindow(result.hWnd, SW_SHOW)
    # result.enableUpdateLoop(6)