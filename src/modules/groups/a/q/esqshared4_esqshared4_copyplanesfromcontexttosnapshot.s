    XDEF    _ESQSHARED4_CopyPlanesFromContextToSnapshot


;------------------------------------------------------------------------------
; FUNC: _ESQSHARED4_CopyPlanesFromContextToSnapshot   (Routine at _ESQSHARED4_CopyPlanesFromContextToSnapshot)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A1/A2/A3/A4/A7/D1
; CALLS:
;   (none)
; READS:
;   _ESQPARS2_BannerSnapshotPlane0DstPtr, lab_0C94, lab_0C95, lab_0C96
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_ESQSHARED4_CopyPlanesFromContextToSnapshot:
    MOVEM.L D1/A1-A4,-(A7)
    LEA     20(A1),A1
    LEA     _ESQPARS2_BannerSnapshotPlane0DstPtr,A2
    MOVEA.L (A1),A3
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1

.lab_0C94:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,.lab_0C94
    MOVE.L  A3,(A1)+
    MOVEA.L (A1),A3
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1

.lab_0C95:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,.lab_0C95
    MOVE.L  A3,(A1)+
    MOVEA.L (A1),A3
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1

.lab_0C96:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,.lab_0C96
    MOVE.L  A3,(A1)+
    MOVEM.L (A7)+,D1/A1-A4
    RTS

;!======