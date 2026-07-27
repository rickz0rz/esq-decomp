    XDEF    _CLEANUP_ReleaseDisplayResources


;------------------------------------------------------------------------------
; FUNC: _CLEANUP_ReleaseDisplayResources
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/D7/A0-A1/A6
; CALLS:
;   _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, _GROUP_AB_JMPTBL_GRAPHICS_FreeRaster,
;   _LVOCloseFont, _LVOCloseLibrary
; READS:
;   _Global_REF_96_BYTES_ALLOCATED, _Global_REF_RASTPORT_1, _WDISP_LivePlaneRasterTable0, _WDISP_352x240RasterPtrTable,
;   _WDISP_BannerRowScratchRasterTable0, _WDISP_DisplayContextPlanePointer0, _WDISP_BannerWorkRasterPtr, _Global_HANDLE_PREVUE_FONT,
;   _Global_HANDLE_TOPAZ_FONT, _Global_HANDLE_H26F_FONT, _Global_HANDLE_PREVUEC_FONT,
;   _Global_REF_UTILITY_LIBRARY, _Global_REF_DISKFONT_LIBRARY,
;   _Global_REF_DOS_LIBRARY, _Global_REF_INTUITION_LIBRARY, Global_REF_GRAPHICS_LIBRARY,
;   _Global_STR_CLEANUP_C_6, _Global_STR_CLEANUP_C_7, _Global_STR_CLEANUP_C_8,
;   _Global_STR_CLEANUP_C_9, _Global_STR_CLEANUP_C_10, _Global_STR_CLEANUP_C_11,
;   _Global_STR_CLEANUP_C_12
; WRITES:
;   (none)
; DESC:
;   Frees rastport memory, raster allocations, and closes font/library handles.
; NOTES:
;   - Iterates over multiple raster pointer tables to free each entry.
;------------------------------------------------------------------------------
_CLEANUP_ReleaseDisplayResources:
    MOVE.L  D7,-(A7)

    PEA     96.W
    MOVE.L  _Global_REF_96_BYTES_ALLOCATED,-(A7)
    PEA     148.W
    PEA     _Global_STR_CLEANUP_C_6
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    PEA     100.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    PEA     152.W
    PEA     _Global_STR_CLEANUP_C_7
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     32(A7),A7
    MOVEQ   #0,D7

.freeRaster_set1_loop:
    MOVEQ   #3,D0
    CMP.L   D0,D7
    BGE.S   .after_raster_set1

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _WDISP_LivePlaneRasterTable0,A0
    ADDA.L  D0,A0
    PEA     2.W
    PEA     696.W
    MOVE.L  (A0),-(A7)
    PEA     160.W
    PEA     _Global_STR_CLEANUP_C_8
    JSR     _GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(PC)

    LEA     20(A7),A7
    ADDQ.L  #1,D7
    BRA.S   .freeRaster_set1_loop

.after_raster_set1:
    MOVEQ   #0,D7

.freeRaster_set2_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .after_raster_set2

    MOVE.L  D7,D1
    ASL.L   #2,D1
    LEA     _WDISP_352x240RasterPtrTable,A0
    ADDA.L  D1,A0
    PEA     240.W
    PEA     352.W
    MOVE.L  (A0),-(A7)
    PEA     169.W
    PEA     _Global_STR_CLEANUP_C_9
    JSR     _GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(PC)

    LEA     20(A7),A7
    ADDQ.L  #1,D7
    BRA.S   .freeRaster_set2_loop

.after_raster_set2:
    MOVEQ   #0,D7

.freeRaster_set3_loop:
    MOVEQ   #3,D0
    CMP.L   D0,D7
    BGE.S   .after_raster_set3

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _WDISP_BannerRowScratchRasterTable0,A0
    ADDA.L  D0,A0
    PEA     509.W
    PEA     696.W
    MOVE.L  (A0),-(A7)
    PEA     178.W
    PEA     _Global_STR_CLEANUP_C_10
    JSR     _GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(PC)

    LEA     20(A7),A7
    ADDQ.L  #1,D7
    BRA.S   .freeRaster_set3_loop

.after_raster_set3:
    MOVEQ   #3,D7

.freeRaster_set4_loop:
    MOVEQ   #5,D0
    CMP.L   D0,D7
    BGE.S   .after_raster_set4

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _WDISP_DisplayContextPlanePointer0,A0
    ADDA.L  D0,A0
    PEA     241.W
    PEA     696.W
    MOVE.L  (A0),-(A7)
    PEA     187.W
    PEA     _Global_STR_CLEANUP_C_11
    JSR     _GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(PC)

    LEA     20(A7),A7
    ADDQ.L  #1,D7
    BRA.S   .freeRaster_set4_loop

.after_raster_set4:
    PEA     15.W
    PEA     696.W
    MOVE.L  _WDISP_BannerWorkRasterPtr,-(A7)
    PEA     200.W
    PEA     _Global_STR_CLEANUP_C_12
    JSR     _GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(PC)

    LEA     20(A7),A7

    TST.L   _Global_HANDLE_PREVUE_FONT
    BEQ.S   .closeTopazFont

    MOVEA.L _Global_HANDLE_PREVUE_FONT,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOCloseFont(A6)

.closeTopazFont:
    TST.L   _Global_HANDLE_TOPAZ_FONT
    BEQ.S   .closeH26fFont

    MOVEA.L _Global_HANDLE_TOPAZ_FONT,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOCloseFont(A6)

.closeH26fFont:
    TST.L   _Global_HANDLE_H26F_FONT
    BEQ.S   .closePrevueCFont

    MOVEA.L _Global_HANDLE_H26F_FONT,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOCloseFont(A6)

.closePrevueCFont:
    TST.L   _Global_HANDLE_PREVUEC_FONT
    BEQ.S   .closeUtilityLibrary

    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOCloseFont(A6)

.closeUtilityLibrary:
    TST.L   _Global_REF_UTILITY_LIBRARY
    BEQ.S   .closeDiskfontLibrary

    MOVEA.L _Global_REF_UTILITY_LIBRARY,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCloseLibrary(A6)

.closeDiskfontLibrary:
    MOVEA.L _Global_REF_DISKFONT_LIBRARY,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCloseLibrary(A6)

    MOVEA.L _Global_REF_DOS_LIBRARY,A1
    JSR     _LVOCloseLibrary(A6)

    MOVEA.L _Global_REF_INTUITION_LIBRARY,A1
    JSR     _LVOCloseLibrary(A6)

    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A1
    JSR     _LVOCloseLibrary(A6)

    MOVE.L  (A7)+,D7
    RTS

;!======