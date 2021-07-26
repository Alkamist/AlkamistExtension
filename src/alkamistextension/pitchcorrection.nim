import reaper, pitchcorrection/editor

proc pitchCorrectionMain*() =
  var window = newWindow()

  window.title = "Pitch Correction"
  window.backgroundColor = rgb(16, 16, 16)
  window.setBounds(4.Inches, 2.Inches, 12.Inches, 8.Inches)

  var editor = newPitchEditor(
    position = (x: 0.Inches, y: 0.Inches),
    width = window.width,
    height = window.height,
    dpi = window.dpi,
    timeLength = 10.Seconds,
  )

  template redrawIfNeeded(): untyped =
    if editor.shouldRedraw:
      window.redraw()
      editor.shouldRedraw = false

  window.onMousePress = proc() =
    editor.onMousePress(window.input)
    redrawIfNeeded()

  window.onMouseRelease = proc() =
    editor.onMouseRelease(window.input)
    redrawIfNeeded()

  window.onMouseMove = proc() =
    editor.onMouseMove(window.input)
    redrawIfNeeded()

  window.onResize = proc() =
    editor.onResize(window.width, window.height)
    redrawIfNeeded()

  window.onDraw = proc() =
    editor.updateImage()
    window.image.drawImage(
      editor.image,
      editor.x * window.dpi,
      editor.y * window.dpi,
    )

  window.onKeyPress = proc() =
    case window.input.lastKeyPress:
    of Space: Main_OnCommandEx(40044, 0, nil)
    else: discard