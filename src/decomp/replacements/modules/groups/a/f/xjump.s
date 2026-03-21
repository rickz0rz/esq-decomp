;------------------------------------------------------------------------------
; DECOMP TARGETS GROUP_AF wrapper module boundary
; SOURCE: modules/groups/a/f/xjump.s
; PURPOSE:
;   Object-level hybrid replacement for the GROUP_AF xjump wrapper now that
;   the restored SAS/C compare lane for GROUP_AF_JMPTBL_GCOMMAND_SaveBrushResult
;   is green in this checkout. This replacement carries the wrapper body
;   directly instead of delegating back to the canonical asm include.
;------------------------------------------------------------------------------

    XDEF    GROUP_AF_JMPTBL_GCOMMAND_SaveBrushResult

;------------------------------------------------------------------------------
; FUNC: GROUP_AF_JMPTBL_GCOMMAND_SaveBrushResult   (JumpStub_GCOMMAND_SaveBrushResult)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   GCOMMAND_SaveBrushResult
; READS:
;   (none observed)
; WRITES:
;   (none observed)
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
