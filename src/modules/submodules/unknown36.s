LAB_1AB9:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    BTST    #1,27(A3)
    BEQ.S   LAB_1ABA

    MOVE.L  A3,-(A7)
    PEA     -1.W
    JSR     LAB_1916(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    BRA.S   LAB_1ABB

LAB_1ABA:
    MOVEQ   #0,D7

LAB_1ABB:
    MOVEQ   #12,D0
    AND.L   24(A3),D0
    BNE.S   LAB_1ABC

    TST.L   20(A3)
    BEQ.S   LAB_1ABC

    MOVE.L  20(A3),-(A7)
    MOVE.L  16(A3),-(A7)
    JSR     LAB_1A9D(PC)

    ADDQ.W  #8,A7

LAB_1ABC:
    CLR.L   24(A3)
    MOVE.L  28(A3),-(A7)
    JSR     LAB_1ACC(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D6
    MOVEQ   #-1,D0
    CMP.L   D0,D7
    BEQ.S   LAB_1ABD

    TST.L   D6
    BNE.S   LAB_1ABD

    MOVEQ   #0,D0

LAB_1ABD:
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

LAB_1ABE:
    LINK.W  A5,#-104
    MOVEM.L D2-D3/D6-D7/A6,-(A7)

    MOVEQ   #0,D7
    MOVEA.L -592(A4),A0
    MOVE.B  -1(A0),D7
    MOVEQ   #79,D0
    CMP.L   D0,D7
    BLE.S   LAB_1ABF

    MOVE.L  D0,D7

LAB_1ABF:
    MOVE.L  D7,D0
    LEA     -81(A5),A1
    BRA.S   LAB_1AC1

LAB_1AC0:
    MOVE.B  (A0)+,(A1)+

LAB_1AC1:
    SUBQ.L  #1,D0
    BCC.S   LAB_1AC0

    CLR.B   -81(A5,D7.L)
    MOVEA.L AbsExecBase,A6
    SUBA.L  A1,A1
    JSR     _LVOFindTask(A6)

    MOVE.L  D0,-90(A5)
    MOVEA.L D0,A0
    TST.L   172(A0)
    BEQ.S   LAB_1AC3

    MOVE.L  172(A0),D1
    ASL.L   #2,D1
    MOVEA.L D1,A1
    MOVE.L  56(A1),D6
    MOVEM.L D1,-98(A5)
    TST.L   D6
    BNE.S   LAB_1AC2

    MOVE.L  160(A0),D6

LAB_1AC2:
    TST.L   D6
    BEQ.S   LAB_1AC3

    MOVEA.L LocalDosLibraryDisplacement(A4),A6
    MOVE.L  D6,D1
    LEA     LAB_1ACA(PC),A0
    MOVE.L  A0,D2
    MOVEQ   #11,D3
    JSR     _LVOWrite(A6)

    MOVEA.L D7,A0
    ADDQ.L  #1,D7
    MOVE.L  A0,D0
    MOVE.B  #$a,-81(A5,D0.L)
    MOVEA.L LocalDosLibraryDisplacement(A4),A6
    MOVE.L  D6,D1
    MOVE.L  D7,D3
    LEA     -81(A5),A0
    MOVE.L  A0,D2
    JSR     _LVOWrite(A6)

    MOVEQ   #-1,D0
    BRA.S   LAB_1AC6

LAB_1AC3:
    MOVEA.L AbsExecBase,A6
    LEA     LOCAL_STR_INTUITION_LIBRARY(PC),A1
    MOVEQ   #0,D0
    JSR     _LVOOpenLibrary(A6)

    MOVE.L  D0,-102(A5)
    BNE.S   LAB_1AC4

    MOVEQ   #-1,D0
    BRA.S   LAB_1AC6

LAB_1AC4:
    LEA     -81(A5),A0
    MOVE.L  A0,-712(A4)
    MOVE.L  -102(A5),-(A7)
    PEA     60.W
    PEA     250.W
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -684(A4)
    PEA     -704(A4)
    PEA     -724(A4)
    CLR.L   -(A7)
    JSR     LAB_1A8C(PC)

    LEA     36(A7),A7
    SUBQ.L  #1,D0
    BEQ.S   LAB_1AC5

    MOVEQ   #-1,D0
    BRA.S   LAB_1AC6

LAB_1AC5:
    MOVEQ   #0,D0

LAB_1AC6:
    MOVEM.L (A7)+,D2-D3/D6-D7/A6
    UNLK    A5
    RTS

;!======

LAB_1AC7:
    DC.B    "** User Abort Requested **",0,0

LAB_1AC8:
    DC.B    "CONTINUE",0,0

LAB_1AC9:
    DC.B    "ABORT",0

LAB_1ACA:
    DC.B    "*** Break: ",0

LOCAL_STR_INTUITION_LIBRARY:
    DC.B    "intuition.library",0

;!======

    ; Alignment
    DS.W    3
    DC.W    $7061
