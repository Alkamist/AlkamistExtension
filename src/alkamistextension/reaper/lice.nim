import
  std/options,
  winapi, types, units

type
  LICE_pixel = cuint
  # LICE_pixel_chan = cuchar
  LICE_IBitmap {.importc, header: ReaperPluginFunctionsHeader.} = object
  # LICE_IFont {.importc, header: ReaperPluginFunctionsHeader.} = object

proc LICE_private_Destroy(bm: ptr LICE_IBitmap) {.importc: "LICE__Destroy", header: ReaperPluginFunctionsHeader.}
# proc LICE_private_DestroyFont(font: ptr LICE_IFont) {.importc: "LICE__DestroyFont", header: ReaperPluginFunctionsHeader.}
# proc LICE_private_DrawText(font: ptr LICE_IFont; bm: ptr LICE_IBitmap; str: cstring; strcnt: cint; rect: ptr RECT; dtFlags: UINT): cint {.importc: "LICE__DrawText", header: ReaperPluginFunctionsHeader.}
# proc LICE_private_GetBits(bm: ptr LICE_IBitmap): pointer {.importc: "LICE__GetBits", header: ReaperPluginFunctionsHeader.}
proc LICE_private_GetDC(bm: ptr LICE_IBitmap): HDC {.importc: "LICE__GetDC", header: ReaperPluginFunctionsHeader.}
# proc LICE_private_GetHeight(bm: ptr LICE_IBitmap): cint {.importc: "LICE__GetHeight", header: ReaperPluginFunctionsHeader.}
# proc LICE_private_GetRowSpan(bm: ptr LICE_IBitmap): cint {.importc: "LICE__GetRowSpan", header: ReaperPluginFunctionsHeader.}
# proc LICE_private_GetWidth(bm: ptr LICE_IBitmap): cint {.importc: "LICE__GetWidth", header: ReaperPluginFunctionsHeader.}
# proc LICE_private_IsFlipped(bm: ptr LICE_IBitmap): bool {.importc: "LICE__IsFlipped", header: ReaperPluginFunctionsHeader.}
proc LICE_private_resize(bm: ptr LICE_IBitmap; w: cint; h: cint): bool {.importc: "LICE__resize", header: ReaperPluginFunctionsHeader.}
# proc LICE_private_SetBkColor(font: ptr LICE_IFont; color: LICE_pixel): LICE_pixel {.importc: "LICE__SetBkColor", header: ReaperPluginFunctionsHeader.}
# proc LICE_private_SetFromHFont(font: ptr LICE_IFont; hfont: HFONT; flags: cint) {.importc: "LICE__SetFromHFont", header: ReaperPluginFunctionsHeader.}
# proc LICE_private_SetTextColor(font: ptr LICE_IFont; color: LICE_pixel): LICE_pixel {.importc: "LICE__SetTextColor", header: ReaperPluginFunctionsHeader.}
# proc LICE_private_SetTextCombineMode(ifont: ptr LICE_IFont; mode: cint; alpha: cfloat) {.importc: "LICE__SetTextCombineMode", header: ReaperPluginFunctionsHeader.}
# proc LICE_Arc(dest: ptr LICE_IBitmap; cx: cfloat; cy: cfloat; r: cfloat; minAngle: cfloat; maxAngle: cfloat; color: LICE_pixel; alpha: cfloat; mode: cint; aa: bool) {.importc, header: ReaperPluginFunctionsHeader.}
proc LICE_Blit(dest: ptr LICE_IBitmap; src: ptr LICE_IBitmap; dstx: cint; dsty: cint; srcx: cint; srcy: cint; srcw: cint; srch: cint; alpha: cfloat; mode: cint) {.importc, header: ReaperPluginFunctionsHeader.}
# proc LICE_Blur(dest: ptr LICE_IBitmap; src: ptr LICE_IBitmap; dstx: cint; dsty: cint; srcx: cint; srcy: cint; srcw: cint; srch: cint) {.importc, header: ReaperPluginFunctionsHeader.}
# proc LICE_BorderedRect(dest: ptr LICE_IBitmap; x: cint; y: cint; w: cint; h: cint; bgcolor: LICE_pixel; fgcolor: LICE_pixel; alpha: cfloat; mode: cint) {.importc, header: ReaperPluginFunctionsHeader.}
# proc LICE_Circle(dest: ptr LICE_IBitmap; cx: cfloat; cy: cfloat; r: cfloat; color: LICE_pixel; alpha: cfloat; mode: cint; aa: bool) {.importc, header: ReaperPluginFunctionsHeader.}
proc LICE_Clear(dest: ptr LICE_IBitmap; color: LICE_pixel) {.importc, header: ReaperPluginFunctionsHeader.}
# proc LICE_ClearRect(dest: ptr LICE_IBitmap; x: cint; y: cint; w: cint; h: cint; mask: LICE_pixel; orbits: LICE_pixel) {.importc, header: ReaperPluginFunctionsHeader.}
# proc LICE_ClipLine(pX1Out: ptr cint; pY1Out: ptr cint; pX2Out: ptr cint; pY2Out: ptr cint; xLo: cint; yLo: cint; xHi: cint; yHi: cint): bool {.importc, header: ReaperPluginFunctionsHeader.}
# proc LICE_Copy(dest: ptr LICE_IBitmap; src: ptr LICE_IBitmap) {.importc, header: ReaperPluginFunctionsHeader.}
proc LICE_CreateBitmap(mode: cint; w: cint; h: cint): ptr LICE_IBitmap {.importc, header: ReaperPluginFunctionsHeader.}
# proc LICE_CreateFont(): ptr LICE_IFont {.importc, header: ReaperPluginFunctionsHeader.}
# proc LICE_DrawCBezier(dest: ptr LICE_IBitmap; xstart: cdouble; ystart: cdouble; xctl1: cdouble; yctl1: cdouble; xctl2: cdouble; yctl2: cdouble; xend: cdouble; yend: cdouble; color: LICE_pixel; alpha: cfloat; mode: cint; aa: bool; tol: cdouble) {.importc, header: ReaperPluginFunctionsHeader.}
# proc LICE_DrawChar(bm: ptr LICE_IBitmap; x: cint; y: cint; c: char; color: LICE_pixel; alpha: cfloat; mode: cint) {.importc, header: ReaperPluginFunctionsHeader.}
# proc LICE_DrawGlyph(dest: ptr LICE_IBitmap; x: cint; y: cint; color: LICE_pixel; alphas: ptr LICE_pixel_chan; glyph_w: cint; glyph_h: cint; alpha: cfloat; mode: cint) {.importc, header: ReaperPluginFunctionsHeader.}
# proc LICE_DrawRect(dest: ptr LICE_IBitmap; x: cint; y: cint; w: cint; h: cint; color: LICE_pixel; alpha: cfloat; mode: cint) {.importc, header: ReaperPluginFunctionsHeader.}
# proc LICE_DrawText(bm: ptr LICE_IBitmap; x: cint; y: cint; string: cstring; color: LICE_pixel; alpha: cfloat; mode: cint) {.importc, header: ReaperPluginFunctionsHeader.}
# proc LICE_FillCBezier(dest: ptr LICE_IBitmap; xstart: cdouble; ystart: cdouble; xctl1: cdouble; yctl1: cdouble; xctl2: cdouble; yctl2: cdouble; xend: cdouble; yend: cdouble; yfill: cint; color: LICE_pixel; alpha: cfloat; mode: cint; aa: bool; tol: cdouble) {.importc, header: ReaperPluginFunctionsHeader.}
proc LICE_FillCircle(dest: ptr LICE_IBitmap; cx: cfloat; cy: cfloat; r: cfloat; color: LICE_pixel; alpha: cfloat; mode: cint; aa: bool) {.importc, header: ReaperPluginFunctionsHeader.}
# proc LICE_FillConvexPolygon(dest: ptr LICE_IBitmap; x: ptr cint; y: ptr cint; npoints: cint; color: LICE_pixel; alpha: cfloat; mode: cint) {.importc, header: ReaperPluginFunctionsHeader.}
proc LICE_FillRect(dest: ptr LICE_IBitmap; x: cint; y: cint; w: cint; h: cint; color: LICE_pixel; alpha: cfloat; mode: cint) {.importc, header: ReaperPluginFunctionsHeader.}
# proc LICE_FillTrapezoid(dest: ptr LICE_IBitmap; x1a: cint; x1b: cint; y1: cint; x2a: cint; x2b: cint; y2: cint; color: LICE_pixel; alpha: cfloat; mode: cint) {.importc, header: ReaperPluginFunctionsHeader.}
# proc LICE_FillTriangle(dest: ptr LICE_IBitmap; x1: cint; y1: cint; x2: cint; y2: cint; x3: cint; y3: cint; color: LICE_pixel; alpha: cfloat; mode: cint) {.importc, header: ReaperPluginFunctionsHeader.}
# proc LICE_GetPixel(bm: ptr LICE_IBitmap; x: cint; y: cint): LICE_pixel {.importc, header: ReaperPluginFunctionsHeader.}
# proc LICE_GradRect(dest: ptr LICE_IBitmap; dstx: cint; dsty: cint; dstw: cint; dsth: cint; ir: cfloat; ig: cfloat; ib: cfloat; ia: cfloat; drdx: cfloat; dgdx: cfloat; dbdx: cfloat; dadx: cfloat; drdy: cfloat; dgdy: cfloat; dbdy: cfloat; dady: cfloat; mode: cint) {.importc, header: ReaperPluginFunctionsHeader.}
proc LICE_Line(dest: ptr LICE_IBitmap; x1: cfloat; y1: cfloat; x2: cfloat; y2: cfloat; color: LICE_pixel; alpha: cfloat; mode: cint; aa: bool) {.importc, header: ReaperPluginFunctionsHeader.}
# proc LICE_LineInt(dest: ptr LICE_IBitmap; x1: cint; y1: cint; x2: cint; y2: cint; color: LICE_pixel; alpha: cfloat; mode: cint; aa: bool) {.importc, header: ReaperPluginFunctionsHeader.}
# proc LICE_LoadPNG(filename: cstring; bmp: ptr LICE_IBitmap): ptr LICE_IBitmap {.importc, header: ReaperPluginFunctionsHeader.}
# proc LICE_LoadPNGFromResource(hInst: HINSTANCE; resid: cstring; bmp: ptr LICE_IBitmap): ptr LICE_IBitmap {.importc, header: ReaperPluginFunctionsHeader.}
# proc LICE_MeasureText(string: cstring; w: ptr cint; h: ptr cint) {.importc, header: ReaperPluginFunctionsHeader.}
# proc LICE_MultiplyAddRect(dest: ptr LICE_IBitmap; x: cint; y: cint; w: cint; h: cint; rsc: cfloat; gsc: cfloat; bsc: cfloat; asc: cfloat; radd: cfloat; gadd: cfloat; badd: cfloat; aadd: cfloat) {.importc, header: ReaperPluginFunctionsHeader.}
# proc LICE_PutPixel(bm: ptr LICE_IBitmap; x: cint; y: cint; color: LICE_pixel; alpha: cfloat; mode: cint) {.importc, header: ReaperPluginFunctionsHeader.}
# proc LICE_RotatedBlit(dest: ptr LICE_IBitmap; src: ptr LICE_IBitmap; dstx: cint; dsty: cint; dstw: cint; dsth: cint; srcx: cfloat; srcy: cfloat; srcw: cfloat; srch: cfloat; angle: cfloat; cliptosourcerect: bool; alpha: cfloat; mode: cint; rotxcent: cfloat; rotycent: cfloat) {.importc, header: ReaperPluginFunctionsHeader.}
# proc LICE_RoundRect(drawbm: ptr LICE_IBitmap; xpos: cfloat; ypos: cfloat; w: cfloat; h: cfloat; cornerradius: cint; col: LICE_pixel; alpha: cfloat; mode: cint; aa: bool) {.importc, header: ReaperPluginFunctionsHeader.}
# proc LICE_ScaledBlit(dest: ptr LICE_IBitmap; src: ptr LICE_IBitmap; dstx: cint; dsty: cint; dstw: cint; dsth: cint; srcx: cfloat; srcy: cfloat; srcw: cfloat; srch: cfloat; alpha: cfloat; mode: cint) {.importc, header: ReaperPluginFunctionsHeader.}
# proc LICE_SimpleFill(dest: ptr LICE_IBitmap; x: cint; y: cint; newcolor: LICE_pixel; comparemask: LICE_pixel; keepmask: LICE_pixel) {.importc, header: ReaperPluginFunctionsHeader.}

type
  Color* = object
    r*, g*, b*, a*: float

  BitmapMode = enum
    NoContext,
    WithContext,

  BlitMode* = enum
    Copy,
    Add,
    Dodge,
    Multiply,
    Overlay,
    HsvAdjust,
    ChannelCopy,

  BlitFilter* = enum
    None,
    Bilinear,

  Image* = object
    bitmapMode: BitmapMode
    width, height: Pixels
    licePtr: pointer

# const
#   LiceBlitModeMask = 0xff
#   LiceBlitFilterMask = 0xff00
#   LiceBlitIgnoreScaling = 0x20000
#   LiceBlitUseAlpha = 0x10000

{.push inline.}

func rgb*(r, g, b: float, a = 1.0): Color =
  Color(r: r, g: g, b: b, a: a)

func toLicePixel(color: Color): LICE_pixel =
  let
    r = color.r.toInt
    g = color.g.toInt
    b = color.b.toInt
    a = 255
  ((b and 0xff) or
  ((g and 0xff) shl 8) or
  ((r and 0xff) shl 16) or
  ((a and 0xff) shl 24)).uint32

func toLiceBitmapMode(mode: BitmapMode): cint =
  case mode:
  of NoContext: 0
  of WithContext: 1

func toLiceBlitFilter(filter: BlitFilter): cint =
  case filter:
  of None: 0
  of Bilinear: 1

func toLiceBlitMode(mode: BlitMode, filter = BlitFilter.None): cint =
  case mode:
  of Copy: 0 or filter.toLiceBlitFilter
  of Add: 1 or filter.toLiceBlitFilter
  of Dodge: 2 or filter.toLiceBlitFilter
  of Multiply: 3 or filter.toLiceBlitFilter
  of Overlay: 4 or filter.toLiceBlitFilter
  of HsvAdjust: 5 or filter.toLiceBlitFilter
  of ChannelCopy: 0xf0 or filter.toLiceBlitFilter

template liceBitmap(image: Image): untyped =
  cast[ptr LICE_IBitmap](image.licePtr)

func initImage*(width, height: Pixels): Image =
  result.width = width
  result.height = height
  result.bitmapMode = WithContext
  result.licePtr = LICE_CreateBitmap(result.bitmapMode.toLiceBitmapMode,
                                     width.toInt.cint,
                                     height.toInt.cint)

func `=destroy`(image: var Image) =
  if image.licePtr != nil:
    LICE_private_Destroy(image.liceBitmap)

func context*(image: Image): Option[HDC] =
  if image.licePtr != nil and image.bitmapMode == WithContext:
    return some(LICE_private_GetDC(image.liceBitmap))

func resize*(image: var Image, width, height: Pixels) =
  image.width = width
  image.height = height
  if image.licePtr != nil:
    discard LICE_private_resize(image.liceBitmap,
                                width.toInt.cint,
                                height.toInt.cint)

func width*(image: Image): Pixels =
  image.width

func height*(image: Image): Pixels  =
  image.height

func clear*(image: Image, color: Color) =
  if image.licePtr != nil:
    LICE_Clear(image.liceBitmap, color.toLicePixel)

func drawBitmap*(self, other: Image,
                 x, y = 0.Pixels,
                 mode = BlitMode.Copy,
                 filter = BlitFilter.None) =
  if self.licePtr != nil and other.licePtr != nil:
    LICE_Blit(
      self.liceBitmap,
      other.liceBitmap,
      x.toInt.cint, y.toInt.cint,
      0, 0,
      other.width.toInt.cint, other.height.toInt.cint,
      1.0,
      mode.toLiceBlitMode(filter),
    )

func fillRectangle*(image: Image,
                    x, y, width, height: Pixels,
                    color: Color,
                    mode = BlitMode.Copy) =
  if image.licePtr != nil:
    LICE_FillRect(
      image.liceBitmap,
      x.toInt.cint, y.toInt.cint,
      width.toInt.cint, height.toInt.cint,
      color.toLicePixel,
      color.a.cfloat,
      mode.toLiceBlitMode,
    )

func fillCircle*(image: Image,
                 x, y, radius: Pixels,
                 color: Color,
                 antiAlias = true,
                 mode = BlitMode.Copy) =
  if image.licePtr != nil:
    LICE_FillCircle(
      image.liceBitmap,
      x.cfloat, y.cfloat, radius.cfloat,
      color.toLicePixel,
      color.a.cfloat,
      mode.toLiceBlitMode,
      antiAlias,
    )

func drawLine*(image: Image,
               x1, y1, x2, y2: Pixels,
               color: Color,
               mode = BlitMode.Copy) =
  if image.licePtr != nil:
    LICE_Line(
      image.liceBitmap,
      x1.cfloat, y1.cfloat,
      x2.cfloat, y2.cfloat,
      color.toLicePixel,
      color.a.cfloat,
      mode.toLiceBlitMode,
      true,
    )

{.pop.}