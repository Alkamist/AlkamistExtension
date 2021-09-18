import reaper


import alkamistextension/[reaperwrapper, relativecopy]

proc relativeCopyAction =
  let project = currentProject()
  project.relativeCopyItems(project.editCursorTime)

proc relativePasteAction =
  preventUiRefresh(true)
  let project = currentProject()
  # for i in 0 ..< 100:
  #   project.relativePasteItems(project.editCursorTime + i.float, 1.0, 0.0)
  project.relativePasteItems(project.editCursorTime, 1.0, 0.0)
  preventUiRefresh(false)
  updateArrange()


# import std/strutils
# import alkamistextension/reaperwrapper

# proc isIdLine*(line: string): bool =
#   let unindentedLine = line.unindent
#   unindentedLine.startsWith("IGUID") or
#   unindentedLine.startsWith("GUID") or
#   unindentedLine.startsWith("IID")

# proc stripStateChunkIds*(chunk: string): string =
#   for line in chunk.splitLines:
#     if not line.isIdLine:
#       result.add line & '\n'

# proc relativeCopyAction =
#   let project = currentProject()
#   for item in project.selectedItems:
#     recho item.stateChunk.stripStateChunkIds


createExtension:
  addAction("Alkamist: Relative Copy", "ALKAMIST_RELATIVE_COPY", relativeCopyAction)
  addAction("Alkamist: Relative Paste", "ALKAMIST_RELATIVE_PASTE", relativePasteAction)