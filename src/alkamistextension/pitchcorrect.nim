import
  reaper, input,
  pitchcorrect/keyeditor

# template key(kind: KeyKind): untyped =
#   window.keyboard[kind]

# template mouse(): untyped =
#   window.mouse

# template mb(kind: MouseButtonKind): untyped =
#   window.mouse[kind]

proc pitchCorrectionMain*() =
  var window = newWindow()

  window.title = "Pitch Correction"
  window.setBounds(400, 300, 800, 500)

  var x, y = 0.0

  window.onMouseMove = proc() =
    x += window.mouse.xChange.float
    y += window.mouse.yChange.float
    window.redraw()

  # var keyEditor = initKeyEditor()

  window.onDraw = proc() =
    window.updateColor initColor(200, 200, 200)
    window.drawRectangle(x, y, 50.0, 50.0)
    # keyEditor.draw(window)

  #window.onResize = proc() =
    # keyEditor.width = window.width.float
    # keyEditor.height = window.height.float
    # window.redraw()

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