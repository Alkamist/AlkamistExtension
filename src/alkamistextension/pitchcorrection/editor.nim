import
  std/[math, algorithm, random],
  ../lice, ../units, ../input, ../view, ../geometry,
  whitekeys

type
  PitchPoint* = tuple[time: Seconds, pitch: Semitones]
  PitchSegment* = tuple[a, b: PitchPoint]
  PitchPolyLine* = seq[PitchPoint]

  PitchPolyLineEditState* = enum
    None,
    Point,
    Segment,

  PitchPolyLineEdit* = object
    state*: PitchPolyLineEditState
    point*: ptr PitchPoint
    segment*: ptr PitchSegment
    pointDistance*: Inches
    segmentDistance*: Inches
    pointPolyLine*: ptr PitchPolyLine
    segmentPolyLine*: ptr PitchPolyLine

  PitchEditorColorScheme* = object
    background*: Color
    blackKeys*: Color
    whiteKeys*: Color
    centerLine*: Color

  PitchEditor* = object
    position*: Vector2d[Inches]
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
    correctionEdit: PitchPolyLineEdit
    mouseMiddleWasPressedInside: bool
    corrections: seq[PitchPolyLine]

proc comparePitchPoint*(x, y: PitchPoint): int =
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

func positionIsInside*(editor: PitchEditor, position: Vector2d[Inches]): bool =
  position.x >= 0.Inches and
  position.x <= editor.width and
  position.y >= 0.Inches and
  position.y <= editor.height

func toVisualPoint*(point: PitchPoint, editor: PitchEditor): Vector2d[Inches] =
  (editor.viewX.convert point.time,
   editor.viewY.convert point.pitch)

# func resetPitchSnap*(editor: var PitchEditor) =
#   if editor.correctionEditIsPoint:
#     editor.correctionEditPointSnapStart = (editor.correctionEdit.point.time,
#                                            editor.correctionEdit.point.pitch)
#   elif editor.correctionEditIsSegment:
#     editor.correctionEditPointSnapStart = (editor.correctionEdit.point.time,
#                                            editor.correctionEdit.point.pitch)

{.pop.}

proc initPitchEditor*(position: Vector2d[Inches],
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

  for correctionId in 0 ..< 5:
    var correction: PitchPolyLine

    for pointId in 0 ..< 5:
      let pointNumber = 5 * correctionId + pointId
      correction.add (
        time: pointNumber.Seconds,
        pitch: rand(numKeys).Semitones,
      )

    result.corrections.add correction

func onMousePress*(editor: var PitchEditor, input: Input) =
  case input.lastMousePress:
  # of Left:
  #   if editor.positionIsInside(input.mousePosition):
  #     editor.isEditingCorrection = editor.correctionEdit.state != PitchPointEditState.None
  #     # if editor.isEditingCorrection:
  #     #   editor.resetPitchSnap()
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
  # of Left: editor.isEditingCorrection = false
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

func calculateCorrectionEdit(editor: var PitchEditor, input: Input) =
  var visualCorrections: seq[PolyLine2d[Inches]]
  for correction in editor.corrections:
    var visualLine: PolyLine2d[Inches]
    for point in correction:
      visualLine.add point.toVisualPoint(editor)
    visualCorrections.add visualLine

  var distanceInfo = distanceInfo[Inches](visualCorrections)

  # state*: PitchPolyLineEditState

  result.pointDistance = distanceInfo.closestPointDistance
  result.pointPolyLine = editor.corrections[distanceInfo.closestPointPolyLineIndex].addr
  result.point = result.pointPolyLine[distanceInfo.closestPointIndex].addr

  result.segmentDistance  = distanceInfo.closestSegmentDistance
  result.segmentPolyLine = editor.corrections[distanceInfo.closestSegmentPolyLineIndex].addr
  result.segment = (result.segmentPolyLine[distanceInfo.closestSegmentIndex].addr,
                    result.segmentPolyLine[distanceInfo.closestSegmentIndex + 1].addr)

func onMouseMove*(editor: var PitchEditor, input: Input) =
  # if editor.isEditingCorrection:
  #   editor.handleEditMovement(input)
  # else:

  editor.calculateCorrectionEdit(input)

  if editor.mouseMiddleWasPressedInside and input.isPressed(Middle):
    editor.handleViewMovement(input)
    editor.redraw()

func onResize*(editor: var PitchEditor, width, height: Inches) =
  editor.resize(width, height)
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
    # highlightColor = rgb(255, 255, 255, 0.5)

  for correction in editor.corrections:
    let lastPointId = correction.len - 1

    for i, point in correction:
      let
        x = editor.viewX.convert(point.time).toPixels
        y = editor.viewY.convert(point.pitch).toPixels

      if i < lastPointId:
        var nextPoint = correction[i + 1]

        let
          nextX = editor.viewX.convert(nextPoint.time).toPixels
          nextY = editor.viewY.convert(nextPoint.pitch).toPixels

        editor.image.drawLine(x, y, nextX, nextY, color)

        # if editor.correctionEditIsSegment and
        #    editor.correctionEditSegment[0] == point and
        #    editor.correctionEditSegment[1] == nextPoint:
        #   editor.image.drawLine(x, y, nextX, nextY, highlightColor)

      editor.image.fillCircle(x, y, r, rgb(29, 81, 84))
      editor.image.drawCircle(x, y, r, color)

      # if editor.correctionEditIsPoint and
      #    editor.correctionEdit.point == point:
      #   editor.image.fillCircle(x, y, r, highlightColor)

func updateImage*(editor: PitchEditor) =
  editor.image.clear(editor.colorScheme.background)
  editor.drawKeys()
  editor.drawPitchCorrections()