    XDEF    _DISKIO1_DumpProgramSourceRecordVerbose


;------------------------------------------------------------------------------
; FUNC: _DISKIO1_DumpProgramSourceRecordVerbose   (Routine at _DISKIO1_DumpProgramSourceRecordVerbose)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   _Global_REF_STR_CLOCK_FORMAT, DISKIO1_DumpProgramSourceRecordVerbose_Return, _DISKIO_FMT_CHANNEL_LINE_UP_PCT_D, _DISKIO_FMT_ETID_PCT_D_CHAN_NUM_PCT_S_SOURCE_PCT, _DISKIO_STR_ATTR, _DISKIO_STR_NONE_VerboseSourceAttrFlags, _DISKIO_STR_HILITE_SRC_VerboseSourceAttrFlags, _DISKIO_STR_SUM_SRC_VerboseSourceAttrFlags, _DISKIO_STR_VIDEO_TAG_DISABLE_VerboseSourceAttrFlags, _DISKIO_STR_PPV_SRC_VerboseSourceAttrFlags, _DISKIO_STR_DITTO_VerboseSourceAttrFlags, _DISKIO_STR_ALTHILITESRC_VerboseSourceAttrFlags, _DISKIO_STR_STEREO, _DISKIO_STR_ProgramAttrCloseParenNewline, _DISKIO_FMT_TSLT_MASK_PCT_02X_PCT_02X_PCT_02X_PC, _DISKIO_FMT_BLKOUT_MASK_PCT_02X_PCT_02X_PCT_02X_, _DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG2_0X_PCT_04X_BG_VerboseSourceRecord, DISKIO_FMT_PROGRAM_INFO_PCT_LD, DISKIO_FMT_PROG_SRCE_PCT_S_VerboseProgramInfo, DISKIO_STR_NewlineOnly_A, DISKIO_FMT_PCT_02LD_PCT_S_COLON_ATTR_PCT_02LX, DISKIO_STR_NONE_VerboseProgramAttrFlags, DISKIO_STR_MOVIE_VerboseProgramAttrFlags, DISKIO_STR_ALTHILITE_PROG_VerboseProgramAttrFlags, DISKIO_STR_TAG_PROG_VerboseProgramAttrFlags, DISKIO_STR_0X10, DISKIO_STR_0X20_VerboseProgramAttrFlags, DISKIO_STR_0X40, DISKIO_STR_PREV_DAYS_DATA_VerboseProgramAttrFlags, DISKIO_STR_ProgramAttrCloseAndProgPrefix, DISKIO_FMT_PCT_S_VerboseProgramStringLine, DISKIO_STR_NullLine, DISKIO_STR_NewlineOnly_B, branch_18, branch_7
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_DISKIO1_DumpProgramSourceRecordVerbose:
    MOVEM.L D2-D5/D7/A2-A3,-(A7)
    MOVEA.L 32(A7),A3
    MOVE.L  36(A7),D7
    MOVE.L  D7,-(A7)
    PEA     _DISKIO_FMT_CHANNEL_LINE_UP_PCT_D
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    LEA     1(A3),A0
    LEA     12(A3),A1
    LEA     19(A3),A2
    MOVE.L  A2,(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     _DISKIO_FMT_ETID_PCT_D_CHAN_NUM_PCT_S_SOURCE_PCT
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    PEA     _DISKIO_STR_ATTR
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     28(A7),A7
    MOVEQ   #1,D0
    CMP.B   27(A3),D0
    BNE.S   .lab_043A

    PEA     _DISKIO_STR_NONE_VerboseSourceAttrFlags
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.lab_043A:
    BTST    #1,27(A3)
    BEQ.S   .lab_043B

    PEA     _DISKIO_STR_HILITE_SRC_VerboseSourceAttrFlags
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.lab_043B:
    BTST    #2,27(A3)
    BEQ.S   .branch

    PEA     _DISKIO_STR_SUM_SRC_VerboseSourceAttrFlags
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch:
    BTST    #3,27(A3)
    BEQ.S   .branch_1

    PEA     _DISKIO_STR_VIDEO_TAG_DISABLE_VerboseSourceAttrFlags
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_1:
    BTST    #4,27(A3)
    BEQ.S   .branch_2

    PEA     _DISKIO_STR_PPV_SRC_VerboseSourceAttrFlags
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_2:
    BTST    #5,27(A3)
    BEQ.S   .branch_3

    PEA     _DISKIO_STR_DITTO_VerboseSourceAttrFlags
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_3:
    BTST    #6,27(A3)
    BEQ.S   .branch_4

    PEA     _DISKIO_STR_ALTHILITESRC_VerboseSourceAttrFlags
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_4:
    BTST    #7,27(A3)
    BEQ.S   .branch_5

    PEA     _DISKIO_STR_STEREO
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_5:
    PEA     _DISKIO_STR_ProgramAttrCloseParenNewline
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.B  28(A3),D0
    MOVEQ   #0,D1
    MOVE.B  29(A3),D1
    MOVEQ   #0,D2
    MOVE.B  30(A3),D2
    MOVEQ   #0,D3
    MOVE.B  31(A3),D3
    MOVEQ   #0,D4
    MOVE.B  32(A3),D4
    MOVEQ   #0,D5
    MOVE.B  33(A3),D5
    MOVE.L  D5,(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     _DISKIO_FMT_TSLT_MASK_PCT_02X_PCT_02X_PCT_02X_PC
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.B  34(A3),D0
    MOVEQ   #0,D1
    MOVE.B  35(A3),D1
    MOVEQ   #0,D2
    MOVE.B  36(A3),D2
    MOVEQ   #0,D3
    MOVE.B  37(A3),D3
    MOVEQ   #0,D4
    MOVE.B  38(A3),D4
    MOVEQ   #0,D5
    MOVE.B  39(A3),D5
    MOVE.L  D5,(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     _DISKIO_FMT_BLKOUT_MASK_PCT_02X_PCT_02X_PCT_02X_
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.B  40(A3),D0
    MOVEQ   #0,D1
    MOVE.W  46(A3),D1
    MOVEQ   #0,D2
    MOVE.B  41(A3),D2
    MOVEQ   #0,D3
    MOVE.B  42(A3),D3
    LEA     43(A3),A0
    MOVE.L  A0,(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     _DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG2_0X_PCT_04X_BG_VerboseSourceRecord
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     72(A7),A7
    MOVEM.L (A7)+,D2-D5/D7/A2-A3
    RTS

;!======