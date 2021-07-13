import reaper

{.link: "resource/resource.res".}

{.emit: """/*INCLUDESECTION*/
#define REAPERAPI_IMPLEMENT
""".}

# proc handleEvents(msg: ptr MSG, ctx: ptr accelerator_register_t): cint {.cdecl.} =
#   if msg.message in [WM_KEYDOWN, WM_SYSKEYDOWN, WM_KEYUP, WM_SYSKEYUP]:
#     let
#       keyCode = msg.wParam.int
#       key = CodeToKey[keyCode]

#     if msg.message in [WM_KEYDOWN, WM_SYSKEYDOWN]:
#       ShowConsoleMsg($key)

#     elif msg.message in [WM_KEYUP, WM_SYSKEYUP]:
#       ShowConsoleMsg($key)

# var accelerator = accelerator_register_t(translateAccel: handleEvents, isLocal: true)

# proc windowProc(unnamedParam1: HWND, unnamedParam2: UINT, unnamedParam3: WPARAM, unnamedParam4: LPARAM): INT_PTR {.stdcall.} =
#   discard

proc REAPER_PLUGIN_ENTRYPOINT(hInstance: HINSTANCE, rec: ptr reaper_plugin_info_t): cint {.codegenDecl: "REAPER_PLUGIN_DLL_EXPORT $# $#$#", exportc, dynlib.} =
  if rec != nil:
    if REAPERAPI_LoadAPI(rec.GetFunc) != 0:
      return 0

    # discard rec.Register("accelerator", addr accelerator)

    let testWindow = CreateDialog(hInstance, MAKEINTRESOURCE(100), nil, nil)
    if testWindow != nil:
      discard ShowWindow(testWindow, SW_SHOW)

    # ShowConsoleMsg("Alkamist Extension initialized.\n")

    return 1

  # discard rec.Register("-accelerator", addr accelerator)