    XDEF    _NEWGRID_AddShowtimeBucketEntry


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_AddShowtimeBucketEntry   (Insert showtime bucket entry)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +16: arg_3 (via 20(A5))
; RET:
;   D0: 1 if inserted, 0 if not
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _PARSEINI_JMPTBL_STR_FindCharPtr, _SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, _PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString
; READS:
;   _NEWGRID_ShowtimeBucketEntryTable, _NEWGRID_ShowtimeBucketPtrTable, _NEWGRID_ShowtimeBucketCount
; WRITES:
;   _NEWGRID_ShowtimeBucketEntryTable, _NEWGRID_ShowtimeBucketPtrTable, _NEWGRID_ShowtimeBucketCount
; DESC:
;   Adds an entry into the sorted bucket list if capacity allows.
; NOTES:
;   Uses insertion-style shifting to keep buckets sorted.
;------------------------------------------------------------------------------
_NEWGRID_AddShowtimeBucketEntry:
    LINK.W  A5,#-28
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    CLR.L   -20(A5)
    PEA     58.W
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STR_FindCharPtr(PC)

    MOVEA.L D0,A0
    LEA     1(A0),A1
    MOVE.L  A1,(A7)
    MOVE.L  A1,-4(A5)
    JSR     _SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D6
    MOVE.L  D7,D0
    ASL.L   #8,D0
    ADD.L   D0,D6
    MOVE.L  _NEWGRID_ShowtimeBucketCount,D0
    MOVEQ   #10,D1
    CMP.L   D1,D0
    BGE.W   .return

    ASL.L   #3,D0
    LEA     _NEWGRID_ShowtimeBucketEntryTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  D6,(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    ADDA.L  D0,A0
    MOVE.L  4(A0),-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A1,32(A7)
    JSR     _PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVEA.L 24(A7),A0
    MOVE.L  D0,4(A0)
    MOVE.L  _NEWGRID_ShowtimeBucketCount,D5

.find_insert_pos:
    TST.L   D5
    BLE.S   .check_insert

    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     NEWGRID_ShowtimeBucketEntryTablePadLong,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    CMP.L   (A1),D6
    BGE.S   .check_insert

    SUBQ.L  #1,D5
    BRA.S   .find_insert_pos

.check_insert:
    TST.L   D5
    BEQ.S   .shift_needed

    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     NEWGRID_ShowtimeBucketEntryTablePadLong,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    CMP.L   (A1),D6
    BEQ.S   .return

.shift_needed:
    MOVE.L  _NEWGRID_ShowtimeBucketCount,D4

.shift_loop:
    CMP.L   D5,D4
    BLE.S   .store_bucket

    MOVE.L  D4,D0
    ASL.L   #2,D0
    LEA     _NEWGRID_ShowtimeBucketPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  D4,D0
    ASL.L   #2,D0
    LEA     NEWGRID_ShowtimeBucketEntryTablePadLong,A1
    ADDA.L  D0,A1
    MOVE.L  (A1),(A0)
    SUBQ.L  #1,D4
    BRA.S   .shift_loop

.store_bucket:
    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     _NEWGRID_ShowtimeBucketPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  _NEWGRID_ShowtimeBucketCount,D0
    MOVE.L  D0,D1
    ASL.L   #3,D1
    LEA     _NEWGRID_ShowtimeBucketEntryTable,A1
    ADDA.L  D1,A1
    MOVE.L  A1,(A0)
    ADDQ.L  #1,_NEWGRID_ShowtimeBucketCount
    MOVEQ   #1,D0
    MOVE.L  D0,-20(A5)

.return:
    MOVE.L  -20(A5),D0
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======