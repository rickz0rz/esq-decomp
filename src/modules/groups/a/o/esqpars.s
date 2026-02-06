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
;   CTRL_BUFFER, CTRL_H, DATACErrs, GLOB_REF_696_400_BITMAP, GLOB_REF_RASTPORT_1, GLOB_STR_23, GLOB_STR_RESET_COMMAND_RECEIVED, DATA_CTASKS_STR_1_1BC9, DATA_ESQ_BSS_WORD_1DF6, DATA_WDISP_BSS_LONG_21BD, DATA_WDISP_BSS_LONG_2298, DATA_WDISP_BSS_WORD_2299, DATA_WDISP_BSS_WORD_22A0, ED_DiagnosticsViewMode, ESQIFF_RecordBufferPtr, ESQIFF_RecordChecksumByte, ESQIFF_RecordLength, ESQIFF_ParseAttemptCount, ESQIFF_LineErrorCount, ESQPARS_Preamble55SeenFlag, ESQPARS_CommandPreambleArmedFlag, ESQPARS_ResetArmedFlag, LOCAVAIL_PrimaryFilterState, LOCAVAIL_SecondaryFilterState, SCRIPT_CTRL_CHECKSUM, SCRIPT_CTRL_READ_INDEX, SCRIPT_CTRL_STATE, TEXTDISP_PrimaryGroupCode, TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_PrimaryEntryPtrTable, TEXTDISP_PrimaryTitlePtrTable, TEXTDISP_SecondaryGroupCode, TEXTDISP_SecondaryGroupPresentFlag, TEXTDISP_SecondaryGroupEntryCount, TEXTDISP_SecondaryEntryPtrTable, TEXTDISP_SecondaryTitlePtrTable
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
    BNE.S   .preamble_dispatch_command_byte

    MOVEQ   #$55,D1         ; Copy 0x55 ('U') into D1
    CMP.B   D1,D0           ; Compare that byte to D0
    BNE.S   .preamble_check_double_sync       ; and jump to .preamble_check_double_sync if it's not equa.

    MOVEQ   #1,D1           ; Copy 1 into D1...
    MOVE.W  D1,ESQPARS_Preamble55SeenFlag     ; and then 0x0001 into ESQPARS_Preamble55SeenFlag
    MOVEQ   #0,D2           ; Copy 0 into D2...
    MOVE.W  D2,ESQPARS_CommandPreambleArmedFlag     ; and then 0x0000 into ESQPARS_CommandPreambleArmedFlag
    BRA.W   .cmdbyte_return       ; and branch to .cmdbyte_return

.preamble_check_double_sync:
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #$55,D2
    ADD.L   D2,D2
    CMP.L   D2,D1
    BNE.S   .preamble_reset_state

    MOVE.W  ESQPARS_Preamble55SeenFlag,D1
    SUBQ.W  #1,D1
    BNE.S   .preamble_reset_state

    MOVEQ   #0,D1
    MOVE.W  D1,ESQPARS_Preamble55SeenFlag
    MOVEQ   #1,D2
    MOVE.W  D2,ESQPARS_CommandPreambleArmedFlag
    BRA.W   .cmdbyte_return

.preamble_reset_state:
    MOVEQ   #0,D1
    MOVE.W  D1,ESQPARS_Preamble55SeenFlag
    MOVE.W  D1,ESQPARS_CommandPreambleArmedFlag
    BRA.W   .cmdbyte_return

.preamble_dispatch_command_byte:
    SUBQ.W  #1,D1
    BNE.W   .cmdTableDATA

    MOVE.W  DATA_WDISP_BSS_WORD_22A0,D1
    BNE.W   .cmdTableDATA

    MOVEQ   #65,D1
    CMP.B   D1,D0
    BNE.W   .cmd_initial_w_upper

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
    BNE.S   .cmd_a_checksum_error

    MOVE.W  ESQIFF_RecordLength,D0
    MOVEQ   #16,D1
    CMP.W   D1,D0
    BHI.S   .cmd_a_record_too_long

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

.cmd_a_record_too_long:
    MOVE.W  ESQIFF_LineErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_LineErrorCount
    BRA.S   .clearValues

;!======

; Increment the number of DATACErrs encountered
.cmd_a_checksum_error:
    MOVE.W  DATACErrs,D0    ; Move DATACErrs to D0
    ADDQ.W  #1,D0           ; Add 1 to D0
    MOVE.W  D0,DATACErrs    ; Move D0 back to DATACErrs
    BRA.S   .clearValues    ; Clear the values

.cmd_initial_w_upper:
    MOVEQ   #87,D1
    CMP.B   D1,D0
    BNE.S   .cmd_initial_w_lower

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    JSR     ESQPARS_JMPTBL_UNKNOWN_VerifyChecksumAndParseRecord(PC)

    ADDQ.W  #4,A7
    BRA.S   .clearValues

.cmd_initial_w_lower:
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
    BRA.W   .cmdbyte_return

.cmdTableDATA:
    ; https://prevueguide.com/Documentation/D2400.pdf
    MOVE.W  ESQPARS_CommandPreambleArmedFlag,D0
    SUBQ.W  #1,D0
    BNE.W   .cmdbyte_return

    MOVE.W  DATA_WDISP_BSS_WORD_22A0,D0
    SUBQ.W  #1,D0
    BNE.W   .cmdbyte_return

    MOVEQ   #0,D0       ; Move 0 into D0 to clear it out
    MOVE.B  -5(A5),D0   ; Copy the byte at -5(A5) which is the byte from serial to D0

    SUBI.W  #$21,D0   ; Subtract x21/33 from D0
    BEQ.W   .cmd_bang_begin   ; Does D0 equal zero (exactly)? Means D0 was 33 or '!'

    SUBQ.W  #4,D0       ; Subtract 4 more so x25/37
    BEQ.W   .cmd_percent_begin   ; Does D0 equal zero now? This is mode '%'

    SUBI.W  #$18,D0   ; Subtract x18/24 so x3D/61
    BEQ.W   .cmdDATABinaryDL ; Does D0 equal zero now? This is mode '='

    SUBQ.W  #6,D0       ; Subtract x6/6 so 67
    BEQ.W   .cmd_c_group_record   ; Same as above... this time mode 'C'

    SUBQ.W  #1,D0       ; Subtract 1 so 68
    BEQ.W   .processCommand_D_Diagnostics   ; Mode 'D' (diagnostic command)

    SUBQ.W  #1,D0
    BEQ.W   .cmd_e_copy_string   ; 'E'

    SUBQ.W  #1,D0
    BEQ.W   .cmd_f_status_packet   ; 'F'

    SUBQ.W  #2,D0
    BEQ.W   .cmdDATABinaryDL ; 'H'

    SUBQ.W  #1,D0
    BEQ.W   .cmd_i_parse_digit_label ; 'I'

    SUBQ.W  #2,D0
    BEQ.W   .processCommand_K_Clock ; 'K'

    SUBQ.W  #1,D0
    BEQ.W   .cmd_l_or_t_banner_entry ; 'L'

    SUBQ.W  #1,D0
    BEQ.W   .cmd_m_ack ; 'M'

    SUBQ.W  #2,D0
    BEQ.W   .cmd_o_clear_primary_flags ; 'O'

    SUBQ.W  #1,D0
    BEQ.W   .cmd_p_compact_entry ; 'P'

    SUBQ.W  #2,D0
    BEQ.W   .processCommand_R_Reset ; 'R'

    SUBQ.W  #4,D0
    BEQ.W   .processCommand_V_Version ; 'V'

    SUBQ.W  #1,D0
    BEQ.W   .cmd_upper_w_verify_record ; 'W'

    SUBI.W  #12,D0
    BEQ.W   .cmd_c_lower_program_info ; 'c'

    SUBQ.W  #3,D0
    BEQ.W   .cmd_f_lower_config_record ; 'f'

    SUBQ.W  #1,D0
    BEQ.W   .cmd_g_filter_or_banner ; 'g'

    SUBQ.W  #1,D0
    BEQ.W   .cmdDATABinaryDL ; 'h'

    SUBQ.W  #1,D0
    BEQ.W   .cmd_i_lower_copy_label ; 'i'

    SUBQ.W  #1,D0
    BEQ.W   .cmd_j_line_head_tail ; 'j'

    SUBQ.W  #6,D0
    BEQ.W   .cmd_p_lower_begin ; 'p'

    SUBQ.W  #4,D0
    BEQ.W   .cmd_l_or_t_banner_entry ; 't'

    SUBQ.W  #2,D0
    BEQ.W   .cmd_v_lower_aligned_listing ; 'v'

    SUBQ.W  #1,D0
    BEQ.W   .cmd_lower_w_verify_list ; 'w'

    SUBQ.W  #1,D0
    BEQ.W   .cmd_x_font_command ; 'x'

    SUBI.W  #$43,D0
    BEQ.W   .processCommand_xBB_BoxOff ; xBB (Box off)

    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_bang_begin:
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
    BCS.S   .cmd_bang_reject

    MOVE.B  -8(A5),D1
    MOVEQ   #48,D2
    CMP.B   D2,D1
    BHI.S   .cmd_bang_reject

    CMP.B   D0,D1
    BCS.S   .cmd_bang_reject

    MOVEQ   #0,D0
    MOVE.B  TEXTDISP_PrimaryGroupCode,D0
    MOVE.L  -14(A5),D1
    CMP.L   D1,D0
    BEQ.S   .cmd_bang_read_title_key

    MOVEQ   #0,D0
    MOVE.B  TEXTDISP_SecondaryGroupCode,D0

    CMP.L   D0,D1
    BEQ.S   .cmd_bang_read_title_key

.cmd_bang_reject:
    CLR.B   -62(A5)
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_bang_read_title_key:
    CLR.L   -22(A5)
    PEA     -71(A5)
    PEA     1.W
    PEA     -61(A5)
    BSR.W   ESQIFF2_ReadSerialBytesWithXor

    LEA     12(A7),A7

.cmd_bang_collect_title_loop:
    TST.B   -61(A5)
    BEQ.S   .cmd_bang_terminate_title

    MOVE.B  -61(A5),D0
    MOVEQ   #18,D1
    CMP.B   D1,D0
    BEQ.S   .cmd_bang_terminate_title

    MOVEQ   #32,D1
    CMP.B   D1,D0
    BEQ.S   .cmd_bang_terminate_title

    MOVE.L  -22(A5),D1
    MOVEQ   #6,D2
    CMP.L   D2,D1
    BGE.S   .cmd_bang_terminate_title

    ADDQ.L  #1,-22(A5)
    MOVE.B  D0,-41(A5,D1.L)
    PEA     -71(A5)
    PEA     1.W
    PEA     -61(A5)
    BSR.W   ESQIFF2_ReadSerialBytesWithXor

    LEA     12(A7),A7
    BRA.S   .cmd_bang_collect_title_loop

.cmd_bang_terminate_title:
    MOVE.L  -22(A5),D0
    CLR.B   -41(A5,D0.L)

.cmd_bang_skip_to_nul_loop:
    TST.B   -61(A5)
    BEQ.S   .cmd_bang_verify_xor

    PEA     -71(A5)
    PEA     1.W
    PEA     -61(A5)
    BSR.W   ESQIFF2_ReadSerialBytesWithXor

    LEA     12(A7),A7
    BRA.S   .cmd_bang_skip_to_nul_loop

.cmd_bang_verify_xor:
    PEA     1.W
    PEA     -31(A5)
    BSR.W   ESQIFF2_ReadSerialBytesToBuffer

    ADDQ.W  #8,A7
    MOVE.B  -71(A5),D0
    MOVE.B  -31(A5),D1
    CMP.B   D1,D0
    BEQ.S   .cmd_bang_verify_xor_ok

    MOVEQ   #0,D0
    MOVE.B  D0,-62(A5)
    BRA.S   .cmd_bang_after_verify

.cmd_bang_verify_xor_ok:
    MOVEQ   #1,D0
    MOVE.B  D0,-62(A5)

.cmd_bang_after_verify:
    SUBQ.B  #1,D0
    BNE.W   .cmdbyte_clear_preamble_and_finish

    CLR.B   -62(A5)
    MOVEQ   #89,D0
    CMP.B   -7(A5),D0
    BNE.S   .cmd_bang_normalize_y_group

    MOVEQ   #1,D0
    MOVE.B  #$30,-8(A5)
    MOVE.B  D0,-7(A5)

.cmd_bang_normalize_y_group:
    MOVEQ   #0,D0
    MOVE.B  TEXTDISP_SecondaryGroupCode,D0
    MOVE.L  -14(A5),D1
    CMP.L   D1,D0
    BNE.S   .cmd_bang_try_primary_group

    MOVE.B  TEXTDISP_SecondaryGroupPresentFlag,D0
    SUBQ.B  #1,D0
    BNE.S   .cmd_bang_try_primary_group

    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D0
    MOVEQ   #2,D2
    MOVE.L  D2,-30(A5)
    MOVE.L  D0,-18(A5)
    BRA.S   .cmd_bang_prepare_entry_scan

.cmd_bang_try_primary_group:
    MOVEQ   #0,D0
    MOVE.B  TEXTDISP_PrimaryGroupCode,D0
    CMP.L   D0,D1
    BNE.W   .cmdbyte_clear_preamble_and_finish

    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    MOVEQ   #1,D1
    MOVE.L  D1,-30(A5)
    MOVE.L  D0,-18(A5)

.cmd_bang_prepare_entry_scan:
    CLR.L   -26(A5)

.cmd_bang_find_entry_loop:
    MOVE.L  -26(A5),D0
    CMP.L   -18(A5),D0
    BGE.S   .cmd_bang_entry_scan_done

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

.cmd_bang_compare_title_loop:
    MOVE.B  (A0)+,D1
    CMP.B   (A1)+,D1
    BNE.S   .cmd_bang_next_entry

    TST.B   D1
    BNE.S   .cmd_bang_compare_title_loop

    BNE.S   .cmd_bang_next_entry

    MOVE.B  #$1,-62(A5)
    BRA.S   .cmd_bang_entry_scan_done

.cmd_bang_next_entry:
    ADDQ.L  #1,-26(A5)
    BRA.S   .cmd_bang_find_entry_loop

.cmd_bang_entry_scan_done:
    MOVEQ   #1,D0
    CMP.B   -62(A5),D0
    BNE.W   .cmdbyte_clear_preamble_and_finish

    MOVE.B  -7(A5),D0
    MOVEQ   #1,D1
    CMP.B   D1,D0
    BNE.S   .cmd_bang_after_optional_flag_clear

    MOVEQ   #48,D1
    CMP.B   -8(A5),D1
    BNE.S   .cmd_bang_after_optional_flag_clear

    MOVEQ   #0,D1
    MOVEA.L -66(A5),A0
    MOVE.B  40(A0),D1
    ANDI.W  #$ff7f,D1
    MOVE.B  D1,40(A0)

.cmd_bang_after_optional_flag_clear:
    MOVE.B  D0,-9(A5)

.cmd_bang_apply_slot_range_loop:
    MOVE.B  -9(A5),D0
    CMP.B   -8(A5),D0
    BHI.W   .cmdbyte_clear_preamble_and_finish

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
    BRA.S   .cmd_bang_apply_slot_range_loop

.cmd_p_compact_entry:
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
    BNE.S   .cmd_p_checksum_error

    MOVE.W  ESQIFF_RecordLength,D0
    CMPI.W  #$1ff,D0
    BHI.S   .cmd_p_record_too_long

    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    JSR     ESQSHARED_ParseCompactEntryRecord(PC)

    ADDQ.W  #4,A7
    BRA.S   .cmd_p_finish

.cmd_p_record_too_long:
    MOVE.W  ESQIFF_LineErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_LineErrorCount
    BRA.S   .cmd_p_finish

.cmd_p_checksum_error:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.cmd_p_finish:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_p_lower_begin:
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

.cmd_p_lower_read_key_loop:
    MOVE.B  -62(A5),D0
    MOVE.L  -18(A5),D1
    MOVE.B  D0,-36(A5,D1.L)
    MOVEQ   #18,D2
    CMP.B   D2,D0
    BEQ.S   .cmd_p_lower_key_ready

    MOVEQ   #8,D0
    CMP.L   D0,D1
    BGE.S   .cmd_p_lower_key_ready

    PEA     -227(A5)
    PEA     1.W
    PEA     -62(A5)
    BSR.W   ESQIFF2_ReadSerialBytesWithXor

    LEA     12(A7),A7
    ADDQ.L  #1,-18(A5)
    BRA.S   .cmd_p_lower_read_key_loop

.cmd_p_lower_key_ready:
    MOVE.L  -18(A5),D0
    CLR.B   -36(A5,D0.L)
    MOVEQ   #0,D0
    MOVE.B  TEXTDISP_SecondaryGroupCode,D0
    MOVE.L  -10(A5),D1
    CMP.L   D1,D0
    BNE.S   .cmd_p_lower_try_primary_group

    MOVE.B  TEXTDISP_SecondaryGroupPresentFlag,D0
    SUBQ.B  #1,D0
    BNE.S   .cmd_p_lower_try_primary_group

    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D0
    MOVE.L  D0,-14(A5)
    BRA.S   .cmd_p_lower_read_bitmap6

.cmd_p_lower_try_primary_group:
    MOVEQ   #0,D0
    MOVE.B  TEXTDISP_PrimaryGroupCode,D0
    CMP.L   D0,D1
    BNE.W   .cmdbyte_clear_preamble_and_finish

    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.L  D0,-14(A5)

.cmd_p_lower_read_bitmap6:
    PEA     -227(A5)
    PEA     6.W
    PEA     -62(A5)
    BSR.W   ESQIFF2_ReadSerialBytesWithXor

    LEA     12(A7),A7
    CLR.L   -18(A5)

.cmd_p_lower_validate_bitmap_loop:
    MOVE.L  -18(A5),D0
    MOVEQ   #6,D1
    CMP.L   D1,D0
    BGE.S   .cmd_p_lower_after_bitmap_validation

    TST.B   -62(A5,D0.L)
    BEQ.S   .cmd_p_lower_next_bitmap_byte

    CLR.B   -224(A5)

.cmd_p_lower_next_bitmap_byte:
    ADDQ.L  #1,-18(A5)
    BRA.S   .cmd_p_lower_validate_bitmap_loop

.cmd_p_lower_after_bitmap_validation:
    PEA     -62(A5)
    PEA     -42(A5)
    JSR     ESQSHARED_JMPTBL_ESQ_ReverseBitsIn6Bytes(PC)

    ADDQ.W  #8,A7
    CLR.L   -26(A5)

.cmd_p_lower_find_title_loop:
    MOVE.L  -26(A5),D0
    CMP.L   -14(A5),D0
    BGE.S   .cmd_p_lower_read_payload_width

    MOVEQ   #0,D1
    MOVE.B  TEXTDISP_SecondaryGroupCode,D1
    MOVE.L  -10(A5),D2
    CMP.L   D1,D2
    BNE.S   .cmd_p_lower_use_primary_tables

    MOVE.B  TEXTDISP_SecondaryGroupPresentFlag,D1
    SUBQ.B  #1,D1
    BNE.S   .cmd_p_lower_use_primary_tables

    ASL.L   #2,D0
    LEA     TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-218(A5)
    LEA     TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-222(A5)
    BRA.S   .cmd_p_lower_compare_title_start

.cmd_p_lower_use_primary_tables:
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-218(A5)
    LEA     TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-222(A5)

.cmd_p_lower_compare_title_start:
    LEA     -36(A5),A0
    MOVEA.L -222(A5),A1

.cmd_p_lower_compare_title_loop:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.S   .cmd_p_lower_next_title

    TST.B   D0
    BNE.S   .cmd_p_lower_compare_title_loop

    BNE.S   .cmd_p_lower_next_title

    MOVE.B  #$1,-213(A5)
    BRA.S   .cmd_p_lower_read_payload_width

.cmd_p_lower_next_title:
    ADDQ.L  #1,-26(A5)
    BRA.S   .cmd_p_lower_find_title_loop

.cmd_p_lower_read_payload_width:
    PEA     -227(A5)
    PEA     1.W
    PEA     -223(A5)
    BSR.W   ESQIFF2_ReadSerialBytesWithXor

    LEA     12(A7),A7
    MOVE.B  -223(A5),D0
    MOVEQ   #1,D1
    CMP.B   D1,D0
    BCS.S   .cmd_p_lower_invalid_payload_width

    MOVEQ   #3,D1
    CMP.B   D1,D0
    BLS.S   .cmd_p_lower_apply_payload_mode

.cmd_p_lower_invalid_payload_width:
    MOVEQ   #0,D1
    MOVE.B  D1,-213(A5)

.cmd_p_lower_apply_payload_mode:
    TST.B   -224(A5)
    BEQ.W   .cmd_p_lower_sparse_path

    TST.B   -213(A5)
    BEQ.W   .cmd_p_lower_sparse_path

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
    BEQ.S   .cmd_p_lower_after_payload_trailer

    CLR.B   -213(A5)

.cmd_p_lower_after_payload_trailer:
    PEA     1.W
    PEA     -225(A5)
    BSR.W   ESQIFF2_ReadSerialBytesToBuffer

    ADDQ.W  #8,A7
    MOVE.B  -227(A5),D0
    MOVE.B  -225(A5),D1
    CMP.B   D1,D0
    BEQ.S   .cmd_p_lower_after_checksum_byte

    MOVEQ   #0,D0
    MOVE.B  D0,-213(A5)

.cmd_p_lower_after_checksum_byte:
    TST.B   -213(A5)
    BEQ.W   .cmd_p_lower_finish

    MOVE.B  -223(A5),D0
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.S   .cmd_p_lower_after_optional_highlight_flag

    MOVE.B  -212(A5),D0
    MOVEQ   #5,D1
    CMP.B   D1,D0
    BCS.S   .cmd_p_lower_after_optional_highlight_flag

    MOVEQ   #10,D1
    CMP.B   D1,D0
    BHI.S   .cmd_p_lower_after_optional_highlight_flag

    MOVEA.L -218(A5),A0
    BSET    #0,40(A0)

.cmd_p_lower_after_optional_highlight_flag:
    CLR.L   -18(A5)

.cmd_p_lower_fill_all_rows_loop:
    MOVE.L  -18(A5),D0
    MOVEQ   #49,D1
    CMP.L   D1,D0
    BGE.W   .cmd_p_lower_finish

    MOVE.B  -223(A5),D1
    MOVEQ   #0,D2
    CMP.B   D2,D1
    BLS.S   .cmd_p_lower_after_col0

    MOVEA.L -222(A5),A0
    MOVE.L  D0,D2
    ADDI.L  #$fc,D2
    MOVE.B  -212(A5),0(A0,D2.L)

.cmd_p_lower_after_col0:
    MOVE.B  -223(A5),D1
    MOVEQ   #1,D2
    CMP.B   D2,D1
    BLS.S   .cmd_p_lower_after_col1

    MOVEA.L -222(A5),A0
    MOVE.L  D0,D2
    ADDI.L  #$12d,D2
    MOVE.B  -211(A5),0(A0,D2.L)

.cmd_p_lower_after_col1:
    MOVE.B  -223(A5),D1
    MOVEQ   #2,D2
    CMP.B   D2,D1
    BLS.S   .cmd_p_lower_next_row_all

    MOVEA.L -222(A5),A0
    MOVE.L  D0,D0
    ADDI.L  #$15e,D0
    MOVE.B  -210(A5),0(A0,D0.L)

.cmd_p_lower_next_row_all:
    ADDQ.L  #1,-18(A5)
    BRA.S   .cmd_p_lower_fill_all_rows_loop

.cmd_p_lower_sparse_path:
    TST.B   -213(A5)
    BEQ.W   .cmd_p_lower_finish

    CLR.L   -26(A5)
    MOVEQ   #1,D0
    MOVE.L  D0,-18(A5)

.cmd_p_lower_count_marked_rows_loop:
    MOVE.L  -18(A5),D0
    MOVEQ   #49,D1
    CMP.L   D1,D0
    BGE.S   .cmd_p_lower_read_sparse_payload

    MOVE.L  D0,-(A7)
    PEA     -42(A5)
    JSR     ESQSHARED_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-22(A5)
    ADDQ.L  #1,D0
    BNE.S   .cmd_p_lower_next_bit_index

    ADDQ.L  #1,-26(A5)

.cmd_p_lower_next_bit_index:
    ADDQ.L  #1,-18(A5)
    BRA.S   .cmd_p_lower_count_marked_rows_loop

.cmd_p_lower_read_sparse_payload:
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
    BEQ.S   .cmd_p_lower_after_sparse_trailer

    CLR.B   -213(A5)

.cmd_p_lower_after_sparse_trailer:
    PEA     1.W
    PEA     -225(A5)
    BSR.W   ESQIFF2_ReadSerialBytesToBuffer

    ADDQ.W  #8,A7
    MOVE.B  -227(A5),D0
    MOVE.B  -225(A5),D1
    CMP.B   D1,D0
    BEQ.S   .cmd_p_lower_after_sparse_checksum_byte

    MOVEQ   #0,D0
    MOVE.B  D0,-213(A5)

.cmd_p_lower_after_sparse_checksum_byte:
    TST.B   -213(A5)
    BEQ.W   .cmd_p_lower_finish

    CLR.L   -26(A5)
    MOVEQ   #1,D0
    MOVE.L  D0,-18(A5)

.cmd_p_lower_apply_sparse_rows_loop:
    MOVE.L  -18(A5),D0
    MOVEQ   #49,D1
    CMP.L   D1,D0
    BGE.W   .cmd_p_lower_finish

    MOVE.L  D0,-(A7)
    PEA     -42(A5)
    JSR     ESQSHARED_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-22(A5)
    ADDQ.L  #1,D0
    BNE.W   .cmd_p_lower_next_sparse_row

    MOVE.B  -223(A5),D0
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.S   .cmd_p_lower_after_sparse_col0

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
    BCS.S   .cmd_p_lower_after_sparse_col0

    MOVEA.L A0,A1
    ADDA.L  D1,A1
    CMPI.B  #$a,(A1)
    BHI.S   .cmd_p_lower_after_sparse_col0

    MOVEA.L -218(A5),A1
    BSET    #0,40(A1)

.cmd_p_lower_after_sparse_col0:
    ADDQ.L  #1,-26(A5)
    MOVE.B  -223(A5),D0
    MOVEQ   #1,D1
    CMP.B   D1,D0
    BLS.S   .cmd_p_lower_after_sparse_col1

    LEA     -212(A5),A0
    MOVEA.L A0,A1
    ADDA.L  -26(A5),A1
    ADDQ.L  #1,-26(A5)
    MOVEA.L -222(A5),A2
    MOVE.L  -18(A5),D1
    ADDI.L  #301,D1
    MOVE.B  (A1),0(A2,D1.L)

.cmd_p_lower_after_sparse_col1:
    MOVE.B  -223(A5),D0
    MOVEQ   #2,D1
    CMP.B   D1,D0
    BLS.S   .cmd_p_lower_next_sparse_row

    LEA     -212(A5),A0
    ADDA.L  -26(A5),A0
    ADDQ.L  #1,-26(A5)
    MOVEA.L -222(A5),A1
    MOVE.L  -18(A5),D0
    ADDI.L  #$15e,D0
    MOVE.B  (A0),0(A1,D0.L)

.cmd_p_lower_next_sparse_row:
    ADDQ.L  #1,-18(A5)
    BRA.W   .cmd_p_lower_apply_sparse_rows_loop

.cmd_p_lower_finish:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_l_or_t_banner_entry:
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
    BNE.S   .cmd_l_or_t_checksum_error

    MOVE.W  ESQIFF_RecordLength,D0
    CMPI.W  #$130,D0
    BHI.S   .cmd_l_or_t_record_too_long

    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LADFUNC_ParseBannerEntryData(PC)

    ADDQ.W  #8,A7
    BRA.S   .cmd_l_or_t_finish

.cmd_l_or_t_record_too_long:
    MOVE.W  ESQIFF_LineErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_LineErrorCount
    BRA.S   .cmd_l_or_t_finish

.cmd_l_or_t_checksum_error:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.cmd_l_or_t_finish:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

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
    BNE.S   .cmd_boxoff_checksum_error

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #0,D0
    NOT.B   D0
    CMP.L   D0,D1
    BNE.S   .cmd_boxoff_checksum_error

    TST.W   DATA_ESQ_BSS_WORD_1DF6
    BEQ.S   .cmd_boxoff_apply

    BSR.W   ESQPARS_PersistStateDataAfterCommand

    MOVEQ   #0,D0
    MOVE.W  D0,DATA_ESQ_BSS_WORD_1DF6

.cmd_boxoff_apply:
    CLR.W   DATA_WDISP_BSS_WORD_22A0
    CLR.L   -(A7)
    PEA     2.W
    JSR     ESQDISP_UpdateStatusMaskAndRefresh(PC)

    ADDQ.W  #8,A7
    BRA.S   .cmd_boxoff_finish

.cmd_boxoff_checksum_error:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.cmd_boxoff_finish:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_c_group_record:
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
    BEQ.W   .cmdbyte_clear_preamble_and_finish

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
    BNE.S   .cmd_c_checksum_error

    MOVE.W  DATA_WDISP_BSS_WORD_2299,D0
    SUBQ.W  #1,D0
    BNE.S   .cmd_c_finish

    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ParseGroupRecordAndRefresh

    ADDQ.W  #4,A7
    BRA.S   .cmd_c_finish

.cmd_c_checksum_error:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.cmd_c_finish:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_c_lower_program_info:
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
    BLS.S   .cmd_c_lower_invalid_record

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
    BNE.S   .cmd_c_lower_invalid_record

    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    JSR     ESQDISP_ParseProgramInfoCommandRecord(PC)

    ADDQ.W  #4,A7
    BRA.S   .cmd_c_lower_finish

.cmd_c_lower_invalid_record:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.cmd_c_lower_finish:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_v_lower_aligned_listing:
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
    BEQ.W   .cmdbyte_clear_preamble_and_finish

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
    BNE.S   .cmd_v_lower_checksum_error

    MOVEA.L ESQIFF_RecordBufferPtr,A0
    MOVE.B  1(A0),D0
    MOVEQ   #49,D1
    CMP.B   D1,D0
    BNE.S   .cmd_v_lower_finish

    MOVE.L  A0,-(A7)
    JSR     ESQPARS_JMPTBL_CLEANUP_ParseAlignedListingBlock(PC)

    ADDQ.W  #4,A7
    BRA.S   .cmd_v_lower_finish

.cmd_v_lower_checksum_error:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.cmd_v_lower_finish:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_e_copy_string:
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
    BNE.S   .cmd_e_checksum_error

    MOVEA.L ESQIFF_RecordBufferPtr,A0
    LEA     DATA_WDISP_BSS_LONG_2298,A1

.cmd_e_copy_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .cmd_e_copy_loop

    BRA.S   .cmd_e_finish

.cmd_e_checksum_error:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.cmd_e_finish:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

    if includeCustomAriAssembly

.cmd_e_debug_status_dump:
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
    BRA.W   .cmdbyte_clear_preamble_and_finish
    endif

.cmd_f_status_packet:
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
    BNE.S   .cmd_f_invalid_packet

    MOVEA.L ESQIFF_RecordBufferPtr,A0
    MOVE.B  (A0),D0
    MOVEQ   #65,D1
    CMP.B   D1,D0
    BEQ.S   .cmd_f_validate_packet_header

    MOVEQ   #66,D2
    CMP.B   D2,D0
    BNE.S   .cmd_f_invalid_packet

.cmd_f_validate_packet_header:
    MOVE.B  1(A0),D0
    CMP.B   D1,D0
    BCS.S   .cmd_f_invalid_packet

    MOVEQ   #74,D1
    CMP.B   D1,D0
    BCC.S   .cmd_f_invalid_packet

    MOVE.L  A0,-(A7)
    BSR.W   ESQIFF2_ApplyIncomingStatusPacket

    ADDQ.W  #4,A7
    BRA.S   .cmd_f_finish

.cmd_f_invalid_packet:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.cmd_f_finish:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.processCommand_K_Clock:
    MOVE.W  ED_DiagnosticsViewMode,D0
    SUBQ.W  #1,D0
    BEQ.W   .cmdbyte_clear_preamble_and_finish

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
    BRA.S   .cmd_k_finish

.command_K_Increment_Data_CErrs:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.cmd_k_finish:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_j_line_head_tail:
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
    BNE.S   .cmd_j_checksum_error

    MOVE.W  ESQIFF_RecordLength,D0
    CMPI.W  #$1f4,D0
    BHI.S   .cmd_j_record_too_long

    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ParseLineHeadTailRecord

    ADDQ.W  #4,A7
    BRA.S   .cmd_j_finish

.cmd_j_record_too_long:
    MOVE.W  ESQIFF_LineErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_LineErrorCount
    BRA.S   .cmd_j_finish

.cmd_j_checksum_error:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.cmd_j_finish:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_i_parse_digit_label:
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
    BNE.S   .cmd_i_checksum_error

    MOVE.W  ESQIFF_RecordLength,D0
    MOVEQ   #39,D1
    CMP.W   D1,D0
    BHI.S   .cmd_i_record_too_long

    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    JSR     ESQPARS_JMPTBL_UNKNOWN_ParseDigitLabelAndDisplay(PC)

    ADDQ.W  #4,A7
    BRA.S   .cmd_i_finish

.cmd_i_record_too_long:
    MOVE.W  ESQIFF_LineErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_LineErrorCount
    BRA.S   .cmd_i_finish

.cmd_i_checksum_error:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.cmd_i_finish:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_i_lower_copy_label:
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
    BNE.S   .cmd_i_lower_checksum_error

    MOVE.W  ESQIFF_RecordLength,D0
    MOVEQ   #39,D1
    CMP.W   D1,D0
    BHI.S   .cmd_i_lower_record_too_long

    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    JSR     ESQPARS_JMPTBL_UNKNOWN_CopyLabelToGlobal(PC)

    ADDQ.W  #4,A7
    BRA.S   .cmd_i_lower_finish

.cmd_i_lower_record_too_long:
    MOVE.W  ESQIFF_LineErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_LineErrorCount
    BRA.S   .cmd_i_lower_finish

.cmd_i_lower_checksum_error:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.cmd_i_lower_finish:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_percent_begin:
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
    BNE.S   .cmd_percent_checksum_error

    MOVEQ   #1,D0
    MOVE.W  D0,DATA_ESQ_BSS_WORD_1DF6
    BRA.S   .cmd_percent_finish

.cmd_percent_checksum_error:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.cmd_percent_finish:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

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
    BNE.S   .cmd_r_checksum_error

    MOVE.W  ESQPARS_ResetArmedFlag,D0
    SUBQ.W  #1,D0
    BNE.S   .cmd_r_finish

    MOVE.W  #21000,DATA_WDISP_BSS_LONG_2363
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  #GLOB_REF_696_400_BITMAP,4(A0)

.cmd_r_reset_overlay_loop:
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    MOVEQ   #34,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .cmd_r_reset_overlay_center_adjust

    ADDQ.L  #1,D1

.cmd_r_reset_overlay_center_adjust:
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
    BRA.S   .cmd_r_reset_overlay_loop

.cmd_r_checksum_error:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.cmd_r_finish:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_m_ack:
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_o_clear_primary_flags:
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
    BNE.S   .cmd_o_checksum_error

    BSR.W   ESQIFF2_ClearPrimaryEntryFlags34To39

    BRA.S   .cmd_o_finish

.cmd_o_checksum_error:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.cmd_o_finish:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmdDATABinaryDL:
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    MOVEQ   #0,D0
    MOVE.W  D0,ESQPARS_ResetArmedFlag
    MOVE.L  D0,D5
    MOVEQ   #1,D0
    CMP.L   DATA_WDISP_BSS_LONG_21BD,D0
    BNE.W   .cmdbyte_clear_preamble_and_finish

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
    BRA.W   .cmdbyte_clear_preamble_and_finish

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
    BEQ.S   .cmd_d_finish

    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.cmd_d_finish:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_upper_w_verify_record:
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_UNKNOWN_VerifyChecksumAndParseRecord(PC)

    ADDQ.W  #4,A7
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_lower_w_verify_list:
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_UNKNOWN_VerifyChecksumAndParseList(PC)

    ADDQ.W  #4,A7
    BRA.W   .cmdbyte_clear_preamble_and_finish

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
    BNE.S   .cmd_v_checksum_error

    MOVE.W  ESQIFF_RecordLength,D0
    CMPI.W  #$8b,D0
    BHI.S   .cmd_v_record_too_long

    BSR.W   ESQIFF2_ShowVersionMismatchOverlay

    BRA.S   .cmd_v_finish

.cmd_v_record_too_long:
    MOVE.W  ESQIFF_LineErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_LineErrorCount
    BRA.S   .cmd_v_finish

.cmd_v_checksum_error:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.cmd_v_finish:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_x_font_command:
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
    BNE.S   .cmd_x_invalid_record

    MOVE.W  ESQIFF_RecordLength,D0
    MOVEQ   #80,D1
    CMP.W   D1,D0
    BHI.S   .cmd_x_invalid_record

    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    JSR     ESQPARS_JMPTBL_PARSEINI_HandleFontCommand(PC)

    ADDQ.W  #4,A7
    BRA.S   .cmd_x_finish

.cmd_x_invalid_record:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.cmd_x_finish:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_f_lower_config_record:
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
    BCS.S   .cmd_f_lower_read_config_payload

    MOVE.W  ESQIFF_LineErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_LineErrorCount
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_f_lower_read_config_payload:
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
    BNE.S   .cmd_f_lower_checksum_error

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
    BRA.S   .cmd_f_lower_finish

.cmd_f_lower_checksum_error:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.cmd_f_lower_finish:
    CLR.W   ESQPARS_ResetArmedFlag
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_g_filter_or_banner:
    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.L  D0,D6
    MOVE.B  -5(A5),D0
    MOVE.B  D0,-6(A5)
    EOR.B   D6,D0
    MOVE.B  D0,-6(A5)
    MOVEQ   #49,D0
    CMP.B   D0,D6
    BNE.W   .cmd_g_dispatch_banner_subcommand

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
    BNE.S   .cmd_g_type1_checksum_error

    MOVEA.L ESQIFF_RecordBufferPtr,A0
    MOVE.B  (A0),D0
    MOVE.B  TEXTDISP_PrimaryGroupCode,D1
    CMP.B   D1,D0
    BNE.S   .cmd_g_apply_secondary_filter

    PEA     LOCAVAIL_PrimaryFilterState
    MOVE.L  A0,-(A7)
    JSR     LOCAVAIL_ParseFilterStateFromBuffer(PC)

    ADDQ.W  #8,A7
    BRA.S   .cmd_g_filter_finish

.cmd_g_apply_secondary_filter:
    MOVE.B  TEXTDISP_SecondaryGroupCode,D1
    CMP.B   D1,D0
    BNE.S   .cmd_g_filter_finish

    PEA     LOCAVAIL_SecondaryFilterState
    MOVE.L  A0,-(A7)
    JSR     LOCAVAIL_ParseFilterStateFromBuffer(PC)

    ADDQ.W  #8,A7

.cmd_g_filter_finish:
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_g_type1_checksum_error:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_g_dispatch_banner_subcommand:
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  D0,-(A7)
    PEA     GLOB_STR_23
    JSR     GROUP_AS_JMPTBL_UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.W   .cmd_g_maybe_type_or_options

    PEA     2.W
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    BSR.W   ESQIFF2_ReadSerialSizedTextRecord

    ADDQ.W  #8,A7
    MOVE.W  D0,ESQIFF_RecordLength
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .cmd_g_banner_line_error

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
    BNE.S   .cmd_g_banner_checksum_error

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
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_g_banner_checksum_error:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_g_banner_line_error:
    MOVE.W  ESQIFF_LineErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_LineErrorCount
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_g_maybe_type_or_options:
    MOVEQ   #53,D0
    CMP.B   D0,D6
    BNE.S   .cmd_g_maybe_cmd_options

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
    BNE.S   .cmd_g_type5_checksum_error

    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    JSR     ESQPARS_JMPTBL_P_TYPE_ParseAndStoreTypeRecord(PC)

    ADDQ.W  #4,A7
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_g_type5_checksum_error:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_g_maybe_cmd_options:
    MOVEQ   #54,D0
    CMP.B   D0,D6
    BNE.S   .cmd_g_maybe_cmd_string

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
    BNE.S   .cmd_g_type6_checksum_error

    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    JSR     GCOMMAND_ParseCommandOptions(PC)

    ADDQ.W  #4,A7
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_g_type6_checksum_error:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_g_maybe_cmd_string:
    MOVEQ   #55,D0
    CMP.B   D0,D6
    BNE.S   .cmd_g_maybe_ppv

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
    BNE.S   .cmd_g_type7_checksum_error

    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    JSR     GCOMMAND_ParseCommandString(PC)

    ADDQ.W  #4,A7
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    BRA.W   .cmdbyte_clear_preamble_and_finish

.cmd_g_type7_checksum_error:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs
    BRA.S   .cmdbyte_clear_preamble_and_finish

.cmd_g_maybe_ppv:
    MOVEQ   #56,D0
    CMP.B   D0,D6
    BNE.S   .cmdbyte_clear_preamble_and_finish

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
    BNE.S   .cmd_g_type8_checksum_error

    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    JSR     GCOMMAND_ParsePPVCommand(PC)

    ADDQ.W  #4,A7
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,ESQIFF_ParseAttemptCount
    BRA.S   .cmdbyte_clear_preamble_and_finish

.cmd_g_type8_checksum_error:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.cmdbyte_clear_preamble_and_finish:
    MOVEQ   #0,D0
    MOVE.W  D0,ESQPARS_Preamble55SeenFlag
    MOVE.W  D0,ESQPARS_CommandPreambleArmedFlag

.cmdbyte_return:
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
