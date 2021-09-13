import reaper
import alkamistextension/[reaperwrapper, relativecopy]

proc relativeCopyAction =
  let project = currentProject()
  project.relativeCopyItems(project.editCursorTime)

proc relativePasteAction =
  let project = currentProject()
  project.relativePasteItems(project.editCursorTime, 1.0, 0.0)
  updateArrange()

# import alkamistextension/reaperwrapper

# proc relativeCopyAction =
#   let project = currentProject()
#   let item = project.selectedItem(0).get
#   recho project.averageTempoOfTimeRange(item.positionTime, item.rightTime)

# proc relativePasteAction =
#   discard

createExtension:
  addAction("Alkamist: Relative Copy", "ALKAMIST_RELATIVE_COPY", relativeCopyAction)
  addAction("Alkamist: Relative Paste", "ALKAMIST_RELATIVE_PASTE", relativePasteAction)