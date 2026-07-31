    XDEF    _DST_ComputeBannerIndex


;------------------------------------------------------------------------------
; FUNC: _DST_ComputeBannerIndex   (Compute banner index from time structuncertain)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +10: arg_2 (via 14(A5))
;   stack +15: arg_3 (via 19(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D1/D6/D7
; CALLS:
;   _DST_BuildBannerTimeEntry, _GROUP_AG_JMPTBL_MATH_DivS32
; READS:
;   8(A3), 10(A3), 18(A3)
; WRITES:
;   (none observed)
; DESC:
;   Calls _DST_BuildBannerTimeEntry and computes a derived index value.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DST_ComputeBannerIndex:
    LINK.W  A5,#-4
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.B  19(A5),D6
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    MOVE.L  A3,-(A7)
    PEA     -2(A5)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   _DST_BuildBannerTimeEntry

    LEA     16(A7),A7
    MOVE.W  8(A3),D0
    EXT.L   D0
    MOVEQ   #12,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    TST.W   18(A3)
    BEQ.S   .month_offset_zero

    MOVEQ   #12,D0
    BRA.S   .month_offset_ready

.month_offset_zero:
    MOVEQ   #0,D0

.month_offset_ready:
    ADD.L   D0,D1
    ADD.L   D1,D1
    CMPI.W  #$1d,10(A3)
    SGT     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    ADD.L   D0,D1
    BEQ.S   .set_nonzero_flag

    MOVEQ   #1,D0
    BRA.S   .nonzero_flag_ready

.set_nonzero_flag:
    MOVEQ   #0,D0

.nonzero_flag_ready:
    MOVE.L  D0,D7
    ADDI.W  #$26,D7
    MOVE.L  D7,D0
    EXT.L   D0
    DIVS    #$30,D0
    SWAP    D0
    MOVE.L  D0,D7
    ADDQ.W  #1,D7
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======