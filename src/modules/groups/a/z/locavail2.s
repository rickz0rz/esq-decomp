;------------------------------------------------------------------------------
; FUNC: OVERRIDE_INTUITION_FUNCS   (Routine at OVERRIDE_INTUITION_FUNCS)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A6/A7/D0
; CALLS:
;   _LVOSetFunction
; READS:
;   AbsExecBase, GLOB_REF_INTUITION_LIBRARY, LOCAVAIL2_AutoRequestNoOp, LOCAVAIL2_DisplayAlertDelayAndReboot, _LVOAutoRequest, _LVODisplayAlert
; WRITES:
;   GLOB_REF_BACKED_UP_INTUITION_AUTOREQUEST, GLOB_REF_BACKED_UP_INTUITION_DISPLAYALERT
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
OVERRIDE_INTUITION_FUNCS:
    MOVE.L  A2,-(A7)

    ; overriding the AutoRequest function in intuition.library
    ; to point to LOCAVAIL2_AutoRequestNoOp(PC) storing the old version in GLOB_REF_BACKED_UP_INTUITION_AUTOREQUEST
    MOVEA.L GLOB_REF_INTUITION_LIBRARY,A1
    MOVEA.W #_LVOAutoRequest,A0
    LEA     LOCAVAIL2_AutoRequestNoOp(PC),A2
    MOVE.L  A2,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOSetFunction(A6)

    MOVE.L  D0,GLOB_REF_BACKED_UP_INTUITION_AUTOREQUEST

    ; overriding the ItemAddress function in intuition.library
    ; to point to LOCAVAIL2_DisplayAlertDelayAndReboot(PC) storing the old version in GLOB_REF_BACKED_UP_INTUITION_DISPLAYALERT
    MOVEA.L GLOB_REF_INTUITION_LIBRARY,A1
    MOVEA.W #_LVODisplayAlert,A0
    LEA     LOCAVAIL2_DisplayAlertDelayAndReboot(PC),A2
    MOVE.L  A2,D0
    JSR     _LVOSetFunction(A6)

    MOVE.L  D0,GLOB_REF_BACKED_UP_INTUITION_DISPLAYALERT

    MOVEA.L (A7)+,A2
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL2_AutoRequestNoOp   (Routine at LOCAVAIL2_AutoRequestNoOp)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A4/A7/D0
; CALLS:
;   (none)
; READS:
;   GLOB_REF_LONG_FILE_SCRATCH
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
LOCAVAIL2_AutoRequestNoOp:
    MOVE.L  A4,-(A7)
    LEA     GLOB_REF_LONG_FILE_SCRATCH,A4
    MOVEQ   #0,D0
    MOVEA.L (A7)+,A4
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL2_DisplayAlertDelayAndReboot   (Routine at LOCAVAIL2_DisplayAlertDelayAndReboot)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A4/A7/D0/D7
; CALLS:
;   GROUP_AZ_JMPTBL_ESQ_ColdReboot
; READS:
;   GLOB_REF_LONG_FILE_SCRATCH, f4240
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
LOCAVAIL2_DisplayAlertDelayAndReboot:
    LINK.W  A5,#-4
    MOVEM.L D7/A4,-(A7)
    LEA     GLOB_REF_LONG_FILE_SCRATCH,A4
    MOVEQ   #0,D7

.LAB_0FA1:
    CMPI.L  #$f4240,D7
    BGE.S   .LAB_0FA2

    ADDQ.L  #1,D7
    BRA.S   .LAB_0FA1

.LAB_0FA2:
    JSR     GROUP_AZ_JMPTBL_ESQ_ColdReboot(PC)

    MOVEQ   #0,D0
    MOVEM.L (A7)+,D7/A4
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

