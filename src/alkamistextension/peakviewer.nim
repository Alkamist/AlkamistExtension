import window, view, lice, reaper

proc peakViewerMain*() =
  var
    window = newWindow(
      title = "Pitch Correction",
      bounds = ((4.0, 2.0), (12.0, 8.0)),
      backgroundColor = rgb(16, 16, 16)
    )
    view = newView()
    peaks: MonoPeaks

  view.y.isInverted = true

  let take = currentProject().selectedItem(0).activeTake
  if take.kind == Audio:
    var source = take.source
    peaks = source.peaks(0.0, 15.0, 1000.0).toMono

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
    let minWidth = 1.0 / window.dpi
    for sampleId, sample in peaks:
      let
        x = view.x.convertToExternal(0.1 + sampleId.toFloat)
        top = view.y.convertToExternal(sample.maximum)
        bottom = view.y.convertToExternal(sample.minimum)
        width = max(minWidth, view.x.scaleToExternal(0.8))
        height = (bottom - top).abs

      window.image.fillRectangle(
        (x, top),
        (width, height),
        rgb(220, 220, 220),
      )