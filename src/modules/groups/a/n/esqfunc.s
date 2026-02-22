    XDEF    ESQFUNC_AllocateLineTextBuffers
    XDEF    ESQFUNC_CommitSecondaryStateAndPersist
    XDEF    ESQFUNC_DrawDiagnosticsScreen
    XDEF    ESQFUNC_DrawEscMenuVersion
    XDEF    ESQFUNC_DrawMemoryStatusScreen
    XDEF    ESQFUNC_FreeExtraTitleTextPointers
    XDEF    ESQFUNC_FreeLineTextBuffers
    XDEF    ESQFUNC_ProcessUiFrameTick
    XDEF    ESQFUNC_RebuildPwBrushListFromTagTable
    XDEF    ESQFUNC_SelectAndApplyBrushForCurrentEntry
    XDEF    ESQFUNC_ServiceUiTickIfRunning
    XDEF    ESQFUNC_TrimTextToPixelWidthWordBoundary
    XDEF    ESQFUNC_UpdateDiskWarningAndRefreshTick
    XDEF    ESQFUNC_UpdateRefreshModeState
    XDEF    ESQFUNC_WaitForClockChangeAndServiceUi
    XDEF    SETUP_INTERRUPT_INTB_AUD1
    XDEF    SETUP_INTERRUPT_INTB_RBF
    XDEF    SETUP_INTERRUPT_INTB_VERTB
    XDEF    ESQFUNC_JMPTBL_CLEANUP_DrawClockBanner
    XDEF    ESQFUNC_JMPTBL_CLEANUP_ProcessAlerts
    XDEF    ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths
    XDEF    ESQFUNC_JMPTBL_ESQ_ClampBannerCharRange
    XDEF    ESQFUNC_JMPTBL_ESQ_GetHalfHourSlotIndex
    XDEF    ESQFUNC_JMPTBL_ESQ_HandleSerialRbfInterrupt
    XDEF    ESQFUNC_JMPTBL_ESQ_PollCtrlInput
    XDEF    ESQFUNC_JMPTBL_ESQ_TickGlobalCounters
    XDEF    ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit
    XDEF    ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState
    XDEF    ESQFUNC_JMPTBL_LOCAVAIL_RebuildFilterStateFromCurrentGroup
    XDEF    ESQFUNC_JMPTBL_LOCAVAIL_SyncSecondaryFilterForCurrentGroup
    XDEF    ESQFUNC_JMPTBL_PARSEINI_ComputeHTCMaxValues
    XDEF    ESQFUNC_JMPTBL_PARSEINI_MonitorClockChange
    XDEF    ESQFUNC_JMPTBL_PARSEINI_NormalizeClockData
    XDEF    ESQFUNC_JMPTBL_PARSEINI_UpdateCtrlHDeltaMax
    XDEF    ESQFUNC_JMPTBL_P_TYPE_EnsureSecondaryList
    XDEF    ESQFUNC_JMPTBL_P_TYPE_PromoteSecondaryList
    XDEF    ESQFUNC_JMPTBL_SCRIPT_GetCtrlLineFlag
    XDEF    ESQFUNC_JMPTBL_SCRIPT_HandleSerialCtrlCmd
    XDEF    ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit3Flag
    XDEF    ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask
    XDEF    ESQFUNC_JMPTBL_STRING_CopyPadNul
    XDEF    ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh
    XDEF    ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode
    XDEF    ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState
    XDEF    ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines
    XDEF    ESQFUNC_TrimTextToPixelWidthWordBoundary_Return

;!======

;------------------------------------------------------------------------------
; FUNC: SETUP_INTERRUPT_INTB_VERTB   (InstallVerticalBlankInterruptVector)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/A7/D0
; CALLS:
;   ESQIFF_JMPTBL_MEMORY_AllocateMemory, _LVOAddIntVector
; READS:
;   AbsExecBase, ESQFUNC_JMPTBL_ESQ_TickGlobalCounters, Global_REF_INTERRUPT_STRUCT_INTB_VERTB, Global_STR_ESQFUNC_C_1, Global_STR_VERTICAL_BLANK_INT, INTB_VERTB, DATA_WDISP_BSS_LONG_2290, MEMF_PUBLIC
; WRITES:
;   Global_REF_INTERRUPT_STRUCT_INTB_VERTB
; DESC:
;   Allocates and initializes an Interrupt struct for VBLANK and installs it on
;   INTB_VERTB, targeting ESQFUNC_JMPTBL_ESQ_TickGlobalCounters.
; NOTES:
;   Stores the allocated Interrupt pointer in Global_REF_INTERRUPT_STRUCT_INTB_VERTB.
;------------------------------------------------------------------------------
SETUP_INTERRUPT_INTB_VERTB:
    ; Allocate 22 bytes to memory for interrupt struct
    PEA     (MEMF_PUBLIC).W                 ; Memory Type
    PEA     22.W                            ; Bytes to Allocate
    PEA     1159.W                          ; Line Number
    PEA     Global_STR_ESQFUNC_C_1            ; Calling File
    JSR     ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7

    MOVE.L  D0,Global_REF_INTERRUPT_STRUCT_INTB_VERTB
    MOVEA.L D0,A0
    MOVE.B  #$2,8(A0)

    MOVEA.L Global_REF_INTERRUPT_STRUCT_INTB_VERTB,A0
    CLR.B   9(A0)

    MOVEA.L Global_REF_INTERRUPT_STRUCT_INTB_VERTB,A0
    MOVE.L  #Global_STR_VERTICAL_BLANK_INT,10(A0)

    MOVEA.L Global_REF_INTERRUPT_STRUCT_INTB_VERTB,A0
    MOVE.L  #DATA_WDISP_BSS_LONG_2290,14(A0)
    LEA     ESQFUNC_JMPTBL_ESQ_TickGlobalCounters(PC),A0

    MOVEA.L Global_REF_INTERRUPT_STRUCT_INTB_VERTB,A1
    MOVE.L  A0,18(A1)
    MOVEQ   #INTB_VERTB,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAddIntVector(A6)

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SETUP_INTERRUPT_INTB_AUD1   (InstallAud1InterruptVector)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/A7/D0
; CALLS:
;   ESQIFF_JMPTBL_MEMORY_AllocateMemory, _LVOSetIntVector
; READS:
;   AbsExecBase, ESQFUNC_JMPTBL_ESQ_PollCtrlInput, Global_REF_INTERRUPT_STRUCT_INTB_AUD1, Global_STR_ESQFUNC_C_2, Global_STR_JOYSTICK_INT, INTB_AUD1, DATA_COMMON_BSS_LONG_1B04, MEMF_CHIP
; WRITES:
;   Global_REF_INTB_AUD1_INTERRUPT, Global_REF_INTERRUPT_STRUCT_INTB_AUD1
; DESC:
;   Allocates and initializes an Interrupt struct for AUD1 and installs it on
;   INTB_AUD1, targeting ESQFUNC_JMPTBL_ESQ_PollCtrlInput.
; NOTES:
;   Saves the previous vector returned by SetIntVector in Global_REF_INTB_AUD1_INTERRUPT.
;------------------------------------------------------------------------------
SETUP_INTERRUPT_INTB_AUD1:
    ; Allocate 22 bytes to memory for interrupt struct
    PEA     (MEMF_CHIP).W                   ; Memory Type
    PEA     22.W                            ; Bytes to Allocate
    PEA     1172.W                          ; Line Number
    PEA     Global_STR_ESQFUNC_C_2            ; Calling File
    JSR     ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7

    MOVE.L  D0,Global_REF_INTERRUPT_STRUCT_INTB_AUD1
    MOVEA.L D0,A0
    MOVE.B  #$2,8(A0)

    MOVEA.L Global_REF_INTERRUPT_STRUCT_INTB_AUD1,A0
    CLR.B   9(A0)

    MOVEA.L Global_REF_INTERRUPT_STRUCT_INTB_AUD1,A0
    MOVE.L  #Global_STR_JOYSTICK_INT,10(A0)

    MOVEA.L Global_REF_INTERRUPT_STRUCT_INTB_AUD1,A0
    MOVE.L  #DATA_COMMON_BSS_LONG_1B04,14(A0)
    LEA     ESQFUNC_JMPTBL_ESQ_PollCtrlInput(PC),A0

    MOVEA.L Global_REF_INTERRUPT_STRUCT_INTB_AUD1,A1
    MOVE.L  A0,18(A1)
    MOVEQ   #INTB_AUD1,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOSetIntVector(A6)

    MOVE.L  D0,Global_REF_INTB_AUD1_INTERRUPT
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SETUP_INTERRUPT_INTB_RBF   (InstallSerialRbfInterruptVector)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/A7/D0
; CALLS:
;   ESQIFF_JMPTBL_MEMORY_AllocateMemory, _LVOSetIntVector
; READS:
;   AbsExecBase, ESQFUNC_JMPTBL_ESQ_HandleSerialRbfInterrupt, Global_REF_INTB_RBF_64K_BUFFER, Global_REF_INTERRUPT_STRUCT_INTB_RBF, Global_STR_ESQFUNC_C_3, Global_STR_ESQFUNC_C_4, Global_STR_RS232_RECEIVE_HANDLER, INTB_RBF, MEMF_CLEAR, MEMF_PUBLIC
; WRITES:
;   Global_REF_INTB_RBF_64K_BUFFER, Global_REF_INTB_RBF_INTERRUPT, Global_REF_INTERRUPT_STRUCT_INTB_RBF
; DESC:
;   Allocates an Interrupt struct plus a 64k receive buffer and installs the
;   serial receive-full handler vector on INTB_RBF.
; NOTES:
;   Vector target is ESQFUNC_JMPTBL_ESQ_HandleSerialRbfInterrupt.
;------------------------------------------------------------------------------
SETUP_INTERRUPT_INTB_RBF:
    ; Allocate 22 bytes to memory for interrupt struct
    PEA     (MEMF_PUBLIC).W                 ; Memory Type
    PEA     22.W                            ; Bytes to Allocate
    PEA     1195.W                          ; Line Number
    PEA     Global_STR_ESQFUNC_C_3            ; Calling File
    JSR     ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVE.L  D0,Global_REF_INTERRUPT_STRUCT_INTB_RBF

    ; Allocate 64,000 bytes to memory
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)  ; Memory Type
    MOVE.L  #64000,-(A7)                    ; Bytes to Allocate
    PEA     1197.W                          ; Line Number
    PEA     Global_STR_ESQFUNC_C_4            ; Calling File
    JSR     ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     28(A7),A7

    MOVE.L  D0,Global_REF_INTB_RBF_64K_BUFFER

    MOVEA.L Global_REF_INTERRUPT_STRUCT_INTB_RBF,A0
    MOVE.B  #2,8(A0)

    MOVEA.L Global_REF_INTERRUPT_STRUCT_INTB_RBF,A0
    CLR.B   9(A0)

    MOVEA.L Global_REF_INTERRUPT_STRUCT_INTB_RBF,A0
    MOVE.L  #Global_STR_RS232_RECEIVE_HANDLER,10(A0)

    MOVEA.L Global_REF_INTERRUPT_STRUCT_INTB_RBF,A0
    MOVE.L  Global_REF_INTB_RBF_64K_BUFFER,14(A0)

    LEA     ESQFUNC_JMPTBL_ESQ_HandleSerialRbfInterrupt(PC),A0
    MOVEA.L Global_REF_INTERRUPT_STRUCT_INTB_RBF,A1

    ; Setup IntVector on INTB_RBF (interrupt 11 aka "serial port recieve buffer full") pointing to 18(A1)
    MOVE.L  A0,18(A1)
    MOVEQ   #INTB_RBF,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOSetIntVector(A6)

    MOVE.L  D0,Global_REF_INTB_RBF_INTERRUPT
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_AllocateLineTextBuffers   (AllocateLineTextBuffers)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0/D7
; CALLS:
;   ESQIFF_JMPTBL_MEMORY_AllocateMemory
; READS:
;   Global_STR_ESQFUNC_C_5, LADFUNC_LineTextBufferPtrs, MEMF_CLEAR, MEMF_PUBLIC
; WRITES:
;   LADFUNC_LineSlotWriteIndex, LADFUNC_LineSlotSecondaryIndex
; DESC:
;   Allocates 20 line text buffers (60 bytes each), stores pointers in
;   LADFUNC_LineTextBufferPtrs, and resets line-slot indices.
; NOTES:
;   Companion free path is ESQFUNC_FreeLineTextBuffers.
;------------------------------------------------------------------------------
ESQFUNC_AllocateLineTextBuffers:
    LINK.W  A5,#-4
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7

.lab_0964:
    MOVEQ   #20,D0
    CMP.W   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LADFUNC_LineTextBufferPtrs,A0
    ADDA.L  D0,A0

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)     ; Memory Type
    PEA     60.W                                ; Bytes to Allocate
    PEA     1222.W                              ; Line Number
    PEA     Global_STR_ESQFUNC_C_5                ; Calling File
    MOVE.L  A0,20(A7)
    JSR     ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L 4(A7),A0
    MOVE.L  D0,(A0)
    ADDQ.W  #1,D7
    BRA.S   .lab_0964

.return:
    MOVEQ   #0,D0
    MOVE.W  D0,LADFUNC_LineSlotWriteIndex
    MOVE.W  D0,LADFUNC_LineSlotSecondaryIndex
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_FreeLineTextBuffers   (Free and clear LADFUNC line text buffers)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0/D7
; CALLS:
;   ESQIFF_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   Global_STR_ESQFUNC_C_6, LADFUNC_LineTextBufferPtrs
; WRITES:
;   (none observed)
; DESC:
;   Iterates 20 line-text buffer pointers, deallocates each 60-byte buffer, and
;   clears the pointer slot.
; NOTES:
;   Uses Global_STR_ESQFUNC_C_6 as deallocation callsite tag.
;------------------------------------------------------------------------------
ESQFUNC_FreeLineTextBuffers:
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7

.loop_free_line_text_buffers:
    MOVEQ   #20,D0
    CMP.W   D0,D7
    BGE.S   .return_free_line_text_buffers

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LADFUNC_LineTextBufferPtrs,A0
    ADDA.L  D0,A0

    ; Deallocate 60 bytes from A0
    PEA     60.W
    MOVE.L  (A0),-(A7)
    PEA     1235.W
    PEA     Global_STR_ESQFUNC_C_6
    JSR     ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LADFUNC_LineTextBufferPtrs,A0
    ADDA.L  D0,A0
    CLR.L   (A0)
    ADDQ.W  #1,D7
    BRA.S   .loop_free_line_text_buffers

.return_free_line_text_buffers:
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_UpdateDiskWarningAndRefreshTick   (UpdateDiskWarningAndRefreshTick)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0
; CALLS:
;   ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths, ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines
; READS:
;   Global_REF_RASTPORT_2, Global_STR_DISK_0_IS_WRITE_PROTECTED, Global_STR_YOU_MUST_REINSERT_SYSTEM_DISK_INTO_DRIVE_0, WDISP_DisplayContextBase, DISKIO_Drive0WriteProtectedCode, DATA_WDISP_BSS_LONG_231A, Global_RefreshTickCounter
; WRITES:
;   Global_RefreshTickCounter
; DESC:
;   Re-probes drive assignment state and updates the startup warning text path
;   plus Global_RefreshTickCounter based on disk write-protect conditions.
; NOTES:
;   Draws one of two centered warning strings when protected/reinsert states are active.
;------------------------------------------------------------------------------
ESQFUNC_UpdateDiskWarningAndRefreshTick:
    JSR     ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths(PC)

    TST.L   DISKIO_Drive0WriteProtectedCode
    BNE.S   .lab_096B

    TST.L   DATA_WDISP_BSS_LONG_231A
    BNE.S   .lab_096A

    MOVE.W  Global_RefreshTickCounter,D0
    ADDQ.W  #1,D0
    BNE.S   .lab_096C

    CLR.W   Global_RefreshTickCounter
    BRA.S   .lab_096C

.lab_096A:
    MOVE.W  #(-1),Global_RefreshTickCounter
    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     90.W
    PEA     Global_STR_DISK_0_IS_WRITE_PROTECTED
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    LEA     12(A7),A7
    BRA.S   .lab_096C

.lab_096B:
    MOVE.W  #(-1),Global_RefreshTickCounter
    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     90.W
    PEA     Global_STR_YOU_MUST_REINSERT_SYSTEM_DISK_INTO_DRIVE_0
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    LEA     12(A7),A7

.lab_096C:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_WaitForClockChangeAndServiceUi   (Poll clock change while servicing UI tick)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQFUNC_JMPTBL_PARSEINI_MonitorClockChange, ESQFUNC_ServiceUiTickIfRunning
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Repeatedly polls clock-change monitor and services one UI tick until a
;   clock-change event is reported.
; NOTES:
;   Blocks caller until ESQFUNC_JMPTBL_PARSEINI_MonitorClockChange returns non-zero.
;------------------------------------------------------------------------------
ESQFUNC_WaitForClockChangeAndServiceUi:
    JSR     ESQFUNC_JMPTBL_PARSEINI_MonitorClockChange(PC)

    TST.W   D0
    BNE.S   .return

    BSR.W   ESQFUNC_ServiceUiTickIfRunning

    BRA.S   ESQFUNC_WaitForClockChangeAndServiceUi

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_CommitSecondaryStateAndPersist   (Commit promoted state and persist secondary-derived data)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7/D7
; CALLS:
;   DATETIME_SavePairToFile, ESQFUNC_JMPTBL_LOCAVAIL_RebuildFilterStateFromCurrentGroup, ESQFUNC_JMPTBL_P_TYPE_PromoteSecondaryList, ESQPARS_JMPTBL_DISKIO2_FlushDataFilesIfNeeded, ESQPARS_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile, ESQPARS_JMPTBL_P_TYPE_WritePromoIdDataFile, ESQPARS_JMPTBL_LADFUNC_SaveTextAdsToFile, ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty, ESQDISP_PropagatePrimaryTitleMetadataToSecondary, ESQDISP_PromoteSecondaryGroupToPrimary, ESQDISP_PromoteSecondaryLineHeadTailIfMarked, ESQFUNC_UpdateDiskWarningAndRefreshTick
; READS:
;   ESQPARS2_ReadModeFlags, DST_BannerWindowPrimary, LOCAVAIL_PrimaryFilterState, LOCAVAIL_SecondaryFilterState
; WRITES:
;   DATA_ESQDISP_BSS_WORD_1E86, ESQPARS2_ReadModeFlags
; DESC:
;   Temporarily switches parser read mode, promotes/normalizes secondary state into
;   primary structures, persists dependent files, then restores previous read flags.
; NOTES:
;   Performs disk warning refresh after persist operations.
;------------------------------------------------------------------------------
ESQFUNC_CommitSecondaryStateAndPersist:
    MOVE.L  D7,-(A7)
    MOVE.W  ESQPARS2_ReadModeFlags,D7
    MOVE.W  #$100,ESQPARS2_ReadModeFlags
    MOVE.W  #1,DATA_ESQDISP_BSS_WORD_1E86
    BSR.W   ESQDISP_PropagatePrimaryTitleMetadataToSecondary

    JSR     ESQFUNC_JMPTBL_LOCAVAIL_RebuildFilterStateFromCurrentGroup(PC)

    BSR.W   ESQDISP_PromoteSecondaryGroupToPrimary

    BSR.W   ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty

    BSR.W   ESQDISP_PromoteSecondaryLineHeadTailIfMarked

    JSR     ESQPARS_JMPTBL_DISKIO2_FlushDataFilesIfNeeded(PC)

    JSR     ESQPARS_JMPTBL_LADFUNC_SaveTextAdsToFile(PC)

    PEA     LOCAVAIL_SecondaryFilterState
    PEA     LOCAVAIL_PrimaryFilterState
    JSR     ESQPARS_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile(PC)

    PEA     DST_BannerWindowPrimary
    JSR     DATETIME_SavePairToFile(PC)

    JSR     ESQFUNC_JMPTBL_P_TYPE_PromoteSecondaryList(PC)

    JSR     ESQPARS_JMPTBL_P_TYPE_WritePromoIdDataFile(PC)

    BSR.W   ESQFUNC_UpdateDiskWarningAndRefreshTick

    LEA     12(A7),A7
    MOVE.W  D7,ESQPARS2_ReadModeFlags
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_ProcessUiFrameTick   (Process one UI frame tick)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1
; CALLS:
;   ED_DispatchEscMenuState, ESQFUNC_JMPTBL_CLEANUP_ProcessAlerts, ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths, ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh, ESQFUNC_JMPTBL_SCRIPT_HandleSerialCtrlCmd, ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState, ESQDISP_ProcessGridMessagesIfIdle, ESQDISP_RefreshStatusIndicatorsFromCurrentMask, ESQDISP_PollInputModeAndRefreshSelection, ESQFUNC_CommitSecondaryStateAndPersist, ESQIFF_QueueIffBrushLoad, ESQIFF_ServiceExternalAssetSourceState, ESQIFF_PlayNextExternalAssetFrame
; READS:
;   Global_REF_LONG_DF0_LOGO_LST_DATA, Global_REF_LONG_GFX_G_ADS_DATA, LAB_097C, PARSEINI_BannerBrushResourceHead, WDISP_WeatherStatusBrushListHead, CTASKS_IffTaskDoneFlag, ED_DiagGraphModeChar, DATA_ESQDISP_BSS_LONG_1E84, DATA_ESQDISP_BSS_LONG_1E88, DATA_ESQDISP_BSS_WORD_1E89, DATA_ESQFUNC_BSS_BYTE_1EE5, DATA_GCOMMAND_BSS_WORD_1FA9, DATA_GCOMMAND_CONST_WORD_1FB0, Global_UIBusyFlag, CLEANUP_PendingAlertFlag, ESQIFF_ExternalAssetFlags, fffd, fffe
; WRITES:
;   ESQIFF_GAdsBrushListCount, ESQIFF_LogoBrushListCount, DATA_ESQDISP_BSS_LONG_1E88, DATA_ESQDISP_BSS_WORD_1E89, DATA_ESQFUNC_BSS_BYTE_1EE5, ESQIFF_ExternalAssetFlags
; DESC:
;   Runs one UI service slice: optional drive probe, input-mode polling,
;   grid/message pumping, alert processing, serial ctrl handling, brush/source
;   maintenance, and final display/status refresh checks.
; NOTES:
;   Includes multiple gating checks on UI busy flags and pending-alert/task flags.
;------------------------------------------------------------------------------
ESQFUNC_ProcessUiFrameTick:
    TST.W   DATA_GCOMMAND_CONST_WORD_1FB0
    BEQ.S   .lab_0971

    JSR     ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths(PC)

.lab_0971:
    MOVEQ   #1,D0
    CMP.L   DATA_ESQDISP_BSS_LONG_1E84,D0
    BNE.S   .lab_0972

    BSR.W   ESQDISP_PollInputModeAndRefreshSelection

.lab_0972:
    TST.W   Global_UIBusyFlag
    BNE.S   .lab_0973

    JSR     ESQDISP_ProcessGridMessagesIfIdle(PC)

.lab_0973:
    JSR     ED_DispatchEscMenuState(PC)

    TST.W   Global_UIBusyFlag
    BNE.S   .lab_0974

    JSR     ESQFUNC_JMPTBL_SCRIPT_HandleSerialCtrlCmd(PC)

.lab_0974:
    TST.W   CLEANUP_PendingAlertFlag
    BEQ.W   .lab_097C

    JSR     ESQFUNC_JMPTBL_CLEANUP_ProcessAlerts(PC)

    TST.L   DATA_ESQDISP_BSS_LONG_1E88
    BEQ.S   .lab_0975

    CLR.L   DATA_ESQDISP_BSS_LONG_1E88
    BSR.W   ESQFUNC_CommitSecondaryStateAndPersist

.lab_0975:
    TST.W   CTASKS_IffTaskDoneFlag
    BEQ.W   .lab_097C

    BTST    #1,DATA_ESQFUNC_BSS_BYTE_1EE5
    BEQ.S   .lab_0976

    TST.W   Global_UIBusyFlag
    BNE.S   .lab_0976

    BCLR    #1,DATA_ESQFUNC_BSS_BYTE_1EE5
    JSR     ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh(PC)

    BRA.S   .lab_0977

.lab_0976:
    BTST    #0,DATA_ESQFUNC_BSS_BYTE_1EE5
    BEQ.S   .lab_0977

    TST.W   Global_UIBusyFlag
    BNE.S   .lab_0977

    BCLR    #0,DATA_ESQFUNC_BSS_BYTE_1EE5
    PEA     1.W
    JSR     ESQIFF_PlayNextExternalAssetFrame(PC)

    ADDQ.W  #4,A7

.lab_0977:
    TST.L   Global_REF_LONG_DF0_LOGO_LST_DATA
    BNE.S   .lab_0978

    TST.W   Global_UIBusyFlag
    BNE.S   .lab_0978

    MOVE.W  ESQIFF_ExternalAssetFlags,D0
    MOVE.L  D0,D1
    ANDI.W  #$fffd,D1
    MOVE.W  D1,ESQIFF_ExternalAssetFlags

.lab_0978:
    MOVE.B  ED_DiagGraphModeChar,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BEQ.S   .lab_0979

    TST.L   Global_REF_LONG_GFX_G_ADS_DATA
    BNE.S   .lab_0979

    TST.W   Global_UIBusyFlag
    BNE.S   .lab_0979

    MOVE.W  ESQIFF_ExternalAssetFlags,D0
    ANDI.W  #$fffe,D0
    MOVE.W  D0,ESQIFF_ExternalAssetFlags

.lab_0979:
    TST.L   WDISP_WeatherStatusBrushListHead
    BNE.S   .lab_097A

    TST.L   PARSEINI_BannerBrushResourceHead
    BEQ.S   .lab_097A

    CLR.L   -(A7)
    JSR     ESQIFF_QueueIffBrushLoad(PC)

    ADDQ.W  #4,A7

.lab_097A:
    CMPI.L  #$1,ESQIFF_LogoBrushListCount
    BGE.S   .lab_097B

    CLR.L   -(A7)
    JSR     ESQIFF_ServiceExternalAssetSourceState(PC)

    ADDQ.W  #4,A7
    BRA.S   .lab_097C

.lab_097B:
    MOVE.B  ED_DiagGraphModeChar,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BEQ.S   .lab_097C

    CMPI.L  #$2,ESQIFF_GAdsBrushListCount
    BGE.S   .lab_097C

    TST.W   Global_UIBusyFlag
    BNE.S   .lab_097C

    PEA     1.W
    JSR     ESQIFF_ServiceExternalAssetSourceState(PC)

    ADDQ.W  #4,A7

.lab_097C:
    JSR     ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState(PC)

    TST.B   DATA_ESQDISP_BSS_WORD_1E89
    BEQ.S   .return

    TST.B   DATA_GCOMMAND_BSS_WORD_1FA9
    BNE.S   .return

    CLR.B   DATA_ESQDISP_BSS_WORD_1E89
    JSR     ESQDISP_RefreshStatusIndicatorsFromCurrentMask(PC)

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_ServiceUiTickIfRunning   (Gate UI frame service by run flag)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQFUNC_JMPTBL_CLEANUP_ProcessAlerts, ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState, ESQDISP_ProcessGridMessagesIfIdle, ESQFUNC_ProcessUiFrameTick
; READS:
;   DATA_ESQ_BSS_WORD_1DE5, CLEANUP_PendingAlertFlag
; WRITES:
;   (none observed)
; DESC:
;   Calls ESQFUNC_ProcessUiFrameTick only while the main run flag is enabled.
; NOTES:
;   This is the main idle-loop UI tick gate used by ESQ_MainInitAndRun.
;------------------------------------------------------------------------------
ESQFUNC_ServiceUiTickIfRunning:
    TST.W   DATA_ESQ_BSS_WORD_1DE5
    BEQ.S   .return

    BSR.W   ESQFUNC_ProcessUiFrameTick

.return:
    RTS

;!======

    JSR     ESQDISP_ProcessGridMessagesIfIdle(PC)

    TST.W   CLEANUP_PendingAlertFlag
    BEQ.S   .lab_0980

    JSR     ESQFUNC_JMPTBL_CLEANUP_ProcessAlerts(PC)

.lab_0980:
    JSR     ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState(PC)

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_FreeExtraTitleTextPointers   (PruneEntryTextPointersuncertain)
; ARGS:
;   stack +10: maxIndex (D7)
; RET:
;   D0: none
; CLOBBERS:
;   D0/D4-D7/A0-A1
; CALLS:
;   ESQPARS_ReplaceOwnedString (deallocate)
; READS:
;   TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_PrimaryEntryPtrTable, TEXTDISP_PrimaryTitlePtrTable
; WRITES:
;   TEXTDISP_PrimaryTitlePtrTable[entry].field56[] (pointer array cleared)
; DESC:
;   Walks the entry tables and frees extra non-null text pointers up to the
;   given index, leaving the first non-null pointer intact.
; NOTES:
;   The inner loop runs down from min(maxIndex, 34).
;------------------------------------------------------------------------------
ESQFUNC_FreeExtraTitleTextPointers:
    LINK.W  A5,#-20
    MOVEM.L D4-D7,-(A7)

    MOVE.W  10(A5),D7
    MOVEQ   #0,D4

.entry_loop:
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.W   D0,D4
    BGE.S   .return_status

    MOVE.L  D4,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    LEA     TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    MOVEQ   #0,D6
    MOVEQ   #34,D0
    CMP.W   D0,D7
    BGT.S   .cap_limit

    MOVE.L  D7,D0
    EXT.L   D0
    BRA.S   .set_limit

.cap_limit:
    MOVEQ   #34,D0

.set_limit:
    MOVE.L  D0,D5

.slot_loop:
    TST.W   D5
    BMI.S   .next_entry

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    MOVEA.L 56(A0,D0.L),A0
    MOVE.L  A0,-12(A5)
    MOVE.L  A0,D0
    BEQ.S   .next_slot

    TST.W   D6
    BEQ.S   .mark_first_seen

    MOVE.L  A0,-(A7)
    CLR.L   -(A7)
    JSR     ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    CLR.L   56(A0,D0.L)
    BRA.S   .next_slot

.mark_first_seen:
    MOVEQ   #1,D6

.next_slot:
    SUBQ.W  #1,D5
    BRA.S   .slot_loop

.next_entry:
    ADDQ.W  #1,D4
    BRA.S   .entry_loop

.return_status:
    MOVEM.L (A7)+,D4-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_UpdateRefreshModeState   (UpdateRefreshModeState)
; ARGS:
;   stack +8: arg_1 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D7
; CALLS:
;   ESQSHARED4_ComputeBannerRowBlitGeometry
; READS:
;   NEWGRID_MessagePumpSuspendFlag, NEWGRID_LastRefreshRequest
; WRITES:
;   DATA_ESQFUNC_CONST_WORD_1ECD, DATA_ESQPARS2_CONST_WORD_1F53, DATA_ESQPARS2_CONST_WORD_1F54, NEWGRID_RefreshStateFlag, NEWGRID_MessagePumpSuspendFlag, NEWGRID_ModeSelectorState, NEWGRID_LastRefreshRequest
; DESC:
;   Updates NEWGRID refresh/mode selector state from the incoming request flag
;   and recomputes banner blit geometry when message-pump suspension is cleared.
; NOTES:
;   Writes NEWGRID_LastRefreshRequest every call; uses mode 0 vs 2 selector states.
;------------------------------------------------------------------------------
ESQFUNC_UpdateRefreshModeState:
    LINK.W  A5,#0

    MOVE.L  D7,-(A7)
    MOVE.L  12(A5),D7
    MOVE.W  #1,DATA_ESQFUNC_CONST_WORD_1ECD
    TST.L   NEWGRID_MessagePumpSuspendFlag
    BEQ.S   .apply_mode_selector_state

    MOVEQ   #0,D0
    MOVE.L  D0,NEWGRID_RefreshStateFlag
    MOVE.L  D0,NEWGRID_MessagePumpSuspendFlag
    MOVE.W  #$90,DATA_ESQPARS2_CONST_WORD_1F53
    MOVE.W  #$230,DATA_ESQPARS2_CONST_WORD_1F54
    JSR     ESQSHARED4_ComputeBannerRowBlitGeometry

.apply_mode_selector_state:
    TST.L   D7
    BNE.S   .set_mode_selector_two

    MOVEQ   #0,D0
    MOVE.L  D0,NEWGRID_ModeSelectorState
    BRA.S   .store_last_refresh_request

.set_mode_selector_two:
    MOVEQ   #2,D0
    MOVE.L  D0,NEWGRID_ModeSelectorState
    TST.L   NEWGRID_LastRefreshRequest
    BNE.S   .store_last_refresh_request

    CLR.L   NEWGRID_RefreshStateFlag

.store_last_refresh_request:
    MOVE.L  D7,NEWGRID_LastRefreshRequest
    MOVE.L  (A7)+,D7

    UNLK    A5
    RTS

;!======

; Draw the contents of the ESC -> Version screen
;------------------------------------------------------------------------------
; FUNC: ESQFUNC_DrawEscMenuVersion   (Draw ESC->Version screen text and prompt)
; ARGS:
;   stack +77: arg_1 (via 81(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/A7/D0
; CALLS:
;   ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition, GROUP_AM_JMPTBL_WDISP_SPrintf, _LVOSetAPen, _LVOSetDrMd
; READS:
;   Global_LONG_BUILD_NUMBER, Global_LONG_ROM_VERSION_CHECK, Global_PTR_STR_BUILD_ID, Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, Global_STR_BUILD_NUMBER_FORMATTED, Global_STR_PUSH_ANY_KEY_TO_CONTINUE_1, Global_STR_ROM_VERSION_1_3, Global_STR_ROM_VERSION_2_04, Global_STR_ROM_VERSION_FORMATTED
; WRITES:
;   ED_DiagnosticsScreenActive
; DESC:
;   Renders build-number and ROM-version lines using sprintf scratch text, then
;   draws the “push any key” prompt and restores normal APen state.
; NOTES:
;   Uses a shared 81-byte local printf buffer at -81(A5) for both lines.
;   WDISP_SPrintf has no destination-length parameter.
;------------------------------------------------------------------------------
ESQFUNC_DrawEscMenuVersion:

.versionLineBuffer = -81

    LINK.W  A5,#-84

    CLR.W   ED_DiagnosticsScreenActive

    ; Global_REF_RASTPORT_1 seems to be a rastport that's used a lot in here.
    MOVEA.L Global_REF_RASTPORT_1,A1

    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    ; Build "Build Number: '%ld%s'" string
    MOVE.L  Global_PTR_STR_BUILD_ID,-(A7)     ; parameter 2
    MOVE.L  Global_LONG_BUILD_NUMBER,-(A7)    ; parameter 1
    PEA     Global_STR_BUILD_NUMBER_FORMATTED ; format string
    PEA     .versionLineBuffer(A5)          ; result string pointer
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)            ; call printf

    ; Display string at position
    PEA     .versionLineBuffer(A5)          ; string
    PEA     330.W                           ; y
    PEA     175.W                           ; x
    MOVE.L  Global_REF_RASTPORT_1,-(A7)                  ; rastport
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     32(A7),A7

    MOVEQ   #1,D0                           ; Set D0 to 1
    CMP.L   Global_LONG_ROM_VERSION_CHECK,D0  ; And compare Global_LONG_ROM_VERSION_CHECK with it.
    BNE.S   .setRomVersion2_04              ; If it's not equal, jump to LAB_098F

    LEA     Global_STR_ROM_VERSION_1_3,A0     ; Load the effective address of the 1.3 string to A0
    BRA.S   .format_rom_version_line

.setRomVersion2_04:
    LEA     Global_STR_ROM_VERSION_2_04,A0    ; Load the effective address of the 2.04 string to A0

.format_rom_version_line:
    MOVE.L  A0,-(A7)                        ; parameter 1
    PEA     Global_STR_ROM_VERSION_FORMATTED  ; format string
    PEA     .versionLineBuffer(A5)          ; result string pointer
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)            ; call printf

    PEA     .versionLineBuffer(A5)          ; string
    PEA     360.W                           ; y
    PEA     175.W                           ; x
    MOVE.L  Global_REF_RASTPORT_1,-(A7)                  ; rastport
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    PEA     Global_STR_PUSH_ANY_KEY_TO_CONTINUE_1 ; string
    PEA     390.W                           ; y
    PEA     175.W                           ; x
    MOVE.L  Global_REF_RASTPORT_1,-(A7)                  ; rastport
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_DrawMemoryStatusScreen   (DrawMemoryStatusScreen)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1
; CALLS:
;   _LVOSetAPen, _LVOSetDrMd, _LVOAvailMem, GROUP_AM_JMPTBL_WDISP_SPrintf,
;   ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition, ESQFUNC_JMPTBL_PARSEINI_ComputeHTCMaxValues,
;   ESQFUNC_JMPTBL_PARSEINI_UpdateCtrlHDeltaMax
; READS:
;   ED_DiagnosticsScreenActive, ED_DiagnosticsViewMode, ED_DiagAvailMemMask, ESQIFF_ParseAttemptCount, DATACErrs, ESQIFF_LineErrorCount,
;   DATA_WDISP_BSS_WORD_2347/2348/2349, DATA_WDISP_BSS_WORD_228A, Global_WORD_H_VALUE, Global_WORD_T_VALUE,
;   Global_WORD_MAX_VALUE, CTRL_H, CTRL_HPreviousSample, CTRL_HDeltaMax, TEXTDISP_PrimaryGroupCode/TEXTDISP_SecondaryGroupCode,
;   TEXTDISP_PrimaryGroupHeaderCode/TEXTDISP_SecondaryGroupHeaderCode, TEXTDISP_PrimaryGroupPresentFlag/TEXTDISP_SecondaryGroupPresentFlag, DATA_WDISP_BSS_WORD_223C/223B/2244/223D,
;   CLOCK_CurrentDayOfMonth/2275/227E/2277, DST_PrimaryCountdown/227B/225C, DATA_WDISP_BSS_WORD_223E,
;   Global_WORD_CURRENT_HOUR, CLOCK_HalfHourSlotIndex
; WRITES:
;   ED_DiagnosticsScreenActive (early return gate), temporary text buffer on stack
; DESC:
;   Draws the ESC diagnostics memory/status screen with data/CTRL counts,
;   available memory totals, and various clock/calendar diagnostics.
; NOTES:
;   Uses ED_DiagAvailMemMask bitmask to select which memory types to show.
;   Reuses a 72-byte local printf buffer at -72(A5) for all text lines.
;------------------------------------------------------------------------------
; draw the screen showing available memory
ESQFUNC_DrawMemoryStatusScreen:
    LINK.W  A5,#-80
    MOVEM.L D2-D7,-(A7)

    MOVEA.L Global_REF_RASTPORT_1,A0
    MOVE.L  4(A0),-76(A5)
    MOVE.L  #Global_REF_696_400_BITMAP,4(A0)
    TST.W   ED_DiagnosticsScreenActive
    BEQ.W   .return

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    MOVE.W  ED_DiagnosticsViewMode,D0
    BNE.W   .draw_calendar_section

    MOVEQ   #0,D0
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    MOVE.W  DATACErrs,D1
    EXT.L   D1
    MOVE.W  ESQIFF_LineErrorCount,D2
    EXT.L   D2

    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_DATA_CMDS_CERRS_LERRS
    ; Shared 72-byte line buffer for all diagnostics rows in this function.
    PEA     -72(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -72(A5)
    PEA     112.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    MOVEQ   #0,D0
    MOVE.W  DATA_WDISP_BSS_WORD_2347,D0
    MOVE.W  DATA_WDISP_BSS_WORD_2348,D1
    EXT.L   D1
    MOVE.W  DATA_WDISP_BSS_WORD_2349,D2
    EXT.L   D2

    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_CTRL_CMDS_CERRS_LERRS
    PEA     -72(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -72(A5)
    PEA     142.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     68(A7),A7
    MOVEQ   #7,D0
    AND.L   ED_DiagAvailMemMask,D0
    SUBQ.L  #7,D0
    BNE.S   .check_chip_only

    MOVE.L  #$20002,D1          ; Attributes: 0x20000 = Largest
    MOVEA.L AbsExecBase,A6      ; so 0x20002 = Largest | Chip
    JSR     _LVOAvailMem(A6)

    MOVE.L  D0,D7

    MOVEQ   #4,D1               ; Attributes: 0x4 = Fast
    JSR     _LVOAvailMem(A6)

    MOVE.L  D0,D6

    MOVEQ   #2,D1               ; Attributes: 0x2 = Chip
    SWAP    D1
    JSR     _LVOAvailMem(A6)

    MOVE.L  D0,D5

    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    PEA     Global_STR_L_CHIP_FAST_MAX
    PEA     -72(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     20(A7),A7
    BRA.W   .draw_memory_section

.check_chip_only:
    MOVEQ   #1,D0
    AND.L   ED_DiagAvailMemMask,D0
    SUBQ.L  #1,D0
    BNE.S   .check_fast_only

    MOVEQ   #2,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAvailMem(A6)

    MOVE.L  D0,D7
    MOVE.L  D7,-(A7)
    PEA     Global_STR_CHIP_PLACEHOLDER
    PEA     -72(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     12(A7),A7
    BRA.S   .draw_memory_section

.check_fast_only:
    MOVEQ   #2,D0
    AND.L   ED_DiagAvailMemMask,D0
    SUBQ.L  #2,D0
    BNE.S   .check_max_only

    MOVEQ   #4,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAvailMem(A6)

    MOVE.L  D0,D6
    MOVE.L  D6,-(A7)
    PEA     Global_STR_FAST_PLACEHOLDER
    PEA     -72(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     12(A7),A7
    BRA.S   .draw_memory_section

.check_max_only:
    MOVEQ   #4,D0
    AND.L   ED_DiagAvailMemMask,D0
    SUBQ.L  #4,D0
    BNE.S   .show_disabled

    MOVEQ   #2,D1
    SWAP    D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAvailMem(A6)

    MOVE.L  D0,D5
    MOVE.L  D5,-(A7)
    PEA     Global_STR_MAX_PLACEHOLDER
    PEA     -72(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     12(A7),A7
    BRA.S   .draw_memory_section

.show_disabled:
    PEA     Global_STR_MEMORY_TYPES_DISABLED
    PEA     -72(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    ADDQ.W  #8,A7

.draw_memory_section:
    PEA     -72(A5)
    PEA     172.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    MOVEQ   #0,D0
    MOVE.W  DATA_WDISP_BSS_WORD_228A,D0
    MOVE.L  D0,(A7)
    PEA     Global_STR_DATA_OVERRUNS_FORMATTED
    PEA     -72(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -72(A5)
    PEA     202.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    JSR     ESQFUNC_JMPTBL_PARSEINI_ComputeHTCMaxValues(PC)

    MOVE.L  D0,D4
    MOVEQ   #0,D0
    MOVE.W  Global_WORD_H_VALUE,D0
    MOVEQ   #0,D1
    MOVE.W  Global_WORD_T_VALUE,D1
    MOVEQ   #0,D2
    MOVE.W  Global_WORD_MAX_VALUE,D2
    MOVE.L  D2,(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_DATA_H_T_C_MAX_FORMATTED
    PEA     -72(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -72(A5)
    PEA     232.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     76(A7),A7
    JSR     ESQFUNC_JMPTBL_PARSEINI_UpdateCtrlHDeltaMax(PC)

    MOVE.L  D0,D4
    MOVEQ   #0,D0
    MOVE.W  CTRL_H,D0
    MOVEQ   #0,D1
    MOVE.W  CTRL_HPreviousSample,D1
    MOVEQ   #0,D2
    MOVE.W  CTRL_HDeltaMax,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_CTRL_H_T_C_MAX_FORMATTED
    PEA     -72(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -72(A5)
    PEA     262.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     40(A7),A7

.draw_calendar_section:
    MOVE.W  ED_DiagnosticsViewMode,D0
    SUBQ.W  #1,D0
    BNE.W   .return

    MOVEQ   #0,D0
    MOVE.B  TEXTDISP_PrimaryGroupCode,D0
    MOVEQ   #0,D1
    MOVE.B  TEXTDISP_SecondaryGroupCode,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_JULIAN_DAY_NEXT_FORMATTED
    PEA     -72(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -72(A5)                                 ; Text address to display
    PEA     112.W                                   ; X position
    PEA     40.W                                    ; Y position
    MOVE.L  Global_REF_RASTPORT_1,-(A7)               ; Rastport
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    MOVEQ   #0,D0
    MOVE.B  TEXTDISP_PrimaryGroupHeaderCode,D0
    MOVEQ   #0,D1
    MOVE.B  TEXTDISP_SecondaryGroupHeaderCode,D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_JDAY1_JDAY2_FORMATTED
    PEA     -72(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -72(A5)
    PEA     142.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    MOVEQ   #0,D0
    MOVE.B  TEXTDISP_PrimaryGroupPresentFlag,D0
    MOVEQ   #0,D1
    MOVE.B  TEXTDISP_SecondaryGroupPresentFlag,D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_CURCLU_NXTCLU_FORMATTED
    PEA     -72(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     72(A7),A7
    PEA     -72(A5)
    PEA     172.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    MOVE.W  DATA_WDISP_BSS_WORD_223C,D0
    EXT.L   D0
    MOVE.W  DATA_WDISP_BSS_WORD_223B,D1
    EXT.L   D1
    MOVE.W  ESQFUNC_CListLinePointer,D2
    EXT.L   D2
    MOVE.W  DATA_WDISP_BSS_WORD_223D,D3
    EXT.L   D3
    MOVE.L  D3,(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_C_DATE_C_MONTH_LP_YR_FORMATTED
    PEA     -72(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -72(A5)
    PEA     202.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    MOVE.W  CLOCK_CurrentDayOfMonth,D0
    EXT.L   D0
    MOVE.W  CLOCK_CurrentMonthIndex,D1
    EXT.L   D1
    MOVE.W  DATA_WDISP_BSS_WORD_227E,D2
    EXT.L   D2
    MOVE.W  CLOCK_CurrentYearValue,D3
    EXT.L   D3
    MOVE.L  D3,(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_B_DATE_B_MONTH_LP_YR_FORMATTED
    PEA     -72(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     72(A7),A7
    PEA     -72(A5)
    PEA     232.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    MOVE.W  DST_PrimaryCountdown,D0
    EXT.L   D0
    MOVE.W  DST_SecondaryCountdown,D1
    EXT.L   D1
    MOVE.W  WDISP_BannerCharPhaseShift,D2
    EXT.L   D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_C_DST_B_DST_PSHIFT_FORMATTED
    PEA     -72(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -72(A5)
    PEA     262.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    MOVE.W  DATA_WDISP_BSS_WORD_223E,D0
    EXT.L   D0
    MOVE.W  Global_WORD_CURRENT_HOUR,D1
    EXT.L   D1
    MOVEQ   #0,D2
    MOVE.W  CLOCK_HalfHourSlotIndex,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_C_HOUR_B_HOUR_CS_FORMATTED
    PEA     -72(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -72(A5)
    PEA     292.W
    PEA     40.W
    MOVE.L  Global_REF_RASTPORT_1,-(A7)
    JSR     ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     80(A7),A7

.return:
    MOVEA.L Global_REF_RASTPORT_1,A0
    MOVE.L  -76(A5),4(A0)

    MOVEM.L (A7)+,D2-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_DrawDiagnosticsScreen   (DrawDiagnosticsScreenuncertain)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1
; CALLS:
;   _LVOSetFont, ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask,
;   ESQFUNC_JMPTBL_SCRIPT_GetCtrlLineFlag, ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit3Flag,
;   GROUP_AM_JMPTBL_WDISP_SPrintf, ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition,
;   ESQFUNC_JMPTBL_PARSEINI_UpdateCtrlHDeltaMax
; READS:
;   DATA_ESQFUNC_CONST_LONG_1EB6, DATA_SCRIPT_BSS_WORD_2118, DATA_ESQFUNC_STR_CLOSED_ENABLED_1EB8/1EB9, DATA_ESQFUNC_TAG_CLOSED_1EBA/1EBB, DATA_ESQFUNC_STR_CLOSED_ON_AIR_1EBC/1EBD,
;   Global_HANDLE_TOPAZ_FONT, Global_REF_GRAPHICS_LIBRARY, WDISP_DisplayContextBase
; WRITES:
;   ESQ_CopperStatusDigitsA/1E27/1E28/1E29/1E2A, ESQ_CopperStatusDigitsB/1E56/1E57 (status fields),
;   ESQ_CopperStatusDigitsA/1E27/1E28/1E29/1E2A (cleared/initialized), stack buffers
; DESC:
;   Builds and renders the ESC diagnostics screen, selecting status strings
;   based on multiple subsystem checks and a mode selector.
; NOTES:
;   Uses several helper probes (CIA bit/flag reads) to choose message text.
;   Reuses a 132-byte local printf buffer at -132(A5) for every row.
;   Most `%s` arguments in this routine come from fixed static literal tables
;   (status tags, mode names, TRUE/FALSE, AM/PM) rather than mutable buffers.
;------------------------------------------------------------------------------
; Printing of more diagnostic data
ESQFUNC_DrawDiagnosticsScreen:
    LINK.W  A5,#-164
    MOVEM.L D2-D7,-(A7)

    LEA     DATA_ESQFUNC_CONST_LONG_1EB6,A0
    LEA     -148(A5),A1
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.W  #$fff,D0
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E27
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E56
    MOVEQ   #0,D0
    MOVE.W  D0,ESQ_CopperStatusDigitsA
    MOVE.W  D0,ESQ_CopperStatusDigitsB
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E28
    MOVE.W  D0,DATA_ESQ_CONST_WORD_1E57
    MOVE.W  D0,DATA_ESQ_CONST_LONG_1E29
    MOVE.W  D0,DATA_ESQ_CONST_WORD_1E2A

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    MOVEA.L A0,A1
    MOVEA.L Global_HANDLE_TOPAZ_FONT,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    JSR     ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask(PC)

    TST.B   D0
    BEQ.S   .status_a_false

    LEA     DATA_ESQFUNC_STR_CLOSED_ENABLED_1EB8,A0

    BRA.S   .status_a_selected

.status_a_false:
    LEA     DATA_ESQFUNC_STR_OPEN_DISABLED_1EB9,A0

.status_a_selected:
    MOVE.L  A0,24(A7)
    JSR     ESQFUNC_JMPTBL_SCRIPT_GetCtrlLineFlag(PC)

    TST.B   D0
    BEQ.S   .status_b_false

    LEA     DATA_ESQFUNC_TAG_CLOSED_1EBA,A0
    BRA.S   .status_b_selected

.status_b_false:
    LEA     DATA_ESQFUNC_TAG_OPEN_1EBB,A0

.status_b_selected:
    MOVE.L  A0,28(A7)
    JSR     ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit3Flag(PC)

    TST.B   D0
    BEQ.S   .status_c_false

    LEA     DATA_ESQFUNC_STR_CLOSED_ON_AIR_1EBC,A0
    BRA.S   .status_c_selected

.status_c_false:
    LEA     DATA_ESQFUNC_STR_OPEN_OFF_AIR_1EBD,A0

.status_c_selected:
    MOVE.W  DATA_SCRIPT_BSS_WORD_2118,D0
    SUBQ.W  #2,D0
    BNE.S   .select_mode_two

    LEA     DATA_ESQFUNC_STR_ON_AIR_1EBE,A1
    BRA.S   .format_main_line

.select_mode_two:
    MOVE.W  DATA_SCRIPT_BSS_WORD_2118,D0
    SUBQ.W  #1,D0
    BNE.S   .select_mode_one

    LEA     DATA_ESQFUNC_STR_OFF_AIR_1EBF,A1
    BRA.S   .format_main_line

.select_mode_one:
    LEA     DATA_ESQFUNC_STR_NO_DETECT_1EC0,A1

.format_main_line:
    ; `%s` args here are selected from static string literals above:
    ; CartSW, CartREL, VidSW, and on_air tags.
    ; Budget note for -132(A5): conservative max is 85 bytes incl NUL.
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  36(A7),-(A7)
    MOVE.L  36(A7),-(A7)
    PEA     DATA_ESQFUNC_FMT_CARTSW_COLON_PCT_S_CARTREL_COLON_PCT_1EB7
    PEA     -132(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     92.W
    PEA     -132(A5)
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVE.W  SCRIPT_RuntimeMode,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     -148(A5),A0
    ADDA.L  D0,A0
    MOVE.W  ESQPARS2_ReadModeFlags,D0
    EXT.L   D0
    ; Entry-string source is from DATA_ESQFUNC_CONST_LONG_1EB6 (4 static labels).
    ; Budget note for -132(A5): conservative max is 62 bytes incl NUL
    ; (uses 8-digit worst-case for %04X-style hex expansion).
    MOVE.L  D0,(A7)
    MOVE.L  (A0),-(A7)
    PEA     DATA_ESQFUNC_FMT_INSERTIME_PCT_S_WINIT_0X_PCT_04X_1EC1
    PEA     -132(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     110.W
    PEA     -132(A5)
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVEQ   #0,D0
    ; Deferred action countdown/armed are populated in SCRIPT3/ED2 and then
    ; decremented in TEXTDISP_TickDisplayState while armed.
    MOVE.W  TEXTDISP_DeferredActionCountdown,D0
    MOVEQ   #0,D1
    MOVE.W  TEXTDISP_DeferredActionArmed,D1
    ; Layout-coupled LOCAVAIL_PrimaryFilterState longs (+12 then +8).
    MOVE.L  LOCAVAIL_PrimaryFilterState_Field0C,(A7)
    MOVE.L  LOCAVAIL_PrimaryFilterState_Field08,-(A7)
    ; Filter class/step/mode are state-machine outputs from LOCAVAIL_UpdateFilterStateMachine.
    MOVE.L  LOCAVAIL_FilterClassId,-(A7)
    MOVE.L  LOCAVAIL_FilterStep,-(A7)
    MOVE.L  LOCAVAIL_FilterModeFlag,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    ; Budget note for -132(A5): full signed-32 worst-case is 156 bytes incl NUL
    ; (%ld/%d treated as up to 11 chars each), so this row is top guard priority.
    PEA     DATA_ESQFUNC_FMT_LOCAL_MODE_PCT_LD_LOCAL_UPDATE_PCT_L_1EC2
    PEA     -132(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     92(A7),A7
    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     128.W
    PEA     -132(A5)
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    LEA     12(A7),A7
    ; Clock globals are normalized by PARSEINI_NormalizeClockData.
    ; Month/day are 0-based table indexes; month is +1 only when writing RTC.
    MOVE.W  CLOCK_CacheMonthIndex0,D0
    EXT.L   D0
    MOVE.W  CLOCK_CacheDayIndex0,D1
    EXT.L   D1
    MOVE.W  CLOCK_CacheYear,D2
    EXT.L   D2
    MOVE.W  CLOCK_CacheHour,D3
    EXT.L   D3
    MOVE.W  CLOCK_CacheMinuteOrSecond,D4
    EXT.L   D4
    ; Seconds snapshot used by PARSEINI/SCRIPT clock-change detection paths.
    MOVE.W  Global_REF_CLOCKDATA_STRUCT,D5
    EXT.L   D5
    ; AM/PM selector: 0 = AM, non-zero (typically -1) = PM.
    TST.W   CLOCK_CacheAmPmFlag
    BEQ.S   .use_am_suffix

    LEA     DATA_ESQFUNC_STR_PM_1EC4,A0
    BRA.S   .format_clock_line

.use_am_suffix:
    LEA     DATA_ESQFUNC_STR_AM_1EC5,A0

.format_clock_line:
    ; LOCAVAIL cooldown timer: seeded in LOCAVAIL and adjusted/decremented in CLEANUP/APP2 ticks.
    MOVE.W  LOCAVAIL_FilterCooldownTicks,D6
    EXT.L   D6
    MOVE.L  D6,-(A7)
    ; `%s` here is only "am"/"pm".
    MOVE.L  A0,-(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    ; Budget note for -132(A5): full signed-32 worst-case is 146 bytes incl NUL.
    PEA     DATA_ESQFUNC_FMT_CTIME_PCT_02D_SLASH_PCT_02D_SLASH_PC_1EC3
    PEA     -132(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     146.W
    PEA     -132(A5)
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVE.L  #$20002,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAvailMem(A6)

    MOVE.L  D0,76(A7)
    MOVEQ   #4,D1
    JSR     _LVOAvailMem(A6)

    MOVE.L  D0,80(A7)
    MOVEQ   #2,D1
    SWAP    D1
    JSR     _LVOAvailMem(A6)

    MOVE.L  D0,(A7)
    MOVE.L  80(A7),-(A7)
    MOVE.L  80(A7),-(A7)
    ; Budget note for -132(A5): conservative max is 56 bytes incl NUL.
    PEA     DATA_ESQFUNC_FMT_L_CHIP_COLON_PCT_07LD_FAST_COLON_PCT_1EC6
    PEA     -132(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     68(A7),A7
    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     164.W
    PEA     -132(A5)
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    JSR     ESQFUNC_JMPTBL_PARSEINI_ComputeHTCMaxValues(PC)

    MOVE.L  D0,D7
    MOVEQ   #0,D0
    MOVE.W  ESQIFF_ParseAttemptCount,D0
    MOVE.W  DATACErrs,D1
    EXT.L   D1
    MOVE.W  ESQIFF_LineErrorCount,D2
    EXT.L   D2
    MOVEQ   #0,D3
    MOVE.W  Global_WORD_MAX_VALUE,D3
    MOVE.L  D7,(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    ; Budget note for -132(A5): full signed-32 worst-case is 109 bytes incl NUL.
    PEA     DATA_ESQFUNC_FMT_DATA_COLON_CMD_CNT_COLON_PCT_08LD_CR_1EC7
    PEA     -132(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     182.W
    PEA     -132(A5)
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVEQ   #0,D0
    MOVE.W  DATA_WDISP_BSS_WORD_2347,D0
    MOVE.W  DATA_WDISP_BSS_WORD_2348,D1
    EXT.L   D1
    MOVE.W  DATA_WDISP_BSS_WORD_2349,D2
    EXT.L   D2
    MOVEQ   #0,D3
    MOVE.W  CTRL_HDeltaMax,D3
    MOVE.L  D0,72(A7)
    MOVE.L  D1,76(A7)
    MOVE.L  D2,80(A7)
    MOVE.L  D3,84(A7)
    JSR     ESQFUNC_JMPTBL_PARSEINI_UpdateCtrlHDeltaMax(PC)

    MOVE.L  D0,(A7)
    MOVE.L  84(A7),-(A7)
    MOVE.L  84(A7),-(A7)
    MOVE.L  84(A7),-(A7)
    MOVE.L  84(A7),-(A7)
    ; Budget note for -132(A5): full signed-32 worst-case is 110 bytes incl NUL.
    PEA     DATA_ESQFUNC_FMT_CTRL_COLON_CMD_CNT_COLON_PCT_08LD_CR_1EC8
    PEA     -132(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     72(A7),A7
    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     200.W
    PEA     -132(A5)
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    LEA     12(A7),A7
    ; Monotonic diagnostics row counter (increments once per draw).
    ADDQ.L  #1,DATA_ESQFUNC_BSS_LONG_1EB1
    MOVE.W  Global_RefreshTickCounter,D0
    EXT.L   D0
    TST.W   DATA_ESQDISP_BSS_WORD_1E87
    BEQ.S   .set_false_text

    LEA     Global_STR_TRUE_2,A0
    BRA.S   .format_tick_line

.set_false_text:
    LEA     Global_STR_FALSE_2,A0

.format_tick_line:
    ; SCRIPT playback-side command counter (incremented in SCRIPT3 dispatch path).
    MOVE.W  DATA_SCRIPT_BSS_WORD_211C,D1
    EXT.L   D1
    ; ED finite-state id (byte enum set across ED menu handlers).
    MOVE.B  ED_MenuStateId,D2
    EXT.W   D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    ; `%s` here is only Global_STR_TRUE_2 / Global_STR_FALSE_2.
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  DATA_ESQFUNC_BSS_LONG_1EB1,-(A7)
    ; Budget note for -132(A5): full signed-32 worst-case is 142 bytes incl NUL,
    ; driven by four numeric fields plus "%s" TRUE/FALSE token.
    PEA     DATA_ESQFUNC_FMT_PCT_05LD_COLON_PEP_COLON_PCT_LD_REUS_1EC9
    PEA     -132(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    PEA     218.W
    PEA     -132(A5)
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    MOVEA.L A0,A1
    MOVEA.L Global_HANDLE_PREVUEC_FONT,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    MOVEM.L -188(A5),D2-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   TEXTDISP_SetRastForMode
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode:
    JMP     TEXTDISP_SetRastForMode

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_P_TYPE_PromoteSecondaryList   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   P_TYPE_PromoteSecondaryList
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_P_TYPE_PromoteSecondaryList:
    JMP     P_TYPE_PromoteSecondaryList

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DISKIO_ProbeDrivesAndAssignPaths
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths:
    JMP     DISKIO_ProbeDrivesAndAssignPaths

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_PARSEINI_UpdateCtrlHDeltaMax   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   PARSEINI_UpdateCtrlHDeltaMax
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_PARSEINI_UpdateCtrlHDeltaMax:
    JMP     PARSEINI_UpdateCtrlHDeltaMax

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_ESQ_ClampBannerCharRange   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_ClampBannerCharRange
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_ESQ_ClampBannerCharRange:
    JMP     ESQ_ClampBannerCharRange

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit3Flag   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   SCRIPT_ReadHandshakeBit3Flag
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit3Flag:
    JMP     SCRIPT_ReadHandshakeBit3Flag

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   TLIBA3_DrawCenteredWrappedTextLines
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines:
    JMP     TLIBA3_DrawCenteredWrappedTextLines

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_SCRIPT_GetCtrlLineFlag   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   SCRIPT_GetCtrlLineFlag
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_SCRIPT_GetCtrlLineFlag:
    JMP     SCRIPT_GetCtrlLineFlag

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_LOCAVAIL_SyncSecondaryFilterForCurrentGroup   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   LOCAVAIL_SyncSecondaryFilterForCurrentGroup
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_LOCAVAIL_SyncSecondaryFilterForCurrentGroup:
    JMP     LOCAVAIL_SyncSecondaryFilterForCurrentGroup

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   TEXTDISP_ResetSelectionAndRefresh
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh:
    JMP     TEXTDISP_ResetSelectionAndRefresh

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_PARSEINI_MonitorClockChange   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   PARSEINI_MonitorClockChange
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_PARSEINI_MonitorClockChange:
    JMP     PARSEINI_MonitorClockChange

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   LADFUNC_ParseHexDigit
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit:
    JMP     LADFUNC_ParseHexDigit

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_CLEANUP_ProcessAlerts   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   CLEANUP_ProcessAlerts
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_CLEANUP_ProcessAlerts:
    ; Update on-screen alerts and pending timers (cleanup module owns the UI state).
    JMP     CLEANUP_ProcessAlerts

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_ESQ_GetHalfHourSlotIndex   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_GetHalfHourSlotIndex
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_ESQ_GetHalfHourSlotIndex:
    JMP     ESQ_GetHalfHourSlotIndex

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_CLEANUP_DrawClockBanner   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   CLEANUP_DrawClockBanner
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_CLEANUP_DrawClockBanner:
    JMP     CLEANUP_DrawClockBanner

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_PARSEINI_ComputeHTCMaxValues   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   PARSEINI_ComputeHTCMaxValues
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_PARSEINI_ComputeHTCMaxValues:
    JMP     PARSEINI_ComputeHTCMaxValues

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   LADFUNC_UpdateHighlightState
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState:
    JMP     LADFUNC_UpdateHighlightState

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_P_TYPE_EnsureSecondaryList   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   P_TYPE_EnsureSecondaryList
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_P_TYPE_EnsureSecondaryList:
    JMP     P_TYPE_EnsureSecondaryList

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   SCRIPT_ReadHandshakeBit5Mask
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask:
    JMP     SCRIPT_ReadHandshakeBit5Mask

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_PARSEINI_NormalizeClockData   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   PARSEINI_NormalizeClockData
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_PARSEINI_NormalizeClockData:
    JMP     PARSEINI_NormalizeClockData

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_ESQ_TickGlobalCounters   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_TickGlobalCounters
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_ESQ_TickGlobalCounters:
    JMP     ESQ_TickGlobalCounters

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_SCRIPT_HandleSerialCtrlCmd   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   SCRIPT_HandleSerialCtrlCmd
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_SCRIPT_HandleSerialCtrlCmd:
    JMP     SCRIPT_HandleSerialCtrlCmd

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_ESQ_HandleSerialRbfInterrupt   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_HandleSerialRbfInterrupt
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_ESQ_HandleSerialRbfInterrupt:
    JMP     ESQ_HandleSerialRbfInterrupt

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   TEXTDISP_TickDisplayState
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState:
    JMP     TEXTDISP_TickDisplayState

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_ESQ_PollCtrlInput   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_PollCtrlInput
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_ESQ_PollCtrlInput:
    JMP     ESQ_PollCtrlInput

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_LOCAVAIL_RebuildFilterStateFromCurrentGroup   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   LOCAVAIL_RebuildFilterStateFromCurrentGroup
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_LOCAVAIL_RebuildFilterStateFromCurrentGroup:
    JMP     LOCAVAIL_RebuildFilterStateFromCurrentGroup

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_STRING_CopyPadNul   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   STRING_CopyPadNul
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_STRING_CopyPadNul:
    JMP     STRING_CopyPadNul

;!======

    MOVEQ   #97,D0

;!======

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_SelectAndApplyBrushForCurrentEntry   (Select and blit brush for current entry context)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
;   stack +16: arg_3 (via 20(A5))
;   stack +20: arg_4 (via 24(A5))
;   stack +28: arg_5 (via 32(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D1/D2/D4/D5/D6/D7
; CALLS:
;   ESQIFF_JMPTBL_BRUSH_SelectBrushSlot, ESQIFF_JMPTBL_STRING_CompareN, ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex, ESQSHARED_JMPTBL_ESQ_WildcardMatch, ESQIFF_RestoreBasePaletteTriples, _LVOSetRast
; READS:
;   BRUSH_ScriptPrimarySelection, BRUSH_ScriptSecondarySelection, BRUSH_SelectedNode, Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_2, ESQFUNC_BasePaletteRgbTriples, DATA_ESQFUNC_BSS_LONG_1ED0, ESQIFF_BrushIniListHead, DATA_ESQFUNC_TAG_00_1EE6, DATA_ESQFUNC_TAG_11_1EE7, TEXTDISP_ActiveGroupId, WDISP_DisplayContextBase, TEXTDISP_PrimaryEntryPtrTable, TEXTDISP_SecondaryEntryPtrTable, WDISP_PaletteTriplesRBase, TEXTDISP_CurrentMatchIndex, e8
; WRITES:
;   (none observed)
; DESC:
;   Chooses a brush from script selection or brush.ini metadata for the current
;   entry, clears target rastports, blits the brush, and applies palette-copy rules.
; NOTES:
;   Entry tag bytes at `entry+0x2B` steer tag/wildcard lookup paths.
;------------------------------------------------------------------------------
ESQFUNC_SelectAndApplyBrushForCurrentEntry:
    LINK.W  A5,#-32
    MOVEM.L D2/D4-D7,-(A7)
    MOVE.W  10(A5),D7
    MOVE.L  ESQIFF_BrushIniListHead,-4(A5)
    MOVEQ   #0,D5
    TST.W   D7
    BNE.S   .load_secondary_script_selection

    MOVE.L  BRUSH_ScriptPrimarySelection,-24(A5) ; prefer script-selected brush if present
    BRA.S   .resolve_selection_source

.load_secondary_script_selection:
    MOVEA.L BRUSH_ScriptSecondarySelection,A0 ; fall back to secondary slot when requested
    MOVE.L  A0,-24(A5)

.resolve_selection_source:
    TST.L   -24(A5)
    BNE.W   .use_script_selected_brush

    MOVE.W  TEXTDISP_ActiveGroupId,D0
    SUBQ.W  #1,D0
    BNE.S   .load_secondary_current_entry_ptr

    MOVE.W  TEXTDISP_CurrentMatchIndex,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    BRA.S   .compare_entry_tag_00

.load_secondary_current_entry_ptr:
    MOVE.W  TEXTDISP_CurrentMatchIndex,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)

.compare_entry_tag_00:
    MOVEA.L -8(A5),A0
    ADDA.W  #$2b,A0
    PEA     2.W
    PEA     DATA_ESQFUNC_TAG_00_1EE6
    MOVE.L  A0,-(A7)
    JSR     ESQIFF_JMPTBL_STRING_CompareN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .compare_entry_tag_11

    MOVE.L  BRUSH_SelectedNode,-4(A5)
    MOVEQ   #1,D5
    BRA.W   .ensure_fallback_selected_brush

.compare_entry_tag_11:
    MOVEA.L -8(A5),A0
    ADDA.W  #$2b,A0
    PEA     2.W
    PEA     DATA_ESQFUNC_TAG_11_1EE7
    MOVE.L  A0,-(A7)
    JSR     ESQIFF_JMPTBL_STRING_CompareN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .scan_brush_nodes_by_2char_tag

.scan_brush_nodes_by_wildcard_chain:
    TST.L   -4(A5)
    BEQ.S   .fallback_to_type3_or_selected

    TST.L   D5
    BNE.S   .fallback_to_type3_or_selected

    MOVEA.L -4(A5),A0
    MOVE.L  364(A0),-20(A5)

.loop_match_wildcard_list:
    TST.L   -20(A5)
    BEQ.S   .advance_brush_node_chain

    TST.L   D5
    BNE.S   .advance_brush_node_chain

    MOVEA.L -8(A5),A0
    ADDA.W  #12,A0
    MOVE.L  -20(A5),-(A7)
    MOVE.L  A0,-(A7)
    JSR     ESQSHARED_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .advance_wildcard_node

    MOVEQ   #1,D5

.advance_wildcard_node:
    MOVEA.L -20(A5),A0
    MOVE.L  8(A0),-20(A5)
    BRA.S   .loop_match_wildcard_list

.advance_brush_node_chain:
    TST.L   D5
    BNE.S   .scan_brush_nodes_by_wildcard_chain

    MOVEA.L -4(A5),A0
    MOVE.L  368(A0),-4(A5)
    BRA.S   .scan_brush_nodes_by_wildcard_chain

.fallback_to_type3_or_selected:
    TST.L   D5
    BNE.S   .ensure_fallback_selected_brush

    MOVEA.L -8(A5),A0
    BTST    #4,27(A0)
    BEQ.S   .ensure_fallback_selected_brush

    TST.L   DATA_ESQFUNC_BSS_LONG_1ED0
    BEQ.S   .ensure_fallback_selected_brush

    MOVEQ   #1,D5
    MOVE.L  DATA_ESQFUNC_BSS_LONG_1ED0,-4(A5)
    BRA.S   .ensure_fallback_selected_brush

.scan_brush_nodes_by_2char_tag:
    TST.L   -4(A5)
    BEQ.S   .ensure_fallback_selected_brush

    TST.L   D5
    BNE.S   .ensure_fallback_selected_brush

    MOVEA.L -8(A5),A0
    ADDA.W  #$2b,A0
    MOVEA.L -4(A5),A1
    ADDA.W  #$21,A1
    PEA     2.W
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ESQIFF_JMPTBL_STRING_CompareN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .advance_tag_match_node

    MOVEQ   #1,D5

.advance_tag_match_node:
    TST.L   D5
    BNE.S   .scan_brush_nodes_by_2char_tag

    MOVEA.L -4(A5),A0
    MOVE.L  368(A0),-4(A5)
    BRA.S   .scan_brush_nodes_by_2char_tag

.use_script_selected_brush:
    MOVEQ   #1,D5
    MOVE.L  -24(A5),-4(A5)

.ensure_fallback_selected_brush:
    TST.L   D5
    BNE.S   .clear_rastports_before_brush_blit

    MOVE.L  BRUSH_SelectedNode,-4(A5)

.clear_rastports_before_brush_blit:
    MOVEA.L Global_REF_RASTPORT_2,A1
    MOVEQ   #31,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #31,D0
    JSR     _LVOSetRast(A6)

    TST.L   -4(A5)
    BEQ.S   .maybe_copy_brush_palette_segment

    TST.L   BRUSH_SelectedNode
    BNE.S   .blit_selected_brush_to_rast

    TST.L   D5
    BEQ.S   .maybe_copy_brush_palette_segment

.blit_selected_brush_to_rast:
    MOVEQ   #0,D0
    MOVEA.L WDISP_DisplayContextBase,A0
    MOVE.W  2(A0),D0
    SUBQ.L  #1,D0
    MOVEQ   #0,D1
    MOVE.W  4(A0),D1
    SUBQ.L  #1,D1
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  Global_REF_RASTPORT_2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(PC)

    LEA     28(A7),A7

.maybe_copy_brush_palette_segment:
    TST.L   -4(A5)
    BEQ.W   .restore_base_palette_when_no_brush

    MOVEA.L -4(A5),A0
    TST.L   328(A0)
    BEQ.S   .prepare_plane_mask_bounds

    MOVE.L  328(A0),D0
    MOVEQ   #1,D1
    CMP.L   D1,D0
    BEQ.S   .prepare_plane_mask_bounds

    SUBQ.L  #3,D0
    BNE.S   .apply_brush_palette_mode_postprocess

.prepare_plane_mask_bounds:
    PEA     5.W
    JSR     ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    MOVE.L  D1,D4
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  184(A0),D0
    MOVE.L  D0,(A7)
    JSR     ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    MOVEQ   #0,D6
    MOVE.L  D1,-32(A5)

.loop_copy_palette_bytes_from_brush:
    CMP.L   -32(A5),D6
    BGE.S   .apply_brush_palette_mode_postprocess

    CMP.L   D4,D6
    BGE.S   .apply_brush_palette_mode_postprocess

    LEA     WDISP_PaletteTriplesRBase,A0
    ADDA.L  D6,A0
    MOVEA.L -4(A5),A1
    MOVE.L  D6,D0
    ADDI.L  #$e8,D0
    MOVE.B  0(A1,D0.L),(A0)
    ADDQ.L  #1,D6
    BRA.S   .loop_copy_palette_bytes_from_brush

.apply_brush_palette_mode_postprocess:
    MOVEQ   #1,D0
    MOVEA.L -4(A5),A0
    CMP.L   328(A0),D0
    BNE.S   .check_palette_mode_three

    BSR.W   ESQIFF_RestoreBasePaletteTriples

    BRA.S   .return

.check_palette_mode_three:
    MOVEQ   #3,D0
    CMP.L   328(A0),D0
    BNE.S   .return

    MOVEQ   #0,D6

.loop_restore_first_12_palette_bytes:
    MOVEQ   #12,D0
    CMP.L   D0,D6
    BGE.S   .return

    LEA     WDISP_PaletteTriplesRBase,A0
    ADDA.L  D6,A0
    LEA     ESQFUNC_BasePaletteRgbTriples,A1
    ADDA.L  D6,A1
    MOVE.B  (A1),(A0)
    ADDQ.L  #1,D6
    BRA.S   .loop_restore_first_12_palette_bytes

.restore_base_palette_when_no_brush:
    BSR.W   ESQIFF_RestoreBasePaletteTriples

.return:
    MOVEQ   #1,D0
    MOVEM.L (A7)+,D2/D4-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_RebuildPwBrushListFromTagTable   (Rebuild PW brush descriptor/list chain from tag table)
; ARGS:
;   stack +8: arg_1 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A5/A7/D0/D7
; CALLS:
;   ESQIFF_JMPTBL_BRUSH_AllocBrushNode, ESQIFF_JMPTBL_BRUSH_FreeBrushList, ESQIFF_JMPTBL_BRUSH_PopulateBrushList
; READS:
;   ESQFUNC_PwBrushDescriptorHead, ESQFUNC_PwBrushListHead, DATA_ESQFUNC_CONST_LONG_1EDE
; WRITES:
;   ESQFUNC_PwBrushDescriptorHead
; DESC:
;   Frees existing PW brush list, allocates descriptor nodes from a 6-entry tag
;   table, assigns descriptor type bytes, and repopulates runtime brush list.
; NOTES:
;   Uses PC-relative jump-table switch on descriptor index.
;------------------------------------------------------------------------------
ESQFUNC_RebuildPwBrushListFromTagTable:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    CLR.L   -4(A5)
    CLR.L   -(A7)
    PEA     ESQFUNC_PwBrushListHead
    JSR     ESQIFF_JMPTBL_BRUSH_FreeBrushList(PC)

    ADDQ.W  #8,A7
    MOVEQ   #0,D7

.loop_build_pw_brush_descriptors:
    MOVEQ   #6,D0
    CMP.L   D0,D7
    BGE.W   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     DATA_ESQFUNC_CONST_LONG_1EDE,A0
    ADDA.L  D0,A0
    MOVE.L  -4(A5),-(A7)
    MOVE.L  (A0),-(A7)
    JSR     ESQIFF_JMPTBL_BRUSH_AllocBrushNode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    MOVE.L  D7,D0
    CMPI.L  #$6,D0
    BCC.S   .link_pw_descriptor_or_advance

    ADD.W   D0,D0
    MOVE.W  .switch_pw_descriptor_type_case(PC,D0.W),D0
    JMP     .switch_pw_descriptor_type_case+2(PC,D0.W)

; switch/jumptable
.switch_pw_descriptor_type_case:
    DC.W    .set_pw_descriptor_type_08-.switch_pw_descriptor_type_case-2
	DC.W    .set_pw_descriptor_type_09_case1-.switch_pw_descriptor_type_case-2
    DC.W    .set_pw_descriptor_type_09_case2-.switch_pw_descriptor_type_case-2
	DC.W    .set_pw_descriptor_type_09_case3-.switch_pw_descriptor_type_case-2
    DC.W    .set_pw_descriptor_type_09_case4-.switch_pw_descriptor_type_case-2
    DC.W    .set_pw_descriptor_type_09_case5-.switch_pw_descriptor_type_case-2

.set_pw_descriptor_type_08:
    MOVEA.L -4(A5),A0
    MOVE.B  #$8,190(A0)
    BRA.S   .link_pw_descriptor_or_advance

.set_pw_descriptor_type_09_case1:
    MOVEA.L -4(A5),A0
    MOVE.B  #$9,190(A0)
    BRA.S   .link_pw_descriptor_or_advance

.set_pw_descriptor_type_09_case2:
    MOVEA.L -4(A5),A0
    MOVE.B  #$9,190(A0)
    BRA.S   .link_pw_descriptor_or_advance

.set_pw_descriptor_type_09_case3:
    MOVEA.L -4(A5),A0
    MOVE.B  #$9,190(A0)
    BRA.S   .link_pw_descriptor_or_advance

.set_pw_descriptor_type_09_case4:
    MOVEA.L -4(A5),A0
    MOVE.B  #$9,190(A0)
    BRA.S   .link_pw_descriptor_or_advance

.set_pw_descriptor_type_09_case5:
    MOVEA.L -4(A5),A0
    MOVE.B  #$9,190(A0)

.link_pw_descriptor_or_advance:
    TST.L   ESQFUNC_PwBrushDescriptorHead
    BNE.S   .advance_pw_descriptor_index

    MOVE.L  -4(A5),ESQFUNC_PwBrushDescriptorHead

.advance_pw_descriptor_index:
    ADDQ.L  #1,D7
    BRA.W   .loop_build_pw_brush_descriptors

.return:
    PEA     ESQFUNC_PwBrushListHead
    MOVE.L  ESQFUNC_PwBrushDescriptorHead,-(A7)
    JSR     ESQIFF_JMPTBL_BRUSH_PopulateBrushList(PC)

    CLR.L   ESQFUNC_PwBrushDescriptorHead
    MOVE.L  -12(A5),D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_TrimTextToPixelWidthWordBoundary   (Trim text length to fit pixel width at word boundary)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A6/A7/D0/D6/D7
; CALLS:
;   _LVOTextLength
; READS:
;   Global_REF_GRAPHICS_LIBRARY, WDISP_CharClassTable
; WRITES:
;   (none observed)
; DESC:
;   Measures text width and repeatedly shrinks candidate length to a class-3
;   boundary until TextLength(text[0..len]) fits within max pixel width.
; NOTES:
;   Uses WDISP_CharClassTable bit3 as boundary classifier.
;------------------------------------------------------------------------------
ESQFUNC_TrimTextToPixelWidthWordBoundary:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.L  24(A7),D7
    MOVEA.L 28(A7),A2
    MOVEA.L A2,A0

.loop_find_text_nul:
    TST.B   (A0)+
    BNE.S   .loop_find_text_nul

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,D6

.loop_fit_text_to_pixel_width:
    TST.L   D6
    BLE.S   ESQFUNC_TrimTextToPixelWidthWordBoundary_Return

    MOVEA.L A3,A1
    MOVEA.L A2,A0
    MOVE.L  D6,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    CMP.L   D7,D0
    BLE.S   ESQFUNC_TrimTextToPixelWidthWordBoundary_Return

.scan_backward_to_word_boundary:
    SUBQ.L  #1,D6
    TST.L   D6
    BLE.S   .rewind_over_trailing_class3_chars

    MOVE.B  -1(A2,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #3,(A0)
    BEQ.S   .scan_backward_to_word_boundary

.rewind_over_trailing_class3_chars:
    TST.L   D6
    BLE.S   .loop_fit_text_to_pixel_width

    MOVE.B  -1(A2,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #3,(A0)
    BEQ.S   .loop_fit_text_to_pixel_width

    SUBQ.L  #1,D6
    BRA.S   .rewind_over_trailing_class3_chars

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_TrimTextToPixelWidthWordBoundary_Return   (Return tail for pixel-width text trim helper)
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
;   Returns selected text length in D0 and restores saved registers.
; NOTES:
;   Shared return from fit success and lower-bound exits.
;------------------------------------------------------------------------------
ESQFUNC_TrimTextToPixelWidthWordBoundary_Return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS
