    XDEF    ESQ_ParseCommandLineAndRun
    XDEF    UNKNOWN29_JMPTBL_ESQ_MainInitAndRun

;------------------------------------------------------------------------------
; FUNC: ESQ_ParseCommandLineAndRun   (Parse command line, init handles, run main.)
; ARGS:
;   stack +6: A3 = command line buffer
; RET:
;   D0: result/status
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   HANDLE_CloseAllAndReturnWithCode, STRING_AppendN, BUFFER_FlushAllAndCloseWithCode,
;   UNKNOWN29_JMPTBL_ESQ_MainInitAndRun
; READS:
;   Global_ArgCount, Global_ArgvStorage, Global_SavedMsg, Global_DefaultHandleFlags
; WRITES:
;   Global_ArgCount, Global_ArgvPtr, Global_HandleEntry* globals,
;   Global_PreallocHandleNode0/1/2_* startup state fields
; DESC:
;   Tokenizes the command line into argv storage, sets up console/handles,
;   installs the abort requester callback, and enters the main loop.
; NOTES:
;   Handles quoted strings and whitespace; uses '*' as default output when args exist.
;------------------------------------------------------------------------------
ESQ_ParseCommandLineAndRun:
    LINK.W  A5,#-16
    MOVEM.L D2/D7/A2-A3/A6,-(A7)

    SetOffsetForStack   5
    UseStackLong    MOVEA.L,6,A3

.parse_loop:
    CMPI.L  #' ',Global_ArgCount(A4)
    BGE.W   .finalize_args

.skip_whitespace:
    MOVE.B  (A3),D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BEQ.S   .advance_whitespace

    MOVEQ   #9,D1
    CMP.B   D1,D0
    BEQ.S   .advance_whitespace

    MOVEQ   #10,D1
    CMP.B   D1,D0
    BNE.S   .token_start

.advance_whitespace:
    ADDQ.L  #1,A3
    BRA.S   .skip_whitespace

.token_start:
    TST.B   (A3)
    BEQ.S   .finalize_args

    MOVE.L  Global_ArgCount(A4),D0
    ASL.L   #2,D0
    ADDQ.L  #1,Global_ArgCount(A4)
    LEA     Global_ArgvStorage(A4),A0
    ADDA.L  D0,A0
    MOVEA.L A0,A2
    MOVEQ   #34,D0
    CMP.B   (A3),D0
    BNE.S   .token_unquoted

    ADDQ.L  #1,A3
    MOVE.L  A3,(A2)

.scan_quoted:
    TST.B   (A3)
    BEQ.S   .end_quote

    MOVEQ   #34,D0
    CMP.B   (A3),D0
    BEQ.S   .end_quote

    ADDQ.L  #1,A3
    BRA.S   .scan_quoted

.end_quote:
    TST.B   (A3)
    BNE.S   .terminate_quoted

    PEA     1.W
    JSR     HANDLE_CloseAllAndReturnWithCode(PC)

    ADDQ.W  #4,A7
    BRA.S   .parse_loop

.terminate_quoted:
    CLR.B   (A3)+
    BRA.S   .parse_loop

.token_unquoted:
    MOVE.L  A3,(A2)

.scan_unquoted:
    TST.B   (A3)
    BEQ.S   .end_unquoted

    MOVE.B  (A3),D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BEQ.S   .end_unquoted

    MOVEQ   #9,D1
    CMP.B   D1,D0
    BEQ.S   .end_unquoted

    MOVEQ   #10,D1
    CMP.B   D1,D0
    BEQ.S   .end_unquoted

    ADDQ.L  #1,A3
    BRA.S   .scan_unquoted

.end_unquoted:
    TST.B   (A3)
    BNE.S   .terminate_unquoted

    BRA.S   .finalize_args

.terminate_unquoted:
    CLR.B   (A3)+
    BRA.W   .parse_loop

.finalize_args:
    TST.L   Global_ArgCount(A4)
    BNE.S   .argv_from_storage

    MOVEA.L Global_SavedMsg(A4),A0
    BRA.S   .set_argv_ptr

.argv_from_storage:
    LEA     Global_ArgvStorage(A4),A0

.set_argv_ptr:
    MOVE.L  A0,Global_ArgvPtr(A4)
    TST.L   Global_ArgCount(A4)
    BNE.S   .setup_existing_handles

    LEA     .loc(PC),A1
    LEA     Global_ConsoleNameBuffer(A4),A6
    MOVE.L  (A1)+,(A6)+
    MOVE.L  (A1)+,(A6)+
    MOVE.L  (A1)+,(A6)+
    MOVE.L  (A1)+,(A6)+
    MOVE.W  (A1),(A6)
    MOVEA.L Global_SavedMsg(A4),A1
    MOVEA.L 36(A1),A0
    PEA     40.W
    MOVE.L  4(A0),-(A7)
    PEA     Global_ConsoleNameBuffer(A4)
    JSR     STRING_AppendN(PC)

    LEA     12(A7),A7
    MOVEA.L Global_DosLibrary(A4),A6
    LEA     Global_ConsoleNameBuffer(A4),A0
    MOVE.L  A0,D1
    MOVE.L  #MODE_NEWFILE,D2
    JSR     _LVOOpen(A6)

    MOVE.L  D0,Global_HandleEntry0_Ptr(A4)
    MOVE.L  D0,Global_HandleEntry1_Ptr(A4)
    MOVEQ   #16,D1
    MOVE.L  D1,Global_HandleEntry1_Flags(A4)
    MOVE.L  D0,Global_HandleEntry2_Ptr(A4)
    MOVE.L  D1,Global_HandleEntry2_Flags(A4)
    ASL.L   #2,D0
    MOVE.L  D0,-16(A5)
    MOVEA.L AbsExecBase,A6
    SUBA.L  A1,A1
    JSR     _LVOFindTask(A6)

    MOVEA.L -16(A5),A0
    MOVEA.L D0,A1
    MOVE.L  8(A0),164(A1)
    MOVEQ   #0,D7
    MOVE.L  D0,-12(A5)
    BRA.S   .set_handle_flags

.setup_existing_handles:
    MOVEA.L Global_DosLibrary(A4),A6
    JSR     _LVOInput(A6)

    MOVE.L  D0,Global_HandleEntry0_Ptr(A4)    ; Original input file handle
    JSR     _LVOOutput(A6)

    MOVE.L  D0,Global_HandleEntry1_Ptr(A4)    ; Original output file handle
    LEA     .loc_1(PC),A0
    MOVE.L  A0,D1
    MOVE.L  #MODE_OLDFILE,D2
    JSR     _LVOOpen(A6)

    MOVE.L  D0,Global_HandleEntry2_Ptr(A4)
    MOVEQ   #16,D7

.set_handle_flags:
    MOVE.L  D7,D0
    ORI.W   #$8001,D0
    OR.L    D0,Global_HandleEntry0_Flags(A4)
    MOVE.L  D7,D0
    ORI.W   #$8002,D0
    OR.L    D0,Global_HandleEntry1_Flags(A4)
    ORI.L   #$8003,Global_HandleEntry2_Flags(A4) ; memory thing?
    TST.L   Global_DefaultHandleFlags(A4)
    BEQ.S   .default_flags_zero

    MOVEQ   #0,D0
    BRA.S   .apply_default_flags

.default_flags_zero:
    MOVE.L  #$8000,D0

.apply_default_flags:
    MOVE.L  D0,D7
    CLR.L   Global_PreallocHandleNode0_HandleIndex(A4)  ; node0 uses handle index 0
    MOVE.L  D7,D0
    ORI.W   #1,D0
    MOVE.L  D0,Global_PreallocHandleNode0_OpenFlags(A4) ; read-ish base mode
    MOVEQ   #1,D0
    MOVE.L  D0,Global_PreallocHandleNode1_HandleIndex(A4) ; node1 uses handle index 1
    MOVE.L  D7,D0
    ORI.W   #2,D0
    MOVE.L  D0,Global_PreallocHandleNode1_OpenFlags(A4) ; write-ish base mode
    MOVEQ   #2,D0
    MOVE.L  D0,Global_PreallocHandleNode2_HandleIndex(A4) ; node2 uses handle index 2
    MOVE.L  D7,D0
    ORI.W   #$80,D0
    MOVE.L  D0,Global_PreallocHandleNode2_OpenFlags(A4) ; special mode bit ($80) remains unresolved
    LEA     UNKNOWN36_ShowAbortRequester(PC),A0
    MOVE.L  A0,Global_SignalCallbackPtr(A4)
    MOVE.L  Global_ArgvPtr(A4),-(A7)
    MOVE.L  Global_ArgCount(A4),-(A7)
    JSR     UNKNOWN29_JMPTBL_ESQ_MainInitAndRun(PC)

    CLR.L   (A7)
    JSR     BUFFER_FlushAllAndCloseWithCode(PC)

    MOVEM.L -36(A5),D2/D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

.loc:
    NStr    "con.10/10/320/80/"

.loc_1:
    NStr    "*"

;!======

;------------------------------------------------------------------------------
; FUNC: UNKNOWN29_JMPTBL_ESQ_MainInitAndRun   (JumpStub_ESQ_MainInitAndRun)
;------------------------------------------------------------------------------
UNKNOWN29_JMPTBL_ESQ_MainInitAndRun:
    JMP     ESQ_MainInitAndRun

;!======

    ; Alignment
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    ORI.B   #0,D0
    MOVEQ   #97,D0
