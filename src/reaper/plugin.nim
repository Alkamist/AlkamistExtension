import types, winapi

export winapi

type
  reaper_plugin_info_t* {.importc, header: ReaperHeader.} = object
    caller_version*: cint
    hwnd_main*: HWND
    Register*: proc(name: cstring, infostruct: pointer): cint {.cdecl.}
    GetFunc*: proc(name: cstring): pointer {.cdecl.}

  accelerator_register_t* {.importc, header: ReaperHeader.} = object
    translateAccel*: proc(msg: ptr MSG, ctx: ptr accelerator_register_t): cint {.cdecl.}
    isLocal*: bool
    user*: pointer

proc REAPERAPI_LoadAPI*(getAPI: proc(name: cstring): pointer {.cdecl.}): cint {.importc, header: ReaperHeader.}