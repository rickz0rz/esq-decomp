    XDEF    _ESQIFF2_ReadSerialSizedTextRecord
    XDEF    ESQIFF2_ReadSerialSizedTextRecord_Return


;------------------------------------------------------------------------------
; FUNC: _ESQIFF2_ReadSerialSizedTextRecord   (Read sized serial text record with trailer validation)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   _ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte, _ESQFUNC_WaitForClockChangeAndServiceUi
; READS:
;   (none observed)
; WRITES:
;   _ESQIFF_RecordChecksumByte
; DESC:
;   Reads an initial sized text payload, parses a following signed trailer length,
;   reads that many trailing bytes, then validates completion before consuming and
;   storing the trailing checksum byte.
; NOTES:
;   Returns 0 and clears destination when trailer validation fails.
;------------------------------------------------------------------------------
_ESQIFF2_ReadSerialSizedTextRecord:
    LINK.W  A5,#-4
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 32(A7),A3
    MOVE.L  36(A7),D7
    TST.L   D7
    BLE.S   .reject_invalid_size

    CMPI.L  #$2328,D7
    BLT.S   .begin_initial_payload_read

.reject_invalid_size:
    MOVEQ   #0,D0
    BRA.W   ESQIFF2_ReadSerialSizedTextRecord_Return

.begin_initial_payload_read:
    MOVEQ   #0,D6
    MOVEQ   #0,D4

.loop_read_initial_payload:
    CMP.L   D7,D6
    BGE.S   .parse_trailer_length

    CMPI.L  #$2328,D6
    BGE.S   .parse_trailer_length

    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVE.L  D0,20(A7)
    JSR     _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.L  20(A7),D1
    MOVE.B  D0,0(A3,D1.L)
    ADDQ.L  #1,D6
    ADDQ.W  #1,D4
    BRA.S   .loop_read_initial_payload

.parse_trailer_length:
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    CLR.B   0(A3,D0.L)
    MOVE.L  A3,-(A7)
    JSR     _ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D5
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVE.B  #$20,0(A3,D0.L)
    MOVEQ   #0,D6

.loop_read_trailer_bytes:
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    TST.B   -1(A3,D0.L)
    BEQ.S   .validate_trailer_completion

    CMP.L   D5,D6
    BGE.S   .validate_trailer_completion

    CMPI.W  #$2328,D4
    BCC.S   .validate_trailer_completion

    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    MOVEQ   #0,D0
    MOVE.W  D4,D0
    MOVE.L  D0,20(A7)
    JSR     _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.L  20(A7),D1
    MOVE.B  D0,0(A3,D1.L)
    ADDQ.L  #1,D6
    ADDQ.W  #1,D4
    BRA.S   .loop_read_trailer_bytes

.validate_trailer_completion:
    MOVEQ   #0,D0
    MOVE.W  D4,D0
    TST.B   -1(A3,D0.L)
    BNE.S   .fail_trailer_validation

    CMP.L   D5,D6
    BEQ.S   .read_trailing_checksum

.fail_trailer_validation:
    MOVEQ   #0,D4
    CLR.B   (A3)
    BRA.S   .finish_sized_record_read

.read_trailing_checksum:
    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,_ESQIFF_RecordChecksumByte

.finish_sized_record_read:
    MOVE.L  D4,D0

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ReadSerialSizedTextRecord_Return   (Return tail for sized text serial reader)
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
;   Restores frame/registers and returns final text length/status.
; NOTES:
;   Shared return for reject, success, and validation-failure paths.
;------------------------------------------------------------------------------
ESQIFF2_ReadSerialSizedTextRecord_Return:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======