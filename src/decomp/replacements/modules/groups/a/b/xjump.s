;------------------------------------------------------------------------------
; DECOMP TARGET direct hybrid replacement
; SOURCE: modules/groups/a/b/xjump.s
; PURPOSE:
;   Carry the GROUP_AB wrapper module body directly now that the maintained
;   SAS/C compare lanes for its ten wrapper exports are green in this
;   checkout.
;------------------------------------------------------------------------------

    XDEF    GROUP_AB_JMPTBL_ESQFUNC_FreeLineTextBuffers
    XDEF    GROUP_AB_JMPTBL_ESQIFF2_ClearLineHeadTailByMode
    XDEF    GROUP_AB_JMPTBL_ESQIFF_DeallocateAdsAndLogoLstData
    XDEF    GROUP_AB_JMPTBL_ESQPARS_RemoveGroupEntryAndReleaseStrings
    XDEF    GROUP_AB_JMPTBL_IOSTDREQ_Free
    XDEF    GROUP_AB_JMPTBL_LADFUNC_FreeBannerRectEntries
    XDEF    GROUP_AB_JMPTBL_LOCAVAIL_FreeResourceChain
    XDEF    GROUP_AB_JMPTBL_NEWGRID_ShutdownGridResources
    XDEF    GROUP_AB_JMPTBL_UNKNOWN2A_Stub0
    XDEF    GROUP_AB_JMPTBL_GRAPHICS_FreeRaster

;------------------------------------------------------------------------------
; FUNC: GROUP_AB_JMPTBL_ESQPARS_RemoveGroupEntryAndReleaseStrings   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQPARS_RemoveGroupEntryAndReleaseStrings
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to ESQPARS_RemoveGroupEntryAndReleaseStrings.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AB_JMPTBL_ESQPARS_RemoveGroupEntryAndReleaseStrings:
    JMP     ESQPARS_RemoveGroupEntryAndReleaseStrings

;------------------------------------------------------------------------------
; FUNC: GROUP_AB_JMPTBL_ESQFUNC_FreeLineTextBuffers   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQFUNC_FreeLineTextBuffers
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to ESQFUNC_FreeLineTextBuffers.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AB_JMPTBL_ESQFUNC_FreeLineTextBuffers:
    JMP     ESQFUNC_FreeLineTextBuffers

;------------------------------------------------------------------------------
; FUNC: GROUP_AB_JMPTBL_ESQIFF_DeallocateAdsAndLogoLstData   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQIFF_DeallocateAdsAndLogoLstData
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to ESQIFF_DeallocateAdsAndLogoLstData.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AB_JMPTBL_ESQIFF_DeallocateAdsAndLogoLstData:
    JMP     ESQIFF_DeallocateAdsAndLogoLstData

;------------------------------------------------------------------------------
; FUNC: GROUP_AB_JMPTBL_LADFUNC_FreeBannerRectEntries   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   LADFUNC_FreeBannerRectEntries
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to LADFUNC_FreeBannerRectEntries.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AB_JMPTBL_LADFUNC_FreeBannerRectEntries:
    JMP     LADFUNC_FreeBannerRectEntries

;------------------------------------------------------------------------------
; FUNC: GROUP_AB_JMPTBL_UNKNOWN2A_Stub0   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   UNKNOWN2A_Stub0
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to UNKNOWN2A_Stub0.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AB_JMPTBL_UNKNOWN2A_Stub0:
    JMP     UNKNOWN2A_Stub0

;------------------------------------------------------------------------------
; FUNC: GROUP_AB_JMPTBL_NEWGRID_ShutdownGridResources   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   NEWGRID_ShutdownGridResources
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to NEWGRID_ShutdownGridResources.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AB_JMPTBL_NEWGRID_ShutdownGridResources:
    JMP     NEWGRID_ShutdownGridResources

;------------------------------------------------------------------------------
; FUNC: GROUP_AB_JMPTBL_LOCAVAIL_FreeResourceChain   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   LOCAVAIL_FreeResourceChain
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to LOCAVAIL_FreeResourceChain.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AB_JMPTBL_LOCAVAIL_FreeResourceChain:
    JMP     LOCAVAIL_FreeResourceChain

;------------------------------------------------------------------------------
; FUNC: GROUP_AB_JMPTBL_GRAPHICS_FreeRaster   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   GRAPHICS_FreeRaster
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to GRAPHICS_FreeRaster.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AB_JMPTBL_GRAPHICS_FreeRaster:
    JMP     GRAPHICS_FreeRaster

;------------------------------------------------------------------------------
; FUNC: GROUP_AB_JMPTBL_IOSTDREQ_Free   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   IOSTDREQ_Free
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to IOSTDREQ_Free.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AB_JMPTBL_IOSTDREQ_Free:
    JMP     IOSTDREQ_Free

;------------------------------------------------------------------------------
; FUNC: GROUP_AB_JMPTBL_ESQIFF2_ClearLineHeadTailByMode   (JumpStub)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   ESQIFF2_ClearLineHeadTailByMode
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to ESQIFF2_ClearLineHeadTailByMode.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AB_JMPTBL_ESQIFF2_ClearLineHeadTailByMode:
    JMP     ESQIFF2_ClearLineHeadTailByMode

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000
    MOVEQ   #97,D0
