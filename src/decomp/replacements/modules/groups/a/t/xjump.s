;------------------------------------------------------------------------------
; DECOMP TARGET group at xjump wrapper module boundary
; SOURCE: modules/groups/a/t/xjump.s
; PURPOSE:
;   Object-level hybrid replacement for the GROUP_AT xjump module now that the
;   wrapper-backed SAS/C compare lanes for GROUP_AT_JMPTBL_DOS_SystemTagList,
;   GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit0, and
;   GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit1 are green in this checkout.
;   This replacement carries the module body directly instead of delegating
;   back to the canonical asm include.
;------------------------------------------------------------------------------

    XDEF    GROUP_AT_JMPTBL_DOS_SystemTagList
    XDEF    GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit0
    XDEF    GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit1

;------------------------------------------------------------------------------
; FUNC: GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit0   (JumpStub_ED1_WaitForFlagAndClearBit0)
; ARGS:
;   (none observed)
; RET:
;   (none)
; CLOBBERS:
;   (none observed)
; CALLS:
;   ED1_WaitForFlagAndClearBit0
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to ED1_WaitForFlagAndClearBit0.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit0:
    JMP     ED1_WaitForFlagAndClearBit0

;------------------------------------------------------------------------------
; FUNC: GROUP_AT_JMPTBL_DOS_SystemTagList   (JumpStub_DOS_SystemTagList)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   DOS_SystemTagList
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to DOS_SystemTagList.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AT_JMPTBL_DOS_SystemTagList:
    JMP     DOS_SystemTagList

;------------------------------------------------------------------------------
; FUNC: GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit1   (JumpStub_ED1_WaitForFlagAndClearBit1)
; ARGS:
;   (none observed)
; RET:
;   (none)
; CLOBBERS:
;   (none observed)
; CALLS:
;   ED1_WaitForFlagAndClearBit1
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to ED1_WaitForFlagAndClearBit1.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit1:
    JMP     ED1_WaitForFlagAndClearBit1

;!======

    ; Alignment
    MOVEQ   #97,D0
    RTS
    ALIGN_WORD
