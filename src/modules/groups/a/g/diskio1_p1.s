    XDEF    DISKIO1_DumpProgramInfoAttrTable_Return
    XDEF    DISKIO1_DumpProgramSourceRecordVerbose_Return


;------------------------------------------------------------------------------
; FUNC: DISKIO1_DumpProgramInfoRecordVerbose   (Verbose dump of one program-info record)
; NOTES:
;   This function had NO LABEL. refbytes.py extracts label-to-label, so it was
;   being absorbed into _DISKIO1_DumpProgramSourceRecordVerbose above, which
;   therefore measured 754 bytes instead of its true 416. Labelling it is
;   byte-neutral -- both gates stay green -- and it needs no XDEF, because
;   nothing outside this module refers to it. See AGENTS.md, "...and not every
;   function has a label".
;------------------------------------------------------------------------------
DISKIO1_DumpProgramInfoRecordVerbose:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVE.L  20(A7),D7
    MOVE.L  D7,-(A7)
    PEA     DISKIO_FMT_PROGRAM_INFO_PCT_LD
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVE.L  A3,(A7)
    PEA     DISKIO_FMT_PROG_SRCE_PCT_S_VerboseProgramInfo
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     12(A7),A7
    MOVE.L  A3,D0
    BNE.S   .branch_6

    PEA     DISKIO_STR_NewlineOnly_A
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7
    BRA.W   DISKIO1_DumpProgramSourceRecordVerbose_Return

.branch_6:
    MOVEQ   #1,D6

.branch_7:
    MOVEQ   #49,D0
    CMP.L   D0,D6
    BGE.W   .branch_18

    MOVE.L  D6,D0
    ASL.L   #2,D0
    MOVEA.L _Global_REF_STR_CLOCK_FORMAT,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  7(A3,D6.L),D0
    MOVE.L  D0,-(A7)
    MOVE.L  (A0),-(A7)
    MOVE.L  D6,-(A7)
    PEA     DISKIO_FMT_PCT_02LD_PCT_S_COLON_ATTR_PCT_02LX
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     16(A7),A7
    MOVEQ   #1,D0
    CMP.B   7(A3,D6.L),D0
    BNE.S   .branch_8

    PEA     DISKIO_STR_NONE_VerboseProgramAttrFlags
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_8:
    BTST    #1,7(A3,D6.L)
    BEQ.S   .branch_9

    PEA     DISKIO_STR_MOVIE_VerboseProgramAttrFlags
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_9:
    BTST    #2,7(A3,D6.L)
    BEQ.S   .branch_10

    PEA     DISKIO_STR_ALTHILITE_PROG_VerboseProgramAttrFlags
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_10:
    BTST    #3,7(A3,D6.L)
    BEQ.S   .branch_11

    PEA     DISKIO_STR_TAG_PROG_VerboseProgramAttrFlags
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_11:
    BTST    #4,7(A3,D6.L)
    BEQ.S   .branch_12

    PEA     DISKIO_STR_0X10
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_12:
    BTST    #5,7(A3,D6.L)
    BEQ.S   .branch_13

    PEA     DISKIO_STR_0X20_VerboseProgramAttrFlags
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_13:
    BTST    #6,7(A3,D6.L)
    BEQ.S   .branch_14

    PEA     DISKIO_STR_0X40
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_14:
    BTST    #7,7(A3,D6.L)
    BEQ.S   .branch_15

    PEA     DISKIO_STR_PREV_DAYS_DATA_VerboseProgramAttrFlags
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_15:
    PEA     DISKIO_STR_ProgramAttrCloseAndProgPrefix
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7
    MOVE.L  D6,D0
    ASL.L   #2,D0
    TST.L   56(A3,D0.L)
    BEQ.S   .branch_16

    MOVE.L  56(A3,D0.L),-(A7)
    PEA     DISKIO_FMT_PCT_S_VerboseProgramStringLine
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #8,A7
    BRA.S   .branch_17

.branch_16:
    PEA     DISKIO_STR_NullLine
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_17:
    ADDQ.L  #1,D6
    BRA.W   .branch_7

.branch_18:
    PEA     DISKIO_STR_NewlineOnly_B
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

;------------------------------------------------------------------------------
; FUNC: DISKIO1_DumpProgramSourceRecordVerbose_Return   (Routine at DISKIO1_DumpProgramSourceRecordVerbose_Return)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +41: arg_3 (via 45(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A5/A7/D0/D1/D2/D3/D6/D7
; CALLS:
;   GROUP_AG_JMPTBL_LADFUNC2_EmitEscapedStringToScratch, _GROUP_AG_JMPTBL_STRING_CopyPadNul, _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   _Global_REF_STR_CLOCK_FORMAT, DISKIO1_DumpProgramInfoAttrTable_Return, DISKIO_FMT_PROGRAM_INFO_PCT_D, DISKIO_STR_NewlineOnly_C, DISKIO_FMT_PROG_SRCE_PCT_S_ProgramInfoAttrTable, DISKIO_FMT_PCT_02D_PCT_S_COLON_ATTR, DISKIO_STR_NONE_ProgramInfoAttrTable, DISKIO_STR_MOVIE_ProgramInfoAttrTable, DISKIO_STR_ALTHILITE_PROG_ProgramInfoAttrTable, DISKIO_STR_TAG_PROG_ProgramInfoAttrTable, DISKIO_STR_SPORTSPROG, DISKIO_STR_0X20_ProgramInfoAttrTable, DISKIO_STR_REPEATPROG, DISKIO_STR_PREV_DAYS_DATA_ProgramInfoAttrTable, DISKIO_STR_ProgramAttrCloseAndProgQuotedPrefix, DISKIO_TAG_NONE, DISKIO_FMT_ProgramStringSuffixWithTypeFields, branch, fc, lab_045E
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO1_DumpProgramSourceRecordVerbose_Return:
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

    LINK.W  A5,#-48
    MOVEM.L D2-D3/D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  D7,-(A7)
    PEA     DISKIO_FMT_PROGRAM_INFO_PCT_D
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  A3,D0
    BNE.S   .lab_0450

    PEA     DISKIO_STR_NewlineOnly_C
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    BRA.W   DISKIO1_DumpProgramInfoAttrTable_Return

.lab_0450:
    MOVE.L  A3,-(A7)
    PEA     DISKIO_FMT_PROG_SRCE_PCT_S_ProgramInfoAttrTable
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #8,A7
    CLR.B   -5(A5)
    MOVEQ   #1,D6

.branch:
    MOVEQ   #49,D0
    CMP.L   D0,D6
    BGE.W   DISKIO1_DumpProgramInfoAttrTable_Return

    MOVEQ   #1,D0
    CMP.B   7(A3,D6.L),D0
    BNE.S   .lab_0452

    MOVE.L  D6,D0
    ASL.L   #2,D0
    TST.L   56(A3,D0.L)
    BEQ.W   .lab_045E

.lab_0452:
    MOVE.L  D6,D0
    ASL.L   #2,D0
    MOVEA.L _Global_REF_STR_CLOCK_FORMAT,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    MOVE.L  D6,-(A7)
    PEA     DISKIO_FMT_PCT_02D_PCT_S_COLON_ATTR
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     12(A7),A7
    MOVEQ   #1,D0
    CMP.B   7(A3,D6.L),D0
    BNE.S   .branch_1

    PEA     DISKIO_STR_NONE_ProgramInfoAttrTable
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_1:
    BTST    #1,7(A3,D6.L)
    BEQ.S   .branch_2

    PEA     DISKIO_STR_MOVIE_ProgramInfoAttrTable
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_2:
    BTST    #2,7(A3,D6.L)
    BEQ.S   .branch_3

    PEA     DISKIO_STR_ALTHILITE_PROG_ProgramInfoAttrTable
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_3:
    BTST    #3,7(A3,D6.L)
    BEQ.S   .branch_4

    PEA     DISKIO_STR_TAG_PROG_ProgramInfoAttrTable
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_4:
    BTST    #4,7(A3,D6.L)
    BEQ.S   .branch_5

    PEA     DISKIO_STR_SPORTSPROG
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_5:
    BTST    #5,7(A3,D6.L)
    BEQ.S   .branch_6

    PEA     DISKIO_STR_0X20_ProgramInfoAttrTable
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_6:
    BTST    #6,7(A3,D6.L)
    BEQ.S   .branch_7

    PEA     DISKIO_STR_REPEATPROG
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_7:
    BTST    #7,7(A3,D6.L)
    BEQ.S   .branch_8

    PEA     DISKIO_STR_PREV_DAYS_DATA_ProgramInfoAttrTable
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_8:
    PEA     DISKIO_STR_ProgramAttrCloseAndProgQuotedPrefix
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7
    MOVE.L  D6,D0
    ASL.L   #2,D0
    TST.L   56(A3,D0.L)
    BEQ.S   .branch_9

    PEA     40.W
    MOVE.L  56(A3,D0.L),-(A7)
    PEA     -45(A5)
    JSR     _GROUP_AG_JMPTBL_STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    BRA.S   .branch_11

.branch_9:
    LEA     DISKIO_TAG_NONE,A0
    LEA     -45(A5),A1

.branch_10:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .branch_10

.branch_11:
    PEA     -45(A5)
    JSR     GROUP_AG_JMPTBL_LADFUNC2_EmitEscapedStringToScratch(PC)

    MOVEQ   #0,D0
    MOVE.L  D6,D1
    ADDI.L  #$fc,D1
    MOVE.B  0(A3,D1.L),D0
    MOVEQ   #0,D1
    MOVE.L  D6,D2
    ADDI.L  #$12d,D2
    MOVE.B  0(A3,D2.L),D1
    MOVEQ   #0,D2
    MOVE.L  D6,D3
    ADDI.L  #$15e,D3
    MOVE.B  0(A3,D3.L),D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     DISKIO_FMT_ProgramStringSuffixWithTypeFields
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     16(A7),A7

.lab_045E:
    ADDQ.L  #1,D6
    BRA.W   .branch

;------------------------------------------------------------------------------
; FUNC: DISKIO1_DumpProgramInfoAttrTable_Return   (Routine at DISKIO1_DumpProgramInfoAttrTable_Return)
; ARGS:
;   stack +64: arg_1 (via 68(A5))
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
DISKIO1_DumpProgramInfoAttrTable_Return:
    MOVEM.L -68(A5),D2-D3/D6-D7/A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD
