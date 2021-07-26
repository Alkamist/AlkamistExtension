import reaper, pitchcorrection/editor

proc pitchCorrectionMain*() =
  var window = newWindow()

  window.title = "Pitch Correction"
  window.backgroundColor = rgb(16, 16, 16)
  window.setBounds(4.Inches, 2.Inches, 12.Inches, 8.Inches)

  var editor = newPitchEditor(0, 0, window.width, window.height)

  # window.onMousePress = proc() =
  #   editor.onMousePress()

  # window.onMouseRelease = proc() =
  #   editor.onMouseRelease()

  # window.onMouseMove = proc() =
  #   editor.onMouseMove()

  # window.onResize = proc() =
  #   editor.onResize()

  window.onDraw = proc() =
    editor.updateImage()
    window.image.drawImage(
      editor.image, editor.x, editor.y
    )

  window.onKeyPress = proc() =
    case window.input.lastKeyPress:
    of Space: Main_OnCommandEx(40044, 0, nil)
    else: discard