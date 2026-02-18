    XDEF    GROUP_AZ_JMPTBL_ESQ_ColdReboot

;------------------------------------------------------------------------------
; FUNC: GROUP_AZ_JMPTBL_ESQ_ColdReboot   (Routine at GROUP_AZ_JMPTBL_ESQ_ColdReboot)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   ESQ_ColdReboot
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
GROUP_AZ_JMPTBL_ESQ_ColdReboot:
    JMP     ESQ_ColdReboot

;!======

    ; Alignment
    MOVEQ   #97,D0
    RTS
    DC.W    $0000
