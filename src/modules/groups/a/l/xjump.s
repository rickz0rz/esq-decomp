    XDEF    _GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth
    XDEF    _GROUP_AL_JMPTBL_LADFUNC_BuildEntryBuffersOrDefault
    XDEF    _GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble
    XDEF    _GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble
    XDEF    _GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte
    XDEF    _GROUP_AL_JMPTBL_LADFUNC_UpdateEntryBuffersForAdIndex

;!======
;------------------------------------------------------------------------------
; FUNC: _GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _LADFUNC_ComposePackedPenByte
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to _LADFUNC_ComposePackedPenByte.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte:
    JMP     _LADFUNC_ComposePackedPenByte

;------------------------------------------------------------------------------
; FUNC: _GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _LADFUNC_GetPackedPenLowNibble
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to _LADFUNC_GetPackedPenLowNibble.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble:
    JMP     _LADFUNC_GetPackedPenLowNibble

;------------------------------------------------------------------------------
; FUNC: _GROUP_AL_JMPTBL_LADFUNC_UpdateEntryBuffersForAdIndex   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _LADFUNC_UpdateEntryFromTextAndAttrBuffers
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to _LADFUNC_UpdateEntryFromTextAndAttrBuffers.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_GROUP_AL_JMPTBL_LADFUNC_UpdateEntryBuffersForAdIndex:
    JMP     _LADFUNC_UpdateEntryFromTextAndAttrBuffers

;------------------------------------------------------------------------------
; FUNC: _GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQ_WriteDecFixedWidth
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to _ESQ_WriteDecFixedWidth.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth:
    JMP     _ESQ_WriteDecFixedWidth

;------------------------------------------------------------------------------
; FUNC: _GROUP_AL_JMPTBL_LADFUNC_BuildEntryBuffersOrDefault   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _LADFUNC_BuildEntryBuffersOrDefault
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to _LADFUNC_BuildEntryBuffersOrDefault.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_GROUP_AL_JMPTBL_LADFUNC_BuildEntryBuffersOrDefault:
    JMP     _LADFUNC_BuildEntryBuffersOrDefault

;------------------------------------------------------------------------------
; FUNC: _GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _LADFUNC_GetPackedPenHighNibble
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to _LADFUNC_GetPackedPenHighNibble.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble:
    JMP     _LADFUNC_GetPackedPenHighNibble
