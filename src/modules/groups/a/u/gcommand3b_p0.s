

    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEA.L 24(A7),A2
    MOVE.L  A3,-(A7)
    PEA     _GCOMMAND_FMT_PCT_S_COLON
    JSR     _GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    PEA     _GCOMMAND_STR_GRADIENT
    JSR     _GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D7

.lab_0D6F:
    MOVEQ   #16,D0
    CMP.L   D0,D7
    BGE.S   .lab_0D72

    MOVE.L  D7,D0
    ADD.L   D0,D0
    MOVE.W  0(A2,D0.L),D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D7,-(A7)
    PEA     _GCOMMAND_FMT_COLOR_PCT_D_PCT_D
    JSR     _GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D6

.lab_0D70:
    MOVE.L  D7,D0
    ADD.L   D0,D0
    MOVE.W  0(A2,D0.L),D1
    EXT.L   D1
    CMP.L   D1,D6
    BGE.S   .lab_0D71

    MOVE.L  D7,D0
    ASL.L   #7,D0
    MOVEA.L A2,A0
    ADDA.L  D0,A0
    MOVE.L  D6,D0
    ADD.L   D0,D0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.W  32(A0),D0
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    PEA     _GCOMMAND_FMT_PCT_D_PCT_03X
    JSR     _GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D6
    BRA.S   .lab_0D70

.lab_0D71:
    ADDQ.L  #1,D7
    BRA.S   .lab_0D6F

.lab_0D72:
    PEA     _GCOMMAND_FMT_TABLE_DONE_WITH_LEADING_BLANK_LINE
    JSR     _GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======