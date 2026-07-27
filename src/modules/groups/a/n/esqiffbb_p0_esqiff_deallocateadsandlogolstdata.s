    XDEF    _ESQIFF_DeallocateAdsAndLogoLstData


;------------------------------------------------------------------------------
; FUNC: _ESQIFF_DeallocateAdsAndLogoLstData   (Free loaded external catalog blobs)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0
; CALLS:
;   _ESQIFF_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   _Global_REF_LONG_DF0_LOGO_LST_DATA, _Global_REF_LONG_DF0_LOGO_LST_FILESIZE, _Global_REF_LONG_GFX_G_ADS_DATA, _Global_REF_LONG_GFX_G_ADS_FILESIZE, _Global_STR_ESQIFF_C_7, _Global_STR_ESQIFF_C_8
; WRITES:
;   _Global_REF_LONG_DF0_LOGO_LST_DATA, _Global_REF_LONG_DF0_LOGO_LST_FILESIZE, _Global_REF_LONG_GFX_G_ADS_DATA, _Global_REF_LONG_GFX_G_ADS_FILESIZE
; DESC:
;   Frees loaded `gfx/g_ads.data` and `df0:logo.lst` memory buffers when both
;   pointer and filesize are non-zero, then clears their globals.
; NOTES:
;   Passes `(size+1)` to deallocator, matching allocation strategy.
;------------------------------------------------------------------------------
_ESQIFF_DeallocateAdsAndLogoLstData:
    TST.L   _Global_REF_LONG_GFX_G_ADS_DATA
    BEQ.S   .deallocLogoLstData

    TST.L   _Global_REF_LONG_GFX_G_ADS_FILESIZE
    BEQ.S   .deallocLogoLstData

    MOVE.L  _Global_REF_LONG_GFX_G_ADS_FILESIZE,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  _Global_REF_LONG_GFX_G_ADS_DATA,-(A7)
    PEA     1988.W
    PEA     _Global_STR_ESQIFF_C_7
    JSR     _ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    CLR.L   _Global_REF_LONG_GFX_G_ADS_DATA
    CLR.L   _Global_REF_LONG_GFX_G_ADS_FILESIZE

.deallocLogoLstData:
    TST.L   _Global_REF_LONG_DF0_LOGO_LST_DATA
    BEQ.S   .return

    TST.L   _Global_REF_LONG_DF0_LOGO_LST_FILESIZE
    BEQ.S   .return

    MOVE.L  _Global_REF_LONG_DF0_LOGO_LST_FILESIZE,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  _Global_REF_LONG_DF0_LOGO_LST_DATA,-(A7)
    PEA     1994.W
    PEA     _Global_STR_ESQIFF_C_8
    JSR     _ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    CLR.L   _Global_REF_LONG_DF0_LOGO_LST_DATA
    CLR.L   _Global_REF_LONG_DF0_LOGO_LST_FILESIZE

.return:
    RTS

;!======