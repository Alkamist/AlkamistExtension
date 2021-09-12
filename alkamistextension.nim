import reaper
import alkamistextension/[reaperwrapper, relativecopy]

proc relativeCopyAction =
  let project = currentProject()
  project.relativeCopyItems(project.editCursorPosition)

# proc relativePaste =
  # let project = currentProject()
  # project.relativePasteItems(project.editCursorPosition)

createExtension:
  addAction("Alkamist: Relative Copy", "ALKAMIST_RELATIVE_COPY", relativeCopyAction)
  # addAction("Alkamist: Relative Paste", "ALKAMIST_RELATIVE_PASTE", relativePaste)