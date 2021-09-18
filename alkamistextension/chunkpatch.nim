import std/[options, strutils]

type
  ChunkPatchKind* {.pure.} = enum
    UpdateField, RemoveField,

  ChunkPatch* = object
    case kind*: ChunkPatchKind
    of ChunkPatchKind.UpdateField:
      updateFieldName*: string
      updateFieldValues*: seq[Option[string]]
    of ChunkPatchKind.RemoveField:
      removeFieldName*: string

proc patch*(chunk: string, commands: varargs[ChunkPatch]): string =
  for line in chunk.splitLines:
    let unindentedLine = line.unindent

    var patchedField = false
    for command in commands:
      case command.kind:

      of ChunkPatchKind.UpdateField:
        if unindentedLine.startsWith(command.updateFieldName):
          var originalFields: seq[string]
          var valueId = 0
          for value in unindentedLine.splitWhitespace:
            if valueId > 0:
              originalFields.add value
            inc valueId

          assert originalFields.len == command.updateFieldValues.len,
            "Unmatched field value count while patching chunk field values."

          let lastId = command.updateFieldValues.len - 1
          var fullValueString: string

          for fieldId, fieldValue in command.updateFieldValues:
            let finalFieldValue = block:
              if fieldValue.isSome: fieldValue.get
              else: originalFields[fieldId]

            fullValueString.add finalFieldValue
            if fieldId < lastId:
              fullValueString.add ' '

          result.add command.updateFieldName & ' ' & fullValueString & '\n'

          patchedField = true

      of ChunkPatchKind.RemoveField:
        if unindentedLine.startsWith(command.removeFieldName):
          patchedField = true

    if not patchedField:
      result.add unindentedLine & '\n'

proc formatRppXmlFloat*(value: SomeFloat): string =
  result = formatFloat(value)
  result.trimZeros()

proc toChunkField*(value: string): Option[string] = some value
proc toChunkField*(value: Option[string]): Option[string] = value
proc toChunkField*(value: SomeInteger): Option[string] = some $value
proc toChunkField*(value: SomeFloat): Option[string] = some formatRppXmlFloat(value)
proc toChunkField*(value: bool): Option[string] = some $value.int

proc removeField*(name: string): ChunkPatch =
  ChunkPatch(kind: ChunkPatchKind.RemoveField,
    removeFieldName: name,
  )

proc updateField*(name: string, values: varargs[Option[string], toChunkField]): ChunkPatch =
  var valuesSeq = newSeq[Option[string]](values.len)
  for i, value in values:
    valuesSeq[i] = value
  ChunkPatch(kind: ChunkPatchKind.UpdateField,
    updateFieldName: name,
    updateFieldValues: valuesSeq,
  )

# const testChunk = """
# <ITEM
#   POSITION 18.75
#   SNAPOFFS 0
#   LENGTH 1.875
#   LOOP 0
#   ALLTAKES 0
#   FADEIN 0 0 0 0 0 0 0
#   FADEOUT 0 0 0 0 0 0 0
#   MUTE 0 0
#   SEL 1
#   IGUID {54018701-31CA-47BC-B9E2-B6C80AB43AFE}
#   IID 2
#   NAME "untitled MIDI item-glued"
#   VOLPAN 1 0 1 -1
#   SOFFS 0 0
#   PLAYRATE 1 1 0 -1 0 0.0025
#   CHANMODE 0
#   GUID {56799207-6D3F-4C21-8132-83E1CF2CBCA3}
#   <SOURCE MIDI
#     HASDATA 1 5120 QN
#     CCINTERP 32
#     POOLEDEVTS {E429A158-441D-4D4A-93F1-46F913DDEA9A}
#     E 0 90 3c 60
#     E 2560 80 3c 00
#     E 2560 90 3c 60
#     E 2560 80 3c 00
#     E 2560 90 3c 60
#     E 2560 80 3c 00
#     E 2560 90 3c 60
#     E 2560 80 3c 00
#     E 2560 b0 7b 00
#     CCINTERP 32
#     CHASE_CC_TAKEOFFS 1
#     GUID {67CDD837-BB7E-4DCB-B059-DAFDFB4D1A69}
#     IGNTEMPO 0 120 4 4
#     SRCCOLOR 40
#     VELLANE -1 135 6
#     CFGEDITVIEW -3763.339804 0.032302 59 12 0 -1 0 0 0 0.5
#     KEYSNAP 0
#     TRACKSEL 311
#     EVTFILTER 0 -1 -1 -1 -1 0 0 0 0 -1 -1 -1 -1 0 -1 0 -1 -1
#     CFGEDIT 1 1 0 0 0 0 1 0 1 1 1 0.25 550 252 2438 1277 1 0 0 0 0.5 0 0 0 0 0.5 0 0 1 64
#   >
# >
# """

# let patchedChunk = testChunk.patch(
#   removeField "GUID",
#   removeField "IGUID",
#   removeField "IID",
#   updateField("POSITION", 300.5),
#   updateField("SEL", false),
#   updateField("PLAYRATE", none string, 10.1, none string, none string, none string, 0.03),
# )

# echo patchedChunk