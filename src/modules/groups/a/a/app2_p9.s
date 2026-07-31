    XDEF    _ESQ_ColdReboot
    XDEF    ESQ_ColdRebootViaSupervisor


;------------------------------------------------------------------------------
; FUNC: _ESQ_ColdReboot   (ColdRebootOrSupervisoruncertain)
; ARGS:
;   (none)
; RET:
;   none (does not return)
; CLOBBERS:
;   A6
; CALLS:
;   exec.library ColdReboot, exec.library Supervisor
; READS:
;   AbsExecBase, ExecBase+20 (version)
; WRITES:
;   (none)
; DESC:
;   Performs a cold reboot via Exec when available; otherwise uses Supervisor.
; NOTES:
;   Branches to a Supervisor-mode reset path on older Exec versions (< $24).
;------------------------------------------------------------------------------
_ESQ_ColdReboot:
    MOVEA.L AbsExecBase,A6
    CMPI.W  #$24,20(A6)
    BLT.S   ESQ_ColdRebootViaSupervisor

    JMP     _LVOColdReboot(A6)

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_ColdRebootViaSupervisor   (ColdRebootViaSupervisoruncertain)
; ARGS:
;   (none)
; RET:
;   none (does not return)
; CLOBBERS:
;   A5/A6
; CALLS:
;   exec.library Supervisor
; READS:
;   AbsExecBase, ExecBase+20 (version)
; WRITES:
;   (none)
; DESC:
;   Falls back to a Supervisor-mode reboot path on older Exec versions.
; NOTES:
;   Loads the supervisor entry address into A5 and calls _LVOSupervisor.
;------------------------------------------------------------------------------
ESQ_ColdRebootViaSupervisor:
    LEA     _ESQ_SupervisorColdReboot(PC),A5
    JSR     _LVOSupervisor(A6)

;!======

    ; Alignment
    ALIGN_WORD
