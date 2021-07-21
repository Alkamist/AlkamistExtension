import reaper, pitchcorrect/keyeditor

proc pitchCorrectionMain*() =
  var window = newWindow()

  window.title = "Pitch Correction"
  window.setBounds(400, 300, 800, 500)

  var keyEditor = initKeyEditor()

  window.onMousePress = proc(button: MouseButton) =
    case button:
    of Middle:
      keyEditor.xView.target = window.mouseX.float
      keyEditor.yView.target = -window.mouseY.float
    else: discard

  window.onMouseMove = proc(x, y, xPrevious, yPrevious: int) =
    let
      xChange = (x - xPrevious).float
      yChange = (y - yPrevious).float

    if window.mouseButtonIsPressed(Middle):
      if window.keyIsPressed(Shift):
        keyEditor.xView.changeZoom(xChange)
        keyEditor.yView.changeZoom(yChange)
      else:
        keyEditor.xView.changePan(xChange)
        keyEditor.yView.changePan(-yChange)

      window.redraw()

  window.onDraw = proc() =
    keyEditor.draw(window)

  window.onResize = proc() =
    keyEditor.width = window.width.float
    keyEditor.height = window.height.float
    window.redraw()

  window.onKeyPress = proc(key: KeyboardKey) =
    case key:
    of Space: Main_OnCommandEx(40044, 0, nil)
    else: discard