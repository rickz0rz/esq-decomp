    XDEF    DISKIO_EnsurePc1MountedAndGfxAssigned
    XDEF    DISKIO_LoadConfigFromDisk
    XDEF    DISKIO_ParseConfigBuffer
    XDEF    DISKIO_SaveConfigToFileHandle
    XDEF    DISKIO_EnsurePc1MountedAndGfxAssigned_Return
    XDEF    DISKIO_SaveConfigToFileHandle_Return


;------------------------------------------------------------------------------
; FUNC: DISKIO_ParseConfigBuffer   (Routine at DISKIO_ParseConfigBuffer)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +24: arg_3 (via 28(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A5/A7/D0/D1/D2/D5/D6/D7
; CALLS:
;   BRUSH_SelectBrushByLabel, GROUP_AG_JMPTBL_ESQFUNC_UpdateRefreshModeState, _GROUP_AG_JMPTBL_MATH_Mulu32, _GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, GROUP_AG_JMPTBL_SCRIPT_BeginBannerCharTransition, _GROUP_AI_JMPTBL_STR_FindCharPtr, DISKIO_EnsurePc1MountedAndGfxAssigned
; READS:
;   Global_JMPTBL_HALF_HOURS_12_HR_FMT, _Global_JMPTBL_HALF_HOURS_24_HR_FMT, _Global_REF_STR_USE_24_HR_CLOCK, _CONFIG_BannerCopperHeadByte, LAB_0409, CONFIG_RefreshIntervalMinutes, _ED_DiagTextModeChar, CONFIG_EnsurePc1GfxAssignedFlag, CONFIG_MsnRuntimeModeSelectorChar_LRBN, _CONFIG_LRBN_FlagChar, DISKIO_TAG_NRLS, DISKIO_TAG_LRBN, DISKIO_TAG_MSN, _WDISP_CharClassTable, N
; WRITES:
;   Global_REF_BYTE_NUMBER_OF_COLOR_PALETTES, _Global_REF_STR_CLOCK_FORMAT, _Global_REF_STR_USE_24_HR_CLOCK, _CONFIG_BannerCopperHeadByte, CONFIG_RefreshIntervalMinutes, CTASKS_STR_C, _CONFIG_NicheModeCycleBudget_Y, _CONFIG_NicheModeCycleBudget_Static, CONFIG_SerializedNumericSlot05, CONFIG_NewgridWindowSpanHalfHoursPrimary, CTASKS_STR_G, CONFIG_SerializedFlagSlot08_DefaultN, CTASKS_STR_A, CTASKS_STR_E, CONFIG_SerializedNumericSlot10, _CONFIG_NicheModeCycleBudget_Custom, _CONFIG_NewgridSelectionCode34PrimaryEnabledFlag, CONFIG_NewgridSelectionCode35EnabledFlag, CONFIG_SerializedFlagSlot15_DefaultN, _CONFIG_NewgridSelectionCode34AltEnabledFlag, CONFIG_NewgridSelectionCode32EnabledFlag, CONFIG_RuntimeMode12BannerJumpEnabledFlag, CTASKS_STR_L, CONFIG_SerializedNumericSlot19, CONFIG_SerializedNumericSlot20, _CONFIG_ModeCycleEnabledFlag, _CONFIG_NewgridPlaceholderBevelFlag, _CONFIG_NewgridSelectionCode48_49EnabledFlag, CONFIG_SerializedNumericSlot25, CONFIG_SerializedNumericSlot26, CONFIG_NewgridWindowSpanHalfHoursAlt, _CONFIG_TimeWindowMinutes, _CONFIG_ModeCycleGateDuration, CONFIG_NewgridSelectionCode16EnabledFlag, CONFIG_ParseiniLogoScanEnabledFlag, _ED_DiagTextModeChar, CONFIG_EnsurePc1GfxAssignedFlag, CONFIG_MsnRuntimeModeSelectorChar_LRBN, _CONFIG_LRBN_FlagChar, _CONFIG_MSN_FlagChar, _CTASKS_STR_1, _CONFIG_RefreshIntervalSeconds
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO_ParseConfigBuffer:
    LINK.W  A5,#-8
    MOVEM.L D2/D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7

    MOVEQ   #0,D6
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVEQ   #-48,D1
    ADD.B   0(A3,D0.W),D1
    MOVE.B  D1,CONFIG_RefreshIntervalMinutes
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,CTASKS_STR_C
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVEQ   #-48,D1
    ADD.B   0(A3,D0.W),D1
    MOVE.B  D1,_CONFIG_NicheModeCycleBudget_Y
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVEQ   #-48,D1
    ADD.B   0(A3,D0.W),D1
    MOVE.B  D1,_CONFIG_NicheModeCycleBudget_Static
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-7(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-6(A5)
    CLR.B   -5(A5)
    PEA     -7(A5)
    JSR     _GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,CONFIG_SerializedNumericSlot05
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-7(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-6(A5)
    CLR.B   -5(A5)
    PEA     -7(A5)
    JSR     _GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,CONFIG_NewgridWindowSpanHalfHoursPrimary
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,CTASKS_STR_G
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03E1

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,CONFIG_SerializedFlagSlot08_DefaultN
    BRA.S   .lab_03E2

.lab_03E1:
    MOVEQ   #78,D0
    MOVE.B  D0,CONFIG_SerializedFlagSlot08_DefaultN

.lab_03E2:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03E3

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,CTASKS_STR_A
    BRA.S   .lab_03E4

.lab_03E3:
    MOVE.B  #'A',CTASKS_STR_A

.lab_03E4:
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,CTASKS_STR_E
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03E6

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVEQ   #-48,D1
    ADD.B   0(A3,D0.W),D1
    MOVE.B  D1,CONFIG_SerializedNumericSlot10
    TST.B   D1
    BMI.S   .lab_03E5

    MOVEQ   #9,D0
    CMP.B   D0,D1
    BLE.S   .lab_03E6

.lab_03E5:
    MOVEQ   #0,D0
    MOVE.B  D0,CONFIG_SerializedNumericSlot10

.lab_03E6:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03E8

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVEQ   #-48,D1
    ADD.B   0(A3,D0.W),D1
    MOVE.B  D1,_CONFIG_NicheModeCycleBudget_Custom
    TST.B   D1
    BMI.S   .lab_03E7

    MOVEQ   #9,D0
    CMP.B   D0,D1
    BLE.S   .lab_03E8

.lab_03E7:
    MOVEQ   #0,D0
    MOVE.B  D0,_CONFIG_NicheModeCycleBudget_Custom

.lab_03E8:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03E9

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,_CONFIG_NewgridSelectionCode34PrimaryEnabledFlag
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .lab_03E9

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .lab_03E9

    MOVE.B  D0,_CONFIG_NewgridSelectionCode34PrimaryEnabledFlag

.lab_03E9:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03EA

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,CONFIG_NewgridSelectionCode35EnabledFlag
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .lab_03EA

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .lab_03EA

    MOVE.B  D0,CONFIG_NewgridSelectionCode35EnabledFlag

.lab_03EA:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03EB

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,CONFIG_SerializedFlagSlot15_DefaultN
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .lab_03EB

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .lab_03EB

    MOVE.B  D2,CONFIG_SerializedFlagSlot15_DefaultN

.lab_03EB:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03EC

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,_CONFIG_NewgridSelectionCode34AltEnabledFlag
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .lab_03EC

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .lab_03EC

    MOVE.B  D2,_CONFIG_NewgridSelectionCode34AltEnabledFlag

.lab_03EC:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03ED

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,CONFIG_NewgridSelectionCode32EnabledFlag
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .lab_03ED

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .lab_03ED

    MOVE.B  D0,CONFIG_NewgridSelectionCode32EnabledFlag

.lab_03ED:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03EE

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,CONFIG_RuntimeMode12BannerJumpEnabledFlag
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .lab_03EE

    MOVEQ   #78,D0
    CMP.B   D0,D1
    BEQ.S   .lab_03EE

    MOVE.B  D0,CONFIG_RuntimeMode12BannerJumpEnabledFlag

.lab_03EE:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03EF

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,CTASKS_STR_L
    MOVEQ   #76,D0
    CMP.B   D0,D1
    BEQ.S   .lab_03EF

    MOVEQ   #83,D2
    CMP.B   D2,D1
    BEQ.S   .lab_03EF

    MOVEQ   #86,D2
    CMP.B   D2,D1
    BEQ.S   .lab_03EF

    MOVE.B  D0,CTASKS_STR_L

.lab_03EF:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03F0

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-7(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-6(A5)
    CLR.B   -5(A5)
    PEA     -7(A5)
    JSR     _GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,CONFIG_SerializedNumericSlot19

.lab_03F0:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03F1

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-7(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-6(A5)
    CLR.B   -5(A5)
    PEA     -7(A5)
    JSR     _GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,CONFIG_SerializedNumericSlot20

.lab_03F1:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03F2

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,_CONFIG_ModeCycleEnabledFlag
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .lab_03F2

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .lab_03F2

    MOVE.B  D0,_CONFIG_ModeCycleEnabledFlag

.lab_03F2:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03F3

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,_CONFIG_NewgridPlaceholderBevelFlag
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .lab_03F3

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .lab_03F3

    MOVE.B  D0,_CONFIG_NewgridPlaceholderBevelFlag

.lab_03F3:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03F4

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,_CONFIG_NewgridSelectionCode48_49EnabledFlag
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .lab_03F4

    MOVEQ   #78,D0
    CMP.B   D0,D1
    BEQ.S   .lab_03F4

    MOVE.B  D0,_CONFIG_NewgridSelectionCode48_49EnabledFlag

.lab_03F4:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03F5

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-7(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-6(A5)
    CLR.B   -5(A5)
    PEA     -7(A5)
    JSR     _GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,CONFIG_SerializedNumericSlot25

.lab_03F5:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03F6

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-7(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-6(A5)
    CLR.B   -5(A5)
    PEA     -7(A5)
    JSR     _GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,CONFIG_SerializedNumericSlot26

.lab_03F6:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03F7

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-7(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-6(A5)
    CLR.B   -5(A5)
    PEA     -7(A5)
    JSR     _GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,CONFIG_NewgridWindowSpanHalfHoursAlt

.lab_03F7:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03F8

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-7(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-6(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-5(A5)
    CLR.B   -4(A5)
    PEA     -7(A5)
    JSR     _GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,_CONFIG_TimeWindowMinutes

.lab_03F8:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03FA

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVEQ   #0,D1
    MOVE.B  0(A3,D0.W),D1
    MOVEQ   #48,D0
    SUB.L   D0,D1
    MOVE.L  D1,_CONFIG_ModeCycleGateDuration
    MOVEQ   #1,D0
    CMP.L   D0,D1
    BLT.S   .lab_03F9

    MOVEQ   #9,D2
    CMP.L   D2,D1
    BLE.S   .lab_03FA

.lab_03F9:
    MOVE.L  D0,_CONFIG_ModeCycleGateDuration

.lab_03FA:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03FB

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-7(A5)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),-6(A5)
    CLR.B   -5(A5)
    PEA     -7(A5)
    JSR     BRUSH_SelectBrushByLabel(PC)

    ADDQ.W  #4,A7

.lab_03FB:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_03FC

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,CONFIG_NewgridSelectionCode16EnabledFlag
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .lab_03FC

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .lab_03FC

    MOVE.B  D0,CONFIG_NewgridSelectionCode16EnabledFlag

.lab_03FC:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_0400

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,_Global_REF_STR_USE_24_HR_CLOCK
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .lab_03FD

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .lab_03FD

    MOVE.B  D2,_Global_REF_STR_USE_24_HR_CLOCK

.lab_03FD:
    MOVE.B  _Global_REF_STR_USE_24_HR_CLOCK,D1
    CMP.B   D0,D1
    BNE.S   .lab_03FE

    LEA     _Global_JMPTBL_HALF_HOURS_24_HR_FMT,A0
    BRA.S   .lab_03FF

.lab_03FE:
    LEA     Global_JMPTBL_HALF_HOURS_12_HR_FMT,A0

.lab_03FF:
    MOVE.L  A0,_Global_REF_STR_CLOCK_FORMAT

.lab_0400:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_0401

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,CONFIG_ParseiniLogoScanEnabledFlag
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .lab_0401

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .lab_0401

    MOVE.B  D0,CONFIG_ParseiniLogoScanEnabledFlag

.lab_0401:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.W   .lab_0409

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D5
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    LEA     _WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   .lab_0402

    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .lab_0403

.lab_0402:
    MOVEQ   #0,D0
    MOVE.B  D5,D0

.lab_0403:
    MOVEQ   #67,D1
    SUB.L   D1,D0
    BEQ.S   .lab_0405

    SUBQ.L  #3,D0
    BEQ.S   .lab_0404

    SUBQ.L  #2,D0
    BEQ.S   .lab_0406

    SUBQ.L  #8,D0
    BEQ.S   .lab_0406

    BRA.S   .lab_0406

.lab_0404:
    MOVE.W  #128,_CONFIG_BannerCopperHeadByte
    ADDQ.W  #1,D6
    BRA.S   .lab_0407

.lab_0405:
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVEQ   #0,D1
    MOVE.B  0(A3,D0.W),D1
    MOVE.W  D1,_CONFIG_BannerCopperHeadByte
    BRA.S   .lab_0407

.lab_0406:
    MOVE.W  #$8e,_CONFIG_BannerCopperHeadByte
    ADDQ.W  #1,D6

.lab_0407:
    MOVE.W  _CONFIG_BannerCopperHeadByte,D0
    CMPI.W  #128,D0
    BCS.S   .lab_0408

    CMPI.W  #220,D0
    BLS.S   .lab_0409

.lab_0408:
    MOVE.W  #$8e,_CONFIG_BannerCopperHeadByte

.lab_0409:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_040B

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVEQ   #-48,D1
    ADD.B   0(A3,D0.W),D1
    MOVE.B  D1,Global_REF_BYTE_NUMBER_OF_COLOR_PALETTES
    MOVEQ   #8,D0
    CMP.B   D0,D1
    BLT.S   .lab_040A

    CMP.B   D0,D1
    BLE.S   .lab_040B

.lab_040A:
    MOVE.B  D0,Global_REF_BYTE_NUMBER_OF_COLOR_PALETTES

.lab_040B:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_040F

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D5
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    LEA     _WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   .lab_040C

    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .lab_040D

.lab_040C:
    MOVEQ   #0,D0
    MOVE.B  D5,D0

.lab_040D:
    MOVE.B  D0,_ED_DiagTextModeChar
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     DISKIO_TAG_NRLS
    JSR     _GROUP_AI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .lab_040E

    MOVE.B  _ED_DiagTextModeChar,D0
    TST.B   D0
    BNE.S   .lab_040F

.lab_040E:
    MOVEQ   #78,D0
    MOVE.B  D0,_ED_DiagTextModeChar

.lab_040F:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_0410

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,CONFIG_EnsurePc1GfxAssignedFlag
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .lab_0410

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .lab_0410

    MOVE.B  D2,CONFIG_EnsurePc1GfxAssignedFlag

.lab_0410:
    MOVE.B  CONFIG_EnsurePc1GfxAssignedFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .lab_0411

    BSR.W   DISKIO_EnsurePc1MountedAndGfxAssigned

.lab_0411:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_0413

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,CONFIG_MsnRuntimeModeSelectorChar_LRBN
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    PEA     DISKIO_TAG_LRBN
    JSR     _GROUP_AI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .lab_0412

    MOVE.B  CONFIG_MsnRuntimeModeSelectorChar_LRBN,D0
    TST.B   D0
    BNE.S   .lab_0413

.lab_0412:
    MOVEQ   #78,D0
    MOVE.B  D0,CONFIG_MsnRuntimeModeSelectorChar_LRBN

.lab_0413:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_0415

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,_CONFIG_LRBN_FlagChar
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BEQ.S   .lab_0414

    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .lab_0414

    MOVE.B  D0,_CONFIG_LRBN_FlagChar

.lab_0414:
    MOVE.B  _CONFIG_LRBN_FlagChar,D1
    CMP.B   D0,D1
    BEQ.S   .lab_0415

    MOVE.B  D0,_CONFIG_LRBN_FlagChar
    MOVE.W  _CONFIG_BannerCopperHeadByte,D0
    EXT.L   D0
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    JSR     GROUP_AG_JMPTBL_SCRIPT_BeginBannerCharTransition(PC)

    ADDQ.W  #8,A7
    MOVE.B  #'N',_CONFIG_LRBN_FlagChar

.lab_0415:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .lab_0416

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,_CONFIG_MSN_FlagChar
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    PEA     DISKIO_TAG_MSN
    JSR     _GROUP_AI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .lab_0416

    MOVE.B  #'N',_CONFIG_MSN_FlagChar

.lab_0416:
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   .return

    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    MOVE.B  0(A3,D0.W),D1
    MOVE.B  D1,_CTASKS_STR_1
    MOVEQ   #49,D0
    CMP.B   D0,D1
    BEQ.S   .return

    MOVEQ   #50,D2
    CMP.B   D2,D1
    BEQ.S   .return

    MOVE.B  D0,_CTASKS_STR_1

.return:
    MOVE.B  CONFIG_RefreshIntervalMinutes,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    JSR     GROUP_AG_JMPTBL_ESQFUNC_UpdateRefreshModeState(PC)

    MOVE.B  CONFIG_RefreshIntervalMinutes,D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #60,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,_CONFIG_RefreshIntervalSeconds
    MOVEM.L -28(A5),D2/D5-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DISKIO_EnsurePc1MountedAndGfxAssigned   (Routine at DISKIO_EnsurePc1MountedAndGfxAssigned)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A6/A7/D1/D2/D3
; CALLS:
;   _LVOExecute
; READS:
;   Global_REF_DOS_LIBRARY_2, DISKIO_Pc1MountAssignFlag, DISKIO_CMD_MOUNT_PC1, DISKIO_CMD_ASSIGN_GFX_PC1_EXPLICIT
; WRITES:
;   DISKIO_Pc1MountAssignFlag
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO_EnsurePc1MountedAndGfxAssigned:
    MOVEM.L D2-D3,-(A7)
    TST.W   DISKIO_Pc1MountAssignFlag
    BNE.S   DISKIO_EnsurePc1MountedAndGfxAssigned_Return

    MOVE.W  #1,DISKIO_Pc1MountAssignFlag
    LEA     DISKIO_CMD_MOUNT_PC1,A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

    MOVE.L  D2,D3
    LEA     DISKIO_CMD_ASSIGN_GFX_PC1_EXPLICIT,A0
    MOVE.L  A0,D1
    JSR     _LVOExecute(A6)

;------------------------------------------------------------------------------
; FUNC: DISKIO_EnsurePc1MountedAndGfxAssigned_Return   (Routine at DISKIO_EnsurePc1MountedAndGfxAssigned_Return)
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
DISKIO_EnsurePc1MountedAndGfxAssigned_Return:
    MOVEM.L (A7)+,D2-D3
    RTS

;!======

; perhaps dealing with loading or saving configuration?
;------------------------------------------------------------------------------
; FUNC: DISKIO_SaveConfigToFileHandle   (Routine at DISKIO_SaveConfigToFileHandle)
; ARGS:
;   stack +54: arg_1 (via 58(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   _DISKIO_OpenFileWithBuffer, _GROUP_AE_JMPTBL_WDISP_SPrintf, _DISKIO_CloseBufferedFileAndFlush, _DISKIO_WriteBufferedBytes
; READS:
;   BRUSH_LabelScratch, Global_REF_BYTE_NUMBER_OF_COLOR_PALETTES, _Global_REF_STR_USE_24_HR_CLOCK, _CONFIG_BannerCopperHeadByte, Global_STR_DEFAULT_CONFIG_FORMATTED, Global_STR_DF0_CONFIG_DAT_1, DISKIO_SaveConfigToFileHandle_Return, CONFIG_RefreshIntervalMinutes, CTASKS_STR_C, _CONFIG_NicheModeCycleBudget_Y, _CONFIG_NicheModeCycleBudget_Static, CONFIG_SerializedNumericSlot05, CONFIG_NewgridWindowSpanHalfHoursPrimary, CTASKS_STR_G, CONFIG_SerializedFlagSlot08_DefaultN, CTASKS_STR_A, CTASKS_STR_E, CONFIG_SerializedNumericSlot10, _CONFIG_NicheModeCycleBudget_Custom, _CONFIG_NewgridSelectionCode34PrimaryEnabledFlag, CONFIG_NewgridSelectionCode35EnabledFlag, CONFIG_SerializedFlagSlot15_DefaultN, _CONFIG_NewgridSelectionCode34AltEnabledFlag, CONFIG_NewgridSelectionCode32EnabledFlag, CONFIG_RuntimeMode12BannerJumpEnabledFlag, CTASKS_STR_L, CONFIG_SerializedNumericSlot19, CONFIG_SerializedNumericSlot20, _CONFIG_ModeCycleEnabledFlag, _CONFIG_NewgridPlaceholderBevelFlag, _CONFIG_NewgridSelectionCode48_49EnabledFlag, CONFIG_SerializedNumericSlot25, CONFIG_SerializedNumericSlot26, CONFIG_NewgridWindowSpanHalfHoursAlt, _CONFIG_TimeWindowMinutes, _CONFIG_ModeCycleGateDuration, CONFIG_NewgridSelectionCode16EnabledFlag, CONFIG_ParseiniLogoScanEnabledFlag, _ED_DiagTextModeChar, CONFIG_EnsurePc1GfxAssignedFlag, CONFIG_MsnRuntimeModeSelectorChar_LRBN, _CONFIG_LRBN_FlagChar, _CONFIG_MSN_FlagChar, _CTASKS_STR_1, MODE_NEWFILE
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO_SaveConfigToFileHandle:
    LINK.W  A5,#-212
    MOVEM.L D2-D7,-(A7)
    PEA     MODE_NEWFILE.W
    PEA     Global_STR_DF0_CONFIG_DAT_1
    BSR.W   _DISKIO_OpenFileWithBuffer

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    TST.L   D7
    BNE.S   .lab_041B

    MOVEQ   #-1,D0
    BRA.W   DISKIO_SaveConfigToFileHandle_Return

.lab_041B:
    MOVEQ   #67,D6
    MOVEQ   #0,D0
    MOVE.W  _CONFIG_BannerCopperHeadByte,D0
    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    MOVE.L  D0,D5
    MOVE.B  CONFIG_RefreshIntervalMinutes,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.B  CTASKS_STR_C,D1
    EXT.W   D1
    EXT.L   D1
    MOVE.B  _CONFIG_NicheModeCycleBudget_Y,D2
    EXT.W   D2
    EXT.L   D2
    MOVE.B  _CONFIG_NicheModeCycleBudget_Static,D3
    EXT.W   D3
    EXT.L   D3
    MOVE.B  CONFIG_SerializedNumericSlot05,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,40(A7)
    MOVE.B  CONFIG_NewgridWindowSpanHalfHoursPrimary,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,44(A7)
    MOVE.B  CTASKS_STR_G,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,48(A7)
    MOVE.B  CONFIG_SerializedFlagSlot08_DefaultN,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,52(A7)
    MOVE.B  CTASKS_STR_A,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,56(A7)
    MOVE.B  CTASKS_STR_E,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,60(A7)
    MOVE.B  CONFIG_SerializedNumericSlot10,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,64(A7)
    MOVE.B  _CONFIG_NicheModeCycleBudget_Custom,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,68(A7)
    MOVE.B  _CONFIG_NewgridSelectionCode34PrimaryEnabledFlag,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,72(A7)
    MOVE.B  CONFIG_NewgridSelectionCode35EnabledFlag,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,76(A7)
    MOVE.B  CONFIG_SerializedFlagSlot15_DefaultN,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,80(A7)
    MOVE.B  _CONFIG_NewgridSelectionCode34AltEnabledFlag,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,84(A7)
    MOVE.B  CONFIG_NewgridSelectionCode32EnabledFlag,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,88(A7)
    MOVE.B  CONFIG_RuntimeMode12BannerJumpEnabledFlag,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,92(A7)
    MOVE.B  CTASKS_STR_L,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,96(A7)
    MOVE.B  CONFIG_SerializedNumericSlot19,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,100(A7)
    MOVE.B  CONFIG_SerializedNumericSlot20,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,104(A7)
    MOVE.B  _CONFIG_ModeCycleEnabledFlag,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,108(A7)
    MOVE.B  _CONFIG_NewgridPlaceholderBevelFlag,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,112(A7)
    MOVE.B  _CONFIG_NewgridSelectionCode48_49EnabledFlag,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,116(A7)
    MOVE.B  CONFIG_SerializedNumericSlot25,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,120(A7)
    MOVE.B  CONFIG_SerializedNumericSlot26,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,124(A7)
    MOVE.B  CONFIG_NewgridWindowSpanHalfHoursAlt,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,128(A7)
    MOVE.B  CONFIG_NewgridSelectionCode16EnabledFlag,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,132(A7)
    MOVE.B  _Global_REF_STR_USE_24_HR_CLOCK,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,136(A7)
    MOVE.B  CONFIG_ParseiniLogoScanEnabledFlag,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,140(A7)
    MOVE.L  D6,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,144(A7)
    MOVE.L  D5,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,148(A7)
    MOVE.B  Global_REF_BYTE_NUMBER_OF_COLOR_PALETTES,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,152(A7)
    MOVE.B  _ED_DiagTextModeChar,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,156(A7)
    MOVE.B  CONFIG_EnsurePc1GfxAssignedFlag,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,160(A7)
    MOVE.B  CONFIG_MsnRuntimeModeSelectorChar_LRBN,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,164(A7)
    MOVE.B  _CONFIG_LRBN_FlagChar,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,168(A7)
    MOVE.B  _CONFIG_MSN_FlagChar,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,172(A7)
    MOVE.B  _CTASKS_STR_1,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    MOVE.L  176(A7),-(A7)
    PEA     BRUSH_LabelScratch
    MOVE.L  _CONFIG_ModeCycleGateDuration,-(A7)
    MOVE.L  _CONFIG_TimeWindowMinutes,-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  188(A7),-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_DEFAULT_CONFIG_FORMATTED
    PEA     -58(A5)
    JSR     _GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    LEA     176(A7),A7
    PEA     52.W
    PEA     -58(A5)
    MOVE.L  D7,-(A7)
    BSR.W   _DISKIO_WriteBufferedBytes

    MOVE.L  D7,(A7)
    BSR.W   _DISKIO_CloseBufferedFileAndFlush

;------------------------------------------------------------------------------
; FUNC: DISKIO_SaveConfigToFileHandle_Return   (Routine at DISKIO_SaveConfigToFileHandle_Return)
; ARGS:
;   stack +232: arg_1 (via 236(A5))
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
DISKIO_SaveConfigToFileHandle_Return:
    MOVEM.L -236(A5),D2-D7
    UNLK    A5
    RTS

;!======

; Load the configuration
;------------------------------------------------------------------------------
; FUNC: DISKIO_LoadConfigFromDisk   (Routine at DISKIO_LoadConfigFromDisk)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A5/A7/D0/D6/D7
; CALLS:
;   _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, _DISKIO_LoadFileToWorkBuffer, DISKIO_ParseConfigBuffer
; READS:
;   _Global_REF_LONG_FILE_SCRATCH, Global_STR_DF0_CONFIG_DAT_2, Global_STR_DISKIO_C_9, _Global_PTR_WORK_BUFFER
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
DISKIO_LoadConfigFromDisk:
    LINK.W  A5,#-12
    MOVEM.L D6-D7,-(A7)

    PEA     Global_STR_DF0_CONFIG_DAT_2
    BSR.W   _DISKIO_LoadFileToWorkBuffer

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BNE.S   .lab_041E

    MOVEQ   #-1,D6
    BRA.S   .return

.lab_041E:
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,D7
    MOVEA.L _Global_PTR_WORK_BUFFER,A0
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-4(A5)
    BSR.W   DISKIO_ParseConfigBuffer

    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     1344.W
    PEA     Global_STR_DISKIO_C_9
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D6

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7
    UNLK    A5
    RTS
