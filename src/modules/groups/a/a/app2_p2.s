
;------------------------------------------------------------------------------
; FUNC: ESQ_ClearCopperListFlags   (ClearCopperListFlagsuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   _ESQ_CopperListBannerA, _ESQ_CopperListBannerB
; DESC:
;   Clears the lead bytes of two copper list tables.
; NOTES:
;   Exact meaning of the cleared bytes is unknown.
;------------------------------------------------------------------------------
    MOVE.B  #0,D0
    MOVE.B  D0,_ESQ_CopperListBannerA
    MOVE.B  D0,_ESQ_CopperListBannerB
    RTS

;!======