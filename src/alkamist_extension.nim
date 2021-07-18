import alkamist_extension/reaper

proc windowProc(hWnd: HWND, msg: UINT, wParam: WPARAM, lParam: LPARAM): LRESULT {.stdcall.} =
  case msg:

  of WM_PAINT:
    var
      ps = PAINTSTRUCT()
      ctx = hWnd.BeginPaint(addr ps)
      pen = CreatePen(PS_SOLID, 5, RGB(16, 16, 16))
    discard ctx.SelectObject(pen)
    discard ctx.Rectangle(50, 50, 200, 200)
    discard hWnd.EndPaint(addr ps)

  of WM_MOUSEMOVE:
    case LOWORD(wParam):
    of MK_LBUTTON:
      # ShowConsoleMsg($GET_X_LPARAM(lParam))
      discard
    else:
      discard

  else:
    discard

# proc testActionFn() =
#   let testWindow = CreateDialog(hInstance, MAKEINTRESOURCE(100), pluginInfo.hwnd_main, cast[DLGPROC](windowProc))
#   if testWindow != nil:
#     discard ShowWindow(testWindow, SW_SHOW)

createExtension:
  # addAction("Alkamist: Test Action", "ALKAMIST_TEST_ACTION", testActionFn)
  # ShowConsoleMsg("Alkamist Extension initialized.\n")
  let testWindow = CreateDialog(hInstance, MAKEINTRESOURCE(100), pluginInfo.hwnd_main, cast[DLGPROC](windowProc))
  if testWindow != nil:
    discard ShowWindow(testWindow, SW_SHOW)