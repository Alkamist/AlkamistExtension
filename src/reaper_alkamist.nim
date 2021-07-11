import win_api, reaper_api

{.emit: """/*INCLUDESECTION*/
#define REAPERAPI_IMPLEMENT
""".}

type
  ReaperPluginInfo* {.importc: "struct reaper_plugin_info_t", header: ReaperHeader.} = object
    caller_version*: cint
    hwnd_main*: HWND
    Register*: proc(name: cstring, infostruct: pointer): cint {.cdecl.}
    GetFunc*: proc(name: cstring): pointer {.cdecl.}

  AcceleratorRegister* {.importc: "struct accelerator_register_t", header: ReaperHeader.} = object
    translateAccel*: proc(msg: ptr MSG, ctx: ptr AcceleratorRegister): cint {.cdecl.}
    isLocal*: bool
    user*: pointer

proc REAPERAPI_LoadAPI(getAPI: proc(name: cstring): pointer {.cdecl.}): cint {.importc, header: ReaperHeader.}

proc handleEvents(msg: ptr MSG, ctx: ptr AcceleratorRegister): cint {.cdecl.} =
  case msg.message:
  of WM_KEYDOWN: ShowConsoleMsg("Key Down\n")
  of WM_KEYUP: ShowConsoleMsg("Key Up\n")
  else: discard

var accelerator = AcceleratorRegister(translateAccel: handleEvents, isLocal: true)

proc REAPER_PLUGIN_ENTRYPOINT(hInstance: HINSTANCE, rec: ptr ReaperPluginInfo): cint {.codegenDecl: "REAPER_PLUGIN_DLL_EXPORT $# $#$#", exportc, dynlib.} =
  if rec != nil:
    if REAPERAPI_LoadAPI(rec.GetFunc) != 0:
      return 0

    discard rec.Register("accelerator", addr accelerator)

    ShowConsoleMsg("Minimal extension loaded\n")

    discard rec.Register("-accelerator", addr accelerator)

    return 1