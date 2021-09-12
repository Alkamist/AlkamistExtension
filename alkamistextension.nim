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
  let timeSelection = project.timeSelectionBounds
  if timeSelection.isSome:
    recho project.timeRangeContainsTempoChange(timeSelection.get.left, timeSelection.get.right)
    # recho project.averageTempoOfTimeRange(timeSelection.get.left, timeSelection.get.right)

createExtension:
  addAction("Alkamist: Relative Copy", "ALKAMIST_RELATIVE_COPY", relativeCopyAction)
  # addAction("Alkamist: Relative Paste", "ALKAMIST_RELATIVE_PASTE", relativePaste)