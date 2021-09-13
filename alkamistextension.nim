import reaper
import alkamistextension/reaperwrapper

# proc relativeCopyAction =
#   let project = currentProject()
#   project.relativeCopyItems(project.editCursorPosition)

# proc relativePaste =
  # let project = currentProject()
  # project.relativePasteItems(project.editCursorPosition)

proc relativeCopyAction =
  let project = currentProject()
  let item = project.selectedItem(0).get

  # recho "snapPositionTime: " & $item.snapPositionTime
  # recho "snapPositionBeats: " & $item.snapPositionBeats

createExtension:
  addAction("Alkamist: Relative Copy", "ALKAMIST_RELATIVE_COPY", relativeCopyAction)
  # addAction("Alkamist: Relative Paste", "ALKAMIST_RELATIVE_PASTE", relativePaste)