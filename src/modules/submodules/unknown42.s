    XDEF    CLOCK_CheckDateOrSecondsFromEpoch
    XDEF    CLOCK_SecondsFromEpoch
    XDEF    PARALLEL_CheckReady
    XDEF    PARALLEL_CheckReadyStub
    XDEF    PARALLEL_RawDoFmt
    XDEF    PARALLEL_RawDoFmtCommon
    XDEF    PARALLEL_RawDoFmtStackArgs
    XDEF    PARALLEL_WaitReady
    XDEF    PARALLEL_WriteCharD0
    XDEF    PARALLEL_WriteCharHw
    XDEF    PARALLEL_WriteStringLoop

;------------------------------------------------------------------------------
; FUNC: CLOCK_CheckDateOrSecondsFromEpoch   (CheckDateOrSecondsFromEpochuncertain)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D0, A0, A6
; CALLS:
;   utility.library CheckDate
; READS:
;   Global_REF_UTILITY_LIBRARY
; WRITES:
;   (none)
; DESC:
;   Validates a ClockData struct via CheckDate.
; NOTES:
;   The return semantics of CheckDate are treated as-is; callers interpret D0.
;------------------------------------------------------------------------------
CLOCK_CheckDateOrSecondsFromEpoch:
    MOVE.L  A6,-(A7)

    SetOffsetForStack 1

    MOVEA.L Global_REF_UTILITY_LIBRARY,A6
    MOVEA.L .stackOffsetBytes+4(A7),A0
    JSR     _LVOCheckDate(A6)

    MOVEA.L (A7)+,A6
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLOCK_SecondsFromEpoch
; ARGS:
;   stack +4: clockData (ClockDatauncertain)
; RET:
;   D0: seconds since Amiga epoch
; CLOBBERS:
;   D0, A0, A6
; CALLS:
;   utility.library Date2Amiga
; READS:
;   Global_REF_UTILITY_LIBRARY
; WRITES:
;   (none)
; DESC:
;   Converts a ClockData struct into seconds since the Amiga epoch.
; NOTES:
;   Assumes input was already validated.
;------------------------------------------------------------------------------
CLOCK_SecondsFromEpoch:
    MOVE.L  A6,-(A7)

    MOVEA.L Global_REF_UTILITY_LIBRARY,A6
    MOVEA.L 8(A7),A0
    JSR     _LVODate2Amiga(A6)

    MOVEA.L (A7)+,A6
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARALLEL_WriteChar   (WriteCharToParalleluncertain)
; ARGS:
;   stack +4: ch (byte)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1
; CALLS:
;   PARALLEL_WriteCharD0
; READS:
;   (none)
; WRITES:
;   CIAA/CIAB registers (see NOTES)
; DESC:
;   Writes a single character using the parallel-port routine.
; NOTES:
;   Low-level output uses CIAA/CIAB handshake; exact device target is inferred.
;   Completes the operation by falling through to PARALLEL_WriteCharD0.
;------------------------------------------------------------------------------
    MOVE.L  4(A7),D0

;!======

;------------------------------------------------------------------------------
; FUNC: PARALLEL_WriteCharD0   (WriteCharD0uncertain)
; ARGS:
;   D0: ch (byte)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1
; CALLS:
;   PARALLEL_WriteCharHw
; READS:
;   (none)
; WRITES:
;   CIAA/CIAB registers (see NOTES)
; DESC:
;   Writes the character in D0 using the low-level parallel writer.
; NOTES:
;   Converts LF to CR+LF behavior before output.
;------------------------------------------------------------------------------
PARALLEL_WriteCharD0:
    JSR     PARALLEL_WriteCharHw

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARALLEL_WriteString   (WriteStringToParalleluncertain)
; ARGS:
;   stack +4: str (null-terminated)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, A0
; CALLS:
;   PARALLEL_WriteCharD0
; READS:
;   [str]
; WRITES:
;   CIAA/CIAB registers (see NOTES)
; DESC:
;   Outputs a null-terminated string via the parallel writer.
; NOTES:
;   Stops on NUL; uses the D0 output routine for each byte.
;------------------------------------------------------------------------------
    MOVEA.L 4(A7),A0

;------------------------------------------------------------------------------
; FUNC: PARALLEL_WriteStringLoop   (Routine at PARALLEL_WriteStringLoop)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
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
PARALLEL_WriteStringLoop:
    MOVE.B  (A0)+,D0
    BEQ.S   .return

    BSR.S   PARALLEL_WriteCharD0

    BRA.S   PARALLEL_WriteStringLoop

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARALLEL_WaitReady   (WaitReadyuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0
; CALLS:
;   PARALLEL_CheckReady
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Busy-waits until PARALLEL_CheckReady returns non-negative.
; NOTES:
;   Current stub always returns -1, so this loops forever if called.
;------------------------------------------------------------------------------
PARALLEL_WaitReady:
    BSR.S   PARALLEL_CheckReady

    TST.L   D0
    BMI.S   PARALLEL_WaitReady

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARALLEL_CheckReady   (CheckReadyuncertain)
; ARGS:
;   (none)
; RET:
;   D0: status (negative means not-ready)
; CLOBBERS:
;   D0
; CALLS:
;   PARALLEL_CheckReadyStub
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Wrapper for a readiness probe (currently stubbed).
; NOTES:
;   Calls PARALLEL_CheckReadyStub which returns -1.
;------------------------------------------------------------------------------
PARALLEL_CheckReady:
    JSR     PARALLEL_CheckReadyStub

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARALLEL_RawDoFmtPtrs   (RawDoFmtPtrsuncertain)
; ARGS:
;   stack +4: fmtPtr
;   stack +8: argsPtr
; RET:
;   (none)
; CLOBBERS:
;   A0-A2
; CALLS:
;   .lab_JMPTBL_PARALLEL_RawDoFmt
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   RawDoFmt wrapper using explicit format and args pointers.
; NOTES:
;   Marked dead code; entry label not referenced externally.
;------------------------------------------------------------------------------
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    BRA.S   PARALLEL_RawDoFmtCommon

;------------------------------------------------------------------------------
; FUNC: PARALLEL_RawDoFmtStackArgs   (RawDoFmtStackArgsuncertain)
; ARGS:
;   stack +4: fmtPtr
;   stack +8: first arg on stack
; RET:
;   (none)
; CLOBBERS:
;   A0-A2
; CALLS:
;   .lab_JMPTBL_PARALLEL_RawDoFmt
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   RawDoFmt wrapper using stack-based argument list.
; NOTES:
;   Uses A1 = &stack+8 for RawDoFmt argument stream.
;------------------------------------------------------------------------------
PARALLEL_RawDoFmtStackArgs:
    MOVEA.L 4(A7),A0
    LEA     8(A7),A1

;------------------------------------------------------------------------------
; FUNC: PARALLEL_RawDoFmtCommon   (Routine at PARALLEL_RawDoFmtCommon)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A2/A7/D0
; CALLS:
;   PARALLEL_RawDoFmt
; READS:
;   PARALLEL_WriteCharD0
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
PARALLEL_RawDoFmtCommon:
    MOVEM.L A2,-(A7)
    LEA     PARALLEL_WriteCharD0(PC),A2
    BSR.S   .lab_JMPTBL_PARALLEL_RawDoFmt

    MOVEM.L (A7)+,A2
    RTS

.lab_JMPTBL_PARALLEL_RawDoFmt:
    JSR     PARALLEL_RawDoFmt

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARALLEL_RawDoFmtRegs   (RawDoFmtRegsuncertain)
; ARGS:
;   A0-A3: RawDoFmt inputs (format + args + output hook)
; RET:
;   (none)
; CLOBBERS:
;   A0-A3
; CALLS:
;   .lab_JMPTBL_PARALLEL_RawDoFmt
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   RawDoFmt wrapper that preserves A2/A3.
; NOTES:
;   Marked dead code; entry label not referenced externally.
;------------------------------------------------------------------------------
    MOVEM.L A2-A3,-(A7)
    MOVEM.L 12(A7),A0-A3
    BSR.S   .lab_JMPTBL_PARALLEL_RawDoFmt

    MOVEM.L (A7)+,A2-A3
    RTS

;!======

    ; Alignment/padding?
    DC.W    $0000

;------------------------------------------------------------------------------
; FUNC: PARALLEL_WriteCharHwFromStack   (WriteCharHwFromStackuncertain)
; ARGS:
;   stack +4: ch (byte)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1
; CALLS:
;   PARALLEL_WriteCharHw
; READS:
;   (none)
; WRITES:
;   CIAA/CIAB registers (see NOTES)
; DESC:
;   Writes a single character using the low-level parallel routine.
; NOTES:
;   Entry is preceded by a padding word; keep layout intact.
;------------------------------------------------------------------------------
    MOVE.L  4(A7),D0

;------------------------------------------------------------------------------
; FUNC: PARALLEL_WriteCharHw   (WriteCharHwuncertain)
; ARGS:
;   D0: ch (byte)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1
; CALLS:
;   (none)
; READS:
;   CIAB_PRA
; WRITES:
;   CIAA_DDRB, CIAA_PRB
; DESC:
;   Low-level parallel output with CIAA/CIAB handshake.
; NOTES:
;   Translates LF (0x0A) into CR + LF.
;------------------------------------------------------------------------------
PARALLEL_WriteCharHw:
    MOVE.B  D0,-(A7)
    CMPI.B  #$a,D0
    BNE.S   .PARALLEL_WriteCharRestore

    MOVEQ   #13,D0
    BSR.S   .PARALLEL_WriteCharWaitAndWrite

.PARALLEL_WriteCharRestore:
    MOVE.B  (A7)+,D0

.PARALLEL_WriteCharWaitAndWrite:
    MOVE.B  CIAB_PRA,D1
    BTST    #0,D1
    BNE.S   .PARALLEL_WriteCharWaitAndWrite

    MOVE.B  #$ff,CIAA_DDRB
    MOVE.B  D0,CIAA_PRB
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARALLEL_RawDoFmt   (RawDoFmtParalleluncertain)
; ARGS:
;   A0: format string
;   A1: argument stream
; RET:
;   (none)
; CLOBBERS:
;   A2/A6
; CALLS:
;   exec.library RawDoFmt
; READS:
;   AbsExecBase
; WRITES:
;   (none)
; DESC:
;   Calls RawDoFmt with the parallel output hook.
; NOTES:
;   Uses PARALLEL_WriteCharHw as the output function.
;------------------------------------------------------------------------------
PARALLEL_RawDoFmt:
    MOVEM.L A2/A6,-(A7)

    LEA     PARALLEL_WriteCharHw(PC),A2
    MOVEA.L AbsExecBase,A6
    JSR     _LVORawDoFmt(A6)

    MOVEM.L (A7)+,A2/A6
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARALLEL_CheckReadyStub   (CheckReadyStub)
; ARGS:
;   (none)
; RET:
;   D0: -1
; CLOBBERS:
;   D0
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Placeholder ready-check stub.
; NOTES:
;   Always returns -1.
;------------------------------------------------------------------------------
PARALLEL_CheckReadyStub:
    MOVEQ   #-1,D0
    RTS

;!======

    ; Alignment
    ALIGN_WORD
