;------------------------------------------------------------------------------
; FUNC: ESQ_SupervisorColdReboot   (SupervisorColdRebootuncertain)
; ARGS:
;   (none)
; RET:
;   none (does not return)
; CLOBBERS:
;   D0/D1/A0
; CALLS:
;   (none)
; READS:
;   AA55, ESQ_TryRomWriteTest, FBFFFC
; WRITES:
;   (none) (see NOTES)
; DESC:
;   Supervisor-mode reboot path that computes a ROM reset vector and jumps to it.
; NOTES:
;   Entered via _LVOSupervisor when Exec version < $24.
;   Uses the longword at $00FFFFEC to derive a base, then jumps via [base+4]-2.
;   A ROM write-test sequence follows but is unreachable due to the JMP; keep as-is.
;------------------------------------------------------------------------------
ESQ_SupervisorColdReboot:
    LEA     $1000000,A0
    SUBA.L  -20(A0),A0  ; [0x00FFFFEC] = uncertain (ROM base offset?)
    MOVEA.L 4(A0),A0    ; [A0+4] = reset vectoruncertain (to be jumped to)
    SUBQ.L  #2,A0       ; Adjust vector address (align/format?) uncertain
    RESET               ; Reset external devices
    JMP     (A0)        ; Jump to reset vector

    MOVE.L  #$FBFFFC,D0 ; Something in the system rom.
    MOVEA.L D0,A0
    MOVE.W  (A0),D1
    MOVE.W  #$55AA,(A0) ; Are we dynamically patching the rom?
    MOVE.W  (A0),D0
    CMPI.W  #$55AA,D0
    BNE.W   ESQ_TryRomWriteTest

    MOVE.W  #$AA55,(A0)
    MOVE.W  (A0),D0
    CMPI.W  #$AA55,D0
    BNE.W   ESQ_TryRomWriteTest

    MOVE.W  D1,(A0)
    MOVEQ   #0,D0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_TryRomWriteTest   (TryRomWriteTestuncertain)
; ARGS:
;   (none)
; RET:
;   D0: 1 on failure, 0 on success
; CLOBBERS:
;   D0-D1, A0
; CALLS:
;   (none)
; READS:
;   [ROM?]
; WRITES:
;   [ROM?] (write-test values)
; DESC:
;   Attempts a ROM write-test sequence and reports success/failure.
; NOTES:
;   Used by ESQ_SupervisorColdReboot; likely unreachable when ROM is read-only.
;------------------------------------------------------------------------------
ESQ_TryRomWriteTest:
    MOVEQ   #1,D0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_InvokeGcommandInit   (InvokeGcommandInituncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0-A1
; CALLS:
;   GCOMMAND_ProcessCtrlCommand
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Simple wrapper around GCOMMAND_ProcessCtrlCommand with register preservation.
; NOTES:
;   Likely used as a callback.
;------------------------------------------------------------------------------
ESQ_InvokeGcommandInit:
    MOVEM.L A0-A1,-(A7)
    JSR     GCOMMAND_ProcessCtrlCommand

    ADDQ.L  #8,A7
    RTS

;!======

    ; Alignment
    ALIGN_WORD
