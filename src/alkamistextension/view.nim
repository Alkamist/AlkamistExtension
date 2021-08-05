import std/math

type
  ViewAxis* = ref object
    pan*, zoomTarget*: float
    zoom*: float
    zoomSensitivity*: float
    isInverted*: bool
    externalSize, previousExternalSize: float

  View* = ref object
    x*, y*: ViewAxis

func externalSize*(axis: ViewAxis): float = axis.externalSize

func scaleToInternal*(axis: ViewAxis, value: float): float =
  value / axis.zoom

func scaleToExternal*(axis: ViewAxis, value: float): float =
  value * axis.zoom

func convertToInternal*(axis: ViewAxis, value: float): float =
  if axis.isInverted:
    axis.pan - axis.scaleToInternal(value - axis.externalSize)
  else:
    axis.pan + axis.scaleToInternal(value)

func convertToExternal*(axis: ViewAxis, value: float): float =
  if axis.isInverted:
    axis.scaleToExternal(axis.pan - value) + axis.externalSize
  else:
    axis.scaleToExternal(value - axis.pan)

func changePanInternally*(axis: ViewAxis, value: float) =
  axis.pan += value

func changePanExternally*(axis: ViewAxis, value: float) =
  if axis.isInverted:
    axis.changePanInternally(axis.scaleToInternal(-value))
  else:
    axis.changePanInternally(axis.scaleToInternal(value))

template zoomToTarget(axis: ViewAxis, zoomChangeCode: untyped): untyped =
  let previousSize = axis.scaleToInternal(axis.externalSize)

  zoomChangeCode

  let
    currentSize = axis.scaleToInternal(axis.externalSize)
    zoomRatio = (axis.zoomTarget - axis.pan) / previousSize
    sizeChange = currentSize - previousSize

  axis.pan -= sizeChange * zoomRatio

func changeZoom*(axis: ViewAxis, value: float) =
  axis.zoomToTarget:
    axis.zoom *= 2.0.pow(value * axis.zoomSensitivity)

func resize*(axis: ViewAxis, externalSize: float) =
  let delta = externalSize - axis.previousExternalSize
  axis.externalSize = externalSize
  if axis.isInverted:
    axis.changePanExternally(delta)
  axis.previousExternalSize = externalSize

func scaleToInternal*(view: View, value: (float, float)): (float, float) =
  (view.x.scaleToInternal(value[0]),
   view.y.scaleToInternal(value[1]))

func scaleToExternal*(view: View, value: (float, float)): (float, float) =
  (view.x.scaleToExternal(value[0]),
   view.y.scaleToExternal(value[1]))

func convertToInternal*(view: View, value: (float, float)): (float, float) =
  (view.x.convertToInternal(value[0]),
   view.y.convertToInternal(value[1]))

func convertToExternal*(view: View, value: (float, float)): (float, float) =
  (view.x.convertToExternal(value[0]),
   view.y.convertToExternal(value[1]))

func changePanInternally*(view: View, value: (float, float)) =
  view.x.changePanInternally(value[0])
  view.y.changePanInternally(value[1])

func changePanExternally*(view: View, value: (float, float)) =
  view.x.changePanExternally(value[0])
  view.y.changePanExternally(value[1])

func changeZoom*(view: View, value: (float, float)) =
  view.x.changeZoom(value[0])
  view.y.changeZoom(value[1])

func setZoomTargetExternally*(view: View, value: (float, float)) =
  view.x.zoomTarget = view.x.convertToInternal(value[0])
  view.y.zoomTarget = view.y.convertToInternal(value[1])

func resize*(view: View, externalDimensions: (float, float)) =
  view.x.resize(externalDimensions[0])
  view.y.resize(externalDimensions[1])

func newViewAxis*(): ViewAxis =
  result = ViewAxis()
  result.pan = 0.0
  result.zoomTarget = 0.0
  result.externalSize = 1.0
  result.previousExternalSize = 1.0
  result.zoom = 1.0
  result.zoomSensitivity = 0.5

func newView*(): View =
  result = View()
  result.x = newViewAxis()
  result.y = newViewAxis()