import reaper


# import alkamistextension/[reaperwrapper, relativecopy]

# proc relativeCopyAction =
#   let project = currentProject()
#   project.relativeCopyItems(project.editCursorTime)

# proc relativePasteAction =
#   preventUiRefresh(true)
#   let project = currentProject()
#   for i in 0 ..< 100:
#     project.relativePasteItems(project.editCursorTime + i.float, 1.0, 0.0)
#   preventUiRefresh(false)
#   updateArrange()

import std/times
import alkamistextension/reaperwrapper

# proc stateChunk(track: Track): string =
#   result = newString(1024)
#   while true:
#     let chunkLength = result.len
#     discard GetTrackStateChunk(track, result, chunkLength.cint, false)

#     let endPos = result.find('\0')
#     if endpos < chunkLength - 1:
#       result.setLen(endpos)
#       return result

#     if chunkLength > 100 shl 20:
#       raise newException(IOError, "The track chunk size exceeded the 100 MiB limit.")

#     result.setLen(chunkLength * 2)

proc stateChunk(item: Item): string =
  result = newString(1024)
  while true:
    let chunkLength = result.len
    discard GetItemStateChunk(item, result, chunkLength.cint, false)

    let endPos = result.find('\0')
    if endpos < chunkLength - 1:
      result.setLen(endpos)
      return result

    if chunkLength > 100 shl 20:
      raise newException(IOError, "The media item chunk size exceeded the 100 MiB limit.")

    result.setLen(chunkLength * 2)

proc relativeCopyAction =
  preventUiRefresh(true)

  let project = currentProject()

  let t = cpuTime()

  for item in project.selectedItems:
    let itemTrack = item.track
    let itemPosition = item.positionTime
    let chunk = item.stateChunk
    for i in 0 ..< 1000:
      let pastedItem = AddMediaItemToTrack(itemTrack)
      discard SetItemStateChunk(pastedItem, chunk, false)
      pastedItem.positionTime = itemPosition + i.float

  preventUiRefresh(false)

  recho cpuTime() - t

proc relativePasteAction =
  discard


createExtension:
  addAction("Alkamist: Relative Copy", "ALKAMIST_RELATIVE_COPY", relativeCopyAction)
  addAction("Alkamist: Relative Paste", "ALKAMIST_RELATIVE_PASTE", relativePasteAction)