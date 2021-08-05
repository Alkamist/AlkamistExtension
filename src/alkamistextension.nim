# addAction("Alkamist: Test Action", "ALKAMIST_TEST_ACTION", testActionFn)


import alkamistextension/[reaper, pitchcorrection]

createExtension:
  pitchCorrectionMain()



# import alkamistextension/[reaper, peakviewer]

# createExtension:
#   addAction("Alkamist: Test Action", "ALKAMIST_TEST_ACTION", peakViewerMain)



# import alkamistextension/reaper

# proc testFn() =
#   let wnd = newWindow(
#     title = "A Window",
#     bounds = ((2.0, 2.0), (8.0, 6.0)),
#     backgroundColor = rgb(16, 16, 16),
#   )

# createExtension:
#   addAction("Alkamist: Test Action", "ALKAMIST_TEST_ACTION", testFn)