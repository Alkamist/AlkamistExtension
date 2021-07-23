import reaper, pitchcorrect/keyeditor

proc pitchCorrectionMain*() =
  var window = newWindow()

  window.title = "Pitch Correction"
  window.backgroundColor = rgb(16, 16, 16)
  window.setBounds(400, 300, 800, 500)

  var
    keyEditor = initKeyEditor(600, 300)
    editorX = 0
    editorY = 0

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
    keyEditor.updateBitmap()
    window.bitmap.drawBitmap(keyEditor.bitmap)

  window.onResize = proc() =
    # keyEditor.resize(window.width, window.height)
    window.redraw()

  window.onKeyPress = proc(key: KeyboardKey) =
    case key:
    of Space: Main_OnCommandEx(40044, 0, nil)
    else: discard