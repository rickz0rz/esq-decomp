    XDEF    _DISPTEXT_SetLayoutParams

;------------------------------------------------------------------------------
; FUNC: _DISPTEXT_SetLayoutParams   (Set display layout paramsuncertain)
; ARGS:
;   (none observed)
; RET:
;   D0: 1 if applied, 0 if clamped/no change
; CLOBBERS:
;   A7/D0/D5/D6/D7
; CALLS:
;   _DISPLIB_ResetTextBufferAndLineTables, _DISPLIB_CommitCurrentLinePenAndAdvance
; READS:
;   _DISPTEXT_LineWidthPx, _DISPTEXT_TargetLineIndex
; WRITES:
;   _DISPTEXT_LineWidthPx, _DISPTEXT_TargetLineIndex
; DESC:
;   Updates layout parameters and returns whether the requested values matched.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DISPTEXT_SetLayoutParams:
    MOVEM.L D5-D7,-(A7)
    MOVE.L  16(A7),D7
    MOVE.L  20(A7),D6
    MOVE.L  24(A7),D5
    BSR.W   _DISPLIB_ResetTextBufferAndLineTables

    TST.L   D7
    BMI.S   .clamp_width

    CMPI.L  #624,D7
    BGT.S   .clamp_width

    MOVE.L  D7,_DISPTEXT_LineWidthPx

.clamp_width:
    TST.L   D6
    BLE.S   .clamp_lines

    MOVEQ   #20,D0
    CMP.L   D0,D6
    BGT.S   .clamp_lines

    MOVE.L  D6,D0
    MOVE.W  D0,_DISPTEXT_TargetLineIndex

.clamp_lines:
    MOVE.L  D5,-(A7)
    BSR.W   _DISPLIB_CommitCurrentLinePenAndAdvance

    ADDQ.W  #4,A7
    MOVE.L  _DISPTEXT_LineWidthPx,D0
    CMP.L   D7,D0
    BNE.S   .mismatch

    MOVEQ   #0,D0
    MOVE.W  _DISPTEXT_TargetLineIndex,D0
    CMP.L   D6,D0
    BNE.S   .mismatch

    MOVEQ   #1,D0
    BRA.S   .done

.mismatch:
    MOVEQ   #0,D0

.done:
    MOVEM.L (A7)+,D5-D7
    RTS

;!======