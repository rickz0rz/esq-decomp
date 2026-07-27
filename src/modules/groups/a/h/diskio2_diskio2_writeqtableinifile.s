    XDEF    _DISKIO2_WriteQTableIniFile


;------------------------------------------------------------------------------
; FUNC: _DISKIO2_WriteQTableIniFile   (Write INI-style banner list to disk.)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +12: arg_2 (via 16(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A7/D0/D1/D7
; CALLS:
;   _DISKIO_OpenFileWithBuffer, _DISKIO_WriteBufferedBytes, _DISKIO_CloseBufferedFileAndFlush
; READS:
;   _TEXTDISP_AliasCount, _TEXTDISP_AliasPtrTable tables
; WRITES:
;   _DISKIO2_QTableIniFileHandle
; DESC:
;   Writes a banner list file using the current _TEXTDISP_AliasPtrTable entries.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DISKIO2_WriteQTableIniFile:
    LINK.W  A5,#-12
    MOVE.L  D7,-(A7)
    MOVE.L  #_DISKIO2_STR_QTABLE,-4(A5)
    MOVE.W  _TEXTDISP_AliasCount,D0
    MOVEQ   #1,D1
    CMP.W   D1,D0
    BGE.S   .writeqtable_open_file

    MOVEQ   #-1,D0
    BRA.W   .writeqtable_return

.writeqtable_open_file:
    PEA     MODE_NEWFILE.W
    PEA     _CTASKS_PATH_QTABLE_INI
    JSR     _DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_DISKIO2_QTableIniFileHandle
    TST.L   D0
    BEQ.S   .writeqtable_fail

    MOVE.W  _TEXTDISP_AliasCount,D0
    BNE.S   .writeqtable_write_header

.writeqtable_fail:
    MOVEQ   #-1,D0
    BRA.W   .writeqtable_return

.writeqtable_write_header:
    MOVEA.L -4(A5),A0

.writeqtable_scan_header_len:
    TST.B   (A0)+
    BNE.S   .writeqtable_scan_header_len

    SUBQ.L  #1,A0
    SUBA.L  -4(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  _DISKIO2_QTableIniFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    PEA     2.W
    PEA     _DISKIO2_STR_QTableLineBreakAfterHeader
    MOVE.L  _DISKIO2_QTableIniFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     24(A7),A7
    MOVEQ   #0,D7

    ; Emit each banner entry with separators.
.writeqtable_entry_loop:
    MOVE.W  _TEXTDISP_AliasCount,D0
    CMP.W   D0,D7
    BCC.W   .writeqtable_close_file

    MOVEQ   #0,D0
    MOVE.W  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_AliasPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    MOVEA.L -8(A5),A1
    MOVEA.L (A1),A0

.writeqtable_scan_key_len:
    ; Write first string field.
    TST.B   (A0)+
    BNE.S   .writeqtable_scan_key_len

    SUBQ.L  #1,A0
    SUBA.L  (A1),A0
    MOVE.L  A0,-(A7)
    MOVE.L  (A1),-(A7)
    MOVE.L  _DISKIO2_QTableIniFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    PEA     1.W
    PEA     _DISKIO2_STR_QTableEquals
    MOVE.L  _DISKIO2_QTableIniFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    PEA     1.W
    PEA     _DISKIO2_STR_QTableValueQuoteOpen
    MOVE.L  _DISKIO2_QTableIniFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    MOVEA.L -8(A5),A1
    MOVEA.L 4(A1),A0

.writeqtable_scan_value_len:
    ; Write second string field.
    TST.B   (A0)+
    BNE.S   .writeqtable_scan_value_len

    SUBQ.L  #1,A0
    SUBA.L  4(A1),A0
    MOVE.L  A0,(A7)
    MOVE.L  4(A1),-(A7)
    MOVE.L  _DISKIO2_QTableIniFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    PEA     1.W
    PEA     _DISKIO2_STR_QTableValueQuoteClose
    MOVE.L  _DISKIO2_QTableIniFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    PEA     2.W
    PEA     _DISKIO2_STR_QTableLineBreakAfterEntry
    MOVE.L  _DISKIO2_QTableIniFileHandle,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    LEA     68(A7),A7
    ADDQ.W  #1,D7
    BRA.W   .writeqtable_entry_loop

.writeqtable_close_file:
    MOVE.L  _DISKIO2_QTableIniFileHandle,-(A7)
    JSR     _DISKIO_CloseBufferedFileAndFlush(PC)

.writeqtable_return:
    MOVE.L  -16(A5),D7
    UNLK    A5
    RTS

;!======