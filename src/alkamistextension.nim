# import alkamistextension/[reaper, pitchcorrect]

# createExtension:
  # addAction("Alkamist: Test Action", "ALKAMIST_TEST_ACTION", testActionFn)
  # pitchCorrectionMain()

import alkamistextension/reaper

createExtension:
  var window = newWindow()

  window.title = "Pitch Correction"
  window.setBounds(400, 300, 800, 500)

  # window.onResize = proc() =
  #   window.redraw()