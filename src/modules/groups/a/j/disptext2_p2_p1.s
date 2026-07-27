    XDEF    DATETIME_SavePairToFile

;------------------------------------------------------------------------------
; FUNC: DATETIME_SavePairToFile   (Save time structs to file)
; ARGS:
;   stack +8: A3 = struct pair
; RET:
;   D0: boolean success
; CLOBBERS:
;   A3/A7/D0/D7
; CALLS:
;   _DISKIO_OpenFileWithBuffer, _DISKIO_WriteBufferedBytes, _DATETIME_FormatPairToStream, _DISKIO_CloseBufferedFileAndFlush
; READS:
;   DST_DefaultDatPathPtr, DST_STR_G2_COLON, DST_STR_G3_COLON
; WRITES:
;   file
; DESC:
;   Writes formatted struct data to a file using a buffered handle.
; NOTES:
;   Requires both struct pointers to be non-null.
;------------------------------------------------------------------------------
DATETIME_SavePairToFile:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.L  A3,D0
    BEQ.S   .return_false

    TST.L   (A3)
    BEQ.S   .return_false

    TST.L   4(A3)
    BEQ.S   .return_false

    PEA     MODE_NEWFILE.W
    MOVE.L  DST_DefaultDatPathPtr,-(A7)
    JSR     _DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    TST.L   D7
    BEQ.S   .return_false

    PEA     4.W
    PEA     DST_STR_G2_COLON
    MOVE.L  D7,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    MOVE.L  4(A3),(A7)
    MOVE.L  D7,-(A7)
    BSR.W   _DATETIME_FormatPairToStream

    PEA     4.W
    PEA     DST_STR_G3_COLON
    MOVE.L  D7,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    MOVE.L  (A3),(A7)
    MOVE.L  D7,-(A7)
    BSR.W   _DATETIME_FormatPairToStream

    MOVE.L  D7,(A7)
    JSR     _DISKIO_CloseBufferedFileAndFlush(PC)

    LEA     32(A7),A7
    MOVEQ   #1,D0
    BRA.S   .return

.return_false:
    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,D7/A3
    RTS
