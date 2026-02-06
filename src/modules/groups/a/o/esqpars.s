;!======

;------------------------------------------------------------------------------
; FUNC: ESQPARS_ClearAliasStringPointers   (Routine at ESQPARS_ClearAliasStringPointers)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A7/D0/D7
; CALLS:
;   ESQIFF_JMPTBL_MEMORY_DeallocateMemory, ESQPARS_ReplaceOwnedString
; READS:
;   GLOB_STR_ESQPARS_C_1, TEXTDISP_AliasCount, TEXTDISP_AliasPtrTable
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_ClearAliasStringPointers:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7

.branch:
    MOVE.W  TEXTDISP_AliasCount,D0
    CMP.W   D0,D7
    BGE.S   .lab_0B37

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     TEXTDISP_AliasPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,-6(A5)
    MOVE.L  A1,D0
    BEQ.S   .branch_1

    MOVE.L  (A1),-(A7)
    CLR.L   -(A7)
    BSR.W   ESQPARS_ReplaceOwnedString

    MOVEA.L -6(A5),A0
    MOVE.L  D0,(A0)
    MOVE.L  4(A0),(A7)
    CLR.L   -(A7)
    BSR.W   ESQPARS_ReplaceOwnedString

    MOVEA.L -6(A5),A0
    MOVE.L  D0,4(A0)
    PEA     8.W
    MOVE.L  A0,-(A7)
    PEA     945.W
    PEA     GLOB_STR_ESQPARS_C_1
    JSR     ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     28(A7),A7
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     TEXTDISP_AliasPtrTable,A0
    ADDA.L  D0,A0
    CLR.L   (A0)

.branch_1:
    ADDQ.W  #1,D7
    BRA.S   .branch

.lab_0B37:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQPARS_RemoveGroupEntryAndReleaseStrings   (Routine at ESQPARS_RemoveGroupEntryAndReleaseStrings)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
;   stack +8: arg_3 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A5/A7/D0/D1/D5/D6/D7
; CALLS:
;   ESQIFF_JMPTBL_MEMORY_DeallocateMemory, ESQPARS_JMPTBL_COI_FreeEntryResources, ESQPARS_JMPTBL_SCRIPT_ResetCtrlContextAndClearStatusLine, ESQIFF2_ClearLineHeadTailByMode
; READS:
;   GLOB_STR_ESQPARS_C_2, GLOB_STR_ESQPARS_C_3, GLOB_STR_ESQPARS_C_4, ESQPARS_RemoveGroupEntryAndReleaseStrings_Return, TEXTDISP_SecondaryGroupEntryCount, TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_PrimaryEntryPtrTable, TEXTDISP_SecondaryEntryPtrTable, TEXTDISP_PrimaryTitlePtrTable, TEXTDISP_SecondaryTitlePtrTable, lab_0B3A
; WRITES:
;   TEXTDISP_SecondaryGroupPresentFlag, TEXTDISP_SecondaryGroupEntryCount, TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_PrimaryGroupPresentFlag
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_RemoveGroupEntryAndReleaseStrings:
    LINK.W  A5,#-16
    MOVEM.L D5-D7/A2,-(A7)
    MOVE.W  10(A5),D7
    JSR     ESQPARS_JMPTBL_SCRIPT_ResetCtrlContextAndClearStatusLine(PC)

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   ESQIFF2_ClearLineHeadTailByMode

    ADDQ.W  #4,A7
    MOVEQ   #2,D0
    CMP.W   D0,D7
    BNE.S   .lab_0B39

    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D0
    MOVE.L  D0,D5
    SUBQ.W  #1,D5
    MOVEQ   #0,D0
    MOVE.W  D0,TEXTDISP_SecondaryGroupEntryCount
    MOVEQ   #0,D1
    MOVE.B  D1,TEXTDISP_SecondaryGroupPresentFlag
    BRA.S   .lab_0B3A

.lab_0B39:
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.L  D0,D5
    SUBQ.W  #1,D5
    CLR.W   TEXTDISP_PrimaryGroupEntryCount
    CLR.B   TEXTDISP_PrimaryGroupPresentFlag

.lab_0B3A:
    TST.W   D5
    BMI.W   ESQPARS_RemoveGroupEntryAndReleaseStrings_Return

    MOVEQ   #2,D0
    CMP.W   D0,D7
    BNE.S   .branch

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     TEXTDISP_SecondaryEntryPtrTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  (A1),-4(A5)
    ADDA.L  D0,A0
    SUBA.L  A1,A1
    MOVE.L  A1,(A0)
    LEA     TEXTDISP_SecondaryTitlePtrTable,A0
    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVE.L  (A2),-8(A5)
    ADDA.L  D0,A0
    MOVE.L  A1,(A0)
    BRA.S   .branch_1

.branch:
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  (A1),-4(A5)
    ADDA.L  D0,A0
    SUBA.L  A1,A1
    MOVE.L  A1,(A0)
    LEA     TEXTDISP_PrimaryTitlePtrTable,A0
    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVE.L  (A2),-8(A5)
    ADDA.L  D0,A0
    MOVE.L  A1,(A0)

.branch_1:
    MOVEQ   #0,D6

.branch_2:
    TST.L   -8(A5)
    BEQ.S   .branch_5

    MOVEQ   #49,D0
    CMP.W   D0,D6
    BGE.S   .branch_5

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    MOVEA.L 56(A0,D0.L),A0
    MOVE.L  A0,-12(A5)
    MOVE.L  A0,D0
    BEQ.S   .branch_4

.branch_3:
    TST.B   (A0)+
    BNE.S   .branch_3

    SUBQ.L  #1,A0
    SUBA.L  -12(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    PEA     1025.W
    PEA     GLOB_STR_ESQPARS_C_2
    JSR     ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    CLR.L   56(A0,D0.L)

.branch_4:
    ADDQ.W  #1,D6
    BRA.S   .branch_2

.branch_5:
    TST.L   -8(A5)
    BEQ.S   .branch_6

    PEA     500.W
    MOVE.L  -8(A5),-(A7)
    PEA     1031.W
    PEA     GLOB_STR_ESQPARS_C_3
    JSR     ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.branch_6:
    MOVE.L  -4(A5),-(A7)
    JSR     ESQPARS_JMPTBL_COI_FreeEntryResources(PC)

    ADDQ.W  #4,A7
    TST.L   -4(A5)
    BEQ.S   .branch_7

    PEA     52.W
    MOVE.L  -4(A5),-(A7)
    PEA     1040.W
    PEA     GLOB_STR_ESQPARS_C_4
    JSR     ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.branch_7:
    SUBQ.W  #1,D5
    BRA.W   .lab_0B3A

;------------------------------------------------------------------------------
; FUNC: ESQPARS_RemoveGroupEntryAndReleaseStrings_Return   (Routine at ESQPARS_RemoveGroupEntryAndReleaseStrings_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D5
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
ESQPARS_RemoveGroupEntryAndReleaseStrings_Return:
    MOVEM.L (A7)+,D5-D7/A2
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQPARS_ReplaceOwnedString   (Routine at ESQPARS_ReplaceOwnedString)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A6/A7/D0/D1/D6/D7
; CALLS:
;   ESQIFF_JMPTBL_MEMORY_AllocateMemory, ESQIFF_JMPTBL_MEMORY_DeallocateMemory, _LVOAvailMem
; READS:
;   AbsExecBase, GLOB_STR_ESQPARS_C_5, GLOB_STR_ESQPARS_C_6, MEMF_PUBLIC
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_ReplaceOwnedString:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEA.L 24(A7),A2

    MOVE.L  A2,D0
    BEQ.S   .lab_0B46

    MOVEA.L A2,A0

.lab_0B45:
    TST.B   (A0)+
    BNE.S   .lab_0B45

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,D0
    MOVE.L  D0,D7
    ADDQ.L  #1,D7
    MOVE.L  D7,-(A7)
    MOVE.L  A2,-(A7)
    PEA     1081.W
    PEA     GLOB_STR_ESQPARS_C_5
    JSR     ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.lab_0B46:
    MOVE.L  A3,D0
    BNE.S   .lab_0B47

    MOVEQ   #0,D0
    BRA.S   ESQPARS_ReplaceOwnedString_Return

.lab_0B47:
    MOVEA.L A3,A0

.lab_0B48:
    TST.B   (A0)+
    BNE.S   .lab_0B48

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D0
    MOVE.L  D0,D6
    ADDQ.L  #1,D6
    MOVEQ   #1,D0
    CMP.L   D0,D6
    BNE.S   .lab_0B49

    MOVEQ   #0,D0
    BRA.S   ESQPARS_ReplaceOwnedString_Return

.lab_0B49:
    SUBA.L  A2,A2
    MOVEQ   #1,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAvailMem(A6)

    CMPI.L  #$2710,D0
    BLE.S   .lab_0B4A

    PEA     (MEMF_PUBLIC).W
    MOVE.L  D6,-(A7)
    PEA     1100.W
    PEA     GLOB_STR_ESQPARS_C_6
    JSR     ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A2

.lab_0B4A:
    MOVE.L  A2,D0
    BEQ.S   .branch_1

    MOVEA.L A3,A0
    MOVEA.L A2,A1

.branch:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .branch

.branch_1:
    MOVE.L  A2,D0

;------------------------------------------------------------------------------
; FUNC: ESQPARS_ReplaceOwnedString_Return   (Routine at ESQPARS_ReplaceOwnedString_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D6
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
ESQPARS_ReplaceOwnedString_Return:
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQPARS_ApplyRtcBytesAndPersist   (Routine at ESQPARS_ApplyRtcBytesAndPersist)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
;   stack +8: arg_3 (via 12(A5))
;   stack +10: arg_4 (via 14(A5))
;   stack +12: arg_5 (via 16(A5))
;   stack +14: arg_6 (via 18(A5))
;   stack +16: arg_7 (via 20(A5))
;   stack +18: arg_8 (via 22(A5))
;   stack +20: arg_9 (via 24(A5))
;   stack +28: arg_10 (via 32(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A5/A7/D0/D7
; CALLS:
;   ESQPARS_JMPTBL_PARSEINI_WriteRtcFromGlobals, ESQDISP_NormalizeClockAndRedrawBanner
; READS:
;   ESQPARS2_ReadModeFlags
; WRITES:
;   ESQPARS2_ReadModeFlags
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_ApplyRtcBytesAndPersist:
    LINK.W  A5,#-24
    MOVEM.L D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.B  (A3),D0
    EXT.W   D0
    MOVE.W  D0,-24(A5)
    MOVE.B  1(A3),D0
    EXT.W   D0
    MOVE.W  D0,-22(A5)
    MOVE.B  2(A3),D0
    EXT.W   D0
    MOVE.W  D0,-20(A5)
    MOVE.B  3(A3),D0
    EXT.W   D0
    EXT.L   D0
    ADDI.L  #1900,D0
    MOVE.W  D0,-18(A5)
    MOVE.B  4(A3),D0
    EXT.W   D0
    MOVE.W  D0,-16(A5)
    MOVE.B  5(A3),D0
    EXT.W   D0
    MOVE.W  D0,-14(A5)
    MOVE.B  6(A3),D0
    EXT.W   D0
    MOVE.W  D0,-12(A5)
    MOVE.B  7(A3),D0
    EXT.W   D0
    MOVE.W  D0,-10(A5)
    PEA     -24(A5)
    JSR     ESQDISP_NormalizeClockAndRedrawBanner(PC)

    MOVE.W  ESQPARS2_ReadModeFlags,D7
    MOVE.W  #256,ESQPARS2_ReadModeFlags
    JSR     ESQPARS_JMPTBL_PARSEINI_WriteRtcFromGlobals(PC)

    MOVE.W  D7,ESQPARS2_ReadModeFlags

    MOVEM.L -32(A5),D7/A3
    UNLK    A5
    RTS

;!======

; This whole sub-routine appears to be for processing control data
;------------------------------------------------------------------------------
; FUNC: ESQPARS_ProcessSerialCommandByte   (Routine at ESQPARS_ProcessSerialCommandByte)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +5: arg_2 (via 9(A5))
;   stack +6: arg_3 (via 10(A5))
;   stack +10: arg_4 (via 14(A5))
;   stack +14: arg_5 (via 18(A5))
;   stack +18: arg_6 (via 22(A5))
;   stack +22: arg_7 (via 26(A5))
;   stack +26: arg_8 (via 30(A5))
;   stack +27: arg_9 (via 31(A5))
;   stack +32: arg_10 (via 36(A5))
;   stack +37: arg_11 (via 41(A5))
;   stack +38: arg_12 (via 42(A5))
;   stack +57: arg_13 (via 61(A5))
;   stack +58: arg_14 (via 62(A5))
;   stack +62: arg_15 (via 66(A5))
;   stack +66: arg_16 (via 70(A5))
;   stack +67: arg_17 (via 71(A5))
;   stack +68: arg_18 (via 72(A5))
;   stack +206: arg_19 (via 210(A5))
;   stack +207: arg_20 (via 211(A5))
;   stack +208: arg_21 (via 212(A5))
;   stack +209: arg_22 (via 213(A5))
;   stack +214: arg_23 (via 218(A5))
;   stack +218: arg_24 (via 222(A5))
;   stack +219: arg_25 (via 223(A5))
;   stack +220: arg_26 (via 224(A5))
;   stack +221: arg_27 (via 225(A5))
;   stack +222: arg_28 (via 226(A5))
;   stack +223: arg_29 (via 227(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   ESQIFF_JMPTBL_MATH_Mulu32, ESQPARS_JMPTBL_CLEANUP_ParseAlignedListingBlock, ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition, ESQPARS_JMPTBL_DST_HandleBannerCommand32_33, ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte, ESQPARS_JMPTBL_DISKIO_ParseConfigBuffer, ESQPARS_JMPTBL_DISKIO_SaveConfigToFileHandle, ESQPARS_JMPTBL_DISKIO2_HandleInteractiveFileTransfer, ESQPARS_JMPTBL_P_TYPE_ParseAndStoreTypeRecord, ESQPARS_JMPTBL_PARSEINI_HandleFontCommand, ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte, ESQPARS_JMPTBL_UNKNOWN_CopyLabelToGlobal, ESQPARS_JMPTBL_UNKNOWN_ParseDigitLabelAndDisplay, ESQPARS_JMPTBL_UNKNOWN_VerifyChecksumAndParseList, ESQPARS_JMPTBL_UNKNOWN_VerifyChecksumAndParseRecord, ESQSHARED_JMPTBL_ESQ_ReverseBitsIn6Bytes, ESQSHARED_JMPTBL_ESQ_TestBit1Based, ESQ_PollCtrlInput, GCOMMAND_ParseCommandOptions, GCOMMAND_ParseCommandString, GCOMMAND_ParsePPVCommand, GROUP_AM_JMPTBL_WDISP_SPrintf, GROUP_AS_JMPTBL_UNKNOWN7_FindCharWrapper, GROUP_AW_JMPTBL_DISPLIB_DisplayTextAtPosition, ESQDISP_UpdateStatusMaskAndRefresh, ESQDISP_ParseProgramInfoCommandRecord, ESQDISP_GetEntryPointerByMode, ESQDISP_GetEntryAuxPointerByMode, ESQFUNC_WaitForClockChangeAndServiceUi, ESQIFF2_ApplyIncomingStatusPacket, ESQIFF2_ParseLineHeadTailRecord, ESQIFF2_ParseGroupRecordAndRefresh, ESQIFF2_ReadSerialBytesToBuffer, ESQIFF2_ReadSerialBytesWithXor, ESQIFF2_ReadSerialRecordIntoBuffer, ESQIFF2_ReadSerialSizedTextRecord, ESQIFF2_ShowVersionMismatchOverlay, ESQIFF2_ClearPrimaryEntryFlags34To39, ESQPARS_ReplaceOwnedString, ESQPARS_ApplyRtcBytesAndPersist, ESQPARS_ReadLengthWordWithChecksumXor, ESQPARS_PersistStateDataAfterCommand, ESQSHARED_ParseCompactEntryRecord, ESQSHARED_MatchSelectionCodeWithOptionalSuffix, LOCAVAIL_ParseFilterStateFromBuffer, LADFUNC_ParseBannerEntryData
; READS:
;   CTRL_BUFFER, CTRL_H, DATACErrs, GLOB_REF_696_400_BITMAP, GLOB_REF_RASTPORT_1, GLOB_STR_23, GLOB_STR_RESET_COMMAND_RECEIVED, LAB_0B55, LAB_0B59, LAB_0B6B, LAB_0B6F, LAB_0B86, LAB_0B8C, LAB_0B8F, LAB_0B90, LAB_0B91, LAB_0B99, LAB_0B9C, LAB_0B9F, LAB_0BA2, LAB_0BA6, LAB_0BAD, LAB_0BB1, LAB_0BB5, LAB_0BB9, LAB_0BC1, LAB_0BC2, LAB_0BC8, LAB_0BC9, LAB_0BCE, LAB_0BD1, LAB_0BD5, LAB_0BD9, LAB_0BDC, LAB_0BE4, LAB_0BE5, DATA_CTASKS_STR_1_1BC9, DATA_ESQ_BSS_WORD_1DF6, DATA_WDISP_BSS_LONG_21BD, TEXTDISP_SecondaryGroupCode, TEXTDISP_SecondaryGroupPresentFlag, TEXTDISP_SecondaryGroupEntryCount, TEXTDISP_PrimaryGroupCode, TEXTDISP_PrimaryGroupEntryCount, ESQIFF_RecordLength, TEXTDISP_PrimaryEntryPtrTable, TEXTDISP_SecondaryEntryPtrTable, TEXTDISP_PrimaryTitlePtrTable, TEXTDISP_SecondaryTitlePtrTable, ESQIFF_RecordChecksumByte, ED_DiagnosticsViewMode, ESQIFF_ParseAttemptCount, ESQIFF_LineErrorCount, DATA_WDISP_BSS_LONG_2298, DATA_WDISP_BSS_WORD_2299, ESQIFF_RecordBufferPtr, ESQPARS_Preamble55SeenFlag, ESQPARS_CommandPreambleArmedFlag, DATA_WDISP_BSS_WORD_22A0, ESQPARS_ResetArmedFlag, LOCAVAIL_PrimaryFilterState, LOCAVAIL_SecondaryFilterState, LAB_CTRLHTCMAX, SCRIPT_CTRL_CHECKSUM, SCRIPT_CTRL_READ_INDEX, SCRIPT_CTRL_STATE, a, cmdDATABinaryDL, cmdTableDATA, de, fc, ff7f, processCommand_D_Diagnostics, processCommand_K_Clock, processCommand_R_Reset, processCommand_V_Version, processCommand_xBB_BoxOff
; WRITES:
;   DATACErrs, DATA_ESQ_BSS_WORD_1DF6, DATA_WDISP_BSS_LONG_21BD, ESQIFF_RecordLength, ESQIFF_RecordChecksumByte, ESQIFF_ParseAttemptCount, ESQIFF_LineErrorCount, ESQPARS_Preamble55SeenFlag, ESQPARS_CommandPreambleArmedFlag, DATA_WDISP_BSS_WORD_22A0, ESQPARS_ResetArmedFlag, DATA_WDISP_BSS_LONG_2363
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_ProcessSerialCommandByte:
    LINK.W  A5,#-232
    MOVEM.L D2/D5-D7/A2,-(A7)

    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.W  ESQPARS_CommandPreambleArmedFlag,D1
    MOVE.B  D0,-5(A5)
    TST.W   D1
    BNE.S   .LAB_0B52

    MOVEQ   #$55,D1         ; Copy 0x55 ('U') into D1
    CMP.B   D1,D0           ; Compare that byte to D0
    BNE.S   .LAB_0B50       ; and jump to .LAB_0B50 if it's not equa.

    MOVEQ   #1,D1           ; Copy 1 into D1...
    MOVE.W  D1,ESQPARS_Preamble55SeenFlag     ; and then 0x0001 into ESQPARS_Preamble55SeenFlag
    MOVEQ   #0,D2           ; Copy 0 into D2...
    MOVE.W  D2,ESQPARS_CommandPreambleArmedFlag     ; and then 0x0000 into ESQPARS_CommandPreambleArmedFlag
    BRA.W   .LAB_0BE5       ; and branch to .LAB_0BE5

.LAB_0B50:
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #$55,D2
    ADD.L   D2,D2
    CMP.L   D2,D1
    BNE.S   .LAB_0B51

    MOVE.W  ESQPARS_Preamble55SeenFlag,D1
    SUBQ.W  #1,D1
    BNE.S   .LAB_0B51

    MOVEQ   #0,D1
    MOVE.W  D1,ESQPARS_Preamble55SeenFlag
    MOVEQ   #1,D2
    MOVE.W  D2,ESQPARS_CommandPreambleArmedFlag
    BRA.W   .LAB_0BE5

.LAB_0B51:
    MOVEQ   #0,D1
    MOVE.W  D1,ESQPARS_Preamble55SeenFlag
    MOVE.W  D1,ESQPARS_CommandPreambleArmedFlag
    BRA.W   .LAB_0BE5

.LAB_0B52:
    SUBQ.W  #1,D1
    BNE.W   .cmdTableDATA

    MOVE.W  DATA_WDISP_BSS_WORD_22A0,D1
    BNE.W   .cmdTableDATA

    MOVEQ   #65,D1
    CMP.B   D1,D0
    BNE.W   .LAB_0B55

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ReadSerialRecordIntoBuffer

    MOVE.W  D0,ESQIFF_RecordLength
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0B54

    MOVE.W  ESQIFF_RecordLength,D0
    MOVEQ   #16,D1
    CMP.W   D1,D0
    BHI.S   .LAB_0B53

    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    JSR     ESQSHARED_MatchSelectionCodeWithOptionalSuffix(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.W  D1,DATA_WDISP_BSS_WORD_22A0
    SUBQ.W  #1,D1
    BNE.S   .clearValues

    MOVE.W  #1,ESQPARS_ResetArmedFlag
    PEA     1.W
    PEA     2.W
    JSR     ESQDISP_UpdateStatusMaskAndRefresh(PC)

    ADDQ.W  #8,A7
    MOVEQ   #1,D0
    MOVE.L  D0,DATA_WDISP_BSS_LONG_21BD
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    BRA.S   .clearValues

.LAB_0B53:
    MOVE.W  ESQIFF_LineErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_LineErrorCount
    BRA.S   .clearValues

;!======

; Increment the number of DATACErrs encountered
.LAB_0B54:
    MOVE.W  DATACErrs,D0    ; Move DATACErrs to D0
    ADDQ.W  #1,D0           ; Add 1 to D0
    MOVE.W  D0,DATACErrs    ; Move D0 back to DATACErrs
    BRA.S   .clearValues    ; Clear the values

.LAB_0B55:
    MOVEQ   #87,D1
    CMP.B   D1,D0
    BNE.S   .LAB_0B56

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    JSR     ESQPARS_JMPTBL_UNKNOWN_VerifyChecksumAndParseRecord(PC)

    ADDQ.W  #4,A7
    BRA.S   .clearValues

.LAB_0B56:
    MOVEQ   #119,D1         ; Copy 119 ('w') into D1
    CMP.B   D1,D0           ; Compare 'w' in D1 to D0
    BNE.S   .clearValues    ; If they're not equal, jump to clear values

    MOVEQ   #0,D1           ; Move 0 into D1 to clear out all the bits
    MOVE.B  D0,D1           ; Then move a byte from D0 into D1
    MOVE.L  D1,-(A7)        ; Push D1 to the stack
    JSR     ESQPARS_JMPTBL_UNKNOWN_VerifyChecksumAndParseList(PC)    ; Jump to ESQPARS_JMPTBL_UNKNOWN_VerifyChecksumAndParseList(PC)

    ADDQ.W  #4,A7           ; Add 4 to the stack (nuking the last value in it)

.clearValues:               ; Clear out ESQPARS_Preamble55SeenFlag and ESQPARS_CommandPreambleArmedFlag
    MOVEQ   #0,D0           ; Copy 0 into D0
    MOVE.W  D0,ESQPARS_Preamble55SeenFlag     ; Copy D0 (0) into ESQPARS_Preamble55SeenFlag
    MOVE.W  D0,ESQPARS_CommandPreambleArmedFlag     ; Copy D0 (0) into ESQPARS_CommandPreambleArmedFlag
    BRA.W   .LAB_0BE5

.cmdTableDATA:
    ; https://prevueguide.com/Documentation/D2400.pdf
    MOVE.W  ESQPARS_CommandPreambleArmedFlag,D0
    SUBQ.W  #1,D0
    BNE.W   .LAB_0BE5

    MOVE.W  DATA_WDISP_BSS_WORD_22A0,D0
    SUBQ.W  #1,D0
    BNE.W   .LAB_0BE5

    MOVEQ   #0,D0       ; Move 0 into D0 to clear it out
    MOVE.B  -5(A5),D0   ; Copy the byte at -5(A5) which is the byte from serial to D0

    SUBI.W  #$21,D0   ; Subtract x21/33 from D0
    BEQ.W   .LAB_0B59   ; Does D0 equal zero (exactly)? Means D0 was 33 or '!'

    SUBQ.W  #4,D0       ; Subtract 4 more so x25/37
    BEQ.W   .LAB_0BB9   ; Does D0 equal zero now? This is mode '%'

    SUBI.W  #$18,D0   ; Subtract x18/24 so x3D/61
    BEQ.W   .cmdDATABinaryDL ; Does D0 equal zero now? This is mode '='

    SUBQ.W  #6,D0       ; Subtract x6/6 so 67
    BEQ.W   .LAB_0B99   ; Same as above... this time mode 'C'

    SUBQ.W  #1,D0       ; Subtract 1 so 68
    BEQ.W   .processCommand_D_Diagnostics   ; Mode 'D' (diagnostic command)

    SUBQ.W  #1,D0
    BEQ.W   .LAB_0BA2   ; 'E'

    SUBQ.W  #1,D0
    BEQ.W   .LAB_0BA6   ; 'F'

    SUBQ.W  #2,D0
    BEQ.W   .cmdDATABinaryDL ; 'H'

    SUBQ.W  #1,D0
    BEQ.W   .LAB_0BB1 ; 'I'

    SUBQ.W  #2,D0
    BEQ.W   .processCommand_K_Clock ; 'K'

    SUBQ.W  #1,D0
    BEQ.W   .LAB_0B91 ; 'L'

    SUBQ.W  #1,D0
    BEQ.W   .LAB_0BC1 ; 'M'

    SUBQ.W  #2,D0
    BEQ.W   .LAB_0BC2 ; 'O'

    SUBQ.W  #1,D0
    BEQ.W   .LAB_0B6B ; 'P'

    SUBQ.W  #2,D0
    BEQ.W   .processCommand_R_Reset ; 'R'

    SUBQ.W  #4,D0
    BEQ.W   .processCommand_V_Version ; 'V'

    SUBQ.W  #1,D0
    BEQ.W   .LAB_0BC8 ; 'W'

    SUBI.W  #12,D0
    BEQ.W   .LAB_0B9C ; 'c'

    SUBQ.W  #3,D0
    BEQ.W   .LAB_0BD1 ; 'f'

    SUBQ.W  #1,D0
    BEQ.W   .LAB_0BD5 ; 'g'

    SUBQ.W  #1,D0
    BEQ.W   .cmdDATABinaryDL ; 'h'

    SUBQ.W  #1,D0
    BEQ.W   .LAB_0BB5 ; 'i'

    SUBQ.W  #1,D0
    BEQ.W   .LAB_0BAD ; 'j'

    SUBQ.W  #6,D0
    BEQ.W   .LAB_0B6F ; 'p'

    SUBQ.W  #4,D0
    BEQ.W   .LAB_0B91 ; 't'

    SUBQ.W  #2,D0
    BEQ.W   .LAB_0B9F ; 'v'

    SUBQ.W  #1,D0
    BEQ.W   .LAB_0BC9 ; 'w'

    SUBQ.W  #1,D0
    BEQ.W   .LAB_0BCE ; 'x'

    SUBI.W  #$43,D0
    BEQ.W   .processCommand_xBB_BoxOff ; xBB (Box off)

    BRA.W   .LAB_0BE4

.LAB_0B59:
    CLR.B   -62(A5)
    MOVE.B  #$de,-71(A5)
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    PEA     -71(A5)
    PEA     1.W
    PEA     -61(A5)
    BSR.W   ESQIFF2_ReadSerialBytesWithXor

    MOVEQ   #0,D0
    MOVE.B  -61(A5),D0
    PEA     -71(A5)
    PEA     1.W
    PEA     -61(A5)
    MOVE.L  D0,-14(A5)
    BSR.W   ESQIFF2_ReadSerialBytesWithXor

    MOVE.B  -61(A5),-7(A5)
    PEA     -71(A5)
    PEA     1.W
    PEA     -61(A5)
    BSR.W   ESQIFF2_ReadSerialBytesWithXor

    LEA     36(A7),A7
    MOVE.B  -61(A5),D0
    MOVE.B  D0,-8(A5)
    MOVE.B  -7(A5),D0
    MOVEQ   #1,D1
    CMP.B   D1,D0
    BCS.S   .LAB_0B5A

    MOVE.B  -8(A5),D1
    MOVEQ   #48,D2
    CMP.B   D2,D1
    BHI.S   .LAB_0B5A

    CMP.B   D0,D1
    BCS.S   .LAB_0B5A

    MOVEQ   #0,D0
    MOVE.B  TEXTDISP_PrimaryGroupCode,D0
    MOVE.L  -14(A5),D1
    CMP.L   D1,D0
    BEQ.S   .LAB_0B5B

    MOVEQ   #0,D0
    MOVE.B  TEXTDISP_SecondaryGroupCode,D0

    CMP.L   D0,D1
    BEQ.S   .LAB_0B5B

.LAB_0B5A:
    CLR.B   -62(A5)
    BRA.W   .LAB_0BE4

.LAB_0B5B:
    CLR.L   -22(A5)
    PEA     -71(A5)
    PEA     1.W
    PEA     -61(A5)
    BSR.W   ESQIFF2_ReadSerialBytesWithXor

    LEA     12(A7),A7

.LAB_0B5C:
    TST.B   -61(A5)
    BEQ.S   .LAB_0B5D

    MOVE.B  -61(A5),D0
    MOVEQ   #18,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_0B5D

    MOVEQ   #32,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_0B5D

    MOVE.L  -22(A5),D1
    MOVEQ   #6,D2
    CMP.L   D2,D1
    BGE.S   .LAB_0B5D

    ADDQ.L  #1,-22(A5)
    MOVE.B  D0,-41(A5,D1.L)
    PEA     -71(A5)
    PEA     1.W
    PEA     -61(A5)
    BSR.W   ESQIFF2_ReadSerialBytesWithXor

    LEA     12(A7),A7
    BRA.S   .LAB_0B5C

.LAB_0B5D:
    MOVE.L  -22(A5),D0
    CLR.B   -41(A5,D0.L)

.LAB_0B5E:
    TST.B   -61(A5)
    BEQ.S   .LAB_0B5F

    PEA     -71(A5)
    PEA     1.W
    PEA     -61(A5)
    BSR.W   ESQIFF2_ReadSerialBytesWithXor

    LEA     12(A7),A7
    BRA.S   .LAB_0B5E

.LAB_0B5F:
    PEA     1.W
    PEA     -31(A5)
    BSR.W   ESQIFF2_ReadSerialBytesToBuffer

    ADDQ.W  #8,A7
    MOVE.B  -71(A5),D0
    MOVE.B  -31(A5),D1
    CMP.B   D1,D0
    BEQ.S   .LAB_0B60

    MOVEQ   #0,D0
    MOVE.B  D0,-62(A5)
    BRA.S   .LAB_0B61

.LAB_0B60:
    MOVEQ   #1,D0
    MOVE.B  D0,-62(A5)

.LAB_0B61:
    SUBQ.B  #1,D0
    BNE.W   .LAB_0BE4

    CLR.B   -62(A5)
    MOVEQ   #89,D0
    CMP.B   -7(A5),D0
    BNE.S   .LAB_0B62

    MOVEQ   #1,D0
    MOVE.B  #$30,-8(A5)
    MOVE.B  D0,-7(A5)

.LAB_0B62:
    MOVEQ   #0,D0
    MOVE.B  TEXTDISP_SecondaryGroupCode,D0
    MOVE.L  -14(A5),D1
    CMP.L   D1,D0
    BNE.S   .LAB_0B63

    MOVE.B  TEXTDISP_SecondaryGroupPresentFlag,D0
    SUBQ.B  #1,D0
    BNE.S   .LAB_0B63

    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D0
    MOVEQ   #2,D2
    MOVE.L  D2,-30(A5)
    MOVE.L  D0,-18(A5)
    BRA.S   .LAB_0B64

.LAB_0B63:
    MOVEQ   #0,D0
    MOVE.B  TEXTDISP_PrimaryGroupCode,D0
    CMP.L   D0,D1
    BNE.W   .LAB_0BE4

    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    MOVEQ   #1,D1
    MOVE.L  D1,-30(A5)
    MOVE.L  D0,-18(A5)

.LAB_0B64:
    CLR.L   -26(A5)

.LAB_0B65:
    MOVE.L  -26(A5),D0
    CMP.L   -18(A5),D0
    BGE.S   .LAB_0B68

    MOVE.L  -30(A5),-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQDISP_GetEntryPointerByMode(PC)

    MOVE.L  -30(A5),(A7)
    MOVE.L  -26(A5),-(A7)
    MOVE.L  D0,-66(A5)
    JSR     ESQDISP_GetEntryAuxPointerByMode(PC)

    LEA     12(A7),A7
    LEA     -41(A5),A0
    MOVEA.L D0,A1
    MOVE.L  D0,-70(A5)

.LAB_0B66:
    MOVE.B  (A0)+,D1
    CMP.B   (A1)+,D1
    BNE.S   .LAB_0B67

    TST.B   D1
    BNE.S   .LAB_0B66

    BNE.S   .LAB_0B67

    MOVE.B  #$1,-62(A5)
    BRA.S   .LAB_0B68

.LAB_0B67:
    ADDQ.L  #1,-26(A5)
    BRA.S   .LAB_0B65

.LAB_0B68:
    MOVEQ   #1,D0
    CMP.B   -62(A5),D0
    BNE.W   .LAB_0BE4

    MOVE.B  -7(A5),D0
    MOVEQ   #1,D1
    CMP.B   D1,D0
    BNE.S   .LAB_0B69

    MOVEQ   #48,D1
    CMP.B   -8(A5),D1
    BNE.S   .LAB_0B69

    MOVEQ   #0,D1
    MOVEA.L -66(A5),A0
    MOVE.B  40(A0),D1
    ANDI.W  #$ff7f,D1
    MOVE.B  D1,40(A0)

.LAB_0B69:
    MOVE.B  D0,-9(A5)

.LAB_0B6A:
    MOVE.B  -9(A5),D0
    CMP.B   -8(A5),D0
    BHI.W   .LAB_0BE4

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,D2
    EXT.L   D2
    ASL.L   #2,D2
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -70(A5),A0
    MOVE.L  56(A0,D0.L),-(A7)
    CLR.L   -(A7)
    MOVE.L  D2,28(A7)
    BSR.W   ESQPARS_ReplaceOwnedString

    ADDQ.W  #8,A7
    MOVEA.L -70(A5),A0
    MOVE.L  20(A7),D1
    MOVE.L  D0,56(A0,D1.L)
    MOVEQ   #0,D0
    MOVE.B  -9(A5),D0
    MOVE.B  #$1,7(A0,D0.W)
    ADDQ.B  #1,-9(A5)
    BRA.S   .LAB_0B6A

.LAB_0B6B:
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    CLR.L   -(A7)
    PEA     2.W
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ReadSerialRecordIntoBuffer

    MOVE.W  D0,ESQIFF_RecordLength
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0B6D

    MOVE.W  ESQIFF_RecordLength,D0
    CMPI.W  #$1ff,D0
    BHI.S   .LAB_0B6C

    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    JSR     ESQSHARED_ParseCompactEntryRecord(PC)

    ADDQ.W  #4,A7
    BRA.S   .LAB_0B6E

.LAB_0B6C:
    MOVE.W  ESQIFF_LineErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_LineErrorCount
    BRA.S   .LAB_0B6E

.LAB_0B6D:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0B6E:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .LAB_0BE4

.LAB_0B6F:
    CLR.B   -213(A5)
    MOVE.B  #$1,-224(A5)
    MOVE.B  #$8f,-227(A5)
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    PEA     -227(A5)
    PEA     1.W
    PEA     -62(A5)
    BSR.W   ESQIFF2_ReadSerialBytesWithXor

    MOVEQ   #0,D0
    MOVE.B  -62(A5),D0
    PEA     -227(A5)
    PEA     1.W
    PEA     -62(A5)
    MOVE.L  D0,-10(A5)
    BSR.W   ESQIFF2_ReadSerialBytesWithXor

    LEA     24(A7),A7
    CLR.L   -18(A5)

.LAB_0B70:
    MOVE.B  -62(A5),D0
    MOVE.L  -18(A5),D1
    MOVE.B  D0,-36(A5,D1.L)
    MOVEQ   #18,D2
    CMP.B   D2,D0
    BEQ.S   .LAB_0B71

    MOVEQ   #8,D0
    CMP.L   D0,D1
    BGE.S   .LAB_0B71

    PEA     -227(A5)
    PEA     1.W
    PEA     -62(A5)
    BSR.W   ESQIFF2_ReadSerialBytesWithXor

    LEA     12(A7),A7
    ADDQ.L  #1,-18(A5)
    BRA.S   .LAB_0B70

.LAB_0B71:
    MOVE.L  -18(A5),D0
    CLR.B   -36(A5,D0.L)
    MOVEQ   #0,D0
    MOVE.B  TEXTDISP_SecondaryGroupCode,D0
    MOVE.L  -10(A5),D1
    CMP.L   D1,D0
    BNE.S   .LAB_0B72

    MOVE.B  TEXTDISP_SecondaryGroupPresentFlag,D0
    SUBQ.B  #1,D0
    BNE.S   .LAB_0B72

    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D0
    MOVE.L  D0,-14(A5)
    BRA.S   .LAB_0B73

.LAB_0B72:
    MOVEQ   #0,D0
    MOVE.B  TEXTDISP_PrimaryGroupCode,D0
    CMP.L   D0,D1
    BNE.W   .LAB_0BE4

    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.L  D0,-14(A5)

.LAB_0B73:
    PEA     -227(A5)
    PEA     6.W
    PEA     -62(A5)
    BSR.W   ESQIFF2_ReadSerialBytesWithXor

    LEA     12(A7),A7
    CLR.L   -18(A5)

.LAB_0B74:
    MOVE.L  -18(A5),D0
    MOVEQ   #6,D1
    CMP.L   D1,D0
    BGE.S   .LAB_0B76

    TST.B   -62(A5,D0.L)
    BEQ.S   .LAB_0B75

    CLR.B   -224(A5)

.LAB_0B75:
    ADDQ.L  #1,-18(A5)
    BRA.S   .LAB_0B74

.LAB_0B76:
    PEA     -62(A5)
    PEA     -42(A5)
    JSR     ESQSHARED_JMPTBL_ESQ_ReverseBitsIn6Bytes(PC)

    ADDQ.W  #8,A7
    CLR.L   -26(A5)

.LAB_0B77:
    MOVE.L  -26(A5),D0
    CMP.L   -14(A5),D0
    BGE.S   .LAB_0B7C

    MOVEQ   #0,D1
    MOVE.B  TEXTDISP_SecondaryGroupCode,D1
    MOVE.L  -10(A5),D2
    CMP.L   D1,D2
    BNE.S   .LAB_0B78

    MOVE.B  TEXTDISP_SecondaryGroupPresentFlag,D1
    SUBQ.B  #1,D1
    BNE.S   .LAB_0B78

    ASL.L   #2,D0
    LEA     TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-218(A5)
    LEA     TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-222(A5)
    BRA.S   .LAB_0B79

.LAB_0B78:
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-218(A5)
    LEA     TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-222(A5)

.LAB_0B79:
    LEA     -36(A5),A0
    MOVEA.L -222(A5),A1

.LAB_0B7A:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.S   .LAB_0B7B

    TST.B   D0
    BNE.S   .LAB_0B7A

    BNE.S   .LAB_0B7B

    MOVE.B  #$1,-213(A5)
    BRA.S   .LAB_0B7C

.LAB_0B7B:
    ADDQ.L  #1,-26(A5)
    BRA.S   .LAB_0B77

.LAB_0B7C:
    PEA     -227(A5)
    PEA     1.W
    PEA     -223(A5)
    BSR.W   ESQIFF2_ReadSerialBytesWithXor

    LEA     12(A7),A7
    MOVE.B  -223(A5),D0
    MOVEQ   #1,D1
    CMP.B   D1,D0
    BCS.S   .LAB_0B7D

    MOVEQ   #3,D1
    CMP.B   D1,D0
    BLS.S   .LAB_0B7E

.LAB_0B7D:
    MOVEQ   #0,D1
    MOVE.B  D1,-213(A5)

.LAB_0B7E:
    TST.B   -224(A5)
    BEQ.W   .LAB_0B86

    TST.B   -213(A5)
    BEQ.W   .LAB_0B86

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    EXT.L   D1
    PEA     -227(A5)
    MOVE.L  D1,-(A7)
    PEA     -212(A5)
    BSR.W   ESQIFF2_ReadSerialBytesWithXor

    PEA     -227(A5)
    PEA     1.W
    PEA     -226(A5)
    BSR.W   ESQIFF2_ReadSerialBytesWithXor

    LEA     24(A7),A7
    MOVE.B  -226(A5),D0
    TST.B   D0
    BEQ.S   .LAB_0B7F

    CLR.B   -213(A5)

.LAB_0B7F:
    PEA     1.W
    PEA     -225(A5)
    BSR.W   ESQIFF2_ReadSerialBytesToBuffer

    ADDQ.W  #8,A7
    MOVE.B  -227(A5),D0
    MOVE.B  -225(A5),D1
    CMP.B   D1,D0
    BEQ.S   .LAB_0B80

    MOVEQ   #0,D0
    MOVE.B  D0,-213(A5)

.LAB_0B80:
    TST.B   -213(A5)
    BEQ.W   .LAB_0B90

    MOVE.B  -223(A5),D0
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.S   .LAB_0B81

    MOVE.B  -212(A5),D0
    MOVEQ   #5,D1
    CMP.B   D1,D0
    BCS.S   .LAB_0B81

    MOVEQ   #10,D1
    CMP.B   D1,D0
    BHI.S   .LAB_0B81

    MOVEA.L -218(A5),A0
    BSET    #0,40(A0)

.LAB_0B81:
    CLR.L   -18(A5)

.LAB_0B82:
    MOVE.L  -18(A5),D0
    MOVEQ   #49,D1
    CMP.L   D1,D0
    BGE.W   .LAB_0B90

    MOVE.B  -223(A5),D1
    MOVEQ   #0,D2
    CMP.B   D2,D1
    BLS.S   .LAB_0B83

    MOVEA.L -222(A5),A0
    MOVE.L  D0,D2
    ADDI.L  #$fc,D2
    MOVE.B  -212(A5),0(A0,D2.L)

.LAB_0B83:
    MOVE.B  -223(A5),D1
    MOVEQ   #1,D2
    CMP.B   D2,D1
    BLS.S   .LAB_0B84

    MOVEA.L -222(A5),A0
    MOVE.L  D0,D2
    ADDI.L  #$12d,D2
    MOVE.B  -211(A5),0(A0,D2.L)

.LAB_0B84:
    MOVE.B  -223(A5),D1
    MOVEQ   #2,D2
    CMP.B   D2,D1
    BLS.S   .LAB_0B85

    MOVEA.L -222(A5),A0
    MOVE.L  D0,D0
    ADDI.L  #$15e,D0
    MOVE.B  -210(A5),0(A0,D0.L)

.LAB_0B85:
    ADDQ.L  #1,-18(A5)
    BRA.S   .LAB_0B82

.LAB_0B86:
    TST.B   -213(A5)
    BEQ.W   .LAB_0B90

    CLR.L   -26(A5)
    MOVEQ   #1,D0
    MOVE.L  D0,-18(A5)

.LAB_0B87:
    MOVE.L  -18(A5),D0
    MOVEQ   #49,D1
    CMP.L   D1,D0
    BGE.S   .LAB_0B89

    MOVE.L  D0,-(A7)
    PEA     -42(A5)
    JSR     ESQSHARED_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-22(A5)
    ADDQ.L  #1,D0
    BNE.S   .LAB_0B88

    ADDQ.L  #1,-26(A5)

.LAB_0B88:
    ADDQ.L  #1,-18(A5)
    BRA.S   .LAB_0B87

.LAB_0B89:
    MOVEQ   #0,D0
    MOVE.B  -223(A5),D0
    MOVE.L  -26(A5),D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    EXT.L   D0
    PEA     -227(A5)
    MOVE.L  D0,-(A7)
    PEA     -212(A5)
    BSR.W   ESQIFF2_ReadSerialBytesWithXor

    PEA     -227(A5)
    PEA     1.W
    PEA     -226(A5)
    BSR.W   ESQIFF2_ReadSerialBytesWithXor

    LEA     24(A7),A7
    MOVE.B  -226(A5),D0
    TST.B   D0
    BEQ.S   .LAB_0B8A

    CLR.B   -213(A5)

.LAB_0B8A:
    PEA     1.W
    PEA     -225(A5)
    BSR.W   ESQIFF2_ReadSerialBytesToBuffer

    ADDQ.W  #8,A7
    MOVE.B  -227(A5),D0
    MOVE.B  -225(A5),D1
    CMP.B   D1,D0
    BEQ.S   .LAB_0B8B

    MOVEQ   #0,D0
    MOVE.B  D0,-213(A5)

.LAB_0B8B:
    TST.B   -213(A5)
    BEQ.W   .LAB_0B90

    CLR.L   -26(A5)
    MOVEQ   #1,D0
    MOVE.L  D0,-18(A5)

.LAB_0B8C:
    MOVE.L  -18(A5),D0
    MOVEQ   #49,D1
    CMP.L   D1,D0
    BGE.W   .LAB_0B90

    MOVE.L  D0,-(A7)
    PEA     -42(A5)
    JSR     ESQSHARED_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-22(A5)
    ADDQ.L  #1,D0
    BNE.W   .LAB_0B8F

    MOVE.B  -223(A5),D0
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.S   .LAB_0B8D

    LEA     -212(A5),A0
    MOVE.L  -26(A5),D1
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    MOVEA.L -222(A5),A2
    MOVE.L  -18(A5),D2
    ADDI.L  #$fc,D2
    MOVE.B  (A1),0(A2,D2.L)
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    CMPI.B  #$5,(A1)
    BCS.S   .LAB_0B8D

    MOVEA.L A0,A1
    ADDA.L  D1,A1
    CMPI.B  #$a,(A1)
    BHI.S   .LAB_0B8D

    MOVEA.L -218(A5),A1
    BSET    #0,40(A1)

.LAB_0B8D:
    ADDQ.L  #1,-26(A5)
    MOVE.B  -223(A5),D0
    MOVEQ   #1,D1
    CMP.B   D1,D0
    BLS.S   .LAB_0B8E

    LEA     -212(A5),A0
    MOVEA.L A0,A1
    ADDA.L  -26(A5),A1
    ADDQ.L  #1,-26(A5)
    MOVEA.L -222(A5),A2
    MOVE.L  -18(A5),D1
    ADDI.L  #301,D1
    MOVE.B  (A1),0(A2,D1.L)

.LAB_0B8E:
    MOVE.B  -223(A5),D0
    MOVEQ   #2,D1
    CMP.B   D1,D0
    BLS.S   .LAB_0B8F

    LEA     -212(A5),A0
    ADDA.L  -26(A5),A0
    ADDQ.L  #1,-26(A5)
    MOVEA.L -222(A5),A1
    MOVE.L  -18(A5),D0
    ADDI.L  #$15e,D0
    MOVE.B  (A0),0(A1,D0.L)

.LAB_0B8F:
    ADDQ.L  #1,-18(A5)
    BRA.W   .LAB_0B8C

.LAB_0B90:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .LAB_0BE4

.LAB_0B91:
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ReadSerialRecordIntoBuffer

    MOVE.W  D0,ESQIFF_RecordLength
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0B93

    MOVE.W  ESQIFF_RecordLength,D0
    CMPI.W  #$130,D0
    BHI.S   .LAB_0B92

    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LADFUNC_ParseBannerEntryData(PC)

    ADDQ.W  #8,A7
    BRA.S   .LAB_0B94

.LAB_0B92:
    MOVE.W  ESQIFF_LineErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_LineErrorCount
    BRA.S   .LAB_0B94

.LAB_0B93:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0B94:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .LAB_0BE4

.processCommand_xBB_BoxOff:
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,-5(A5)
    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,ESQIFF_RecordChecksumByte
    MOVEQ   #0,D1
    MOVE.B  -5(A5),D1
    MOVEQ   #68,D2
    NOT.B   D2
    CMP.L   D2,D1
    BNE.S   .LAB_0B97

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #0,D0
    NOT.B   D0
    CMP.L   D0,D1
    BNE.S   .LAB_0B97

    TST.W   DATA_ESQ_BSS_WORD_1DF6
    BEQ.S   .LAB_0B96

    BSR.W   ESQPARS_PersistStateDataAfterCommand

    MOVEQ   #0,D0
    MOVE.W  D0,DATA_ESQ_BSS_WORD_1DF6

.LAB_0B96:
    CLR.W   DATA_WDISP_BSS_WORD_22A0
    CLR.L   -(A7)
    PEA     2.W
    JSR     ESQDISP_UpdateStatusMaskAndRefresh(PC)

    ADDQ.W  #8,A7
    BRA.S   .LAB_0B98

.LAB_0B97:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0B98:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .LAB_0BE4

.LAB_0B99:
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    PEA     6.W
    PEA     1.W
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ReadSerialRecordIntoBuffer

    LEA     12(A7),A7
    MOVE.W  D0,ESQIFF_RecordLength
    TST.W   D0
    BEQ.W   .LAB_0BE4

    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  ESQIFF_RecordLength,D1
    MOVE.L  D1,-(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D1
    MOVE.B  ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0B9A

    MOVE.W  DATA_WDISP_BSS_WORD_2299,D0
    SUBQ.W  #1,D0
    BNE.S   .LAB_0B9B

    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ParseGroupRecordAndRefresh

    ADDQ.W  #4,A7
    BRA.S   .LAB_0B9B

.LAB_0B9A:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0B9B:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .LAB_0BE4

.LAB_0B9C:
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    CLR.L   -(A7)
    PEA     1.W
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ReadSerialRecordIntoBuffer

    LEA     12(A7),A7
    MOVE.W  D0,ESQIFF_RecordLength
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .LAB_0B9D

    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  ESQIFF_RecordLength,D1
    MOVE.L  D1,-(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D1
    MOVE.B  ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0B9D

    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    JSR     ESQDISP_ParseProgramInfoCommandRecord(PC)

    ADDQ.W  #4,A7
    BRA.S   .LAB_0B9E

.LAB_0B9D:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0B9E:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .LAB_0BE4

.LAB_0B9F:
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    CLR.L   -(A7)
    PEA     1.W
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ReadSerialRecordIntoBuffer

    LEA     12(A7),A7
    MOVE.W  D0,ESQIFF_RecordLength
    TST.W   D0
    BEQ.W   .LAB_0BE4

    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  ESQIFF_RecordLength,D1
    MOVE.L  D1,-(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D1
    MOVE.B  ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0BA0

    MOVEA.L ESQIFF_RecordBufferPtr,A0
    MOVE.B  1(A0),D0
    MOVEQ   #49,D1
    CMP.B   D1,D0
    BNE.S   .LAB_0BA1

    MOVE.L  A0,-(A7)
    JSR     ESQPARS_JMPTBL_CLEANUP_ParseAlignedListingBlock(PC)

    ADDQ.W  #4,A7
    BRA.S   .LAB_0BA1

.LAB_0BA0:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BA1:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .LAB_0BE4

.LAB_0BA2:
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ReadSerialRecordIntoBuffer

    MOVE.W  D0,ESQIFF_RecordLength
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0BA4

    MOVEA.L ESQIFF_RecordBufferPtr,A0
    LEA     DATA_WDISP_BSS_LONG_2298,A1

.LAB_0BA3:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_0BA3

    BRA.S   .LAB_0BA5

.LAB_0BA4:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BA5:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .LAB_0BE4

    if includeCustomAriAssembly

.LAB_0BA5_2:
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    JSR     ESQ_PollCtrlInput

    MOVEQ   #0,D0
    LEA     76(A7),A7
    MOVE.W  SCRIPT_CTRL_STATE,D4
    MOVEQ   #0,D0
    MOVE.W  CTRL_H,D0
    MOVEQ   #0,D3
    MOVE.W  SCRIPT_CTRL_CHECKSUM,D3
    MOVEQ   #0,D1
    MOVE.W  SCRIPT_CTRL_READ_INDEX,D1
    MOVEQ   #0,D2
    LEA     CTRL_BUFFER,A3
    ADDA    D0,A3
    SUBA    #1,A3
    MOVEQ   #0,D2
    MOVE.B (A3),D2
    MOVE.L  D2,-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_CTRLHTCMAX
    PEA     -72(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)
    PEA     -72(A5)
    PEA     262.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .LAB_0BE4
    endif

.LAB_0BA6:
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    PEA     21.W
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ReadSerialBytesToBuffer

    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,ESQIFF_RecordChecksumByte
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    PEA     20.W
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0BA8

    MOVEA.L ESQIFF_RecordBufferPtr,A0
    MOVE.B  (A0),D0
    MOVEQ   #65,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_0BA7

    MOVEQ   #66,D2
    CMP.B   D2,D0
    BNE.S   .LAB_0BA8

.LAB_0BA7:
    MOVE.B  1(A0),D0
    CMP.B   D1,D0
    BCS.S   .LAB_0BA8

    MOVEQ   #74,D1
    CMP.B   D1,D0
    BCC.S   .LAB_0BA8

    MOVE.L  A0,-(A7)
    BSR.W   ESQIFF2_ApplyIncomingStatusPacket

    ADDQ.W  #4,A7
    BRA.S   .LAB_0BA9

.LAB_0BA8:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BA9:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .LAB_0BE4

.processCommand_K_Clock:
    MOVE.W  ED_DiagnosticsViewMode,D0
    SUBQ.W  #1,D0
    BEQ.W   .LAB_0BE4

    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    PEA     8.W
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ReadSerialBytesToBuffer

    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,ESQIFF_RecordChecksumByte
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    PEA     8.W
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .command_K_Increment_Data_CErrs

    ; At this point A0 is a pointer to a struct or array that
    ; matches the data received from the request.
    ; See: https://prevueguide.com/Documentation/D2400.pdf
    ; (Byte 4 and onward)

    ; Small sanity checks: check day (not over 7)
    MOVEA.L ESQIFF_RecordBufferPtr,A0 ; Pointer to all the data received.
    MOVE.B  (A0),D0     ; Byte 0: Day
    MOVEQ   #7,D1
    CMP.B   D1,D0
    BCC.S   .command_K_Increment_Data_CErrs

    ; Small sanity checks: check month (not over 12)
    MOVE.B  1(A0),D0    ; Byte 1: Month
    MOVEQ   #12,D1
    CMP.B   D1,D0
    BCC.S   .command_K_Increment_Data_CErrs

    MOVE.B  6(A0),D0    ; Byte 6: Second
    MOVEQ   #60,D1
    CMP.B   D1,D0
    BCC.S   .command_K_Increment_Data_CErrs

    MOVE.B  DATA_CTASKS_STR_1_1BC9,D0
    MOVEQ   #50,D1
    CMP.B   D1,D0
    BNE.S   .command_K_Increment_Data_CErrs

    MOVE.L  A0,-(A7)    ; Push the address of the data to the stack
    BSR.W   ESQPARS_ApplyRtcBytesAndPersist

    ADDQ.W  #4,A7
    BRA.S   .LAB_0BAC

.command_K_Increment_Data_CErrs:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BAC:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .LAB_0BE4

.LAB_0BAD:
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    CLR.L   -(A7)
    PEA     2.W
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ReadSerialRecordIntoBuffer

    MOVE.W  D0,ESQIFF_RecordLength
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0BAF

    MOVE.W  ESQIFF_RecordLength,D0
    CMPI.W  #$1f4,D0
    BHI.S   .LAB_0BAE

    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ParseLineHeadTailRecord

    ADDQ.W  #4,A7
    BRA.S   .LAB_0BB0

.LAB_0BAE:
    MOVE.W  ESQIFF_LineErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_LineErrorCount
    BRA.S   .LAB_0BB0

.LAB_0BAF:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BB0:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .LAB_0BE4

.LAB_0BB1:
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ReadSerialRecordIntoBuffer

    MOVE.W  D0,ESQIFF_RecordLength
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0BB3

    MOVE.W  ESQIFF_RecordLength,D0
    MOVEQ   #39,D1
    CMP.W   D1,D0
    BHI.S   .LAB_0BB2

    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    JSR     ESQPARS_JMPTBL_UNKNOWN_ParseDigitLabelAndDisplay(PC)

    ADDQ.W  #4,A7
    BRA.S   .LAB_0BB4

.LAB_0BB2:
    MOVE.W  ESQIFF_LineErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_LineErrorCount
    BRA.S   .LAB_0BB4

.LAB_0BB3:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BB4:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .LAB_0BE4

.LAB_0BB5:
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ReadSerialRecordIntoBuffer

    MOVE.W  D0,ESQIFF_RecordLength
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0BB7

    MOVE.W  ESQIFF_RecordLength,D0
    MOVEQ   #39,D1
    CMP.W   D1,D0
    BHI.S   .LAB_0BB6

    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    JSR     ESQPARS_JMPTBL_UNKNOWN_CopyLabelToGlobal(PC)

    ADDQ.W  #4,A7
    BRA.S   .LAB_0BB8

.LAB_0BB6:
    MOVE.W  ESQIFF_LineErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_LineErrorCount
    BRA.S   .LAB_0BB8

.LAB_0BB7:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BB8:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .LAB_0BE4

.LAB_0BB9:
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,ESQIFF_RecordChecksumByte
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #109,D0
    ADD.L   D0,D0
    CMP.L   D0,D1
    BNE.S   .LAB_0BBA

    MOVEQ   #1,D0
    MOVE.W  D0,DATA_ESQ_BSS_WORD_1DF6
    BRA.S   .LAB_0BBB

.LAB_0BBA:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BBB:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .LAB_0BE4

.processCommand_R_Reset:
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #82,D0
    NOT.B   D0
    CMP.L   D0,D1
    BNE.S   .LAB_0BBF

    MOVE.W  ESQPARS_ResetArmedFlag,D0
    SUBQ.W  #1,D0
    BNE.S   .LAB_0BC0

    MOVE.W  #21000,DATA_WDISP_BSS_LONG_2363
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  #GLOB_REF_696_400_BITMAP,4(A0)

.LAB_0BBD:
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    MOVEQ   #34,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .LAB_0BBE

    ADDQ.L  #1,D1

.LAB_0BBE:
    ASR.L   #1,D1
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    ADD.L   D0,D1
    MOVEQ   #29,D0
    ADD.L   D0,D1
    PEA     GLOB_STR_RESET_COMMAND_RECEIVED
    MOVE.L  D1,-(A7)
    PEA     40.W
    MOVE.L  A1,-(A7)
    JSR     GROUP_AW_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    BRA.S   .LAB_0BBD

.LAB_0BBF:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BC0:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .LAB_0BE4

.LAB_0BC1:
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .LAB_0BE4

.LAB_0BC2:
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #88,D0
    ADD.L   D0,D0
    CMP.L   D0,D1
    BNE.S   .LAB_0BC3

    BSR.W   ESQIFF2_ClearPrimaryEntryFlags34To39

    BRA.S   .LAB_0BC4

.LAB_0BC3:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BC4:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .LAB_0BE4

.cmdDATABinaryDL:
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    MOVEQ   #0,D0
    MOVE.W  D0,ESQPARS_ResetArmedFlag
    MOVE.L  D0,D5
    MOVEQ   #1,D0
    CMP.L   DATA_WDISP_BSS_LONG_21BD,D0
    BNE.W   .LAB_0BE4

    MOVEQ   #61,D1
    CMP.B   -5(A5),D1
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    JSR     ESQPARS_JMPTBL_DISKIO2_HandleInteractiveFileTransfer(PC)

    ADDQ.W  #4,A7
    BRA.W   .LAB_0BE4

.processCommand_D_Diagnostics:
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    PEA     256.W
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ReadSerialBytesToBuffer

    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,ESQIFF_RecordChecksumByte
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    PEA     256.W
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BEQ.S   .LAB_0BC7

    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BC7:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .LAB_0BE4

.LAB_0BC8:
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_UNKNOWN_VerifyChecksumAndParseRecord(PC)

    ADDQ.W  #4,A7
    BRA.W   .LAB_0BE4

.LAB_0BC9:
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_UNKNOWN_VerifyChecksumAndParseList(PC)

    ADDQ.W  #4,A7
    BRA.W   .LAB_0BE4

.processCommand_V_Version:
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ReadSerialRecordIntoBuffer

    MOVE.W  D0,ESQIFF_RecordLength
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0BCC

    MOVE.W  ESQIFF_RecordLength,D0
    CMPI.W  #$8b,D0
    BHI.S   .LAB_0BCB

    BSR.W   ESQIFF2_ShowVersionMismatchOverlay

    BRA.S   .LAB_0BCD

.LAB_0BCB:
    MOVE.W  ESQIFF_LineErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_LineErrorCount
    BRA.S   .LAB_0BCD

.LAB_0BCC:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BCD:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .LAB_0BE4

.LAB_0BCE:
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ReadSerialRecordIntoBuffer

    MOVE.W  D0,ESQIFF_RecordLength
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVEQ   #0,D1
    MOVE.W  ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0BCF

    MOVE.W  ESQIFF_RecordLength,D0
    MOVEQ   #80,D1
    CMP.W   D1,D0
    BHI.S   .LAB_0BCF

    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    JSR     ESQPARS_JMPTBL_PARSEINI_HandleFontCommand(PC)

    ADDQ.W  #4,A7
    BRA.S   .LAB_0BD0

.LAB_0BCF:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BD0:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .LAB_0BE4

.LAB_0BD1:
    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.L  D0,D6
    MOVE.B  -5(A5),D0
    MOVE.B  D0,-6(A5)
    EOR.B   D6,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    MOVE.B  D0,-6(A5)
    BSR.W   ESQPARS_ReadLengthWordWithChecksumXor

    ADDQ.W  #4,A7
    MOVE.W  ESQIFF_RecordLength,D1
    MOVE.B  D0,-6(A5)
    CMPI.W  #$2328,D1
    BCS.S   .LAB_0BD2

    MOVE.W  ESQIFF_LineErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_LineErrorCount
    BRA.W   .LAB_0BE4

.LAB_0BD2:
    MOVE.W  ESQIFF_RecordLength,D0
    MOVE.L  D0,D1
    SUBQ.W  #1,D1
    MOVE.W  D1,ESQIFF_RecordLength
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ReadSerialBytesToBuffer

    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,ESQIFF_RecordChecksumByte
    MOVEQ   #0,D0
    MOVE.B  -6(A5),D0
    MOVEQ   #0,D1
    MOVE.W  ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     16(A7),A7
    MOVE.L  D0,D7
    MOVE.B  ESQIFF_RecordChecksumByte,D0
    CMP.B   D0,D7
    BNE.S   .LAB_0BD3

    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    MOVEQ   #0,D0
    MOVE.W  ESQIFF_RecordLength,D0
    MOVE.L  D0,-(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    JSR     ESQPARS_JMPTBL_DISKIO_ParseConfigBuffer(PC)

    JSR     ESQPARS_JMPTBL_DISKIO_SaveConfigToFileHandle(PC)

    ADDQ.W  #8,A7
    BRA.S   .LAB_0BD4

.LAB_0BD3:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BD4:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .LAB_0BE4

.LAB_0BD5:
    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.L  D0,D6
    MOVE.B  -5(A5),D0
    MOVE.B  D0,-6(A5)
    EOR.B   D6,D0
    MOVE.B  D0,-6(A5)
    MOVEQ   #49,D0
    CMP.B   D0,D6
    BNE.W   .LAB_0BD9

    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVEA.L ESQIFF_RecordBufferPtr,A0
    MOVE.B  D0,(A0)
    LEA     1(A0),A1
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    BSR.W   ESQIFF2_ReadSerialRecordIntoBuffer

    LEA     12(A7),A7
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_RecordLength
    MOVEQ   #0,D1
    MOVE.B  -6(A5),D1
    MOVEQ   #0,D2
    MOVE.W  D0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D1,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D1
    MOVE.B  ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0BD8

    MOVEA.L ESQIFF_RecordBufferPtr,A0
    MOVE.B  (A0),D0
    MOVE.B  TEXTDISP_PrimaryGroupCode,D1
    CMP.B   D1,D0
    BNE.S   .LAB_0BD6

    PEA     LOCAVAIL_PrimaryFilterState
    MOVE.L  A0,-(A7)
    JSR     LOCAVAIL_ParseFilterStateFromBuffer(PC)

    ADDQ.W  #8,A7
    BRA.S   .LAB_0BD7

.LAB_0BD6:
    MOVE.B  TEXTDISP_SecondaryGroupCode,D1
    CMP.B   D1,D0
    BNE.S   .LAB_0BD7

    PEA     LOCAVAIL_SecondaryFilterState
    MOVE.L  A0,-(A7)
    JSR     LOCAVAIL_ParseFilterStateFromBuffer(PC)

    ADDQ.W  #8,A7

.LAB_0BD7:
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    BRA.W   .LAB_0BE4

.LAB_0BD8:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs
    BRA.W   .LAB_0BE4

.LAB_0BD9:
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  D0,-(A7)
    PEA     GLOB_STR_23
    JSR     GROUP_AS_JMPTBL_UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.W   .LAB_0BDC

    PEA     2.W
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ReadSerialSizedTextRecord

    ADDQ.W  #8,A7
    MOVE.W  D0,ESQIFF_RecordLength
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .LAB_0BDB

    MOVEQ   #0,D1
    MOVE.B  -6(A5),D1
    MOVEQ   #0,D2
    MOVE.W  D0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D1,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D1
    MOVE.B  ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0BDA

    MOVE.L  D6,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_DST_HandleBannerCommand32_33(PC)

    ADDQ.W  #8,A7
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    BRA.W   .LAB_0BE4

.LAB_0BDA:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs
    BRA.W   .LAB_0BE4

.LAB_0BDB:
    MOVE.W  ESQIFF_LineErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_LineErrorCount
    BRA.W   .LAB_0BE4

.LAB_0BDC:
    MOVEQ   #53,D0
    CMP.B   D0,D6
    BNE.S   .LAB_0BDE

    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ReadSerialRecordIntoBuffer

    MOVE.W  D0,ESQIFF_RecordLength
    MOVEQ   #0,D0
    MOVE.B  -6(A5),D0
    MOVEQ   #0,D1
    MOVE.W  ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0BDD

    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    JSR     ESQPARS_JMPTBL_P_TYPE_ParseAndStoreTypeRecord(PC)

    ADDQ.W  #4,A7
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    BRA.W   .LAB_0BE4

.LAB_0BDD:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs
    BRA.W   .LAB_0BE4

.LAB_0BDE:
    MOVEQ   #54,D0
    CMP.B   D0,D6
    BNE.S   .LAB_0BE0

    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ReadSerialRecordIntoBuffer

    MOVE.W  D0,ESQIFF_RecordLength
    MOVEQ   #0,D0
    MOVE.B  -6(A5),D0
    MOVEQ   #0,D1
    MOVE.W  ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0BDF

    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    JSR     GCOMMAND_ParseCommandOptions(PC)

    ADDQ.W  #4,A7
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    BRA.W   .LAB_0BE4

.LAB_0BDF:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs
    BRA.W   .LAB_0BE4

.LAB_0BE0:
    MOVEQ   #55,D0
    CMP.B   D0,D6
    BNE.S   .LAB_0BE2

    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ReadSerialRecordIntoBuffer

    MOVE.W  D0,ESQIFF_RecordLength
    MOVEQ   #0,D0
    MOVE.B  -6(A5),D0
    MOVEQ   #0,D1
    MOVE.W  ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0BE1

    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    JSR     GCOMMAND_ParseCommandString(PC)

    ADDQ.W  #4,A7
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    BRA.W   .LAB_0BE4

.LAB_0BE1:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs
    BRA.S   .LAB_0BE4

.LAB_0BE2:
    MOVEQ   #56,D0
    CMP.B   D0,D6
    BNE.S   .LAB_0BE4

    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ReadSerialRecordIntoBuffer

    MOVE.W  D0,ESQIFF_RecordLength
    MOVEQ   #0,D0
    MOVE.B  -6(A5),D0
    MOVEQ   #0,D1
    MOVE.W  ESQIFF_RecordLength,D1
    MOVE.L  D1,(A7)
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  ESQIFF_RecordChecksumByte,D1
    CMP.L   D1,D0
    BNE.S   .LAB_0BE3

    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    JSR     GCOMMAND_ParsePPVCommand(PC)

    ADDQ.W  #4,A7
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    BRA.S   .LAB_0BE4

.LAB_0BE3:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.LAB_0BE4:
    MOVEQ   #0,D0
    MOVE.W  D0,ESQPARS_Preamble55SeenFlag
    MOVE.W  D0,ESQPARS_CommandPreambleArmedFlag

.LAB_0BE5:
    MOVEM.L (A7)+,D2/D5-D7/A2
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQPARS_ReadLengthWordWithChecksumXor   (Routine at ESQPARS_ReadLengthWordWithChecksumXor)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1/D5/D6/D7
; CALLS:
;   ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte, ESQFUNC_WaitForClockChangeAndServiceUi
; READS:
;   ESQIFF_RecordLength
; WRITES:
;   ESQIFF_RecordLength
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_ReadLengthWordWithChecksumXor:
    MOVEM.L D5-D7,-(A7)
    MOVE.B  19(A7),D7
    MOVEQ   #0,D0
    MOVE.W  D0,ESQIFF_RecordLength
    MOVE.L  D0,D5

.lab_0BE7:
    MOVEQ   #2,D0
    CMP.W   D0,D5
    BGE.S   ESQPARS_ReadLengthWordWithChecksumXor_Return

    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.L  D0,D6
    EOR.B   D6,D7
    MOVEQ   #0,D0
    MOVE.W  ESQIFF_RecordLength,D0
    ASL.L   #8,D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    ADD.L   D1,D0
    MOVE.W  D0,ESQIFF_RecordLength
    ADDQ.W  #1,D5
    BRA.S   .lab_0BE7

;------------------------------------------------------------------------------
; FUNC: ESQPARS_ReadLengthWordWithChecksumXor_Return   (Routine at ESQPARS_ReadLengthWordWithChecksumXor_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D5
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
ESQPARS_ReadLengthWordWithChecksumXor_Return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D5-D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQPARS_PersistStateDataAfterCommand   (Routine at ESQPARS_PersistStateDataAfterCommand)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7
; CALLS:
;   ESQPARS_JMPTBL_DATETIME_SavePairToFile, ESQPARS_JMPTBL_DISKIO2_FlushDataFilesIfNeeded, ESQPARS_JMPTBL_P_TYPE_WritePromoIdDataFile, LOCAVAIL_SaveAvailabilityDataFile, LADFUNC_SaveTextAdsToFile
; READS:
;   DST_BannerWindowPrimary, LOCAVAIL_PrimaryFilterState, LOCAVAIL_SecondaryFilterState
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_PersistStateDataAfterCommand:
    JSR     ESQPARS_JMPTBL_DISKIO2_FlushDataFilesIfNeeded(PC)

    JSR     LADFUNC_SaveTextAdsToFile(PC)

    PEA     DST_BannerWindowPrimary
    JSR     ESQPARS_JMPTBL_DATETIME_SavePairToFile(PC)

    PEA     LOCAVAIL_SecondaryFilterState
    PEA     LOCAVAIL_PrimaryFilterState
    JSR     LOCAVAIL_SaveAvailabilityDataFile(PC)

    JSR     ESQPARS_JMPTBL_P_TYPE_WritePromoIdDataFile(PC)

    LEA     12(A7),A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_DISKIO2_FlushDataFilesIfNeeded   (Routine at ESQPARS_JMPTBL_DISKIO2_FlushDataFilesIfNeeded)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DISKIO2_FlushDataFilesIfNeeded
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_DISKIO2_FlushDataFilesIfNeeded:
    JMP     DISKIO2_FlushDataFilesIfNeeded

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache   (Routine at ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   NEWGRID_RebuildIndexCache
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache:
    JMP     NEWGRID_RebuildIndexCache

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_DATETIME_SavePairToFile   (Routine at ESQPARS_JMPTBL_DATETIME_SavePairToFile)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DATETIME_SavePairToFile
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_DATETIME_SavePairToFile:
    JMP     DATETIME_SavePairToFile

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_UNKNOWN_VerifyChecksumAndParseList   (Routine at ESQPARS_JMPTBL_UNKNOWN_VerifyChecksumAndParseList)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   UNKNOWN_VerifyChecksumAndParseList
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_UNKNOWN_VerifyChecksumAndParseList:
    JMP     UNKNOWN_VerifyChecksumAndParseList

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_P_TYPE_ParseAndStoreTypeRecord   (Routine at ESQPARS_JMPTBL_P_TYPE_ParseAndStoreTypeRecord)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   P_TYPE_ParseAndStoreTypeRecord
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_P_TYPE_ParseAndStoreTypeRecord:
    JMP     P_TYPE_ParseAndStoreTypeRecord

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_UNKNOWN_CopyLabelToGlobal   (Routine at ESQPARS_JMPTBL_UNKNOWN_CopyLabelToGlobal)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   UNKNOWN_CopyLabelToGlobal
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_UNKNOWN_CopyLabelToGlobal:
    JMP     UNKNOWN_CopyLabelToGlobal

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_DST_HandleBannerCommand32_33   (Routine at ESQPARS_JMPTBL_DST_HandleBannerCommand32_33)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DST_HandleBannerCommand32_33
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_DST_HandleBannerCommand32_33:
    JMP     DST_HandleBannerCommand32_33

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_ESQ_SeedMinuteEventThresholds   (Routine at ESQPARS_JMPTBL_ESQ_SeedMinuteEventThresholds)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_SeedMinuteEventThresholds
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_ESQ_SeedMinuteEventThresholds:
    JMP     ESQ_SeedMinuteEventThresholds

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_PARSEINI_HandleFontCommand   (Routine at ESQPARS_JMPTBL_PARSEINI_HandleFontCommand)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   PARSEINI_HandleFontCommand
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_PARSEINI_HandleFontCommand:
    JMP     PARSEINI_HandleFontCommand

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_TEXTDISP_ApplySourceConfigAllEntries   (Routine at ESQPARS_JMPTBL_TEXTDISP_ApplySourceConfigAllEntries)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   TEXTDISP_ApplySourceConfigAllEntries
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_TEXTDISP_ApplySourceConfigAllEntries:
    JMP     TEXTDISP_ApplySourceConfigAllEntries

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000

;!======

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex   (Routine at ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_PlaneMaskForIndex
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex:
    JMP     BRUSH_PlaneMaskForIndex

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_SCRIPT_ResetCtrlContextAndClearStatusLine   (JumpStub_SCRIPT_ResetCtrlContextAndClearStatusLine)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   SCRIPT_ResetCtrlContextAndClearStatusLine
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to SCRIPT_ResetCtrlContextAndClearStatusLine.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_SCRIPT_ResetCtrlContextAndClearStatusLine:
    JMP     SCRIPT_ResetCtrlContextAndClearStatusLine

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_PARSEINI_WriteRtcFromGlobals   (Routine at ESQPARS_JMPTBL_PARSEINI_WriteRtcFromGlobals)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   PARSEINI_WriteRtcFromGlobals
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_PARSEINI_WriteRtcFromGlobals:
    JMP     PARSEINI_WriteRtcFromGlobals

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile   (Routine at ESQPARS_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   LOCAVAIL_SaveAvailabilityDataFile
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile:
    JMP     LOCAVAIL_SaveAvailabilityDataFile

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition   (Routine at ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DISPLIB_DisplayTextAtPosition
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition:
    JMP     DISPLIB_DisplayTextAtPosition

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_LADFUNC_SaveTextAdsToFile   (Routine at ESQPARS_JMPTBL_LADFUNC_SaveTextAdsToFile)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   LADFUNC_SaveTextAdsToFile
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_LADFUNC_SaveTextAdsToFile:
    JMP     LADFUNC_SaveTextAdsToFile

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt   (Routine at ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   PARSE_ReadSignedLongSkipClass3_Alt
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt:
    JMP     PARSE_ReadSignedLongSkipClass3_Alt

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_DISKIO2_HandleInteractiveFileTransfer   (Routine at ESQPARS_JMPTBL_DISKIO2_HandleInteractiveFileTransfer)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   DISKIO2_HandleInteractiveFileTransfer
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_DISKIO2_HandleInteractiveFileTransfer:
    JMP     DISKIO2_HandleInteractiveFileTransfer

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000

;!======

;!======

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_P_TYPE_WritePromoIdDataFile   (Routine at ESQPARS_JMPTBL_P_TYPE_WritePromoIdDataFile)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   P_TYPE_WritePromoIdDataFile
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_P_TYPE_WritePromoIdDataFile:
    JMP     P_TYPE_WritePromoIdDataFile

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_COI_FreeEntryResources   (Routine at ESQPARS_JMPTBL_COI_FreeEntryResources)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   COI_FreeEntryResources
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_COI_FreeEntryResources:
    JMP     COI_FreeEntryResources

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_DST_UpdateBannerQueue   (Routine at ESQPARS_JMPTBL_DST_UpdateBannerQueue)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DST_UpdateBannerQueue
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_DST_UpdateBannerQueue:
    JMP     DST_UpdateBannerQueue

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_UNKNOWN_VerifyChecksumAndParseRecord   (Routine at ESQPARS_JMPTBL_UNKNOWN_VerifyChecksumAndParseRecord)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   UNKNOWN_VerifyChecksumAndParseRecord
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_UNKNOWN_VerifyChecksumAndParseRecord:
    JMP     UNKNOWN_VerifyChecksumAndParseRecord

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_UNKNOWN_ParseDigitLabelAndDisplay   (Routine at ESQPARS_JMPTBL_UNKNOWN_ParseDigitLabelAndDisplay)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   UNKNOWN_ParseDigitLabelAndDisplay
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_UNKNOWN_ParseDigitLabelAndDisplay:
    JMP     UNKNOWN_ParseDigitLabelAndDisplay

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_DISKIO_ParseConfigBuffer   (Routine at ESQPARS_JMPTBL_DISKIO_ParseConfigBuffer)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DISKIO_ParseConfigBuffer
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_DISKIO_ParseConfigBuffer:
    JMP     DISKIO_ParseConfigBuffer

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_CLEANUP_ParseAlignedListingBlock   (Routine at ESQPARS_JMPTBL_CLEANUP_ParseAlignedListingBlock)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   CLEANUP_ParseAlignedListingBlock
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_CLEANUP_ParseAlignedListingBlock:
    JMP     CLEANUP_ParseAlignedListingBlock

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte   (Routine at ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   SCRIPT_ReadSerialRbfByte
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte:
    JMP     SCRIPT_ReadSerialRbfByte

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte   (Routine at ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   ESQ_GenerateXorChecksumByte
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte:
    JMP     ESQ_GenerateXorChecksumByte

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000

;!======

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_DST_RefreshBannerBuffer   (Routine at ESQPARS_JMPTBL_DST_RefreshBannerBuffer)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DST_RefreshBannerBuffer
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_DST_RefreshBannerBuffer:
    JMP     DST_RefreshBannerBuffer

;------------------------------------------------------------------------------
; FUNC: ESQPARS_JMPTBL_DISKIO_SaveConfigToFileHandle   (Routine at ESQPARS_JMPTBL_DISKIO_SaveConfigToFileHandle)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DISKIO_SaveConfigToFileHandle
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQPARS_JMPTBL_DISKIO_SaveConfigToFileHandle:
    JMP     DISKIO_SaveConfigToFileHandle
