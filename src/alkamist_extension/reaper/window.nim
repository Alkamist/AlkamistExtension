import
  std/tables,
  winapi

type
  Window* = ref object
    draw*: proc()
    hInstance*: HINSTANCE
    hWnd*: HWND
    parent*: HWND

var hWndWindowTable = initTable[HWND, Window]()

proc windowProc(hWnd: HWND, msg: UINT, wParam: WPARAM, lParam: LPARAM): INT_PTR {.stdcall.} =
  case msg:
  of WM_PAINT:
    if hWndWindowTable.contains(hWnd):
      hWndWindowTable[hWnd].draw()
  else:
    discard

proc newWindow*(hInstance: HINSTANCE, parent: HWND): Window =
  result = Window(hWnd: CreateDialog(hInstance, MAKEINTRESOURCE(100), parent, windowProc))
  if result.hWnd != nil:
    hWndWindowTable[result.hWnd] = result
    discard ShowWindow(result.hWnd, SW_SHOW)







# proc windowProc(hWnd: HWND, msg: UINT, wParam: WPARAM, lParam: LPARAM): LRESULT {.stdcall.} =
#   case msg:

#   of WM_PAINT:
#     var
#       ps = PAINTSTRUCT()
#       ctx = hWnd.BeginPaint(addr ps)
#       pen = CreatePen(PS_SOLID, 5, RGB(16, 16, 16))
#     discard ctx.SelectObject(pen)
#     discard ctx.Rectangle(50, 50, 200, 200)
#     discard hWnd.EndPaint(addr ps)

#   of WM_MOUSEMOVE:
#     case LOWORD(wParam):
#     of MK_LBUTTON:
#       # ShowConsoleMsg($GET_X_LPARAM(lParam))
#       discard
#     else:
#       discard

#   else:
#     discard