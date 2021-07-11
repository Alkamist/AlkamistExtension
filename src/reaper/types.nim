import winapi

const ReaperHeader* = "reaper/reaper_cpp/reaper_plugin_functions.h"

type
  LICE_pixel* = cuint
  LICE_pixel_chan* = cuchar
  ReaProject = object
  MediaTrack = object
  MediaItem = object
  MediaItem_Take = object
  TrackEnvelope = object

  reaper_plugin_info_t* {.bycopy.} = object
    caller_version*: cint
    hwnd_main*: HWND
    Register*: proc (name: cstring; infostruct: pointer): cint
    GetFunc*: proc (name: cstring): pointer

  MIDI_event_t* {.bycopy.} = object
    frame_offset*: cint
    size*: cint
    midi_message*: array[4, cuchar]

  MIDI_eventprops* {.bycopy.} = object
    ppqpos*: cdouble
    ppqpos_end_or_bezier_tension*: cdouble
    flag*: char
    msg*: array[3, cuchar]
    varmsg*: cstring
    varmsglen*: cint
    setflag*: cint

  PCM_source_transfer_t* {.bycopy.} = object
    time_s*: cdouble
    samplerate*: cdouble
    nch*: cint
    length*: cint
    samples*: ptr ReaSample
    samples_out*: cint
    midi_events*: ptr MIDI_eventlist
    approximate_playback_latency*: cdouble
    absolute_time_s*: cdouble
    force_bpm*: cdouble

  midi_realtime_write_struct_t* {.bycopy.} = object
    global_time*: cdouble
    global_item_time*: cdouble
    srate*: cdouble
    length*: cint
    overwritemode*: cint
    events*: ptr MIDI_eventlist
    item_playrate*: cdouble
    latency*: cdouble
    overwrite_actives*: ptr cuint
    do_not_quantize_past_sec*: cdouble

  REAPER_cue* {.bycopy.} = object
    m_id*: cint
    m_time*: cdouble
    m_endtime*: cdouble
    m_isregion*: bool
    m_name*: cstring
    m_flags*: cint
    resvd*: array[124, char]

  REAPER_slice* {.bycopy.} = object
    m_sliceSrc*: ptr PCM_source
    m_beatSnapOffset*: cdouble
    flag*: cint
    resvd*: array[124, char]

  REAPER_inline_positioninfo* {.bycopy.} = object
    draw_start_time*: cdouble
    draw_start_y*: cint
    pixels_per_second*: cdouble
    width*: cint
    height*: cint
    mouse_x*: cint
    mouse_y*: cint
    extraParms*: array[8, pointer]

  pcmsrc_register_t* {.bycopy.} = object
    CreateFromType*: proc (`type`: cstring; priority: cint): ptr PCM_source
    CreateFromFile*: proc (filename: cstring; priority: cint): ptr PCM_source
    EnumFileExtensions*: proc (i: cint; descptr: cstringArray): cstring

  midi_quantize_mode_t* {.bycopy.} = object
    doquant*: bool
    movemode*: char
    sizemode*: char
    quantstrength*: char
    quantamt*: cdouble
    swingamt*: char
    range_min*: char
    range_max*: char

  pcmsink_register_t* {.bycopy.} = object
    GetFmt*: proc (desc: cstringArray): cuint
    GetExtension*: proc (cfg: pointer; cfg_l: cint): cstring
    ShowConfig*: proc (cfg: pointer; cfg_l: cint; parent: HWND): HWND
    CreateSink*: proc (filename: cstring; cfg: pointer; cfg_l: cint; nch: cint;
                     srate: cint; buildpeaks: bool): ptr PCM_sink

  pcmsink_register_ext_t* {.bycopy.} = object
    sink*: pcmsink_register_t
    Extended*: proc (call: cint; parm1: pointer; parm2: pointer; parm3: pointer): cint
    expand*: array[256, char]

  accelerator_register_t* {.bycopy.} = object
    translateAccel*: proc (msg: ptr MSG; ctx: ptr accelerator_register_t): cint
    isLocal*: bool
    user*: pointer

  custom_action_register_t* {.bycopy.} = object
    uniqueSectionId*: cint
    idStr*: cstring
    name*: cstring
    extra*: pointer

  gaccel_register_t* {.bycopy.} = object
    accel*: ACCEL
    desc*: cstring

  action_help_t* {.bycopy.} = object
    action_desc*: cstring
    action_help*: cstring

  editor_register_t* {.bycopy.} = object
    editFile*: proc (filename: cstring; parent: HWND; trackidx: cint): cint
    wouldHandle*: proc (filename: cstring): cstring

  project_import_register_t* {.bycopy.} = object
    WantProjectFile*: proc (fn: cstring): bool
    EnumFileExtensions*: proc (i: cint; descptr: cstringArray): cstring
    LoadProject*: proc (fn: cstring; genstate: ptr ProjectStateContext): cint

  project_config_extension_t* {.bycopy.} = object
    ProcessExtensionLine*: proc (line: cstring; ctx: ptr ProjectStateContext;
                               isUndo: bool; reg: ptr project_config_extension_t): bool
    SaveExtensionConfig*: proc (ctx: ptr ProjectStateContext; isUndo: bool;
                              reg: ptr project_config_extension_t)
    BeginLoadProjectState*: proc (isUndo: bool; reg: ptr project_config_extension_t)
    userData*: pointer

  prefs_page_register_t* {.bycopy.} = object
    idstr*: cstring
    displayname*: cstring
    create*: proc (par: HWND): HWND
    par_id*: cint
    par_idstr*: cstring
    childrenFlag*: cint
    treeitem*: pointer
    hwndCache*: HWND
    _extra*: array[64, char]

  audio_hook_register_t* {.bycopy.} = object
    OnAudioBuffer*: proc (isPost: bool; len: cint; srate: cdouble;
                        reg: ptr audio_hook_register_t)
    userdata1*: pointer
    userdata2*: pointer
    input_nch*: cint
    output_nch*: cint
    GetBuffer*: proc (isOutput: bool; idx: cint): ptr ReaSample

  KbdCmd* {.bycopy.} = object
    cmd*: DWORD
    text*: cstring

  KbdKeyBindingInfo* {.bycopy.} = object
    key*: cint
    cmd*: cint
    flags*: cint

  KbdSectionInfo* {.bycopy.} = object
    uniqueID*: cint
    name*: cstring
    action_list*: ptr KbdCmd
    action_list_cnt*: cint
    def_keys*: ptr KbdKeyBindingInfo
    def_keys_cnt*: cint
    onAction*: proc (cmd: cint; val: cint; valhw: cint; relmode: cint; hwnd: HWND): bool
    accels*: pointer
    recent_cmds*: pointer
    extended_data*: array[32, pointer]