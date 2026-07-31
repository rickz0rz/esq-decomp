    XDEF    _ESQ_IncCopperListsTowardsTargets



;------------------------------------------------------------------------------
; FUNC: _ESQ_IncCopperListsTowardsTargets   (IncCopperListsTowardsTargetsuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0, D2-D6, A1-A3
; CALLS:
;   _ESQ_BumpColorTowardTargets
; READS:
;   _WDISP_PaletteTriplesRBase, _ESQ_CopperStatusDigitsA, _ESQ_CopperStatusDigitsB
; WRITES:
;   _ESQ_CopperStatusDigitsA, _ESQ_CopperStatusDigitsB
; DESC:
;   Adjusts copper list colors based on a per-entry target table.
; NOTES:
;   Uses _WDISP_PaletteTriplesRBase as a 3-byte-per-entry target stream.
;------------------------------------------------------------------------------
_ESQ_IncCopperListsTowardsTargets:
    MOVEM.L D2-D6/A2-A3,-(A7)
    LEA     _WDISP_PaletteTriplesRBase,A1
    LEA     _ESQ_CopperStatusDigitsA,A2
    LEA     _ESQ_CopperStatusDigitsB,A3
    MOVE.W  #0,D5
    MOVEQ   #7,D4

.update_dual_loop:
    MOVE.W  0(A2,D5.W),D0
    BSR.S   _ESQ_BumpColorTowardTargets

    MOVE.W  D0,0(A2,D5.W)
    MOVE.W  D0,0(A3,D5.W)
    ADDQ.W  #4,D5
    DBF     D4,.update_dual_loop
    MOVEQ   #23,D4

.update_primary_loop:
    MOVE.W  0(A2,D5.W),D0
    BSR.S   _ESQ_BumpColorTowardTargets

    MOVE.W  D0,0(A2,D5.W)
    ADDQ.W  #4,D5
    DBF     D4,.update_primary_loop
    MOVEM.L (A7)+,D2-D6/A2-A3
    RTS

;!======