;------------------------------------------------------------------------------
; FUNC: UNKNOWN36_FinalizeRequest   (Release task/queue resources and update status??)
; ARGS:
;   stack +16: struct* ?? (A3)
; RET:
;   D0: 0 on success? -1? (depends on D7/D6 checks)
; CLOBBERS:
;   D0/D6-D7/A3 ??
; CALLS:
;   LAB_1916, LAB_1A9D, LAB_1ACC
; READS:
;   16(A3), 20(A3), 24(A3), 27(A3), 28(A3)
; WRITES:
;   24(A3)
; DESC:
;   Conditionally performs cleanup and invokes helper callbacks on the struct.
; NOTES:
;   ??
;------------------------------------------------------------------------------
UNKNOWN36_FinalizeRequest:
LAB_1AB9:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    BTST    #1,27(A3)
    BEQ.S   .no_abort_flag

    ; If flag set, invoke LAB_1916 with -1 and capture result.
    MOVE.L  A3,-(A7)
    PEA     -1.W
    JSR     LAB_1916(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    BRA.S   .after_abort_call

.no_abort_flag:
    MOVEQ   #0,D7

.after_abort_call:
    MOVEQ   #12,D0
    AND.L   24(A3),D0
    BNE.S   .after_optional_cleanup

    TST.L   20(A3)
    BEQ.S   .after_optional_cleanup

    MOVE.L  20(A3),-(A7)
    MOVE.L  16(A3),-(A7)
    JSR     LAB_1A9D(PC)

    ADDQ.W  #8,A7

.after_optional_cleanup:
    CLR.L   24(A3)
    ; Invoke handler at 28(A3).
    MOVE.L  28(A3),-(A7)
    JSR     LAB_1ACC(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D6
    MOVEQ   #-1,D0
    CMP.L   D0,D7
    BEQ.S   .return

    TST.L   D6
    BNE.S   .return

    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: UNKNOWN36_ShowAbortRequester   (Emit abort request to console or open dialog??)
; ARGS:
;   ??
; RET:
;   D0: 0 on success, -1 on failure
; CLOBBERS:
;   D0-D7/A6 ??
; CALLS:
;   _LVOFindTask, _LVOWrite, _LVOOpenLibrary, LAB_1A8C
; READS:
;   LocalDosLibraryDisplacement(A4), task fields at offsets 160/172
; WRITES:
;   -81(A5) buffer, -712(A4)
; DESC:
;   Attempts to write a “break” line to the current task’s console; otherwise
;   opens an Intuition requester using pre-baked strings.
; NOTES:
;   ??
;------------------------------------------------------------------------------
UNKNOWN36_ShowAbortRequester:
LAB_1ABE:
    LINK.W  A5,#-104
    MOVEM.L D2-D3/D6-D7/A6,-(A7)

    MOVEQ   #0,D7
    MOVEA.L -592(A4),A0
    MOVE.B  -1(A0),D7
    MOVEQ   #79,D0
    CMP.L   D0,D7
    BLE.S   .clamp_len

    MOVE.L  D0,D7

.clamp_len:
    MOVE.L  D7,D0
    LEA     -81(A5),A1
    BRA.S   .copy_name_check

.copy_name_loop:
    MOVE.B  (A0)+,(A1)+

.copy_name_check:
    SUBQ.L  #1,D0
    BCC.S   .copy_name_loop

    ; Try to write to the current task's console/CLI if present.
    CLR.B   -81(A5,D7.L)
    MOVEA.L AbsExecBase,A6
    SUBA.L  A1,A1
    JSR     _LVOFindTask(A6)

    MOVE.L  D0,-90(A5)
    MOVEA.L D0,A0
    TST.L   172(A0)
    BEQ.S   .open_requester

    MOVE.L  172(A0),D1
    ASL.L   #2,D1
    MOVEA.L D1,A1
    MOVE.L  56(A1),D6
    MOVEM.L D1,-98(A5)
    TST.L   D6
    BNE.S   .have_console

    MOVE.L  160(A0),D6

.have_console:
    TST.L   D6
    BEQ.S   .open_requester

    ; Emit a "*** Break: " line and the buffered message.
    MOVEA.L LocalDosLibraryDisplacement(A4),A6
    MOVE.L  D6,D1
    LEA     LAB_1ACA(PC),A0
    MOVE.L  A0,D2
    MOVEQ   #11,D3
    JSR     _LVOWrite(A6)

    MOVEA.L D7,A0
    ADDQ.L  #1,D7
    MOVE.L  A0,D0
    MOVE.B  #$a,-81(A5,D0.L)
    MOVEA.L LocalDosLibraryDisplacement(A4),A6
    MOVE.L  D6,D1
    MOVE.L  D7,D3
    LEA     -81(A5),A0
    MOVE.L  A0,D2
    JSR     _LVOWrite(A6)

    MOVEQ   #-1,D0
    BRA.S   .return

.open_requester:
    ; Fall back to an Intuition requester if no CLI output is available.
    MOVEA.L AbsExecBase,A6
    LEA     LOCAL_STR_INTUITION_LIBRARY(PC),A1
    MOVEQ   #0,D0
    JSR     _LVOOpenLibrary(A6)

    MOVE.L  D0,-102(A5)
    BNE.S   .have_intuition

    MOVEQ   #-1,D0
    BRA.S   .return

.have_intuition:
    LEA     -81(A5),A0
    MOVE.L  A0,-712(A4)
    MOVE.L  -102(A5),-(A7)
    PEA     60.W
    PEA     250.W
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -684(A4)
    PEA     -704(A4)
    PEA     -724(A4)
    CLR.L   -(A7)
    JSR     LAB_1A8C(PC)

    LEA     36(A7),A7
    SUBQ.L  #1,D0
    BEQ.S   .requester_ok

    MOVEQ   #-1,D0
    BRA.S   .return

.requester_ok:
    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,D2-D3/D6-D7/A6
    UNLK    A5
    RTS

;!======

LAB_1AC7:
    DC.B    "** User Abort Requested **",0,0

LAB_1AC8:
    DC.B    "CONTINUE",0,0

LAB_1AC9:
    DC.B    "ABORT",0

LAB_1ACA:
    DC.B    "*** Break: ",0

LOCAL_STR_INTUITION_LIBRARY:
    DC.B    "intuition.library",0

;!======

    ; Alignment
    DS.W    3
    DC.W    $7061
