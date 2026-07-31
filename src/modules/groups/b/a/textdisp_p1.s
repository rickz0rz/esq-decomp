    XDEF    _TEXTDISP_SetSelectionFields


;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_SetSelectionFields   (Update mode/index selection)
; ARGS:
;   stack +20: entryPtr (A3)
;   stack +24: mode (long, 1/2/3)
;   stack +28: displayIndex (long)
;   stack +32: entryIndex (long)
; RET:
;   none
; CLOBBERS:
;   D0-D1/A3
; CALLS:
;   _TEXTDISP_GetGroupEntryCount, _TEXTDISP_ResetSelectionState
; WRITES:
;   entry+210, entry+214, entry+218, entry+220
; DESC:
;   Sets selection state fields, clamping indices to valid ranges.
; NOTES:
;   Resets state when mode or indices are invalid.
;------------------------------------------------------------------------------
_TEXTDISP_SetSelectionFields:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.L  24(A7),D7
    MOVE.L  28(A7),D6
    MOVE.L  32(A7),D5
    MOVE.L  A3,D0
    BEQ.S   .return

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BEQ.S   .use_mode_passed

    MOVEQ   #2,D0
    CMP.L   D0,D7
    BNE.S   .use_mode_default

.use_mode_passed:
    MOVE.L  D7,D0
    BRA.S   .store_mode

.use_mode_default:
    MOVEQ   #3,D0

.store_mode:
    MOVE.L  D0,210(A3)
    MOVE.L  D0,-(A7)
    BSR.W   _TEXTDISP_GetGroupEntryCount

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    CMP.L   D1,D6
    BGE.S   .clamp_display_index

    MOVE.L  D6,D0
    BRA.S   .store_display_index

.clamp_display_index:
    MOVEQ   #-1,D0

.store_display_index:
    MOVE.L  D0,214(A3)
    TST.L   D5
    BLE.S   .invalidate_entry_index

    MOVEQ   #49,D1
    CMP.L   D1,D5
    BGE.S   .invalidate_entry_index

    MOVE.L  D5,D1
    BRA.S   .store_entry_index

.invalidate_entry_index:
    MOVEQ   #-1,D1

.store_entry_index:
    MOVE.W  D1,218(A3)
    CLR.B   220(A3)
    MOVEQ   #3,D0
    CMP.L   210(A3),D0
    BEQ.S   .reset_selection

    MOVEQ   #-1,D0
    CMP.L   214(A3),D0
    BEQ.S   .reset_selection

    MOVEQ   #-1,D0
    CMP.W   218(A3),D0
    BNE.S   .return

.reset_selection:
    MOVE.L  A3,-(A7)
    BSR.W   _TEXTDISP_ResetSelectionState

    ADDQ.W  #4,A7

.return:
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======