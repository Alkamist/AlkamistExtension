import std/options, button

type
  KeyKind* = enum
    ControlBreak,
    Backspace,
    Tab,
    Clear,
    Enter,
    Shift,
    Control,
    Alt,
    Pause,
    CapsLock,
    IMEKana,
    IMEJunja,
    IMEFinal,
    IMEHanja,
    Escape,
    IMEConvert,
    IMENonConvert,
    IMEAccept,
    IMEModeChange,
    Space,
    PageUp,
    PageDown,
    End,
    Home,
    LeftArrow,
    UpArrow,
    RightArrow,
    DownArrow,
    Select,
    Print,
    Execute,
    PrintScreen,
    Insert,
    Delete,
    Help,
    Key0,
    Key1,
    Key2,
    Key3,
    Key4,
    Key5,
    Key6,
    Key7,
    Key8,
    Key9,
    A,
    B,
    C,
    D,
    E,
    F,
    G,
    H,
    I,
    J,
    K,
    L,
    M,
    N,
    O,
    P,
    Q,
    R,
    S,
    T,
    U,
    V,
    W,
    X,
    Y,
    Z,
    LeftWindows,
    RightWindows,
    Applications,
    Sleep,
    NumPad0,
    NumPad1,
    NumPad2,
    NumPad3,
    NumPad4,
    NumPad5,
    NumPad6,
    NumPad7,
    NumPad8,
    NumPad9,
    NumPadMultiply,
    NumPadAdd,
    NumPadSeparator,
    NumPadSubtract,
    NumPadDecimal,
    NumPadDivide,
    F1,
    F2,
    F3,
    F4,
    F5,
    F6,
    F7,
    F8,
    F9,
    F10,
    F11,
    F12,
    F13,
    F14,
    F15,
    F16,
    F17,
    F18,
    F20,
    F21,
    F22,
    F23,
    F24,
    NumLock,
    ScrollLock,
    LeftShift,
    RightShift,
    LeftControl,
    RightControl,
    LeftAlt,
    RightAlt,
    BrowserBack,
    BrowserForward,
    BrowserRefresh,
    BrowserStop,
    BrowserSearch,
    BrowserFavorites,
    BrowserHome,
    BrowserMute,
    VolumeDown,
    VolumeUp,
    MediaNextTrack,
    MediaPreviousTrack,
    MediaStop,
    MediaPlay,
    StartMail,
    MediaSelect,
    LaunchApplication1,
    LaunchApplication2,
    Semicolon,
    Equals,
    Comma,
    Minus,
    Period,
    Slash,
    Grave,
    LeftBracket,
    BackSlash,
    RightBracket,
    Apostrophe,
    IMEProcess,

  Keyboard* = object
    keys*: array[KeyKind, Button]

{.push inline.}

proc update*(keyboard: var Keyboard) =
  for key in keyboard.keys.mitems:
    key.update()

func `[]`*(keyboard: var Keyboard, kind: KeyKind): var Button =
  return keyboard.keys[kind]

{.pop.}

proc toKeyKind*(code: int): Option[KeyKind] =
  case code:
  of 3: some(KeyKind.ControlBreak)
  of 8: some(KeyKind.Backspace)
  of 9: some(KeyKind.Tab)
  of 12: some(KeyKind.Clear)
  of 13: some(KeyKind.Enter)
  of 16: some(KeyKind.Shift)
  of 17: some(KeyKind.Control)
  of 18: some(KeyKind.Alt)
  of 19: some(KeyKind.Pause)
  of 20: some(KeyKind.CapsLock)
  of 21: some(KeyKind.IMEKana)
  of 23: some(KeyKind.IMEJunja)
  of 24: some(KeyKind.IMEFinal)
  of 25: some(KeyKind.IMEHanja)
  of 27: some(KeyKind.Escape)
  of 28: some(KeyKind.IMEConvert)
  of 29: some(KeyKind.IMENonConvert)
  of 30: some(KeyKind.IMEAccept)
  of 31: some(KeyKind.IMEModeChange)
  of 32: some(KeyKind.Space)
  of 33: some(KeyKind.PageUp)
  of 34: some(KeyKind.PageDown)
  of 35: some(KeyKind.End)
  of 36: some(KeyKind.Home)
  of 37: some(KeyKind.LeftArrow)
  of 38: some(KeyKind.UpArrow)
  of 39: some(KeyKind.RightArrow)
  of 40: some(KeyKind.DownArrow)
  of 41: some(KeyKind.Select)
  of 42: some(KeyKind.Print)
  of 43: some(KeyKind.Execute)
  of 44: some(KeyKind.PrintScreen)
  of 45: some(KeyKind.Insert)
  of 46: some(KeyKind.Delete)
  of 47: some(KeyKind.Help)
  of 48: some(KeyKind.Key0)
  of 49: some(KeyKind.Key1)
  of 50: some(KeyKind.Key2)
  of 51: some(KeyKind.Key3)
  of 52: some(KeyKind.Key4)
  of 53: some(KeyKind.Key5)
  of 54: some(KeyKind.Key6)
  of 55: some(KeyKind.Key7)
  of 56: some(KeyKind.Key8)
  of 57: some(KeyKind.Key9)
  of 65: some(KeyKind.A)
  of 66: some(KeyKind.B)
  of 67: some(KeyKind.C)
  of 68: some(KeyKind.D)
  of 69: some(KeyKind.E)
  of 70: some(KeyKind.F)
  of 71: some(KeyKind.G)
  of 72: some(KeyKind.H)
  of 73: some(KeyKind.I)
  of 74: some(KeyKind.J)
  of 75: some(KeyKind.K)
  of 76: some(KeyKind.L)
  of 77: some(KeyKind.M)
  of 78: some(KeyKind.N)
  of 79: some(KeyKind.O)
  of 80: some(KeyKind.P)
  of 81: some(KeyKind.Q)
  of 82: some(KeyKind.R)
  of 83: some(KeyKind.S)
  of 84: some(KeyKind.T)
  of 85: some(KeyKind.U)
  of 86: some(KeyKind.V)
  of 87: some(KeyKind.W)
  of 88: some(KeyKind.X)
  of 89: some(KeyKind.Y)
  of 90: some(KeyKind.Z)
  of 91: some(KeyKind.LeftWindows)
  of 92: some(KeyKind.RightWindows)
  of 93: some(KeyKind.Applications)
  of 95: some(KeyKind.Sleep)
  of 96: some(KeyKind.NumPad0)
  of 97: some(KeyKind.NumPad1)
  of 98: some(KeyKind.NumPad2)
  of 99: some(KeyKind.NumPad3)
  of 100: some(KeyKind.NumPad4)
  of 101: some(KeyKind.NumPad5)
  of 102: some(KeyKind.NumPad6)
  of 103: some(KeyKind.NumPad7)
  of 104: some(KeyKind.NumPad8)
  of 105: some(KeyKind.NumPad9)
  of 106: some(KeyKind.NumPadMultiply)
  of 107: some(KeyKind.NumPadAdd)
  of 108: some(KeyKind.NumPadSeparator)
  of 109: some(KeyKind.NumPadSubtract)
  of 110: some(KeyKind.NumPadDecimal)
  of 111: some(KeyKind.NumPadDivide)
  of 112: some(KeyKind.F1)
  of 113: some(KeyKind.F2)
  of 114: some(KeyKind.F3)
  of 115: some(KeyKind.F4)
  of 116: some(KeyKind.F5)
  of 117: some(KeyKind.F6)
  of 118: some(KeyKind.F7)
  of 119: some(KeyKind.F8)
  of 120: some(KeyKind.F9)
  of 121: some(KeyKind.F10)
  of 122: some(KeyKind.F11)
  of 123: some(KeyKind.F12)
  of 124: some(KeyKind.F13)
  of 125: some(KeyKind.F14)
  of 126: some(KeyKind.F15)
  of 127: some(KeyKind.F16)
  of 128: some(KeyKind.F17)
  of 129: some(KeyKind.F18)
  of 130: some(KeyKind.F20)
  of 131: some(KeyKind.F21)
  of 132: some(KeyKind.F22)
  of 133: some(KeyKind.F23)
  of 134: some(KeyKind.F24)
  of 144: some(KeyKind.NumLock)
  of 145: some(KeyKind.ScrollLock)
  of 160: some(KeyKind.LeftShift)
  of 161: some(KeyKind.RightShift)
  of 162: some(KeyKind.LeftControl)
  of 163: some(KeyKind.RightControl)
  of 164: some(KeyKind.LeftAlt)
  of 165: some(KeyKind.RightAlt)
  of 166: some(KeyKind.BrowserBack)
  of 167: some(KeyKind.BrowserForward)
  of 168: some(KeyKind.BrowserRefresh)
  of 169: some(KeyKind.BrowserStop)
  of 170: some(KeyKind.BrowserSearch)
  of 171: some(KeyKind.BrowserFavorites)
  of 172: some(KeyKind.BrowserHome)
  of 173: some(KeyKind.BrowserMute)
  of 174: some(KeyKind.VolumeDown)
  of 175: some(KeyKind.VolumeUp)
  of 176: some(KeyKind.MediaNextTrack)
  of 177: some(KeyKind.MediaPreviousTrack)
  of 178: some(KeyKind.MediaStop)
  of 179: some(KeyKind.MediaPlay)
  of 180: some(KeyKind.StartMail)
  of 181: some(KeyKind.MediaSelect)
  of 182: some(KeyKind.LaunchApplication1)
  of 183: some(KeyKind.LaunchApplication2)
  of 186: some(KeyKind.Semicolon)
  of 187: some(KeyKind.Equals)
  of 188: some(KeyKind.Comma)
  of 189: some(KeyKind.Minus)
  of 190: some(KeyKind.Period)
  of 191: some(KeyKind.Slash)
  of 192: some(KeyKind.Grave)
  of 219: some(KeyKind.LeftBracket)
  of 220: some(KeyKind.BackSlash)
  of 221: some(KeyKind.RightBracket)
  of 222: some(KeyKind.Apostrophe)
  of 229: some(KeyKind.IMEProcess)
  else: none(KeyKind)