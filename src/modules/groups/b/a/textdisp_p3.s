    XDEF    TEXTDISP_JMPTBL_CLEANUP_BuildAlignedStatusLine
    XDEF    _TEXTDISP_JMPTBL_CLEANUP_DrawInsetRectFrame
    XDEF    TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility
    XDEF    _TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition
    XDEF    TEXTDISP_JMPTBL_NEWGRID_ShouldOpenEditor


    ; Alignment
    ALIGN_WORD

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_JMPTBL_NEWGRID_ShouldOpenEditor   (JumpStub)
; ARGS:
;   see _NEWGRID_ShouldOpenEditor
; RET:
;   see _NEWGRID_ShouldOpenEditor
; DESC:
;   Jump stub to _NEWGRID_ShouldOpenEditor.
;------------------------------------------------------------------------------
TEXTDISP_JMPTBL_NEWGRID_ShouldOpenEditor:
    JMP     _NEWGRID_ShouldOpenEditor

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility   (JumpStub)
; ARGS:
;   see ESQDISP_TestEntryGridEligibility
; RET:
;   see ESQDISP_TestEntryGridEligibility
; DESC:
;   Jump stub to ESQDISP_TestEntryGridEligibility.
;------------------------------------------------------------------------------
TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility:
    JMP     ESQDISP_TestEntryGridEligibility

;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition   (JumpStub)
; ARGS:
;   see _ESQIFF_RunCopperRiseTransition
; RET:
;   see _ESQIFF_RunCopperRiseTransition
; DESC:
;   Jump stub to _ESQIFF_RunCopperRiseTransition.
;------------------------------------------------------------------------------
_TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition:
    JMP     _ESQIFF_RunCopperRiseTransition

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_JMPTBL_CLEANUP_BuildAlignedStatusLine   (Routine at TEXTDISP_JMPTBL_CLEANUP_BuildAlignedStatusLine)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   CLEANUP_BuildAlignedStatusLine
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
TEXTDISP_JMPTBL_CLEANUP_BuildAlignedStatusLine:
    JMP     CLEANUP_BuildAlignedStatusLine

;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_JMPTBL_CLEANUP_DrawInsetRectFrame   (Routine at _TEXTDISP_JMPTBL_CLEANUP_DrawInsetRectFrame)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   _CLEANUP_DrawInsetRectFrame
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_TEXTDISP_JMPTBL_CLEANUP_DrawInsetRectFrame:
    JMP     _CLEANUP_DrawInsetRectFrame

;!======

    ; Alignment
    MOVEQ   #97,D0
