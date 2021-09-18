import std/strutils

# proc formatRppXmlNumber(value: float): string =
#   result = formatFloat(value)
#   result.trimZeros()

type
  RpNodeKind* {.pure.} = enum
    Empty, Field, Section, Parameter,

  RpNode* = ref object
    case kind*: RpNodeKind
    of Empty: discard
    of Field: fieldValue*: string
    else: children*: seq[RpNode]

  RppXmlParser* = ref object
    data*: string
    location*: int

proc add*(n, child: RpNode) =
  n.children.add child

proc rpEmpty*(): RpNode = RpNode(kind: Empty)
proc rpField*(value: string): RpNode = RpNode(kind: Field, fieldValue: value)

template makeRpTree(k, c): untyped =
  result = RpNode(kind: k)
  for child in c:
    result.children.add child

proc rpSection*(children: varargs[RpNode]): RpNode = makeRpTree(RpNodeKind.Section, children)
proc rpParameter*(children: varargs[RpNode]): RpNode = makeRpTree(RpNodeKind.Parameter, children)

proc treeRepr*(n: RpNode): string =
  template printContainer(nodeName) =
    result = nodeName & ":\n"
    for i, child in n.children:
      result &= indent(child.treeRepr, 2)
      if i < n.children.len - 1:
        result &= "\n"

  case n.kind:
  of Empty: result = "Empty"
  of Field: result = n.fieldValue
  of Section: printContainer("Section")
  of Parameter: printContainer("Parameter")

proc toRppXml*(n: RpNode): string =
  case n.kind:
  of Empty: raise newException(IOError, "Empty nodes cannot be translated to RppXml.")
  of Field: result = n.fieldValue
  of Section:
    result.add '<'
    let lastId = n.children.len - 1
    for i, child in n.children:
      if i == 0:
        result.add child.toRppXml & '\n'
      else:
        result.add indent(child.toRppXml, 2) & '\n'
      if i >= lastId:
        result.add ">"
  of Parameter:
    let lastId = n.children.len - 1
    for i, child in n.children:
      result.add child.toRppXml
      if i < lastId:
        result.add " "

proc stringTo*(parser: RppXmlParser, i: int): string =
  parser.data[parser.location..i]

proc stringFrom*(parser: RppXmlParser, i: int): string =
  parser.data[i..parser.location]

proc chr*(parser: RppXmlParser, i = parser.location): char =
  parser.data[i]

proc step*(parser: RppXmlParser) =
  inc parser.location

proc stepBack*(parser: RppXmlParser) =
  dec parser.location

proc isAtEnd*(parser: RppXmlParser, i = parser.location): bool =
  i >= parser.data.len

proc isInBounds*(parser: RppXmlParser, i = parser.location): bool =
  i < parser.data.len

proc isSpace*(parser: RppXmlParser, i = parser.location): bool =
  parser.data[i] == ' '

proc isLineEnd*(parser: RppXmlParser, i = parser.location): bool =
  parser.data[i] == '\n'

proc isSectionStart*(parser: RppXmlParser, i = parser.location): bool =
  parser.data[i] == '<'

proc isSectionEnd*(parser: RppXmlParser, i = parser.location): bool =
  parser.data[i] == '>'

proc isStringEdge*(parser: RppXmlParser, i = parser.location): bool =
  parser.data[i] == '"'

proc parseField(parser: RppXmlParser): RpNode =
  result = rpEmpty()
  if parser.isAtEnd:
    return

  let start = parser.location

  let isString = parser.isStringEdge
  if isString:
    parser.step()

  while true:
    if isString:
      if parser.isStringEdge:
        break

      if parser.isLineEnd:
        parser.stepBack()
        break

      parser.step()
    else:
      if parser.isAtEnd or
         parser.isSpace or
         parser.isLineEnd:
        parser.stepBack()
        break

      parser.step()

  let valueString = parser.stringFrom(start)
  parser.step()

  result = rpField(valueString)

proc parseParameter(parser: RppXmlParser): RpNode =
  result = rpEmpty()
  if parser.isAtEnd:
    return

  let title = parser.parseField()
  result = rpParameter(title)

  var valueId = 0
  while true:
    if parser.isAtEnd:
      return

    case parser.chr:
    of ' ': parser.step()
    of '\n': return
    else: discard

    let value = parser.parseField()
    if value.kind == Empty:
      return

    result.add value

    inc valueId

proc parseSection(parser: RppXmlParser): RpNode =
  result = rpEmpty()
  if parser.isAtEnd:
    return

  if not parser.isSectionStart:
    return
  else:
    parser.step()

  result = rpSection()

  var sectionCount = 1
  while true:
    if parser.isAtEnd:
      return

    if parser.isSpace or parser.isLineEnd:
      parser.step()
      continue

    var n = parser.parseParameter()
    if n.kind != Empty:
      result.add n
      continue

    if parser.isSectionStart:
      inc sectionCount

    if parser.isSectionEnd:
      parser.step()
      dec sectionCount
      if sectionCount == 0:
        return

    n = parser.parseSection()
    if n.kind != Empty:
      result.add n
      continue

const testStr = """
<ITEM
  POSITION 18.75
  SNAPOFFS 0
  LENGTH 1.875
  LOOP 0
  ALLTAKES 0
  FADEIN 0 0 0 0 0 0 0
  FADEOUT 0 0 0 0 0 0 0
  MUTE 0 0
  SEL 1
  IGUID {54018701-31CA-47BC-B9E2-B6C80AB43AFE}
  IID 2
  NAME "untitled MIDI item-glued"
  VOLPAN 1 0 1 -1
  SOFFS 0 0
  PLAYRATE 1 1 0 -1 0 0.0025
  CHANMODE 0
  GUID {56799207-6D3F-4C21-8132-83E1CF2CBCA3}
  <SOURCE MIDI
    HASDATA 1 5120 QN
    CCINTERP 32
    POOLEDEVTS {E429A158-441D-4D4A-93F1-46F913DDEA9A}
    E 0 90 3c 60
    E 2560 80 3c 00
    E 2560 90 3c 60
    E 2560 80 3c 00
    E 2560 90 3c 60
    E 2560 80 3c 00
    E 2560 90 3c 60
    E 2560 80 3c 00
    E 2560 b0 7b 00
    CCINTERP 32
    CHASE_CC_TAKEOFFS 1
    GUID {67CDD837-BB7E-4DCB-B059-DAFDFB4D1A69}
    IGNTEMPO 0 120 4 4
    SRCCOLOR 40
    VELLANE -1 135 6
    CFGEDITVIEW -3763.339804 0.032302 59 12 0 -1 0 0 0 0.5
    KEYSNAP 0
    TRACKSEL 311
    EVTFILTER 0 -1 -1 -1 -1 0 0 0 0 -1 -1 -1 -1 0 -1 0 -1 -1
    CFGEDIT 1 1 0 0 0 0 1 0 1 1 1 0.25 550 252 2438 1277 1 0 0 0 0.5 0 0 0 0 0.5 0 0 1 64
  >
>
"""

# var p = RppXmlParser()
# p.location = 0
# p.data = testStr
# echo p.parseSection().toRppXml