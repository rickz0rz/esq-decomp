    XDEF    _DST_HandleBannerCommand32_33



;------------------------------------------------------------------------------
; FUNC: _DST_HandleBannerCommand32_33   (Handle banner command $32/$33 and enqueue text)
; ARGS:
;   stack +7: arg_1 (via 11(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +18: arg_3 (via 22(A5))
;   stack +40: arg_4 (via 44(A5))
;   stack +48: arg_5 (via 52(A5))
; RET:
;   D0: none
; CLOBBERS:
;   A3/A7/D0/D7
; CALLS:
;   _DATETIME_ParseString, _DATETIME_CopyPairAndRecalc, _DST_UpdateBannerQueue
; READS:
;   _DST_BannerWindowSecondary, _DST_BannerWindowPrimary
; WRITES:
;   (none observed)
; DESC:
;   Parses two string segments and enqueues them to the appropriate buffer.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DST_HandleBannerCommand32_33:
    LINK.W  A5,#-44
    MOVEM.L D7/A3,-(A7)
    MOVE.B  11(A5),D7
    MOVEA.L 12(A5),A3
    MOVE.B  D7,D0
    EXT.W   D0
    SUBI.W  #$32,D0
    BEQ.S   .case_cmd_32

    SUBQ.W  #1,D0
    BEQ.S   .case_cmd_33

    BRA.S   .return

.case_cmd_32:
    ; Parse two string segments and enqueue into _DST_BannerWindowSecondary.
    PEA     4.W
    MOVE.L  A3,-(A7)
    PEA     -22(A5)
    BSR.W   _DATETIME_ParseString

    PEA     19.W
    MOVE.L  A3,-(A7)
    PEA     -44(A5)
    BSR.W   _DATETIME_ParseString

    PEA     -44(A5)
    PEA     -22(A5)
    MOVE.L  _DST_BannerWindowSecondary,-(A7)
    BSR.W   _DATETIME_CopyPairAndRecalc

    LEA     36(A7),A7
    BRA.S   .return

.case_cmd_33:
    ; Parse two string segments and enqueue into _DST_BannerWindowPrimary.
    PEA     4.W
    MOVE.L  A3,-(A7)
    PEA     -22(A5)
    BSR.W   _DATETIME_ParseString

    PEA     19.W
    MOVE.L  A3,-(A7)
    PEA     -44(A5)
    BSR.W   _DATETIME_ParseString

    PEA     -44(A5)
    PEA     -22(A5)
    MOVE.L  _DST_BannerWindowPrimary,-(A7)
    BSR.W   _DATETIME_CopyPairAndRecalc

    LEA     36(A7),A7

.return:
    PEA     _DST_BannerWindowPrimary
    BSR.W   _DST_UpdateBannerQueue

    MOVEM.L -52(A5),D7/A3
    UNLK    A5
    RTS

;!======