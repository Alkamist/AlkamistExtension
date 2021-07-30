import std/math, units

type
  ViewAxis*[I, E] = ref object
    pan*, zoomTarget*: I
    externalSize*: E
    zoom*, zoomSensitivity*: float
    isInverted*: bool

  View*[Ix, Iy, E] = ref object
    x*: ViewAxis[Ix, E]
    y*: ViewAxis[Iy, E]

{.push inline.}

func newViewAxis*[I, E](): ViewAxis[I, E] =
  result = ViewAxis[I, E]()
  result.pan = 0.I
  result.zoomTarget = 0.I
  result.externalSize = 1.E
  result.zoom = 1.0
  result.zoomSensitivity = 0.5

func scale*[I, E](axis: ViewAxis[I, E], value: E): I =
  (value.toFloat / axis.zoom).I

func scale*[I, E](axis: ViewAxis[I, E], value: I): E =
  (value.toFloat * axis.zoom).E

func convert*[I, E](axis: ViewAxis[I, E], value: E): I =
  if axis.isInverted:
    axis.pan - axis.scale(value - axis.externalSize)
  else:
    axis.pan + axis.scale(value)

func convert*[I, E](axis: ViewAxis[I, E], value: I): E =
  if axis.isInverted:
    axis.scale(axis.pan - value) + axis.externalSize
  else:
    axis.scale(value - axis.pan)

func changePan*[I, E](axis: var ViewAxis[I, E], value: I) =
  axis.pan += value

func changePan*[I, E](axis: var ViewAxis[I, E], value: E) =
  if axis.isInverted:
    axis.changePan(axis.scale(-value))
  else:
    axis.changePan(axis.scale(value))

func changeZoom*[I, E](axis: var ViewAxis[I, E], value: E) =
  let
    previousSize = axis.scale(axis.externalSize)
    zoomMultiplier = 2.0.pow(axis.zoomSensitivity * value.toFloat)

  axis.zoom *= zoomMultiplier

  let
    currentSize = axis.scale(axis.externalSize)
    zoomRatio = (axis.zoomTarget - axis.pan) / currentSize
    sizeChange = currentSize - previousSize

  axis.pan -= sizeChange * zoomRatio

func newView*[Ix, Iy, E](): View[Ix, Iy, E] =
  result = View[Ix, Iy, E]()
  result.x = newViewAxis[Ix, E]()
  result.y = newViewAxis[Iy, E]()

func scale*[Ix, Iy, E](view: View[Ix, Iy, E], value: (E, E)): (Ix, Iy) =
  (view.x.scale(value.x),
   view.y.scale(value.y))

func scale*[Ix, Iy, E](view: View[Ix, Iy, E], value: (Ix, Iy)): (E, E) =
  (view.x.scale(value.x),
   view.y.scale(value.y))

func convert*[Ix, Iy, E](view: View[Ix, Iy, E], value: (E, E)): (Ix, Iy) =
  (view.x.convert(value.x),
   view.y.convert(value.y))

func convert*[Ix, Iy, E](view: View[Ix, Iy, E], value: (Ix, Iy)): (E, E) =
  (view.x.convert(value.x),
   view.y.convert(value.y))

func changePan*[Ix, Iy, E](view: View[Ix, Iy, E], value: (E, E)) =
  view.x.changePan(value.x)
  view.y.changePan(value.y)

func changePan*[Ix, Iy, E](view: View[Ix, Iy, E], value: (Ix, Iy)) =
  view.x.changePan(value.x)
  view.y.changePan(value.y)

func changeZoom*[Ix, Iy, E](view: View[Ix, Iy, E], value: (E, E)) =
  view.x.changeZoom(value.x)
  view.y.changeZoom(value.y)

func `zoomTarget=`*[Ix, Iy, E](view: var View[Ix, Iy, E], value: (E, E)) =
  view.x.zoomTarget = view.x.convert(value.x)
  view.y.zoomTarget = view.y.convert(value.y)

{.pop.}