import header

type
  LICE_pixel* = cuint
  LICE_pixel_chan* = cuchar

proc __mergesort*(base: pointer; nmemb: csize_t; size: csize_t;
                 cmpfunc: proc (a1: pointer; a2: pointer): cint {.importc, header: ReaperHeader.};
                 tmpspace: pointer) {.importc, header: ReaperHeader.}
proc AddCustomizableMenu*(menuidstr: cstring; menuname: cstring; kbdsecname: cstring;
                         addtomainmenu: bool): bool {.importc, header: ReaperHeader.}
proc AddExtensionsMainMenu*(): bool {.importc, header: ReaperHeader.}
proc AddMediaItemToTrack*(tr: ptr MediaTrack): ptr MediaItem {.importc, header: ReaperHeader.}
proc AddProjectMarker*(proj: ptr ReaProject; isrgn: bool; pos: cdouble; rgnend: cdouble;
                      name: cstring; wantidx: cint): cint {.importc, header: ReaperHeader.}
proc AddProjectMarker2*(proj: ptr ReaProject; isrgn: bool; pos: cdouble;
                       rgnend: cdouble; name: cstring; wantidx: cint; color: cint): cint {.
    importc, header: ReaperHeader.}
proc AddRemoveReaScript*(add: bool; sectionID: cint; scriptfn: cstring; commit: bool): cint {.
    importc, header: ReaperHeader.}
proc AddTakeToMediaItem*(item: ptr MediaItem): ptr MediaItem_Take {.importc, header: ReaperHeader.}
proc AddTempoTimeSigMarker*(proj: ptr ReaProject; timepos: cdouble; bpm: cdouble;
                           timesig_num: cint; timesig_denom: cint;
                           lineartempochange: bool): bool {.importc, header: ReaperHeader.}
proc adjustZoom*(amt: cdouble; forceset: cint; doupd: bool; centermode: cint) {.importc, header: ReaperHeader.}
proc AnyTrackSolo*(proj: ptr ReaProject): bool {.importc, header: ReaperHeader.}
proc APIExists*(function_name: cstring): bool {.importc, header: ReaperHeader.}
proc APITest*() {.importc, header: ReaperHeader.}
proc ApplyNudge*(project: ptr ReaProject; nudgeflag: cint; nudgewhat: cint;
                nudgeunits: cint; value: cdouble; reverse: bool; copies: cint): bool {.
    importc, header: ReaperHeader.}
proc ArmCommand*(cmd: cint; sectionname: cstring) {.importc, header: ReaperHeader.}
proc Audio_Init*() {.importc, header: ReaperHeader.}
proc Audio_IsPreBuffer*(): cint {.importc, header: ReaperHeader.}
proc Audio_IsRunning*(): cint {.importc, header: ReaperHeader.}
proc Audio_Quit*() {.importc, header: ReaperHeader.}
proc Audio_RegHardwareHook*(isAdd: bool; reg: ptr audio_hook_register_t): cint {.importc, header: ReaperHeader.}
proc AudioAccessorStateChanged*(accessor: ptr AudioAccessor): bool {.importc, header: ReaperHeader.}
proc AudioAccessorUpdate*(accessor: ptr AudioAccessor) {.importc, header: ReaperHeader.}
proc AudioAccessorValidateState*(accessor: ptr AudioAccessor): bool {.importc, header: ReaperHeader.}
proc BypassFxAllTracks*(bypass: cint) {.importc, header: ReaperHeader.}
proc CalculatePeaks*(srcBlock: ptr PCM_source_transfer_t;
                    pksBlock: ptr PCM_source_peaktransfer_t): cint {.importc, header: ReaperHeader.}
proc CalculatePeaksFloatSrcPtr*(srcBlock: ptr PCM_source_transfer_t;
                               pksBlock: ptr PCM_source_peaktransfer_t): cint {.
    importc, header: ReaperHeader.}
proc ClearAllRecArmed*() {.importc, header: ReaperHeader.}
proc ClearConsole*() {.importc, header: ReaperHeader.}
proc ClearPeakCache*() {.importc, header: ReaperHeader.}
proc ColorFromNative*(col: cint; rOut: ptr cint; gOut: ptr cint; bOut: ptr cint) {.importc, header: ReaperHeader.}
proc ColorToNative*(r: cint; g: cint; b: cint): cint {.importc, header: ReaperHeader.}
proc CountActionShortcuts*(section: ptr KbdSectionInfo; cmdID: cint): cint {.importc, header: ReaperHeader.}
proc CountAutomationItems*(env: ptr TrackEnvelope): cint {.importc, header: ReaperHeader.}
proc CountEnvelopePoints*(envelope: ptr TrackEnvelope): cint {.importc, header: ReaperHeader.}
proc CountEnvelopePointsEx*(envelope: ptr TrackEnvelope; autoitem_idx: cint): cint {.
    importc, header: ReaperHeader.}
proc CountMediaItems*(proj: ptr ReaProject): cint {.importc, header: ReaperHeader.}
proc CountProjectMarkers*(proj: ptr ReaProject; num_markersOut: ptr cint;
                         num_regionsOut: ptr cint): cint {.importc, header: ReaperHeader.}
proc CountSelectedMediaItems*(proj: ptr ReaProject): cint {.importc, header: ReaperHeader.}
proc CountSelectedTracks*(proj: ptr ReaProject): cint {.importc, header: ReaperHeader.}
proc CountSelectedTracks2*(proj: ptr ReaProject; wantmaster: bool): cint {.importc, header: ReaperHeader.}
proc CountTakeEnvelopes*(take: ptr MediaItem_Take): cint {.importc, header: ReaperHeader.}
proc CountTakes*(item: ptr MediaItem): cint {.importc, header: ReaperHeader.}
proc CountTCPFXParms*(project: ptr ReaProject; track: ptr MediaTrack): cint {.importc, header: ReaperHeader.}
proc CountTempoTimeSigMarkers*(proj: ptr ReaProject): cint {.importc, header: ReaperHeader.}
proc CountTrackEnvelopes*(track: ptr MediaTrack): cint {.importc, header: ReaperHeader.}
proc CountTrackMediaItems*(track: ptr MediaTrack): cint {.importc, header: ReaperHeader.}
proc CountTracks*(projOptional: ptr ReaProject): cint {.importc, header: ReaperHeader.}
proc CreateLocalOscHandler*(obj: pointer; callback: pointer): pointer {.importc, header: ReaperHeader.}
proc CreateMIDIInput*(dev: cint): ptr midi_Input {.importc, header: ReaperHeader.}
proc CreateMIDIOutput*(dev: cint; streamMode: bool; msoffset100: ptr cint): ptr midi_Output {.
    importc, header: ReaperHeader.}
proc CreateNewMIDIItemInProj*(track: ptr MediaTrack; starttime: cdouble;
                             endtime: cdouble; qnInOptional: ptr bool): ptr MediaItem {.
    importc, header: ReaperHeader.}
proc CreateTakeAudioAccessor*(take: ptr MediaItem_Take): ptr AudioAccessor {.importc, header: ReaperHeader.}
proc CreateTrackAudioAccessor*(track: ptr MediaTrack): ptr AudioAccessor {.importc, header: ReaperHeader.}
proc CreateTrackSend*(tr: ptr MediaTrack; desttrInOptional: ptr MediaTrack): cint {.
    importc, header: ReaperHeader.}
proc CSurf_FlushUndo*(force: bool) {.importc, header: ReaperHeader.}
proc CSurf_GetTouchState*(trackid: ptr MediaTrack; isPan: cint): bool {.importc, header: ReaperHeader.}
proc CSurf_GoEnd*() {.importc, header: ReaperHeader.}
proc CSurf_GoStart*() {.importc, header: ReaperHeader.}
proc CSurf_NumTracks*(mcpView: bool): cint {.importc, header: ReaperHeader.}
proc CSurf_OnArrow*(whichdir: cint; wantzoom: bool) {.importc, header: ReaperHeader.}
proc CSurf_OnFwd*(seekplay: cint) {.importc, header: ReaperHeader.}
proc CSurf_OnFXChange*(trackid: ptr MediaTrack; en: cint): bool {.importc, header: ReaperHeader.}
proc CSurf_OnInputMonitorChange*(trackid: ptr MediaTrack; monitor: cint): cint {.importc, header: ReaperHeader.}
proc CSurf_OnInputMonitorChangeEx*(trackid: ptr MediaTrack; monitor: cint;
                                  allowgang: bool): cint {.importc, header: ReaperHeader.}
proc CSurf_OnMuteChange*(trackid: ptr MediaTrack; mute: cint): bool {.importc, header: ReaperHeader.}
proc CSurf_OnMuteChangeEx*(trackid: ptr MediaTrack; mute: cint; allowgang: bool): bool {.
    importc, header: ReaperHeader.}
proc CSurf_OnOscControlMessage*(msg: cstring; arg: ptr cfloat) {.importc, header: ReaperHeader.}
proc CSurf_OnPanChange*(trackid: ptr MediaTrack; pan: cdouble; relative: bool): cdouble {.
    importc, header: ReaperHeader.}
proc CSurf_OnPanChangeEx*(trackid: ptr MediaTrack; pan: cdouble; relative: bool;
                         allowGang: bool): cdouble {.importc, header: ReaperHeader.}
proc CSurf_OnPause*() {.importc, header: ReaperHeader.}
proc CSurf_OnPlay*() {.importc, header: ReaperHeader.}
proc CSurf_OnPlayRateChange*(playrate: cdouble) {.importc, header: ReaperHeader.}
proc CSurf_OnRecArmChange*(trackid: ptr MediaTrack; recarm: cint): bool {.importc, header: ReaperHeader.}
proc CSurf_OnRecArmChangeEx*(trackid: ptr MediaTrack; recarm: cint; allowgang: bool): bool {.
    importc, header: ReaperHeader.}
proc CSurf_OnRecord*() {.importc, header: ReaperHeader.}
proc CSurf_OnRecvPanChange*(trackid: ptr MediaTrack; recv_index: cint; pan: cdouble;
                           relative: bool): cdouble {.importc, header: ReaperHeader.}
proc CSurf_OnRecvVolumeChange*(trackid: ptr MediaTrack; recv_index: cint;
                              volume: cdouble; relative: bool): cdouble {.importc, header: ReaperHeader.}
proc CSurf_OnRew*(seekplay: cint) {.importc, header: ReaperHeader.}
proc CSurf_OnRewFwd*(seekplay: cint; dir: cint) {.importc, header: ReaperHeader.}
proc CSurf_OnScroll*(xdir: cint; ydir: cint) {.importc, header: ReaperHeader.}
proc CSurf_OnSelectedChange*(trackid: ptr MediaTrack; selected: cint): bool {.importc, header: ReaperHeader.}
proc CSurf_OnSendPanChange*(trackid: ptr MediaTrack; send_index: cint; pan: cdouble;
                           relative: bool): cdouble {.importc, header: ReaperHeader.}
proc CSurf_OnSendVolumeChange*(trackid: ptr MediaTrack; send_index: cint;
                              volume: cdouble; relative: bool): cdouble {.importc, header: ReaperHeader.}
proc CSurf_OnSoloChange*(trackid: ptr MediaTrack; solo: cint): bool {.importc, header: ReaperHeader.}
proc CSurf_OnSoloChangeEx*(trackid: ptr MediaTrack; solo: cint; allowgang: bool): bool {.
    importc, header: ReaperHeader.}
proc CSurf_OnStop*() {.importc, header: ReaperHeader.}
proc CSurf_OnTempoChange*(bpm: cdouble) {.importc, header: ReaperHeader.}
proc CSurf_OnTrackSelection*(trackid: ptr MediaTrack) {.importc, header: ReaperHeader.}
proc CSurf_OnVolumeChange*(trackid: ptr MediaTrack; volume: cdouble; relative: bool): cdouble {.
    importc, header: ReaperHeader.}
proc CSurf_OnVolumeChangeEx*(trackid: ptr MediaTrack; volume: cdouble; relative: bool;
                            allowGang: bool): cdouble {.importc, header: ReaperHeader.}
proc CSurf_OnWidthChange*(trackid: ptr MediaTrack; width: cdouble; relative: bool): cdouble {.
    importc, header: ReaperHeader.}
proc CSurf_OnWidthChangeEx*(trackid: ptr MediaTrack; width: cdouble; relative: bool;
                           allowGang: bool): cdouble {.importc, header: ReaperHeader.}
proc CSurf_OnZoom*(xdir: cint; ydir: cint) {.importc, header: ReaperHeader.}
proc CSurf_ResetAllCachedVolPanStates*() {.importc, header: ReaperHeader.}
proc CSurf_ScrubAmt*(amt: cdouble) {.importc, header: ReaperHeader.}
proc CSurf_SetAutoMode*(mode: cint; ignoresurf: ptr IReaperControlSurface) {.importc, header: ReaperHeader.}
proc CSurf_SetPlayState*(play: bool; pause: bool; rec: bool;
                        ignoresurf: ptr IReaperControlSurface) {.importc, header: ReaperHeader.}
proc CSurf_SetRepeatState*(rep: bool; ignoresurf: ptr IReaperControlSurface) {.importc, header: ReaperHeader.}
proc CSurf_SetSurfaceMute*(trackid: ptr MediaTrack; mute: bool;
                          ignoresurf: ptr IReaperControlSurface) {.importc, header: ReaperHeader.}
proc CSurf_SetSurfacePan*(trackid: ptr MediaTrack; pan: cdouble;
                         ignoresurf: ptr IReaperControlSurface) {.importc, header: ReaperHeader.}
proc CSurf_SetSurfaceRecArm*(trackid: ptr MediaTrack; recarm: bool;
                            ignoresurf: ptr IReaperControlSurface) {.importc, header: ReaperHeader.}
proc CSurf_SetSurfaceSelected*(trackid: ptr MediaTrack; selected: bool;
                              ignoresurf: ptr IReaperControlSurface) {.importc, header: ReaperHeader.}
proc CSurf_SetSurfaceSolo*(trackid: ptr MediaTrack; solo: bool;
                          ignoresurf: ptr IReaperControlSurface) {.importc, header: ReaperHeader.}
proc CSurf_SetSurfaceVolume*(trackid: ptr MediaTrack; volume: cdouble;
                            ignoresurf: ptr IReaperControlSurface) {.importc, header: ReaperHeader.}
proc CSurf_SetTrackListChange*() {.importc, header: ReaperHeader.}
proc CSurf_TrackFromID*(idx: cint; mcpView: bool): ptr MediaTrack {.importc, header: ReaperHeader.}
proc CSurf_TrackToID*(track: ptr MediaTrack; mcpView: bool): cint {.importc, header: ReaperHeader.}
proc DB2SLIDER*(x: cdouble): cdouble {.importc, header: ReaperHeader.}
proc DeleteActionShortcut*(section: ptr KbdSectionInfo; cmdID: cint; shortcutidx: cint): bool {.
    importc, header: ReaperHeader.}
proc DeleteEnvelopePointEx*(envelope: ptr TrackEnvelope; autoitem_idx: cint;
                           ptidx: cint): bool {.importc, header: ReaperHeader.}
proc DeleteEnvelopePointRange*(envelope: ptr TrackEnvelope; time_start: cdouble;
                              time_end: cdouble): bool {.importc, header: ReaperHeader.}
proc DeleteEnvelopePointRangeEx*(envelope: ptr TrackEnvelope; autoitem_idx: cint;
                                time_start: cdouble; time_end: cdouble): bool {.importc, header: ReaperHeader.}
proc DeleteExtState*(section: cstring; key: cstring; persist: bool) {.importc, header: ReaperHeader.}
proc DeleteProjectMarker*(proj: ptr ReaProject; markrgnindexnumber: cint; isrgn: bool): bool {.
    importc, header: ReaperHeader.}
proc DeleteProjectMarkerByIndex*(proj: ptr ReaProject; markrgnidx: cint): bool {.importc, header: ReaperHeader.}
proc DeleteTakeMarker*(take: ptr MediaItem_Take; idx: cint): bool {.importc, header: ReaperHeader.}
proc DeleteTakeStretchMarkers*(take: ptr MediaItem_Take; idx: cint;
                              countInOptional: ptr cint): cint {.importc, header: ReaperHeader.}
proc DeleteTempoTimeSigMarker*(project: ptr ReaProject; markerindex: cint): bool {.
    importc, header: ReaperHeader.}
proc DeleteTrack*(tr: ptr MediaTrack) {.importc, header: ReaperHeader.}
proc DeleteTrackMediaItem*(tr: ptr MediaTrack; it: ptr MediaItem): bool {.importc, header: ReaperHeader.}
proc DestroyAudioAccessor*(accessor: ptr AudioAccessor) {.importc, header: ReaperHeader.}
proc DestroyLocalOscHandler*(local_osc_handler: pointer) {.importc, header: ReaperHeader.}
proc DoActionShortcutDialog*(hwnd: HWND; section: ptr KbdSectionInfo; cmdID: cint;
                            shortcutidx: cint): bool {.importc, header: ReaperHeader.}
proc Dock_UpdateDockID*(ident_str: cstring; whichDock: cint) {.importc, header: ReaperHeader.}
proc DockGetPosition*(whichDock: cint): cint {.importc, header: ReaperHeader.}
proc DockIsChildOfDock*(hwnd: HWND; isFloatingDockerOut: ptr bool): cint {.importc, header: ReaperHeader.}
proc DockWindowActivate*(hwnd: HWND) {.importc, header: ReaperHeader.}
proc DockWindowAdd*(hwnd: HWND; name: cstring; pos: cint; allowShow: bool) {.importc, header: ReaperHeader.}
proc DockWindowAddEx*(hwnd: HWND; name: cstring; identstr: cstring; allowShow: bool) {.
    importc, header: ReaperHeader.}
proc DockWindowRefresh*() {.importc, header: ReaperHeader.}
proc DockWindowRefreshForHWND*(hwnd: HWND) {.importc, header: ReaperHeader.}
proc DockWindowRemove*(hwnd: HWND) {.importc, header: ReaperHeader.}
proc DuplicateCustomizableMenu*(srcmenu: pointer; destmenu: pointer): bool {.importc, header: ReaperHeader.}
proc EditTempoTimeSigMarker*(project: ptr ReaProject; markerindex: cint): bool {.importc, header: ReaperHeader.}
proc EnsureNotCompletelyOffscreen*(rInOut: ptr RECT) {.importc, header: ReaperHeader.}
proc EnumerateFiles*(path: cstring; fileindex: cint): cstring {.importc, header: ReaperHeader.}
proc EnumerateSubdirectories*(path: cstring; subdirindex: cint): cstring {.importc, header: ReaperHeader.}
proc EnumPitchShiftModes*(mode: cint; strOut: cstringArray): bool {.importc, header: ReaperHeader.}
proc EnumPitchShiftSubModes*(mode: cint; submode: cint): cstring {.importc, header: ReaperHeader.}
proc EnumProjectMarkers*(idx: cint; isrgnOut: ptr bool; posOut: ptr cdouble;
                        rgnendOut: ptr cdouble; nameOut: cstringArray;
                        markrgnindexnumberOut: ptr cint): cint {.importc, header: ReaperHeader.}
proc EnumProjectMarkers2*(proj: ptr ReaProject; idx: cint; isrgnOut: ptr bool;
                         posOut: ptr cdouble; rgnendOut: ptr cdouble;
                         nameOut: cstringArray; markrgnindexnumberOut: ptr cint): cint {.
    importc, header: ReaperHeader.}
proc EnumProjectMarkers3*(proj: ptr ReaProject; idx: cint; isrgnOut: ptr bool;
                         posOut: ptr cdouble; rgnendOut: ptr cdouble;
                         nameOut: cstringArray; markrgnindexnumberOut: ptr cint;
                         colorOut: ptr cint): cint {.importc, header: ReaperHeader.}
proc EnumProjects*(idx: cint; projfnOutOptional: cstring; projfnOutOptional_sz: cint): ptr ReaProject {.
    importc, header: ReaperHeader.}
proc EnumProjExtState*(proj: ptr ReaProject; extname: cstring; idx: cint;
                      keyOutOptional: cstring; keyOutOptional_sz: cint;
                      valOutOptional: cstring; valOutOptional_sz: cint): bool {.importc, header: ReaperHeader.}
proc EnumRegionRenderMatrix*(proj: ptr ReaProject; regionindex: cint;
                            rendertrack: cint): ptr MediaTrack {.importc, header: ReaperHeader.}
proc EnumTrackMIDIProgramNames*(track: cint; programNumber: cint;
                               programName: cstring; programName_sz: cint): bool {.
    importc, header: ReaperHeader.}
proc EnumTrackMIDIProgramNamesEx*(proj: ptr ReaProject; track: ptr MediaTrack;
                                 programNumber: cint; programName: cstring;
                                 programName_sz: cint): bool {.importc, header: ReaperHeader.}
proc Envelope_Evaluate*(envelope: ptr TrackEnvelope; time: cdouble;
                       samplerate: cdouble; samplesRequested: cint;
                       valueOutOptional: ptr cdouble; dVdSOutOptional: ptr cdouble;
                       ddVdSOutOptional: ptr cdouble;
                       dddVdSOutOptional: ptr cdouble): cint {.importc, header: ReaperHeader.}
proc Envelope_FormatValue*(env: ptr TrackEnvelope; value: cdouble; bufOut: cstring;
                          bufOut_sz: cint) {.importc, header: ReaperHeader.}
proc Envelope_GetParentTake*(env: ptr TrackEnvelope; indexOutOptional: ptr cint;
                            index2OutOptional: ptr cint): ptr MediaItem_Take {.importc, header: ReaperHeader.}
proc Envelope_GetParentTrack*(env: ptr TrackEnvelope; indexOutOptional: ptr cint;
                             index2OutOptional: ptr cint): ptr MediaTrack {.importc, header: ReaperHeader.}
proc Envelope_SortPoints*(envelope: ptr TrackEnvelope): bool {.importc, header: ReaperHeader.}
proc Envelope_SortPointsEx*(envelope: ptr TrackEnvelope; autoitem_idx: cint): bool {.
    importc, header: ReaperHeader.}
proc ExecProcess*(cmdline: cstring; timeoutmsec: cint): cstring {.importc, header: ReaperHeader.}
proc file_exists*(path: cstring): bool {.importc, header: ReaperHeader.}
proc FindTempoTimeSigMarker*(project: ptr ReaProject; time: cdouble): cint {.importc, header: ReaperHeader.}
proc format_timestr*(tpos: cdouble; buf: cstring; buf_sz: cint) {.importc, header: ReaperHeader.}
proc format_timestr_len*(tpos: cdouble; buf: cstring; buf_sz: cint; offset: cdouble;
                        modeoverride: cint) {.importc, header: ReaperHeader.}
proc format_timestr_pos*(tpos: cdouble; buf: cstring; buf_sz: cint; modeoverride: cint) {.
    importc, header: ReaperHeader.}
proc FreeHeapPtr*(`ptr`: pointer) {.importc, header: ReaperHeader.}
proc genGuid*(g: ptr GUID) {.importc, header: ReaperHeader.}
proc get_config_var*(name: cstring; szOut: ptr cint): pointer {.importc, header: ReaperHeader.}
proc get_config_var_string*(name: cstring; bufOut: cstring; bufOut_sz: cint): bool {.
    importc, header: ReaperHeader.}
proc get_ini_file*(): cstring {.importc, header: ReaperHeader.}
proc get_midi_config_var*(name: cstring; szOut: ptr cint): pointer {.importc, header: ReaperHeader.}
proc GetActionShortcutDesc*(section: ptr KbdSectionInfo; cmdID: cint;
                           shortcutidx: cint; desc: cstring; desclen: cint): bool {.
    importc, header: ReaperHeader.}
proc GetActiveTake*(item: ptr MediaItem): ptr MediaItem_Take {.importc, header: ReaperHeader.}
proc GetAllProjectPlayStates*(ignoreProject: ptr ReaProject): cint {.importc, header: ReaperHeader.}
proc GetAppVersion*(): cstring {.importc, header: ReaperHeader.}
proc GetArmedCommand*(secOut: cstring; secOut_sz: cint): cint {.importc, header: ReaperHeader.}
proc GetAudioAccessorEndTime*(accessor: ptr AudioAccessor): cdouble {.importc, header: ReaperHeader.}
proc GetAudioAccessorHash*(accessor: ptr AudioAccessor; hashNeed128: cstring) {.importc, header: ReaperHeader.}
proc GetAudioAccessorSamples*(accessor: ptr AudioAccessor; samplerate: cint;
                             numchannels: cint; starttime_sec: cdouble;
                             numsamplesperchannel: cint; samplebuffer: ptr cdouble): cint {.
    importc, header: ReaperHeader.}
proc GetAudioAccessorStartTime*(accessor: ptr AudioAccessor): cdouble {.importc, header: ReaperHeader.}
proc GetAudioDeviceInfo*(attribute: cstring; desc: cstring; desc_sz: cint): bool {.importc, header: ReaperHeader.}
proc GetColorTheme*(idx: cint; defval: cint): INT_PTR {.importc, header: ReaperHeader.}
proc GetColorThemeStruct*(szOut: ptr cint): pointer {.importc, header: ReaperHeader.}
proc GetConfigWantsDock*(ident_str: cstring): cint {.importc, header: ReaperHeader.}
proc GetContextMenu*(idx: cint): HMENU {.importc, header: ReaperHeader.}
proc GetCurrentProjectInLoadSave*(): ptr ReaProject {.importc, header: ReaperHeader.}
proc GetCursorContext*(): cint {.importc, header: ReaperHeader.}
proc GetCursorContext2*(want_last_valid: bool): cint {.importc, header: ReaperHeader.}
proc GetCursorPosition*(): cdouble {.importc, header: ReaperHeader.}
proc GetCursorPositionEx*(proj: ptr ReaProject): cdouble {.importc, header: ReaperHeader.}
proc GetDisplayedMediaItemColor*(item: ptr MediaItem): cint {.importc, header: ReaperHeader.}
proc GetDisplayedMediaItemColor2*(item: ptr MediaItem; take: ptr MediaItem_Take): cint {.
    importc, header: ReaperHeader.}
proc GetEnvelopeInfo_Value*(tr: ptr TrackEnvelope; parmname: cstring): cdouble {.importc, header: ReaperHeader.}
proc GetEnvelopeName*(env: ptr TrackEnvelope; bufOut: cstring; bufOut_sz: cint): bool {.
    importc, header: ReaperHeader.}
proc GetEnvelopePoint*(envelope: ptr TrackEnvelope; ptidx: cint;
                      timeOutOptional: ptr cdouble; valueOutOptional: ptr cdouble;
                      shapeOutOptional: ptr cint; tensionOutOptional: ptr cdouble;
                      selectedOutOptional: ptr bool): bool {.importc, header: ReaperHeader.}
proc GetEnvelopePointByTime*(envelope: ptr TrackEnvelope; time: cdouble): cint {.importc, header: ReaperHeader.}
proc GetEnvelopePointByTimeEx*(envelope: ptr TrackEnvelope; autoitem_idx: cint;
                              time: cdouble): cint {.importc, header: ReaperHeader.}
proc GetEnvelopePointEx*(envelope: ptr TrackEnvelope; autoitem_idx: cint; ptidx: cint;
                        timeOutOptional: ptr cdouble;
                        valueOutOptional: ptr cdouble; shapeOutOptional: ptr cint;
                        tensionOutOptional: ptr cdouble;
                        selectedOutOptional: ptr bool): bool {.importc, header: ReaperHeader.}
proc GetEnvelopeScalingMode*(env: ptr TrackEnvelope): cint {.importc, header: ReaperHeader.}
proc GetEnvelopeStateChunk*(env: ptr TrackEnvelope; strNeedBig: cstring;
                           strNeedBig_sz: cint; isundoOptional: bool): bool {.importc, header: ReaperHeader.}
proc GetExePath*(): cstring {.importc, header: ReaperHeader.}
proc GetExtState*(section: cstring; key: cstring): cstring {.importc, header: ReaperHeader.}
proc GetFocusedFX*(tracknumberOut: ptr cint; itemnumberOut: ptr cint;
                  fxnumberOut: ptr cint): cint {.importc, header: ReaperHeader.}
proc GetFocusedFX2*(tracknumberOut: ptr cint; itemnumberOut: ptr cint;
                   fxnumberOut: ptr cint): cint {.importc, header: ReaperHeader.}
proc GetFreeDiskSpaceForRecordPath*(proj: ptr ReaProject; pathidx: cint): cint {.importc, header: ReaperHeader.}
proc GetFXEnvelope*(track: ptr MediaTrack; fxindex: cint; parameterindex: cint;
                   create: bool): ptr TrackEnvelope {.importc, header: ReaperHeader.}
proc GetGlobalAutomationOverride*(): cint {.importc, header: ReaperHeader.}
proc GetHZoomLevel*(): cdouble {.importc, header: ReaperHeader.}
proc GetIconThemePointer*(name: cstring): pointer {.importc, header: ReaperHeader.}
proc GetIconThemePointerForDPI*(name: cstring; dpisc: cint): pointer {.importc, header: ReaperHeader.}
proc GetIconThemeStruct*(szOut: ptr cint): pointer {.importc, header: ReaperHeader.}
proc GetInputChannelName*(channelIndex: cint): cstring {.importc, header: ReaperHeader.}
proc GetInputOutputLatency*(inputlatencyOut: ptr cint; outputLatencyOut: ptr cint) {.
    importc, header: ReaperHeader.}
proc GetItemEditingTime2*(which_itemOut: ptr ptr PCM_source; flagsOut: ptr cint): cdouble {.
    importc, header: ReaperHeader.}
proc GetItemFromPoint*(screen_x: cint; screen_y: cint; allow_locked: bool;
                      takeOutOptional: ptr ptr MediaItem_Take): ptr MediaItem {.importc, header: ReaperHeader.}
proc GetItemProjectContext*(item: ptr MediaItem): ptr ReaProject {.importc, header: ReaperHeader.}
proc GetItemStateChunk*(item: ptr MediaItem; strNeedBig: cstring; strNeedBig_sz: cint;
                       isundoOptional: bool): bool {.importc, header: ReaperHeader.}
proc GetLastColorThemeFile*(): cstring {.importc, header: ReaperHeader.}
proc GetLastMarkerAndCurRegion*(proj: ptr ReaProject; time: cdouble;
                               markeridxOut: ptr cint; regionidxOut: ptr cint) {.importc, header: ReaperHeader.}
proc GetLastTouchedFX*(tracknumberOut: ptr cint; fxnumberOut: ptr cint;
                      paramnumberOut: ptr cint): bool {.importc, header: ReaperHeader.}
proc GetLastTouchedTrack*(): ptr MediaTrack {.importc, header: ReaperHeader.}
proc GetMainHwnd*(): HWND {.importc, header: ReaperHeader.}
proc GetMasterMuteSoloFlags*(): cint {.importc, header: ReaperHeader.}
proc GetMasterTrack*(proj: ptr ReaProject): ptr MediaTrack {.importc, header: ReaperHeader.}
proc GetMasterTrackVisibility*(): cint {.importc, header: ReaperHeader.}
proc GetMaxMidiInputs*(): cint {.importc, header: ReaperHeader.}
proc GetMaxMidiOutputs*(): cint {.importc, header: ReaperHeader.}
proc GetMediaFileMetadata*(mediaSource: ptr PCM_source; identifier: cstring;
                          bufOutNeedBig: cstring; bufOutNeedBig_sz: cint): cint {.
    importc, header: ReaperHeader.}
proc GetMediaItem*(proj: ptr ReaProject; itemidx: cint): ptr MediaItem {.importc, header: ReaperHeader.}
proc GetMediaItem_Track*(item: ptr MediaItem): ptr MediaTrack {.importc, header: ReaperHeader.}
proc GetMediaItemInfo_Value*(item: ptr MediaItem; parmname: cstring): cdouble {.importc, header: ReaperHeader.}
proc GetMediaItemNumTakes*(item: ptr MediaItem): cint {.importc, header: ReaperHeader.}
proc GetMediaItemTake*(item: ptr MediaItem; tk: cint): ptr MediaItem_Take {.importc, header: ReaperHeader.}
proc GetMediaItemTake_Item*(take: ptr MediaItem_Take): ptr MediaItem {.importc, header: ReaperHeader.}
proc GetMediaItemTake_Peaks*(take: ptr MediaItem_Take; peakrate: cdouble;
                            starttime: cdouble; numchannels: cint;
                            numsamplesperchannel: cint; want_extra_type: cint;
                            buf: ptr cdouble): cint {.importc, header: ReaperHeader.}
proc GetMediaItemTake_Source*(take: ptr MediaItem_Take): ptr PCM_source {.importc, header: ReaperHeader.}
proc GetMediaItemTake_Track*(take: ptr MediaItem_Take): ptr MediaTrack {.importc, header: ReaperHeader.}
proc GetMediaItemTakeByGUID*(project: ptr ReaProject; guid: ptr GUID): ptr MediaItem_Take {.
    importc, header: ReaperHeader.}
proc GetMediaItemTakeInfo_Value*(take: ptr MediaItem_Take; parmname: cstring): cdouble {.
    importc, header: ReaperHeader.}
proc GetMediaItemTrack*(item: ptr MediaItem): ptr MediaTrack {.importc, header: ReaperHeader.}
proc GetMediaSourceFileName*(source: ptr PCM_source; filenamebuf: cstring;
                            filenamebuf_sz: cint) {.importc, header: ReaperHeader.}
proc GetMediaSourceLength*(source: ptr PCM_source; lengthIsQNOut: ptr bool): cdouble {.
    importc, header: ReaperHeader.}
proc GetMediaSourceNumChannels*(source: ptr PCM_source): cint {.importc, header: ReaperHeader.}
proc GetMediaSourceParent*(src: ptr PCM_source): ptr PCM_source {.importc, header: ReaperHeader.}
proc GetMediaSourceSampleRate*(source: ptr PCM_source): cint {.importc, header: ReaperHeader.}
proc GetMediaSourceType*(source: ptr PCM_source; typebuf: cstring; typebuf_sz: cint) {.
    importc, header: ReaperHeader.}
proc GetMediaTrackInfo_Value*(tr: ptr MediaTrack; parmname: cstring): cdouble {.importc, header: ReaperHeader.}
proc GetMIDIInputName*(dev: cint; nameout: cstring; nameout_sz: cint): bool {.importc, header: ReaperHeader.}
proc GetMIDIOutputName*(dev: cint; nameout: cstring; nameout_sz: cint): bool {.importc, header: ReaperHeader.}
proc GetMixerScroll*(): ptr MediaTrack {.importc, header: ReaperHeader.}
proc GetMouseModifier*(context: cstring; modifier_flag: cint; action: cstring;
                      action_sz: cint) {.importc, header: ReaperHeader.}
proc GetMousePosition*(xOut: ptr cint; yOut: ptr cint) {.importc, header: ReaperHeader.}
proc GetNumAudioInputs*(): cint {.importc, header: ReaperHeader.}
proc GetNumAudioOutputs*(): cint {.importc, header: ReaperHeader.}
proc GetNumMIDIInputs*(): cint {.importc, header: ReaperHeader.}
proc GetNumMIDIOutputs*(): cint {.importc, header: ReaperHeader.}
proc GetNumTakeMarkers*(take: ptr MediaItem_Take): cint {.importc, header: ReaperHeader.}
proc GetNumTracks*(): cint {.importc, header: ReaperHeader.}
proc GetOS*(): cstring {.importc, header: ReaperHeader.}
proc GetOutputChannelName*(channelIndex: cint): cstring {.importc, header: ReaperHeader.}
proc GetOutputLatency*(): cdouble {.importc, header: ReaperHeader.}
proc GetParentTrack*(track: ptr MediaTrack): ptr MediaTrack {.importc, header: ReaperHeader.}
proc GetPeakFileName*(fn: cstring; buf: cstring; buf_sz: cint) {.importc, header: ReaperHeader.}
proc GetPeakFileNameEx*(fn: cstring; buf: cstring; buf_sz: cint; forWrite: bool) {.importc, header: ReaperHeader.}
proc GetPeakFileNameEx2*(fn: cstring; buf: cstring; buf_sz: cint; forWrite: bool;
                        peaksfileextension: cstring) {.importc, header: ReaperHeader.}
proc GetPeaksBitmap*(pks: ptr PCM_source_peaktransfer_t; maxamp: cdouble; w: cint;
                    h: cint; bmp: ptr LICE_IBitmap): pointer {.importc, header: ReaperHeader.}
proc GetPlayPosition*(): cdouble {.importc, header: ReaperHeader.}
proc GetPlayPosition2*(): cdouble {.importc, header: ReaperHeader.}
proc GetPlayPosition2Ex*(proj: ptr ReaProject): cdouble {.importc, header: ReaperHeader.}
proc GetPlayPositionEx*(proj: ptr ReaProject): cdouble {.importc, header: ReaperHeader.}
proc GetPlayState*(): cint {.importc, header: ReaperHeader.}
proc GetPlayStateEx*(proj: ptr ReaProject): cint {.importc, header: ReaperHeader.}
proc GetPreferredDiskReadMode*(mode: ptr cint; nb: ptr cint; bs: ptr cint) {.importc, header: ReaperHeader.}
proc GetPreferredDiskReadModePeak*(mode: ptr cint; nb: ptr cint; bs: ptr cint) {.importc, header: ReaperHeader.}
proc GetPreferredDiskWriteMode*(mode: ptr cint; nb: ptr cint; bs: ptr cint) {.importc, header: ReaperHeader.}
proc GetProjectLength*(proj: ptr ReaProject): cdouble {.importc, header: ReaperHeader.}
proc GetProjectName*(proj: ptr ReaProject; buf: cstring; buf_sz: cint) {.importc, header: ReaperHeader.}
proc GetProjectPath*(buf: cstring; buf_sz: cint) {.importc, header: ReaperHeader.}
proc GetProjectPathEx*(proj: ptr ReaProject; buf: cstring; buf_sz: cint) {.importc, header: ReaperHeader.}
proc GetProjectStateChangeCount*(proj: ptr ReaProject): cint {.importc, header: ReaperHeader.}
proc GetProjectTimeOffset*(proj: ptr ReaProject; rndframe: bool): cdouble {.importc, header: ReaperHeader.}
proc GetProjectTimeSignature*(bpmOut: ptr cdouble; bpiOut: ptr cdouble) {.importc, header: ReaperHeader.}
proc GetProjectTimeSignature2*(proj: ptr ReaProject; bpmOut: ptr cdouble;
                              bpiOut: ptr cdouble) {.importc, header: ReaperHeader.}
proc GetProjExtState*(proj: ptr ReaProject; extname: cstring; key: cstring;
                     valOutNeedBig: cstring; valOutNeedBig_sz: cint): cint {.importc, header: ReaperHeader.}
proc GetResourcePath*(): cstring {.importc, header: ReaperHeader.}
proc GetSelectedEnvelope*(proj: ptr ReaProject): ptr TrackEnvelope {.importc, header: ReaperHeader.}
proc GetSelectedMediaItem*(proj: ptr ReaProject; selitem: cint): ptr MediaItem {.importc, header: ReaperHeader.}
proc GetSelectedTrack*(proj: ptr ReaProject; seltrackidx: cint): ptr MediaTrack {.importc, header: ReaperHeader.}
proc GetSelectedTrack2*(proj: ptr ReaProject; seltrackidx: cint; wantmaster: bool): ptr MediaTrack {.
    importc, header: ReaperHeader.}
proc GetSelectedTrackEnvelope*(proj: ptr ReaProject): ptr TrackEnvelope {.importc, header: ReaperHeader.}
proc GetSet_ArrangeView2*(proj: ptr ReaProject; isSet: bool; screen_x_start: cint;
                         screen_x_end: cint; start_timeOut: ptr cdouble;
                         end_timeOut: ptr cdouble) {.importc, header: ReaperHeader.}
proc GetSet_LoopTimeRange*(isSet: bool; isLoop: bool; startOut: ptr cdouble;
                          endOut: ptr cdouble; allowautoseek: bool) {.importc, header: ReaperHeader.}
proc GetSet_LoopTimeRange2*(proj: ptr ReaProject; isSet: bool; isLoop: bool;
                           startOut: ptr cdouble; endOut: ptr cdouble;
                           allowautoseek: bool) {.importc, header: ReaperHeader.}
proc GetSetAutomationItemInfo*(env: ptr TrackEnvelope; autoitem_idx: cint;
                              desc: cstring; value: cdouble; is_set: bool): cdouble {.
    importc, header: ReaperHeader.}
proc GetSetAutomationItemInfo_String*(env: ptr TrackEnvelope; autoitem_idx: cint;
                                     desc: cstring; valuestrNeedBig: cstring;
                                     is_set: bool): bool {.importc, header: ReaperHeader.}
proc GetSetEnvelopeInfo_String*(env: ptr TrackEnvelope; parmname: cstring;
                               stringNeedBig: cstring; setNewValue: bool): bool {.
    importc, header: ReaperHeader.}
proc GetSetEnvelopeState*(env: ptr TrackEnvelope; str: cstring; str_sz: cint): bool {.
    importc, header: ReaperHeader.}
proc GetSetEnvelopeState2*(env: ptr TrackEnvelope; str: cstring; str_sz: cint;
                          isundo: bool): bool {.importc, header: ReaperHeader.}
proc GetSetItemState*(item: ptr MediaItem; str: cstring; str_sz: cint): bool {.importc, header: ReaperHeader.}
proc GetSetItemState2*(item: ptr MediaItem; str: cstring; str_sz: cint; isundo: bool): bool {.
    importc, header: ReaperHeader.}
proc GetSetMediaItemInfo*(item: ptr MediaItem; parmname: cstring; setNewValue: pointer): pointer {.
    importc, header: ReaperHeader.}
proc GetSetMediaItemInfo_String*(item: ptr MediaItem; parmname: cstring;
                                stringNeedBig: cstring; setNewValue: bool): bool {.
    importc, header: ReaperHeader.}
proc GetSetMediaItemTakeInfo*(tk: ptr MediaItem_Take; parmname: cstring;
                             setNewValue: pointer): pointer {.importc, header: ReaperHeader.}
proc GetSetMediaItemTakeInfo_String*(tk: ptr MediaItem_Take; parmname: cstring;
                                    stringNeedBig: cstring; setNewValue: bool): bool {.
    importc, header: ReaperHeader.}
proc GetSetMediaTrackInfo*(tr: ptr MediaTrack; parmname: cstring; setNewValue: pointer): pointer {.
    importc, header: ReaperHeader.}
proc GetSetMediaTrackInfo_String*(tr: ptr MediaTrack; parmname: cstring;
                                 stringNeedBig: cstring; setNewValue: bool): bool {.
    importc, header: ReaperHeader.}
proc GetSetObjectState*(obj: pointer; str: cstring): cstring {.importc, header: ReaperHeader.}
proc GetSetObjectState2*(obj: pointer; str: cstring; isundo: bool): cstring {.importc, header: ReaperHeader.}
proc GetSetProjectAuthor*(proj: ptr ReaProject; set: bool; author: cstring;
                         author_sz: cint) {.importc, header: ReaperHeader.}
proc GetSetProjectGrid*(project: ptr ReaProject; set: bool;
                       divisionInOutOptional: ptr cdouble;
                       swingmodeInOutOptional: ptr cint;
                       swingamtInOutOptional: ptr cdouble): cint {.importc, header: ReaperHeader.}
proc GetSetProjectInfo*(project: ptr ReaProject; desc: cstring; value: cdouble;
                       is_set: bool): cdouble {.importc, header: ReaperHeader.}
proc GetSetProjectInfo_String*(project: ptr ReaProject; desc: cstring;
                              valuestrNeedBig: cstring; is_set: bool): bool {.importc, header: ReaperHeader.}
proc GetSetProjectNotes*(proj: ptr ReaProject; set: bool; notesNeedBig: cstring;
                        notesNeedBig_sz: cint) {.importc, header: ReaperHeader.}
proc GetSetRepeat*(val: cint): cint {.importc, header: ReaperHeader.}
proc GetSetRepeatEx*(proj: ptr ReaProject; val: cint): cint {.importc, header: ReaperHeader.}
proc GetSetTrackGroupMembership*(tr: ptr MediaTrack; groupname: cstring;
                                setmask: cuint; setvalue: cuint): cuint {.importc, header: ReaperHeader.}
proc GetSetTrackGroupMembershipHigh*(tr: ptr MediaTrack; groupname: cstring;
                                    setmask: cuint; setvalue: cuint): cuint {.importc, header: ReaperHeader.}
proc GetSetTrackMIDISupportFile*(proj: ptr ReaProject; track: ptr MediaTrack;
                                which: cint; filename: cstring): cstring {.importc, header: ReaperHeader.}
proc GetSetTrackSendInfo*(tr: ptr MediaTrack; category: cint; sendidx: cint;
                         parmname: cstring; setNewValue: pointer): pointer {.importc, header: ReaperHeader.}
proc GetSetTrackSendInfo_String*(tr: ptr MediaTrack; category: cint; sendidx: cint;
                                parmname: cstring; stringNeedBig: cstring;
                                setNewValue: bool): bool {.importc, header: ReaperHeader.}
proc GetSetTrackState*(track: ptr MediaTrack; str: cstring; str_sz: cint): bool {.importc, header: ReaperHeader.}
proc GetSetTrackState2*(track: ptr MediaTrack; str: cstring; str_sz: cint; isundo: bool): bool {.
    importc, header: ReaperHeader.}
proc GetSubProjectFromSource*(src: ptr PCM_source): ptr ReaProject {.importc, header: ReaperHeader.}
proc GetTake*(item: ptr MediaItem; takeidx: cint): ptr MediaItem_Take {.importc, header: ReaperHeader.}
proc GetTakeEnvelope*(take: ptr MediaItem_Take; envidx: cint): ptr TrackEnvelope {.importc, header: ReaperHeader.}
proc GetTakeEnvelopeByName*(take: ptr MediaItem_Take; envname: cstring): ptr TrackEnvelope {.
    importc, header: ReaperHeader.}
proc GetTakeMarker*(take: ptr MediaItem_Take; idx: cint; nameOut: cstring;
                   nameOut_sz: cint; colorOutOptional: ptr cint): cdouble {.importc, header: ReaperHeader.}
proc GetTakeName*(take: ptr MediaItem_Take): cstring {.importc, header: ReaperHeader.}
proc GetTakeNumStretchMarkers*(take: ptr MediaItem_Take): cint {.importc, header: ReaperHeader.}
proc GetTakeStretchMarker*(take: ptr MediaItem_Take; idx: cint; posOut: ptr cdouble;
                          srcposOutOptional: ptr cdouble): cint {.importc, header: ReaperHeader.}
proc GetTakeStretchMarkerSlope*(take: ptr MediaItem_Take; idx: cint): cdouble {.importc, header: ReaperHeader.}
proc GetTCPFXParm*(project: ptr ReaProject; track: ptr MediaTrack; index: cint;
                  fxindexOut: ptr cint; parmidxOut: ptr cint): bool {.importc, header: ReaperHeader.}
proc GetTempoMatchPlayRate*(source: ptr PCM_source; srcscale: cdouble;
                           position: cdouble; mult: cdouble; rateOut: ptr cdouble;
                           targetlenOut: ptr cdouble): bool {.importc, header: ReaperHeader.}
proc GetTempoTimeSigMarker*(proj: ptr ReaProject; ptidx: cint;
                           timeposOut: ptr cdouble; measureposOut: ptr cint;
                           beatposOut: ptr cdouble; bpmOut: ptr cdouble;
                           timesig_numOut: ptr cint; timesig_denomOut: ptr cint;
                           lineartempoOut: ptr bool): bool {.importc, header: ReaperHeader.}
proc GetThemeColor*(ini_key: cstring; flagsOptional: cint): cint {.importc, header: ReaperHeader.}
proc GetToggleCommandState*(command_id: cint): cint {.importc, header: ReaperHeader.}
proc GetToggleCommandState2*(section: ptr KbdSectionInfo; command_id: cint): cint {.
    importc, header: ReaperHeader.}
proc GetToggleCommandStateEx*(section_id: cint; command_id: cint): cint {.importc, header: ReaperHeader.}
proc GetToggleCommandStateThroughHooks*(section: ptr KbdSectionInfo;
                                       command_id: cint): cint {.importc, header: ReaperHeader.}
proc GetTooltipWindow*(): HWND {.importc, header: ReaperHeader.}
proc GetTrack*(proj: ptr ReaProject; trackidx: cint): ptr MediaTrack {.importc, header: ReaperHeader.}
proc GetTrackAutomationMode*(tr: ptr MediaTrack): cint {.importc, header: ReaperHeader.}
proc GetTrackColor*(track: ptr MediaTrack): cint {.importc, header: ReaperHeader.}
proc GetTrackDepth*(track: ptr MediaTrack): cint {.importc, header: ReaperHeader.}
proc GetTrackEnvelope*(track: ptr MediaTrack; envidx: cint): ptr TrackEnvelope {.importc, header: ReaperHeader.}
proc GetTrackEnvelopeByChunkName*(tr: ptr MediaTrack; cfgchunkname: cstring): ptr TrackEnvelope {.
    importc, header: ReaperHeader.}
proc GetTrackEnvelopeByName*(track: ptr MediaTrack; envname: cstring): ptr TrackEnvelope {.
    importc, header: ReaperHeader.}
proc GetTrackFromPoint*(screen_x: cint; screen_y: cint; infoOutOptional: ptr cint): ptr MediaTrack {.
    importc, header: ReaperHeader.}
proc GetTrackGUID*(tr: ptr MediaTrack): ptr GUID {.importc, header: ReaperHeader.}
proc GetTrackInfo*(track: INT_PTR; flags: ptr cint): cstring {.importc, header: ReaperHeader.}
proc GetTrackMediaItem*(tr: ptr MediaTrack; itemidx: cint): ptr MediaItem {.importc, header: ReaperHeader.}
proc GetTrackMIDILyrics*(track: ptr MediaTrack; flag: cint; bufWantNeedBig: cstring;
                        bufWantNeedBig_sz: ptr cint): bool {.importc, header: ReaperHeader.}
proc GetTrackMIDINoteName*(track: cint; pitch: cint; chan: cint): cstring {.importc, header: ReaperHeader.}
proc GetTrackMIDINoteNameEx*(proj: ptr ReaProject; track: ptr MediaTrack; pitch: cint;
                            chan: cint): cstring {.importc, header: ReaperHeader.}
proc GetTrackMIDINoteRange*(proj: ptr ReaProject; track: ptr MediaTrack;
                           note_loOut: ptr cint; note_hiOut: ptr cint) {.importc, header: ReaperHeader.}
proc GetTrackName*(track: ptr MediaTrack; bufOut: cstring; bufOut_sz: cint): bool {.importc, header: ReaperHeader.}
proc GetTrackNumMediaItems*(tr: ptr MediaTrack): cint {.importc, header: ReaperHeader.}
proc GetTrackNumSends*(tr: ptr MediaTrack; category: cint): cint {.importc, header: ReaperHeader.}
proc GetTrackReceiveName*(track: ptr MediaTrack; recv_index: cint; buf: cstring;
                         buf_sz: cint): bool {.importc, header: ReaperHeader.}
proc GetTrackReceiveUIMute*(track: ptr MediaTrack; recv_index: cint; muteOut: ptr bool): bool {.
    importc, header: ReaperHeader.}
proc GetTrackReceiveUIVolPan*(track: ptr MediaTrack; recv_index: cint;
                             volumeOut: ptr cdouble; panOut: ptr cdouble): bool {.importc, header: ReaperHeader.}
proc GetTrackSendInfo_Value*(tr: ptr MediaTrack; category: cint; sendidx: cint;
                            parmname: cstring): cdouble {.importc, header: ReaperHeader.}
proc GetTrackSendName*(track: ptr MediaTrack; send_index: cint; buf: cstring;
                      buf_sz: cint): bool {.importc, header: ReaperHeader.}
proc GetTrackSendUIMute*(track: ptr MediaTrack; send_index: cint; muteOut: ptr bool): bool {.
    importc, header: ReaperHeader.}
proc GetTrackSendUIVolPan*(track: ptr MediaTrack; send_index: cint;
                          volumeOut: ptr cdouble; panOut: ptr cdouble): bool {.importc, header: ReaperHeader.}
proc GetTrackState*(track: ptr MediaTrack; flagsOut: ptr cint): cstring {.importc, header: ReaperHeader.}
proc GetTrackStateChunk*(track: ptr MediaTrack; strNeedBig: cstring;
                        strNeedBig_sz: cint; isundoOptional: bool): bool {.importc, header: ReaperHeader.}
proc GetTrackUIMute*(track: ptr MediaTrack; muteOut: ptr bool): bool {.importc, header: ReaperHeader.}
proc GetTrackUIPan*(track: ptr MediaTrack; pan1Out: ptr cdouble; pan2Out: ptr cdouble;
                   panmodeOut: ptr cint): bool {.importc, header: ReaperHeader.}
proc GetTrackUIVolPan*(track: ptr MediaTrack; volumeOut: ptr cdouble;
                      panOut: ptr cdouble): bool {.importc, header: ReaperHeader.}
proc GetUnderrunTime*(audio_xrunOutOptional: ptr cuint;
                     media_xrunOutOptional: ptr cuint;
                     curtimeOutOptional: ptr cuint) {.importc, header: ReaperHeader.}
proc GetUserFileNameForRead*(filenameNeed4096: cstring; title: cstring;
                            defext: cstring): bool {.importc, header: ReaperHeader.}
proc GetUserInputs*(title: cstring; num_inputs: cint; captions_csv: cstring;
                   retvals_csv: cstring; retvals_csv_sz: cint): bool {.importc, header: ReaperHeader.}
proc GoToMarker*(proj: ptr ReaProject; marker_index: cint; use_timeline_order: bool) {.
    importc, header: ReaperHeader.}
proc GoToRegion*(proj: ptr ReaProject; region_index: cint; use_timeline_order: bool) {.
    importc, header: ReaperHeader.}
proc GR_SelectColor*(hwnd: HWND; colorOut: ptr cint): cint {.importc, header: ReaperHeader.}
proc GSC_mainwnd*(t: cint): cint {.importc, header: ReaperHeader.}
proc guidToString*(g: ptr GUID; destNeed64: cstring) {.importc, header: ReaperHeader.}
proc HasExtState*(section: cstring; key: cstring): bool {.importc, header: ReaperHeader.}
proc HasTrackMIDIPrograms*(track: cint): cstring {.importc, header: ReaperHeader.}
proc HasTrackMIDIProgramsEx*(proj: ptr ReaProject; track: ptr MediaTrack): cstring {.
    importc, header: ReaperHeader.}
proc Help_Set*(helpstring: cstring; is_temporary_help: bool) {.importc, header: ReaperHeader.}
proc HiresPeaksFromSource*(src: ptr PCM_source;
                          `block`: ptr PCM_source_peaktransfer_t) {.importc, header: ReaperHeader.}
proc image_resolve_fn*(`in`: cstring; `out`: cstring; out_sz: cint) {.importc, header: ReaperHeader.}
proc InsertAutomationItem*(env: ptr TrackEnvelope; pool_id: cint; position: cdouble;
                          length: cdouble): cint {.importc, header: ReaperHeader.}
proc InsertEnvelopePoint*(envelope: ptr TrackEnvelope; time: cdouble; value: cdouble;
                         shape: cint; tension: cdouble; selected: bool;
                         noSortInOptional: ptr bool): bool {.importc, header: ReaperHeader.}
proc InsertEnvelopePointEx*(envelope: ptr TrackEnvelope; autoitem_idx: cint;
                           time: cdouble; value: cdouble; shape: cint;
                           tension: cdouble; selected: bool;
                           noSortInOptional: ptr bool): bool {.importc, header: ReaperHeader.}
proc InsertMedia*(file: cstring; mode: cint): cint {.importc, header: ReaperHeader.}
proc InsertMediaSection*(file: cstring; mode: cint; startpct: cdouble; endpct: cdouble;
                        pitchshift: cdouble): cint {.importc, header: ReaperHeader.}
proc InsertTrackAtIndex*(idx: cint; wantDefaults: bool) {.importc, header: ReaperHeader.}
proc IsInRealTimeAudio*(): cint {.importc, header: ReaperHeader.}
proc IsItemTakeActiveForPlayback*(item: ptr MediaItem; take: ptr MediaItem_Take): bool {.
    importc, header: ReaperHeader.}
proc IsMediaExtension*(ext: cstring; wantOthers: bool): bool {.importc, header: ReaperHeader.}
proc IsMediaItemSelected*(item: ptr MediaItem): bool {.importc, header: ReaperHeader.}
proc IsProjectDirty*(proj: ptr ReaProject): cint {.importc, header: ReaperHeader.}
proc IsREAPER*(): bool {.importc, header: ReaperHeader.}
proc IsTrackSelected*(track: ptr MediaTrack): bool {.importc, header: ReaperHeader.}
proc IsTrackVisible*(track: ptr MediaTrack; mixer: bool): bool {.importc, header: ReaperHeader.}
proc joystick_create*(guid: ptr GUID): ptr joystick_device {.importc, header: ReaperHeader.}
proc joystick_destroy*(device: ptr joystick_device) {.importc, header: ReaperHeader.}
proc joystick_enum*(index: cint; namestrOutOptional: cstringArray): cstring {.importc, header: ReaperHeader.}
proc joystick_getaxis*(dev: ptr joystick_device; axis: cint): cdouble {.importc, header: ReaperHeader.}
proc joystick_getbuttonmask*(dev: ptr joystick_device): cuint {.importc, header: ReaperHeader.}
proc joystick_getinfo*(dev: ptr joystick_device; axesOutOptional: ptr cint;
                      povsOutOptional: ptr cint): cint {.importc, header: ReaperHeader.}
proc joystick_getpov*(dev: ptr joystick_device; pov: cint): cdouble {.importc, header: ReaperHeader.}
proc joystick_update*(dev: ptr joystick_device): bool {.importc, header: ReaperHeader.}
proc kbd_enumerateActions*(section: ptr KbdSectionInfo; idx: cint;
                          nameOut: cstringArray): cint {.importc, header: ReaperHeader.}
proc kbd_formatKeyName*(ac: ptr ACCEL; s: cstring) {.importc, header: ReaperHeader.}
proc kbd_getCommandName*(cmd: cint; s: cstring; section: ptr KbdSectionInfo) {.importc, header: ReaperHeader.}
proc kbd_getTextFromCmd*(cmd: DWORD; section: ptr KbdSectionInfo): cstring {.importc, header: ReaperHeader.}
proc KBD_OnMainActionEx*(cmd: cint; val: cint; valhw: cint; relmode: cint; hwnd: HWND;
                        proj: ptr ReaProject): cint {.importc, header: ReaperHeader.}
proc kbd_OnMidiEvent*(evt: ptr MIDI_event_t; dev_index: cint) {.importc, header: ReaperHeader.}
proc kbd_OnMidiList*(list: ptr MIDI_eventlist; dev_index: cint) {.importc, header: ReaperHeader.}
proc kbd_ProcessActionsMenu*(menu: HMENU; section: ptr KbdSectionInfo) {.importc, header: ReaperHeader.}
proc kbd_processMidiEventActionEx*(evt: ptr MIDI_event_t;
                                  section: ptr KbdSectionInfo; hwndCtx: HWND): bool {.
    importc, header: ReaperHeader.}
proc kbd_reprocessMenu*(menu: HMENU; section: ptr KbdSectionInfo) {.importc, header: ReaperHeader.}
proc kbd_RunCommandThroughHooks*(section: ptr KbdSectionInfo;
                                actionCommandID: ptr cint; val: ptr cint;
                                valhw: ptr cint; relmode: ptr cint; hwnd: HWND): bool {.
    importc, header: ReaperHeader.}
proc kbd_translateAccelerator*(hwnd: HWND; msg: ptr MSG; section: ptr KbdSectionInfo): cint {.
    importc, header: ReaperHeader.}
proc kbd_translateMouse*(winmsg: pointer; midimsg: ptr cuchar): bool {.importc, header: ReaperHeader.}
proc LICE__Destroy*(bm: ptr LICE_IBitmap) {.importc, header: ReaperHeader.}
proc LICE__DestroyFont*(font: ptr LICE_IFont) {.importc, header: ReaperHeader.}
proc LICE__DrawText*(font: ptr LICE_IFont; bm: ptr LICE_IBitmap; str: cstring;
                    strcnt: cint; rect: ptr RECT; dtFlags: UINT): cint {.importc, header: ReaperHeader.}
proc LICE__GetBits*(bm: ptr LICE_IBitmap): pointer {.importc, header: ReaperHeader.}
proc LICE__GetDC*(bm: ptr LICE_IBitmap): HDC {.importc, header: ReaperHeader.}
proc LICE__GetHeight*(bm: ptr LICE_IBitmap): cint {.importc, header: ReaperHeader.}
proc LICE__GetRowSpan*(bm: ptr LICE_IBitmap): cint {.importc, header: ReaperHeader.}
proc LICE__GetWidth*(bm: ptr LICE_IBitmap): cint {.importc, header: ReaperHeader.}
proc LICE__IsFlipped*(bm: ptr LICE_IBitmap): bool {.importc, header: ReaperHeader.}
proc LICE__resize*(bm: ptr LICE_IBitmap; w: cint; h: cint): bool {.importc, header: ReaperHeader.}
proc LICE__SetBkColor*(font: ptr LICE_IFont; color: LICE_pixel): LICE_pixel {.importc, header: ReaperHeader.}
proc LICE__SetFromHFont*(font: ptr LICE_IFont; hfont: HFONT; flags: cint) {.importc, header: ReaperHeader.}
proc LICE__SetTextColor*(font: ptr LICE_IFont; color: LICE_pixel): LICE_pixel {.importc, header: ReaperHeader.}
proc LICE__SetTextCombineMode*(ifont: ptr LICE_IFont; mode: cint; alpha: cfloat) {.importc, header: ReaperHeader.}
proc LICE_Arc*(dest: ptr LICE_IBitmap; cx: cfloat; cy: cfloat; r: cfloat;
              minAngle: cfloat; maxAngle: cfloat; color: LICE_pixel; alpha: cfloat;
              mode: cint; aa: bool) {.importc, header: ReaperHeader.}
proc LICE_Blit*(dest: ptr LICE_IBitmap; src: ptr LICE_IBitmap; dstx: cint; dsty: cint;
               srcx: cint; srcy: cint; srcw: cint; srch: cint; alpha: cfloat; mode: cint) {.
    importc, header: ReaperHeader.}
proc LICE_Blur*(dest: ptr LICE_IBitmap; src: ptr LICE_IBitmap; dstx: cint; dsty: cint;
               srcx: cint; srcy: cint; srcw: cint; srch: cint) {.importc, header: ReaperHeader.}
proc LICE_BorderedRect*(dest: ptr LICE_IBitmap; x: cint; y: cint; w: cint; h: cint;
                       bgcolor: LICE_pixel; fgcolor: LICE_pixel; alpha: cfloat;
                       mode: cint) {.importc, header: ReaperHeader.}
proc LICE_Circle*(dest: ptr LICE_IBitmap; cx: cfloat; cy: cfloat; r: cfloat;
                 color: LICE_pixel; alpha: cfloat; mode: cint; aa: bool) {.importc, header: ReaperHeader.}
proc LICE_Clear*(dest: ptr LICE_IBitmap; color: LICE_pixel) {.importc, header: ReaperHeader.}
proc LICE_ClearRect*(dest: ptr LICE_IBitmap; x: cint; y: cint; w: cint; h: cint;
                    mask: LICE_pixel; orbits: LICE_pixel) {.importc, header: ReaperHeader.}
proc LICE_ClipLine*(pX1Out: ptr cint; pY1Out: ptr cint; pX2Out: ptr cint;
                   pY2Out: ptr cint; xLo: cint; yLo: cint; xHi: cint; yHi: cint): bool {.
    importc, header: ReaperHeader.}
proc LICE_Copy*(dest: ptr LICE_IBitmap; src: ptr LICE_IBitmap) {.importc, header: ReaperHeader.}
proc LICE_CreateBitmap*(mode: cint; w: cint; h: cint): ptr LICE_IBitmap {.importc, header: ReaperHeader.}
proc LICE_CreateFont*(): ptr LICE_IFont {.importc, header: ReaperHeader.}
proc LICE_DrawCBezier*(dest: ptr LICE_IBitmap; xstart: cdouble; ystart: cdouble;
                      xctl1: cdouble; yctl1: cdouble; xctl2: cdouble; yctl2: cdouble;
                      xend: cdouble; yend: cdouble; color: LICE_pixel; alpha: cfloat;
                      mode: cint; aa: bool; tol: cdouble) {.importc, header: ReaperHeader.}
proc LICE_DrawChar*(bm: ptr LICE_IBitmap; x: cint; y: cint; c: char; color: LICE_pixel;
                   alpha: cfloat; mode: cint) {.importc, header: ReaperHeader.}
proc LICE_DrawGlyph*(dest: ptr LICE_IBitmap; x: cint; y: cint; color: LICE_pixel;
                    alphas: ptr LICE_pixel_chan; glyph_w: cint; glyph_h: cint;
                    alpha: cfloat; mode: cint) {.importc, header: ReaperHeader.}
proc LICE_DrawRect*(dest: ptr LICE_IBitmap; x: cint; y: cint; w: cint; h: cint;
                   color: LICE_pixel; alpha: cfloat; mode: cint) {.importc, header: ReaperHeader.}
proc LICE_DrawText*(bm: ptr LICE_IBitmap; x: cint; y: cint; string: cstring;
                   color: LICE_pixel; alpha: cfloat; mode: cint) {.importc, header: ReaperHeader.}
proc LICE_FillCBezier*(dest: ptr LICE_IBitmap; xstart: cdouble; ystart: cdouble;
                      xctl1: cdouble; yctl1: cdouble; xctl2: cdouble; yctl2: cdouble;
                      xend: cdouble; yend: cdouble; yfill: cint; color: LICE_pixel;
                      alpha: cfloat; mode: cint; aa: bool; tol: cdouble) {.importc, header: ReaperHeader.}
proc LICE_FillCircle*(dest: ptr LICE_IBitmap; cx: cfloat; cy: cfloat; r: cfloat;
                     color: LICE_pixel; alpha: cfloat; mode: cint; aa: bool) {.importc, header: ReaperHeader.}
proc LICE_FillConvexPolygon*(dest: ptr LICE_IBitmap; x: ptr cint; y: ptr cint;
                            npoints: cint; color: LICE_pixel; alpha: cfloat;
                            mode: cint) {.importc, header: ReaperHeader.}
proc LICE_FillRect*(dest: ptr LICE_IBitmap; x: cint; y: cint; w: cint; h: cint;
                   color: LICE_pixel; alpha: cfloat; mode: cint) {.importc, header: ReaperHeader.}
proc LICE_FillTrapezoid*(dest: ptr LICE_IBitmap; x1a: cint; x1b: cint; y1: cint;
                        x2a: cint; x2b: cint; y2: cint; color: LICE_pixel;
                        alpha: cfloat; mode: cint) {.importc, header: ReaperHeader.}
proc LICE_FillTriangle*(dest: ptr LICE_IBitmap; x1: cint; y1: cint; x2: cint; y2: cint;
                       x3: cint; y3: cint; color: LICE_pixel; alpha: cfloat; mode: cint) {.
    importc, header: ReaperHeader.}
proc LICE_GetPixel*(bm: ptr LICE_IBitmap; x: cint; y: cint): LICE_pixel {.importc, header: ReaperHeader.}
proc LICE_GradRect*(dest: ptr LICE_IBitmap; dstx: cint; dsty: cint; dstw: cint;
                   dsth: cint; ir: cfloat; ig: cfloat; ib: cfloat; ia: cfloat;
                   drdx: cfloat; dgdx: cfloat; dbdx: cfloat; dadx: cfloat; drdy: cfloat;
                   dgdy: cfloat; dbdy: cfloat; dady: cfloat; mode: cint) {.importc, header: ReaperHeader.}
proc LICE_Line*(dest: ptr LICE_IBitmap; x1: cfloat; y1: cfloat; x2: cfloat; y2: cfloat;
               color: LICE_pixel; alpha: cfloat; mode: cint; aa: bool) {.importc, header: ReaperHeader.}
proc LICE_LineInt*(dest: ptr LICE_IBitmap; x1: cint; y1: cint; x2: cint; y2: cint;
                  color: LICE_pixel; alpha: cfloat; mode: cint; aa: bool) {.importc, header: ReaperHeader.}
proc LICE_LoadPNG*(filename: cstring; bmp: ptr LICE_IBitmap): ptr LICE_IBitmap {.importc, header: ReaperHeader.}
proc LICE_LoadPNGFromResource*(hInst: HINSTANCE; resid: cstring;
                              bmp: ptr LICE_IBitmap): ptr LICE_IBitmap {.importc, header: ReaperHeader.}
proc LICE_MeasureText*(string: cstring; w: ptr cint; h: ptr cint) {.importc, header: ReaperHeader.}
proc LICE_MultiplyAddRect*(dest: ptr LICE_IBitmap; x: cint; y: cint; w: cint; h: cint;
                          rsc: cfloat; gsc: cfloat; bsc: cfloat; asc: cfloat;
                          radd: cfloat; gadd: cfloat; badd: cfloat; aadd: cfloat) {.
    importc, header: ReaperHeader.}
proc LICE_PutPixel*(bm: ptr LICE_IBitmap; x: cint; y: cint; color: LICE_pixel;
                   alpha: cfloat; mode: cint) {.importc, header: ReaperHeader.}
proc LICE_RotatedBlit*(dest: ptr LICE_IBitmap; src: ptr LICE_IBitmap; dstx: cint;
                      dsty: cint; dstw: cint; dsth: cint; srcx: cfloat; srcy: cfloat;
                      srcw: cfloat; srch: cfloat; angle: cfloat;
                      cliptosourcerect: bool; alpha: cfloat; mode: cint;
                      rotxcent: cfloat; rotycent: cfloat) {.importc, header: ReaperHeader.}
proc LICE_RoundRect*(drawbm: ptr LICE_IBitmap; xpos: cfloat; ypos: cfloat; w: cfloat;
                    h: cfloat; cornerradius: cint; col: LICE_pixel; alpha: cfloat;
                    mode: cint; aa: bool) {.importc, header: ReaperHeader.}
proc LICE_ScaledBlit*(dest: ptr LICE_IBitmap; src: ptr LICE_IBitmap; dstx: cint;
                     dsty: cint; dstw: cint; dsth: cint; srcx: cfloat; srcy: cfloat;
                     srcw: cfloat; srch: cfloat; alpha: cfloat; mode: cint) {.importc, header: ReaperHeader.}
proc LICE_SimpleFill*(dest: ptr LICE_IBitmap; x: cint; y: cint; newcolor: LICE_pixel;
                     comparemask: LICE_pixel; keepmask: LICE_pixel) {.importc, header: ReaperHeader.}
proc LocalizeString*(src_string: cstring; section: cstring; flagsOptional: cint): cstring {.
    importc, header: ReaperHeader.}
proc Loop_OnArrow*(project: ptr ReaProject; direction: cint): bool {.importc, header: ReaperHeader.}
proc Main_OnCommand*(command: cint; flag: cint) {.importc, header: ReaperHeader.}
proc Main_OnCommandEx*(command: cint; flag: cint; proj: ptr ReaProject) {.importc, header: ReaperHeader.}
proc Main_openProject*(name: cstring) {.importc, header: ReaperHeader.}
proc Main_SaveProject*(proj: ptr ReaProject; forceSaveAsInOptional: bool) {.importc, header: ReaperHeader.}
proc Main_UpdateLoopInfo*(ignoremask: cint) {.importc, header: ReaperHeader.}
proc MarkProjectDirty*(proj: ptr ReaProject) {.importc, header: ReaperHeader.}
proc MarkTrackItemsDirty*(track: ptr MediaTrack; item: ptr MediaItem) {.importc, header: ReaperHeader.}
proc Master_GetPlayRate*(project: ptr ReaProject): cdouble {.importc, header: ReaperHeader.}
proc Master_GetPlayRateAtTime*(time_s: cdouble; proj: ptr ReaProject): cdouble {.importc, header: ReaperHeader.}
proc Master_GetTempo*(): cdouble {.importc, header: ReaperHeader.}
proc Master_NormalizePlayRate*(playrate: cdouble; isnormalized: bool): cdouble {.importc, header: ReaperHeader.}
proc Master_NormalizeTempo*(bpm: cdouble; isnormalized: bool): cdouble {.importc, header: ReaperHeader.}
proc MB*(msg: cstring; title: cstring; `type`: cint): cint {.importc, header: ReaperHeader.}
proc MediaItemDescendsFromTrack*(item: ptr MediaItem; track: ptr MediaTrack): cint {.
    importc, header: ReaperHeader.}
proc MIDI_CountEvts*(take: ptr MediaItem_Take; notecntOut: ptr cint;
                    ccevtcntOut: ptr cint; textsyxevtcntOut: ptr cint): cint {.importc, header: ReaperHeader.}
proc MIDI_DeleteCC*(take: ptr MediaItem_Take; ccidx: cint): bool {.importc, header: ReaperHeader.}
proc MIDI_DeleteEvt*(take: ptr MediaItem_Take; evtidx: cint): bool {.importc, header: ReaperHeader.}
proc MIDI_DeleteNote*(take: ptr MediaItem_Take; noteidx: cint): bool {.importc, header: ReaperHeader.}
proc MIDI_DeleteTextSysexEvt*(take: ptr MediaItem_Take; textsyxevtidx: cint): bool {.
    importc, header: ReaperHeader.}
proc MIDI_DisableSort*(take: ptr MediaItem_Take) {.importc, header: ReaperHeader.}
proc MIDI_EnumSelCC*(take: ptr MediaItem_Take; ccidx: cint): cint {.importc, header: ReaperHeader.}
proc MIDI_EnumSelEvts*(take: ptr MediaItem_Take; evtidx: cint): cint {.importc, header: ReaperHeader.}
proc MIDI_EnumSelNotes*(take: ptr MediaItem_Take; noteidx: cint): cint {.importc, header: ReaperHeader.}
proc MIDI_EnumSelTextSysexEvts*(take: ptr MediaItem_Take; textsyxidx: cint): cint {.
    importc, header: ReaperHeader.}
proc MIDI_eventlist_Create*(): ptr MIDI_eventlist {.importc, header: ReaperHeader.}
proc MIDI_eventlist_Destroy*(evtlist: ptr MIDI_eventlist) {.importc, header: ReaperHeader.}
proc MIDI_GetAllEvts*(take: ptr MediaItem_Take; bufNeedBig: cstring;
                     bufNeedBig_sz: ptr cint): bool {.importc, header: ReaperHeader.}
proc MIDI_GetCC*(take: ptr MediaItem_Take; ccidx: cint; selectedOut: ptr bool;
                mutedOut: ptr bool; ppqposOut: ptr cdouble; chanmsgOut: ptr cint;
                chanOut: ptr cint; msg2Out: ptr cint; msg3Out: ptr cint): bool {.importc, header: ReaperHeader.}
proc MIDI_GetCCShape*(take: ptr MediaItem_Take; ccidx: cint; shapeOut: ptr cint;
                     beztensionOut: ptr cdouble): bool {.importc, header: ReaperHeader.}
proc MIDI_GetEvt*(take: ptr MediaItem_Take; evtidx: cint; selectedOut: ptr bool;
                 mutedOut: ptr bool; ppqposOut: ptr cdouble; msg: cstring;
                 msg_sz: ptr cint): bool {.importc, header: ReaperHeader.}
proc MIDI_GetGrid*(take: ptr MediaItem_Take; swingOutOptional: ptr cdouble;
                  noteLenOutOptional: ptr cdouble): cdouble {.importc, header: ReaperHeader.}
proc MIDI_GetHash*(take: ptr MediaItem_Take; notesonly: bool; hash: cstring;
                  hash_sz: cint): bool {.importc, header: ReaperHeader.}
proc MIDI_GetNote*(take: ptr MediaItem_Take; noteidx: cint; selectedOut: ptr bool;
                  mutedOut: ptr bool; startppqposOut: ptr cdouble;
                  endppqposOut: ptr cdouble; chanOut: ptr cint; pitchOut: ptr cint;
                  velOut: ptr cint): bool {.importc, header: ReaperHeader.}
proc MIDI_GetPPQPos_EndOfMeasure*(take: ptr MediaItem_Take; ppqpos: cdouble): cdouble {.
    importc, header: ReaperHeader.}
proc MIDI_GetPPQPos_StartOfMeasure*(take: ptr MediaItem_Take; ppqpos: cdouble): cdouble {.
    importc, header: ReaperHeader.}
proc MIDI_GetPPQPosFromProjQN*(take: ptr MediaItem_Take; projqn: cdouble): cdouble {.
    importc, header: ReaperHeader.}
proc MIDI_GetPPQPosFromProjTime*(take: ptr MediaItem_Take; projtime: cdouble): cdouble {.
    importc, header: ReaperHeader.}
proc MIDI_GetProjQNFromPPQPos*(take: ptr MediaItem_Take; ppqpos: cdouble): cdouble {.
    importc, header: ReaperHeader.}
proc MIDI_GetProjTimeFromPPQPos*(take: ptr MediaItem_Take; ppqpos: cdouble): cdouble {.
    importc, header: ReaperHeader.}
proc MIDI_GetScale*(take: ptr MediaItem_Take; rootOut: ptr cint; scaleOut: ptr cint;
                   name: cstring; name_sz: cint): bool {.importc, header: ReaperHeader.}
proc MIDI_GetTextSysexEvt*(take: ptr MediaItem_Take; textsyxevtidx: cint;
                          selectedOutOptional: ptr bool;
                          mutedOutOptional: ptr bool;
                          ppqposOutOptional: ptr cdouble;
                          typeOutOptional: ptr cint; msgOptional: cstring;
                          msgOptional_sz: ptr cint): bool {.importc, header: ReaperHeader.}
proc MIDI_GetTrackHash*(track: ptr MediaTrack; notesonly: bool; hash: cstring;
                       hash_sz: cint): bool {.importc, header: ReaperHeader.}
proc MIDI_InsertCC*(take: ptr MediaItem_Take; selected: bool; muted: bool;
                   ppqpos: cdouble; chanmsg: cint; chan: cint; msg2: cint; msg3: cint): bool {.
    importc, header: ReaperHeader.}
proc MIDI_InsertEvt*(take: ptr MediaItem_Take; selected: bool; muted: bool;
                    ppqpos: cdouble; bytestr: cstring; bytestr_sz: cint): bool {.importc, header: ReaperHeader.}
proc MIDI_InsertNote*(take: ptr MediaItem_Take; selected: bool; muted: bool;
                     startppqpos: cdouble; endppqpos: cdouble; chan: cint;
                     pitch: cint; vel: cint; noSortInOptional: ptr bool): bool {.importc, header: ReaperHeader.}
proc MIDI_InsertTextSysexEvt*(take: ptr MediaItem_Take; selected: bool; muted: bool;
                             ppqpos: cdouble; `type`: cint; bytestr: cstring;
                             bytestr_sz: cint): bool {.importc, header: ReaperHeader.}
proc midi_reinit*() {.importc, header: ReaperHeader.}
proc MIDI_SelectAll*(take: ptr MediaItem_Take; select: bool) {.importc, header: ReaperHeader.}
proc MIDI_SetAllEvts*(take: ptr MediaItem_Take; buf: cstring; buf_sz: cint): bool {.importc, header: ReaperHeader.}
proc MIDI_SetCC*(take: ptr MediaItem_Take; ccidx: cint; selectedInOptional: ptr bool;
                mutedInOptional: ptr bool; ppqposInOptional: ptr cdouble;
                chanmsgInOptional: ptr cint; chanInOptional: ptr cint;
                msg2InOptional: ptr cint; msg3InOptional: ptr cint;
                noSortInOptional: ptr bool): bool {.importc, header: ReaperHeader.}
proc MIDI_SetCCShape*(take: ptr MediaItem_Take; ccidx: cint; shape: cint;
                     beztension: cdouble; noSortInOptional: ptr bool): bool {.importc, header: ReaperHeader.}
proc MIDI_SetEvt*(take: ptr MediaItem_Take; evtidx: cint;
                 selectedInOptional: ptr bool; mutedInOptional: ptr bool;
                 ppqposInOptional: ptr cdouble; msgOptional: cstring;
                 msgOptional_sz: cint; noSortInOptional: ptr bool): bool {.importc, header: ReaperHeader.}
proc MIDI_SetItemExtents*(item: ptr MediaItem; startQN: cdouble; endQN: cdouble): bool {.
    importc, header: ReaperHeader.}
proc MIDI_SetNote*(take: ptr MediaItem_Take; noteidx: cint;
                  selectedInOptional: ptr bool; mutedInOptional: ptr bool;
                  startppqposInOptional: ptr cdouble;
                  endppqposInOptional: ptr cdouble; chanInOptional: ptr cint;
                  pitchInOptional: ptr cint; velInOptional: ptr cint;
                  noSortInOptional: ptr bool): bool {.importc, header: ReaperHeader.}
proc MIDI_SetTextSysexEvt*(take: ptr MediaItem_Take; textsyxevtidx: cint;
                          selectedInOptional: ptr bool; mutedInOptional: ptr bool;
                          ppqposInOptional: ptr cdouble; typeInOptional: ptr cint;
                          msgOptional: cstring; msgOptional_sz: cint;
                          noSortInOptional: ptr bool): bool {.importc, header: ReaperHeader.}
proc MIDI_Sort*(take: ptr MediaItem_Take) {.importc, header: ReaperHeader.}
proc MIDIEditor_GetActive*(): HWND {.importc, header: ReaperHeader.}
proc MIDIEditor_GetMode*(midieditor: HWND): cint {.importc, header: ReaperHeader.}
proc MIDIEditor_GetSetting_int*(midieditor: HWND; setting_desc: cstring): cint {.importc, header: ReaperHeader.}
proc MIDIEditor_GetSetting_str*(midieditor: HWND; setting_desc: cstring;
                               buf: cstring; buf_sz: cint): bool {.importc, header: ReaperHeader.}
proc MIDIEditor_GetTake*(midieditor: HWND): ptr MediaItem_Take {.importc, header: ReaperHeader.}
proc MIDIEditor_LastFocused_OnCommand*(command_id: cint; islistviewcommand: bool): bool {.
    importc, header: ReaperHeader.}
proc MIDIEditor_OnCommand*(midieditor: HWND; command_id: cint): bool {.importc, header: ReaperHeader.}
proc MIDIEditor_SetSetting_int*(midieditor: HWND; setting_desc: cstring;
                               setting: cint): bool {.importc, header: ReaperHeader.}
proc mkpanstr*(strNeed64: cstring; pan: cdouble) {.importc, header: ReaperHeader.}
proc mkvolpanstr*(strNeed64: cstring; vol: cdouble; pan: cdouble) {.importc, header: ReaperHeader.}
proc mkvolstr*(strNeed64: cstring; vol: cdouble) {.importc, header: ReaperHeader.}
proc MoveEditCursor*(adjamt: cdouble; dosel: bool) {.importc, header: ReaperHeader.}
proc MoveMediaItemToTrack*(item: ptr MediaItem; desttr: ptr MediaTrack): bool {.importc, header: ReaperHeader.}
proc MuteAllTracks*(mute: bool) {.importc, header: ReaperHeader.}
proc my_getViewport*(r: ptr RECT; sr: ptr RECT; wantWorkArea: bool) {.importc, header: ReaperHeader.}
proc NamedCommandLookup*(command_name: cstring): cint {.importc, header: ReaperHeader.}
proc OnPauseButton*() {.importc, header: ReaperHeader.}
proc OnPauseButtonEx*(proj: ptr ReaProject) {.importc, header: ReaperHeader.}
proc OnPlayButton*() {.importc, header: ReaperHeader.}
proc OnPlayButtonEx*(proj: ptr ReaProject) {.importc, header: ReaperHeader.}
proc OnStopButton*() {.importc, header: ReaperHeader.}
proc OnStopButtonEx*(proj: ptr ReaProject) {.importc, header: ReaperHeader.}
proc OpenColorThemeFile*(fn: cstring): bool {.importc, header: ReaperHeader.}
proc OpenMediaExplorer*(mediafn: cstring; play: bool): HWND {.importc, header: ReaperHeader.}
proc OscLocalMessageToHost*(message: cstring; valueInOptional: ptr cdouble) {.importc, header: ReaperHeader.}
proc parse_timestr*(buf: cstring): cdouble {.importc, header: ReaperHeader.}
proc parse_timestr_len*(buf: cstring; offset: cdouble; modeoverride: cint): cdouble {.
    importc, header: ReaperHeader.}
proc parse_timestr_pos*(buf: cstring; modeoverride: cint): cdouble {.importc, header: ReaperHeader.}
proc parsepanstr*(str: cstring): cdouble {.importc, header: ReaperHeader.}
proc PCM_Sink_Create*(filename: cstring; cfg: cstring; cfg_sz: cint; nch: cint;
                     srate: cint; buildpeaks: bool): ptr PCM_sink {.importc, header: ReaperHeader.}
proc PCM_Sink_CreateEx*(proj: ptr ReaProject; filename: cstring; cfg: cstring;
                       cfg_sz: cint; nch: cint; srate: cint; buildpeaks: bool): ptr PCM_sink {.
    importc, header: ReaperHeader.}
proc PCM_Sink_CreateMIDIFile*(filename: cstring; cfg: cstring; cfg_sz: cint;
                             bpm: cdouble; `div`: cint): ptr PCM_sink {.importc, header: ReaperHeader.}
proc PCM_Sink_CreateMIDIFileEx*(proj: ptr ReaProject; filename: cstring; cfg: cstring;
                               cfg_sz: cint; bpm: cdouble; `div`: cint): ptr PCM_sink {.
    importc, header: ReaperHeader.}
proc PCM_Sink_Enum*(idx: cint; descstrOut: cstringArray): cuint {.importc, header: ReaperHeader.}
proc PCM_Sink_GetExtension*(data: cstring; data_sz: cint): cstring {.importc, header: ReaperHeader.}
proc PCM_Sink_ShowConfig*(cfg: cstring; cfg_sz: cint; hwndParent: HWND): HWND {.importc, header: ReaperHeader.}
proc PCM_Source_CreateFromFile*(filename: cstring): ptr PCM_source {.importc, header: ReaperHeader.}
proc PCM_Source_CreateFromFileEx*(filename: cstring; forcenoMidiImp: bool): ptr PCM_source {.
    importc, header: ReaperHeader.}
proc PCM_Source_CreateFromSimple*(dec: ptr ISimpleMediaDecoder; fn: cstring): ptr PCM_source {.
    importc, header: ReaperHeader.}
proc PCM_Source_CreateFromType*(sourcetype: cstring): ptr PCM_source {.importc, header: ReaperHeader.}
proc PCM_Source_Destroy*(src: ptr PCM_source) {.importc, header: ReaperHeader.}
proc PCM_Source_GetPeaks*(src: ptr PCM_source; peakrate: cdouble; starttime: cdouble;
                         numchannels: cint; numsamplesperchannel: cint;
                         want_extra_type: cint; buf: ptr cdouble): cint {.importc, header: ReaperHeader.}
proc PCM_Source_GetSectionInfo*(src: ptr PCM_source; offsOut: ptr cdouble;
                               lenOut: ptr cdouble; revOut: ptr bool): bool {.importc, header: ReaperHeader.}
proc PeakBuild_Create*(src: ptr PCM_source; fn: cstring; srate: cint; nch: cint): ptr REAPER_PeakBuild_Interface {.
    importc, header: ReaperHeader.}
proc PeakBuild_CreateEx*(src: ptr PCM_source; fn: cstring; srate: cint; nch: cint;
                        flags: cint): ptr REAPER_PeakBuild_Interface {.importc, header: ReaperHeader.}
proc PeakGet_Create*(fn: cstring; srate: cint; nch: cint): ptr REAPER_PeakGet_Interface {.
    importc, header: ReaperHeader.}
proc PitchShiftSubModeMenu*(hwnd: HWND; x: cint; y: cint; mode: cint; submode_sel: cint): cint {.
    importc, header: ReaperHeader.}
proc PlayPreview*(preview: ptr preview_register_t): cint {.importc, header: ReaperHeader.}
proc PlayPreviewEx*(preview: ptr preview_register_t; bufflags: cint;
                   measure_align: cdouble): cint {.importc, header: ReaperHeader.}
proc PlayTrackPreview*(preview: ptr preview_register_t): cint {.importc, header: ReaperHeader.}
proc PlayTrackPreview2*(proj: ptr ReaProject; preview: ptr preview_register_t): cint {.
    importc, header: ReaperHeader.}
proc PlayTrackPreview2Ex*(proj: ptr ReaProject; preview: ptr preview_register_t;
                         flags: cint; measure_align: cdouble): cint {.importc, header: ReaperHeader.}
proc plugin_getapi*(name: cstring): pointer {.importc, header: ReaperHeader.}
proc plugin_getFilterList*(): cstring {.importc, header: ReaperHeader.}
proc plugin_getImportableProjectFilterList*(): cstring {.importc, header: ReaperHeader.}
proc plugin_register*(name: cstring; infostruct: pointer): cint {.importc, header: ReaperHeader.}
proc PluginWantsAlwaysRunFx*(amt: cint) {.importc, header: ReaperHeader.}
proc PreventUIRefresh*(prevent_count: cint) {.importc, header: ReaperHeader.}
proc projectconfig_var_addr*(proj: ptr ReaProject; idx: cint): pointer {.importc, header: ReaperHeader.}
proc projectconfig_var_getoffs*(name: cstring; szOut: ptr cint): cint {.importc, header: ReaperHeader.}
proc PromptForAction*(session_mode: cint; init_id: cint; section_id: cint): cint {.importc, header: ReaperHeader.}
proc realloc_cmd_ptr*(`ptr`: cstringArray; ptr_size: ptr cint; new_size: cint): bool {.
    importc, header: ReaperHeader.}
proc ReaperGetPitchShiftAPI*(version: cint): ptr IReaperPitchShift {.importc, header: ReaperHeader.}
proc ReaScriptError*(errmsg: cstring) {.importc, header: ReaperHeader.}
proc RecursiveCreateDirectory*(path: cstring; ignored: csize_t): cint {.importc, header: ReaperHeader.}
proc reduce_open_files*(flags: cint): cint {.importc, header: ReaperHeader.}
proc RefreshToolbar*(command_id: cint) {.importc, header: ReaperHeader.}
proc RefreshToolbar2*(section_id: cint; command_id: cint) {.importc, header: ReaperHeader.}
proc relative_fn*(`in`: cstring; `out`: cstring; out_sz: cint) {.importc, header: ReaperHeader.}
proc RemoveTrackSend*(tr: ptr MediaTrack; category: cint; sendidx: cint): bool {.importc, header: ReaperHeader.}
proc RenderFileSection*(source_filename: cstring; target_filename: cstring;
                       start_percent: cdouble; end_percent: cdouble;
                       playrate: cdouble): bool {.importc, header: ReaperHeader.}
proc ReorderSelectedTracks*(beforeTrackIdx: cint; makePrevFolder: cint): bool {.importc, header: ReaperHeader.}
proc Resample_EnumModes*(mode: cint): cstring {.importc, header: ReaperHeader.}
proc Resampler_Create*(): ptr REAPER_Resample_Interface {.importc, header: ReaperHeader.}
proc resolve_fn*(`in`: cstring; `out`: cstring; out_sz: cint) {.importc, header: ReaperHeader.}
proc resolve_fn2*(`in`: cstring; `out`: cstring; out_sz: cint;
                 checkSubDirOptional: cstring) {.importc, header: ReaperHeader.}
proc ReverseNamedCommandLookup*(command_id: cint): cstring {.importc, header: ReaperHeader.}
proc ScaleFromEnvelopeMode*(scaling_mode: cint; val: cdouble): cdouble {.importc, header: ReaperHeader.}
proc ScaleToEnvelopeMode*(scaling_mode: cint; val: cdouble): cdouble {.importc, header: ReaperHeader.}
proc screenset_register*(id: cstring; callbackFunc: pointer; param: pointer) {.importc, header: ReaperHeader.}
proc screenset_registerNew*(id: cstring; callbackFunc: screensetNewCallbackFunc;
                           param: pointer) {.importc, header: ReaperHeader.}
proc screenset_unregister*(id: cstring) {.importc, header: ReaperHeader.}
proc screenset_unregisterByParam*(param: pointer) {.importc, header: ReaperHeader.}
proc screenset_updateLastFocus*(prevWin: HWND) {.importc, header: ReaperHeader.}
proc SectionFromUniqueID*(uniqueID: cint): ptr KbdSectionInfo {.importc, header: ReaperHeader.}
proc SelectAllMediaItems*(proj: ptr ReaProject; selected: bool) {.importc, header: ReaperHeader.}
proc SelectProjectInstance*(proj: ptr ReaProject) {.importc, header: ReaperHeader.}
proc SendLocalOscMessage*(local_osc_handler: pointer; msg: cstring; msglen: cint) {.
    importc, header: ReaperHeader.}
proc SetActiveTake*(take: ptr MediaItem_Take) {.importc, header: ReaperHeader.}
proc SetAutomationMode*(mode: cint; onlySel: bool) {.importc, header: ReaperHeader.}
proc SetCurrentBPM*(__proj: ptr ReaProject; bpm: cdouble; wantUndo: bool) {.importc, header: ReaperHeader.}
proc SetCursorContext*(mode: cint; envInOptional: ptr TrackEnvelope) {.importc, header: ReaperHeader.}
proc SetEditCurPos*(time: cdouble; moveview: bool; seekplay: bool) {.importc, header: ReaperHeader.}
proc SetEditCurPos2*(proj: ptr ReaProject; time: cdouble; moveview: bool; seekplay: bool) {.
    importc, header: ReaperHeader.}
proc SetEnvelopePoint*(envelope: ptr TrackEnvelope; ptidx: cint;
                      timeInOptional: ptr cdouble; valueInOptional: ptr cdouble;
                      shapeInOptional: ptr cint; tensionInOptional: ptr cdouble;
                      selectedInOptional: ptr bool; noSortInOptional: ptr bool): bool {.
    importc, header: ReaperHeader.}
proc SetEnvelopePointEx*(envelope: ptr TrackEnvelope; autoitem_idx: cint; ptidx: cint;
                        timeInOptional: ptr cdouble; valueInOptional: ptr cdouble;
                        shapeInOptional: ptr cint; tensionInOptional: ptr cdouble;
                        selectedInOptional: ptr bool; noSortInOptional: ptr bool): bool {.
    importc, header: ReaperHeader.}
proc SetEnvelopeStateChunk*(env: ptr TrackEnvelope; str: cstring; isundoOptional: bool): bool {.
    importc, header: ReaperHeader.}
proc SetExtState*(section: cstring; key: cstring; value: cstring; persist: bool) {.importc, header: ReaperHeader.}
proc SetGlobalAutomationOverride*(mode: cint) {.importc, header: ReaperHeader.}
proc SetItemStateChunk*(item: ptr MediaItem; str: cstring; isundoOptional: bool): bool {.
    importc, header: ReaperHeader.}
proc SetMasterTrackVisibility*(flag: cint): cint {.importc, header: ReaperHeader.}
proc SetMediaItemInfo_Value*(item: ptr MediaItem; parmname: cstring; newvalue: cdouble): bool {.
    importc, header: ReaperHeader.}
proc SetMediaItemLength*(item: ptr MediaItem; length: cdouble; refreshUI: bool): bool {.
    importc, header: ReaperHeader.}
proc SetMediaItemPosition*(item: ptr MediaItem; position: cdouble; refreshUI: bool): bool {.
    importc, header: ReaperHeader.}
proc SetMediaItemSelected*(item: ptr MediaItem; selected: bool) {.importc, header: ReaperHeader.}
proc SetMediaItemTake_Source*(take: ptr MediaItem_Take; source: ptr PCM_source): bool {.
    importc, header: ReaperHeader.}
proc SetMediaItemTakeInfo_Value*(take: ptr MediaItem_Take; parmname: cstring;
                                newvalue: cdouble): bool {.importc, header: ReaperHeader.}
proc SetMediaTrackInfo_Value*(tr: ptr MediaTrack; parmname: cstring; newvalue: cdouble): bool {.
    importc, header: ReaperHeader.}
proc SetMIDIEditorGrid*(project: ptr ReaProject; division: cdouble) {.importc, header: ReaperHeader.}
proc SetMixerScroll*(leftmosttrack: ptr MediaTrack): ptr MediaTrack {.importc, header: ReaperHeader.}
proc SetMouseModifier*(context: cstring; modifier_flag: cint; action: cstring) {.importc, header: ReaperHeader.}
proc SetOnlyTrackSelected*(track: ptr MediaTrack) {.importc, header: ReaperHeader.}
proc SetProjectGrid*(project: ptr ReaProject; division: cdouble) {.importc, header: ReaperHeader.}
proc SetProjectMarker*(markrgnindexnumber: cint; isrgn: bool; pos: cdouble;
                      rgnend: cdouble; name: cstring): bool {.importc, header: ReaperHeader.}
proc SetProjectMarker2*(proj: ptr ReaProject; markrgnindexnumber: cint; isrgn: bool;
                       pos: cdouble; rgnend: cdouble; name: cstring): bool {.importc, header: ReaperHeader.}
proc SetProjectMarker3*(proj: ptr ReaProject; markrgnindexnumber: cint; isrgn: bool;
                       pos: cdouble; rgnend: cdouble; name: cstring; color: cint): bool {.
    importc, header: ReaperHeader.}
proc SetProjectMarker4*(proj: ptr ReaProject; markrgnindexnumber: cint; isrgn: bool;
                       pos: cdouble; rgnend: cdouble; name: cstring; color: cint;
                       flags: cint): bool {.importc, header: ReaperHeader.}
proc SetProjectMarkerByIndex*(proj: ptr ReaProject; markrgnidx: cint; isrgn: bool;
                             pos: cdouble; rgnend: cdouble; IDnumber: cint;
                             name: cstring; color: cint): bool {.importc, header: ReaperHeader.}
proc SetProjectMarkerByIndex2*(proj: ptr ReaProject; markrgnidx: cint; isrgn: bool;
                              pos: cdouble; rgnend: cdouble; IDnumber: cint;
                              name: cstring; color: cint; flags: cint): bool {.importc, header: ReaperHeader.}
proc SetProjExtState*(proj: ptr ReaProject; extname: cstring; key: cstring;
                     value: cstring): cint {.importc, header: ReaperHeader.}
proc SetRegionRenderMatrix*(proj: ptr ReaProject; regionindex: cint;
                           track: ptr MediaTrack; addorremove: cint) {.importc, header: ReaperHeader.}
proc SetRenderLastError*(errorstr: cstring) {.importc, header: ReaperHeader.}
proc SetTakeMarker*(take: ptr MediaItem_Take; idx: cint; nameIn: cstring;
                   srcposInOptional: ptr cdouble; colorInOptional: ptr cint): cint {.
    importc, header: ReaperHeader.}
proc SetTakeStretchMarker*(take: ptr MediaItem_Take; idx: cint; pos: cdouble;
                          srcposInOptional: ptr cdouble): cint {.importc, header: ReaperHeader.}
proc SetTakeStretchMarkerSlope*(take: ptr MediaItem_Take; idx: cint; slope: cdouble): bool {.
    importc, header: ReaperHeader.}
proc SetTempoTimeSigMarker*(proj: ptr ReaProject; ptidx: cint; timepos: cdouble;
                           measurepos: cint; beatpos: cdouble; bpm: cdouble;
                           timesig_num: cint; timesig_denom: cint; lineartempo: bool): bool {.
    importc, header: ReaperHeader.}
proc SetThemeColor*(ini_key: cstring; color: cint; flagsOptional: cint): cint {.importc, header: ReaperHeader.}
proc SetToggleCommandState*(section_id: cint; command_id: cint; state: cint): bool {.
    importc, header: ReaperHeader.}
proc SetTrackAutomationMode*(tr: ptr MediaTrack; mode: cint) {.importc, header: ReaperHeader.}
proc SetTrackColor*(track: ptr MediaTrack; color: cint) {.importc, header: ReaperHeader.}
proc SetTrackMIDILyrics*(track: ptr MediaTrack; flag: cint; str: cstring): bool {.importc, header: ReaperHeader.}
proc SetTrackMIDINoteName*(track: cint; pitch: cint; chan: cint; name: cstring): bool {.
    importc, header: ReaperHeader.}
proc SetTrackMIDINoteNameEx*(proj: ptr ReaProject; track: ptr MediaTrack; pitch: cint;
                            chan: cint; name: cstring): bool {.importc, header: ReaperHeader.}
proc SetTrackSelected*(track: ptr MediaTrack; selected: bool) {.importc, header: ReaperHeader.}
proc SetTrackSendInfo_Value*(tr: ptr MediaTrack; category: cint; sendidx: cint;
                            parmname: cstring; newvalue: cdouble): bool {.importc, header: ReaperHeader.}
proc SetTrackSendUIPan*(track: ptr MediaTrack; send_idx: cint; pan: cdouble; isend: cint): bool {.
    importc, header: ReaperHeader.}
proc SetTrackSendUIVol*(track: ptr MediaTrack; send_idx: cint; vol: cdouble; isend: cint): bool {.
    importc, header: ReaperHeader.}
proc SetTrackStateChunk*(track: ptr MediaTrack; str: cstring; isundoOptional: bool): bool {.
    importc, header: ReaperHeader.}
proc ShowActionList*(caller: ptr KbdSectionInfo; callerWnd: HWND) {.importc, header: ReaperHeader.}
proc ShowConsoleMsg*(msg: cstring) {.importc, header: ReaperHeader.}
proc ShowMessageBox*(msg: cstring; title: cstring; `type`: cint): cint {.importc, header: ReaperHeader.}
proc ShowPopupMenu*(name: cstring; x: cint; y: cint; hwndParentOptional: HWND;
                   ctxOptional: pointer; ctx2Optional: cint; ctx3Optional: cint) {.
    importc, header: ReaperHeader.}
proc SLIDER2DB*(y: cdouble): cdouble {.importc, header: ReaperHeader.}
proc SnapToGrid*(project: ptr ReaProject; time_pos: cdouble): cdouble {.importc, header: ReaperHeader.}
proc SoloAllTracks*(solo: cint) {.importc, header: ReaperHeader.}
proc Splash_GetWnd*(): HWND {.importc, header: ReaperHeader.}
proc SplitMediaItem*(item: ptr MediaItem; position: cdouble): ptr MediaItem {.importc, header: ReaperHeader.}
proc StopPreview*(preview: ptr preview_register_t): cint {.importc, header: ReaperHeader.}
proc StopTrackPreview*(preview: ptr preview_register_t): cint {.importc, header: ReaperHeader.}
proc StopTrackPreview2*(proj: pointer; preview: ptr preview_register_t): cint {.importc, header: ReaperHeader.}
proc stringToGuid*(str: cstring; g: ptr GUID) {.importc, header: ReaperHeader.}
proc StuffMIDIMessage*(mode: cint; msg1: cint; msg2: cint; msg3: cint) {.importc, header: ReaperHeader.}
proc TakeFX_AddByName*(take: ptr MediaItem_Take; fxname: cstring; instantiate: cint): cint {.
    importc, header: ReaperHeader.}
proc TakeFX_CopyToTake*(src_take: ptr MediaItem_Take; src_fx: cint;
                       dest_take: ptr MediaItem_Take; dest_fx: cint; is_move: bool) {.
    importc, header: ReaperHeader.}
proc TakeFX_CopyToTrack*(src_take: ptr MediaItem_Take; src_fx: cint;
                        dest_track: ptr MediaTrack; dest_fx: cint; is_move: bool) {.
    importc, header: ReaperHeader.}
proc TakeFX_Delete*(take: ptr MediaItem_Take; fx: cint): bool {.importc, header: ReaperHeader.}
proc TakeFX_EndParamEdit*(take: ptr MediaItem_Take; fx: cint; param: cint): bool {.importc, header: ReaperHeader.}
proc TakeFX_FormatParamValue*(take: ptr MediaItem_Take; fx: cint; param: cint;
                             val: cdouble; buf: cstring; buf_sz: cint): bool {.importc, header: ReaperHeader.}
proc TakeFX_FormatParamValueNormalized*(take: ptr MediaItem_Take; fx: cint;
                                       param: cint; value: cdouble; buf: cstring;
                                       buf_sz: cint): bool {.importc, header: ReaperHeader.}
proc TakeFX_GetChainVisible*(take: ptr MediaItem_Take): cint {.importc, header: ReaperHeader.}
proc TakeFX_GetCount*(take: ptr MediaItem_Take): cint {.importc, header: ReaperHeader.}
proc TakeFX_GetEnabled*(take: ptr MediaItem_Take; fx: cint): bool {.importc, header: ReaperHeader.}
proc TakeFX_GetEnvelope*(take: ptr MediaItem_Take; fxindex: cint;
                        parameterindex: cint; create: bool): ptr TrackEnvelope {.importc, header: ReaperHeader.}
proc TakeFX_GetFloatingWindow*(take: ptr MediaItem_Take; index: cint): HWND {.importc, header: ReaperHeader.}
proc TakeFX_GetFormattedParamValue*(take: ptr MediaItem_Take; fx: cint; param: cint;
                                   buf: cstring; buf_sz: cint): bool {.importc, header: ReaperHeader.}
proc TakeFX_GetFXGUID*(take: ptr MediaItem_Take; fx: cint): ptr GUID {.importc, header: ReaperHeader.}
proc TakeFX_GetFXName*(take: ptr MediaItem_Take; fx: cint; buf: cstring; buf_sz: cint): bool {.
    importc, header: ReaperHeader.}
proc TakeFX_GetIOSize*(take: ptr MediaItem_Take; fx: cint;
                      inputPinsOutOptional: ptr cint;
                      outputPinsOutOptional: ptr cint): cint {.importc, header: ReaperHeader.}
proc TakeFX_GetNamedConfigParm*(take: ptr MediaItem_Take; fx: cint; parmname: cstring;
                               bufOut: cstring; bufOut_sz: cint): bool {.importc, header: ReaperHeader.}
proc TakeFX_GetNumParams*(take: ptr MediaItem_Take; fx: cint): cint {.importc, header: ReaperHeader.}
proc TakeFX_GetOffline*(take: ptr MediaItem_Take; fx: cint): bool {.importc, header: ReaperHeader.}
proc TakeFX_GetOpen*(take: ptr MediaItem_Take; fx: cint): bool {.importc, header: ReaperHeader.}
proc TakeFX_GetParam*(take: ptr MediaItem_Take; fx: cint; param: cint;
                     minvalOut: ptr cdouble; maxvalOut: ptr cdouble): cdouble {.importc, header: ReaperHeader.}
proc TakeFX_GetParameterStepSizes*(take: ptr MediaItem_Take; fx: cint; param: cint;
                                  stepOut: ptr cdouble; smallstepOut: ptr cdouble;
                                  largestepOut: ptr cdouble; istoggleOut: ptr bool): bool {.
    importc, header: ReaperHeader.}
proc TakeFX_GetParamEx*(take: ptr MediaItem_Take; fx: cint; param: cint;
                       minvalOut: ptr cdouble; maxvalOut: ptr cdouble;
                       midvalOut: ptr cdouble): cdouble {.importc, header: ReaperHeader.}
proc TakeFX_GetParamName*(take: ptr MediaItem_Take; fx: cint; param: cint; buf: cstring;
                         buf_sz: cint): bool {.importc, header: ReaperHeader.}
proc TakeFX_GetParamNormalized*(take: ptr MediaItem_Take; fx: cint; param: cint): cdouble {.
    importc, header: ReaperHeader.}
proc TakeFX_GetPinMappings*(tr: ptr MediaItem_Take; fx: cint; isoutput: cint; pin: cint;
                           high32OutOptional: ptr cint): cint {.importc, header: ReaperHeader.}
proc TakeFX_GetPreset*(take: ptr MediaItem_Take; fx: cint; presetname: cstring;
                      presetname_sz: cint): bool {.importc, header: ReaperHeader.}
proc TakeFX_GetPresetIndex*(take: ptr MediaItem_Take; fx: cint;
                           numberOfPresetsOut: ptr cint): cint {.importc, header: ReaperHeader.}
proc TakeFX_GetUserPresetFilename*(take: ptr MediaItem_Take; fx: cint; fn: cstring;
                                  fn_sz: cint) {.importc, header: ReaperHeader.}
proc TakeFX_NavigatePresets*(take: ptr MediaItem_Take; fx: cint; presetmove: cint): bool {.
    importc, header: ReaperHeader.}
proc TakeFX_SetEnabled*(take: ptr MediaItem_Take; fx: cint; enabled: bool) {.importc, header: ReaperHeader.}
proc TakeFX_SetNamedConfigParm*(take: ptr MediaItem_Take; fx: cint; parmname: cstring;
                               value: cstring): bool {.importc, header: ReaperHeader.}
proc TakeFX_SetOffline*(take: ptr MediaItem_Take; fx: cint; offline: bool) {.importc, header: ReaperHeader.}
proc TakeFX_SetOpen*(take: ptr MediaItem_Take; fx: cint; open: bool) {.importc, header: ReaperHeader.}
proc TakeFX_SetParam*(take: ptr MediaItem_Take; fx: cint; param: cint; val: cdouble): bool {.
    importc, header: ReaperHeader.}
proc TakeFX_SetParamNormalized*(take: ptr MediaItem_Take; fx: cint; param: cint;
                               value: cdouble): bool {.importc, header: ReaperHeader.}
proc TakeFX_SetPinMappings*(tr: ptr MediaItem_Take; fx: cint; isoutput: cint; pin: cint;
                           low32bits: cint; hi32bits: cint): bool {.importc, header: ReaperHeader.}
proc TakeFX_SetPreset*(take: ptr MediaItem_Take; fx: cint; presetname: cstring): bool {.
    importc, header: ReaperHeader.}
proc TakeFX_SetPresetByIndex*(take: ptr MediaItem_Take; fx: cint; idx: cint): bool {.
    importc, header: ReaperHeader.}
proc TakeFX_Show*(take: ptr MediaItem_Take; index: cint; showFlag: cint) {.importc, header: ReaperHeader.}
proc TakeIsMIDI*(take: ptr MediaItem_Take): bool {.importc, header: ReaperHeader.}
proc ThemeLayout_GetLayout*(section: cstring; idx: cint; nameOut: cstring;
                           nameOut_sz: cint): bool {.importc, header: ReaperHeader.}
proc ThemeLayout_GetParameter*(wp: cint; descOutOptional: cstringArray;
                              valueOutOptional: ptr cint;
                              defValueOutOptional: ptr cint;
                              minValueOutOptional: ptr cint;
                              maxValueOutOptional: ptr cint): cstring {.importc, header: ReaperHeader.}
proc ThemeLayout_RefreshAll*() {.importc, header: ReaperHeader.}
proc ThemeLayout_SetLayout*(section: cstring; layout: cstring): bool {.importc, header: ReaperHeader.}
proc ThemeLayout_SetParameter*(wp: cint; value: cint; persist: bool): bool {.importc, header: ReaperHeader.}
proc time_precise*(): cdouble {.importc, header: ReaperHeader.}
proc TimeMap2_beatsToTime*(proj: ptr ReaProject; tpos: cdouble;
                          measuresInOptional: ptr cint): cdouble {.importc, header: ReaperHeader.}
proc TimeMap2_GetDividedBpmAtTime*(proj: ptr ReaProject; time: cdouble): cdouble {.
    importc, header: ReaperHeader.}
proc TimeMap2_GetNextChangeTime*(proj: ptr ReaProject; time: cdouble): cdouble {.importc, header: ReaperHeader.}
proc TimeMap2_QNToTime*(proj: ptr ReaProject; qn: cdouble): cdouble {.importc, header: ReaperHeader.}
proc TimeMap2_timeToBeats*(proj: ptr ReaProject; tpos: cdouble;
                          measuresOutOptional: ptr cint; cmlOutOptional: ptr cint;
                          fullbeatsOutOptional: ptr cdouble;
                          cdenomOutOptional: ptr cint): cdouble {.importc, header: ReaperHeader.}
proc TimeMap2_timeToQN*(proj: ptr ReaProject; tpos: cdouble): cdouble {.importc, header: ReaperHeader.}
proc TimeMap_curFrameRate*(proj: ptr ReaProject; dropFrameOutOptional: ptr bool): cdouble {.
    importc, header: ReaperHeader.}
proc TimeMap_GetDividedBpmAtTime*(time: cdouble): cdouble {.importc, header: ReaperHeader.}
proc TimeMap_GetMeasureInfo*(proj: ptr ReaProject; measure: cint;
                            qn_startOut: ptr cdouble; qn_endOut: ptr cdouble;
                            timesig_numOut: ptr cint; timesig_denomOut: ptr cint;
                            tempoOut: ptr cdouble): cdouble {.importc, header: ReaperHeader.}
proc TimeMap_GetMetronomePattern*(proj: ptr ReaProject; time: cdouble;
                                 pattern: cstring; pattern_sz: cint): cint {.importc, header: ReaperHeader.}
proc TimeMap_GetTimeSigAtTime*(proj: ptr ReaProject; time: cdouble;
                              timesig_numOut: ptr cint; timesig_denomOut: ptr cint;
                              tempoOut: ptr cdouble) {.importc, header: ReaperHeader.}
proc TimeMap_QNToMeasures*(proj: ptr ReaProject; qn: cdouble;
                          qnMeasureStartOutOptional: ptr cdouble;
                          qnMeasureEndOutOptional: ptr cdouble): cint {.importc, header: ReaperHeader.}
proc TimeMap_QNToTime*(qn: cdouble): cdouble {.importc, header: ReaperHeader.}
proc TimeMap_QNToTime_abs*(proj: ptr ReaProject; qn: cdouble): cdouble {.importc, header: ReaperHeader.}
proc TimeMap_timeToQN*(tpos: cdouble): cdouble {.importc, header: ReaperHeader.}
proc TimeMap_timeToQN_abs*(proj: ptr ReaProject; tpos: cdouble): cdouble {.importc, header: ReaperHeader.}
proc ToggleTrackSendUIMute*(track: ptr MediaTrack; send_idx: cint): bool {.importc, header: ReaperHeader.}
proc Track_GetPeakHoldDB*(track: ptr MediaTrack; channel: cint; clear: bool): cdouble {.
    importc, header: ReaperHeader.}
proc Track_GetPeakInfo*(track: ptr MediaTrack; channel: cint): cdouble {.importc, header: ReaperHeader.}
proc TrackCtl_SetToolTip*(fmt: cstring; xpos: cint; ypos: cint; topmost: bool) {.importc, header: ReaperHeader.}
proc TrackFX_AddByName*(track: ptr MediaTrack; fxname: cstring; recFX: bool;
                       instantiate: cint): cint {.importc, header: ReaperHeader.}
proc TrackFX_CopyToTake*(src_track: ptr MediaTrack; src_fx: cint;
                        dest_take: ptr MediaItem_Take; dest_fx: cint; is_move: bool) {.
    importc, header: ReaperHeader.}
proc TrackFX_CopyToTrack*(src_track: ptr MediaTrack; src_fx: cint;
                         dest_track: ptr MediaTrack; dest_fx: cint; is_move: bool) {.
    importc, header: ReaperHeader.}
proc TrackFX_Delete*(track: ptr MediaTrack; fx: cint): bool {.importc, header: ReaperHeader.}
proc TrackFX_EndParamEdit*(track: ptr MediaTrack; fx: cint; param: cint): bool {.importc, header: ReaperHeader.}
proc TrackFX_FormatParamValue*(track: ptr MediaTrack; fx: cint; param: cint;
                              val: cdouble; buf: cstring; buf_sz: cint): bool {.importc, header: ReaperHeader.}
proc TrackFX_FormatParamValueNormalized*(track: ptr MediaTrack; fx: cint; param: cint;
                                        value: cdouble; buf: cstring; buf_sz: cint): bool {.
    importc, header: ReaperHeader.}
proc TrackFX_GetByName*(track: ptr MediaTrack; fxname: cstring; instantiate: bool): cint {.
    importc, header: ReaperHeader.}
proc TrackFX_GetChainVisible*(track: ptr MediaTrack): cint {.importc, header: ReaperHeader.}
proc TrackFX_GetCount*(track: ptr MediaTrack): cint {.importc, header: ReaperHeader.}
proc TrackFX_GetEnabled*(track: ptr MediaTrack; fx: cint): bool {.importc, header: ReaperHeader.}
proc TrackFX_GetEQ*(track: ptr MediaTrack; instantiate: bool): cint {.importc, header: ReaperHeader.}
proc TrackFX_GetEQBandEnabled*(track: ptr MediaTrack; fxidx: cint; bandtype: cint;
                              bandidx: cint): bool {.importc, header: ReaperHeader.}
proc TrackFX_GetEQParam*(track: ptr MediaTrack; fxidx: cint; paramidx: cint;
                        bandtypeOut: ptr cint; bandidxOut: ptr cint;
                        paramtypeOut: ptr cint; normvalOut: ptr cdouble): bool {.importc, header: ReaperHeader.}
proc TrackFX_GetFloatingWindow*(track: ptr MediaTrack; index: cint): HWND {.importc, header: ReaperHeader.}
proc TrackFX_GetFormattedParamValue*(track: ptr MediaTrack; fx: cint; param: cint;
                                    buf: cstring; buf_sz: cint): bool {.importc, header: ReaperHeader.}
proc TrackFX_GetFXGUID*(track: ptr MediaTrack; fx: cint): ptr GUID {.importc, header: ReaperHeader.}
proc TrackFX_GetFXName*(track: ptr MediaTrack; fx: cint; buf: cstring; buf_sz: cint): bool {.
    importc, header: ReaperHeader.}
proc TrackFX_GetInstrument*(track: ptr MediaTrack): cint {.importc, header: ReaperHeader.}
proc TrackFX_GetIOSize*(track: ptr MediaTrack; fx: cint;
                       inputPinsOutOptional: ptr cint;
                       outputPinsOutOptional: ptr cint): cint {.importc, header: ReaperHeader.}
proc TrackFX_GetNamedConfigParm*(track: ptr MediaTrack; fx: cint; parmname: cstring;
                                bufOut: cstring; bufOut_sz: cint): bool {.importc, header: ReaperHeader.}
proc TrackFX_GetNumParams*(track: ptr MediaTrack; fx: cint): cint {.importc, header: ReaperHeader.}
proc TrackFX_GetOffline*(track: ptr MediaTrack; fx: cint): bool {.importc, header: ReaperHeader.}
proc TrackFX_GetOpen*(track: ptr MediaTrack; fx: cint): bool {.importc, header: ReaperHeader.}
proc TrackFX_GetParam*(track: ptr MediaTrack; fx: cint; param: cint;
                      minvalOut: ptr cdouble; maxvalOut: ptr cdouble): cdouble {.importc, header: ReaperHeader.}
proc TrackFX_GetParameterStepSizes*(track: ptr MediaTrack; fx: cint; param: cint;
                                   stepOut: ptr cdouble; smallstepOut: ptr cdouble;
                                   largestepOut: ptr cdouble; istoggleOut: ptr bool): bool {.
    importc, header: ReaperHeader.}
proc TrackFX_GetParamEx*(track: ptr MediaTrack; fx: cint; param: cint;
                        minvalOut: ptr cdouble; maxvalOut: ptr cdouble;
                        midvalOut: ptr cdouble): cdouble {.importc, header: ReaperHeader.}
proc TrackFX_GetParamName*(track: ptr MediaTrack; fx: cint; param: cint; buf: cstring;
                          buf_sz: cint): bool {.importc, header: ReaperHeader.}
proc TrackFX_GetParamNormalized*(track: ptr MediaTrack; fx: cint; param: cint): cdouble {.
    importc, header: ReaperHeader.}
proc TrackFX_GetPinMappings*(tr: ptr MediaTrack; fx: cint; isoutput: cint; pin: cint;
                            high32OutOptional: ptr cint): cint {.importc, header: ReaperHeader.}
proc TrackFX_GetPreset*(track: ptr MediaTrack; fx: cint; presetname: cstring;
                       presetname_sz: cint): bool {.importc, header: ReaperHeader.}
proc TrackFX_GetPresetIndex*(track: ptr MediaTrack; fx: cint;
                            numberOfPresetsOut: ptr cint): cint {.importc, header: ReaperHeader.}
proc TrackFX_GetRecChainVisible*(track: ptr MediaTrack): cint {.importc, header: ReaperHeader.}
proc TrackFX_GetRecCount*(track: ptr MediaTrack): cint {.importc, header: ReaperHeader.}
proc TrackFX_GetUserPresetFilename*(track: ptr MediaTrack; fx: cint; fn: cstring;
                                   fn_sz: cint) {.importc, header: ReaperHeader.}
proc TrackFX_NavigatePresets*(track: ptr MediaTrack; fx: cint; presetmove: cint): bool {.
    importc, header: ReaperHeader.}
proc TrackFX_SetEnabled*(track: ptr MediaTrack; fx: cint; enabled: bool) {.importc, header: ReaperHeader.}
proc TrackFX_SetEQBandEnabled*(track: ptr MediaTrack; fxidx: cint; bandtype: cint;
                              bandidx: cint; enable: bool): bool {.importc, header: ReaperHeader.}
proc TrackFX_SetEQParam*(track: ptr MediaTrack; fxidx: cint; bandtype: cint;
                        bandidx: cint; paramtype: cint; val: cdouble; isnorm: bool): bool {.
    importc, header: ReaperHeader.}
proc TrackFX_SetNamedConfigParm*(track: ptr MediaTrack; fx: cint; parmname: cstring;
                                value: cstring): bool {.importc, header: ReaperHeader.}
proc TrackFX_SetOffline*(track: ptr MediaTrack; fx: cint; offline: bool) {.importc, header: ReaperHeader.}
proc TrackFX_SetOpen*(track: ptr MediaTrack; fx: cint; open: bool) {.importc, header: ReaperHeader.}
proc TrackFX_SetParam*(track: ptr MediaTrack; fx: cint; param: cint; val: cdouble): bool {.
    importc, header: ReaperHeader.}
proc TrackFX_SetParamNormalized*(track: ptr MediaTrack; fx: cint; param: cint;
                                value: cdouble): bool {.importc, header: ReaperHeader.}
proc TrackFX_SetPinMappings*(tr: ptr MediaTrack; fx: cint; isoutput: cint; pin: cint;
                            low32bits: cint; hi32bits: cint): bool {.importc, header: ReaperHeader.}
proc TrackFX_SetPreset*(track: ptr MediaTrack; fx: cint; presetname: cstring): bool {.
    importc, header: ReaperHeader.}
proc TrackFX_SetPresetByIndex*(track: ptr MediaTrack; fx: cint; idx: cint): bool {.importc, header: ReaperHeader.}
proc TrackFX_Show*(track: ptr MediaTrack; index: cint; showFlag: cint) {.importc, header: ReaperHeader.}
proc TrackList_AdjustWindows*(isMinor: bool) {.importc, header: ReaperHeader.}
proc TrackList_UpdateAllExternalSurfaces*() {.importc, header: ReaperHeader.}
proc Undo_BeginBlock*() {.importc, header: ReaperHeader.}
proc Undo_BeginBlock2*(proj: ptr ReaProject) {.importc, header: ReaperHeader.}
proc Undo_CanRedo2*(proj: ptr ReaProject): cstring {.importc, header: ReaperHeader.}
proc Undo_CanUndo2*(proj: ptr ReaProject): cstring {.importc, header: ReaperHeader.}
proc Undo_DoRedo2*(proj: ptr ReaProject): cint {.importc, header: ReaperHeader.}
proc Undo_DoUndo2*(proj: ptr ReaProject): cint {.importc, header: ReaperHeader.}
proc Undo_EndBlock*(descchange: cstring; extraflags: cint) {.importc, header: ReaperHeader.}
proc Undo_EndBlock2*(proj: ptr ReaProject; descchange: cstring; extraflags: cint) {.
    importc, header: ReaperHeader.}
proc Undo_OnStateChange*(descchange: cstring) {.importc, header: ReaperHeader.}
proc Undo_OnStateChange2*(proj: ptr ReaProject; descchange: cstring) {.importc, header: ReaperHeader.}
proc Undo_OnStateChange_Item*(proj: ptr ReaProject; name: cstring; item: ptr MediaItem) {.
    importc, header: ReaperHeader.}
proc Undo_OnStateChangeEx*(descchange: cstring; whichStates: cint; trackparm: cint) {.
    importc, header: ReaperHeader.}
proc Undo_OnStateChangeEx2*(proj: ptr ReaProject; descchange: cstring;
                           whichStates: cint; trackparm: cint) {.importc, header: ReaperHeader.}
proc update_disk_counters*(readamt: cint; writeamt: cint) {.importc, header: ReaperHeader.}
proc UpdateArrange*() {.importc, header: ReaperHeader.}
proc UpdateItemInProject*(item: ptr MediaItem) {.importc, header: ReaperHeader.}
proc UpdateTimeline*() {.importc, header: ReaperHeader.}
proc ValidatePtr*(pointer: pointer; ctypename: cstring): bool {.importc, header: ReaperHeader.}
proc ValidatePtr2*(proj: ptr ReaProject; pointer: pointer; ctypename: cstring): bool {.
    importc, header: ReaperHeader.}
proc ViewPrefs*(page: cint; pageByName: cstring) {.importc, header: ReaperHeader.}
proc WDL_VirtualWnd_ScaledBlitBG*(dest: ptr LICE_IBitmap;
                                 src: ptr WDL_VirtualWnd_BGCfg; destx: cint;
                                 desty: cint; destw: cint; desth: cint; clipx: cint;
                                 clipy: cint; clipw: cint; cliph: cint; alpha: cfloat;
                                 mode: cint): bool {.importc, header: ReaperHeader.}