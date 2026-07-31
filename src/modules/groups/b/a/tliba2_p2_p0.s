    XDEF    _TLIBA2_JMPTBL_DST_AddTimeOffset
    XDEF    _TLIBA2_JMPTBL_ESQ_TestBit1Based


    ; Alignment
    ALIGN_WORD

;!======

;------------------------------------------------------------------------------
; FUNC: _TLIBA2_JMPTBL_DST_AddTimeOffset   (JumpStub_DST_AddTimeOffset)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _DST_AddTimeOffset
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _DST_AddTimeOffset.
;------------------------------------------------------------------------------
_TLIBA2_JMPTBL_DST_AddTimeOffset:
    JMP     _DST_AddTimeOffset

;------------------------------------------------------------------------------
; FUNC: _TLIBA2_JMPTBL_ESQ_TestBit1Based   (JumpStub_ESQ_TestBit1Based)
; ARGS:
;   (none)
; RET:
;   D0: result from _ESQ_TestBit1Based
; CLOBBERS:
;   (none)
; CALLS:
;   _ESQ_TestBit1Based
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _ESQ_TestBit1Based.
;------------------------------------------------------------------------------
_TLIBA2_JMPTBL_ESQ_TestBit1Based:
    JMP     _ESQ_TestBit1Based

;!======

    ; Alignment
    RTS
    DC.W    $0000
