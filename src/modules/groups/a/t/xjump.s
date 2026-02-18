    XDEF    GROUP_AT_JMPTBL_DOS_SystemTagList
    XDEF    GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit0
    XDEF    GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit1

;------------------------------------------------------------------------------
; FUNC: GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit0   (JumpStub_ED1_WaitForFlagAndClearBit0)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   (none)
; CALLS:
;   ED1_WaitForFlagAndClearBit0
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to ED1_WaitForFlagAndClearBit0.
;------------------------------------------------------------------------------
GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit0:
    JMP     ED1_WaitForFlagAndClearBit0

;------------------------------------------------------------------------------
; FUNC: GROUP_AT_JMPTBL_DOS_SystemTagList   (JumpStub_DOS_SystemTagList)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   (none)
; CALLS:
;   DOS_SystemTagList
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to DOS_SystemTagList.
;------------------------------------------------------------------------------
GROUP_AT_JMPTBL_DOS_SystemTagList:
    JMP     DOS_SystemTagList

;------------------------------------------------------------------------------
; FUNC: GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit1   (JumpStub_ED1_WaitForFlagAndClearBit1)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   (none)
; CALLS:
;   ED1_WaitForFlagAndClearBit1
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to ED1_WaitForFlagAndClearBit1.
;------------------------------------------------------------------------------
GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit1:
    JMP     ED1_WaitForFlagAndClearBit1

;!======

    ; Alignment
    MOVEQ   #97,D0
