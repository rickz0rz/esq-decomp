    XDEF    _DISKIO_ResetCtrlInputStateIfIdle


;------------------------------------------------------------------------------
; FUNC: _DISKIO_ResetCtrlInputStateIfIdle   (Routine at _DISKIO_ResetCtrlInputStateIfIdle)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A6/D0
; CALLS:
;   _LVODisable, _LVOEnable
; READS:
;   AbsExecBase, _Global_UIBusyFlag
; WRITES:
;   _CTRL_H, _ESQPARS2_ReadModeFlags, _CTRL_HPreviousSample, _CTRL_BufferedByteCount, _Global_RefreshTickCounter
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_DISKIO_ResetCtrlInputStateIfIdle:
    TST.W   _Global_UIBusyFlag
    BNE.S   .return

    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    MOVEQ   #0,D0
    MOVE.W  D0,_CTRL_BufferedByteCount
    MOVE.W  D0,_CTRL_HPreviousSample
    MOVE.W  D0,_CTRL_H
    JSR     _LVOEnable(A6)

    MOVEQ   #0,D0
    MOVE.W  D0,_Global_RefreshTickCounter
    MOVE.W  D0,_ESQPARS2_ReadModeFlags

.return:
    RTS

;!======