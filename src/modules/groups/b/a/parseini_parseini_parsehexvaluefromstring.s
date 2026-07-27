    XDEF    _PARSEINI_ParseHexValueFromString


;------------------------------------------------------------------------------
; FUNC: _PARSEINI_ParseHexValueFromString   (ParseHexValueFromStringuncertain)
; ARGS:
;   stack +8: A3 = pointer to hex string
; RET:
;   D0: parsed value
; CLOBBERS:
;   D0-D1/D7/A0/A3
; CALLS:
;   _SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit
; READS:
;   _WDISP_CharClassTable (char class table)
; WRITES:
;   (none)
; DESC:
;   Parses consecutive hex characters into a 32-bit value until a non-hex.
; NOTES:
;   Treats each nibble as upper-case hex via _LADFUNC_ParseHexDigit.
;------------------------------------------------------------------------------
_PARSEINI_ParseHexValueFromString:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7

.loop_13D5:
    MOVE.L  A3,D0
    BEQ.S   .return_13D6

    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    LEA     _WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   .return_13D6

    ASL.L   #4,D7
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     _SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    ADD.L   D1,D7
    ADDQ.L  #1,A3
    BRA.S   .loop_13D5

.return_13D6:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======