;------------------------------------------------------------------------------
; DECOMP TARGET 742, 783-787
; SOURCE: modules/groups/a/l/xjump.s
; PURPOSE:
;   Direct object-level hybrid replacement for the GROUP_AL wrapper module.
;   This replaces the earlier passthrough boundary now that the maintained
;   restored SAS/C compare lanes for all wrapper-backed exports are green in
;   this checkout.
;------------------------------------------------------------------------------

    XDEF    GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth
    XDEF    GROUP_AL_JMPTBL_LADFUNC_BuildEntryBuffersOrDefault
    XDEF    GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble
    XDEF    GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble
    XDEF    GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte
    XDEF    GROUP_AL_JMPTBL_LADFUNC_UpdateEntryBuffersForAdIndex

;!======
;------------------------------------------------------------------------------
; FUNC: GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte   (JumpStub_LADFUNC_ComposePackedPenByte)
; ARGS:
;   (none observed)
; RET:
;   D0: packed pen byte
; CLOBBERS:
;   D0
; CALLS:
;   LADFUNC_ComposePackedPenByte
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to LADFUNC_ComposePackedPenByte.
; NOTES:
;   Mirrors the original wrapper module while keeping this replacement local.
;------------------------------------------------------------------------------
GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte:
    JMP     LADFUNC_ComposePackedPenByte

;------------------------------------------------------------------------------
; FUNC: GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble   (JumpStub_LADFUNC_GetPackedPenLowNibble)
; ARGS:
;   (none observed)
; RET:
;   D0: low nibble value
; CLOBBERS:
;   D0
; CALLS:
;   LADFUNC_GetPackedPenLowNibble
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to LADFUNC_GetPackedPenLowNibble.
; NOTES:
;   Mirrors the original wrapper module while keeping this replacement local.
;------------------------------------------------------------------------------
GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble:
    JMP     LADFUNC_GetPackedPenLowNibble

;------------------------------------------------------------------------------
; FUNC: GROUP_AL_JMPTBL_LADFUNC_UpdateEntryBuffersForAdIndex   (JumpStub_LADFUNC_UpdateEntryFromTextAndAttrBuffers)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D0
; CALLS:
;   LADFUNC_UpdateEntryFromTextAndAttrBuffers
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to LADFUNC_UpdateEntryFromTextAndAttrBuffers.
; NOTES:
;   Mirrors the original wrapper module while keeping this replacement local.
;------------------------------------------------------------------------------
GROUP_AL_JMPTBL_LADFUNC_UpdateEntryBuffersForAdIndex:
    JMP     LADFUNC_UpdateEntryFromTextAndAttrBuffers

;------------------------------------------------------------------------------
; FUNC: GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth   (JumpStub_ESQ_WriteDecFixedWidth)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D0
; CALLS:
;   ESQ_WriteDecFixedWidth
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to ESQ_WriteDecFixedWidth.
; NOTES:
;   Mirrors the original wrapper module while keeping this replacement local.
;------------------------------------------------------------------------------
GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth:
    JMP     ESQ_WriteDecFixedWidth

;------------------------------------------------------------------------------
; FUNC: GROUP_AL_JMPTBL_LADFUNC_BuildEntryBuffersOrDefault   (JumpStub_LADFUNC_BuildEntryBuffersOrDefault)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D0
; CALLS:
;   LADFUNC_BuildEntryBuffersOrDefault
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to LADFUNC_BuildEntryBuffersOrDefault.
; NOTES:
;   Mirrors the original wrapper module while keeping this replacement local.
;------------------------------------------------------------------------------
GROUP_AL_JMPTBL_LADFUNC_BuildEntryBuffersOrDefault:
    JMP     LADFUNC_BuildEntryBuffersOrDefault

;------------------------------------------------------------------------------
; FUNC: GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble   (JumpStub_LADFUNC_GetPackedPenHighNibble)
; ARGS:
;   (none observed)
; RET:
;   D0: high nibble value
; CLOBBERS:
;   D0
; CALLS:
;   LADFUNC_GetPackedPenHighNibble
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to LADFUNC_GetPackedPenHighNibble.
; NOTES:
;   Mirrors the original wrapper module while keeping this replacement local.
;------------------------------------------------------------------------------
GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble:
    JMP     LADFUNC_GetPackedPenHighNibble
