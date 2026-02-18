    XDEF    FORMAT_U32ToOctalString

;------------------------------------------------------------------------------
; FUNC: FORMAT_U32ToOctalString   (Format an unsigned value as octal ASCII.)
; ARGS:
;   stack +4: A0 = destination buffer
;   stack +8: D0 = value
; RET:
;   D0: length of output string (bytes, excluding NUL)
; CLOBBERS:
;   D0-D1/A0-A1
; DESC:
;   Emits octal digits into a temp stack buffer, then reverses into A0.
;------------------------------------------------------------------------------
FORMAT_U32ToOctalString:
    MOVE.L  8(A7),D0
    MOVEA.L 4(A7),A0
    LINK.W  A5,#-12
    MOVEA.L A7,A1

.digit_loop:
    MOVE.L  D0,D1
    ANDI.W  #7,D1
    ADDI.W  #$30,D1
    MOVE.B  D1,(A1)+
    LSR.L   #3,D0
    BNE.S   .digit_loop

    MOVE.L  A1,D0

.emit_loop:
    MOVE.B  -(A1),(A0)+
    CMPA.L  A1,A7
    BNE.S   .emit_loop

    CLR.B   (A0)
    SUB.L   A7,D0
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD
