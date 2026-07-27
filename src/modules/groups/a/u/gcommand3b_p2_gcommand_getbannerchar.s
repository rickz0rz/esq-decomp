    XDEF    _GCOMMAND_GetBannerChar

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_GetBannerChar   (Return the current banner character stored at _ESQ_CopperListBannerA.)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A5/D0
; CALLS:
;   (none)
; READS:
;   _ESQ_CopperListBannerA
; WRITES:
;   (none observed)
; DESC:
;   Return the current banner character stored at _ESQ_CopperListBannerA.
; NOTES:
;   Reads byte 0 from `_ESQ_CopperListBannerA` and returns it zero-extended.
;------------------------------------------------------------------------------

; Return the current banner character stored at _ESQ_CopperListBannerA.
_GCOMMAND_GetBannerChar:
    LINK.W  A5,#-4
    MOVE.L  #_ESQ_CopperListBannerA,-4(A5)
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  (A0),D0
    UNLK    A5
    RTS

;!======