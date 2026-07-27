    XDEF    _ESQIFF2_ReadSerialRecordIntoBuffer
    XDEF    ESQIFF2_ReadSerialRecordIntoBuffer_Return


;------------------------------------------------------------------------------
; FUNC: _ESQIFF2_ReadSerialRecordIntoBuffer   (Read serial record with delimiter handling)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +10: arg_2 (via 14(A5))
;   stack +14: arg_3 (via 18(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A5/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte, _ESQFUNC_WaitForClockChangeAndServiceUi
; READS:
;   (none observed)
; WRITES:
;   _ESQIFF_RecordChecksumByte
; DESC:
;   Reads a serial record into buffer until NUL or guard limits, with optional
;   handling of 0x14/0x12 escaped segments, then reads trailing checksum byte.
; NOTES:
;   Writes _ESQIFF_RecordChecksumByte and returns payload length in D0.
;------------------------------------------------------------------------------
_ESQIFF2_ReadSerialRecordIntoBuffer:
    LINK.W  A5,#-12
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.W  18(A5),D6
    MOVEQ   #0,D4
    MOVE.W  D4,-6(A5)

.loop_read_record_body:
    CMPI.W  #$2328,D4
    BCC.W   .read_and_store_trailing_checksum

    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVE.L  D0,20(A7)
    JSR     _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.L  20(A7),D1
    MOVE.B  D0,0(A3,D1.L)
    TST.B   D0
    BNE.S   .check_escape_or_delimiter_bytes

    TST.W   D7
    BNE.S   .guard_short_record_terminator

    BRA.W   .read_and_store_trailing_checksum

.guard_short_record_terminator:
    MOVEQ   #1,D0
    CMP.W   D0,D4
    BHI.W   .read_and_store_trailing_checksum

.check_escape_or_delimiter_bytes:
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVEQ   #20,D1
    CMP.B   0(A3,D0.L),D1
    BNE.S   .check_0x12_delimiter_case

    MOVEQ   #1,D0
    CMP.W   D0,D7
    BNE.S   .check_0x12_delimiter_case

    ADDQ.W  #1,D4
    MOVEQ   #0,D5

.loop_copy_0x14_extension:
    CMP.W   D6,D5
    BCC.S   .loop_read_record_body

    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    MOVE.L  D4,D0
    ADDQ.W  #1,D4
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,20(A7)
    JSR     _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.L  20(A7),D1
    MOVE.B  D0,0(A3,D1.L)
    ADDQ.W  #1,D5
    BRA.S   .loop_copy_0x14_extension

.check_0x12_delimiter_case:
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVEQ   #18,D1
    CMP.B   0(A3,D0.L),D1
    BNE.S   .advance_record_offset

    MOVEQ   #1,D0
    CMP.W   D0,D7
    BNE.S   .advance_record_offset

    ADDQ.W  #1,D4
    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    MOVE.L  D4,D0
    ADDQ.W  #1,D4
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,20(A7)
    JSR     _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.L  20(A7),D1
    MOVE.B  D0,0(A3,D1.L)
    ADDQ.W  #1,-6(A5)
    CMPI.W  #$12e,-6(A5)
    BCS.W   .loop_read_record_body

    MOVEQ   #0,D0
    BRA.S   ESQIFF2_ReadSerialRecordIntoBuffer_Return

.advance_record_offset:
    ADDQ.W  #1,D4
    BRA.W   .loop_read_record_body

.read_and_store_trailing_checksum:
    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,_ESQIFF_RecordChecksumByte
    MOVE.L  D4,D0

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ReadSerialRecordIntoBuffer_Return   (Return tail for serial record reader)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D4
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Restores frame/registers and returns payload length/status in D0.
; NOTES:
;   Shared return after guard failures, normal terminator, or extension-limit hit.
;------------------------------------------------------------------------------
ESQIFF2_ReadSerialRecordIntoBuffer_Return:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======