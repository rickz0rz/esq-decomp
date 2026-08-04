    XDEF    _DOS_STR_CRLF

;------------------------------------------------------------------------------
; DATA: _DOS_STR_CRLF   (the two bytes CR LF, plus alignment)
;
; THIS IS NOT CODE AND IT IS NOT A CALLBACK. The disassembly named it
; DOS_MovepWordReadCallback and rendered its first word as `MOVEP.W 0(A2),D6`,
; but MOVEP.W (d16,A2),D6 encodes as $0D0A -- which is CR LF. It is the
; line-ending constant the text-translate path writes.
;
; Its ONE use proves it. _STREAM_BufferedPutcOrFlush reaches it by ADDRESS, not
; by call, and hands it to DOS_WriteByIndex with a length of 2:
;
;     MOVEQ   #2,D1
;     MOVE.L  D1,-(A7)                ; length = 2
;     PEA     _DOS_STR_CRLF(PC)        ; buffer
;     MOVE.L  ...HandleIndex(A3),-(A7)
;     JSR     _DOS_WriteByIndex(PC)
;
; A callback would be reached with JSR and would not be passed a length.
;
; The bytes are unchanged: DC.B 13,10 is $0D0A, and the two zero words that
; follow are the same padding the MOVEP displacement word and the trailing
; DC.W accounted for. Both gates stay green across this relabelling.
;------------------------------------------------------------------------------
_DOS_STR_CRLF:
    DC.B    13,10
    DC.W    $0000
    DC.W    $0000

;!======