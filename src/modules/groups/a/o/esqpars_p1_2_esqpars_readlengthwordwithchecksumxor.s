    XDEF    _ESQPARS_ReadLengthWordWithChecksumXor
    XDEF    ESQPARS_ReadLengthWordWithChecksumXor_Return


;------------------------------------------------------------------------------
; FUNC: _ESQPARS_ReadLengthWordWithChecksumXor   (Read 2-byte length with rolling XOR)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1/D5/D6/D7
; CALLS:
;   _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte, _ESQFUNC_WaitForClockChangeAndServiceUi
; READS:
;   _ESQIFF_RecordLength
; WRITES:
;   _ESQIFF_RecordLength
; DESC:
;   Reads two serial bytes, left-shifts/accumulates into _ESQIFF_RecordLength,
;   and updates caller-supplied XOR accumulator byte.
; NOTES:
;   Waits for UI/clock servicing before each byte read to avoid parser stalls.
;------------------------------------------------------------------------------
_ESQPARS_ReadLengthWordWithChecksumXor:
    MOVEM.L D5-D7,-(A7)
    MOVE.B  19(A7),D7
    MOVEQ   #0,D0
    MOVE.W  D0,_ESQIFF_RecordLength
    MOVE.L  D0,D5

.length_byte_loop:
    MOVEQ   #2,D0
    CMP.W   D0,D5
    BGE.S   ESQPARS_ReadLengthWordWithChecksumXor_Return

    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.L  D0,D6
    EOR.B   D6,D7
    MOVEQ   #0,D0
    MOVE.W  _ESQIFF_RecordLength,D0
    ASL.L   #8,D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    ADD.L   D1,D0
    MOVE.W  D0,_ESQIFF_RecordLength
    ADDQ.W  #1,D5
    BRA.S   .length_byte_loop

;------------------------------------------------------------------------------
; FUNC: ESQPARS_ReadLengthWordWithChecksumXor_Return   (Return XOR accumulator for length bytes)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D5
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Returns final checksum XOR accumulator in D0 and restores D5-D7.
; NOTES:
;   Shared return target from both normal exit and read-loop bound check.
;------------------------------------------------------------------------------
ESQPARS_ReadLengthWordWithChecksumXor_Return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D5-D7
    RTS

;!======