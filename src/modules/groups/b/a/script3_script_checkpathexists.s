    XDEF    _SCRIPT_CheckPathExists


;------------------------------------------------------------------------------
; FUNC: _SCRIPT_CheckPathExists   (CheckPathExistsuncertain)
; ARGS:
;   stack +8: path (char *)
; RET:
;   D0: 1 if lock/unlock succeeds, 0 otherwise
; CLOBBERS:
;   D0-D2/D6-D7/A3
; CALLS:
;   _LVOLock, _LVOUnLock
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Attempts a DOS lock on path and returns whether it succeeds.
; NOTES:
;   Uses lock mode -2 (shared read).
;------------------------------------------------------------------------------
_SCRIPT_CheckPathExists:
    MOVEM.L D2/D6-D7/A3,-(A7)
    MOVEA.L 20(A7),A3

    MOVEQ   #0,D7
    MOVEQ   #0,D6
    MOVE.L  A3,D1
    MOVEQ   #-2,D2
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOLock(A6)

    MOVE.L  D0,D7
    TST.L   D7
    BEQ.S   .return

    MOVE.L  D7,D1
    JSR     _LVOUnLock(A6)

    MOVEQ   #1,D6

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D2/D6-D7/A3
    RTS

;!======