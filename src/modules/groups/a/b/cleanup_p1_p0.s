    XDEF    CLEANUP_ShutdownSystem


;------------------------------------------------------------------------------
; FUNC: CLEANUP_ShutdownSystem
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1/A6
; CALLS:
;   _LVOForbid, _LOCAVAIL_FreeResourceChain, _BRUSH_FreeBrushList,
;   _CLEANUP_ClearVertbInterruptServer, _CLEANUP_ClearAud1InterruptVector,
;   _CLEANUP_ClearRbfInterruptAndSerial, _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory,
;   _CLEANUP_ShutdownInputDevices, _CLEANUP_ReleaseDisplayResources, GROUP_AB_JMPTBL_LADFUNC_FreeBannerRectEntries, _GROUP_AH_JMPTBL_ESQPARS_ClearAliasStringPointers,
;   GROUP_AB_JMPTBL_ESQIFF2_ClearLineHeadTailByMode, GROUP_AB_JMPTBL_ESQIFF_DeallocateAdsAndLogoLstData, GROUP_AB_JMPTBL_ESQPARS_RemoveGroupEntryAndReleaseStrings, GROUP_AB_JMPTBL_ESQFUNC_FreeLineTextBuffers,
;   _LVOSetFunction, _LVOVBeamPos, GROUP_AB_JMPTBL_UNKNOWN2A_Stub0, _LVOPermit
; READS:
;   _LOCAVAIL_PrimaryFilterState, _LOCAVAIL_SecondaryFilterState, _ESQIFF_BrushIniListHead, _ESQIFF_GAdsBrushListHead, _ESQIFF_LogoBrushListHead, _ESQFUNC_PwBrushListHead, ESQIFF_RecordBufferPtr,
;   _ESQ_HighlightMsgPort, _ESQ_HighlightReplyPort, ESQDISP_HighlightBitmapTable, _WDISP_HighlightRasterHeightPx, WDISP_WeatherStatusTextPtr, WDISP_WeatherStatusOverlayTextPtr, ESQ_ProcessWindowPtrBackup,
;   WDISP_ExecBaseHookPtr, Global_REF_GRAPHICS_LIBRARY, _Global_REF_INTUITION_LIBRARY,
;   _Global_REF_BACKED_UP_INTUITION_AUTOREQUEST, _Global_REF_BACKED_UP_INTUITION_DISPLAYALERT,
;   AbsExecBase, Global_STR_CLEANUP_C_13, Global_STR_CLEANUP_C_14, Global_STR_CLEANUP_C_15,
;   Global_STR_CLEANUP_C_16
; WRITES:
;   WDISP_WeatherStatusTextPtr, WDISP_WeatherStatusOverlayTextPtr
; DESC:
;   Global shutdown: forbids task switches, releases resources, restores patched
;   system vectors, and re-enables multitasking.
; NOTES:
;   - Frees raster tables via nested loops over ESQDISP_HighlightBitmapTable entries.
;------------------------------------------------------------------------------
; Global shutdown sequence: stop interrupts, free rsrcs, reset display.
CLEANUP_ShutdownSystem:
    MOVEM.L D6-D7,-(A7)

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    PEA     _LOCAVAIL_PrimaryFilterState
    JSR     GROUP_AB_JMPTBL_LOCAVAIL_FreeResourceChain(PC)

    PEA     _LOCAVAIL_SecondaryFilterState
    JSR     GROUP_AB_JMPTBL_LOCAVAIL_FreeResourceChain(PC)

    CLR.L   (A7)
    PEA     _ESQIFF_BrushIniListHead
    JSR     _BRUSH_FreeBrushList(PC)      ; release primary brush list

    CLR.L   (A7)
    PEA     _ESQIFF_GAdsBrushListHead
    JSR     _BRUSH_FreeBrushList(PC)      ; release alternate brush buckets

    CLR.L   (A7)
    PEA     _ESQIFF_LogoBrushListHead
    JSR     _BRUSH_FreeBrushList(PC)

    CLR.L   (A7)
    PEA     _ESQFUNC_PwBrushListHead
    JSR     _BRUSH_FreeBrushList(PC)

    BSR.W   _CLEANUP_ClearVertbInterruptServer

    BSR.W   _CLEANUP_ClearAud1InterruptVector

    BSR.W   _CLEANUP_ClearRbfInterruptAndSerial

    PEA     9000.W
    MOVE.L  ESQIFF_RecordBufferPtr,-(A7)
    PEA     260.W
    PEA     Global_STR_CLEANUP_C_13
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    BSR.W   _CLEANUP_ShutdownInputDevices

    BSR.W   _CLEANUP_ReleaseDisplayResources

    JSR     GROUP_AB_JMPTBL_LADFUNC_FreeBannerRectEntries(PC)

    JSR     _GROUP_AH_JMPTBL_ESQPARS_ClearAliasStringPointers(PC)

    PEA     1.W
    JSR     GROUP_AB_JMPTBL_ESQIFF2_ClearLineHeadTailByMode(PC)

    PEA     2.W
    JSR     GROUP_AB_JMPTBL_ESQIFF2_ClearLineHeadTailByMode(PC)

    JSR     GROUP_AB_JMPTBL_ESQIFF_DeallocateAdsAndLogoLstData(PC)

    PEA     2.W
    JSR     GROUP_AB_JMPTBL_ESQPARS_RemoveGroupEntryAndReleaseStrings(PC)

    PEA     1.W
    JSR     GROUP_AB_JMPTBL_ESQPARS_RemoveGroupEntryAndReleaseStrings(PC)

    JSR     GROUP_AB_JMPTBL_ESQFUNC_FreeLineTextBuffers(PC)

    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A0
    MOVE.L  38(A0),COP1LCH
    JSR     GROUP_AB_JMPTBL_NEWGRID_ShutdownGridResources(PC)

    PEA     34.W
    MOVE.L  _ESQ_HighlightMsgPort,-(A7)
    PEA     318.W
    PEA     Global_STR_CLEANUP_C_14
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     72(A7),A7

    PEA     34.W
    MOVE.L  _ESQ_HighlightReplyPort,-(A7)
    PEA     319.W
    PEA     Global_STR_CLEANUP_C_15
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

    MOVEQ   #0,D6

.freeRaster_rows_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D6
    BGE.S   .after_raster_table

    MOVEQ   #0,D7

.freeRaster_cols_loop:
    MOVEQ   #3,D0
    CMP.L   D0,D7
    BGE.S   .next_raster_row

    MOVE.L  D6,D0
    MOVEQ   #40,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    LEA     ESQDISP_HighlightBitmapTable,A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.W  _WDISP_HighlightRasterHeightPx,D0
    MOVE.L  D0,-(A7)
    PEA     696.W
    MOVE.L  8(A0),-(A7)
    PEA     329.W
    PEA     Global_STR_CLEANUP_C_16
    JSR     _GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(PC)

    LEA     20(A7),A7
    ADDQ.L  #1,D7
    BRA.S   .freeRaster_cols_loop

.next_raster_row:
    ADDQ.L  #1,D6
    BRA.S   .freeRaster_rows_loop

.after_raster_table:
    MOVE.L  WDISP_WeatherStatusTextPtr,-(A7)
    CLR.L   -(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,WDISP_WeatherStatusTextPtr
    MOVE.L  WDISP_WeatherStatusOverlayTextPtr,(A7)
    CLR.L   -(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     12(A7),A7
    MOVE.L  D0,WDISP_WeatherStatusOverlayTextPtr

    ; this must be restoring functions that were hijacked?
    ; ...the other use of this stores D0 and this doesn't.

    ; Overriding the AutoRequest function in intuition.library
    ; to point to _Global_REF_BACKED_UP_INTUITION_AUTOREQUEST
    MOVEA.L _Global_REF_BACKED_UP_INTUITION_AUTOREQUEST,A0
    MOVE.L  A0,D0
    MOVEA.L _Global_REF_INTUITION_LIBRARY,A1
    MOVEA.W #_LVOAutoRequest,A0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOSetFunction(A6)

    ; Overriding the ItemAddress function in intuition.library
    ; to point to _Global_REF_BACKED_UP_INTUITION_DISPLAYALERT
    MOVEA.L _Global_REF_BACKED_UP_INTUITION_DISPLAYALERT,A0
    MOVE.L  A0,D0
    MOVEA.L _Global_REF_INTUITION_LIBRARY,A1
    MOVEA.W #_LVODisplayAlert,A0
    JSR     _LVOSetFunction(A6)

    MOVEA.L _Global_REF_INTUITION_LIBRARY,A6
    JSR     _LVOVBeamPos(A6)

    TST.L   ESQ_ProcessWindowPtrBackup
    BEQ.S   .after_optional_restore

    MOVEA.L WDISP_ExecBaseHookPtr,A0
    MOVE.L  ESQ_ProcessWindowPtrBackup,184(A0)

.after_optional_restore:
    JSR     GROUP_AB_JMPTBL_UNKNOWN2A_Stub0(PC)

    MOVEA.L AbsExecBase,A6
    JSR     _LVOPermit(A6)

    MOVEM.L (A7)+,D6-D7
    RTS

;!======

    ; Alignment
    ALIGN_WORD
