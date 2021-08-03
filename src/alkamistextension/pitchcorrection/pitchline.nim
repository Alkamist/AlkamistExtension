import
  std/[math, algorithm, sequtils],
  ../lice, ../view, ../input,
  pitchpoint, boxselect

export
  lice, view, input,
  pitchpoint

type
  PitchLine* = ref object
    parentPosition*: (float, float)
    maxEditDistance*: float
    mousePoint*: PitchPoint
    first*, last*: PitchPoint
    activeColor*, inactiveColor*: Color
    editingIsEnabled*: bool
    editingActivationsIsEnabled*: bool
    isEditingPoint: bool
    points: seq[PitchPoint]
    view: View
    input: Input
    boxSelect: BoxSelect
    selection: seq[PitchPoint]
    snapStart: (float, float)

defineInputProcs(PitchLine, parentPosition)

{.push inline.}

func updateVisualPositions*(line: PitchLine) =
  for point in line.points.mitems:
    point.visualPosition = line.view.convertToExternal(point.position)

func timeSort(line: PitchLine) =
  line.points.sort(compareTime)
  line.first = nil
  line.last = nil
  let lastId = line.points.len - 1
  for i, point in line.points:
    if i == 0: line.first = point
    if i == lastId: line.last = point
    if i > 0: point.previous = line.points[i - 1]
    if i < lastId: point.next = line.points[i + 1]

func select*(line: PitchLine, point: PitchPoint, state: bool) =
  if point != nil:
    if state:
      if not point.isSelected:
        point.isSelected = true
        line.selection.add(point)
    else:
      point.isSelected = false

func unselectAll*(line: PitchLine) =
  for point in line.selection:
    point.isSelected = false
  line.selection = @[]

func cleanSelection*(line: PitchLine) =
  line.selection.keepIf(proc(x: PitchPoint): bool = x.isSelected)
  line.selection = line.selection.deduplicate()

func toggleSelectionActivations*(line: PitchLine) =
  for point in line.selection.mitems:
    point.isActive = not point.isActive

func deleteSelection*(line: PitchLine) =
  line.selection = @[]
  line.points.keepIf(proc(x: PitchPoint): bool = not x.isSelected)
  line.timeSort()

func addPoints*(line: PitchLine, points: seq[tuple[time, pitch: float]]) =
  for point in points:
    var pitchPoint = newPitchPoint()
    pitchPoint.time = point.time
    pitchPoint.pitch = point.pitch
    line.points.add(pitchPoint)
  line.timeSort()
  line.updateVisualPositions()

func deactivatePointsSpreadByTime*(line: PitchLine, timeThreshold: float) =
  let lastId = line.points.len - 1

  for pointId, point in line.points.mpairs:
    if point.previous != nil and
       point.time - point.previous.time >= timeThreshold:
      point.previous.isActive = false

    if pointId == lastId:
      point.isActive = false

{.pop.}

template clickSelectLogic(line: PitchLine): untyped =
  let
    editingSelectedPoint = line.mousePoint != nil and line.mousePoint.mouseOver == Point and line.mousePoint.isSelected
    editingSelectedSegment = line.mousePoint != nil and line.mousePoint.mouseOver == Segment and line.mousePoint.isSelected and
                             line.mousePoint.next != nil and line.mousePoint.next.isSelected
    editingSelected = editingSelectedPoint or editingSelectedSegment

  var
    previous: PitchPoint
    lastId = line.points.len - 1

  for i, point in line.points.mpairs:
    case point.mouseOver:

    of Point:
      if line.isPressed(Control) and not line.isPressed(Shift):
        line.select(point, not point.isSelected)
      else:
        line.select(point, true)

    of Segment:
      if i < lastId:
        let next = line.points[i + 1]

        if line.isPressed(Control) and not line.isPressed(Shift):
          line.select(point, not point.isSelected)
          if not line.isPressed(Alt):
            line.select(next, not next.isSelected)
        else:
          line.select(point, true)
          if not line.isPressed(Alt):
            line.select(next, true)

    of PitchPointMouseOver.None:
      let
        neitherShiftNorControl = not (line.isPressed(Shift) or line.isPressed(Control))
        previousIsNotSegment = previous == nil or previous != nil and previous.mouseOver != Segment

      if neitherShiftNorControl and previousIsNotSegment and not editingSelected:
        line.select(point, false)

    previous = point

  line.cleanSelection()

template doubleClickLogic(line: PitchLine): untyped =
  if line.mousePoint != nil:
    let pitchChange = line.mousePoint.pitch.round - line.mousePoint.pitch
    for point in line.selection.mitems:
      point.pitch += pitchChange

template mouseCreationLogic(line: PitchLine): untyped =
  let mouseInternal = line.view.convertToInternal(line.mousePosition)

  line.unselectAll()

  var point = newPitchPoint()

  if line.isPressed(Shift):
    point.position = mouseInternal
  else:
    point.position = (mouseInternal.time, mouseInternal.pitch.round)

  line.points.add(point)
  line.timeSort()

  if line.editingActivationsIsEnabled and
     line.isPressed(Alt) and
     point.previous != nil:
    point.previous.isActive = false

  line.select(point, true)

template boxSelectLogic(line: PitchLine): untyped =
  for point in line.points.mitems:
    if point.visualPosition.isInside(line.boxSelect):
      if line.isPressed(Control) and not line.isPressed(Shift):
        line.select(point, not point.isSelected)
      else:
        line.select(point, true)
    else:
      if not (line.isPressed(Shift) or line.isPressed(Control)):
        line.select(point, false)

  line.cleanSelection()

template editMovementLogic(line: PitchLine): untyped =
  let
    internalMouse = line.view.convertToInternal(line.mousePosition)
    editStart = line.snapStart
    editDelta = internalMouse - editStart

  for point in line.selection.mitems:
    if point.isSelected:
      if line.isPressed(Shift):
        point.time = point.editOffset.time + editStart.time + editDelta.time
        point.pitch = point.editOffset.pitch + editStart.pitch + editDelta.pitch
        line.snapStart = internalMouse
      else:
        point.time = point.editOffset.time + editStart.time + editDelta.time
        point.pitch = point.editOffset.pitch + editStart.pitch + editDelta.pitch.round

  line.timeSort()

template updateMouseOvers(line: PitchLine): untyped =
  let lastId = line.points.len - 1
  var
    closestPoint: PitchPoint
    closestSegment: (PitchPoint, PitchPoint)
    closestPointDistance: float
    closestSegmentDistance: float

  line.mousePoint = nil

  for i, point in line.points:
    point.mouseOver = PitchPointMouseOver.None

    if point.isActive and i < lastId:
      let
        next = line.points[i + 1]
        distanceToSegment = line.mousePosition.distance((point.visualPosition,
                                                         next.visualPosition))

      if closestSegment[0] == nil:
        closestSegment = (point, next)
        closestSegmentDistance = distanceToSegment
      elif distanceToSegment < closestSegmentDistance:
        closestSegment = (point, next)
        closestSegmentDistance = distanceToSegment

    let distanceToPoint = line.mousePosition.distance(point.visualPosition)

    if closestPoint == nil:
      closestPoint = point
      closestPointDistance = distanceToPoint
    elif distanceToPoint < closestPointDistance:
      closestPoint = point
      closestPointDistance = distanceToPoint

  let
    isPoint = closestPointDistance <= line.maxEditDistance
    isSegment = closestSegmentDistance <= line.maxEditDistance and not isPoint

  if isPoint:
    if closestPoint != nil:
      closestPoint.mouseOver = Point
      line.mousePoint = closestPoint

  elif isSegment:
    if closestSegment[0] != nil:
      closestSegment[0].mouseOver = Segment
      line.mousePoint = closestSegment[0]

func onLeftPress*(line: PitchLine) =
  if line.editingIsEnabled:
    line.clickSelectLogic()

    if line.mousePoint != nil:
      if line.editingActivationsIsEnabled and line.isPressed(Alt):
        line.toggleSelectionActivations()
      elif line.lastMousePressWasDoubleClick:
        line.doubleClickLogic()

    else:
      line.mouseCreationLogic()

    let internalMouse = line.view.convertToInternal(line.mousePosition)

    line.snapStart = internalMouse
    for point in line.points.mitems:
      point.editOffset = point.position - internalMouse

    line.isEditingPoint = true
    line.updateVisualPositions()

func onLeftRelease*(line: PitchLine) =
  if line.editingIsEnabled:
    if not line.isEditingPoint:
      line.unselectAll()
  line.isEditingPoint = false

func onRightRelease*(line: PitchLine) =
  if line.editingIsEnabled:
    line.boxSelectLogic()

func onMouseMove*(line: PitchLine) =
  if line.editingIsEnabled:
    if line.isEditingPoint:
      line.editMovementLogic()
    else:
      line.updateMouseOvers()

  line.updateVisualPositions()

template drawPitchLine(drawPoint: untyped): untyped =
  let
    lastId = line.points.len - 1
    activeColorDark {.inject.} = (line.activeColor * 0.2).redistribute
    inactiveColorDark {.inject.} = (line.inactiveColor * 0.2).redistribute
    highlight {.inject.} = rgb(255, 255, 255, 0.5)

  for i, point {.inject.} in line.points:
    if point.isActive and i < lastId:
      let next = line.points[i + 1]

      image.drawLine(
        point.visualPosition,
        next.visualPosition,
        line.activeColor,
      )

      if point.mouseOver == Segment:
        image.drawLine(
          point.visualPosition,
          next.visualPosition,
          highlight,
        )

    drawPoint

func drawWithCirclePoints*(line: PitchLine, image: Image) =
  let r = (3.0 / 96.0).float

  drawPitchLine:
    if point.isSelected:
      if point.isActive:
        image.fillCircle(point.visualPosition, r, line.activeColor)
      else:
        image.fillCircle(point.visualPosition, r, line.inactiveColor)
    else:
      if point.isActive:
        image.fillCircle(point.visualPosition, r, activeColorDark)
        image.drawCircle(point.visualPosition, r, line.activeColor)
      else:
        image.fillCircle(point.visualPosition, r, inactiveColorDark)
        image.drawCircle(point.visualPosition, r, line.inactiveColor)

    if point.mouseOver == Point:
      image.fillCircle(point.visualPosition, r, highlight)

func drawWithSquarePoints*(line: PitchLine, image: Image) =
  let
    r = (3.0 / 96.0).float
    dimensions = (r, r)
    dimensionsHalf = (r * 0.5, r * 0.5)

  drawPitchLine:
    let position = point.visualPosition - dimensionsHalf

    if point.isSelected:
      if point.isActive:
        image.fillRectangle(position, dimensions, line.activeColor)
        image.drawRectangle(position, dimensions, line.activeColor)
      else:
        image.fillRectangle(position, dimensions, line.inactiveColor)
        image.drawRectangle(position, dimensions, line.inactiveColor)
    else:
      if point.isActive:
        image.fillRectangle(position, dimensions, activeColorDark)
        image.drawRectangle(position, dimensions, line.activeColor)
      else:
        image.fillRectangle(position, dimensions, inactiveColorDark)
        image.drawRectangle(position, dimensions, line.inactiveColor)

    if point.mouseOver == Point:
      image.fillRectangle(position, dimensions, highlight)
      image.drawRectangle(position, dimensions, highlight)

func newPitchLine*(parentPosition: (float, float),
                   view: View,
                   input: Input,
                   boxSelect: BoxSelect): PitchLine =
  result = PitchLine()
  result.parentPosition = parentPosition
  result.view = view
  result.input = input
  result.boxSelect = boxSelect
  result.maxEditDistance = 5.0 / 96.0
  result.activeColor = rgb(51, 214, 255)
  result.inactiveColor = rgb(255, 46, 112)