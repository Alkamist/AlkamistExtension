import std/math

type
  ViewAxis* = object
    scale*: float
    zoom*: float
    pan*: float
    target*: float
    sensitivity*: float

proc initViewAxis*(): ViewAxis =
  result.scale = 1.0
  result.zoom = 1.0
  result.pan = 0.0
  result.target = 0.0
  result.sensitivity = 0.01

proc changePan*(axis: var ViewAxis, value: float) =
  let change = value / axis.scale
  axis.pan += change / axis.zoom

proc changeZoom*(axis: var ViewAxis, value: float) =
  let
    target = axis.target / axis.scale
    change = pow(2.0, axis.sensitivity * value)
  axis.zoom *= change
  axis.pan -= (change - 1.0) * target / axis.zoom

proc transform*(axis: ViewAxis, value: float): float =
  axis.scale * axis.zoom * (value + axis.pan)