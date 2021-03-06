import std/strutils
import reaper
import types

proc recho*(args: varargs[string, `$`]) =
  ShowConsoleMsg(args.join(" ") & "\n")

proc updateArrange* =
  UpdateArrange()

var uiRefreshPrevented = false
proc preventUiRefresh*(shouldPrevent: bool) =
  if shouldPrevent and not uiRefreshPrevented:
    PreventUIRefresh(1)
    uiRefreshPrevented = true
  elif not shouldPrevent and uiRefreshPrevented:
    PreventUIRefresh(-1)
    uiRefreshPrevented = false

proc mainCommand*(id: int) =
  Main_OnCommand(id.cint, 0)

proc mainCommand*(id: string) =
  Main_OnCommand(NamedCommandLookup(id), 0)

proc currentProject*: Project =
  EnumProjects(-1, nil, 0)

proc currentTempo*: float =
  Master_GetTempo()

proc showMessageBox*(title, msg: string, kind = MessageBoxKind.Ok) =
  discard ShowMessageBox(msg, title, kind.cint)