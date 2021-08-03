when defined windows:
  {.passL: "user32.lib".}
  {.passL: "gdi32.lib".}
  {.pragma: windowsHeader, importc, header: "<windows.h>".}
  {.pragma: windowsXHeader, importc, header: "<windowsx.h>".}
else:
  {.pragma: windowsHeader, importc, header: "../swell/swell.h".}
  {.pragma: windowsXHeader, importc, header: "../swell/swell.h".}

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
  VOID* {.windowsHeader.} = pointer
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
  HBRUSH* {.windowsHeader.} = HANDLE
  HFONT* {.windowsHeader.} = HANDLE
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

  WNDPROC* {.windowsHeader.} = proc(hWnd: HWND, msg: UINT, wParam: WPARAM, lParam: LPARAM): LRESULT {.stdcall.}
  DLGPROC* {.windowsHeader.} = proc(hWnd: HWND, msg: UINT, wParam: WPARAM, lParam: LPARAM): INT_PTR {.stdcall.}
  TIMERPROC* {.windowsHeader.} = proc(P1: HWND, P2: UINT, P3: UINT_PTR, P4: DWORD): VOID {.stdcall.}

  COLORREF* {.windowsHeader.} = DWORD

const
  HWND_TOP* {.windowsHeader.} = nil
  HWND_BOTTOM* {.windowsHeader.} = nil
  HWND_TOPMOST* {.windowsHeader.} = nil
  HWND_NOTOPMOST* {.windowsHeader.} = nil
  WM_KEYDOWN* {.windowsHeader.} = 0x0100
  WM_KEYUP* {.windowsHeader.} = 0x0101
  WM_SYSKEYDOWN* {.windowsHeader.} = 0x0104
  WM_SYSKEYUP* {.windowsHeader.} = 0x0105
  WM_MOUSEMOVE* {.windowsHeader.} = 0x0200
  WM_LBUTTONDOWN* {.windowsHeader.} = 0x0201
  WM_LBUTTONUP* {.windowsHeader.} = 0x0202
  WM_LBUTTONDBLCLK* {.windowsHeader.} = 0x0203
  WM_MBUTTONDOWN* {.windowsHeader.} = 0x0207
  WM_MBUTTONUP* {.windowsHeader.} = 0x0208
  WM_MBUTTONDBLCLK* {.windowsHeader.} = 0x0209
  WM_RBUTTONDOWN* {.windowsHeader.} = 0x0204
  WM_RBUTTONUP* {.windowsHeader.} = 0x0205
  WM_RBUTTONDBLCLK* {.windowsHeader.} = 0x0206
  WM_XBUTTONDOWN* {.windowsHeader.} = 0x020b
  WM_XBUTTONUP* {.windowsHeader.} = 0x020c
  WM_XBUTTONDBLCLK* {.windowsHeader.} = 0x020d
  WM_CREATE* {.windowsHeader.} = 0x0001
  WM_INITDIALOG* {.windowsHeader.} = 0x0110
  WM_SHOWWINDOW* {.windowsHeader.} = 0x0018
  WM_PAINT* {.windowsHeader.} = 0x000f
  WM_ERASEBKGND* {.windowsHeader.} = 0x0014
  WM_CLOSE* {.windowsHeader.} = 0x0010
  WM_SIZE* {.windowsHeader.} = 0x0005
  WM_MOVE* {.windowsHeader.} = 0x0003
  WM_TIMER* {.windowsHeader.} =  0x0113
  WM_DPICHANGED* {.windowsHeader.} = 0x02E0
  MK_CONTROL* {.windowsHeader.} = 0x0008
  MK_LBUTTON* {.windowsHeader.} = 0x0001
  MK_MBUTTON* {.windowsHeader.} = 0x0010
  MK_RBUTTON* {.windowsHeader.} = 0x0002
  MK_SHIFT* {.windowsHeader.} = 0x0004
  MK_XBUTTON1* {.windowsHeader.} = 0x0020
  MK_XBUTTON2* {.windowsHeader.} = 0x0040
  SW_HIDE* {.windowsHeader.} = 0
  SW_SHOWNORMAL* {.windowsHeader.} = 1
  SW_NORMAL* {.windowsHeader.} = 1
  SW_SHOWMINIMIZED* {.windowsHeader.} = 2
  SW_SHOWMAXIMIZED* {.windowsHeader.} = 3
  SW_MAXIMIZE* {.windowsHeader.} = 3
  SW_SHOWNOACTIVATE* {.windowsHeader.} = 4
  SW_SHOW* {.windowsHeader.} = 5
  SW_MINIMIZE* {.windowsHeader.} = 6
  SW_SHOWMINNOACTIVE* {.windowsHeader.} = 7
  SW_SHOWNA* {.windowsHeader.} = 8
  SW_RESTORE* {.windowsHeader.} = 9
  SW_SHOWDEFAULT* {.windowsHeader.} = 10
  SW_FORCEMINIMIZE* {.windowsHeader.} = 11
  PS_COSMETIC* {.windowsHeader.} = 0x00000000
  PS_ENDCAP_ROUND* {.windowsHeader.} = 0x00000000
  PS_JOIN_ROUND* {.windowsHeader.} = 0x00000000
  PS_SOLID* {.windowsHeader.} = 0x00000000
  PS_DASH* {.windowsHeader.} = 0x00000001
  PS_DOT* {.windowsHeader.} = 0x00000002
  PS_DASHDOT* {.windowsHeader.} = 0x00000003
  PS_DASHDOTDOT* {.windowsHeader.} = 0x00000004
  PS_NULL* {.windowsHeader.} = 0x00000005
  PS_INSIDEFRAME* {.windowsHeader.} = 0x00000006
  PS_USERSTYLE* {.windowsHeader.} = 0x00000007
  PS_ALTERNATE* {.windowsHeader.} = 0x00000008
  PS_ENDCAP_SQUARE* {.windowsHeader.} = 0x00000100
  PS_ENDCAP_FLAT* {.windowsHeader.} = 0x00000200
  PS_JOIN_BEVEL* {.windowsHeader.} = 0x00001000
  PS_JOIN_MITER* {.windowsHeader.} = 0x00002000
  PS_GEOMETRIC* {.windowsHeader.} = 0x00010000
  SWP_ASYNCWINDOWPOS* {.windowsHeader.} = 0x4000
  SWP_DEFERERASE* {.windowsHeader.} = 0x2000
  SWP_DRAWFRAME* {.windowsHeader.} = 0x0020
  SWP_FRAMECHANGED* {.windowsHeader.} = 0x0020
  SWP_HIDEWINDOW* {.windowsHeader.} = 0x0080
  SWP_NOACTIVATE* {.windowsHeader.} = 0x0010
  SWP_NOCOPYBITS* {.windowsHeader.} = 0x0100
  SWP_NOMOVE* {.windowsHeader.} = 0x0002
  SWP_NOOWNERZORDER* {.windowsHeader.} = 0x0200
  SWP_NOREDRAW* {.windowsHeader.} = 0x0008
  SWP_NOREPOSITION* {.windowsHeader.} = 0x0200
  SWP_NOSENDCHANGING* {.windowsHeader.} = 0x0400
  SWP_NOSIZE* {.windowsHeader.} = 0x0001
  SWP_NOZORDER* {.windowsHeader.} = 0x0004
  SWP_SHOWWINDOW* {.windowsHeader.} = 0x0040
  SRCCOPY* {.windowsHeader.} = 0x00CC0020

proc LOWORD*(value: WPARAM): int {.stdcall, windowsXHeader.}
proc HIWORD*(value: WPARAM): int {.stdcall, windowsXHeader.}
proc GET_X_LPARAM*(lParam: LPARAM): int {.stdcall, windowsXHeader.}
proc GET_Y_LPARAM*(lParam: LPARAM): int {.stdcall, windowsXHeader.}
proc MAKEINTRESOURCE*(i: int): LPCTSTR {.stdcall, windowsHeader.}

proc CreateDialog*(hInstance: HINSTANCE, lpName: LPCTSTR, hWndParent: HWND, lpDialogFunc: DLGPROC): HWND {.stdcall, windowsHeader.}
proc ShowWindow*(hWnd: HINSTANCE, nCmdShow: int): BOOL {.stdcall, windowsHeader.}
proc DestroyWindow*(hWnd: HWND): BOOL {.stdcall, windowsHeader.}
proc GetWindowRect*(hWnd: HWND, lpRect: ptr Rect): BOOL {.stdcall, windowsHeader.}
proc GetClientRect*(hWnd: HWND, lpRect: ptr Rect): BOOL {.stdcall, windowsHeader.}
proc SetFocus*(hWnd: HWND): HWND {.stdcall, windowsHeader.}
proc GetDpiForWindow*(hWnd: HWND): UINT {.stdcall, windowsHeader.}
proc SetWindowText*(hWnd: HWND, lpString: LPCSTR): BOOL {.stdcall, windowsHeader.}
proc SetWindowPos*(hWnd, hWndInsertAfter: HWND; X, Y, cx, cy: int; uFlags: UINT): BOOL {.stdcall, windowsHeader.}
proc SetTimer*(hWnd: HWND, nIDEvent: UINT_PTR, uElapse: UINT, lpTimerFunc: TIMERPROC): UINT_PTR {.stdcall, windowsHeader.}
proc KillTimer*(hWnd: HWND, uIDEvent: UINT_PTR): BOOL {.stdcall, windowsHeader.}
proc SetCapture*(hWnd: HWND): HWND {.stdcall, windowsHeader.}
proc ReleaseCapture*(): BOOL {.stdcall, windowsHeader.}
proc GetCursorPos*(lpPoint: ptr POINT): BOOL {.stdcall, windowsHeader.}
proc InvalidateRect*(hWnd: HWND, lpRect: ptr RECT, bErase: BOOL): BOOL {.stdcall, windowsHeader.}
proc BitBlt*(hdc: HDC, x, y, cx, cy: int, hdcSrc: HDC, x1, y1: int, rop: DWORD): BOOL {.stdcall, windowsHeader.}

proc BeginPaint*(hWnd: HWND, lpPaint: LPPAINTSTRUCT): HDC {.stdcall, windowsHeader.}
proc EndPaint*(hWnd: HWND, lpPaint: ptr PAINTSTRUCT): BOOL {.stdcall, windowsHeader.}
proc RGB*(r, g, b: int): COLORREF {.stdcall, windowsHeader.}
proc SetBkColor*(hdc: HDC, color: COLORREF): COLORREF {.stdcall, windowsHeader.}
proc CreatePen*(iStyle, cWidth: int, color: COLORREF): HPEN {.stdcall, windowsHeader.}
proc CreateSolidBrush*(color: COLORREF): HBRUSH {.stdcall, windowsHeader.}
proc DeleteObject*(ho: HGDIOBJ): BOOL {.stdcall, windowsHeader.}
proc SelectObject*(hdc: HDC, h: HGDIOBJ): HGDIOBJ {.stdcall, windowsHeader.}
proc Rectangle*(ctx: HDC; l, t, r, b: int): BOOL {.stdcall, windowsHeader.}