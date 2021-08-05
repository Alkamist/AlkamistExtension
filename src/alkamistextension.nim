# addAction("Alkamist: Test Action", "ALKAMIST_TEST_ACTION", testActionFn)


# import alkamistextension/[reaper, pitchcorrection]

# createExtension:
#   pitchCorrectionMain()



# import alkamistextension/[reaper, peakviewer]

# createExtension:
#   addAction("Alkamist: Test Action", "ALKAMIST_TEST_ACTION", peakViewerMain)




import alkamistextension/[reaper, winapi]

proc windowProc(hWnd: HWND, msg: UINT, wParam: WPARAM, lParam: LPARAM): INT_PTR {.stdcall.} =
  case msg:
  of WM_INITDIALOG: return 0
  of WM_COMMAND: return 0
  else: return 0

createExtension:
  let hWnd = CreateDialog(hInstance, MAKEINTRESOURCE(100), pluginInfo.hwnd_main, windowProc)
  discard ShowWindow(hWnd, SW_SHOW)