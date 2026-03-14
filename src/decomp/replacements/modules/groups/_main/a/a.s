;------------------------------------------------------------------------------
; DECOMP TARGETS _main/a/a ESQ startup/shutdown helper module boundary
; SOURCE: modules/groups/_main/a/a.s
; PURPOSE:
;   Object-level hybrid replacement for the primary _main startup/shutdown
;   helper module now that the restored SAS/C lane covers ESQ_StartupEntry,
;   ESQ_ReturnWithStackCode, and ESQ_ShutdownAndReturn. This replacement now
;   carries the module body directly instead of delegating back to the
;   canonical asm include.
;------------------------------------------------------------------------------

    XDEF    ESQ_ReturnWithStackCode
    XDEF    ESQ_ShutdownAndReturn

;------------------------------------------------------------------------------
; FUNC: ESQ_StartupEntry   (StartupEntry)
; ARGS:
;   (none observed)
; RET:
;   D0: exit code
; CLOBBERS:
;   D0-D6/A0-A6
; CALLS:
;   _LVOSetSignal, _LVOOpenLibrary, _LVOWaitPort, _LVOGetMsg, _LVOCurrentDir,
;   _LVOSupervisor, _LVOCloseLibrary, _LVOReplyMsg,
;   GROUP_MAIN_A_JMPTBL_ESQ_MainEntryNoOpHook,
;   GROUP_MAIN_A_JMPTBL_ESQ_ParseCommandLineAndRun,
;   GROUP_MAIN_A_JMPTBL_MEMLIST_FreeAll,
;   GROUP_MAIN_A_JMPTBL_ESQ_MainExitNoOpHook
; READS:
;   AbsExecBase, ESQ_STR_DosLibrary
; WRITES:
;   Global_SavedStackPointer, Global_SavedExecBase, Global_SavedMsg,
;   Global_DosLibrary
; DESC:
;   Entry/segment startup: clears temp buffers, opens dos.library, handles
;   Workbench/CLI startup message, invokes init routines, and returns exit
;   code.
; NOTES:
;   Uses Workbench message fields when launched from Workbench.
;------------------------------------------------------------------------------
    MOVEM.L D1-D6/A0-A6,-(A7)

    MOVEA.L A0,A2
    MOVE.L  D0,D2
    LEA     Global_REF_LONG_FILE_SCRATCH,A4
    MOVEA.L AbsExecBase.W,A6
    LEA     BUFFER_5929_LONGWORDS,A3
    MOVEQ   #0,D1
    MOVE.L  #5929,D0
    BRA.S   .clear_5929_buffer_check

.clear_5929_buffer_loop:
    MOVE.L  D1,(A3)+

.clear_5929_buffer_check:
    DBF     D0,.clear_5929_buffer_loop

    MOVE.L  A7,Global_SavedStackPointer(A4)
    MOVE.L  A6,Global_SavedExecBase(A4)
    CLR.L   Global_SavedMsg(A4)
    MOVEQ   #0,D0
    MOVE.L  #$3000,D1
    JSR     _LVOSetSignal(A6)

    LEA     ESQ_STR_DosLibrary(PC),A1
    MOVEQ   #0,D0
    JSR     _LVOOpenLibrary(A6)

    MOVE.L  D0,Global_DosLibrary(A4)
    BNE.S   .dos_opened_prepare_startup

    MOVEQ   #100,D0
    BRA.W   ESQ_ShutdownAndReturn

.dos_opened_prepare_startup:
    MOVEA.L Struct_ExecBase__ThisTask(A6),A3
    MOVE.L  ((Struct_ExecBase__TaskWait-Struct_ExecBase__ThisTask)+Struct_List__lh_TailPred)(A3),Global_SavedDirLock(A4)
    TST.L   (Struct_ExecBase__SoftInts-Struct_ExecBase__ThisTask)+(Struct_SoftIntList__sh_Pad)(A3)
    BEQ.S   .wait_for_wb_message

    MOVE.L  A7,D0
    SUB.L   4(A7),D0
    ADDI.L  #128,D0
    MOVE.L  D0,Global_CommandLineSize(A4)
    MOVEA.L ((Struct_ExecBase__SoftInts-Struct_ExecBase__ThisTask)+Struct_SoftIntList__sh_Pad)(A3),A0
    ADDA.L  A0,A0
    ADDA.L  A0,A0
    MOVEA.L 16(A0),A1
    ADDA.L  A1,A1
    ADDA.L  A1,A1
    MOVE.L  D2,D0
    MOVEQ   #0,D1
    MOVE.B  (A1)+,D1
    MOVE.L  A1,Global_ScratchPtr_592(A4)
    ADD.L   D1,D0
    ADDQ.L  #1,D0
    CLR.W   -(A7)
    ADDQ.L  #1,D0
    ANDI.W  #$fffe,D0
    SUBA.L  D0,A7
    SUBQ.L  #2,D0
    CLR.W   0(A7,D0.L)
    MOVE.L  D2,D0
    SUBQ.L  #1,D0
    ADD.L   D1,D2

.copy_cmdline_loop:
    MOVE.B  0(A2,D0.W),0(A7,D2.W)
    SUBQ.L  #1,D2
    DBF     D0,.copy_cmdline_loop

    MOVE.B  #$20,0(A7,D2.W)
    SUBQ.L  #1,D2

.copy_softint_tail_loop:
    MOVE.B  0(A1,D2.W),0(A7,D2.W)
    DBF     D2,.copy_softint_tail_loop

    MOVEA.L A7,A1
    MOVE.L  A1,-(A7)
    BRA.S   .run_main_init

.wait_for_wb_message:
    MOVE.L  58(A3),Global_CommandLineSize(A4)
    MOVEQ   #127,D0
    ADDQ.L  #1,D0
    ADD.L   D0,Global_CommandLineSize(A4)

    LEA     92(A3),A0
    JSR     _LVOWaitPort(A6)

    LEA     92(A3),A0
    JSR     _LVOGetMsg(A6)

    MOVE.L  D0,Global_SavedMsg(A4)
    MOVE.L  D0,-(A7)
    MOVEA.L D0,A2
    MOVE.L  36(A2),D0
    BEQ.S   .maybe_set_current_dir

    MOVEA.L Global_DosLibrary(A4),A6
    MOVEA.L D0,A0
    MOVE.L  0(A0),D1
    MOVE.L  D1,Global_SavedDirLock(A4)
    JSR     _LVOCurrentDir(A6)

.maybe_set_current_dir:
    MOVE.L  32(A2),D1
    BEQ.S   .maybe_update_window_ptr

    MOVE.L  #1005,D2
    JSR     _LVOSupervisor(A6)

    MOVE.L  D0,Global_WBStartupWindowPtr(A4)
    BEQ.S   .maybe_update_window_ptr

    LSL.L   #2,D0
    MOVEA.L D0,A0
    MOVE.L  8(A0),164(A3)

.maybe_update_window_ptr:
    MOVEA.L Global_SavedMsg(A4),A0
    MOVE.L  A0,-(A7)
    PEA     Global_WBStartupCmdBuffer(A4)
    MOVEA.L 36(A0),A0
    MOVE.L  4(A0),Global_ScratchPtr_592(A4)

.run_main_init:
    JSR     GROUP_MAIN_A_JMPTBL_ESQ_MainEntryNoOpHook(PC)

    JSR     GROUP_MAIN_A_JMPTBL_ESQ_ParseCommandLineAndRun(PC)

    MOVEQ   #0,D0
    BRA.S   ESQ_ShutdownAndReturn

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_ReturnWithStackCode   (ReturnWithStackCode)
; ARGS:
;   stack +4: exitCode (long)
; RET:
;   D0: exit code
; CLOBBERS:
;   D0
; CALLS:
;   ESQ_ShutdownAndReturn
; READS:
;   (none)
; WRITES:
;   D0
; DESC:
;   Loads exit code from the stack and jumps to shutdown/return path.
;------------------------------------------------------------------------------
ESQ_ReturnWithStackCode:
    MOVE.L  4(A7),D0

;------------------------------------------------------------------------------
; FUNC: ESQ_ShutdownAndReturn   (ShutdownAndReturn)
; ARGS:
;   D0: exit code
; RET:
;   D0: exit code
; CLOBBERS:
;   D0/A0-A6
; CALLS:
;   GROUP_MAIN_A_JMPTBL_MEMLIST_FreeAll, _LVOCloseLibrary,
;   GROUP_MAIN_A_JMPTBL_ESQ_MainExitNoOpHook, _LVOReplyMsg
; READS:
;   Global_SavedMsg, Global_SavedStackPointer, Global_SavedExecBase,
;   Global_DosLibrary
; WRITES:
;   (none)
; DESC:
;   Runs shutdown hooks, closes dos.library, replies to Workbench msg, and
;   restores registers/stack before returning.
;------------------------------------------------------------------------------
ESQ_ShutdownAndReturn:
    MOVE.L  D0,-(A7)
    MOVE.L  Global_ExitHookPtr(A4),D0
    BEQ.S   .call_exit_hook

    MOVEA.L D0,A0
    JSR     (A0)

.call_exit_hook:
    JSR     GROUP_MAIN_A_JMPTBL_MEMLIST_FreeAll(PC)

    MOVEA.L AbsExecBase,A6
    MOVEA.L Global_DosLibrary(A4),A1
    JSR     _LVOCloseLibrary(A6)

    JSR     GROUP_MAIN_A_JMPTBL_ESQ_MainExitNoOpHook(PC)

    TST.L   Global_SavedMsg(A4)
    BEQ.S   .restore_registers_and_return

    MOVE.L  Global_WBStartupWindowPtr(A4),D1
    BEQ.S   .maybe_restore_supervisor

    JSR     _LVOexecPrivate1(A6)

.maybe_restore_supervisor:
    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    MOVEA.L Global_SavedMsg(A4),A1
    JSR     _LVOReplyMsg(A6)

.restore_registers_and_return:
    MOVE.L  (A7)+,D0
    MOVEA.L Global_SavedStackPointer(A4),A7
    MOVEM.L (A7)+,D1-D6/A0-A6
    RTS

;!======

ESQ_STR_DosLibrary:
    NStr    "dos.library"
