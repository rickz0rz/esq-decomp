    XDEF    _PARSEINI_ComputeHTCMaxValues


;------------------------------------------------------------------------------
; FUNC: _PARSEINI_ComputeHTCMaxValues   (Compute H/T delta maxuncertain)
; ARGS:
;   (none)
; RET:
;   D0: max delta (updated)
; CLOBBERS:
;   D0/D7
; CALLS:
;   none
; READS:
;   _Global_WORD_H_VALUE, _Global_WORD_T_VALUE, _Global_WORD_MAX_VALUE
; WRITES:
;   _Global_WORD_MAX_VALUE
; DESC:
;   Computes (H - T) modulo 64000, updating the stored max when larger.
; NOTES:
;   Wrap logic suggests a circular counter.
;------------------------------------------------------------------------------
_PARSEINI_ComputeHTCMaxValues:
    MOVE.L  D7,-(A7)

    MOVEQ   #0,D0
    MOVE.W  _Global_WORD_H_VALUE,D0
    MOVEQ   #0,D1
    MOVE.W  _Global_WORD_T_VALUE,D1
    SUB.L   D1,D0
    MOVE.L  D0,D7
    TST.L   D7
    BPL.S   .replaceMaxValue

    ADDI.L  #64000,D7

.replaceMaxValue:
    MOVEQ   #0,D0
    MOVE.W  _Global_WORD_MAX_VALUE,D0
    CMP.L   D7,D0
    BGE.S   .return

    MOVE.L  D7,D0
    MOVE.W  D0,_Global_WORD_MAX_VALUE

.return:
    MOVE.L  D7,D0
    MOVE.L  (A7)+,D7
    RTS

;!======