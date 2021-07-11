import header, winapi

export winapi

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

proc REAPERAPI_LoadAPI*(getAPI: proc(name: cstring): pointer {.cdecl.}): cint {.importc, header: ReaperHeader.}