import
  reaper, window,
  pitchcorrection/editor

proc pitchCorrectionMain*() =
  var window = newWindow()

  window.title = "Pitch Correction"
  window.backgroundColor = rgb(16, 16, 16)
  window.bounds = ((4.0, 2.0), (12.0, 8.0))

  template editorDimensions: untyped =
    (window.clientWidth - 0.6,
     window.clientHeight - 0.6)

  var editor = newPitchEditor(
    position = (0.3, 0.3),
    dimensions = editorDimensions,
    dpi = window.dpi,
    input = window.input,
  )

  template redrawIfNeeded(): untyped =
    if editor.shouldRedraw:
      window.redraw()
      editor.shouldRedraw = false

  window.onMousePress = proc() =
    editor.onMousePress()
    redrawIfNeeded()

  window.onMouseRelease = proc() =
    editor.onMouseRelease()
    redrawIfNeeded()

  window.onMouseMove = proc() =
    editor.onMouseMove()
    redrawIfNeeded()

  window.onResize = proc() =
    editor.onResize(editorDimensions)
    redrawIfNeeded()

  window.onDraw = proc() =
    editor.updateImage()
    window.image.drawImage(editor.image, editor.position)

  window.onKeyPress = proc() =
    if window.input.lastKeyPress == Space:
      Main_OnCommandEx(40044, 0, nil)
    editor.onKeyPress()
    redrawIfNeeded()