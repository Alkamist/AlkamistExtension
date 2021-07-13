{.passL: "user32.lib".}

{.pragma: WindowsType, importc, header: "<windows.h>".}
{.pragma: WindowsFunction, stdcall, importc, header: "<windows.h>".}

when defined(cpu64):
  type
    INT_PTR* {.WindowsType.} = clonglong
    UINT_PTR* {.WindowsType.} = culonglong
    LONG_PTR* {.WindowsType.} = clonglong
    ULONG_PTR* {.WindowsType.} = culonglong
else:
  type
    INT_PTR* {.WindowsType.} = cint
    UINT_PTR* {.WindowsType.} = cuint
    LONG_PTR* {.WindowsType.} = clong
    ULONG_PTR* {.WindowsType.} = culong

type
  BOOL* {.WindowsType.} = cint
  CHAR* {.WindowsType.} = cchar
  WORD* {.WindowsType.} = cshort
  INT* {.WindowsType.} = cint
  LONG* {.WindowsType.} = clong
  BYTE* {.WindowsType.} = cuchar
  UCHAR* {.WindowsType.} = cuchar
  USHORT* {.WindowsType.} = cushort
  WCHAR* {.WindowsType.} = cuint
  UINT* {.WindowsType.} = cuint
  ULONG* {.WindowsType.} = culong
  DWORD* {.WindowsType.} = culong
  FLOAT* {.WindowsType.} = cfloat
  WPARAM* {.WindowsType.} = UINT_PTR
  LPARAM* {.WindowsType.} = LONG_PTR
  LRESULT* {.WindowsType.} = LONG_PTR
  LPSTR* {.WindowsType.} = cstring
  LPCSTR* {.WindowsType.} = cstring
  LPWSTR* {.WindowsType.} = cstring
  LPCWSTR* {.WindowsType.} = cstring
  LPCTSTR* {.WindowsType.} = cstring

type
  HANDLE* {.WindowsType.} = pointer
  HINSTANCE* {.WindowsType.} = HANDLE
  HWND* {.WindowsType.} = HANDLE
  HMENU* {.WindowsType.} = HANDLE

type
  POINT* {.WindowsType.} = object
    x*: LONG
    y*: LONG

  RECT* {.WindowsType.} = object
    left*: LONG
    top*: LONG
    right*: LONG
    bottom*: LONG

  MSG* {.WindowsType.} = object
    hwnd*: HWND
    message*: UINT
    wParam*: WPARAM
    lParam*: LPARAM
    time*: DWORD
    pt*: POINT

  GUID* {.WindowsType.} = object
    Data1*: culong
    Data2*: cushort
    Data3*: cushort
    Data4*: array[8, cuchar]

type
  DLGPROC* {.WindowsType.} = proc(unnamedParam1: HWND, unnamedParam2: UINT, unnamedParam3: WPARAM, unnamedParam4: LPARAM): INT_PTR {.stdcall.}

const
  WM_KEYDOWN*: UINT = 0x0100
  WM_KEYUP*: UINT = 0x0101
  WM_SYSKEYDOWN*: UINT = 0x0104
  WM_SYSKEYUP*: UINT = 0x0105
  SW_HIDE*: cint = 0
  SW_SHOWNORMAL*: cint = 1
  SW_NORMAL*: cint = 1
  SW_SHOWMINIMIZED*: cint = 2
  SW_SHOWMAXIMIZED*: cint = 3
  SW_MAXIMIZE*: cint = 3
  SW_SHOWNOACTIVATE*: cint = 4
  SW_SHOW*: cint = 5
  SW_MINIMIZE*: cint = 6
  SW_SHOWMINNOACTIVE*: cint = 7
  SW_SHOWNA*: cint = 8
  SW_RESTORE*: cint = 9
  SW_SHOWDEFAULT*: cint = 10
  SW_FORCEMINIMIZE*: cint = 11

proc MAKEINTRESOURCE*(i: cint): LPCTSTR {.WindowsFunction.}
proc CreateDialog*(hInstance: HINSTANCE, lpName: LPCTSTR, hWndParent: HWND, lpDialogFunc: DLGPROC): HWND {.WindowsFunction.}
proc ShowWindow*(hWnd: HINSTANCE, nCmdShow: cint): BOOL {.WindowsFunction.}