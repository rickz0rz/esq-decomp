    XDEF    _EXEC_CallVector_48


;------------------------------------------------------------------------------
; FUNC: _EXEC_CallVector_48   (Exec.library call wrapper at LVO -48.)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D0/A0-A2/A6
; DESC:
;   Dispatches to _LVOexecPrivate3 using _INPUTDEVICE_LibraryBaseFromConsoleIo as library base.
; NOTES:
;   Vector identity unknown; verify against call sites.
;------------------------------------------------------------------------------
_EXEC_CallVector_48:
    MOVEM.L A2/A6,-(A7)

    MOVEA.L _INPUTDEVICE_LibraryBaseFromConsoleIo,A6
    MOVEM.L 12(A7),A0-A1
    MOVEM.L 20(A7),D1/A2
    JSR     _LVOexecPrivate3(A6)

    MOVEM.L (A7)+,A2/A6
    RTS

;!======