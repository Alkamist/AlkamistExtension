import alkamistextension/reaper

# proc testFn() =
#   preventUiRefresh(true)

#   let
#     take = currentProject().selectedItem(0).activeTake
#     source = take.source

#   var
#     pitchPoints = source.analyzePitch(0.0, source.timeLength)
#     corrections = @[
#       (0.0, 48.0, 1.0, 1.0, true),
#       (source.timeLength, 48.0, 1.0, 1.0, false),
#     ]

#   take.correctPitch(
#     pitchPoints,
#     corrections,
#   )

#   preventUiRefresh(false)
#   updateArrange()

# createExtension:
#   addAction("Alkamist: Test Action", "ALKAMIST_TEST_ACTION", testFn)





import alkamistextension/[reaper, pitchcorrection]

createExtension:
  pitchCorrectionMain()



# import alkamistextension/[reaper, peakviewer]

# createExtension:
#   addAction("Alkamist: Test Action", "ALKAMIST_TEST_ACTION", peakViewerMain)