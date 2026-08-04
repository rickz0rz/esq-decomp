    XDEF    _GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq
    XDEF    _GROUP_AV_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths
    XDEF    _GROUP_AV_JMPTBL_ESQ_InvokeGcommandInit
    XDEF    _GROUP_AV_JMPTBL_EXEC_CallVector_48
    XDEF    _GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal

;------------------------------------------------------------------------------
; FUNC: _GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq   (Routine at _GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ALLOCATE_AllocAndInitializeIOStdReq
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq:
    JMP     _ALLOCATE_AllocAndInitializeIOStdReq

;------------------------------------------------------------------------------
; FUNC: _GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal   (Routine at _GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _SIGNAL_CreateMsgPortWithSignal
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal:
    JMP     _SIGNAL_CreateMsgPortWithSignal

;------------------------------------------------------------------------------
; FUNC: _GROUP_AV_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths   (Routine at _GROUP_AV_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _DISKIO_ProbeDrivesAndAssignPaths
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_GROUP_AV_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths:
    JMP     _DISKIO_ProbeDrivesAndAssignPaths

;------------------------------------------------------------------------------
; FUNC: _GROUP_AV_JMPTBL_ESQ_InvokeGcommandInit   (Routine at _GROUP_AV_JMPTBL_ESQ_InvokeGcommandInit)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQ_InvokeGcommandInit
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_GROUP_AV_JMPTBL_ESQ_InvokeGcommandInit:
    JMP     _ESQ_InvokeGcommandInit

;------------------------------------------------------------------------------
; FUNC: _GROUP_AV_JMPTBL_EXEC_CallVector_48   (Routine at _GROUP_AV_JMPTBL_EXEC_CallVector_48)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   _EXEC_CallVector_48
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_GROUP_AV_JMPTBL_EXEC_CallVector_48:
    JMP     _EXEC_CallVector_48

;!======

    ; Alignment
    MOVEQ   #97,D0
