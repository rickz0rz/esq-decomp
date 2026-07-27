    XDEF    _ESQ_ReadSerialRbfByte


;------------------------------------------------------------------------------
; FUNC: _ESQ_ReadSerialRbfByte   (ReadSerialRbfByte)
; ARGS:
;   (none)
; RET:
;   D0: next byte from RBF ring buffer (low byte)
; CLOBBERS:
;   D0-D1, A0
; CALLS:
;   (none)
; READS:
;   _Global_WORD_T_VALUE, _Global_WORD_H_VALUE, _ESQPARS2_ReadModeFlags, _Global_REF_INTB_RBF_64K_BUFFER
; WRITES:
;   _Global_WORD_T_VALUE, _ESQPARS2_ReadModeFlags
; DESC:
;   Reads one byte from the RBF ring buffer and advances the tail index.
; NOTES:
;   Clears _ESQPARS2_ReadModeFlags when fill drops below $BB80 (if previously set to $102).
;------------------------------------------------------------------------------
_ESQ_ReadSerialRbfByte:
    MOVEQ   #0,D1
    MOVE.L  D1,D0
    MOVE.W  _Global_WORD_T_VALUE,D1
    MOVEA.L _Global_REF_INTB_RBF_64K_BUFFER,A0
    ADDA.L  D1,A0
    MOVE.B  (A0),D0
    ADDQ.W  #1,D1
    CMPI.W  #$fa00,D1
    BNE.S   .tail_update_done

    MOVEQ   #0,D1

.tail_update_done:
    MOVE.W  D1,_Global_WORD_T_VALUE
    MOVE.L  D0,-(A7)
    MOVE.W  _Global_WORD_H_VALUE,D0
    SUB.W   D1,D0
    BCC.W   .fill_count_ok

    ADDI.W  #$fa00,D0

.fill_count_ok:
    CMPI.W  #$102,_ESQPARS2_ReadModeFlags
    BNE.W   .return

    CMPI.W  #$bb80,D0   ; Box off.
    BCC.W   .return

    MOVE.W  #0,_ESQPARS2_ReadModeFlags

.return:
    MOVE.L  (A7)+,D0
    RTS

;!======