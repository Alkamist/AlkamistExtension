import types, winapi

{.pragma: ReaperAPI, importc, header: ReaperPluginFunctionsHeader.}

proc REAPERAPI_LoadAPI*(getAPI: proc(name: cstring): pointer {.cdecl.}): cint {.ReaperAPI.}

proc AddCustomizableMenu*(menuidstr: cstring; menuname: cstring; kbdsecname: cstring; addtomainmenu: bool): bool {.ReaperAPI.}
proc AddExtensionsMainMenu*(): bool {.ReaperAPI.}
proc AddMediaItemToTrack*(tr: ptr MediaTrack): ptr MediaItem {.ReaperAPI.}
proc AddProjectMarker*(proj: ptr ReaProject; isrgn: bool; pos: cdouble; rgnend: cdouble; name: cstring; wantidx: cint): cint {.ReaperAPI.}
proc AddProjectMarker2*(proj: ptr ReaProject; isrgn: bool; pos: cdouble; rgnend: cdouble; name: cstring; wantidx: cint; color: cint): cint {.ReaperAPI.}
proc AddRemoveReaScript*(add: bool; sectionID: cint; scriptfn: cstring; commit: bool): cint {.ReaperAPI.}
proc AddTakeToMediaItem*(item: ptr MediaItem): ptr MediaItem_Take {.ReaperAPI.}
proc AddTempoTimeSigMarker*(proj: ptr ReaProject; timepos: cdouble; bpm: cdouble; timesig_num: cint; timesig_denom: cint; lineartempochange: bool): bool {.ReaperAPI.}
proc adjustZoom*(amt: cdouble; forceset: cint; doupd: bool; centermode: cint) {.ReaperAPI.}
proc AnyTrackSolo*(proj: ptr ReaProject): bool {.ReaperAPI.}
proc APIExists*(function_name: cstring): bool {.ReaperAPI.}
proc APITest*() {.ReaperAPI.}
proc ApplyNudge*(project: ptr ReaProject; nudgeflag: cint; nudgewhat: cint; nudgeunits: cint; value: cdouble; reverse: bool; copies: cint): bool {.ReaperAPI.}
proc ArmCommand*(cmd: cint; sectionname: cstring) {.ReaperAPI.}
proc Audio_Init*() {.ReaperAPI.}
proc Audio_IsPreBuffer*(): cint {.ReaperAPI.}
proc Audio_IsRunning*(): cint {.ReaperAPI.}
proc Audio_Quit*() {.ReaperAPI.}
# proc Audio_RegHardwareHook*(isAdd: bool; reg: ptr audio_hook_register_t): cint {.ReaperAPI.}
# proc AudioAccessorStateChanged*(accessor: ptr AudioAccessor): bool {.ReaperAPI.}
# proc AudioAccessorUpdate*(accessor: ptr AudioAccessor) {.ReaperAPI.}
# proc AudioAccessorValidateState*(accessor: ptr AudioAccessor): bool {.ReaperAPI.}
proc BypassFxAllTracks*(bypass: cint) {.ReaperAPI.}
# proc CalculatePeaks*(srcBlock: ptr PCM_source_transfer_t; pksBlock: ptr PCM_source_peaktransfer_t): cint {.ReaperAPI.}
# proc CalculatePeaksFloatSrcPtr*(srcBlock: ptr PCM_source_transfer_t; pksBlock: ptr PCM_source_peaktransfer_t): cint {.ReaperAPI.}
proc ClearAllRecArmed*() {.ReaperAPI.}
proc ClearConsole*() {.ReaperAPI.}
proc ClearPeakCache*() {.ReaperAPI.}
proc ColorFromNative*(col: cint; rOut: ptr cint; gOut: ptr cint; bOut: ptr cint) {.ReaperAPI.}
proc ColorToNative*(r: cint; g: cint; b: cint): cint {.ReaperAPI.}
proc CountActionShortcuts*(section: ptr KbdSectionInfo; cmdID: cint): cint {.ReaperAPI.}
proc CountAutomationItems*(env: ptr TrackEnvelope): cint {.ReaperAPI.}
proc CountEnvelopePoints*(envelope: ptr TrackEnvelope): cint {.ReaperAPI.}
proc CountEnvelopePointsEx*(envelope: ptr TrackEnvelope; autoitem_idx: cint): cint {.ReaperAPI.}
proc CountMediaItems*(proj: ptr ReaProject): cint {.ReaperAPI.}
proc CountProjectMarkers*(proj: ptr ReaProject; num_markersOut: ptr cint; num_regionsOut: ptr cint): cint {.ReaperAPI.}
proc CountSelectedMediaItems*(proj: ptr ReaProject): cint {.ReaperAPI.}
proc CountSelectedTracks*(proj: ptr ReaProject): cint {.ReaperAPI.}
proc CountSelectedTracks2*(proj: ptr ReaProject; wantmaster: bool): cint {.ReaperAPI.}
proc CountTakeEnvelopes*(take: ptr MediaItem_Take): cint {.ReaperAPI.}
proc CountTakes*(item: ptr MediaItem): cint {.ReaperAPI.}
proc CountTCPFXParms*(project: ptr ReaProject; track: ptr MediaTrack): cint {.ReaperAPI.}
proc CountTempoTimeSigMarkers*(proj: ptr ReaProject): cint {.ReaperAPI.}
proc CountTrackEnvelopes*(track: ptr MediaTrack): cint {.ReaperAPI.}
proc CountTrackMediaItems*(track: ptr MediaTrack): cint {.ReaperAPI.}
proc CountTracks*(projOptional: ptr ReaProject): cint {.ReaperAPI.}
proc CreateLocalOscHandler*(obj: pointer; callback: pointer): pointer {.ReaperAPI.}
# proc CreateMIDIInput*(dev: cint): ptr midi_Input {.ReaperAPI.}
# proc CreateMIDIOutput*(dev: cint; streamMode: bool; msoffset100: ptr cint): ptr midi_Output {.ReaperAPI.}
proc CreateNewMIDIItemInProj*(track: ptr MediaTrack; starttime: cdouble; endtime: cdouble; qnInOptional: ptr bool): ptr MediaItem {.ReaperAPI.}
proc CreateTakeAudioAccessor*(take: ptr MediaItem_Take): ptr AudioAccessor {.ReaperAPI.}
proc CreateTrackAudioAccessor*(track: ptr MediaTrack): ptr AudioAccessor {.ReaperAPI.}
proc CreateTrackSend*(tr: ptr MediaTrack; desttrInOptional: ptr MediaTrack): cint {.ReaperAPI.}
proc CSurf_FlushUndo*(force: bool) {.ReaperAPI.}
proc CSurf_GetTouchState*(trackid: ptr MediaTrack; isPan: cint): bool {.ReaperAPI.}
proc CSurf_GoEnd*() {.ReaperAPI.}
proc CSurf_GoStart*() {.ReaperAPI.}
proc CSurf_NumTracks*(mcpView: bool): cint {.ReaperAPI.}
proc CSurf_OnArrow*(whichdir: cint; wantzoom: bool) {.ReaperAPI.}
proc CSurf_OnFwd*(seekplay: cint) {.ReaperAPI.}
proc CSurf_OnFXChange*(trackid: ptr MediaTrack; en: cint): bool {.ReaperAPI.}
proc CSurf_OnInputMonitorChange*(trackid: ptr MediaTrack; monitor: cint): cint {.ReaperAPI.}
proc CSurf_OnInputMonitorChangeEx*(trackid: ptr MediaTrack; monitor: cint; allowgang: bool): cint {.ReaperAPI.}
proc CSurf_OnMuteChange*(trackid: ptr MediaTrack; mute: cint): bool {.ReaperAPI.}
proc CSurf_OnMuteChangeEx*(trackid: ptr MediaTrack; mute: cint; allowgang: bool): bool {.ReaperAPI.}
proc CSurf_OnOscControlMessage*(msg: cstring; arg: ptr cfloat) {.ReaperAPI.}
proc CSurf_OnPanChange*(trackid: ptr MediaTrack; pan: cdouble; relative: bool): cdouble {.ReaperAPI.}
proc CSurf_OnPanChangeEx*(trackid: ptr MediaTrack; pan: cdouble; relative: bool; allowGang: bool): cdouble {.ReaperAPI.}
proc CSurf_OnPause*() {.ReaperAPI.}
proc CSurf_OnPlay*() {.ReaperAPI.}
proc CSurf_OnPlayRateChange*(playrate: cdouble) {.ReaperAPI.}
proc CSurf_OnRecArmChange*(trackid: ptr MediaTrack; recarm: cint): bool {.ReaperAPI.}
proc CSurf_OnRecArmChangeEx*(trackid: ptr MediaTrack; recarm: cint; allowgang: bool): bool {.ReaperAPI.}
proc CSurf_OnRecord*() {.ReaperAPI.}
proc CSurf_OnRecvPanChange*(trackid: ptr MediaTrack; recv_index: cint; pan: cdouble; relative: bool): cdouble {.ReaperAPI.}
proc CSurf_OnRecvVolumeChange*(trackid: ptr MediaTrack; recv_index: cint; volume: cdouble; relative: bool): cdouble {.ReaperAPI.}
proc CSurf_OnRew*(seekplay: cint) {.ReaperAPI.}
proc CSurf_OnRewFwd*(seekplay: cint; dir: cint) {.ReaperAPI.}
proc CSurf_OnScroll*(xdir: cint; ydir: cint) {.ReaperAPI.}
proc CSurf_OnSelectedChange*(trackid: ptr MediaTrack; selected: cint): bool {.ReaperAPI.}
proc CSurf_OnSendPanChange*(trackid: ptr MediaTrack; send_index: cint; pan: cdouble; relative: bool): cdouble {.ReaperAPI.}
proc CSurf_OnSendVolumeChange*(trackid: ptr MediaTrack; send_index: cint; volume: cdouble; relative: bool): cdouble {.ReaperAPI.}
proc CSurf_OnSoloChange*(trackid: ptr MediaTrack; solo: cint): bool {.ReaperAPI.}
proc CSurf_OnSoloChangeEx*(trackid: ptr MediaTrack; solo: cint; allowgang: bool): bool {.ReaperAPI.}
proc CSurf_OnStop*() {.ReaperAPI.}
proc CSurf_OnTempoChange*(bpm: cdouble) {.ReaperAPI.}
proc CSurf_OnTrackSelection*(trackid: ptr MediaTrack) {.ReaperAPI.}
proc CSurf_OnVolumeChange*(trackid: ptr MediaTrack; volume: cdouble; relative: bool): cdouble {.ReaperAPI.}
proc CSurf_OnVolumeChangeEx*(trackid: ptr MediaTrack; volume: cdouble; relative: bool; allowGang: bool): cdouble {.ReaperAPI.}
proc CSurf_OnWidthChange*(trackid: ptr MediaTrack; width: cdouble; relative: bool): cdouble {.ReaperAPI.}
proc CSurf_OnWidthChangeEx*(trackid: ptr MediaTrack; width: cdouble; relative: bool; allowGang: bool): cdouble {.ReaperAPI.}
proc CSurf_OnZoom*(xdir: cint; ydir: cint) {.ReaperAPI.}
proc CSurf_ResetAllCachedVolPanStates*() {.ReaperAPI.}
proc CSurf_ScrubAmt*(amt: cdouble) {.ReaperAPI.}
# proc CSurf_SetAutoMode*(mode: cint; ignoresurf: ptr IReaperControlSurface) {.ReaperAPI.}
# proc CSurf_SetPlayState*(play: bool; pause: bool; rec: bool; ignoresurf: ptr IReaperControlSurface) {.ReaperAPI.}
# proc CSurf_SetRepeatState*(rep: bool; ignoresurf: ptr IReaperControlSurface) {.ReaperAPI.}
# proc CSurf_SetSurfaceMute*(trackid: ptr MediaTrack; mute: bool; ignoresurf: ptr IReaperControlSurface) {.ReaperAPI.}
# proc CSurf_SetSurfacePan*(trackid: ptr MediaTrack; pan: cdouble; ignoresurf: ptr IReaperControlSurface) {.ReaperAPI.}
# proc CSurf_SetSurfaceRecArm*(trackid: ptr MediaTrack; recarm: bool; ignoresurf: ptr IReaperControlSurface) {.ReaperAPI.}
# proc CSurf_SetSurfaceSelected*(trackid: ptr MediaTrack; selected: bool; ignoresurf: ptr IReaperControlSurface) {.ReaperAPI.}
# proc CSurf_SetSurfaceSolo*(trackid: ptr MediaTrack; solo: bool; ignoresurf: ptr IReaperControlSurface) {.ReaperAPI.}
# proc CSurf_SetSurfaceVolume*(trackid: ptr MediaTrack; volume: cdouble; ignoresurf: ptr IReaperControlSurface) {.ReaperAPI.}
proc CSurf_SetTrackListChange*() {.ReaperAPI.}
proc CSurf_TrackFromID*(idx: cint; mcpView: bool): ptr MediaTrack {.ReaperAPI.}
proc CSurf_TrackToID*(track: ptr MediaTrack; mcpView: bool): cint {.ReaperAPI.}
proc DB2SLIDER*(x: cdouble): cdouble {.ReaperAPI.}
proc DeleteActionShortcut*(section: ptr KbdSectionInfo; cmdID: cint; shortcutidx: cint): bool {.ReaperAPI.}
proc DeleteEnvelopePointEx*(envelope: ptr TrackEnvelope; autoitem_idx: cint; ptidx: cint): bool {.ReaperAPI.}
proc DeleteEnvelopePointRange*(envelope: ptr TrackEnvelope; time_start: cdouble; time_end: cdouble): bool {.ReaperAPI.}
proc DeleteEnvelopePointRangeEx*(envelope: ptr TrackEnvelope; autoitem_idx: cint; time_start: cdouble; time_end: cdouble): bool {.ReaperAPI.}
proc DeleteExtState*(section: cstring; key: cstring; persist: bool) {.ReaperAPI.}
proc DeleteProjectMarker*(proj: ptr ReaProject; markrgnindexnumber: cint; isrgn: bool): bool {.ReaperAPI.}
proc DeleteProjectMarkerByIndex*(proj: ptr ReaProject; markrgnidx: cint): bool {.ReaperAPI.}
proc DeleteTakeMarker*(take: ptr MediaItem_Take; idx: cint): bool {.ReaperAPI.}
proc DeleteTakeStretchMarkers*(take: ptr MediaItem_Take; idx: cint; countInOptional: ptr cint): cint {.ReaperAPI.}
proc DeleteTempoTimeSigMarker*(project: ptr ReaProject; markerindex: cint): bool {.ReaperAPI.}
proc DeleteTrack*(tr: ptr MediaTrack) {.ReaperAPI.}
proc DeleteTrackMediaItem*(tr: ptr MediaTrack; it: ptr MediaItem): bool {.ReaperAPI.}
proc DestroyAudioAccessor*(accessor: ptr AudioAccessor) {.ReaperAPI.}
proc DestroyLocalOscHandler*(local_osc_handler: pointer) {.ReaperAPI.}
proc DoActionShortcutDialog*(hwnd: HWND; section: ptr KbdSectionInfo; cmdID: cint; shortcutidx: cint): bool {.ReaperAPI.}
proc Dock_UpdateDockID*(ident_str: cstring; whichDock: cint) {.ReaperAPI.}
proc DockGetPosition*(whichDock: cint): cint {.ReaperAPI.}
proc DockIsChildOfDock*(hwnd: HWND; isFloatingDockerOut: ptr bool): cint {.ReaperAPI.}
proc DockWindowActivate*(hwnd: HWND) {.ReaperAPI.}
proc DockWindowAdd*(hwnd: HWND; name: cstring; pos: cint; allowShow: bool) {.ReaperAPI.}
proc DockWindowAddEx*(hwnd: HWND; name: cstring; identstr: cstring; allowShow: bool) {.ReaperAPI.}
proc DockWindowRefresh*() {.ReaperAPI.}
proc DockWindowRefreshForHWND*(hwnd: HWND) {.ReaperAPI.}
proc DockWindowRemove*(hwnd: HWND) {.ReaperAPI.}
proc DuplicateCustomizableMenu*(srcmenu: pointer; destmenu: pointer): bool {.ReaperAPI.}
proc EditTempoTimeSigMarker*(project: ptr ReaProject; markerindex: cint): bool {.ReaperAPI.}
proc EnsureNotCompletelyOffscreen*(rInOut: ptr RECT) {.ReaperAPI.}
proc EnumerateFiles*(path: cstring; fileindex: cint): cstring {.ReaperAPI.}
proc EnumerateSubdirectories*(path: cstring; subdirindex: cint): cstring {.ReaperAPI.}
proc EnumPitchShiftModes*(mode: cint; strOut: cstringArray): bool {.ReaperAPI.}
proc EnumPitchShiftSubModes*(mode: cint; submode: cint): cstring {.ReaperAPI.}
proc EnumProjectMarkers*(idx: cint; isrgnOut: ptr bool; posOut: ptr cdouble; rgnendOut: ptr cdouble; nameOut: cstringArray; markrgnindexnumberOut: ptr cint): cint {.ReaperAPI.}
proc EnumProjectMarkers2*(proj: ptr ReaProject; idx: cint; isrgnOut: ptr bool; posOut: ptr cdouble; rgnendOut: ptr cdouble; nameOut: cstringArray; markrgnindexnumberOut: ptr cint): cint {.ReaperAPI.}
proc EnumProjectMarkers3*(proj: ptr ReaProject; idx: cint; isrgnOut: ptr bool; posOut: ptr cdouble; rgnendOut: ptr cdouble; nameOut: cstringArray; markrgnindexnumberOut: ptr cint; colorOut: ptr cint): cint {.ReaperAPI.}
proc EnumProjects*(idx: cint; projfnOutOptional: cstring; projfnOutOptional_sz: cint): ptr ReaProject {.ReaperAPI.}
proc EnumProjExtState*(proj: ptr ReaProject; extname: cstring; idx: cint; keyOutOptional: cstring; keyOutOptional_sz: cint; valOutOptional: cstring; valOutOptional_sz: cint): bool {.ReaperAPI.}
proc EnumRegionRenderMatrix*(proj: ptr ReaProject; regionindex: cint; rendertrack: cint): ptr MediaTrack {.ReaperAPI.}
proc EnumTrackMIDIProgramNames*(track: cint; programNumber: cint; programName: cstring; programName_sz: cint): bool {.ReaperAPI.}
proc EnumTrackMIDIProgramNamesEx*(proj: ptr ReaProject; track: ptr MediaTrack; programNumber: cint; programName: cstring; programName_sz: cint): bool {.ReaperAPI.}
proc Envelope_Evaluate*(envelope: ptr TrackEnvelope; time: cdouble; samplerate: cdouble; samplesRequested: cint; valueOutOptional: ptr cdouble; dVdSOutOptional: ptr cdouble; ddVdSOutOptional: ptr cdouble; dddVdSOutOptional: ptr cdouble): cint {.ReaperAPI.}
proc Envelope_FormatValue*(env: ptr TrackEnvelope; value: cdouble; bufOut: cstring; bufOut_sz: cint) {.ReaperAPI.}
proc Envelope_GetParentTake*(env: ptr TrackEnvelope; indexOutOptional: ptr cint; index2OutOptional: ptr cint): ptr MediaItem_Take {.ReaperAPI.}
proc Envelope_GetParentTrack*(env: ptr TrackEnvelope; indexOutOptional: ptr cint; index2OutOptional: ptr cint): ptr MediaTrack {.ReaperAPI.}
proc Envelope_SortPoints*(envelope: ptr TrackEnvelope): bool {.ReaperAPI.}
proc Envelope_SortPointsEx*(envelope: ptr TrackEnvelope; autoitem_idx: cint): bool {.ReaperAPI.}
proc ExecProcess*(cmdline: cstring; timeoutmsec: cint): cstring {.ReaperAPI.}
proc file_exists*(path: cstring): bool {.ReaperAPI.}
proc FindTempoTimeSigMarker*(project: ptr ReaProject; time: cdouble): cint {.ReaperAPI.}
proc format_timestr*(tpos: cdouble; buf: cstring; buf_sz: cint) {.ReaperAPI.}
proc format_timestr_len*(tpos: cdouble; buf: cstring; buf_sz: cint; offset: cdouble; modeoverride: cint) {.ReaperAPI.}
proc format_timestr_pos*(tpos: cdouble; buf: cstring; buf_sz: cint; modeoverride: cint) {.ReaperAPI.}
proc FreeHeapPtr*(`ptr`: pointer) {.ReaperAPI.}
proc genGuid*(g: ptr GUID) {.ReaperAPI.}
proc get_config_var*(name: cstring; szOut: ptr cint): pointer {.ReaperAPI.}
proc get_config_var_string*(name: cstring; bufOut: cstring; bufOut_sz: cint): bool {.ReaperAPI.}
proc get_ini_file*(): cstring {.ReaperAPI.}
proc get_midi_config_var*(name: cstring; szOut: ptr cint): pointer {.ReaperAPI.}
proc GetActionShortcutDesc*(section: ptr KbdSectionInfo; cmdID: cint; shortcutidx: cint; desc: cstring; desclen: cint): bool {.ReaperAPI.}
proc GetActiveTake*(item: ptr MediaItem): ptr MediaItem_Take {.ReaperAPI.}
proc GetAllProjectPlayStates*(ignoreProject: ptr ReaProject): cint {.ReaperAPI.}
proc GetAppVersion*(): cstring {.ReaperAPI.}
proc GetArmedCommand*(secOut: cstring; secOut_sz: cint): cint {.ReaperAPI.}
proc GetAudioAccessorEndTime*(accessor: ptr AudioAccessor): cdouble {.ReaperAPI.}
proc GetAudioAccessorHash*(accessor: ptr AudioAccessor; hashNeed128: cstring) {.ReaperAPI.}
proc GetAudioAccessorSamples*(accessor: ptr AudioAccessor; samplerate: cint; numchannels: cint; starttime_sec: cdouble; numsamplesperchannel: cint; samplebuffer: ptr cdouble): cint {.ReaperAPI.}
proc GetAudioAccessorStartTime*(accessor: ptr AudioAccessor): cdouble {.ReaperAPI.}
proc GetAudioDeviceInfo*(attribute: cstring; desc: cstring; desc_sz: cint): bool {.ReaperAPI.}
proc GetColorTheme*(idx: cint; defval: cint): INT_PTR {.ReaperAPI.}
proc GetColorThemeStruct*(szOut: ptr cint): pointer {.ReaperAPI.}
proc GetConfigWantsDock*(ident_str: cstring): cint {.ReaperAPI.}
proc GetContextMenu*(idx: cint): HMENU {.ReaperAPI.}
proc GetCurrentProjectInLoadSave*(): ptr ReaProject {.ReaperAPI.}
proc GetCursorContext*(): cint {.ReaperAPI.}
proc GetCursorContext2*(want_last_valid: bool): cint {.ReaperAPI.}
proc GetCursorPosition*(): cdouble {.ReaperAPI.}
proc GetCursorPositionEx*(proj: ptr ReaProject): cdouble {.ReaperAPI.}
proc GetDisplayedMediaItemColor*(item: ptr MediaItem): cint {.ReaperAPI.}
proc GetDisplayedMediaItemColor2*(item: ptr MediaItem; take: ptr MediaItem_Take): cint {.ReaperAPI.}
proc GetEnvelopeInfo_Value*(tr: ptr TrackEnvelope; parmname: cstring): cdouble {.ReaperAPI.}
proc GetEnvelopeName*(env: ptr TrackEnvelope; bufOut: cstring; bufOut_sz: cint): bool {.ReaperAPI.}
proc GetEnvelopePoint*(envelope: ptr TrackEnvelope; ptidx: cint; timeOutOptional: ptr cdouble; valueOutOptional: ptr cdouble; shapeOutOptional: ptr cint; tensionOutOptional: ptr cdouble; selectedOutOptional: ptr bool): bool {.ReaperAPI.}
proc GetEnvelopePointByTime*(envelope: ptr TrackEnvelope; time: cdouble): cint {.ReaperAPI.}
proc GetEnvelopePointByTimeEx*(envelope: ptr TrackEnvelope; autoitem_idx: cint; time: cdouble): cint {.ReaperAPI.}
proc GetEnvelopePointEx*(envelope: ptr TrackEnvelope; autoitem_idx: cint; ptidx: cint; timeOutOptional: ptr cdouble; valueOutOptional: ptr cdouble; shapeOutOptional: ptr cint; tensionOutOptional: ptr cdouble; selectedOutOptional: ptr bool): bool {.ReaperAPI.}
proc GetEnvelopeScalingMode*(env: ptr TrackEnvelope): cint {.ReaperAPI.}
proc GetEnvelopeStateChunk*(env: ptr TrackEnvelope; strNeedBig: cstring; strNeedBig_sz: cint; isundoOptional: bool): bool {.ReaperAPI.}
proc GetExePath*(): cstring {.ReaperAPI.}
proc GetExtState*(section: cstring; key: cstring): cstring {.ReaperAPI.}
proc GetFocusedFX*(tracknumberOut: ptr cint; itemnumberOut: ptr cint; fxnumberOut: ptr cint): cint {.ReaperAPI.}
proc GetFocusedFX2*(tracknumberOut: ptr cint; itemnumberOut: ptr cint; fxnumberOut: ptr cint): cint {.ReaperAPI.}
proc GetFreeDiskSpaceForRecordPath*(proj: ptr ReaProject; pathidx: cint): cint {.ReaperAPI.}
proc GetFXEnvelope*(track: ptr MediaTrack; fxindex: cint; parameterindex: cint; create: bool): ptr TrackEnvelope {.ReaperAPI.}
proc GetGlobalAutomationOverride*(): cint {.ReaperAPI.}
proc GetHZoomLevel*(): cdouble {.ReaperAPI.}
proc GetIconThemePointer*(name: cstring): pointer {.ReaperAPI.}
proc GetIconThemePointerForDPI*(name: cstring; dpisc: cint): pointer {.ReaperAPI.}
proc GetIconThemeStruct*(szOut: ptr cint): pointer {.ReaperAPI.}
proc GetInputChannelName*(channelIndex: cint): cstring {.ReaperAPI.}
proc GetInputOutputLatency*(inputlatencyOut: ptr cint; outputLatencyOut: ptr cint) {.ReaperAPI.}
# proc GetItemEditingTime2*(which_itemOut: ptr ptr PCM_source; flagsOut: ptr cint): cdouble {.ReaperAPI.}
proc GetItemFromPoint*(screen_x: cint; screen_y: cint; allow_locked: bool; takeOutOptional: ptr ptr MediaItem_Take): ptr MediaItem {.ReaperAPI.}
proc GetItemProjectContext*(item: ptr MediaItem): ptr ReaProject {.ReaperAPI.}
proc GetItemStateChunk*(item: ptr MediaItem; strNeedBig: cstring; strNeedBig_sz: cint; isundoOptional: bool): bool {.ReaperAPI.}
proc GetLastColorThemeFile*(): cstring {.ReaperAPI.}
proc GetLastMarkerAndCurRegion*(proj: ptr ReaProject; time: cdouble; markeridxOut: ptr cint; regionidxOut: ptr cint) {.ReaperAPI.}
proc GetLastTouchedFX*(tracknumberOut: ptr cint; fxnumberOut: ptr cint; paramnumberOut: ptr cint): bool {.ReaperAPI.}
proc GetLastTouchedTrack*(): ptr MediaTrack {.ReaperAPI.}
proc GetMainHwnd*(): HWND {.ReaperAPI.}
proc GetMasterMuteSoloFlags*(): cint {.ReaperAPI.}
proc GetMasterTrack*(proj: ptr ReaProject): ptr MediaTrack {.ReaperAPI.}
proc GetMasterTrackVisibility*(): cint {.ReaperAPI.}
proc GetMaxMidiInputs*(): cint {.ReaperAPI.}
proc GetMaxMidiOutputs*(): cint {.ReaperAPI.}
# proc GetMediaFileMetadata*(mediaSource: ptr PCM_source; identifier: cstring; bufOutNeedBig: cstring; bufOutNeedBig_sz: cint): cint {.ReaperAPI.}
proc GetMediaItem*(proj: ptr ReaProject; itemidx: cint): ptr MediaItem {.ReaperAPI.}
proc GetMediaItemInfo_Value*(item: ptr MediaItem; parmname: cstring): cdouble {.ReaperAPI.}
proc GetMediaItemNumTakes*(item: ptr MediaItem): cint {.ReaperAPI.}
proc GetMediaItemTake*(item: ptr MediaItem; tk: cint): ptr MediaItem_Take {.ReaperAPI.}
proc GetMediaItemTake_Item*(take: ptr MediaItem_Take): ptr MediaItem {.ReaperAPI.}
proc GetMediaItemTake_Peaks*(take: ptr MediaItem_Take; peakrate: cdouble; starttime: cdouble; numchannels: cint; numsamplesperchannel: cint; want_extra_type: cint; buf: ptr cdouble): cint {.ReaperAPI.}
# proc GetMediaItemTake_Source*(take: ptr MediaItem_Take): ptr PCM_source {.ReaperAPI.}
proc GetMediaItemTake_Track*(take: ptr MediaItem_Take): ptr MediaTrack {.ReaperAPI.}
proc GetMediaItemTakeByGUID*(project: ptr ReaProject; guid: ptr GUID): ptr MediaItem_Take {.ReaperAPI.}
proc GetMediaItemTakeInfo_Value*(take: ptr MediaItem_Take; parmname: cstring): cdouble {.ReaperAPI.}
proc GetMediaItemTrack*(item: ptr MediaItem): ptr MediaTrack {.ReaperAPI.}
# proc GetMediaSourceFileName*(source: ptr PCM_source; filenamebuf: cstring; filenamebuf_sz: cint) {.ReaperAPI.}
# proc GetMediaSourceLength*(source: ptr PCM_source; lengthIsQNOut: ptr bool): cdouble {.ReaperAPI.}
# proc GetMediaSourceNumChannels*(source: ptr PCM_source): cint {.ReaperAPI.}
# proc GetMediaSourceParent*(src: ptr PCM_source): ptr PCM_source {.ReaperAPI.}
# proc GetMediaSourceSampleRate*(source: ptr PCM_source): cint {.ReaperAPI.}
# proc GetMediaSourceType*(source: ptr PCM_source; typebuf: cstring; typebuf_sz: cint) {.ReaperAPI.}
proc GetMediaTrackInfo_Value*(tr: ptr MediaTrack; parmname: cstring): cdouble {.ReaperAPI.}
proc GetMIDIInputName*(dev: cint; nameout: cstring; nameout_sz: cint): bool {.ReaperAPI.}
proc GetMIDIOutputName*(dev: cint; nameout: cstring; nameout_sz: cint): bool {.ReaperAPI.}
proc GetMixerScroll*(): ptr MediaTrack {.ReaperAPI.}
proc GetMouseModifier*(context: cstring; modifier_flag: cint; action: cstring; action_sz: cint) {.ReaperAPI.}
proc GetMousePosition*(xOut: ptr cint; yOut: ptr cint) {.ReaperAPI.}
proc GetNumAudioInputs*(): cint {.ReaperAPI.}
proc GetNumAudioOutputs*(): cint {.ReaperAPI.}
proc GetNumMIDIInputs*(): cint {.ReaperAPI.}
proc GetNumMIDIOutputs*(): cint {.ReaperAPI.}
proc GetNumTakeMarkers*(take: ptr MediaItem_Take): cint {.ReaperAPI.}
proc GetNumTracks*(): cint {.ReaperAPI.}
proc GetOS*(): cstring {.ReaperAPI.}
proc GetOutputChannelName*(channelIndex: cint): cstring {.ReaperAPI.}
proc GetOutputLatency*(): cdouble {.ReaperAPI.}
proc GetParentTrack*(track: ptr MediaTrack): ptr MediaTrack {.ReaperAPI.}
proc GetPeakFileName*(fn: cstring; buf: cstring; buf_sz: cint) {.ReaperAPI.}
proc GetPeakFileNameEx*(fn: cstring; buf: cstring; buf_sz: cint; forWrite: bool) {.ReaperAPI.}
proc GetPeakFileNameEx2*(fn: cstring; buf: cstring; buf_sz: cint; forWrite: bool; peaksfileextension: cstring) {.ReaperAPI.}
# proc GetPeaksBitmap*(pks: ptr PCM_source_peaktransfer_t; maxamp: cdouble; w: cint; h: cint; bmp: ptr LICE_IBitmap): pointer {.ReaperAPI.}
proc GetPlayPosition*(): cdouble {.ReaperAPI.}
proc GetPlayPosition2*(): cdouble {.ReaperAPI.}
proc GetPlayPosition2Ex*(proj: ptr ReaProject): cdouble {.ReaperAPI.}
proc GetPlayPositionEx*(proj: ptr ReaProject): cdouble {.ReaperAPI.}
proc GetPlayState*(): cint {.ReaperAPI.}
proc GetPlayStateEx*(proj: ptr ReaProject): cint {.ReaperAPI.}
proc GetPreferredDiskReadMode*(mode: ptr cint; nb: ptr cint; bs: ptr cint) {.ReaperAPI.}
proc GetPreferredDiskReadModePeak*(mode: ptr cint; nb: ptr cint; bs: ptr cint) {.ReaperAPI.}
proc GetPreferredDiskWriteMode*(mode: ptr cint; nb: ptr cint; bs: ptr cint) {.ReaperAPI.}
proc GetProjectLength*(proj: ptr ReaProject): cdouble {.ReaperAPI.}
proc GetProjectName*(proj: ptr ReaProject; buf: cstring; buf_sz: cint) {.ReaperAPI.}
proc GetProjectPath*(buf: cstring; buf_sz: cint) {.ReaperAPI.}
proc GetProjectPathEx*(proj: ptr ReaProject; buf: cstring; buf_sz: cint) {.ReaperAPI.}
proc GetProjectStateChangeCount*(proj: ptr ReaProject): cint {.ReaperAPI.}
proc GetProjectTimeOffset*(proj: ptr ReaProject; rndframe: bool): cdouble {.ReaperAPI.}
proc GetProjectTimeSignature*(bpmOut: ptr cdouble; bpiOut: ptr cdouble) {.ReaperAPI.}
proc GetProjectTimeSignature2*(proj: ptr ReaProject; bpmOut: ptr cdouble; bpiOut: ptr cdouble) {.ReaperAPI.}
proc GetProjExtState*(proj: ptr ReaProject; extname: cstring; key: cstring; valOutNeedBig: cstring; valOutNeedBig_sz: cint): cint {.ReaperAPI.}
proc GetResourcePath*(): cstring {.ReaperAPI.}
proc GetSelectedEnvelope*(proj: ptr ReaProject): ptr TrackEnvelope {.ReaperAPI.}
proc GetSelectedMediaItem*(proj: ptr ReaProject; selitem: cint): ptr MediaItem {.ReaperAPI.}
proc GetSelectedTrack*(proj: ptr ReaProject; seltrackidx: cint): ptr MediaTrack {.ReaperAPI.}
proc GetSelectedTrack2*(proj: ptr ReaProject; seltrackidx: cint; wantmaster: bool): ptr MediaTrack {.ReaperAPI.}
proc GetSelectedTrackEnvelope*(proj: ptr ReaProject): ptr TrackEnvelope {.ReaperAPI.}
proc GetSet_ArrangeView2*(proj: ptr ReaProject; isSet: bool; screen_x_start: cint; screen_x_end: cint; start_timeOut: ptr cdouble; end_timeOut: ptr cdouble) {.ReaperAPI.}
proc GetSet_LoopTimeRange*(isSet: bool; isLoop: bool; startOut: ptr cdouble; endOut: ptr cdouble; allowautoseek: bool) {.ReaperAPI.}
proc GetSet_LoopTimeRange2*(proj: ptr ReaProject; isSet: bool; isLoop: bool; startOut: ptr cdouble; endOut: ptr cdouble; allowautoseek: bool) {.ReaperAPI.}
proc GetSetAutomationItemInfo*(env: ptr TrackEnvelope; autoitem_idx: cint; desc: cstring; value: cdouble; is_set: bool): cdouble {.ReaperAPI.}
proc GetSetAutomationItemInfo_String*(env: ptr TrackEnvelope; autoitem_idx: cint; desc: cstring; valuestrNeedBig: cstring; is_set: bool): bool {.ReaperAPI.}
proc GetSetEnvelopeInfo_String*(env: ptr TrackEnvelope; parmname: cstring; stringNeedBig: cstring; setNewValue: bool): bool {.ReaperAPI.}
proc GetSetEnvelopeState*(env: ptr TrackEnvelope; str: cstring; str_sz: cint): bool {.ReaperAPI.}
proc GetSetEnvelopeState2*(env: ptr TrackEnvelope; str: cstring; str_sz: cint; isundo: bool): bool {.ReaperAPI.}
proc GetSetItemState*(item: ptr MediaItem; str: cstring; str_sz: cint): bool {.ReaperAPI.}
proc GetSetItemState2*(item: ptr MediaItem; str: cstring; str_sz: cint; isundo: bool): bool {.ReaperAPI.}
proc GetSetMediaItemInfo*(item: ptr MediaItem; parmname: cstring; setNewValue: pointer): pointer {.ReaperAPI.}
proc GetSetMediaItemInfo_String*(item: ptr MediaItem; parmname: cstring; stringNeedBig: cstring; setNewValue: bool): bool {.ReaperAPI.}
proc GetSetMediaItemTakeInfo*(tk: ptr MediaItem_Take; parmname: cstring; setNewValue: pointer): pointer {.ReaperAPI.}
proc GetSetMediaItemTakeInfo_String*(tk: ptr MediaItem_Take; parmname: cstring; stringNeedBig: cstring; setNewValue: bool): bool {.ReaperAPI.}
proc GetSetMediaTrackInfo*(tr: ptr MediaTrack; parmname: cstring; setNewValue: pointer): pointer {.ReaperAPI.}
proc GetSetMediaTrackInfo_String*(tr: ptr MediaTrack; parmname: cstring; stringNeedBig: cstring; setNewValue: bool): bool {.ReaperAPI.}
proc GetSetObjectState*(obj: pointer; str: cstring): cstring {.ReaperAPI.}
proc GetSetObjectState2*(obj: pointer; str: cstring; isundo: bool): cstring {.ReaperAPI.}
proc GetSetProjectAuthor*(proj: ptr ReaProject; set: bool; author: cstring; author_sz: cint) {.ReaperAPI.}
proc GetSetProjectGrid*(project: ptr ReaProject; set: bool; divisionInOutOptional: ptr cdouble; swingmodeInOutOptional: ptr cint; swingamtInOutOptional: ptr cdouble): cint {.ReaperAPI.}
proc GetSetProjectInfo*(project: ptr ReaProject; desc: cstring; value: cdouble; is_set: bool): cdouble {.ReaperAPI.}
proc GetSetProjectInfo_String*(project: ptr ReaProject; desc: cstring; valuestrNeedBig: cstring; is_set: bool): bool {.ReaperAPI.}
proc GetSetProjectNotes*(proj: ptr ReaProject; set: bool; notesNeedBig: cstring; notesNeedBig_sz: cint) {.ReaperAPI.}
proc GetSetRepeat*(val: cint): cint {.ReaperAPI.}
proc GetSetRepeatEx*(proj: ptr ReaProject; val: cint): cint {.ReaperAPI.}
proc GetSetTrackGroupMembership*(tr: ptr MediaTrack; groupname: cstring; setmask: cuint; setvalue: cuint): cuint {.ReaperAPI.}
proc GetSetTrackGroupMembershipHigh*(tr: ptr MediaTrack; groupname: cstring; setmask: cuint; setvalue: cuint): cuint {.ReaperAPI.}
proc GetSetTrackMIDISupportFile*(proj: ptr ReaProject; track: ptr MediaTrack; which: cint; filename: cstring): cstring {.ReaperAPI.}
proc GetSetTrackSendInfo*(tr: ptr MediaTrack; category: cint; sendidx: cint; parmname: cstring; setNewValue: pointer): pointer {.ReaperAPI.}
proc GetSetTrackSendInfo_String*(tr: ptr MediaTrack; category: cint; sendidx: cint; parmname: cstring; stringNeedBig: cstring; setNewValue: bool): bool {.ReaperAPI.}
proc GetSetTrackState*(track: ptr MediaTrack; str: cstring; str_sz: cint): bool {.ReaperAPI.}
proc GetSetTrackState2*(track: ptr MediaTrack; str: cstring; str_sz: cint; isundo: bool): bool {.ReaperAPI.}
# proc GetSubProjectFromSource*(src: ptr PCM_source): ptr ReaProject {.ReaperAPI.}
proc GetTake*(item: ptr MediaItem; takeidx: cint): ptr MediaItem_Take {.ReaperAPI.}
proc GetTakeEnvelope*(take: ptr MediaItem_Take; envidx: cint): ptr TrackEnvelope {.ReaperAPI.}
proc GetTakeEnvelopeByName*(take: ptr MediaItem_Take; envname: cstring): ptr TrackEnvelope {.ReaperAPI.}
proc GetTakeMarker*(take: ptr MediaItem_Take; idx: cint; nameOut: cstring; nameOut_sz: cint; colorOutOptional: ptr cint): cdouble {.ReaperAPI.}
proc GetTakeName*(take: ptr MediaItem_Take): cstring {.ReaperAPI.}
proc GetTakeNumStretchMarkers*(take: ptr MediaItem_Take): cint {.ReaperAPI.}
proc GetTakeStretchMarker*(take: ptr MediaItem_Take; idx: cint; posOut: ptr cdouble; srcposOutOptional: ptr cdouble): cint {.ReaperAPI.}
proc GetTakeStretchMarkerSlope*(take: ptr MediaItem_Take; idx: cint): cdouble {.ReaperAPI.}
proc GetTCPFXParm*(project: ptr ReaProject; track: ptr MediaTrack; index: cint; fxindexOut: ptr cint; parmidxOut: ptr cint): bool {.ReaperAPI.}
# proc GetTempoMatchPlayRate*(source: ptr PCM_source; srcscale: cdouble; position: cdouble; mult: cdouble; rateOut: ptr cdouble; targetlenOut: ptr cdouble): bool {.ReaperAPI.}
proc GetTempoTimeSigMarker*(proj: ptr ReaProject; ptidx: cint; timeposOut: ptr cdouble; measureposOut: ptr cint; beatposOut: ptr cdouble; bpmOut: ptr cdouble; timesig_numOut: ptr cint; timesig_denomOut: ptr cint; lineartempoOut: ptr bool): bool {.ReaperAPI.}
proc GetThemeColor*(ini_key: cstring; flagsOptional: cint): cint {.ReaperAPI.}
proc GetToggleCommandState*(command_id: cint): cint {.ReaperAPI.}
proc GetToggleCommandState2*(section: ptr KbdSectionInfo; command_id: cint): cint {.ReaperAPI.}
proc GetToggleCommandStateEx*(section_id: cint; command_id: cint): cint {.ReaperAPI.}
proc GetToggleCommandStateThroughHooks*(section: ptr KbdSectionInfo; command_id: cint): cint {.ReaperAPI.}
proc GetTooltipWindow*(): HWND {.ReaperAPI.}
proc GetTrack*(proj: ptr ReaProject; trackidx: cint): ptr MediaTrack {.ReaperAPI.}
proc GetTrackAutomationMode*(tr: ptr MediaTrack): cint {.ReaperAPI.}
proc GetTrackColor*(track: ptr MediaTrack): cint {.ReaperAPI.}
proc GetTrackDepth*(track: ptr MediaTrack): cint {.ReaperAPI.}
proc GetTrackEnvelope*(track: ptr MediaTrack; envidx: cint): ptr TrackEnvelope {.ReaperAPI.}
proc GetTrackEnvelopeByChunkName*(tr: ptr MediaTrack; cfgchunkname: cstring): ptr TrackEnvelope {.ReaperAPI.}
proc GetTrackEnvelopeByName*(track: ptr MediaTrack; envname: cstring): ptr TrackEnvelope {.ReaperAPI.}
proc GetTrackFromPoint*(screen_x: cint; screen_y: cint; infoOutOptional: ptr cint): ptr MediaTrack {.ReaperAPI.}
proc GetTrackGUID*(tr: ptr MediaTrack): ptr GUID {.ReaperAPI.}
proc GetTrackInfo*(track: INT_PTR; flags: ptr cint): cstring {.ReaperAPI.}
proc GetTrackMediaItem*(tr: ptr MediaTrack; itemidx: cint): ptr MediaItem {.ReaperAPI.}
proc GetTrackMIDILyrics*(track: ptr MediaTrack; flag: cint; bufWantNeedBig: cstring; bufWantNeedBig_sz: ptr cint): bool {.ReaperAPI.}
proc GetTrackMIDINoteName*(track: cint; pitch: cint; chan: cint): cstring {.ReaperAPI.}
proc GetTrackMIDINoteNameEx*(proj: ptr ReaProject; track: ptr MediaTrack; pitch: cint; chan: cint): cstring {.ReaperAPI.}
proc GetTrackMIDINoteRange*(proj: ptr ReaProject; track: ptr MediaTrack; note_loOut: ptr cint; note_hiOut: ptr cint) {.ReaperAPI.}
proc GetTrackName*(track: ptr MediaTrack; bufOut: cstring; bufOut_sz: cint): bool {.ReaperAPI.}
proc GetTrackNumMediaItems*(tr: ptr MediaTrack): cint {.ReaperAPI.}
proc GetTrackNumSends*(tr: ptr MediaTrack; category: cint): cint {.ReaperAPI.}
proc GetTrackReceiveName*(track: ptr MediaTrack; recv_index: cint; buf: cstring; buf_sz: cint): bool {.ReaperAPI.}
proc GetTrackReceiveUIMute*(track: ptr MediaTrack; recv_index: cint; muteOut: ptr bool): bool {.ReaperAPI.}
proc GetTrackReceiveUIVolPan*(track: ptr MediaTrack; recv_index: cint; volumeOut: ptr cdouble; panOut: ptr cdouble): bool {.ReaperAPI.}
proc GetTrackSendInfo_Value*(tr: ptr MediaTrack; category: cint; sendidx: cint; parmname: cstring): cdouble {.ReaperAPI.}
proc GetTrackSendName*(track: ptr MediaTrack; send_index: cint; buf: cstring; buf_sz: cint): bool {.ReaperAPI.}
proc GetTrackSendUIMute*(track: ptr MediaTrack; send_index: cint; muteOut: ptr bool): bool {.ReaperAPI.}
proc GetTrackSendUIVolPan*(track: ptr MediaTrack; send_index: cint; volumeOut: ptr cdouble; panOut: ptr cdouble): bool {.ReaperAPI.}
proc GetTrackState*(track: ptr MediaTrack; flagsOut: ptr cint): cstring {.ReaperAPI.}
proc GetTrackStateChunk*(track: ptr MediaTrack; strNeedBig: cstring; strNeedBig_sz: cint; isundoOptional: bool): bool {.ReaperAPI.}
proc GetTrackUIMute*(track: ptr MediaTrack; muteOut: ptr bool): bool {.ReaperAPI.}
proc GetTrackUIPan*(track: ptr MediaTrack; pan1Out: ptr cdouble; pan2Out: ptr cdouble; panmodeOut: ptr cint): bool {.ReaperAPI.}
proc GetTrackUIVolPan*(track: ptr MediaTrack; volumeOut: ptr cdouble; panOut: ptr cdouble): bool {.ReaperAPI.}
proc GetUnderrunTime*(audio_xrunOutOptional: ptr cuint; media_xrunOutOptional: ptr cuint; curtimeOutOptional: ptr cuint) {.ReaperAPI.}
proc GetUserFileNameForRead*(filenameNeed4096: cstring; title: cstring; defext: cstring): bool {.ReaperAPI.}
proc GetUserInputs*(title: cstring; num_inputs: cint; captions_csv: cstring; retvals_csv: cstring; retvals_csv_sz: cint): bool {.ReaperAPI.}
proc GoToMarker*(proj: ptr ReaProject; marker_index: cint; use_timeline_order: bool) {.ReaperAPI.}
proc GoToRegion*(proj: ptr ReaProject; region_index: cint; use_timeline_order: bool) {.ReaperAPI.}
proc GR_SelectColor*(hwnd: HWND; colorOut: ptr cint): cint {.ReaperAPI.}
proc GSC_mainwnd*(t: cint): cint {.ReaperAPI.}
proc guidToString*(g: ptr GUID; destNeed64: cstring) {.ReaperAPI.}
proc HasExtState*(section: cstring; key: cstring): bool {.ReaperAPI.}
proc HasTrackMIDIPrograms*(track: cint): cstring {.ReaperAPI.}
proc HasTrackMIDIProgramsEx*(proj: ptr ReaProject; track: ptr MediaTrack): cstring {.ReaperAPI.}
proc Help_Set*(helpstring: cstring; is_temporary_help: bool) {.ReaperAPI.}
# proc HiresPeaksFromSource*(src: ptr PCM_source; `block`: ptr PCM_source_peaktransfer_t) {.ReaperAPI.}
proc image_resolve_fn*(`in`: cstring; `out`: cstring; out_sz: cint) {.ReaperAPI.}
proc InsertAutomationItem*(env: ptr TrackEnvelope; pool_id: cint; position: cdouble; length: cdouble): cint {.ReaperAPI.}
proc InsertEnvelopePoint*(envelope: ptr TrackEnvelope; time: cdouble; value: cdouble; shape: cint; tension: cdouble; selected: bool; noSortInOptional: ptr bool): bool {.ReaperAPI.}
proc InsertEnvelopePointEx*(envelope: ptr TrackEnvelope; autoitem_idx: cint; time: cdouble; value: cdouble; shape: cint; tension: cdouble; selected: bool; noSortInOptional: ptr bool): bool {.ReaperAPI.}
proc InsertMedia*(file: cstring; mode: cint): cint {.ReaperAPI.}
proc InsertMediaSection*(file: cstring; mode: cint; startpct: cdouble; endpct: cdouble; pitchshift: cdouble): cint {.ReaperAPI.}
proc InsertTrackAtIndex*(idx: cint; wantDefaults: bool) {.ReaperAPI.}
proc IsInRealTimeAudio*(): cint {.ReaperAPI.}
proc IsItemTakeActiveForPlayback*(item: ptr MediaItem; take: ptr MediaItem_Take): bool {.ReaperAPI.}
proc IsMediaExtension*(ext: cstring; wantOthers: bool): bool {.ReaperAPI.}
proc IsMediaItemSelected*(item: ptr MediaItem): bool {.ReaperAPI.}
proc IsProjectDirty*(proj: ptr ReaProject): cint {.ReaperAPI.}
proc IsREAPER*(): bool {.ReaperAPI.}
proc IsTrackSelected*(track: ptr MediaTrack): bool {.ReaperAPI.}
proc IsTrackVisible*(track: ptr MediaTrack; mixer: bool): bool {.ReaperAPI.}
proc joystick_create*(guid: ptr GUID): ptr joystick_device {.ReaperAPI.}
proc joystick_destroy*(device: ptr joystick_device) {.ReaperAPI.}
proc joystick_enum*(index: cint; namestrOutOptional: cstringArray): cstring {.ReaperAPI.}
proc joystick_getaxis*(dev: ptr joystick_device; axis: cint): cdouble {.ReaperAPI.}
proc joystick_getbuttonmask*(dev: ptr joystick_device): cuint {.ReaperAPI.}
proc joystick_getinfo*(dev: ptr joystick_device; axesOutOptional: ptr cint; povsOutOptional: ptr cint): cint {.ReaperAPI.}
proc joystick_getpov*(dev: ptr joystick_device; pov: cint): cdouble {.ReaperAPI.}
proc joystick_update*(dev: ptr joystick_device): bool {.ReaperAPI.}
proc kbd_enumerateActions*(section: ptr KbdSectionInfo; idx: cint; nameOut: cstringArray): cint {.ReaperAPI.}
# proc kbd_formatKeyName*(ac: ptr ACCEL; s: cstring) {.ReaperAPI.}
proc kbd_getCommandName*(cmd: cint; s: cstring; section: ptr KbdSectionInfo) {.ReaperAPI.}
proc kbd_getTextFromCmd*(cmd: DWORD; section: ptr KbdSectionInfo): cstring {.ReaperAPI.}
proc KBD_OnMainActionEx*(cmd: cint; val: cint; valhw: cint; relmode: cint; hwnd: HWND; proj: ptr ReaProject): cint {.ReaperAPI.}
proc kbd_OnMidiEvent*(evt: ptr MIDI_event_t; dev_index: cint) {.ReaperAPI.}
# proc kbd_OnMidiList*(list: ptr MIDI_eventlist; dev_index: cint) {.ReaperAPI.}
proc kbd_ProcessActionsMenu*(menu: HMENU; section: ptr KbdSectionInfo) {.ReaperAPI.}
proc kbd_processMidiEventActionEx*(evt: ptr MIDI_event_t; section: ptr KbdSectionInfo; hwndCtx: HWND): bool {.ReaperAPI.}
proc kbd_reprocessMenu*(menu: HMENU; section: ptr KbdSectionInfo) {.ReaperAPI.}
proc kbd_RunCommandThroughHooks*(section: ptr KbdSectionInfo; actionCommandID: ptr cint; val: ptr cint; valhw: ptr cint; relmode: ptr cint; hwnd: HWND): bool {.ReaperAPI.}
proc kbd_translateAccelerator*(hwnd: HWND; msg: ptr MSG; section: ptr KbdSectionInfo): cint {.ReaperAPI.}
proc kbd_translateMouse*(winmsg: pointer; midimsg: ptr cuchar): bool {.ReaperAPI.}
# proc LICE__Destroy*(bm: ptr LICE_IBitmap) {.ReaperAPI.}
# proc LICE__DestroyFont*(font: ptr LICE_IFont) {.ReaperAPI.}
# proc LICE__DrawText*(font: ptr LICE_IFont; bm: ptr LICE_IBitmap; str: cstring; strcnt: cint; rect: ptr RECT; dtFlags: UINT): cint {.ReaperAPI.}
# proc LICE__GetBits*(bm: ptr LICE_IBitmap): pointer {.ReaperAPI.}
# proc LICE__GetDC*(bm: ptr LICE_IBitmap): HDC {.ReaperAPI.}
# proc LICE__GetHeight*(bm: ptr LICE_IBitmap): cint {.ReaperAPI.}
# proc LICE__GetRowSpan*(bm: ptr LICE_IBitmap): cint {.ReaperAPI.}
# proc LICE__GetWidth*(bm: ptr LICE_IBitmap): cint {.ReaperAPI.}
# proc LICE__IsFlipped*(bm: ptr LICE_IBitmap): bool {.ReaperAPI.}
# proc LICE__resize*(bm: ptr LICE_IBitmap; w: cint; h: cint): bool {.ReaperAPI.}
# proc LICE__SetBkColor*(font: ptr LICE_IFont; color: LICE_pixel): LICE_pixel {.ReaperAPI.}
# proc LICE__SetFromHFont*(font: ptr LICE_IFont; hfont: HFONT; flags: cint) {.ReaperAPI.}
# proc LICE__SetTextColor*(font: ptr LICE_IFont; color: LICE_pixel): LICE_pixel {.ReaperAPI.}
# proc LICE__SetTextCombineMode*(ifont: ptr LICE_IFont; mode: cint; alpha: cfloat) {.ReaperAPI.}
proc LICE_Arc*(dest: ptr LICE_IBitmap; cx: cfloat; cy: cfloat; r: cfloat; minAngle: cfloat; maxAngle: cfloat; color: LICE_pixel; alpha: cfloat; mode: cint; aa: bool) {.ReaperAPI.}
proc LICE_Blit*(dest: ptr LICE_IBitmap; src: ptr LICE_IBitmap; dstx: cint; dsty: cint; srcx: cint; srcy: cint; srcw: cint; srch: cint; alpha: cfloat; mode: cint) {.ReaperAPI.}
proc LICE_Blur*(dest: ptr LICE_IBitmap; src: ptr LICE_IBitmap; dstx: cint; dsty: cint; srcx: cint; srcy: cint; srcw: cint; srch: cint) {.ReaperAPI.}
proc LICE_BorderedRect*(dest: ptr LICE_IBitmap; x: cint; y: cint; w: cint; h: cint; bgcolor: LICE_pixel; fgcolor: LICE_pixel; alpha: cfloat; mode: cint) {.ReaperAPI.}
proc LICE_Circle*(dest: ptr LICE_IBitmap; cx: cfloat; cy: cfloat; r: cfloat; color: LICE_pixel; alpha: cfloat; mode: cint; aa: bool) {.ReaperAPI.}
proc LICE_Clear*(dest: ptr LICE_IBitmap; color: LICE_pixel) {.ReaperAPI.}
proc LICE_ClearRect*(dest: ptr LICE_IBitmap; x: cint; y: cint; w: cint; h: cint; mask: LICE_pixel; orbits: LICE_pixel) {.ReaperAPI.}
proc LICE_ClipLine*(pX1Out: ptr cint; pY1Out: ptr cint; pX2Out: ptr cint; pY2Out: ptr cint; xLo: cint; yLo: cint; xHi: cint; yHi: cint): bool {.ReaperAPI.}
proc LICE_Copy*(dest: ptr LICE_IBitmap; src: ptr LICE_IBitmap) {.ReaperAPI.}
proc LICE_CreateBitmap*(mode: cint; w: cint; h: cint): ptr LICE_IBitmap {.ReaperAPI.}
proc LICE_CreateFont*(): ptr LICE_IFont {.ReaperAPI.}
proc LICE_DrawCBezier*(dest: ptr LICE_IBitmap; xstart: cdouble; ystart: cdouble; xctl1: cdouble; yctl1: cdouble; xctl2: cdouble; yctl2: cdouble; xend: cdouble; yend: cdouble; color: LICE_pixel; alpha: cfloat; mode: cint; aa: bool; tol: cdouble) {.ReaperAPI.}
proc LICE_DrawChar*(bm: ptr LICE_IBitmap; x: cint; y: cint; c: char; color: LICE_pixel; alpha: cfloat; mode: cint) {.ReaperAPI.}
proc LICE_DrawGlyph*(dest: ptr LICE_IBitmap; x: cint; y: cint; color: LICE_pixel; alphas: ptr LICE_pixel_chan; glyph_w: cint; glyph_h: cint; alpha: cfloat; mode: cint) {.ReaperAPI.}
proc LICE_DrawRect*(dest: ptr LICE_IBitmap; x: cint; y: cint; w: cint; h: cint; color: LICE_pixel; alpha: cfloat; mode: cint) {.ReaperAPI.}
proc LICE_DrawText*(bm: ptr LICE_IBitmap; x: cint; y: cint; string: cstring; color: LICE_pixel; alpha: cfloat; mode: cint) {.ReaperAPI.}
proc LICE_FillCBezier*(dest: ptr LICE_IBitmap; xstart: cdouble; ystart: cdouble; xctl1: cdouble; yctl1: cdouble; xctl2: cdouble; yctl2: cdouble; xend: cdouble; yend: cdouble; yfill: cint; color: LICE_pixel; alpha: cfloat; mode: cint; aa: bool; tol: cdouble) {.ReaperAPI.}
proc LICE_FillCircle*(dest: ptr LICE_IBitmap; cx: cfloat; cy: cfloat; r: cfloat; color: LICE_pixel; alpha: cfloat; mode: cint; aa: bool) {.ReaperAPI.}
proc LICE_FillConvexPolygon*(dest: ptr LICE_IBitmap; x: ptr cint; y: ptr cint; npoints: cint; color: LICE_pixel; alpha: cfloat; mode: cint) {.ReaperAPI.}
proc LICE_FillRect*(dest: ptr LICE_IBitmap; x: cint; y: cint; w: cint; h: cint; color: LICE_pixel; alpha: cfloat; mode: cint) {.ReaperAPI.}
proc LICE_FillTrapezoid*(dest: ptr LICE_IBitmap; x1a: cint; x1b: cint; y1: cint; x2a: cint; x2b: cint; y2: cint; color: LICE_pixel; alpha: cfloat; mode: cint) {.ReaperAPI.}
proc LICE_FillTriangle*(dest: ptr LICE_IBitmap; x1: cint; y1: cint; x2: cint; y2: cint; x3: cint; y3: cint; color: LICE_pixel; alpha: cfloat; mode: cint) {.ReaperAPI.}
proc LICE_GetPixel*(bm: ptr LICE_IBitmap; x: cint; y: cint): LICE_pixel {.ReaperAPI.}
proc LICE_GradRect*(dest: ptr LICE_IBitmap; dstx: cint; dsty: cint; dstw: cint; dsth: cint; ir: cfloat; ig: cfloat; ib: cfloat; ia: cfloat; drdx: cfloat; dgdx: cfloat; dbdx: cfloat; dadx: cfloat; drdy: cfloat; dgdy: cfloat; dbdy: cfloat; dady: cfloat; mode: cint) {.ReaperAPI.}
proc LICE_Line*(dest: ptr LICE_IBitmap; x1: cfloat; y1: cfloat; x2: cfloat; y2: cfloat; color: LICE_pixel; alpha: cfloat; mode: cint; aa: bool) {.ReaperAPI.}
proc LICE_LineInt*(dest: ptr LICE_IBitmap; x1: cint; y1: cint; x2: cint; y2: cint; color: LICE_pixel; alpha: cfloat; mode: cint; aa: bool) {.ReaperAPI.}
proc LICE_LoadPNG*(filename: cstring; bmp: ptr LICE_IBitmap): ptr LICE_IBitmap {.ReaperAPI.}
proc LICE_LoadPNGFromResource*(hInst: HINSTANCE; resid: cstring; bmp: ptr LICE_IBitmap): ptr LICE_IBitmap {.ReaperAPI.}
proc LICE_MeasureText*(string: cstring; w: ptr cint; h: ptr cint) {.ReaperAPI.}
proc LICE_MultiplyAddRect*(dest: ptr LICE_IBitmap; x: cint; y: cint; w: cint; h: cint; rsc: cfloat; gsc: cfloat; bsc: cfloat; asc: cfloat; radd: cfloat; gadd: cfloat; badd: cfloat; aadd: cfloat) {.ReaperAPI.}
proc LICE_PutPixel*(bm: ptr LICE_IBitmap; x: cint; y: cint; color: LICE_pixel; alpha: cfloat; mode: cint) {.ReaperAPI.}
proc LICE_RotatedBlit*(dest: ptr LICE_IBitmap; src: ptr LICE_IBitmap; dstx: cint; dsty: cint; dstw: cint; dsth: cint; srcx: cfloat; srcy: cfloat; srcw: cfloat; srch: cfloat; angle: cfloat; cliptosourcerect: bool; alpha: cfloat; mode: cint; rotxcent: cfloat; rotycent: cfloat) {.ReaperAPI.}
proc LICE_RoundRect*(drawbm: ptr LICE_IBitmap; xpos: cfloat; ypos: cfloat; w: cfloat; h: cfloat; cornerradius: cint; col: LICE_pixel; alpha: cfloat; mode: cint; aa: bool) {.ReaperAPI.}
proc LICE_ScaledBlit*(dest: ptr LICE_IBitmap; src: ptr LICE_IBitmap; dstx: cint; dsty: cint; dstw: cint; dsth: cint; srcx: cfloat; srcy: cfloat; srcw: cfloat; srch: cfloat; alpha: cfloat; mode: cint) {.ReaperAPI.}
proc LICE_SimpleFill*(dest: ptr LICE_IBitmap; x: cint; y: cint; newcolor: LICE_pixel; comparemask: LICE_pixel; keepmask: LICE_pixel) {.ReaperAPI.}
proc LocalizeString*(src_string: cstring; section: cstring; flagsOptional: cint): cstring {.ReaperAPI.}
proc Loop_OnArrow*(project: ptr ReaProject; direction: cint): bool {.ReaperAPI.}
proc Main_OnCommand*(command: cint; flag: cint) {.ReaperAPI.}
proc Main_OnCommandEx*(command: cint; flag: cint; proj: ptr ReaProject) {.ReaperAPI.}
proc Main_openProject*(name: cstring) {.ReaperAPI.}
proc Main_SaveProject*(proj: ptr ReaProject; forceSaveAsInOptional: bool) {.ReaperAPI.}
proc Main_UpdateLoopInfo*(ignoremask: cint) {.ReaperAPI.}
proc MarkProjectDirty*(proj: ptr ReaProject) {.ReaperAPI.}
proc MarkTrackItemsDirty*(track: ptr MediaTrack; item: ptr MediaItem) {.ReaperAPI.}
proc Master_GetPlayRate*(project: ptr ReaProject): cdouble {.ReaperAPI.}
proc Master_GetPlayRateAtTime*(time_s: cdouble; proj: ptr ReaProject): cdouble {.ReaperAPI.}
proc Master_GetTempo*(): cdouble {.ReaperAPI.}
proc Master_NormalizePlayRate*(playrate: cdouble; isnormalized: bool): cdouble {.ReaperAPI.}
proc Master_NormalizeTempo*(bpm: cdouble; isnormalized: bool): cdouble {.ReaperAPI.}
proc MB*(msg: cstring; title: cstring; `type`: cint): cint {.ReaperAPI.}
proc MediaItemDescendsFromTrack*(item: ptr MediaItem; track: ptr MediaTrack): cint {.ReaperAPI.}
proc MIDI_CountEvts*(take: ptr MediaItem_Take; notecntOut: ptr cint; ccevtcntOut: ptr cint; textsyxevtcntOut: ptr cint): cint {.ReaperAPI.}
proc MIDI_DeleteCC*(take: ptr MediaItem_Take; ccidx: cint): bool {.ReaperAPI.}
proc MIDI_DeleteEvt*(take: ptr MediaItem_Take; evtidx: cint): bool {.ReaperAPI.}
proc MIDI_DeleteNote*(take: ptr MediaItem_Take; noteidx: cint): bool {.ReaperAPI.}
proc MIDI_DeleteTextSysexEvt*(take: ptr MediaItem_Take; textsyxevtidx: cint): bool {.ReaperAPI.}
proc MIDI_DisableSort*(take: ptr MediaItem_Take) {.ReaperAPI.}
proc MIDI_EnumSelCC*(take: ptr MediaItem_Take; ccidx: cint): cint {.ReaperAPI.}
proc MIDI_EnumSelEvts*(take: ptr MediaItem_Take; evtidx: cint): cint {.ReaperAPI.}
proc MIDI_EnumSelNotes*(take: ptr MediaItem_Take; noteidx: cint): cint {.ReaperAPI.}
proc MIDI_EnumSelTextSysexEvts*(take: ptr MediaItem_Take; textsyxidx: cint): cint {.ReaperAPI.}
# proc MIDI_eventlist_Create*(): ptr MIDI_eventlist {.ReaperAPI.}
# proc MIDI_eventlist_Destroy*(evtlist: ptr MIDI_eventlist) {.ReaperAPI.}
proc MIDI_GetAllEvts*(take: ptr MediaItem_Take; bufNeedBig: cstring; bufNeedBig_sz: ptr cint): bool {.ReaperAPI.}
proc MIDI_GetCC*(take: ptr MediaItem_Take; ccidx: cint; selectedOut: ptr bool; mutedOut: ptr bool; ppqposOut: ptr cdouble; chanmsgOut: ptr cint; chanOut: ptr cint; msg2Out: ptr cint; msg3Out: ptr cint): bool {.ReaperAPI.}
proc MIDI_GetCCShape*(take: ptr MediaItem_Take; ccidx: cint; shapeOut: ptr cint; beztensionOut: ptr cdouble): bool {.ReaperAPI.}
proc MIDI_GetEvt*(take: ptr MediaItem_Take; evtidx: cint; selectedOut: ptr bool; mutedOut: ptr bool; ppqposOut: ptr cdouble; msg: cstring; msg_sz: ptr cint): bool {.ReaperAPI.}
proc MIDI_GetGrid*(take: ptr MediaItem_Take; swingOutOptional: ptr cdouble; noteLenOutOptional: ptr cdouble): cdouble {.ReaperAPI.}
proc MIDI_GetHash*(take: ptr MediaItem_Take; notesonly: bool; hash: cstring; hash_sz: cint): bool {.ReaperAPI.}
proc MIDI_GetNote*(take: ptr MediaItem_Take; noteidx: cint; selectedOut: ptr bool; mutedOut: ptr bool; startppqposOut: ptr cdouble; endppqposOut: ptr cdouble; chanOut: ptr cint; pitchOut: ptr cint; velOut: ptr cint): bool {.ReaperAPI.}
proc MIDI_GetPPQPos_EndOfMeasure*(take: ptr MediaItem_Take; ppqpos: cdouble): cdouble {.ReaperAPI.}
proc MIDI_GetPPQPos_StartOfMeasure*(take: ptr MediaItem_Take; ppqpos: cdouble): cdouble {.ReaperAPI.}
proc MIDI_GetPPQPosFromProjQN*(take: ptr MediaItem_Take; projqn: cdouble): cdouble {.ReaperAPI.}
proc MIDI_GetPPQPosFromProjTime*(take: ptr MediaItem_Take; projtime: cdouble): cdouble {.ReaperAPI.}
proc MIDI_GetProjQNFromPPQPos*(take: ptr MediaItem_Take; ppqpos: cdouble): cdouble {.ReaperAPI.}
proc MIDI_GetProjTimeFromPPQPos*(take: ptr MediaItem_Take; ppqpos: cdouble): cdouble {.ReaperAPI.}
proc MIDI_GetScale*(take: ptr MediaItem_Take; rootOut: ptr cint; scaleOut: ptr cint; name: cstring; name_sz: cint): bool {.ReaperAPI.}
proc MIDI_GetTextSysexEvt*(take: ptr MediaItem_Take; textsyxevtidx: cint; selectedOutOptional: ptr bool; mutedOutOptional: ptr bool; ppqposOutOptional: ptr cdouble; typeOutOptional: ptr cint; msgOptional: cstring; msgOptional_sz: ptr cint): bool {.ReaperAPI.}
proc MIDI_GetTrackHash*(track: ptr MediaTrack; notesonly: bool; hash: cstring; hash_sz: cint): bool {.ReaperAPI.}
proc MIDI_InsertCC*(take: ptr MediaItem_Take; selected: bool; muted: bool; ppqpos: cdouble; chanmsg: cint; chan: cint; msg2: cint; msg3: cint): bool {.ReaperAPI.}
proc MIDI_InsertEvt*(take: ptr MediaItem_Take; selected: bool; muted: bool; ppqpos: cdouble; bytestr: cstring; bytestr_sz: cint): bool {.ReaperAPI.}
proc MIDI_InsertNote*(take: ptr MediaItem_Take; selected: bool; muted: bool; startppqpos: cdouble; endppqpos: cdouble; chan: cint; pitch: cint; vel: cint; noSortInOptional: ptr bool): bool {.ReaperAPI.}
proc MIDI_InsertTextSysexEvt*(take: ptr MediaItem_Take; selected: bool; muted: bool; ppqpos: cdouble; `type`: cint; bytestr: cstring; bytestr_sz: cint): bool {.ReaperAPI.}
proc midi_reinit*() {.ReaperAPI.}
proc MIDI_SelectAll*(take: ptr MediaItem_Take; select: bool) {.ReaperAPI.}
proc MIDI_SetAllEvts*(take: ptr MediaItem_Take; buf: cstring; buf_sz: cint): bool {.ReaperAPI.}
proc MIDI_SetCC*(take: ptr MediaItem_Take; ccidx: cint; selectedInOptional: ptr bool; mutedInOptional: ptr bool; ppqposInOptional: ptr cdouble; chanmsgInOptional: ptr cint; chanInOptional: ptr cint; msg2InOptional: ptr cint; msg3InOptional: ptr cint; noSortInOptional: ptr bool): bool {.ReaperAPI.}
proc MIDI_SetCCShape*(take: ptr MediaItem_Take; ccidx: cint; shape: cint; beztension: cdouble; noSortInOptional: ptr bool): bool {.ReaperAPI.}
proc MIDI_SetEvt*(take: ptr MediaItem_Take; evtidx: cint; selectedInOptional: ptr bool; mutedInOptional: ptr bool; ppqposInOptional: ptr cdouble; msgOptional: cstring; msgOptional_sz: cint; noSortInOptional: ptr bool): bool {.ReaperAPI.}
proc MIDI_SetItemExtents*(item: ptr MediaItem; startQN: cdouble; endQN: cdouble): bool {.ReaperAPI.}
proc MIDI_SetNote*(take: ptr MediaItem_Take; noteidx: cint; selectedInOptional: ptr bool; mutedInOptional: ptr bool; startppqposInOptional: ptr cdouble; endppqposInOptional: ptr cdouble; chanInOptional: ptr cint; pitchInOptional: ptr cint; velInOptional: ptr cint; noSortInOptional: ptr bool): bool {.ReaperAPI.}
proc MIDI_SetTextSysexEvt*(take: ptr MediaItem_Take; textsyxevtidx: cint; selectedInOptional: ptr bool; mutedInOptional: ptr bool; ppqposInOptional: ptr cdouble; typeInOptional: ptr cint; msgOptional: cstring; msgOptional_sz: cint; noSortInOptional: ptr bool): bool {.ReaperAPI.}
proc MIDI_Sort*(take: ptr MediaItem_Take) {.ReaperAPI.}
proc MIDIEditor_GetActive*(): HWND {.ReaperAPI.}
proc MIDIEditor_GetMode*(midieditor: HWND): cint {.ReaperAPI.}
proc MIDIEditor_GetSetting_int*(midieditor: HWND; setting_desc: cstring): cint {.ReaperAPI.}
proc MIDIEditor_GetSetting_str*(midieditor: HWND; setting_desc: cstring; buf: cstring; buf_sz: cint): bool {.ReaperAPI.}
proc MIDIEditor_GetTake*(midieditor: HWND): ptr MediaItem_Take {.ReaperAPI.}
proc MIDIEditor_LastFocused_OnCommand*(command_id: cint; islistviewcommand: bool): bool {.ReaperAPI.}
proc MIDIEditor_OnCommand*(midieditor: HWND; command_id: cint): bool {.ReaperAPI.}
proc MIDIEditor_SetSetting_int*(midieditor: HWND; setting_desc: cstring; setting: cint): bool {.ReaperAPI.}
proc mkpanstr*(strNeed64: cstring; pan: cdouble) {.ReaperAPI.}
proc mkvolpanstr*(strNeed64: cstring; vol: cdouble; pan: cdouble) {.ReaperAPI.}
proc mkvolstr*(strNeed64: cstring; vol: cdouble) {.ReaperAPI.}
proc MoveEditCursor*(adjamt: cdouble; dosel: bool) {.ReaperAPI.}
proc MoveMediaItemToTrack*(item: ptr MediaItem; desttr: ptr MediaTrack): bool {.ReaperAPI.}
proc MuteAllTracks*(mute: bool) {.ReaperAPI.}
proc my_getViewport*(r: ptr RECT; sr: ptr RECT; wantWorkArea: bool) {.ReaperAPI.}
proc NamedCommandLookup*(command_name: cstring): cint {.ReaperAPI.}
proc OnPauseButton*() {.ReaperAPI.}
proc OnPauseButtonEx*(proj: ptr ReaProject) {.ReaperAPI.}
proc OnPlayButton*() {.ReaperAPI.}
proc OnPlayButtonEx*(proj: ptr ReaProject) {.ReaperAPI.}
proc OnStopButton*() {.ReaperAPI.}
proc OnStopButtonEx*(proj: ptr ReaProject) {.ReaperAPI.}
proc OpenColorThemeFile*(fn: cstring): bool {.ReaperAPI.}
proc OpenMediaExplorer*(mediafn: cstring; play: bool): HWND {.ReaperAPI.}
proc OscLocalMessageToHost*(message: cstring; valueInOptional: ptr cdouble) {.ReaperAPI.}
proc parse_timestr*(buf: cstring): cdouble {.ReaperAPI.}
proc parse_timestr_len*(buf: cstring; offset: cdouble; modeoverride: cint): cdouble {.ReaperAPI.}
proc parse_timestr_pos*(buf: cstring; modeoverride: cint): cdouble {.ReaperAPI.}
proc parsepanstr*(str: cstring): cdouble {.ReaperAPI.}
# proc PCM_Sink_Create*(filename: cstring; cfg: cstring; cfg_sz: cint; nch: cint; srate: cint; buildpeaks: bool): ptr PCM_sink {.ReaperAPI.}
# proc PCM_Sink_CreateEx*(proj: ptr ReaProject; filename: cstring; cfg: cstring; cfg_sz: cint; nch: cint; srate: cint; buildpeaks: bool): ptr PCM_sink {.ReaperAPI.}
# proc PCM_Sink_CreateMIDIFile*(filename: cstring; cfg: cstring; cfg_sz: cint; bpm: cdouble; `div`: cint): ptr PCM_sink {.ReaperAPI.}
# proc PCM_Sink_CreateMIDIFileEx*(proj: ptr ReaProject; filename: cstring; cfg: cstring; cfg_sz: cint; bpm: cdouble; `div`: cint): ptr PCM_sink {.ReaperAPI.}
proc PCM_Sink_Enum*(idx: cint; descstrOut: cstringArray): cuint {.ReaperAPI.}
proc PCM_Sink_GetExtension*(data: cstring; data_sz: cint): cstring {.ReaperAPI.}
proc PCM_Sink_ShowConfig*(cfg: cstring; cfg_sz: cint; hwndParent: HWND): HWND {.ReaperAPI.}
# proc PCM_Source_CreateFromFile*(filename: cstring): ptr PCM_source {.ReaperAPI.}
# proc PCM_Source_CreateFromFileEx*(filename: cstring; forcenoMidiImp: bool): ptr PCM_source {.ReaperAPI.}
# proc PCM_Source_CreateFromSimple*(dec: ptr ISimpleMediaDecoder; fn: cstring): ptr PCM_source {.ReaperAPI.}
# proc PCM_Source_CreateFromType*(sourcetype: cstring): ptr PCM_source {.ReaperAPI.}
# proc PCM_Source_Destroy*(src: ptr PCM_source) {.ReaperAPI.}
# proc PCM_Source_GetPeaks*(src: ptr PCM_source; peakrate: cdouble; starttime: cdouble; numchannels: cint; numsamplesperchannel: cint; want_extra_type: cint; buf: ptr cdouble): cint {.ReaperAPI.}
# proc PCM_Source_GetSectionInfo*(src: ptr PCM_source; offsOut: ptr cdouble; lenOut: ptr cdouble; revOut: ptr bool): bool {.ReaperAPI.}
# proc PeakBuild_Create*(src: ptr PCM_source; fn: cstring; srate: cint; nch: cint): ptr REAPER_PeakBuild_Interface {.ReaperAPI.}
# proc PeakBuild_CreateEx*(src: ptr PCM_source; fn: cstring; srate: cint; nch: cint; flags: cint): ptr REAPER_PeakBuild_Interface {.ReaperAPI.}
# proc PeakGet_Create*(fn: cstring; srate: cint; nch: cint): ptr REAPER_PeakGet_Interface {.ReaperAPI.}
proc PitchShiftSubModeMenu*(hwnd: HWND; x: cint; y: cint; mode: cint; submode_sel: cint): cint {.ReaperAPI.}
# proc PlayPreview*(preview: ptr preview_register_t): cint {.ReaperAPI.}
# proc PlayPreviewEx*(preview: ptr preview_register_t; bufflags: cint; measure_align: cdouble): cint {.ReaperAPI.}
# proc PlayTrackPreview*(preview: ptr preview_register_t): cint {.ReaperAPI.}
# proc PlayTrackPreview2*(proj: ptr ReaProject; preview: ptr preview_register_t): cint {.ReaperAPI.}
# proc PlayTrackPreview2Ex*(proj: ptr ReaProject; preview: ptr preview_register_t; flags: cint; measure_align: cdouble): cint {.ReaperAPI.}
proc plugin_getapi*(name: cstring): pointer {.ReaperAPI.}
proc plugin_getFilterList*(): cstring {.ReaperAPI.}
proc plugin_getImportableProjectFilterList*(): cstring {.ReaperAPI.}
proc plugin_register*(name: cstring; infostruct: pointer): cint {.ReaperAPI.}
proc PluginWantsAlwaysRunFx*(amt: cint) {.ReaperAPI.}
proc PreventUIRefresh*(prevent_count: cint) {.ReaperAPI.}
proc projectconfig_var_addr*(proj: ptr ReaProject; idx: cint): pointer {.ReaperAPI.}
proc projectconfig_var_getoffs*(name: cstring; szOut: ptr cint): cint {.ReaperAPI.}
proc PromptForAction*(session_mode: cint; init_id: cint; section_id: cint): cint {.ReaperAPI.}
proc realloc_cmd_ptr*(`ptr`: cstringArray; ptr_size: ptr cint; new_size: cint): bool {.ReaperAPI.}
# proc ReaperGetPitchShiftAPI*(version: cint): ptr IReaperPitchShift {.ReaperAPI.}
proc ReaScriptError*(errmsg: cstring) {.ReaperAPI.}
proc RecursiveCreateDirectory*(path: cstring; ignored: csize_t): cint {.ReaperAPI.}
proc reduce_open_files*(flags: cint): cint {.ReaperAPI.}
proc RefreshToolbar*(command_id: cint) {.ReaperAPI.}
proc RefreshToolbar2*(section_id: cint; command_id: cint) {.ReaperAPI.}
proc relative_fn*(`in`: cstring; `out`: cstring; out_sz: cint) {.ReaperAPI.}
proc RemoveTrackSend*(tr: ptr MediaTrack; category: cint; sendidx: cint): bool {.ReaperAPI.}
proc RenderFileSection*(source_filename: cstring; target_filename: cstring; start_percent: cdouble; end_percent: cdouble; playrate: cdouble): bool {.ReaperAPI.}
proc ReorderSelectedTracks*(beforeTrackIdx: cint; makePrevFolder: cint): bool {.ReaperAPI.}
proc Resample_EnumModes*(mode: cint): cstring {.ReaperAPI.}
# proc Resampler_Create*(): ptr REAPER_Resample_Interface {.ReaperAPI.}
proc resolve_fn*(`in`: cstring; `out`: cstring; out_sz: cint) {.ReaperAPI.}
proc resolve_fn2*(`in`: cstring; `out`: cstring; out_sz: cint; checkSubDirOptional: cstring) {.ReaperAPI.}
proc ReverseNamedCommandLookup*(command_id: cint): cstring {.ReaperAPI.}
proc ScaleFromEnvelopeMode*(scaling_mode: cint; val: cdouble): cdouble {.ReaperAPI.}
proc ScaleToEnvelopeMode*(scaling_mode: cint; val: cdouble): cdouble {.ReaperAPI.}
proc screenset_register*(id: cstring; callbackFunc: pointer; param: pointer) {.ReaperAPI.}
# proc screenset_registerNew*(id: cstring; callbackFunc: screensetNewCallbackFunc; param: pointer) {.ReaperAPI.}
proc screenset_unregister*(id: cstring) {.ReaperAPI.}
proc screenset_unregisterByParam*(param: pointer) {.ReaperAPI.}
proc screenset_updateLastFocus*(prevWin: HWND) {.ReaperAPI.}
proc SectionFromUniqueID*(uniqueID: cint): ptr KbdSectionInfo {.ReaperAPI.}
proc SelectAllMediaItems*(proj: ptr ReaProject; selected: bool) {.ReaperAPI.}
proc SelectProjectInstance*(proj: ptr ReaProject) {.ReaperAPI.}
proc SendLocalOscMessage*(local_osc_handler: pointer; msg: cstring; msglen: cint) {.ReaperAPI.}
proc SetActiveTake*(take: ptr MediaItem_Take) {.ReaperAPI.}
proc SetAutomationMode*(mode: cint; onlySel: bool) {.ReaperAPI.}
# proc SetCurrentBPM*(__proj: ptr ReaProject; bpm: cdouble; wantUndo: bool) {.ReaperAPI.}
proc SetCursorContext*(mode: cint; envInOptional: ptr TrackEnvelope) {.ReaperAPI.}
proc SetEditCurPos*(time: cdouble; moveview: bool; seekplay: bool) {.ReaperAPI.}
proc SetEditCurPos2*(proj: ptr ReaProject; time: cdouble; moveview: bool; seekplay: bool) {.ReaperAPI.}
proc SetEnvelopePoint*(envelope: ptr TrackEnvelope; ptidx: cint; timeInOptional: ptr cdouble; valueInOptional: ptr cdouble; shapeInOptional: ptr cint; tensionInOptional: ptr cdouble; selectedInOptional: ptr bool; noSortInOptional: ptr bool): bool {.ReaperAPI.}
proc SetEnvelopePointEx*(envelope: ptr TrackEnvelope; autoitem_idx: cint; ptidx: cint; timeInOptional: ptr cdouble; valueInOptional: ptr cdouble; shapeInOptional: ptr cint; tensionInOptional: ptr cdouble; selectedInOptional: ptr bool; noSortInOptional: ptr bool): bool {.ReaperAPI.}
proc SetEnvelopeStateChunk*(env: ptr TrackEnvelope; str: cstring; isundoOptional: bool): bool {.ReaperAPI.}
proc SetExtState*(section: cstring; key: cstring; value: cstring; persist: bool) {.ReaperAPI.}
proc SetGlobalAutomationOverride*(mode: cint) {.ReaperAPI.}
proc SetItemStateChunk*(item: ptr MediaItem; str: cstring; isundoOptional: bool): bool {.ReaperAPI.}
proc SetMasterTrackVisibility*(flag: cint): cint {.ReaperAPI.}
proc SetMediaItemInfo_Value*(item: ptr MediaItem; parmname: cstring; newvalue: cdouble): bool {.ReaperAPI.}
proc SetMediaItemLength*(item: ptr MediaItem; length: cdouble; refreshUI: bool): bool {.ReaperAPI.}
proc SetMediaItemPosition*(item: ptr MediaItem; position: cdouble; refreshUI: bool): bool {.ReaperAPI.}
proc SetMediaItemSelected*(item: ptr MediaItem; selected: bool) {.ReaperAPI.}
# proc SetMediaItemTake_Source*(take: ptr MediaItem_Take; source: ptr PCM_source): bool {.ReaperAPI.}
proc SetMediaItemTakeInfo_Value*(take: ptr MediaItem_Take; parmname: cstring; newvalue: cdouble): bool {.ReaperAPI.}
proc SetMediaTrackInfo_Value*(tr: ptr MediaTrack; parmname: cstring; newvalue: cdouble): bool {.ReaperAPI.}
proc SetMIDIEditorGrid*(project: ptr ReaProject; division: cdouble) {.ReaperAPI.}
proc SetMixerScroll*(leftmosttrack: ptr MediaTrack): ptr MediaTrack {.ReaperAPI.}
proc SetMouseModifier*(context: cstring; modifier_flag: cint; action: cstring) {.ReaperAPI.}
proc SetOnlyTrackSelected*(track: ptr MediaTrack) {.ReaperAPI.}
proc SetProjectGrid*(project: ptr ReaProject; division: cdouble) {.ReaperAPI.}
proc SetProjectMarker*(markrgnindexnumber: cint; isrgn: bool; pos: cdouble; rgnend: cdouble; name: cstring): bool {.ReaperAPI.}
proc SetProjectMarker2*(proj: ptr ReaProject; markrgnindexnumber: cint; isrgn: bool; pos: cdouble; rgnend: cdouble; name: cstring): bool {.ReaperAPI.}
proc SetProjectMarker3*(proj: ptr ReaProject; markrgnindexnumber: cint; isrgn: bool; pos: cdouble; rgnend: cdouble; name: cstring; color: cint): bool {.ReaperAPI.}
proc SetProjectMarker4*(proj: ptr ReaProject; markrgnindexnumber: cint; isrgn: bool; pos: cdouble; rgnend: cdouble; name: cstring; color: cint; flags: cint): bool {.ReaperAPI.}
proc SetProjectMarkerByIndex*(proj: ptr ReaProject; markrgnidx: cint; isrgn: bool; pos: cdouble; rgnend: cdouble; IDnumber: cint; name: cstring; color: cint): bool {.ReaperAPI.}
proc SetProjectMarkerByIndex2*(proj: ptr ReaProject; markrgnidx: cint; isrgn: bool; pos: cdouble; rgnend: cdouble; IDnumber: cint; name: cstring; color: cint; flags: cint): bool {.ReaperAPI.}
proc SetProjExtState*(proj: ptr ReaProject; extname: cstring; key: cstring; value: cstring): cint {.ReaperAPI.}
proc SetRegionRenderMatrix*(proj: ptr ReaProject; regionindex: cint; track: ptr MediaTrack; addorremove: cint) {.ReaperAPI.}
proc SetRenderLastError*(errorstr: cstring) {.ReaperAPI.}
proc SetTakeMarker*(take: ptr MediaItem_Take; idx: cint; nameIn: cstring; srcposInOptional: ptr cdouble; colorInOptional: ptr cint): cint {.ReaperAPI.}
proc SetTakeStretchMarker*(take: ptr MediaItem_Take; idx: cint; pos: cdouble; srcposInOptional: ptr cdouble): cint {.ReaperAPI.}
proc SetTakeStretchMarkerSlope*(take: ptr MediaItem_Take; idx: cint; slope: cdouble): bool {.ReaperAPI.}
proc SetTempoTimeSigMarker*(proj: ptr ReaProject; ptidx: cint; timepos: cdouble; measurepos: cint; beatpos: cdouble; bpm: cdouble; timesig_num: cint; timesig_denom: cint; lineartempo: bool): bool {.ReaperAPI.}
proc SetThemeColor*(ini_key: cstring; color: cint; flagsOptional: cint): cint {.ReaperAPI.}
proc SetToggleCommandState*(section_id: cint; command_id: cint; state: cint): bool {.ReaperAPI.}
proc SetTrackAutomationMode*(tr: ptr MediaTrack; mode: cint) {.ReaperAPI.}
proc SetTrackColor*(track: ptr MediaTrack; color: cint) {.ReaperAPI.}
proc SetTrackMIDILyrics*(track: ptr MediaTrack; flag: cint; str: cstring): bool {.ReaperAPI.}
proc SetTrackMIDINoteName*(track: cint; pitch: cint; chan: cint; name: cstring): bool {.ReaperAPI.}
proc SetTrackMIDINoteNameEx*(proj: ptr ReaProject; track: ptr MediaTrack; pitch: cint; chan: cint; name: cstring): bool {.ReaperAPI.}
proc SetTrackSelected*(track: ptr MediaTrack; selected: bool) {.ReaperAPI.}
proc SetTrackSendInfo_Value*(tr: ptr MediaTrack; category: cint; sendidx: cint; parmname: cstring; newvalue: cdouble): bool {.ReaperAPI.}
proc SetTrackSendUIPan*(track: ptr MediaTrack; send_idx: cint; pan: cdouble; isend: cint): bool {.ReaperAPI.}
proc SetTrackSendUIVol*(track: ptr MediaTrack; send_idx: cint; vol: cdouble; isend: cint): bool {.ReaperAPI.}
proc SetTrackStateChunk*(track: ptr MediaTrack; str: cstring; isundoOptional: bool): bool {.ReaperAPI.}
proc ShowActionList*(caller: ptr KbdSectionInfo; callerWnd: HWND) {.ReaperAPI.}
proc ShowConsoleMsg*(msg: cstring) {.ReaperAPI.}
proc ShowMessageBox*(msg: cstring; title: cstring; `type`: cint): cint {.ReaperAPI.}
proc ShowPopupMenu*(name: cstring; x: cint; y: cint; hwndParentOptional: HWND; ctxOptional: pointer; ctx2Optional: cint; ctx3Optional: cint) {.ReaperAPI.}
proc SLIDER2DB*(y: cdouble): cdouble {.ReaperAPI.}
proc SnapToGrid*(project: ptr ReaProject; time_pos: cdouble): cdouble {.ReaperAPI.}
proc SoloAllTracks*(solo: cint) {.ReaperAPI.}
proc Splash_GetWnd*(): HWND {.ReaperAPI.}
proc SplitMediaItem*(item: ptr MediaItem; position: cdouble): ptr MediaItem {.ReaperAPI.}
# proc StopPreview*(preview: ptr preview_register_t): cint {.ReaperAPI.}
# proc StopTrackPreview*(preview: ptr preview_register_t): cint {.ReaperAPI.}
# proc StopTrackPreview2*(proj: pointer; preview: ptr preview_register_t): cint {.ReaperAPI.}
proc stringToGuid*(str: cstring; g: ptr GUID) {.ReaperAPI.}
proc StuffMIDIMessage*(mode: cint; msg1: cint; msg2: cint; msg3: cint) {.ReaperAPI.}
proc TakeFX_AddByName*(take: ptr MediaItem_Take; fxname: cstring; instantiate: cint): cint {.ReaperAPI.}
proc TakeFX_CopyToTake*(src_take: ptr MediaItem_Take; src_fx: cint; dest_take: ptr MediaItem_Take; dest_fx: cint; is_move: bool) {.ReaperAPI.}
proc TakeFX_CopyToTrack*(src_take: ptr MediaItem_Take; src_fx: cint; dest_track: ptr MediaTrack; dest_fx: cint; is_move: bool) {.ReaperAPI.}
proc TakeFX_Delete*(take: ptr MediaItem_Take; fx: cint): bool {.ReaperAPI.}
proc TakeFX_EndParamEdit*(take: ptr MediaItem_Take; fx: cint; param: cint): bool {.ReaperAPI.}
proc TakeFX_FormatParamValue*(take: ptr MediaItem_Take; fx: cint; param: cint; val: cdouble; buf: cstring; buf_sz: cint): bool {.ReaperAPI.}
proc TakeFX_FormatParamValueNormalized*(take: ptr MediaItem_Take; fx: cint; param: cint; value: cdouble; buf: cstring; buf_sz: cint): bool {.ReaperAPI.}
proc TakeFX_GetChainVisible*(take: ptr MediaItem_Take): cint {.ReaperAPI.}
proc TakeFX_GetCount*(take: ptr MediaItem_Take): cint {.ReaperAPI.}
proc TakeFX_GetEnabled*(take: ptr MediaItem_Take; fx: cint): bool {.ReaperAPI.}
proc TakeFX_GetEnvelope*(take: ptr MediaItem_Take; fxindex: cint; parameterindex: cint; create: bool): ptr TrackEnvelope {.ReaperAPI.}
proc TakeFX_GetFloatingWindow*(take: ptr MediaItem_Take; index: cint): HWND {.ReaperAPI.}
proc TakeFX_GetFormattedParamValue*(take: ptr MediaItem_Take; fx: cint; param: cint; buf: cstring; buf_sz: cint): bool {.ReaperAPI.}
proc TakeFX_GetFXGUID*(take: ptr MediaItem_Take; fx: cint): ptr GUID {.ReaperAPI.}
proc TakeFX_GetFXName*(take: ptr MediaItem_Take; fx: cint; buf: cstring; buf_sz: cint): bool {.ReaperAPI.}
proc TakeFX_GetIOSize*(take: ptr MediaItem_Take; fx: cint; inputPinsOutOptional: ptr cint; outputPinsOutOptional: ptr cint): cint {.ReaperAPI.}
proc TakeFX_GetNamedConfigParm*(take: ptr MediaItem_Take; fx: cint; parmname: cstring; bufOut: cstring; bufOut_sz: cint): bool {.ReaperAPI.}
proc TakeFX_GetNumParams*(take: ptr MediaItem_Take; fx: cint): cint {.ReaperAPI.}
proc TakeFX_GetOffline*(take: ptr MediaItem_Take; fx: cint): bool {.ReaperAPI.}
proc TakeFX_GetOpen*(take: ptr MediaItem_Take; fx: cint): bool {.ReaperAPI.}
proc TakeFX_GetParam*(take: ptr MediaItem_Take; fx: cint; param: cint; minvalOut: ptr cdouble; maxvalOut: ptr cdouble): cdouble {.ReaperAPI.}
proc TakeFX_GetParameterStepSizes*(take: ptr MediaItem_Take; fx: cint; param: cint; stepOut: ptr cdouble; smallstepOut: ptr cdouble; largestepOut: ptr cdouble; istoggleOut: ptr bool): bool {.ReaperAPI.}
proc TakeFX_GetParamEx*(take: ptr MediaItem_Take; fx: cint; param: cint; minvalOut: ptr cdouble; maxvalOut: ptr cdouble; midvalOut: ptr cdouble): cdouble {.ReaperAPI.}
proc TakeFX_GetParamName*(take: ptr MediaItem_Take; fx: cint; param: cint; buf: cstring; buf_sz: cint): bool {.ReaperAPI.}
proc TakeFX_GetParamNormalized*(take: ptr MediaItem_Take; fx: cint; param: cint): cdouble {.ReaperAPI.}
proc TakeFX_GetPinMappings*(tr: ptr MediaItem_Take; fx: cint; isoutput: cint; pin: cint; high32OutOptional: ptr cint): cint {.ReaperAPI.}
proc TakeFX_GetPreset*(take: ptr MediaItem_Take; fx: cint; presetname: cstring; presetname_sz: cint): bool {.ReaperAPI.}
proc TakeFX_GetPresetIndex*(take: ptr MediaItem_Take; fx: cint;numberOfPresetsOut: ptr cint): cint {.ReaperAPI.}
proc TakeFX_GetUserPresetFilename*(take: ptr MediaItem_Take; fx: cint; fn: cstring; fn_sz: cint) {.ReaperAPI.}
proc TakeFX_NavigatePresets*(take: ptr MediaItem_Take; fx: cint; presetmove: cint): bool {.ReaperAPI.}
proc TakeFX_SetEnabled*(take: ptr MediaItem_Take; fx: cint; enabled: bool) {.ReaperAPI.}
proc TakeFX_SetNamedConfigParm*(take: ptr MediaItem_Take; fx: cint; parmname: cstring; value: cstring): bool {.ReaperAPI.}
proc TakeFX_SetOffline*(take: ptr MediaItem_Take; fx: cint; offline: bool) {.ReaperAPI.}
proc TakeFX_SetOpen*(take: ptr MediaItem_Take; fx: cint; open: bool) {.ReaperAPI.}
proc TakeFX_SetParam*(take: ptr MediaItem_Take; fx: cint; param: cint; val: cdouble): bool {.ReaperAPI.}
proc TakeFX_SetParamNormalized*(take: ptr MediaItem_Take; fx: cint; param: cint; value: cdouble): bool {.ReaperAPI.}
proc TakeFX_SetPinMappings*(tr: ptr MediaItem_Take; fx: cint; isoutput: cint; pin: cint; low32bits: cint; hi32bits: cint): bool {.ReaperAPI.}
proc TakeFX_SetPreset*(take: ptr MediaItem_Take; fx: cint; presetname: cstring): bool {.ReaperAPI.}
proc TakeFX_SetPresetByIndex*(take: ptr MediaItem_Take; fx: cint; idx: cint): bool {.ReaperAPI.}
proc TakeFX_Show*(take: ptr MediaItem_Take; index: cint; showFlag: cint) {.ReaperAPI.}
proc TakeIsMIDI*(take: ptr MediaItem_Take): bool {.ReaperAPI.}
proc ThemeLayout_GetLayout*(section: cstring; idx: cint; nameOut: cstring; nameOut_sz: cint): bool {.ReaperAPI.}
proc ThemeLayout_GetParameter*(wp: cint; descOutOptional: cstringArray; valueOutOptional: ptr cint; defValueOutOptional: ptr cint; minValueOutOptional: ptr cint; maxValueOutOptional: ptr cint): cstring {.ReaperAPI.}
proc ThemeLayout_RefreshAll*() {.ReaperAPI.}
proc ThemeLayout_SetLayout*(section: cstring; layout: cstring): bool {.ReaperAPI.}
proc ThemeLayout_SetParameter*(wp: cint; value: cint; persist: bool): bool {.ReaperAPI.}
proc time_precise*(): cdouble {.ReaperAPI.}
proc TimeMap2_beatsToTime*(proj: ptr ReaProject; tpos: cdouble; measuresInOptional: ptr cint): cdouble {.ReaperAPI.}
proc TimeMap2_GetDividedBpmAtTime*(proj: ptr ReaProject; time: cdouble): cdouble {.ReaperAPI.}
proc TimeMap2_GetNextChangeTime*(proj: ptr ReaProject; time: cdouble): cdouble {.ReaperAPI.}
proc TimeMap2_QNToTime*(proj: ptr ReaProject; qn: cdouble): cdouble {.ReaperAPI.}
proc TimeMap2_timeToBeats*(proj: ptr ReaProject; tpos: cdouble; measuresOutOptional: ptr cint; cmlOutOptional: ptr cint; fullbeatsOutOptional: ptr cdouble; cdenomOutOptional: ptr cint): cdouble {.ReaperAPI.}
proc TimeMap2_timeToQN*(proj: ptr ReaProject; tpos: cdouble): cdouble {.ReaperAPI.}
proc TimeMap_curFrameRate*(proj: ptr ReaProject; dropFrameOutOptional: ptr bool): cdouble {.ReaperAPI.}
proc TimeMap_GetDividedBpmAtTime*(time: cdouble): cdouble {.ReaperAPI.}
proc TimeMap_GetMeasureInfo*(proj: ptr ReaProject; measure: cint; qn_startOut: ptr cdouble; qn_endOut: ptr cdouble; timesig_numOut: ptr cint; timesig_denomOut: ptr cint; tempoOut: ptr cdouble): cdouble {.ReaperAPI.}
proc TimeMap_GetMetronomePattern*(proj: ptr ReaProject; time: cdouble; pattern: cstring; pattern_sz: cint): cint {.ReaperAPI.}
proc TimeMap_GetTimeSigAtTime*(proj: ptr ReaProject; time: cdouble; timesig_numOut: ptr cint; timesig_denomOut: ptr cint; tempoOut: ptr cdouble) {.ReaperAPI.}
proc TimeMap_QNToMeasures*(proj: ptr ReaProject; qn: cdouble; qnMeasureStartOutOptional: ptr cdouble; qnMeasureEndOutOptional: ptr cdouble): cint {.ReaperAPI.}
proc TimeMap_QNToTime*(qn: cdouble): cdouble {.ReaperAPI.}
proc TimeMap_QNToTime_abs*(proj: ptr ReaProject; qn: cdouble): cdouble {.ReaperAPI.}
proc TimeMap_timeToQN*(tpos: cdouble): cdouble {.ReaperAPI.}
proc TimeMap_timeToQN_abs*(proj: ptr ReaProject; tpos: cdouble): cdouble {.ReaperAPI.}
proc ToggleTrackSendUIMute*(track: ptr MediaTrack; send_idx: cint): bool {.ReaperAPI.}
proc Track_GetPeakHoldDB*(track: ptr MediaTrack; channel: cint; clear: bool): cdouble {.ReaperAPI.}
proc Track_GetPeakInfo*(track: ptr MediaTrack; channel: cint): cdouble {.ReaperAPI.}
proc TrackCtl_SetToolTip*(fmt: cstring; xpos: cint; ypos: cint; topmost: bool) {.ReaperAPI.}
proc TrackFX_AddByName*(track: ptr MediaTrack; fxname: cstring; recFX: bool; instantiate: cint): cint {.ReaperAPI.}
proc TrackFX_CopyToTake*(src_track: ptr MediaTrack; src_fx: cint; dest_take: ptr MediaItem_Take; dest_fx: cint; is_move: bool) {.ReaperAPI.}
proc TrackFX_CopyToTrack*(src_track: ptr MediaTrack; src_fx: cint; dest_track: ptr MediaTrack; dest_fx: cint; is_move: bool) {.ReaperAPI.}
proc TrackFX_Delete*(track: ptr MediaTrack; fx: cint): bool {.ReaperAPI.}
proc TrackFX_EndParamEdit*(track: ptr MediaTrack; fx: cint; param: cint): bool {.ReaperAPI.}
proc TrackFX_FormatParamValue*(track: ptr MediaTrack; fx: cint; param: cint; val: cdouble; buf: cstring; buf_sz: cint): bool {.ReaperAPI.}
proc TrackFX_FormatParamValueNormalized*(track: ptr MediaTrack; fx: cint; param: cint; value: cdouble; buf: cstring; buf_sz: cint): bool {.ReaperAPI.}
proc TrackFX_GetByName*(track: ptr MediaTrack; fxname: cstring; instantiate: bool): cint {.ReaperAPI.}
proc TrackFX_GetChainVisible*(track: ptr MediaTrack): cint {.ReaperAPI.}
proc TrackFX_GetCount*(track: ptr MediaTrack): cint {.ReaperAPI.}
proc TrackFX_GetEnabled*(track: ptr MediaTrack; fx: cint): bool {.ReaperAPI.}
proc TrackFX_GetEQ*(track: ptr MediaTrack; instantiate: bool): cint {.ReaperAPI.}
proc TrackFX_GetEQBandEnabled*(track: ptr MediaTrack; fxidx: cint; bandtype: cint; bandidx: cint): bool {.ReaperAPI.}
proc TrackFX_GetEQParam*(track: ptr MediaTrack; fxidx: cint; paramidx: cint; bandtypeOut: ptr cint; bandidxOut: ptr cint; paramtypeOut: ptr cint; normvalOut: ptr cdouble): bool {.ReaperAPI.}
proc TrackFX_GetFloatingWindow*(track: ptr MediaTrack; index: cint): HWND {.ReaperAPI.}
proc TrackFX_GetFormattedParamValue*(track: ptr MediaTrack; fx: cint; param: cint; buf: cstring; buf_sz: cint): bool {.ReaperAPI.}
proc TrackFX_GetFXGUID*(track: ptr MediaTrack; fx: cint): ptr GUID {.ReaperAPI.}
proc TrackFX_GetFXName*(track: ptr MediaTrack; fx: cint; buf: cstring; buf_sz: cint): bool {.ReaperAPI.}
proc TrackFX_GetInstrument*(track: ptr MediaTrack): cint {.ReaperAPI.}
proc TrackFX_GetIOSize*(track: ptr MediaTrack; fx: cint; inputPinsOutOptional: ptr cint; outputPinsOutOptional: ptr cint): cint {.ReaperAPI.}
proc TrackFX_GetNamedConfigParm*(track: ptr MediaTrack; fx: cint; parmname: cstring; bufOut: cstring; bufOut_sz: cint): bool {.ReaperAPI.}
proc TrackFX_GetNumParams*(track: ptr MediaTrack; fx: cint): cint {.ReaperAPI.}
proc TrackFX_GetOffline*(track: ptr MediaTrack; fx: cint): bool {.ReaperAPI.}
proc TrackFX_GetOpen*(track: ptr MediaTrack; fx: cint): bool {.ReaperAPI.}
proc TrackFX_GetParam*(track: ptr MediaTrack; fx: cint; param: cint; minvalOut: ptr cdouble; maxvalOut: ptr cdouble): cdouble {.ReaperAPI.}
proc TrackFX_GetParameterStepSizes*(track: ptr MediaTrack; fx: cint; param: cint; stepOut: ptr cdouble; smallstepOut: ptr cdouble; largestepOut: ptr cdouble; istoggleOut: ptr bool): bool {.ReaperAPI.}
proc TrackFX_GetParamEx*(track: ptr MediaTrack; fx: cint; param: cint; minvalOut: ptr cdouble; maxvalOut: ptr cdouble; midvalOut: ptr cdouble): cdouble {.ReaperAPI.}
proc TrackFX_GetParamName*(track: ptr MediaTrack; fx: cint; param: cint; buf: cstring; buf_sz: cint): bool {.ReaperAPI.}
proc TrackFX_GetParamNormalized*(track: ptr MediaTrack; fx: cint; param: cint): cdouble {.ReaperAPI.}
proc TrackFX_GetPinMappings*(tr: ptr MediaTrack; fx: cint; isoutput: cint; pin: cint; high32OutOptional: ptr cint): cint {.ReaperAPI.}
proc TrackFX_GetPreset*(track: ptr MediaTrack; fx: cint; presetname: cstring; presetname_sz: cint): bool {.ReaperAPI.}
proc TrackFX_GetPresetIndex*(track: ptr MediaTrack; fx: cint; numberOfPresetsOut: ptr cint): cint {.ReaperAPI.}
proc TrackFX_GetRecChainVisible*(track: ptr MediaTrack): cint {.ReaperAPI.}
proc TrackFX_GetRecCount*(track: ptr MediaTrack): cint {.ReaperAPI.}
proc TrackFX_GetUserPresetFilename*(track: ptr MediaTrack; fx: cint; fn: cstring; fn_sz: cint) {.ReaperAPI.}
proc TrackFX_NavigatePresets*(track: ptr MediaTrack; fx: cint; presetmove: cint): bool {.ReaperAPI.}
proc TrackFX_SetEnabled*(track: ptr MediaTrack; fx: cint; enabled: bool) {.ReaperAPI.}
proc TrackFX_SetEQBandEnabled*(track: ptr MediaTrack; fxidx: cint; bandtype: cint; bandidx: cint; enable: bool): bool {.ReaperAPI.}
proc TrackFX_SetEQParam*(track: ptr MediaTrack; fxidx: cint; bandtype: cint; bandidx: cint; paramtype: cint; val: cdouble; isnorm: bool): bool {.ReaperAPI.}
proc TrackFX_SetNamedConfigParm*(track: ptr MediaTrack; fx: cint; parmname: cstring; value: cstring): bool {.ReaperAPI.}
proc TrackFX_SetOffline*(track: ptr MediaTrack; fx: cint; offline: bool) {.ReaperAPI.}
proc TrackFX_SetOpen*(track: ptr MediaTrack; fx: cint; open: bool) {.ReaperAPI.}
proc TrackFX_SetParam*(track: ptr MediaTrack; fx: cint; param: cint; val: cdouble): bool {.ReaperAPI.}
proc TrackFX_SetParamNormalized*(track: ptr MediaTrack; fx: cint; param: cint; value: cdouble): bool {.ReaperAPI.}
proc TrackFX_SetPinMappings*(tr: ptr MediaTrack; fx: cint; isoutput: cint; pin: cint; low32bits: cint; hi32bits: cint): bool {.ReaperAPI.}
proc TrackFX_SetPreset*(track: ptr MediaTrack; fx: cint; presetname: cstring): bool {.ReaperAPI.}
proc TrackFX_SetPresetByIndex*(track: ptr MediaTrack; fx: cint; idx: cint): bool {.ReaperAPI.}
proc TrackFX_Show*(track: ptr MediaTrack; index: cint; showFlag: cint) {.ReaperAPI.}
proc TrackList_AdjustWindows*(isMinor: bool) {.ReaperAPI.}
proc TrackList_UpdateAllExternalSurfaces*() {.ReaperAPI.}
proc Undo_BeginBlock*() {.ReaperAPI.}
proc Undo_BeginBlock2*(proj: ptr ReaProject) {.ReaperAPI.}
proc Undo_CanRedo2*(proj: ptr ReaProject): cstring {.ReaperAPI.}
proc Undo_CanUndo2*(proj: ptr ReaProject): cstring {.ReaperAPI.}
proc Undo_DoRedo2*(proj: ptr ReaProject): cint {.ReaperAPI.}
proc Undo_DoUndo2*(proj: ptr ReaProject): cint {.ReaperAPI.}
proc Undo_EndBlock*(descchange: cstring; extraflags: cint) {.ReaperAPI.}
proc Undo_EndBlock2*(proj: ptr ReaProject; descchange: cstring; extraflags: cint) {.ReaperAPI.}
proc Undo_OnStateChange*(descchange: cstring) {.ReaperAPI.}
proc Undo_OnStateChange2*(proj: ptr ReaProject; descchange: cstring) {.ReaperAPI.}
proc Undo_OnStateChange_Item*(proj: ptr ReaProject; name: cstring; item: ptr MediaItem) {.ReaperAPI.}
proc Undo_OnStateChangeEx*(descchange: cstring; whichStates: cint; trackparm: cint) {.ReaperAPI.}
proc Undo_OnStateChangeEx2*(proj: ptr ReaProject; descchange: cstring; whichStates: cint; trackparm: cint) {.ReaperAPI.}
proc update_disk_counters*(readamt: cint; writeamt: cint) {.ReaperAPI.}
proc UpdateArrange*() {.ReaperAPI.}
proc UpdateItemInProject*(item: ptr MediaItem) {.ReaperAPI.}
proc UpdateTimeline*() {.ReaperAPI.}
proc ValidatePtr*(pointer: pointer; ctypename: cstring): bool {.ReaperAPI.}
proc ValidatePtr2*(proj: ptr ReaProject; pointer: pointer; ctypename: cstring): bool {.ReaperAPI.}
proc ViewPrefs*(page: cint; pageByName: cstring) {.ReaperAPI.}
proc WDL_VirtualWnd_ScaledBlitBG*(dest: ptr LICE_IBitmap; src: ptr WDL_VirtualWnd_BGCfg; destx: cint; desty: cint; destw: cint; desth: cint; clipx: cint; clipy: cint; clipw: cint; cliph: cint; alpha: cfloat; mode: cint): bool {.ReaperAPI.}