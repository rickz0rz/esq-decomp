    XDEF    _TLIBA3_DrawOuterFrameBorder


;------------------------------------------------------------------------------
; FUNC: _TLIBA3_DrawOuterFrameBorder   (_TLIBA3_DrawOuterFrameBorder)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A6/A7/D0/D1
; CALLS:
;   _LVODraw, _LVOMove
; READS:
;   Global_REF_GRAPHICS_LIBRARY
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_TLIBA3_DrawOuterFrameBorder:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L 4(A3),A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    ASL.L   #3,D0
    SUBQ.L  #1,D0
    MOVEA.L A3,A1
    MOVEQ   #0,D1
    JSR     _LVODraw(A6)

    MOVEA.L 4(A3),A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    ASL.L   #3,D0

    SUBQ.L  #1,D0
    MOVEQ   #0,D1
    MOVE.W  2(A0),D1
    SUBQ.L  #1,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVEA.L 4(A3),A0
    MOVEQ   #0,D0
    MOVE.W  2(A0),D0
    SUBQ.L  #1,D0
    MOVEA.L A3,A1
    MOVE.L  D0,D1
    MOVEQ   #0,D0
    JSR     _LVODraw(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    JSR     _LVODraw(A6)

    MOVEA.L (A7)+,A3
    RTS

;!======