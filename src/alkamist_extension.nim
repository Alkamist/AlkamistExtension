import alkamist_extension/reaper

# proc windowProc(hWnd: HWND, msg: UINT, wParam: WPARAM, lParam: LPARAM): INT_PTR {.stdcall.} =
#   case msg:
#   of WM_MOUSEMOVE:
#     case LOWORD(wParam):
#     of MK_LBUTTON:
#       ShowConsoleMsg($GET_X_LPARAM(lParam))
#     else:
#       discard
#   else:
#     discard

# let testWindow = CreateDialog(hInstance, MAKEINTRESOURCE(100), nil, windowProc)
# if testWindow != nil:
#   discard ShowWindow(testWindow, SW_SHOW)

proc testActionFn() =
  ShowConsoleMsg("Test Action executed.\n")

createReaperExtension:
  addAction("Alkamist: Test Action", "ALKAMIST_TEST_ACTION", testActionFn)
  ShowConsoleMsg("Alkamist Extension initialized.\n")