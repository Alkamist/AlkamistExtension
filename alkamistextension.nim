import reaper
import alkamistextension/[reaperwrapper, relativecopy]

proc relativeCopyAction =
  let project = currentProject()
  project.relativeCopyItems(project.editCursorTime)

proc relativePasteAction =
  let project = currentProject()
  project.relativePasteItems(project.editCursorTime, 1.0, 0.0)
  updateArrange()

createExtension:
  addAction("Alkamist: Relative Copy", "ALKAMIST_RELATIVE_COPY", relativeCopyAction)
  addAction("Alkamist: Relative Paste", "ALKAMIST_RELATIVE_PASTE", relativePasteAction)