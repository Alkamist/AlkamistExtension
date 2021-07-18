import
  std/tables,
  winapi, keyboard, functions

type
  Window* = ref object
    draw*: proc(self: Window)
    ctx: HDC
    curPenColor: Color
    curPenThickness: int
    curPenStyle: PenStyle
    paintStruct: PAINTSTRUCT
    hInstance: HINSTANCE
    hWnd: HWND
    parent: HWND
    pen: HPEN

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

proc windowProc(hWnd: HWND, msg: UINT, wParam: WPARAM, lParam: LPARAM): INT_PTR {.stdcall.} =
  case msg:

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

proc updatePen(window: var Window) =
  discard DeleteObject(window.pen)
  window.pen = CreatePen(
    window.curPenStyle.toInt,
    window.curPenThickness,
    RGB(window.curPenColor.r, window.curPenColor.g, window.curPenColor.b)
  )
  discard window.ctx.SelectObject(window.pen)

proc newWindow*(hInstance: HINSTANCE, parent: HWND): Window =
  result = Window(hWnd: CreateDialog(hInstance, MAKEINTRESOURCE(100), parent, windowProc))
  if result.hWnd != nil:
    result.curPenColor = Color(r: 0, g: 0, b: 0)
    result.curPenThickness = 1
    result.curPenStyle = Solid
    result.pen = CreatePen(
      result.curPenStyle.toInt,
      result.curPenThickness,
      RGB(result.curPenColor.r, result.curPenColor.g, result.curPenColor.b)
    )
    hWndWindows[result.hWnd] = result
    discard ShowWindow(result.hWnd, SW_SHOW)

proc `penColor=`*(window: var Window, value: Color) =
  window.curPenColor = value
  window.updatePen()

proc `penThickness=`*(window: var Window, value: int) =
  window.curPenThickness = value
  window.updatePen()

proc `penStyle=`*(window: var Window, value: PenStyle) =
  window.curPenStyle = value
  window.updatePen()

proc rect*(window: Window; x, y, w, h: int) =
  discard window.ctx.Rectangle(x, y, w, h)