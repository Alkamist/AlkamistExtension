typedef struct reaper_plugin_info_t
{
  int caller_version;
  HWND hwnd_main;
  int (*Register)(const char *name, void *infostruct);
  void * (*GetFunc)(const char *name);
} reaper_plugin_info_t;

enum
{
  PROJSTATECTX_UNDO_REDO=1,
  PROJSTATECTX_SAVE_LOAD=2,
  PROJSTATECTX_CUTCOPY_PASTE=3,
};

struct MIDI_event_t
{
  int frame_offset;
  int size;
  unsigned char midi_message[4];
  bool is_note() const { return (midi_message[0]&0xe0)==0x80; }
  bool is_note_on() const {
    return (midi_message[0]&0xf0)==0x90 && midi_message[2];
  }
  bool is_note_off() const {
    switch (midi_message[0]&0xf0)
    {
      case 0x80: return true;
      case 0x90: return midi_message[2]==0;
    }
    return false;
  }
};

typedef struct
{
  double ppqpos;
  double ppqpos_end_or_bezier_tension;
  char flag;
  unsigned char msg[3];
  char* varmsg;
  int varmsglen;
  int setflag;
} MIDI_eventprops;

typedef struct
{
  double time_s;
  double samplerate;
  int nch;
  int length;
  ReaSample *samples;
  int samples_out;
  MIDI_eventlist *midi_events;
  double approximate_playback_latency;
  double absolute_time_s;
  double force_bpm;
} PCM_source_transfer_t;

typedef struct
{
  double global_time;
  double global_item_time;
  double srate;
  int length;
  int overwritemode;
  MIDI_eventlist *events;
  double item_playrate;
  double latency;
  unsigned int *overwrite_actives;
  double do_not_quantize_past_sec;
} midi_realtime_write_struct_t;

typedef struct
{
  int m_id;
  double m_time;
  double m_endtime;
  bool m_isregion;
  char *m_name;
  int m_flags;
  char resvd[124];
} REAPER_cue;

typedef struct
{
  PCM_source* m_sliceSrc;
  double m_beatSnapOffset;
  int flag;
  char resvd[124];
} REAPER_slice;

typedef struct
{
  double draw_start_time;
  int draw_start_y;
  double pixels_per_second;
  int width, height;
  int mouse_x, mouse_y;
  void *extraParms[8];
} REAPER_inline_positioninfo;

typedef struct {
  PCM_source *(*CreateFromType)(const char *type, int priority);
  PCM_source *(*CreateFromFile)(const char *filename, int priority);
  const char *(*EnumFileExtensions)(int i, const char **descptr);
} pcmsrc_register_t;

typedef struct
{
  bool doquant;
  char movemode;
  char sizemode;
  char quantstrength;
  double quantamt;
  char swingamt;
  char range_min;
  char range_max;
} midi_quantize_mode_t;

typedef struct
{
  unsigned int (*GetFmt)(const char **desc);
  const char *(*GetExtension)(const void *cfg, int cfg_l);
  HWND (*ShowConfig)(const void *cfg, int cfg_l, HWND parent);
  PCM_sink *(*CreateSink)(const char *filename, void *cfg, int cfg_l, int nch, int srate, bool buildpeaks);
} pcmsink_register_t;

typedef struct
{
  pcmsink_register_t sink;
  int (*Extended)(int call, void* parm1, void* parm2, void* parm3);
  char expand[256];
} pcmsink_register_ext_t;

typedef struct accelerator_register_t
{
  int (*translateAccel)(MSG *msg, accelerator_register_t *ctx);
  bool isLocal;
  void *user;
} accelerator_register_t;

typedef struct
{
  int uniqueSectionId;
  const char* idStr;
  const char* name;
  void *extra;
} custom_action_register_t;

typedef struct
{
  ACCEL accel;
  const char *desc;
} gaccel_register_t;

typedef struct
{
  const char* action_desc;
  const char* action_help;
} action_help_t;

typedef struct
{
  int (*editFile)(const char *filename, HWND parent, int trackidx);
  const char *(*wouldHandle)(const char *filename);
} editor_register_t;

typedef struct
{
  bool (*WantProjectFile)(const char *fn);
  const char *(*EnumFileExtensions)(int i, char **descptr);
  int (*LoadProject)(const char *fn, ProjectStateContext *genstate);
} project_import_register_t;

typedef struct project_config_extension_t
{
  bool (*ProcessExtensionLine)(const char *line, ProjectStateContext *ctx, bool isUndo, struct project_config_extension_t *reg);
  void (*SaveExtensionConfig)(ProjectStateContext *ctx, bool isUndo, struct project_config_extension_t *reg);
  void (*BeginLoadProjectState)(bool isUndo, struct project_config_extension_t *reg);
  void *userData;
} project_config_extension_t;

typedef struct prefs_page_register_t
{
  const char *idstr;
  const char *displayname;
  HWND (*create)(HWND par);
  int par_id;
  const char *par_idstr;
  int childrenFlag;
  void *treeitem;
  HWND hwndCache;
  char _extra[64];
} prefs_page_register_t;

typedef struct audio_hook_register_t
{
  void (*OnAudioBuffer)(bool isPost, int len, double srate, struct audio_hook_register_t *reg);
  void *userdata1;
  void *userdata2;
  int input_nch, output_nch;
  ReaSample *(*GetBuffer)(bool isOutput, int idx);
} audio_hook_register_t;

struct KbdAccel;

typedef struct
{
  DWORD cmd;
  const char *text;
} KbdCmd;

typedef struct
{
  int key;
  int cmd;
  int flags;
} KbdKeyBindingInfo;

typedef struct
{
  int uniqueID;
  const char *name;
  KbdCmd *action_list;
  int action_list_cnt;
  KbdKeyBindingInfo *def_keys;
  int def_keys_cnt;
  bool (*onAction)(int cmd, int val, int valhw, int relmode, HWND hwnd);
  void* accels;
  void *recent_cmds;
  void *extended_data[32];
} KbdSectionInfo;