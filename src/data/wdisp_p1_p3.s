    XDEF    _GCOMMAND_PPVListingsTemplatePtr
    XDEF    _GCOMMAND_PPVPeriodTemplatePtr
    XDEF    _GCOMMAND_PpvShowtimesRowSpan
    XDEF    _GCOMMAND_DefaultPresetTable
    XDEF    _GCOMMAND_PresetValueTable
    XDEF    _GCOMMAND_PresetWorkEntryTable
    XDEF    _GCOMMAND_PresetWorkEntry0_ValueIndex
    XDEF    _GCOMMAND_PresetWorkEntry1
    XDEF    _GCOMMAND_PresetWorkEntry1_ValueIndex
    XDEF    _GCOMMAND_PresetWorkEntry2
    XDEF    _GCOMMAND_PresetWorkEntry2_ValueIndex
    XDEF    _GCOMMAND_PresetWorkEntry3
    XDEF    _GCOMMAND_PresetWorkEntry3_ValueIndex
    XDEF    _GCOMMAND_HighlightFlag
    XDEF    _GCOMMAND_BannerBoundLeft
    XDEF    _GCOMMAND_BannerBoundTop
    XDEF    _GCOMMAND_BannerBoundRight
    XDEF    _GCOMMAND_BannerBoundBottom
    XDEF    _GCOMMAND_BannerStepLeft
    XDEF    _GCOMMAND_BannerStepTop
    XDEF    _GCOMMAND_BannerStepRight
    XDEF    _GCOMMAND_BannerStepBottom
    XDEF    _GCOMMAND_BannerRowByteOffsetCurrent
    XDEF    _GCOMMAND_BannerRowByteOffsetPrevious
    XDEF    _GCOMMAND_BannerQueueSlotPrevious
    XDEF    _GCOMMAND_BannerQueueSlotCurrent
    XDEF    _GCOMMAND_BannerRowIndexPrevious
    XDEF    _GCOMMAND_BannerRowIndexCurrent
    XDEF    _GCOMMAND_ActiveMsgSavedField20
    XDEF    _GCOMMAND_ActiveMsgSavedField24
    XDEF    _GCOMMAND_ActiveMsgSavedField28
    XDEF    _ESQSHARED4_InterleaveCopyBaseOffset
    XDEF    _ESQSHARED4_InterleaveCopyTailOffsetCurrent
    XDEF    _ESQSHARED4_InterleaveCopyTailOffsetReset
    XDEF    _Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE
    XDEF    _Global_REF_DATA_INPUT_BUFFER
    XDEF    _Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE
    XDEF    _Global_REF_INPUTDEVICE_MSGPORT
    XDEF    _Global_REF_CONSOLEDEVICE_MSGPORT
    XDEF    _DISKIO_Drive0WriteProtectedCode
    XDEF    _DISKIO_DriveWriteProtectStatusCodeDrive1
    XDEF    _DISKIO_DriveMediaStatusCodeTable
    XDEF    _ED_StateRingWriteIndex
    XDEF    _ED_StateRingIndex
    XDEF    _ED_StateRingTable
    XDEF    _INPUTDEVICE_LibraryBaseFromConsoleIo
    XDEF    _INPUTDEVICE_HandlerUserDataLong
    XDEF    _LADFUNC_SaveAdsFileHandle
    XDEF    _LOCAVAIL_PrimaryFilterState
    XDEF    _LOCAVAIL_PrimaryFilterState_Field08
    XDEF    _LOCAVAIL_PrimaryFilterState_Field0C
    XDEF    _LOCAVAIL_SecondaryFilterState
    XDEF    _LOCAVAIL_FilterCooldownTicks
    XDEF    _Global_REF_BACKED_UP_INTUITION_AUTOREQUEST
    XDEF    _Global_REF_BACKED_UP_INTUITION_DISPLAYALERT
    XDEF    _NEWGRID_RowHeightPx
    XDEF    _NEWGRID_SampleTimeTextWidthPx
    XDEF    _NEWGRID_ColumnStartXPx
    XDEF    _NEWGRID_ColumnWidthPx
    XDEF    _NEWGRID_RowLayoutCommitPenId
    XDEF    _NEWGRID_SelectionMarkerPenState
    XDEF    _NEWGRID_HeaderFramePenId
    XDEF    _NEWGRID_ShowtimesSelectionContextPtr
    XDEF    _NEWGRID_ShowtimesWorkflowArgLong
    XDEF    _NEWGRID_ShowtimesWorkflowArgWord
    XDEF    _NEWGRID2_ShowtimesSelectionContextPtr
    XDEF    _NEWGRID_SelectedGridEntryPtr
    XDEF    _NEWGRID_OverridePenIndex
    XDEF    _NEWGRID_EntryTextScratchPtr
    XDEF    _NEWGRID_ShowtimeBucketEntryTable
    XDEF    _NEWGRID_ShowtimeBucketEntryTablePadLong
    XDEF    _NEWGRID_ShowtimeBucketPtrTable
    XDEF    _NEWGRID_ShowtimeBucketCount
    XDEF    _FLIB_LogEntryByteCount
    XDEF    _P_TYPE_PrimaryGroupListPtr
    XDEF    _P_TYPE_SecondaryGroupListPtr
    XDEF    _PARSEINI_CurrentWeatherBlockPtr
    XDEF    _PARSEINI_WeatherBrushNodePtr
    XDEF    _GCOMMAND_GradientPresetTable
    XDEF    _CTRL_BUFFER
    XDEF    _SCRIPT_SerialShadowWord
    XDEF    _SCRIPT_SerialInputLatch
    XDEF    _SCRIPT_CtrlLineAssertedTicks
    XDEF    _Global_WORD_CLOCK_SECONDS
    XDEF    _SCRIPT_CTRL_STATE
    XDEF    _SCRIPT_RuntimeMode
    XDEF    _SCRIPT_CtrlCmdCount
    XDEF    _SCRIPT_CtrlCmdChecksumErrorCount
    XDEF    _SCRIPT_CtrlCmdLengthErrorCount
    XDEF    _Global_RefreshTickCounter
    XDEF    _TEXTDISP_PrimarySearchText
    XDEF    _TEXTDISP_SecondarySearchText
    XDEF    _TEXTDISP_PrimaryChannelCode
    XDEF    _TEXTDISP_SecondaryChannelCode
    XDEF    _SCRIPT_ChannelRangeDigitChar
    XDEF    _SCRIPT_SearchMatchCountOrIndex
    XDEF    _SCRIPT_PlaybackCursor
    XDEF    _SCRIPT_BannerTransitionTargetChar
    XDEF    _SCRIPT_BannerTransitionStepDelta
    XDEF    _SCRIPT_BannerTransitionStepSign
    XDEF    _SCRIPT_CTRL_CONTEXT
    XDEF    _SCRIPT_PrimarySearchFirstFlag
;------------------------------------------------------------------------------
; SYM: _GCOMMAND_PPVListingsTemplatePtr/_GCOMMAND_PPVPeriodTemplatePtr   (Digital PPV template strings)
; TYPE: pointer/pointer
; PURPOSE: Owns the assembled PPV listings and PPV period template strings.
; USED BY: FLIB2 init helpers, GCOMMAND_PPV parsing/formatting paths
; NOTES: Reinitialized alongside other command template pointers.
;------------------------------------------------------------------------------
_GCOMMAND_PPVListingsTemplatePtr:
    DS.L    1
_GCOMMAND_PPVPeriodTemplatePtr:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _GCOMMAND_PpvShowtimesRowSpan   (PPV showtimes row span)
; TYPE: s32
; PURPOSE: Additional row span added to the current row when NEWGRID builds PPV showtimes buckets.
; USED BY: _FLIB2_LoadDigitalPpvDefaults, _GCOMMAND_ParsePPVCommand, _NEWGRID_BuildShowtimesText
; NOTES: Parsed from a 2-char numeric option and clamped to <= 96 by parser logic.
;------------------------------------------------------------------------------
_GCOMMAND_PpvShowtimesRowSpan:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _GCOMMAND_DefaultPresetTable   (default preset table)
; TYPE: u16[16]
; PURPOSE: Default preset values consumed by GCOMMAND preset increment/validation paths.
; USED BY: _GCOMMAND_InitPresetDefaults, _GCOMMAND_ComputePresetIncrement, _GCOMMAND_ValidatePresetTable
; NOTES: Copied from validated preset sources and used as fallback baseline values.
;------------------------------------------------------------------------------
_GCOMMAND_DefaultPresetTable:
    DS.L    8
;------------------------------------------------------------------------------
; SYM: _GCOMMAND_PresetValueTable   (preset value matrix)
; TYPE: u16[16][64]
; PURPOSE: Stores preset curve/value rows consumed by banner build/update logic.
; USED BY: _GCOMMAND_SetPresetEntry, _GCOMMAND_ExpandPresetBlock, _GCOMMAND_BuildBannerBlock
; NOTES: Rows are addressed with `ASL #7` (128-byte stride); values are read as words.
;------------------------------------------------------------------------------
_GCOMMAND_PresetValueTable:
    DS.L    512
;------------------------------------------------------------------------------
; SYM: _GCOMMAND_PresetWorkEntryTable   (highlight preset work entries)
; TYPE: struct[4]
; PURPOSE: Runtime table for preset timing/accumulator state used by banner highlight updates.
; USED BY: _GCOMMAND_ResetPresetWorkTables, _GCOMMAND_LoadPresetWorkEntries, _GCOMMAND_TickPresetWorkEntries
; NOTES: Four entries, each 24 bytes.
;        Entry0 starts at _GCOMMAND_PresetWorkEntryTable; entry1/2/3 start at
;        _GCOMMAND_PresetWorkEntry1/2/3. The *_ValueIndex aliases map to offset +8
;        in each entry and are read by banner rebuild/draw paths.
;------------------------------------------------------------------------------
_GCOMMAND_PresetWorkEntryTable:
    DS.L    2
_GCOMMAND_PresetWorkEntry0_ValueIndex:
    DS.L    4
_GCOMMAND_PresetWorkEntry1:  
    DS.L    2
_GCOMMAND_PresetWorkEntry1_ValueIndex:
    DS.L    4
_GCOMMAND_PresetWorkEntry2:
    DS.L    2
_GCOMMAND_PresetWorkEntry2_ValueIndex:
    DS.L    4
_GCOMMAND_PresetWorkEntry3:
    DS.L    2
_GCOMMAND_PresetWorkEntry3_ValueIndex:
    DS.L    4
; Tracks whether the digital banner highlight is enabled (0/1).
_GCOMMAND_HighlightFlag:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _GCOMMAND_BannerBoundLeft/_GCOMMAND_BannerBoundTop/_GCOMMAND_BannerBoundRight/_GCOMMAND_BannerBoundBottom   (cached banner bounds)
; TYPE: s32/s32/s32/s32
; PURPOSE: Cached geometry bounds supplied through _GCOMMAND_UpdateBannerBounds.
; USED BY: _GCOMMAND_UpdateBannerBounds, _GCOMMAND_RebuildBannerTablesFromBounds
; NOTES: Updated atomically before requesting a banner-table rebuild.
;------------------------------------------------------------------------------
_GCOMMAND_BannerBoundLeft:
    DS.L    1
_GCOMMAND_BannerBoundTop:
    DS.L    1
_GCOMMAND_BannerBoundRight:
    DS.L    1
_GCOMMAND_BannerBoundBottom:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _GCOMMAND_BannerStepLeft/_GCOMMAND_BannerStepTop/_GCOMMAND_BannerStepRight/_GCOMMAND_BannerStepBottom   (cached preset increments)
; TYPE: s32/s32/s32/s32
; PURPOSE: Precomputed per-bound increments derived from cached banner bounds.
; USED BY: _GCOMMAND_UpdateBannerBounds, _GCOMMAND_RebuildBannerTablesFromBounds
; NOTES: Produced by _GCOMMAND_ComputePresetIncrement with a mode-dependent seed.
;------------------------------------------------------------------------------
_GCOMMAND_BannerStepLeft:
    DS.L    1
_GCOMMAND_BannerStepTop:
    DS.L    1
_GCOMMAND_BannerStepRight:
    DS.L    1
_GCOMMAND_BannerStepBottom:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _GCOMMAND_BannerRowByteOffsetCurrent/_GCOMMAND_BannerRowByteOffsetPrevious   (banner row byte offsets)
; TYPE: s32/s32
; PURPOSE: Tracks current/previous byte offsets used when rebuilding banner rows.
; USED BY: _GCOMMAND_RefreshBannerTables, _GCOMMAND_TickHighlightState, ESQSHARED4 blit helpers
; NOTES: Current offset advances in fixed strides and wraps with the highlight cycle.
;------------------------------------------------------------------------------
_GCOMMAND_BannerRowByteOffsetCurrent:
    DS.L    1
_GCOMMAND_BannerRowByteOffsetPrevious:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _GCOMMAND_BannerQueueSlotPrevious/_GCOMMAND_BannerQueueSlotCurrent   (banner queue slot indices)
; TYPE: u16/u16
; PURPOSE: Tracks previous/current byte slot indices into _ESQPARS2_BannerQueueBuffer banner queue storage.
; USED BY: _GCOMMAND_MapKeycodeToPreset, _GCOMMAND_ConsumeBannerQueueEntry, _GCOMMAND_TickHighlightState
; NOTES: Decrements each tick with wrap at 97 (`$61`).
;------------------------------------------------------------------------------
_GCOMMAND_BannerQueueSlotPrevious:
    DS.W    1
_GCOMMAND_BannerQueueSlotCurrent:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _GCOMMAND_BannerRowIndexPrevious/_GCOMMAND_BannerRowIndexCurrent   (banner row indices)
; TYPE: s32/s32
; PURPOSE: Tracks previous/current row indices while rotating banner copper row pointers.
; USED BY: _GCOMMAND_UpdateBannerRowPointers, _GCOMMAND_UpdateBannerOffset, _GCOMMAND_BuildBannerTables
; NOTES: Current index wraps in range 0..97; previous snapshots prior value for pointer updates.
;------------------------------------------------------------------------------
_GCOMMAND_BannerRowIndexPrevious:
    DS.L    1
_GCOMMAND_BannerRowIndexCurrent:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _GCOMMAND_ActiveMsgSavedField20/_GCOMMAND_ActiveMsgSavedField24/_GCOMMAND_ActiveMsgSavedField28   (active highlight-message saved fields)
; TYPE: u32/u32/u32
; PURPOSE: Temporarily stores active highlight-message payload longs while banner/preset processing mutates message state.
; USED BY: _GCOMMAND_ServiceHighlightMessages, _GCOMMAND_ResetHighlightMessages
; NOTES: Values are copied from message offsets +20/+24/+28 and restored before reply/reset.
;------------------------------------------------------------------------------
_GCOMMAND_ActiveMsgSavedField20:
    DS.L    1
_GCOMMAND_ActiveMsgSavedField24:
    DS.L    1
_GCOMMAND_ActiveMsgSavedField28:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _ESQSHARED4_InterleaveCopyBaseOffset/_ESQSHARED4_InterleaveCopyTailOffsetCurrent/_ESQSHARED4_InterleaveCopyTailOffsetReset   (banner interleave-copy offsets)
; TYPE: u32/u32/u32
; PURPOSE:
;   `...BaseOffset` is the fixed start offset for interleaved row-word copy passes.
;   `...TailOffsetCurrent` advances each tick to select the final tail source row.
;   `...TailOffsetReset` seeds/reset value copied back into current on wrap/rebuild.
; USED BY: _GCOMMAND_ResetBannerFadeState, _GCOMMAND_BuildBannerTables, _GCOMMAND_TickHighlightState, _ESQSHARED4_CopyInterleavedRowWordsFromOffset
; NOTES: Current known reset constants are 128 (base) and 128+0x264 (tail reset).
;------------------------------------------------------------------------------
_ESQSHARED4_InterleaveCopyBaseOffset:
    DS.L    1
_ESQSHARED4_InterleaveCopyTailOffsetCurrent:
    DS.L    1
_ESQSHARED4_InterleaveCopyTailOffsetReset:
    DS.L    1
    DS.W    1
_Global_REF_IOSTDREQ_STRUCT_INPUT_DEVICE:
    DS.L    1
_Global_REF_DATA_INPUT_BUFFER:
    DS.L    1
_Global_REF_IOSTDREQ_STRUCT_CONSOLE_DEVICE:
    DS.L    1
_Global_REF_INPUTDEVICE_MSGPORT:
    DS.L    1
_Global_REF_CONSOLEDEVICE_MSGPORT:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _DISKIO_Drive0WriteProtectedCode/_DISKIO_DriveWriteProtectStatusCodeDrive1/_DISKIO_DriveMediaStatusCodeTable   (per-drive probe status tables)
; TYPE: s32/s32[3]/s32[4]
; PURPOSE:
;   `_DISKIO_Drive0WriteProtectedCode` is drive-0 entry in a write-protect/probe-status table.
;   `_DISKIO_DriveWriteProtectStatusCodeDrive1` provides drive1..drive3 companion entries.
;   `_DISKIO_DriveMediaStatusCodeTable` stores secondary per-drive media-status probe codes.
; USED BY: _DISKIO_ProbeDrivesAndAssignPaths, ESQ startup warning path, ESQIFF external-asset reload gating, _ESQFUNC_UpdateDiskWarningAndRefreshTick
; NOTES:
;   Tables are indexed by drive number with `ASL #2`.
;   Callers often treat drive-0 entries as boolean gates, but raw probe codes are preserved.
;------------------------------------------------------------------------------
_DISKIO_Drive0WriteProtectedCode:
    DS.L    1
_DISKIO_DriveWriteProtectStatusCodeDrive1:
    DS.L    3
_DISKIO_DriveMediaStatusCodeTable:
    DS.L    4
;------------------------------------------------------------------------------
; SYM: _ED_StateRingWriteIndex   (editor state-ring write index)
; TYPE: s32
; PURPOSE: Producer index into _ED_StateRingTable for newly queued control/input events.
; USED BY: _GCOMMAND_ProcessCtrlCommand, APP2 input staging, ED dispatcher gate
; NOTES: Advanced modulo $14; _ED_StateRingIndex is the consumer side.
;------------------------------------------------------------------------------
_ED_StateRingWriteIndex:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _ED_StateRingIndex   (editor state ring index)
; TYPE: s32
; PURPOSE: Current write/read index into _ED_StateRingTable.
; USED BY: ED_*, ED1_*, ED2_*, ED3_*, KYBD_*
; NOTES: Advanced modulo $14 in editor dispatch paths.
;------------------------------------------------------------------------------
_ED_StateRingIndex:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _ED_StateRingTable   (editor state ring table)
; TYPE: s32[]
; PURPOSE: Ring buffer backing store for editor state/history entries.
; USED BY: ED_*, ED1_*, ED2_*, ED3_*, KYBD_*
; NOTES: Indexed via _ED_StateRingIndex.
;------------------------------------------------------------------------------
_ED_StateRingTable:
    DS.L    25
;------------------------------------------------------------------------------
; SYM: _INPUTDEVICE_LibraryBaseFromConsoleIo/_INPUTDEVICE_HandlerUserDataLong   (input-handler call context)
; TYPE: pointer/u32[2]
; PURPOSE:
;   `_INPUTDEVICE_LibraryBaseFromConsoleIo` caches the console-device library base used by _EXEC_CallVector_48.
;   `_INPUTDEVICE_HandlerUserDataLong` is the handler user-data storage pointer wired into the 22-byte input-handler struct.
; USED BY: _KYBD_InitializeInputDevices, _EXEC_CallVector_48
; NOTES:
;   `_INPUTDEVICE_HandlerUserDataLong` address is written to handler struct offset +14 (`is_Data`-style field).
;------------------------------------------------------------------------------
_INPUTDEVICE_LibraryBaseFromConsoleIo:
    DS.L    1
_INPUTDEVICE_HandlerUserDataLong:
    DS.L    2
;------------------------------------------------------------------------------
; SYM: _LADFUNC_SaveAdsFileHandle   (LAD text-ads save file handle)
; TYPE: pointer/handle
; PURPOSE: File handle used while serializing LAD text ads to `df0:local.ads`.
; USED BY: _LADFUNC_SaveTextAdsToFile
; NOTES: Opened via _DISKIO_OpenFileWithBuffer and consumed by _DISKIO_WriteBufferedBytes/_DISKIO_WriteDecimalField/_DISKIO_CloseBufferedFileAndFlush I/O helpers.
;------------------------------------------------------------------------------
_LADFUNC_SaveAdsFileHandle:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _LOCAVAIL_PrimaryFilterState/_LOCAVAIL_SecondaryFilterState   (locavail filter state structs)
; TYPE: struct/struct
; PURPOSE: Persistent filter/scan state blocks for primary and secondary locavail group handling.
; USED BY: LOCAVAIL_*, ESQPARS_*, ESQFUNC_*, CLEANUP_*, ED1_*, SCRIPT3_*
; NOTES: Accessed via struct-style offsets (e.g. +8/+12/+20), so adjacent storage is part of the layout.
;------------------------------------------------------------------------------
_LOCAVAIL_PrimaryFilterState:
    DS.L    2
_LOCAVAIL_PrimaryFilterState_Field08:
    DS.L    1
_LOCAVAIL_PrimaryFilterState_Field0C:
    DS.L    1
_LOCAVAIL_PrimaryFilterState_Field10:
    DS.L    1
_LOCAVAIL_PrimaryFilterState_Field14:
    DS.L    1
_LOCAVAIL_SecondaryFilterState:
    DS.L    6
_LOCAVAIL_FilterCooldownTicks:
    DS.L    1
_Global_REF_BACKED_UP_INTUITION_AUTOREQUEST:
    DS.L    1
_Global_REF_BACKED_UP_INTUITION_DISPLAYALERT:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _NEWGRID_RowHeightPx   (grid row height in pixels)
; TYPE: u16
; PURPOSE: Pixel height of one NEWGRID row cell.
; USED BY: NEWGRID_* layout and rendering helpers
; NOTES: Derived from active font metrics during grid initialization.
;------------------------------------------------------------------------------
_NEWGRID_RowHeightPx:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _NEWGRID_SampleTimeTextWidthPx   (sample "44:44:44" text width)
; TYPE: u16
; PURPOSE: Cached width of sample time text used during grid geometry setup.
; USED BY: _NEWGRID_InitGridResources
; NOTES: Baseline used to compute _NEWGRID_ColumnStartXPx.
;------------------------------------------------------------------------------
_NEWGRID_SampleTimeTextWidthPx:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _NEWGRID_ColumnStartXPx   (left edge of first data column)
; TYPE: u16
; PURPOSE: Horizontal pixel offset where NEWGRID data columns begin.
; USED BY: _NEWGRID_DrawClockFormatHeader, NEWGRID date/header rendering
; NOTES: Computed from _NEWGRID_SampleTimeTextWidthPx plus padding.
;------------------------------------------------------------------------------
_NEWGRID_ColumnStartXPx:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _NEWGRID_ColumnWidthPx   (per-column width in pixels)
; TYPE: u16
; PURPOSE: Width of each day/time column in the NEWGRID header/body.
; USED BY: NEWGRID_* column layout loops
; NOTES: Computed from available width and number of columns.
;------------------------------------------------------------------------------
_NEWGRID_ColumnWidthPx:
    DS.W    1
_NEWGRID_RowLayoutCommitPenId:
    DS.L    1
_NEWGRID_SelectionMarkerPenState:
    DS.L    1
_NEWGRID_HeaderFramePenId:
    DS.L    1
_NEWGRID_ShowtimesSelectionContextPtr:
    DS.L    2
;------------------------------------------------------------------------------
; SYM: _NEWGRID_ShowtimesWorkflowArgLong/_NEWGRID_ShowtimesWorkflowArgWord   (showtimes state latch cluster ??)
; TYPE: s32[4] + s32 + u16
; PURPOSE: Auxiliary showtimes workflow state passed through NEWGRID state transitions.
; USED BY: _NEWGRID_ProcessShowtimesWorkflow, _NEWGRID_UpdateGridState
; NOTES:
;   Callers pass these slots as workflow arguments; producer semantics still unresolved.
;------------------------------------------------------------------------------
_NEWGRID_ShowtimesWorkflowArgLong:
    DS.L    3
_NEWGRID_ShowtimesWorkflowArgWord:
    DS.L    1
    DS.W    1
_NEWGRID2_ShowtimesSelectionContextPtr:
    DS.L    6
    DS.W    1
_NEWGRID_SelectedGridEntryPtr:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _NEWGRID_OverridePenIndex   (newgrid override pen index)
; TYPE: s32
; PURPOSE: Holds temporary color/pen override selected while drawing current grid entry.
; USED BY: _NEWGRID_SelectEntryPen, _NEWGRID_ProcessGridEntries
; NOTES: Clamped to 1..3 by _NEWGRID_SelectEntryPen before cell drawing consumes it.
;------------------------------------------------------------------------------
_NEWGRID_OverridePenIndex:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _NEWGRID_EntryTextScratchPtr   (newgrid entry text scratch pointer)
; TYPE: pointer
; PURPOSE: Heap buffer used as staging text while NEWGRID formats/splits per-entry display lines.
; USED BY: _NEWGRID_DrawGridEntry, _NEWGRID2_EnsureBuffersAllocated, _NEWGRID2_FreeBuffersIfAllocated
; NOTES: Allocated as 1000 bytes in _NEWGRID2_EnsureBuffersAllocated.
;------------------------------------------------------------------------------
_NEWGRID_EntryTextScratchPtr:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _NEWGRID_ShowtimeBucketEntryTable/_NEWGRID_ShowtimeBucketEntryTablePadLong/_NEWGRID_ShowtimeBucketPtrTable   (showtime bucket storage)
; TYPE: struct[10]/pointer[10]
; PURPOSE: Stores normalized showtime bucket records and a sortable pointer index table.
; USED BY: _NEWGRID_ResetShowtimeBuckets, _NEWGRID_AddShowtimeBucketEntry, _NEWGRID_AppendShowtimeBuckets
; NOTES: Entry records contain a packed key plus text pointer; pointer table supports insertion-sorted ordering.
;------------------------------------------------------------------------------
_NEWGRID_ShowtimeBucketEntryTable:
    DS.L    19
_NEWGRID_ShowtimeBucketEntryTablePadLong:
    DS.L    1
_NEWGRID_ShowtimeBucketPtrTable:
    DS.L    10
;------------------------------------------------------------------------------
; SYM: _NEWGRID_ShowtimeBucketCount   (showtime bucket count)
; TYPE: s32
; PURPOSE: Current number of active entries in NEWGRID showtime bucket arrays.
; USED BY: _NEWGRID_ResetShowtimeBuckets, _NEWGRID_AddShowtimeBucketEntry, _NEWGRID_AppendShowtimeBuckets
; NOTES: Clamped to a max of 10 entries.
;------------------------------------------------------------------------------
_NEWGRID_ShowtimeBucketCount:
    DS.L    1
_FLIB_LogEntryByteCount:
    DS.L    2
;------------------------------------------------------------------------------
; SYM: _P_TYPE_PrimaryGroupListPtr/_P_TYPE_SecondaryGroupListPtr   (p_type group list pointers)
; TYPE: pointer/pointer
; PURPOSE: Holds parsed P_TYPE list objects for the primary and secondary group codes.
; USED BY: P_TYPE_*
; NOTES: Secondary may be staged then promoted into primary during list rollover.
;------------------------------------------------------------------------------
_P_TYPE_PrimaryGroupListPtr:
    DS.L    1
_P_TYPE_SecondaryGroupListPtr:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _PARSEINI_CurrentWeatherBlockPtr   (current weather block struct pointer)
; TYPE: pointer
; PURPOSE: Points to the weather/display config block currently being populated.
; USED BY: _PARSEINI_ProcessWeatherBlocks
; NOTES: Set by brush-node allocation when parsing filename/loadcolor blocks.
;------------------------------------------------------------------------------
_PARSEINI_CurrentWeatherBlockPtr:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _PARSEINI_WeatherBrushNodePtr   (weather brush node pointer)
; TYPE: pointer
; PURPOSE: Tracks the most recently allocated weather brush node during parsing.
; USED BY: _PARSEINI_LoadWeatherStrings
; NOTES: Cleared when the banner brush resource list is empty.
;------------------------------------------------------------------------------
_PARSEINI_WeatherBrushNodePtr:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _GCOMMAND_GradientPresetTable   (gradient preset table)
; TYPE: s32[520]
; PURPOSE: Stores gradient preset values parsed from the [gradient] INI section.
; USED BY: _PARSEINI_ParseIniBufferAndDispatch, _GCOMMAND_InitPresetTableFromPalette
; NOTES:
;   Table length is 520 longs (2080 bytes).
;   Current traced writers/readers are parse-time only (`PARSEINI_*` + initializer/
;   validator helpers passed this table pointer). No direct runtime banner consumer
;   has been confirmed yet in named-symbol call paths.
;------------------------------------------------------------------------------
_GCOMMAND_GradientPresetTable:
    DS.L    520
_CTRL_BUFFER:
    DS.L    125
;------------------------------------------------------------------------------
; SYM: _SCRIPT_SerialShadowWord/_SCRIPT_SerialInputLatch   (serial control shadow)
; TYPE: u16/u16
; PURPOSE: Shadow copy of serial control word plus most recent latched input bits.
; USED BY: _SCRIPT_AssertCtrlLine*, _SCRIPT_DeassertCtrlLine*, _SCRIPT_WriteCtrlShadowToSerdat
; NOTES: CTRL-line assert/deassert toggles bit 5 in _SCRIPT_SerialShadowWord before writing SERDAT.
;------------------------------------------------------------------------------
_SCRIPT_SerialShadowWord:
    DS.W    1
_SCRIPT_SerialInputLatch:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _SCRIPT_CtrlLineAssertedTicks   (ctrl-line asserted tick counter)
; TYPE: s16 (stored in long slot)
; PURPOSE: Counts ticks while the CTRL line remains asserted.
; USED BY: _SCRIPT_PollHandshakeAndApplyTimeout
; NOTES: Reset to 0 after reaching the timeout threshold.
;------------------------------------------------------------------------------
_SCRIPT_CtrlLineAssertedTicks:
    DS.L    1
_Global_WORD_CLOCK_SECONDS:
    DS.W    1
_SCRIPT_CTRL_STATE:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _SCRIPT_RuntimeMode   (script runtime mode/state)
; TYPE: u16
; PURPOSE: Current script engine mode used by SCRIPT3/TEXTDISP2 flows.
; USED BY: SCRIPT3_*, TEXTDISP2_*, ED1_*, ESQFUNC_*, ESQIFF2_*
; NOTES: Frequently switched among small integer mode ids.
;------------------------------------------------------------------------------
_SCRIPT_RuntimeMode:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _SCRIPT_CtrlCmdCount/_SCRIPT_CtrlCmdChecksumErrorCount/_SCRIPT_CtrlCmdLengthErrorCount   (CTRL command counters)
; TYPE: u16/u16/u16
; PURPOSE: Tracks CTRL command totals plus checksum and length error counts.
; USED BY: _SCRIPT_HandleSerialCtrlCmd, _ESQFUNC_DrawMemoryStatusScreen, _ED2_HandleDiagnosticsMenuActions
; NOTES: "LERRS" increments when CTRL buffer length exceeds 198 bytes.
;------------------------------------------------------------------------------
_SCRIPT_CtrlCmdCount:
    DS.W    1
_SCRIPT_CtrlCmdChecksumErrorCount:
    DS.W    1
_SCRIPT_CtrlCmdLengthErrorCount:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _Global_RefreshTickCounter   (global refresh tick counter)
; TYPE: s16
; PURPOSE: Tick counter for periodic refresh/redraw scheduling.
; USED BY: TEXTDISP2_*, SCRIPT3_*, ESQFUNC_*, DISKIO_*, APP2_*
; NOTES: Uses -1 sentinel in several callers.
;------------------------------------------------------------------------------
_Global_RefreshTickCounter:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _TEXTDISP_PrimarySearchText/_TEXTDISP_SecondarySearchText   (search text buffers)
; TYPE: char[200]/char[200]
; PURPOSE: Stores primary and secondary search text used by text display filtering.
; USED BY: TEXTDISP_*, SCRIPT3_*, CLEANUP3_*
; NOTES: Declared as 50 longs each (200 bytes); treated as C-style byte strings.
;------------------------------------------------------------------------------
_TEXTDISP_PrimarySearchText:
    DS.L    50
_TEXTDISP_SecondarySearchText:
    DS.L    50
;------------------------------------------------------------------------------
; SYM: _TEXTDISP_PrimaryChannelCode/_TEXTDISP_SecondaryChannelCode   (active channel-code pair)
; TYPE: u16/u16
; PURPOSE: Stores active primary/secondary channel code values used by text/display script flows.
; USED BY: TEXTDISP_*, SCRIPT3_*, CLEANUP3_*
; NOTES: Defaults and clamping are applied in TEXTDISP dispatch code before channel-table lookups.
;------------------------------------------------------------------------------
_TEXTDISP_PrimaryChannelCode:
    DS.W    1
_TEXTDISP_SecondaryChannelCode:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _SCRIPT_ChannelRangeDigitChar   (channel-range digit char)
; TYPE: u8 (stored in word slot)
; PURPOSE: Captures the channel-range digit parsed from script control buffers.
; USED BY: _SCRIPT_HandleBrushCommand, playback aligned-status render paths
; NOTES: Stored as ASCII digit; '0' disables the channel-range path.
;------------------------------------------------------------------------------
_SCRIPT_ChannelRangeDigitChar:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _SCRIPT_SearchMatchCountOrIndex   (search match count/index ??)
; TYPE: s32
; PURPOSE: Stores the selection argument passed into _SCRIPT_SelectPlaybackCursorFromSearchText.
; USED BY: _SCRIPT_SelectPlaybackCursorFromSearchText, _SCRIPT_LoadCtrlContextSnapshot, _SCRIPT_SaveCtrlContextSnapshot
; NOTES: Passed through to _CLEANUP_RenderAlignedStatusScreen (usage uncertain).
;------------------------------------------------------------------------------
_SCRIPT_SearchMatchCountOrIndex:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _SCRIPT_PlaybackCursor   (script playback cursor/state value)
; TYPE: s32
; PURPOSE: Tracks active script playback/progression position/state.
; USED BY: SCRIPT3_* state handlers
; NOTES: Saved/restored with SCRIPT context structs.
;------------------------------------------------------------------------------
_SCRIPT_PlaybackCursor:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _SCRIPT_BannerTransitionTargetChar/_SCRIPT_BannerTransitionStepDelta/_SCRIPT_BannerTransitionStepSign   (banner transition params)
; TYPE: u8/s16/s16
; PURPOSE: Stores the target banner character plus per-tick step data.
; USED BY: _SCRIPT_BeginBannerCharTransition, _SCRIPT_UpdateBannerCharTransition, _SCRIPT_PrimeBannerTransitionFromHexCode
; NOTES: Step delta is signed after applying the sign value.
;------------------------------------------------------------------------------
_SCRIPT_BannerTransitionTargetChar:
    DS.W    1
_SCRIPT_BannerTransitionStepDelta:
    DS.W    1
_SCRIPT_BannerTransitionStepSign:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _SCRIPT_CTRL_CONTEXT   (CtrlContextStruct_uncertain)
; TYPE: struct
; PURPOSE: Control/script context storage used by script control handlers.
; USED BY: _SCRIPT_InitCtrlContext, _SCRIPT_SetCtrlContextMode, _SCRIPT_ResetCtrlContext
; NOTES: Size = 112 longs (448 bytes). Field meanings largely unknown.
;------------------------------------------------------------------------------
_SCRIPT_CTRL_CONTEXT:
    DS.L    112
;------------------------------------------------------------------------------
; SYM: _SCRIPT_PrimarySearchFirstFlag   (script search-order flag)
; TYPE: u16
; PURPOSE: Selects whether script-driven lookup checks primary search first.
; USED BY: SCRIPT3 state/serialization handlers, _TEXTDISP_SelectGroupAndEntry dispatch wrapper
; NOTES: Toggled by script command bytes (`L`/`R`) and persisted in script state blobs.
;------------------------------------------------------------------------------
_SCRIPT_PrimarySearchFirstFlag:
    DS.W    1