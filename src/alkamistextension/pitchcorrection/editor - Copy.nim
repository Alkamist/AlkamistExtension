import
  std/[math, algorithm, random],
  ../lice, ../units, ../input, ../view, ../geometry,
  whitekeys

type
  PitchPoint = (Seconds, Semitones)

  PitchEditState = enum
    None,
    Point,
    Segment,

  PitchEdit = object
    state*: PitchEditState
    point*: ref PitchPoint
    segment*: (ref PitchPoint, ref PitchPoint)
    pointDistance*: Inches
    segmentDistance*: Inches
    pointIndex*: int
    segmentIndex*: int
    pointPolyLineIndex*: int
    segmentPolyLineIndex*: int
    pointSnapStart*: PitchPoint
    segmentSnapStart*: PitchPoint
    segmentOffset*: (PitchPoint, PitchPoint)

  PitchEditorColorScheme* = object
    background*: Color
    blackKeys*: Color
    whiteKeys*: Color
    centerLine*: Color

  PitchEditor* = object
    position*: (Inches, Inches)
    image*: Image
    dpi*: Dpi
    timeLength*: Seconds
    colorScheme*: PitchEditorColorScheme
    correctionEditDistance*: Inches
    correctionPointVisualRadius*: Inches
    shouldRedraw*: bool
    viewX: ViewAxis[Seconds, Inches]
    viewY: ViewAxis[Semitones, Inches]
    isEditingCorrection: bool
    correctionEdit: PitchEdit
    mouseMiddleWasPressedInside: bool
    corrections: seq[seq[ref PitchPoint]]
    visualCorrections: seq[seq[(Inches, Inches)]]

{.push inline.}

func `time`*(a: PitchPoint): Seconds = a[0]
func `time=`*(a: var PitchPoint, value: Seconds) = a[0] = value
func `time`*(a: ref PitchPoint): Seconds = a[0]
func `time=`*(a: var ref PitchPoint, value: Seconds) = a[0] = value
func `pitch`*(a: PitchPoint): Semitones = a[1]
func `pitch=`*(a: var PitchPoint, value: Semitones) = a[1] = value
func `pitch`*(a: ref PitchPoint): Semitones = a[1]
func `pitch=`*(a: var ref PitchPoint, value: Semitones) = a[1] = value
func `+`*(a, b: PitchPoint): PitchPoint = (a[0] + b[0], a[1] + b[1])
func `+=`*(a: var PitchPoint, b: PitchPoint) = a = a + b
func `-`*(a, b: PitchPoint): PitchPoint = (a[0] - b[0], a[1] - b[1])
func `-=`*(a: var PitchPoint, b: PitchPoint) = a = a - b
func `-`*(a: PitchPoint): PitchPoint = (-a[0], -a[1])

{.pop.}

proc comparePitchPoint*(x, y: ref PitchPoint): int =
  if x.time < y.time: -1
  else: 1

{.push inline.}

func defaultPitchEditorColorScheme*(): PitchEditorColorScheme =
  result.background = rgb(16, 16, 16)
  result.blackKeys = rgb(60, 60, 60, 1.0)
  result.whiteKeys = rgb(110, 110, 110, 1.0)
  result.centerLine = rgb(255, 255, 255, 0.15)

func redraw*(editor: var PitchEditor) =
  editor.shouldRedraw = true

func resize*(editor: var PitchEditor, width, height: Inches) =
  editor.viewX.externalSize = width
  editor.viewY.externalSize = height
  editor.image.resize(width * editor.dpi,height * editor.dpi)

func x*(editor: PitchEditor): Inches = editor.position.x
func y*(editor: PitchEditor): Inches = editor.position.y
func width*(editor: PitchEditor): Inches = editor.viewX.externalSize
func height*(editor: PitchEditor): Inches = editor.viewY.externalSize
func `width=`*(editor: var PitchEditor, value: Inches) = editor.resize(value, editor.height)
func `height=`*(editor: var PitchEditor, value: Inches) = editor.resize(editor.width, value)

func mousePosition*(editor: PitchEditor, input: Input): PitchPoint =
  (editor.viewX.convert input.mousePosition.x,
   editor.viewY.convert input.mousePosition.y)

func zoomOutXToFull*(editor: var PitchEditor) =
  editor.viewX.zoom = editor.width.toFloat / editor.timeLength.toFloat

func zoomOutYToFull*(editor: var PitchEditor) =
  editor.viewY.zoom = editor.height.toFloat / numKeys.toFloat

func positionIsInside*(editor: PitchEditor, position: (Inches, Inches)): bool =
  position.x >= 0.Inches and
  position.x <= editor.width and
  position.y >= 0.Inches and
  position.y <= editor.height

func toVisualPoint*(point: PitchPoint, editor: PitchEditor): (Inches, Inches) =
  (editor.viewX.convert point.time,
   editor.viewY.convert point.pitch)

func resetPitchSnap(editor: var PitchEditor, input: Input) =
  editor.correctionEdit.pointSnapStart = (
    editor.correctionEdit.point.time,
    editor.correctionEdit.point.pitch,
  )

  editor.correctionEdit.segmentSnapStart = (
    editor.correctionEdit.segment[0].time,
    editor.correctionEdit.segment[0].pitch,
  )

  # let
  #   mouse = editor.mousePosition(input)

  #   segmentMinTime = min(editor.correctionEdit.segment[0].time,
  #                        editor.correctionEdit.segment[1].time)
  #   segmentMaxTime = max(editor.correctionEdit.segment[0].time,
  #                        editor.correctionEdit.segment[1].time)
  #   segmentMinPitch = min(editor.correctionEdit.segment[0].pitch,
  #                         editor.correctionEdit.segment[1].pitch)
  #   segmentMaxPitch = max(editor.correctionEdit.segment[0].pitch,
  #                         editor.correctionEdit.segment[1].pitch)
  #   segmentTotalTime = abs(segmentMaxTime - segmentMinTime)
  #   timeRatio = (mouse.time - segmentMinTime) / segmentTotalTime

  #   pitchDelta = segmentMaxPitch - segmentMinPitch

  #   segmentEditTime = segmentTotalTime * timeRatio + segmentMinTime
  #   segmentEditPitch = pitchDelta * timeRatio + segmentMinPitch

  # editor.correctionEdit.segmentSnapStart = (segmentEditTime, segmentEditPitch)

{.pop.}

func updateVisualCorrections(editor: var PitchEditor) =
  editor.visualCorrections = @[]
  for correction in editor.corrections:
    var visualLine: seq[(Inches, Inches)]
    for point in correction:
      visualLine.add point[].toVisualPoint(editor)
    editor.visualCorrections.add visualLine

func updateCorrectionEditSegmentOffset(editor: var PitchEditor, input: Input) =
  let mouse = editor.mousePosition(input)
  editor.correctionEdit.segmentOffset = (
    (mouse.time - editor.correctionEdit.segment[0].time,
     mouse.pitch - editor.correctionEdit.segment[0].pitch),
    (mouse.time - editor.correctionEdit.segment[1].time,
     mouse.pitch - editor.correctionEdit.segment[1].pitch),
  )

proc initPitchEditor*(position: (Inches, Inches),
                      width, height: Inches,
                      dpi: Dpi): PitchEditor =
  result.position = position
  result.timeLength = 10.Seconds
  result.viewX = initViewAxis[Seconds, Inches]()
  result.viewY = initViewAxis[Semitones, Inches]()
  result.viewY.isInverted = true
  result.resize(width, height)
  result.zoomOutXToFull()
  result.zoomOutYToFull()
  result.dpi = dpi
  result.image = initImage(width * dpi, height * dpi)
  result.colorScheme = defaultPitchEditorColorScheme()
  result.correctionPointVisualRadius = (3.0 / 96.0).Inches
  result.correctionEditDistance = (5.0 / 96.0).Inches

  for correctionId in 0 ..< 2:
    var correction: seq[ref PitchPoint]

    for pointId in 0 ..< 3:
      let pointNumber = 5 * correctionId + pointId
      var point = new PitchPoint
      point.time = pointNumber.Seconds
      point.pitch = rand(numKeys).Semitones
      correction.add point

    result.corrections.add correction

  result.updateVisualCorrections()

func calculateCorrectionEdit(editor: var PitchEditor, input: Input) =
  editor.updateVisualCorrections()

  var info = editor.visualCorrections.distanceInfo input.mousePosition

  let
    isPoint = info.closestPointDistance <= editor.correctionEditDistance
    isSegment = info.closestSegmentDistance <= editor.correctionEditDistance and not isPoint

  editor.correctionEdit.state =
    if isPoint: PitchEditState.Point
    elif isSegment: PitchEditState.Segment
    else: PitchEditState.None

  editor.correctionEdit.pointDistance = info.closestPointDistance
  editor.correctionEdit.pointPolyLineIndex = info.closestPointPolyLineIndex
  editor.correctionEdit.pointIndex = info.closestPointIndex
  editor.correctionEdit.point = editor.corrections[info.closestPointPolyLineIndex][info.closestPointIndex]

  editor.correctionEdit.segmentDistance  = info.closestSegmentDistance
  editor.correctionEdit.segmentPolyLineIndex = info.closestSegmentPolyLineIndex
  editor.correctionEdit.segmentIndex = info.closestSegmentIndex
  editor.correctionEdit.segment = (
    editor.corrections[info.closestSegmentPolyLineIndex][info.closestSegmentIndex],
    editor.corrections[info.closestSegmentPolyLineIndex][info.closestSegmentIndex + 1],
  )

func onMousePress*(editor: var PitchEditor, input: Input) =
  case input.lastMousePress:
  of Left:
    if editor.positionIsInside(input.mousePosition):
      editor.calculateCorrectionEdit(input)
      editor.isEditingCorrection = editor.correctionEdit.state != PitchEditState.None
      if editor.isEditingCorrection:
        editor.updateCorrectionEditSegmentOffset(input)
        editor.resetPitchSnap(input)
  of Middle:
    if editor.positionIsInside(input.mousePosition):
      editor.mouseMiddleWasPressedInside = true
      editor.viewX.zoomTarget = editor.viewX.convert input.mousePosition.x
      editor.viewY.zoomTarget = editor.viewY.convert input.mousePosition.y
      # ShowConsoleMsg("Target: " & $editor.viewX.zoomTarget & "\n")
      # ShowConsoleMsg("Pan: " & $editor.viewX.pan & "\n")
  else: discard

func onMouseRelease*(editor: var PitchEditor, input: Input) =
  case input.lastMouseRelease:
  of Left: editor.isEditingCorrection = false
  of Middle: editor.mouseMiddleWasPressedInside = false
  else: discard

func handleViewMovement*(editor: var PitchEditor, input: Input) =
  let
    xChange = input.mouseDelta.x
    yChange = input.mouseDelta.y

  if input.isPressed(Shift):
    editor.viewX.changeZoom xChange
    editor.viewY.changeZoom yChange
  else:
    editor.viewX.changePan -xChange
    editor.viewY.changePan yChange

  editor.updateVisualCorrections()

func handleEditMovement(editor: var PitchEditor, input: Input) =
  let mouse = editor.mousePosition(input)

  template assignPoint(p): untyped =
    if editor.correctionEdit.point != nil:
      editor.correctionEdit.point.time = p.time
      editor.correctionEdit.point.pitch = p.pitch
      editor.corrections[editor.correctionEdit.pointPolyLineIndex].sort comparePitchPoint

  template assignSegment(p1, p2): untyped =
    if editor.correctionEdit.segment[0] != nil and
       editor.correctionEdit.segment[1] != nil:
      editor.correctionEdit.segment[0].time = p1.time
      editor.correctionEdit.segment[0].pitch = p1.pitch
      editor.correctionEdit.segment[1].time = p2.time
      editor.correctionEdit.segment[1].pitch = p2.pitch
      editor.corrections[editor.correctionEdit.pointPolyLineIndex].sort comparePitchPoint

  case editor.correctionEdit.state:
  of Point:
    if input.isPressed(Shift):
      assignPoint(mouse)
      editor.resetPitchSnap(input)
    else:
      let
        pitchStart = editor.correctionEdit.pointSnapStart.pitch
        pitchDelta = mouse.pitch - pitchStart
      assignPoint (mouse.time, pitchStart + pitchDelta.round)
  of Segment:
    if input.isPressed(Shift):
      assignSegment(mouse - editor.correctionEdit.segmentOffset[0],
                    mouse - editor.correctionEdit.segmentOffset[1])
      editor.resetPitchSnap(input)
    else:
      let
        pitchStart = editor.correctionEdit.segmentSnapStart.pitch
        pitchDelta = mouse.pitch - pitchStart
        snappedPosition = (mouse.time, pitchStart + pitchDelta.round)
      assignSegment(snappedPosition - editor.correctionEdit.segmentOffset[0],
                    snappedPosition - editor.correctionEdit.segmentOffset[1])
  of None:
    discard

  editor.updateVisualCorrections()

func onMouseMove*(editor: var PitchEditor, input: Input) =
  if editor.isEditingCorrection:
    editor.handleEditMovement(input)
  else:
    editor.calculateCorrectionEdit(input)

  if editor.mouseMiddleWasPressedInside and input.isPressed(Middle):
    editor.handleViewMovement(input)
    editor.redraw()

func onResize*(editor: var PitchEditor, width, height: Inches) =
  editor.resize(width, height)
  editor.updateVisualCorrections()
  editor.redraw()

func drawKeys(editor: PitchEditor) =
  template toPixels(inches: Inches): Pixels =
    inches * editor.dpi

  var keyColorPrevious = editor.colorScheme.blackKeys

  for pitchId in 0 ..< numKeys:
    let
      keyCenterSemitones = pitchId.Semitones
      keyCenterInches = editor.viewY.convert keyCenterSemitones
      keyBottomSemitones = keyCenterSemitones - 0.5.Semitones
      keyBottomInches = editor.viewY.convert keyBottomSemitones
      keyTopSemitones = keyCenterSemitones + 0.5.Semitones
      keyTopInches = editor.viewY.convert keyTopSemitones
      keyLeftPixels = 0.Pixels
      keyCenterPixels = keyCenterInches.toPixels
      keyTopPixels = keyTopInches.toPixels - 1.Pixels
      keyBottomPixels = keyBottomInches.toPixels
      keyWidthPixels = editor.width.toPixels
      keyHeightPixels = (keyTopPixels - keyBottomPixels).abs
      keyColor =
        if isWhiteKey(pitchId):
          editor.colorScheme.whiteKeys
        else:
          editor.colorScheme.blackKeys

    editor.image.fillRectangle(
      keyLeftPixels, keyTopPixels,
      keyWidthPixels, keyHeightPixels,
      keyColor,
    )

    if pitchId > 0 and
       keyColor == editor.colorScheme.whiteKeys and
       keyColorPrevious == editor.colorScheme.whiteKeys:
      editor.image.drawLine(
        keyLeftPixels, keyBottomPixels,
        keyWidthPixels, keyBottomPixels,
        editor.colorScheme.blackKeys,
      )

    editor.image.drawLine(
      keyLeftPixels, keyCenterPixels,
      keyWidthPixels, keyCenterPixels,
      editor.colorScheme.centerLine,
    )

    keyColorPrevious = keyColor

func drawPitchCorrections(editor: PitchEditor) =
  template toPixels(inches: Inches): Pixels =
    inches * editor.dpi

  let
    r = editor.correctionPointVisualRadius.toPixels
    color = rgb(109, 186, 191)
    highlightColor = rgb(255, 255, 255, 0.5)

  for correctionId, correction in editor.visualCorrections:
    let lastPointId = correction.len - 1

    for pointId, point in correction:
      let
        x = point.x.toPixels
        y = point.y.toPixels

      if pointId < lastPointId:
        let nextPointId = pointId + 1
        var nextPoint = correction[pointId + 1]

        let
          nextX = nextPoint.x.toPixels
          nextY = nextPoint.y.toPixels

        editor.image.drawLine(x, y, nextX, nextY, color)

        if editor.correctionEdit.state == PitchEditState.Segment and
           editor.corrections[correctionId][pointId] == editor.correctionEdit.segment[0] and
           editor.corrections[correctionId][nextPointId] == editor.correctionEdit.segment[1]:
          editor.image.drawLine(x, y, nextX, nextY, highlightColor)

      editor.image.fillCircle(x, y, r, rgb(29, 81, 84))
      editor.image.drawCircle(x, y, r, color)

      if editor.correctionEdit.state == PitchEditState.Point and
         editor.corrections[correctionId][pointId] == editor.correctionEdit.point:
        editor.image.fillCircle(x, y, r, highlightColor)

func updateImage*(editor: PitchEditor) =
  editor.image.clear(editor.colorScheme.background)
  editor.drawKeys()
  editor.drawPitchCorrections()