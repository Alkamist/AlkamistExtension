import
  std/math,
  ../lice, ../units, ../input, ../view, ../geometry,
  whitekeys

type
  PitchEditorColorScheme* = object
    background*: Color
    blackKeys*: Color
    whiteKeys*: Color
    centerLine*: Color

  PitchEditor* = ref object
    position*: (Inches, Inches)
    image*: Image
    timeLength*: Seconds
    colorScheme*: PitchEditorColorScheme
    correctionEditDistance*: Inches
    correctionPointVisualRadius*: Inches
    shouldRedraw*: bool
    view: View[Seconds, Semitones, Inches]
    isEditingCorrection: bool
    mouseMiddleWasPressedInside: bool
    mouseRightWasPressedInside: bool

{.push inline.}

func x*(editor: PitchEditor): Inches = editor.position.x
func y*(editor: PitchEditor): Inches = editor.position.y
func width*(editor: PitchEditor): Inches = editor.view.x.externalSize
func height*(editor: PitchEditor): Inches = editor.view.y.externalSize
func dimensions*(editor: PitchEditor): (Inches, Inches) = (editor.width, editor.height)
func dpi*(editor: PitchEditor): Dpi = editor.image.dpi

{.pop.}

func defaultPitchEditorColorScheme*(): PitchEditorColorScheme =
  result.background = rgb(16, 16, 16)
  result.blackKeys = rgb(60, 60, 60, 1.0)
  result.whiteKeys = rgb(110, 110, 110, 1.0)
  result.centerLine = rgb(255, 255, 255, 0.15)

func resize*(editor: var PitchEditor, dimensions: (Inches, Inches)) =
  editor.view.x.externalSize = dimensions.width
  editor.view.y.externalSize = dimensions.height
  editor.image.resize(dimensions)

func redraw*(editor: var PitchEditor) =
  editor.shouldRedraw = true

func zoomOutXToFull*(editor: var PitchEditor) =
  editor.view.x.zoom = editor.width.toFloat / editor.timeLength.toFloat

func zoomOutYToFull*(editor: var PitchEditor) =
  editor.view.y.zoom = editor.height.toFloat / numKeys.toFloat

func positionIsInside*(editor: PitchEditor, position: (Inches, Inches)): bool =
  position.x >= 0.Inches and
  position.x <= editor.width and
  position.y >= 0.Inches and
  position.y <= editor.height

proc newPitchEditor*(position: (Inches, Inches),
                     dimensions: (Inches, Inches),
                     dpi: Dpi): PitchEditor =
  result = PitchEditor()
  result.position = position
  result.timeLength = 10.Seconds
  result.view = newView[Seconds, Semitones, Inches]()
  result.view.y.isInverted = true
  result.resize(dimensions)
  result.zoomOutXToFull()
  result.zoomOutYToFull()
  result.image = initImage(dpi, dimensions)
  result.colorScheme = defaultPitchEditorColorScheme()
  result.correctionPointVisualRadius = (3.0 / 96.0).Inches
  result.correctionEditDistance = (5.0 / 96.0).Inches
  result.redraw()

func onMousePress*(editor: var PitchEditor, input: Input) =
  case input.lastMousePress:
  of Middle:
    if editor.positionIsInside(input.mousePosition):
      editor.mouseMiddleWasPressedInside = true
      editor.view.zoomTarget = input.mousePosition
  else: discard

func onMouseRelease*(editor: var PitchEditor, input: Input) =
  case input.lastMouseRelease:
  of Middle: editor.mouseMiddleWasPressedInside = false
  else: discard

func handleViewMovement*(editor: var PitchEditor, input: Input) =
  if input.isPressed(Shift):
    editor.view.changeZoom(input.mouseDelta)
  else:
    editor.view.changePan(input.mouseDelta)

func onMouseMove*(editor: var PitchEditor, input: Input) =
  if editor.mouseMiddleWasPressedInside and input.isPressed(Middle):
    editor.handleViewMovement(input)
    editor.redraw()

func onResize*(editor: var PitchEditor, dimensions: (Inches, Inches)) =
  editor.resize(dimensions)
  editor.redraw()

func drawKeys(editor: PitchEditor) =
  var keyColorPrevious = editor.colorScheme.blackKeys

  for pitchId in 0 ..< numKeys:
    let
      keyCenterSemitones = pitchId.Semitones
      keyBottomSemitones = keyCenterSemitones - 0.5.Semitones
      keyTopSemitones = keyCenterSemitones + 0.5.Semitones

      keyLeftInches = 0.Inches
      keyCenterInches = editor.view.y.convert(keyCenterSemitones)
      keyBottomInches = editor.view.y.convert(keyBottomSemitones)
      keyTopInches = editor.view.y.convert(keyTopSemitones) - (1.0 / 96.0).Inches
      keyWidthInches = editor.width
      keyHeightInches = abs(keyTopInches - keyBottomInches)

      keyColor =
        if isWhiteKey(pitchId):
          editor.colorScheme.whiteKeys
        else:
          editor.colorScheme.blackKeys

    editor.image.fillRectangle(
      (keyLeftInches, keyTopInches),
      (keyWidthInches, keyHeightInches),
      keyColor,
    )

    if pitchId > 0 and
       keyColor == editor.colorScheme.whiteKeys and
       keyColorPrevious == editor.colorScheme.whiteKeys:
      editor.image.drawLine(
        (keyLeftInches, keyBottomInches),
        (keyWidthInches, keyBottomInches),
        editor.colorScheme.blackKeys,
      )

    editor.image.drawLine(
      (keyLeftInches, keyCenterInches),
      (keyWidthInches, keyCenterInches),
      editor.colorScheme.centerLine,
    )

    keyColorPrevious = keyColor

func updateImage*(editor: PitchEditor) =
  editor.image.clear(editor.colorScheme.background)
  editor.drawKeys()