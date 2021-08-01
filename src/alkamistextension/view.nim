import std/math, vector

export vector

type
  ViewAxis* = ref object
    pan*, zoomTarget*: float
    externalSize*: float
    zoom*, zoomSensitivity*: float
    isInverted*: bool

  View* = ref object
    x*, y*: ViewAxis

{.push inline.}

func newViewAxis*(): ViewAxis =
  result = ViewAxis()
  result.pan = 0.0
  result.zoomTarget = 0.0
  result.externalSize = 1.0
  result.zoom = 1.0
  result.zoomSensitivity = 0.5

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

func changePanInternally*(axis: var ViewAxis, value: float) =
  axis.pan += value

func changePanExternally*(axis: var ViewAxis, value: float) =
  if axis.isInverted:
    axis.changePanInternally(axis.scaleToInternal(-value))
  else:
    axis.changePanInternally(axis.scaleToInternal(value))

func changeZoom*(axis: var ViewAxis, value: float) =
  let
    previousSize = axis.scaleToInternal(axis.externalSize)
    zoomMultiplier = 2.0.pow(axis.zoomSensitivity * value)

  axis.zoom *= zoomMultiplier

  let
    currentSize = axis.scaleToInternal(axis.externalSize)
    zoomRatio = (axis.zoomTarget - axis.pan) / currentSize
    sizeChange = currentSize - previousSize

  axis.pan -= sizeChange * zoomRatio

func newView*(): View =
  result = View()
  result.x = newViewAxis()
  result.y = newViewAxis()

func scaleToInternal*(view: View, value: (float, float)): (float, float) =
  (view.x.scaleToInternal(value.x),
   view.y.scaleToInternal(value.y))

func scaleToExternal*(view: View, value: (float, float)): (float, float) =
  (view.x.scaleToExternal(value.x),
   view.y.scaleToExternal(value.y))

func convertToInternal*(view: View, value: (float, float)): (float, float) =
  (view.x.convertToInternal(value.x),
   view.y.convertToInternal(value.y))

func convertToExternal*(view: View, value: (float, float)): (float, float) =
  (view.x.convertToExternal(value.x),
   view.y.convertToExternal(value.y))

func changePanInternally*(view: View, value: (float, float)) =
  view.x.changePanInternally(value.x)
  view.y.changePanInternally(value.y)

func changePanExternally*(view: View, value: (float, float)) =
  view.x.changePanExternally(value.x)
  view.y.changePanExternally(value.y)

func changeZoom*(view: View, value: (float, float)) =
  view.x.changeZoom(value.x)
  view.y.changeZoom(value.y)

func setZoomTargetExternally*(view: var View, value: (float, float)) =
  view.x.zoomTarget = view.x.convertToInternal(value.x)
  view.y.zoomTarget = view.y.convertToInternal(value.y)

{.pop.}