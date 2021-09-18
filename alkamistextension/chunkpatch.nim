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
  ## Loops through a chunk string line by line a single time, and builds
  ## a new chunk string based on the commands passed in.

  for line in chunk.splitLines:
    let unindentedLine = line.unindent
    var patchedField = false

    # Check every command every line to see
    # if it needs to be processed.
    for command in commands:
      case command.kind:

      of ChunkPatchKind.UpdateField:
        if unindentedLine.startsWith(command.updateFieldName):
          # Keep a record of the original fields without the title.
          var originalFields: seq[string]
          var valueId = 0
          for value in unindentedLine.splitWhitespace:
            if valueId > 0:
              originalFields.add value
            inc valueId

          let lastId = originalFields.len - 1

          var fullValueString: string

          # Start building the final value string by choosing between
          # original field value and updated values based on whether
          # or not they are provided in the command.
          for fieldId, fieldValue in command.updateFieldValues:
            let finalFieldValue = block:
              if fieldValue.isSome: fieldValue.get
              else: originalFields[fieldId]

            fullValueString.add finalFieldValue

            # Only add a space at the end of each value if it is the
            # very last value of the field.
            if fieldId < lastId:
              fullValueString.add ' '

          # If the command values don't cover every original field,
          # then loop through the rest of the original fields and
          # finish the value string.
          for fieldId in command.updateFieldValues.len .. lastId:
            fullValueString.add originalFields[fieldId]
            if fieldId < lastId:
              fullValueString.add ' '

          result.add command.updateFieldName & ' ' & fullValueString & '\n'

          patchedField = true

      of ChunkPatchKind.RemoveField:
        # Simply mark the field as having been patched so it isn't re-added.
        if unindentedLine.startsWith(command.removeFieldName):
          patchedField = true

    # Add back any unpatched fields.
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

proc toChunkIndexField*[T](value: (int, T)): (int, Option[string]) =
  (value[0], value[1].toChunkField)

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

proc updateField*(name: string, indexValues: varargs[(int, Option[string]), toChunkIndexField]): ChunkPatch =
  var highestId = 0
  for indexValue in indexValues:
    if indexValue[0] > highestId:
      highestId = indexValue[0]

  let valuesLen = highestId + 1
  var valuesSeq = newSeq[Option[string]](valuesLen)

  for i in 0 ..< valuesLen:
    var value: Option[string]
    for indexValue in indexValues:
      if indexValue[0] == i:
        value = indexValue[1]

    valuesSeq[i] = value

  ChunkPatch(kind: ChunkPatchKind.UpdateField,
    updateFieldName: name,
    updateFieldValues: valuesSeq,
  )

when isMainModule:
  const testChunk = """
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

  let patchedChunk = testChunk.patch(
    removeField("GUID"),
    removeField("IGUID"),
    removeField("IID"),
    updateField("POSITION", 300.5),
    updateField("SEL", false),
    updateField("PLAYRATE", (1, 10.1), (4, 0.03)),
  )

  echo patchedChunk