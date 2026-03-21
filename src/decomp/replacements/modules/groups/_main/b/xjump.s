;------------------------------------------------------------------------------
; DECOMP TARGET group _main/b xjump wrapper module boundary
; SOURCE: modules/groups/_main/b/xjump.s
; PURPOSE:
;   Object-level hybrid replacement for the GROUP_MAIN_B xjump module now that
;   the wrapper-backed SAS/C compare lanes for
;   GROUP_MAIN_B_JMPTBL_BUFFER_FlushAllAndCloseWithCode,
;   GROUP_MAIN_B_JMPTBL_DOS_Delay, GROUP_MAIN_B_JMPTBL_MATH_Mulu32, and
;   GROUP_MAIN_B_JMPTBL_STREAM_BufferedWriteString are green in this checkout.
;   This replacement carries the module body directly instead of delegating
;   back to the canonical asm include.
;------------------------------------------------------------------------------

    XDEF    GROUP_MAIN_B_JMPTBL_BUFFER_FlushAllAndCloseWithCode
    XDEF    GROUP_MAIN_B_JMPTBL_DOS_Delay
    XDEF    GROUP_MAIN_B_JMPTBL_MATH_Mulu32
    XDEF    GROUP_MAIN_B_JMPTBL_STREAM_BufferedWriteString

;------------------------------------------------------------------------------
; FUNC: GROUP_MAIN_B_JMPTBL_DOS_Delay   (JumpStub_DOS_Delay)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   DOS_Delay
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to DOS_Delay.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_MAIN_B_JMPTBL_DOS_Delay:
    JMP     DOS_Delay

;------------------------------------------------------------------------------
; FUNC: GROUP_MAIN_B_JMPTBL_STREAM_BufferedWriteString   (JumpStub_STREAM_BufferedWriteString)
; ARGS:
;   (none observed)
; RET:
;   (none)
; CLOBBERS:
;   (none observed)
; CALLS:
;   STREAM_BufferedWriteString
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to STREAM_BufferedWriteString.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_MAIN_B_JMPTBL_STREAM_BufferedWriteString:
    JMP     STREAM_BufferedWriteString

;------------------------------------------------------------------------------
; FUNC: GROUP_MAIN_B_JMPTBL_MATH_Mulu32   (JumpStub_MATH_Mulu32)
; ARGS:
;   (none observed)
; RET:
;   D0: product
; CLOBBERS:
;   D0
; CALLS:
;   MATH_Mulu32
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to MATH_Mulu32.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_MAIN_B_JMPTBL_MATH_Mulu32:
    JMP     MATH_Mulu32

;------------------------------------------------------------------------------
; FUNC: GROUP_MAIN_B_JMPTBL_BUFFER_FlushAllAndCloseWithCode   (JumpStub_BUFFER_FlushAllAndCloseWithCode)
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
;   Jump stub to BUFFER_FlushAllAndCloseWithCode.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_MAIN_B_JMPTBL_BUFFER_FlushAllAndCloseWithCode:
    JMP     BUFFER_FlushAllAndCloseWithCode

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000
