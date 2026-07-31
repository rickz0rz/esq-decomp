    XDEF    _NEWGRID_AppendShowtimeBuckets


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_AppendShowtimeBuckets   (Append showtime buckets to buffer)
; ARGS:
;   stack +8: A3 = output buffer
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _PARSEINI_JMPTBL_STRING_AppendAtNull
; READS:
;   _NEWGRID_ShowtimeBucketPtrTable, _NEWGRID_ShowtimeBucketCount, _NEWGRID_ShowtimeBucketSeparator
; WRITES:
;   output buffer contents
; DESC:
;   Appends each bucket’s data into the output buffer.
;------------------------------------------------------------------------------
_NEWGRID_AppendShowtimeBuckets:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEA.L _NEWGRID_ShowtimeBucketPtrTable,A0
    MOVE.L  4(A0),-(A7)
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    MOVEQ   #1,D7

.append_loop:
    CMP.L   _NEWGRID_ShowtimeBucketCount,D7
    BGE.S   .return

    PEA     _NEWGRID_ShowtimeBucketSeparator
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _NEWGRID_ShowtimeBucketPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  4(A1),(A7)
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D7
    BRA.S   .append_loop

.return:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======