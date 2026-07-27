    XDEF    _LOCAVAIL2_DisplayAlertDelayAndReboot


;------------------------------------------------------------------------------
; FUNC: _LOCAVAIL2_DisplayAlertDelayAndReboot   (Routine at _LOCAVAIL2_DisplayAlertDelayAndReboot)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A4/A7/D0/D7
; CALLS:
;   _GROUP_AZ_JMPTBL_ESQ_ColdReboot
; READS:
;   _Global_REF_LONG_FILE_SCRATCH, f4240
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_LOCAVAIL2_DisplayAlertDelayAndReboot:
    LINK.W  A5,#-4
    MOVEM.L D7/A4,-(A7)
    LEA     _Global_REF_LONG_FILE_SCRATCH,A4
    MOVEQ   #0,D7

.lab_0FA1:
    CMPI.L  #$f4240,D7
    BGE.S   .lab_0FA2

    ADDQ.L  #1,D7
    BRA.S   .lab_0FA1

.lab_0FA2:
    JSR     _GROUP_AZ_JMPTBL_ESQ_ColdReboot(PC)

    MOVEQ   #0,D0
    MOVEM.L (A7)+,D7/A4
    UNLK    A5
    RTS

;!======