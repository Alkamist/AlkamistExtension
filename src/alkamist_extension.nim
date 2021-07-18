import alkamist_extension/reaper

# proc testActionFn() =
#   var window = newWindow()
#   window.backgroundColor = initColor(16, 16, 16)
#   window.draw = proc(self: Window) =
#     self.rect(20, 20, 50, 50)

createExtension:
  # addAction("Alkamist: Test Action", "ALKAMIST_TEST_ACTION", testActionFn)

  var window = newWindow()

  window.title = "Test Window"
  window.setBounds(400, 300, 800, 500)

  window.draw = proc(self: var Window) =
    self.backgroundColor = initColor(16, 16, 16)
    self.fillBackground()
    self.penColor = initColor(200, 200, 200)
    self.brushColor = initColor(60, 60, 60)
    self.updatePen()
    self.updateBrush()
    self.rect(20, 20, 50, 50)