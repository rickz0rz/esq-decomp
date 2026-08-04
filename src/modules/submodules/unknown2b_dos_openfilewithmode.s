    XDEF    _DOS_OpenFileWithMode

;------------------------------------------------------------------------------
; FUNC: _DOS_OpenFileWithMode   (DOS Open wrapper)
; ARGS:
;   stack +8: A3 = filename pointer
;   stack +12: D7 = access mode
; RET:
;   D0: file handle (or 0)
; CLOBBERS:
;   A3/A6/A7/D0/D1/D2/D6/D7
; CALLS:
;   _LVOOpen
; READS:
;   _Global_REF_DOS_LIBRARY_2
; WRITES:
;   (none observed)
; DESC:
;   Opens a file via dos.library using the provided access mode.
; NOTES:
;   Direct pass-through to dos.library Open(name, mode).
;------------------------------------------------------------------------------
_DOS_OpenFileWithMode:
    MOVEM.L D2/D6-D7/A3,-(A7)

    SetOffsetForStack 4

    MOVEA.L .stackOffsetBytes+4(A7),A3
    MOVE.L  .stackOffsetBytes+8(A7),D7

    MOVE.L  A3,D1
    MOVE.L  D7,D2
    MOVEA.L _Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOOpen(A6)

    MOVE.L  D0,D6
    MOVE.L  D6,D0

    MOVEM.L (A7)+,D2/D6-D7/A3
    RTS

;!======