; ==========================================
; ESQ-3.asm disassembly + annotation
; ==========================================

; Set this to 1 to include Ari's custom assembly for dumping debug output.
includeCustomAriAssembly = 0
; Set this to 1 to patch the address being calculated for A4 offsets.
; If you have this to 0 and you try to modify anything in the S_1 section, you
; might encounter a crash.
patchA4OffsetForData = 0

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

    if patchA4OffsetForData
Global_GraphicsLibraryBase_A4    = Global_REF_GRAPHICS_LIBRARY - A4_Base
    else
Global_GraphicsLibraryBase_A4    = -22440
    endif

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
A4_Base = Global_REF_LONG_FILE_SCRATCH
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
Global_GCOMMAND_GradientPresetTable      = GCOMMAND_GradientPresetTable - A4_Base ; suffix $233F
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
