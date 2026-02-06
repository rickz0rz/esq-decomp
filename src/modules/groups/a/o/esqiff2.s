; Rename this file to its proper purpose.

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ApplyIncomingStatusPacket   (Routine at ESQIFF2_ApplyIncomingStatusPacket)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A7/D0/D1/D2/D6/D7
; CALLS:
;   ED_DrawDiagnosticModeText, ESQDISP_DrawStatusBanner, ESQPARS_JMPTBL_DST_RefreshBannerBuffer, ESQPARS_JMPTBL_DST_UpdateBannerQueue, ESQPARS_JMPTBL_ESQ_SeedMinuteEventThresholds
; READS:
;   GLOB_STR_SATELLITE_DELIVERED_SCROLL_SPEED, DATA_ESQ_STR_B_1DC8, DATA_ESQ_CONST_BYTE_1DCF, DATA_ESQ_CONST_BYTE_1DD0, DATA_ESQ_STR_6_1DD1, ED_DiagVinModeChar, LOCAVAIL_FilterModeFlag, DST_BannerWindowPrimary, DATA_WDISP_BSS_LONG_21E2, ED_DiagnosticsScreenActive, SCRIPT_RuntimeMode
; WRITES:
;   DATA_ESQ_CONST_BYTE_1DCF, DATA_ESQ_CONST_BYTE_1DD0, DATA_ESQ_STR_6_1DD1, ESQPARS2_StateIndex, DATA_SCRIPT_BSS_LONG_2125
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF2_ApplyIncomingStatusPacket:
    MOVEM.L D2/D6-D7/A3,-(A7)
    MOVEA.L 20(A7),A3

    MOVE.B  ED_DiagVinModeChar,D6
    MOVEQ   #0,D7

.lab_0AB9:
    MOVEQ   #20,D0
    CMP.W   D0,D7
    BGE.S   .lab_0ABA

    LEA     DATA_ESQ_STR_B_1DC8,A0
    ADDA.W  D7,A0
    MOVE.B  0(A3,D7.W),(A0)
    ADDQ.W  #1,D7
    BRA.S   .lab_0AB9

.lab_0ABA:
    TST.L   LOCAVAIL_FilterModeFlag
    BNE.S   .branch

    MOVE.B  ED_DiagVinModeChar,D0
    CMP.B   D0,D6
    BEQ.S   .branch

    MOVE.W  SCRIPT_RuntimeMode,D0
    BEQ.S   .branch

    MOVEQ   #1,D0
    MOVE.L  D0,DATA_SCRIPT_BSS_LONG_2125

.branch:
    MOVE.B  DATA_ESQ_STR_6_1DD1,D0
    MOVEQ   #49,D1
    CMP.B   D1,D0
    BCS.S   .branch_1

    MOVEQ   #72,D1
    CMP.B   D1,D0
    BLS.S   .branch_2

.branch_1:
    MOVE.B  #$36,DATA_ESQ_STR_6_1DD1

.branch_2:
    PEA     DST_BannerWindowPrimary
    JSR     ESQPARS_JMPTBL_DST_UpdateBannerQueue(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BNE.S   .branch_3

    JSR     ESQPARS_JMPTBL_DST_RefreshBannerBuffer(PC)

.branch_3:
    PEA     1.W
    JSR     ESQDISP_DrawStatusBanner(PC)

    ADDQ.W  #4,A7
    MOVE.B  DATA_ESQ_CONST_BYTE_1DCF,D0
    MOVEQ   #9,D1
    CMP.B   D1,D0
    BHI.S   .branch_4

    MOVEQ   #0,D2
    CMP.B   D2,D0
    BHI.S   .branch_5

.branch_4:
    MOVEQ   #1,D2
    MOVE.B  D2,DATA_ESQ_CONST_BYTE_1DCF

.branch_5:
    MOVE.B  DATA_ESQ_CONST_BYTE_1DD0,D0
    CMP.B   D1,D0
    BHI.S   .branch_6

    MOVEQ   #0,D1
    CMP.B   D1,D0
    BHI.S   .branch_7

.branch_6:
    MOVEQ   #1,D1
    MOVE.B  D1,DATA_ESQ_CONST_BYTE_1DD0

.branch_7:
    MOVEQ   #0,D0
    MOVE.B  DATA_ESQ_CONST_BYTE_1DCF,D0
    MOVEQ   #0,D1
    MOVE.B  DATA_ESQ_CONST_BYTE_1DD0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_SeedMinuteEventThresholds(PC)

    ADDQ.W  #8,A7
    TST.W   ED_DiagnosticsScreenActive
    BEQ.S   .branch_8

    JSR     ED_DrawDiagnosticModeText(PC)

.branch_8:
    TST.L   DATA_WDISP_BSS_LONG_21E2
    BNE.S   ESQIFF2_ApplyIncomingStatusPacket_Return

    MOVEQ   #0,D0
    MOVE.B  GLOB_STR_SATELLITE_DELIVERED_SCROLL_SPEED,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.L  D0,D7
    MOVEQ   #1,D0
    CMP.W   D0,D7
    BLT.S   .branch_9

    MOVEQ   #8,D1
    CMP.W   D1,D7
    BGT.S   .branch_9

    MOVE.W  D7,ESQPARS2_StateIndex
    BRA.S   ESQIFF2_ApplyIncomingStatusPacket_Return

.branch_9:
    MOVE.W  #4,ESQPARS2_StateIndex

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ApplyIncomingStatusPacket_Return   (Routine at ESQIFF2_ApplyIncomingStatusPacket_Return)
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
;   DATA_WDISP_BSS_WORD_2299
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF2_ApplyIncomingStatusPacket_Return:
    MOVE.W  #1,DATA_WDISP_BSS_WORD_2299
    MOVEM.L (A7)+,D2/D6-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ValidateAsciiNumericByte   (Routine at ESQIFF2_ValidateAsciiNumericByte)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1/D7
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
ESQIFF2_ValidateAsciiNumericByte:
    MOVE.L  D7,-(A7)
    MOVE.B  11(A7),D7

    MOVEQ   #1,D0
    CMP.B   D0,D7
    BLT.S   .return

    MOVEQ   #48,D1
    CMP.B   D1,D7
    BGT.S   .return

    MOVE.L  D7,D0

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ClearLineHeadTailByMode   (Routine at ESQIFF2_ClearLineHeadTailByMode)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D7
; CALLS:
;   ESQPARS_ReplaceOwnedString
; READS:
;   ESQIFF_PrimaryLineHeadPtr, ESQIFF_PrimaryLineTailPtr, ESQIFF_SecondaryLineHeadPtr, ESQIFF_SecondaryLineTailPtr
; WRITES:
;   ESQIFF_PrimaryLineHeadPtr, ESQIFF_PrimaryLineTailPtr, ESQIFF_SecondaryLineHeadPtr, ESQIFF_SecondaryLineTailPtr
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF2_ClearLineHeadTailByMode:
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7
    MOVEQ   #2,D0
    CMP.W   D0,D7
    BNE.S   .lab_0AC9

    MOVE.L  ESQIFF_SecondaryLineHeadPtr,-(A7)
    CLR.L   -(A7)
    BSR.W   ESQPARS_ReplaceOwnedString

    MOVE.L  D0,ESQIFF_SecondaryLineHeadPtr
    MOVE.L  ESQIFF_SecondaryLineTailPtr,(A7)
    CLR.L   -(A7)
    BSR.W   ESQPARS_ReplaceOwnedString

    LEA     12(A7),A7
    MOVE.L  D0,ESQIFF_SecondaryLineTailPtr
    BRA.S   .lab_0ACA

.lab_0AC9:
    MOVE.L  ESQIFF_PrimaryLineHeadPtr,-(A7)
    CLR.L   -(A7)
    BSR.W   ESQPARS_ReplaceOwnedString

    MOVE.L  D0,ESQIFF_PrimaryLineHeadPtr
    MOVE.L  ESQIFF_PrimaryLineTailPtr,(A7)
    CLR.L   -(A7)
    BSR.W   ESQPARS_ReplaceOwnedString

    LEA     12(A7),A7
    MOVE.L  D0,ESQIFF_PrimaryLineTailPtr

.lab_0ACA:
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ParseLineHeadTailRecord   (Routine at ESQIFF2_ParseLineHeadTailRecord)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A7/D0/D1/D6/D7
; CALLS:
;   ESQIFF2_ClearLineHeadTailByMode, ESQPARS_ReplaceOwnedString
; READS:
;   ESQIFF2_ParseLineHeadTailRecord_Return, ESQIFF_PrimaryLineHeadPtr, ESQIFF_PrimaryLineTailPtr, ESQIFF_SecondaryLineHeadPtr, ESQIFF_SecondaryLineTailPtr, TEXTDISP_SecondaryGroupCode, TEXTDISP_PrimaryGroupCode, ESQIFF_RecordLength, lab_0AD1
; WRITES:
;   ESQIFF_PrimaryLineHeadPtr, ESQIFF_PrimaryLineTailPtr, ESQIFF_SecondaryLineHeadPtr, ESQIFF_SecondaryLineTailPtr, DATA_WDISP_BSS_WORD_228F
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF2_ParseLineHeadTailRecord:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    MOVE.L  D0,D7
    MOVE.B  TEXTDISP_PrimaryGroupCode,D0
    CMP.B   D0,D7
    BNE.W   .lab_0AD1

    PEA     1.W
    BSR.W   ESQIFF2_ClearLineHeadTailByMode

    ADDQ.W  #4,A7
    MOVEQ   #18,D0
    CMP.B   1(A3),D0
    BNE.S   .lab_0ACD

    SUBA.L  A0,A0
    MOVE.L  A0,ESQIFF_PrimaryLineHeadPtr
    MOVEQ   #0,D1
    MOVE.W  ESQIFF_RecordLength,D1
    CMP.B   -1(A3,D1.L),D0
    BNE.S   .lab_0ACC

    MOVE.L  A0,ESQIFF_PrimaryLineTailPtr
    BRA.W   ESQIFF2_ParseLineHeadTailRecord_Return

.lab_0ACC:
    LEA     2(A3),A0
    MOVE.L  ESQIFF_PrimaryLineTailPtr,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   ESQPARS_ReplaceOwnedString

    ADDQ.W  #8,A7
    MOVE.L  D0,ESQIFF_PrimaryLineTailPtr
    BRA.W   ESQIFF2_ParseLineHeadTailRecord_Return

.lab_0ACD:
    MOVEQ   #0,D0
    MOVE.W  ESQIFF_RecordLength,D0
    MOVEQ   #18,D1
    CMP.B   -1(A3,D0.L),D1
    BNE.S   .lab_0ACE

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    CLR.B   -1(A3,D1.L)
    LEA     1(A3),A0
    MOVE.L  ESQIFF_PrimaryLineHeadPtr,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   ESQPARS_ReplaceOwnedString

    ADDQ.W  #8,A7
    MOVE.L  D0,ESQIFF_PrimaryLineHeadPtr
    CLR.L   ESQIFF_PrimaryLineTailPtr
    BRA.W   ESQIFF2_ParseLineHeadTailRecord_Return

.lab_0ACE:
    MOVEQ   #3,D6

.lab_0ACF:
    MOVEQ   #18,D0
    CMP.B   0(A3,D6.W),D0
    BEQ.S   .lab_0AD0

    MOVEQ   #103,D0
    CMP.W   D0,D6
    BGE.S   .lab_0AD0

    ADDQ.W  #1,D6
    BRA.S   .lab_0ACF

.lab_0AD0:
    CLR.B   0(A3,D6.W)
    LEA     1(A3),A0
    MOVE.L  ESQIFF_PrimaryLineHeadPtr,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   ESQPARS_ReplaceOwnedString

    MOVE.L  D0,ESQIFF_PrimaryLineHeadPtr
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     1(A0),A1
    MOVE.L  ESQIFF_PrimaryLineTailPtr,(A7)
    MOVE.L  A1,-(A7)
    BSR.W   ESQPARS_ReplaceOwnedString

    LEA     12(A7),A7
    MOVE.L  D0,ESQIFF_PrimaryLineTailPtr
    BRA.W   ESQIFF2_ParseLineHeadTailRecord_Return

.lab_0AD1:
    MOVE.B  TEXTDISP_SecondaryGroupCode,D0
    CMP.B   D0,D7
    BNE.W   ESQIFF2_ParseLineHeadTailRecord_Return

    PEA     2.W
    BSR.W   ESQIFF2_ClearLineHeadTailByMode

    ADDQ.W  #4,A7
    MOVE.W  #1,DATA_WDISP_BSS_WORD_228F
    MOVEQ   #18,D0
    CMP.B   1(A3),D0
    BNE.S   .branch_1

    SUBA.L  A0,A0
    MOVE.L  A0,ESQIFF_SecondaryLineHeadPtr
    MOVEQ   #0,D1
    MOVE.W  ESQIFF_RecordLength,D1
    CMP.B   -1(A3,D1.L),D0
    BNE.S   .branch

    MOVE.L  A0,ESQIFF_SecondaryLineTailPtr
    BRA.W   ESQIFF2_ParseLineHeadTailRecord_Return

.branch:
    LEA     2(A3),A0
    MOVE.L  ESQIFF_SecondaryLineTailPtr,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   ESQPARS_ReplaceOwnedString

    ADDQ.W  #8,A7
    MOVE.L  D0,ESQIFF_SecondaryLineTailPtr
    BRA.W   ESQIFF2_ParseLineHeadTailRecord_Return

.branch_1:
    MOVEQ   #0,D0
    MOVE.W  ESQIFF_RecordLength,D0
    MOVEQ   #18,D1
    CMP.B   -1(A3,D0.L),D1
    BNE.S   .branch_2

    LEA     1(A3),A0
    MOVE.L  ESQIFF_SecondaryLineHeadPtr,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   ESQPARS_ReplaceOwnedString

    ADDQ.W  #8,A7
    MOVE.L  D0,ESQIFF_SecondaryLineHeadPtr
    CLR.L   ESQIFF_SecondaryLineTailPtr
    BRA.S   ESQIFF2_ParseLineHeadTailRecord_Return

.branch_2:
    MOVEQ   #3,D6

.branch_3:
    MOVEQ   #18,D0
    CMP.B   0(A3,D6.W),D0
    BEQ.S   .branch_4

    MOVEQ   #103,D0
    CMP.W   D0,D6
    BGE.S   .branch_4

    ADDQ.W  #1,D6
    BRA.S   .branch_3

.branch_4:
    CLR.B   0(A3,D6.W)
    LEA     1(A3),A0
    MOVE.L  ESQIFF_SecondaryLineHeadPtr,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   ESQPARS_ReplaceOwnedString

    MOVE.L  D0,ESQIFF_SecondaryLineHeadPtr
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     1(A0),A1
    MOVE.L  ESQIFF_SecondaryLineTailPtr,(A7)
    MOVE.L  A1,-(A7)
    BSR.W   ESQPARS_ReplaceOwnedString

    LEA     12(A7),A7
    MOVE.L  D0,ESQIFF_SecondaryLineTailPtr

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ParseLineHeadTailRecord_Return   (Routine at ESQIFF2_ParseLineHeadTailRecord_Return)
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
ESQIFF2_ParseLineHeadTailRecord_Return:
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ParseGroupRecordAndRefresh   (Routine at ESQIFF2_ParseGroupRecordAndRefresh)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +10: arg_3 (via 14(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A5/A7/D0/D1/D2/D4/D5/D6/D7
; CALLS:
;   ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache, ESQPARS_JMPTBL_TEXTDISP_ApplySourceConfigAllEntries, ESQIFF2_ValidateFieldIndexAndLength, ESQIFF2_PadEntriesToMaxTitleWidth, ESQPARS_RemoveGroupEntryAndReleaseStrings, ESQSHARED_CreateGroupEntryAndTitle
; READS:
;   ESQIFF2_ParseGroupRecordAndRefresh_Return, TEXTDISP_SecondaryGroupCode, TEXTDISP_SecondaryGroupEntryCount, TEXTDISP_PrimaryGroupCode, TEXTDISP_PrimaryGroupEntryCount, ESQIFF_RecordLength, TEXTDISP_PrimaryGroupRecordChecksum, TEXTDISP_PrimaryGroupRecordLength, TEXTDISP_SecondaryGroupRecordChecksum, TEXTDISP_SecondaryGroupRecordLength, ESQIFF_RecordChecksumByte, ESQIFF_ParseField0Buffer, ESQIFF_ParseField1Buffer, ESQIFF_ParseField2Buffer, ESQIFF_ParseField3Buffer, branch, ff, lab_0AE9, lab_0AEB, lab_0AEE, lab_0AF1, lab_0AF3
; WRITES:
;   TEXTDISP_PrimaryGroupRecordChecksum, TEXTDISP_PrimaryGroupRecordLength, TEXTDISP_MaxEntryTitleLength, TEXTDISP_SecondaryGroupRecordChecksum, TEXTDISP_SecondaryGroupRecordLength, NEWGRID_RefreshStateFlag, ESQIFF_ParseField0Buffer, ESQIFF_ParseField0TailBuffer, ESQIFF_ParseField1Buffer, ESQIFF_ParseField1TailByte, ESQIFF_ParseField3Buffer, ESQIFF_ParseField3TailBuffer
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF2_ParseGroupRecordAndRefresh:
    LINK.W  A5,#-20
    MOVEM.L D2/D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D0
    MOVE.B  (A3)+,D0
    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    MOVE.L  D0,D7
    MOVE.B  TEXTDISP_PrimaryGroupCode,D0
    CMP.B   D0,D7
    BNE.S   .lab_0ADA

    MOVE.W  TEXTDISP_PrimaryGroupRecordLength,D0
    MOVE.W  ESQIFF_RecordLength,D1
    CMP.W   D1,D0
    BNE.S   .lab_0AD9

    MOVE.B  TEXTDISP_PrimaryGroupRecordChecksum,D0
    MOVE.B  ESQIFF_RecordChecksumByte,D2
    CMP.B   D2,D0
    BEQ.S   .lab_0ADA

.lab_0AD9:
    MOVE.W  D1,TEXTDISP_PrimaryGroupRecordLength
    MOVE.B  ESQIFF_RecordChecksumByte,TEXTDISP_PrimaryGroupRecordChecksum
    MOVEQ   #0,D0
    MOVE.W  D0,TEXTDISP_MaxEntryTitleLength
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D1
    CMP.W   D0,D1
    BLS.S   .lab_0ADD

    PEA     1.W
    BSR.W   ESQPARS_RemoveGroupEntryAndReleaseStrings

    ADDQ.W  #4,A7
    MOVEQ   #1,D0
    MOVE.L  D0,NEWGRID_RefreshStateFlag
    BRA.S   .lab_0ADD

.lab_0ADA:
    MOVE.B  TEXTDISP_SecondaryGroupCode,D0
    CMP.B   D0,D7
    BNE.S   .lab_0ADC

    MOVE.W  TEXTDISP_SecondaryGroupRecordLength,D0
    MOVE.W  ESQIFF_RecordLength,D1
    CMP.W   D1,D0
    BNE.S   .lab_0ADB

    MOVE.B  TEXTDISP_SecondaryGroupRecordChecksum,D0
    MOVE.B  ESQIFF_RecordChecksumByte,D2
    CMP.B   D2,D0
    BEQ.S   .lab_0ADC

.lab_0ADB:
    MOVE.W  D1,TEXTDISP_SecondaryGroupRecordLength
    MOVE.B  ESQIFF_RecordChecksumByte,TEXTDISP_SecondaryGroupRecordChecksum
    MOVEQ   #0,D0
    MOVE.W  D0,TEXTDISP_MaxEntryTitleLength
    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D1
    CMP.W   D0,D1
    BLS.S   .lab_0ADD

    PEA     2.W
    BSR.W   ESQPARS_RemoveGroupEntryAndReleaseStrings

    ADDQ.W  #4,A7
    BRA.S   .lab_0ADD

.lab_0ADC:
    MOVEQ   #0,D0
    BRA.W   ESQIFF2_ParseGroupRecordAndRefresh_Return

.lab_0ADD:
    MOVEQ   #1,D6
    MOVEQ   #0,D0
    MOVE.B  D0,ESQIFF_ParseField0Buffer
    MOVE.B  D0,ESQIFF_ParseField1Buffer
    MOVEQ   #0,D5

.lab_0ADE:
    MOVEQ   #6,D0
    CMP.W   D0,D5
    BGE.S   .lab_0ADF

    LEA     ESQIFF_ParseField2Buffer,A0
    ADDA.W  D5,A0
    MOVE.B  #$ff,(A0)
    ADDQ.W  #1,D5
    BRA.S   .lab_0ADE

.lab_0ADF:
    CLR.B   ESQIFF_ParseField3Buffer
    MOVEQ   #0,D4
    MOVEQ   #0,D5
    MOVEQ   #1,D0
    MOVE.L  D0,-8(A5)
    CLR.L   -12(A5)
    CLR.W   -14(A5)

.branch:
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-3(A5)
    TST.B   D0
    BEQ.W   .lab_0AF3

    TST.L   -12(A5)
    BNE.W   .lab_0AF3

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    SUBQ.W  #1,D1
    BEQ.W   .lab_0AEE

    SUBI.W  #16,D1
    BEQ.W   .lab_0AE9

    SUBQ.W  #1,D1
    BEQ.S   .lab_0AE1

    SUBQ.W  #2,D1
    BEQ.W   .lab_0AEB

    BRA.W   .lab_0AF1

.lab_0AE1:
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   ESQIFF2_ValidateFieldIndexAndLength

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .branch_1

    MOVEQ   #1,D0
    MOVE.L  D0,-12(A5)
    BRA.S   .branch

.branch_1:
    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     ESQIFF_ParseField0Buffer,A0
    ADDA.L  D0,A0
    ADDA.W  D5,A0
    CLR.B   (A0)
    TST.L   -8(A5)
    BNE.S   .branch_4

    TST.W   -14(A5)
    BNE.S   .branch_3

    LEA     ESQIFF_ParseField0Buffer,A0
    LEA     ESQIFF_ParseField3Buffer,A1

.branch_2:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .branch_2

.branch_3:
    MOVEQ   #0,D0
    MOVE.B  D0,ESQIFF_ParseField0TailBuffer
    MOVE.B  D0,ESQIFF_ParseField1TailByte
    MOVE.B  D0,ESQIFF_ParseField3TailBuffer
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    PEA     ESQIFF_ParseField3Buffer
    PEA     ESQIFF_ParseField2Buffer
    PEA     ESQIFF_ParseField1Buffer
    PEA     ESQIFF_ParseField0Buffer
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQSHARED_CreateGroupEntryAndTitle(PC)

    LEA     24(A7),A7
    MOVEQ   #0,D0
    MOVE.W  D0,-14(A5)
    BRA.S   .branch_5

.branch_4:
    CLR.L   -8(A5)

.branch_5:
    MOVEQ   #0,D0
    MOVE.B  D0,ESQIFF_ParseField0Buffer
    MOVE.B  D0,ESQIFF_ParseField1Buffer
    MOVEQ   #0,D5

.branch_6:
    MOVEQ   #6,D0
    CMP.W   D0,D5
    BGE.S   .branch_7

    LEA     ESQIFF_ParseField2Buffer,A0
    ADDA.W  D5,A0
    MOVE.B  #$ff,(A0)
    ADDQ.W  #1,D5
    BRA.S   .branch_6

.branch_7:
    CLR.B   ESQIFF_ParseField3Buffer
    MOVEQ   #0,D4
    MOVEQ   #0,D5
    MOVE.B  (A3)+,D6
    BRA.W   .branch

.lab_0AE9:
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   ESQIFF2_ValidateFieldIndexAndLength

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .branch_8

    MOVEQ   #1,D0
    MOVE.L  D0,-12(A5)
    BRA.W   .branch

.branch_8:
    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     ESQIFF_ParseField0Buffer,A0
    ADDA.L  D0,A0
    ADDA.W  D5,A0
    CLR.B   (A0)
    MOVEQ   #1,D4
    MOVEQ   #0,D5
    BRA.W   .branch

.lab_0AEB:
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   ESQIFF2_ValidateFieldIndexAndLength

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .branch_9

    MOVEQ   #1,D0
    MOVE.L  D0,-12(A5)
    BRA.W   .branch

.branch_9:
    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     ESQIFF_ParseField0Buffer,A0
    ADDA.L  D0,A0
    ADDA.W  D5,A0
    CLR.B   (A0)
    MOVEQ   #0,D5

.branch_10:
    MOVEQ   #6,D0
    CMP.W   D0,D5
    BGE.W   .branch

    LEA     ESQIFF_ParseField2Buffer,A0
    ADDA.W  D5,A0
    MOVE.B  (A3)+,(A0)
    ADDQ.W  #1,D5
    BRA.S   .branch_10

.lab_0AEE:
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   ESQIFF2_ValidateFieldIndexAndLength

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .branch_11

    MOVEQ   #1,D0
    MOVE.L  D0,-12(A5)
    BRA.W   .branch

.branch_11:
    MOVEQ   #2,D0
    CMP.W   D0,D4
    BEQ.S   .branch_12

    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     ESQIFF_ParseField0Buffer,A0
    ADDA.L  D0,A0
    ADDA.W  D5,A0
    CLR.B   (A0)

.branch_12:
    MOVEQ   #3,D4
    MOVEQ   #0,D5
    MOVE.W  #1,-14(A5)
    BRA.W   .branch

.lab_0AF1:
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   ESQIFF2_ValidateFieldIndexAndLength

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .branch_13

    MOVEQ   #1,D0
    MOVE.L  D0,-12(A5)
    BRA.W   .branch

.branch_13:
    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     ESQIFF_ParseField0Buffer,A0
    ADDA.L  D0,A0
    MOVE.L  D5,D0
    ADDQ.W  #1,D5
    ADDA.W  D0,A0
    MOVE.B  -3(A5),(A0)
    BRA.W   .branch

.lab_0AF3:
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   ESQIFF2_ValidateFieldIndexAndLength

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .branch_14

    MOVEQ   #0,D0
    BRA.S   ESQIFF2_ParseGroupRecordAndRefresh_Return

.branch_14:
    MOVE.L  D4,D0
    MULS    #10,D0
    LEA     ESQIFF_ParseField0Buffer,A0
    ADDA.L  D0,A0
    ADDA.W  D5,A0
    MOVEQ   #0,D0
    MOVE.B  D0,(A0)
    MOVE.B  D0,ESQIFF_ParseField0TailBuffer
    MOVE.B  D0,ESQIFF_ParseField1TailByte
    MOVE.B  D0,ESQIFF_ParseField3TailBuffer
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    PEA     ESQIFF_ParseField3Buffer
    PEA     ESQIFF_ParseField2Buffer
    PEA     ESQIFF_ParseField1Buffer
    PEA     ESQIFF_ParseField0Buffer
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQSHARED_CreateGroupEntryAndTitle(PC)

    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,(A7)
    BSR.W   ESQIFF2_PadEntriesToMaxTitleWidth

    JSR     ESQPARS_JMPTBL_TEXTDISP_ApplySourceConfigAllEntries(PC)

    JSR     ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache(PC)

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ParseGroupRecordAndRefresh_Return   (Routine at ESQIFF2_ParseGroupRecordAndRefresh_Return)
; ARGS:
;   stack +40: arg_1 (via 44(A5))
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
ESQIFF2_ParseGroupRecordAndRefresh_Return:
    MOVEM.L -44(A5),D2/D4-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ValidateFieldIndexAndLength   (Routine at ESQIFF2_ValidateFieldIndexAndLength)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D6/D7
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
ESQIFF2_ValidateFieldIndexAndLength:
    MOVEM.L D6-D7,-(A7)
    MOVE.W  14(A7),D7
    MOVE.W  18(A7),D6
    MOVEQ   #3,D0
    CMP.W   D0,D7
    BLE.S   .lab_0AF7

    MOVEQ   #0,D0
    BRA.S   ESQIFF2_ValidateFieldIndexAndLength_Return

.lab_0AF7:
    MOVEQ   #1,D0
    CMP.W   D0,D7
    BNE.S   .lab_0AF8

    MOVEQ   #10,D0
    CMP.W   D0,D6
    BLE.S   .lab_0AF9

    MOVEQ   #0,D0
    BRA.S   ESQIFF2_ValidateFieldIndexAndLength_Return

.lab_0AF8:
    MOVEQ   #7,D0
    CMP.W   D0,D6
    BLE.S   .lab_0AF9

    MOVEQ   #0,D0
    BRA.S   ESQIFF2_ValidateFieldIndexAndLength_Return

.lab_0AF9:
    MOVEQ   #1,D0

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ValidateFieldIndexAndLength_Return   (Routine at ESQIFF2_ValidateFieldIndexAndLength_Return)
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
ESQIFF2_ValidateFieldIndexAndLength_Return:
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_PadEntriesToMaxTitleWidth   (Routine at ESQIFF2_PadEntriesToMaxTitleWidth)
; ARGS:
;   stack +7: arg_1 (via 11(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +20: arg_3 (via 24(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   GROUP_AR_JMPTBL_STRING_AppendAtNull
; READS:
;   ESQIFF2_PadEntriesToMaxTitleWidth_Return, TEXTDISP_SecondaryGroupCode, TEXTDISP_SecondaryGroupEntryCount, TEXTDISP_PrimaryGroupCode, TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_PrimaryEntryPtrTable, TEXTDISP_SecondaryEntryPtrTable, TEXTDISP_MaxEntryTitleLength, lab_0AFF
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF2_PadEntriesToMaxTitleWidth:
    LINK.W  A5,#-24
    MOVEM.L D4-D7,-(A7)
    MOVE.B  11(A5),D7
    MOVE.B  TEXTDISP_SecondaryGroupCode,D0
    CMP.B   D7,D0
    BNE.S   .lab_0AFC

    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D0
    MOVE.W  D0,-12(A5)
    BRA.S   .lab_0AFE

.lab_0AFC:
    MOVE.B  TEXTDISP_PrimaryGroupCode,D0
    CMP.B   D0,D7
    BNE.S   .lab_0AFD

    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.W  D0,-12(A5)
    BRA.S   .lab_0AFE

.lab_0AFD:
    MOVEQ   #0,D0
    BRA.W   ESQIFF2_PadEntriesToMaxTitleWidth_Return

.lab_0AFE:
    MOVEQ   #0,D6

.lab_0AFF:
    CMP.W   -12(A5),D6
    BGE.W   ESQIFF2_PadEntriesToMaxTitleWidth_Return

    MOVE.B  TEXTDISP_SecondaryGroupCode,D0
    CMP.B   D0,D7
    BNE.S   .lab_0B00

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    BRA.S   .lab_0B01

.lab_0B00:
    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)

.lab_0B01:
    MOVEA.L -4(A5),A0
    ADDQ.L  #1,A0
    MOVEA.L A0,A1

.lab_0B02:
    TST.B   (A1)+
    BNE.S   .lab_0B02

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.W  TEXTDISP_MaxEntryTitleLength,D0
    EXT.L   D0
    MOVE.L  A1,D1
    SUB.L   D1,D0
    MOVE.L  D0,D4
    TST.W   D4
    BLE.S   .lab_0B06

    MOVEQ   #0,D5

.lab_0B03:
    MOVEQ   #10,D0
    CMP.W   D0,D5
    BGE.S   .lab_0B04

    MOVE.B  #$20,-24(A5,D5.W)
    ADDQ.W  #1,D5
    BRA.S   .lab_0B03

.lab_0B04:
    CLR.B   -24(A5,D4.W)
    MOVEA.L -4(A5),A0
    ADDQ.L  #1,A0
    MOVE.L  A0,-(A7)
    PEA     -24(A5)
    JSR     GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    MOVEA.L -4(A5),A0
    ADDQ.L  #1,A0
    LEA     -24(A5),A1

.lab_0B05:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .lab_0B05

.lab_0B06:
    ADDQ.W  #1,D6
    BRA.W   .lab_0AFF

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_PadEntriesToMaxTitleWidth_Return   (Routine at ESQIFF2_PadEntriesToMaxTitleWidth_Return)
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
ESQIFF2_PadEntriesToMaxTitleWidth_Return:
    MOVEM.L (A7)+,D4-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ReadSerialBytesToBuffer   (Routine at ESQIFF2_ReadSerialBytesToBuffer)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A3/A7/D6/D7
; CALLS:
;   ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte, ESQFUNC_WaitForClockChangeAndServiceUi
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF2_ReadSerialBytesToBuffer:
    LINK.W  A5,#-4
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVE.W  30(A7),D7
    MOVEQ   #0,D6

.lab_0B09:
    CMP.W   D7,D6
    BGE.S   ESQIFF2_ReadSerialBytesToBuffer_Return

    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    MOVEA.L A3,A0
    ADDQ.L  #1,A3
    MOVE.L  A0,12(A7)
    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVEA.L 12(A7),A0
    MOVE.B  D0,(A0)
    ADDQ.W  #1,D6
    BRA.S   .lab_0B09

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ReadSerialBytesToBuffer_Return   (Routine at ESQIFF2_ReadSerialBytesToBuffer_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D6
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
ESQIFF2_ReadSerialBytesToBuffer_Return:
    MOVE.L  A3,D0
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ReadSerialBytesWithXor   (Routine at ESQIFF2_ReadSerialBytesWithXor)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A2/A3/A7/D6/D7
; CALLS:
;   ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte, ESQFUNC_WaitForClockChangeAndServiceUi
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF2_ReadSerialBytesWithXor:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.W  26(A7),D7
    MOVEA.L 28(A7),A2
    MOVEQ   #0,D6

.lab_0B0C:
    CMP.W   D7,D6
    BGE.S   ESQIFF2_ReadSerialBytesWithXor_Return

    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,(A3)
    ADDQ.L  #1,A3
    EOR.B   D0,(A2)
    ADDQ.W  #1,D6
    BRA.S   .lab_0B0C

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ReadSerialBytesWithXor_Return   (Routine at ESQIFF2_ReadSerialBytesWithXor_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D6
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
ESQIFF2_ReadSerialBytesWithXor_Return:
    MOVE.L  A3,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ReadSerialRecordIntoBuffer   (Routine at ESQIFF2_ReadSerialRecordIntoBuffer)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +10: arg_2 (via 14(A5))
;   stack +14: arg_3 (via 18(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A5/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte, ESQFUNC_WaitForClockChangeAndServiceUi
; READS:
;   lab_0B0F, lab_0B15
; WRITES:
;   ESQIFF_RecordChecksumByte
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF2_ReadSerialRecordIntoBuffer:
    LINK.W  A5,#-12
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.W  18(A5),D6
    MOVEQ   #0,D4
    MOVE.W  D4,-6(A5)

.lab_0B0F:
    CMPI.W  #$2328,D4
    BCC.W   .lab_0B15

    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVE.L  D0,20(A7)
    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.L  20(A7),D1
    MOVE.B  D0,0(A3,D1.L)
    TST.B   D0
    BNE.S   .lab_0B11

    TST.W   D7
    BNE.S   .lab_0B10

    BRA.W   .lab_0B15

.lab_0B10:
    MOVEQ   #1,D0
    CMP.W   D0,D4
    BHI.W   .lab_0B15

.lab_0B11:
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVEQ   #20,D1
    CMP.B   0(A3,D0.L),D1
    BNE.S   .lab_0B13

    MOVEQ   #1,D0
    CMP.W   D0,D7
    BNE.S   .lab_0B13

    ADDQ.W  #1,D4
    MOVEQ   #0,D5

.lab_0B12:
    CMP.W   D6,D5
    BCC.S   .lab_0B0F

    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    MOVE.L  D4,D0
    ADDQ.W  #1,D4
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,20(A7)
    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.L  20(A7),D1
    MOVE.B  D0,0(A3,D1.L)
    ADDQ.W  #1,D5
    BRA.S   .lab_0B12

.lab_0B13:
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVEQ   #18,D1
    CMP.B   0(A3,D0.L),D1
    BNE.S   .lab_0B14

    MOVEQ   #1,D0
    CMP.W   D0,D7
    BNE.S   .lab_0B14

    ADDQ.W  #1,D4
    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    MOVE.L  D4,D0
    ADDQ.W  #1,D4
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,20(A7)
    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.L  20(A7),D1
    MOVE.B  D0,0(A3,D1.L)
    ADDQ.W  #1,-6(A5)
    CMPI.W  #$12e,-6(A5)
    BCS.W   .lab_0B0F

    MOVEQ   #0,D0
    BRA.S   ESQIFF2_ReadSerialRecordIntoBuffer_Return

.lab_0B14:
    ADDQ.W  #1,D4
    BRA.W   .lab_0B0F

.lab_0B15:
    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,ESQIFF_RecordChecksumByte
    MOVE.L  D4,D0

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ReadSerialRecordIntoBuffer_Return   (Routine at ESQIFF2_ReadSerialRecordIntoBuffer_Return)
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
ESQIFF2_ReadSerialRecordIntoBuffer_Return:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ReadSerialSizedTextRecord   (Routine at ESQIFF2_ReadSerialSizedTextRecord)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte, ESQFUNC_WaitForClockChangeAndServiceUi
; READS:
;   ESQIFF2_ReadSerialSizedTextRecord_Return
; WRITES:
;   ESQIFF_RecordChecksumByte
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF2_ReadSerialSizedTextRecord:
    LINK.W  A5,#-4
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 32(A7),A3
    MOVE.L  36(A7),D7
    TST.L   D7
    BLE.S   .lab_0B18

    CMPI.L  #$2328,D7
    BLT.S   .lab_0B19

.lab_0B18:
    MOVEQ   #0,D0
    BRA.W   ESQIFF2_ReadSerialSizedTextRecord_Return

.lab_0B19:
    MOVEQ   #0,D6
    MOVEQ   #0,D4

.lab_0B1A:
    CMP.L   D7,D6
    BGE.S   .lab_0B1B

    CMPI.L  #$2328,D6
    BGE.S   .lab_0B1B

    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVE.L  D0,20(A7)
    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.L  20(A7),D1
    MOVE.B  D0,0(A3,D1.L)
    ADDQ.L  #1,D6
    ADDQ.W  #1,D4
    BRA.S   .lab_0B1A

.lab_0B1B:
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    CLR.B   0(A3,D0.L)
    MOVE.L  A3,-(A7)
    JSR     ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D5
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVE.B  #$20,0(A3,D0.L)
    MOVEQ   #0,D6

.lab_0B1C:
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    TST.B   -1(A3,D0.L)
    BEQ.S   .lab_0B1D

    CMP.L   D5,D6
    BGE.S   .lab_0B1D

    CMPI.W  #$2328,D4
    BCC.S   .lab_0B1D

    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVE.L  D0,20(A7)
    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.L  20(A7),D1
    MOVE.B  D0,0(A3,D1.L)
    ADDQ.L  #1,D6
    ADDQ.W  #1,D4
    BRA.S   .lab_0B1C

.lab_0B1D:
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    TST.B   -1(A3,D0.L)
    BNE.S   .lab_0B1E

    CMP.L   D5,D6
    BEQ.S   .lab_0B1F

.lab_0B1E:
    MOVEQ   #0,D4
    CLR.B   (A3)
    BRA.S   .lab_0B20

.lab_0B1F:
    JSR     ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,ESQIFF_RecordChecksumByte

.lab_0B20:
    MOVE.L  D4,D0

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ReadSerialSizedTextRecord_Return   (Routine at ESQIFF2_ReadSerialSizedTextRecord_Return)
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
ESQIFF2_ReadSerialSizedTextRecord_Return:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ShowVersionMismatchOverlay   (Routine at ESQIFF2_ShowVersionMismatchOverlay)
; ARGS:
;   stack +36: arg_1 (via 40(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/A7/D0/D1/D2/D3
; CALLS:
;   ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition, ESQSHARED_JMPTBL_ESQ_WildcardMatch, GCOMMAND_SeedBannerFromPrefs, GROUP_AM_JMPTBL_WDISP_SPrintf, GROUP_AR_JMPTBL_STRING_AppendAtNull, _LVODisable, _LVOEnable, _LVORectFill, _LVOSetAPen
; READS:
;   AbsExecBase, GLOB_LONG_PATCH_VERSION_NUMBER, GLOB_REF_696_400_BITMAP, GLOB_REF_GRAPHICS_LIBRARY, GLOB_REF_RASTPORT_1, GLOB_STR_APOSTROPHE, GLOB_STR_MAJOR_MINOR_VERSION_1, GLOB_STR_MAJOR_MINOR_VERSION_2, ESQIFF2_ShowVersionMismatchOverlay_Return, DATA_ESQIFF_FMT_PCT_S_DOT_PCT_LD_1EFA, DATA_ESQIFF_STR_INCORRECT_VERSION_PLEASE_CORRECT_ASA_1EFC, DATA_ESQIFF_FMT_YOUR_VERSION_IS_PCT_S_DOT_PCT_LD_1EFD, DATA_ESQIFF_STR_CORRECT_VERSION_IS_1EFF, ED_DiagnosticsScreenActive, GLOB_UIBusyFlag, ESQIFF_RecordBufferPtr, lab_0B24
; WRITES:
;   ESQPARS2_ReadModeFlags, ED_DiagnosticsScreenActive
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF2_ShowVersionMismatchOverlay:
    LINK.W  A5,#-40
    MOVEM.L D2-D3,-(A7)

    MOVEA.L ESQIFF_RecordBufferPtr,A0
    CLR.B   20(A0)
    MOVE.L  GLOB_LONG_PATCH_VERSION_NUMBER,-(A7)
    PEA     GLOB_STR_MAJOR_MINOR_VERSION_1
    PEA     DATA_ESQIFF_FMT_PCT_S_DOT_PCT_LD_1EFA
    PEA     -40(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L ESQIFF_RecordBufferPtr,A0
    ADDQ.L  #1,A0
    MOVE.L  A0,(A7)
    PEA     -40(A5)
    JSR     ESQSHARED_JMPTBL_ESQ_WildcardMatch(PC)

    LEA     20(A7),A7
    TST.B   D0
    BEQ.W   ESQIFF2_ShowVersionMismatchOverlay_Return

    TST.W   GLOB_UIBusyFlag
    BEQ.S   .lab_0B23

    TST.W   ED_DiagnosticsScreenActive
    BEQ.W   ESQIFF2_ShowVersionMismatchOverlay_Return

.lab_0B23:
    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    MOVE.W  #$100,ESQPARS2_ReadModeFlags
    JSR     GCOMMAND_SeedBannerFromPrefs(PC)

    MOVEA.L AbsExecBase,A6
    JSR     _LVOEnable(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  #GLOB_REF_696_400_BITMAP,4(A0)
    CLR.W   ED_DiagnosticsScreenActive
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEQ   #60,D1
    MOVE.L  #679,D2
    MOVEQ   #100,D3
    NOT.B   D3
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    PEA     DATA_ESQIFF_STR_INCORRECT_VERSION_PLEASE_CORRECT_ASA_1EFC
    PEA     90.W
    PEA     30.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    MOVE.L  GLOB_LONG_PATCH_VERSION_NUMBER,(A7)
    PEA     GLOB_STR_MAJOR_MINOR_VERSION_2
    PEA     DATA_ESQIFF_FMT_YOUR_VERSION_IS_PCT_S_DOT_PCT_LD_1EFD
    PEA     -40(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -40(A5)
    PEA     120.W
    PEA     30.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     DATA_ESQIFF_STR_CORRECT_VERSION_IS_1EFF,A0
    LEA     -40(A5),A1
    MOVEQ   #4,D0

; Concatenate a string with an apostrophe before displaying
; the text at a 30,150
.lab_0B24:
    MOVE.L  (A0)+,(A1)+ ; Iterate copying A0 into A1 and...
    DBF     D0,.lab_0B24 ; incrementing both until A0 is null.

    CLR.B   (A1)
    MOVEA.L ESQIFF_RecordBufferPtr,A0
    ADDQ.L  #1,A0
    MOVE.L  A0,(A7)
    PEA     -40(A5)
    JSR     GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    PEA     GLOB_STR_APOSTROPHE
    PEA     -40(A5)
    JSR     GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    PEA     -40(A5)
    PEA     150.W
    PEA     30.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     72(A7),A7

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ShowVersionMismatchOverlay_Return   (Routine at ESQIFF2_ShowVersionMismatchOverlay_Return)
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
ESQIFF2_ShowVersionMismatchOverlay_Return:
    MOVEM.L (A7)+,D2-D3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ShowAttentionOverlay   (Routine at ESQIFF2_ShowAttentionOverlay)
; ARGS:
;   stack +7: arg_1 (via 11(A5))
;   stack +124: arg_2 (via 128(A5))
;   stack +134: arg_3 (via 138(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D1/D2/D3/D5/D6/D7
; CALLS:
;   ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex, ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition, GCOMMAND_SeedBannerFromPrefs, GROUP_AM_JMPTBL_WDISP_SPrintf, _LVODisable, _LVOEnable, _LVORectFill, _LVOSetAPen, _LVOSetDrMd
; READS:
;   AbsExecBase, BRUSH_SnapshotDepth, BRUSH_SnapshotHeader, BRUSH_SnapshotWidth, GLB_STR_PLEASE_STANDBY_2, GLOB_REF_696_400_BITMAP, GLOB_REF_GRAPHICS_LIBRARY, GLOB_REF_RASTPORT_1, GLOB_STR_ATTENTION_SYSTEM_ENGINEER_2, GLOB_STR_FILE_PERCENT_S, GLOB_STR_FILE_WIDTH_COLORS_FORMATTED, GLOB_STR_PRESS_ESC_TWICE_TO_RESUME_SCROLL, GLOB_STR_REPORT_ERROR_CODE_FORMATTED, ESQIFF2_ShowAttentionOverlay_Return, ED_DiagnosticsScreenActive, GLOB_UIBusyFlag, lab_0B28, lab_0B29_0008, lab_0B29_000C, lab_0B29_0010, lab_0B29_0014, lab_0B29_0018
; WRITES:
;   DATA_COI_BSS_WORD_1B85, ESQPARS2_ReadModeFlags, ED_DiagnosticsScreenActive
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF2_ShowAttentionOverlay:
    LINK.W  A5,#-140
    MOVEM.L D2-D3/D5-D7,-(A7)
    MOVE.B  11(A5),D7
    MOVEQ   #-1,D5
    TST.W   GLOB_UIBusyFlag
    BEQ.S   .LAB_0B27

    TST.W   ED_DiagnosticsScreenActive
    BEQ.W   ESQIFF2_ShowAttentionOverlay_Return

.LAB_0B27:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    SUBQ.W  #1,D0
    BLT.S   .lab_0B2A

    CMPI.W  #5,D0
    BGE.S   .lab_0B2A

    ADD.W   D0,D0
    MOVE.W  .lab_0B28(PC,D0.W),D0
    JMP     .lab_0B28+2(PC,D0.W)

; switch/jumptable
.lab_0B28:
    DC.W    .lab_0B29_0008-.lab_0B28-2
    DC.W    .lab_0B29_000C-.lab_0B28-2
    DC.W    .lab_0B29_0010-.lab_0B28-2
    DC.W    .lab_0B29_0014-.lab_0B28-2
    DC.W    .lab_0B29_0018-.lab_0B28-2

.lab_0B29_0008:
    MOVEQ   #1,D5
    BRA.S   .lab_0B2A

.lab_0B29_000C:
    MOVEQ   #2,D5
    BRA.S   .lab_0B2A

.lab_0B29_0010:
    MOVEQ   #8,D5
    BRA.S   .lab_0B2A

.lab_0B29_0014:
    MOVEQ   #9,D5
    BRA.S   .lab_0B2A

.lab_0B29_0018:
    MOVEQ   #10,D5

.lab_0B2A:
    TST.L   D5
    BLE.W   ESQIFF2_ShowAttentionOverlay_Return

    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    MOVE.W  #$100,ESQPARS2_ReadModeFlags
    JSR     GCOMMAND_SeedBannerFromPrefs(PC)

    MOVEA.L AbsExecBase,A6
    JSR     _LVOEnable(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  4(A0),-138(A5)
    MOVE.L  #GLOB_REF_696_400_BITMAP,4(A0)
    CLR.W   ED_DiagnosticsScreenActive
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEQ   #65,D1
    MOVE.L  #$2ac,D2
    MOVEQ   #40,D3
    NOT.B   D3
    JSR     _LVORectFill(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.B  28(A0),D6
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    PEA     GLB_STR_PLEASE_STANDBY_2
    PEA     90.W
    PEA     35.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_ATTENTION_SYSTEM_ENGINEER_2
    PEA     120.W
    PEA     35.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    MOVE.L  D5,(A7)
    PEA     GLOB_STR_REPORT_ERROR_CODE_FORMATTED
    PEA     -128(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -128(A5)
    PEA     150.W
    PEA     35.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     56(A7),A7
    MOVEQ   #9,D0
    CMP.L   D0,D5
    BEQ.S   .lab_0B2B

    MOVEQ   #10,D0
    CMP.L   D0,D5
    BNE.S   .lab_0B2C

.lab_0B2B:
    MOVE.L  BRUSH_SnapshotDepth,-(A7)   ; reuse cached brush dimensions in file dialog
    JSR     ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

    MOVE.L  D0,(A7)
    MOVE.L  BRUSH_SnapshotWidth,-(A7)
    PEA     BRUSH_SnapshotHeader
    PEA     GLOB_STR_FILE_WIDTH_COLORS_FORMATTED
    PEA     -128(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     20(A7),A7
    MOVE.W  #1,DATA_COI_BSS_WORD_1B85
    BRA.S   .lab_0B2D

.lab_0B2C:
    PEA     BRUSH_SnapshotHeader
    PEA     GLOB_STR_FILE_PERCENT_S
    PEA     -128(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     12(A7),A7

.lab_0B2D:
    PEA     -128(A5)
    PEA     180.W
    PEA     35.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    PEA     GLOB_STR_PRESS_ESC_TWICE_TO_RESUME_SCROLL
    PEA     210.W
    PEA     35.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     32(A7),A7
    MOVE.L  D6,D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  -138(A5),4(A0)

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ShowAttentionOverlay_Return   (Routine at ESQIFF2_ShowAttentionOverlay_Return)
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
ESQIFF2_ShowAttentionOverlay_Return:
    MOVEM.L (A7)+,D2-D3/D5-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ClearPrimaryEntryFlags34To39   (Routine at ESQIFF2_ClearPrimaryEntryFlags34To39)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A5/A7/D0/D6/D7
; CALLS:
;   (none)
; READS:
;   TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_PrimaryEntryPtrTable
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQIFF2_ClearPrimaryEntryFlags34To39:
    LINK.W  A5,#-8
    MOVEM.L D6-D7,-(A7)
    MOVEQ   #0,D7

.lab_0B30:
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.W   D0,D7
    BGE.S   ESQIFF2_ClearPrimaryEntryFlags34To39_Return

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    MOVEQ   #0,D6

.lab_0B31:
    MOVEQ   #6,D0
    CMP.W   D0,D6
    BGE.S   .lab_0B32

    MOVEA.L -4(A5),A0
    CLR.B   34(A0,D6.W)
    ADDQ.W  #1,D6
    BRA.S   .lab_0B31

.lab_0B32:
    ADDQ.W  #1,D7
    BRA.S   .lab_0B30

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ClearPrimaryEntryFlags34To39_Return   (Routine at ESQIFF2_ClearPrimaryEntryFlags34To39_Return)
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
ESQIFF2_ClearPrimaryEntryFlags34To39_Return:
    MOVEM.L (A7)+,D6-D7
    UNLK    A5
    RTS
