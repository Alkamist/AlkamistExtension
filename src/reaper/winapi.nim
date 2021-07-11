when defined(cpu64):
  type
    UINT_PTR* = uint64
    LONG_PTR* = int64
    ULONG_PTR* = uint64
when not defined(cpu64):
  type
    UINT_PTR* = int32
    LONG_PTR* = int32
    ULONG_PTR* = int32

type
  HANDLE* = int
  HINSTANCE* = HANDLE
  HWND* = HANDLE
  HHOOK* = HANDLE
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
  MSG* {.importc.} = object
    hwnd*: HWND
    message*: UINT
    wParam*: WPARAM
    lParam*: LPARAM
    time*: DWORD
    pt*: POINT
  LPMSG* = ptr MSG

const
  HC_ACTION* = 0
  WH_KEYBOARD_LL* = 13
  WM_KEYDOWN* = 0x0100
  WM_KEYUP* = 0x0101
  WM_SYSKEYDOWN* = 0x0104
  WM_SYSKEYUP* = 0x0105