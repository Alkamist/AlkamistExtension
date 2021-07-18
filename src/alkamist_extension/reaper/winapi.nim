when defined windows:
  {.passL: "user32.lib".}
  {.passL: "gdi32.lib".}
  {.pragma: windowsHeader, importc, header: "<windows.h>".}
  {.pragma: windowsXHeader, importc, header: "<windowsx.h>".}
else:
  {.pragma: windowsHeader, importc, header: "swell/swell.h".}
  {.pragma: windowsXHeader, importc, header: "swell/swell.h".}

when defined cpu64:
  type
    INT_PTR* {.windowsHeader.} = int64
    UINT_PTR* {.windowsHeader.} = int64
    LONG_PTR* {.windowsHeader.} = int64
    ULONG_PTR* {.windowsHeader.} = int64
else:
  type
    INT_PTR* {.windowsHeader.} = int32
    UINT_PTR* {.windowsHeader.} = int32
    LONG_PTR* {.windowsHeader.} = int32
    ULONG_PTR* {.windowsHeader.} = int32

type
  BOOL* {.windowsHeader.} = int32
  CHAR* {.windowsHeader.} = char
  WORD* {.windowsHeader.} = uint16
  INT* {.windowsHeader.} = int32
  LONG* {.windowsHeader.} = int32
  BYTE* {.windowsHeader.} = uint8
  UCHAR* {.windowsHeader.} = uint8
  USHORT* {.windowsHeader.} = uint16
  WCHAR* {.windowsHeader.} = uint16
  UINT* {.windowsHeader.} = int32
  ULONG* {.windowsHeader.} = int32
  DWORD* {.windowsHeader.} = int32
  FLOAT* {.windowsHeader.} = float32
  WPARAM* {.windowsHeader.} = UINT_PTR
  LPARAM* {.windowsHeader.} = LONG_PTR
  LRESULT* {.windowsHeader.} = LONG_PTR
  LPSTR* {.windowsHeader.} = cstring
  LPCSTR* {.windowsHeader.} = cstring
  LPWSTR* {.windowsHeader.} = cstring
  LPCWSTR* {.windowsHeader.} = cstring
  LPCTSTR* {.windowsHeader.} = cstring

  HANDLE* {.windowsHeader.} = pointer
  HINSTANCE* {.windowsHeader.} = HANDLE
  HWND* {.windowsHeader.} = HANDLE
  HMENU* {.windowsHeader.} = HANDLE
  HDC* {.windowsHeader.} = HANDLE
  HPEN* {.windowsHeader.} = HANDLE
  HGDIOBJ* {.windowsHeader.} = HANDLE

  POINT* {.windowsHeader.} = object
    x*: LONG
    y*: LONG

  RECT* {.windowsHeader.} = object
    left*: LONG
    top*: LONG
    right*: LONG
    bottom*: LONG

  MSG* {.windowsHeader.} = object
    hwnd*: HWND
    message*: UINT
    wParam*: WPARAM
    lParam*: LPARAM
    time*: DWORD
    pt*: POINT

  GUID* {.windowsHeader.} = object
    Data1*: int32
    Data2*: uint16
    Data3*: uint16
    Data4*: array[8, uint8]

  ACCEL* {.windowsHeader.} = object
    fVirt*: BYTE
    key*: WORD
    cmd*: WORD

  PAINTSTRUCT* {.windowsHeader.} = object
    hdc*: HDC
    fErase*: BOOL
    rcPaint*: RECT
    fRestore*: BOOL
    fIncUpdate*: BOOL
    rgbReserved*: array[32, BYTE]
  LPPAINTSTRUCT* = ptr PAINTSTRUCT

  WNDPROC* {.windowsHeader.} = proc (hWnd: HWND, msg: UINT, wParam: WPARAM, lParam: LPARAM): LRESULT {.stdcall.}
  DLGPROC* {.windowsHeader.} = proc(hWnd: HWND, msg: UINT, wParam: WPARAM, lParam: LPARAM): INT_PTR {.stdcall.}

  COLORREF* {.windowsHeader.} = DWORD

const
  WM_KEYDOWN* = 0x0100
  WM_KEYUP* = 0x0101
  WM_SYSKEYDOWN* = 0x0104
  WM_SYSKEYUP* = 0x0105
  WM_MOUSEMOVE* = 0x0200
  WM_PAINT* = 0x000f
  WM_CLOSE* = 0x0010
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
  PS_COSMETIC* = 0x00000000
  PS_ENDCAP_ROUND* = 0x00000000
  PS_JOIN_ROUND* = 0x00000000
  PS_SOLID* = 0x00000000
  PS_DASH* = 0x00000001
  PS_DOT* = 0x00000002
  PS_DASHDOT* = 0x00000003
  PS_DASHDOTDOT* = 0x00000004
  PS_NULL* = 0x00000005
  PS_INSIDEFRAME* = 0x00000006
  PS_USERSTYLE* = 0x00000007
  PS_ALTERNATE* = 0x00000008
  PS_ENDCAP_SQUARE* = 0x00000100
  PS_ENDCAP_FLAT* = 0x00000200
  PS_JOIN_BEVEL* = 0x00001000
  PS_JOIN_MITER* = 0x00002000
  PS_GEOMETRIC* = 0x00010000

proc LOWORD*(value: WPARAM): int {.stdcall, windowsXHeader.}
proc HIWORD*(value: WPARAM): int {.stdcall, windowsXHeader.}
proc GET_X_LPARAM*(lParam: LPARAM): int {.stdcall, windowsXHeader.}
proc GET_Y_LPARAM*(lParam: LPARAM): int {.stdcall, windowsXHeader.}
proc MAKEINTRESOURCE*(i: int): LPCTSTR {.stdcall, windowsHeader.}

proc CreateDialog*(hInstance: HINSTANCE, lpName: LPCTSTR, hWndParent: HWND, lpDialogFunc: DLGPROC): HWND {.stdcall, windowsHeader.}
proc ShowWindow*(hWnd: HINSTANCE, nCmdShow: int32): BOOL {.stdcall, windowsHeader.}
proc DestroyWindow*(hWnd: HWND): BOOL {.stdcall, windowsHeader.}

proc BeginPaint*(hWnd: HWND, lpPaint: LPPAINTSTRUCT): HDC {.stdcall, windowsHeader.}
proc EndPaint*(hWnd: HWND, lpPaint: ptr PAINTSTRUCT): BOOL {.stdcall, windowsHeader.}
proc RGB*(r, g, b: int): COLORREF {.stdcall, windowsHeader.}
proc CreatePen*(iStyle, cWidth: int, color: COLORREF): HPEN {.stdcall, windowsHeader.}
proc DeleteObject*(ho: HGDIOBJ): BOOL {.stdcall, windowsHeader.}
proc SelectObject*(hdc: HDC, h: HGDIOBJ): HGDIOBJ {.stdcall, windowsHeader.}
proc Rectangle*(ctx: HDC; l, t, r, b: int): BOOL {.stdcall, windowsHeader.}