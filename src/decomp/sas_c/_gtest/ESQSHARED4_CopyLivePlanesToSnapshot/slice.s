    XDEF    _TESTFN
    XREF    ESQSHARED_LivePlaneBase0
    XREF    ESQSHARED_LivePlaneBase1
    XREF    ESQSHARED_LivePlaneBase2
    XREF    ESQPARS2_BannerSnapshotPlane0DstPtr
    SECTION text,CODE
_TESTFN:
    MOVEM.L D0-D1/A0-A4,-(A7)
    LEA     ESQSHARED_LivePlaneBase0,A1
    MOVEA.L (A1),A3
    LEA     ESQPARS2_BannerSnapshotPlane0DstPtr,A2
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1
L_98:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,L_98
    LEA     ESQSHARED_LivePlaneBase1,A1
    MOVEA.L (A1),A3
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1
L_99:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,L_99
    LEA     ESQSHARED_LivePlaneBase2,A1
    MOVEA.L (A1),A3
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1
L_copy:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,L_copy
    MOVEM.L (A7)+,D0-D1/A0-A4
    RTS
    END
