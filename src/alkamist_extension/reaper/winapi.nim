{.passL: "user32.lib".}

when defined(cpu64):
  type
    INT_PTR* {.importc, header: "<windows.h>".} = clonglong
    UINT_PTR* {.importc, header: "<windows.h>".} = culonglong
    LONG_PTR* {.importc, header: "<windows.h>".} = clonglong
    ULONG_PTR* {.importc, header: "<windows.h>".} = culonglong
else:
  type
    INT_PTR* {.importc, header: "<windows.h>".} = cint
    UINT_PTR* {.importc, header: "<windows.h>".} = cuint
    LONG_PTR* {.importc, header: "<windows.h>".} = clong
    ULONG_PTR* {.importc, header: "<windows.h>".} = culong

type
  BOOL* {.importc, header: "<windows.h>".} = cint
  CHAR* {.importc, header: "<windows.h>".} = cchar
  WORD* {.importc, header: "<windows.h>".} = cshort
  INT* {.importc, header: "<windows.h>".} = cint
  LONG* {.importc, header: "<windows.h>".} = clong
  BYTE* {.importc, header: "<windows.h>".} = cuchar
  UCHAR* {.importc, header: "<windows.h>".} = cuchar
  USHORT* {.importc, header: "<windows.h>".} = cushort
  WCHAR* {.importc, header: "<windows.h>".} = cuint
  UINT* {.importc, header: "<windows.h>".} = cuint
  ULONG* {.importc, header: "<windows.h>".} = culong
  DWORD* {.importc, header: "<windows.h>".} = culong
  FLOAT* {.importc, header: "<windows.h>".} = cfloat
  WPARAM* {.importc, header: "<windows.h>".} = UINT_PTR
  LPARAM* {.importc, header: "<windows.h>".} = LONG_PTR
  LRESULT* {.importc, header: "<windows.h>".} = LONG_PTR
  LPSTR* {.importc, header: "<windows.h>".} = cstring
  LPCSTR* {.importc, header: "<windows.h>".} = cstring
  LPWSTR* {.importc, header: "<windows.h>".} = cstring
  LPCWSTR* {.importc, header: "<windows.h>".} = cstring
  LPCTSTR* {.importc, header: "<windows.h>".} = cstring

type
  HANDLE* {.importc, header: "<windows.h>".} = pointer
  HINSTANCE* {.importc, header: "<windows.h>".} = HANDLE
  HWND* {.importc, header: "<windows.h>".} = HANDLE
  HMENU* {.importc, header: "<windows.h>".} = HANDLE

type
  POINT* {.importc, header: "<windows.h>".} = object
    x*: LONG
    y*: LONG

  RECT* {.importc, header: "<windows.h>".} = object
    left*: LONG
    top*: LONG
    right*: LONG
    bottom*: LONG

  MSG* {.importc, header: "<windows.h>".} = object
    hwnd*: HWND
    message*: UINT
    wParam*: WPARAM
    lParam*: LPARAM
    time*: DWORD
    pt*: POINT

  GUID* {.importc, header: "<windows.h>".} = object
    Data1*: culong
    Data2*: cushort
    Data3*: cushort
    Data4*: array[8, cuchar]

type
  DLGPROC* {.importc, header: "<windows.h>".} = proc(hWnd: HWND, msg: UINT, wParam: WPARAM, lParam: LPARAM): INT_PTR {.stdcall.}

const
  WM_KEYDOWN* = 0x0100
  WM_KEYUP* = 0x0101
  WM_SYSKEYDOWN* = 0x0104
  WM_SYSKEYUP* = 0x0105
  WM_MOUSEMOVE* = 0x0200
  MK_CONTROL* = 0x0008
  MK_LBUTTON* = 0x0001
  MK_MBUTTON* = 0x0010
  MK_RBUTTON* = 0x0002
  MK_SHIFT* = 0x0004
  MK_XBUTTON1* = 0x0020
  MK_XBUTTON2* = 0x0040
  SW_HIDE* = 0
  SW_SHOWNORMAL* = 1
  SW_NORMAL* = 1
  SW_SHOWMINIMIZED* = 2
  SW_SHOWMAXIMIZED* = 3
  SW_MAXIMIZE* = 3
  SW_SHOWNOACTIVATE* = 4
  SW_SHOW* = 5
  SW_MINIMIZE* = 6
  SW_SHOWMINNOACTIVE* = 7
  SW_SHOWNA* = 8
  SW_RESTORE* = 9
  SW_SHOWDEFAULT* = 10
  SW_FORCEMINIMIZE* = 11

proc LOWORD*(value: WPARAM): cint {.stdcall, importc, header: "<windowsx.h>".}
proc HIWORD*(value: WPARAM): cint {.stdcall, importc, header: "<windowsx.h>".}
proc GET_X_LPARAM*(lParam: LPARAM): cint {.stdcall, importc, header: "<windowsx.h>".}
proc GET_Y_LPARAM*(lParam: LPARAM): cint {.stdcall, importc, header: "<windowsx.h>".}
proc MAKEINTRESOURCE*(i: cint): LPCTSTR {.stdcall, importc, header: "<windows.h>".}

proc CreateDialog*(hInstance: HINSTANCE, lpName: LPCTSTR, hWndParent: HWND, lpDialogFunc: DLGPROC): HWND {.stdcall, importc, header: "<windows.h>".}
proc ShowWindow*(hWnd: HINSTANCE, nCmdShow: cint): BOOL {.stdcall, importc, header: "<windows.h>".}