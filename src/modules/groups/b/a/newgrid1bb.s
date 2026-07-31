    XDEF    _NEWGRID_ResetShowtimeBuckets



;------------------------------------------------------------------------------
; FUNC: _NEWGRID_ResetShowtimeBuckets   (Reset showtime buckets)
; ARGS:
;   none
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1
; CALLS:
;   _PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString
; READS:
;   _NEWGRID_ShowtimeBucketEntryTable
; WRITES:
;   _NEWGRID_ShowtimeBucketCount, _NEWGRID_ShowtimeBucketEntryTable
; DESC:
;   Clears bucket count and reinitializes bucket records.
;------------------------------------------------------------------------------
_NEWGRID_ResetShowtimeBuckets:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D0
    MOVE.L  D0,_NEWGRID_ShowtimeBucketCount
    MOVE.L  D0,D7

.init_loop:
    MOVEQ   #10,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    ASL.L   #3,D0
    LEA     _NEWGRID_ShowtimeBucketEntryTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  #$3100,(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    ADDA.L  D0,A0
    MOVE.L  4(A0),-(A7)
    CLR.L   -(A7)
    MOVE.L  A1,16(A7)
    JSR     _PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVEA.L 8(A7),A0
    MOVE.L  D0,4(A0)
    ADDQ.L  #1,D7
    BRA.S   .init_loop

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======