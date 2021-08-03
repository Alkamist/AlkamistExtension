import window, view, lice, reaper

proc peakViewerMain*() =
  var
    window = newWindow()
    view = newView()
    peaks: seq[seq[float64]]

  view.y.isInverted = true

  let take = currentProject().selectedItem(0).activeTake
  if take.kind == Audio:
    var source = take.source
    peaks = source.peaks(0.0, 15.0)

  window.title = "Pitch Correction"
  window.bounds = ((4.0, 2.0), (12.0, 8.0))

  view.resize(window.clientDimensions)
  view.x.zoom = window.clientWidth / (44100.0 * 5.0)
  view.y.zoom = window.clientHeight
  view.y.pan = -0.12

  window.onResize = proc() =
    view.resize(window.clientDimensions)
    window.redraw()

  window.onMousePress = proc() =
    view.setZoomTargetExternally(window.input.mousePosition)

  window.onMouseMove = proc() =
    if window.input.isPressed(Middle):
      if window.input.isPressed(Shift):
        view.changeZoom(window.input.mouseDelta)
      else:
        view.changePanExternally(-window.input.mouseDelta)
      window.redraw()

  window.onDraw = proc() =
    for channelBuffer in peaks:
      for sampleId, sample in channelBuffer:
        if sampleId > 0:
          let
            previousId = sampleId - 1
            previousSample = channelBuffer[previousId]

          window.image.drawLine(
            view.convertToExternal((sampleId.toFloat, sample)),
            view.convertToExternal((previousId.toFloat, previousSample)),
            rgb(255, 255, 255),
          )