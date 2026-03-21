;------------------------------------------------------------------------------
; DECOMP TARGET direct hybrid replacement
; SOURCE: modules/groups/a/r/xjump.s
; PURPOSE:
;   Carry the Group AR wrapper module body directly now that the maintained
;   SAS/C compare lanes for its two wrapper exports are green in this checkout.
;------------------------------------------------------------------------------

    XDEF    GROUP_AR_JMPTBL_PARSEINI_WriteErrorLogEntry
    XDEF    GROUP_AR_JMPTBL_STRING_AppendAtNull

;------------------------------------------------------------------------------
; FUNC: GROUP_AR_JMPTBL_PARSEINI_WriteErrorLogEntry   (Routine at GROUP_AR_JMPTBL_PARSEINI_WriteErrorLogEntry)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   PARSEINI_WriteErrorLogEntry
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
GROUP_AR_JMPTBL_PARSEINI_WriteErrorLogEntry:
    JMP     PARSEINI_WriteErrorLogEntry

;------------------------------------------------------------------------------
; FUNC: GROUP_AR_JMPTBL_STRING_AppendAtNull   (Routine at GROUP_AR_JMPTBL_STRING_AppendAtNull)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STRING_AppendAtNull
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
GROUP_AR_JMPTBL_STRING_AppendAtNull:
    JMP     STRING_AppendAtNull
