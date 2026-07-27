    XDEF    _LOCAVAIL_ResetFilterStateStruct


;------------------------------------------------------------------------------
; FUNC: _LOCAVAIL_ResetFilterStateStruct   (Reset filter-state struct to defaults)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A7/D0
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   filter-state fields at A3 (+0,+2,+6,+8,+12,+16,+20)
; DESC:
;   Clears transient state, nulls shared refs/arrays, sets default mode marker (`'F'`),
;   and initializes cursor-related longs to `-1`.
; NOTES:
;   Does not free prior allocations; intended for fresh/init path or post-free reset.
;------------------------------------------------------------------------------
_LOCAVAIL_ResetFilterStateStruct:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    CLR.B   (A3)
    CLR.L   2(A3)
    SUBA.L  A0,A0
    MOVE.L  A0,16(A3)
    MOVE.L  A0,20(A3)
    MOVE.B  #'F',6(A3)
    MOVEQ   #-1,D0
    MOVE.L  D0,8(A3)
    MOVE.L  D0,12(A3)
    MOVEA.L (A7)+,A3
    RTS

;!======