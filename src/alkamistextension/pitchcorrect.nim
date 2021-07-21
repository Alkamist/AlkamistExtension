import reaper, pitchcorrect/keyeditor

proc pitchCorrectionMain*() =
  var window = newWindow()

  window.title = "Pitch Correction"
  window.setBounds(400, 300, 800, 500)

  var keyEditor = initKeyEditor()

  window.onMouseMove = proc(x, y, xPrevious, yPrevious: int) =
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

  # window.onUpdate = proc() =
  #   if key(Space).justPressed:
  #     Main_OnCommandEx(40044, 0, nil)

    # if mb(Middle).isPressed and mouse.justMoved:
    #   x += mouse.xChange.float
    #   y += mouse.yChange.float
      # keyEditor.xView.changePan(mouse.xChange.float)
      # keyEditor.yView.changePan(mouse.yChange.float)

    # if x > window.width.float:
    #   xVelocity = -100.0
    # if x < 0.0:
    #   xVelocity = 100.0
    # x += xVelocity

    # window.redraw()