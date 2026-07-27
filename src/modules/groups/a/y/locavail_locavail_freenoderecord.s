    XDEF    _LOCAVAIL_FreeNodeRecord


;------------------------------------------------------------------------------
; FUNC: _LOCAVAIL_FreeNodeRecord   (Clear one availability-node record in place)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   node record bytes at A3 (+0,+2,+4,+6)
; DESC:
;   Zeroes flag/count/length/pointer fields for a single node record.
; NOTES:
;   Does not free external buffers; call `_LOCAVAIL_FreeNodeAtPointer` for owned data.
;------------------------------------------------------------------------------
_LOCAVAIL_FreeNodeRecord:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    CLR.B   (A3)
    MOVEQ   #0,D0
    MOVE.W  D0,2(A3)
    MOVE.W  D0,4(A3)
    CLR.L   6(A3)
    MOVEA.L (A7)+,A3
    RTS

;!======