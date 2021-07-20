import
  reaper, input,
  pitch_correction/key_editor

proc pitchCorrectionMain*() =
  var window = newWindow()

  window.title = "Pitch Correction"
  window.setBounds(400, 300, 800, 500)

  var keyEditor = initKeyEditor()

  window.draw = proc() =
    window.backgroundColor = initColor(16, 16, 16)
    window.fillBackground()
    keyEditor.draw(window)

  window.onResize = proc() =
    keyEditor.width = window.width.float
    keyEditor.height = window.height.float
    window.draw()

  window.update = proc() =
    for kind in MouseButtonKind:
      if window.mouse.justMoved:
        ShowConsoleMsg($window.mouse.x & " " & $window.mouse.y & "\n")

      if window.mouse[kind].justPressed:
        ShowConsoleMsg($kind & "\n")
