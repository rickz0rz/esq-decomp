    XDEF    ED1_DrawStatusLine1
    XDEF    ED1_DrawStatusLine2
    XDEF    _ED1_JMPTBL_CLEANUP_DrawDateTimeBannerRow
    XDEF    _ED1_JMPTBL_ESQSHARED4_LoadDefaultPaletteToCopper_NoOp
    XDEF    _ED1_JMPTBL_ESQ_ColdReboot
    XDEF    ED1_JMPTBL_GCOMMAND_ResetHighlightMessages
    XDEF    _ED1_JMPTBL_GCOMMAND_SeedBannerDefaults
    XDEF    ED1_JMPTBL_GCOMMAND_SeedBannerFromPrefs
    XDEF    ED1_JMPTBL_LADFUNC_MergeHighLowNibbles
    XDEF    ED1_JMPTBL_LADFUNC_PackNibblesToByte
    XDEF    ED1_JMPTBL_LADFUNC_SaveTextAdsToFile
    XDEF    _ED1_JMPTBL_LOCAVAIL_ResetFilterCursorState
    XDEF    ED1_JMPTBL_MEM_Move
    XDEF    ED1_JMPTBL_NEWGRID_DrawTopBorderLine
    XDEF    ED1_WaitForFlagAndClearBit0
    XDEF    ED1_WaitForFlagAndClearBit1

;------------------------------------------------------------------------------
; FUNC: ED1_WaitForFlagAndClearBit1   (Wait for flag and clear bit 1)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0
; CALLS:
;   _ESQIFF_ReloadExternalAssetCatalogBuffers
; READS:
;   _CTASKS_IffTaskDoneFlag, _ESQIFF_ExternalAssetFlags
; WRITES:
;   _LADFUNC_EntryCount, _ESQIFF_ExternalAssetFlags
; DESC:
;   Busy-waits for _CTASKS_IffTaskDoneFlag then clears bit 1 in _ESQIFF_ExternalAssetFlags and signals.
; NOTES:
;   Passes 0 to _ESQIFF_ReloadExternalAssetCatalogBuffers.
;------------------------------------------------------------------------------
ED1_WaitForFlagAndClearBit1:
.wait_flag:
    TST.W   _CTASKS_IffTaskDoneFlag
    BEQ.S   .wait_flag

    MOVE.W  #$2e,_LADFUNC_EntryCount
    MOVE.W  _ESQIFF_ExternalAssetFlags,D0
    ANDI.W  #$fffd,D0
    MOVE.W  D0,_ESQIFF_ExternalAssetFlags
    CLR.L   -(A7)
    JSR     _ESQIFF_ReloadExternalAssetCatalogBuffers(PC)

    ADDQ.W  #4,A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED1_WaitForFlagAndClearBit0   (Wait for flag and clear bit 0)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0
; CALLS:
;   _ESQIFF_ReloadExternalAssetCatalogBuffers
; READS:
;   _CTASKS_IffTaskDoneFlag, _ESQIFF_ExternalAssetFlags
; WRITES:
;   _LADFUNC_EntryCount, _ESQIFF_ExternalAssetFlags
; DESC:
;   Busy-waits for _CTASKS_IffTaskDoneFlag then clears bit 0 in _ESQIFF_ExternalAssetFlags and signals.
; NOTES:
;   Passes 1 to _ESQIFF_ReloadExternalAssetCatalogBuffers.
;------------------------------------------------------------------------------
ED1_WaitForFlagAndClearBit0:
.wait_flag:
    TST.W   _CTASKS_IffTaskDoneFlag

    BEQ.S   .wait_flag

    MOVE.W  #$2e,_LADFUNC_EntryCount
    MOVE.W  _ESQIFF_ExternalAssetFlags,D0
    ANDI.W  #$fffe,D0
    MOVE.W  D0,_ESQIFF_ExternalAssetFlags
    PEA     1.W
    JSR     _ESQIFF_ReloadExternalAssetCatalogBuffers(PC)

    ADDQ.W  #4,A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED1_JMPTBL_NEWGRID_DrawTopBorderLine   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _NEWGRID_DrawTopBorderLine
; DESC:
;   Jump stub to _NEWGRID_DrawTopBorderLine.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
ED1_JMPTBL_NEWGRID_DrawTopBorderLine:
    JMP     _NEWGRID_DrawTopBorderLine

;------------------------------------------------------------------------------
; FUNC: _ED1_JMPTBL_LOCAVAIL_ResetFilterCursorState   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   _LOCAVAIL_ResetFilterCursorState
; DESC:
;   Jump stub to _LOCAVAIL_ResetFilterCursorState.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_ED1_JMPTBL_LOCAVAIL_ResetFilterCursorState:
    JMP     _LOCAVAIL_ResetFilterCursorState

;!======

    ; Alignment
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0

;!======

;------------------------------------------------------------------------------
; FUNC: ED1_JMPTBL_GCOMMAND_ResetHighlightMessages   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _GCOMMAND_ResetHighlightMessages
; DESC:
;   Jump stub to _GCOMMAND_ResetHighlightMessages.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
ED1_JMPTBL_GCOMMAND_ResetHighlightMessages:
    JMP     _GCOMMAND_ResetHighlightMessages

;------------------------------------------------------------------------------
; FUNC: ED1_JMPTBL_LADFUNC_MergeHighLowNibbles   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _LADFUNC_SetPackedPenLowNibble
; DESC:
;   Jump stub to _LADFUNC_SetPackedPenLowNibble.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
ED1_JMPTBL_LADFUNC_MergeHighLowNibbles:
    JMP     _LADFUNC_SetPackedPenLowNibble

;------------------------------------------------------------------------------
; FUNC: ED1_JMPTBL_LADFUNC_SaveTextAdsToFile   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _LADFUNC_SaveTextAdsToFile
; DESC:
;   Jump stub to _LADFUNC_SaveTextAdsToFile.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
ED1_JMPTBL_LADFUNC_SaveTextAdsToFile:
    JMP     _LADFUNC_SaveTextAdsToFile

;------------------------------------------------------------------------------
; FUNC: _ED1_JMPTBL_ESQ_ColdReboot   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_ColdReboot
; DESC:
;   Jump stub to ESQ_ColdReboot.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_ED1_JMPTBL_ESQ_ColdReboot:
    JMP     ESQ_ColdReboot

;------------------------------------------------------------------------------
; FUNC: _ED1_JMPTBL_ESQSHARED4_LoadDefaultPaletteToCopper_NoOp   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQSHARED4_LoadDefaultPaletteToCopper_NoOp
; DESC:
;   Jump stub to _ESQSHARED4_LoadDefaultPaletteToCopper_NoOp.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_ED1_JMPTBL_ESQSHARED4_LoadDefaultPaletteToCopper_NoOp:
    JMP     _ESQSHARED4_LoadDefaultPaletteToCopper_NoOp

;------------------------------------------------------------------------------
; FUNC: _ED1_JMPTBL_GCOMMAND_SeedBannerDefaults   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   GCOMMAND_SeedBannerDefaults
; DESC:
;   Jump stub to GCOMMAND_SeedBannerDefaults.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_ED1_JMPTBL_GCOMMAND_SeedBannerDefaults:
    JMP     GCOMMAND_SeedBannerDefaults

;------------------------------------------------------------------------------
; FUNC: ED1_JMPTBL_MEM_Move   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   MEM_Move
; DESC:
;   Jump stub to MEM_Move.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
ED1_JMPTBL_MEM_Move:
    JMP     MEM_Move

;------------------------------------------------------------------------------
; FUNC: ED1_JMPTBL_GCOMMAND_SeedBannerFromPrefs   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _GCOMMAND_SeedBannerFromPrefs
; DESC:
;   Jump stub to _GCOMMAND_SeedBannerFromPrefs.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
ED1_JMPTBL_GCOMMAND_SeedBannerFromPrefs:
    JMP     _GCOMMAND_SeedBannerFromPrefs

;------------------------------------------------------------------------------
; FUNC: _ED1_JMPTBL_CLEANUP_DrawDateTimeBannerRow   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   CLEANUP_DrawDateTimeBannerRow
; DESC:
;   Jump stub to CLEANUP_DrawDateTimeBannerRow.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_ED1_JMPTBL_CLEANUP_DrawDateTimeBannerRow:
    JMP     CLEANUP_DrawDateTimeBannerRow

;------------------------------------------------------------------------------
; FUNC: ED1_JMPTBL_LADFUNC_PackNibblesToByte   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _LADFUNC_SetPackedPenHighNibble
; DESC:
;   Jump stub to _LADFUNC_SetPackedPenHighNibble.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
ED1_JMPTBL_LADFUNC_PackNibblesToByte:
    JMP     _LADFUNC_SetPackedPenHighNibble

;!======
; The below content should belong in another file... need to determine what it is.
;!======

;------------------------------------------------------------------------------
; FUNC: ED1_DrawStatusLine1   (Render status line 1uncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0
; CALLS:
;   _GROUP_AM_JMPTBL_WDISP_SPrintf, _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines
; READS:
;   _ESQPARS2_StateIndex, _WDISP_DisplayContextBase
; WRITES:
;   (none observed)
; DESC:
;   Formats and draws a status string in rastport 2.
; NOTES:
;   Local printf buffer is 41 bytes (-41(A5)..-1(A5).
;------------------------------------------------------------------------------
ED1_DrawStatusLine1:

.statusLine   = -41

    LINK.W  A5,#-44

    MOVE.W  _ESQPARS2_StateIndex,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     _ED2_FMT_SCRSPD_PCT_D
    PEA     .statusLine(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     210.W
    PEA     .statusLine(A5)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED1_DrawStatusLine2   (Render status line 2uncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/A7/D0/D1/D2
; CALLS:
;   _GROUP_AM_JMPTBL_WDISP_SPrintf, _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines, _LVOSetRast
; READS:
;   _WDISP_DisplayContextBase, _CONFIG_NicheModeCycleBudget_Y/1BA5/1BAD/1BB7/1BBD/1BBE/1BC9
; WRITES:
;   (none observed)
; DESC:
;   Formats and draws a multi-line status block in rastport 2.
; NOTES:
;   Local printf buffer is 51 bytes (-51(A5)..-1(A5), reused across three
;   _WDISP_SPrintf calls.
;------------------------------------------------------------------------------
ED1_DrawStatusLine2:

.statusLine   = -51

    LINK.W  A5,#-52
    MOVE.L  D2,-(A7)
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVE.B  _CONFIG_NicheModeCycleBudget_Y,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.B  _CONFIG_NicheModeCycleBudget_Static,D1
    EXT.W   D1
    EXT.L   D1
    MOVE.B  _CONFIG_NicheModeCycleBudget_Custom,D2
    EXT.W   D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     _ED2_FMT_MR_PCT_D_SBS_PCT_D_SPORT_PCT_D
    PEA     .statusLine(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     120.W
    PEA     .statusLine(A5)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVE.B  _CONFIG_ModeCycleEnabledFlag,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  _CONFIG_TimeWindowMinutes,(A7)
    MOVE.L  _CONFIG_ModeCycleGateDuration,-(A7)
    MOVE.L  D0,-(A7)
    PEA     _ED2_FMT_CYCLE_PCT_C_CYCLEFREQ_PCT_D_AFTRORDR
    PEA     .statusLine(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     150.W
    PEA     .statusLine(A5)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVE.B  _CTASKS_STR_1,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     _Global_STR_CLOCKCMD_EQUALS_PCT_C
    PEA     .statusLine(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     68(A7),A7
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     180.W
    PEA     .statusLine(A5)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVE.L  -56(A5),D2
    UNLK    A5
    RTS
