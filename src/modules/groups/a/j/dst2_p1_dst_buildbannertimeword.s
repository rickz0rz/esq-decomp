    XDEF    _DST_BuildBannerTimeWord


;------------------------------------------------------------------------------
; FUNC: _DST_BuildBannerTimeWord   (Wrapper: call _DST_BuildBannerTimeEntry and return word.)
; ARGS:
;   stack +6: arg_1 (via 10(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +11: arg_3 (via 15(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1/D6/D7
; CALLS:
;   _DST_BuildBannerTimeEntry
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Calls _DST_BuildBannerTimeEntry and returns the computed word from stack temp.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DST_BuildBannerTimeWord:
    LINK.W  A5,#-4
    MOVEM.L D6-D7,-(A7)
    MOVE.W  10(A5),D7
    MOVE.B  15(A5),D6
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    CLR.L   -(A7)
    PEA     -2(A5)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   _DST_BuildBannerTimeEntry

    MOVE.W  -2(A5),D0
    MOVEM.L -12(A5),D6-D7
    UNLK    A5
    RTS

;!======