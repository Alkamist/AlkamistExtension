import
  std/[math, options],
  ../lice, ../units, ../input,
  ../reaper/functions,
  view, whitekeys

export view

type
  PitchPoint* = object
    time*: Seconds
    pitch*: Semitones

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
    shouldRedraw*: bool
    mouseMiddleWasPressedInside: bool
    # corrections: seq[seq[PitchPoint]]

{.push inline.}

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

  # result.corrections = newPolyLineGroup2d()

  # for correctionId in 0 ..< 5:
  #   var correction = newPolyLine2d()

  #   for pointId in 0 ..< 5:
  #     let pointNumber = 5 * correctionId + pointId
  #     correction.points.add (
  #       x: pointNumber.float,
  #       y: rand(numKeys).float,
  #     )

  #   result.corrections.lines.add correction

func positionIsInside*(editor: PitchEditor, position: Vector2d[Inches]): bool =
  position.x >= 0.Inches and
  position.x <= editor.width and
  position.y >= 0.Inches and
  position.y <= editor.height

func onMousePress*(editor: var PitchEditor, input: Input) =
  case input.lastMousePress:
  of Middle:
    if editor.positionIsInside(input.mousePosition):
      editor.mouseMiddleWasPressedInside = true
      editor.viewX.zoomTarget = editor.viewX.convert input.mousePosition.x
      editor.viewY.zoomTarget = editor.viewY.convert input.mousePosition.y
      # ShowConsoleMsg("Target: " & $editor.viewY.zoomTarget & "\n")
      # ShowConsoleMsg("Pan: " & $editor.viewY.pan & "\n")
      # ShowConsoleMsg("Zoom: " & $editor.viewY.zoom & "\n")
  else: discard

func onMouseRelease*(editor: var PitchEditor, input: Input) =
  case input.lastMouseRelease:
  of Middle:
    editor.mouseMiddleWasPressedInside = false
  else: discard

func onMouseMove*(editor: var PitchEditor, input: Input) =
  let
    xChange = input.mouseDelta.x
    yChange = input.mouseDelta.y

  if editor.mouseMiddleWasPressedInside and
     input.isPressed(Middle):
    if input.isPressed(Shift):
      editor.viewX.changeZoom xChange
      editor.viewY.changeZoom yChange
    else:
      editor.viewX.changePan xChange
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

# func drawPitchCorrections(editor: PitchEditor, window: Window) =
#   let
#     r = editor.correctionPointVisualRadius
#     color = rgb(109, 186, 191)
#     highlightColor = rgb(255, 255, 255, 0.35)

#   for correction in editor.corrections.mitems:
#     let lastPointId = correction.points.len - 1

#     for i, point in correction.points.mpairs:
#       let
#         x = editor.timeToX(point.x)
#         y = editor.pitchToY(point.y)

#       if i < lastPointId:
#         var nextPoint {.byaddr.} = correction.points[i + 1]

#         let
#           nextX = editor.timeToX(nextPoint.x)
#           nextY = editor.pitchToY(nextPoint.y)

#         editor.image.drawLine(x, y, nextX, nextY, color)

#         # if editor.corrections.editIsSegment and
#         #    editor.corrections.editSegment[0] == point.addr and
#         #    editor.corrections.editSegment[1] == nextPoint.addr:
#         #   editor.image.drawLine(x, y, nextX, nextY, highlightColor)

#       editor.image.fillCircle(x, y, r, rgb(29, 81, 84))
#       editor.image.drawCircle(x, y, r, color)

#       # if editor.corrections.editIsPoint and
#       #    editor.corrections.editPoint == point.addr:
#       #   editor.image.fillCircle(x, y, r, highlightColor)

func updateImage*(editor: PitchEditor) =
  editor.image.clear(editor.backgroundColor)
  editor.drawKeys()
  # editor.drawPitchCorrections(window)