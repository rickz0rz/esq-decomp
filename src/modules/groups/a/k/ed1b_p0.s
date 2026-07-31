    XDEF    _ED1_JMPTBL_CLEANUP_DrawDateTimeBannerRow
    XDEF    _ED1_JMPTBL_ESQSHARED4_LoadDefaultPaletteToCopper_NoOp
    XDEF    _ED1_JMPTBL_ESQ_ColdReboot
    XDEF    _ED1_JMPTBL_GCOMMAND_ResetHighlightMessages
    XDEF    _ED1_JMPTBL_GCOMMAND_SeedBannerDefaults
    XDEF    _ED1_JMPTBL_GCOMMAND_SeedBannerFromPrefs
    XDEF    _ED1_JMPTBL_LADFUNC_MergeHighLowNibbles
    XDEF    _ED1_JMPTBL_LADFUNC_PackNibblesToByte
    XDEF    _ED1_JMPTBL_LADFUNC_SaveTextAdsToFile
    XDEF    _ED1_JMPTBL_LOCAVAIL_ResetFilterCursorState
    XDEF    _ED1_JMPTBL_MEM_Move
    XDEF    _ED1_JMPTBL_NEWGRID_DrawTopBorderLine


;------------------------------------------------------------------------------
; FUNC: _ED1_JMPTBL_NEWGRID_DrawTopBorderLine   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _NEWGRID_DrawTopBorderLine
; DESC:
;   Jump stub to _NEWGRID_DrawTopBorderLine.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_ED1_JMPTBL_NEWGRID_DrawTopBorderLine:
    JMP     _NEWGRID_DrawTopBorderLine

;------------------------------------------------------------------------------
; FUNC: _ED1_JMPTBL_LOCAVAIL_ResetFilterCursorState   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   _LOCAVAIL_ResetFilterCursorState
; DESC:
;   Jump stub to _LOCAVAIL_ResetFilterCursorState.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_ED1_JMPTBL_LOCAVAIL_ResetFilterCursorState:
    JMP     _LOCAVAIL_ResetFilterCursorState

;!======

    ; Alignment
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0

;!======

;------------------------------------------------------------------------------
; FUNC: _ED1_JMPTBL_GCOMMAND_ResetHighlightMessages   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _GCOMMAND_ResetHighlightMessages
; DESC:
;   Jump stub to _GCOMMAND_ResetHighlightMessages.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_ED1_JMPTBL_GCOMMAND_ResetHighlightMessages:
    JMP     _GCOMMAND_ResetHighlightMessages

;------------------------------------------------------------------------------
; FUNC: _ED1_JMPTBL_LADFUNC_MergeHighLowNibbles   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _LADFUNC_SetPackedPenLowNibble
; DESC:
;   Jump stub to _LADFUNC_SetPackedPenLowNibble.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_ED1_JMPTBL_LADFUNC_MergeHighLowNibbles:
    JMP     _LADFUNC_SetPackedPenLowNibble

;------------------------------------------------------------------------------
; FUNC: _ED1_JMPTBL_LADFUNC_SaveTextAdsToFile   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _LADFUNC_SaveTextAdsToFile
; DESC:
;   Jump stub to _LADFUNC_SaveTextAdsToFile.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_ED1_JMPTBL_LADFUNC_SaveTextAdsToFile:
    JMP     _LADFUNC_SaveTextAdsToFile

;------------------------------------------------------------------------------
; FUNC: _ED1_JMPTBL_ESQ_ColdReboot   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQ_ColdReboot
; DESC:
;   Jump stub to _ESQ_ColdReboot.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_ED1_JMPTBL_ESQ_ColdReboot:
    JMP     _ESQ_ColdReboot

;------------------------------------------------------------------------------
; FUNC: _ED1_JMPTBL_ESQSHARED4_LoadDefaultPaletteToCopper_NoOp   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQSHARED4_LoadDefaultPaletteToCopper_NoOp
; DESC:
;   Jump stub to _ESQSHARED4_LoadDefaultPaletteToCopper_NoOp.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_ED1_JMPTBL_ESQSHARED4_LoadDefaultPaletteToCopper_NoOp:
    JMP     _ESQSHARED4_LoadDefaultPaletteToCopper_NoOp

;------------------------------------------------------------------------------
; FUNC: _ED1_JMPTBL_GCOMMAND_SeedBannerDefaults   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _GCOMMAND_SeedBannerDefaults
; DESC:
;   Jump stub to _GCOMMAND_SeedBannerDefaults.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_ED1_JMPTBL_GCOMMAND_SeedBannerDefaults:
    JMP     _GCOMMAND_SeedBannerDefaults

;------------------------------------------------------------------------------
; FUNC: _ED1_JMPTBL_MEM_Move   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _MEM_Move
; DESC:
;   Jump stub to _MEM_Move.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_ED1_JMPTBL_MEM_Move:
    JMP     _MEM_Move

;------------------------------------------------------------------------------
; FUNC: _ED1_JMPTBL_GCOMMAND_SeedBannerFromPrefs   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _GCOMMAND_SeedBannerFromPrefs
; DESC:
;   Jump stub to _GCOMMAND_SeedBannerFromPrefs.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_ED1_JMPTBL_GCOMMAND_SeedBannerFromPrefs:
    JMP     _GCOMMAND_SeedBannerFromPrefs

;------------------------------------------------------------------------------
; FUNC: _ED1_JMPTBL_CLEANUP_DrawDateTimeBannerRow   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _CLEANUP_DrawDateTimeBannerRow
; DESC:
;   Jump stub to _CLEANUP_DrawDateTimeBannerRow.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_ED1_JMPTBL_CLEANUP_DrawDateTimeBannerRow:
    JMP     _CLEANUP_DrawDateTimeBannerRow

;------------------------------------------------------------------------------
; FUNC: _ED1_JMPTBL_LADFUNC_PackNibblesToByte   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _LADFUNC_SetPackedPenHighNibble
; DESC:
;   Jump stub to _LADFUNC_SetPackedPenHighNibble.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
_ED1_JMPTBL_LADFUNC_PackNibblesToByte:
    JMP     _LADFUNC_SetPackedPenHighNibble

;!======
; The below content should belong in another file... need to determine what it is.
;!======