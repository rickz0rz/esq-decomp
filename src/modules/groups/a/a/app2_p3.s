    XDEF    _ESQ_DecCopperListsPrimary



;------------------------------------------------------------------------------
; FUNC: _ESQ_DecCopperListsPrimary   (DecCopperListsPrimaryuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0, D2-D5, A2-A3
; CALLS:
;   _ESQ_DecColorStep
; READS:
;   _ESQ_CopperStatusDigitsA, _ESQ_CopperStatusDigitsB
; WRITES:
;   _ESQ_CopperStatusDigitsA, _ESQ_CopperStatusDigitsB
; DESC:
;   Decrements color components for entries in the primary copper lists.
; NOTES:
;   Updates the first 8 entries in both lists, then the next 24 entries only
;   in _ESQ_CopperStatusDigitsA.
;------------------------------------------------------------------------------
_ESQ_DecCopperListsPrimary:
    MOVEM.L D2-D5/A2-A3,-(A7)
    LEA     _ESQ_CopperStatusDigitsA,A2
    LEA     _ESQ_CopperStatusDigitsB,A3
    MOVE.W  #0,D5
    MOVEQ   #7,D4

.update_dual_loop:
    MOVE.W  0(A2,D5.W),D0
    BSR.S   _ESQ_DecColorStep

    MOVE.W  D0,0(A2,D5.W)
    MOVE.W  D0,0(A3,D5.W)
    ADDQ.W  #4,D5
    DBF     D4,.update_dual_loop
    MOVEQ   #23,D4

.update_primary_loop:
    MOVE.W  0(A2,D5.W),D0
    BSR.S   _ESQ_DecColorStep

    MOVE.W  D0,0(A2,D5.W)
    ADDQ.W  #4,D5
    DBF     D4,.update_primary_loop
    MOVEM.L (A7)+,D2-D5/A2-A3
    RTS

;!======