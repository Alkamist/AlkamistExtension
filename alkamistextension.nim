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
  recho item.take(0).isSome
  recho item.take(5).isSome

createExtension:
  addAction("Alkamist: Relative Copy", "ALKAMIST_RELATIVE_COPY", relativeCopyAction)
  # addAction("Alkamist: Relative Paste", "ALKAMIST_RELATIVE_PASTE", relativePaste)