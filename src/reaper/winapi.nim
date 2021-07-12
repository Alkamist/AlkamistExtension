# const winUnicode* = not (defined(useWinAnsi) or defined(winansi))

{.passL:"user32.lib".}

when defined(cpu64):
  type
    INT_PTR* {.importc.} = clonglong
    UINT_PTR* {.importc.} = culonglong
    LONG_PTR* {.importc.} = clonglong
    ULONG_PTR* {.importc.} = culonglong
else:
  type
    INT_PTR* {.importc.} = cint
    UINT_PTR* {.importc.} = cuint
    LONG_PTR* {.importc.} = clong
    ULONG_PTR* {.importc.} = culong

type
  BOOL* {.importc.} = cint
  CHAR* {.importc.} = cchar
  WORD* {.importc.} = cshort
  INT* {.importc.} = cint
  LONG* {.importc.} = clong
  BYTE* {.importc.} = cuchar
  UCHAR* {.importc.} = cuchar
  USHORT* {.importc.} = cushort
  WCHAR* {.importc.} = cuint
  UINT* {.importc.} = cuint
  ULONG* {.importc.} = culong
  DWORD* {.importc.} = culong
  FLOAT* {.importc.} = cfloat
  WPARAM* {.importc.} = UINT_PTR
  LPARAM* {.importc.} = LONG_PTR
  LRESULT* {.importc.} = LONG_PTR
  LPSTR* {.importc.} = cstring
  LPCSTR* {.importc.} = cstring
  LPWSTR* {.importc.} = cstring
  LPCWSTR* {.importc.} = cstring

type
  HANDLE* {.importc.} = pointer
  HINSTANCE* {.importc.} = HANDLE
  HWND* {.importc.} = HANDLE
  HMENU* {.importc.} = HANDLE

type
  POINT* {.importc.} = object
    x*: LONG
    y*: LONG

  RECT* {.importc.} = object
    left*: LONG
    top*: LONG
    right*: LONG
    bottom*: LONG

  MSG* {.importc.} = object
    hwnd*: HWND
    message*: UINT
    wParam*: WPARAM
    lParam*: LPARAM
    time*: DWORD
    pt*: POINT

  GUID* {.importc.} = object
    Data1*: culong
    Data2*: cushort
    Data3*: cushort
    Data4*: array[8, cuchar]

type
  DLGPROC* {.importc.} = proc(unnamedParam1: HWND, unnamedParam2: UINT, unnamedParam3: WPARAM, unnamedParam4: LPARAM): INT_PTR {.stdcall.}

const
  WM_KEYDOWN*: UINT = 0x0100
  WM_KEYUP*: UINT = 0x0101
  WM_SYSKEYDOWN*: UINT = 0x0104
  WM_SYSKEYUP*: UINT = 0x0105

# type LPTSTR* {.importc.} = LPWSTR

proc DialogBoxParamW*(hInstance: HINSTANCE, lpTemplateName: LPCWSTR, hWndParent: HWND, lpDialogFunc: DLGPROC, dwInitParam: LPARAM): INT_PTR {.stdcall, importc.}
# proc DialogBoxParam*(hInstance: HINSTANCE, lpTemplateName: LPCWSTR, hWndParent: HWND, lpDialogFunc: DLGPROC, dwInitParam: LPARAM): INT_PTR {.stdcall, dynlib: "user32", importc: "DialogBoxParamW".}
# proc DialogBox*(hInstance: HINSTANCE, lpTemplate: LPCWSTR, hWndParent: HWND, lpDialogFunc: DLGPROC): INT_PTR {.inline.} = DialogBoxParamW(hInstance, lpTemplate, hWndParent, lpDialogFunc, 0)

# type LPTSTR* {.importc.} = LPSTR

# proc DialogBoxParamA*(hInstance: HINSTANCE, lpTemplateName: LPCSTR, hWndParent: HWND, lpDialogFunc: DLGPROC, dwInitParam: LPARAM): INT_PTR {.stdcall, dynlib: "user32", importc.}
# proc DialogBoxParam*(hInstance: HINSTANCE, lpTemplateName: LPCSTR, hWndParent: HWND, lpDialogFunc: DLGPROC, dwInitParam: LPARAM): INT_PTR {.stdcall, dynlib: "user32", importc: "DialogBoxParamA".}
# proc DialogBox*(hInstance: HINSTANCE, lpTemplate: LPCSTR, hWndParent: HWND, lpDialogFunc: DLGPROC): INT_PTR {.inline.} = DialogBoxParamA(hInstance, lpTemplate, hWndParent, lpDialogFunc, 0)

# template MAKEINTRESOURCE*(i: untyped): untyped = cast[LPTSTR](i and 0xffff)