    XDEF    _GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator
    XDEF    _GROUP_AA_JMPTBL_STRING_CompareN
    XDEF    _GROUP_AA_JMPTBL_STRING_CompareNoCase
    XDEF    _GROUP_AA_JMPTBL_GRAPHICS_AllocRaster

;------------------------------------------------------------------------------
; FUNC: _GROUP_AA_JMPTBL_STRING_CompareNoCase   (Routine at _GROUP_AA_JMPTBL_STRING_CompareNoCase)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _STRING_CompareNoCase
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_GROUP_AA_JMPTBL_STRING_CompareNoCase:
    JMP     _STRING_CompareNoCase

;------------------------------------------------------------------------------
; FUNC: _GROUP_AA_JMPTBL_STRING_CompareN   (Routine at _GROUP_AA_JMPTBL_STRING_CompareN)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _STRING_CompareN
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_GROUP_AA_JMPTBL_STRING_CompareN:
    JMP     _STRING_CompareN

;------------------------------------------------------------------------------
; FUNC: _GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator   (Routine at _GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _GCOMMAND_FindPathSeparator
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator:
    JMP     _GCOMMAND_FindPathSeparator

;------------------------------------------------------------------------------
; FUNC: _GROUP_AA_JMPTBL_GRAPHICS_AllocRaster   (Routine at _GROUP_AA_JMPTBL_GRAPHICS_AllocRaster)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _GRAPHICS_AllocRaster
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_GROUP_AA_JMPTBL_GRAPHICS_AllocRaster:
    JMP     _GRAPHICS_AllocRaster
