    XDEF    _DISKIO_EnsurePc1MountedAndGfxAssigned
    XDEF    DISKIO_EnsurePc1MountedAndGfxAssigned_Return



;------------------------------------------------------------------------------
; FUNC: _DISKIO_EnsurePc1MountedAndGfxAssigned   (Routine at _DISKIO_EnsurePc1MountedAndGfxAssigned)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A6/A7/D1/D2/D3
; CALLS:
;   _LVOExecute
; READS:
;   _Global_REF_DOS_LIBRARY_2, _DISKIO_Pc1MountAssignFlag, _DISKIO_CMD_MOUNT_PC1, _DISKIO_CMD_ASSIGN_GFX_PC1_EXPLICIT
; WRITES:
;   _DISKIO_Pc1MountAssignFlag
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_DISKIO_EnsurePc1MountedAndGfxAssigned:
    MOVEM.L D2-D3,-(A7)
    TST.W   _DISKIO_Pc1MountAssignFlag
    BNE.S   DISKIO_EnsurePc1MountedAndGfxAssigned_Return

    MOVE.W  #1,_DISKIO_Pc1MountAssignFlag
    LEA     _DISKIO_CMD_MOUNT_PC1,A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L _Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

    MOVE.L  D2,D3
    LEA     _DISKIO_CMD_ASSIGN_GFX_PC1_EXPLICIT,A0
    MOVE.L  A0,D1
    JSR     _LVOExecute(A6)

;------------------------------------------------------------------------------
; FUNC: DISKIO_EnsurePc1MountedAndGfxAssigned_Return   (Routine at DISKIO_EnsurePc1MountedAndGfxAssigned_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D2
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO_EnsurePc1MountedAndGfxAssigned_Return:
    MOVEM.L (A7)+,D2-D3
    RTS

;!======