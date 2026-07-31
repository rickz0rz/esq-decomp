    XDEF    _NEWGRID_JMPTBL_CLEANUP_DrawClockBanner
    XDEF    _NEWGRID_JMPTBL_CLEANUP_DrawClockFormatFrame
    XDEF    _NEWGRID_JMPTBL_CLEANUP_DrawClockFormatList
    XDEF    _NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds
    XDEF    _NEWGRID_JMPTBL_DATETIME_SecondsToStruct
    XDEF    _NEWGRID_JMPTBL_DISPTEXT_FreeBuffers
    XDEF    _NEWGRID_JMPTBL_DISPTEXT_InitBuffers
    XDEF    _NEWGRID_JMPTBL_GENERATE_GRID_DATE_STRING
    XDEF    _NEWGRID_JMPTBL_MATH_DivS32
    XDEF    _NEWGRID_JMPTBL_MATH_Mulu32
    XDEF    _NEWGRID_JMPTBL_MEMORY_AllocateMemory
    XDEF    _NEWGRID_JMPTBL_MEMORY_DeallocateMemory
    XDEF    _NEWGRID_JMPTBL_STR_CopyUntilAnyDelimN
    XDEF    _NEWGRID_JMPTBL_WDISP_UpdateSelectionPreviewPanel


    ; Alignment
    ALIGN_WORD

;!======

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_JMPTBL_MATH_DivS32   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _MATH_DivS32
; DESC:
;   Jump table entry that forwards to _MATH_DivS32.
;------------------------------------------------------------------------------
_NEWGRID_JMPTBL_MATH_DivS32:
    JMP     _MATH_DivS32

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_JMPTBL_DATETIME_SecondsToStruct   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _DATETIME_SecondsToStruct
; DESC:
;   Jump table entry that forwards to _DATETIME_SecondsToStruct.
;------------------------------------------------------------------------------
_NEWGRID_JMPTBL_DATETIME_SecondsToStruct:
    JMP     _DATETIME_SecondsToStruct

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_JMPTBL_GENERATE_GRID_DATE_STRING   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _GENERATE_GRID_DATE_STRING
; DESC:
;   Jump table entry that forwards to _GENERATE_GRID_DATE_STRING.
;------------------------------------------------------------------------------
_NEWGRID_JMPTBL_GENERATE_GRID_DATE_STRING:
    JMP     _GENERATE_GRID_DATE_STRING

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_JMPTBL_MEMORY_DeallocateMemory   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _MEMORY_DeallocateMemory
; DESC:
;   Jump table entry that forwards to _MEMORY_DeallocateMemory.
;------------------------------------------------------------------------------
_NEWGRID_JMPTBL_MEMORY_DeallocateMemory:
    JMP     _MEMORY_DeallocateMemory

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_JMPTBL_CLEANUP_DrawClockFormatList   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _CLEANUP_DrawClockFormatList
; DESC:
;   Jump table entry that forwards to _CLEANUP_DrawClockFormatList.
;------------------------------------------------------------------------------
_NEWGRID_JMPTBL_CLEANUP_DrawClockFormatList:
    JMP     _CLEANUP_DrawClockFormatList

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_JMPTBL_DISPTEXT_FreeBuffers   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _DISPTEXT_FreeBuffers
; DESC:
;   Jump table entry that forwards to _DISPTEXT_FreeBuffers.
;------------------------------------------------------------------------------
_NEWGRID_JMPTBL_DISPTEXT_FreeBuffers:
    JMP     _DISPTEXT_FreeBuffers

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_JMPTBL_CLEANUP_DrawClockBanner   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _CLEANUP_DrawClockBanner
; DESC:
;   Jump table entry that forwards to _CLEANUP_DrawClockBanner.
;------------------------------------------------------------------------------
_NEWGRID_JMPTBL_CLEANUP_DrawClockBanner:
    ; Reuse cleanup module to draw the shared clock banner.
    JMP     _CLEANUP_DrawClockBanner

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_JMPTBL_MEMORY_AllocateMemory   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _MEMORY_AllocateMemory
; DESC:
;   Jump table entry that forwards to _MEMORY_AllocateMemory.
;------------------------------------------------------------------------------
_NEWGRID_JMPTBL_MEMORY_AllocateMemory:
    JMP     _MEMORY_AllocateMemory

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_JMPTBL_DISPTEXT_InitBuffers   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _DISPTEXT_InitBuffers
; DESC:
;   Jump table entry that forwards to _DISPTEXT_InitBuffers.
;------------------------------------------------------------------------------
_NEWGRID_JMPTBL_DISPTEXT_InitBuffers:
    JMP     _DISPTEXT_InitBuffers

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_JMPTBL_CLEANUP_DrawClockFormatFrame   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _CLEANUP_DrawClockFormatFrame
; DESC:
;   Jump table entry that forwards to _CLEANUP_DrawClockFormatFrame.
;------------------------------------------------------------------------------
_NEWGRID_JMPTBL_CLEANUP_DrawClockFormatFrame:
    JMP     _CLEANUP_DrawClockFormatFrame

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _DATETIME_NormalizeStructToSeconds
; DESC:
;   Jump table entry that forwards to _DATETIME_NormalizeStructToSeconds.
;------------------------------------------------------------------------------
_NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds:
    JMP     _DATETIME_NormalizeStructToSeconds

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_JMPTBL_STR_CopyUntilAnyDelimN   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STR_CopyUntilAnyDelimN
; DESC:
;   Jump table entry that forwards to STR_CopyUntilAnyDelimN.
;------------------------------------------------------------------------------
_NEWGRID_JMPTBL_STR_CopyUntilAnyDelimN:
    JMP     STR_CopyUntilAnyDelimN

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_JMPTBL_WDISP_UpdateSelectionPreviewPanel   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _WDISP_UpdateSelectionPreviewPanel
; DESC:
;   Jump table entry that forwards to _WDISP_UpdateSelectionPreviewPanel.
;------------------------------------------------------------------------------
_NEWGRID_JMPTBL_WDISP_UpdateSelectionPreviewPanel:
    JMP     _WDISP_UpdateSelectionPreviewPanel

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_JMPTBL_MATH_Mulu32   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _MATH_Mulu32
; DESC:
;   Jump table entry that forwards to _MATH_Mulu32.
;------------------------------------------------------------------------------
_NEWGRID_JMPTBL_MATH_Mulu32:
    JMP     _MATH_Mulu32
