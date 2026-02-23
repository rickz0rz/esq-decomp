    XDEF    FLIB_AppendClockStampedLogEntry
    XDEF    FLIB_AppendClockStampedLogEntry_Return

;------------------------------------------------------------------------------
; FUNC: FLIB_AppendClockStampedLogEntry   (Routine at FLIB_AppendClockStampedLogEntry)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +115: arg_2 (via 119(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A5/A7/D0/D1/D7
; CALLS:
;   GROUP_AR_JMPTBL_STRING_AppendAtNull, GROUP_AW_JMPTBL_WDISP_SPrintf, ESQPARS_ReplaceOwnedString, NEWGRID_JMPTBL_MATH_DivS32, NEWGRID_JMPTBL_MEMORY_AllocateMemory, NEWGRID_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   Global_REF_CLOCKDATA_STRUCT, Global_STR_FLIB_C_1, Global_STR_FLIB_C_2, FLIB_AppendClockStampedLogEntry_Return, DATA_ESQPARS2_BSS_LONG_1F57, DATA_ESQPARS2_FMT_PCT_02LD_COLON_PCT_02LD_COLON_PCT_02_1F58, DATA_ESQPARS2_TAG_PM_1F59, DATA_ESQPARS2_TAG_AM_1F5A, DATA_ESQPARS2_CONST_WORD_1F5B, DATA_ESQPARS2_CONST_LONG_1F5C, DATA_NEWGRID2_BSS_LONG_2049, CLOCK_CacheHour, CLOCK_CacheMinuteOrSecond, CLOCK_CacheAmPmFlag, DATA_WDISP_BSS_LONG_233A, MEMF_PUBLIC
; WRITES:
;   DATA_ESQPARS2_BSS_LONG_1F57, DATA_NEWGRID2_BSS_LONG_2049, DATA_WDISP_BSS_LONG_233A
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
FLIB_AppendClockStampedLogEntry:
    LINK.W  A5,#-132
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3

.lab_0CB6:
    TST.L   DATA_ESQPARS2_BSS_LONG_1F57
    BNE.S   .lab_0CB6

    MOVEQ   #1,D0
    MOVE.L  D0,DATA_ESQPARS2_BSS_LONG_1F57
    MOVE.W  DATA_WDISP_BSS_LONG_233A,D0
    CMPI.W  #$2710,D0
    BLE.S   .lab_0CB7

    CLR.L   DATA_ESQPARS2_BSS_LONG_1F57
    MOVEQ   #0,D0
    BRA.W   FLIB_AppendClockStampedLogEntry_Return

.lab_0CB7:
    MOVEA.L A3,A0

.branch:
    TST.B   (A0)+
    BNE.S   .branch

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D7
    MOVEQ   #100,D0
    CMP.W   D0,D7
    BLE.S   .branch_1

    MOVE.L  D0,D7
    CLR.B   99(A3)

.branch_1:
    MOVE.W  CLOCK_CacheHour,D0
    EXT.L   D0
    MOVEQ   #100,D1
    JSR     NEWGRID_JMPTBL_MATH_DivS32(PC)

    MOVE.W  CLOCK_CacheMinuteOrSecond,D0
    EXT.L   D0
    MOVE.L  D1,8(A7)
    MOVEQ   #100,D1
    JSR     NEWGRID_JMPTBL_MATH_DivS32(PC)

    MOVE.W  Global_REF_CLOCKDATA_STRUCT,D0
    EXT.L   D0
    MOVE.L  D1,12(A7)
    MOVEQ   #100,D1
    JSR     NEWGRID_JMPTBL_MATH_DivS32(PC)

    TST.W   CLOCK_CacheAmPmFlag
    BEQ.S   .branch_2

    LEA     DATA_ESQPARS2_TAG_PM_1F59,A0
    BRA.S   .branch_3

.branch_2:
    LEA     DATA_ESQPARS2_TAG_AM_1F5A,A0

.branch_3:
    MOVE.L  A0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  20(A7),-(A7)
    MOVE.L  20(A7),-(A7)
    PEA     DATA_ESQPARS2_FMT_PCT_02LD_COLON_PCT_02LD_COLON_PCT_02_1F58
    PEA     -119(A5)
    JSR     GROUP_AW_JMPTBL_WDISP_SPrintf(PC)

    LEA     24(A7),A7
    ADDI.W  #14,D7
    PEA     DATA_ESQPARS2_CONST_WORD_1F5B
    PEA     -119(A5)
    JSR     GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    MOVE.L  A3,(A7)
    PEA     -119(A5)
    JSR     GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    PEA     DATA_ESQPARS2_CONST_LONG_1F5C
    PEA     -119(A5)
    JSR     GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    LEA     20(A7),A7
    MOVE.W  DATA_WDISP_BSS_LONG_233A,D0
    MOVE.L  D0,D1
    ADD.W   D7,D1
    MOVE.W  D1,DATA_WDISP_BSS_LONG_233A
    EXT.L   D1
    ADDQ.L  #1,D1
    PEA     (MEMF_PUBLIC).W
    MOVE.L  D1,-(A7)
    PEA     173.W
    PEA     Global_STR_FLIB_C_1
    JSR     NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.W  DATA_WDISP_BSS_LONG_233A,D1
    MOVE.L  D0,-4(A5)
    CMP.W   D7,D1
    BEQ.S   .branch_5

    MOVEA.L DATA_NEWGRID2_BSS_LONG_2049,A0
    MOVEA.L D0,A1

.branch_4:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .branch_4

    BRA.S   .branch_6

.branch_5:
    MOVEA.L D0,A0
    CLR.B   (A0)

.branch_6:
    PEA     -119(A5)
    MOVE.L  -4(A5),-(A7)
    JSR     GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    MOVE.L  DATA_NEWGRID2_BSS_LONG_2049,(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,DATA_NEWGRID2_BSS_LONG_2049
    MOVE.W  DATA_WDISP_BSS_LONG_233A,D0
    EXT.L   D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     198.W
    PEA     Global_STR_FLIB_C_2
    JSR     NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    CLR.L   DATA_ESQPARS2_BSS_LONG_1F57

;------------------------------------------------------------------------------
; FUNC: FLIB_AppendClockStampedLogEntry_Return   (Routine at FLIB_AppendClockStampedLogEntry_Return)
; ARGS:
;   stack +136: arg_1 (via 140(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A2/A3/A7/D0/D1/D2/D3/D6/D7
; CALLS:
;   GROUP_AR_JMPTBL_PARSEINI_WriteErrorLogEntry, GROUP_AW_JMPTBL_WDISP_SPrintf, ESQPARS_ReplaceOwnedString, FLIB_AppendClockStampedLogEntry
; READS:
;   FLIB_EmptyLogReplacementString, DATA_FLIB_FMT_PCT_02LD_COLON_PCT_02LD_COLON_PCT_02_1F60, DATA_NEWGRID2_BSS_LONG_2049, CLOCK_DaySlotIndex, CLOCK_CacheDayIndex0, CLOCK_CacheHour, FLIB_LogEntryScratchBuffer
; WRITES:
;   DATA_NEWGRID2_BSS_LONG_2049, DATA_WDISP_BSS_LONG_233A
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
FLIB_AppendClockStampedLogEntry_Return:
    MOVEM.L -140(A5),D7/A3
    UNLK    A5
    RTS

;!======

    MOVEM.L D6-D7,-(A7)
    MOVE.W  14(A7),D7
    MOVEQ   #0,D6
    TST.W   D7
    BNE.S   .lab_0CC0

    MOVE.W  CLOCK_DaySlotIndex,D0
    SUBQ.W  #3,D0
    BNE.S   .lab_0CC1

    MOVE.W  CLOCK_CacheDayIndex0,D0
    MOVEQ   #7,D1
    CMP.W   D1,D0
    BGE.S   .lab_0CC1

    MOVE.W  CLOCK_CacheHour,D0
    SUBQ.W  #5,D0
    BNE.S   .lab_0CC1

.lab_0CC0:
    MOVEQ   #1,D6

.lab_0CC1:
    TST.W   D6
    BEQ.S   .lab_0CC2

    MOVE.L  DATA_NEWGRID2_BSS_LONG_2049,-(A7)
    PEA     FLIB_EmptyLogReplacementString
    JSR     ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,DATA_NEWGRID2_BSS_LONG_2049
    CLR.W   DATA_WDISP_BSS_LONG_233A

.lab_0CC2:
    PEA     FLIB_LogEntryScratchBuffer
    BSR.W   FLIB_AppendClockStampedLogEntry

    JSR     GROUP_AR_JMPTBL_PARSEINI_WriteErrorLogEntry(PC)

    ADDQ.W  #4,A7
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

    ; Dead code
    MOVEM.L D2-D3/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEA.L 24(A7),A2
    MOVE.B  3(A3),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.B  2(A3),D1
    EXT.W   D1
    EXT.L   D1
    MOVE.B  1(A3),D2
    EXT.W   D2
    EXT.L   D2
    MOVE.B  (A3),D3
    EXT.W   D3
    EXT.L   D3
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_FLIB_FMT_PCT_02LD_COLON_PCT_02LD_COLON_PCT_02_1F60
    MOVE.L  A2,-(A7)
    JSR     GROUP_AW_JMPTBL_WDISP_SPrintf(PC)

    LEA     24(A7),A7
    MOVEM.L (A7)+,D2-D3/A2-A3
    RTS

;!======

    RTS
