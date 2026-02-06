; Unreachable Code?
    LINK.W  A5,#-36
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  D7,-(A7)
    PEA     DATA_DISKIO_FMT_CHANNEL_LINE_UP_PCT_LD_1BED
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_DISKIO_FMT_ETID_PCT_LD_PCT_02LX_1BEE
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     1(A3),A0
    MOVE.L  A0,(A7)
    PEA     DATA_DISKIO_FMT_CHAN_NUM_PCT_S_1BEF
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     12(A3),A0
    MOVE.L  A0,(A7)
    PEA     DATA_DISKIO_FMT_SOURCE_PCT_S_1BF0
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     19(A3),A0
    MOVE.L  A0,(A7)
    PEA     DATA_DISKIO_FMT_CALL_LET_PCT_S_1BF1
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.B  27(A3),D0
    MOVE.L  D0,(A7)
    PEA     DATA_DISKIO_FMT_ATTR_PCT_02LX_1BF2
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     32(A7),A7
    MOVEQ   #1,D0
    CMP.B   27(A3),D0
    BNE.S   DISKIO1_AppendAttrFlagHiliteSrc

    PEA     DATA_DISKIO_STR_NONE_1BF3
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

;------------------------------------------------------------------------------
; FUNC: DISKIO1_AppendAttrFlagHiliteSrc   (Routine at DISKIO1_AppendAttrFlagHiliteSrc)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A3/A7
; CALLS:
;   GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   DATA_DISKIO_STR_HILITE_SRC_1BF4
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO1_AppendAttrFlagHiliteSrc:
    BTST    #1,27(A3)
    BEQ.S   DISKIO1_AppendAttrFlagSummarySrc

    PEA     DATA_DISKIO_STR_HILITE_SRC_1BF4
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

;------------------------------------------------------------------------------
; FUNC: DISKIO1_AppendAttrFlagSummarySrc   (Routine at DISKIO1_AppendAttrFlagSummarySrc)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A3/A7
; CALLS:
;   GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   DATA_DISKIO_STR_SUM_SRC_1BF5
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO1_AppendAttrFlagSummarySrc:
    BTST    #2,27(A3)
    BEQ.S   DISKIO1_AppendAttrFlagVideoTagDisable

    PEA     DATA_DISKIO_STR_SUM_SRC_1BF5
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

;------------------------------------------------------------------------------
; FUNC: DISKIO1_AppendAttrFlagVideoTagDisable   (Routine at DISKIO1_AppendAttrFlagVideoTagDisable)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A3/A7
; CALLS:
;   GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   DATA_DISKIO_STR_VIDEO_TAG_DISABLE_1BF6
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO1_AppendAttrFlagVideoTagDisable:
    BTST    #3,27(A3)
    BEQ.S   DISKIO1_AppendAttrFlagPpvSrc

    PEA     DATA_DISKIO_STR_VIDEO_TAG_DISABLE_1BF6
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

;------------------------------------------------------------------------------
; FUNC: DISKIO1_AppendAttrFlagPpvSrc   (Routine at DISKIO1_AppendAttrFlagPpvSrc)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A3/A7
; CALLS:
;   GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   DATA_DISKIO_STR_PPV_SRC_1BF7
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO1_AppendAttrFlagPpvSrc:
    BTST    #4,27(A3)
    BEQ.S   DISKIO1_AppendAttrFlagDitto

    PEA     DATA_DISKIO_STR_PPV_SRC_1BF7
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

;------------------------------------------------------------------------------
; FUNC: DISKIO1_AppendAttrFlagDitto   (Routine at DISKIO1_AppendAttrFlagDitto)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A3/A7
; CALLS:
;   GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   DATA_DISKIO_STR_DITTO_1BF8
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO1_AppendAttrFlagDitto:
    BTST    #5,27(A3)
    BEQ.S   DISKIO1_AppendAttrFlagAltHiliteSrc

    PEA     DATA_DISKIO_STR_DITTO_1BF8
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

;------------------------------------------------------------------------------
; FUNC: DISKIO1_AppendAttrFlagAltHiliteSrc   (Routine at DISKIO1_AppendAttrFlagAltHiliteSrc)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A3/A7
; CALLS:
;   GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   DATA_DISKIO_STR_ALTHILITESRC_1BF9
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO1_AppendAttrFlagAltHiliteSrc:
    BTST    #6,27(A3)
    BEQ.S   DISKIO1_AppendAttrFlagBit7

    PEA     DATA_DISKIO_STR_ALTHILITESRC_1BF9
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

;------------------------------------------------------------------------------
; FUNC: DISKIO1_AppendAttrFlagBit7   (Routine at DISKIO1_AppendAttrFlagBit7)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A3/A7
; CALLS:
;   GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   DATA_DISKIO_STR_0X80_1BFA
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO1_AppendAttrFlagBit7:
    BTST    #7,27(A3)
    BEQ.S   DISKIO1_FormatTimeSlotMaskFlags

    PEA     DATA_DISKIO_STR_0X80_1BFA
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

;------------------------------------------------------------------------------
; FUNC: DISKIO1_FormatTimeSlotMaskFlags   (Routine at DISKIO1_FormatTimeSlotMaskFlags)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1/D2/D3/D5/D6
; CALLS:
;   GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   DATA_DISKIO_STR_VALUE_1BFB, DATA_DISKIO_FMT_TSLT_MASK_PCT_02LX_PCT_02LX_PCT_02LX_1BFC
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO1_FormatTimeSlotMaskFlags:
    PEA     DATA_DISKIO_STR_VALUE_1BFB
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.B  28(A3),D0
    MOVEQ   #0,D1
    MOVE.B  29(A3),D1
    MOVEQ   #0,D2
    MOVE.B  30(A3),D2
    MOVEQ   #0,D3
    MOVE.B  31(A3),D3
    MOVE.L  D0,32(A7)
    MOVEQ   #0,D0
    MOVE.B  32(A3),D0
    MOVE.L  D0,48(A7)
    MOVEQ   #0,D0
    MOVE.B  33(A3),D0
    MOVE.L  D0,(A7)
    MOVE.L  48(A7),-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  48(A7),-(A7)
    PEA     DATA_DISKIO_FMT_TSLT_MASK_PCT_02LX_PCT_02LX_PCT_02LX_1BFC
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     28(A7),A7
    MOVEQ   #0,D5
    MOVEQ   #0,D6

;------------------------------------------------------------------------------
; FUNC: DISKIO1_AccumulateTimeSlotMaskSum   (Routine at DISKIO1_AccumulateTimeSlotMaskSum)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D5/D6
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
DISKIO1_AccumulateTimeSlotMaskSum:
    MOVEQ   #6,D0
    CMP.L   D0,D6
    BGE.S   DISKIO1_AppendTimeSlotMaskNoneIfAllBitsSet

    MOVEQ   #0,D0
    MOVE.B  28(A3,D6.L),D0
    ADD.L   D0,D5
    ADDQ.L  #1,D6
    BRA.S   DISKIO1_AccumulateTimeSlotMaskSum

;------------------------------------------------------------------------------
; FUNC: DISKIO1_AppendTimeSlotMaskNoneIfAllBitsSet   (Routine at DISKIO1_AppendTimeSlotMaskNoneIfAllBitsSet)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7/D5
; CALLS:
;   GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   DATA_DISKIO_STR_NONE_1BFD
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO1_AppendTimeSlotMaskNoneIfAllBitsSet:
    CMPI.L  #$5fa,D5
    BNE.S   DISKIO1_AppendTimeSlotMaskOffAirIfEmpty

    PEA     DATA_DISKIO_STR_NONE_1BFD
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7
    BRA.S   DISKIO1_FormatBlackoutMaskFlags

;------------------------------------------------------------------------------
; FUNC: DISKIO1_AppendTimeSlotMaskOffAirIfEmpty   (Routine at DISKIO1_AppendTimeSlotMaskOffAirIfEmpty)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7
; CALLS:
;   GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   GLOB_STR_OFF_AIR_2
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO1_AppendTimeSlotMaskOffAirIfEmpty:
    TST.L   D5
    BNE.S   DISKIO1_AppendTimeSlotMaskValueHeader

    PEA     GLOB_STR_OFF_AIR_2
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7
    BRA.S   DISKIO1_FormatBlackoutMaskFlags

;------------------------------------------------------------------------------
; FUNC: DISKIO1_AppendTimeSlotMaskValueHeader   (Routine at DISKIO1_AppendTimeSlotMaskValueHeader)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7/D4
; CALLS:
;   GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   DATA_DISKIO_STR_VALUE_1BFF
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO1_AppendTimeSlotMaskValueHeader:
    PEA     DATA_DISKIO_STR_VALUE_1BFF
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7
    MOVEQ   #1,D4

;------------------------------------------------------------------------------
; FUNC: DISKIO1_AppendTimeSlotMaskSelectedTimes   (Routine at DISKIO1_AppendTimeSlotMaskSelectedTimes)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0/D1/D4
; CALLS:
;   ESQ_TestBit1Based, GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   GLOB_REF_STR_CLOCK_FORMAT, DATA_DISKIO_FMT_PCT_S_1C00
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO1_AppendTimeSlotMaskSelectedTimes:
    MOVEQ   #49,D0
    CMP.B   D0,D4
    BCC.S   DISKIO1_AppendTimeSlotMaskValueTerminator

    LEA     28(A3),A0
    MOVEQ   #0,D0
    MOVE.B  D4,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BEQ.S   DISKIO1_AdvanceTimeSlotBitIndex

    MOVEQ   #0,D0
    MOVE.B  D4,D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    MOVEA.L GLOB_REF_STR_CLOCK_FORMAT,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-(A7)
    PEA     DATA_DISKIO_FMT_PCT_S_1C00
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #8,A7

;------------------------------------------------------------------------------
; FUNC: DISKIO1_AdvanceTimeSlotBitIndex   (Routine at DISKIO1_AdvanceTimeSlotBitIndex)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D4
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
DISKIO1_AdvanceTimeSlotBitIndex:
    ADDQ.B  #1,D4
    BRA.S   DISKIO1_AppendTimeSlotMaskSelectedTimes

;------------------------------------------------------------------------------
; FUNC: DISKIO1_AppendTimeSlotMaskValueTerminator   (Routine at DISKIO1_AppendTimeSlotMaskValueTerminator)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7
; CALLS:
;   GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   DATA_DISKIO_STR_VALUE_1C01
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO1_AppendTimeSlotMaskValueTerminator:
    PEA     DATA_DISKIO_STR_VALUE_1C01
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

;------------------------------------------------------------------------------
; FUNC: DISKIO1_FormatBlackoutMaskFlags   (Routine at DISKIO1_FormatBlackoutMaskFlags)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1/D2/D3/D5/D6
; CALLS:
;   GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   DATA_DISKIO_FMT_BLKOUT_MASK_PCT_02LX_PCT_02LX_PCT_02_1C02
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO1_FormatBlackoutMaskFlags:
    MOVEQ   #0,D0
    MOVE.B  34(A3),D0
    MOVEQ   #0,D1
    MOVE.B  35(A3),D1
    MOVEQ   #0,D2
    MOVE.B  36(A3),D2
    MOVEQ   #0,D3
    MOVE.B  37(A3),D3
    MOVE.L  D0,28(A7)
    MOVEQ   #0,D0
    MOVE.B  38(A3),D0
    MOVE.L  D0,44(A7)
    MOVEQ   #0,D0
    MOVE.B  39(A3),D0
    MOVE.L  D0,-(A7)
    MOVE.L  48(A7),-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  48(A7),-(A7)
    PEA     DATA_DISKIO_FMT_BLKOUT_MASK_PCT_02LX_PCT_02LX_PCT_02_1C02
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     28(A7),A7
    MOVEQ   #0,D5
    MOVEQ   #0,D6

;------------------------------------------------------------------------------
; FUNC: DISKIO1_AccumulateBlackoutMaskSum   (Routine at DISKIO1_AccumulateBlackoutMaskSum)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D5/D6
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
DISKIO1_AccumulateBlackoutMaskSum:
    MOVEQ   #6,D0
    CMP.L   D0,D6
    BGE.S   DISKIO1_AppendBlackoutMaskNoneIfEmpty

    MOVEQ   #0,D0
    MOVE.B  34(A3,D6.L),D0
    ADD.L   D0,D5
    ADDQ.L  #1,D6
    BRA.S   DISKIO1_AccumulateBlackoutMaskSum

;------------------------------------------------------------------------------
; FUNC: DISKIO1_AppendBlackoutMaskNoneIfEmpty   (Routine at DISKIO1_AppendBlackoutMaskNoneIfEmpty)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7
; CALLS:
;   GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   DATA_DISKIO_STR_NONE_1C03
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO1_AppendBlackoutMaskNoneIfEmpty:
    TST.L   D5
    BNE.S   DISKIO1_AppendBlackoutMaskAllIfAllBitsSet

    PEA     DATA_DISKIO_STR_NONE_1C03
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7
    BRA.S   DISKIO1_DumpDefaultCoiInfoBlock

;------------------------------------------------------------------------------
; FUNC: DISKIO1_AppendBlackoutMaskAllIfAllBitsSet   (Routine at DISKIO1_AppendBlackoutMaskAllIfAllBitsSet)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7/D5
; CALLS:
;   GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   DATA_DISKIO_STR_BLACKED_OUT_1C04
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO1_AppendBlackoutMaskAllIfAllBitsSet:
    CMPI.L  #$5fa,D5
    BNE.S   DISKIO1_AppendBlackoutMaskValueHeader

    PEA     DATA_DISKIO_STR_BLACKED_OUT_1C04
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7
    BRA.S   DISKIO1_DumpDefaultCoiInfoBlock

;------------------------------------------------------------------------------
; FUNC: DISKIO1_AppendBlackoutMaskValueHeader   (Routine at DISKIO1_AppendBlackoutMaskValueHeader)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7/D4
; CALLS:
;   GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   DATA_DISKIO_STR_VALUE_1C05
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO1_AppendBlackoutMaskValueHeader:
    PEA     DATA_DISKIO_STR_VALUE_1C05
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7
    MOVEQ   #1,D4

;------------------------------------------------------------------------------
; FUNC: DISKIO1_AppendBlackoutMaskSelectedTimes   (Routine at DISKIO1_AppendBlackoutMaskSelectedTimes)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0/D1/D4
; CALLS:
;   ESQ_TestBit1Based, GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   GLOB_REF_STR_CLOCK_FORMAT, DATA_DISKIO_FMT_PCT_S_1C06
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO1_AppendBlackoutMaskSelectedTimes:
    MOVEQ   #49,D0
    CMP.B   D0,D4
    BCC.S   DISKIO1_AppendBlackoutMaskValueTerminator

    LEA     34(A3),A0
    MOVEQ   #0,D0
    MOVE.B  D4,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   DISKIO1_AdvanceBlackoutBitIndex

    MOVEQ   #0,D0
    MOVE.B  D4,D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    MOVEA.L GLOB_REF_STR_CLOCK_FORMAT,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-(A7)
    PEA     DATA_DISKIO_FMT_PCT_S_1C06
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #8,A7

;------------------------------------------------------------------------------
; FUNC: DISKIO1_AdvanceBlackoutBitIndex   (Routine at DISKIO1_AdvanceBlackoutBitIndex)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D4
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
DISKIO1_AdvanceBlackoutBitIndex:
    ADDQ.B  #1,D4
    BRA.S   DISKIO1_AppendBlackoutMaskSelectedTimes

;------------------------------------------------------------------------------
; FUNC: DISKIO1_AppendBlackoutMaskValueTerminator   (Routine at DISKIO1_AppendBlackoutMaskValueTerminator)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7
; CALLS:
;   GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   DATA_DISKIO_STR_VALUE_1C07
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO1_AppendBlackoutMaskValueTerminator:
    PEA     DATA_DISKIO_STR_VALUE_1C07
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

;------------------------------------------------------------------------------
; FUNC: DISKIO1_DumpDefaultCoiInfoBlock   (Routine at DISKIO1_DumpDefaultCoiInfoBlock)
; ARGS:
;   stack +10: arg_1 (via 14(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A7/D0/D1/D2/D3
; CALLS:
;   GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   DISKIO1_DumpDefaultCoiInfoBlock_Return, DATA_DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG2_0X_PCT_04X_BG_1C08, DATA_DISKIO_FMT_COI_DASH_PTR_PCT_08LX_1C09, DATA_DISKIO_STR_DEF_COI_INFORMATION_FOLLOWS_COLON_1C0A, DATA_DISKIO_STR_DEF_DEFAULT_1C0B, DATA_DISKIO_FMT_DEF_CITY_PCT_08LX_STAR_DEF_CITY_1C0C, DATA_DISKIO_FMT_DEF_ORDER_PCT_08LX_STAR_DEF_ORDER_1C0D, DATA_DISKIO_FMT_DEF_PRICE_PCT_08LX_STAR_DEF_PRICE_1C0E, DATA_DISKIO_FMT_DEF_TELE_PCT_08LX_STAR_DEF_TELE_1C0F, DATA_DISKIO_FMT_DEF_EVENT_PCT_08LX_STAR_DEF_EVENT_1C10, DATA_DISKIO_FMT_EXCEPTION_COUNT_IS_PCT_LD_1C11, DATA_DISKIO_FMT_EXCEPTION_BLOCK_PCT_08LX_1C12
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO1_DumpDefaultCoiInfoBlock:
    MOVEQ   #0,D0
    MOVE.B  40(A3),D0
    MOVEQ   #0,D1
    MOVE.W  46(A3),D1
    MOVEQ   #0,D2
    MOVE.B  41(A3),D2
    MOVEQ   #0,D3
    MOVE.B  42(A3),D3
    LEA     43(A3),A0
    MOVE.L  A0,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG2_0X_PCT_04X_BG_1C08
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVE.L  48(A3),D0
    MOVE.L  D0,(A7)
    PEA     DATA_DISKIO_FMT_COI_DASH_PTR_PCT_08LX_1C09
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     28(A7),A7
    TST.L   48(A3)
    BEQ.W   DISKIO1_DumpDefaultCoiInfoBlock_Return

    MOVE.L  48(A3),-14(A5)
    PEA     DATA_DISKIO_STR_DEF_COI_INFORMATION_FOLLOWS_COLON_1C0A
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVE.L  -14(A5),(A7)
    PEA     DATA_DISKIO_STR_DEF_DEFAULT_1C0B
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEA.L -14(A5),A1
    MOVEA.L 4(A1),A0
    MOVE.L  A0,(A7)
    MOVE.L  A0,-(A7)
    PEA     DATA_DISKIO_FMT_DEF_CITY_PCT_08LX_STAR_DEF_CITY_1C0C
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEA.L -14(A5),A1
    MOVEA.L 8(A1),A0
    MOVE.L  A0,(A7)
    MOVE.L  A0,-(A7)
    PEA     DATA_DISKIO_FMT_DEF_ORDER_PCT_08LX_STAR_DEF_ORDER_1C0D
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEA.L -14(A5),A1
    MOVEA.L 12(A1),A0
    MOVE.L  A0,(A7)
    MOVE.L  A0,-(A7)
    PEA     DATA_DISKIO_FMT_DEF_PRICE_PCT_08LX_STAR_DEF_PRICE_1C0E
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEA.L -14(A5),A1
    MOVEA.L 16(A1),A0
    MOVE.L  A0,(A7)
    MOVE.L  A0,-(A7)
    PEA     DATA_DISKIO_FMT_DEF_TELE_PCT_08LX_STAR_DEF_TELE_1C0F
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEA.L -14(A5),A1
    MOVEA.L 20(A1),A0
    MOVE.L  A0,(A7)
    MOVE.L  A0,-(A7)
    PEA     DATA_DISKIO_FMT_DEF_EVENT_PCT_08LX_STAR_DEF_EVENT_1C10
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEA.L -14(A5),A0
    MOVE.W  36(A0),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     DATA_DISKIO_FMT_EXCEPTION_COUNT_IS_PCT_LD_1C11
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEA.L -14(A5),A0
    MOVE.L  38(A0),(A7)
    PEA     DATA_DISKIO_FMT_EXCEPTION_BLOCK_PCT_08LX_1C12
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     56(A7),A7

;------------------------------------------------------------------------------
; FUNC: DISKIO1_DumpDefaultCoiInfoBlock_Return   (Routine at DISKIO1_DumpDefaultCoiInfoBlock_Return)
; ARGS:
;   (none observed)
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
DISKIO1_DumpDefaultCoiInfoBlock_Return:
    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISKIO1_DumpProgramSourceRecordVerbose   (Routine at DISKIO1_DumpProgramSourceRecordVerbose)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   GLOB_REF_STR_CLOCK_FORMAT, DISKIO1_DumpProgramSourceRecordVerbose_Return, DATA_DISKIO_FMT_CHANNEL_LINE_UP_PCT_D_1C13, DATA_DISKIO_FMT_ETID_PCT_D_CHAN_NUM_PCT_S_SOURCE_PCT_1C14, DATA_DISKIO_STR_ATTR_1C15, DATA_DISKIO_STR_NONE_1C16, DATA_DISKIO_STR_HILITE_SRC_1C17, DATA_DISKIO_STR_SUM_SRC_1C18, DATA_DISKIO_STR_VIDEO_TAG_DISABLE_1C19, DATA_DISKIO_STR_PPV_SRC_1C1A, DATA_DISKIO_STR_DITTO_1C1B, DATA_DISKIO_STR_ALTHILITESRC_1C1C, DATA_DISKIO_STR_STEREO_1C1D, DATA_DISKIO_STR_VALUE_1C1E, DATA_DISKIO_FMT_TSLT_MASK_PCT_02X_PCT_02X_PCT_02X_PC_1C1F, DATA_DISKIO_FMT_BLKOUT_MASK_PCT_02X_PCT_02X_PCT_02X__1C20, DATA_DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG2_0X_PCT_04X_BG_1C21, DATA_DISKIO_FMT_PROGRAM_INFO_PCT_LD_1C22, DATA_DISKIO_FMT_PROG_SRCE_PCT_S_1C23, DATA_DISKIO_STR_1C24, DATA_DISKIO_FMT_PCT_02LD_PCT_S_COLON_ATTR_PCT_02LX_1C25, DATA_DISKIO_STR_NONE_1C26, DATA_DISKIO_STR_MOVIE_1C27, DATA_DISKIO_STR_ALTHILITE_PROG_1C28, DATA_DISKIO_STR_TAG_PROG_1C29, DATA_DISKIO_STR_0X10_1C2A, DATA_DISKIO_STR_0X20_1C2B, DATA_DISKIO_STR_0X40_1C2C, DATA_DISKIO_STR_PREV_DAYS_DATA_1C2D, DATA_DISKIO_STR_VALUE_1C2E, DATA_DISKIO_FMT_PCT_S_1C2F, DATA_DISKIO_TAG_NULL_1C30, DATA_DISKIO_STR_1C31, branch_18, branch_7
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO1_DumpProgramSourceRecordVerbose:
    MOVEM.L D2-D5/D7/A2-A3,-(A7)
    MOVEA.L 32(A7),A3
    MOVE.L  36(A7),D7
    MOVE.L  D7,-(A7)
    PEA     DATA_DISKIO_FMT_CHANNEL_LINE_UP_PCT_D_1C13
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    LEA     1(A3),A0
    LEA     12(A3),A1
    LEA     19(A3),A2
    MOVE.L  A2,(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_DISKIO_FMT_ETID_PCT_D_CHAN_NUM_PCT_S_SOURCE_PCT_1C14
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    PEA     DATA_DISKIO_STR_ATTR_1C15
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     28(A7),A7
    MOVEQ   #1,D0
    CMP.B   27(A3),D0
    BNE.S   .lab_043A

    PEA     DATA_DISKIO_STR_NONE_1C16
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.lab_043A:
    BTST    #1,27(A3)
    BEQ.S   .lab_043B

    PEA     DATA_DISKIO_STR_HILITE_SRC_1C17
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.lab_043B:
    BTST    #2,27(A3)
    BEQ.S   .branch

    PEA     DATA_DISKIO_STR_SUM_SRC_1C18
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch:
    BTST    #3,27(A3)
    BEQ.S   .branch_1

    PEA     DATA_DISKIO_STR_VIDEO_TAG_DISABLE_1C19
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_1:
    BTST    #4,27(A3)
    BEQ.S   .branch_2

    PEA     DATA_DISKIO_STR_PPV_SRC_1C1A
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_2:
    BTST    #5,27(A3)
    BEQ.S   .branch_3

    PEA     DATA_DISKIO_STR_DITTO_1C1B
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_3:
    BTST    #6,27(A3)
    BEQ.S   .branch_4

    PEA     DATA_DISKIO_STR_ALTHILITESRC_1C1C
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_4:
    BTST    #7,27(A3)
    BEQ.S   .branch_5

    PEA     DATA_DISKIO_STR_STEREO_1C1D
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_5:
    PEA     DATA_DISKIO_STR_VALUE_1C1E
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

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
    PEA     DATA_DISKIO_FMT_TSLT_MASK_PCT_02X_PCT_02X_PCT_02X_PC_1C1F
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

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
    PEA     DATA_DISKIO_FMT_BLKOUT_MASK_PCT_02X_PCT_02X_PCT_02X__1C20
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

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
    PEA     DATA_DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG2_0X_PCT_04X_BG_1C21
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     72(A7),A7
    MOVEM.L (A7)+,D2-D5/D7/A2-A3
    RTS

;!======

    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVE.L  20(A7),D7
    MOVE.L  D7,-(A7)
    PEA     DATA_DISKIO_FMT_PROGRAM_INFO_PCT_LD_1C22
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVE.L  A3,(A7)
    PEA     DATA_DISKIO_FMT_PROG_SRCE_PCT_S_1C23
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     12(A7),A7
    MOVE.L  A3,D0
    BNE.S   .branch_6

    PEA     DATA_DISKIO_STR_1C24
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

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
    MOVEA.L GLOB_REF_STR_CLOCK_FORMAT,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  7(A3,D6.L),D0
    MOVE.L  D0,-(A7)
    MOVE.L  (A0),-(A7)
    MOVE.L  D6,-(A7)
    PEA     DATA_DISKIO_FMT_PCT_02LD_PCT_S_COLON_ATTR_PCT_02LX_1C25
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     16(A7),A7
    MOVEQ   #1,D0
    CMP.B   7(A3,D6.L),D0
    BNE.S   .branch_8

    PEA     DATA_DISKIO_STR_NONE_1C26
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_8:
    BTST    #1,7(A3,D6.L)
    BEQ.S   .branch_9

    PEA     DATA_DISKIO_STR_MOVIE_1C27
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_9:
    BTST    #2,7(A3,D6.L)
    BEQ.S   .branch_10

    PEA     DATA_DISKIO_STR_ALTHILITE_PROG_1C28
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_10:
    BTST    #3,7(A3,D6.L)
    BEQ.S   .branch_11

    PEA     DATA_DISKIO_STR_TAG_PROG_1C29
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_11:
    BTST    #4,7(A3,D6.L)
    BEQ.S   .branch_12

    PEA     DATA_DISKIO_STR_0X10_1C2A
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_12:
    BTST    #5,7(A3,D6.L)
    BEQ.S   .branch_13

    PEA     DATA_DISKIO_STR_0X20_1C2B
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_13:
    BTST    #6,7(A3,D6.L)
    BEQ.S   .branch_14

    PEA     DATA_DISKIO_STR_0X40_1C2C
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_14:
    BTST    #7,7(A3,D6.L)
    BEQ.S   .branch_15

    PEA     DATA_DISKIO_STR_PREV_DAYS_DATA_1C2D
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_15:
    PEA     DATA_DISKIO_STR_VALUE_1C2E
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7
    MOVE.L  D6,D0
    ASL.L   #2,D0
    TST.L   56(A3,D0.L)
    BEQ.S   .branch_16

    MOVE.L  56(A3,D0.L),-(A7)
    PEA     DATA_DISKIO_FMT_PCT_S_1C2F
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #8,A7
    BRA.S   .branch_17

.branch_16:
    PEA     DATA_DISKIO_TAG_NULL_1C30
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_17:
    ADDQ.L  #1,D6
    BRA.W   .branch_7

.branch_18:
    PEA     DATA_DISKIO_STR_1C31
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

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
;   GROUP_AG_JMPTBL_LADFUNC2_EmitEscapedStringToScratch, GROUP_AG_JMPTBL_STRING_CopyPadNul, GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   GLOB_REF_STR_CLOCK_FORMAT, DISKIO1_DumpProgramInfoAttrTable_Return, DATA_DISKIO_FMT_PROGRAM_INFO_PCT_D_1C32, DATA_DISKIO_STR_1C33, DATA_DISKIO_FMT_PROG_SRCE_PCT_S_1C34, DATA_DISKIO_FMT_PCT_02D_PCT_S_COLON_ATTR_1C35, DATA_DISKIO_STR_NONE_1C36, DATA_DISKIO_STR_MOVIE_1C37, DATA_DISKIO_STR_ALTHILITE_PROG_1C38, DATA_DISKIO_STR_TAG_PROG_1C39, DATA_DISKIO_STR_SPORTSPROG_1C3A, DATA_DISKIO_STR_0X20_1C3B, DATA_DISKIO_STR_REPEATPROG_1C3C, DATA_DISKIO_STR_PREV_DAYS_DATA_1C3D, DATA_DISKIO_STR_VALUE_1C3E, DATA_DISKIO_TAG_NONE_1C3F, DATA_DISKIO_STR_VALUE_1C40, branch, fc, lab_045E
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
    PEA     DATA_DISKIO_FMT_PROGRAM_INFO_PCT_D_1C32
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  A3,D0
    BNE.S   .lab_0450

    PEA     DATA_DISKIO_STR_1C33
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    BRA.W   DISKIO1_DumpProgramInfoAttrTable_Return

.lab_0450:
    MOVE.L  A3,-(A7)
    PEA     DATA_DISKIO_FMT_PROG_SRCE_PCT_S_1C34
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

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
    MOVEA.L GLOB_REF_STR_CLOCK_FORMAT,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    MOVE.L  D6,-(A7)
    PEA     DATA_DISKIO_FMT_PCT_02D_PCT_S_COLON_ATTR_1C35
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     12(A7),A7
    MOVEQ   #1,D0
    CMP.B   7(A3,D6.L),D0
    BNE.S   .branch_1

    PEA     DATA_DISKIO_STR_NONE_1C36
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_1:
    BTST    #1,7(A3,D6.L)
    BEQ.S   .branch_2

    PEA     DATA_DISKIO_STR_MOVIE_1C37
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_2:
    BTST    #2,7(A3,D6.L)
    BEQ.S   .branch_3

    PEA     DATA_DISKIO_STR_ALTHILITE_PROG_1C38
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_3:
    BTST    #3,7(A3,D6.L)
    BEQ.S   .branch_4

    PEA     DATA_DISKIO_STR_TAG_PROG_1C39
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_4:
    BTST    #4,7(A3,D6.L)
    BEQ.S   .branch_5

    PEA     DATA_DISKIO_STR_SPORTSPROG_1C3A
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_5:
    BTST    #5,7(A3,D6.L)
    BEQ.S   .branch_6

    PEA     DATA_DISKIO_STR_0X20_1C3B
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_6:
    BTST    #6,7(A3,D6.L)
    BEQ.S   .branch_7

    PEA     DATA_DISKIO_STR_REPEATPROG_1C3C
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_7:
    BTST    #7,7(A3,D6.L)
    BEQ.S   .branch_8

    PEA     DATA_DISKIO_STR_PREV_DAYS_DATA_1C3D
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_8:
    PEA     DATA_DISKIO_STR_VALUE_1C3E
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7
    MOVE.L  D6,D0
    ASL.L   #2,D0
    TST.L   56(A3,D0.L)
    BEQ.S   .branch_9

    PEA     40.W
    MOVE.L  56(A3,D0.L),-(A7)
    PEA     -45(A5)
    JSR     GROUP_AG_JMPTBL_STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    BRA.S   .branch_11

.branch_9:
    LEA     DATA_DISKIO_TAG_NONE_1C3F,A0
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
    PEA     DATA_DISKIO_STR_VALUE_1C40
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

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
