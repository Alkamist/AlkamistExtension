import
  alkamist_extension/reaper

proc windowProc(hWnd: HWND, msg: UINT, wParam: WPARAM, lParam: LPARAM): LRESULT {.stdcall.} =
  case msg:
  of WM_MOUSEMOVE:
    case LOWORD(wParam):
    of MK_LBUTTON:
      ShowConsoleMsg($GET_X_LPARAM(lParam))
    else:
      discard
  else:
    discard

proc testActionFn() =
  let testWindow = CreateDialog(hInstance, MAKEINTRESOURCE(100), pluginInfo.hwnd_main, cast[DLGPROC](windowProc))
  if testWindow != nil:
    discard ShowWindow(testWindow, SW_SHOW)

createExtension:
  addAction("Alkamist: Test Action", "ALKAMIST_TEST_ACTION", testActionFn)
  ShowConsoleMsg("Alkamist Extension initialized.\n")