import reaper, pitchcorrect/editor

proc pitchCorrectionMain*() =
  var window = newWindow()

  window.title = "Pitch Correction"
  window.backgroundColor = rgb(16, 16, 16)
  window.setBounds(300, 200, 1200, 800)

  var editor = newPitchEditor(0, 0, window.width, window.height)

  window.onMousePress = proc() =
    editor.onMousePress()

  window.onMouseRelease = proc() =
    editor.onMouseRelease()

  window.onMouseMove = proc() =
    editor.onMouseMove()

  window.onResize = proc() =
    editor.onResize()

  window.onDraw = proc() =
    editor.updateBitmap(window)
    window.bitmap.drawBitmap(
      editor.bitmap, editor.x, editor.y
    )

  window.onKeyPress = proc(key: KeyboardKey) =
    case key:
    of Space: Main_OnCommandEx(40044, 0, nil)
    else: discard