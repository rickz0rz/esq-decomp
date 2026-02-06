;!======
;------------------------------------------------------------------------------
; FUNC: GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   LADFUNC_ComposePackedPenByte
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to LADFUNC_ComposePackedPenByte.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte:
    JMP     LADFUNC_ComposePackedPenByte

;------------------------------------------------------------------------------
; FUNC: GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   LADFUNC_GetPackedPenLowNibble
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to LADFUNC_GetPackedPenLowNibble.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble:
    JMP     LADFUNC_GetPackedPenLowNibble

;------------------------------------------------------------------------------
; FUNC: GROUP_AL_JMPTBL_LADFUNC_UpdateEntryBuffersForAdIndex   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   LADFUNC_UpdateEntryFromTextAndAttrBuffers
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to LADFUNC_UpdateEntryFromTextAndAttrBuffers.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AL_JMPTBL_LADFUNC_UpdateEntryBuffersForAdIndex:
    JMP     LADFUNC_UpdateEntryFromTextAndAttrBuffers

;------------------------------------------------------------------------------
; FUNC: GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_WriteDecFixedWidth
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to ESQ_WriteDecFixedWidth.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth:
    JMP     ESQ_WriteDecFixedWidth

;------------------------------------------------------------------------------
; FUNC: GROUP_AL_JMPTBL_LADFUNC_BuildEntryBuffersOrDefault   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   LADFUNC_BuildEntryBuffersOrDefault
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to LADFUNC_BuildEntryBuffersOrDefault.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AL_JMPTBL_LADFUNC_BuildEntryBuffersOrDefault:
    JMP     LADFUNC_BuildEntryBuffersOrDefault

;------------------------------------------------------------------------------
; FUNC: GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   LADFUNC_GetPackedPenHighNibble
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to LADFUNC_GetPackedPenHighNibble.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble:
    JMP     LADFUNC_GetPackedPenHighNibble
