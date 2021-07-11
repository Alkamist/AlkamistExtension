import winapi

{.pragma: ReaperAPI, importc, header: ReaperHeader.}

const ReaperHeader* = "reaper/reaper_cpp/reaper_plugin_functions.h"

type
  LICE_pixel* = cuint
  LICE_pixel_chan* = cuchar
  LICE_IBitmap* = object
  LICE_IFont* = object

  ReaProject* = object
  MediaTrack* = object
  MediaItem* = object
  MediaItem_Take* = object
  TrackEnvelope* = object
  AudioAccessor* = object

  WDL_VirtualWnd_BGCfg* = object
  joystick_device* = object

  reaper_plugin_info_t* {.ReaperAPI.} = object
    caller_version*: cint
    hwnd_main*: HWND
    Register*: proc (name: cstring; infostruct: pointer): cint {.cdecl.}
    GetFunc*: proc (name: cstring): pointer {.cdecl.}

  MIDI_event_t* {.ReaperAPI.} = object
    frame_offset*: cint
    size*: cint
    midi_message*: array[4, cuchar]

  MIDI_eventprops* {.ReaperAPI.} = object
    ppqpos*: cdouble
    ppqpos_end_or_bezier_tension*: cdouble
    flag*: char
    msg*: array[3, cuchar]
    varmsg*: cstring
    varmsglen*: cint
    setflag*: cint

  REAPER_cue* {.ReaperAPI.} = object
    m_id*: cint
    m_time*: cdouble
    m_endtime*: cdouble
    m_isregion*: bool
    m_name*: cstring
    m_flags*: cint
    resvd*: array[124, char]

  REAPER_inline_positioninfo* {.ReaperAPI.} = object
    draw_start_time*: cdouble
    draw_start_y*: cint
    pixels_per_second*: cdouble
    width*: cint
    height*: cint
    mouse_x*: cint
    mouse_y*: cint
    extraParms*: array[8, pointer]

  midi_quantize_mode_t* {.ReaperAPI.} = object
    doquant*: bool
    movemode*: char
    sizemode*: char
    quantstrength*: char
    quantamt*: cdouble
    swingamt*: char
    range_min*: char
    range_max*: char

  accelerator_register_t* {.ReaperAPI.} = object
    translateAccel*: proc(msg: ptr MSG, ctx: ptr accelerator_register_t): cint {.cdecl.}
    isLocal*: bool
    user*: pointer

  custom_action_register_t* {.ReaperAPI.} = object
    uniqueSectionId*: cint
    idStr*: cstring
    name*: cstring
    extra*: pointer

  # gaccel_register_t* {.ReaperAPI.} = object
  #   accel*: ACCEL
  #   desc*: cstring

  action_help_t* {.ReaperAPI.} = object
    action_desc*: cstring
    action_help*: cstring

  editor_register_t* {.ReaperAPI.} = object
    editFile*: proc(filename: cstring; parent: HWND; trackidx: cint): cint {.cdecl.}
    wouldHandle*: proc(filename: cstring): cstring {.cdecl.}

  prefs_page_register_t* {.ReaperAPI.} = object
    idstr*: cstring
    displayname*: cstring
    create*: proc (par: HWND): HWND {.cdecl.}
    par_id*: cint
    par_idstr*: cstring
    childrenFlag*: cint
    treeitem*: pointer
    hwndCache*: HWND
    extra*: array[64, char]

  KbdCmd* {.ReaperAPI.} = object
    cmd*: DWORD
    text*: cstring

  KbdKeyBindingInfo* {.ReaperAPI.} = object
    key*: cint
    cmd*: cint
    flags*: cint

  KbdSectionInfo* {.ReaperAPI.} = object
    uniqueID*: cint
    name*: cstring
    action_list*: ptr KbdCmd
    action_list_cnt*: cint
    def_keys*: ptr KbdKeyBindingInfo
    def_keys_cnt*: cint
    onAction*: proc (cmd: cint; val: cint; valhw: cint; relmode: cint; hwnd: HWND): bool {.cdecl.}
    accels*: pointer
    recent_cmds*: pointer
    extended_data*: array[32, pointer]