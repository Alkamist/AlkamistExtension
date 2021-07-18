import alkamist_extension/reaper

proc testActionFn() =
  var window = newWindow()
  window.draw = proc(self: Window) =
    self.rect(20, 20, 50, 50)

createExtension:
  addAction("Alkamist: Test Action", "ALKAMIST_TEST_ACTION", testActionFn)