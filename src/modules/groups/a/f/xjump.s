    XDEF    _GROUP_AF_JMPTBL_GCOMMAND_SaveBrushResult

;------------------------------------------------------------------------------
; FUNC: _GROUP_AF_JMPTBL_GCOMMAND_SaveBrushResult   (JumpStub_GCOMMAND_SaveBrushResult)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   _GCOMMAND_SaveBrushResult
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to _GCOMMAND_SaveBrushResult.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_GROUP_AF_JMPTBL_GCOMMAND_SaveBrushResult:
    JMP     _GCOMMAND_SaveBrushResult

;!======

    ; Alignment
    MOVEQ   #97,D0
    RTS
    ALIGN_WORD
