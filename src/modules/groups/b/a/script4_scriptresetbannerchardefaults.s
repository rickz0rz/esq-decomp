    XDEF    _SCRIPT_ResetBannerCharDefaults

;------------------------------------------------------------------------------
; FUNC: _SCRIPT_ResetBannerCharDefaults   (ResetBannerCharDefaultsuncertain)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   _TEXTDISP_BannerCharSelected, _TEXTDISP_BannerCharFallback, _TEXTDISP_CurrentMatchIndex
; DESC:
;   Resets banner-char defaults and clears the cached value.
; NOTES:
;   Values are hard-coded ($64, $31, -1) pending further context.
;------------------------------------------------------------------------------
_SCRIPT_ResetBannerCharDefaults:
    MOVE.B  #$64,_TEXTDISP_BannerCharSelected
    MOVE.B  #$31,_TEXTDISP_BannerCharFallback
    MOVE.W  #(-1),_TEXTDISP_CurrentMatchIndex
    RTS

;!======
