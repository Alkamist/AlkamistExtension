import reaper


import alkamistextension/[reaperwrapper, relativecopy]

proc relativeCopyAction =
  let project = currentProject()
  project.relativeCopyItems(project.editCursorTime)

proc relativePasteAction =
  let project = currentProject()
  project.relativePasteItems(project.editCursorTime, 0.5, 0.0)
  updateArrange()


# import alkamistextension/reaperwrapper

# proc relativeCopyAction =
#   let project = currentProject()
#   let timeSelectionBounds = project.timeSelectionBounds
#   if timeSelectionBounds.isSome:
#     recho project.averageTempoOfTimeRange(timeSelectionBounds.get.left, timeSelectionBounds.get.right)

# proc relativePasteAction =
#   discard


createExtension:
  addAction("Alkamist: Relative Copy", "ALKAMIST_RELATIVE_COPY", relativeCopyAction)
  addAction("Alkamist: Relative Paste", "ALKAMIST_RELATIVE_PASTE", relativePasteAction)