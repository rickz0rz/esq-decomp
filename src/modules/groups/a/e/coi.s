    XDEF    _COI_FreeEntryResources
    XDEF    COI_FreeEntryResources_Return


;!======

;------------------------------------------------------------------------------
; FUNC: _COI_FreeEntryResources   (Routine at _COI_FreeEntryResources)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A2/A3/A7/D0
; CALLS:
;   _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, _COI_ClearAnimObjectStrings, _COI_FreeSubEntryTableEntries
; READS:
;   _Global_STR_COI_C_3
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_COI_FreeEntryResources:
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.L  A3,D0
    BEQ.S   COI_FreeEntryResources_Return

    MOVEA.L 48(A3),A2
    MOVE.L  A3,-(A7)
    BSR.W   _COI_FreeSubEntryTableEntries

    MOVE.L  A3,(A7)
    BSR.W   _COI_ClearAnimObjectStrings

    ADDQ.W  #4,A7
    MOVE.L  A2,D0
    BEQ.S   .lab_02CF

    PEA     42.W
    MOVE.L  A2,-(A7)
    PEA     815.W
    PEA     _Global_STR_COI_C_3
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.lab_02CF:
    CLR.L   48(A3)

;------------------------------------------------------------------------------
; FUNC: COI_FreeEntryResources_Return   (Routine at COI_FreeEntryResources_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A2
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
COI_FreeEntryResources_Return:
    MOVEM.L (A7)+,A2-A3
    RTS

;!======