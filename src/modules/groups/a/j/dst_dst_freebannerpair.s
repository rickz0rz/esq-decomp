    XDEF    _DST_FreeBannerPair


;------------------------------------------------------------------------------
; FUNC: _DST_FreeBannerPair   (Free both banner structs referenced by the pair.)
; ARGS:
;   (none observed)
; RET:
;   D0: none
; CLOBBERS:
;   A3/A7
; CALLS:
;   _DST_FreeBannerStruct
; READS:
;   A3+0/4 (banner struct pointers)
; WRITES:
;   A3+0/4
; DESC:
;   Frees both banner structs referenced by the pair and clears the pointers.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DST_FreeBannerPair:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    ; Free both banner structs referenced by the pair.
    MOVE.L  (A3),-(A7)
    BSR.S   _DST_FreeBannerStruct

    CLR.L   (A3)
    MOVE.L  4(A3),(A7)
    BSR.S   _DST_FreeBannerStruct

    ADDQ.W  #4,A7
    CLR.L   4(A3)
    MOVEA.L (A7)+,A3
    RTS

;!======