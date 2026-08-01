    XDEF    _GCOMMAND_DisableHighlight



;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_DisableHighlight   (Routine at _GCOMMAND_DisableHighlight)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/A3/A7/D0/D1/D6/D7
; CALLS:
;   _GCOMMAND_ApplyHighlightFlag, _GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   _GCOMMAND_FMT_PCT_S_COLON, _GCOMMAND_STR_GRADIENT, _GCOMMAND_FMT_COLOR_PCT_D_PCT_D, _GCOMMAND_FMT_PCT_D_PCT_03X, _GCOMMAND_FMT_TABLE_DONE_WITH_LEADING_BLANK_LINE
; WRITES:
;   _GCOMMAND_HighlightFlag
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_GCOMMAND_DisableHighlight:
    CLR.W   _GCOMMAND_HighlightFlag
    BSR.W   _GCOMMAND_ApplyHighlightFlag

    RTS

;!======