import std/strutils

type
  RpNodeKind* {.pure.} = enum
    Empty, Identifier, String, Number, BinaryData,
    Id, Section, Parameter,

  RpNode* = ref object
    case kind*: RpNodeKind
    of Empty: discard
    of Identifier: identifierValue*: string
    of String: stringValue*: string
    of Number: numberValue*: float
    of BinaryData: binaryDataValue*: string
    of Id: idValue*: string
    else: children*: seq[RpNode]

  RppXmlParser* = ref object
    data*: string
    location*: int

proc add*(n, child: RpNode) =
  n.children.add child

proc rpEmpty*(): RpNode = RpNode(kind: Empty)
proc rpIdentifier*(value: string): RpNode = RpNode(kind: Identifier, identifierValue: value)
proc rpString*(value: string): RpNode = RpNode(kind: String, stringValue: value)
proc rpNumber*(value: float): RpNode = RpNode(kind: Number, numberValue: value)
proc rpBinaryData*(value: string): RpNode = RpNode(kind: BinaryData, binaryDataValue: value)
proc rpId*(value: string): RpNode = RpNode(kind: Id, idValue: value)

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
  of Identifier: result = n.identifierValue
  of String: result = n.stringValue
  of Number: result = $n.numberValue
  of BinaryData: result = n.binaryDataValue
  of Id: result = n.idValue
  of Section: printContainer("Section")
  of Parameter: printContainer("Parameter")

proc formatRppXmlNumber(value: float): string =
  result = formatFloat(value)
  result.trimZeros()

proc toRppXml*(n: RpNode): string =
  case n.kind:
  of Empty: raise newException(IOError, "Empty nodes cannot be translated to RppXml.")
  of Identifier: result = n.identifierValue
  of String: result = n.stringValue
  of Number: result = formatRppXmlNumber(n.numberValue)
  of BinaryData: result = n.binaryDataValue
  of Id: result = n.idValue
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

proc parseValue(parser: RppXmlParser): RpNode =
  result = rpEmpty()
  if parser.isAtEnd:
    return

  let valueKind = block:
    case parser.chr:
    of '-', '0'..'9': Number
    of 'A'..'Z', 'a'..'z': Identifier
    of '{': Id
    of '"': String
    else: return

  let start = parser.location
  if valueKind == String:
    parser.step()

  while true:
    case valueKind:
    of String:
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

  case valueKind:
  of Number: result = rpNumber(parseFloat(valueString))
  of Id: result = rpId(valueString)
  of String: result = rpString(valueString)
  of Identifier: result = rpIdentifier(valueString)
  else: discard

proc parseParameter(parser: RppXmlParser): RpNode =
  result = rpEmpty()
  if parser.isAtEnd:
    return

  let title = parser.parseValue()
  if title.kind != Identifier:
    return

  result = rpParameter(title)

  while true:
    if parser.isAtEnd:
      return

    case parser.chr:
    of ' ': parser.step()
    of '\n': return
    else: discard

    let value = parser.parseValue()
    if value.kind == Empty:
      return

    result.add value

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
  POSITION 201.29032258060761
  SNAPOFFS 0
  LENGTH 0.11709634618074
  LOOP 0
  ALLTAKES 0
  FADEIN 0 0 0 0 0 0
  FADEOUT 0 0.093363 0 0 0 0
  MUTE 0
  SEL 0
  IGUID {3304A213-BB48-4B96-A8EB-071AFC8A9523}
  IID 362387
  NAME OsirisN2hihat2.wav
  VOLPAN 1 0 1 -1
  SOFFS 0
  PLAYRATE 1.00000000000058 0 0 -1 0 0.0025
  CHANMODE 2
  GUID {D4948180-F4E0-44F1-A507-47561CC5F9DF}
  <SOURCE WAVE
    FILE "F:\Music Libraries\Dave40\VinylSoundtrackSamples\VinylNov02 ok\OsirisN2hihat2.wav"
  >
>
"""

var p = RppXmlParser()
p.location = 0
p.data = testStr
echo p.parseSection().toRppXml