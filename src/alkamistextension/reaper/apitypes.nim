import ../winapi

const
  ReaperPluginHeader* = "../reapersdk/reaper_plugin.h"
  ReaperPluginFunctionsHeader* = "../reapersdk/reaper_plugin_functions.h"

type
  ReaProject* {.importc, header: ReaperPluginHeader.} = object
  MediaTrack* {.importc, header: ReaperPluginHeader.} = object
  MediaItem* {.importc, header: ReaperPluginHeader.} = object
  MediaItem_Take* {.importc, header: ReaperPluginHeader.} = object
  TrackEnvelope* {.importc, header: ReaperPluginHeader.} = object
  PCM_source* {.importc, header: ReaperPluginHeader.} = object

  AudioAccessor* {.importc, header: ReaperPluginFunctionsHeader.} = object

  WDL_VirtualWnd_BGCfg* {.importc, header: ReaperPluginFunctionsHeader.} = object
  joystick_device* {.importc, header: ReaperPluginFunctionsHeader.} = object

  reaper_plugin_info_t* {.importc, header: ReaperPluginHeader.} = object
    caller_version*: cint
    hwnd_main*: HWND
    Register*: proc(name: cstring; infostruct: pointer): cint {.cdecl.}
    GetFunc*: proc(name: cstring): pointer {.cdecl.}

  MIDI_event_t* {.importc, header: ReaperPluginHeader.} = object
    frame_offset*: cint
    size*: cint
    midi_message*: array[4, cuchar]

  MIDI_eventprops* {.importc, header: ReaperPluginHeader.} = object
    ppqpos*: cdouble
    ppqpos_end_or_bezier_tension*: cdouble
    flag*: char
    msg*: array[3, cuchar]
    varmsg*: cstring
    varmsglen*: cint
    setflag*: cint

  REAPER_cue* {.importc, header: ReaperPluginHeader.} = object
    m_id*: cint
    m_time*: cdouble
    m_endtime*: cdouble
    m_isregion*: bool
    m_name*: cstring
    m_flags*: cint
    resvd*: array[124, char]

  REAPER_inline_positioninfo* {.importc, header: ReaperPluginHeader.} = object
    draw_start_time*: cdouble
    draw_start_y*: cint
    pixels_per_second*: cdouble
    width*: cint
    height*: cint
    mouse_x*: cint
    mouse_y*: cint
    extraParms*: array[8, pointer]

  midi_quantize_mode_t* {.importc, header: ReaperPluginHeader.} = object
    doquant*: bool
    movemode*: char
    sizemode*: char
    quantstrength*: char
    quantamt*: cdouble
    swingamt*: char
    range_min*: char
    range_max*: char

  accelerator_register_t* {.importc, header: ReaperPluginHeader.} = object
    translateAccel*: proc(msg: ptr MSG, ctx: ptr accelerator_register_t): cint {.cdecl.}
    isLocal*: bool
    user*: pointer

  custom_action_register_t* {.importc, header: ReaperPluginHeader.} = object
    uniqueSectionId*: cint
    idStr*: cstring
    name*: cstring
    extra*: pointer

  gaccel_register_t* {.importc, header: ReaperPluginHeader.} = object
    accel*: ACCEL
    desc*: cstring

  action_help_t* {.importc, header: ReaperPluginHeader.} = object
    action_desc*: cstring
    action_help*: cstring

  editor_register_t* {.importc, header: ReaperPluginHeader.} = object
    editFile*: proc(filename: cstring; parent: HWND; trackidx: cint): cint {.cdecl.}
    wouldHandle*: proc(filename: cstring): cstring {.cdecl.}

  prefs_page_register_t* {.importc, header: ReaperPluginHeader.} = object
    idstr*: cstring
    displayname*: cstring
    create*: proc(par: HWND): HWND {.cdecl.}
    par_id*: cint
    par_idstr*: cstring
    childrenFlag*: cint
    treeitem*: pointer
    hwndCache*: HWND
    extra*: array[64, char]

  KbdCmd* {.importc, header: ReaperPluginHeader.} = object
    cmd*: DWORD
    text*: cstring

  KbdKeyBindingInfo* {.importc, header: ReaperPluginHeader.} = object
    key*: cint
    cmd*: cint
    flags*: cint

  KbdSectionInfo* {.importc, header: ReaperPluginHeader.} = object
    uniqueID*: cint
    name*: cstring
    action_list*: ptr KbdCmd
    action_list_cnt*: cint
    def_keys*: ptr KbdKeyBindingInfo
    def_keys_cnt*: cint
    onAction*: proc(cmd: cint; val: cint; valhw: cint; relmode: cint; hwnd: HWND): bool {.cdecl.}
    accels*: pointer
    recent_cmds*: pointer
    extended_data*: array[32, pointer]