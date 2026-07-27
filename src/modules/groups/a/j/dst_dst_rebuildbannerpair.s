    XDEF    _DST_RebuildBannerPair


;------------------------------------------------------------------------------
; FUNC: _DST_RebuildBannerPair   (Rebuild both banner structs in the pair)
; ARGS:
;   (none observed)
; RET:
;   D0: success flag (0/1?)
; CLOBBERS:
;   A3/A7/D0/D7
; CALLS:
;   _DST_FreeBannerPair, _DST_AllocateBannerStruct
; READS:
;   A3+0/4 (banner struct pointers)
; WRITES:
;   A3+0/4
; DESC:
;   Frees and re-allocates both banner structs referenced by the pair.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DST_RebuildBannerPair:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7
    ; Rebuild both banner structs in-place.
    MOVE.L  A3,-(A7)
    BSR.W   _DST_FreeBannerPair

    MOVE.L  (A3),(A7)
    BSR.W   _DST_AllocateBannerStruct

    ADDQ.W  #4,A7
    MOVE.L  D0,(A3)
    TST.L   D0
    BEQ.S   .alloc_failed

    MOVE.L  4(A3),-(A7)
    BSR.W   _DST_AllocateBannerStruct

    ADDQ.W  #4,A7
    MOVE.L  D0,4(A3)
    TST.L   (A3)
    BEQ.S   .alloc_failed

    MOVEQ   #1,D7

.alloc_failed:
    TST.W   D7
    BNE.S   .return

    MOVE.L  A3,-(A7)
    BSR.W   _DST_FreeBannerPair

    ADDQ.W  #4,A7

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======