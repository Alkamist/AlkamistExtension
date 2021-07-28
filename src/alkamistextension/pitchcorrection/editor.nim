import
  std/[math, algorithm, random],
  ../lice, ../units, ../input, ../view, ../geometry,
  whitekeys

type
  PitchEditState = enum
    None,
    Point,
    Segment,

  PitchEdit = object
    state*: PitchEditState
    point*: ref (Seconds, Semitones)
    segment*: (ref (Seconds, Semitones), ref (Seconds, Semitones))
    pointDistance*: Inches
    segmentDistance*: Inches
    pointIndex*: int
    segmentIndex*: int
    pointPolyLineIndex*: int
    segmentPolyLineIndex*: int
    pointSnapStart*: (Seconds, Semitones)
    segmentSnapStart*: ((Seconds, Semitones), (Seconds, Semitones))

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
    corrections: seq[seq[ref (Seconds, Semitones)]]
    visualCorrections: seq[seq[(Inches, Inches)]]

{.push inline.}

func `time`*(a: (Seconds, Semitones)): Seconds = a[0]
func `time=`*(a: var (Seconds, Semitones), value: Seconds) = a[0] = value
func `time`*(a: ref (Seconds, Semitones)): Seconds = a[0]
func `time=`*(a: var ref (Seconds, Semitones), value: Seconds) = a[0] = value
func `pitch`*(a: (Seconds, Semitones)): Semitones = a[1]
func `pitch=`*(a: var (Seconds, Semitones), value: Semitones) = a[1] = value
func `pitch`*(a: ref (Seconds, Semitones)): Semitones = a[1]
func `pitch=`*(a: var ref (Seconds, Semitones), value: Semitones) = a[1] = value

{.pop.}

proc comparePitchPoint*(x, y: (Seconds, Semitones)): int =
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

func zoomOutXToFull*(editor: var PitchEditor) =
  editor.viewX.zoom = editor.width.toFloat / editor.timeLength.toFloat

func zoomOutYToFull*(editor: var PitchEditor) =
  editor.viewY.zoom = editor.height.toFloat / numKeys.toFloat

func positionIsInside*(editor: PitchEditor, position: (Inches, Inches)): bool =
  position.x >= 0.Inches and
  position.x <= editor.width and
  position.y >= 0.Inches and
  position.y <= editor.height

func toVisualPoint*(point: (Seconds, Semitones), editor: PitchEditor): (Inches, Inches) =
  (editor.viewX.convert point.time,
   editor.viewY.convert point.pitch)

func resetPitchSnap(editor: var PitchEditor) =
  editor.correctionEdit.pointSnapStart = (
    editor.correctionEdit.point.time,
    editor.correctionEdit.point.pitch,
  )
  editor.correctionEdit.segmentSnapStart = (
    (editor.correctionEdit.segment[0].time, editor.correctionEdit.segment[0].pitch),
    (editor.correctionEdit.segment[1].time, editor.correctionEdit.segment[1].pitch),
  )

{.pop.}

func updateVisualCorrections(editor: var PitchEditor) =
  editor.visualCorrections = @[]
  for correction in editor.corrections:
    var visualLine: seq[(Inches, Inches)]
    for point in correction:
      visualLine.add point[].toVisualPoint(editor)
    editor.visualCorrections.add visualLine

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
    var correction: seq[ref (Seconds, Semitones)]

    for pointId in 0 ..< 3:
      let pointNumber = 5 * correctionId + pointId
      var point = new (Seconds, Semitones)
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
        editor.resetPitchSnap()
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
  let
    mouseTime = editor.viewX.convert input.mousePosition.x
    mousePitch = editor.viewY.convert input.mousePosition.y

  template assignPoint(t, p): untyped =
    if editor.correctionEdit.point != nil:
      editor.correctionEdit.point.time = t
      editor.correctionEdit.point.pitch = p
      # editor.corrections[editor.correctionEdit.pointPolyLineIndex].points.sort comparePitchPoint

  if editor.correctionEdit.state == Point:
    if input.isPressed(Shift):
      assignPoint(mouseTime, mousePitch)
      editor.resetPitchSnap()
    else:
      let
        pitchStart = editor.correctionEdit.pointSnapStart.pitch
        pitchDelta = mousePitch - pitchStart
      assignPoint(mouseTime, pitchStart + pitchDelta.round)

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
        var nextPoint = correction[pointId + 1]

        let
          nextX = nextPoint.x.toPixels
          nextY = nextPoint.y.toPixels

        editor.image.drawLine(x, y, nextX, nextY, color)

        if editor.correctionEdit.state == PitchEditState.Segment and
           editor.correctionEdit.segmentPolyLineIndex == correctionId and
           editor.correctionEdit.segmentIndex == pointId:
          editor.image.drawLine(x, y, nextX, nextY, highlightColor)

      editor.image.fillCircle(x, y, r, rgb(29, 81, 84))
      editor.image.drawCircle(x, y, r, color)

      if editor.correctionEdit.state == PitchEditState.Point and
         editor.correctionEdit.pointPolyLineIndex == correctionId and
         editor.correctionEdit.pointIndex == pointId:
        editor.image.fillCircle(x, y, r, highlightColor)

func updateImage*(editor: PitchEditor) =
  editor.image.clear(editor.colorScheme.background)
  editor.drawKeys()
  editor.drawPitchCorrections()