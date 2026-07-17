    XDEF    _TESTFN
    XREF    ESQPARS2_BannerSnapshotPlane0DstPtr
    SECTION text,CODE
_TESTFN:
    MOVE.L  4(A7),A1
    MOVEM.L D1/A1-A4,-(A7)
    LEA     20(A1),A1
    LEA     ESQPARS2_BannerSnapshotPlane0DstPtr,A2
    MOVEA.L (A1),A3
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1
L94:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,L94
    MOVE.L  A3,(A1)+
    MOVEA.L (A1),A3
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1
L95:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,L95
    MOVE.L  A3,(A1)+
    MOVEA.L (A1),A3
    MOVEA.L (A2)+,A4
    MOVE.L  #$2b,D1
L96:
    MOVE.L  (A3)+,(A4)+
    DBF     D1,L96
    MOVE.L  A3,(A1)+
    MOVEM.L (A7)+,D1/A1-A4
    RTS
    END
