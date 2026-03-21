;------------------------------------------------------------------------------
; DECOMP TARGET group az xjump cold-reboot wrapper module boundary
; SOURCE: modules/groups/a/z/xjump.s
; PURPOSE:
;   Object-level hybrid replacement for the GROUP_AZ xjump module now that the
;   wrapper-backed SAS/C compare lane for GROUP_AZ_JMPTBL_ESQ_ColdReboot is
;   green in the maintained sweep. This replacement carries the module body
;   directly instead of delegating back to the canonical asm include.
;------------------------------------------------------------------------------

    XDEF    GROUP_AZ_JMPTBL_ESQ_ColdReboot

;------------------------------------------------------------------------------
; FUNC: GROUP_AZ_JMPTBL_ESQ_ColdReboot   (Jump-table forwarder)
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
;   Thin jump-table forwarder; execution immediately transfers to the shared
;   cold-reboot helper.
; NOTES:
;   No local logic; argument/return behavior matches ESQ_ColdReboot.
;------------------------------------------------------------------------------
GROUP_AZ_JMPTBL_ESQ_ColdReboot:
    JMP     ESQ_ColdReboot

;!======

    ; Alignment
    MOVEQ   #97,D0
    RTS
    DC.W    $0000
