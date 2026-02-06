;------------------------------------------------------------------------------
; FUNC: GROUP_AW_JMPTBL_TLIBA3_BuildDisplayContextForViewMode   (Routine at GROUP_AW_JMPTBL_TLIBA3_BuildDisplayContextForViewMode)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   TLIBA3_BuildDisplayContextForViewMode
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
GROUP_AW_JMPTBL_TLIBA3_BuildDisplayContextForViewMode:
    JMP     TLIBA3_BuildDisplayContextForViewMode

;------------------------------------------------------------------------------
; FUNC: GROUP_AW_JMPTBL_DISPLIB_ApplyInlineAlignmentPadding   (Routine at GROUP_AW_JMPTBL_DISPLIB_ApplyInlineAlignmentPadding)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DISPLIB_ApplyInlineAlignmentPadding
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
GROUP_AW_JMPTBL_DISPLIB_ApplyInlineAlignmentPadding:
    JMP     DISPLIB_ApplyInlineAlignmentPadding

;------------------------------------------------------------------------------
; FUNC: GROUP_AW_JMPTBL_ESQIFF_RunCopperRiseTransition   (Routine at GROUP_AW_JMPTBL_ESQIFF_RunCopperRiseTransition)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQIFF_RunCopperRiseTransition
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
GROUP_AW_JMPTBL_ESQIFF_RunCopperRiseTransition:
    JMP     ESQIFF_RunCopperRiseTransition

;------------------------------------------------------------------------------
; FUNC: GROUP_AW_JMPTBL_ESQIFF_RunCopperDropTransition   (Routine at GROUP_AW_JMPTBL_ESQIFF_RunCopperDropTransition)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQIFF_RunCopperDropTransition
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
GROUP_AW_JMPTBL_ESQIFF_RunCopperDropTransition:
    JMP     ESQIFF_RunCopperDropTransition

;------------------------------------------------------------------------------
; FUNC: GROUP_AW_JMPTBL_DISPLIB_DisplayTextAtPosition   (Routine at GROUP_AW_JMPTBL_DISPLIB_DisplayTextAtPosition)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DISPLIB_DisplayTextAtPosition
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
GROUP_AW_JMPTBL_DISPLIB_DisplayTextAtPosition:
    JMP     DISPLIB_DisplayTextAtPosition

;------------------------------------------------------------------------------
; FUNC: GROUP_AW_JMPTBL_MEM_Move   (Routine at GROUP_AW_JMPTBL_MEM_Move)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   MEM_Move
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
GROUP_AW_JMPTBL_MEM_Move:
    JMP     MEM_Move

;------------------------------------------------------------------------------
; FUNC: GROUP_AW_JMPTBL_WDISP_SPrintf   (Routine at GROUP_AW_JMPTBL_WDISP_SPrintf)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   WDISP_SPrintf
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
GROUP_AW_JMPTBL_WDISP_SPrintf:
    JMP     WDISP_SPrintf

;------------------------------------------------------------------------------
; FUNC: GROUP_AW_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight   (Routine at GROUP_AW_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   ESQ_SetCopperEffect_OffDisableHighlight
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
GROUP_AW_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight:
    JMP     ESQ_SetCopperEffect_OffDisableHighlight

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000

;------------------------------------------------------------------------------
; FUNC: GROUP_AW_JMPTBL_STRING_CopyPadNul   (Routine at GROUP_AW_JMPTBL_STRING_CopyPadNul)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STRING_CopyPadNul
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
GROUP_AW_JMPTBL_STRING_CopyPadNul:
    JMP     STRING_CopyPadNul
