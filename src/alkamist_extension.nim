import alkamist_extension/reaper

# proc testActionFn() =

createExtension:
  # addAction("Alkamist: Test Action", "ALKAMIST_TEST_ACTION", testActionFn)

  var window = newWindow(hInstance, pluginInfo.hwnd_main)
  window.draw = proc() =
    var
      ps = PAINTSTRUCT()
      ctx = window.hWnd.BeginPaint(addr ps)
      pen = CreatePen(PS_SOLID, 5, RGB(16, 16, 16))
    discard ctx.SelectObject(pen)
    discard ctx.Rectangle(50, 50, 200, 200)
    discard window.hWnd.EndPaint(addr ps)

  ShowConsoleMsg("Alkamist Extension initialized.\n")