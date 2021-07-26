import std/math, ../units

type
  ViewAxis*[I, E] = object
    pan*, zoomTarget*: I
    externalSize*: E
    zoom*, zoomSensitivity*: float
    isInverted*: bool

{.push inline.}

func initViewAxis*[I, E](): ViewAxis[I, E] =
  result.pan = 0.I
  result.zoomTarget = 0.I
  result.externalSize = 1.E
  result.zoom = 1.0
  result.zoomSensitivity = 0.5

func scale*[I, E](axis: ViewAxis[I, E], value: E): I =
  (value.toFloat * axis.zoom).I

func scale*[I, E](axis: ViewAxis[I, E], value: I): E =
  (value.toFloat / axis.zoom).E

func convert*[I, E](axis: ViewAxis[I, E], value: E): I =
  if axis.isInverted:
    axis.pan - axis.scale(value - axis.externalSize)
  else:
    axis.pan + axis.scale(value)

func convert*[I, E](axis: ViewAxis[I, E], value: I): E =
  if axis.isInverted:
    axis.scale(axis.pan - value) + axis.externalSize
  else:
    axis.scale(axis.pan + value)

func changePan*[I, E](axis: var ViewAxis[I, E], value: I) =
  axis.pan += value

func changePan*[I, E](axis: var ViewAxis[I, E], value: E) =
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

  if axis.isInverted:
    axis.pan -= sizeChange * zoomRatio
  else:
    axis.pan += sizeChange * zoomRatio

{.pop.}