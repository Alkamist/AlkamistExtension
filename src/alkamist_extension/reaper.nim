import
  std/tables,
  reaper/[winapi, types, functions]

export
  tables,
  winapi, types, functions

template createReaperExtension*(initCode: untyped): untyped =
  {.link: "resource/resource.res".}

  {.emit: """/*INCLUDESECTION*/
  #define REAPERAPI_IMPLEMENT
  """.}

  var
    hInstance {.inject.}: HINSTANCE
    pluginInfo {.inject.}: ptr reaper_plugin_info_t
    actionProcs {.inject.} = initTable[int, proc()]()

  proc hookCommand(command: cint, flag: cint): bool =
    if command != 0 and actionProcs.contains(command):
      actionProcs[command]()
      return true

  proc addAction(name, id: cstring, fn: proc()) {.inject.} =
    var
      commandId = pluginInfo.Register("command_id", unsafeAddr id)
      accelReg: gaccel_register_t

    accelReg.desc = name
    accelReg.accel.cmd = commandId.uint16

    discard pluginInfo.Register("gaccel", addr accelReg)
    actionProcs[commandId] = fn

  proc REAPER_PLUGIN_ENTRYPOINT(hInst: HINSTANCE, rec: ptr reaper_plugin_info_t): cint {.codegenDecl: "REAPER_PLUGIN_DLL_EXPORT $# $#$#", exportc, dynlib.} =
    hInstance = hInst
    pluginInfo = rec

    if pluginInfo != nil:
      if REAPERAPI_LoadAPI(pluginInfo.GetFunc) != 0:
        return 0

      discard pluginInfo.Register("hookcommand", hookCommand)

      initCode

      return 1