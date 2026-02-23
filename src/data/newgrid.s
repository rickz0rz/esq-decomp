; ========== NEWGRID.c ==========

Global_STR_NEWGRID_C_1:
    NStr    "NEWGRID.c"
Global_STR_NEWGRID_C_2:
    NStr    "NEWGRID.c"
Global_STR_44_44_44:
    NStr    "44:44:44"
    NStr    "44:44:44"
Global_STR_NEWGRID_C_3:
    NStr    "NEWGRID.c"
;------------------------------------------------------------------------------
; SYM: NEWGRID_ModeCycleCountdown/NEWGRID_NicheModeCycleBudget_*/NEWGRID_ModeCandidateIndex   (mode-cycle budget cluster)
; TYPE: u32 + u8 flags + u32
; PURPOSE: Tracks rotating mode-candidate selection and per-family retry budgets.
; USED BY: NEWGRID_SelectNextMode
; NOTES:
;   Budget bytes are decremented/reloaded from GCOMMAND niche/mplex/ppv cycle counts.
;   NEWGRID_ModeCandidateIndex rotates through NEWGRID_ModeSelectionTable entries.
;------------------------------------------------------------------------------
NEWGRID_ModeCycleCountdown:
    DS.L    1
NEWGRID_NicheModeCycleBudget_Static:
    DS.B    1
NEWGRID_NicheModeCycleBudget_Y:
    DS.B    1
NEWGRID_NicheModeCycleBudget_Custom:
    DS.B    1
NEWGRID_NicheModeCycleBudget_Global:
    DS.B    1
NEWGRID_MplexModeCycleBudget:
    DS.B    1
NEWGRID_PpvModeCycleBudget:
    DS.B    1
NEWGRID_ModeCandidateIndex:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_ModeSelectionTable   (mode selection candidates)
; TYPE: u32[7]
; PURPOSE: Candidate NEWGRID mode IDs sampled by NEWGRID_SelectNextMode.
; USED BY: NEWGRID_SelectNextMode
; NOTES: Copied into stack scratch before randomized/rotating selection.
;------------------------------------------------------------------------------
NEWGRID_ModeSelectionTable:
    DC.L    $00000005,$00000006,$00000007,$00000008
    DC.L    $00000009,$0000000a,$0000000c
Global_STR_SINGLE_SPACE:
    NStr    " "
;------------------------------------------------------------------------------
; SYM: NEWGRID_WrapWordSpacer/NEWGRID_WrapReturnSpacer   (word-wrap spacers)
; TYPE: cstring/cstring
; PURPOSE: Single-space tokens appended during wrapped text reconstruction.
; USED BY: NEWGRID_DrawWrappedText
; NOTES: Separate symbols are retained to preserve original callsite intent.
;------------------------------------------------------------------------------
NEWGRID_WrapWordSpacer:
    NStr    " "
NEWGRID_WrapReturnSpacer:
    NStr    " "
;------------------------------------------------------------------------------
; SYM: NEWGRID_MainModeState   (main NEWGRID mode/state id)
; TYPE: s32
; PURPOSE: Current state id for NEWGRID_ProcessGridMessages mode dispatch.
; USED BY: NEWGRID_ProcessGridMessages, NEWGRID_MapSelectionToMode
; NOTES: Indexed through a switch/jumptable (0..11 observed).
;------------------------------------------------------------------------------
NEWGRID_MainModeState:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_SelectedDaySlot   (selected day/clock slot)
; TYPE: u16
; PURPOSE: Active day slot index selected from clock/date controls.
; USED BY: NEWGRID_ProcessGridMessages and clock-slot redraw paths
; NOTES: Updated by NEWGRID_ComputeDaySlotFromClock* helpers.
;------------------------------------------------------------------------------
NEWGRID_SelectedDaySlot:
    DC.W    $0001
;------------------------------------------------------------------------------
; SYM: NEWGRID_RenderDaySlot   (render day/clock slot)
; TYPE: u16
; PURPOSE: Cached day slot used by header/list rendering calls.
; USED BY: NEWGRID_DrawClockFormatHeader, dispatch cases in NEWGRID_ProcessGridMessages
; NOTES: Usually derived from NEWGRID_SelectedDaySlot adjustments.
;------------------------------------------------------------------------------
NEWGRID_RenderDaySlot:
    DC.W    $0001
;------------------------------------------------------------------------------
; SYM: NEWGRID_HeaderRedrawPending   (header redraw pending flag)
; TYPE: s32
; PURPOSE: Signals deferred redraw of the clock-format header.
; USED BY: NEWGRID_ProcessGridMessages case_mode_11
; NOTES: Treated as boolean/non-zero pending state.
;------------------------------------------------------------------------------
NEWGRID_HeaderRedrawPending:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_SecondaryIndexCachePtr   (secondary index cache pointer)
; TYPE: pointer
; PURPOSE: Points to cache table used while rebuilding/filtering secondary entries.
; USED BY: NEWGRID1_* cache populate/filter routines, NEWGRID2_*
; NOTES: Cleared when cache is released.
;------------------------------------------------------------------------------
NEWGRID_SecondaryIndexCachePtr:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_GridOperationId   (active grid operation id)
; TYPE: s32
; PURPOSE: Stores the current operation index dispatched by NEWGRID2.
; USED BY: NEWGRID2_DispatchGridOperation, NEWGRID_ProcessGridEntries, NEWGRID_SelectEntryPen
; NOTES: Valid range is 1..7; cleared to 0 when dispatch receives an out-of-range operation.
;------------------------------------------------------------------------------
NEWGRID_GridOperationId:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_EntryPlaceholderModeFlag/NEWGRID_PrimeTimeLayoutEnable/NEWGRID_ShowtimeEntryVariantFlag   (entry layout gate flags)
; TYPE: u16/u16/u16
; PURPOSE: Gate placeholder/layout variants across NEWGRID1/NEWGRID2 entry draw flows.
; USED BY: NEWGRID1_*, NEWGRID2_ProcessGridState
; NOTES: Flag semantics are inferred from branch gates and may be refined later.
;------------------------------------------------------------------------------
NEWGRID_EntryPlaceholderModeFlag:
    DC.W    $0001
NEWGRID_PrimeTimeLayoutEnable:
    DC.W    $0001
NEWGRID_ShowtimeEntryVariantFlag:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_EntrySplitDelimiterMask   (entry split delimiter mask??)
; TYPE: packed bytes/words ??
; PURPOSE: Delimiter-class mask blob consumed by parse/split helper calls.
; USED BY: NEWGRID1 split/token parsing paths
; NOTES: Field-level meaning of packed constants is still unresolved.
;------------------------------------------------------------------------------
NEWGRID_EntrySplitDelimiterMask:
    DC.L    $90939b99,$a3a39a84,$86858c87
    DC.W    $8d8f
    DS.B    1
NEWGRID_GridEntryDelimiterBar:
    NStr2   145,"|"
;------------------------------------------------------------------------------
; SYM: NEWGRID_EntryDetailFmtStr   (entry detail format)
; TYPE: cstring format
; PURPOSE: Formats detail lines with marker chars and text payload segments.
; USED BY: NEWGRID1 detail-line builders
; NOTES: Format currently `%c%s%c %s`.
;------------------------------------------------------------------------------
NEWGRID_EntryDetailFmtStr:
    NStr    "%c%s%c %s"
;------------------------------------------------------------------------------
; SYM: NEWGRID_GridStateFrameLatch   (grid state frame latch)
; TYPE: s32
; PURPOSE: Tracks frame/full redraw phase in grid-state handlers (4/5 pattern).
; USED BY: NEWGRID1 grid state machine
; NOTES: Compiler-style switch state latch.
;------------------------------------------------------------------------------
NEWGRID_GridStateFrameLatch:
    DC.L    $00000004
;------------------------------------------------------------------------------
; SYM: NEWGRID_GridEntriesWorkflowState   (grid entries workflow state id)
; TYPE: s32
; PURPOSE: State variable for NEWGRID_ProcessGridEntries.
; USED BY: NEWGRID_ProcessGridEntries
; NOTES: Initialized to 4 and updated by a switch/jumptable flow.
;------------------------------------------------------------------------------
NEWGRID_GridEntriesWorkflowState:
    DC.L    $00000004
;------------------------------------------------------------------------------
; SYM: NEWGRID_GridSelectionColumnAdjust/NEWGRID_GridSelectionEntryIndex   (grid selection scratch state)
; TYPE: s32/s32
; PURPOSE: Tracks temporary column adjustment and current entry index while grid selection state advances.
; USED BY: NEWGRID_HandleGridSelection
; NOTES: Entry index uses -1 as sentinel when no candidate is found.
;------------------------------------------------------------------------------
NEWGRID_GridSelectionColumnAdjust:
    DS.L    1
NEWGRID_GridSelectionEntryIndex:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_GridSelectionWorkflowState   (grid selection workflow state id)
; TYPE: s32
; PURPOSE: State variable for NEWGRID_HandleGridSelection.
; USED BY: NEWGRID_HandleGridSelection
; NOTES: State machine includes transitions through states 0/3/4/5.
;------------------------------------------------------------------------------
NEWGRID_GridSelectionWorkflowState:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_GridEditorWorkflowState   (grid editor workflow state id)
; TYPE: s32
; PURPOSE: State variable for NEWGRID_HandleGridEditorState.
; USED BY: NEWGRID_HandleGridEditorState
; NOTES: Uses a two-state redraw loop keyed by values 4 and 5.
;------------------------------------------------------------------------------
NEWGRID_GridEditorWorkflowState:
    DC.L    $00000004
;------------------------------------------------------------------------------
; SYM: NEWGRID_SecondarySelectedEntryIndex   (secondary workflow selected entry index)
; TYPE: s32
; PURPOSE: Holds the active candidate entry index while NEWGRID_ProcessSecondaryState runs.
; USED BY: NEWGRID_ProcessSecondaryState
; NOTES: Uses -1 as "no entry found" sentinel during scans.
;------------------------------------------------------------------------------
NEWGRID_SecondarySelectedEntryIndex:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_SecondaryWorkflowState   (secondary workflow state id)
; TYPE: s32
; PURPOSE: State variable for NEWGRID_ProcessSecondaryState.
; USED BY: NEWGRID_ProcessSecondaryState
; NOTES: Uses switch/jumptable with 0..7 states.
;------------------------------------------------------------------------------
NEWGRID_SecondaryWorkflowState:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_SecondarySelectionHintCounter/NEWGRID_AltGridStateLatch/NEWGRID_AltEntryAttemptCounter/NEWGRID_AltEntryCursor   (secondary+alt workflow scratch)
; TYPE: s32/s32/s32/s32
; PURPOSE: Maintains counters/cursors used while probing secondary/alternate entry workflows.
; USED BY: NEWGRID_ProcessSecondaryState, NEWGRID_HandleAltGridState
; NOTES: Values are transitional and frequently reset on state changes.
;------------------------------------------------------------------------------
NEWGRID_SecondarySelectionHintCounter:
    DS.L    1
NEWGRID_AltGridStateLatch:
    DC.L    $00000004
NEWGRID_AltEntryAttemptCounter:
    DS.L    1
NEWGRID_AltEntryCursor:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_AltEntryWorkflowState   (alternate entry workflow state id)
; TYPE: s32
; PURPOSE: State variable for NEWGRID_ProcessAltEntryState.
; USED BY: NEWGRID_ProcessAltEntryState
; NOTES: Uses switch/jumptable states 0..5.
;------------------------------------------------------------------------------
NEWGRID_AltEntryWorkflowState:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_DetailGridStateLatch/NEWGRID_ChannelRowFmt/NEWGRID_ScheduleSelectionCodeCache/NEWGRID_ScheduleEditorGateFlag/NEWGRID_ScheduleAltSelectorFlag   (detail/schedule helpers)
; TYPE: s32/cstring/s32/s32/s32
; PURPOSE: Drives detail/schedule-state transitions, formatting, and selection gate checks.
; USED BY: NEWGRID1 detail/schedule state machines
; NOTES: Latches follow repeated 4/5 state idiom used by compiler-generated switches.
;------------------------------------------------------------------------------
NEWGRID_DetailGridStateLatch:
    DC.L    $00000004
NEWGRID_ChannelRowFmt:
    NStr    "%s Ch. %s"
NEWGRID_ScheduleSelectionCodeCache:
    DS.L    1
NEWGRID_ScheduleEditorGateFlag:
    DS.L    1
NEWGRID_ScheduleAltSelectorFlag:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_ScheduleRowOffset   (schedule row offset accumulator)
; TYPE: u16
; PURPOSE: Tracks additional row offset while stepping schedule candidates.
; USED BY: NEWGRID_ProcessScheduleState
; NOTES: Incremented during retry scans and added to base row inputs.
;------------------------------------------------------------------------------
NEWGRID_ScheduleRowOffset:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_SelectedPrimaryEntryIndex   (selected primary entry index)
; TYPE: s32
; PURPOSE: Holds the current/newly found primary-entry index during schedule workflow.
; USED BY: NEWGRID_ProcessScheduleState
; NOTES: Uses -1 as "not found" sentinel.
;------------------------------------------------------------------------------
NEWGRID_SelectedPrimaryEntryIndex:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_ScheduleWorkflowState   (schedule/detail workflow state id)
; TYPE: s32
; PURPOSE: State variable for NEWGRID_ProcessScheduleState.
; USED BY: NEWGRID_ProcessScheduleState
; NOTES: Uses switch/jumptable with 0..7 states.
;------------------------------------------------------------------------------
NEWGRID_ScheduleWorkflowState:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_SelectionScanEntryIndex/NEWGRID_SelectionScanRow   (selection scan cursors)
; TYPE: s32/u16
; PURPOSE: Active entry/row scan cursors used by NEWGRID_UpdateSelectionFromInput.
; USED BY: NEWGRID_UpdateSelectionFromInput
; NOTES: Entry index resets to window start when row cursor advances.
;------------------------------------------------------------------------------
NEWGRID_SelectionScanEntryIndex:
    DS.L    1
NEWGRID_SelectionScanRow:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_ShowtimeBucketSeparator/NEWGRID_ShowtimeGenreSpacer/NEWGRID_ShowtimesWorkflowStateLatch   (showtime formatting controls)
; TYPE: cstring/cstring/s32
; PURPOSE: Separators and phase latch used while assembling showtime strings.
; USED BY: NEWGRID1 showtime workflow
; NOTES: State latch follows 4/5 state-phase pattern.
;------------------------------------------------------------------------------
NEWGRID_ShowtimeBucketSeparator:
    NStr    ", "
Global_STR_SINGLE_SPACE_3:
    NStr    " "
Global_STR_COMMA_AND_SINGLE_SPACE_1:
    NStr    ", "
NEWGRID_ShowtimeGenreSpacer:
    NStr    " "
NEWGRID_ShowtimesWorkflowStateLatch:
    DC.L    $00000004
;------------------------------------------------------------------------------
; SYM: NEWGRID_ShowtimesWorkflowState   (showtimes workflow state id)
; TYPE: s32
; PURPOSE: State variable for NEWGRID_ProcessShowtimesWorkflow.
; USED BY: NEWGRID_ProcessShowtimesWorkflow
; NOTES: Uses switch/jumptable with 0..7 states.
;------------------------------------------------------------------------------
NEWGRID_ShowtimesWorkflowState:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_ShowtimesColumnAdjust   (showtimes column adjustment accumulator)
; TYPE: s32
; PURPOSE: Stores temporary column/index adjustment during showtimes navigation.
; USED BY: NEWGRID_ProcessShowtimesWorkflow
; NOTES: Updated when calculating movement offsets from selection input.
;------------------------------------------------------------------------------
NEWGRID_ShowtimesColumnAdjust:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_AltSelectionRowCursor/NEWGRID_AltSelectionEntryCursor/NEWGRID_ShowtimeListSeparator/NEWGRID_ShowtimeRangeDash/NEWGRID_RenderStateLatch   (selection/showtime render scratch)
; TYPE: s32/u16/cstring/cstring/s32
; PURPOSE: Cursors, separators, and render latch used by alternate-selection/showtime render passes.
; USED BY: NEWGRID1_*, NEWGRID2_ProcessGridState
; NOTES: NEWGRID_RenderStateLatch participates in NEWGRID2 4/5 render-state transitions.
;------------------------------------------------------------------------------
NEWGRID_AltSelectionRowCursor:
    DS.L    1
NEWGRID_AltSelectionEntryCursor:
    DS.W    1
NEWGRID_ShowtimeListSeparator:
    NStr    ", "
NEWGRID_ShowtimeRangeDash:
    NStr    "-"
NEWGRID_RenderStateLatch:
    DC.L    $00000004
