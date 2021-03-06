import os

let
  outputName = "reaper_alkamist"
  pluginsDir = getHomeDir() / "AppData" / "Roaming" / "REAPER" / "UserPlugins"

if not pluginsDir.dirExists:
  raise newException(OSError, "Could not find Reaper user plugins directory: " & pluginsDir)

cd thisDir()
cd ".."

proc buildDll =
  exec "nim cpp -d:release --app:lib --cc:vcc " &
       "--o:" & outputName.toDll & " " &
       "--outdir:" & pluginsDir & " " &
       "alkamistextension.nim"

proc removeExtraFiles =
  rmFile(pluginsDir / outputName & ".exp")
  rmFile(pluginsDir / outputName & ".lib")

proc launchReaper =
  let
    reaperDir = "C:" / "Program Files" / "REAPER (x64)"
    reaperFile = reaperDir / "reaper".toExe

  if not reaperDir.dirExists: raise newException(OSError, "Could not find Reaper directory: " & reaperDir)
  if not reaperFile.fileExists: raise newException(OSError, "Could not find Reaper file: " & reaperFile)

  discard gorgeEx reaperFile

buildDll()
removeExtraFiles()
# launchReaper()