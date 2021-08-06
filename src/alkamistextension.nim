# addAction("Alkamist: Test Action", "ALKAMIST_TEST_ACTION", testActionFn)



import alkamistextension/reaper

proc testFn() =
  preventUiRefresh(true)

  let
    take = currentProject().selectedItem(0).activeTake
    source = take.source
    envelope = take.pitchEnvelope
    pitchPoints = source.analyzePitch(0.0, source.timeLength)
    corrections = @[
      (0.0, 60.0, 1.0, 1.0, true),
      (source.timeLength, 40.0, 1.0, 1.0, false),
    ]

  envelope.correctPitch(pitchPoints, corrections)
  envelope.sort()

  preventUiRefresh(false)
  updateArrange()

createExtension:
  addAction("Alkamist: Test Action", "ALKAMIST_TEST_ACTION", testFn)





# import alkamistextension/[reaper, pitchcorrection]

# createExtension:
#   pitchCorrectionMain()



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