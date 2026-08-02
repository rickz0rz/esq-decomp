    XDEF    _GROUP_AT_JMPTBL_DOS_SystemTagList
    XDEF    _GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit0
    XDEF    _GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit1

;------------------------------------------------------------------------------
; FUNC: _GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit0   (JumpStub_ED1_WaitForFlagAndClearBit0)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   (none)
; CALLS:
;   _ED1_WaitForFlagAndClearBit0
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _ED1_WaitForFlagAndClearBit0.
;------------------------------------------------------------------------------
_GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit0:
    JMP     _ED1_WaitForFlagAndClearBit0

;------------------------------------------------------------------------------
; FUNC: _GROUP_AT_JMPTBL_DOS_SystemTagList   (JumpStub_DOS_SystemTagList)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   (none)
; CALLS:
;   _DOS_SystemTagList
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _DOS_SystemTagList.
;------------------------------------------------------------------------------
_GROUP_AT_JMPTBL_DOS_SystemTagList:
    JMP     _DOS_SystemTagList

;------------------------------------------------------------------------------
; FUNC: _GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit1   (JumpStub_ED1_WaitForFlagAndClearBit1)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   (none)
; CALLS:
;   _ED1_WaitForFlagAndClearBit1
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _ED1_WaitForFlagAndClearBit1.
;------------------------------------------------------------------------------
_GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit1:
    JMP     _ED1_WaitForFlagAndClearBit1

;!======

    ; Alignment
    MOVEQ   #97,D0
