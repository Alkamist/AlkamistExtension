import std/strutils

let fullFile = readFile("../src/reaper/reaper_cpp/reaper_plugin_functions.h")

var
  count = 0
  functionPointers = ""

for line in fullFile.splitLines:
  var strippedLine = line.strip(trailing=false)

  if strippedLine.startsWith("#ifdef REAPERAPI_IMPLEMENT"):
    if count > 0:
      break
    count += 1

  let skipLine =
    line.len < 2 or
    line.startsWith("*") or
    strippedLine.startsWith("/*") or
    strippedLine.startsWith("//") or
    strippedLine.startsWith("class") or
    strippedLine.startsWith("#if") or
    strippedLine.startsWith("#endif") or
    strippedLine.startsWith("#else") or
    strippedLine.startsWith("#undef") or
    strippedLine.startsWith("#include") or
    strippedLine.startsWith("#define") or
    strippedLine.startsWith("REAPERAPI_DEF")

  if not skipLine:
    functionPointers.add strippedLine & "\n"

var output = ""
for line in functionPointers.splitLines:
  var
    i = 0
    isRemovingFunctionPointer = false
    removedFunctionPointer = false

  while i < line.len:
    if not removedFunctionPointer and
       line[i] == '(' and
       i + 1 < line.len and
       line[i + 1] == '*':
      isRemovingFunctionPointer = true
      i += 2

    if isRemovingFunctionPointer and
       line[i] == ')':
      isRemovingFunctionPointer = false
      removedFunctionPointer = true
      i += 1

    output.add line[i]
    i += 1

  output.add "\n"

writeFile("stripped_functions.h", output)