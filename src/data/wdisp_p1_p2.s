    XDEF    _SCRIPT_ChannelRangeArmedFlag
    XDEF    _TEXTDISP_FilterCandidateCursor
    XDEF    _TEXTDISP_FilterChannelSlotIndex
    XDEF    _TEXTDISP_FilterMatchCount
    XDEF    _TEXTDISP_FilterPpvSbeMatchFlag
    XDEF    _TEXTDISP_FilterSportsMatchFlag
    XDEF    _TEXTDISP_StatusGroupId
    XDEF    _TEXTDISP_SourceConfigEntryTable
    XDEF    _TEXTDISP_SourceConfigEntryCount
    XDEF    _TEXTDISP_PrimaryFirstMatchIndex
    XDEF    _TEXTDISP_SecondaryFirstMatchIndex
    XDEF    _TEXTDISP_EntryTextBaseWidthPx
    XDEF    _ESQ_GlobalTickCounter
    XDEF    _TEXTDISP_CurrentMatchIndex
    XDEF    _TEXTDISP_ChannelSourceMode
    XDEF    _CLEANUP_AlignedStatusSuffixBuffer
    XDEF    _CLEANUP_AlignedStatusClockEntryBuffer
    XDEF    _CLEANUP_AlignedStatusMatchIndex
    XDEF    _CLEANUP_AlignedStatusClockEntryIndex
    XDEF    _CLEANUP_AlignedStatusEntryCycleTable
    XDEF    _TEXTDISP_EntryShortNameScratch
    XDEF    _TEXTDISP_LinePenOverrideEnabledFlag
    XDEF    _TEXTDISP_LinePenOverrideStateWord
    XDEF    _TEXTDISP_CurrentMatchIndexSaved
    XDEF    _TEXTDISP_SbeFilterActiveFlag
    XDEF    _TEXTDISP_FindModeActiveFlag
    XDEF    _TEXTDISP_CandidateIndexList
    XDEF    _TEXTDISP_BannerFallbackEntryIndex
    XDEF    _TEXTDISP_BannerCharFallback
    XDEF    _TEXTDISP_BannerFallbackIsSpecialFlag
    XDEF    _TEXTDISP_BannerFallbackValidFlag
    XDEF    _TEXTDISP_BannerSelectedEntryIndex
    XDEF    _TEXTDISP_BannerCharSelected
    XDEF    _TEXTDISP_BannerSelectedIsSpecialFlag
    XDEF    _TEXTDISP_BannerSelectedValidFlag
    XDEF    _TEXTDISP_ChannelLabelReadyFlag
    XDEF    _TLIBA2_BroadcastWindowClockSnapshotA
    XDEF    _TLIBA2_BroadcastWindowClockSnapshotB
    XDEF    _TLIBA2_BroadcastWindowClockSnapshotC
    XDEF    _TLIBA3_VmArrayRuntimeTable
    XDEF    _TLIBA3_VmArrayPatternTable
    XDEF    _WDISP_WeatherCycleOffsetCount
    XDEF    _FORMAT_ScratchBuffer
;------------------------------------------------------------------------------
; SYM: _SCRIPT_ChannelRangeArmedFlag   (channel-range gate)
; TYPE: u16 (stored in long slot)
; PURPOSE: Enables channel-range parsing when set by script search selection.
; USED BY: _SCRIPT_SelectPlaybackCursorFromSearchText, _SCRIPT_HandleBrushCommand
; NOTES: Cleared when selection fails or playback cursor is forced.
;------------------------------------------------------------------------------
_SCRIPT_ChannelRangeArmedFlag:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _TEXTDISP_FilterCandidateCursor/_TEXTDISP_FilterChannelSlotIndex/_TEXTDISP_FilterMatchCount/_TEXTDISP_FilterPpvSbeMatchFlag/_TEXTDISP_FilterSportsMatchFlag   (filter state)
; TYPE: u16/u16/u16/u16/u16
; PURPOSE: Tracks filter scan cursor, channel slot, and match flags/counts.
; USED BY: _TEXTDISP_FilterAndSelectEntry
; NOTES: Channel slot advances up to $31 when scanning the candidate list.
;------------------------------------------------------------------------------
_TEXTDISP_FilterCandidateCursor:
    DS.W    1
_TEXTDISP_FilterChannelSlotIndex:
    DS.W    1
_TEXTDISP_FilterMatchCount:
    DS.W    1
_TEXTDISP_FilterPpvSbeMatchFlag:
    DS.W    1
_TEXTDISP_FilterSportsMatchFlag:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _TEXTDISP_StatusGroupId   (status line group id)
; TYPE: u16
; PURPOSE: Stores the group id used when building now/next status lines.
; USED BY: _TEXTDISP_HandleScriptCommand
; NOTES: Set to _TEXTDISP_ActiveGroupId or 0/1 fallback ids.
;------------------------------------------------------------------------------
_TEXTDISP_StatusGroupId:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _TEXTDISP_SourceConfigEntryTable/_TEXTDISP_SourceConfigEntryCount   (SourceCfg table)
; TYPE: pointer[302]/s32
; PURPOSE: Stores SourceCfg entry pointers and the active entry count.
; USED BY: _TEXTDISP_LoadSourceConfig, _TEXTDISP_ClearSourceConfig, _TEXTDISP_ApplySourceConfigToEntry
; NOTES: Each entry points to a 6-byte SourceCfg record.
;------------------------------------------------------------------------------
_TEXTDISP_SourceConfigEntryTable:
    DS.L    302
_TEXTDISP_SourceConfigEntryCount:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _TEXTDISP_PrimaryFirstMatchIndex/_TEXTDISP_SecondaryFirstMatchIndex   (first match indices)
; TYPE: u16/u16
; PURPOSE: Stores the first candidate index found for primary/secondary groups.
; USED BY: _TEXTDISP_SelectGroupAndEntry
; NOTES: Written from _TEXTDISP_CandidateIndexList[0] when matches exist.
;------------------------------------------------------------------------------
_TEXTDISP_PrimaryFirstMatchIndex:
    DS.W    1
_TEXTDISP_SecondaryFirstMatchIndex:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _TEXTDISP_EntryTextBaseWidthPx   (entry text base width)
; TYPE: s32
; PURPOSE: Base pixel width used when populating entry short/long name fields.
; USED BY: _TEXTDISP_SetEntryTextFields
; NOTES: Derived from _CONFIG_LRBN_FlagChar and _CONFIG_BannerCopperHeadByte.
;------------------------------------------------------------------------------
_TEXTDISP_EntryTextBaseWidthPx:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _ESQ_GlobalTickCounter   (global tick counter)
; TYPE: s16 (stored in long slot)
; PURPOSE: Global tick counter used to trigger periodic resets/reboots.
; USED BY: _ESQ_TickGlobalCounters, _TEXTDISP_TickDisplayState, ESQPARS Reset command
; NOTES: _ESQ_ColdReboot is invoked when the counter reaches $5460.
;------------------------------------------------------------------------------
_ESQ_GlobalTickCounter:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _TEXTDISP_CurrentMatchIndex   (current selected/matched entry index)
; TYPE: u16
; PURPOSE: Tracks the active entry index for text search/highlight operations.
; USED BY: _TEXTDISP_FindEntryIndexByWildcard and related draw/selection flows
; NOTES: Preserved/restored around searches via companion state words.
;------------------------------------------------------------------------------
_TEXTDISP_CurrentMatchIndex:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _TEXTDISP_ChannelSourceMode   (channel source mode selector)
; TYPE: u16
; PURPOSE: Selects primary vs secondary channel/search source for text-display range checks.
; USED BY: _TEXTDISP_UpdateChannelRangeFlags, SCRIPT3 save/restore command context, CLEANUP3 state restore
; NOTES: Current paths treat `1` as primary-source mode; non-1 selects secondary-source mode.
;------------------------------------------------------------------------------
_TEXTDISP_ChannelSourceMode:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _CLEANUP_AlignedStatusSuffixBuffer/_CLEANUP_AlignedStatusMatchIndex   (aligned status text state)
; TYPE: char[]/s16
; PURPOSE: Scratch suffix text and associated match index used by aligned status rendering.
; USED BY: _CLEANUP_RenderAlignedStatusScreen, _SCRIPT_HandleSerialCtrlCmd
; NOTES: Match index stores the fallback/current entry when _TEXTDISP_CurrentMatchIndex is temporarily invalid.
;------------------------------------------------------------------------------
_CLEANUP_AlignedStatusSuffixBuffer:
    DS.L    20
    DS.B    1
;------------------------------------------------------------------------------
; SYM: _CLEANUP_AlignedStatusClockEntryBuffer   (aligned-status clock entry buffer)
; TYPE: char[513]
; PURPOSE: Temporary formatted clock/status text buffer for aligned-status template codes.
; USED BY: _CLEANUP_RenderAlignedStatusScreen, _TLIBA1_BuildClockFormatEntryIfVisible
; NOTES: Cleared before formatter calls and copied into local title text when non-empty.
;------------------------------------------------------------------------------
_CLEANUP_AlignedStatusClockEntryBuffer:
    DS.B    1
    DS.L    128
_CLEANUP_AlignedStatusMatchIndex:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _CLEANUP_AlignedStatusClockEntryIndex   (aligned-status clock entry index)
; TYPE: s16
; PURPOSE: Selected entry index forwarded to TLIBA1 clock-format visibility helper.
; USED BY: _CLEANUP_RenderAlignedStatusScreen
; NOTES: `-1` indicates no selection; non-negative values represent entry/time slot IDs.
;------------------------------------------------------------------------------
_CLEANUP_AlignedStatusClockEntryIndex:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _CLEANUP_AlignedStatusEntryCycleTable   (aligned-status per-entry cycle index table)
; TYPE: u16[302]
; PURPOSE: Stores per-entry rolling index state used by template-code `E` scan/rotation logic.
; USED BY: _CLEANUP_RenderAlignedStatusScreen, ESQ startup init/reset
; NOTES: Indexed by `_TEXTDISP_CurrentMatchIndex * 2`; initialized to zero during startup.
;------------------------------------------------------------------------------
_CLEANUP_AlignedStatusEntryCycleTable:
    DS.L    151
;------------------------------------------------------------------------------
; SYM: _TEXTDISP_EntryShortNameScratch   (entry short-name scratch buffer)
; TYPE: char[80]
; PURPOSE: Temporary short-name string built before channel-label composition.
; USED BY: _TEXTDISP_DrawChannelBanner, CLEANUP3 aligned-status rebuild path
; NOTES: Filled by _TEXTDISP_BuildEntryShortName, then copied/concatenated into _TEXTDISP_ChannelLabelBuffer.
;------------------------------------------------------------------------------
_TEXTDISP_EntryShortNameScratch:
    DS.L    20
;------------------------------------------------------------------------------
; SYM: _TEXTDISP_LinePenOverrideEnabledFlag/_TEXTDISP_LinePenOverrideStateWord   (line-pen override state)
; TYPE: u16/u16
; PURPOSE: Controls per-line APen override in TLIBA1 text drawing path plus companion state/reset word.
; USED BY: _TEXTDISP_DrawChannelBanner, TEXTDISP_DrawTextDisplayFrame, CLEANUP3 aligned-status render, TLIBA1 text draw loop
; NOTES:
;   `_TEXTDISP_LinePenOverrideEnabledFlag` is tested in TLIBA1 draw loop (`TST.W`) to apply line pen-table values.
;   `_TEXTDISP_LinePenOverrideStateWord` is currently cleared by caller setup paths; no direct reader confirmed yet.
;------------------------------------------------------------------------------
_TEXTDISP_LinePenOverrideEnabledFlag:
    DS.W    1
_TEXTDISP_LinePenOverrideStateWord:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _TEXTDISP_CurrentMatchIndexSaved   (saved current match index)
; TYPE: u16
; PURPOSE: Snapshot of _TEXTDISP_CurrentMatchIndex used while scripts/cleanup temporarily override selection.
; USED BY: TEXTDISP3 startup reset, SCRIPT3 save/restore flows, CLEANUP3 restore path
; NOTES: Script command paths copy _TEXTDISP_CurrentMatchIndex into/out of this slot.
;------------------------------------------------------------------------------
_TEXTDISP_CurrentMatchIndexSaved:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _TEXTDISP_SbeFilterActiveFlag/_TEXTDISP_FindModeActiveFlag   (search-mode flags)
; TYPE: u16/u16
; PURPOSE: Tracks special wildcard modes while building candidate lists (`SBE` and `FIND1` flows).
; USED BY: _TEXTDISP_BuildMatchIndexList, _TEXTDISP_SelectBestMatchFromList, _TEXTDISP_SelectGroupAndEntry
; NOTES:
;   `_TEXTDISP_SbeFilterActiveFlag` is set when the SBE wildcard branch is active.
;   `_TEXTDISP_FindModeActiveFlag` is set when pattern prefix matches FIND1 and alters selection return behavior.
;------------------------------------------------------------------------------
_TEXTDISP_SbeFilterActiveFlag:
    DS.W    1
_TEXTDISP_FindModeActiveFlag:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _TEXTDISP_CandidateIndexList   (filtered entry index list)
; TYPE: u32[75]
; PURPOSE: Holds candidate entry indices produced by wildcard/filter searches.
; USED BY: _TEXTDISP_FindEntryIndexByWildcard, _TEXTDISP_BuildNowShowingStatusLine, SCRIPT3_*
; NOTES: Built during search passes, then consumed by status/banner rendering code.
;------------------------------------------------------------------------------
_TEXTDISP_CandidateIndexList:
    DS.L    75
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _TEXTDISP_BannerFallbackEntryIndex/_TEXTDISP_BannerFallbackIsSpecialFlag/_TEXTDISP_BannerFallbackValidFlag/_TEXTDISP_BannerSelectedEntryIndex/_TEXTDISP_BannerSelectedIsSpecialFlag/_TEXTDISP_BannerSelectedValidFlag/_TEXTDISP_ChannelLabelReadyFlag
; TYPE: u8/u8/u8/u8/u8/u8/u32
; PURPOSE: Carries fallback/selected entry metadata and channel-label readiness for banner/status rendering.
; USED BY: _TEXTDISP_SelectBestMatchFromList, _TEXTDISP_SelectGroupAndEntry, SCRIPT3 state save/restore, TEXTDISP/CLEANUP3 banner/status draws
; NOTES:
;   Entry-index bytes pair with their corresponding `IsSpecialFlag` and `ValidFlag` fields.
;   `_TEXTDISP_ChannelLabelReadyFlag` is set to 1 when _TEXTDISP_BuildChannelLabel constructs a usable label.
;------------------------------------------------------------------------------
_TEXTDISP_BannerFallbackEntryIndex:
    DS.B    1
;------------------------------------------------------------------------------
; SYM: _TEXTDISP_BannerCharFallback/_TEXTDISP_BannerCharSelected   (status banner chars)
; TYPE: u8/u8
; PURPOSE: Character pair used when composing text display "now showing" status banners.
; USED BY: _TEXTDISP_BuildNowShowingStatusLine, SCRIPT4_*
; NOTES: Selected char falls back to fallback char when selected value is sentinel 100.
;------------------------------------------------------------------------------
_TEXTDISP_BannerCharFallback:
    DS.B    1
_TEXTDISP_BannerFallbackIsSpecialFlag:
    DS.B    1
_TEXTDISP_BannerFallbackValidFlag:
    DS.B    1
_TEXTDISP_BannerSelectedEntryIndex:
    DS.B    1
_TEXTDISP_BannerCharSelected:
    DS.B    1
_TEXTDISP_BannerSelectedIsSpecialFlag:
    DS.B    1
_TEXTDISP_BannerSelectedValidFlag:
    DS.B    1
_TEXTDISP_ChannelLabelReadyFlag:
    DS.L    1
    DS.W    1
_TLIBA2_BroadcastWindowClockSnapshotA:
    DS.L    2
_TLIBA2_BroadcastWindowClockSnapshotB:
    DS.L    2
    DS.W    1
_TLIBA2_BroadcastWindowClockSnapshotC:
    DS.L    1
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _TLIBA2_BroadcastWindowClockSnapshotA/_TLIBA2_BroadcastWindowClockSnapshotB/_TLIBA2_BroadcastWindowClockSnapshotC   (broadcast-window clock snapshot)
; TYPE: packed clock/date tuple scratch
; PURPOSE: Scratch copy of current clock/date fields while TLIBA2 computes adjusted broadcast windows.
; USED BY: _TLIBA2_ComputeBroadcastTimeWindow
; NOTES: Seeded from _CLOCK_CurrentDayOfWeekIndex.._Global_WORD_CURRENT_SECOND before DST offset math.
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
; SYM: _TLIBA3_VmArrayRuntimeTable/_TLIBA3_VmArrayPatternTable   (VM array runtime + pattern tables)
; TYPE: struct[9]/struct[9]
; PURPOSE: Backing tables for TLIBA3 VM-array setup, raster context snapshots, and pattern register layouts.
; USED BY: _TLIBA3_InitPatternTable, _TLIBA3_BuildDisplayContextForViewMode, _TLIBA3_InitRuntimeEntry, _TLIBA3_SetFontForAllViewModes
; NOTES: Runtime table is 9 entries x 154 bytes; pattern table is 9 entries x 76 bytes.
;------------------------------------------------------------------------------
_TLIBA3_VmArrayRuntimeTable:
    DS.L    346
    DS.W    1
_TLIBA3_VmArrayPatternTable:
    DS.L    171
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _WDISP_WeatherCycleOffsetCount   (weather-cycle offset accumulator)
; TYPE: u32
; PURPOSE: Stores weather-cycle offset/count state used by ED2 diagnostics and WDISP weather-cycle logic.
; USED BY: ED2 weather diagnostics reset/display paths, WDISP weather-cycle helpers
; NOTES: Referenced by active ED2 code and partially dead WDISP helper paths.
;------------------------------------------------------------------------------
_WDISP_WeatherCycleOffsetCount:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _FORMAT_ScratchBuffer   (shared RawDoFmt scratch buffer)
; TYPE: u8[856]
; PURPOSE: Temporary output buffer for formatter wrappers and optional debug-log writes.
; USED BY: _FORMAT_RawDoFmtWithScratchBuffer, UNKNOWN2A dead-code formatting wrappers
; NOTES: Sized as 214 longwords.
;------------------------------------------------------------------------------
_FORMAT_ScratchBuffer:
    DS.L    214