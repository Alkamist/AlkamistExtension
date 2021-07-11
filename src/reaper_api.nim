const ReaperHeader* = "reaper/reaper_plugin_functions.h"

proc ShowConsoleMsg*(msg: cstring) {.importc, header: ReaperHeader.}