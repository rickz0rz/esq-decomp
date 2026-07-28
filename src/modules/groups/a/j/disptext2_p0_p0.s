    XDEF    _DATETIME_BuildFromBaseDay


;!======
;------------------------------------------------------------------------------
; FUNC: _DATETIME_BuildFromBaseDay   (Build time struct from date/timeuncertain)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
;   stack +8: arg_3 (via 12(A5))
;   stack +14: arg_4 (via 18(A5))
;   stack +18: arg_5 (via 22(A5))
;   stack +32: arg_6 (via 36(A5))
; RET:
;   D0: seconds?
; CLOBBERS:
;   A2/A3/A5/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   _DATETIME_NormalizeStructToSeconds, _GROUP_AG_JMPTBL_MATH_Mulu32, _DATETIME_SecondsToStruct
; READS:
;   A2
; WRITES:
;   A2 fields, A2+14 cleared
; DESC:
;   Computes a derived time value and fills output fields.
; NOTES:
;   Uses offset of 0x36 and 0x0E10 scaling.
;------------------------------------------------------------------------------
_DATETIME_BuildFromBaseDay:
    LINK.W  A5,#-12
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  18(A5),D7
    MOVE.W  22(A5),D6
    MOVE.L  A3,-(A7)
    BSR.W   _DATETIME_NormalizeStructToSeconds

    ADDQ.W  #4,A7
    MOVE.L  D0,D5
    MOVE.L  D7,D0
    SUBI.W  #$36,D0
    MOVEM.W D0,-10(A5)
    MOVEQ   #1,D1
    CMP.W   D1,D6
    BNE.S   .flag_zero

    MOVEQ   #1,D1
    BRA.S   .flag_ready

.flag_zero:
    MOVEQ   #0,D1

.flag_ready:
    EXT.L   D0
    MOVE.W  D1,-12(A5)
    EXT.L   D1
    SUB.L   D1,D0
    MOVE.L  #$e10,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D5,D4
    ADD.L   D0,D4
    MOVE.L  A2,-(A7)
    MOVE.L  D4,-(A7)
    BSR.W   _DATETIME_SecondsToStruct

    CLR.W   14(A2)
    MOVE.L  D4,D0
    MOVEM.L -36(A5),D4-D7/A2-A3
    UNLK    A5
    RTS

;!======