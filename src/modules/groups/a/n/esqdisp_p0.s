    XDEF    _ESQDISP_InitHighlightMessagePattern
    XDEF    ESQDISP_InitHighlightMessagePattern_Return


;------------------------------------------------------------------------------
; FUNC: _ESQDISP_InitHighlightMessagePattern   (Seed highlight message pattern bytes)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D7
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   A3+55..A3+58
; DESC:
;   Writes ascending pattern bytes 4..7 into message structure offsets 55..58.
; NOTES:
;   Uses a fixed 4-byte loop.
;------------------------------------------------------------------------------
_ESQDISP_InitHighlightMessagePattern:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7

.init_pattern_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   ESQDISP_InitHighlightMessagePattern_Return

    MOVE.L  D7,D0
    ADDQ.L  #4,D0
    MOVE.B  D0,55(A3,D7.L)
    ADDQ.L  #1,D7
    BRA.S   .init_pattern_loop

;------------------------------------------------------------------------------
; FUNC: ESQDISP_InitHighlightMessagePattern_Return   (Return tail for message-pattern initializer)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D7
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Restores D7/A3 and returns.
; NOTES:
;   Shared exit from 4-iteration seed loop.
;------------------------------------------------------------------------------
ESQDISP_InitHighlightMessagePattern_Return:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======