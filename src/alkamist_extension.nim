import alkamist_extension/reaper

proc testActionFn() =
  var window = newWindow()
  window.enableEventLoop(100)

  window.title = "Test Window"
  window.setBounds(400, 300, 800, 500)

  var numDraws = 0
  window.draw = proc(self: var Window) =
    self.backgroundColor = initColor(16, 16, 16)
    self.fillBackground()
    self.updatePenColor initColor(200, 200, 200)
    self.updateBrushColor initColor(60, 60, 60)
    self.rect(20, 20, 50, 50)
    ShowConsoleMsg("Draw: " & $numDraws & "\n")
    inc numDraws

  var lastState = 0
  window.update = proc(self: var Window) =
    let state = GetProjectStateChangeCount(nil)
    if state != lastState:
      window.draw(window)
      lastState = state

createExtension:
  # addAction("Alkamist: Test Action", "ALKAMIST_TEST_ACTION", testActionFn)
  testActionFn()