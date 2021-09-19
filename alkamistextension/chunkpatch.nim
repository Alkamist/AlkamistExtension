import std/[options, tables, strutils]

type
  ChunkPatchLocation = seq[(string, int)]
  ChunkPatchSectionStack = seq[(string, CountTable[string])]

  ChunkPatchKind* {.pure.} = enum
    UpdateField, RemoveField, RemoveAll,

  ChunkPatch* = object
    case kind*: ChunkPatchKind
    of ChunkPatchKind.UpdateField:
      updateFieldLocation*: ChunkPatchLocation
      updateFieldName*: string
      updateFieldValues*: seq[Option[string]]
    of ChunkPatchKind.RemoveField:
      removeFieldLocation*: ChunkPatchLocation
      removeFieldName*: string
    of ChunkPatchKind.RemoveAll:
      removeAllName*: string

proc newSectionStack(): ChunkPatchSectionStack =
  @[("FINISH", initCountTable[string]())]

proc addSection(stack: var ChunkPatchSectionStack, section: string) =
  stack.add (section, initCountTable[string]())

proc currentLocation(stack: ChunkPatchSectionStack): ChunkPatchLocation =
  # Skip the top level "FINISH".
  for i in 1 ..< stack.len:
    let sectionName = stack[i][0]
    let sectionIndex = stack[i - 1][1][sectionName] - 1
    result.add (sectionName, sectionIndex)

proc patch*(chunk: string, commands: varargs[ChunkPatch]): string =
  ## Loops through a chunk string line by line a single time, and builds
  ## a new chunk string based on the commands passed in.

  var sectionStack = newSectionStack()

  for line in chunk.splitLines:
    let unindentedLine = line.unindent

    # Push new sections onto the section stack.
    if unindentedLine.startsWith('<'):
      let sectionName = unindentedLine.splitWhitespace[0].strip(true, false, {'<'})
      sectionStack[^1][1].inc(sectionName)
      sectionStack.addSection(sectionName)

    # Pop the section off of the section stack when it ends.
    if unindentedLine.startsWith('>'):
      discard sectionStack.pop()

    var patchedField = false

    # Check every command every line to see
    # if it needs to be processed.
    for command in commands:
      case command.kind:

      of ChunkPatchKind.UpdateField:
        if unindentedLine.startsWith(command.updateFieldName) and
           sectionStack.currentLocation == command.updateFieldLocation:
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
        if unindentedLine.startsWith(command.removeFieldName) and
           sectionStack.currentLocation == command.removeFieldLocation:
          patchedField = true

      of ChunkPatchKind.RemoveAll:
        if unindentedLine.startsWith(command.removeAllName):
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

proc removeField*(location: ChunkPatchLocation, name: string): ChunkPatch =
  ChunkPatch(kind: ChunkPatchKind.RemoveField,
    removeFieldLocation: location,
    removeFieldName: name,
  )

proc removeAll*(name: string): ChunkPatch =
  ChunkPatch(kind: ChunkPatchKind.RemoveAll,
    removeAllName: name,
  )

proc updateField*(location: ChunkPatchLocation,
                  name: string,
                  values: varargs[Option[string], toChunkField]): ChunkPatch =
  var valuesSeq = newSeq[Option[string]](values.len)
  for i, value in values:
    valuesSeq[i] = value
  ChunkPatch(kind: ChunkPatchKind.UpdateField,
    updateFieldLocation: location,
    updateFieldName: name,
    updateFieldValues: valuesSeq,
  )

proc updateField*(location: ChunkPatchLocation,
                  name: string,
                  indexValues: varargs[(int, Option[string]), toChunkIndexField]): ChunkPatch =
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
    updateFieldLocation: location,
    updateFieldName: name,
    updateFieldValues: valuesSeq,
  )

when isMainModule:
  const testChunk = readFile("alkamistextension/chunktest.txt")

  let patchedChunk = testChunk.patch(
    removeAll("GUID"),
    removeAll("IGUID"),
    removeAll("IID"),
    updateField(@[("TRACK", 0), ("ITEM", 2)], "POSITION", 300.5),
    # updateField("SEL", false),
    # updateField("PLAYRATE", (1, 10.1), (4, 0.03)),
  )

  echo patchedChunk