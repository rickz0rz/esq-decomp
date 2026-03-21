;------------------------------------------------------------------------------
; DECOMP TARGET 744
; SOURCE: modules/groups/a/x/xjump.s
; PURPOSE:
;   Direct object-level hybrid replacement for the GROUP_AX wrapper module.
;   This replaces the earlier passthrough boundary now that the maintained
;   restored SAS/C compare lane for the wrapper is green in this checkout.
;------------------------------------------------------------------------------

    XDEF    GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer

;------------------------------------------------------------------------------
; FUNC: GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer   (JumpStub_FORMAT_RawDoFmtWithScratchBuffer)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to FORMAT_RawDoFmtWithScratchBuffer.
; NOTES:
;   Mirrors the original wrapper module while keeping this replacement local.
;------------------------------------------------------------------------------
GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer:
    JMP     FORMAT_RawDoFmtWithScratchBuffer

;!======

    ; Alignment
    MOVEQ   #97,D0
