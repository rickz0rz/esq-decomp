    XDEF    GROUP_MAIN_B_JMPTBL_BUFFER_FlushAllAndCloseWithCode
    XDEF    GROUP_MAIN_B_JMPTBL_DOS_Delay
    XDEF    GROUP_MAIN_B_JMPTBL_MATH_Mulu32
    XDEF    GROUP_MAIN_B_JMPTBL_STREAM_BufferedWriteString

;------------------------------------------------------------------------------
; FUNC: GROUP_MAIN_B_JMPTBL_DOS_Delay   (Routine at GROUP_MAIN_B_JMPTBL_DOS_Delay)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DOS_Delay
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
GROUP_MAIN_B_JMPTBL_DOS_Delay:
    JMP     DOS_Delay

;------------------------------------------------------------------------------
; FUNC: GROUP_MAIN_B_JMPTBL_STREAM_BufferedWriteString   (Routine at GROUP_MAIN_B_JMPTBL_STREAM_BufferedWriteString)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STREAM_BufferedWriteString
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
GROUP_MAIN_B_JMPTBL_STREAM_BufferedWriteString:
    JMP     STREAM_BufferedWriteString

;------------------------------------------------------------------------------
; FUNC: GROUP_MAIN_B_JMPTBL_MATH_Mulu32   (Routine at GROUP_MAIN_B_JMPTBL_MATH_Mulu32)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   MATH_Mulu32
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
GROUP_MAIN_B_JMPTBL_MATH_Mulu32:
    JMP     MATH_Mulu32

;------------------------------------------------------------------------------
; FUNC: GROUP_MAIN_B_JMPTBL_BUFFER_FlushAllAndCloseWithCode   (Routine at GROUP_MAIN_B_JMPTBL_BUFFER_FlushAllAndCloseWithCode)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   BUFFER_FlushAllAndCloseWithCode
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
GROUP_MAIN_B_JMPTBL_BUFFER_FlushAllAndCloseWithCode:
    JMP     BUFFER_FlushAllAndCloseWithCode

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000
