    XDEF    _NEWGRID_InitShowtimeBuckets

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_InitShowtimeBuckets   (Initialize showtime bucket pointer/index tables)
; ARGS:
;   none
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A2
; CALLS:
;   none
; READS:
;   _NEWGRID_ShowtimeBucketEntryTable
; WRITES:
;   _NEWGRID_ShowtimeBucketPtrTable, _NEWGRID_ShowtimeBucketEntryTable
; DESC:
;   Initializes pointer tables for showtime bucket storage.
;------------------------------------------------------------------------------
_NEWGRID_InitShowtimeBuckets:
    MOVEM.L D7/A2,-(A7)
    MOVEQ   #0,D7

.bucket_loop:
    MOVEQ   #10,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _NEWGRID_ShowtimeBucketPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    ASL.L   #3,D0
    LEA     _NEWGRID_ShowtimeBucketEntryTable,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    MOVE.L  A2,(A0)
    ADDA.L  D0,A1
    CLR.L   4(A1)
    ADDQ.L  #1,D7
    BRA.S   .bucket_loop

.return:
    MOVEM.L (A7)+,D7/A2
    RTS

;!======
