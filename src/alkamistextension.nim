# addAction("Alkamist: Test Action", "ALKAMIST_TEST_ACTION", testActionFn)


# import alkamistextension/[reaper, pitchcorrection]

# createExtension:
#   pitchCorrectionMain()



import alkamistextension/[reaper, peakviewer]

createExtension:
  addAction("Alkamist: Test Action", "ALKAMIST_TEST_ACTION", peakViewerMain)