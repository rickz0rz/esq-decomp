    XDEF    GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer

;------------------------------------------------------------------------------
; FUNC: GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer   (Routine at GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer)
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
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer:
    JMP     FORMAT_RawDoFmtWithScratchBuffer

;!======

    ; Alignment
    MOVEQ   #97,D0
