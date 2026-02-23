; ==========================================
; ESQ-3.asm disassembly + annotation
; ==========================================

; Set this to 1 to include Ari's custom assembly for dumping debug output.
includeCustomAriAssembly = 0

    include "lvo-offsets.s"
    include "hardware-addresses.s"
    include "structs.s"
    include "macros.s"
    include "string-macros.s"
    include "text-formatting.s"
    include "interrupts/constants.s"

    SECTION S_0,CODE

; Some values of importance
DesiredMemoryAvailability        = 8388608  ; 8 MiBytes

Global_ScratchPtr_592            = -592
Global_UNKNOWN36_MessagePtr      = Global_ScratchPtr_592                         ; -592
Global_WBStartupWindowPtr        = Global_ScratchPtr_592-Type_Long_Size          ; -596
Global_SavedStackPointer         = Global_WBStartupWindowPtr-Type_Long_Size      ; -600
Global_SavedMsg                  = Global_SavedStackPointer-Type_Long_Size       ; -604
Global_SavedExecBase             = Global_SavedMsg-Type_Long_Size                ; -608
Global_SavedDirLock              = Global_SavedExecBase-Type_Long_Size           ; -612
Global_SignalCallbackPtr         = Global_SavedDirLock-Type_Long_Size            ; -616
Global_ExitHookPtr               = Global_SignalCallbackPtr-Type_Long_Size       ; -620
Global_DosIoErr                  = -640
Global_CommandLineSize           = -660
Global_WBStartupCmdBuffer        = Global_CommandLineSize-Type_Long_Size         ; -664
Global_UNKNOWN36_RequesterText2  = -684
Global_UNKNOWN36_RequesterText1  = -704
Global_UNKNOWN36_RequesterOutPtr = -712
Global_UNKNOWN36_RequesterText0  = -724
Global_StreamBufferAllocSize      = -748
Global_CharClassTable            = -1007
Global_AllocBlockSize            = -1012
Global_DefaultHandleFlags        = Global_AllocBlockSize-Type_Long_Size          ; -1016
;------------------------------------------------------------------------------
; SYM: Global_PreallocHandleNode0/1/2   (startup preallocated handle nodes)
; TYPE: struct array (34-byte node stride)
; PURPOSE: Early handle-state nodes used before/alongside dynamic handle nodes.
; USED BY: ESQ_ParseCommandLineAndRun, HANDLE_OpenWithMode,
;          BUFFER_FlushAllAndCloseWithCode, STREAM_BufferedWriteString
; NOTES: Field meanings are partial/inferred:
;        +0 next, +4 cursor, +8 read remaining, +12 write remaining,
;        +16 base ptr, +20 capacity, +24 open flags, +26 mode flags byte,
;        +27 status flags byte, +28 handle index, +32 inline-byte scratch.
;        Confidence:
;        - Confirmed by direct multi-caller usage: +0/+4/+8/+12/+16/+20/+24/+28.
;        - Provisional naming: +26 ModeFlags and +27 StateFlags bit semantics.
;        Open-mask constants below are behavior-derived from STREAM paths and
;        should stay conservative until additional traces validate intent.
;------------------------------------------------------------------------------
Struct_PreallocHandleNode__Next          = 0
Struct_PreallocHandleNode__BufferCursor  = 4
Struct_PreallocHandleNode__ReadRemaining = 8
Struct_PreallocHandleNode__WriteRemaining = 12
Struct_PreallocHandleNode__BufferBase    = 16
Struct_PreallocHandleNode__BufferCapacity = 20
Struct_PreallocHandleNode__OpenFlags     = 24
Struct_PreallocHandleNode__ModeFlags     = 26
Struct_PreallocHandleNode__StateFlags    = 27
Struct_PreallocHandleNode__HandleIndex   = 28
Struct_PreallocHandleNode__InlineByte    = 32
Struct_PreallocHandleNode_Size           = 34
Struct_PreallocHandleNode_StateFlag_WritePending_Bit = 1
Struct_PreallocHandleNode_StateFlag_Unbuffered_Bit = 2
Struct_PreallocHandleNode_StateFlag_EofOrShort_Bit = 4
Struct_PreallocHandleNode_StateFlag_IoError_Bit = 5
Struct_PreallocHandleNode_ModeFlag_TextTranslate_Bit = 7
Struct_PreallocHandleNode_ModeFlag_PreWriteScan_Bit = 6
Struct_PreallocHandleNode_OpenMask_WriteReject = $31
Struct_PreallocHandleNode_OpenMask_FlushReject = $30
Struct_PreallocHandleNode_OpenMask_ReadReject = $32
Global_PreallocHandleNode0              = -1120
Global_HandleTableFlags                 = Global_PreallocHandleNode0-Type_Long_Size ; -1124
Global_AllocBytesTotal           = Global_HandleTableFlags-Type_Long_Size        ; -1128
Global_AllocListHead             = Global_AllocBytesTotal-Type_Long_Size         ; -1132
Global_MemListFirstAllocNode     = -1144
Global_HandleTableCount          = Global_MemListFirstAllocNode-Type_Long_Size   ; -1148
Global_PreallocHandleNode0_OpenFlags = Global_PreallocHandleNode0+Struct_PreallocHandleNode__OpenFlags ; -1096
Global_PreallocHandleNode0_HandleIndex = Global_PreallocHandleNode0+Struct_PreallocHandleNode__HandleIndex ; -1092
Global_PreallocHandleNode1       = Global_PreallocHandleNode0+Struct_PreallocHandleNode_Size ; -1086
Global_PreallocHandleNode1_BufferCursor = Global_PreallocHandleNode1+Struct_PreallocHandleNode__BufferCursor ; -1082
Global_PreallocHandleNode1_WriteRemaining = Global_PreallocHandleNode1+Struct_PreallocHandleNode__WriteRemaining ; -1074
Global_PreallocHandleNode1_BufferBudget = Global_PreallocHandleNode1_WriteRemaining ; legacy alias
Global_PreallocHandleNode1_OpenFlags = Global_PreallocHandleNode1+Struct_PreallocHandleNode__OpenFlags ; -1062
Global_PreallocHandleNode1_HandleIndex = Global_PreallocHandleNode1+Struct_PreallocHandleNode__HandleIndex ; -1058
Global_PreallocHandleNode2       = Global_PreallocHandleNode1+Struct_PreallocHandleNode_Size ; -1052
Global_PreallocHandleNode2_OpenFlags = Global_PreallocHandleNode2+Struct_PreallocHandleNode__OpenFlags ; -1028
Global_PreallocHandleNode2_HandleIndex = Global_PreallocHandleNode2+Struct_PreallocHandleNode__HandleIndex ; -1024
Global_GraphicsLibraryBase_A4    = Global_REF_GRAPHICS_LIBRARY-A4_Base           ; -22440
; Keep canonical literal, but verify provenance at assemble time.

    ; These values should be equal.
    PRINTV 22492
    PRINTV Global_PTR_DATA_ESQFUNC_STR_VIDEO_INSERTION_STOP_1EB5
Global_HandleTableBase           = 22492

Global_HandleEntry0_Flags        = Global_HandleTableBase+Struct_HandleEntry__Flags
Global_HandleEntry0_Ptr          = Global_HandleTableBase+Struct_HandleEntry__Ptr
Global_HandleEntry1_Flags        = Global_HandleTableBase+Struct_HandleEntry_Size+Struct_HandleEntry__Flags
Global_HandleEntry1_Ptr          = Global_HandleTableBase+Struct_HandleEntry_Size+Struct_HandleEntry__Ptr
Global_HandleEntry2_Flags        = Global_HandleEntry1_Flags+Struct_HandleEntry_Size
Global_HandleEntry2_Ptr          = Global_HandleEntry1_Ptr+Struct_HandleEntry_Size
Global_PrintfBufferPtr           = Global_HandleTableBase+320                    ; 22812
Global_PrintfByteCount           = Global_PrintfBufferPtr+Type_Long_Size         ; 22816
Global_FormatCallbackBufferPtr   = Global_PrintfByteCount+Type_Long_Size         ; 22820
Global_FormatCallbackByteCount   = Global_FormatCallbackBufferPtr+Type_Long_Size ; 22824
Global_AppErrorCode              = Global_FormatCallbackByteCount+Type_Long_Size ; 22828
Global_DosLibrary                = Global_AppErrorCode+Type_Long_Size            ; 22832
Global_MemListHead               = Global_DosLibrary+Type_Long_Size              ; 22836
Global_MemListTail               = Global_MemListHead+Type_Long_Size             ; 22840
Global_FormatBufferPtr2          = Global_MemListTail+8                          ; 22848
Global_FormatByteCount2          = Global_FormatBufferPtr2+Type_Long_Size        ; 22852
Global_ConsoleNameBuffer         = Global_FormatByteCount2+Type_Long_Size        ; 22856
Global_ArgCount                  = Global_ConsoleNameBuffer+58                   ; 22914
Global_ArgvPtr                   = Global_ArgCount+Type_Long_Size                ; 22918
Global_ArgvStorage               = Global_ArgvPtr+Type_Long_Size                 ; 22922

; A4-based globals (WDISP/TEXTDISP/SCRIPT/ESQIFF offsets).
A4_Base = Global_REF_LONG_FILE_SCRATCH   ; 32768
; BEGIN A4_GLOBALS_AUTOGEN
Global_DISPTEXT_InsetNibbleSecondary     = DISPTEXT_InsetNibbleSecondary - A4_Base ; suffix $21B2
Global_CLEANUP_AlignedInsetNibblePrimary = CLEANUP_AlignedInsetNibblePrimary - A4_Base ; suffix $21B3
Global_CLEANUP_AlignedInsetNibbleSecondary = CLEANUP_AlignedInsetNibbleSecondary - A4_Base ; suffix $21B4
Global_CTASKS_IffTaskSegListBPTR         = CTASKS_IffTaskSegListBPTR - A4_Base ; suffix $21B6
Global_CTASKS_IffTaskProcPtr             = CTASKS_IffTaskProcPtr - A4_Base ; suffix $21B7
Global_CTASKS_CloseTaskSegListBPTR       = CTASKS_CloseTaskSegListBPTR - A4_Base ; suffix $21B9
Global_CTASKS_CloseTaskProcPtr           = CTASKS_CloseTaskProcPtr - A4_Base ; suffix $21BA
Global_DISKIO2_InteractiveTransferArmedFlag = DISKIO2_InteractiveTransferArmedFlag - A4_Base ; suffix $21BD
Global_DISKIO2_TransferFilenameExtPtr    = DISKIO2_TransferFilenameExtPtr - A4_Base ; suffix $21C3
Global_DISKIO2_TransferSizeTokenBuffer   = DISKIO2_TransferSizeTokenBuffer - A4_Base ; suffix $21C4
Global_DISPTEXT_ControlMarkerWidthPx     = DISPTEXT_ControlMarkerWidthPx - A4_Base ; suffix $21DA
Global_ED_SavedCtasksIntervalByte        = ED_SavedCtasksIntervalByte - A4_Base ; suffix $21E7
Global_ED_TempCopyOffset                 = ED_TempCopyOffset - A4_Base ; suffix $21EF
Global_ED_EditBufferScratch              = ED_EditBufferScratch - A4_Base ; suffix $21F1
Global_ED_EditBufferLive                 = ED_EditBufferLive - A4_Base ; suffix $21F8
Global_WDISP_BannerWorkRasterPtr         = WDISP_BannerWorkRasterPtr - A4_Base ; suffix $222A
Global_TEXTDISP_PrimaryEntryPtrTable     = TEXTDISP_PrimaryEntryPtrTable - A4_Base ; suffix $2234
Global_CLOCK_DaySlotIndex                = CLOCK_DaySlotIndex - A4_Base ; suffix $223B
Global_DST_PrimaryCountdown              = DST_PrimaryCountdown - A4_Base ; suffix $2242
Global_TEXTDISP_AliasPtrTable            = TEXTDISP_AliasPtrTable - A4_Base ; suffix $2250
Global_LADFUNC_LineSlotWriteIndex        = LADFUNC_LineSlotWriteIndex - A4_Base ; suffix $2255
Global_LADFUNC_LineControlCodeTable      = LADFUNC_LineControlCodeTable - A4_Base ; suffix $225C
Global_NEWGRID_RefreshStateFlag          = NEWGRID_RefreshStateFlag - A4_Base ; suffix $2260
Global_LADFUNC_EntryCount                = LADFUNC_EntryCount - A4_Base ; suffix $2266
Global_CLOCK_HalfHourSlotIndex           = CLOCK_HalfHourSlotIndex - A4_Base ; suffix $2271
Global_DST_SecondaryCountdown            = DST_SecondaryCountdown - A4_Base ; suffix $227C
Global_WDISP_WeatherStatusCountdown      = WDISP_WeatherStatusCountdown - A4_Base ; suffix $2280
Global_CTRL_BufferedByteCount            = CTRL_BufferedByteCount - A4_Base ; suffix $2284
Global_ESQPARS_SelectionSuffixBuffer     = ESQPARS_SelectionSuffixBuffer - A4_Base ; suffix $2298
Global_ESQIFF_StatusPacketReadyFlag      = ESQIFF_StatusPacketReadyFlag - A4_Base ; suffix $2299
Global_ESQIFF_RecordBufferPtr            = ESQIFF_RecordBufferPtr - A4_Base ; suffix $229B
Global_ESQPARS_SelectionMatchCode        = ESQPARS_SelectionMatchCode - A4_Base ; suffix $22A0
Global_TEXTDISP_DeferredActionDelayTicks = TEXTDISP_DeferredActionDelayTicks - A4_Base ; suffix $22A5
Global_GCOMMAND_HighlightMessageSlotTable = GCOMMAND_HighlightMessageSlotTable - A4_Base ; suffix $22A6
Global_ESQDISP_HighlightBitmapTable      = ESQDISP_HighlightBitmapTable - A4_Base ; suffix $22A7
Global_ESQIFF_PendingExternalBrushNode   = ESQIFF_PendingExternalBrushNode - A4_Base ; suffix $22A8
Global_ESQIFF_LogoListLineIndex          = ESQIFF_LogoListLineIndex - A4_Base ; suffix $22AC
Global_ESQIFF_GAdsListLineIndex          = ESQIFF_GAdsListLineIndex - A4_Base ; suffix $22AD
Global_WDISP_PaletteDepthLog2            = WDISP_PaletteDepthLog2 - A4_Base ; suffix $22AE
Global_ESQIFF_ExternalAssetStateTable    = ESQIFF_ExternalAssetStateTable - A4_Base ; suffix $22C2
Global_ESQIFF_ExternalAssetPathCommaFlag = ESQIFF_ExternalAssetPathCommaFlag - A4_Base ; suffix $22C3
Global_GCOMMAND_NicheTextPen             = GCOMMAND_NicheTextPen - A4_Base ; suffix $22CD
Global_GCOMMAND_NicheFramePen            = GCOMMAND_NicheFramePen - A4_Base ; suffix $22CE
Global_GCOMMAND_NicheEditorLayoutPen     = GCOMMAND_NicheEditorLayoutPen - A4_Base ; suffix $22CF
Global_GCOMMAND_NicheEditorRowPen        = GCOMMAND_NicheEditorRowPen - A4_Base ; suffix $22D0
Global_GCOMMAND_NicheModeCycleCount      = GCOMMAND_NicheModeCycleCount - A4_Base ; suffix $22D1
Global_GCOMMAND_NicheForceMode5Flag      = GCOMMAND_NicheForceMode5Flag - A4_Base ; suffix $22D2
Global_GCOMMAND_NicheWorkflowMode        = GCOMMAND_NicheWorkflowMode - A4_Base ; suffix $22D3
Global_GCOMMAND_MplexModeCycleCount      = GCOMMAND_MplexModeCycleCount - A4_Base ; suffix $22D6
Global_GCOMMAND_MplexSearchRowLimit      = GCOMMAND_MplexSearchRowLimit - A4_Base ; suffix $22D7
Global_GCOMMAND_MplexClockOffsetMinutes  = GCOMMAND_MplexClockOffsetMinutes - A4_Base ; suffix $22D8
Global_GCOMMAND_MplexMessageTextPen      = GCOMMAND_MplexMessageTextPen - A4_Base ; suffix $22D9
Global_GCOMMAND_MplexMessageFramePen     = GCOMMAND_MplexMessageFramePen - A4_Base ; suffix $22DA
Global_GCOMMAND_MplexEditorLayoutPen     = GCOMMAND_MplexEditorLayoutPen - A4_Base ; suffix $22DB
Global_GCOMMAND_MplexEditorRowPen        = GCOMMAND_MplexEditorRowPen - A4_Base ; suffix $22DC
Global_GCOMMAND_MplexDetailLayoutPen     = GCOMMAND_MplexDetailLayoutPen - A4_Base ; suffix $22DD
Global_GCOMMAND_MplexDetailInitialLineIndex = GCOMMAND_MplexDetailInitialLineIndex - A4_Base ; suffix $22DE
Global_GCOMMAND_MplexDetailRowPen        = GCOMMAND_MplexDetailRowPen - A4_Base ; suffix $22DF
Global_GCOMMAND_MplexWorkflowMode        = GCOMMAND_MplexWorkflowMode - A4_Base ; suffix $22E0
Global_GCOMMAND_MplexDetailLayoutFlag    = GCOMMAND_MplexDetailLayoutFlag - A4_Base ; suffix $22E1
Global_GCOMMAND_PpvModeCycleCount        = GCOMMAND_PpvModeCycleCount - A4_Base ; suffix $22E5
Global_GCOMMAND_PpvMessageTextPen        = GCOMMAND_PpvMessageTextPen - A4_Base ; suffix $22E8
Global_GCOMMAND_PpvMessageFramePen       = GCOMMAND_PpvMessageFramePen - A4_Base ; suffix $22E9
Global_GCOMMAND_PpvShowtimesWorkflowMode = GCOMMAND_PpvShowtimesWorkflowMode - A4_Base ; suffix $22EF
Global_GCOMMAND_PpvDetailLayoutFlag      = GCOMMAND_PpvDetailLayoutFlag - A4_Base ; suffix $22F0
Global_GCOMMAND_PpvShowtimesRowSpan      = GCOMMAND_PpvShowtimesRowSpan - A4_Base ; suffix $22F3
Global_GCOMMAND_BannerRowIndexCurrent    = GCOMMAND_BannerRowIndexCurrent - A4_Base ; suffix $230D
Global_DISKIO_Drive0WriteProtectedCode   = DISKIO_Drive0WriteProtectedCode - A4_Base ; suffix $2319
Global_ED_StateRingTable                 = ED_StateRingTable - A4_Base ; suffix $231E
Global_LOCAVAIL_PrimaryFilterState       = LOCAVAIL_PrimaryFilterState - A4_Base ; suffix $2322
Global_LOCAVAIL_SecondaryFilterState     = LOCAVAIL_SecondaryFilterState - A4_Base ; suffix $2325
Global_NEWGRID_ColumnWidthPx             = NEWGRID_ColumnWidthPx - A4_Base ; suffix $232C
Global_NEWGRID_ShowtimeBucketEntryTable  = NEWGRID_ShowtimeBucketEntryTable - A4_Base ; suffix $2337
Global_NEWGRID_ShowtimeBucketCount       = NEWGRID_ShowtimeBucketCount - A4_Base ; suffix $233A
Global_PARSEINI_WeatherBrushNodePtr      = PARSEINI_WeatherBrushNodePtr - A4_Base ; suffix $233E
Global_GCOMMAND_GradientPresetTable      = GCOMMAND_GradientPresetTable - A4_Base ; suffix $233F (currently traced as parse-time staging table)
Global_SCRIPT_CtrlLineAssertedTicks      = SCRIPT_CtrlLineAssertedTicks - A4_Base ; suffix $2343
Global_SCRIPT_CtrlCmdCount               = SCRIPT_CtrlCmdCount - A4_Base ; suffix $2347
Global_SCRIPT_CtrlCmdChecksumErrorCount  = SCRIPT_CtrlCmdChecksumErrorCount - A4_Base ; suffix $2348
Global_SCRIPT_CtrlCmdLengthErrorCount    = SCRIPT_CtrlCmdLengthErrorCount - A4_Base ; suffix $2349
Global_SCRIPT_ChannelRangeDigitChar      = SCRIPT_ChannelRangeDigitChar - A4_Base ; suffix $234F
Global_SCRIPT_SearchMatchCountOrIndex    = SCRIPT_SearchMatchCountOrIndex - A4_Base ; suffix $2350
Global_SCRIPT_BannerTransitionTargetChar = SCRIPT_BannerTransitionTargetChar - A4_Base ; suffix $2352
Global_SCRIPT_BannerTransitionStepDelta  = SCRIPT_BannerTransitionStepDelta - A4_Base ; suffix $2353
Global_SCRIPT_BannerTransitionStepSign   = SCRIPT_BannerTransitionStepSign - A4_Base ; suffix $2354
Global_SCRIPT_ChannelRangeArmedFlag      = SCRIPT_ChannelRangeArmedFlag - A4_Base ; suffix $2357
Global_TEXTDISP_FilterCandidateCursor    = TEXTDISP_FilterCandidateCursor - A4_Base ; suffix $2358
Global_TEXTDISP_FilterChannelSlotIndex   = TEXTDISP_FilterChannelSlotIndex - A4_Base ; suffix $2359
Global_TEXTDISP_FilterMatchCount         = TEXTDISP_FilterMatchCount - A4_Base ; suffix $235A
Global_TEXTDISP_FilterPpvSbeMatchFlag    = TEXTDISP_FilterPpvSbeMatchFlag - A4_Base ; suffix $235B
Global_TEXTDISP_FilterSportsMatchFlag    = TEXTDISP_FilterSportsMatchFlag - A4_Base ; suffix $235C
Global_TEXTDISP_StatusGroupId            = TEXTDISP_StatusGroupId - A4_Base ; suffix $235D
Global_TEXTDISP_SourceConfigEntryTable   = TEXTDISP_SourceConfigEntryTable - A4_Base ; suffix $235E
Global_TEXTDISP_SourceConfigEntryCount   = TEXTDISP_SourceConfigEntryCount - A4_Base ; suffix $235F
Global_TEXTDISP_PrimaryFirstMatchIndex   = TEXTDISP_PrimaryFirstMatchIndex - A4_Base ; suffix $2360
Global_TEXTDISP_SecondaryFirstMatchIndex = TEXTDISP_SecondaryFirstMatchIndex - A4_Base ; suffix $2361
Global_TEXTDISP_EntryTextBaseWidthPx     = TEXTDISP_EntryTextBaseWidthPx - A4_Base ; suffix $2362
Global_ESQ_GlobalTickCounter             = ESQ_GlobalTickCounter - A4_Base ; suffix $2363
Global_TEXTDISP_CurrentMatchIndex        = TEXTDISP_CurrentMatchIndex - A4_Base ; suffix $2365
Global_CLEANUP_AlignedStatusSuffixBuffer = CLEANUP_AlignedStatusSuffixBuffer - A4_Base ; suffix $2367
Global_CLEANUP_AlignedStatusMatchIndex   = CLEANUP_AlignedStatusMatchIndex - A4_Base ; suffix $2369
Global_TEXTDISP_CandidateIndexList       = TEXTDISP_CandidateIndexList - A4_Base ; suffix $2372
Global_TEXTDISP_BannerCharFallback       = TEXTDISP_BannerCharFallback - A4_Base ; suffix $2374
Global_TEXTDISP_BannerCharSelected       = TEXTDISP_BannerCharSelected - A4_Base ; suffix $2378
Global_TLIBA3_VmArrayPatternTable        = TLIBA3_VmArrayPatternTable - A4_Base ; suffix $2380

; END A4_GLOBALS_AUTOGEN

; BEGIN A4_DEBUG_ALIASES_AUTOGEN
; Debugger-friendly duplicate aliases with explicit `_A4` suffix.
; These mirror existing A4-relative globals for watch/window workflows.
Global_ScratchPtr_592_A4                     = Global_ScratchPtr_592
Global_UNKNOWN36_MessagePtr_A4               = Global_UNKNOWN36_MessagePtr
Global_WBStartupWindowPtr_A4                 = Global_WBStartupWindowPtr
Global_SavedStackPointer_A4                  = Global_SavedStackPointer
Global_SavedMsg_A4                           = Global_SavedMsg
Global_SavedExecBase_A4                      = Global_SavedExecBase
Global_SavedDirLock_A4                       = Global_SavedDirLock
Global_SignalCallbackPtr_A4                  = Global_SignalCallbackPtr
Global_ExitHookPtr_A4                        = Global_ExitHookPtr
Global_DosIoErr_A4                           = Global_DosIoErr
Global_CommandLineSize_A4                    = Global_CommandLineSize
Global_WBStartupCmdBuffer_A4                 = Global_WBStartupCmdBuffer
Global_UNKNOWN36_RequesterText2_A4           = Global_UNKNOWN36_RequesterText2
Global_UNKNOWN36_RequesterText1_A4           = Global_UNKNOWN36_RequesterText1
Global_UNKNOWN36_RequesterOutPtr_A4          = Global_UNKNOWN36_RequesterOutPtr
Global_UNKNOWN36_RequesterText0_A4           = Global_UNKNOWN36_RequesterText0
Global_StreamBufferAllocSize_A4              = Global_StreamBufferAllocSize
Global_CharClassTable_A4                     = Global_CharClassTable
Global_AllocBlockSize_A4                     = Global_AllocBlockSize
Global_DefaultHandleFlags_A4                 = Global_DefaultHandleFlags
Global_PreallocHandleNode0_A4                = Global_PreallocHandleNode0
Global_HandleTableFlags_A4                   = Global_HandleTableFlags
Global_AllocBytesTotal_A4                    = Global_AllocBytesTotal
Global_AllocListHead_A4                      = Global_AllocListHead
Global_MemListFirstAllocNode_A4              = Global_MemListFirstAllocNode
Global_HandleTableCount_A4                   = Global_HandleTableCount
Global_PreallocHandleNode0_OpenFlags_A4      = Global_PreallocHandleNode0_OpenFlags
Global_PreallocHandleNode0_HandleIndex_A4    = Global_PreallocHandleNode0_HandleIndex
Global_PreallocHandleNode1_A4                = Global_PreallocHandleNode1
Global_PreallocHandleNode1_BufferCursor_A4   = Global_PreallocHandleNode1_BufferCursor
Global_PreallocHandleNode1_WriteRemaining_A4 = Global_PreallocHandleNode1_WriteRemaining
Global_PreallocHandleNode1_BufferBudget_A4   = Global_PreallocHandleNode1_BufferBudget
Global_PreallocHandleNode1_OpenFlags_A4      = Global_PreallocHandleNode1_OpenFlags
Global_PreallocHandleNode1_HandleIndex_A4    = Global_PreallocHandleNode1_HandleIndex
Global_PreallocHandleNode2_A4                = Global_PreallocHandleNode2
Global_PreallocHandleNode2_OpenFlags_A4      = Global_PreallocHandleNode2_OpenFlags
Global_PreallocHandleNode2_HandleIndex_A4    = Global_PreallocHandleNode2_HandleIndex
Global_HandleTableBase_A4                    = Global_HandleTableBase
Global_HandleEntry0_Flags_A4                 = Global_HandleEntry0_Flags
Global_HandleEntry0_Ptr_A4                   = Global_HandleEntry0_Ptr
Global_HandleEntry1_Flags_A4                 = Global_HandleEntry1_Flags
Global_HandleEntry1_Ptr_A4                   = Global_HandleEntry1_Ptr
Global_HandleEntry2_Flags_A4                 = Global_HandleEntry2_Flags
Global_HandleEntry2_Ptr_A4                   = Global_HandleEntry2_Ptr
Global_PrintfBufferPtr_A4                    = Global_PrintfBufferPtr
Global_PrintfByteCount_A4                    = Global_PrintfByteCount
Global_FormatCallbackBufferPtr_A4            = Global_FormatCallbackBufferPtr
Global_FormatCallbackByteCount_A4            = Global_FormatCallbackByteCount
Global_AppErrorCode_A4                       = Global_AppErrorCode
Global_DosLibrary_A4                         = Global_DosLibrary
Global_MemListHead_A4                        = Global_MemListHead
Global_MemListTail_A4                        = Global_MemListTail
Global_FormatBufferPtr2_A4                   = Global_FormatBufferPtr2
Global_FormatByteCount2_A4                   = Global_FormatByteCount2
Global_ConsoleNameBuffer_A4                  = Global_ConsoleNameBuffer
Global_ArgCount_A4                           = Global_ArgCount
Global_ArgvPtr_A4                            = Global_ArgvPtr
Global_ArgvStorage_A4                        = Global_ArgvStorage
Global_DISPTEXT_InsetNibbleSecondary_A4      = Global_DISPTEXT_InsetNibbleSecondary
Global_CLEANUP_AlignedInsetNibblePrimary_A4  = Global_CLEANUP_AlignedInsetNibblePrimary
Global_CLEANUP_AlignedInsetNibbleSecondary_A4 = Global_CLEANUP_AlignedInsetNibbleSecondary
Global_CTASKS_IffTaskSegListBPTR_A4          = Global_CTASKS_IffTaskSegListBPTR
Global_CTASKS_IffTaskProcPtr_A4              = Global_CTASKS_IffTaskProcPtr
Global_CTASKS_CloseTaskSegListBPTR_A4        = Global_CTASKS_CloseTaskSegListBPTR
Global_CTASKS_CloseTaskProcPtr_A4            = Global_CTASKS_CloseTaskProcPtr
Global_DISKIO2_InteractiveTransferArmedFlag_A4 = Global_DISKIO2_InteractiveTransferArmedFlag
Global_DISKIO2_TransferFilenameExtPtr_A4     = Global_DISKIO2_TransferFilenameExtPtr
Global_DISKIO2_TransferSizeTokenBuffer_A4    = Global_DISKIO2_TransferSizeTokenBuffer
Global_DISPTEXT_ControlMarkerWidthPx_A4      = Global_DISPTEXT_ControlMarkerWidthPx
Global_ED_SavedCtasksIntervalByte_A4         = Global_ED_SavedCtasksIntervalByte
Global_ED_TempCopyOffset_A4                  = Global_ED_TempCopyOffset
Global_ED_EditBufferScratch_A4               = Global_ED_EditBufferScratch
Global_ED_EditBufferLive_A4                  = Global_ED_EditBufferLive
Global_WDISP_BannerWorkRasterPtr_A4          = Global_WDISP_BannerWorkRasterPtr
Global_TEXTDISP_PrimaryEntryPtrTable_A4      = Global_TEXTDISP_PrimaryEntryPtrTable
Global_CLOCK_DaySlotIndex_A4                 = Global_CLOCK_DaySlotIndex
Global_DST_PrimaryCountdown_A4               = Global_DST_PrimaryCountdown
Global_TEXTDISP_AliasPtrTable_A4             = Global_TEXTDISP_AliasPtrTable
Global_LADFUNC_LineSlotWriteIndex_A4         = Global_LADFUNC_LineSlotWriteIndex
Global_LADFUNC_LineControlCodeTable_A4       = Global_LADFUNC_LineControlCodeTable
Global_NEWGRID_RefreshStateFlag_A4           = Global_NEWGRID_RefreshStateFlag
Global_LADFUNC_EntryCount_A4                 = Global_LADFUNC_EntryCount
Global_CLOCK_HalfHourSlotIndex_A4            = Global_CLOCK_HalfHourSlotIndex
Global_DST_SecondaryCountdown_A4             = Global_DST_SecondaryCountdown
Global_WDISP_WeatherStatusCountdown_A4       = Global_WDISP_WeatherStatusCountdown
Global_CTRL_BufferedByteCount_A4             = Global_CTRL_BufferedByteCount
Global_ESQPARS_SelectionSuffixBuffer_A4      = Global_ESQPARS_SelectionSuffixBuffer
Global_ESQIFF_StatusPacketReadyFlag_A4       = Global_ESQIFF_StatusPacketReadyFlag
Global_ESQIFF_RecordBufferPtr_A4             = Global_ESQIFF_RecordBufferPtr
Global_ESQPARS_SelectionMatchCode_A4         = Global_ESQPARS_SelectionMatchCode
Global_TEXTDISP_DeferredActionDelayTicks_A4  = Global_TEXTDISP_DeferredActionDelayTicks
Global_GCOMMAND_HighlightMessageSlotTable_A4 = Global_GCOMMAND_HighlightMessageSlotTable
Global_ESQDISP_HighlightBitmapTable_A4       = Global_ESQDISP_HighlightBitmapTable
Global_ESQIFF_PendingExternalBrushNode_A4    = Global_ESQIFF_PendingExternalBrushNode
Global_ESQIFF_LogoListLineIndex_A4           = Global_ESQIFF_LogoListLineIndex
Global_ESQIFF_GAdsListLineIndex_A4           = Global_ESQIFF_GAdsListLineIndex
Global_WDISP_PaletteDepthLog2_A4             = Global_WDISP_PaletteDepthLog2
Global_ESQIFF_ExternalAssetStateTable_A4     = Global_ESQIFF_ExternalAssetStateTable
Global_ESQIFF_ExternalAssetPathCommaFlag_A4  = Global_ESQIFF_ExternalAssetPathCommaFlag
Global_GCOMMAND_NicheTextPen_A4              = Global_GCOMMAND_NicheTextPen
Global_GCOMMAND_NicheFramePen_A4             = Global_GCOMMAND_NicheFramePen
Global_GCOMMAND_NicheEditorLayoutPen_A4      = Global_GCOMMAND_NicheEditorLayoutPen
Global_GCOMMAND_NicheEditorRowPen_A4         = Global_GCOMMAND_NicheEditorRowPen
Global_GCOMMAND_NicheModeCycleCount_A4       = Global_GCOMMAND_NicheModeCycleCount
Global_GCOMMAND_NicheForceMode5Flag_A4       = Global_GCOMMAND_NicheForceMode5Flag
Global_GCOMMAND_NicheWorkflowMode_A4         = Global_GCOMMAND_NicheWorkflowMode
Global_GCOMMAND_MplexModeCycleCount_A4       = Global_GCOMMAND_MplexModeCycleCount
Global_GCOMMAND_MplexSearchRowLimit_A4       = Global_GCOMMAND_MplexSearchRowLimit
Global_GCOMMAND_MplexClockOffsetMinutes_A4   = Global_GCOMMAND_MplexClockOffsetMinutes
Global_GCOMMAND_MplexMessageTextPen_A4       = Global_GCOMMAND_MplexMessageTextPen
Global_GCOMMAND_MplexMessageFramePen_A4      = Global_GCOMMAND_MplexMessageFramePen
Global_GCOMMAND_MplexEditorLayoutPen_A4      = Global_GCOMMAND_MplexEditorLayoutPen
Global_GCOMMAND_MplexEditorRowPen_A4         = Global_GCOMMAND_MplexEditorRowPen
Global_GCOMMAND_MplexDetailLayoutPen_A4      = Global_GCOMMAND_MplexDetailLayoutPen
Global_GCOMMAND_MplexDetailInitialLineIndex_A4 = Global_GCOMMAND_MplexDetailInitialLineIndex
Global_GCOMMAND_MplexDetailRowPen_A4         = Global_GCOMMAND_MplexDetailRowPen
Global_GCOMMAND_MplexWorkflowMode_A4         = Global_GCOMMAND_MplexWorkflowMode
Global_GCOMMAND_MplexDetailLayoutFlag_A4     = Global_GCOMMAND_MplexDetailLayoutFlag
Global_GCOMMAND_PpvModeCycleCount_A4         = Global_GCOMMAND_PpvModeCycleCount
Global_GCOMMAND_PpvMessageTextPen_A4         = Global_GCOMMAND_PpvMessageTextPen
Global_GCOMMAND_PpvMessageFramePen_A4        = Global_GCOMMAND_PpvMessageFramePen
Global_GCOMMAND_PpvShowtimesWorkflowMode_A4  = Global_GCOMMAND_PpvShowtimesWorkflowMode
Global_GCOMMAND_PpvDetailLayoutFlag_A4       = Global_GCOMMAND_PpvDetailLayoutFlag
Global_GCOMMAND_PpvShowtimesRowSpan_A4       = Global_GCOMMAND_PpvShowtimesRowSpan
Global_GCOMMAND_BannerRowIndexCurrent_A4     = Global_GCOMMAND_BannerRowIndexCurrent
Global_DISKIO_Drive0WriteProtectedCode_A4    = Global_DISKIO_Drive0WriteProtectedCode
Global_ED_StateRingTable_A4                  = Global_ED_StateRingTable
Global_LOCAVAIL_PrimaryFilterState_A4        = Global_LOCAVAIL_PrimaryFilterState
Global_LOCAVAIL_SecondaryFilterState_A4      = Global_LOCAVAIL_SecondaryFilterState
Global_NEWGRID_ColumnWidthPx_A4              = Global_NEWGRID_ColumnWidthPx
Global_NEWGRID_ShowtimeBucketEntryTable_A4   = Global_NEWGRID_ShowtimeBucketEntryTable
Global_NEWGRID_ShowtimeBucketCount_A4        = Global_NEWGRID_ShowtimeBucketCount
Global_PARSEINI_WeatherBrushNodePtr_A4       = Global_PARSEINI_WeatherBrushNodePtr
Global_GCOMMAND_GradientPresetTable_A4       = Global_GCOMMAND_GradientPresetTable
Global_SCRIPT_CtrlLineAssertedTicks_A4       = Global_SCRIPT_CtrlLineAssertedTicks
Global_SCRIPT_CtrlCmdCount_A4                = Global_SCRIPT_CtrlCmdCount
Global_SCRIPT_CtrlCmdChecksumErrorCount_A4   = Global_SCRIPT_CtrlCmdChecksumErrorCount
Global_SCRIPT_CtrlCmdLengthErrorCount_A4     = Global_SCRIPT_CtrlCmdLengthErrorCount
Global_SCRIPT_ChannelRangeDigitChar_A4       = Global_SCRIPT_ChannelRangeDigitChar
Global_SCRIPT_SearchMatchCountOrIndex_A4     = Global_SCRIPT_SearchMatchCountOrIndex
Global_SCRIPT_BannerTransitionTargetChar_A4  = Global_SCRIPT_BannerTransitionTargetChar
Global_SCRIPT_BannerTransitionStepDelta_A4   = Global_SCRIPT_BannerTransitionStepDelta
Global_SCRIPT_BannerTransitionStepSign_A4    = Global_SCRIPT_BannerTransitionStepSign
Global_SCRIPT_ChannelRangeArmedFlag_A4       = Global_SCRIPT_ChannelRangeArmedFlag
Global_TEXTDISP_FilterCandidateCursor_A4     = Global_TEXTDISP_FilterCandidateCursor
Global_TEXTDISP_FilterChannelSlotIndex_A4    = Global_TEXTDISP_FilterChannelSlotIndex
Global_TEXTDISP_FilterMatchCount_A4          = Global_TEXTDISP_FilterMatchCount
Global_TEXTDISP_FilterPpvSbeMatchFlag_A4     = Global_TEXTDISP_FilterPpvSbeMatchFlag
Global_TEXTDISP_FilterSportsMatchFlag_A4     = Global_TEXTDISP_FilterSportsMatchFlag
Global_TEXTDISP_StatusGroupId_A4             = Global_TEXTDISP_StatusGroupId
Global_TEXTDISP_SourceConfigEntryTable_A4    = Global_TEXTDISP_SourceConfigEntryTable
Global_TEXTDISP_SourceConfigEntryCount_A4    = Global_TEXTDISP_SourceConfigEntryCount
Global_TEXTDISP_PrimaryFirstMatchIndex_A4    = Global_TEXTDISP_PrimaryFirstMatchIndex
Global_TEXTDISP_SecondaryFirstMatchIndex_A4  = Global_TEXTDISP_SecondaryFirstMatchIndex
Global_TEXTDISP_EntryTextBaseWidthPx_A4      = Global_TEXTDISP_EntryTextBaseWidthPx
Global_ESQ_GlobalTickCounter_A4              = Global_ESQ_GlobalTickCounter
Global_TEXTDISP_CurrentMatchIndex_A4         = Global_TEXTDISP_CurrentMatchIndex
Global_CLEANUP_AlignedStatusSuffixBuffer_A4  = Global_CLEANUP_AlignedStatusSuffixBuffer
Global_CLEANUP_AlignedStatusMatchIndex_A4    = Global_CLEANUP_AlignedStatusMatchIndex
Global_TEXTDISP_CandidateIndexList_A4        = Global_TEXTDISP_CandidateIndexList
Global_TEXTDISP_BannerCharFallback_A4        = Global_TEXTDISP_BannerCharFallback
Global_TEXTDISP_BannerCharSelected_A4        = Global_TEXTDISP_BannerCharSelected
Global_TLIBA3_VmArrayPatternTable_A4         = Global_TLIBA3_VmArrayPatternTable
; END A4_DEBUG_ALIASES_AUTOGEN


    include "modules/groups/_main/a/a.s"
    include "modules/groups/_main/a/xjump.s"
    include "modules/groups/_main/b/b.s"
    include "modules/groups/_main/b/xjump.s"

    include "modules/groups/a/a/app.s"
    include "modules/groups/a/a/app2.s"
    include "modules/groups/a/a/app3.s"
    include "modules/groups/a/a/bevel.s"
    include "modules/groups/a/a/bitmap.s"
    include "modules/groups/a/a/brush.s"
    include "modules/groups/a/a/xjump.s"

    include "modules/groups/a/b/cleanup.s"
    include "modules/groups/a/b/xjump.s"

    include "modules/groups/a/c/cleanup2.s"
    include "modules/groups/a/c/xjump.s"

    include "modules/groups/a/d/cleanup3.s"
    include "modules/groups/a/d/xjump.s"

    include "modules/groups/a/e/cleanup4.s"
    include "modules/groups/a/e/coi.s"
    include "modules/groups/a/e/xjump.s"

    include "modules/groups/a/f/ctasks.s"
    include "modules/groups/a/f/xjump.s"

    include "modules/groups/a/g/diskio.s"
    include "modules/groups/a/g/diskio1.s"
    include "modules/groups/a/g/xjump.s"

    include "modules/groups/a/h/diskio2.s"
    include "modules/groups/a/h/xjump.s"

    include "modules/groups/a/i/displib.s"
    include "modules/groups/a/i/disptext.s"
    include "modules/groups/a/i/xjump.s"

    include "modules/groups/a/j/disptext2.s"
    include "modules/groups/a/j/dst.s"
    include "modules/groups/a/j/dst2.s"
    include "modules/groups/a/j/xjump.s"

    include "modules/groups/a/k/ed.s"
    include "modules/groups/a/k/ed1.s"
    include "modules/groups/a/k/ed2.s"
    include "modules/groups/a/k/xjump.s"
    include "modules/groups/a/k/xjump2.s"

    include "modules/groups/a/l/ed3.s"
    include "modules/groups/a/l/xjump.s"

    include "modules/groups/a/m/esq.s"
    include "modules/groups/a/m/xjump.s"

    include "modules/groups/a/n/esqdisp.s"
    include "modules/groups/a/n/esqfunc.s"
    include "modules/groups/a/n/esqiff.s"

    include "modules/groups/a/o/esqiff2.s"
    include "modules/groups/a/o/esqpars.s"

    include "modules/groups/a/p/esqshared.s"
    include "modules/groups/a/q/esqshared4.s"

    include "modules/groups/a/r/flib.s"
    include "modules/groups/a/r/xjump.s"

    include "modules/groups/a/s/flib2.s"
    include "modules/groups/a/s/gcommand.s"
    include "modules/groups/a/s/xjump.s"

    include "modules/groups/a/t/gcommand2.s"
    include "modules/groups/a/t/xjump.s"

    include "modules/groups/a/u/gcommand3.s"
    include "modules/groups/a/u/gcommand4.s"
    include "modules/groups/a/u/xjump.s"

    include "modules/groups/a/v/gcommand5.s"
    include "modules/groups/a/v/kybd.s"
    include "modules/groups/a/v/xjump.s"

    include "modules/groups/a/w/ladfunc.s"
    include "modules/groups/a/w/xjump.s"

    include "modules/groups/a/x/ladfunc2.s"
    include "modules/groups/a/x/xjump.s"

    include "modules/groups/a/y/locavail.s"
    include "modules/groups/a/y/xjump.s"

    include "modules/groups/a/z/locavail2.s"
    include "modules/groups/a/z/xjump.s"

    include "modules/groups/b/a/newgrid.s"
    include "modules/groups/b/a/newgrid1.s"
    include "modules/groups/b/a/newgrid2.s"
    include "modules/groups/b/a/p_type.s"
    include "modules/groups/b/a/parseini.s"
    include "modules/groups/b/a/parseini2.s"
    include "modules/groups/b/a/parseini3.s"
    include "modules/groups/b/a/script.s"
    include "modules/groups/b/a/script2.s"
    include "modules/groups/b/a/script3.s"
    include "modules/groups/b/a/script4.s"
    include "modules/groups/b/a/textdisp.s"
    include "modules/groups/b/a/textdisp2.s"
    include "modules/groups/b/a/textdisp3.s"
    include "modules/groups/b/a/tliba1.s"
    include "modules/groups/b/a/tliba2.s"
    include "modules/groups/b/a/tliba3.s"
    include "modules/groups/b/a/wdisp.s"

    include "modules/submodules/unknown.s"
    include "modules/submodules/unknown2a.s"
    include "modules/submodules/memory.s"
    include "modules/submodules/unknown2b.s"
    include "modules/submodules/unknown3.s"
    include "modules/submodules/unknown4.s"
    include "modules/submodules/unknown5.s"
    include "modules/submodules/unknown6.s"
    include "modules/submodules/unknown7.s"
    include "modules/submodules/unknown8.s"
    include "modules/submodules/unknown9.s"
    include "modules/submodules/unknown10.s"
    include "modules/submodules/unknown11.s"
    include "modules/submodules/unknown12.s"
    include "modules/submodules/unknown13.s"
    include "modules/submodules/unknown14.s"
    include "modules/submodules/unknown15.s"
    include "modules/submodules/unknown16.s"
    include "modules/submodules/unknown17.s"
    include "modules/submodules/unknown18.s"
    include "modules/submodules/unknown19.s"
    include "modules/submodules/unknown20.s"
    include "modules/submodules/unknown21.s"
    include "modules/submodules/unknown22.s"
    include "modules/submodules/unknown23.s"
    include "modules/submodules/unknown24.s"
    include "modules/submodules/unknown25.s"
    include "modules/submodules/unknown26.s"
    include "modules/submodules/unknown27.s"
    include "modules/submodules/unknown28.s"
    include "modules/submodules/unknown29.s"
    include "modules/submodules/unknown30.s"
    include "modules/submodules/unknown31.s"
    include "modules/submodules/unknown32.s"
    include "modules/submodules/unknown33.s"
    include "modules/submodules/unknown34.s"
    include "modules/submodules/unknown35.s"
    include "modules/submodules/unknown36.s"
    include "modules/submodules/unknown37.s"
    include "modules/submodules/unknown38.s"
    include "modules/submodules/unknown39.s"
    include "modules/submodules/unknown40.s"
    include "modules/submodules/unknown41.s"
    include "modules/submodules/unknown42.s"

;!================
; Data Section
;!================

    SECTION S_1,DATA,CHIP

    include "data/common.s"
    include "data/brush.s"
    include "data/cleanup.s"
    include "data/clock.s"
    include "data/coi.s"
    include "data/ctasks.s"
    include "data/diskio.s"
    include "data/diskio2.s"
    include "data/displib.s"
    include "data/disptext.s"
    include "data/dst.s"
    include "data/ed2.s"
    include "data/esq.s"
    include "data/esqdisp.s"
    include "data/esqfunc.s"
    include "data/esqiff.s"
    include "data/esqpars.s"
    include "data/esqpars2.s"
    include "data/flib.s"
    include "data/gcommand.s"
    include "data/kybd.s"
    include "data/ladfunc.s"
    include "data/locavail.s"
    include "data/newgrid.s"
    include "data/newgrid2.s"
    include "data/p_type.s"
    include "data/parseini.s"
    include "data/script.s"
    include "data/textdisp.s"
    include "data/tliba1.s"
    include "data/wdisp.s"

    END
