import
  std/[math, options, algorithm, random],
  ../lice, ../units, ../input,
  ../reaper/functions,
  view, whitekeys

export view

type
  PitchPoint* = ref object
    time*: Seconds
    pitch*: Semitones

  PitchCorrection* = ref object
    points*: seq[PitchPoint]

  PitchEditor* = ref object
    position*: Vector2d[Inches]
    image*: Image
    dpi*: Dpi
    timeLength*: Seconds
    viewX*: ViewAxis[Seconds, Inches]
    viewY*: ViewAxis[Semitones, Inches]
    backgroundColor*: Color
    blackKeyColor*: Color
    whiteKeyColor*: Color
    centerLineColor*: Color
    correctionPointVisualRadius*: Inches
    shouldRedraw*: bool
    isEditingCorrection*: bool
    correctionEditDistance*: Inches
    correctionEditIsPoint*: bool
    correctionEditIsSegment*: bool
    correctionEditPoint*: PitchPoint
    correctionEditPointCorrection*: PitchCorrection
    correctionEditPointDistance*: Inches
    correctionEditSegment*: tuple[a: PitchPoint, b: PitchPoint]
    correctionEditSegmentCorrection*: PitchCorrection
    correctionEditSegmentDistance*: Inches
    mouseMiddleWasPressedInside: bool
    corrections: seq[PitchCorrection]

proc comparePitchPoint(x, y: PitchPoint): int =
  if x.time < y.time: -1
  else: 1

{.push inline.}

func `[]`*(correction: PitchCorrection, i: int): PitchPoint =
  return correction.points[i]
func `[]=`*(correction: PitchCorrection, i: int, point: PitchPoint) =
  correction.points[i] = point
iterator items*(correction: PitchCorrection): PitchPoint =
  for point in correction.points:
    yield point
iterator pairs*(correction: PitchCorrection): (int, PitchPoint) =
  for i, point in correction.points:
    yield (i, point)
func len*(correction: PitchCorrection): int =
  correction.points.len
func add*(correction: var PitchCorrection, point: PitchPoint) =
  correction.points.add point
func sort*(correction: var PitchCorrection, cmp: proc (x, y: PitchPoint): int) =
  correction.points.sort cmp

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

func toVisualPoint*(editor: PitchEditor, point: PitchPoint): Vector2d[Inches] =
  (editor.viewX.convert(point.time), editor.viewY.convert(point.pitch))

{.pop.}

proc newPitchEditor*(position: Vector2d[Inches],
                     width, height: Inches,
                     dpi: Dpi,
                     timeLength: Seconds): PitchEditor =
  result = PitchEditor()
  result.position = position
  result.timeLength = timeLength
  result.viewX = initViewAxis[Seconds, Inches]()
  result.viewY = initViewAxis[Semitones, Inches]()
  result.viewY.isInverted = true
  result.resize(width, height)
  result.zoomOutXToFull()
  result.zoomOutYToFull()
  result.dpi = dpi
  result.image = initImage(width * dpi, height * dpi)
  result.backgroundColor = rgb(16, 16, 16)
  result.blackKeyColor = rgb(60, 60, 60, 1.0)
  result.whiteKeyColor = rgb(110, 110, 110, 1.0)
  result.centerLineColor = rgb(255, 255, 255, 0.15)
  result.correctionPointVisualRadius = (3.0 / 96.0).Inches
  result.correctionEditDistance = (5.0 / 96.0).Inches

  for correctionId in 0 ..< 5:
    var correction = PitchCorrection()

    for pointId in 0 ..< 5:
      let pointNumber = 5 * correctionId + pointId
      correction.add PitchPoint(
        time: pointNumber.Seconds,
        pitch: rand(numKeys).Semitones,
      )

    result.corrections.add correction

func calculateCorrectionEdit*(editor: var PitchEditor, toPoint: Vector2d[Inches]) =
  editor.correctionEditPoint = nil
  editor.correctionEditPointDistance = 0.Inches
  editor.correctionEditSegment = (nil, nil)
  editor.correctionEditSegmentDistance = 0.Inches

  let lastPointIndex = editor.corrections.len - 1

  for correction in editor.corrections:
    for i, point in correction:
      let
        pointInches = editor.toVisualPoint point
        distanceToPoint = toPoint.distance pointInches

      if i < lastPointIndex:
        let
          nextPoint = correction[i + 1]
          nextPointInches = editor.toVisualPoint nextPoint
          distanceToSegment = toPoint.distance (pointInches, nextPointInches)

        if editor.correctionEditSegment == (nil, nil):
          editor.correctionEditSegment = (point, nextPoint)
          editor.correctionEditSegmentDistance = distanceToSegment
          editor.correctionEditSegmentCorrection = correction
        else:
          if distanceToSegment < editor.correctionEditSegmentDistance:
            editor.correctionEditSegment = (point, nextPoint)
            editor.correctionEditSegmentDistance = distanceToSegment
            editor.correctionEditSegmentCorrection = correction

      if editor.correctionEditPoint == nil:
        editor.correctionEditPoint = point
        editor.correctionEditPointDistance = distanceToPoint
        editor.correctionEditPointCorrection = correction
      else:
        if distanceToPoint < editor.correctionEditPointDistance:
          editor.correctionEditPoint = point
          editor.correctionEditPointDistance = distanceToPoint
          editor.correctionEditPointCorrection = correction

  editor.correctionEditIsPoint = editor.correctionEditPointDistance <= editor.correctionEditDistance
  editor.correctionEditIsSegment = editor.correctionEditSegmentDistance <= editor.correctionEditDistance and not editor.correctionEditIsPoint

func onMousePress*(editor: var PitchEditor, input: Input) =
  case input.lastMousePress:
  of Left:
    if editor.positionIsInside(input.mousePosition):
      editor.isEditingCorrection = editor.correctionEditIsPoint or
                                   editor.correctionEditIsSegment
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

func onMouseMove*(editor: var PitchEditor, input: Input) =
  let
    xChange = input.mouseDelta.x
    yChange = input.mouseDelta.y

  if editor.isEditingCorrection:
    let
      timeChange = editor.viewX.scale xChange
      pitchChange = editor.viewY.scale -yChange

    if editor.correctionEditIsPoint:
      editor.correctionEditPoint.time += timeChange
      editor.correctionEditPoint.pitch += pitchChange
      editor.correctionEditPointCorrection.sort comparePitchPoint
    elif editor.correctionEditIsSegment:
      editor.correctionEditSegment.a.time += timeChange
      editor.correctionEditSegment.a.pitch += pitchChange
      editor.correctionEditSegment.b.time += timeChange
      editor.correctionEditSegment.b.pitch += pitchChange
      editor.correctionEditSegmentCorrection.sort comparePitchPoint
  else:
    editor.calculateCorrectionEdit(input.mousePosition)

  if editor.mouseMiddleWasPressedInside and
     input.isPressed(Middle):
    if input.isPressed(Shift):
      editor.viewX.changeZoom xChange
      editor.viewY.changeZoom yChange
    else:
      editor.viewX.changePan -xChange
      editor.viewY.changePan yChange

    editor.redraw()

func onResize*(editor: var PitchEditor, width, height: Inches) =
  editor.resize(width, height)
  editor.redraw()

func drawKeys(editor: PitchEditor) =
  template toPixels(inches: Inches): Pixels =
    inches * editor.dpi

  var keyColorPrevious = editor.blackKeyColor

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
          editor.whiteKeyColor
        else:
          editor.blackKeyColor

    editor.image.fillRectangle(
      keyLeftPixels, keyTopPixels,
      keyWidthPixels, keyHeightPixels,
      keyColor,
    )

    if pitchId > 0 and
       keyColor == editor.whiteKeyColor and
       keyColorPrevious == editor.whiteKeyColor:
      editor.image.drawLine(
        keyLeftPixels, keyBottomPixels,
        keyWidthPixels, keyBottomPixels,
        editor.blackKeyColor,
      )

    editor.image.drawLine(
      keyLeftPixels, keyCenterPixels,
      keyWidthPixels, keyCenterPixels,
      editor.centerLineColor,
    )

    keyColorPrevious = keyColor

func drawPitchCorrections(editor: PitchEditor) =
  template toPixels(inches: Inches): Pixels =
    inches * editor.dpi

  let
    r = editor.correctionPointVisualRadius.toPixels
    color = rgb(109, 186, 191)
    highlightColor = rgb(255, 255, 255, 0.5)

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

        if editor.correctionEditIsSegment and
           editor.correctionEditSegment[0] == point and
           editor.correctionEditSegment[1] == nextPoint:
          editor.image.drawLine(x, y, nextX, nextY, highlightColor)

      editor.image.fillCircle(x, y, r, rgb(29, 81, 84))
      editor.image.drawCircle(x, y, r, color)

      if editor.correctionEditIsPoint and
         editor.correctionEditPoint == point:
        editor.image.fillCircle(x, y, r, highlightColor)

func updateImage*(editor: PitchEditor) =
  editor.image.clear(editor.backgroundColor)
  editor.drawKeys()
  editor.drawPitchCorrections()