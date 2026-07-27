    XDEF    _SCRIPT_GetBannerCharOrFallback


;------------------------------------------------------------------------------
; FUNC: _SCRIPT_GetBannerCharOrFallback   (GetBannerCharOrFallbackuncertain)
; ARGS:
;   (none)
; RET:
;   D0: banner char value
; CLOBBERS:
;   D0-D1/D7
; CALLS:
;   (none)
; READS:
;   _TEXTDISP_BannerCharSelected, _TEXTDISP_BannerCharFallback
; WRITES:
;   (none)
; DESC:
;   Returns _TEXTDISP_BannerCharSelected unless it is 100, in which case returns _TEXTDISP_BannerCharFallback.
; NOTES:
;   Likely selects a fallback character when a sentinel is present.
;------------------------------------------------------------------------------
_SCRIPT_GetBannerCharOrFallback:
    MOVE.L  D7,-(A7)
    MOVE.B  _TEXTDISP_BannerCharSelected,D0
    MOVEQ   #100,D1
    CMP.B   D1,D0
    BEQ.S   .return_fallback

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .return

.return_fallback:
    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_BannerCharFallback,D0
    MOVE.L  D0,D1

.return:
    MOVE.L  D1,D7
    MOVE.L  D7,D0
    MOVE.L  (A7)+,D7
    RTS

;!======