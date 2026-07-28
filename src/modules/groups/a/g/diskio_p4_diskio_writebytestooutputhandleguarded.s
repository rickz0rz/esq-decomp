    XDEF    _DISKIO_WriteBytesToOutputHandleGuarded


;------------------------------------------------------------------------------
; FUNC: _DISKIO_WriteBytesToOutputHandleGuarded   (Routine at _DISKIO_WriteBytesToOutputHandleGuarded)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A6/A7/D0/D1/D2/D3/D6/D7
; CALLS:
;   _LVOWrite
; READS:
;   Global_REF_DOS_LIBRARY_2, _ESQPARS2_ReadModeFlags, _DISKIO_WriteFileHandle, _DISKIO_SavedReadModeFlags
; WRITES:
;   _ESQPARS2_ReadModeFlags, _DISKIO_SavedReadModeFlags
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_DISKIO_WriteBytesToOutputHandleGuarded:
    MOVEM.L D2-D3/D6-D7/A3,-(A7)

    MOVEA.L 24(A7),A3
    MOVE.W  30(A7),D7
    MOVE.W  _ESQPARS2_ReadModeFlags,_DISKIO_SavedReadModeFlags
    MOVE.W  #$100,_ESQPARS2_ReadModeFlags
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  A3,D2
    MOVE.L  D0,D3
    MOVE.L  _DISKIO_WriteFileHandle,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOWrite(A6)

    MOVE.L  D0,D6
    CMP.W   D7,D6
    MOVE.W  _DISKIO_SavedReadModeFlags,_ESQPARS2_ReadModeFlags
    CMP.W   D7,D6
    BEQ.S   .lab_03C9

    MOVEQ   #-1,D0
    BRA.S   .return

.lab_03C9:
    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,D2-D3/D6-D7/A3
    RTS

;!======