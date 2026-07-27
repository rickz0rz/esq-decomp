    XDEF    _ESQSHARED4_SnapshotDisplayBufferBases


;------------------------------------------------------------------------------
; FUNC: _ESQSHARED4_SnapshotDisplayBufferBases   (Routine at _ESQSHARED4_SnapshotDisplayBufferBases)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A1/A7
; CALLS:
;   (none)
; READS:
;   ESQSHARED_LivePlaneBase0, ESQSHARED_LivePlaneBase1, _ESQSHARED_LivePlaneBase2
; WRITES:
;   _ESQPARS2_SnapshotLivePlane0Base, ESQPARS2_SnapshotLivePlane1Base, _ESQPARS2_SnapshotLivePlane2Base
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_ESQSHARED4_SnapshotDisplayBufferBases:
    MOVE.L  A1,-(A7)
    LEA     ESQSHARED_LivePlaneBase0,A1
    MOVE.L  (A1),_ESQPARS2_SnapshotLivePlane0Base
    LEA     ESQSHARED_LivePlaneBase1,A1
    MOVE.L  (A1),ESQPARS2_SnapshotLivePlane1Base
    LEA     _ESQSHARED_LivePlaneBase2,A1
    MOVE.L  (A1),_ESQPARS2_SnapshotLivePlane2Base
    MOVEA.L (A7)+,A1
    RTS

;!======