    XDEF    _ESQ_HandleSerialRbfInterrupt



;------------------------------------------------------------------------------
; FUNC: _ESQ_HandleSerialRbfInterrupt
; ARGS:
;   A0: interrupt contextuncertain (reads 24(A0), writes 156(A0))
;   A1: base of receive ring bufferuncertain (offset by head index)
; RET:
;   D0: 0
; CLOBBERS:
;   D0-D1, A1
; CALLS:
;   (none)
; READS:
;   _Global_WORD_H_VALUE, _Global_WORD_T_VALUE, _Global_WORD_MAX_VALUE, _ESQPARS2_ReadModeFlags
; WRITES:
;   (A1+head), _ESQ_SerialRbfErrorCount, _Global_WORD_H_VALUE, _ESQ_SerialRbfFillLevel, _Global_WORD_MAX_VALUE,
;   _ESQPARS2_ReadModeFlags, _SCRIPT_SerialReadModeOverflowCount, 156(A0)
; DESC:
;   Stores a received byte into the RBF ring buffer, updates head/fill counts,
;   and tracks max fill and overflow threshold.
; NOTES:
;   Buffer wraps at $FA00. Sets _ESQPARS2_ReadModeFlags to $102 when fill reaches $DAC0.
;------------------------------------------------------------------------------
_ESQ_HandleSerialRbfInterrupt:
    MOVEQ   #0,D0
    MOVE.W  _Global_WORD_H_VALUE,D0
    ADDA.L  D0,A1
    MOVE.W  24(A0),D1
    MOVE.B  D1,(A1)
    BTST    #15,D1
    BEQ.S   .skip_error_count

    MOVE.W  _ESQ_SerialRbfErrorCount,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,_ESQ_SerialRbfErrorCount

.skip_error_count:
    ADDQ.W  #1,D0
    CMPI.W  #$fa00,D0
    BNE.S   .head_update_done

    MOVEQ   #0,D0

.head_update_done:
    MOVE.W  D0,_Global_WORD_H_VALUE
    MOVE.W  _Global_WORD_T_VALUE,D1
    SUB.W   D1,D0
    BCC.W   .fill_count_ok

    ADDI.W  #$fa00,D0

.fill_count_ok:
    MOVE.W  D0,_ESQ_SerialRbfFillLevel
    CMP.W   _Global_WORD_MAX_VALUE,D0
    BCS.W   .skip_max_update

    MOVE.W  D0,_Global_WORD_MAX_VALUE

.skip_max_update:
    CMPI.W  #$dac0,D0
    BCS.W   .return

    CMPI.W  #$102,_ESQPARS2_ReadModeFlags
    BEQ.W   .return

    MOVE.W  #$102,_ESQPARS2_ReadModeFlags
    ADDI.L  #$1,_SCRIPT_SerialReadModeOverflowCount

.return:
    MOVE.W  #$800,156(A0)
    RTS

;!======