import std/math, ../reaper/units

type
  ViewAxis* = object
    pan*: float
    zoom*: float
    sensitivity*: float
    scale*: Inches
    target*: Inches

  View* = object
    x*, y*: ViewAxis

proc initViewAxis*(): ViewAxis =
  result.pan = 0.0
  result.zoom = 1.0
  result.sensitivity = 0.01
  result.scale = 1.Inches
  result.target = 0.Inches

proc changePan*(axis: var ViewAxis, value: float) =
  let change = value / axis.scale.float
  axis.pan += change / axis.zoom

proc changeZoom*(axis: var ViewAxis, value: float) =
  let
    target = axis.target / axis.scale
    change = pow(2.0, axis.sensitivity * value)
  axis.zoom *= change
  axis.pan -= (change - 1.0) * target.float / axis.zoom

proc transform*(axis: ViewAxis, value: float): float =
  axis.scale.float * axis.zoom * (value + axis.pan)

proc initView*(): View =
  result.x = initViewAxis()
  result.y = initViewAxis()