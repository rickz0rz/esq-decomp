    XDEF    GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq
    XDEF    GROUP_AV_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths
    XDEF    GROUP_AV_JMPTBL_ESQ_InvokeGcommandInit
    XDEF    GROUP_AV_JMPTBL_EXEC_CallVector_48
    XDEF    GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal

;------------------------------------------------------------------------------
; FUNC: GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq   (Routine at GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ALLOCATE_AllocAndInitializeIOStdReq
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq:
    JMP     ALLOCATE_AllocAndInitializeIOStdReq

;------------------------------------------------------------------------------
; FUNC: GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal   (Routine at GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   SIGNAL_CreateMsgPortWithSignal
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal:
    JMP     SIGNAL_CreateMsgPortWithSignal

;------------------------------------------------------------------------------
; FUNC: GROUP_AV_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths   (Routine at GROUP_AV_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DISKIO_ProbeDrivesAndAssignPaths
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
GROUP_AV_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths:
    JMP     DISKIO_ProbeDrivesAndAssignPaths

;------------------------------------------------------------------------------
; FUNC: GROUP_AV_JMPTBL_ESQ_InvokeGcommandInit   (Routine at GROUP_AV_JMPTBL_ESQ_InvokeGcommandInit)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_InvokeGcommandInit
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
GROUP_AV_JMPTBL_ESQ_InvokeGcommandInit:
    JMP     ESQ_InvokeGcommandInit

;------------------------------------------------------------------------------
; FUNC: GROUP_AV_JMPTBL_EXEC_CallVector_48   (Routine at GROUP_AV_JMPTBL_EXEC_CallVector_48)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   EXEC_CallVector_48
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
GROUP_AV_JMPTBL_EXEC_CallVector_48:
    JMP     EXEC_CallVector_48

;!======

    ; Alignment
    MOVEQ   #97,D0
