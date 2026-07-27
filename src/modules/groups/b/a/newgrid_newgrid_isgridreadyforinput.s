    XDEF    _NEWGRID_IsGridReadyForInput


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_IsGridReadyForInput   (Check input gating flags)
; ARGS:
;   (none observed)
; RET:
;   D0: 1 if allowed, 0 if blocked
; CLOBBERS:
;   D0-D1/D6-D7
; CALLS:
;   none
; READS:
;   _TEXTDISP_SecondaryGroupPresentFlag/_TEXTDISP_SecondaryGroupEntryCount, _TEXTDISP_PrimaryGroupPresentFlag/_TEXTDISP_PrimaryGroupEntryCount
; WRITES:
;   none
; DESC:
;   Checks multiple gating flags and counters to decide if input/action is allowed.
; NOTES:
;   Returns 0 when either gate is active with a positive counter.
;------------------------------------------------------------------------------
_NEWGRID_IsGridReadyForInput:
    MOVEM.L D6-D7,-(A7)
    MOVE.L  12(A7),D7

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   .check_primary_gate

    TST.B   _TEXTDISP_SecondaryGroupPresentFlag
    BEQ.S   .allow_input

    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .allow_input

.check_primary_gate:
    TST.B   _TEXTDISP_PrimaryGroupPresentFlag
    BEQ.S   .allow_input

    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .allow_input

    MOVEQ   #0,D0
    BRA.S   .return_ready_flag

.allow_input:
    MOVEQ   #1,D0

.return_ready_flag:
    MOVE.L  D0,D6
    MOVE.L  D6,D0

    MOVEM.L (A7)+,D6-D7
    RTS

;!======