when defined(cpu64):
  type
    INT_PTR* = int64
    PINT_PTR* = ptr int64
    UINT_PTR* = int64
    PUINT_PTR* = ptr int64
    LONG_PTR* = int64
    PLONG_PTR* = ptr int64
    ULONG_PTR* = int64
    PULONG_PTR* = ptr int64
    SHANDLE_PTR* = int64
    HANDLE_PTR* = int64
    UHALF_PTR* = int32
    PUHALF_PTR* = ptr int32
    HALF_PTR* = int32
    PHALF_PTR* = ptr int32
when not defined(cpu64):
  type
    INT_PTR* = int32
    PINT_PTR* = ptr int32
    UINT_PTR* = int32
    PUINT_PTR* = ptr int32
    LONG_PTR* = int32
    PLONG_PTR* = ptr int32
    ULONG_PTR* = int32
    PULONG_PTR* = ptr int32
    UHALF_PTR* = uint16
    PUHALF_PTR* = ptr uint16
    SHANDLE_PTR* = int32
    HANDLE_PTR* = int32

type
  HANDLE* = int
  HINSTANCE* = HANDLE
  HWND* = HANDLE
  HHOOK* = HANDLE
  HMENU* = HANDLE
  WINBOOL* = int32
  DWORD* = int32
  LONG* = int32
  UINT* = int32
  WPARAM* = UINT_PTR
  LPARAM* = LONG_PTR
  LRESULT* = LONG_PTR
  HOOKPROC* = proc (code: int32, wParam: WPARAM, lParam: LPARAM): LRESULT {.stdcall.}
  KBDLLHOOKSTRUCT* {.importc.} = object
    vkCode*: DWORD
    scanCode*: DWORD
    flags*: DWORD
    time*: DWORD
    dwExtraInfo*: ULONG_PTR
  PKBDLLHOOKSTRUCT* = ptr KBDLLHOOKSTRUCT
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
  LPMSG* = ptr MSG
  GUID* {.importc.} = object
    Data1*: int32
    Data2*: uint16
    Data3*: uint16
    Data4*: array[8, uint8]

const
  HC_ACTION* = 0
  WH_KEYBOARD_LL* = 13
  WM_KEYDOWN* = 0x0100
  WM_KEYUP* = 0x0101
  WM_SYSKEYDOWN* = 0x0104
  WM_SYSKEYUP* = 0x0105