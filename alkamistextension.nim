import reaper


# import alkamistextension/[reaperwrapper, relativecopy]

# proc relativeCopyAction =
#   let project = currentProject()
#   project.relativeCopyItems(project.editCursorTime)

# proc relativePasteAction =
#   preventUiRefresh(true)
#   let project = currentProject()
#   # for i in 0 ..< 100:
#   #   project.relativePasteItems(project.editCursorTime + i.float, 1.0, 0.0)
#   project.relativePasteItems(project.editCursorTime, 1.0, 0.0)
#   preventUiRefresh(false)
#   updateArrange()


import alkamistextension/reaperwrapper

proc relativeCopyAction =
  let project = currentProject()
  recho project.selectedItem(0).get.stateChunk


createExtension:
  addAction("Alkamist: Relative Copy", "ALKAMIST_RELATIVE_COPY", relativeCopyAction)
  # addAction("Alkamist: Relative Paste", "ALKAMIST_RELATIVE_PASTE", relativePasteAction)