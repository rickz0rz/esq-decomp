;------------------------------------------------------------------------------
; FUNC: ESQ_StartupEntry   (StartupEntryuncertain)
; ARGS:
;   (none observed)
; RET:
;   D0: exit code
; CLOBBERS:
;   D0-D6/A0-A6
; CALLS:
;   _LVOSetSignal, _LVOOpenLibrary, _LVOWaitPort, _LVOGetMsg, _LVOCurrentDir,
;   _LVOSupervisor, _LVOFindTask, _LVOCloseLibrary, _LVOReplyMsg,
;   GROUP_MAIN_A_JMPTBL_UNKNOWN2B_Stub0, GROUP_MAIN_A_JMPTBL_ESQ_ParseCommandLineAndRun, GROUP_MAIN_A_JMPTBL_MEMLIST_FreeAll, GROUP_MAIN_A_JMPTBL_UNKNOWN2B_Stub1
; READS:
;   AbsExecBase, ESQ_STR_DosLibrary
; WRITES:
;   savedStackPointer, savedExecBase, savedMsg, Global_DosLibrary
; DESC:
;   Entry/segment startup: clears temp buffers, opens dos.library, handles
;   Workbench/CLI startup message, invokes init routines, and returns exit code.
; NOTES:
;   - Uses Workbench message fields when launched from Workbench.
;------------------------------------------------------------------------------
    MOVEM.L D1-D6/A0-A6,-(A7)               ; Backup registers to the stack

    MOVEA.L A0,A2                           ; A0 is a pointer to the command string at startup, copy to A2
    MOVE.L  D0,D2                           ; D0 is the length of the command string at startup, copy to D2
    LEA     GLOB_REF_LONG_FILE_SCRATCH,A4   ; Copy address of GLOB_REF_LONG_FILE_SCRATCH into A4 (0x3BB24) - 00017118
    MOVEA.L AbsExecBase.W,A6                ; 00000004 but this address is dynamically translated at runtime to 002007a0 (confirmed by checking exec.library when dumping libs in fs-uae)
    LEA     BUFFER_5929_LONGWORDS,A3        ; 00016e80
    MOVEQ   #0,D1
    MOVE.L  #5929,D0
    BRA.S   .clear_5929_buffer_check

.clear_5929_buffer_loop:
    MOVE.L  D1,(A3)+                        ; Copy longword 0 into A3 (BUFFER_5929_LONGWORDS) addr and increment to zero that memory.

.clear_5929_buffer_check:
    DBF     D0,.clear_5929_buffer_loop  ; If our counter (D1) is not zero then jump to .clear_5929_buffer_loop else continue

    MOVE.L  A7,savedStackPointer(A4)        ; Save the current stack pointer from A7
    MOVE.L  A6,savedExecBase(A4)            ; Save a pointer to AbsExecBase from A6
    CLR.L   savedMsg(A4)                    ; Clear the long at -604(A4) (0x3B8C8, a value within LAB_21AA) - CLR.L (A4, -$025c) == $00016ebc
    MOVEQ   #0,D0                           ; Old signal, 0x00000000 into D0
    MOVE.L  #$3000,D1                       ; New signal mask: 0x00003000 into D1
    JSR     _LVOSetSignal(A6)

    LEA     ESQ_STR_DosLibrary(PC),A1    ; LEA.L (PC,$0158) == $0021eff2,A1
    MOVEQ   #0,D0
    JSR     _LVOOpenLibrary(A6)             ; Open dos.library version 0 (any) locally...

    MOVE.L  D0,Global_DosLibrary(A4) ; and store it in a known location in memory (0x3BB24 + 22832 or 0x41454) or GLOB_REF_DOS_LIBRARY_2
    BNE.S   .dos_opened_prepare_startup    ; Jump to .dos_opened_prepare_startup if D0 is not 0 (D0 is the addr returned, 0 = didn't load)

    MOVEQ   #100,D0                         ; If it wasn't opened, set D0 to 100...
    BRA.W   ESQ_ShutdownAndReturn           ; and jump to ESQ_ShutdownAndReturn

; Decide startup path (CLI vs WB) after dos.library opens.
.dos_opened_prepare_startup:
    MOVEA.L Struct_ExecBase__ThisTask(A6),A3                                                                ; A6+276 = ThisTask pointer uncertain
    MOVE.L  ((Struct_ExecBase__TaskWait-Struct_ExecBase__ThisTask)+Struct_List__lh_TailPred)(A3),Global_SavedDirLock(A4)   ; A3+152 = TaskWait.lh_TailPred uncertain -> saved dir/lock uncertain
    TST.L   (Struct_ExecBase__SoftInts-Struct_ExecBase__ThisTask)+(Struct_SoftIntList__sh_Pad)(A3)          ; A3+172 = SoftIntList.sh_Pad uncertain (SoftInts[1]) uncertain
    BEQ.S   .wait_for_wb_message

    MOVE.L  A7,D0
    SUB.L   4(A7),D0
    ADDI.L  #128,D0
    MOVE.L  D0,Global_CommandLineSize(A4)                   ; cmdline buffer size uncertain
    MOVEA.L ((Struct_ExecBase__SoftInts-Struct_ExecBase__ThisTask)+Struct_SoftIntList__sh_Pad)(A3),A0       ; Again, like above. SoftInts[1]
    ADDA.L  A0,A0
    ADDA.L  A0,A0
    MOVEA.L 16(A0),A1
    ADDA.L  A1,A1
    ADDA.L  A1,A1
    MOVE.L  D2,D0
    MOVEQ   #0,D1
    MOVE.B  (A1)+,D1
    MOVE.L  A1,Global_ScratchPtr_592(A4)                    ; softint tail ptr uncertain
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
    MOVE.L  58(A3),Global_CommandLineSize(A4)               ; A3+58 = Task/Proc stack size uncertain -> wb stack size uncertain
    MOVEQ   #127,D0 ; ...
    ADDQ.L  #1,D0   ; 128 into D0
    ADD.L   D0,Global_CommandLineSize(A4)

    LEA     92(A3),A0                                       ; A3+92 = Task/Proc message port uncertain
    JSR     _LVOWaitPort(A6) ; A6 should still have AbsExecBase in it at this point

    LEA     92(A3),A0                                       ; A3+92 = Task/Proc message port uncertain
    JSR     _LVOGetMsg(A6)

    MOVE.L  D0,savedMsg(A4)                                 ; A4-604 = saved WBStartup msg uncertain
    MOVE.L  D0,-(A7)
    MOVEA.L D0,A2
    MOVE.L  36(A2),D0                                       ; WBStartup+36 = sm_ArgList uncertain
    BEQ.S   .maybe_set_current_dir

    MOVEA.L Global_DosLibrary(A4),A6
    MOVEA.L D0,A0
    MOVE.L  0(A0),D1                                        ; WBArg[0].wa_Lock uncertain
    MOVE.L  D1,Global_SavedDirLock(A4)                      ; current dir lock uncertain (from WB startup msg)
    JSR     _LVOCurrentDir(A6)

.maybe_set_current_dir:
    MOVE.L  32(A2),D1                                       ; WBStartup+32 = sm_NumArgs uncertain
    BEQ.S   .maybe_update_window_ptr

    MOVE.L  #1005,D2
    JSR     _LVOSupervisor(A6)

    MOVE.L  D0,Global_WBStartupWindowPtr(A4)
    BEQ.S   .maybe_update_window_ptr

    LSL.L   #2,D0
    MOVEA.L D0,A0
    MOVE.L  8(A0),164(A3)

.maybe_update_window_ptr:
    MOVEA.L savedMsg(A4),A0                                 ; saved WBStartup msg uncertain
    MOVE.L  A0,-(A7)
    PEA     Global_WBStartupCmdBuffer(A4)
    MOVEA.L 36(A0),A0                                       ; WBStartup+36 = sm_ArgList uncertain
    MOVE.L  4(A0),Global_ScratchPtr_592(A4)                 ; WBArg[0].wa_Name uncertain

.run_main_init:
    JSR     GROUP_MAIN_A_JMPTBL_UNKNOWN2B_Stub0(PC)

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
;   GROUP_MAIN_A_JMPTBL_MEMLIST_FreeAll, _LVOCloseLibrary, GROUP_MAIN_A_JMPTBL_UNKNOWN2B_Stub1, _LVOReplyMsg
; READS:
;   savedMsg, savedStackPointer, savedExecBase, Global_DosLibrary
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

    JSR     GROUP_MAIN_A_JMPTBL_UNKNOWN2B_Stub1(PC)

    TST.L   savedMsg(A4)
    BEQ.S   .restore_registers_and_return

    MOVE.L  Global_WBStartupWindowPtr(A4),D1
    BEQ.S   .maybe_restore_supervisor

    JSR     _LVOexecPrivate1(A6) ; this might be inaccurate?

.maybe_restore_supervisor:
    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    MOVEA.L savedMsg(A4),A1
    JSR     _LVOReplyMsg(A6)

.restore_registers_and_return:
    MOVE.L  (A7)+,D0
    MOVEA.L savedStackPointer(A4),A7
    MOVEM.L (A7)+,D1-D6/A0-A6
    RTS

;!======

ESQ_STR_DosLibrary:
    NStr    "dos.library"
