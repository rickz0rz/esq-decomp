;------------------------------------------------------------------------------
; FUNC: GROUP_AK_JMPTBL_ESQ_SetCopperEffect_AllOn   (Routine at GROUP_AK_JMPTBL_ESQ_SetCopperEffect_AllOn)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_SetCopperEffect_AllOn
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
GROUP_AK_JMPTBL_ESQ_SetCopperEffect_AllOn:
    JMP     ESQ_SetCopperEffect_AllOn

;------------------------------------------------------------------------------
; FUNC: GROUP_AK_JMPTBL_SCRIPT_AssertCtrlLineNow   (Routine at GROUP_AK_JMPTBL_SCRIPT_AssertCtrlLineNow)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   SCRIPT_AssertCtrlLineNow
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
GROUP_AK_JMPTBL_SCRIPT_AssertCtrlLineNow:
    JMP     SCRIPT_AssertCtrlLineNow

;------------------------------------------------------------------------------
; FUNC: GROUP_AK_JMPTBL_TLIBA3_DrawViewModeGuides   (Routine at GROUP_AK_JMPTBL_TLIBA3_DrawViewModeGuides)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   TLIBA3_DrawViewModeGuides
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
GROUP_AK_JMPTBL_TLIBA3_DrawViewModeGuides:
    JMP     TLIBA3_DrawViewModeGuides

;------------------------------------------------------------------------------
; FUNC: GROUP_AK_JMPTBL_GCOMMAND_CopyGfxToWorkIfAvailable   (Routine at GROUP_AK_JMPTBL_GCOMMAND_CopyGfxToWorkIfAvailable)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   GCOMMAND_CopyGfxToWorkIfAvailable
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
GROUP_AK_JMPTBL_GCOMMAND_CopyGfxToWorkIfAvailable:
    JMP     GCOMMAND_CopyGfxToWorkIfAvailable

    MOVEQ   #97,D0
    RTS

;!======

    ; Alignment
    ALIGN_WORD
