    XDEF    _DISKIO_EnsurePc1MountedAndGfxAssigned
    XDEF    DISKIO_LoadConfigFromDisk
    XDEF    DISKIO_SaveConfigToFileHandle
    XDEF    DISKIO_EnsurePc1MountedAndGfxAssigned_Return
    XDEF    DISKIO_SaveConfigToFileHandle_Return


;------------------------------------------------------------------------------
; FUNC: _DISKIO_EnsurePc1MountedAndGfxAssigned   (Routine at _DISKIO_EnsurePc1MountedAndGfxAssigned)
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
_DISKIO_EnsurePc1MountedAndGfxAssigned:
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
;   _BRUSH_LabelScratch, _Global_REF_BYTE_NUMBER_OF_COLOR_PALETTES, _Global_REF_STR_USE_24_HR_CLOCK, _CONFIG_BannerCopperHeadByte, _Global_STR_DEFAULT_CONFIG_FORMATTED, _Global_STR_DF0_CONFIG_DAT_1, DISKIO_SaveConfigToFileHandle_Return, _CONFIG_RefreshIntervalMinutes, _CTASKS_STR_C, _CONFIG_NicheModeCycleBudget_Y, _CONFIG_NicheModeCycleBudget_Static, _CONFIG_SerializedNumericSlot05, _CONFIG_NewgridWindowSpanHalfHoursPrimary, _CTASKS_STR_G, _CONFIG_SerializedFlagSlot08_DefaultN, _CTASKS_STR_A, _CTASKS_STR_E, _CONFIG_SerializedNumericSlot10, _CONFIG_NicheModeCycleBudget_Custom, _CONFIG_NewgridSelectionCode34PrimaryEnabledFlag, _CONFIG_NewgridSelectionCode35EnabledFlag, _CONFIG_SerializedFlagSlot15_DefaultN, _CONFIG_NewgridSelectionCode34AltEnabledFlag, _CONFIG_NewgridSelectionCode32EnabledFlag, _CONFIG_RuntimeMode12BannerJumpEnabledFlag, _CTASKS_STR_L, _CONFIG_SerializedNumericSlot19, _CONFIG_SerializedNumericSlot20, _CONFIG_ModeCycleEnabledFlag, _CONFIG_NewgridPlaceholderBevelFlag, _CONFIG_NewgridSelectionCode48_49EnabledFlag, _CONFIG_SerializedNumericSlot25, _CONFIG_SerializedNumericSlot26, _CONFIG_NewgridWindowSpanHalfHoursAlt, _CONFIG_TimeWindowMinutes, _CONFIG_ModeCycleGateDuration, _CONFIG_NewgridSelectionCode16EnabledFlag, _CONFIG_ParseiniLogoScanEnabledFlag, _ED_DiagTextModeChar, _CONFIG_EnsurePc1GfxAssignedFlag, _CONFIG_MsnRuntimeModeSelectorChar_LRBN, _CONFIG_LRBN_FlagChar, _CONFIG_MSN_FlagChar, _CTASKS_STR_1, MODE_NEWFILE
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
    PEA     _Global_STR_DF0_CONFIG_DAT_1
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
    MOVE.B  _CONFIG_RefreshIntervalMinutes,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.B  _CTASKS_STR_C,D1
    EXT.W   D1
    EXT.L   D1
    MOVE.B  _CONFIG_NicheModeCycleBudget_Y,D2
    EXT.W   D2
    EXT.L   D2
    MOVE.B  _CONFIG_NicheModeCycleBudget_Static,D3
    EXT.W   D3
    EXT.L   D3
    MOVE.B  _CONFIG_SerializedNumericSlot05,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,40(A7)
    MOVE.B  _CONFIG_NewgridWindowSpanHalfHoursPrimary,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,44(A7)
    MOVE.B  _CTASKS_STR_G,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,48(A7)
    MOVE.B  _CONFIG_SerializedFlagSlot08_DefaultN,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,52(A7)
    MOVE.B  _CTASKS_STR_A,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,56(A7)
    MOVE.B  _CTASKS_STR_E,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,60(A7)
    MOVE.B  _CONFIG_SerializedNumericSlot10,D4
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
    MOVE.B  _CONFIG_NewgridSelectionCode35EnabledFlag,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,76(A7)
    MOVE.B  _CONFIG_SerializedFlagSlot15_DefaultN,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,80(A7)
    MOVE.B  _CONFIG_NewgridSelectionCode34AltEnabledFlag,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,84(A7)
    MOVE.B  _CONFIG_NewgridSelectionCode32EnabledFlag,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,88(A7)
    MOVE.B  _CONFIG_RuntimeMode12BannerJumpEnabledFlag,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,92(A7)
    MOVE.B  _CTASKS_STR_L,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,96(A7)
    MOVE.B  _CONFIG_SerializedNumericSlot19,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,100(A7)
    MOVE.B  _CONFIG_SerializedNumericSlot20,D4
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
    MOVE.B  _CONFIG_SerializedNumericSlot25,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,120(A7)
    MOVE.B  _CONFIG_SerializedNumericSlot26,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,124(A7)
    MOVE.B  _CONFIG_NewgridWindowSpanHalfHoursAlt,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,128(A7)
    MOVE.B  _CONFIG_NewgridSelectionCode16EnabledFlag,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,132(A7)
    MOVE.B  _Global_REF_STR_USE_24_HR_CLOCK,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,136(A7)
    MOVE.B  _CONFIG_ParseiniLogoScanEnabledFlag,D4
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
    MOVE.B  _Global_REF_BYTE_NUMBER_OF_COLOR_PALETTES,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,152(A7)
    MOVE.B  _ED_DiagTextModeChar,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,156(A7)
    MOVE.B  _CONFIG_EnsurePc1GfxAssignedFlag,D4
    EXT.W   D4
    EXT.L   D4
    MOVE.L  D4,160(A7)
    MOVE.B  _CONFIG_MsnRuntimeModeSelectorChar_LRBN,D4
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
    PEA     _BRUSH_LabelScratch
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
    PEA     _Global_STR_DEFAULT_CONFIG_FORMATTED
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
;   _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, _DISKIO_LoadFileToWorkBuffer, _DISKIO_ParseConfigBuffer
; READS:
;   _Global_REF_LONG_FILE_SCRATCH, _Global_STR_DF0_CONFIG_DAT_2, _Global_STR_DISKIO_C_9, _Global_PTR_WORK_BUFFER
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

    PEA     _Global_STR_DF0_CONFIG_DAT_2
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
    BSR.W   _DISKIO_ParseConfigBuffer

    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     1344.W
    PEA     _Global_STR_DISKIO_C_9
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D6

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7
    UNLK    A5
    RTS
