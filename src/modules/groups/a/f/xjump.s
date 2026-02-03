;!======
;------------------------------------------------------------------------------
; FUNC: GROUP_AF_JMPTBL_GCOMMAND_SaveBrushResult   (JumpStub_GCOMMAND_SaveBrushResult)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   GCOMMAND_SaveBrushResult
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Jump stub to GCOMMAND_SaveBrushResult.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AF_JMPTBL_GCOMMAND_SaveBrushResult:
    JMP     GCOMMAND_SaveBrushResult

;!======

    ; Alignment
    MOVEQ   #97,D0
    RTS
    ALIGN_WORD
