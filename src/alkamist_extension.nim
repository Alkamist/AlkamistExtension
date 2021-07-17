import alkamist_extension/reaper

proc testActionFn() =
  ShowConsoleMsg("Test Action executed.\n")

createExtension:
  addAction("Alkamist: Test Action", "ALKAMIST_TEST_ACTION", testActionFn)
  ShowConsoleMsg("Alkamist Extension initialized.\n")