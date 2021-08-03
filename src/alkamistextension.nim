# addAction("Alkamist: Test Action", "ALKAMIST_TEST_ACTION", testActionFn)


import alkamistextension/[reaper, pitchcorrection]

createExtension:
  pitchCorrectionMain()





# import alkamistextension/reaper

# createExtension:
#   var window = newWindow()

#   window.title = "Pitch Correction"
  # window.bounds = ((4.0, 2.0), (12.0, 8.0))

  # window.onDraw = proc() =
  #   window.image.fillCircle(
  #     (4.0, 4.0),
  #     1.0,
  #     rgb(255, 255, 255),
  #   )



# import alkamistextension/[reaper, peakviewer]

# createExtension:
#   addAction("Alkamist: Test Action", "ALKAMIST_TEST_ACTION", peakViewerMain)