import std/math, ../units

type
  ViewAxis*[I, E] = object
    pan*, zoomTarget*: I
    externalSize*: E
    zoom*, zoomSensitivity*: float

{.push inline.}

func initViewAxis*[I, E](): ViewAxis[I, E] =
  result.pan = 0.I
  result.zoomTarget = 0.I
  result.externalSize = 1.E
  result.zoom = 1.0
  result.zoomSensitivity = 0.5

func toInternalScale*[I, E](axis: ViewAxis[I, E], value: E): I =
  (value.toFloat * axis.zoom).I

func toExternalScale*[I, E](axis: ViewAxis[I, E], value: I): E =
  (value.toFloat / axis.zoom).E

func toInternalValue*[I, E](axis: ViewAxis[I, E], value: E): I =
  axis.toInternalScale(value) - axis.pan

func toExternalValue*[I, E](axis: ViewAxis[I, E], value: I): E =
  axis.toExternalScale(value + axis.pan)

func changePan*[I, E](axis: var ViewAxis[I, E], value: I) =
  axis.pan += value

func changePan*[I, E](axis: var ViewAxis[I, E], value: E) =
  axis.changePan(axis.toInternalScale(value))

func changeZoom*[I, E](axis: var ViewAxis[I, E], value: E) =
  let zoomChange = 2.0.pow(axis.zoomSensitivity * value.toFloat)
  axis.zoom *= zoomChange
  axis.pan += (axis.zoomTarget / axis.zoom) * (zoomChange - 1.0)

{.pop.}