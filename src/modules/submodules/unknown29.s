LAB_1A76:
    LINK.W  A5,#-16
    MOVEM.L D2/D7/A2-A3/A6,-(A7)

    SetOffsetForStack   5
    UseStackLong    MOVEA.L,6,A3

LAB_1A77:
    CMPI.L  #' ',22914(A4)
    BGE.W   LAB_1A82

LAB_1A78:
    MOVE.B  (A3),D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BEQ.S   LAB_1A79

    MOVEQ   #9,D1
    CMP.B   D1,D0
    BEQ.S   LAB_1A79

    MOVEQ   #10,D1
    CMP.B   D1,D0
    BNE.S   LAB_1A7A

LAB_1A79:
    ADDQ.L  #1,A3
    BRA.S   LAB_1A78

LAB_1A7A:
    TST.B   (A3)
    BEQ.S   LAB_1A82

    MOVE.L  22914(A4),D0
    ASL.L   #2,D0
    ADDQ.L  #1,22914(A4)
    LEA     22922(A4),A0
    ADDA.L  D0,A0
    MOVEA.L A0,A2
    MOVEQ   #34,D0
    CMP.B   (A3),D0
    BNE.S   LAB_1A7E

    ADDQ.L  #1,A3
    MOVE.L  A3,(A2)

LAB_1A7B:
    TST.B   (A3)
    BEQ.S   LAB_1A7C

    MOVEQ   #34,D0
    CMP.B   (A3),D0
    BEQ.S   LAB_1A7C

    ADDQ.L  #1,A3
    BRA.S   LAB_1A7B

LAB_1A7C:
    TST.B   (A3)
    BNE.S   LAB_1A7D

    PEA     1.W
    JSR     LAB_1A92(PC)

    ADDQ.W  #4,A7
    BRA.S   LAB_1A77

LAB_1A7D:
    CLR.B   (A3)+
    BRA.S   LAB_1A77

LAB_1A7E:
    MOVE.L  A3,(A2)

LAB_1A7F:
    TST.B   (A3)
    BEQ.S   LAB_1A80

    MOVE.B  (A3),D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BEQ.S   LAB_1A80

    MOVEQ   #9,D1
    CMP.B   D1,D0
    BEQ.S   LAB_1A80

    MOVEQ   #10,D1
    CMP.B   D1,D0
    BEQ.S   LAB_1A80

    ADDQ.L  #1,A3
    BRA.S   LAB_1A7F

LAB_1A80:
    TST.B   (A3)
    BNE.S   LAB_1A81

    BRA.S   LAB_1A82

LAB_1A81:
    CLR.B   (A3)+
    BRA.W   LAB_1A77

LAB_1A82:
    TST.L   22914(A4)
    BNE.S   LAB_1A83

    MOVEA.L -604(A4),A0
    BRA.S   LAB_1A84

LAB_1A83:
    LEA     22922(A4),A0

LAB_1A84:
    MOVE.L  A0,22918(A4)
    TST.L   22914(A4)
    BNE.S   LAB_1A85

    LEA     GLOB_STR_CON_10_10_320_80(PC),A1
    LEA     22856(A4),A6
    MOVE.L  (A1)+,(A6)+
    MOVE.L  (A1)+,(A6)+
    MOVE.L  (A1)+,(A6)+
    MOVE.L  (A1)+,(A6)+
    MOVE.W  (A1),(A6)
    MOVEA.L -604(A4),A1
    MOVEA.L 36(A1),A0
    PEA     40.W
    MOVE.L  4(A0),-(A7)
    PEA     22856(A4)
    JSR     LAB_1962(PC)

    LEA     12(A7),A7
    MOVEA.L LocalDosLibraryDisplacement(A4),A6
    LEA     22856(A4),A0
    MOVE.L  A0,D1
    MOVE.L  #MODE_NEWFILE,D2
    JSR     _LVOOpen(A6)

    MOVE.L  D0,22496(A4)
    MOVE.L  D0,22504(A4)
    MOVEQ   #16,D1
    MOVE.L  D1,22500(A4)
    MOVE.L  D0,22512(A4)
    MOVE.L  D1,22508(A4)
    ASL.L   #2,D0
    MOVE.L  D0,-16(A5)
    MOVEA.L AbsExecBase,A6
    SUBA.L  A1,A1
    JSR     _LVOFindTask(A6)

    MOVEA.L -16(A5),A0
    MOVEA.L D0,A1
    MOVE.L  8(A0),164(A1)
    MOVEQ   #0,D7
    MOVE.L  D0,-12(A5)
    BRA.S   LAB_1A86

LAB_1A85:
    MOVEA.L LocalDosLibraryDisplacement(A4),A6
    JSR     _LVOInput(A6)

    MOVE.L  D0,22496(A4)    ; Original input file handle
    JSR     _LVOOutput(A6)

    MOVE.L  D0,22504(A4)    ; Original output file handle
    LEA     GLOB_STR_ASTERISK_1(PC),A0
    MOVE.L  A0,D1
    MOVE.L  #MODE_OLDFILE,D2
    JSR     _LVOOpen(A6)

    MOVE.L  D0,22512(A4)
    MOVEQ   #16,D7

LAB_1A86:
    MOVE.L  D7,D0
    ORI.W   #$8001,D0
    OR.L    D0,22492(A4)
    MOVE.L  D7,D0
    ORI.W   #$8002,D0
    OR.L    D0,22500(A4)
    ORI.L   #$8003,22508(A4) ; memory thing?
    TST.L   -1016(A4)
    BEQ.S   LAB_1A87

    MOVEQ   #0,D0
    BRA.S   LAB_1A88

LAB_1A87:
    MOVE.L  #$8000,D0

LAB_1A88:
    MOVE.L  D0,D7
    CLR.L   -1092(A4)
    MOVE.L  D7,D0
    ORI.W   #1,D0
    MOVE.L  D0,-1096(A4)
    MOVEQ   #1,D0
    MOVE.L  D0,-1058(A4)
    MOVE.L  D7,D0
    ORI.W   #2,D0
    MOVE.L  D0,-1062(A4)
    MOVEQ   #2,D0
    MOVE.L  D0,-1024(A4)
    MOVE.L  D7,D0
    ORI.W   #$80,D0
    MOVE.L  D0,-1028(A4)
    LEA     UNKNOWN36_ShowAbortRequester(PC),A0
    MOVE.L  A0,-616(A4)
    MOVE.L  22918(A4),-(A7)
    MOVE.L  22914(A4),-(A7)
    JSR     WDISP_JMPTBL_ESQ_MainInitAndRun(PC)

    CLR.L   (A7)
    JSR     LIBRARIES_LOAD_FAILED(PC)

    MOVEM.L -36(A5),D2/D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

GLOB_STR_CON_10_10_320_80:
    NStr    "con.10/10/320/80/"

GLOB_STR_ASTERISK_1:
    NStr    "*"

;!======

WDISP_JMPTBL_ESQ_MainInitAndRun:
LAB_1A8B:
    JMP     ESQ_MainInitAndRun

;!======

    ; Alignment
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    MOVEQ   #97,D0
