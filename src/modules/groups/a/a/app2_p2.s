
;------------------------------------------------------------------------------
; FUNC: _ESQ_ClearCopperListFlags   (ClearCopperListFlagsuncertain)
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
;   This block carried no label. The extract for whatever precedes it ran
;   on into it and reported that function as larger than it is. The label
;   below is byte-neutral and separates the two again. It is deliberately
;   not XDEF'd: no other module refers to it.
;------------------------------------------------------------------------------
_ESQ_ClearCopperListFlags:
    MOVE.B  #0,D0
    MOVE.B  D0,_ESQ_CopperListBannerA
    MOVE.B  D0,_ESQ_CopperListBannerB
    RTS

;!======