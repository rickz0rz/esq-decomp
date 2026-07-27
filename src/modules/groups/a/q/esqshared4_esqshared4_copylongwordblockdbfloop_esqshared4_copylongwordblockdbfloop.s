    XDEF    _ESQSHARED4_CopyLongwordBlockDbfLoop
    XDEF    ESQSHARED4_CopyLivePlanesToSnapshot



;------------------------------------------------------------------------------
; FUNC: ESQSHARED4_CopyLivePlanesToSnapshot   (Routine at ESQSHARED4_CopyLivePlanesToSnapshot)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A1/A2/A3/A4/A7/D1
; CALLS:
;   (none)
; READS:
;   _ESQPARS2_BannerSnapshotPlane0DstPtr, _ESQSHARED_LivePlaneBase0, _ESQSHARED_LivePlaneBase1, _ESQSHARED_LivePlaneBase2, lab_0C98, lab_0C99
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQSHARED4_CopyLivePlanesToSnapshot:
    MOVEM.L D0-D1/A0-A4,-(A7)
    LEA     _ESQSHARED_LivePlaneBase0,A1
    MOVEA.L (A1),A3
    LEA     _ESQPARS2_BannerSnapshotPlane0DstPtr,A2
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1

.lab_0C98:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,.lab_0C98
    LEA     _ESQSHARED_LivePlaneBase1,A1
    MOVEA.L (A1),A3
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1

.lab_0C99:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,.lab_0C99
    LEA     _ESQSHARED_LivePlaneBase2,A1
    MOVEA.L (A1),A3
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1

;------------------------------------------------------------------------------
; FUNC: _ESQSHARED4_CopyLongwordBlockDbfLoop   (Routine at _ESQSHARED4_CopyLongwordBlockDbfLoop)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A4/D0
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
_ESQSHARED4_CopyLongwordBlockDbfLoop:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,_ESQSHARED4_CopyLongwordBlockDbfLoop
    MOVEM.L (A7)+,D0-D1/A0-A4
    RTS

;!======