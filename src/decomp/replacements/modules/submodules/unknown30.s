    XDEF    EXEC_CallVector_348

;------------------------------------------------------------------------------
; FUNC: EXEC_CallVector_348   (Exec.library call wrapper at LVO -348.)
; ARGS:
;   (none observed)
; RET:
;   D0: status/return from LVO -348
; CLOBBERS:
;   D0-D3/A0-A3/A6
; DESC:
;   Loads A6 from stack and dispatches to Exec.library -> _LVOFreeTrap.
; NOTES:
;   Vector identity is unknown; verify against call sites.
;------------------------------------------------------------------------------
EXEC_CallVector_348:
    MOVEM.L D2-D3/A2-A3/A6,-(A7)

    SetOffsetForStack 5
    UseStackLong    MOVEA.L,9,A6

; LAB_1A8D:
    MOVEA.L 24(A7),A0
    MOVEA.L 28(A7),A1
    MOVEA.L 32(A7),A2
    MOVEA.L 36(A7),A3
    MOVE.L  40(A7),D0
    MOVE.L  44(A7),D1
    MOVE.L  48(A7),D2
    MOVE.L  52(A7),D3
    JSR     _LVOFreeTrap(A6)

    MOVEM.L (A7)+,D2-D3/A2-A3/A6
    RTS

;!======

    ; Alignment
    ALIGN_WORD
