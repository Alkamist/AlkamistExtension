import reaper, pitchcorrect/editor

proc pitchCorrectionMain*() =
  var window = newWindow()

  window.title = "Pitch Correction"
  window.backgroundColor = rgb(16, 16, 16)
  window.setBounds(400, 300, 800, 500)

  var editor = initPitchEditor(0, 0, window.width, window.height)

  window.onMousePress = proc(button: MouseButton) =
    editor.onMousePress(window, button)

  window.onMouseRelease = proc(button: MouseButton) =
    editor.onMouseRelease(window, button)

  window.onMouseMove = proc(x, y, xPrevious, yPrevious: int) =
    editor.onMouseMove(window,x, y, xPrevious, yPrevious)

  window.onResize = proc() =
    editor.onResize(window)

  window.onDraw = proc() =
    editor.updateBitmap(window)
    window.bitmap.drawBitmap(
      editor.bitmap, editor.x, editor.y
    )

  window.onKeyPress = proc(key: KeyboardKey) =
    case key:
    of Space: Main_OnCommandEx(40044, 0, nil)
    else: discard