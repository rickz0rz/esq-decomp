    XDEF    _ED_LoadTextAdsFromDh2


;------------------------------------------------------------------------------
; FUNC: _ED_LoadTextAdsFromDh2   (Load text ads from DH2uncertain)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7/D7
; CALLS:
;   _ED_IsConfirmKey, _DISPLIB_DisplayTextAtPosition, _GROUP_AM_JMPTBL_LADFUNC_LoadTextAdsFromFile,
;   _ED_DrawESCMenuBottomHelp
; READS:
;   _Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Displays a loading message and invokes the text-ads load routine.
; NOTES:
;   Skips display/trigger if _ED_IsConfirmKey reports busy (D0 nonzero).
;------------------------------------------------------------------------------
_ED_LoadTextAdsFromDh2:
    MOVE.L  D7,-(A7)

    JSR     _ED_IsConfirmKey(PC)

    MOVE.L  D0,D7
    TST.B   D7
    BNE.S   .after_load_text_ads

    PEA     _Global_STR_LOADING_TEXT_ADS_FROM_DH2
    PEA     120.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    JSR     _GROUP_AM_JMPTBL_LADFUNC_LoadTextAdsFromFile(PC)

    LEA     16(A7),A7

.after_load_text_ads:
    JSR     _ED_DrawESCMenuBottomHelp(PC)

    MOVE.L  (A7)+,D7
    RTS

;!======