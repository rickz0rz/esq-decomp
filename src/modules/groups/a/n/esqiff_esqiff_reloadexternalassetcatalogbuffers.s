    XDEF    _ESQIFF_ReloadExternalAssetCatalogBuffers


;------------------------------------------------------------------------------
; FUNC: _ESQIFF_ReloadExternalAssetCatalogBuffers   (Reload external asset catalog blobs and reset brush lists)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A6/A7/D0/D1/D2/D3/D6/D7
; CALLS:
;   _ESQIFF_JMPTBL_BRUSH_FreeBrushList, _ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle, _ESQIFF_JMPTBL_MEMORY_AllocateMemory, _ESQIFF_JMPTBL_MEMORY_DeallocateMemory, _ESQIFF_JMPTBL_DOS_OpenFileWithMode, _LVOClose, _LVOForbid, _LVOPermit, _LVORead
; READS:
;   AbsExecBase, _Global_PTR_STR_DF0_LOGO_LST, _Global_PTR_STR_GFX_G_ADS, _Global_REF_DOS_LIBRARY_2, _Global_REF_LONG_DF0_LOGO_LST_DATA, _Global_REF_LONG_DF0_LOGO_LST_FILESIZE, _Global_REF_LONG_GFX_G_ADS_DATA, _Global_REF_LONG_GFX_G_ADS_FILESIZE, _Global_STR_ESQIFF_C_3, _Global_STR_ESQIFF_C_4, _Global_STR_ESQIFF_C_5, _Global_STR_ESQIFF_C_6, _CTASKS_IffTaskDoneFlag, _ED_DiagGraphModeChar, _ESQIFF_GAdsBrushListHead, _ESQIFF_LogoBrushListHead, _SCRIPT_CtrlInterfaceEnabledFlag, _ESQIFF_ExternalAssetFlags, _DISKIO_Drive0WriteProtectedCode, _DISKIO_DriveWriteProtectStatusCodeDrive1, MEMF_PUBLIC, MODE_OLDFILE
; WRITES:
;   _Global_REF_LONG_DF0_LOGO_LST_DATA, _Global_REF_LONG_DF0_LOGO_LST_FILESIZE, _Global_REF_LONG_GFX_G_ADS_DATA, _Global_REF_LONG_GFX_G_ADS_FILESIZE, _ESQIFF_GAdsBrushListCount, _ESQIFF_LogoBrushListCount, _ESQIFF_ExternalAssetFlags, _ESQIFF_LogoListLineIndex, _ESQIFF_GAdsListLineIndex
; DESC:
;   Frees current external brush lists/catalog buffers, reloads `gfx/g_ads.data`
;   and optionally `df0:logo.lst`, and sets availability bits on successful reads.
; NOTES:
;   Logo-list reload is skipped when the caller mode is non-zero or drive is write-protected.
;------------------------------------------------------------------------------
_ESQIFF_ReloadExternalAssetCatalogBuffers:
    MOVEM.L D2-D3/D6-D7,-(A7)

    SetOffsetForStack   4
    ; UseStackLong    MOVE.L,1,D7
    EmitStackAddress    1
    MOVE.L  .stackLong1(A7),D7

    TST.W   _CTASKS_IffTaskDoneFlag
    BEQ.W   .return

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.W   .maybe_reload_logo_catalog

    MOVE.B  _ED_DiagGraphModeChar,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BEQ.W   .maybe_reload_logo_catalog

    TST.L   _DISKIO_DriveWriteProtectStatusCodeDrive1
    BNE.W   .maybe_reload_logo_catalog

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    CLR.L   -(A7)

    PEA     _ESQIFF_GAdsBrushListHead
    JSR     _ESQIFF_JMPTBL_BRUSH_FreeBrushList(PC)

    ADDQ.W  #8,A7

    MOVEQ   #0,D0
    MOVE.L  D0,_ESQIFF_GAdsBrushListCount
    CLR.W   _ESQIFF_GAdsListLineIndex
    MOVEA.L AbsExecBase,A6
    JSR     _LVOPermit(A6)

    TST.L   _Global_REF_LONG_GFX_G_ADS_DATA
    BEQ.S   .loadGfxGAdsFile

    TST.L   _Global_REF_LONG_GFX_G_ADS_FILESIZE
    BEQ.S   .loadGfxGAdsFile

    MOVE.L  _Global_REF_LONG_GFX_G_ADS_FILESIZE,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  _Global_REF_LONG_GFX_G_ADS_DATA,-(A7)
    PEA     882.W
    PEA     _Global_STR_ESQIFF_C_3
    JSR     _ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.loadGfxGAdsFile:
    CLR.L   _Global_REF_LONG_GFX_G_ADS_DATA
    CLR.L   _Global_REF_LONG_GFX_G_ADS_FILESIZE

    PEA     MODE_OLDFILE
    MOVE.L  _Global_PTR_STR_GFX_G_ADS,-(A7)
    JSR     _ESQIFF_JMPTBL_DOS_OpenFileWithMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D6
    TST.L   D6
    BLE.S   .update_gads_line_cursor_shadow

    MOVE.L  D6,-(A7)
    JSR     _ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,_Global_REF_LONG_GFX_G_ADS_FILESIZE
    TST.L   D0
    BLE.S   .gfxGAdsFileWithoutData

    ADDQ.L  #1,D0
    PEA     (MEMF_PUBLIC).W
    MOVE.L  D0,-(A7)
    PEA     898.W
    PEA     _Global_STR_ESQIFF_C_4
    JSR     _ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7

    MOVE.L  D0,_Global_REF_LONG_GFX_G_ADS_DATA
    MOVE.L  D6,D1
    MOVE.L  D0,D2
    MOVE.L  _Global_REF_LONG_GFX_G_ADS_FILESIZE,D3
    MOVEA.L _Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVORead(A6)

    CMP.L   _Global_REF_LONG_GFX_G_ADS_FILESIZE,D0
    BNE.S   .gfxGAdsFileWithoutData

    MOVE.W  _ESQIFF_ExternalAssetFlags,D0
    ORI.W   #1,D0
    MOVE.W  D0,_ESQIFF_ExternalAssetFlags

.gfxGAdsFileWithoutData:
    MOVE.L  D6,D1
    MOVEA.L _Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

.update_gads_line_cursor_shadow:
    TST.W   _SCRIPT_CtrlInterfaceEnabledFlag
    BEQ.S   .clear_gads_line_cursor_shadow

    MOVE.W  #1,_ESQIFF_GAdsListLineIndex
    BRA.S   .maybe_reload_logo_catalog

.clear_gads_line_cursor_shadow:
    CLR.W   _ESQIFF_GAdsListLineIndex

.maybe_reload_logo_catalog:
    TST.L   D7
    BNE.W   .return

    TST.L   _DISKIO_Drive0WriteProtectedCode
    BNE.W   .return

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    CLR.L   -(A7)
    PEA     _ESQIFF_LogoBrushListHead
    JSR     _ESQIFF_JMPTBL_BRUSH_FreeBrushList(PC)

    ADDQ.W  #8,A7
    MOVEQ   #0,D0
    MOVE.L  D0,_ESQIFF_LogoBrushListCount
    CLR.W   _ESQIFF_LogoListLineIndex
    MOVEA.L AbsExecBase,A6
    JSR     _LVOPermit(A6)

    TST.L   _Global_REF_LONG_DF0_LOGO_LST_DATA
    BEQ.S   .loadDf0LogoLstFile

    TST.L   _Global_REF_LONG_DF0_LOGO_LST_FILESIZE
    BEQ.S   .loadDf0LogoLstFile

    MOVE.L  _Global_REF_LONG_DF0_LOGO_LST_FILESIZE,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  _Global_REF_LONG_DF0_LOGO_LST_DATA,-(A7)
    PEA     963.W
    PEA     _Global_STR_ESQIFF_C_5
    JSR     _ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.loadDf0LogoLstFile:
    CLR.L   _Global_REF_LONG_DF0_LOGO_LST_DATA
    CLR.L   _Global_REF_LONG_DF0_LOGO_LST_FILESIZE
    PEA     MODE_OLDFILE
    MOVE.L  _Global_PTR_STR_DF0_LOGO_LST,-(A7)
    JSR     _ESQIFF_JMPTBL_DOS_OpenFileWithMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D6
    TST.L   D6
    BLE.S   .return

    MOVE.L  D6,-(A7)
    JSR     _ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,_Global_REF_LONG_DF0_LOGO_LST_FILESIZE
    TST.L   D0
    BLE.S   .df0LogoLstFileWithoutData

    ADDQ.L  #1,D0

    PEA     (MEMF_PUBLIC).W
    MOVE.L  D0,-(A7)
    PEA     979.W
    PEA     _Global_STR_ESQIFF_C_6
    JSR     _ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,_Global_REF_LONG_DF0_LOGO_LST_DATA
    MOVE.L  D6,D1
    MOVE.L  D0,D2
    MOVE.L  _Global_REF_LONG_DF0_LOGO_LST_FILESIZE,D3
    MOVEA.L _Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVORead(A6)

    CMP.L   _Global_REF_LONG_DF0_LOGO_LST_FILESIZE,D0
    BNE.S   .df0LogoLstFileWithoutData

    MOVE.W  _ESQIFF_ExternalAssetFlags,D0
    ORI.W   #2,D0
    MOVE.W  D0,_ESQIFF_ExternalAssetFlags

.df0LogoLstFileWithoutData:
    MOVE.L  D6,D1
    MOVEA.L _Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

.return:
    MOVEM.L (A7)+,D2-D3/D6-D7
    RTS

;!======