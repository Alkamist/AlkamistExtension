# addAction("Alkamist: Test Action", "ALKAMIST_TEST_ACTION", testActionFn)


import alkamistextension/[reaper, pitchcorrection]

createExtension:
  pitchCorrectionMain()



# import alkamistextension/[reaper, peakviewer]

# createExtension:
#   addAction("Alkamist: Test Action", "ALKAMIST_TEST_ACTION", peakViewerMain)




# import alkamistextension/reaper

# proc testFn() =
#   let
#     take = currentProject().selectedItem(0).activeTake
#     pitchBuffer = take.analyzePitch()

# createExtension:
#   addAction("Alkamist: Test Action", "ALKAMIST_TEST_ACTION", testFn)