import std/math, ../units

type ViewT = SomeNumber | SomeDistance

type
  ViewAxis*[T: ViewT] = object
    pan*: float
    zoom*: float
    sensitivity*: float
    scale*: T
    target*: T

  View*[T: ViewT] = object
    x*, y*: ViewAxis[T]

proc initViewAxis*[T: ViewT](): ViewAxis[T] =
  result.pan = 0.0
  result.zoom = 1.0
  result.sensitivity = 0.01
  result.scale = 1.T
  result.target = 0.T

proc initView*[T: ViewT](): View[T] =
  result.x = initViewAxis[T]()
  result.y = initViewAxis[T]()

proc changePan*[T: ViewT](axis: var ViewAxis, value: T) =
  let change = value / axis.scale
  axis.pan += change / axis.zoom

proc changeZoom*[T: ViewT](axis: var ViewAxis, value: T) =
  let
    target = axis.target / axis.scale
    change = pow(2.0, axis.sensitivity * value)
  axis.zoom *= change
  axis.pan -= (change - 1.0) * target.float / axis.zoom

# proc transform*(axis: ViewAxis, value: float): float =
#   axis.scale.float * axis.zoom * (value + axis.pan)