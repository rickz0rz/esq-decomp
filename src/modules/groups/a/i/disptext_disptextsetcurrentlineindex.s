    XDEF    _DISPTEXT_SetCurrentLineIndex

;------------------------------------------------------------------------------
; FUNC: _DISPTEXT_SetCurrentLineIndex   (Set current line index)
; ARGS:
;   stack +8: D7 = line index (1..3)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D7
; CALLS:
;   _DISPLIB_CommitCurrentLinePenAndAdvance
; READS:
;   _DISPTEXT_LineTableLockFlag
; WRITES:
;   (via _DISPLIB_CommitCurrentLinePenAndAdvance)
; DESC:
;   Updates current line selection if valid and not locked.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DISPTEXT_SetCurrentLineIndex:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    TST.L   _DISPTEXT_LineTableLockFlag
    BNE.S   .return

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BLT.S   .return

    MOVEQ   #3,D0
    CMP.L   D0,D7
    BGT.S   .return

    MOVE.L  D7,-(A7)
    BSR.W   _DISPLIB_CommitCurrentLinePenAndAdvance

    ADDQ.W  #4,A7

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======
