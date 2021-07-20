import
  std/[tables, options],
  input/[keyboard],
  reaper/[winapi, types, functions, window]

export
  tables,
  winapi, types, functions, window

var
  hInstance*: HINSTANCE
  pluginInfo*: ptr reaper_plugin_info_t
  actionProcs = initTable[int, proc()]()
  keyListeners: seq[proc(keyKind: KeyKind, isDown: bool)]

var accelReg = accelerator_register_t(isLocal: true, user: nil,
  translateAccel: proc(msg: ptr MSG, ctx: ptr accelerator_register_t): cint {.cdecl.} =
    case msg.message:

    of WM_KEYDOWN, WM_SYSKEYDOWN:
      let keyKind = msg.wParam.int.toKeyKind
      if keyKind.isSome:
        for listener in keyListeners:
          listener(keyKind.get, true)

    of WM_KEYUP, WM_SYSKEYUP:
      let keyKind = msg.wParam.int.toKeyKind
      if keyKind.isSome:
        for listener in keyListeners:
          listener(keyKind.get, false)

    else:
      discard
)

proc addKeyListener*(listener: proc(keyKind: KeyKind, isDown: bool)) =
  keyListeners.add listener

proc hookCommand(command: cint, flag: cint): bool =
  if command != 0 and actionProcs.contains(command):
    actionProcs[command]()
    return true

proc addAction*(name, id: cstring, fn: proc()) =
  var
    commandId = pluginInfo.Register("command_id", unsafeAddr id)
    accelReg: gaccel_register_t

  accelReg.desc = name
  accelReg.accel.cmd = commandId.uint16

  discard pluginInfo.Register("gaccel", addr accelReg)
  actionProcs[commandId] = fn

proc newWindow*(): Window =
  newWindow(hInstance, pluginInfo.hwnd_main)

template createExtension*(initCode: untyped): untyped =
  {.link: "resource/resource.res".}

  {.emit: """/*INCLUDESECTION*/
  #define REAPERAPI_IMPLEMENT
  """.}

  proc REAPER_PLUGIN_ENTRYPOINT(hInst: HINSTANCE, rec: ptr reaper_plugin_info_t): cint {.codegenDecl: "REAPER_PLUGIN_DLL_EXPORT $# $#$#", exportc, dynlib.} =
    hInstance = hInst
    pluginInfo = rec

    if pluginInfo != nil:
      if REAPERAPI_LoadAPI(pluginInfo.GetFunc) != 0:
        return 0

      discard rec.Register("accelerator", addr accelReg)
      discard pluginInfo.Register("hookcommand", hookCommand)

      initCode

      return 1

    discard rec.Register("-accelerator", addr accelReg)