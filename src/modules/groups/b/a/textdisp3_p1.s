    XDEF    TEXTDISP_FindControlToken



;------------------------------------------------------------------------------
; FUNC: TEXTDISP_FindControlToken   (Find control token in text)
; ARGS:
;   stack +8: textPtr (A3)
; RET:
;   D0: pointer to control token, or 0 if none
; CLOBBERS:
;   D0/A3
; DESC:
;   Scans for 0x80+ control tokens in a known opcode set.
; NOTES:
;   Returns the first matching token byte.
;   Control tokens: 0x84, 0x85, 0x86, 0x87, 0x8C, 0x8D, 0x8F, 0x90, 0x93, 0x99, 0x9A, 0x9B, 0xA3
;------------------------------------------------------------------------------
TEXTDISP_FindControlToken:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3

.scan_loop:
    TST.B   (A3)
    BEQ.S   .not_found

    BTST    #7,(A3)
    BEQ.S   .skip_byte

    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    SUBI.W  #$84,D0
    BEQ.S   .found_token

    SUBQ.W  #1,D0
    BEQ.S   .found_token

    SUBQ.W  #1,D0
    BEQ.S   .found_token

    SUBQ.W  #1,D0
    BEQ.S   .found_token

    SUBQ.W  #5,D0
    BEQ.S   .found_token

    SUBQ.W  #1,D0
    BEQ.S   .found_token

    SUBQ.W  #2,D0
    BEQ.S   .found_token

    SUBQ.W  #1,D0
    BEQ.S   .found_token

    SUBQ.W  #3,D0
    BEQ.S   .found_token

    SUBQ.W  #6,D0
    BEQ.S   .found_token

    SUBQ.W  #1,D0
    BEQ.S   .found_token

    SUBQ.W  #1,D0
    BEQ.S   .found_token

    SUBQ.W  #8,D0
    BNE.S   .skip_byte

.found_token:
    MOVE.L  A3,D0
    BRA.S   .return

.skip_byte:
    ADDQ.L  #1,A3
    BRA.S   .scan_loop

.not_found:
    MOVEQ   #0,D0

.return:
    MOVEA.L (A7)+,A3
    RTS

;!======