;------------------------------------------------------------------------------
; DECOMP TARGET group av xjump wrapper module boundary
; SOURCE: modules/groups/a/v/xjump.s
; PURPOSE:
;   Object-level hybrid replacement for the GROUP_AV xjump module now that the
;   wrapper-backed SAS/C compare lanes for GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq,
;   GROUP_AV_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths,
;   GROUP_AV_JMPTBL_ESQ_InvokeGcommandInit,
;   GROUP_AV_JMPTBL_EXEC_CallVector_48, and
;   GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal are green in this checkout.
;   This replacement carries the module body directly instead of delegating
;   back to the canonical asm include.
;------------------------------------------------------------------------------

    XDEF    GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq
    XDEF    GROUP_AV_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths
    XDEF    GROUP_AV_JMPTBL_ESQ_InvokeGcommandInit
    XDEF    GROUP_AV_JMPTBL_EXEC_CallVector_48
    XDEF    GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal

;------------------------------------------------------------------------------
; FUNC: GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq   (JumpStub_ALLOCATE_AllocAndInitializeIOStdReq)
; ARGS:
;   (none observed)
; RET:
;   D0: allocated IOStdReq pointer or 0
; CLOBBERS:
;   D0
; CALLS:
;   ALLOCATE_AllocAndInitializeIOStdReq
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to ALLOCATE_AllocAndInitializeIOStdReq.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq:
    JMP     ALLOCATE_AllocAndInitializeIOStdReq

;------------------------------------------------------------------------------
; FUNC: GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal   (JumpStub_SIGNAL_CreateMsgPortWithSignal)
; ARGS:
;   (none observed)
; RET:
;   D0: created MsgPort pointer or 0
; CLOBBERS:
;   D0
; CALLS:
;   SIGNAL_CreateMsgPortWithSignal
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to SIGNAL_CreateMsgPortWithSignal.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal:
    JMP     SIGNAL_CreateMsgPortWithSignal

;------------------------------------------------------------------------------
; FUNC: GROUP_AV_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths   (JumpStub_DISKIO_ProbeDrivesAndAssignPaths)
; ARGS:
;   (none observed)
; RET:
;   (none)
; CLOBBERS:
;   (none observed)
; CALLS:
;   DISKIO_ProbeDrivesAndAssignPaths
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to DISKIO_ProbeDrivesAndAssignPaths.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AV_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths:
    JMP     DISKIO_ProbeDrivesAndAssignPaths

;------------------------------------------------------------------------------
; FUNC: GROUP_AV_JMPTBL_ESQ_InvokeGcommandInit   (JumpStub_ESQ_InvokeGcommandInit)
; ARGS:
;   (none observed)
; RET:
;   (none)
; CLOBBERS:
;   (none observed)
; CALLS:
;   ESQ_InvokeGcommandInit
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Jump stub to ESQ_InvokeGcommandInit.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AV_JMPTBL_ESQ_InvokeGcommandInit:
    JMP     ESQ_InvokeGcommandInit

;------------------------------------------------------------------------------
; FUNC: GROUP_AV_JMPTBL_EXEC_CallVector_48   (JumpStub_EXEC_CallVector_48)
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
;   Jump stub to EXEC_CallVector_48.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
GROUP_AV_JMPTBL_EXEC_CallVector_48:
    JMP     EXEC_CallVector_48

;!======

    ; Alignment
    MOVEQ   #97,D0
    RTS
    ALIGN_WORD
