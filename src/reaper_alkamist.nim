import reaper/[plugin, functions]

{.emit: """/*INCLUDESECTION*/
#define REAPERAPI_IMPLEMENT
""".}

proc handleEvents(msg: ptr MSG, ctx: ptr accelerator_register_t): cint {.cdecl.} =
  case msg.message:
  of WM_KEYDOWN: ShowConsoleMsg("Key Down\n")
  of WM_KEYUP: ShowConsoleMsg("Key Up\n")
  else: discard

var accelerator = accelerator_register_t(translateAccel: handleEvents, isLocal: true)

proc REAPER_PLUGIN_ENTRYPOINT(hInstance: HINSTANCE, rec: ptr reaper_plugin_info_t): cint {.codegenDecl: "REAPER_PLUGIN_DLL_EXPORT $# $#$#", exportc, dynlib.} =
  if rec != nil:
    if REAPERAPI_LoadAPI(rec.GetFunc) != 0:
      return 0

    discard rec.Register("accelerator", addr accelerator)

    ShowConsoleMsg("Minimal extension loaded\n")

    return 1

  discard rec.Register("-accelerator", addr accelerator)