    XDEF    _ESQSHARED_ReplaceTvRatingToken
    XDEF    _ESQSHARED_UpdateMatchingEntriesByTitle
    XDEF    ESQSHARED_UpdateMatchingEntriesByTitle_Return



; Possibly the code that replaces the strings of movie ratings like (R) into
; a corresponding character in the font
;------------------------------------------------------------------------------
; FUNC: _ESQSHARED_ReplaceTvRatingToken   (Replace TV-rating token with glyph marker)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A5/A6/A7/D0/D5/D6/D7
; CALLS:
;   _GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold, _LVOCopyMem
; READS:
;   AbsExecBase, _Global_TBL_TV_PROGRAM_RATINGS, _ESQPARS2_TvRatingTokenGlyphMap
; WRITES:
;   (none observed)
; DESC:
;   Scans TV-rating token table, replaces first match with a one-byte glyph code,
;   and compacts trailing text over the consumed token.
; NOTES:
;   Stops after first successful replacement.
;------------------------------------------------------------------------------
_ESQSHARED_ReplaceTvRatingToken:
    LINK.W  A5,#-16
    MOVEM.L D5-D7/A2-A3,-(A7)

    UseLinkStackLong    MOVEA.L,1,A3

    MOVEQ   #0,D5
    MOVEQ   #0,D7

.lab_0C43:
    MOVEQ   #7,D0
    CMP.L   D0,D7
    BGE.S   .return

    TST.W   D5
    BNE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _Global_TBL_TV_PROGRAM_RATINGS,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    MOVE.L  A3,-(A7)
    JSR     _GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   .lab_0C46

    LEA     _ESQPARS2_TvRatingTokenGlyphMap,A0
    ADDA.L  D7,A0
    MOVE.B  (A0),D0
    MOVEA.L -4(A5),A1
    MOVE.B  D0,(A1)+
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _Global_TBL_TV_PROGRAM_RATINGS,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2

.lab_0C44:
    TST.B   (A2)+
    BNE.S   .lab_0C44

    SUBQ.L  #1,A2
    SUBA.L  (A0),A2
    MOVE.L  A2,D0
    MOVE.L  D0,D6
    SUBQ.L  #1,D6
    MOVE.L  A1,-4(A5)
    ADDA.L  D6,A1
    MOVEA.L A1,A0

.lab_0C45:
    TST.B   (A0)+
    BNE.S   .lab_0C45

    SUBQ.L  #1,A0
    SUBA.L  A1,A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVEA.L A1,A0
    MOVEA.L -4(A5),A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    MOVEQ   #1,D5

.lab_0C46:
    ADDQ.L  #1,D7
    BRA.S   .lab_0C43

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;------------------------------------------------------------------------------
; FUNC: _ESQSHARED_UpdateMatchingEntriesByTitle   (Apply compact payload to title-matched entries)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
;   stack +8: arg_3 (via 12(A5))
;   stack +10: arg_4 (via 14(A5))
;   stack +11: arg_5 (via 15(A5))
;   stack +15: arg_6 (via 19(A5))
;   stack +16: arg_7 (via 20(A5))
;   stack +18: arg_8 (via 22(A5))
;   stack +19: arg_9 (via 23(A5))
;   stack +20: arg_10 (via 24(A5))
;   stack +24: arg_11 (via 28(A5))
;   stack +25: arg_12 (via 29(A5))
;   stack +26: arg_13 (via 30(A5))
;   stack +30: arg_14 (via 34(A5))
;   stack +34: arg_15 (via 38(A5))
;   stack +38: arg_16 (via 42(A5))
;   stack +48: arg_17 (via 52(A5))
;   stack +58: arg_18 (via 62(A5))
;   stack +62: arg_19 (via 66(A5))
;   stack +66: arg_20 (via 70(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   _ESQIFF_JMPTBL_MATH_Mulu32, _ESQIFF_JMPTBL_MEMORY_AllocateMemory, _ESQIFF_JMPTBL_MEMORY_DeallocateMemory, _ESQSHARED_JMPTBL_DST_BuildBannerTimeWord, _ESQSHARED_JMPTBL_ESQ_AdjustBracketedHourInString, _ESQSHARED_JMPTBL_ESQ_SetBit1Based, _ESQSHARED_JMPTBL_ESQ_TestBit1Based, _ESQSHARED_JMPTBL_ESQ_WildcardMatch, _GROUP_AR_JMPTBL_STRING_AppendAtNull, _GROUP_AS_JMPTBL_STR_FindCharPtr, _GROUP_AW_JMPTBL_WDISP_SPrintf, _ESQPARS_ReplaceOwnedString, _ESQSHARED_ApplyProgramTitleTextFilters, _NEWGRID_JMPTBL_MATH_DivS32
; READS:
;   _Global_STR_ESQPARS2_C_1, _Global_STR_ESQPARS2_C_2, ESQSHARED_UpdateMatchingEntriesByTitle_Return, _CLOCK_FormatVariantCode, _ESQPARS2_DurationFmt_DecimalWithSpace, _ESQPARS2_DurationFmt_OpenParenHours, _ESQPARS2_DurationFmt_OpenParenMinutes, _ESQPARS2_DurationFmt_CloseParen, _SCRIPT_StrHoursPluralSuffix, _SCRIPT_StrHourSingularSuffix, _SCRIPT_StrMinutesSuffix, _WDISP_CharClassTable, _TEXTDISP_SecondaryGroupCode, _TEXTDISP_SecondaryGroupPresentFlag, _TEXTDISP_SecondaryGroupEntryCount, _TEXTDISP_PrimaryGroupCode, _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryEntryPtrTable, _TEXTDISP_SecondaryEntryPtrTable, _TEXTDISP_PrimaryTitlePtrTable, _TEXTDISP_SecondaryTitlePtrTable, MEMF_CLEAR, MEMF_PUBLIC, branch, branch_21, lab_0C5F, lab_0C6F
; WRITES:
;   (none observed)
; DESC:
;   Finds entries whose title matches the incoming wildcard key, applies slot
;   flags/bitfields, replaces the targeted title slot string, and normalizes
;   embedded time text/flags in-place.
; NOTES:
;   Slot index D6 is validated to 1..48, with bit6 selecting set-bit behavior.
;------------------------------------------------------------------------------
_ESQSHARED_UpdateMatchingEntriesByTitle:
    LINK.W  A5,#-76
    MOVEM.L D2-D7/A2-A3/A6,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.B  15(A5),D7
    MOVE.B  19(A5),D6
    MOVE.B  23(A5),D5
    MOVEA.L 24(A5),A2

    MOVE.L  D6,D0
    ANDI.B  #$40,D0
    ANDI.B  #$3f,D6
    MOVE.B  D0,-15(A5)
    MOVEQ   #1,D0
    CMP.B   D0,D6
    BCS.S   .lab_0C49

    MOVEQ   #48,D1
    CMP.B   D1,D6
    BLS.S   .lab_0C4A

.lab_0C49:
    MOVEQ   #0,D0
    BRA.W   ESQSHARED_UpdateMatchingEntriesByTitle_Return

.lab_0C4A:
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D0
    CMP.B   D7,D0
    BNE.S   .lab_0C4B

    MOVE.B  _TEXTDISP_SecondaryGroupPresentFlag,D0
    SUBQ.B  #1,D0
    BNE.S   .lab_0C4B

    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    MOVE.W  D0,-14(A5)
    BRA.S   .lab_0C4D

.lab_0C4B:
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D0
    CMP.B   D0,D7
    BNE.S   .lab_0C4C

    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.W  D0,-14(A5)
    BRA.S   .lab_0C4D

.lab_0C4C:
    MOVEQ   #0,D0
    BRA.W   ESQSHARED_UpdateMatchingEntriesByTitle_Return

.lab_0C4D:
    CLR.W   -10(A5)

.branch:
    MOVE.W  -10(A5),D0
    CMP.W   -14(A5),D0
    BGE.W   ESQSHARED_UpdateMatchingEntriesByTitle_Return

    MOVE.B  _TEXTDISP_SecondaryGroupCode,D1
    CMP.B   D1,D7
    BNE.S   .lab_0C4F

    MOVE.B  _TEXTDISP_SecondaryGroupPresentFlag,D1
    SUBQ.B  #1,D1
    BNE.S   .lab_0C4F

    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     _TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-4(A5)
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-8(A5)
    BRA.S   .lab_0C50

.lab_0C4F:
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-4(A5)
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-8(A5)

.lab_0C50:
    MOVE.L  A3,-(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     _ESQSHARED_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.W   .lab_0C6F

    MOVEA.L -4(A5),A0
    ADDA.W  #$22,A0
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _ESQSHARED_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    MOVE.W  D0,-12(A5)
    TST.B   -15(A5)
    BNE.S   .lab_0C51

    TST.W   D0
    BNE.W   .lab_0C6F

.lab_0C51:
    TST.B   -15(A5)
    BEQ.S   .lab_0C52

    MOVEA.L -4(A5),A0
    ADDA.W  #$22,A0
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _ESQSHARED_JMPTBL_ESQ_SetBit1Based(PC)

    ADDQ.W  #8,A7

.lab_0C52:
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVEA.L -8(A5),A0
    MOVE.B  D5,7(A0,D0.W)
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A1
    MOVE.B  27(A1),D0
    MOVE.L  D0,-(A7)
    MOVE.L  A2,-(A7)
    BSR.W   _ESQSHARED_ApplyProgramTitleTextFilters

    ADDQ.W  #8,A7
    MOVEQ   #0,D0
    MOVEA.L A2,A0
    MOVEA.L A0,A1

.lab_0C53:
    TST.B   (A1)+
    BNE.S   .lab_0C53

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D1
    MOVE.L  A0,-34(A5)
    ADDA.L  D1,A0
    MOVE.B  D0,-30(A5)
    MOVE.B  D0,-29(A5)
    MOVE.L  A0,-28(A5)
    MOVE.B  -1(A0),D0
    MOVEQ   #41,D1
    CMP.B   D1,D0
    BNE.S   .lab_0C54

    MOVE.B  -4(A0),D2
    MOVEQ   #58,D3
    CMP.B   D3,D2
    BNE.S   .lab_0C54

    MOVEQ   #40,D4
    CMP.B   -6(A0),D4
    BNE.S   .lab_0C54

    MOVEQ   #1,D4
    MOVE.B  D4,-29(A5)

.lab_0C54:
    CMP.B   D1,D0
    BNE.S   .lab_0C55

    MOVEQ   #58,D0
    CMP.B   -4(A0),D0
    BNE.S   .lab_0C55

    MOVEQ   #40,D0
    CMP.B   -5(A0),D0
    BNE.S   .lab_0C55

    MOVEQ   #1,D0
    MOVE.B  D0,-30(A5)

.lab_0C55:
    TST.B   -29(A5)
    BNE.S   .lab_0C56

    TST.B   -30(A5)
    BEQ.W   .lab_0C5F

.lab_0C56:
    MOVEQ   #0,D0
    SUBA.L  A1,A1
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     50.W
    PEA     720.W
    PEA     _Global_STR_ESQPARS2_C_1
    MOVE.L  D0,-42(A5)
    MOVE.L  D0,-38(A5)
    MOVE.L  A1,-70(A5)
    MOVE.L  A1,-66(A5)
    JSR     _ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-70(A5)
    MOVE.L  D0,-66(A5)
    TST.B   -29(A5)
    BEQ.S   .lab_0C57

    MOVEA.L -28(A5),A0
    MOVE.B  -5(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.L  D0,-38(A5)

.lab_0C57:
    MOVEA.L -28(A5),A0
    MOVE.B  -3(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    MOVE.L  D0,-42(A5)
    JSR     _ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVE.B  -2(A0),D1
    EXT.W   D1
    EXT.L   D1
    ADD.L   D1,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEM.L D0,-42(A5)
    MOVE.L  -38(A5),D1
    TST.L   D1
    BLE.S   .branch_2

    MOVE.L  D0,-(A7)
    PEA     _ESQPARS2_DurationFmt_DecimalWithSpace
    PEA     -52(A5)
    JSR     _GROUP_AW_JMPTBL_WDISP_SPrintf(PC)

    MOVE.L  -38(A5),(A7)
    PEA     _ESQPARS2_DurationFmt_OpenParenHours
    PEA     -62(A5)
    JSR     _GROUP_AW_JMPTBL_WDISP_SPrintf(PC)

    PEA     -62(A5)
    MOVE.L  -66(A5),-(A7)
    JSR     _GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    LEA     28(A7),A7
    MOVEQ   #1,D0
    CMP.L   -38(A5),D0
    BNE.S   .branch_1

    PEA     _SCRIPT_StrHourSingularSuffix
    MOVE.L  -66(A5),-(A7)
    JSR     _GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    BRA.S   .branch_3

.branch_1:
    PEA     _SCRIPT_StrHoursPluralSuffix
    MOVE.L  -66(A5),-(A7)
    JSR     _GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    BRA.S   .branch_3

.branch_2:
    MOVE.L  D0,-(A7)
    PEA     _ESQPARS2_DurationFmt_OpenParenMinutes
    PEA     -52(A5)
    JSR     _GROUP_AW_JMPTBL_WDISP_SPrintf(PC)

    LEA     12(A7),A7

.branch_3:
    MOVE.L  -42(A5),D0
    TST.L   D0
    BLE.S   .branch_4

    PEA     -52(A5)
    MOVE.L  -66(A5),-(A7)
    JSR     _GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    PEA     _SCRIPT_StrMinutesSuffix
    MOVE.L  -66(A5),-(A7)
    JSR     _GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    LEA     16(A7),A7
    BRA.S   .branch_6

.branch_4:
    MOVEA.L -66(A5),A0

.branch_5:
    TST.B   (A0)+
    BNE.S   .branch_5

    SUBQ.L  #1,A0
    SUBA.L  -66(A5),A0
    MOVEA.L -66(A5),A1
    MOVE.L  A0,D0
    CLR.B   -1(A1,D0.L)
    PEA     _ESQPARS2_DurationFmt_CloseParen
    MOVE.L  A1,-(A7)
    JSR     _GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.branch_6:
    MOVEA.L -28(A5),A0
    SUBQ.L  #6,A0
    MOVEA.L -66(A5),A1

.branch_7:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .branch_7

    TST.L   -70(A5)
    BEQ.S   .lab_0C5F

    PEA     50.W
    MOVE.L  -70(A5),-(A7)
    PEA     765.W
    PEA     _Global_STR_ESQPARS2_C_2
    JSR     _ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.lab_0C5F:
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  D0,D2
    EXT.L   D2
    ASL.L   #2,D2
    MOVEA.L -8(A5),A0
    MOVE.L  56(A0,D2.L),-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  D1,44(A7)
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVEA.L -8(A5),A0
    MOVE.L  36(A7),D1
    MOVE.L  D0,56(A0,D1.L)
    MOVE.B  _CLOCK_FormatVariantCode,D0
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.W   .branch_21

    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    PEA     91.W
    MOVE.L  56(A0,D1.L),-(A7)
    JSR     _GROUP_AS_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-20(A5)
    TST.L   D0
    BEQ.W   .branch_21

    MOVEA.L D0,A0
    MOVE.B  1(A0),D1
    EXT.W   D1
    EXT.L   D1
    LEA     _WDISP_CharClassTable,A1
    MOVEA.L A1,A6
    ADDA.L  D1,A6
    BTST    #2,(A6)
    BEQ.S   .branch_8

    MOVE.B  1(A0),D1
    EXT.W   D1
    EXT.L   D1
    MOVEQ   #48,D2
    SUB.L   D2,D1
    MOVEQ   #10,D0
    JSR     _ESQIFF_JMPTBL_MATH_Mulu32(PC)

    BRA.S   .branch_9

.branch_8:
    MOVEQ   #0,D0

.branch_9:
    MOVE.B  2(A0),D1
    EXT.W   D1
    EXT.L   D1
    MOVEA.L A1,A6
    ADDA.L  D1,A6
    MOVE.W  D0,-22(A5)
    BTST    #2,(A6)
    BEQ.S   .branch_10

    MOVE.B  2(A0),D1
    EXT.W   D1
    EXT.L   D1
    MOVEQ   #48,D2
    SUB.L   D2,D1
    BRA.S   .branch_11

.branch_10:
    MOVEQ   #0,D1

.branch_11:
    EXT.L   D0
    ADD.L   D1,D0
    MOVE.B  4(A0),D1
    EXT.W   D1
    EXT.L   D1
    MOVEA.L A1,A6
    ADDA.L  D1,A6
    MOVE.W  D0,-22(A5)
    BTST    #2,(A6)
    BEQ.S   .branch_12

    MOVE.B  4(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    JSR     _ESQIFF_JMPTBL_MATH_Mulu32(PC)

    BRA.S   .branch_13

.branch_12:
    MOVEQ   #0,D0

.branch_13:
    MOVE.B  5(A0),D1
    EXT.W   D1
    EXT.L   D1
    ADDA.L  D1,A1
    MOVE.W  D0,-24(A5)
    BTST    #2,(A1)
    BEQ.S   .branch_14

    MOVE.B  5(A0),D1
    EXT.W   D1
    EXT.L   D1
    MOVEQ   #48,D2
    SUB.L   D2,D1
    BRA.S   .branch_15

.branch_14:
    MOVEQ   #0,D1

.branch_15:
    EXT.L   D0
    ADD.L   D1,D0
    MOVE.W  D0,-24(A5)
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  _CLOCK_FormatVariantCode,D1
    ADD.L   D1,D0
    MOVE.W  D0,-24(A5)

.branch_16:
    MOVE.W  -24(A5),D0
    MOVEQ   #59,D1
    CMP.W   D1,D0
    BLE.S   .branch_17

    MOVEQ   #60,D1
    SUB.W   D1,-24(A5)
    ADDQ.W  #1,-22(A5)
    BRA.S   .branch_16

.branch_17:
    MOVE.W  -22(A5),D0
    MOVEQ   #12,D1
    CMP.W   D1,D0
    BLE.S   .branch_18

    MOVEQ   #12,D1
    SUB.W   D1,-22(A5)
    BRA.S   .branch_17

.branch_18:
    MOVE.W  -22(A5),D0
    EXT.L   D0
    MOVEQ   #10,D1
    JSR     _NEWGRID_JMPTBL_MATH_DivS32(PC)

    MOVEQ   #48,D0
    ADD.L   D0,D1
    MOVEA.L -20(A5),A0
    MOVE.B  D1,2(A0)
    MOVE.W  -22(A5),D1
    EXT.L   D1
    DIVS    #10,D1
    MOVEM.W D1,-22(A5)
    BLE.S   .branch_19

    EXT.L   D1
    ADD.L   D0,D1
    BRA.S   .branch_20

.branch_19:
    MOVEQ   #32,D1

.branch_20:
    MOVE.B  D1,1(A0)
    MOVE.W  -24(A5),D1
    EXT.L   D1
    MOVE.L  D1,D0
    MOVEQ   #10,D1
    JSR     _NEWGRID_JMPTBL_MATH_DivS32(PC)

    MOVEQ   #48,D1
    ADD.L   D1,D0
    MOVE.B  D0,4(A0)
    MOVE.W  -24(A5),D0
    EXT.L   D0
    MOVEQ   #10,D1
    JSR     _NEWGRID_JMPTBL_MATH_DivS32(PC)

    MOVEQ   #48,D0
    ADD.L   D0,D1
    MOVE.B  D1,5(A0)

.branch_21:
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    EXT.L   D0
    MOVEQ   #0,D2
    MOVEA.L -8(A5),A0
    MOVE.B  498(A0),D2
    MOVE.L  D2,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,44(A7)
    JSR     _ESQSHARED_JMPTBL_DST_BuildBannerTimeWord(PC)

    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVEA.L -8(A5),A0
    MOVE.L  44(A7),D1
    MOVE.L  56(A0,D1.L),-(A7)
    JSR     _ESQSHARED_JMPTBL_ESQ_AdjustBracketedHourInString(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVEA.L -8(A5),A0
    BTST    #4,7(A0,D0.W)
    BEQ.S   .branch_22

    MOVEA.L -4(A5),A0
    BSET    #0,40(A0)

.branch_22:
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  40(A0),D0
    ORI.W   #$80,D0
    MOVE.B  D0,40(A0)

.lab_0C6F:
    ADDQ.W  #1,-10(A5)
    BRA.W   .branch

;------------------------------------------------------------------------------
; FUNC: ESQSHARED_UpdateMatchingEntriesByTitle_Return   (Return tail for title-matched updater)
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
;   Shared return tail for _ESQSHARED_UpdateMatchingEntriesByTitle.
; NOTES:
;   Restores D2-D7/A2-A3/A6 and frame state.
;------------------------------------------------------------------------------
ESQSHARED_UpdateMatchingEntriesByTitle_Return:
    MOVEM.L (A7)+,D2-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======