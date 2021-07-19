import reaper, pitch_correction/key_editor

proc pitchCorrectionMain*() =
  var window = newWindow()
  # window.enableUpdateLoop(6)

  window.title = "Pitch Correction"
  window.setBounds(400, 300, 800, 500)

  var keyEditor = initKeyEditor()

  window.draw = proc() =
    window.backgroundColor = initColor(16, 16, 16)
    window.fillBackground()
    keyEditor.draw(window)

  window.onKeyDown = proc(key: Key) =
    case key:
    of Space:
      # Make the space bar play the project.
      Main_OnCommandEx(40044, 0, nil)
    else: discard

  # addKeyListener proc(key: Key, isDown: bool) =
  #   ShowConsoleMsg($key)

  # window.onMouseMove = proc(x, y: int) =
  #   ShowConsoleMsg($x & " " & $y & "\n")

  # var lastState = 0
  # window.update = proc() =
  #   let state = GetProjectStateChangeCount(nil)
  #   if state != lastState:
  #     window.draw(window)
  #     lastState = state