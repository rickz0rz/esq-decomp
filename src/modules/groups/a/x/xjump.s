    XDEF    _GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer

;------------------------------------------------------------------------------
; FUNC: _GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer   (Routine at _GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   _FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer:
    JMP     _FORMAT_RawDoFmtWithScratchBuffer

;!======

    ; Alignment
    MOVEQ   #97,D0
