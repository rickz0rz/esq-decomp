; ========== NEWGRID.c ==========

GLOB_STR_NEWGRID_C_1:
    NStr    "NEWGRID.c"
GLOB_STR_NEWGRID_C_2:
    NStr    "NEWGRID.c"
GLOB_STR_44_44_44:
    NStr    "44:44:44"
    NStr    "44:44:44"
GLOB_STR_NEWGRID_C_3:
    NStr    "NEWGRID.c"
DATA_NEWGRID_BSS_LONG_2003:
    DS.L    1
DATA_NEWGRID_BSS_BYTE_2004:
    DS.B    1
DATA_NEWGRID_BSS_BYTE_2005:
    DS.B    1
DATA_NEWGRID_BSS_BYTE_2006:
    DS.B    1
DATA_NEWGRID_BSS_BYTE_2007:
    DS.B    1
DATA_NEWGRID_BSS_BYTE_2008:
    DS.B    1
DATA_NEWGRID_BSS_BYTE_2009:
    DS.B    1
DATA_NEWGRID_BSS_LONG_200A:
    DS.L    1
DATA_NEWGRID_CONST_LONG_200B:
    DC.L    $00000005,$00000006,$00000007,$00000008
    DC.L    $00000009,$0000000a,$0000000c
GLOB_STR_SINGLE_SPACE:
    NStr    " "
DATA_NEWGRID_SPACE_VALUE_200D:
    NStr    " "
DATA_NEWGRID_SPACE_VALUE_200E:
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
DATA_NEWGRID_CONST_WORD_2015:
    DC.W    $0001
DATA_NEWGRID_CONST_WORD_2016:
    DC.W    $0001
DATA_NEWGRID_BSS_WORD_2017:
    DS.W    1
DATA_NEWGRID_CONST_LONG_2018:
    DC.L    $90939b99,$a3a39a84,$86858c87
    DC.W    $8d8f
    DS.B    1
DATA_NEWGRID_STR_VALUE_2019:
    NStr2   145,"|"
DATA_NEWGRID_FMT_PCT_C_PCT_S_PCT_C_PCT_S_201A:
    NStr    "%c%s%c %s"
DATA_NEWGRID_CONST_LONG_201B:
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
DATA_NEWGRID_BSS_LONG_2023:
    DS.L    1
DATA_NEWGRID_CONST_LONG_2024:
    DC.L    $00000004
DATA_NEWGRID_BSS_LONG_2025:
    DS.L    1
DATA_NEWGRID_BSS_LONG_2026:
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
DATA_NEWGRID_CONST_LONG_2028:
    DC.L    $00000004
DATA_NEWGRID_FMT_PCT_S_CH_DOT_PCT_S_2029:
    NStr    "%s Ch. %s"
DATA_NEWGRID_BSS_LONG_202A:
    DS.L    1
DATA_NEWGRID_BSS_LONG_202B:
    DS.L    1
DATA_NEWGRID_BSS_LONG_202C:
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
DATA_NEWGRID_STR_VALUE_2032:
    NStr    ", "
GLOB_STR_SINGLE_SPACE_3:
    NStr    " "
GLOB_STR_COMMA_AND_SINGLE_SPACE_1:
    NStr    ", "
DATA_NEWGRID_SPACE_VALUE_2035:
    NStr    " "
DATA_NEWGRID_CONST_LONG_2036:
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
DATA_NEWGRID_BSS_LONG_2039:
    DS.L    1
DATA_NEWGRID_BSS_WORD_203A:
    DS.W    1
DATA_NEWGRID_STR_VALUE_203B:
    NStr    ", "
DATA_NEWGRID_STR_DASH_203C:
    NStr    "-"
DATA_NEWGRID_CONST_LONG_203D:
    DC.L    $00000004
