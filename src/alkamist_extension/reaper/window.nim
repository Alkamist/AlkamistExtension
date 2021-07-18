import
  std/tables,
  winapi, keyboard, functions

type
  Window* = ref object
    draw*: proc(self: var Window)
    penColor*: Color
    penThickness*: int
    penStyle*: PenStyle
    brushColor*: Color
    backgroundColor*: Color
    ctx: HDC
    paintStruct: PAINTSTRUCT
    hInstance: HINSTANCE
    hWnd: HWND
    parent: HWND
    pen: HPEN
    brush: HBRUSH

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

proc initColor*(r, g, b: int): Color =
  Color(r: r, g: g, b: b)

proc toInt*(ps: PenStyle): int =
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

proc updatePen*(window: var Window) =
  discard DeleteObject(window.pen)
  window.pen = CreatePen(
    window.penStyle.toInt,
    window.penThickness,
    RGB(window.penColor.r, window.penColor.g, window.penColor.b)
  )
  discard window.ctx.SelectObject(window.pen)

proc updateBrush*(window: var Window) =
  discard DeleteObject(window.brush)
  window.brush = CreateSolidBrush(
    RGB(window.brushColor.r, window.brushColor.g, window.brushColor.b)
  )
  discard window.ctx.SelectObject(window.brush)

proc rect*(window: Window; x, y, w, h: int) =
  discard window.ctx.Rectangle(x, y, w, h)

proc fillBackground*(window: var Window) =
  let
    penColorPrevious = window.penColor
    brushColorPrevious = window.brushColor

  window.penColor = window.backgroundColor
  window.brushColor = window.backgroundColor
  window.updatePen()
  window.updateBrush()

  var windowRect: RECT
  discard GetWindowRect(window.hWnd, addr windowRect)

  window.rect(0, 0, windowRect.right, windowRect.bottom)

  window.penColor = penColorPrevious
  window.brushColor = brushColorPrevious
  window.updatePen()
  window.updateBrush()

proc windowProc(hWnd: HWND, msg: UINT, wParam: WPARAM, lParam: LPARAM): INT_PTR {.stdcall.} =
  case msg:

  # of WM_ERASEBKGND:
  #   if hWndWindows.contains(hWnd):
  #     var window = hWndWindows[hWnd]
  #     window.paintStruct = PAINTSTRUCT()
  #     window.ctx = window.hWnd.BeginPaint(addr window.paintStruct)
  #     window.fillBackground()
  #     discard window.hWnd.EndPaint(addr window.paintStruct)

  of WM_PAINT:
    if hWndWindows.contains(hWnd):
      var window = hWndWindows[hWnd]
      window.paintStruct = PAINTSTRUCT()
      window.ctx = window.hWnd.BeginPaint(addr window.paintStruct)
      discard window.ctx.SelectObject(window.pen)
      window.draw(window)
      discard window.hWnd.EndPaint(addr window.paintStruct)

  of WM_CLOSE:
    discard DestroyWindow(hWnd)
    hWndWindows.del(hWnd)
    return 0

  of WM_KEYDOWN, WM_SYSKEYDOWN:
    case codeKeys[wParam.int]:
    of Key.Space:
      # Make the space bar play the project.
      Main_OnCommandEx(40044, 0, nil)
    else: discard

  else:
    discard

proc newWindow*(hInstance: HINSTANCE, parent: HWND): Window =
  result = Window(hWnd: CreateDialog(hInstance, MAKEINTRESOURCE(100), parent, windowProc))

  if result.hWnd != nil:
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