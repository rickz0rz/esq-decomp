    XDEF    _DST_WriteRtcFromGlobals


;------------------------------------------------------------------------------
; FUNC: _DST_WriteRtcFromGlobals   (Jump stub to PARSEINI RTC write helper)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _GROUP_AJ_JMPTBL_PARSEINI_WriteRtcFromGlobals
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin wrapper that dispatches _GROUP_AJ_JMPTBL_PARSEINI_WriteRtcFromGlobals.
; NOTES:
;   Kept as a local stub so DST queue code can call a stable in-module symbol.
;------------------------------------------------------------------------------
_DST_WriteRtcFromGlobals:
    JSR     _GROUP_AJ_JMPTBL_PARSEINI_WriteRtcFromGlobals(PC)

    RTS

;!======