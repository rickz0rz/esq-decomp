    XDEF    _ESQIFF_HandleBrushIniReloadHotkey



;------------------------------------------------------------------------------
; FUNC: _ESQIFF_HandleBrushIniReloadHotkey   (Handle brush.ini reload hotkey and refresh brush lists)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D7
; CALLS:
;   _ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate, _ESQIFF_JMPTBL_BRUSH_FindType3Brush, _ESQIFF_JMPTBL_BRUSH_FreeBrushList, _ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel, _ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle, _ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle, _GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch, _GROUP_AU_JMPTBL_BRUSH_PopulateBrushList
; READS:
;   _BRUSH_SelectedNode, _Global_STR_DF0_BRUSH_INI_2, _PARSEINI_ParsedDescriptorListHead, _ESQIFF_BrushIniListHead, _ESQIFF_TAG_DT, _ESQIFF_TAG_DITHER
; WRITES:
;   _BRUSH_SelectedNode, _ESQFUNC_FallbackType3BrushNode
; DESC:
;   On hotkey `'a'`, refreshes brush.ini data, rebuilds brush lists, selects
;   preferred brush tags, and updates cached type-3 brush pointer.
; NOTES:
;   Calls disk refresh/reset helpers before and after parse/rebuild sequence.
;------------------------------------------------------------------------------
_ESQIFF_HandleBrushIniReloadHotkey:
    MOVE.L  D7,-(A7)

    MOVE.B  11(A7),D7
    MOVEQ   #97,D0
    CMP.B   D0,D7
    BNE.S   .return

    JSR     _ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle(PC)

    CLR.L   -(A7)
    PEA     _ESQIFF_BrushIniListHead
    JSR     _ESQIFF_JMPTBL_BRUSH_FreeBrushList(PC)

    PEA     _Global_STR_DF0_BRUSH_INI_2
    JSR     _GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(PC)

    PEA     _ESQIFF_BrushIniListHead
    MOVE.L  _PARSEINI_ParsedDescriptorListHead,-(A7)
    JSR     _GROUP_AU_JMPTBL_BRUSH_PopulateBrushList(PC)

    PEA     _ESQIFF_TAG_DT
    JSR     _ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel(PC)

    LEA     24(A7),A7
    TST.L   _BRUSH_SelectedNode
    BNE.S   .ensure_type3_brush_cache

    PEA     _ESQIFF_BrushIniListHead
    PEA     _ESQIFF_TAG_DITHER
    JSR     _ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_BRUSH_SelectedNode

.ensure_type3_brush_cache:
    PEA     _ESQIFF_BrushIniListHead
    JSR     _ESQIFF_JMPTBL_BRUSH_FindType3Brush(PC)

    MOVE.L  D0,_ESQFUNC_FallbackType3BrushNode
    JSR     _ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle(PC)

    ADDQ.W  #4,A7

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======