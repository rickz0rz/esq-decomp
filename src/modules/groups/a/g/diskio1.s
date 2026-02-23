    XDEF    DISKIO1_AccumulateBlackoutMaskSum
    XDEF    DISKIO1_AccumulateTimeSlotMaskSum
    XDEF    DISKIO1_AdvanceBlackoutBitIndex
    XDEF    DISKIO1_AdvanceTimeSlotBitIndex
    XDEF    DISKIO1_AppendAttrFlagAltHiliteSrc
    XDEF    DISKIO1_AppendAttrFlagBit7
    XDEF    DISKIO1_AppendAttrFlagDitto
    XDEF    DISKIO1_AppendAttrFlagHiliteSrc
    XDEF    DISKIO1_AppendAttrFlagPpvSrc
    XDEF    DISKIO1_AppendAttrFlagSummarySrc
    XDEF    DISKIO1_AppendAttrFlagVideoTagDisable
    XDEF    DISKIO1_AppendBlackoutMaskAllIfAllBitsSet
    XDEF    DISKIO1_AppendBlackoutMaskNoneIfEmpty
    XDEF    DISKIO1_AppendBlackoutMaskSelectedTimes
    XDEF    DISKIO1_AppendBlackoutMaskValueHeader
    XDEF    DISKIO1_AppendBlackoutMaskValueTerminator
    XDEF    DISKIO1_AppendTimeSlotMaskNoneIfAllBitsSet
    XDEF    DISKIO1_AppendTimeSlotMaskOffAirIfEmpty
    XDEF    DISKIO1_AppendTimeSlotMaskSelectedTimes
    XDEF    DISKIO1_AppendTimeSlotMaskValueHeader
    XDEF    DISKIO1_AppendTimeSlotMaskValueTerminator
    XDEF    DISKIO1_DumpDefaultCoiInfoBlock
    XDEF    DISKIO1_DumpProgramSourceRecordVerbose
    XDEF    DISKIO1_FormatBlackoutMaskFlags
    XDEF    DISKIO1_FormatTimeSlotMaskFlags
    XDEF    DISKIO1_DumpDefaultCoiInfoBlock_Return
    XDEF    DISKIO1_DumpProgramInfoAttrTable_Return
    XDEF    DISKIO1_DumpProgramSourceRecordVerbose_Return

; Unreachable Code?
    LINK.W  A5,#-36
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  D7,-(A7)
    PEA     DISKIO_FMT_CHANNEL_LINE_UP_PCT_LD
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     DISKIO_FMT_ETID_PCT_LD_PCT_02LX
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     1(A3),A0
    MOVE.L  A0,(A7)
    PEA     DISKIO_FMT_CHAN_NUM_PCT_S
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     12(A3),A0
    MOVE.L  A0,(A7)
    PEA     DISKIO_FMT_SOURCE_PCT_S
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     19(A3),A0
    MOVE.L  A0,(A7)
    PEA     DISKIO_FMT_CALL_LET_PCT_S
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.B  27(A3),D0
    MOVE.L  D0,(A7)
    PEA     DISKIO_FMT_ATTR_PCT_02LX
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     32(A7),A7
    MOVEQ   #1,D0
    CMP.B   27(A3),D0
    BNE.S   DISKIO1_AppendAttrFlagHiliteSrc

    PEA     DISKIO_STR_NONE_CompactSourceAttrFlags
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
;   DISKIO_STR_HILITE_SRC_CompactSourceAttrFlags
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

    PEA     DISKIO_STR_HILITE_SRC_CompactSourceAttrFlags
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
;   DISKIO_STR_SUM_SRC_CompactSourceAttrFlags
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

    PEA     DISKIO_STR_SUM_SRC_CompactSourceAttrFlags
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
;   DISKIO_STR_VIDEO_TAG_DISABLE_CompactSourceAttrFlags
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

    PEA     DISKIO_STR_VIDEO_TAG_DISABLE_CompactSourceAttrFlags
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
;   DISKIO_STR_PPV_SRC_CompactSourceAttrFlags
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

    PEA     DISKIO_STR_PPV_SRC_CompactSourceAttrFlags
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
;   DISKIO_STR_DITTO_CompactSourceAttrFlags
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

    PEA     DISKIO_STR_DITTO_CompactSourceAttrFlags
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
;   DISKIO_STR_ALTHILITESRC_CompactSourceAttrFlags
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

    PEA     DISKIO_STR_ALTHILITESRC_CompactSourceAttrFlags
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
;   DISKIO_STR_0X80
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

    PEA     DISKIO_STR_0X80
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
;   DISKIO_STR_AttrFlagsCloseParenNewline_A, DISKIO_FMT_TSLT_MASK_PCT_02LX_PCT_02LX_PCT_02LX
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO1_FormatTimeSlotMaskFlags:
    PEA     DISKIO_STR_AttrFlagsCloseParenNewline_A
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
    PEA     DISKIO_FMT_TSLT_MASK_PCT_02LX_PCT_02LX_PCT_02LX
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
;   DISKIO_STR_NONE_TimeSlotMaskAllSet
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

    PEA     DISKIO_STR_NONE_TimeSlotMaskAllSet
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
;   Global_STR_OFF_AIR_2
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

    PEA     Global_STR_OFF_AIR_2
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
;   DISKIO_STR_TimeSlotListOpenParen
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO1_AppendTimeSlotMaskValueHeader:
    PEA     DISKIO_STR_TimeSlotListOpenParen
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
;   Global_REF_STR_CLOCK_FORMAT, DISKIO_FMT_PCT_S_TimeSlotMaskEntry
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
    MOVEA.L Global_REF_STR_CLOCK_FORMAT,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-(A7)
    PEA     DISKIO_FMT_PCT_S_TimeSlotMaskEntry
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
;   DISKIO_STR_TimeSlotListCloseParenNewline
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO1_AppendTimeSlotMaskValueTerminator:
    PEA     DISKIO_STR_TimeSlotListCloseParenNewline
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
;   DISKIO_FMT_BLKOUT_MASK_PCT_02LX_PCT_02LX_PCT_02
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
    PEA     DISKIO_FMT_BLKOUT_MASK_PCT_02LX_PCT_02LX_PCT_02
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
;   DISKIO_STR_NONE_BlackoutMaskEmpty
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

    PEA     DISKIO_STR_NONE_BlackoutMaskEmpty
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
;   DISKIO_STR_BLACKED_OUT
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

    PEA     DISKIO_STR_BLACKED_OUT
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
;   DISKIO_STR_BlackoutListOpenParen
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO1_AppendBlackoutMaskValueHeader:
    PEA     DISKIO_STR_BlackoutListOpenParen
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
;   Global_REF_STR_CLOCK_FORMAT, DISKIO_FMT_PCT_S_BlackoutMaskEntry
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
    MOVEA.L Global_REF_STR_CLOCK_FORMAT,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-(A7)
    PEA     DISKIO_FMT_PCT_S_BlackoutMaskEntry
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
;   DISKIO_STR_BlackoutListCloseParenNewline
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO1_AppendBlackoutMaskValueTerminator:
    PEA     DISKIO_STR_BlackoutListCloseParenNewline
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
;   DISKIO1_DumpDefaultCoiInfoBlock_Return, DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG2_0X_PCT_04X_BG_DefaultCoiDump, DISKIO_FMT_COI_DASH_PTR_PCT_08LX, DISKIO_STR_DEF_COI_INFORMATION_FOLLOWS_COLON, DISKIO_STR_DEF_DEFAULT, DISKIO_FMT_DEF_CITY_PCT_08LX_STAR_DEF_CITY, DISKIO_FMT_DEF_ORDER_PCT_08LX_STAR_DEF_ORDER, DISKIO_FMT_DEF_PRICE_PCT_08LX_STAR_DEF_PRICE, DISKIO_FMT_DEF_TELE_PCT_08LX_STAR_DEF_TELE, DISKIO_FMT_DEF_EVENT_PCT_08LX_STAR_DEF_EVENT, DISKIO_FMT_EXCEPTION_COUNT_IS_PCT_LD, DISKIO_FMT_EXCEPTION_BLOCK_PCT_08LX
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
    PEA     DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG2_0X_PCT_04X_BG_DefaultCoiDump
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVE.L  48(A3),D0
    MOVE.L  D0,(A7)
    PEA     DISKIO_FMT_COI_DASH_PTR_PCT_08LX
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     28(A7),A7
    TST.L   48(A3)
    BEQ.W   DISKIO1_DumpDefaultCoiInfoBlock_Return

    MOVE.L  48(A3),-14(A5)
    PEA     DISKIO_STR_DEF_COI_INFORMATION_FOLLOWS_COLON
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVE.L  -14(A5),(A7)
    PEA     DISKIO_STR_DEF_DEFAULT
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEA.L -14(A5),A1
    MOVEA.L 4(A1),A0
    MOVE.L  A0,(A7)
    MOVE.L  A0,-(A7)
    PEA     DISKIO_FMT_DEF_CITY_PCT_08LX_STAR_DEF_CITY
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEA.L -14(A5),A1
    MOVEA.L 8(A1),A0
    MOVE.L  A0,(A7)
    MOVE.L  A0,-(A7)
    PEA     DISKIO_FMT_DEF_ORDER_PCT_08LX_STAR_DEF_ORDER
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEA.L -14(A5),A1
    MOVEA.L 12(A1),A0
    MOVE.L  A0,(A7)
    MOVE.L  A0,-(A7)
    PEA     DISKIO_FMT_DEF_PRICE_PCT_08LX_STAR_DEF_PRICE
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEA.L -14(A5),A1
    MOVEA.L 16(A1),A0
    MOVE.L  A0,(A7)
    MOVE.L  A0,-(A7)
    PEA     DISKIO_FMT_DEF_TELE_PCT_08LX_STAR_DEF_TELE
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEA.L -14(A5),A1
    MOVEA.L 20(A1),A0
    MOVE.L  A0,(A7)
    MOVE.L  A0,-(A7)
    PEA     DISKIO_FMT_DEF_EVENT_PCT_08LX_STAR_DEF_EVENT
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEA.L -14(A5),A0
    MOVE.W  36(A0),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     DISKIO_FMT_EXCEPTION_COUNT_IS_PCT_LD
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEA.L -14(A5),A0
    MOVE.L  38(A0),(A7)
    PEA     DISKIO_FMT_EXCEPTION_BLOCK_PCT_08LX
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
;   Global_REF_STR_CLOCK_FORMAT, DISKIO1_DumpProgramSourceRecordVerbose_Return, DISKIO_FMT_CHANNEL_LINE_UP_PCT_D, DISKIO_FMT_ETID_PCT_D_CHAN_NUM_PCT_S_SOURCE_PCT, DISKIO_STR_ATTR, DISKIO_STR_NONE_VerboseSourceAttrFlags, DISKIO_STR_HILITE_SRC_VerboseSourceAttrFlags, DISKIO_STR_SUM_SRC_VerboseSourceAttrFlags, DISKIO_STR_VIDEO_TAG_DISABLE_VerboseSourceAttrFlags, DISKIO_STR_PPV_SRC_VerboseSourceAttrFlags, DISKIO_STR_DITTO_VerboseSourceAttrFlags, DISKIO_STR_ALTHILITESRC_VerboseSourceAttrFlags, DISKIO_STR_STEREO, DISKIO_STR_ProgramAttrCloseParenNewline, DISKIO_FMT_TSLT_MASK_PCT_02X_PCT_02X_PCT_02X_PC, DISKIO_FMT_BLKOUT_MASK_PCT_02X_PCT_02X_PCT_02X_, DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG2_0X_PCT_04X_BG_VerboseSourceRecord, DISKIO_FMT_PROGRAM_INFO_PCT_LD, DISKIO_FMT_PROG_SRCE_PCT_S_VerboseProgramInfo, DISKIO_STR_NewlineOnly_A, DISKIO_FMT_PCT_02LD_PCT_S_COLON_ATTR_PCT_02LX, DISKIO_STR_NONE_VerboseProgramAttrFlags, DISKIO_STR_MOVIE_VerboseProgramAttrFlags, DISKIO_STR_ALTHILITE_PROG_VerboseProgramAttrFlags, DISKIO_STR_TAG_PROG_VerboseProgramAttrFlags, DISKIO_STR_0X10, DISKIO_STR_0X20_VerboseProgramAttrFlags, DISKIO_STR_0X40, DISKIO_STR_PREV_DAYS_DATA_VerboseProgramAttrFlags, DISKIO_STR_ProgramAttrCloseAndProgPrefix, DISKIO_FMT_PCT_S_VerboseProgramStringLine, DISKIO_STR_NullLine, DISKIO_STR_NewlineOnly_B, branch_18, branch_7
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
    PEA     DISKIO_FMT_CHANNEL_LINE_UP_PCT_D
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
    PEA     DISKIO_FMT_ETID_PCT_D_CHAN_NUM_PCT_S_SOURCE_PCT
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    PEA     DISKIO_STR_ATTR
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     28(A7),A7
    MOVEQ   #1,D0
    CMP.B   27(A3),D0
    BNE.S   .lab_043A

    PEA     DISKIO_STR_NONE_VerboseSourceAttrFlags
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.lab_043A:
    BTST    #1,27(A3)
    BEQ.S   .lab_043B

    PEA     DISKIO_STR_HILITE_SRC_VerboseSourceAttrFlags
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.lab_043B:
    BTST    #2,27(A3)
    BEQ.S   .branch

    PEA     DISKIO_STR_SUM_SRC_VerboseSourceAttrFlags
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch:
    BTST    #3,27(A3)
    BEQ.S   .branch_1

    PEA     DISKIO_STR_VIDEO_TAG_DISABLE_VerboseSourceAttrFlags
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_1:
    BTST    #4,27(A3)
    BEQ.S   .branch_2

    PEA     DISKIO_STR_PPV_SRC_VerboseSourceAttrFlags
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_2:
    BTST    #5,27(A3)
    BEQ.S   .branch_3

    PEA     DISKIO_STR_DITTO_VerboseSourceAttrFlags
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_3:
    BTST    #6,27(A3)
    BEQ.S   .branch_4

    PEA     DISKIO_STR_ALTHILITESRC_VerboseSourceAttrFlags
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_4:
    BTST    #7,27(A3)
    BEQ.S   .branch_5

    PEA     DISKIO_STR_STEREO
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_5:
    PEA     DISKIO_STR_ProgramAttrCloseParenNewline
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
    PEA     DISKIO_FMT_TSLT_MASK_PCT_02X_PCT_02X_PCT_02X_PC
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
    PEA     DISKIO_FMT_BLKOUT_MASK_PCT_02X_PCT_02X_PCT_02X_
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
    PEA     DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG2_0X_PCT_04X_BG_VerboseSourceRecord
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     72(A7),A7
    MOVEM.L (A7)+,D2-D5/D7/A2-A3
    RTS

;!======

    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVE.L  20(A7),D7
    MOVE.L  D7,-(A7)
    PEA     DISKIO_FMT_PROGRAM_INFO_PCT_LD
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVE.L  A3,(A7)
    PEA     DISKIO_FMT_PROG_SRCE_PCT_S_VerboseProgramInfo
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     12(A7),A7
    MOVE.L  A3,D0
    BNE.S   .branch_6

    PEA     DISKIO_STR_NewlineOnly_A
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
    MOVEA.L Global_REF_STR_CLOCK_FORMAT,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  7(A3,D6.L),D0
    MOVE.L  D0,-(A7)
    MOVE.L  (A0),-(A7)
    MOVE.L  D6,-(A7)
    PEA     DISKIO_FMT_PCT_02LD_PCT_S_COLON_ATTR_PCT_02LX
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     16(A7),A7
    MOVEQ   #1,D0
    CMP.B   7(A3,D6.L),D0
    BNE.S   .branch_8

    PEA     DISKIO_STR_NONE_VerboseProgramAttrFlags
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_8:
    BTST    #1,7(A3,D6.L)
    BEQ.S   .branch_9

    PEA     DISKIO_STR_MOVIE_VerboseProgramAttrFlags
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_9:
    BTST    #2,7(A3,D6.L)
    BEQ.S   .branch_10

    PEA     DISKIO_STR_ALTHILITE_PROG_VerboseProgramAttrFlags
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_10:
    BTST    #3,7(A3,D6.L)
    BEQ.S   .branch_11

    PEA     DISKIO_STR_TAG_PROG_VerboseProgramAttrFlags
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_11:
    BTST    #4,7(A3,D6.L)
    BEQ.S   .branch_12

    PEA     DISKIO_STR_0X10
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_12:
    BTST    #5,7(A3,D6.L)
    BEQ.S   .branch_13

    PEA     DISKIO_STR_0X20_VerboseProgramAttrFlags
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_13:
    BTST    #6,7(A3,D6.L)
    BEQ.S   .branch_14

    PEA     DISKIO_STR_0X40
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_14:
    BTST    #7,7(A3,D6.L)
    BEQ.S   .branch_15

    PEA     DISKIO_STR_PREV_DAYS_DATA_VerboseProgramAttrFlags
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_15:
    PEA     DISKIO_STR_ProgramAttrCloseAndProgPrefix
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7
    MOVE.L  D6,D0
    ASL.L   #2,D0
    TST.L   56(A3,D0.L)
    BEQ.S   .branch_16

    MOVE.L  56(A3,D0.L),-(A7)
    PEA     DISKIO_FMT_PCT_S_VerboseProgramStringLine
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #8,A7
    BRA.S   .branch_17

.branch_16:
    PEA     DISKIO_STR_NullLine
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_17:
    ADDQ.L  #1,D6
    BRA.W   .branch_7

.branch_18:
    PEA     DISKIO_STR_NewlineOnly_B
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
;   Global_REF_STR_CLOCK_FORMAT, DISKIO1_DumpProgramInfoAttrTable_Return, DISKIO_FMT_PROGRAM_INFO_PCT_D, DISKIO_STR_NewlineOnly_C, DISKIO_FMT_PROG_SRCE_PCT_S_ProgramInfoAttrTable, DISKIO_FMT_PCT_02D_PCT_S_COLON_ATTR, DISKIO_STR_NONE_ProgramInfoAttrTable, DISKIO_STR_MOVIE_ProgramInfoAttrTable, DISKIO_STR_ALTHILITE_PROG_ProgramInfoAttrTable, DISKIO_STR_TAG_PROG_ProgramInfoAttrTable, DISKIO_STR_SPORTSPROG, DISKIO_STR_0X20_ProgramInfoAttrTable, DISKIO_STR_REPEATPROG, DISKIO_STR_PREV_DAYS_DATA_ProgramInfoAttrTable, DISKIO_STR_ProgramAttrCloseAndProgQuotedPrefix, DISKIO_TAG_NONE, DISKIO_FMT_ProgramStringSuffixWithTypeFields, branch, fc, lab_045E
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
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  A3,D0
    BNE.S   .lab_0450

    PEA     DISKIO_STR_NewlineOnly_C
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    BRA.W   DISKIO1_DumpProgramInfoAttrTable_Return

.lab_0450:
    MOVE.L  A3,-(A7)
    PEA     DISKIO_FMT_PROG_SRCE_PCT_S_ProgramInfoAttrTable
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
    MOVEA.L Global_REF_STR_CLOCK_FORMAT,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    MOVE.L  D6,-(A7)
    PEA     DISKIO_FMT_PCT_02D_PCT_S_COLON_ATTR
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     12(A7),A7
    MOVEQ   #1,D0
    CMP.B   7(A3,D6.L),D0
    BNE.S   .branch_1

    PEA     DISKIO_STR_NONE_ProgramInfoAttrTable
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_1:
    BTST    #1,7(A3,D6.L)
    BEQ.S   .branch_2

    PEA     DISKIO_STR_MOVIE_ProgramInfoAttrTable
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_2:
    BTST    #2,7(A3,D6.L)
    BEQ.S   .branch_3

    PEA     DISKIO_STR_ALTHILITE_PROG_ProgramInfoAttrTable
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_3:
    BTST    #3,7(A3,D6.L)
    BEQ.S   .branch_4

    PEA     DISKIO_STR_TAG_PROG_ProgramInfoAttrTable
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_4:
    BTST    #4,7(A3,D6.L)
    BEQ.S   .branch_5

    PEA     DISKIO_STR_SPORTSPROG
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_5:
    BTST    #5,7(A3,D6.L)
    BEQ.S   .branch_6

    PEA     DISKIO_STR_0X20_ProgramInfoAttrTable
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_6:
    BTST    #6,7(A3,D6.L)
    BEQ.S   .branch_7

    PEA     DISKIO_STR_REPEATPROG
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_7:
    BTST    #7,7(A3,D6.L)
    BEQ.S   .branch_8

    PEA     DISKIO_STR_PREV_DAYS_DATA_ProgramInfoAttrTable
    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_8:
    PEA     DISKIO_STR_ProgramAttrCloseAndProgQuotedPrefix
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
