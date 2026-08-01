    XDEF    _Global_STR_ESQDISP_C
    XDEF    _ESQDISP_StatusIndicatorColorCache
    XDEF    _ESQDISP_StatusIndicatorMask
    XDEF    _Global_REF_INTB_AUD1_INTERRUPT
    XDEF    _Global_REF_INTB_RBF_INTERRUPT
    XDEF    _ESQDISP_DisplayActiveFlag
    XDEF    _ESQDISP_StatusBannerClampGateFlag
    XDEF    _ESQDISP_PendingGridReinitFlag
    XDEF    _ESQDISP_PrimarySecondaryMirrorFlag
    XDEF    _ESQDISP_SecondaryPersistRequestFlag
    XDEF    _ESQDISP_StatusRefreshPendingFlag
    XDEF    _ESQDISP_ProgramInfoZeroTag
    XDEF    _ESQDISP_LatchedInputModeBit
    XDEF    _ESQDISP_InputModeDebounceCount
    XDEF    _ESQDISP_LastPrimaryCountdownValue
    XDEF    _ESQDISP_SecondaryPersistArmGateFlag
; ========== ESQDISP.c ==========

_Global_STR_ESQDISP_C:
    NStr    "ESQDISP.c"
;------------------------------------------------------------------------------
; SYM: _ESQDISP_StatusIndicatorColorCache   (status indicator color cache)
; TYPE: u32[2]
; PURPOSE: Stores current color values for the two status indicator slots.
; USED BY: _ESQDISP_SetStatusIndicatorColorSlot
; NOTES: Initialized to all 1s and refreshed when indicator colors change.
;------------------------------------------------------------------------------
_ESQDISP_StatusIndicatorColorCache:
    DC.L    $ffffffff,$ffffffff
;------------------------------------------------------------------------------
; SYM: _ESQDISP_StatusIndicatorMask   (status indicator bitmask)
; TYPE: u32 mask
; PURPOSE: Tracks active status-indicator bits used for repaint decisions.
; USED BY: _ESQDISP_UpdateStatusMaskAndRefresh
; NOTES: Mask is clamped to 12 bits.
;------------------------------------------------------------------------------
_ESQDISP_StatusIndicatorMask:
    DS.L    1
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _Global_REF_INTB_AUD1_INTERRUPT   (INTB AUD1 interrupt pointer)
; TYPE: pointer
; PURPOSE: Cached pointer/reference to AUD1 interrupt descriptor/state.
; USED BY: ESQ interrupt/display control paths
; NOTES: Name preserved from existing code; semantics inferred from INTB/AUD1 role.
;------------------------------------------------------------------------------
_Global_REF_INTB_AUD1_INTERRUPT:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _Global_REF_INTB_RBF_INTERRUPT   (INTB RBF interrupt pointer)
; TYPE: pointer
; PURPOSE: Cached pointer/reference to RBF interrupt descriptor/state.
; USED BY: ESQ interrupt/display control paths
; NOTES: Name preserved from existing code; semantics inferred from INTB/RBF role.
;------------------------------------------------------------------------------
_Global_REF_INTB_RBF_INTERRUPT:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _ESQDISP_DisplayActiveFlag   (display-active gate)
; TYPE: u32 flag
; PURPOSE: Indicates whether ESQ display/update polling should run.
; USED BY: ESQ, _ESQFUNC_ProcessUiFrameTick, _SCRIPT_HandleSerialCtrlCmd
; NOTES: Cleared at startup and set once display state is initialized.
;------------------------------------------------------------------------------
_ESQDISP_DisplayActiveFlag:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _ESQDISP_StatusBannerClampGateFlag   (status banner clamp gate)
; TYPE: u16 flag
; PURPOSE: Gates status-banner clamp/highlight setup around forced redraw paths.
; USED BY: CLEANUP2_ForceStatusBannerRedraw, _ESQDISP_DrawStatusBanner_Impl
; NOTES: Temporarily cleared during cleanup-triggered redraw.
;------------------------------------------------------------------------------
_ESQDISP_StatusBannerClampGateFlag:
    DC.W    $0001
;------------------------------------------------------------------------------
; SYM: _ESQDISP_PendingGridReinitFlag   (pending grid reinit)
; TYPE: u16 flag
; PURPOSE: Requests NEWGRID2 to reinitialize grid context after state commit.
; USED BY: _ESQFUNC_CommitSecondaryStateAndPersist, _NEWGRID2_DispatchGridOperation
; NOTES: Producer sets to 1; NEWGRID2 consumes and clears.
;------------------------------------------------------------------------------
_ESQDISP_PendingGridReinitFlag:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _ESQDISP_PrimarySecondaryMirrorFlag   (mirror-done flag)
; TYPE: u16 flag
; PURPOSE: Marks when primary entries were mirrored into secondary slots.
; USED BY: _ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty, _ESQFUNC_DrawDiagnosticsScreen
; NOTES: Set on successful mirror path; cleared when not mirrored.
;------------------------------------------------------------------------------
_ESQDISP_PrimarySecondaryMirrorFlag:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _ESQDISP_SecondaryPersistRequestFlag   (secondary persist request)
; TYPE: u32 flag
; PURPOSE: Requests secondary-state persistence/update work in frame tick processing.
; USED BY: _ESQDISP_DrawStatusBanner_Impl, _ESQFUNC_ProcessUiFrameTick
; NOTES: Armed by banner timing path and consumed/cleared by frame tick.
;------------------------------------------------------------------------------
_ESQDISP_SecondaryPersistRequestFlag:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _ESQDISP_StatusRefreshPendingFlag   (status refresh pending)
; TYPE: u16 flag
; PURPOSE: Defers status refresh until highlight holdoff countdown completes.
; USED BY: _GCOMMAND_ConsumeBannerQueueEntry, _ESQFUNC_ProcessUiFrameTick
; NOTES: Written with byte ops by producers/consumers.
;------------------------------------------------------------------------------
_ESQDISP_StatusRefreshPendingFlag:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _ESQDISP_ProgramInfoZeroTag   (program info default "00")
; TYPE: char[3]
; PURPOSE: Fallback two-digit token used when parsed program-info digits are absent.
; USED BY: _ESQDISP_ParseProgramInfoCommandRecord
; NOTES: NUL-terminated.
;------------------------------------------------------------------------------
_ESQDISP_ProgramInfoZeroTag:
    DC.B    "00",0
;------------------------------------------------------------------------------
; SYM: _ESQDISP_LatchedInputModeBit   (latched input mode bit)
; TYPE: u8
; PURPOSE: Stores last stable CIAB input-mode bit for debounce comparison.
; USED BY: _ESQDISP_PollInputModeAndRefreshSelection
; NOTES: Seed value $FF guarantees first sampled bit is treated as a change.
;------------------------------------------------------------------------------
_ESQDISP_LatchedInputModeBit:
    DC.B    $ff
;------------------------------------------------------------------------------
; SYM: _ESQDISP_InputModeDebounceCount   (input-mode debounce counter)
; TYPE: u32
; PURPOSE: Counts consecutive identical input-mode samples before accepting state.
; USED BY: _ESQDISP_PollInputModeAndRefreshSelection
; NOTES: Threshold compares against 5 samples.
;------------------------------------------------------------------------------
_ESQDISP_InputModeDebounceCount:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _ESQDISP_LastPrimaryCountdownValue   (cached primary countdown)
; TYPE: u16
; PURPOSE: Caches previous _DST_PrimaryCountdown for edge-triggered slot handling.
; USED BY: _ESQDISP_DrawStatusBanner_Impl
; NOTES: Detects countdown transitions (including 1->0 events).
;------------------------------------------------------------------------------
_ESQDISP_LastPrimaryCountdownValue:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _ESQDISP_SecondaryPersistArmGateFlag   (secondary persist arm gate)
; TYPE: u16 flag
; PURPOSE: One-shot gate controlling when secondary persist request can be re-armed.
; USED BY: _ESQDISP_DrawStatusBanner_Impl
; NOTES: Behavior is slot-index dependent; naming remains conservative.
;------------------------------------------------------------------------------
_ESQDISP_SecondaryPersistArmGateFlag:
    DC.W    $0001