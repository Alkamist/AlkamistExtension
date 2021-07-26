import
  std/[math, options],
  ../lice, ../units, ../input,
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
    shouldRedraw*: bool
    mouseMiddleWasPressedInside: bool
    # corrections: seq[seq[PitchPoint]]

{.push inline.}

func redraw*(editor: var PitchEditor) =
  editor.shouldRedraw = true

func resize*(editor: var PitchEditor, width, height: Inches) =
  editor.viewX.externalSize = width
  editor.viewY.externalSize = height
  editor.image.resize(width * editor.dpi, height * editor.dpi)

func x*(editor: PitchEditor): Inches = editor.position.x
func y*(editor: PitchEditor): Inches = editor.position.y
func width*(editor: PitchEditor): Inches = editor.viewX.externalSize
func height*(editor: PitchEditor): Inches = editor.viewY.externalSize
func `width=`*(editor: var PitchEditor, value: Inches) = editor.resize(value, editor.height)
func `height=`*(editor: var PitchEditor, value: Inches) = editor.resize(editor.width, value)

# func toSeconds*(editor: PitchEditor, x: Inches): Seconds =
#   editor.timeLength * (editor.xView.pan + x / (editor.width.float * editor.xView.zoom))

# func yToPitch*(editor: PitchEditor, y: float): float =
#   numKeys.float * (1.0 - (editor.yView.pan + y / (editor.height.float * editor.yView.zoom))) - 0.5

# func timeToX*(editor: PitchEditor, time: Seconds): float =
#   editor.xView.zoom * editor.width.float * (time.float / editor.timeLength - editor.xView.pan)

# func pitchToDistance*(editor: PitchEditor, pitch: Semitones): Inches =
#   (editor.view.y.zoom * editor.height.float * ((1.0 - (0.5 + pitch.float) / numKeys.float) - editor.view.y.pan)).Inches

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
  result.resize(width, height)
  result.dpi = dpi
  result.image = initImage(width * dpi, height * dpi)
  result.backgroundColor = rgb(16, 16, 16)
  result.blackKeyColor = rgb(60, 60, 60, 1.0)
  result.whiteKeyColor = rgb(110, 110, 110, 1.0)

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
  position.x >= editor.x and
  position.x <= editor.x + editor.width and
  position.y >= editor.y and
  position.y <= editor.y + editor.height

func onMousePress*(editor: var PitchEditor, input: Input) =
  case input.lastMousePress:
  of Middle:
    if editor.positionIsInside(input.mousePosition):
      editor.mouseMiddleWasPressedInside = true
      # editor.viewX.zoomTarget = editor.viewX.toInternal[Seconds, Inches] -input.mousePosition.x
      editor.viewY.zoomTarget = editor.viewY.toInternalValue input.mousePosition.y
  else: discard

func onMouseRelease*(editor: var PitchEditor, input: Input) =
  case input.lastMouseRelease:
  of Middle:
    editor.mouseMiddleWasPressedInside = false
  else: discard

func onMouseMove*(editor: var PitchEditor, input: Input) =
  let
    # xChange = input.mouseDelta.x
    yChange = input.mouseDelta.y

  if editor.mouseMiddleWasPressedInside and
     input.isPressed(Middle):
    if input.isPressed(Shift):
      # editor.view.x.pan += xChange
      editor.viewY.changeZoom -yChange
    else:
      # editor.view.x.changePan(-xChange)
      editor.viewY.changePan yChange

    editor.redraw()

func onResize*(editor: var PitchEditor, width, height: Inches) =
  editor.resize(width, height)
  editor.redraw()

func drawKeys(editor: PitchEditor) =
  template toPixels(inches: Inches): Pixels =
    inches * editor.dpi

  const topSemitones = (numKeys.float + 0.5).Semitones

  var
    keyTopInches = editor.viewY.toExternalValue topSemitones
    keyColorPrevious: Color

  for pitchId in 0 ..< numKeys:
    let
      bottomSemitones = (numKeys.float - (pitchId + 1).float + 0.5).Semitones
      keyBottomInches = editor.viewY.toExternalValue bottomSemitones
      keyLeftPixels = 0.Pixels
      keyTopPixels = keyTopInches.toPixels
      keyBottomPixels = keyBottomInches.toPixels - 1.Pixels
      keyWidthPixels = editor.width.toPixels
      keyHeightPixels = (keyBottomPixels - keyTopPixels).abs
      keyColor =
        if isWhiteKey(pitchId):
          editor.whiteKeyColor
        else:
          editor.blackKeyColor

    editor.image.fillRectangle(keyLeftPixels, keyTopPixels, keyWidthPixels, keyHeightPixels, keyColor)

    # if pitchId > 0 and keyColorPrevious == editor.whiteKeyColor:
    #   editor.image.drawLine(0.Pixels, keyBottom, editor.width.float, keyBottom, editor.blackKeyColor)

    keyTopInches = keyBottomInches
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