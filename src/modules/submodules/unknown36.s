;------------------------------------------------------------------------------
; Struct offsets (UNKNOWN36 request struct)
Struct_UNKNOWN36_Request__Arg16     = 16
Struct_UNKNOWN36_Request__Arg20     = 20
Struct_UNKNOWN36_Request__Flags     = 24
Struct_UNKNOWN36_Request__FlagByte  = 27
Struct_UNKNOWN36_Request__Handler   = 28
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; FUNC: UNKNOWN36_FinalizeRequest   (Finalize a request struct and dispatch callbacks.)
; ARGS:
;   stack +16: struct* request (A3)
; RET:
;   D0: 0 on success, -1 on failure
; CLOBBERS:
;   D0/D6-D7/A3 ??
; CALLS:
;   STREAM_BufferedPutcOrFlush, ALLOC_InsertFreeBlock, HANDLE_CloseByIndex
; READS:
;   Struct_UNKNOWN36_Request__Arg16: ptr ??
;   Struct_UNKNOWN36_Request__Arg20: ptr ??
;   Struct_UNKNOWN36_Request__Flags: flags (bitmask, uses 0x0c)
;   Struct_UNKNOWN36_Request__FlagByte: flags (bit 1 triggers STREAM_BufferedPutcOrFlush)
;   Struct_UNKNOWN36_Request__Handler: handler/callback pointer
; WRITES:
;   Struct_UNKNOWN36_Request__Flags: flags cleared
; DESC:
;   If a flag is set, calls a callback with -1, optionally runs a secondary
;   cleanup, clears the flags field, then invokes the struct’s handler at 28(A3).
; NOTES:
;   Returns -1 if STREAM_BufferedPutcOrFlush returns -1 or if the handler returns non-zero.
;------------------------------------------------------------------------------
UNKNOWN36_FinalizeRequest:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    BTST    #1,Struct_UNKNOWN36_Request__FlagByte(A3)
    BEQ.S   .no_abort_flag

    ; If flag set, invoke STREAM_BufferedPutcOrFlush with -1 and capture result.
    MOVE.L  A3,-(A7)
    PEA     -1.W
    JSR     STREAM_BufferedPutcOrFlush(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    BRA.S   .after_abort_call

.no_abort_flag:
    MOVEQ   #0,D7

.after_abort_call:
    MOVEQ   #12,D0
    AND.L   Struct_UNKNOWN36_Request__Flags(A3),D0
    BNE.S   .after_optional_cleanup

    TST.L   Struct_UNKNOWN36_Request__Arg20(A3)
    BEQ.S   .after_optional_cleanup

    MOVE.L  Struct_UNKNOWN36_Request__Arg20(A3),-(A7)
    MOVE.L  Struct_UNKNOWN36_Request__Arg16(A3),-(A7)
    JSR     ALLOC_InsertFreeBlock(PC)

    ADDQ.W  #8,A7

.after_optional_cleanup:
    CLR.L   Struct_UNKNOWN36_Request__Flags(A3)
    ; Invoke handler at 28(A3).
    MOVE.L  Struct_UNKNOWN36_Request__Handler(A3),-(A7)
    JSR     HANDLE_CloseByIndex(PC)

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
; FUNC: UNKNOWN36_ShowAbortRequester   (Emit abort request to console or open dialog.)
; ARGS:
;   none (uses globals via A4)
; RET:
;   D0: 0 on requester success, -1 on failure
; CLOBBERS:
;   D0-D7/A6 ??
; CALLS:
;   _LVOFindTask, _LVOWrite, _LVOOpenLibrary, EXEC_CallVector_348
; READS:
;   Global_UNKNOWN36_MessagePtr: ptr to message buffer (length byte at -1(A0))
;   LocalDosLibraryDisplacement(A4), task fields at offsets 160/172
;   Global_UNKNOWN36_RequesterText0/1/2: requester text tables
; WRITES:
;   -81(A5) buffer, Global_UNKNOWN36_RequesterOutPtr
; DESC:
;   Attempts to write a “*** Break: ” line plus the buffered message to the
;   current task’s console; otherwise opens an Intuition requester.
; NOTES:
;   Uses the byte at -1(A0) as a length, clamped to 79.
;------------------------------------------------------------------------------
UNKNOWN36_ShowAbortRequester:
    LINK.W  A5,#-104
    MOVEM.L D2-D3/D6-D7/A6,-(A7)

    MOVEQ   #0,D7
    MOVEA.L Global_UNKNOWN36_MessagePtr(A4),A0
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
    LEA     DEBUG_STR_Break(PC),A0
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
    LEA     DEBUG_STR_INTUITION_LIBRARY(PC),A1
    MOVEQ   #0,D0
    JSR     _LVOOpenLibrary(A6)

    MOVE.L  D0,-102(A5)
    BNE.S   .have_intuition

    MOVEQ   #-1,D0
    BRA.S   .return

.have_intuition:
    LEA     -81(A5),A0
    MOVE.L  A0,Global_UNKNOWN36_RequesterOutPtr(A4)
    MOVE.L  -102(A5),-(A7)
    PEA     60.W
    PEA     250.W
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_UNKNOWN36_RequesterText2(A4)
    PEA     Global_UNKNOWN36_RequesterText1(A4)
    PEA     Global_UNKNOWN36_RequesterText0(A4)
    CLR.L   -(A7)
    JSR     EXEC_CallVector_348(PC)

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

DEBUG_STR_UserAbortRequested:
    DC.B    "** User Abort Requested **",0,0

DEBUG_STR_Continue:
    DC.B    "CONTINUE",0,0

DEBUG_STR_Abort:
    DC.B    "ABORT",0

DEBUG_STR_Break:
    DC.B    "*** Break: ",0

DEBUG_STR_INTUITION_LIBRARY:
    DC.B    "intuition.library",0

;!======

    ; Alignment
    DS.W    3
    DC.W    $7061
