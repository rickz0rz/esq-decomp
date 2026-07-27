    XDEF    GROUP_AD_JMPTBL_DATETIME_AdjustMonthIndex
    XDEF    GROUP_AD_JMPTBL_DATETIME_NormalizeMonthRange
    XDEF    GROUP_AD_JMPTBL_DST_ComputeBannerIndex
    XDEF    GROUP_AD_JMPTBL_ESQFUNC_SelectAndApplyBrushForCurrentEntry
    XDEF    GROUP_AD_JMPTBL_ESQIFF_RunCopperDropTransition
    XDEF    GROUP_AD_JMPTBL_ESQIFF_RunCopperRiseTransition
    XDEF    _GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort
    XDEF    GROUP_AD_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte
    XDEF    GROUP_AD_JMPTBL_TEXTDISP_BuildChannelLabel
    XDEF    GROUP_AD_JMPTBL_TEXTDISP_BuildEntryShortName
    XDEF    GROUP_AD_JMPTBL_TEXTDISP_DrawChannelBanner
    XDEF    GROUP_AD_JMPTBL_TEXTDISP_DrawInsetRectFrame
    XDEF    GROUP_AD_JMPTBL_TEXTDISP_FormatEntryTime
    XDEF    GROUP_AD_JMPTBL_TEXTDISP_TrimTextToPixelWidth
    XDEF    GROUP_AD_JMPTBL_TLIBA1_BuildClockFormatEntryIfVisible
    XDEF    GROUP_AD_JMPTBL_TLIBA3_BuildDisplayContextForViewMode
    XDEF    GROUP_AD_JMPTBL_TLIBA3_GetViewModeHeight
    XDEF    GROUP_AD_JMPTBL_TLIBA3_GetViewModeRastPort

;------------------------------------------------------------------------------
; FUNC: GROUP_AD_JMPTBL_TLIBA3_BuildDisplayContextForViewMode   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _TLIBA3_BuildDisplayContextForViewMode
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _TLIBA3_BuildDisplayContextForViewMode.
;------------------------------------------------------------------------------
GROUP_AD_JMPTBL_TLIBA3_BuildDisplayContextForViewMode:
    JMP     _TLIBA3_BuildDisplayContextForViewMode

;------------------------------------------------------------------------------
; FUNC: GROUP_AD_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _SCRIPT_UpdateSerialShadowFromCtrlByte
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _SCRIPT_UpdateSerialShadowFromCtrlByte.
;------------------------------------------------------------------------------
GROUP_AD_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte:
    JMP     _SCRIPT_UpdateSerialShadowFromCtrlByte

;------------------------------------------------------------------------------
; FUNC: GROUP_AD_JMPTBL_DATETIME_NormalizeMonthRange   (JumpStub_DATETIME_NormalizeMonthRange)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _DATETIME_NormalizeMonthRange
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _DATETIME_NormalizeMonthRange.
;------------------------------------------------------------------------------
GROUP_AD_JMPTBL_DATETIME_NormalizeMonthRange:
    JMP     _DATETIME_NormalizeMonthRange

;------------------------------------------------------------------------------
; FUNC: GROUP_AD_JMPTBL_TEXTDISP_DrawChannelBanner   (JumpStub_TEXTDISP_DrawChannelBanner)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   TEXTDISP_DrawChannelBanner
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to TEXTDISP_DrawChannelBanner.
;------------------------------------------------------------------------------
GROUP_AD_JMPTBL_TEXTDISP_DrawChannelBanner:
    JMP     TEXTDISP_DrawChannelBanner

;------------------------------------------------------------------------------
; FUNC: GROUP_AD_JMPTBL_TEXTDISP_FormatEntryTime   (JumpStub_TEXTDISP_FormatEntryTime)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _TEXTDISP_FormatEntryTime
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _TEXTDISP_FormatEntryTime.
;------------------------------------------------------------------------------
GROUP_AD_JMPTBL_TEXTDISP_FormatEntryTime:
    JMP     _TEXTDISP_FormatEntryTime

;------------------------------------------------------------------------------
; FUNC: GROUP_AD_JMPTBL_ESQIFF_RunCopperRiseTransition   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _ESQIFF_RunCopperRiseTransition
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _ESQIFF_RunCopperRiseTransition.
;------------------------------------------------------------------------------
GROUP_AD_JMPTBL_ESQIFF_RunCopperRiseTransition:
    JMP     _ESQIFF_RunCopperRiseTransition

;------------------------------------------------------------------------------
; FUNC: GROUP_AD_JMPTBL_TEXTDISP_BuildEntryShortName   (JumpStub_TEXTDISP_BuildEntryShortName)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   TEXTDISP_BuildEntryShortName
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to TEXTDISP_BuildEntryShortName.
;------------------------------------------------------------------------------
GROUP_AD_JMPTBL_TEXTDISP_BuildEntryShortName:
    JMP     TEXTDISP_BuildEntryShortName

;------------------------------------------------------------------------------
; FUNC: _GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort   (JumpStub_GRAPHICS_BltBitMapRastPort)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   GRAPHICS_BltBitMapRastPort
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to GRAPHICS_BltBitMapRastPort.
;------------------------------------------------------------------------------
_GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort:
    JMP     GRAPHICS_BltBitMapRastPort

;------------------------------------------------------------------------------
; FUNC: GROUP_AD_JMPTBL_ESQIFF_RunCopperDropTransition   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _ESQIFF_RunCopperDropTransition
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _ESQIFF_RunCopperDropTransition.
;------------------------------------------------------------------------------
GROUP_AD_JMPTBL_ESQIFF_RunCopperDropTransition:
    JMP     _ESQIFF_RunCopperDropTransition

;------------------------------------------------------------------------------
; FUNC: GROUP_AD_JMPTBL_TLIBA1_BuildClockFormatEntryIfVisible   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   TLIBA1_BuildClockFormatEntryIfVisible
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to TLIBA1_BuildClockFormatEntryIfVisible.
;------------------------------------------------------------------------------
GROUP_AD_JMPTBL_TLIBA1_BuildClockFormatEntryIfVisible:
    JMP     TLIBA1_BuildClockFormatEntryIfVisible

;------------------------------------------------------------------------------
; FUNC: GROUP_AD_JMPTBL_TEXTDISP_BuildChannelLabel   (JumpStub_TEXTDISP_BuildChannelLabel)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _TEXTDISP_BuildChannelLabel
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _TEXTDISP_BuildChannelLabel.
;------------------------------------------------------------------------------
GROUP_AD_JMPTBL_TEXTDISP_BuildChannelLabel:
    JMP     _TEXTDISP_BuildChannelLabel

;------------------------------------------------------------------------------
; FUNC: GROUP_AD_JMPTBL_TEXTDISP_DrawInsetRectFrame   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   TEXTDISP_DrawInsetRectFrame
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to TEXTDISP_DrawInsetRectFrame.
;------------------------------------------------------------------------------
GROUP_AD_JMPTBL_TEXTDISP_DrawInsetRectFrame:
    JMP     TEXTDISP_DrawInsetRectFrame

;------------------------------------------------------------------------------
; FUNC: GROUP_AD_JMPTBL_TEXTDISP_TrimTextToPixelWidth   (JumpStub_TEXTDISP_TrimTextToPixelWidth)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   TEXTDISP_TrimTextToPixelWidth
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to TEXTDISP_TrimTextToPixelWidth.
;------------------------------------------------------------------------------
GROUP_AD_JMPTBL_TEXTDISP_TrimTextToPixelWidth:
    JMP     TEXTDISP_TrimTextToPixelWidth

;------------------------------------------------------------------------------
; FUNC: GROUP_AD_JMPTBL_TLIBA3_GetViewModeRastPort   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _TLIBA3_GetViewModeRastPort
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _TLIBA3_GetViewModeRastPort.
;------------------------------------------------------------------------------
GROUP_AD_JMPTBL_TLIBA3_GetViewModeRastPort:
    JMP     _TLIBA3_GetViewModeRastPort

;------------------------------------------------------------------------------
; FUNC: GROUP_AD_JMPTBL_ESQFUNC_SelectAndApplyBrushForCurrentEntry   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   ESQFUNC_SelectAndApplyBrushForCurrentEntry
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to ESQFUNC_SelectAndApplyBrushForCurrentEntry.
;------------------------------------------------------------------------------
GROUP_AD_JMPTBL_ESQFUNC_SelectAndApplyBrushForCurrentEntry:
    JMP     ESQFUNC_SelectAndApplyBrushForCurrentEntry

;------------------------------------------------------------------------------
; FUNC: GROUP_AD_JMPTBL_DATETIME_AdjustMonthIndex   (JumpStub_DATETIME_AdjustMonthIndex)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _DATETIME_AdjustMonthIndex
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _DATETIME_AdjustMonthIndex.
;------------------------------------------------------------------------------
GROUP_AD_JMPTBL_DATETIME_AdjustMonthIndex:
    JMP     _DATETIME_AdjustMonthIndex

;------------------------------------------------------------------------------
; FUNC: GROUP_AD_JMPTBL_DST_ComputeBannerIndex   (JumpStub_DST_ComputeBannerIndex)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   DST_ComputeBannerIndex
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to DST_ComputeBannerIndex.
;------------------------------------------------------------------------------
GROUP_AD_JMPTBL_DST_ComputeBannerIndex:
    JMP     DST_ComputeBannerIndex

;------------------------------------------------------------------------------
; FUNC: GROUP_AD_JMPTBL_TLIBA3_GetViewModeHeight   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _TLIBA3_GetViewModeHeight
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _TLIBA3_GetViewModeHeight.
;------------------------------------------------------------------------------
GROUP_AD_JMPTBL_TLIBA3_GetViewModeHeight:
    JMP     _TLIBA3_GetViewModeHeight
