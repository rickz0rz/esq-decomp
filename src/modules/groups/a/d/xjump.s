    XDEF    _GROUP_AD_JMPTBL_DATETIME_AdjustMonthIndex
    XDEF    _GROUP_AD_JMPTBL_DATETIME_NormalizeMonthRange
    XDEF    _GROUP_AD_JMPTBL_DST_ComputeBannerIndex
    XDEF    _GROUP_AD_JMPTBL_ESQFUNC_SelectAndApplyBrushForCurrentEntry
    XDEF    _GROUP_AD_JMPTBL_ESQIFF_RunCopperDropTransition
    XDEF    _GROUP_AD_JMPTBL_ESQIFF_RunCopperRiseTransition
    XDEF    _GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort
    XDEF    _GROUP_AD_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte
    XDEF    _GROUP_AD_JMPTBL_TEXTDISP_BuildChannelLabel
    XDEF    _GROUP_AD_JMPTBL_TEXTDISP_BuildEntryShortName
    XDEF    _GROUP_AD_JMPTBL_TEXTDISP_DrawChannelBanner
    XDEF    _GROUP_AD_JMPTBL_TEXTDISP_DrawInsetRectFrame
    XDEF    _GROUP_AD_JMPTBL_TEXTDISP_FormatEntryTime
    XDEF    _GROUP_AD_JMPTBL_TEXTDISP_TrimTextToPixelWidth
    XDEF    _GROUP_AD_JMPTBL_TLIBA1_BuildClockFormatEntryIfVisible
    XDEF    _GROUP_AD_JMPTBL_TLIBA3_BuildDisplayContextForViewMode
    XDEF    _GROUP_AD_JMPTBL_TLIBA3_GetViewModeHeight
    XDEF    _GROUP_AD_JMPTBL_TLIBA3_GetViewModeRastPort

;------------------------------------------------------------------------------
; FUNC: _GROUP_AD_JMPTBL_TLIBA3_BuildDisplayContextForViewMode   (JumpStub)
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
_GROUP_AD_JMPTBL_TLIBA3_BuildDisplayContextForViewMode:
    JMP     _TLIBA3_BuildDisplayContextForViewMode

;------------------------------------------------------------------------------
; FUNC: _GROUP_AD_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte   (JumpStub)
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
_GROUP_AD_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte:
    JMP     _SCRIPT_UpdateSerialShadowFromCtrlByte

;------------------------------------------------------------------------------
; FUNC: _GROUP_AD_JMPTBL_DATETIME_NormalizeMonthRange   (JumpStub_DATETIME_NormalizeMonthRange)
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
_GROUP_AD_JMPTBL_DATETIME_NormalizeMonthRange:
    JMP     _DATETIME_NormalizeMonthRange

;------------------------------------------------------------------------------
; FUNC: _GROUP_AD_JMPTBL_TEXTDISP_DrawChannelBanner   (JumpStub_TEXTDISP_DrawChannelBanner)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _TEXTDISP_DrawChannelBanner
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _TEXTDISP_DrawChannelBanner.
;------------------------------------------------------------------------------
_GROUP_AD_JMPTBL_TEXTDISP_DrawChannelBanner:
    JMP     _TEXTDISP_DrawChannelBanner

;------------------------------------------------------------------------------
; FUNC: _GROUP_AD_JMPTBL_TEXTDISP_FormatEntryTime   (JumpStub_TEXTDISP_FormatEntryTime)
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
_GROUP_AD_JMPTBL_TEXTDISP_FormatEntryTime:
    JMP     _TEXTDISP_FormatEntryTime

;------------------------------------------------------------------------------
; FUNC: _GROUP_AD_JMPTBL_ESQIFF_RunCopperRiseTransition   (JumpStub)
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
_GROUP_AD_JMPTBL_ESQIFF_RunCopperRiseTransition:
    JMP     _ESQIFF_RunCopperRiseTransition

;------------------------------------------------------------------------------
; FUNC: _GROUP_AD_JMPTBL_TEXTDISP_BuildEntryShortName   (JumpStub_TEXTDISP_BuildEntryShortName)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _TEXTDISP_BuildEntryShortName
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _TEXTDISP_BuildEntryShortName.
;------------------------------------------------------------------------------
_GROUP_AD_JMPTBL_TEXTDISP_BuildEntryShortName:
    JMP     _TEXTDISP_BuildEntryShortName

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
; FUNC: _GROUP_AD_JMPTBL_ESQIFF_RunCopperDropTransition   (JumpStub)
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
_GROUP_AD_JMPTBL_ESQIFF_RunCopperDropTransition:
    JMP     _ESQIFF_RunCopperDropTransition

;------------------------------------------------------------------------------
; FUNC: _GROUP_AD_JMPTBL_TLIBA1_BuildClockFormatEntryIfVisible   (JumpStub)
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
_GROUP_AD_JMPTBL_TLIBA1_BuildClockFormatEntryIfVisible:
    JMP     TLIBA1_BuildClockFormatEntryIfVisible

;------------------------------------------------------------------------------
; FUNC: _GROUP_AD_JMPTBL_TEXTDISP_BuildChannelLabel   (JumpStub_TEXTDISP_BuildChannelLabel)
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
_GROUP_AD_JMPTBL_TEXTDISP_BuildChannelLabel:
    JMP     _TEXTDISP_BuildChannelLabel

;------------------------------------------------------------------------------
; FUNC: _GROUP_AD_JMPTBL_TEXTDISP_DrawInsetRectFrame   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _TEXTDISP_DrawInsetRectFrame
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _TEXTDISP_DrawInsetRectFrame.
;------------------------------------------------------------------------------
_GROUP_AD_JMPTBL_TEXTDISP_DrawInsetRectFrame:
    JMP     _TEXTDISP_DrawInsetRectFrame

;------------------------------------------------------------------------------
; FUNC: _GROUP_AD_JMPTBL_TEXTDISP_TrimTextToPixelWidth   (JumpStub_TEXTDISP_TrimTextToPixelWidth)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _TEXTDISP_TrimTextToPixelWidth
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _TEXTDISP_TrimTextToPixelWidth.
;------------------------------------------------------------------------------
_GROUP_AD_JMPTBL_TEXTDISP_TrimTextToPixelWidth:
    JMP     _TEXTDISP_TrimTextToPixelWidth

;------------------------------------------------------------------------------
; FUNC: _GROUP_AD_JMPTBL_TLIBA3_GetViewModeRastPort   (JumpStub)
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
_GROUP_AD_JMPTBL_TLIBA3_GetViewModeRastPort:
    JMP     _TLIBA3_GetViewModeRastPort

;------------------------------------------------------------------------------
; FUNC: _GROUP_AD_JMPTBL_ESQFUNC_SelectAndApplyBrushForCurrentEntry   (JumpStub)
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
_GROUP_AD_JMPTBL_ESQFUNC_SelectAndApplyBrushForCurrentEntry:
    JMP     ESQFUNC_SelectAndApplyBrushForCurrentEntry

;------------------------------------------------------------------------------
; FUNC: _GROUP_AD_JMPTBL_DATETIME_AdjustMonthIndex   (JumpStub_DATETIME_AdjustMonthIndex)
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
_GROUP_AD_JMPTBL_DATETIME_AdjustMonthIndex:
    JMP     _DATETIME_AdjustMonthIndex

;------------------------------------------------------------------------------
; FUNC: _GROUP_AD_JMPTBL_DST_ComputeBannerIndex   (JumpStub_DST_ComputeBannerIndex)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _DST_ComputeBannerIndex
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _DST_ComputeBannerIndex.
;------------------------------------------------------------------------------
_GROUP_AD_JMPTBL_DST_ComputeBannerIndex:
    JMP     _DST_ComputeBannerIndex

;------------------------------------------------------------------------------
; FUNC: _GROUP_AD_JMPTBL_TLIBA3_GetViewModeHeight   (JumpStub)
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
_GROUP_AD_JMPTBL_TLIBA3_GetViewModeHeight:
    JMP     _TLIBA3_GetViewModeHeight
