# import std/[tables, sequtils]

# export tables

type
  MouseButton* {.pure.} = enum
    Left,
    Middle,
    Right,
    Side1,
    Side2,

# proc toBiTable[K, V](entries: openArray[(K, V)]): (Table[K, V], Table[V, K]) =
#   let reverseEntries = entries.mapIt((it[1], it[0]))
#   result = (entries.toTable(), reverseEntries.toTable())

# const (mouseButtonCodes*, codeMouseButtons*) = {
#   MouseButton.Left: 0x0001,
#   MouseButton.Middle: 0x0010,
#   MouseButton.Right: 0x0002,
#   MouseButton.Side1: 0x0020,
#   MouseButton.Side2: 0x0040,
# }.toBiTable