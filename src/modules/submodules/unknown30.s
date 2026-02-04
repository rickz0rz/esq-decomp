;------------------------------------------------------------------------------
; FUNC: EXEC_CallVector_348   (Exec.library call wrapper at LVO -348.)
; ARGS:
;   stack +4:  A6 = ExecBase?? (loaded via UseStackLong)
;   stack +8:  A0 ??
;   stack +12: A1 ??
;   stack +16: A2 ??
;   stack +20: A3 ??
;   stack +24: D0 ??
;   stack +28: D1 ??
;   stack +32: D2 ??
;   stack +36: D3 ??
; RET:
;   D0: status/return from LVO -348
; CLOBBERS:
;   D0-D3/A0-A3/A6
; DESC:
;   Loads A6 from stack and dispatches to Exec.library vector -348.
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
    JSR     -348(A6)                    ; Traced A6 to AbsExecBase here...? FreeTrap

    MOVEM.L (A7)+,D2-D3/A2-A3/A6
    RTS

;!======

    ; Alignment
    ALIGN_WORD
