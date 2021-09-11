import reaper
import alkamistextension/[reaperwrapper, region]

# var lastChangeCount: Option[cint]
# proc timerProc =
#   if lastChangeCount.isNone:
#     lastChangeCount = some GetProjectStateChangeCount(nil)
#   else:
#     let changeCount = GetProjectStateChangeCount(nil)
#     if changeCount != lastChangeCount.get:
#       let asdf = changeCount - lastChangeCount.get
#       ShowConsoleMsg($asdf & "\n")
#     lastChangeCount = some changeCount

var reg: Region

proc copyRegion =
  let project = currentProject()
  reg.reset()
  reg.project = project
  reg.position = project.editCursorPosition
  for item in project.selectedItems:
    reg.items.add item

proc pasteRegion =
  let project = currentProject()
  preventUiRefresh(true)
  reg.copyContent()
  reg.pasteContent(project.editCursorPosition)
  preventUiRefresh(false)

createExtension:
  addAction("Alkamist: Copy Region", "ALKAMIST_COPY_REGION", copyRegion)
  addAction("Alkamist: Paste Region", "ALKAMIST_PASTE_REGION", pasteRegion)
  # addTimerProc(timerProc)