# CHECKPOINT: Main Entrypoint Call Tree (First Pass)

## Scope
- Rooted at `ESQ_StartupEntry` in `src/modules/groups/_main/a/a.s`.
- Expands direct control-flow to shutdown and command-line dispatch paths.
- Resolves `_main` and `a/m` jump stubs to concrete callees where symbols are known.
- Uses phase buckets for `ESQ_MainInitAndRun` because full leaf expansion is very large.

## Resolved Root Tree

```text
ESQ_StartupEntry
  -> _LVOSetSignal
  -> _LVOOpenLibrary (dos.library)
  -> (CLI/WB split)
  -> GROUP_MAIN_A_JMPTBL_UNKNOWN2B_Stub0
       -> UNKNOWN2B_Stub0
  -> GROUP_MAIN_A_JMPTBL_ESQ_ParseCommandLineAndRun
       -> ESQ_ParseCommandLineAndRun
            -> HANDLE_CloseAllAndReturnWithCode
            -> STRING_AppendN
            -> UNKNOWN29_JMPTBL_ESQ_MainInitAndRun
                 -> ESQ_MainInitAndRun
            -> BUFFER_FlushAllAndCloseWithCode
  -> ESQ_ShutdownAndReturn
       -> GROUP_MAIN_A_JMPTBL_MEMLIST_FreeAll
            -> MEMLIST_FreeAll
       -> _LVOCloseLibrary
       -> GROUP_MAIN_A_JMPTBL_UNKNOWN2B_Stub1
            -> UNKNOWN2B_Stub1
       -> _LVOReplyMsg (WB path)
```

## Key Function Nodes And Edges

### `ESQ_StartupEntry`
File: `src/modules/groups/_main/a/a.s`
- Startup responsibilities confirmed:
  - clears large scratch region
  - opens `dos.library`
  - branches CLI vs Workbench message startup
  - delegates runtime init to `ESQ_ParseCommandLineAndRun`
  - centralizes cleanup through `ESQ_ShutdownAndReturn`
- `UNKNOWN2B_Stub0/1` are currently true no-op stubs.

### `ESQ_ParseCommandLineAndRun`
File: `src/modules/submodules/unknown29.s`
- High-confidence responsibilities:
  - tokenizes command line (quoted and unquoted)
  - populates argc/argv globals
  - initializes handle entries (`Global_HandleEntry0/1/2_*`)
  - installs abort callback (`UNKNOWN36_ShowAbortRequester`)
  - enters main startup via `ESQ_MainInitAndRun`
  - flush/close path via `BUFFER_FlushAllAndCloseWithCode`

### `ESQ_ShutdownAndReturn`
File: `src/modules/groups/_main/a/a.s`
- High-confidence responsibilities:
  - runs exit hook if present
  - frees tracked allocations (`MEMLIST_FreeAll`)
  - closes `dos.library`
  - replies WB startup message if present
  - restores saved stack/register context and returns exit code

### `MEMLIST_FreeAll`
File: `src/modules/submodules/unknown24.s`
- High-confidence responsibilities:
  - traverses tracked allocation list and frees each node
  - zeroes list head/tail globals

## `ESQ_MainInitAndRun` Phase Tree
File: `src/modules/groups/a/m/esq.s`

### Phase 1: process startup args / select code
- parse argv[1] into `ESQ_SelectCodeBuffer`
- compare against `"RAVESC"`
- set/clear `Global_WORD_SELECT_CODE_IS_RAVESC`

### Phase 2: base system/library bootstrap
- `_LVOExecute` nil assignment command
- open and store graphics/diskfont/dos/intuition (+utility/resource when applicable)
- hard-fail path uses `GROUP_AM_JMPTBL_BUFFER_FlushAllAndCloseWithCode`

### Phase 3: font + rastport/bitmap bootstrap
- `GROUP_AM_JMPTBL_OVERRIDE_INTUITION_FUNCS`
- open topaz/PrevueC/h26f/Prevue fonts with topaz fallback
- allocate/init rastports and bitmaps
- allocate highlight rasters via `ESQDISP_AllocateHighlightBitmaps` and `UNKNOWN2B_AllocRaster`

### Phase 4: diagnostics / capability checks
- format disk warning text (`GROUP_AM_JMPTBL_ESQ_FormatDiskErrorMessage`)
- check fast memory + video chip compatibility
- topaz guard path (`GROUP_AM_JMPTBL_ESQ_CheckTopazFontGuard`)

### Phase 5: message ports, serial, interrupts, io
- parse/update clock and banner buffers
- create message port + serial IO request
- open serial device / issue `DoIO`
- install interrupts (`RBF`, `AUD1`, `VERTB`)

#### Phase 5 Expanded (interrupt/device subtree)

```text
ESQ_MainInitAndRun
  -> GROUP_AM_JMPTBL_SIGNAL_CreateMsgPortWithSignal
       -> SIGNAL_CreateMsgPortWithSignal
  -> GROUP_AM_JMPTBL_STRUCT_AllocWithOwner
       -> STRUCT_AllocWithOwner
  -> _LVOOpenDevice (serial.device)
  -> _LVODoIO (initial serial request)
  -> SETUP_INTERRUPT_INTB_RBF
       -> ESQIFF_JMPTBL_MEMORY_AllocateMemory (22-byte Interrupt struct)
       -> ESQIFF_JMPTBL_MEMORY_AllocateMemory (64k receive buffer)
       -> _LVOSetIntVector (INTB_RBF -> ESQFUNC_JMPTBL_ESQ_HandleSerialRbfInterrupt)
  -> SETUP_INTERRUPT_INTB_AUD1
       -> ESQIFF_JMPTBL_MEMORY_AllocateMemory (22-byte Interrupt struct)
       -> _LVOSetIntVector (INTB_AUD1 -> ESQFUNC_JMPTBL_ESQ_PollCtrlInput)
  -> GROUP_AM_JMPTBL_ESQ_InitAudio1Dma
       -> ESQ_InitAudio1Dma
  -> GROUP_AM_JMPTBL_SCRIPT_InitCtrlContext
       -> SCRIPT_InitCtrlContext
            -> SCRIPT_SetCtrlContextMode
  -> GROUP_AM_JMPTBL_KYBD_InitializeInputDevices
       -> KYBD_InitializeInputDevices
            -> GROUP_AV_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths
                 -> DISKIO_ProbeDrivesAndAssignPaths
            -> GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal (x2)
                 -> SIGNAL_CreateMsgPortWithSignal
            -> GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq (x2)
                 -> ALLOCATE_AllocAndInitializeIOStdReq
            -> _LVOOpenDevice (input.device + console.device)
            -> _LVODoIO
            -> NEWGRID_JMPTBL_MEMORY_AllocateMemory (22-byte input buffer)
  -> ESQFUNC_AllocateLineTextBuffers
       -> ESQIFF_JMPTBL_MEMORY_AllocateMemory (20 x 60-byte line buffers)
  -> SETUP_INTERRUPT_INTB_VERTB
       -> ESQIFF_JMPTBL_MEMORY_AllocateMemory (22-byte Interrupt struct)
       -> _LVOAddIntVector (INTB_VERTB -> ESQFUNC_JMPTBL_ESQ_TickGlobalCounters)
```

#### Phase 5 naming confidence
- High:
  - `SIGNAL_CreateMsgPortWithSignal`
  - `STRUCT_AllocWithOwner`
  - `ESQ_InitAudio1Dma`
  - `SCRIPT_InitCtrlContext`
  - `KYBD_InitializeInputDevices`
  - `ALLOCATE_AllocAndInitializeIOStdReq`
- Medium:
  - `SETUP_INTERRUPT_INTB_RBF`, `SETUP_INTERRUPT_INTB_AUD1`, `SETUP_INTERRUPT_INTB_VERTB`
    - Semantics are clear (install vector + allocate interrupt struct), but naming convention still mixes setup target + hardware token.
  - `ESQFUNC_AllocateLineTextBuffers`
    - behavior is clear; ownership/lifetime semantics are inferred from sibling free path.

### Phase 6: subsystem init + data/config load
- initialize script/keyboard/text buffers/display systems
- load disk/config/INI/listing/ad/promo/availability data
- parse INI buffers via `GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch`

#### Phase 6 Expanded (data-load / INI subtree)

```text
ESQ_MainInitAndRun
  -> GROUP_AM_JMPTBL_DISKIO_LoadConfigFromDisk
       -> DISKIO_LoadConfigFromDisk
  -> ESQFUNC_UpdateRefreshModeState
       -> ESQSHARED4_ComputeBannerRowBlitGeometry
  -> ESQSHARED4_InitializeBannerCopperSystem
       -> ESQSHARED4_SnapshotDisplayBufferBases
       -> ESQSHARED4_ResetBannerColorSweepState
            -> ESQSHARED4_ResetBannerColorToStart
       -> ESQSHARED4_SetupBannerPlanePointerWords
            -> ESQSHARED4_SetBannerColorBaseAndLimit
  -> GROUP_AM_JMPTBL_TLIBA3_InitPatternTable
       -> TLIBA3_InitPatternTable
  -> ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths
       -> DISKIO_ProbeDrivesAndAssignPaths
  -> GROUP_AM_JMPTBL_SCRIPT_PrimeBannerTransitionFromHexCode
       -> SCRIPT_PrimeBannerTransitionFromHexCode
  -> GROUP_AM_JMPTBL_GCOMMAND_InitPresetDefaults
       -> GCOMMAND_InitPresetDefaults
  -> GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch
       -> PARSEINI_ParseIniBufferAndDispatch
  -> GROUP_AM_JMPTBL_GCOMMAND_ResetBannerFadeState
       -> GCOMMAND_ResetBannerFadeState
  -> DISKIO2_ReloadDataFilesAndRebuildIndex
       -> DISKIO2_LoadCurDayDataFile
       -> DISKIO2_LoadNxtDayDataFile
       -> DISKIO2_LoadOinfoDataFile
       -> GROUP_AH_JMPTBL_NEWGRID_RebuildIndexCache
            -> NEWGRID_RebuildIndexCache
  -> GROUP_AM_JMPTBL_DISKIO2_ParseIniFileFromDisk
       -> DISKIO2_ParseIniFileFromDisk
  -> GROUP_AM_JMPTBL_TEXTDISP_LoadSourceConfig
       -> TEXTDISP_LoadSourceConfig
  -> GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch (default/brush/banner INI passes)
       -> PARSEINI_ParseIniBufferAndDispatch
  -> ESQIFF_JMPTBL_BRUSH_PopulateBrushList / SelectBrushByLabel / FindBrushByPredicate / FindType3Brush
  -> ESQFUNC_RebuildPwBrushListFromTagTable
  -> GROUP_AM_JMPTBL_FLIB2_ResetAndLoadListingTemplates
       -> FLIB2_ResetAndLoadListingTemplates
  -> GROUP_AM_JMPTBL_LADFUNC_LoadTextAdsFromFile
       -> LADFUNC_LoadTextAdsFromFile
  -> ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState
       -> LADFUNC_UpdateHighlightState
  -> ESQDISP_UpdateStatusMaskAndRefresh
  -> GROUP_AM_JMPTBL_P_TYPE_ResetListsAndLoadPromoIds
       -> P_TYPE_ResetListsAndLoadPromoIds
  -> GROUP_AM_JMPTBL_LOCAVAIL_ResetFilterStateStruct (primary + secondary)
       -> LOCAVAIL_ResetFilterStateStruct
  -> GROUP_AM_JMPTBL_LOCAVAIL_LoadAvailabilityDataFile
       -> LOCAVAIL_LoadAvailabilityDataFile
  -> DST_LoadBannerPairFromFiles
       -> DST_RebuildBannerPair
       -> DISKIO_LoadFileToWorkBuffer
       -> DATETIME_ParseString / DATETIME_CopyPairAndRecalc
       -> DST_UpdateBannerQueue
  -> ESQFUNC_UpdateDiskWarningAndRefreshTick
       -> ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths
            -> DISKIO_ProbeDrivesAndAssignPaths
       -> ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines
```

#### Phase 6 naming confidence
- High:
  - `DISKIO2_ReloadDataFilesAndRebuildIndex`
  - `ESQSHARED4_InitializeBannerCopperSystem`
  - `ESQFUNC_UpdateDiskWarningAndRefreshTick`
  - `DST_LoadBannerPairFromFiles`
- Medium:
  - `ESQFUNC_UpdateRefreshModeState`
    - behavior is clear (mode/refresh state + geometry recompute gate), but exact state semantics still partially inferred from globals.

### Phase 7: startup rendering + steady-state entry
- palette/copper transitions
- startup splash text render calls
- brush list/tag setup
- final refresh/status update
- enters service loop and eventual `GROUP_AM_JMPTBL_CLEANUP_ShutdownSystem`

#### Phase 7 Expanded (startup-render / copper subtree)

```text
ESQ_MainInitAndRun
  -> ESQIFF_RestoreBasePaletteTriples
       -> (byte copy loop from DATA_ESQFUNC_CONST_LONG_1ECC into WDISP_PaletteTriplesRBase)
  -> ESQIFF_RunCopperDropTransition
       -> ESQIFF_RunPendingCopperAnimations
  -> _LVOSetAPen / _LVORectFill / _LVOSetBPen / _LVOSetDrMd
       (startup background clears and pen setup)
  -> ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines (multiple startup/status lines)
       -> TLIBA3_DrawCenteredWrappedTextLines
  -> GROUP_AM_JMPTBL_WDISP_SPrintf
       -> WDISP_SPrintf
  -> (compat warning path)
       -> ESQIFF_RunCopperRiseTransition
            -> ESQIFF_RunPendingCopperAnimations
       -> compat_halt_loop (terminal wait loop)
  -> (normal startup path)
       -> ESQIFF_RunCopperRiseTransition
            -> ESQIFF_RunPendingCopperAnimations
       -> ESQDISP_UpdateStatusMaskAndRefresh
            -> ESQDISP_ApplyStatusMaskToIndicators
  -> GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight
       -> ESQ_SetCopperEffect_OffDisableHighlight
            -> ESQ_SetCopperEffectParams
            -> GCOMMAND_DisableHighlight
  -> (RAVESC-only branch)
       -> GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight
            -> ESQ_SetCopperEffect_OnEnableHighlight
                 -> ESQ_SetCopperEffectParams
                 -> GCOMMAND_EnableHighlight
  -> main idle loop
       -> ESQFUNC_ServiceUiTickIfRunning
       -> ESQFUNC_JMPTBL_PARSEINI_MonitorClockChange
       -> ESQPARS_ConsumeRbfByteAndDispatchCommand (gated)
  -> GROUP_AM_JMPTBL_CLEANUP_ShutdownSystem
       -> CLEANUP_ShutdownSystem
```

#### Phase 7 naming confidence
- High:
  - `ESQIFF_RestoreBasePaletteTriples`
  - `ESQIFF_RunCopperDropTransition`
  - `ESQIFF_RunCopperRiseTransition`
  - `ESQ_SetCopperEffect_OffDisableHighlight`
  - `ESQ_SetCopperEffect_OnEnableHighlight`
- Medium:
  - `ESQDISP_UpdateStatusMaskAndRefresh`
    - behavior is clear (apply/clear mask bits then refresh indicators on change), but exact status-bit ownership per subsystem is still distributed.

### Phase 8: main idle/parser deep branch
- expands the long-lived loop reached at `src/modules/groups/a/m/esq.s:1272`
- captures both UI service and serial parser fan-out without flattening every leaf

#### Phase 8 Expanded (idle loop deep subtree)

```text
ESQ_MainInitAndRun
  -> main_idle_loop
       -> ESQFUNC_ServiceUiTickIfRunning
            -> (if DATA_ESQ_BSS_WORD_1DE5 != 0) ESQFUNC_ProcessUiFrameTick
                 -> (optional) ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths
                 -> (optional) ESQDISP_PollInputModeAndRefreshSelection
                 -> (if not UI busy) ESQDISP_ProcessGridMessagesIfIdle
                      -> ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages
                 -> ED_DispatchEscMenuState
                 -> (if not UI busy) ESQFUNC_JMPTBL_SCRIPT_HandleSerialCtrlCmd
                      -> SCRIPT_HandleSerialCtrlCmd
                 -> (if CLEANUP_PendingAlertFlag) ESQFUNC_JMPTBL_CLEANUP_ProcessAlerts
                      -> CLEANUP_ProcessAlerts
                 -> (if pending secondary commit) ESQFUNC_CommitSecondaryStateAndPersist
                 -> (iff task done paths)
                      -> ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh
                      -> ESQIFF_PlayNextExternalAssetFrame
                 -> (brush/source maintenance)
                      -> ESQIFF_QueueIffBrushLoad
                      -> ESQIFF_ServiceExternalAssetSourceState
                 -> ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState
                      -> TEXTDISP_TickDisplayState
                 -> (dirty-flag gated) ESQDISP_RefreshStatusIndicatorsFromCurrentMask
            -> (tail helper calls in same local subroutine chunk)
                 -> ESQDISP_ProcessGridMessagesIfIdle
                 -> (if CLEANUP_PendingAlertFlag) ESQFUNC_JMPTBL_CLEANUP_ProcessAlerts
                 -> ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState
       -> ESQFUNC_JMPTBL_PARSEINI_MonitorClockChange
            -> PARSEINI_MonitorClockChange
                 -> SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh (state-change toggles)
       -> (if clock changed and exit flag clear) ESQPARS_ConsumeRbfByteAndDispatchCommand
            -> ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte
            -> preamble state machine ('U', 0xAA sync -> command-armed)
            -> command dispatch table (selected families):
                 -> '!'  : title/slot update path
                      -> ESQIFF2_ReadRbfBytesWithXor / ESQIFF2_ReadRbfBytesToBuffer
                      -> ESQDISP_GetEntryPointerByMode / ESQDISP_GetEntryAuxPointerByMode
                      -> ESQPARS_ReplaceOwnedString
                 -> 'P'/'p': compact/sparse listing payload decode
                      -> ESQSHARED_ParseCompactEntryRecord
                      -> ESQSHARED_JMPTBL_ESQ_ReverseBitsIn6Bytes
                      -> ESQSHARED_JMPTBL_ESQ_TestBit1Based
                 -> 'C'/'c'/'j'/'v': grouped listing/info decoders
                      -> ESQIFF2_ParseGroupRecordAndRefresh
                      -> ESQIFF2_ParseLineHeadTailRecord
                      -> ESQPARS_JMPTBL_CLEANUP_ParseAlignedListingBlock
                      -> ESQDISP_ParseProgramInfoCommandRecord
                 -> 'F'/'f'/'K'/'O'/'R'/'%': status/rtc/config/reset handlers
                      -> ESQIFF2_ApplyIncomingStatusPacket
                      -> ESQPARS_ApplyRtcBytesAndPersist
                      -> ESQPARS_JMPTBL_DISKIO_ParseConfigBuffer
                      -> ESQPARS_JMPTBL_DISKIO_SaveConfigToFileHandle
                      -> ESQIFF2_ShowVersionMismatchOverlay
                 -> 'g': filter/banner/options/string/ppv multiplexer
                      -> LOCAVAIL_ParseFilterStateFromBuffer
                      -> ESQPARS_JMPTBL_DST_HandleBannerCommand32_33
                      -> ESQPARS_JMPTBL_P_TYPE_ParseAndStoreTypeRecord
                      -> GCOMMAND_ParseCommandOptions / GCOMMAND_ParseCommandString / GCOMMAND_ParsePPVCommand
                 -> 'x': ESQPARS_JMPTBL_PARSEINI_HandleFontCommand
                 -> 'W'/'w': verify-record / verify-list helper wrappers
            -> command epilogue
                 -> clear ESQPARS_Preamble55SeenFlag + ESQPARS_CommandPreambleArmedFlag
  -> (exit flag set) GROUP_AM_JMPTBL_CLEANUP_ShutdownSystem
       -> CLEANUP_ShutdownSystem
```

#### Phase 8A Expanded (`ESQFUNC_ProcessUiFrameTick` inner fan-out)

```text
ESQFUNC_ProcessUiFrameTick
  -> (if DATA_GCOMMAND_CONST_WORD_1FB0 != 0) ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths
       -> DISKIO_ProbeDrivesAndAssignPaths
  -> (if DATA_ESQDISP_BSS_LONG_1E84 == 1) ESQDISP_PollInputModeAndRefreshSelection
  -> (if not Global_UIBusyFlag) ESQDISP_ProcessGridMessagesIfIdle
       -> ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages
            -> NEWGRID_ProcessGridMessages
  -> ED_DispatchEscMenuState
  -> (if not Global_UIBusyFlag) ESQFUNC_JMPTBL_SCRIPT_HandleSerialCtrlCmd
       -> SCRIPT_HandleSerialCtrlCmd
  -> (if CLEANUP_PendingAlertFlag) ESQFUNC_JMPTBL_CLEANUP_ProcessAlerts
       -> CLEANUP_ProcessAlerts
  -> (if DATA_ESQDISP_BSS_LONG_1E88 != 0) ESQFUNC_CommitSecondaryStateAndPersist
  -> (if CTASKS_IffTaskDoneFlag and bit gates pass)
       -> ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh
            -> TEXTDISP_ResetSelectionAndRefresh
       -> ESQIFF_PlayNextExternalAssetFrame
  -> (asset source maintenance)
       -> ESQIFF_QueueIffBrushLoad
       -> ESQIFF_ServiceExternalAssetSourceState (mode 0/1 variant)
  -> ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState
       -> TEXTDISP_TickDisplayState
  -> (if DATA_ESQDISP_BSS_WORD_1E89 and !DATA_GCOMMAND_BSS_WORD_1FA9)
       -> ESQDISP_RefreshStatusIndicatorsFromCurrentMask
```

#### Phase 8B Expanded (`SCRIPT_HandleSerialCtrlCmd` branch)

```text
SCRIPT_HandleSerialCtrlCmd
  -> PARSEINI_CheckCtrlHChange (poll gate)
  -> SCRIPT_ESQ_CaptureCtrlBit4StreamBufferByte (read next CTRL byte)
  -> parser state machine:
       -> state 0 (idle): switch/jumptable on command byte 1..22
            -> start packet path:
                 -> write first byte to SCRIPT_CTRL_CMD_BUFFER
                 -> init SCRIPT_CTRL_CHECKSUM / SCRIPT_CTRL_STATE
            -> gated-start paths (require !Global_WORD_SELECT_CODE_IS_RAVESC)
            -> state-enter path: SCRIPT_CTRL_STATE := 3
       -> state 1 (collect body):
            -> append bytes into SCRIPT_CTRL_CMD_BUFFER
            -> XOR into SCRIPT_CTRL_CHECKSUM
            -> transition to state 2 at CR (0x0D)
       -> state 2 (expect checksum):
            -> verify checksum
            -> on success:
                 -> (RAVESC mode) SCRIPT_HandleBrushCommand
                      -> SCRIPT_ApplyPendingBannerTarget
                      -> ESQ_SetCopperEffect_OnEnableHighlight
                      -> TEXTDISP_SetRastForMode
                 -> (normal mode)
                      -> SCRIPT_HandleBrushCommand (immediate or deferred)
                      -> SCRIPT_ProcessCtrlContextPlaybackTick
            -> on mismatch:
                 -> ESQDISP_UpdateStatusMaskAndRefresh(mask=32,set=1)
       -> state 3: clear state
       -> invalid state: reset parser globals
  -> overflow guard:
       -> if SCRIPT_CTRL_READ_INDEX > 198 then reset parser and optionally
          TEXTDISP_ResetSelectionAndRefresh (runtime-mode dependent)
```

#### Phase 8C Expanded (`SCRIPT_HandleBrushCommand` sub-dispatch)

```text
SCRIPT_HandleBrushCommand
  -> SCRIPT_LoadCtrlContextSnapshot
  -> switch/jumptable on first command byte (22-entry command family):
       -> select primary/secondary brush by tags and list scan
       -> set channel codes / toggle primary-search preference
       -> parse/apply RTC payload (YYYYMMDDHHMM -> ESQPARS_ApplyRtcBytesAndPersist)
       -> select playback mode/cursor from filter/runtime gates
       -> subcommand dispatcher:
            -> search/wildcard cursor selection
            -> channel-range update (TEXTDISP_UpdateChannelRangeFlags)
            -> pending-banner hex parse + speed decode
            -> command text replacement (ESQPARS_ReplaceOwnedString)
            -> filter mode update (LOCAVAIL_SetFilterModeAndResetState)
            -> runtime-mode gating with char normalization and CIA test
       -> split search buffer helper path
       -> no-op families
  -> SCRIPT_SaveCtrlContextSnapshot
  -> (if cursor active) TEXTDISP_HandleScriptCommand
```

#### Phase 8D Expanded (`ESQPARS_ConsumeRbfByteAndDispatchCommand` dispatch matrix)

```text
ESQPARS_ConsumeRbfByteAndDispatchCommand
  -> preamble sync:
       -> 0x55 arm stage-1, 0xAA promotes to command-armed
  -> command dispatch (armed + select-code gate):
       -> '!'  title-slot update stream
            -> ESQIFF2_ReadRbfBytesWithXor / ReadSerialBytesToBuffer
            -> ESQDISP_GetEntryPointerByMode / GetEntryAuxPointerByMode
            -> ESQPARS_ReplaceOwnedString
       -> 'P'  compact-entry record
            -> ESQSHARED_ParseCompactEntryRecord
       -> 'p'  sparse bitmap + payload entry patch
            -> ESQSHARED_JMPTBL_ESQ_ReverseBitsIn6Bytes
            -> ESQSHARED_JMPTBL_ESQ_TestBit1Based
            -> ESQIFF_JMPTBL_MATH_Mulu32
       -> 'C'/'c'/'j'/'v'
            -> ESQIFF2_ParseGroupRecordAndRefresh
            -> ESQDISP_ParseProgramInfoCommandRecord
            -> ESQIFF2_ParseLineHeadTailRecord
            -> CLEANUP_ParseAlignedListingBlock
       -> 'F'/'f'/'K'/'O'/'R'/'%'
            -> ESQIFF2_ApplyIncomingStatusPacket
            -> ESQPARS_ApplyRtcBytesAndPersist
            -> DISKIO_ParseConfigBuffer / SaveConfigToFileHandle
            -> ESQIFF2_ShowVersionMismatchOverlay
       -> 'g' sub-multiplexer
            -> type1: LOCAVAIL_ParseFilterStateFromBuffer (primary/secondary)
            -> type2/3: DST_HandleBannerCommand32_33
            -> type5: P_TYPE_ParseAndStoreTypeRecord
            -> type6: GCOMMAND_ParseCommandOptions
            -> type7: GCOMMAND_ParseCommandString
            -> type8: GCOMMAND_ParsePPVCommand
       -> 'x'  PARSEINI_HandleFontCommand
       -> 'W'/'w' verify checksum wrappers
  -> epilogue:
       -> clear ESQPARS_Preamble55SeenFlag + ESQPARS_CommandPreambleArmedFlag
```

#### Phase 8E Expanded (`SCRIPT_ProcessCtrlContextPlaybackTick` + cursor dispatch)

```text
SCRIPT_ProcessCtrlContextPlaybackTick
  -> LOCAVAIL_UpdateFilterStateMachine
  -> SCRIPT_LoadCtrlContextSnapshot
  -> (pending mode latch) force SCRIPT_RuntimeMode := 3
  -> runtime/cursor gate:
       -> SCRIPT_UpdateRuntimeModeForPlaybackCursor
       -> SCRIPT_ApplyPendingBannerTarget (except cursor==1 fast path)
       -> SCRIPT_DispatchPlaybackCursorCommand(&SCRIPT_PlaybackCursor)

SCRIPT_DispatchPlaybackCursorCommand (cursor 1..15 switch)
  -> 1: TEXTDISP_ResetSelectionAndRefresh
  -> 2: enter mode/rast + serial shadow (mode-dependent value)
  -> 3: enter mode/rast + fixed shadow 1
  -> 4: deferred mode path (TEXTDISP_DeferredActionCountdown := 3, armed := 1)
  -> 5: CLEANUP_RenderAlignedStatusScreen(current)
  -> 6: CLEANUP_RenderAlignedStatusScreen(primary)
  -> 7: CLEANUP_RenderAlignedStatusScreen(secondary)
  -> 8: WDISP_HandleWeatherStatusCommand(DATA_SCRIPT_STR_X_2126)
  -> 9: TEXTDISP_HandleScriptCommand(DATA_SCRIPT_BSS_BYTE_2127, DATA_SCRIPT_BSS_WORD_2128, SCRIPT_CommandTextPtr)
  -> 10: SCRIPT_AssertCtrlLineNow + SCRIPT_RuntimeMode := 1
  -> 11: enable highlight/rast and queue banner target (hex+28)
  -> 12: queue banner target (current hex)
  -> 13: ESQ_SetCopperEffect_Custom
  -> 14: set ESQPARS2_ReadModeFlags=256 (read-mode on)
  -> 15: clear read-mode flags
  -> default: increment fallback counter DATA_SCRIPT_BSS_WORD_211C
  -> common tail: SCRIPT_ClearSearchTextsAndChannels + clear cursor slot
```

#### Phase 8F Expanded (`TEXTDISP_HandleScriptCommand` downstream fan-out)

```text
TEXTDISP_HandleScriptCommand
  -> opcode split by modeChar:
       -> 'C' path:
            -> TEXTDISP_SelectGroupAndEntry
            -> TEXTDISP_BuildNowShowingStatusLine
            -> SCRIPT_ResetBannerCharDefaults
       -> 'J' path:
            -> TEXTDISP_BuildEntryPairStatusLine
       -> source-config path:
            -> lazy allocate SourceCfg block (MEMORY_AllocateMemory)
            -> TEXTDISP_SetEntryTextFields
            -> TEXTDISP_FilterAndSelectEntry (mode 70 then 88)
            -> TEXTDISP_DrawHighlightFrame
            -> cleanup free path (MEMORY_DeallocateMemory)
  -> finalize defaults:
       -> DATA_SCRIPT_CONST_WORD_2149 := -1
       -> DATA_SCRIPT_CONST_BYTE_214A := 0x31
```

#### Phase 8G Expanded (`CLEANUP_ProcessAlerts` + clock event map)

```text
CLEANUP_ProcessAlerts
  -> one-shot gate:
       -> requires CLEANUP_PendingAlertFlag and !CLEANUP_AlertProcessingFlag
  -> state/cooldown maintenance:
       -> optional diagnostics redraw when cooldown expires
       -> LOCAVAIL_FilterStep progression (2 -> 3 -> 4)
       -> optional TEXTDISP_ResetSelectionAndRefresh on transition to state 4
  -> clock tick/event sampling:
       -> ESQ_TickClockAndFlagEvents(&CLOCK_DaySlotIndex)      ; returns D7 event
       -> ESQ_TickClockAndFlagEvents(&CLOCK_CurrentDayOfWeekIndex)
  -> control-line/banner queue maintenance:
       -> SCRIPT_ClearCtrlLineIfEnabled / SCRIPT_PollHandshakeAndApplyTimeout
       -> DST_UpdateBannerQueue + ESQDISP_DrawStatusBanner
  -> brush alert overlays:
       -> BRUSH_PendingAlertCode 1/2/3 -> attention overlays 3/4/5
  -> event-conditioned updates (from D7):
       -> D7==2 with Y-gate: force status banner redraw pulse
       -> D7==2 or D7==5: PARSEINI_UpdateClockFromRtc + DST_RefreshBannerBuffer + redraw
       -> D7==3 with Y-gate: initialize rolling banner-char range
       -> D7==4 with Y-gate: advance rolling banner-char range
       -> D7==2: optionally clear BRUSH_PendingAlertCode on half-hour parity
  -> final draw/update:
       -> CLEANUP_DrawGridTimeBanner or CLEANUP_DrawClockBanner (UI busy gate)
       -> SCRIPT_UpdateCtrlStateMachine
       -> optional ESQFUNC_DrawEscMenuVersion / ESQFUNC_DrawMemoryStatusScreen

ESQ_TickClockAndFlagEvents (event code summary)
  -> 0: no boundary event
  -> 1: second->minute carry path entered
  -> 2: half-hour / minute==30 or hour rollover event
  -> 3: configured minute trigger set A (DATA_COMMON_BSS_WORD_1B09/1B0A)
  -> 4: minute==20 or minute==50
  -> 5: configured minute trigger set B (DATA_COMMON_BSS_WORD_1B0B/1B0C)
```

#### Phase 8H Expanded (`TEXTDISP_FilterAndSelectEntry` leaf walk)

```text
TEXTDISP_FilterAndSelectEntry
  -> filter mode dispatch:
       -> 'F' path:
            -> set TEXTDISP_FilterModeId := 1
            -> wildcard probes for PPV/SBE/SPORTS tags
            -> populate DATA_WDISP_BSS_WORD_235B/235C feature gates
       -> default path:
            -> TEXTDISP_FilterModeId := 3
  -> candidate discovery (per mode):
       -> TEXTDISP_GetGroupEntryCount(mode)
       -> for each entry index:
            -> ESQDISP_GetEntryPointerByMode
            -> flag gates (bit tests on entry flags)
            -> optional TEXTDISP_ShouldOpenEditorForEntry gate
            -> wildcard title match
            -> append to TEXTDISP_CandidateIndexList
  -> cursor/channel search:
       -> ESQDISP_GetEntryAuxPointerByMode
       -> optional time-window check via COI_TestEntryWithinTimeWindow
       -> TEXTDISP_SkipControlCodes
       -> case-insensitive compare against requested title
       -> eligibility bit test via TLIBA2_JMPTBL_ESQ_TestBit1Based
  -> on match:
       -> TEXTDISP_SetSelectionFields
       -> TEXTDISP_BuildEntryDetailLine
  -> on miss:
       -> rotate DATA_WDISP_BSS_WORD_2359 (channel cursor)
       -> cycle TEXTDISP_FilterModeId 1->2->3
       -> fallback TEXTDISP_ResetSelectionState
```

#### Phase 8I Expanded (serial command family leaf handlers)

```text
ESQPARS_ConsumeRbfByteAndDispatchCommand
  -> 'C' family leaves:
       -> ESQIFF2_ParseGroupRecordAndRefresh
            -> ESQIFF2_ValidateFieldIndexAndLength
            -> ESQSHARED_CreateGroupEntryAndTitle
            -> ESQPARS_RemoveGroupEntryAndReleaseStrings (checksum/length changed)
            -> ESQIFF2_PadEntriesToMaxTitleWidth
            -> ESQPARS_JMPTBL_TEXTDISP_ApplySourceConfigAllEntries
            -> ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache
       -> ESQDISP_ParseProgramInfoCommandRecord
            -> ESQDISP_FillProgramInfoHeaderFields
            -> ESQFUNC_JMPTBL_STRING_CopyPadNul / LADFUNC_ParseHexDigit / MATH_Mulu32
       -> ESQIFF2_ParseLineHeadTailRecord
            -> ESQIFF2_ClearLineHeadTailByMode
            -> ESQPARS_ReplaceOwnedString
  -> 'P'/'p' leaves:
       -> ESQSHARED_ParseCompactEntryRecord
            -> ESQSHARED_UpdateMatchingEntriesByTitle
       -> sparse path helpers:
            -> ESQSHARED_JMPTBL_ESQ_ReverseBitsIn6Bytes
            -> ESQSHARED_JMPTBL_ESQ_TestBit1Based
            -> ESQIFF_JMPTBL_MATH_Mulu32
  -> 'g' leaves:
       -> LOCAVAIL_ParseFilterStateFromBuffer
            -> LOCAVAIL_ResetFilterStateStruct / CopyFilterStateStructRetainRefs
            -> LOCAVAIL_AllocNodeArraysForState / LOCAVAIL_FreeResourceChain
            -> NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt
       -> DST_HandleBannerCommand32_33
            -> DATETIME_ParseString / DATETIME_CopyPairAndRecalc / DST_UpdateBannerQueue
       -> P_TYPE_ParseAndStoreTypeRecord
            -> P_TYPE_FreeEntry / P_TYPE_AllocateEntry
       -> GCOMMAND_ParseCommandOptions / ParseCommandString / ParsePPVCommand
            -> defaults loaders (FLIB2_*), numeric option parsing, template pointer updates
  -> shared serial read helpers:
       -> ESQIFF2_ReadSerialRecordIntoBuffer
       -> ESQIFF2_ReadRbfBytesWithXor
```

#### Phase 8J Expanded (`GCOMMAND_Parse*` option parser leaf maps)

```text
GCOMMAND_ParseCommandOptions (Digital Niche)
  -> FLIB2_LoadDigitalNicheDefaults
  -> option byte decode pipeline:
       -> Opt0: Y/N enable flag
       -> Opt1..Opt6: pen/layout/workflow/mode-cycle fields
       -> hex-digit validated pen fields via LADFUNC_ParseHexDigit
  -> tail handling:
       -> append remaining command substring to GCOMMAND_DigitalNicheListingsTemplatePtr

GCOMMAND_ParseCommandString (Digital Mplex)
  -> FLIB2_LoadDigitalMplexDefaults
  -> Opt0..Opt12 decode:
       -> enable/mode-cycle/search-limit/clock-offset/text+frame pens
       -> editor/detail pens and workflow/detail-layout flags
  -> split-marker handling (0x12):
       -> append tail and split parts to GCOMMAND_MplexAtTemplatePtr / GCOMMAND_MplexListingsTemplatePtr

GCOMMAND_ParsePPVCommand (Digital PPV)
  -> FLIB2_LoadDigitalPpvDefaults
  -> Opt0..Opt13 decode:
       -> enable/mode-cycle/window/tolerance
       -> message/editor/showtimes pen and workflow/detail flags
       -> row-span numeric option
  -> tail handling:
       -> append tail/split parts to GCOMMAND_PPVPeriodTemplatePtr / GCOMMAND_PPVListingsTemplatePtr
       -> reload template path via GCOMMAND_LoadPPVTemplate
```

#### Phase 8K Expanded (`PARSEINI_HandleFontCommand` command dispatch)

```text
PARSEINI_HandleFontCommand
  -> preamble gate:
       -> requires command prefix bytes '3','2'|'3'|'4'
  -> '32' subcommand:
       -> execute DOS command string via _LVOExecute
  -> '33' subcommand families:
       -> ED wait/clear bit gates (bit0/bit1)
       -> optional PARSEINI_ScanLogoDirectory
       -> rebuild brush list from tags
       -> font setters (h26f/PrevueC/Prevue) via PARSEINI_TestMemoryAndOpenTopazFont
       -> parse INI loads:
            -> DISKIO2_ParseIniFileFromDisk
            -> ParseIniBufferAndDispatch for gradient/banner/default/sourcecfg
            -> banner path includes brush-list free + queue load
       -> hotkey/brush reload helper paths
       -> sourcecfg post-pass: TEXTDISP_ApplySourceConfigAllEntries
  -> '34' subcommands:
       -> enter/exit ESC menu
       -> draw diagnostics screen
       -> draw ESC menu version
```

#### Phase 8L Expanded (`PARSEINI_ScanLogoDirectory` leaf)

```text
PARSEINI_ScanLogoDirectory
  -> initialize two 100-entry pointer arrays (primary/secondary)
  -> execute directory listing command via _LVOExecute
  -> open list files (df0:logo.lst + ram:logodir.txt variants)
  -> for each readable line:
       -> STREAM_ReadLineWithLimit
       -> sanitize CR/LF/comma delimiters
       -> allocate storage via SCRIPT_JMPTBL_MEMORY_AllocateMemory
       -> split path/name via GCOMMAND_FindPathSeparator
       -> store pointers in table slots
  -> maintains separate list heads/counts for two sources
  -> returns with populated pointer arrays for downstream brush/logo loading
```

#### Phase 8M Expanded (`LOCAVAIL_ParseFilterStateFromBuffer` leaf)

```text
LOCAVAIL_ParseFilterStateFromBuffer
  -> reset local working state struct
  -> parse header/tag bytes and FV selector gate
  -> parse node-count numeric field
  -> allocate node arrays for parsed count
  -> node loop:
       -> parse per-node numbers via ReadSignedLong
       -> allocate per-node buffers
       -> map node fields into state arrays (index-scaled writes)
  -> copy/retain refs into destination filter state
  -> on failure:
       -> free resource chains and leave destination unchanged
```

#### Phase 8N Expanded (`ESQIFF2_ParseGroupRecordAndRefresh` field-state machine)

```text
ESQIFF2_ParseGroupRecordAndRefresh
  -> pre-check:
       -> compare group code (primary/secondary)
       -> skip rebuild when record length+checksum unchanged
       -> on change: clear old group entries (RemoveGroupEntryAndReleaseStrings)
  -> field parser loop (record byte stream):
       -> control byte dispatch:
            -> 0x01: finalize current field0 text chunk / maybe emit entry
            -> 0x11: terminate field0 chunk and set parse state D4=1
            -> 0x12: terminate field0 chunk and load 6-byte field2 table
            -> 0x13: terminate field0 chunk, set parse state D4=3 (field3 mode)
            -> default: append byte into ESQIFF_ParseField0Buffer slot by (D4,D5)
       -> all transitions guarded by ESQIFF2_ValidateFieldIndexAndLength
  -> entry emit points:
       -> ESQSHARED_CreateGroupEntryAndTitle(groupCode, field1, field0..field3 buffers)
       -> ESQIFF2_PadEntriesToMaxTitleWidth(groupCode)
       -> TEXTDISP_ApplySourceConfigAllEntries
       -> NEWGRID_RebuildIndexCache
```

#### Phase 8O Expanded (`SCRIPT_HandleBrushCommand` subcommand outcomes)

```text
SCRIPT_HandleBrushCommand
  -> top-level 22-way command family sets:
       -> selection/tag resolution family:
            -> choose BRUSH_ScriptPrimarySelection / BRUSH_ScriptSecondarySelection
       -> channel/search families:
            -> set TEXTDISP_PrimaryChannelCode / SecondaryChannelCode
            -> toggle SCRIPT_PrimarySearchFirstFlag
            -> split/normalize search text buffer
       -> playback cursor selector families:
            -> cursor 1/2/3/4/5/6/7/8/9/10/13/14/15 outcomes
            -> wildcard/select helpers via SCRIPT_SelectPlaybackCursorFromSearchText
       -> banner-target family:
            -> parse hex target + optional speed into SCRIPT_PendingBannerTargetChar and DATA_SCRIPT_BSS_WORD_211F
       -> filter/runtime family:
            -> LOCAVAIL_SetFilterModeAndResetState / ComputeFilterOffsetForEntry
            -> runtime mode gating with ED_DiagVinModeChar normalization and CIA bit tests
       -> RTC apply family:
            -> parse YYYYMMDDHHMM payload -> ESQPARS_ApplyRtcBytesAndPersist
  -> finalization:
       -> SCRIPT_SaveCtrlContextSnapshot
       -> optional TEXTDISP_HandleScriptCommand dispatch when cursor set
```

#### Phase 8P Expanded (`SCRIPT_HandleBrushCommand` subcode-byte map)

```text
SCRIPT_HandleBrushCommand
  -> command family 0 (`.brush_cmd_case_dispatch_subcommand`) subcode from `1(A2)`:
       -> `'1'`:
            -> SCRIPT_SelectPlaybackCursorFromSearchText(primary path flag=0)
       -> `'3'`:
            -> reset TEXTDISP_CurrentMatchIndex=-1
            -> if DATA_ESQ_STR_N_1DCE == 'Y': cursor=1 else cursor=2
       -> `'4'` or `'6'`:
            -> TEXTDISP_FindEntryIndexByWildcard(2+ payload)
            -> found => cursor=3, not found => cursor=1 and return status D6=0
       -> `'5'`:
            -> parse 2 hex digits into SCRIPT_PendingBannerTargetChar
            -> optional 2 decimal speed digits -> DATA_SCRIPT_BSS_WORD_211F (default 1000)
            -> trailing filter text empty => cursor=2
            -> trailing text present:
                 -> if RAVESC mode / MSN override / wildcard hit => cursor=3
                 -> else cursor=1 + clear pending banner target
       -> `'7'`:
            -> requires DATA_WDISP_BSS_LONG_2357 active and non-'0' digit
            -> resolves current match index fallback from CLEANUP_AlignedStatusMatchIndex
            -> TEXTDISP_UpdateChannelRangeFlags(), cursor=5
       -> `'8'`:
            -> SCRIPT_SelectPlaybackCursorFromSearchText(secondary path flag=1)
       -> `'D'`:
            -> reset match index and force cursor=1
       -> `'F'`:
            -> cursor=9, capture byte pair into DATA_SCRIPT_BSS_BYTE_2127/WORD_2128
            -> replace owned command tail string, set pending banner target=-2
       -> `'W'`:
            -> cursor=8, store payload byte in DATA_SCRIPT_STR_X_2126
       -> `'X'`:
            -> same cursor=9/banner-text setup as `'F'`
       -> default:
            -> no-op/finalize (status preserved)
  -> command family 21 (`.brush_cmd_case_filter_or_runtime_mode`):
       -> `'9'`: enable filter mode + parse/set primary filter state
       -> `'8'` when filter-mode already active: disable filter mode
       -> otherwise runtime gate:
            -> normalized ED_DiagVinModeChar + command digit checks (`Y0`, `L2`, `Y1`, `L3`)
            -> requires SCRIPT_ReadHandshakeBit5Mask pass to set cursor=10
            -> failing gates sets D6=0
```

#### Phase 8Q Expanded (`TEXTDISP_BuildEntryDetailLine` text pipeline)

```text
TEXTDISP_BuildEntryDetailLine
  -> validity gate:
       -> rejects/reset selection when mode/index fields are sentinel-invalid
  -> source acquisition:
       -> ESQDISP_GetEntryAuxPointerByMode(modeA,modeB)
       -> ESQDISP_GetEntryPointerByMode(modeA,modeB)
       -> TEXTDISP_BuildEntryShortName(entryPtr, scratch512)
  -> title prefix normalization:
       -> skip control bytes and 0x18/0x19 markers
       -> if visible text exists, prepend DATA_SCRIPT_STR_213E and append trimmed source text
  -> entry-string segment:
       -> select table slot 56(entryAux,index*4), skip control codes
       -> length-align against existing title width before copying
       -> format into scratch via WDISP_SPrintf("%s")
       -> find and mark sports delimiters (`" at "`, `" vs."`, `" vs "`) with 0x18 sentinels
       -> truncate at '(' and backtrack over class-3 separators
       -> append built segment onto destination buffer
  -> channel/time suffix:
       -> TEXTDISP_FormatEntryTimeForIndex(scratch, index, auxTable)
       -> skip control codes; if non-empty add DATA_SCRIPT_STR_2143 separator + suffix text
  -> program token extraction:
       -> copy non-space bytes from entry pointer +1 into scratch
       -> if non-empty append Global_STR_ALIGNED_CHANNEL_2 + token text
  -> final layout:
       -> TEXTDISP_TrimTextToPixelWidth(dest, 284px)
```

#### Phase 8R Expanded (`TEXTDISP_SelectGroupAndEntry` group fallback flow)

```text
TEXTDISP_SelectGroupAndEntry
  -> initialize:
       -> clear group result words (`2360/2361`) and local count marker (`236F`)
       -> set TEXTDISP_ActiveGroupId=1 (primary group first)
  -> pass 1 (group 1):
       -> TEXTDISP_BuildMatchIndexList(filter, entryIndex)
       -> if matches: TEXTDISP_SelectBestMatchFromList(...)
       -> store first candidate byte into DATA_WDISP_BSS_WORD_2360
  -> pass 2 (group 2 fallback):
       -> only when group1 had no usable selection and secondary group has records
       -> set TEXTDISP_ActiveGroupId=0
       -> repeat BuildMatchIndexList/SelectBestMatchFromList
       -> store first candidate byte into DATA_WDISP_BSS_WORD_2361
  -> final select:
       -> if no matches: restore ActiveGroupId=1 and return 0
       -> if selector returns mode=2:
            -> choose DATA_WDISP_BSS_BYTE_2372 when banner char == 'd'
            -> else choose DATA_WDISP_BSS_BYTE_2376
       -> else choose TEXTDISP_CandidateIndexList[0]
       -> write TEXTDISP_CurrentMatchIndex and return 1
```

#### Phase 8S Expanded (`TEXTDISP_BuildMatchIndexList` / `TEXTDISP_SelectBestMatchFromList`)

```text
TEXTDISP_BuildMatchIndexList
  -> prefilter mode flags:
       -> pattern `PPV*` / `SBE*` toggles DATA_WDISP_BSS_WORD_236F and include-mask behavior
       -> `SPORTS*` / `SPT*` mismatch forces wildcard `"*"`
       -> `FIND1` prefix sets DATA_WDISP_BSS_WORD_2370 and rewrites pattern to `"*"`
  -> group scan setup:
       -> selects primary vs secondary entry/title tables from TEXTDISP_ActiveGroupId
       -> loop count from group-specific entry count global
  -> per-entry gate chain:
       -> skip if hidden bit set (`BTST #3,27(A2)`)
       -> command `E` requires flag bit at `40(A2)`
       -> optional editor-only gate via TEXTDISP_ShouldOpenEditorForEntry
       -> fallback wildcard match against title string (A3)
  -> output:
       -> append passing entry index bytes into TEXTDISP_CandidateIndexList
       -> return match count in D0

TEXTDISP_SelectBestMatchFromList
  -> channel/day viability gate:
       -> validates input channel code ranges (`0..C` and `H..M` families)
       -> checks day-enable bitmask table (`Global_STR_TEXTDISP_C_3[channel][dow]`)
       -> invalid channel/day => early return error code 1
  -> per-candidate scoring loop:
       -> loads candidate index into TEXTDISP_CurrentMatchIndex
       -> TEXTDISP_FindEntryMatchIndex(mode=1/2/3 depending on branch)
       -> TEXTDISP_ComputeTimeOffset against primary/secondary title table
       -> tracks:
            -> best positive offset candidate (`2376/2378/2379`, selected banner char)
            -> best non-positive fallback (`2372/2374/2375`, fallback banner char)
  -> mode return behavior:
       -> returns 2 for resolved candidate flow (including find-mode short path)
       -> returns 0 when channel normalized/defaulted but otherwise acceptable
       -> returns 1 when channel/day gate fails or channel is forced default `D`
  -> side effects:
       -> bumps per-entry usage counter in title table when selected banner char != `'d'`
```

#### Phase 8T Expanded (`SCRIPT_SelectPlaybackCursorFromSearchText` / playback tick)

```text
SCRIPT_SelectPlaybackCursorFromSearchText
  -> setup:
       -> stores incoming match/index arg into DATA_WDISP_BSS_LONG_2350
       -> enables search-active latch DATA_WDISP_BSS_LONG_2357=1
       -> scans parse buffer for delimiter 0x12 up to offset 30, then NUL-splits
  -> selection order:
       -> if SCRIPT_PrimarySearchFirstFlag == 0:
            -> try secondary window first (tail after delimiter) via TEXTDISP_SelectGroupAndEntry
            -> success => cursor=7
       -> always try primary window next (`A3+2`) via TEXTDISP_SelectGroupAndEntry
            -> success => cursor=6
       -> if primary-first mode and primary miss:
            -> retry secondary window
            -> success => cursor=7
  -> fail path:
       -> clear status D6=0
       -> clear DATA_WDISP_BSS_LONG_2357
       -> force cursor=1
  -> return:
       -> D0 reflects D6 (1 success / 0 miss)

SCRIPT_ProcessCtrlContextPlaybackTick
  -> per-tick prologue:
       -> LOCAVAIL_UpdateFilterStateMachine(PrimaryFilterState)
       -> load/sync ctrl context snapshot
       -> apply deferred runtime latch DATA_SCRIPT_BSS_LONG_2125 -> runtime mode 3
  -> runtime/cursor gating:
       -> `MSN='M'` constrains low cursors (<10) to cursor=2
       -> runtime mode 2 + DATA_SCRIPT_BSS_WORD_211A latch suppresses high-cursor dispatch
       -> only cursors 1..15 are dispatchable
  -> dispatch path:
       -> SCRIPT_UpdateRuntimeModeForPlaybackCursor
       -> for cursor !=1, apply SCRIPT_ApplyPendingBannerTarget
       -> SCRIPT_DispatchPlaybackCursorCommand(&SCRIPT_PlaybackCursor)
  -> epilogue:
       -> mirror TEXTDISP_CurrentMatchIndex -> DATA_WDISP_BSS_WORD_236E
       -> save ctrl context snapshot
```

#### Phase 8U Expanded (`SCRIPT_SplitAndNormalizeSearchBuffer` / pending banner apply)

```text
SCRIPT_SplitAndNormalizeSearchBuffer
  -> delimiter strategy (byte 0x12):
       -> leading delimiter at parse[1] => secondary-only payload, clear primary
       -> trailing delimiter => primary-only payload, clear secondary
       -> mid delimiter (scan up to 0xC8 bytes) => split into both primary/secondary
  -> copy targets:
       -> primary text -> TEXTDISP_PrimarySearchText
       -> secondary text -> TEXTDISP_SecondarySearchText
  -> normalization:
       -> for each non-empty search buffer, apply ESQSHARED_ApplyProgramTitleTextFilters(max=128)

SCRIPT_ApplyPendingBannerTarget
  -> fetch current banner char via GCOMMAND_GetBannerChar
  -> pending target state machine:
       -> pending `-2` => normalize to `-1` (cancel deferred special marker)
       -> pending `>=0` => SCRIPT_BeginBannerCharTransition(target, speed211F), then clear pending
       -> pending `-1`:
            -> if current != default target (Global_REF_WORD_HEX_CODE_8E), transition to default
            -> clear pending after transition
  -> read-mode cleanup:
       -> when DATA_SCRIPT_BSS_WORD_2122 set, clear ESQPARS2_ReadModeFlags and latch 2122
```

#### Phase 8V Expanded (`SCRIPT_UpdateRuntimeModeForPlaybackCursor` / dispatch map)

```text
SCRIPT_UpdateRuntimeModeForPlaybackCursor
  -> if SCRIPT_RuntimeMode == 1:
       -> optional banner transition to (default banner + 28) when CTASKS flag `1BB3` == 'Y'
       -> enter mode2:
            -> DATA_SCRIPT_BSS_WORD_2119=0, TEXTDISP_CurrentMatchIndex=-1
            -> SCRIPT_RuntimeMode=2, DATA_SCRIPT_BSS_WORD_211A=1
            -> enable highlight copper + TEXTDISP_SetRastForMode(0)
       -> choose serial shadow ctrl byte:
            -> default 0
            -> when `MSN` in {'M','S'}, decode DATA_CTASKS_STR_N_1BC6 into 0/1/2/3 bucket
       -> SCRIPT_UpdateSerialShadowFromCtrlByte(bucket), clear search texts/channels, return 1
  -> else path:
       -> if runtime mode == 3: SCRIPT_DeassertCtrlLineNow(), clear latch DATA_SCRIPT_BSS_WORD_211A
       -> set SCRIPT_RuntimeMode=0, return 0

SCRIPT_DispatchPlaybackCursorCommand (cursor 1..15)
  -> 1: reset selection/refresh
  -> 2: enter mode2 + highlight + rast + serial shadow (3 for MSN='M', else 1)
  -> 3: enter mode2 + highlight + rast + serial shadow 1
  -> 4: if no deferred countdown, serial shadow 3 and arm deferred countdown=3
  -> 5: render aligned status using current channel/match globals
  -> 6: render aligned primary using DATA_WDISP_BSS_LONG_2350
  -> 7: render aligned secondary using DATA_WDISP_BSS_LONG_2350
  -> 8: weather status command from DATA_SCRIPT_STR_X_2126
  -> 9: textdisp command from (byte2127, word2128, SCRIPT_CommandTextPtr)
  -> 10: assert ctrl line and set runtime mode 1
  -> 11: enable highlight+rast and set pending banner (default+28, speed=1000)
  -> 12: set pending banner to current default, speed=1000
  -> 13: custom copper effect
  -> 14: set read mode on (DATA_SCRIPT_BSS_WORD_2122=1, ESQPARS2_ReadModeFlags=256)
  -> 15: set read mode off (clear 2122/read flags)
  -> default/out-of-range:
       -> TEXTDISP_CurrentMatchIndex=-1, increment DATA_SCRIPT_BSS_WORD_211C
  -> unified epilogue:
       -> SCRIPT_ClearSearchTextsAndChannels
       -> clear *playbackCursorPtr slot to 0
```

#### Phase 8W Expanded (`SCRIPT_UpdateCtrlStateMachine` control-line gate loop)

```text
SCRIPT_UpdateCtrlStateMachine
  -> refresh substate (`.refresh_ctrl_state`):
       -> checks ED_DiagVinModeChar membership in "YL"
       -> if matched, probes SCRIPT_ReadHandshakeBit3Flag:
            -> set DATA_SCRIPT_BSS_WORD_2118 = 1 or 2
       -> else clear DATA_SCRIPT_BSS_WORD_2118
  -> runtime-mode handling:
       -> only active when SCRIPT_RuntimeMode == 2
       -> substate 1:
            -> increment DATA_SCRIPT_BSS_WORD_2119
            -> after 3 ticks: clear counter, set runtime mode 3,
               SCRIPT_DeassertCtrlLineNow, TEXTDISP_ResetSelectionAndRefresh
       -> substate 2:
            -> clear DATA_SCRIPT_BSS_WORD_2119
       -> other substates:
            -> if Global_UIBusyFlag set, force runtime mode 3
  -> non-mode2 path:
       -> clear DATA_SCRIPT_BSS_WORD_2119
```

#### Phase 8X Expanded (`ESQPARS_ConsumeRbfByteAndDispatchCommand` preamble + command families)

```text
ESQPARS_ConsumeRbfByteAndDispatchCommand
  -> byte ingest:
       -> SCRIPT_ReadNextRbfByte -> current byte cached at -5(A5)
  -> preamble sync state:
       -> expects `0x55` then `0xAA` to arm command dispatch
       -> any mismatch resets ESQPARS_Preamble55SeenFlag / ESQPARS_CommandPreambleArmedFlag
  -> first-stage armed gate (when CommandPreambleArmedFlag==1 and no active code):
       -> `'A'`: read record + xor verify + ESQSHARED_MatchSelectionCodeWithOptionalSuffix
            -> may arm reset/status flags and increment parse attempts
       -> `'W'`: ESQPROTO_VerifyChecksumAndParseRecord
       -> `'w'`: ESQPROTO_VerifyChecksumAndParseList
       -> clears preamble flags after handling
  -> DATA command table (requires armed + DATA_WDISP_BSS_WORD_22A0==1):
       -> `'!'`: title-slot replacement flow (group/key lookup + per-slot ESQPARS_ReplaceOwnedString)
       -> `'%'`: DISKIO2_HandleInteractiveFileTransfer
       -> `'='`/`'H'`/`'h'`: DATA binary path
       -> `'C'`: ESQIFF2_ParseGroupRecordAndRefresh
       -> `'D'`: diagnostics command family
       -> `'E'` / `'i'`: copy-label flows (`ESQPROTO_CopyLabelToGlobal`)
       -> `'F'`: ESQIFF2_ApplyIncomingStatusPacket
       -> `'I'`: ESQPROTO_ParseDigitLabelAndDisplay
       -> `'K'`: clock/rtc flow (ESQPARS_ApplyRtcBytesAndPersist family)
       -> `'L'`/`'t'`: LADFUNC_ParseBannerEntryData
       -> `'M'`: ack fast-path
       -> `'O'`: ESQIFF2_ClearPrimaryEntryFlags34To39
       -> `'P'`: ESQSHARED_ParseCompactEntryRecord
       -> `'p'`: bitmap/title payload update with sparse/full row modes
       -> `'R'`: reset overlay + state persist
       -> `'V'`: version check / mismatch overlay
       -> `'c'`: ESQDISP_ParseProgramInfoCommandRecord
       -> `'f'`: config payload save/load path
       -> `'g'`: multiplexed subcommands:
            -> type `'1'` filter-state updates (primary/secondary via LOCAVAIL_ParseFilterStateFromBuffer)
            -> banner commands (`Global_STR_23` membership) -> DST_HandleBannerCommand32_33
            -> type `'5'` P_TYPE_ParseAndStoreTypeRecord
            -> type `'6'` GCOMMAND_ParseCommandOptions
            -> type `'7'` GCOMMAND_ParseCommandString
            -> type `'8'` GCOMMAND_ParsePPVCommand
       -> `'x'`: PARSEINI_HandleFontCommand
       -> `0xBB`: diagnostics box-off handler
  -> accounting/error behavior:
       -> XOR mismatch => DATACErrs++
       -> size/line failures => ESQIFF_LineErrorCount++
       -> successful handled records usually ESQIFF_ParseAttemptCount++
  -> epilogue:
       -> clears both preamble flags before return (except waiting-for-sync cases)
```

#### Phase 8Y Expanded (`ESQPARS` `'!'` title-slot replacement flow)

```text
ESQPARS_ConsumeRbfByteAndDispatchCommand :: cmd '!'
  -> framing:
       -> increments parse-attempt counter
       -> initializes running XOR seed (0xDE) and reads:
            -> group code byte
            -> slot start byte
            -> slot end byte
  -> early validation:
       -> slotStart >= 1
       -> slotEnd <= 48
       -> slotEnd >= slotStart
       -> group code matches primary or secondary group id
  -> key capture:
       -> reads title key text (max 6 chars; stops at NUL/0x12/space)
       -> drains remaining payload until NUL
       -> reads checksum byte and verifies against XOR accumulator
  -> target resolve:
       -> normalize special `'Y'` group encoding into slot range `1..0x30`
       -> choose active table set by group code and presence flag
       -> scan entry list:
            -> ESQDISP_GetEntryPointerByMode
            -> ESQDISP_GetEntryAuxPointerByMode
            -> byte-compare title key with aux-title text
  -> apply update:
       -> optional clear of entry flag bit7 when slot range is exactly `1..0x30`
       -> for each slot in [slotStart..slotEnd]:
            -> ESQPARS_ReplaceOwnedString(oldSlotPtr, NULL)
            -> write returned pointer to title slot table index (base + 56 + slot*4)
            -> set per-slot present flag byte at offset 7+slot
  -> any failed gate:
       -> aborts and returns through common preamble-clear epilogue
```

#### Phase 8Z Expanded (`ESQPARS` `'p'` bitmap row payload update flow)

```text
ESQPARS_ConsumeRbfByteAndDispatchCommand :: cmd 'p'
  -> setup:
       -> parse-attempt counter++
       -> initialize XOR seed 0x8F
       -> read group code + key text (up to 9 bytes, terminated by 0x12)
       -> resolve primary/secondary group entry count by group code
  -> bitmap decode:
       -> read 6-byte row bitmask (xor-tracked)
       -> if any bitmask byte nonzero => sparse mode candidate, else full-row mode
       -> reverse bit order with ESQ_ReverseBitsIn6Bytes
  -> entry lookup:
       -> iterate group titles, match incoming key against entry title text
       -> if no matching title, mark invalid and finish
  -> payload-width gate:
       -> read width byte (must be 1..3)
       -> invalid width clears valid flag
  -> full-row path (bitmap all-zero):
       -> read width bytes payload + trailer byte + checksum
       -> on success, write same width columns to all 49 rows:
            -> col0 base +0xFC
            -> col1 base +0x12D
            -> col2 base +0x15E
       -> if col0 value in 5..10, set entry flag bit0 at entry+40
  -> sparse path (bitmap nonzero):
       -> count marked rows via ESQ_TestBit1Based over 1..49
       -> read (markedRows * width) payload + trailer + checksum
       -> iterate rows 1..49 again:
            -> for each marked row, consume width bytes and write cols 0..2
            -> same col0 5..10 rule sets entry flag bit0
  -> finish:
       -> clears ESQPARS_ResetArmedFlag and uses shared preamble-clear epilogue
```

#### Phase 8AA Expanded (`ESQPARS` checksum/length-gated handler templates)

```text
ESQPARS_ConsumeRbfByteAndDispatchCommand
  -> shared pattern A (record handlers):
       -> ESQIFF2_ReadSerialRecordIntoBuffer(...)
       -> ESQ_GenerateXorChecksumByte(cmdByte, buffer, len)
       -> checksum mismatch => DATACErrs++
       -> optional length cap => ESQIFF_LineErrorCount++ on overflow
       -> invoke typed handler
       -> clear ESQPARS_ResetArmedFlag
  -> pattern A examples:
       -> `'j'` -> ESQIFF2_ParseLineHeadTailRecord, len <= 0x1F4
       -> `'i'` -> ESQPROTO_ParseDigitLabelAndDisplay, len <= 39
       -> `'i'` lower -> ESQPROTO_CopyLabelToGlobal, len <= 39
       -> `'V'` -> ESQIFF2_ShowVersionMismatchOverlay, len <= 0x8B
       -> `'x'` -> PARSEINI_HandleFontCommand, len <= 80
       -> `'L'/'t'` -> LADFUNC_ParseBannerEntryData, len <= 0x130
       -> `'c'` -> ESQDISP_ParseProgramInfoCommandRecord, len > 0 and checksum-valid
  -> shared pattern B (fixed-byte packet + trailer checksum):
       -> read fixed payload bytes with ESQIFF2_ReadRbfBytesToBuffer
       -> read checksum byte via SCRIPT_ReadNextRbfByte
       -> xor compare; mismatch => DATACErrs++
       -> typed validation and apply
  -> pattern B examples:
       -> `'F'` status packet: header byte in {'A','B'} and field1 in [65,73], then ESQIFF2_ApplyIncomingStatusPacket
       -> `'K'` clock packet: day<7, month<12, second<60, mode guard `DATA_CTASKS_STR_1_1BC9=='2'`, then ESQPARS_ApplyRtcBytesAndPersist
       -> `'D'` diagnostics buffer: 256-byte read + checksum gate
  -> shared pattern C (single-byte control checksum):
       -> `'%'`: expects 0xDA and sets DATA_ESQ_BSS_WORD_1DF6=1
       -> `'O'`: expects 0xB0 then ESQIFF2_ClearPrimaryEntryFlags34To39
       -> `'R'`: expects complement of 'R'; on armed-reset path, enters reset overlay loop
  -> config-stream special (`'f'` lower):
       -> reads subtype byte + rolling length via ESQPARS_ReadLengthWordWithChecksumXor
       -> enforces len < 0x2328
       -> reads payload(len-1) + final checksum
       -> on success: DISKIO_ParseConfigBuffer + DISKIO_SaveConfigToFileHandle
```

#### Phase 8AB Expanded (`ESQPARS_ReadLengthWordWithChecksumXor` + persist tail)

```text
ESQPARS_ReadLengthWordWithChecksumXor
  -> input:
       -> seed checksum byte provided in caller stack arg
  -> two-iteration loop:
       -> wait for clock/service UI
       -> read one serial byte
       -> XOR byte into running checksum
       -> shift ESQIFF_RecordLength by 8 and append byte
  -> output:
       -> ESQIFF_RecordLength contains big-endian 16-bit length
       -> D0 returns updated checksum accumulator

ESQPARS_PersistStateDataAfterCommand
  -> ordered persistence sequence:
       -> DISKIO2_FlushDataFilesIfNeeded
       -> LADFUNC_SaveTextAdsToFile
       -> DATETIME_SavePairToFile(DST_BannerWindowPrimary)
       -> LOCAVAIL_SaveAvailabilityDataFile(primary, secondary)
       -> P_TYPE_WritePromoIdDataFile
  -> used by reset/box-off style control paths before clearing armed flags
```

#### Phase 8AC Expanded (`ESQPARS` `'g'` multiplexed subtype dispatcher)

```text
ESQPARS_ConsumeRbfByteAndDispatchCommand :: cmd 'g'
  -> pre-step:
       -> read subtype byte D6 with wait-for-clock pacing
       -> fold subtype into rolling checksum seed (-6(A5))
  -> subtype `'1'` (filter-state payload):
       -> read record into ESQIFF_RecordBufferPtr with first byte preloaded
       -> xor verify whole payload
       -> dispatch by group code byte[0]:
            -> primary group -> LOCAVAIL_ParseFilterStateFromBuffer(..., LOCAVAIL_PrimaryFilterState)
            -> secondary group -> LOCAVAIL_ParseFilterStateFromBuffer(..., LOCAVAIL_SecondaryFilterState)
  -> banner subcommand path:
       -> if subtype exists in `Global_STR_23`, read sized text record
       -> xor verify
       -> DST_HandleBannerCommand32_33(subtype, recordBuf)
  -> subtype `'5'`:
       -> read+verify record
       -> P_TYPE_ParseAndStoreTypeRecord(recordBuf)
  -> subtype `'6'`:
       -> read+verify record
       -> GCOMMAND_ParseCommandOptions(recordBuf)
  -> subtype `'7'`:
       -> read+verify record
       -> GCOMMAND_ParseCommandString(recordBuf)
  -> subtype `'8'`:
       -> read+verify record
       -> GCOMMAND_ParsePPVCommand(recordBuf)
  -> error accounting:
       -> checksum mismatch => DATACErrs++
       -> banner sized-read failure => ESQIFF_LineErrorCount++
       -> successful handled subtypes => ESQIFF_ParseAttemptCount++
```

#### Phase 8AD Expanded (`ESQPARS` reset + box-off control paths)

```text
ESQPARS_ConsumeRbfByteAndDispatchCommand :: cmd 0xBB (box-off)
  -> reads control bytes with UI pacing and verifies complements:
       -> first byte must equal `~'D'` (0xBB)
       -> checksum byte must equal `0xFF`
  -> if DATA_ESQ_BSS_WORD_1DF6 set:
       -> ESQPARS_PersistStateDataAfterCommand()
       -> clear DATA_ESQ_BSS_WORD_1DF6 latch
  -> apply:
       -> clear DATA_WDISP_BSS_WORD_22A0
       -> ESQDISP_UpdateStatusMaskAndRefresh(2,0)
       -> clear ESQPARS_ResetArmedFlag + preamble flags

ESQPARS_ConsumeRbfByteAndDispatchCommand :: cmd 'R'
  -> verifies checksum byte equals `~'R'`
  -> requires ESQPARS_ResetArmedFlag == 1
  -> on pass:
       -> set ESQ_GlobalTickCounter=21000
       -> force bitmap target to Global_REF_696_400_BITMAP
       -> enters continuous overlay draw loop:
            -> centers and draws `Global_STR_RESET_COMMAND_RECEIVED`
            -> does not return to parser in normal flow
  -> on checksum fail:
       -> DATACErrs++
       -> clear ESQPARS_ResetArmedFlag + preamble flags
```

#### Phase 8AE Expanded (`ESQIFF2_ShowVersionMismatchOverlay` leaf)

```text
ESQIFF2_ShowVersionMismatchOverlay
  -> build local version string:
       -> sprintf("%s.%ld", majorMinorPrefix, Global_LONG_PATCH_VERSION_NUMBER)
  -> gate:
       -> wildcard-match incoming version payload (recordBuf+1) against local version
       -> if match => return (no overlay)
       -> if UI busy and diagnostics screen inactive => return
  -> overlay draw sequence:
       -> Disable multitasking / set ESQPARS2_ReadModeFlags=0x100 / reseed banner / Enable
       -> switch rastport bitmap to Global_REF_696_400_BITMAP
       -> clear diagnostics-active latch
       -> fill overlay rect (pen 2 fill, pen 3 text)
       -> draw three centered text lines:
            -> incorrect-version warning
            -> "your version is <current>"
            -> "correct version is <incoming>'"
  -> return tail:
       -> restores D2-D3 and stack frame
```

#### Phase 8AF Expanded (`ESQDISP_UpdateStatusMaskAndRefresh` leaf)

```text
ESQDISP_UpdateStatusMaskAndRefresh(maskBits, setMode)
  -> snapshot current mask (oldMask = DATA_ESQDISP_BSS_LONG_1E81)
  -> if setMode != 0:
       -> newMask = oldMask OR maskBits
    else:
       -> newMask = oldMask AND (~maskBits)
  -> clamp to 12-bit range (`newMask &= 0x0FFF`)
  -> if newMask changed:
       -> ESQDISP_ApplyStatusMaskToIndicators(newMask)
  -> return

ESQDISP_RefreshStatusIndicatorsFromCurrentMask
  -> ESQDISP_ApplyStatusMaskToIndicators(-1) to force full reapply
```

#### Phase 8AG Expanded (`ESQIFF2` attention/version UI overlays)

```text
ESQIFF2_ShowAttentionOverlay(codeByte)
  -> UI gate:
       -> if UI busy and diagnostics screen inactive, returns immediately
  -> code map:
       -> input 1..5 -> report code {1,2,8,9,10}; others => return
  -> overlay prologue:
       -> Disable/Enable pair around GCOMMAND_SeedBannerFromPrefs
       -> set ESQPARS2_ReadModeFlags=0x100
       -> swap rast bitmap to Global_REF_696_400_BITMAP and clear diagnostics-active latch
  -> draw body:
       -> fill dark rectangle and set text pen
       -> draw standby + engineer warning lines
       -> draw formatted error code line (`REPORT_ERROR_CODE_FORMATTED`)
       -> draw file context line:
            -> for codes 9/10 include width/colors via BRUSH_PlaneMaskForIndex
            -> otherwise include file name only
       -> draw resume hint line (`PRESS_ESC_TWICE...`)
  -> epilogue:
       -> restore prior draw mode and original rast bitmap pointer

ESQIFF2_ShowVersionMismatchOverlay
  -> compares incoming version payload against local major.minor.patch format
  -> on mismatch draws correction overlay and expected/current version lines
  -> returns via shared tail when versions match or gate conditions suppress display

ESQIFF2_ClearPrimaryEntryFlags34To39
  -> for each primary entry pointer:
       -> clear bytes entry[34]..entry[39]
  -> used by ESQPARS `'O'` control command
```

#### Phase 8AH Expanded (`ESQDISP` schedule/program-info helpers)

```text
ESQDISP_ComputeScheduleOffsetForRow(rowWord, slotByte)
  -> DST_BuildBannerTimeWord(rowWord, slotByte) => timeWord
  -> combines row + (timeWord*2) into intermediate offset
  -> DISPLIB_NormalizeValueByStep(intermediate, 1, 48)
  -> returns normalized schedule offset in D0

ESQDISP_FillProgramInfoHeaderFields(dst, statusChar, timeWord, flagA, flagB, codePtr)
  -> guard: returns immediately if dst == NULL
  -> writes:
       -> dst+40 = statusChar
       -> dst+46 = timeWord
       -> dst+41 = flagA
       -> dst+42 = flagB
  -> copies 2-byte code string into dst+43 and forces NUL at dst+45
```

#### Phase 8AI Expanded (`ESQDISP_ParseProgramInfoCommandRecord` matcher/update flow)

```text
ESQDISP_ParseProgramInfoCommandRecord(recordBuf)
  -> select target group table:
       -> secondary table when group byte matches secondary code and present flag set
       -> otherwise primary table when group byte matches primary code
  -> parse slot index from up to two decimal digits; require slot >= 6 and group has entries
  -> stream walk:
       -> requires delimiter 0x12 framing
       -> captures key/title token and finds payload break marker byte 0x04
  -> per-entry loop:
       -> compare key token against entry title text (entry+12)
       -> on match, derive field updates from payload bytes:
            -> toggles bit flags in status byte from Y/N-like chars
            -> parses two hex nibbles with range clamps
            -> copies optional 2-byte code text fallbacking to "00"
       -> ESQDISP_FillProgramInfoHeaderFields(entryPtr, ...)
```

#### Phase 8AJ Expanded (`ESQSHARED` compact record updater chain)

```text
ESQSHARED_ParseCompactEntryRecord
  -> parse tuple: groupCode, slotMaskType, titleKey(up to 8 chars, stop at 0x12), stateByte
  -> forward remaining payload pointer to:
       -> ESQSHARED_UpdateMatchingEntriesByTitle(titleKey, slotMaskType, groupCode, stateByte, payloadPtr)

ESQSHARED_UpdateMatchingEntriesByTitle
  -> validates slot index (1..48), resolves primary/secondary group entry tables
  -> loops entries:
       -> wildcard-match title key against title pointer table
       -> test/set slot bit in entry bitfield (entry+0x22) depending on slotMaskType bit6
       -> writes slot state byte into title-table flag array (offset 7+slot)
       -> applies title text filters to payload and normalizes special suffix formats
       -> replaces slot string pointer at titleTable[56 + slot*4] via ESQPARS_ReplaceOwnedString
       -> optional clock-format rewrite:
            -> find bracketed hour marker
            -> parse/edit hour+minute digits with CLOCK_FormatVariantCode offset
            -> adjust bracketed hour text + rebuild banner time word
       -> sets entry status bits (`entry+40 |= 0x80`, plus conditional bit0)
```

#### Phase 8AK Expanded (`ESQSHARED_CreateGroupEntryAndTitle` allocation/mutation path)

```text
ESQSHARED_CreateGroupEntryAndTitle(groupCode, headerText, bitfield6, reverseBitsSrc, titleSeed, ...)
  -> group selection:
       -> if groupCode == secondaryGroupCode:
            -> allocate 52-byte entry record into SecondaryEntryPtrTable[next]
            -> allocate 500-byte title table into SecondaryTitlePtrTable[next]
            -> set SecondaryGroupPresentFlag/header code
       -> else if groupCode == primaryGroupCode:
            -> allocate same pair into primary tables and set primary present/header code
       -> else return 0
  -> initialization:
       -> ESQSHARED_InitEntryDefaults(entryPtr)
       -> COI_EnsureAnimObjectAllocated(entryPtr)
       -> copy normalized seed text (space-stripped + trailing space) into entry+1
       -> copy header/title text blocks into entry+12 and entry+19
       -> store flags byte at entry+27 and reverse 6-byte bitset into entry+28..33
       -> clear bytes entry+34..39
  -> title-table init:
       -> copy title seed into title table base
       -> set titleTable[498] = groupCode
       -> for all 49 slots:
            -> set slot-present byte (offset 7+idx) = 1
            -> clear slot string pointer table entries (offset 56+idx*4)
  -> counters/state:
       -> increment group entry count
       -> update TEXTDISP_GroupMutationState (primary->1 unless already 2, secondary->2)

ESQSHARED_ApplyProgramTitleTextFilters
  -> applies transforms in order:
       -> CompressClosedCaptionedTag
       -> NormalizeInStereoTag
       -> ReplaceMovieRatingToken
       -> ReplaceTvRatingToken
```

#### Phase 8AL Expanded (`ESQSHARED` title-token filter helper leaves)

```text
ESQSHARED_CompressClosedCaptionedTag
  -> find case-folded substring "Closed Captioned"
  -> write marker byte 0x7C at token start
  -> copy tail text left to remove extra token bytes

ESQSHARED_NormalizeInStereoTag
  -> find "In Stereo"
  -> write marker byte 0x91 at token start
  -> mode branch on flag bit7:
       -> clear/trim path removes trailing class-3 separators before marker
       -> compact path shifts remaining suffix left over token body

ESQSHARED_ReplaceMovieRatingToken
  -> iterate movie-rating token table (max 8)
  -> on first match:
       -> replace token start with mapped glyph byte
       -> remove remaining token chars by tail compaction
       -> stop scan

ESQSHARED_ReplaceTvRatingToken
  -> same algorithm as movie-rating replacer over TV-rating token table
  -> first match wins; tail is compacted in-place
```

#### Phase 8AM Expanded (`ESQSHARED_MatchSelectionCodeWithOptionalSuffix` parser)

```text
ESQSHARED_MatchSelectionCodeWithOptionalSuffix(inputToken)
  -> token parse:
       -> splits base token and optional suffix around '.'
       -> handles separator/asterisk/question-mark edge cases
       -> tracks last significant delimiter char for fallback validation
  -> base match:
       -> wildcard-match parsed base token against ESQ_SelectCodeBuffer
       -> empty base token forces immediate failure state
  -> optional suffix match:
       -> if suffix present, wildcard-match suffix against DATA_WDISP_BSS_LONG_2298
  -> success rule:
       -> base match success AND suffix (if any) success
       -> plus fallback delimiter marker must remain default
  -> returns 1 on success, else 0
```

#### Phase 8AN Expanded (`ESQDISP` entry-eligibility helper leaves)

```text
ESQDISP_TestEntryGridEligibility(entryTitlePtr, slotIndex)
  -> validates slotIndex in range 1..48 and entry pointer non-NULL
  -> true if either:
       -> slot flag bit4 set at entryTitlePtr[7+slotIndex]
       -> value byte entryTitlePtr[0xFC+slotIndex] in numeric range 5..10
  -> returns 1 eligible, 0 otherwise

ESQDISP_TestEntryBits0And2_Core(entryPtr)
  -> checks entry status byte +40
  -> returns 1 only when both bit0 and bit2 are set

ESQDISP_GetEntryPointerByMode(index, mode)
  -> mode 1: primary table lookup with bounds check
  -> mode 2: secondary table lookup with bounds check
  -> otherwise returns NULL
```

#### Phase 8AO Expanded (`ESQDISP` mode/title-pointer and clock redraw helpers)

```text
ESQDISP_GetEntryAuxPointerByMode(index, mode)
  -> mode 1: primary title-table pointer lookup with bounds check
  -> mode 2: secondary title-table pointer lookup with bounds check
  -> unsupported mode or invalid index => NULL

ESQDISP_PollInputModeAndRefreshSelection
  -> samples CIAB mode bit from address 0xBFD0EE masked by 0x04
  -> debounce counter increments on change, resets on stable match
  -> after >5 consecutive differing polls:
       -> commits new mode byte
       -> if mode == 0: TEXTDISP_SetRastForMode(0)
       -> else: TEXTDISP_ResetSelectionAndRefresh()

ESQDISP_NormalizeClockAndRedrawBanner
  -> PARSEINI_NormalizeClockData(incomingClock, CLOCK_DaySlotIndex)
  -> DST_UpdateBannerQueue(DST_BannerWindowPrimary)
  -> if queue update reports no pending change: DST_RefreshBannerBuffer
  -> temporarily switch rastport bitmap to Global_REF_696_400_BITMAP
  -> CLEANUP_DrawClockBanner
  -> restore original bitmap pointer
  -> ESQDISP_DrawStatusBanner_Impl(1)
```

#### Phase 8AP Expanded (`ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty` clone path)

```text
ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty
  -> guard: if SecondaryGroupEntryCount != 0:
       -> DATA_ESQDISP_BSS_WORD_1E87 = 0
       -> return
  -> for each primary entry index i in [0, PrimaryGroupEntryCount):
       -> srcEntry = PrimaryEntryPtrTable[i]
       -> ESQSHARED_CreateGroupEntryAndTitle(
            secondaryGroupCode,
            srcEntry+12,         ; title/header text
            srcEntry[27],        ; entry class/state byte
            srcEntry+1,          ; normalized source label
            srcEntry+28,         ; slot bitset template
            srcEntry+19)         ; subtitle block
       -> dstEntry = SecondaryEntryPtrTablePreSlot[SecondaryGroupEntryCount]
       -> derive header args from srcEntry fields around +40..+46 (with 0xFF7F mask)
       -> ESQDISP_FillProgramInfoHeaderFields(dstEntry, ...)
  -> after full clone:
       -> DATA_ESQDISP_BSS_WORD_1E87 = 1
       -> return
```

#### Phase 8AQ Expanded (`ESQDISP_PropagatePrimaryTitleMetadataToSecondary` match/copy path)

```text
ESQDISP_PropagatePrimaryTitleMetadataToSecondary
  -> early return if PrimaryGroupEntryCount == 0 or SecondaryGroupEntryCount == 0
  -> for each secondary index s:
       -> secTitle = SecondaryTitlePtrTable[s]
       -> skip if secTitle->slotStringPtr0 (offset +60) already non-NULL
       -> secEntry = SecondaryEntryPtrTable[s]
       -> skip if slot bit1 is set in secEntry+28 bitfield
       -> found = false
       -> for each primary index p while !found:
            -> wildcard-match SecondaryTitlePtrTable[s] vs PrimaryTitlePtrTable[p]
            -> if no match: continue
            -> choose slot scan floor by primary entry class bit5:
                 class bit5=0 -> slots 48 down to 45
                 class bit5=1 -> slots 48 down to 1
            -> descending slot scan:
                 -> require slot bit set in primary entry+28
                 -> require primary title slot string ptr (56 + slot*4) non-NULL
                 -> ESQPARS_ReplaceOwnedString(secTitle, primarySlotString, secTitle->slotStringPtr0)
                 -> mirror per-slot flag bytes (offsets +253, +302, +351 families)
                 -> set secEntry status bit7 at +40
                 -> found = true
  -> return
```

#### Phase 8AR Expanded (`ESQDISP_PromoteSecondaryGroupToPrimary` table promotion path)

```text
ESQDISP_PromoteSecondaryGroupToPrimary
  -> ESQPARS_RemoveGroupEntryAndReleaseStrings(mode=1)
  -> NEWGRID_RefreshStateFlag = 1
  -> clear primary record checksum/length and reset GroupMutationState baseline
  -> if SecondaryGroupPresentFlag == 1:
       -> for i in [0, SecondaryGroupEntryCount):
            -> PrimaryEntryPtrTable[i] = SecondaryEntryPtrTable[i]
            -> PrimaryTitlePtrTable[i] = SecondaryTitlePtrTable[i]
            -> SecondaryEntryPtrTable[i] = NULL
            -> SecondaryTitlePtrTable[i] = NULL
       -> copy secondary metadata into primary:
            -> entry count, checksum, header code, record length
            -> PrimaryGroupPresentFlag = 1
       -> clear secondary metadata/present flag
       -> GroupMutationState = 3
  -> sync task bytes:
       -> DATA_CTASKS_BSS_BYTE_1B91 <- DATA_CTASKS_BSS_BYTE_1B92
       -> DATA_CTASKS_BSS_BYTE_1B8F <- DATA_CTASKS_BSS_BYTE_1B90
       -> DATA_CTASKS_BSS_BYTE_1B92 <- 0xFF
       -> DATA_CTASKS_BSS_BYTE_1B90 <- 0
  -> ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache
```

#### Phase 8AS Expanded (`ESQDISP` secondary line-chain promote + boolean helper)

```text
ESQDISP_PromoteSecondaryLineHeadTailIfMarked
  -> if DATA_WDISP_BSS_WORD_228F != 0:
       -> ESQIFF2_ClearLineHeadTailByMode(1)
       -> PrimaryLineHead/Tail <- SecondaryLineHead/Tail
       -> SecondaryLineHead/Tail <- NULL
  -> DATA_WDISP_BSS_WORD_228F = 0

ESQDISP_TestWordIsZeroBooleanize
  -> input: stack word argument
  -> output: D0 = -1 if input == 0, else D0 = 0
  -> idiom: `TST` + `SEQ` + `NEG` + `EXT.W` + `EXT.L`
```

#### Phase 8AT Expanded (`ESQIFF2` line-head/tail clear + parse paths)

```text
ESQIFF2_ClearLineHeadTailByMode(mode)
  -> mode == 2:
       -> ReplaceOwnedString(NULL, SecondaryLineHeadPtr)
       -> ReplaceOwnedString(NULL, SecondaryLineTailPtr)
       -> store returned pointers back into secondary head/tail globals
  -> else (primary):
       -> ReplaceOwnedString(NULL, PrimaryLineHeadPtr)
       -> ReplaceOwnedString(NULL, PrimaryLineTailPtr)
       -> store returned pointers back into primary head/tail globals

ESQIFF2_ParseLineHeadTailRecord(recordPtr)
  -> read leading group code byte
  -> if code == PrimaryGroupCode:
       -> ESQIFF2_ClearLineHeadTailByMode(1)
       -> parse payload split around delimiter 0x12:
            -> leading delimiter + trailing delimiter => both NULL
            -> leading delimiter only => tail-only replacement
            -> trailing delimiter only => head-only replacement, tail NULL
            -> internal delimiter => split head/tail and ReplaceOwnedString both
  -> else if code == SecondaryGroupCode:
       -> ESQIFF2_ClearLineHeadTailByMode(2)
       -> DATA_WDISP_BSS_WORD_228F = 1 (pending secondary line-chain promotion)
       -> apply same delimiter split logic using secondary head/tail globals
  -> else:
       -> ignore record and return
```

#### Phase 8AU Expanded (`ESQIFF2_ParseGroupRecordAndRefresh` token dispatch map)

```text
ESQIFF2_ParseGroupRecordAndRefresh
  -> group gate:
       -> if primary group code:
            -> compare record length/checksum against primary stored values
            -> on change: update stored length/checksum, reset max-title len,
               and clear prior primary entries via RemoveGroupEntryAndReleaseStrings(1)
       -> else if secondary group code:
            -> same change-detection/update flow for secondary metadata
            -> on change: RemoveGroupEntryAndReleaseStrings(2)
       -> else return 0 (record ignored)
  -> parser state init:
       -> D4 = active field index, D5 = field offset, D6 = group code
       -> parse buffers reset (`field0/1=""`, `field2=0xFF*6`, `field3=0`)
       -> error/flush sentinels zeroed
  -> byte loop dispatch:
       -> token `0x01`: switch into field-3 capture mode (`D4=3`, reset offset)
       -> token `0x11`: terminate current field text and switch to next field class (`D4=1`)
       -> token `0x12`: finalize current entry buffers and emit `CreateGroupEntryAndTitle`
       -> token `0x14`: copy fixed 6-byte field2 payload
       -> default: append data byte to active field text buffer
       -> each branch first validates `(field index, offset)` via `ValidateFieldIndexAndLength`
         and raises parse-fail sentinel on out-of-range
  -> loop flush:
       -> null-terminate current field
       -> `CreateGroupEntryAndTitle`
       -> `PadEntriesToMaxTitleWidth(groupCode)`
       -> `TEXTDISP_ApplySourceConfigAllEntries`
       -> `NEWGRID_RebuildIndexCache`
```

#### Phase 8AV Expanded (`ESQIFF2` field-bound validator + title-width padding)

```text
ESQIFF2_ValidateFieldIndexAndLength(fieldIndex, fieldOffset)
  -> reject if fieldIndex > 3
  -> if fieldIndex == 1: allow offset <= 10
  -> else: allow offset <= 7
  -> returns 1 valid / 0 invalid

ESQIFF2_PadEntriesToMaxTitleWidth(groupCode)
  -> resolve entry count/table by group code:
       -> secondary group => SecondaryEntryPtrTable + SecondaryGroupEntryCount
       -> primary group => PrimaryEntryPtrTable + PrimaryGroupEntryCount
       -> no group match => return 0
  -> for each entry:
       -> scan text at entry+1 for current NUL-terminated length
       -> delta = TEXTDISP_MaxEntryTitleLength - currentLen
       -> if delta > 0:
            -> build local space buffer (up to 10 bytes)
            -> append spaces with STRING_AppendAtNull
            -> copy padded text back to entry+1
  -> return
```

#### Phase 8AW Expanded (`ESQIFF2` serial record byte readers)

```text
ESQIFF2_ReadRbfBytesToBuffer(dst, count)
  -> repeats `count` times:
       -> wait/service UI tick
       -> read one serial RBF byte
       -> store to `*dst++`
  -> returns end pointer

ESQIFF2_ReadRbfBytesWithXor(dst, count, checksumPtr)
  -> repeats `count` times:
       -> wait/service UI tick
       -> read one serial byte
       -> store to `*dst++`
       -> `*checksumPtr ^= byte`
  -> returns end pointer

ESQIFF2_ReadSerialRecordIntoBuffer(dst, allowShortTerminatorFlag, extLenLimit)
  -> main record-body loop (hard cap at 0x2328 bytes):
       -> read one byte into dst[offset]
       -> if NUL terminator:
            -> with short-terminator disabled: end body
            -> with short-terminator enabled: require offset <= 1 else end body
       -> if byte == 0x14 and short-terminator enabled:
            -> copy up to `extLenLimit` immediate extension bytes
       -> if byte == 0x12 and short-terminator enabled:
            -> consume one extra byte, increment extension counter (-6(A5))
            -> abort with failure if extension counter reaches 0x12E
       -> advance offset and continue
  -> after body end:
       -> read one trailing checksum byte into `ESQIFF_RecordChecksumByte`
       -> return payload length in D0
```

#### Phase 8AX Expanded (`ESQIFF2_ReadSerialSizedTextRecord` sized+trailer flow)

```text
ESQIFF2_ReadSerialSizedTextRecord(dst, initialSize)
  -> reject if `initialSize <= 0` or `initialSize >= 0x2328`
  -> read initial payload bytes (`initialSize`) into `dst`
  -> NUL-terminate at current write cursor
  -> parse signed trailer length via `PARSE_ReadSignedLongSkipClass3_Alt(dst)`
  -> write provisional space marker at current cursor
  -> read trailer bytes while:
       -> previous byte is non-NUL
       -> trailer bytes read < parsed trailer length
       -> absolute cursor < 0x2328
  -> validate completion:
       -> require previous byte is NUL and trailer byte count matches parsed length
       -> else clear `dst[0]` and force return length 0
  -> on success:
       -> read/store trailing checksum byte into `ESQIFF_RecordChecksumByte`
  -> return current text length in D0
```

#### Phase 8AY Expanded (`ESQIFF` weather-status brush queue/slice renderer)

```text
ESQIFF_QueueIffBrushLoad(mode)
  -> resource cursor bootstrap:
       -> if local cursor is NULL (or mode==1 path), seed from PARSEINI_BannerBrushResourceHead
  -> decision split:
       -> weather-overlay immediate path:
            -> gate by countdown and digit-char state
            -> alloc brush node from current resource
            -> clone brush record -> WDISP_WeatherStatusBrushListHead
            -> ESQIFF_DrawWeatherStatusOverlayIntoBrush(clone)
            -> deallocate pending descriptor staging node
       -> standard async load path:
            -> alloc brush node from current resource
            -> mark descriptor class/state and set CTASKS_IffTaskState=6
            -> start IFF task process
  -> cursor advance:
       -> if mode != 2, advance DATA_ESQIFF_BSS_LONG_1EE9 via node->next (+234)

ESQIFF_RenderWeatherStatusBrushSlice(dstRast, brush)
  -> null-brush guard: clear remaining counter and return
  -> initialize slice-state on first call / reset gate:
       -> remaining width = brush width (A2+178)
       -> consumed offset = 0
       -> one-shot NEWGRID trigger flag = 1
  -> clamp per-step slice width to max 30
  -> mode dispatch:
       -> mode byte 9: perform dual-edge blits (left/right mirrored regions)
       -> other modes: center blit using half-width offset
       -> mode byte 11 + one-shot flag + `'Y'` gate:
            -> NEWGRID_ValidateSelectionCode(...)
            -> clear one-shot flag
  -> progress update:
       -> remaining -= sliceWidth
       -> consumed += sliceWidth
       -> store half-slice width in rast scratch (A3+52)
  -> return remaining width in D0
```

#### Phase 8BA Expanded (`ESQIFF` copper row-step + brightest-pen helper)

```text
ESQIFF_ServicePendingCopperPaletteMoves
  -> row 0 gate (`DATA_COMMON_BSS_WORD_1B15`):
       -> if countdown reaches trigger state and move flags are set:
            -> direction bit1 set: MoveCopperEntryTowardEnd(startIdx, endIdx)
            -> else: MoveCopperEntryTowardStart(startIdx, endIdx)
            -> clear row gate word
  -> repeat same pattern for rows 1, 2, and 3 using:
       -> row1: `1B16` + `WDISP_AccumulatorRow1_*`
       -> row2: `1B17` + `WDISP_AccumulatorRow2_*`
       -> row3: `1B18` + `WDISP_AccumulatorRow3_*`

ESQIFF_SetApenToBrightestPaletteIndex
  -> derive active palette count from depth bit (`DATA_WDISP_BSS_LONG_22AE`)
  -> initialize best score from palette index 0 RGB sum
  -> scan remaining palette entries:
       -> intensity = R + G + B
       -> if intensity > best: store new best intensity/index
  -> resolve display-context rastport pointer
  -> _LVOSetAPen(bestIndex)
```

#### Phase 8BB Expanded (`ESQIFF` external catalog reload + line-entry reader)

```text
ESQIFF_ReloadExternalAssetCatalogBuffers(mode)
  -> early gates:
       -> requires CTASKS_IffTaskDoneFlag set
  -> g_ads reload branch (guarded by mode/diag/write gates):
       -> Forbid/Permit around brush-list free/reset
       -> clear ESQIFF_GAdsBrushListCount + ESQIFF_GAdsListLineIndex
       -> free prior g_ads blob if present
       -> open `gfx/g_ads.data`, get filesize, allocate `size+1`, read blob
       -> on full read: set ESQIFF_ExternalAssetFlags bit0
       -> close handle
       -> sync g_ads line index shadow to 0/1 from DATA_WDISP_BSS_WORD_2294 gate
  -> logo.lst reload branch (only when mode==0 and drive writable):
       -> Forbid/Permit around brush-list free/reset
       -> clear ESQIFF_LogoBrushListCount + ESQIFF_LogoListLineIndex
       -> free prior logo blob if present
       -> open `df0:logo.lst`, get filesize, allocate `size+1`, read blob
       -> on full read: set ESQIFF_ExternalAssetFlags bit1
       -> close handle

ESQIFF_ReadNextExternalAssetPathEntry(outBuf)
  -> picks source stream by ESQIFF_AssetSourceSelect:
       -> logo stream (`df0:logo.lst`) with ESQIFF_LogoListLineIndex
       -> or g_ads stream with ESQIFF_GAdsListLineIndex (requires ESQIFF_GAdsSourceEnabled)
  -> seeks forward to stored line index by counting newline bytes (0x0A)
  -> updates selected stream line index for next call
  -> copies entry chars into outBuf until delimiter:
       -> stop on LF/CR/space/end
       -> comma => terminate output and set ESQIFF_ExternalAssetPathCommaFlag=1
  -> NUL-terminate outBuf and return success flag
```

#### Phase 8BC Expanded (`ESQIFF_QueueNextExternalAssetIffJob` high-level map, partial)

```text
ESQIFF_QueueNextExternalAssetIffJob
  -> task/quotas gate:
       -> requires CTASKS_IffTaskDoneFlag
       -> enforces per-source list-count caps before queueing new work
  -> source viability gate:
       -> chooses active catalog blob by source select
       -> loops ESQIFF_ReadNextExternalAssetPathEntry until acceptable path found
       -> uses wildcard/path-prefix checks and comma-flag behavior to skip disallowed items
  -> queue path:
       -> alloc brush descriptor for selected path
       -> type byte 0x04 (logo) or 0x05 (g_ads)
       -> stash descriptor to pending pointer and start IFF task process
  -> loop continuation:
       -> compares previous/current path snapshot; may continue scanning
       -> returns -1 when no valid path remains in this pass
```

#### Phase 8BD Expanded (`ESQIFF` external asset blit/play/service chain)

```text
ESQIFF_ShowExternalAssetWithCopperFx(sourceMode)
  -> select brush head by source:
       -> sourceMode!=0 => g_ads head
       -> sourceMode==0 => logo head
       -> if no head: set retry bit in DATA_ESQFUNC_BSS_WORD_1EE4 and return
  -> run drop transition, compute banner-transition duration from brush width/flags
  -> wait for SCRIPT_BannerTransitionActive to clear
  -> capture 4 accumulator rows from brush offsets +200.. into WDISP_AccumulatorRowTable
  -> choose display-context mode from brush flags (196/198/199 paths)
  -> clear rast, set pen, and blit brush via BRUSH_SelectBrushSlot
  -> optional palette-triple refresh from brush palette bytes (offset +0xE8)
  -> store accumulator threshold words 1B0D..1B10 and arm rise-transition state 1B11..1B18
  -> run rise transition

ESQIFF_PlayNextExternalAssetFrame(sourceMode)
  -> run drop transition and validate active brush head for source
  -> fallback path:
       -> restore base palette, disable highlight/copper effect, set rast mode 2
  -> render path:
       -> build temp display context, call ShowExternalAssetWithCopperFx(sourceMode)
       -> mode0 with no comma-flag:
            -> set brightest pen, restore CurrentMatchIndex snapshot, redraw channel banner
       -> Forbid/Permit protected pop:
            -> decrement list count
            -> pop head from active list (logo or g_ads)
  -> preserve/restore accumulator-capture flag around rise transition
  -> call ESQIFF_ServiceExternalAssetSourceState(sourceMode ? 1 : 0)

ESQIFF_ServiceExternalAssetSourceState(modeFlag)
  -> skip when select-code RAVESC gate or COI busy gate is active
  -> set ESQIFF_AssetSourceSelect / ESQIFF_GAdsSourceEnabled based on modeFlag
  -> conditionally reload catalogs:
       -> logo reload if drive writable and logo flag missing
       -> g_ads reload if DATA_WDISP_BSS_LONG_2319 clear and g_ads flag missing
  -> queue next asset job
```

#### Phase 8BE Expanded (`ESQIFF` external catalog teardown + copper tick + brush.ini hotkey)

```text
ESQIFF_DeallocateAdsAndLogoLstData
  -> if g_ads pointer and filesize are set:
       -> DeallocateMemory(size+1, ptr, callsite tag)
       -> clear g_ads pointer/filesize globals
  -> if logo.lst pointer and filesize are set:
       -> DeallocateMemory(size+1, ptr, callsite tag)
       -> clear logo pointer/filesize globals

ESQIFF_RunPendingCopperAnimations
  -> lane 1B19: while >0 -> ESQ_NoOp_006A + decrement
  -> lane 1B1A: while >0 -> ESQ_NoOp_0074 + decrement
  -> lane 1B1B: while >0 -> ESQ_DecCopperListsPrimary + decrement
  -> lane 1B1C: while >0 -> ESQ_IncCopperListsTowardsTargets + decrement
  -> exits only when all four lanes are zero

ESQIFF_HandleBrushIniReloadHotkey(key)
  -> active only for key `'a'`
  -> force UI refresh idle-safe
  -> free ESQIFF_BrushIniListHead
  -> parse `df0:brush.ini`
  -> repopulate brush list from parsed descriptors
  -> select preferred `DT` brush by label
  -> fallback to `DITHER` brush predicate if no selected node
  -> cache type-3 brush pointer in DATA_ESQFUNC_BSS_LONG_1ED0
  -> reset ctrl input state idle-safe
```

#### Phase 8BF Expanded (`ESQFUNC` secondary commit + UI-wait helpers)

```text
ESQFUNC_FreeLineTextBuffers
  -> for slot 0..19:
       -> deallocate 60-byte line buffer from LADFUNC_LineTextBufferPtrs[slot]
       -> clear slot pointer
  -> reset return state

ESQFUNC_WaitForClockChangeAndServiceUi
  -> loop:
       -> ParseIni_MonitorClockChange
       -> if unchanged: ESQFUNC_ServiceUiTickIfRunning
       -> repeat until change is reported

ESQFUNC_CommitSecondaryStateAndPersist
  -> save ESQPARS2_ReadModeFlags; force mode to 0x100
  -> set DATA_ESQDISP_BSS_WORD_1E86 = 1
  -> propagate/promote/mirror secondary state:
       -> ESQDISP_PropagatePrimaryTitleMetadataToSecondary
       -> LOCAVAIL_RebuildFilterStateFromCurrentGroup
       -> ESQDISP_PromoteSecondaryGroupToPrimary
       -> ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty
       -> ESQDISP_PromoteSecondaryLineHeadTailIfMarked
  -> flush/save persistence outputs:
       -> FlushDataFilesIfNeeded
       -> SaveTextAdsToFile
       -> SaveAvailabilityDataFile(primary, secondary)
       -> DATETIME_SavePairToFile(DST_BannerWindowPrimary)
       -> PromoteSecondaryList
       -> WritePromoIdDataFile
  -> ESQFUNC_UpdateDiskWarningAndRefreshTick
  -> restore ESQPARS2_ReadModeFlags
```

#### Phase 8BG Expanded (`ESQFUNC` brush select/apply + PW list rebuild + trim helper)

```text
ESQFUNC_SelectAndApplyBrushForCurrentEntry(modeFlag, ...)
  -> selection source:
       -> prefer script-selected brush pointer (primary/secondary by modeFlag)
       -> otherwise resolve current entry pointer from active group/index
  -> entry tag routing (`entry+0x2B`):
       -> tag `00`: use BRUSH_SelectedNode directly
       -> tag `11`: wildcard scan through brush descriptor chains
       -> fallback: 2-char tag compare against brush nodes
       -> optional type-3 fallback via DATA_ESQFUNC_BSS_LONG_1ED0 when entry flag bit4 set
  -> clear global/display rastports to pen 31
  -> if brush resolved, blit with BRUSH_SelectBrushSlot into display context
  -> palette handling from brush mode (field +328):
       -> mode 0/1: copy brush palette bytes (offset +0xE8) into live palette triples
       -> mode 1: immediately restore base palette
       -> mode 3: restore first 12 bytes from DATA_ESQFUNC_CONST_LONG_1ECC
       -> no brush: restore base palette
  -> returns success flag 1

ESQFUNC_RebuildPwBrushListFromTagTable
  -> free existing ESQFUNC_PwBrushListHead
  -> iterate 6 tag-table entries:
       -> alloc brush descriptor node
       -> assign descriptor type byte (index0 => 0x08, others => 0x09)
       -> seed ESQFUNC_PwBrushDescriptorHead on first node
  -> populate ESQFUNC_PwBrushListHead from descriptor chain
  -> clear descriptor head scratch

ESQFUNC_TrimTextToPixelWidthWordBoundary(rastport, maxPx, textPtr)
  -> find text length
  -> while TextLength(text[0..len]) > maxPx:
       -> scan backward to class-3 boundary using WDISP_CharClassTable bit3
       -> trim trailing class-3 run
  -> return fitted length
```

#### Phase 8BH Expanded (`ESQFUNC` refresh-mode setter + ESC version screen)

```text
ESQFUNC_UpdateRefreshModeState(requestFlag)
  -> always sets DATA_ESQFUNC_CONST_WORD_1ECD = 1
  -> if NEWGRID_MessagePumpSuspendFlag set:
       -> clear NEWGRID_RefreshStateFlag + suspend flag
       -> reset blit geometry words (1F53/1F54)
       -> recompute banner row blit geometry
  -> mode selector update:
       -> requestFlag==0 => NEWGRID_ModeSelectorState = 0
       -> requestFlag!=0 => NEWGRID_ModeSelectorState = 2
            -> if previous NEWGRID_LastRefreshRequest was 0: clear NEWGRID_RefreshStateFlag
  -> NEWGRID_LastRefreshRequest = requestFlag

ESQFUNC_DrawEscMenuVersion
  -> clear diagnostics active flag
  -> set APen/DrMd on Global_REF_RASTPORT_1
  -> sprintf + draw build line at (175,330)
  -> choose ROM string (`1.3` vs `2.04`) from Global_LONG_ROM_VERSION_CHECK
  -> sprintf + draw ROM line at (175,360)
  -> set APen=3 and draw continue prompt at (175,390)
  -> restore APen=1
```

#### Phase 8BI Expanded (`ESQPARS` ownership release/replace helper return tails)

```text
ESQPARS_RemoveGroupEntryAndReleaseStrings_Return
  -> shared epilogue for entry/title/string release loop helper
  -> restores D5-D7/A2 + frame state and returns

ESQPARS_ReplaceOwnedString_Return
  -> shared epilogue for owned-string replacement helper
  -> restores D6-D7/A2-A3 and returns replacement pointer in D0
```

#### Phase 8BJ Expanded (`ESQPARS` RTC/length helper semantics + wrapper consistency)

```text
ESQPARS_ApplyRtcBytesAndPersist
  -> decodes incoming RTC payload bytes into stack temporaries
  -> expands year byte with +1900 adjustment
  -> commits globals via PARSEINI_WriteRtcFromGlobals
  -> normalizes + redraws on-screen clock state

ESQPARS_ReadLengthWordWithChecksumXor
  -> loops two serial reads to assemble 16-bit ESQIFF_RecordLength (big-endian)
  -> XOR-folds each byte into caller accumulator
  -> services UI tick wait before each byte read

ESQPARS_ReadLengthWordWithChecksumXor_Return
  -> shared loop exit; returns final XOR accumulator in D0

ESQPARS_JMPTBL_SCRIPT_ResetCtrlContextAndClearStatusLine
  -> normalized as standard jump-table forwarder documentation block
```

#### Phase 8BK Expanded (`ESQIFF` jump-table forwarder normalization batch)

```text
ESQIFF_JMPTBL_* wrapper block (34 routines)
  -> converted header aliases from `(Routine at ...)` to `(Jump-table forwarder)`
  -> replaced static-scan placeholder DESC/NOTES with consistent forwarder wording
  -> no control-flow or opcode changes; documentation-only normalization
```

#### Phase 8BL Expanded (`ESQFUNC` jump-table forwarder normalization batch)

```text
ESQFUNC_JMPTBL_* wrapper block (27 routines)
  -> converted header aliases from `(Routine at ...)` to `(Jump-table forwarder)`
  -> replaced static-scan placeholder DESC/NOTES with consistent forwarder wording
  -> no control-flow or opcode changes; documentation-only normalization
```

#### Phase 8BM Expanded (`ESQDISP` jump-table forwarder normalization batch)

```text
ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages
ESQDISP_JMPTBL_UNKNOWN2B_AllocRaster
  -> normalized to standard jump-table forwarder header wording
  -> no control-flow or opcode changes; documentation-only normalization
```

#### Phase 8BN Expanded (`ESQIFF` weather-overlay brush text renderer)

```text
ESQIFF_DrawWeatherStatusOverlayIntoBrush
  -> copies current weather overlay string into owned working buffer
  -> rewrites delimiter byte `$18` to NUL to segment text rows
  -> clamps render segments to max 10 and trims each segment to fit brush width
  -> draws paired left/right column segments via Move/Text calls
  -> restores APen/DrMd and frees working buffer on every exit path
```

#### Phase 8BO Expanded (`ESQDISP` highlight/msg + indicator mask helpers)

```text
ESQDISP_AllocateHighlightBitmaps (+ Return)
  -> initializes 3-plane highlight bitmap metadata and allocates/clears per-plane rasters

ESQDISP_InitHighlightMessagePattern (+ Return)
  -> seeds message pattern bytes (4..7) at A3+55..58

ESQDISP_QueueHighlightDrawMessage
  -> populates highlight message payload and embedded RastPort, then PutMsg enqueues work

ESQDISP_ApplyStatusMaskToIndicators
  -> decodes status-bit groups and maps them into two indicator color-slot updates
```

#### Phase 8BP Expanded (`ESQDISP` status-indicator color painter)

```text
ESQDISP_SetStatusIndicatorColorSlot
  -> validates slot index and keeps per-slot pending color cache
  -> honors busy gate by caching deferred updates without repaint
  -> when active, paints indicator rectangle and restores prior rastport pen/bitmap
  -> supports `D7==-1` to consume cached color and clear pending entry
```

#### Phase 8BQ Expanded (`ESQDISP` entry helpers + status-banner docs refinement)

```text
ESQDISP_TestEntryBits0And2 (+ Core)
  -> documented alias-to-core flow and clarified bit-test local labels

ESQDISP_GetEntryPointerByMode
  -> replaced duplicate placeholder preface with explicit alias/documentation note

ESQDISP_DrawStatusBanner_Impl (+ Return)
  -> replaced placeholder DESC/NOTES with behavior summary and shared-return semantics
```

#### Phase 8BR Expanded (`LOCAVAIL` foundational state/node helpers)

```text
LOCAVAIL_FreeNodeRecord / FreeNodeAtPointer
  -> clarified node reset vs payload-free responsibilities and null/no-op paths

LOCAVAIL_ResetFilterStateStruct / ResetFilterCursorState
  -> documented default sentinels (`'F'`, `-1`) and reset scope

LOCAVAIL_FreeResourceChain
  -> documented shared-ref decrement + conditional node-array teardown flow

LOCAVAIL_CopyFilterStateStructRetainRefs
  -> documented shallow-copy + shared-ref retention semantics

LOCAVAIL_AllocNodeArraysForState
  -> documented valid node-count bounds (1..99) and success-flag return

LOCAVAIL_SetFilterModeAndResetState
  -> documented supported mode gating (0/1) and reset-on-change behavior
```

#### Phase 8BS Expanded (`LOCAVAIL` parser/token helper return-path refinements)

```text
LOCAVAIL_ParseFilterStateFromBuffer_Return
  -> clarified success-flag return and shared unwind semantics

LOCAVAIL_MapFilterTokenCharToClass (+ Return)
  -> documented digit/alpha token-to-class mapping behavior
  -> renamed local labels for non-digit/alpha/fallback branches

LOCAVAIL_GetNodeDurationByIndex
  -> documented bounds-checked duration return semantics

LOCAVAIL_ComputeFilterOffsetForEntry_Return
  -> clarified shared return-tail behavior
```

#### Leaf Coverage Ledger (Skip-Revisit List)

```text
Purpose:
  -> Track leaves already renamed/documented so outer-tree traversal can avoid
     re-touching the same local routines unless new semantics are discovered.

Coverage markers:
  -> [done] = header/local-flow clarity pass completed + hash verified
  -> [hold] = intentionally deferred due to low confidence or pending context

[done] ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty           (Phase 8AP)
[done] ESQDISP_PropagatePrimaryTitleMetadataToSecondary         (Phase 8AQ)
[done] ESQDISP_PromoteSecondaryGroupToPrimary                   (Phase 8AR)
[done] ESQDISP_PromoteSecondaryLineHeadTailIfMarked             (Phase 8AS)
[done] ESQDISP_TestWordIsZeroBooleanize                         (Phase 8AS)
[done] ESQIFF2_ClearLineHeadTailByMode                          (Phase 8AT)
[done] ESQIFF2_ParseLineHeadTailRecord                          (Phase 8AT)
[done] ESQIFF2_ParseGroupRecordAndRefresh                       (Phase 8AU)
[done] ESQIFF2_ValidateFieldIndexAndLength                      (Phase 8AV)
[done] ESQIFF2_PadEntriesToMaxTitleWidth                        (Phase 8AV)
[done] ESQIFF2_ReadRbfBytesToBuffer                          (Phase 8AW)
[done] ESQIFF2_ReadRbfBytesWithXor                           (Phase 8AW)
[done] ESQIFF2_ReadSerialRecordIntoBuffer                       (Phase 8AW)
[done] ESQIFF2_ReadSerialSizedTextRecord                        (Phase 8AX)
[done] ESQIFF_QueueIffBrushLoad                                 (Phase 8AY)
[done] ESQIFF_RenderWeatherStatusBrushSlice                     (Phase 8AY)
[done] ESQIFF_ServicePendingCopperPaletteMoves                  (Phase 8BA)
[done] ESQIFF_SetApenToBrightestPaletteIndex                   (Phase 8BA)
[done] ESQIFF_ReloadExternalAssetCatalogBuffers                 (Phase 8BB)
[done] ESQIFF_ReadNextExternalAssetPathEntry                    (Phase 8BB)
[done] ESQIFF_QueueNextExternalAssetIffJob                      (Phase 8BC)
[done] ESQIFF_ShowExternalAssetWithCopperFx                     (Phase 8BD)
[done] ESQIFF_PlayNextExternalAssetFrame                        (Phase 8BD)
[done] ESQIFF_ServiceExternalAssetSourceState                   (Phase 8BD)
[done] ESQIFF_DeallocateAdsAndLogoLstData                       (Phase 8BE)
[done] ESQIFF_RunPendingCopperAnimations                        (Phase 8BE)
[done] ESQIFF_HandleBrushIniReloadHotkey                        (Phase 8BE)
[done] ESQFUNC_FreeLineTextBuffers                              (Phase 8BF)
[done] ESQFUNC_WaitForClockChangeAndServiceUi                   (Phase 8BF)
[done] ESQFUNC_CommitSecondaryStateAndPersist                   (Phase 8BF)
[done] ESQFUNC_SelectAndApplyBrushForCurrentEntry               (Phase 8BG)
[done] ESQFUNC_RebuildPwBrushListFromTagTable                   (Phase 8BG)
[done] ESQFUNC_TrimTextToPixelWidthWordBoundary                 (Phase 8BG)
[done] ESQFUNC_DrawEscMenuVersion                               (Phase 8BH)
[done] ESQPARS_RemoveGroupEntryAndReleaseStrings_Return         (Phase 8BI)
[done] ESQPARS_ReplaceOwnedString_Return                        (Phase 8BI)
[done] ESQPARS_ApplyRtcBytesAndPersist                          (Phase 8BJ)
[done] ESQPARS_ReadLengthWordWithChecksumXor                    (Phase 8BJ)
[done] ESQPARS_ReadLengthWordWithChecksumXor_Return             (Phase 8BJ)
[done] ESQPARS_JMPTBL_SCRIPT_ResetCtrlContextAndClearStatusLine (Phase 8BJ)
[done] ESQIFF_JMPTBL_* wrapper block (34 forwarders)            (Phase 8BK)
[done] ESQFUNC_JMPTBL_* wrapper block (27 forwarders)           (Phase 8BL)
[done] ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages               (Phase 8BM)
[done] ESQDISP_JMPTBL_UNKNOWN2B_AllocRaster                     (Phase 8BM)
[done] ESQIFF_DrawWeatherStatusOverlayIntoBrush                 (Phase 8BN)
[done] ESQDISP_AllocateHighlightBitmaps                         (Phase 8BO)
[done] ESQDISP_AllocateHighlightBitmaps_Return                  (Phase 8BO)
[done] ESQDISP_InitHighlightMessagePattern                      (Phase 8BO)
[done] ESQDISP_InitHighlightMessagePattern_Return               (Phase 8BO)
[done] ESQDISP_QueueHighlightDrawMessage                        (Phase 8BO)
[done] ESQDISP_ApplyStatusMaskToIndicators                      (Phase 8BO)
[done] ESQDISP_SetStatusIndicatorColorSlot                      (Phase 8BP)
[done] ESQDISP_TestEntryBits0And2                               (Phase 8BQ)
[done] ESQDISP_TestEntryBits0And2_Core                          (Phase 8BQ)
[done] ESQDISP_GetEntryPointerByMode                            (Phase 8BQ)
[done] ESQDISP_DrawStatusBanner_Impl                            (Phase 8BQ)
[done] ESQDISP_DrawStatusBanner_Impl_Return                     (Phase 8BQ)
[done] LOCAVAIL_FreeNodeRecord                                  (Phase 8BR)
[done] LOCAVAIL_FreeNodeAtPointer                               (Phase 8BR)
[done] LOCAVAIL_ResetFilterStateStruct                          (Phase 8BR)
[done] LOCAVAIL_FreeResourceChain                               (Phase 8BR)
[done] LOCAVAIL_CopyFilterStateStructRetainRefs                 (Phase 8BR)
[done] LOCAVAIL_AllocNodeArraysForState                         (Phase 8BR)
[done] LOCAVAIL_ResetFilterCursorState                          (Phase 8BR)
[done] LOCAVAIL_SetFilterModeAndResetState                      (Phase 8BR)
[done] LOCAVAIL_ParseFilterStateFromBuffer_Return               (Phase 8BS)
[done] LOCAVAIL_MapFilterTokenCharToClass                       (Phase 8BS)
[done] LOCAVAIL_MapFilterTokenCharToClass_Return                (Phase 8BS)
[done] LOCAVAIL_GetNodeDurationByIndex                          (Phase 8BS)
[done] LOCAVAIL_ComputeFilterOffsetForEntry_Return              (Phase 8BS)
[done] ESQIFF2_ApplyIncomingStatusPacket_Return                 (header pass)
[done] ESQIFF2_ValidateAsciiNumericByte                         (header pass)
[done] ESQIFF2_ClearPrimaryEntryFlags34To39_Return              (header pass)
```

#### Phase 8 naming confidence
- High:
  - `ESQFUNC_ServiceUiTickIfRunning`
  - `ESQFUNC_ProcessUiFrameTick`
  - `PARSEINI_MonitorClockChange`
  - `ESQPARS_ConsumeRbfByteAndDispatchCommand`
  - `SCRIPT_HandleSerialCtrlCmd`
  - `SCRIPT_HandleBrushCommand`
  - `SCRIPT_DispatchPlaybackCursorCommand`
  - `TEXTDISP_HandleScriptCommand`
  - `CLEANUP_ProcessAlerts`
  - `ESQ_TickClockAndFlagEvents`
  - `TEXTDISP_FilterAndSelectEntry`
  - `ESQIFF2_ParseGroupRecordAndRefresh`
  - `ESQIFF2_ParseLineHeadTailRecord`
  - `PARSEINI_HandleFontCommand`
  - `PARSEINI_ScanLogoDirectory`
  - `GCOMMAND_ParseCommandString`
  - `GCOMMAND_ParsePPVCommand`
  - `LOCAVAIL_ParseFilterStateFromBuffer`
  - `ESQIFF2_ParseGroupRecordAndRefresh`
  - `SCRIPT_HandleBrushCommand`
- Medium:
  - command-family grouping labels under `ESQPARS_ConsumeRbfByteAndDispatchCommand`
    - family behavior is clear, but full byte-to-handler semantics still need per-command validation.

## Naming/Documentation Confidence Pass

## Keep As-Is (High Confidence)
- `ESQ_StartupEntry`
- `ESQ_ParseCommandLineAndRun`
- `ESQ_ShutdownAndReturn`
- `MEMLIST_FreeAll`
- `ESQ_FormatDiskErrorMessage`

## Keep But Track (Medium Confidence)
- `ESQ_MainInitAndRun`
  - Name is directionally accurate; function is both initializer and early runtime dispatcher.
  - If renamed later, prefer alias-first approach to avoid churn.

## Low-Confidence / Placeholder Nodes
- `UNKNOWN2B_Stub0`, `UNKNOWN2B_Stub1`
  - Currently true empty stubs (RTS only).
  - Keep names until a non-stub implementation appears.
- `GROUP_MAIN_A_JMPTBL_UNKNOWN2B_Stub0/1`
  - Accurate as jump-table wrappers to stub targets.

## Immediate Follow-Up Checks (call-tree driven)
1. Verify all function headers under this root path have complete `CALLS` lists that match current code.
2. Add confidence tags (`high/med/low`) in header human-name parentheses where still uncertain.
3. Expand this tree depth-first for one heavy branch at a time:
   - `ESQIFF2_ParseGroupRecordAndRefresh` field parser sub-loops (`ParseField*` state)
   - `TEXTDISP_BuildEntryDetailLine` token/substring transformation stages
   - `SCRIPT_HandleBrushCommand` subcommand byte map to final cursor states

## Notes
- This checkpoint intentionally favors correctness and traceability over exhaustive leaf enumeration.
- For large fan-out routines, phase trees are more maintainable than a single monolithic call dump.
