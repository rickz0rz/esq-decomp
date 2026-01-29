; ==========================================
; ESQ-3.asm disassembly + annotation
; ==========================================

    include "lvo-offsets.s"
    include "hardware-addresses.s"
    include "structs.s"
    include "macros.s"
    include "string-macros.s"
    include "text-formatting.s"
    include "interrupts/constants.s"

includeCustomAriAssembly = 0

; Some values of importance
LocalDosLibraryDisplacement = 22832
DesiredMemoryAvailability   = $00800000 ; 8388608 bytes/8 MiBytes

    SECTION S_0,CODE

savedStackPointer   = -600
savedMsg            = -604
savedExecBase       = -608

;------------------------------------------------------------------------------
; FUNC: ESQ_StartupEntry   (StartupEntry??)
; ARGS:
;   D0: cmdLen?? (startup command length)
;   A0: cmdPtr?? (startup command string)
; RET:
;   D0: exit code
; CLOBBERS:
;   D0-D6/A0-A6
; CALLS:
;   _LVOSetSignal, _LVOOpenLibrary, _LVOWaitPort, _LVOGetMsg, _LVOCurrentDir,
;   _LVOSupervisor, _LVOFindTask, _LVOCloseLibrary, _LVOReplyMsg,
;   ESQ_JMP_TBL_LAB_190F, ESQ_JMP_TBL_LAB_1A76, ESQ_JMP_TBL_LAB_1A26, ESQ_JMP_TBL_LAB_1910
; READS:
;   AbsExecBase, LOCAL_STR_DOS_LIBRARY
; WRITES:
;   savedStackPointer, savedExecBase, savedMsg, LocalDosLibraryDisplacement
; DESC:
;   Entry/segment startup: clears temp buffers, opens dos.library, handles
;   Workbench/CLI startup message, invokes init routines, and returns exit code.
; NOTES:
;   - Uses Workbench message fields when launched from Workbench.
;------------------------------------------------------------------------------
ESQ_StartupEntry:
SECSTRT_0:                                  ; PC: 0021EE58
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

    LEA     LOCAL_STR_DOS_LIBRARY(PC),A1    ; LEA.L (PC,$0158) == $0021eff2,A1
    MOVEQ   #0,D0
    JSR     _LVOOpenLibrary(A6)             ; Open dos.library version 0 (any) locally...

    MOVE.L  D0,LocalDosLibraryDisplacement(A4) ; and store it in a known location in memory (0x3BB24 + 22832 or 0x41454) or GLOB_REF_DOS_LIBRARY_2
    BNE.S   .dos_opened_prepare_startup    ; Jump to .dos_opened_prepare_startup if D0 is not 0 (D0 is the addr returned, 0 = didn't load)

    MOVEQ   #100,D0                         ; If it wasn't opened, set D0 to 100...
    BRA.W   ESQ_ShutdownAndReturn           ; and jump to LAB_000A

; Decide startup path (CLI vs WB) after dos.library opens.
.dos_opened_prepare_startup:
    MOVEA.L Struct_ExecBase__ThisTask(A6),A3                                                                ; A6+276 = ThisTask pointer ??
    MOVE.L  ((Struct_ExecBase__TaskWait-Struct_ExecBase__ThisTask)+Struct_List__lh_TailPred)(A3),-612(A4)   ; A3+152 = TaskWait.lh_TailPred ?? -> A4-612 = saved dir/lock ??
    TST.L   (Struct_ExecBase__SoftInts-Struct_ExecBase__ThisTask)+(Struct_SoftIntList__sh_Pad)(A3)          ; A3+172 = SoftIntList.sh_Pad ?? (SoftInts[1]) ??
    BEQ.S   .wait_for_wb_message

    MOVE.L  A7,D0
    SUB.L   4(A7),D0
    ADDI.L  #128,D0
    MOVE.L  D0,-660(A4)                                     ; A4-660 = cmdline buffer size ??
    MOVEA.L ((Struct_ExecBase__SoftInts-Struct_ExecBase__ThisTask)+Struct_SoftIntList__sh_Pad)(A3),A0       ; Again, like above. SoftInts[1]
    ADDA.L  A0,A0
    ADDA.L  A0,A0
    MOVEA.L 16(A0),A1
    ADDA.L  A1,A1
    ADDA.L  A1,A1
    MOVE.L  D2,D0
    MOVEQ   #0,D1
    MOVE.B  (A1)+,D1
    MOVE.L  A1,-592(A4)                                     ; A4-592 = softint tail ptr ??
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
    MOVE.L  58(A3),-660(A4)                                 ; A3+58 = Task/Proc stack size ?? -> A4-660 = wb stack size ??
    MOVEQ   #127,D0 ; ...
    ADDQ.L  #1,D0   ; 128 into D0
    ADD.L   D0,-660(A4)

    LEA     92(A3),A0                                       ; A3+92 = Task/Proc message port ??
    JSR     _LVOWaitPort(A6) ; A6 should still have AbsExecBase in it at this point

    LEA     92(A3),A0                                       ; A3+92 = Task/Proc message port ??
    JSR     _LVOGetMsg(A6)

    MOVE.L  D0,savedMsg(A4)                                 ; A4-604 = saved WBStartup msg ??
    MOVE.L  D0,-(A7)
    MOVEA.L D0,A2
    MOVE.L  36(A2),D0                                       ; WBStartup+36 = sm_ArgList ??
    BEQ.S   .maybe_set_current_dir

    MOVEA.L LocalDosLibraryDisplacement(A4),A6
    MOVEA.L D0,A0
    MOVE.L  0(A0),D1                                        ; WBArg[0].wa_Lock ??
    MOVE.L  D1,-612(A4)                                     ; A4-612 = current dir lock ?? (from WB startup msg)
    JSR     _LVOCurrentDir(A6)

.maybe_set_current_dir:
    MOVE.L  32(A2),D1                                       ; WBStartup+32 = sm_NumArgs ??
    BEQ.S   .maybe_update_window_ptr

    MOVE.L  #1005,D2
    JSR     _LVOSupervisor(A6)

    MOVE.L  D0,-596(A4)
    BEQ.S   .maybe_update_window_ptr

    LSL.L   #2,D0
    MOVEA.L D0,A0
    MOVE.L  8(A0),164(A3)

.maybe_update_window_ptr:
    MOVEA.L -604(A4),A0                                     ; A4-604 = saved WBStartup msg ??
    MOVE.L  A0,-(A7)
    PEA     -664(A4)
    MOVEA.L 36(A0),A0                                       ; WBStartup+36 = sm_ArgList ??
    MOVE.L  4(A0),-592(A4)                                  ; WBArg[0].wa_Name ??

.run_main_init:
    JSR     ESQ_JMP_TBL_LAB_190F(PC)

    JSR     ESQ_JMP_TBL_LAB_1A76(PC)

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
LAB_0009:
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
;   ESQ_JMP_TBL_LAB_1A26, _LVOCloseLibrary, ESQ_JMP_TBL_LAB_1910, _LVOReplyMsg
; READS:
;   savedMsg, savedStackPointer, savedExecBase, LocalDosLibraryDisplacement
; WRITES:
;   (none)
; DESC:
;   Runs shutdown hooks, closes dos.library, replies to Workbench msg, and
;   restores registers/stack before returning.
;------------------------------------------------------------------------------
ESQ_ShutdownAndReturn:
LAB_000A:
    MOVE.L  D0,-(A7)
    MOVE.L  -620(A4),D0
    BEQ.S   .call_exit_hook

    MOVEA.L D0,A0
    JSR     (A0)

.call_exit_hook:
    JSR     ESQ_JMP_TBL_LAB_1A26(PC)

    MOVEA.L AbsExecBase,A6
    MOVEA.L LocalDosLibraryDisplacement(A4),A1
    JSR     _LVOCloseLibrary(A6)

    JSR     ESQ_JMP_TBL_LAB_1910(PC)

    TST.L   savedMsg(A4)
    BEQ.S   .restore_registers_and_return

    MOVE.L  -596(A4),D1
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

LOCAL_STR_DOS_LIBRARY:
    NStr    "dos.library"

;------------------------------------------------------------------------------
; FUNC: ESQ_JMP_TBL_LAB_1910   (JumpStub_LAB_1910)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_1910
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_1910.
;------------------------------------------------------------------------------
ESQ_JMP_TBL_LAB_1910:
LAB_000F:
    JMP     LAB_1910

;------------------------------------------------------------------------------
; FUNC: ESQ_JMP_TBL_LAB_190F   (JumpStub_LAB_190F)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_190F
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_190F.
;------------------------------------------------------------------------------
ESQ_JMP_TBL_LAB_190F:
LAB_0010:
    JMP     LAB_190F

;------------------------------------------------------------------------------
; FUNC: ESQ_JMP_TBL_LAB_1A26   (JumpStub_LAB_1A26)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_1A26
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_1A26.
;------------------------------------------------------------------------------
ESQ_JMP_TBL_LAB_1A26:
LAB_0011:
    JMP     LAB_1A26

;------------------------------------------------------------------------------
; FUNC: ESQ_JMP_TBL_LAB_1A76   (JumpStub_LAB_1A76)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_1A76
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_1A76.
;------------------------------------------------------------------------------
ESQ_JMP_TBL_LAB_1A76:
LAB_0012:
    JMP     LAB_1A76

;!======

;------------------------------------------------------------------------------
; FUNC: CHECK_AVAILABLE_FAST_MEMORY   (CheckAvailableFastMemory)
; ARGS:
;   (none)
; RET:
;   D0: available fast memory bytes
; CLOBBERS:
;   D0-D1/A6
; CALLS:
;   _LVOAvailMem
; READS:
;   AbsExecBase
; WRITES:
;   HAS_REQUESTED_FAST_MEMORY
; DESC:
;   Checks available fast memory and sets HAS_REQUESTED_FAST_MEMORY if below
;   the desired threshold.
; NOTES:
;   - Threshold is .desiredMemory (600,000 bytes).
;------------------------------------------------------------------------------
; If the system has at least 600,000 bytes of fast memory, keep HAS_REQUESTED_FAST_MEMORY set to 0.
; Otherwise, set it to 1.
CHECK_AVAILABLE_FAST_MEMORY:

.desiredMemory  = 600000

    MOVEQ   #2,D1                           ; Set 2 to D1...
    MOVEA.L AbsExecBase,A6                  ; Check the available memory for type 2 (fast memory) in D1, and
    JSR     _LVOAvailMem(A6)                ; store the result in D0.

    CMPI.L  #(.desiredMemory),D0            ; See if we have more than 600,000 bytes of available memory
    BGE.S   .done                           ; If we have equal to or more than our target, jump to .skipFastMemorySet

    MOVE.W  #1,HAS_REQUESTED_FAST_MEMORY    ; Set HAS_REQUESTED_FAST_MEMORY to 0x0001 (it's 0x0000 by default)

.done:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CHECK_IF_COMPATIBLE_VIDEO_CHIP   (CheckCompatibleVideoChip)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D6-D7
; CALLS:
;   (none)
; READS:
;   VPOSR
; WRITES:
;   IS_COMPATIBLE_VIDEO_CHIP
; DESC:
;   Checks VPOSR chip ID against a whitelist; sets IS_COMPATIBLE_VIDEO_CHIP if
;   the current chip does not match the known IDs.
; NOTES:
;   - Whitelist: $30, $20, $33 (see chip table below).
;------------------------------------------------------------------------------
; Chip table here:
; (1) 30 = 8372 (Fat-hr) (agnushr),thru rev4, NTSC
; (2) 20 = 8372 (Fat-hr) (agnushr),thru rev4, PAL
; (3) 33 = 8374 (Alice) rev 3 thru rev 4, NTSC
CHECK_IF_COMPATIBLE_VIDEO_CHIP:
    MOVEM.L D6-D7,-(A7)

    MOVE.W  VPOSR,D7                    ; $DFF004 = http://amiga-dev.wikidot.com/hardware:vposr
    MOVE.L  D7,D6                       ; Copy VPOSR value into D6
    ANDI.W  #$7f00,D6                   ; Logical AND D6 with $7F00 (01111111 00000000) and store back into D6
    CMPI.W  #$3000,D6                   ; Compare it with high byte of $3000 (00110000 00000000) aka $30 to see if we're chip 1
    BEQ.S   .done                       ; If equal, jump to .return

    CMPI.W  #$2000,D6                   ; Compare it with high byte of $2000 (00110000 00000000) aka $20 to see if we're chip 2
    BEQ.S   .done                       ; If equal, jump to .return

    CMPI.W  #$3300,D6                   ; Compare it with high byte of $3300 (00110011 00000000) aka $33 to see if we're chip 3
    BEQ.S   .done                       ; If equal, jump to .return

    MOVE.W  #1,IS_COMPATIBLE_VIDEO_CHIP ; Set $0001 (true) into IS_COMPATIBLE_VIDEO_CHIP

.done:
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_CheckTopazFontGuard   (CheckTopazFontGuard??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A6
; CALLS:
;   JMP_TBL_DO_DELAY, _LVOSetAPen, _LVORectFill, _LVOMove, _LVOText,
;   _LVOSizeWindow, _LVORemakeDisplay, _LVOFreeMem,
;   JMP_TBL_LAB_1A06_1, JMP_TBL_LAB_1911, JMP_TBL_LIBRARIES_LOAD_FAILED_1
; READS:
;   GLOB_REF_INTUITION_LIBRARY, GLOB_REF_GRAPHICS_LIBRARY, GLOB_STR_TOPAZ_FONT,
;   LAB_1DE9_B, LAB_1DD8_RASTPORT,
;   GLB_STR_PLEASE_STANDBY_1, GLOB_STR_ATTENTION_SYSTEM_ENGINEER_1,
;   GLOB_STR_REPORT_CODE_ER003
; WRITES:
;   (none)
; DESC:
;   Checks topaz font/intuition state and may display a warning/lockup screen.
; NOTES:
;   - Soft-locks in a loop for the engineer warning path.
;------------------------------------------------------------------------------
ESQ_CheckTopazFontGuard:
LAB_0017:
    LINK.W  A5,#-32
    MOVEM.L D2-D7,-(A7)

.strTopazFont1  = -4
.lab1DE9        = -8
.strTopazFont2  = -12

; Testing out address math here. None of this _feels_ right but it's
; still compiling to the same hash. It looks like this is just doing
; some trampolining to get to the desired end address.

;LAB_0018:  ; unreferenced
    MOVEA.L GLOB_REF_INTUITION_LIBRARY,A0
    MOVE.L  (GLOB_STR_TOPAZ_FONT-GLOB_REF_INTUITION_LIBRARY)+4(A0),.strTopazFont1(A5)
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #(LAB_1DE9_B-GLOB_STR_TOPAZ_FONT),A0
    MOVE.L  A0,.lab1DE9(A5)
    MOVEQ   #2,D0
    CMP.B   5(A0),D0
    BNE.W   .show_rerun_error

    MOVEA.L GLOB_REF_INTUITION_LIBRARY,A0
    MOVE.L  (GLOB_STR_TOPAZ_FONT-GLOB_REF_INTUITION_LIBRARY)(A0),.strTopazFont2(A5)
    MOVE.W  20(A0),D0                   ; 20 = Library__lib_Version
    MOVEQ   #33,D1
    CMP.W   D1,D0                       ; Sub 33 from the obtained version
    BHI.W   .bypassSystemEngineerLockup ; Compare the library to the requested version, if it's greater or higher jump

    ; Delay 250 ticks or 5 seconds
    PEA     250.W
    JSR     JMP_TBL_DO_DELAY(PC)

    ADDQ.W  #4,A7

    ; Trampoline to LAB_1DD8_RASTPORT in A0
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #(LAB_1DD8_RASTPORT-GLOB_STR_TOPAZ_FONT),A0

    ; Set the primary pen to 2
    MOVEA.L A0,A1
    MOVEQ   #2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    ; Trampoline to LAB_1DD8_RASTPORT in A0
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #(LAB_1DD8_RASTPORT-GLOB_STR_TOPAZ_FONT),A0

    ; Draw a filled rect from 0,0 to 639,56
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVE.L  #639,D2
    MOVEQ   #56,D3
    NOT.B   D3
    JSR     _LVORectFill(A6)

    ; Trampoline to LAB_1DD8_RASTPORT in A0
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #(LAB_1DD8_RASTPORT-GLOB_STR_TOPAZ_FONT),A0

    ; Set the primary pen to 1
    MOVEA.L A0,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    ; Trampoline to LAB_1DD8_RASTPORT in A0
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #(LAB_1DD8_RASTPORT-GLOB_STR_TOPAZ_FONT),A0

    ; Move the pen to 20,100
    MOVEA.L A0,A1
    MOVEQ   #20,D0
    MOVEQ   #100,D1
    JSR     _LVOMove(A6)

    ; Trampoline to LAB_1DD8_RASTPORT in A0
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #(LAB_1DD8_RASTPORT-GLOB_STR_TOPAZ_FONT),A0

    ; Draw "Please Standby..." text
    ; Draw_TEXT A0,GLB_STR_PLEASE_STANDBY_1,#17
    MOVEA.L A0,A1
    LEA     GLB_STR_PLEASE_STANDBY_1,A0
    MOVEQ   #17,D0
    JSR     _LVOText(A6)

    ; Trampoline to LAB_1DD8_RASTPORT in A0
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #(LAB_1DD8_RASTPORT-GLOB_STR_TOPAZ_FONT),A0

    ; Move the pen to 20,113
    MOVEA.L A0,A1
    MOVEQ   #20,D0
    MOVEQ   #113,D1
    JSR     _LVOMove(A6)

    ; Trampoline to LAB_1DD8_RASTPORT in A0
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #(LAB_1DD8_RASTPORT-GLOB_STR_TOPAZ_FONT),A0

    ; Draw "ATTENTION! SYSTEM ENGINEER" text
    MOVEA.L A0,A1
    LEA     GLOB_STR_ATTENTION_SYSTEM_ENGINEER_1,A0
    MOVEQ   #26,D0
    JSR     _LVOText(A6)

    ; Trampoline to LAB_1DD8_RASTPORT in A0
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #(LAB_1DD8_RASTPORT-GLOB_STR_TOPAZ_FONT),A0

    ; Move the pen to 20,126
    MOVEA.L A0,A1
    MOVEQ   #20,D0
    MOVEQ   #126,D1
    JSR     _LVOMove(A6)

    ; Trampoline to LAB_1DD8_RASTPORT in A0
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #(LAB_1DD8_RASTPORT-GLOB_STR_TOPAZ_FONT),A0

    ; Draw "Report Code ER003 to TV Guide Technical Services." text
    MOVEA.L A0,A1
    LEA     GLOB_STR_REPORT_CODE_ER003,A0
    MOVEQ   #47,D0
    JSR     _LVOText(A6)

; Loop here to soft-lock the system.
.engineer_lock_loop:
    BRA.S   .engineer_lock_loop

.bypassSystemEngineerLockup:
    MOVEA.L .strTopazFont1(A5),A0
    MOVE.W  14(A0),D7
    EXT.L   D7
    MOVEA.L -12(A5),A0  ; window
    MOVE.W  10(A0),D0
    EXT.L   D0
    MOVEQ   #50,D1
    SUB.L   D0,D1       ; deltaY
    MOVEQ   #0,D0       ; deltaX
    MOVEA.L GLOB_REF_INTUITION_LIBRARY,A6
    JSR     _LVOSizeWindow(A6)

    PEA     100.W
    JSR     JMP_TBL_DO_DELAY(PC)

    ADDQ.W  #4,A7
    MOVEQ   #50,D0
    MOVEA.L .strTopazFont1(A5),A0
    MOVE.W  D0,14(A0)
    MOVEA.L -8(A5),A0
    MOVE.W  D0,2(A0)
    MOVE.B  #$1,5(A0)
    MOVE.L  8(A0),D6
    MOVE.L  12(A0),D5
    CLR.L   12(A0)
    MOVE.L  D6,D4
    ADDI.L  #4000,D4
    MOVE.L  D7,D0
    MOVE.L  #640,D1
    JSR     JMP_TBL_LAB_1A06_1(PC)

    LSR.L   #3,D0
    MOVE.L  D5,D1
    ADD.L   D0,D1
    MOVE.L  D1,-32(A5)

    MOVEA.L GLOB_REF_INTUITION_LIBRARY,A6
    JSR     _LVORemakeDisplay(A6)

    MOVEA.L D4,A0
    MOVE.L  -32(A5),D0
    SUB.L   D4,D0
    MOVEA.L A0,A1

    MOVEA.L AbsExecBase,A6
    JSR     _LVOFreeMem(A6)

    BRA.S   .done

.show_rerun_error:
    PEA     GLOB_STR_YOU_CANNOT_RE_RUN_THE_SOFTWARE
    JSR     JMP_TBL_LAB_1911(PC)

    CLR.L   (A7)
    JSR     JMP_TBL_LIBRARIES_LOAD_FAILED_1(PC)

    ADDQ.W  #4,A7

.done:
    MOVEM.L (A7)+,D2-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_FormatDiskErrorMessage   (FormatDiskErrorMessage)
; ARGS:
;   (none)
; RET:
;   D0: 0
; CLOBBERS:
;   D0-D7
; CALLS:
;   LAB_03C4, LAB_03C0, JMP_TBL_PRINTF_1
; READS:
;   LAB_1AF4, LAB_1AF6, GLOB_STR_DISK_ERRORS_FORMATTED,
;   GLOB_STR_DISK_IS_FULL_FORMATTED, LAB_2249
; WRITES:
;   LAB_2249 (formatted text buffer)
; DESC:
;   Builds a disk error message into LAB_2249 based on disk error counts.
; NOTES:
;   - Uses LAB_03C4 and LAB_03C0 helpers for error count retrieval.
;------------------------------------------------------------------------------
ESQ_FormatDiskErrorMessage:
LAB_001E:
    MOVEM.L D6-D7,-(A7)

    SetOffsetForStack   2

    PEA     LAB_1AF4
    JSR     LAB_03C4(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D6
    TST.L   D6
    BLE.S   .createDiskIsFullMessage

    MOVE.L  D6,-(A7)
    PEA     GLOB_STR_DISK_ERRORS_FORMATTED
    PEA     LAB_2249
    JSR     JMP_TBL_PRINTF_1(PC)

    LEA     .stackOffsetBytes+4(A7),A7
    BRA.S   .done

.createDiskIsFullMessage:
    PEA     LAB_1AF6
    JSR     LAB_03C0(PC)

    MOVE.L  D0,D7
    MOVE.L  D7,(A7)
    PEA     GLOB_STR_DISK_IS_FULL_FORMATTED
    PEA     LAB_2249
    JSR     JMP_TBL_PRINTF_1(PC)

    LEA     .stackOffsetBytes+4(A7),A7

.done:
    MOVEQ   #0,D0
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000

;!======

JMP_TBL_DO_DELAY:
    JMP     DO_DELAY

JMP_TBL_LAB_1911:
    JMP     LAB_1911

JMP_TBL_LAB_1A06_1:
    JMP     LAB_1A06

JMP_TBL_LIBRARIES_LOAD_FAILED_1:
    JMP     LIBRARIES_LOAD_FAILED

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000

;!======

;------------------------------------------------------------------------------
; FUNC: INTB_RBF_EXEC   (HandleSerialRbfInterrupt)
; ARGS:
;   A0: interrupt context?? (reads 24(A0), writes 156(A0))
;   A1: base of receive ring buffer?? (offset by head index)
; RET:
;   D0: 0
; CLOBBERS:
;   D0-D1, A1
; CALLS:
;   (none)
; READS:
;   GLOB_WORD_H_VALUE, GLOB_WORD_T_VALUE, GLOB_WORD_MAX_VALUE, LAB_1F45
; WRITES:
;   (A1+head), LAB_228A, GLOB_WORD_H_VALUE, LAB_228C, GLOB_WORD_MAX_VALUE,
;   LAB_1F45, LAB_20AB, 156(A0)
; DESC:
;   Stores a received byte into the RBF ring buffer, updates head/fill counts,
;   and tracks max fill and overflow threshold.
; NOTES:
;   Buffer wraps at $FA00. Sets LAB_1F45 to $102 when fill reaches $DAC0.
;------------------------------------------------------------------------------
INTB_RBF_EXEC:
    MOVEQ   #0,D0
    MOVE.W  GLOB_WORD_H_VALUE,D0
    ADDA.L  D0,A1
    MOVE.W  24(A0),D1
    MOVE.B  D1,(A1)
    BTST    #15,D1
    BEQ.S   .skip_error_count

    MOVE.W  LAB_228A,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,LAB_228A

.skip_error_count:
    ADDQ.W  #1,D0
    CMPI.W  #$fa00,D0
    BNE.S   .head_update_done

    MOVEQ   #0,D0

.head_update_done:
    MOVE.W  D0,GLOB_WORD_H_VALUE
    MOVE.W  GLOB_WORD_T_VALUE,D1
    SUB.W   D1,D0
    BCC.W   .fill_count_ok

    ADDI.W  #$fa00,D0

.fill_count_ok:
    MOVE.W  D0,LAB_228C
    CMP.W   GLOB_WORD_MAX_VALUE,D0
    BCS.W   .skip_max_update

    MOVE.W  D0,GLOB_WORD_MAX_VALUE

.skip_max_update:
    CMPI.W  #$dac0,D0
    BCS.W   .return

    CMPI.W  #$102,LAB_1F45
    BEQ.W   .return

    MOVE.W  #$102,LAB_1F45
    ADDI.L  #$1,LAB_20AB

.return:
    MOVE.W  #$800,156(A0)
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_ReadSerialRbfByte   (ReadSerialRbfByte)
; ARGS:
;   (none)
; RET:
;   D0: next byte from RBF ring buffer (low byte)
; CLOBBERS:
;   D0-D1, A0
; CALLS:
;   (none)
; READS:
;   GLOB_WORD_T_VALUE, GLOB_WORD_H_VALUE, LAB_1F45, GLOB_REF_INTB_RBF_64K_BUFFER
; WRITES:
;   GLOB_WORD_T_VALUE, LAB_1F45
; DESC:
;   Reads one byte from the RBF ring buffer and advances the tail index.
; NOTES:
;   Clears LAB_1F45 when fill drops below $BB80 (if previously set to $102).
;------------------------------------------------------------------------------
ESQ_ReadSerialRbfByte:
LAB_002B:
    MOVEQ   #0,D1
    MOVE.L  D1,D0
    MOVE.W  GLOB_WORD_T_VALUE,D1
    MOVEA.L GLOB_REF_INTB_RBF_64K_BUFFER,A0
    ADDA.L  D1,A0
    MOVE.B  (A0),D0
    ADDQ.W  #1,D1
    CMPI.W  #$fa00,D1
    BNE.S   .tail_update_done

    MOVEQ   #0,D1

.tail_update_done:
    MOVE.W  D1,GLOB_WORD_T_VALUE
    MOVE.L  D0,-(A7)
    MOVE.W  GLOB_WORD_H_VALUE,D0
    SUB.W   D1,D0
    BCC.W   .fill_count_ok

    ADDI.W  #$fa00,D0

.fill_count_ok:
    CMPI.W  #$102,LAB_1F45
    BNE.W   .return

    CMPI.W  #$bb80,D0   ; Box off.
    BCC.W   .return

    MOVE.W  #0,LAB_1F45

.return:
    MOVE.L  (A7)+,D0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_InitAudio1Dma   (InitAudioChannel1Dma)
; ARGS:
;   (none)
; RET:
;   D0: 0
; CLOBBERS:
;   D0, A0-A1
; CALLS:
;   (none)
; READS:
;   GLOB_PTR_AUD1_DMA
; WRITES:
;   AUD1LCH, AUD1LEN, AUD1VOL, AUD1PER, DMACON, LAB_1AF8, LAB_1AFA, LAB_1B03
; DESC:
;   Initializes audio channel 1 DMA and clears related CTRL capture state.
;------------------------------------------------------------------------------
ESQ_InitAudio1Dma:
LAB_002F:
    MOVEA.L #BLTDDAT,A0
    LEA     GLOB_PTR_AUD1_DMA,A1
    MOVE.L  A1,(AUD1LCH-BLTDDAT)(A0)    ; Store DMA data in GLOB_PTR_AUD1_DMA
    MOVE.W  #1,(AUD1LEN-BLTDDAT)(A0)
    MOVE.W  #0,(AUD1VOL-BLTDDAT)(A0)
    MOVE.W  #$65b,(AUD1PER-BLTDDAT)(A0)
    MOVE.W  #$8202,(DMACON-BLTDDAT)(A0)
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_1AF8
    MOVE.W  D0,LAB_1AFA
    MOVE.W  D0,LAB_1B03
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_CaptureCtrlBit3Stream   (CaptureCiabPraBit3Stream)
; ARGS:
;   (none)
; RET:
;   D0: 0
; CLOBBERS:
;   D0-D1, A5
; CALLS:
;   GET_BIT_3_OF_CIAB_PRA_INTO_D1, ESQ_StoreCtrlSampleEntry
; READS:
;   LAB_1AFC, LAB_1AF9, LAB_1AFD, LAB_1B03
; WRITES:
;   LAB_1AFC, LAB_1AF9, LAB_1AFD, LAB_1AFF, LAB_1B03, LAB_1B04
; DESC:
;   Samples CIAB PRA bit 3 over time, builds bytes from samples, and stores
;   them into the LAB_1B04 ring buffer.
; NOTES:
;   Uses LAB_1AFC/1AF9/1AFD as sampling state. Sample buffer is LAB_1AFF.
;------------------------------------------------------------------------------
ESQ_CaptureCtrlBit3Stream:
LAB_0030:
    TST.W   LAB_1AFC
    BNE.S   .advance_state

    JSR     GET_BIT_3_OF_CIAB_PRA_INTO_D1

    TST.B   D1
    BPL.W   .return

    ADDQ.W  #1,LAB_1AFC
    MOVE.W  #4,LAB_1AF9
    MOVE.W  #0,LAB_1AFD
    RTS

;!======

.advance_state:
    MOVE.W  LAB_1AFC,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_1AFC
    MOVE.W  LAB_1AF9,D1
    CMP.W   D0,D1
    BGT.W   .return

    MOVEQ   #4,D1
    CMP.W   D1,D0
    BGT.W   .collect_samples

    JSR     GET_BIT_3_OF_CIAB_PRA_INTO_D1

    TST.B   D1
    BPL.S   .reset_state

    MOVE.W  #14,LAB_1AF9
    MOVEQ   #7,D0
    LEA     LAB_1AFF,A5
    MOVEQ   #0,D1

.clear_sample_buffer_loop:
    MOVE.B  D1,(A5)+
    DBF     D0,.clear_sample_buffer_loop
    RTS

;!======

.reset_state:
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_1AF9
    MOVE.W  D0,LAB_1AFD
    MOVE.W  D0,LAB_1AFC
    RTS

;!======

.collect_samples:
    MOVEQ   #94,D1
    CMP.W   D1,D0
    BGE.S   .assemble_and_store

    JSR     GET_BIT_3_OF_CIAB_PRA_INTO_D1

    LEA     LAB_1AFF,A5
    ADDA.W  LAB_1AFD,A5
    MOVE.B  D1,(A5)
    ADDQ.W  #1,LAB_1AFD
    ADDI.W  #10,LAB_1AF9
    RTS

;!======

.assemble_and_store:
    JSR     GET_BIT_3_OF_CIAB_PRA_INTO_D1

    TST.B   D1
    BMI.S   .reset_state_and_exit

    LEA     LAB_1AFF,A5
    ADDA.W  LAB_1AFD,A5
    MOVE.W  LAB_1AFD,D1
    SUBQ.W  #1,D1
    MOVEQ   #0,D0

.build_byte_loop:
    TST.B   -(A5)
    BMI.S   .clear_bit

    BSET    D1,D0
    BRA.S   .next_bit

.clear_bit:
    BCLR    D1,D0

.next_bit:
    DBF     D1,.build_byte_loop
    LEA     LAB_1B04,A1
    MOVE.W  LAB_1B03,D1
    ADDA.W  D1,A1
    MOVE.B  D0,(A1)
    BEQ.S   .flush_on_zero

    ADDQ.W  #1,D1
    CMPI.W  #5,D1
    BLT.S   .store_index

    MOVE.B  #0,(A1)

.flush_on_zero:
    JSR     ESQ_StoreCtrlSampleEntry

    MOVEQ   #0,D1

.store_index:
    MOVE.W  D1,LAB_1B03

.reset_state_and_exit:
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_1AF9
    MOVE.W  D0,LAB_1AFD
    MOVE.W  D0,LAB_1AFC

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: GET_BIT_3_OF_CIAB_PRA_INTO_D1   (GetCiabPraBit3)
; ARGS:
;   (none)
; RET:
;   D1: $FF if CIAB_PRA bit 3 is 0, else 0
; CLOBBERS:
;   D1, A5
; CALLS:
;   (none)
; READS:
;   CIAB_PRA
; WRITES:
;   (none)
; DESC:
;   Reads CIAB_PRA and returns an inverted boolean for bit 3 in D1.
;------------------------------------------------------------------------------
GET_BIT_3_OF_CIAB_PRA_INTO_D1:
    MOVEQ   #0,D1           ; Copy 0 into D1 to clear all bytes
    MOVEA.L #CIAB_PRA,A5    ; Copy the address of CIAB_PRA into A5
    MOVE.B  (A5),D1         ; Get contents of the least significant byte at A5 and copy into D1
    BTST    #3,D1           ; Test bit 3, set Z to true if it's 0
    SEQ     D1              ; SEQ sets D1 to $FF when Z=1, otherwise 0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: GET_BIT_4_OF_CIAB_PRA_INTO_D1   (GetCiabPraBit4)
; ARGS:
;   (none)
; RET:
;   D1: $FF if CIAB_PRA bit 4 is 0, else 0
; CLOBBERS:
;   D1, A5
; CALLS:
;   (none)
; READS:
;   CIAB_PRA
; WRITES:
;   (none)
; DESC:
;   Reads CIAB_PRA and returns an inverted boolean for bit 4 in D1.
;------------------------------------------------------------------------------
GET_BIT_4_OF_CIAB_PRA_INTO_D1:
    MOVEQ   #0,D1           ; Copy 0 into D1 to clear all bytes
    MOVEA.L #CIAB_PRA,A5    ; Copy the address of CIAB_PRA into A5
    MOVE.B  (A5),D1         ; Get contents of the least significant byte at A5 and copy into D1
    BTST    #4,D1           ; Test bit 4, set Z to true if it's 0
    SEQ     D1              ; SEQ sets D1 to $FF when Z=1, otherwise 0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_PollCtrlInput   (PollCtrlInput)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, A0-A1, A4-A5
; CALLS:
;   ESQ_CaptureCtrlBit4Stream, ESQ_CaptureCtrlBit3Stream
; READS:
;   LAB_1DC8
; WRITES:
;   INTREQ
; DESC:
;   Updates CTRL sampling state and acknowledges the audio channel 1 interrupt.
; NOTES:
;   Only captures the bit-3 stream when LAB_1DC8+18 holds 'N'.
;------------------------------------------------------------------------------
ESQ_PollCtrlInput:
callCTRL:
    MOVE.L  A5,-(A7)
    MOVE.L  A4,-(A7)

    JSR     ESQ_CaptureCtrlBit4Stream

    LEA     LAB_1DC8,A4
    MOVE.B  18(A4),D1
    CMPI.B  #"N",D1
    BNE.S   .LAB_0040

    JSR     ESQ_CaptureCtrlBit3Stream(PC)

.LAB_0040:
    MOVEA.L #BLTDDAT,A0
    MOVE.W  #$100,(INTREQ-BLTDDAT)(A0)
    ; Looking at that, 0100 means bit 8 starting from the right as 0 is set
    ; so we're setting "Audio channel 1 block finished"

    MOVEA.L (A7)+,A4
    MOVEA.L (A7)+,A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_CaptureCtrlBit4Stream   (CaptureCiabPraBit4Stream)
; ARGS:
;   (none)
; RET:
;   D0: 0 (on reset path)
; CLOBBERS:
;   D0-D1, A5
; CALLS:
;   GET_BIT_4_OF_CIAB_PRA_INTO_D1
; READS:
;   LAB_1AFA, LAB_1AF8, LAB_1AFB
; WRITES:
;   LAB_1AFA, LAB_1AF8, LAB_1AFB, LAB_1AFE, CTRL_BUFFER, CTRL_H, LAB_2282,
;   LAB_2283, LAB_2284
; DESC:
;   Samples CIAB PRA bit 4 over time, assembles bytes, and appends them to
;   CTRL_BUFFER.
; NOTES:
;   Uses LAB_1AFA/1AF8/1AFB as sampling state. Buffer wraps at $01F4.
;------------------------------------------------------------------------------
ESQ_CaptureCtrlBit4Stream:
readCTRL:
    TST.W   LAB_1AFA            ; Test LAB_1AFA...
    BNE.S   .advance_state       ; and if it's not equal to zero, jump to LAB_0042

    JSR     GET_BIT_4_OF_CIAB_PRA_INTO_D1(PC)        ; Read the bit from CIAB_PRA and store bit 4's value in D1

    TST.B   D1                  ; Test the value (this cheaply is seeing if it's 1 or 0)
    BPL.W   .return              ; If it's 1, jump to LAB_004D (which is just RTS) so exit this subroutine.

    ADDQ.W  #1,LAB_1AFA
    MOVE.W  #4,LAB_1AF8
    MOVE.W  #0,LAB_1AFB
    RTS

;!======

.advance_state:
    MOVE.W  LAB_1AFA,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_1AFA
    MOVE.W  LAB_1AF8,D1
    CMP.W   D0,D1
    BGT.W   .return

    MOVEQ   #4,D1
    CMP.W   D1,D0
    BGT.W   .collect_samples

    JSR     GET_BIT_4_OF_CIAB_PRA_INTO_D1(PC)

    TST.B   D1
    BPL.S   .reset_state

    MOVE.W  #14,LAB_1AF8
    MOVEQ   #7,D0
    LEA     LAB_1AFE,A5
    MOVEQ   #0,D1

.clear_sample_buffer_loop:
    MOVE.B  D1,(A5)+
    DBF     D0,.clear_sample_buffer_loop

    RTS

.reset_state:
    MOVEQ   #0,D0           ; Set D0 to 0
    MOVE.W  D0,LAB_1AF8     ; Set LAB_1AF8 to D0 (0)
    MOVE.W  D0,LAB_1AFB     ; Set LAB_1AFB to D0 (0)
    MOVE.W  D0,LAB_1AFA     ; Set LAB_1AFA to D0 (0)
    RTS

.collect_samples:
    MOVEQ   #94,D1              ; Move 94 ('^') into D1
    CMP.W   D1,D0
    BGE.S   .assemble_and_store

    JSR     GET_BIT_4_OF_CIAB_PRA_INTO_D1(PC)

    LEA     LAB_1AFE,A5
    ADDA.W  LAB_1AFB,A5
    MOVE.B  D1,(A5)
    ADDQ.W  #1,LAB_1AFB
    ADDI.W  #10,LAB_1AF8
    RTS

.assemble_and_store:
    JSR     GET_BIT_4_OF_CIAB_PRA_INTO_D1(PC)

    TST.B   D1
    BMI.S   .reset_state_and_exit

    LEA     LAB_1AFE,A5
    ADDA.W  LAB_1AFB,A5
    MOVE.W  LAB_1AFB,D1
    SUBQ.W  #1,D1
    MOVEQ   #0,D0

.build_byte_loop:
    TST.B   -(A5)
    BMI.S   .clear_bit

    BSET    D1,D0
    BRA.S   .next_bit

.clear_bit:
    BCLR    D1,D0

.next_bit:
    DBF     D1,.build_byte_loop
    LEA     CTRL_BUFFER,A1
    MOVE.W  CTRL_H,D1
    ADDA.W  D1,A1
    MOVE.B  D0,(A1)+
    ADDQ.W  #1,D1
    CMPI.W  #$1f4,D1
    BNE.S   .store_tail

    MOVEQ   #0,D1

.store_tail:
    MOVE.W  D1,CTRL_H
    MOVE.W  D1,D0
    MOVE.W  LAB_2282,D1
    SUB.W   D1,D0
    BCC.W   .fill_count_ok

    ADDI.W  #$1f4,D0

.fill_count_ok:
    MOVE.W  D0,LAB_2284
    CMP.W   LAB_2283,D0
    BCS.W   .reset_state_and_exit

    MOVE.W  D0,LAB_2283

.reset_state_and_exit:
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_1AF8
    MOVE.W  D0,LAB_1AFB
    MOVE.W  D0,LAB_1AFA

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_ReadCtrlBufferByte   (ReadCtrlBufferByte)
; ARGS:
;   (none)
; RET:
;   D0: next byte from CTRL_BUFFER (low byte)
; CLOBBERS:
;   D0-D1, A0
; CALLS:
;   (none)
; READS:
;   LAB_2282, CTRL_BUFFER
; WRITES:
;   LAB_2282
; DESC:
;   Reads one byte from CTRL_BUFFER and advances the tail index.
; NOTES:
;   Buffer wraps at $01F4.
;------------------------------------------------------------------------------
ESQ_ReadCtrlBufferByte:
getCTRLBuffer:
    MOVEQ   #0,D1
    MOVE.L  D1,D0
    MOVE.W  LAB_2282,D1
    LEA     CTRL_BUFFER,A0
    ADDA.L  D1,A0
    MOVE.B  (A0),D0
    ADDQ.W  #1,D1
    CMPI.W  #$1f4,D1
    BNE.S   .tail_update_done

    MOVEQ   #0,D1

.tail_update_done:
    MOVE.W  D1,LAB_2282
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_StoreCtrlSampleEntry   (StoreCtrlSampleEntry??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, A0-A1
; CALLS:
;   (none)
; READS:
;   LAB_1B04, LAB_231B
; WRITES:
;   LAB_231D, LAB_231B
; DESC:
;   Copies a null-terminated byte sequence from LAB_1B04 into the current
;   5-byte slot of LAB_231D, then advances the slot index.
; NOTES:
;   Slot index wraps at 20 entries. Entry size includes the terminator.
;------------------------------------------------------------------------------
ESQ_StoreCtrlSampleEntry:
LAB_0050:
    MOVEM.L D0-D1/A0-A1,-(A7)

    LEA     LAB_231D,A0
    MOVE.L  LAB_231B,D0
    MOVE.W  D0,D1
    MULS    #5,D1
    ADDA.W  D1,A0
    LEA     LAB_1B04,A1

.LAB_0051:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .LAB_0051

    ADDQ.L  #1,D0
    MOVEQ   #20,D1
    CMP.L   D1,D0
    BLT.S   .return

    MOVEQ   #0,D0

.return:
    MOVE.L  D0,LAB_231B
    MOVEM.L (A7)+,D0-D1/A0-A1
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_SetCopperEffect_Default   (SetCopperEffectDefault??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1
; CALLS:
;   ESQ_SetCopperEffectParams
; READS:
;   (none)
; WRITES:
;   LAB_1B00, LAB_1B01, LAB_1B02, LAB_1E22, LAB_1E51
; DESC:
;   Loads a default effect parameter pair (0/$3F) and updates copper tables.
; NOTES:
;   Likely tied to a highlight/flash effect; exact purpose unknown.
;------------------------------------------------------------------------------
ESQ_SetCopperEffect_Default:
LAB_0053:
    MOVE.B  #0,D0
    MOVE.B  #$3f,D1
    JSR     ESQ_SetCopperEffectParams

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_SetCopperEffect_Custom   (SetCopperEffectCustom??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, A1
; CALLS:
;   ESQ_SetCopperEffectParams
; READS:
;   LAB_1B05, CIAB_PRA
; WRITES:
;   CIAB_PRA, LAB_1B00, LAB_1B01, LAB_1B02, LAB_1E22, LAB_1E51
; DESC:
;   Forces CIAB_PRA bits 6/7 high, uses LAB_1B05 as a parameter, and updates
;   the copper tables.
; NOTES:
;   Exact meaning of the parameters is unknown.
;------------------------------------------------------------------------------
ESQ_SetCopperEffect_Custom:
LAB_0054:
    MOVEA.L #CIAB_PRA,A1
    MOVE.B  (A1),D1
    BSET    #6,D1
    BSET    #7,D1
    MOVE.B  D1,(A1)
    MOVE.B  #$3f,D0
    MOVE.B  LAB_1B05,D1
    JSR     ESQ_SetCopperEffectParams

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_SetCopperEffect_AllOn   (SetCopperEffectAllOn??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, A1
; CALLS:
;   ESQ_SetCopperEffectParams
; READS:
;   CIAB_PRA
; WRITES:
;   CIAB_PRA, LAB_1B00, LAB_1B01, LAB_1B02, LAB_1E22, LAB_1E51
; DESC:
;   Clears CIAB_PRA bits 6/7, sets both parameters to $3F, and updates the
;   copper tables.
; NOTES:
;   Exact meaning of the parameters is unknown.
;------------------------------------------------------------------------------
ESQ_SetCopperEffect_AllOn:
LAB_0055:
    MOVEA.L #CIAB_PRA,A1
    MOVE.B  (A1),D1
    BCLR    #6,D1
    BCLR    #7,D1
    MOVE.B  D1,(A1)
    MOVE.B  #$3f,D0
    MOVE.B  #$3f,D1
    JSR     ESQ_SetCopperEffectParams

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_SetCopperEffect_OffDisableHighlight   (SetCopperEffectOffDisableHighlight??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, A1
; CALLS:
;   ESQ_SetCopperEffectParams, GCOMMAND_DisableHighlight
; READS:
;   CIAB_PRA
; WRITES:
;   CIAB_PRA, LAB_1B00, LAB_1B01, LAB_1B02, LAB_1E22, LAB_1E51
; DESC:
;   Sets CIAB_PRA bits to 01, clears both parameters, updates copper tables,
;   and disables UI highlight.
; NOTES:
;   Exact meaning of the parameters is unknown.
;------------------------------------------------------------------------------
ESQ_SetCopperEffect_OffDisableHighlight:
LAB_0056:
    MOVEA.L #CIAB_PRA,A1
    MOVE.B  (A1),D1
    BCLR    #6,D1
    BSET    #7,D1
    MOVE.B  D1,(A1)
    MOVE.B  #0,D0
    MOVE.B  #0,D1
    JSR     ESQ_SetCopperEffectParams

    JSR     GCOMMAND_DisableHighlight

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_SetCopperEffect_OnEnableHighlight   (SetCopperEffectOnEnableHighlight??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, A1
; CALLS:
;   ESQ_SetCopperEffectParams, GCOMMAND_EnableHighlight
; READS:
;   CIAB_PRA
; WRITES:
;   CIAB_PRA, LAB_1B00, LAB_1B01, LAB_1B02, LAB_1E22, LAB_1E51
; DESC:
;   Sets CIAB_PRA bits to 11, loads parameters ($3F/0), updates copper tables,
;   and enables UI highlight.
; NOTES:
;   Exact meaning of the parameters is unknown.
;------------------------------------------------------------------------------
ESQ_SetCopperEffect_OnEnableHighlight:
LAB_0057:
    MOVEA.L #CIAB_PRA,A1
    MOVE.B  (A1),D1
    BSET    #6,D1
    BSET    #7,D1
    MOVE.B  D1,(A1)
    MOVE.B  #$3f,D0
    MOVE.B  #0,D1
    JSR     ESQ_SetCopperEffectParams

    JSR     GCOMMAND_EnableHighlight

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_SetCopperEffectParams   (SetCopperEffectParams??)
; ARGS:
;   D0.b: paramA (0..$3F ??)
;   D1.b: paramB (0..$3F ??)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1
; CALLS:
;   ESQ_UpdateCopperListsFromParams
; READS:
;   (none)
; WRITES:
;   LAB_1B00, LAB_1B01, LAB_1B02, LAB_1E22, LAB_1E51
; DESC:
;   Stores the effect parameters and regenerates the copper tables.
; NOTES:
;   Parameters are packed into LAB_1B00..LAB_1B02 for ESQ_UpdateCopperListsFromParams.
;------------------------------------------------------------------------------
ESQ_SetCopperEffectParams:
LAB_0058:
    MOVE.B  D0,LAB_1B01
    MOVE.B  D1,LAB_1B02
    MOVE.W  #5,LAB_1B00
    JSR     ESQ_UpdateCopperListsFromParams

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_UpdateCopperListsFromParams   (UpdateCopperListsFromParams??)
; ARGS:
;   (none)
; RET:
;   D0: 0
; CLOBBERS:
;   D0-D4, A0-A1, A6
; CALLS:
;   (none)
; READS:
;   LAB_1B00, LAB_1B01, LAB_1B02, LAB_1E25
; WRITES:
;   LAB_1E22, LAB_1E51
; DESC:
;   Expands packed effect parameters into copper list words for two tables.
; NOTES:
;   Writes 16 entries (DBF runs D4+1 iterations). Exact effect semantics unknown.
;------------------------------------------------------------------------------
ESQ_UpdateCopperListsFromParams:
LAB_0059:
    LEA     LAB_1E25,A0
    MOVE.W  26(A0),D1
    MOVE.L  LAB_1B00,D0
    LEA     LAB_1E22,A0
    LEA     LAB_1E51,A1
    ADDQ.L  #6,A0
    ADDQ.L  #6,A1
    ADD.B   D0,D0
    ADD.B   D0,D0
    ADD.W   D0,D0
    ADD.W   D0,D0
    SWAP    D0
    TST.B   D0
    BNE.S   .normalize_seed

    MOVEQ   #0,D0

.normalize_seed:
    ROL.L   #5,D0
    MOVEM.L D2-D4/A6,-(A7)
    MOVEA.W #$100,A6
    MOVE.W  D1,D3
    BCLR    #8,D3
    MOVEQ   #15,D4

.write_copper_loop:
    MOVE.W  A6,D2
    AND.W   D0,D2
    OR.W    D3,D2
    MOVE.W  D2,(A0)
    MOVE.W  D2,(A1)
    MOVE.W  D2,4(A0)
    MOVE.W  D2,4(A1)
    MOVE.W  D2,136(A0)
    MOVE.W  D2,136(A1)
    MOVE.W  D2,140(A0)
    MOVE.W  D2,140(A1)
    ADDQ.L  #8,A0
    ADDQ.L  #8,A1
    ROL.L   #1,D0
    DBF     D4,.write_copper_loop

    MOVE.W  D1,(A0)
    MOVE.W  D1,(A1)
    MOVE.W  D1,136(A0)
    MOVE.W  D1,136(A1)
    MOVEM.L (A7)+,D2-D4/A6
    MOVEQ   #0,D0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_NoOp   (NoOpStub)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   (none)
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   No-op stub that returns immediately.
;------------------------------------------------------------------------------
ESQ_NoOp:
LAB_005C:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_ClearCopperListFlags   (ClearCopperListFlags??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   LAB_1E2B, LAB_1E58
; DESC:
;   Clears the lead bytes of two copper list tables.
; NOTES:
;   Exact meaning of the cleared bytes is unknown.
;------------------------------------------------------------------------------
ESQ_ClearCopperListFlags:
LAB_005C_CLEAR:
    MOVE.B  #0,D0
    MOVE.B  D0,LAB_1E2B
    MOVE.B  D0,LAB_1E58
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_MoveCopperEntryTowardStart   (MoveCopperEntryTowardStart??)
; ARGS:
;   stack +4: dstIndex (entry index, masked to 0..31)
;   stack +8: srcIndex (entry index, masked to 0..31)
; RET:
;   (none)
; CLOBBERS:
;   D0-D4
; CALLS:
;   (none)
; READS:
;   LAB_1E26, LAB_1E55
; WRITES:
;   LAB_1E26, LAB_1E55
; DESC:
;   Moves an entry toward the start of the table by shifting intervening
;   entries down and inserting the original value at dstIndex.
; NOTES:
;   Table entries are 4 bytes wide; the secondary table mirrors part of the range.
;------------------------------------------------------------------------------
ESQ_MoveCopperEntryTowardStart:
LAB_005D:
    MOVE.L  4(A7),D1
    MOVE.L  8(A7),D0
    MOVEM.L D2-D4,-(A7)
    MOVE.L  D0,D2
    ANDI.W  #$1f,D2
    ANDI.W  #$1f,D1
    LSL.W   #2,D1
    LSL.W   #2,D2
    LEA     LAB_1E26,A1
    LEA     LAB_1E55,A0
    ADDI.W  #0,D1
    ADDI.W  #0,D2
    MOVE.W  #$1c,D4
    MOVE.W  D2,D3
    SUBI.W  #4,D3
    MOVE.W  0(A1,D2.W),D0

.shift_down_loop:
    CMP.W   D1,D2
    BMI.W   .insert_entry

    MOVE.W  0(A1,D3.W),0(A1,D2.W)
    CMP.W   D2,D4
    BMI.W   .copy_secondary_if_in_range

    MOVE.W  0(A1,D3.W),0(A0,D2.W)

.copy_secondary_if_in_range:
    SUBI.W  #4,D2
    SUBI.W  #4,D3
    BRA.S   .shift_down_loop

.insert_entry:
    MOVE.W  D0,0(A1,D1.W)
    CMP.W   D2,D4
    BMI.W   .return

    BEQ.W   .return

    MOVE.W  D0,0(A0,D1.W)

.return:
    MOVEM.L (A7)+,D2-D4
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_MoveCopperEntryTowardEnd   (MoveCopperEntryTowardEnd??)
; ARGS:
;   stack +4: srcIndex (entry index, masked to 0..31)
;   stack +8: dstIndex (entry index, masked to 0..31)
; RET:
;   (none)
; CLOBBERS:
;   D0-D4
; CALLS:
;   (none)
; READS:
;   LAB_1E26, LAB_1E55
; WRITES:
;   LAB_1E26, LAB_1E55
; DESC:
;   Moves an entry toward the end of the table by shifting intervening
;   entries up and inserting the original value at dstIndex.
; NOTES:
;   Table entries are 4 bytes wide; the secondary table mirrors part of the range.
;------------------------------------------------------------------------------
ESQ_MoveCopperEntryTowardEnd:
LAB_0062:
    MOVE.L  4(A7),D1
    MOVE.L  8(A7),D0
    MOVEM.L D2-D4,-(A7)
    MOVE.L  D0,D2
    ANDI.W  #$1f,D2
    ANDI.W  #$1f,D1
    LSL.W   #2,D1
    LSL.W   #2,D2
    LEA     LAB_1E26,A1
    LEA     LAB_1E55,A0
    ADDI.W  #0,D1
    ADDI.W  #0,D2
    MOVE.W  #$20,D4
    MOVEQ   #4,D3
    ADD.W   D1,D3
    MOVE.W  0(A1,D1.W),D0

.shift_up_loop:
    CMP.W   D2,D1
    BPL.W   .insert_entry

    MOVE.W  0(A1,D3.W),0(A1,D1.W)
    CMP.W   D4,D1
    BPL.W   .copy_secondary_if_in_range

    MOVE.W  0(A1,D3.W),0(A0,D1.W)

.copy_secondary_if_in_range:
    ADDI.W  #4,D1
    ADDI.W  #4,D3
    BRA.S   .shift_up_loop

.insert_entry:
    MOVE.W  D0,0(A1,D1.W)
    CMP.W   D4,D1
    BPL.W   .return

    MOVE.W  D0,0(A0,D1.W)

.return:
    MOVEM.L (A7)+,D2-D4
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_DecCopperListsPrimary   (DecCopperListsPrimary??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0, D2-D5, A2-A3
; CALLS:
;   ESQ_DecColorStep
; READS:
;   LAB_1E26, LAB_1E55
; WRITES:
;   LAB_1E26, LAB_1E55
; DESC:
;   Decrements color components for entries in the primary copper lists.
; NOTES:
;   Updates the first 8 entries in both lists, then the next 24 entries only
;   in LAB_1E26.
;------------------------------------------------------------------------------
ESQ_DecCopperListsPrimary:
LAB_0067:
    MOVEM.L D2-D5/A2-A3,-(A7)
    LEA     LAB_1E26,A2
    LEA     LAB_1E55,A3
    MOVE.W  #0,D5
    MOVEQ   #7,D4

.update_dual_loop:
    MOVE.W  0(A2,D5.W),D0
    JSR     ESQ_DecColorStep

    MOVE.W  D0,0(A2,D5.W)
    MOVE.W  D0,0(A3,D5.W)
    ADDQ.W  #4,D5
    DBF     D4,.update_dual_loop
    MOVEQ   #23,D4

.update_primary_loop:
    MOVE.W  0(A2,D5.W),D0
    JSR     ESQ_DecColorStep

    MOVE.W  D0,0(A2,D5.W)
    ADDQ.W  #4,D5
    DBF     D4,.update_primary_loop
    MOVEM.L (A7)+,D2-D5/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_NoOp_006A   (NoOpStub_006A)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   (none)
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   No-op stub that returns immediately.
;------------------------------------------------------------------------------
ESQ_NoOp_006A:
LAB_006A:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_DecCopperListsAltSkipIndex4   (DecCopperListsAltSkipIndex4??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0, D2-D5, A2-A3
; CALLS:
;   ESQ_DecColorStep
; READS:
;   LAB_1E2E, LAB_1E5B
; WRITES:
;   LAB_1E2E, LAB_1E5B
; DESC:
;   Decrements color components for entries in the alternate copper lists,
;   skipping the entry at byte offset 4.
; NOTES:
;   Skips when D5 == 4.
;------------------------------------------------------------------------------
ESQ_DecCopperListsAltSkipIndex4:
LAB_006B_ENTRY:
    MOVEM.L D2-D5/A2-A3,-(A7)
    LEA     LAB_1E2E,A2
    LEA     LAB_1E5B,A3
    MOVE.W  #0,D5
    MOVEQ   #7,D4

.update_loop:
    CMPI.W  #4,D5
    BEQ.W   .skip_index4

    MOVE.W  0(A2,D5.W),D0
    JSR     ESQ_DecColorStep

    MOVE.W  D0,0(A2,D5.W)
    MOVE.W  D0,0(A3,D5.W)

.skip_index4:
    ADDQ.W  #4,D5
    DBF     D4,.update_loop
    MOVEM.L (A7)+,D2-D5/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_DecColorStep   (DecColorStep??)
; ARGS:
;   D0.w: color value (packed nibbles, likely RGB)
; RET:
;   D0.w: color value with each non-zero component decremented by 1
; CLOBBERS:
;   D0-D2
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Decrements each non-zero 4-bit color component by one step.
; NOTES:
;   Assumes packed 0RGB format; component layout is inferred.
;------------------------------------------------------------------------------
ESQ_DecColorStep:
LAB_006D:
    MOVE.W  D0,D1
    MOVE.W  D0,D2
    ANDI.W  #$f00,D1
    ANDI.W  #$f0,D2
    ANDI.W  #15,D0
    TST.W   D1
    BEQ.S   .green_check

    SUBI.W  #$100,D1

.green_check:
    TST.W   D2
    BEQ.S   .blue_check

    SUBI.W  #16,D2

.blue_check:
    TST.W   D0
    BEQ.S   .combine_components

    SUBI.W  #1,D0

.combine_components:
    ADD.W   D1,D0
    ADD.W   D2,D0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_IncCopperListsTowardsTargets   (IncCopperListsTowardsTargets??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0, D2-D6, A1-A3
; CALLS:
;   ESQ_BumpColorTowardTargets
; READS:
;   LAB_2295, LAB_1E26, LAB_1E55
; WRITES:
;   LAB_1E26, LAB_1E55
; DESC:
;   Adjusts copper list colors based on a per-entry target table.
; NOTES:
;   Uses LAB_2295 as a 3-byte-per-entry target stream.
;------------------------------------------------------------------------------
ESQ_IncCopperListsTowardsTargets:
LAB_0071:
    MOVEM.L D2-D6/A2-A3,-(A7)
    LEA     LAB_2295,A1
    LEA     LAB_1E26,A2
    LEA     LAB_1E55,A3
    MOVE.W  #0,D5
    MOVEQ   #7,D4

.update_dual_loop:
    MOVE.W  0(A2,D5.W),D0
    JSR     ESQ_BumpColorTowardTargets

    MOVE.W  D0,0(A2,D5.W)
    MOVE.W  D0,0(A3,D5.W)
    ADDQ.W  #4,D5
    DBF     D4,.update_dual_loop
    MOVEQ   #23,D4

.update_primary_loop:
    MOVE.W  0(A2,D5.W),D0
    JSR     ESQ_BumpColorTowardTargets

    MOVE.W  D0,0(A2,D5.W)
    ADDQ.W  #4,D5
    DBF     D4,.update_primary_loop
    MOVEM.L (A7)+,D2-D6/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_NoOp_0074   (NoOpStub_0074)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   (none)
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   No-op stub that returns immediately.
;------------------------------------------------------------------------------
ESQ_NoOp_0074:
LAB_0074:
    RTS

;!======

; Orphaned helper? No known callers; only referenced internally.
;------------------------------------------------------------------------------
; FUNC: ESQ_IncCopperListsAltSkipIndex4   (IncCopperListsAltSkipIndex4??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0, D2-D5, A1-A3
; CALLS:
;   ESQ_BumpColorTowardTargets
; READS:
;   LAB_1E2E, LAB_1E5B
; WRITES:
;   LAB_1E2E, LAB_1E5B
; DESC:
;   Adjusts alternate copper list colors based on the target stream,
;   skipping the entry at byte offset 4.
; NOTES:
;   This block is currently marked unreachable.
;------------------------------------------------------------------------------
ESQ_IncCopperListsAltSkipIndex4:
LAB_0075_ENTRY:
    MOVEM.L D2-D5/A2-A3,-(A7)
    LEA     LAB_1E2E,A2
    LEA     LAB_1E5B,A3
    MOVE.W  #0,D5
    MOVEQ   #7,D4

.update_loop:
    CMPI.W  #4,D5
    BEQ.W   .skip_index4

    MOVE.W  0(A2,D5.W),D0
    JSR     ESQ_BumpColorTowardTargets

    MOVE.W  D0,0(A2,D5.W)
    MOVE.W  D0,0(A3,D5.W)

.skip_index4:
    ADDQ.W  #4,D5
    DBF     D4,.update_loop
    MOVEM.L (A7)+,D2-D5/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_BumpColorTowardTargets   (BumpColorTowardTargets??)
; ARGS:
;   D0.w: color value (packed nibbles, likely RGB)
;   A1: pointer to 3-byte target stream (advances by 3)
; RET:
;   D0.w: adjusted color value
; CLOBBERS:
;   D0-D3, A1
; CALLS:
;   (none)
; READS:
;   (A1)+
; WRITES:
;   (none)
; DESC:
;   Adjusts each color component based on a per-component target byte.
; NOTES:
;   Component layout and adjustment direction are inferred.
;------------------------------------------------------------------------------
ESQ_BumpColorTowardTargets:
LAB_0077:
    MOVE.W  D0,D1
    MOVE.W  D0,D2
    ANDI.W  #$f00,D1
    ANDI.W  #$f0,D2
    ANDI.W  #15,D0
    MOVEQ   #0,D3
    MOVE.B  (A1)+,D3
    LSL.W   #8,D3
    CMP.W   D3,D1
    BEQ.S   .after_red

    ADDI.W  #$100,D1

.after_red:
    MOVEQ   #0,D3
    MOVE.B  (A1)+,D3
    LSL.W   #4,D3
    CMP.W   D3,D2
    BEQ.S   .after_green

    ADDI.W  #16,D2

.after_green:
    MOVEQ   #0,D3
    MOVE.B  (A1)+,D3
    CMP.W   D3,D0
    BEQ.S   .return

    ADDI.W  #1,D0

.return:
    ADD.W   D1,D0
    ADD.W   D2,D0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_TickClockAndFlagEvents   (TickClockAndFlagEvents??)
; ARGS:
;   stack +4: timePtr (struct with date/time fields)
; RET:
;   D0: event code (0..5 ??)
; CLOBBERS:
;   D0-D4
; CALLS:
;   ESQ_UpdateMonthDayFromDayOfYear
; READS:
;   LAB_1B09, LAB_1B0A, LAB_1B0B, LAB_1B0C
; WRITES:
;   [timePtr] fields (0,2,4,6,8,10,12,16,18,20)
; DESC:
;   Advances the time structure by one second and returns a status/event code
;   for notable boundaries (minute/half-hour/hour/day changes).
; NOTES:
;   Field meanings are inferred; 18(A0) is treated as an AM/PM sign flag.
;------------------------------------------------------------------------------
ESQ_TickClockAndFlagEvents:
LAB_007B:
    MOVEA.L 4(A7),A0
    MOVEM.L D2-D4,-(A7)
    MOVEQ   #0,D0
    MOVE.L  D0,D2
    MOVE.L  D0,D4
    MOVEQ   #1,D1
    MOVEQ   #60,D3
    MOVE.W  12(A0),D0
    CMP.W   D3,D0
    BLT.W   .return

    SUB.W   D3,12(A0)
    MOVEQ   #1,D4
    MOVE.W  10(A0),D0
    ADD.W   D1,D0
    MOVE.W  D0,10(A0)
    CMPI.W  #$1e,D0
    BNE.W   .check_minute_flags

    MOVEQ   #2,D4
    BRA.W   .return

.check_minute_flags:
    CMP.W   D3,D0
    BGE.W   .hour_rollover

    CMP.W   LAB_1B0C,D0
    BEQ.W   .minute_trigger_5

    CMP.W   LAB_1B0B,D0
    BNE.W   .check_minute_20_or_50

.minute_trigger_5:
    MOVEQ   #5,D4
    BRA.W   .return

.check_minute_20_or_50:
    CMPI.W  #20,D0
    BEQ.W   .minute_trigger_4

    CMPI.W  #$32,D0
    BNE.W   .check_minute_special_3

.minute_trigger_4:
    MOVEQ   #4,D4
    BRA.W   .return

.check_minute_special_3:
    CMP.W   LAB_1B09,D0
    BEQ.W   .minute_trigger_3

    CMP.W   LAB_1B0A,D0
    BNE.W   .return

.minute_trigger_3:
    MOVEQ   #3,D4
    BRA.W   .return

.hour_rollover:
    MOVE.W  D2,10(A0)
    MOVEQ   #2,D4
    MOVE.W  8(A0),D0
    ADD.W   D1,D0
    MOVE.W  D0,8(A0)
    MOVEQ   #12,D3
    CMP.W   D3,D0
    BLT.W   .return

    BEQ.S   .toggle_am_pm

    MOVE.W  D1,8(A0)
    BRA.W   .return

.toggle_am_pm:
    EORI.W   #$ffff,18(A0)
    BMI.W   .return

    MOVE.W  0(A0),D0
    ADD.W   D1,D0
    MOVE.W  D0,0(A0)
    MOVEQ   #7,D3
    CMP.W   D3,D0
    BNE.S   .wrap_weekday

    MOVE.W  D2,0(A0)

.wrap_weekday:
    MOVE.W  16(A0),D0
    ADD.W   D1,D0
    MOVE.W  D0,16(A0)
    MOVE.W  #$16e,D3
    TST.W   20(A0)
    BEQ.S   .day_of_year_check

    ADD.W   D1,D3

.day_of_year_check:
    CMP.W   D3,D0
    BLT.S   .update_month_day

    MOVE.W  6(A0),D0
    ADD.W   D1,D0
    MOVE.W  D0,6(A0)
    MOVE.W  D1,16(A0)
    MOVEQ   #0,D1
    ANDI.W  #3,D0
    BNE.S   .update_leap_flag

    MOVE.W  #(-1),D1

.update_leap_flag:
    MOVE.W  D1,20(A0)

.update_month_day:
    JSR     ESQ_UpdateMonthDayFromDayOfYear

.return:
    MOVE.W  D4,D0
    MOVEM.L (A7)+,D2-D4
    RTS

;!======

; Unreachable Code?
    MOVEA.L 4(A7),A0

;------------------------------------------------------------------------------
; FUNC: ESQ_UpdateMonthDayFromDayOfYear   (UpdateMonthDayFromDayOfYear??)
; ARGS:
;   stack +4: timePtr (struct with day-of-year fields)
; RET:
;   (none)
; CLOBBERS:
;   D0-D2, A1
; CALLS:
;   (none)
; READS:
;   LAB_1B1D
; WRITES:
;   2(A0), 4(A0)
; DESC:
;   Converts day-of-year to month index and day-of-month fields.
; NOTES:
;   Uses alternate month-length table when 20(A0) is non-zero.
;------------------------------------------------------------------------------
ESQ_UpdateMonthDayFromDayOfYear:
LAB_0089:
    MOVE.L  D2,-(A7)
    MOVE.W  16(A0),D0
    MOVEQ   #0,D2
    LEA     LAB_1B1D,A1
    TST.W   20(A0)
    BEQ.S   .scan_months

    ADDA.L  #$18,A1

.scan_months:
    MOVE.W  (A1)+,D1
    CMP.W   D1,D0
    BLE.S   .return

    SUB.W   D1,D0
    ADDQ.W  #1,D2
    BRA.S   .scan_months

.return:
    MOVE.W  D2,2(A0)
    MOVE.W  D0,4(A0)
    MOVE.L  (A7)+,D2
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_CalcDayOfYearFromMonthDay   (CalcDayOfYearFromMonthDay??)
; ARGS:
;   stack +4: timePtr (struct with month/day fields)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, A1
; CALLS:
;   (none)
; READS:
;   LAB_1B1D
; WRITES:
;   16(A0)
; DESC:
;   Converts month index and day-of-month into day-of-year.
; NOTES:
;   Uses alternate month-length table when 20(A0) is non-zero.
;------------------------------------------------------------------------------
ESQ_CalcDayOfYearFromMonthDay:
LAB_008C:
    MOVEA.L 4(A7),A0
    MOVE.W  2(A0),D1
    MOVEQ   #0,D0
    LEA     LAB_1B1D,A1
    DBF     D1,.month_loop

    BRA.S   .return

.month_loop:
    TST.W   20(A0)
    BEQ.S   .select_table

    ADDA.L  #$18,A1

.select_table:
    ADD.W   (A1)+,D0
    DBF     D1,.select_table

.return:
    ADD.W   4(A0),D0
    MOVE.W  D0,16(A0)
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_FormatTimeStamp   (FormatTimeStamp??)
; ARGS:
;   stack +4: outBuf (expects at least 12 bytes)
;   stack +8: timePtr (struct with time fields)
; RET:
;   (none)
; CLOBBERS:
;   D0-D2, A0-A1
; CALLS:
;   (none)
; READS:
;   8(A1), 10(A1), 12(A1), 18(A1)
; WRITES:
;   outBuf (null-terminated string)
; DESC:
;   Formats "hh:mm:ss AM/PM" into the output buffer.
; NOTES:
;   Writes the string backward from outBuf+$0B. Uses 18(A1) sign for AM/PM.
;------------------------------------------------------------------------------
ESQ_FormatTimeStamp:
LAB_0090:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    MOVE.L  D2,-(A7)
    ADDA.L  #$b,A0
    MOVE.B  #0,(A0)
    MOVE.B  #'M',-(A0)
    TST.W   18(A1)
    BPL.S   .set_am

    MOVE.B  #'P',-(A0)
    BRA.S   .after_ampm

.set_am:
    MOVE.B  #'A',-(A0)

.after_ampm:
    MOVE.B  #' ',-(A0)
    MOVE.W  12(A1),D2
    EXT.L   D2
    DIVS    #10,D2
    SWAP    D2
    ADDI.B  #'0',D2
    MOVE.B  D2,-(A0)
    SWAP    D2
    ADDI.B  #'0',D2
    MOVE.B  D2,-(A0)
    MOVE.B  #':',-(A0)
    MOVE.W  10(A1),D1
    EXT.L   D1
    DIVS    #10,D1
    SWAP    D1
    ADDI.B  #'0',D1
    MOVE.B  D1,-(A0)
    SWAP    D1
    ADDI.B  #'0',D1
    MOVE.B  D1,-(A0)
    MOVE.B  #':',-(A0)
    MOVE.W  8(A1),D0
    EXT.L   D0
    DIVS    #10,D0
    SWAP    D0
    ADDI.B  #'0',D0
    MOVE.B  D0,-(A0)
    SWAP    D0
    TST.B   D0
    BEQ.S   .leading_space

    ADDI.B  #'0',D0
    BRA.S   .return

.leading_space:
    MOVE.B  #' ',D0

.return:
    MOVE.B  D0,-(A0)
    MOVE.L  (A7)+,D2
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_GetHalfHourSlotIndex   (GetHalfHourSlotIndex??)
; ARGS:
;   stack +4: timePtr (struct with time fields)
; RET:
;   D0: slot index (mapped through LAB_1B1E)
; CLOBBERS:
;   D0-D2, A1
; CALLS:
;   (none)
; READS:
;   8(A0), 10(A0), 18(A0), LAB_1B1E
; WRITES:
;   (none)
; DESC:
;   Computes a half-hour slot for the time and returns a lookup-mapped value.
; NOTES:
;   Slot = hour*2 (+1 if minutes >= 30), with 12-hour and AM/PM handling.
;------------------------------------------------------------------------------
ESQ_GetHalfHourSlotIndex:
LAB_0095:
    MOVEA.L 4(A7),A0
    MOVE.L  D2,-(A7)
    MOVEQ   #0,D0
    MOVEQ   #12,D1
    MOVE.W  8(A0),D0
    TST.W   18(A0)
    BPL.S   .normalize_midnight

    ADD.W   D1,D0
    BRA.S   .wrap_24h

.normalize_midnight:
    CMP.W   D1,D0
    BNE.S   .wrap_24h

    MOVEQ   #0,D0

.wrap_24h:
    MOVEQ   #24,D1
    CMP.W   D1,D0
    BEQ.S   .maybe_add_half

    ADD.W   D0,D0

.maybe_add_half:
    MOVE.W  10(A0),D2
    MOVEQ   #30,D1
    CMP.W   D1,D2
    BLT.S   .return

    ADDQ.W  #1,D0

.return:
    LEA     LAB_1B1E,A1
    MOVE.B  0(A1,D0.W),D0
    MOVE.L  (A7)+,D2
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_ClampBannerCharRange   (ClampBannerCharRange??)
; ARGS:
;   stack +4: value0
;   stack +8: value1
;   stack +12: value2
; RET:
;   (none)
; CLOBBERS:
;   D0-D4
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   LAB_226F, LAB_2280
; DESC:
;   Normalizes values into a bounded A..C/I range and writes two globals.
; NOTES:
;   Heavily context-dependent; likely relates to banner character bounds.
;------------------------------------------------------------------------------
ESQ_ClampBannerCharRange:
LAB_009A:
    MOVE.L  4(A7),D0
    MOVE.L  8(A7),D1
    MOVEA.L 12(A7),A0
    MOVEM.L D2-D4,-(A7)
    MOVE.L  A0,D2
    MOVEQ   #65,D3
    CMP.W   D3,D1
    BLT.S   .force_low_char

    MOVEQ   #67,D3
    CMP.W   D3,D1
    BLT.S   .force_high_char

.force_low_char:
    MOVEQ   #65,D1

.force_high_char:
    MOVEQ   #65,D3
    CMP.W   D3,D2
    BLT.S   .force_second_default

    MOVEQ   #73,D3
    CMP.W   D3,D2
    BLE.S   .normalize_chars

.force_second_default:
    MOVEQ   #69,D2

.normalize_chars:
    MOVEQ   #65,D3
    SUB.W   D3,D1
    SUB.W   D3,D2
    ADDQ.W  #1,D2
    MOVEQ   #48,D4
    MOVE.W  D0,D3
    TST.W   D1
    BEQ.S   .wrap_first_char

    SUB.W   D1,D0
    CMPI.W  #1,D0
    BGE.S   .wrap_first_char

    ADD.W   D4,D0

.wrap_first_char:
    ADD.W   D2,D3
    CMP.W   D4,D3
    BLE.S   .return

    SUB.W   D4,D3

.return:
    MOVE.W  D0,LAB_226F
    MOVE.W  D3,LAB_2280
    MOVEM.L (A7)+,D2-D4
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_AdvanceBannerCharIndex   (AdvanceBannerCharIndex??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D3
; CALLS:
;   (none)
; READS:
;   LAB_2257, LAB_225C, LAB_226F, LAB_2280, LAB_1B08
; WRITES:
;   LAB_2256, LAB_2257, LAB_2273, LAB_1B08
; DESC:
;   Advances a cycling index in the 1..48 range and applies a step offset.
; NOTES:
;   If LAB_1B08 is non-zero, forces a reset path and clears the flag.
;   Also resets when the index matches LAB_2280, using LAB_226F as the base.
;------------------------------------------------------------------------------
ESQ_AdvanceBannerCharIndex:
    MOVEM.L D2-D3,-(A7)
    MOVE.W  LAB_2257,D0
    MOVEQ   #1,D2
    ADD.W   D2,D0
    MOVEQ   #48,D3
    CMP.W   D3,D0
    BLE.S   LAB_00A1

    MOVE.W  D2,D0

LAB_00A1:
    TST.W   LAB_1B08
    BEQ.S   LAB_00A2

    MOVE.W  #0,LAB_1B08
    BRA.S   LAB_00A3

LAB_00A2:
    MOVE.W  LAB_2280,D1
    CMP.W   D1,D0
    BNE.S   LAB_00A4

LAB_00A3:
    MOVE.W  D2,LAB_2256
    MOVE.W  LAB_226F,D0

LAB_00A4:
    MOVE.W  D0,LAB_2257
    MOVE.W  LAB_225C,D1
    BEQ.S   LAB_00A6

    ADD.W   D1,D0
    ADD.W   D1,D0
    CMP.W   D2,D0
    BGE.S   LAB_00A5

    ADD.W   D3,D0
    BRA.S   LAB_00A6

LAB_00A5:
    CMP.W   D3,D0
    BLE.S   LAB_00A6

    SUB.W   D3,D0

LAB_00A6:
    MOVE.W  D0,LAB_2273
    MOVEM.L (A7)+,D2-D3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_AdjustBracketedHourInString   (AdjustBracketedHourInString??)
; ARGS:
;   stack +4: textPtr
;   stack +8: hourOffset (byte, signed??)
; RET:
;   (none)
; CLOBBERS:
;   D0-D4, A0-A1
; CALLS:
;   (none)
; READS:
;   [textPtr]
; WRITES:
;   [textPtr]
; DESC:
;   Scans for bracketed hour fields, replaces '['/']' with '(' / ')' and
;   optionally offsets the hour value, wrapping it into 1..12.
; NOTES:
;   Only adjusts when hourOffset != 0; parsing assumes two-digit hours with
;   a possible leading space.
;------------------------------------------------------------------------------
ESQ_AdjustBracketedHourInString:
LAB_00A7:
    MOVEA.L 4(A7),A0
    MOVE.L  8(A7),D0
    MOVEM.L D2-D4,-(A7)
    MOVE.L  D0,D4

.scan_for_left_bracket:
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVE.L  D0,D2
    MOVEQ   #91,D3

.find_left_bracket:
    MOVE.B  (A0)+,D2
    BEQ.W   .return

    CMP.B   D3,D2
    BNE.S   .find_left_bracket

    SUBQ.W  #1,A0
    MOVEQ   #40,D3
    MOVE.B  D3,(A0)+
    TST.B   D4
    BEQ.S   .scan_for_right_bracket

    MOVE.B  (A0)+,D1
    CMPI.B  #$20,D1
    BEQ.S   .parse_second_digit

    MOVEQ   #10,D0

.parse_second_digit:
    MOVE.B  (A0)+,D1
    SUBI.B  #$30,D1
    ADD.B   D1,D0
    MOVEQ   #12,D1
    ADD.B   D4,D0
    CMPI.B  #$1,D0
    BGE.S   .wrap_hour_range

    ADD.B   D1,D0
    BRA.S   .emit_hour

.wrap_hour_range:
    CMP.B   D1,D0
    BLE.S   .emit_hour

    SUB.B   D1,D0
    BRA.S   .wrap_hour_range

.emit_hour:
    MOVEQ   #10,D1
    MOVEQ   #32,D2
    MOVEA.L A0,A1
    CMP.B   D1,D0
    BLT.S   .write_hour_digits

    SUB.B   D1,D0
    MOVEQ   #49,D2

.write_hour_digits:
    ADDI.B  #$30,D0
    MOVE.B  D0,-(A1)
    MOVE.B  D2,-(A1)

.scan_for_right_bracket:
    MOVEQ   #93,D3

.find_right_bracket:
    MOVE.B  (A0)+,D2
    BEQ.S   .return

    CMP.B   D3,D2
    BNE.S   .find_right_bracket

    SUBQ.W  #1,A0
    MOVEQ   #41,D3
    MOVE.B  D3,(A0)+
    BRA.S   .scan_for_left_bracket

.return:
    MOVEM.L (A7)+,D2-D4
    RTS

;!======

; int32_t test_bit_1based(const uint8_t *base, uint32_t bit_index)
; {
;     uint32_t n = bit_index - 1;          // 1-based -> 0-based
;     uint32_t byte_i = (n & 0xFFFF) >> 3; // because LSR.W
;     uint32_t bit_i  = n & 7;
;     return (base[byte_i] & (1u << bit_i)) ? -1 : 0;
; }
;------------------------------------------------------------------------------
; FUNC: ESQ_TestBit1Based   (TestBit1Based)
; ARGS:
;   stack +4: base (byte array)
;   stack +8: bitIndex (1-based)
; RET:
;   D0: -1 if bit is set, 0 if clear
; CLOBBERS:
;   D0-D1, A0
; CALLS:
;   (none)
; READS:
;   [base]
; WRITES:
;   (none)
; DESC:
;   Tests a 1-based bit index in a byte array.
; NOTES:
;   Uses LSR.W so index is masked to 16 bits before byte addressing.
;------------------------------------------------------------------------------
ESQ_TestBit1Based:
LAB_00B1:
    MOVEA.L 4(A7),A0
    MOVE.L  8(A7),D0
    MOVEQ   #0,D1
    SUBQ.L  #1,D0
    MOVE.B  D0,D1
    ANDI.L  #$7,D1
    LSR.W   #3,D0
    BTST    D1,0(A0,D0.W)
    SNE     D0
    EXT.W   D0
    EXT.L   D0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_SetBit1Based   (SetBit1Based)
; ARGS:
;   stack +4: base (byte array)
;   stack +8: bitIndex (1-based)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, A0
; CALLS:
;   (none)
; READS:
;   [base]
; WRITES:
;   [base]
; DESC:
;   Sets a 1-based bit index in a byte array.
; NOTES:
;   Uses LSR.W so index is masked to 16 bits before byte addressing.
;------------------------------------------------------------------------------
ESQ_SetBit1Based:
LAB_00B2:
    MOVEA.L 4(A7),A0
    MOVE.L  8(A7),D0
    MOVEQ   #0,D1
    SUBQ.L  #1,D0
    MOVE.B  D0,D1
    ANDI.L  #$7,D1
    LSR.W   #3,D0
    BSET    D1,0(A0,D0.W)
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_ReverseBitsIn6Bytes   (ReverseBitsIn6Bytes??)
; ARGS:
;   stack +4: dst (6 bytes)
;   stack +8: src (6 bytes)
; RET:
;   (none)
; CLOBBERS:
;   D0-D4, A0-A1
; CALLS:
;   (none)
; READS:
;   [src]
; WRITES:
;   [dst]
; DESC:
;   Copies six bytes, bit-reversing each non-0/0xFF byte.
; NOTES:
;   Preserves 0x00 and 0xFF without reversal.
;------------------------------------------------------------------------------
ESQ_ReverseBitsIn6Bytes:
LAB_00B3:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    MOVEM.L D2-D4,-(A7)
    MOVEQ   #5,D0

.copy_loop:
    MOVE.B  (A1)+,D4
    BEQ.S   .store_byte

    CMPI.B  #$ff,D4
    BEQ.S   .store_byte

    MOVEQ   #0,D3
    MOVE.L  D3,D1
    MOVE.B  D4,D1
    MOVE.L  D3,D4
    MOVEQ   #7,D2

.reverse_loop:
    BTST    D2,D1
    BEQ.S   .next_bit

    BSET    D3,D4

.next_bit:
    ADDQ.W  #1,D3
    DBF     D2,.reverse_loop

.store_byte:
    MOVE.B  D4,(A0)+
    DBF     D0,.copy_loop

    MOVEM.L (A7)+,D2-D4
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_GenerateXorChecksumByte   (GenerateXorChecksumByte??)
; ARGS:
;   stack +4: seed (initial byte, low 8 bits used)
;   stack +8: src (byte buffer)
;   stack +12: length (bytes)
; RET:
;   D0: checksum byte (low 8 bits)
; CLOBBERS:
;   D0-D2, A0
; CALLS:
;   (none)
; READS:
;   LAB_2253, LAB_2206
; WRITES:
;   (none)
; DESC:
;   Computes an XOR checksum over a buffer, seeded by an inverted byte.
; NOTES:
;   If LAB_2206 is non-zero, returns LAB_2253 instead of computing.
;------------------------------------------------------------------------------
ESQ_GenerateXorChecksumByte:
GENERATE_CHECKSUM_BYTE_INTO_D0:
    MOVEQ   #0,D0
    MOVE.B  LAB_2253,D0
    TST.B   LAB_2206
    BNE.S   .return

    MOVE.L  4(A7),D0
    MOVEA.L 8(A7),A0
    MOVE.L  12(A7),D1
    MOVE.L  D2,-(A7)
    MOVE.L  D1,D2
    SUBQ.W  #1,D2
    EORI.B  #$ff,D0
    MOVEQ   #0,D1

.xor_loop:
    MOVE.B  (A0)+,D1
    EOR.B   D1,D0
    DBF     D2,.xor_loop

    ANDI.L  #$ff,D0
    MOVE.L  (A7)+,D2

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_TerminateAfterSecondQuote   (TerminateAfterSecondQuote??)
; ARGS:
;   stack +4: textPtr
; RET:
;   (none)
; CLOBBERS:
;   D0-D2, A0
; CALLS:
;   (none)
; READS:
;   [textPtr]
; WRITES:
;   [textPtr] (writes a null byte)
; DESC:
;   Scans for the second double-quote and writes a terminator after it.
; NOTES:
;   No callers found via static search; may be reached via computed jump.
;------------------------------------------------------------------------------
ESQ_TerminateAfterSecondQuote:
LAB_00BB_Unreachable:
    MOVEA.L 4(A7),A0
    MOVE.L  D2,-(A7)
    MOVEQ   #0,D0
    MOVE.W  D0,D1
    MOVEQ   #34,D2

.find_first_quote:
    MOVE.B  (A0)+,D1
    BEQ.S   .return

    CMP.B   D2,D1
    BNE.S   .find_first_quote

.find_second_quote:
    MOVE.B  (A0)+,D1
    BEQ.S   .return

    CMP.B   D2,D1
    BNE.S   .find_second_quote

    MOVE.B  D0,(A0)

.return:
    MOVE.L  (A7)+,D2
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_WildcardMatch   (WildcardMatch??)
; ARGS:
;   stack +4: str
;   stack +8: pattern
; RET:
;   D0.b: 0 if match, 1 if mismatch
; CLOBBERS:
;   D0-D1, A0-A1
; CALLS:
;   (none)
; READS:
;   [str], [pattern]
; WRITES:
;   (none)
; DESC:
;   Compares a string against a pattern supporting '*' and '?' wildcards.
; NOTES:
;   Returns mismatch on null pointers. '*' short-circuits to match.
;------------------------------------------------------------------------------
ESQ_WildcardMatch:
LAB_00BE:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    CMPA.L  #0,A0
    BEQ.S   .mismatch

    CMPA.L  #0,A1
    BEQ.S   .mismatch

    MOVEQ   #0,D0

.match_loop:
    MOVE.B  (A0)+,D0
    MOVE.B  (A1)+,D1
    CMPI.B  #$2a,D1
    BEQ.S   .match

    TST.B   D0
    BEQ.S   .check_end

    CMPI.B  #$3f,D1
    BEQ.S   .match_loop

    SUB.B   D1,D0
    BEQ.S   .match_loop

.mismatch:
    MOVE.B  #$1,D0
    RTS

;!======

.check_end:
    TST.B   D1
    BNE.S   .mismatch

.match:
    MOVE.B  #0,D0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_FindSubstringCaseFold   (FindSubstringCaseFold??)
; ARGS:
;   stack +4: haystack
;   stack +8: needle
; RET:
;   D0: pointer to match (or 0 if not found)
; CLOBBERS:
;   D0-D2, A0-A3
; CALLS:
;   (none)
; READS:
;   [haystack], [needle]
; WRITES:
;   (none)
; DESC:
;   Searches for needle inside haystack with ASCII case folding.
; NOTES:
;   Case fold uses BCHG #5 (ASCII letter case bit).
;------------------------------------------------------------------------------
ESQ_FindSubstringCaseFold:
LAB_00C3:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    MOVEM.L A2-A3,-(A7)

    MOVEQ   #0,D0
    TST.B   (A1)
    BEQ.S   .return

    MOVEA.L A0,A3
    MOVEA.L A1,A2

.search_loop:
    TST.B   (A0)
    BNE.S   .compare_loop

    TST.B   (A2)
    BNE.S   .return

.found:
    MOVE.L  A3,D0

.return:
    MOVEM.L (A7)+,A2-A3
    RTS

;!======

.compare_loop:
    TST.B   (A2)
    BEQ.S   .found

    MOVE.B  (A0)+,D1
    CMP.B   (A2),D1
    BNE.S   .try_case_fold

    TST.B   (A2)+
    BRA.S   .search_loop

.try_case_fold:
    BCHG    #5,D1
    CMP.B   (A2),D1
    BNE.S   .reset_search

    TST.B   (A2)+
    BRA.S   .search_loop

.reset_search:
    MOVE.L  A2,D2
    CMPA.L  D2,A1
    BEQ.S   .restart_from_next

    MOVE.L  A0,D1
    SUBI.L  #$1,D1
    MOVEA.L D1,A0

.restart_from_next:
    MOVEA.L A0,A3
    MOVEA.L A1,A2
    BRA.S   .search_loop

;------------------------------------------------------------------------------
; FUNC: ESQ_WriteDecFixedWidth   (WriteDecFixedWidth??)
; ARGS:
;   stack +4: outBuf
;   stack +8: value
;   stack +12: digits
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, A0
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   outBuf
; DESC:
;   Writes a fixed-width decimal string into outBuf.
; NOTES:
;   Writes digits right-to-left and terminates with null at outBuf+digits.
;------------------------------------------------------------------------------
ESQ_WriteDecFixedWidth:
LAB_00CB:
    MOVEA.L 4(A7),A0
    MOVE.L  8(A7),D0
    MOVE.L  12(A7),D1
    ADDA.L  D1,A0
    MOVE.B  #0,(A0)
    SUBQ.W  #1,D1

.emit_digit_loop:
    EXT.L   D0
    DIVS    #10,D0
    SWAP    D0
    MOVE.B  D0,-(A0)
    ADDI.B  #$30,(A0)
    SWAP    D0
    DBF     D1,.emit_digit_loop

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_PackBitsDecode   (PackBitsDecode??)
; ARGS:
;   stack +4: src
;   stack +8: dst
;   stack +12: dstLen
; RET:
;   D0: src pointer after decoding
; CLOBBERS:
;   D0-D1, D6-D7, A0-A1
; CALLS:
;   (none)
; READS:
;   [src]
; WRITES:
;   [dst]
; DESC:
;   Decodes PackBits-style RLE from src into dst.
; NOTES:
;   Positive counts copy literal bytes; negative counts repeat next byte.
;------------------------------------------------------------------------------
ESQ_PackBitsDecode:
LAB_00CD:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    MOVE.L  12(A7),D0

    MOVEQ   #0,D1
    MOVE.L  D7,-(A7)
    MOVE.L  D6,-(A7)

.decode_loop:
    CMP.W   D0,D1
    BGE.W   .done

    MOVE.B  (A0)+,D7
    TST.B   D7
    BMI.W   .repeat_run

    ADDQ.B  #1,D7

.copy_literals:
    TST.B   D7
    BLE.S   .decode_loop

    MOVE.B  (A0)+,(A1)+
    ADDQ.W  #1,D1
    CMP.W   D0,D1
    BGE.W   .done

    SUBQ.B  #1,D7
    BRA.S   .copy_literals

.repeat_run:
    EXT.W   D7
    EXT.L   D7
    CMPI.L  #$ff,D7
    BEQ.S   .decode_loop

    NEG.L   D7
    ADDQ.L  #1,D7
    MOVE.B  (A0)+,D6

.repeat_byte:
    TST.B   D7
    BLE.S   .decode_loop

    MOVE.B  D6,(A1)+
    ADDQ.W  #1,D1
    CMP.W   D0,D1
    BGE.W   .done

    SUBQ.B  #1,D7
    BRA.S   .repeat_byte

.done:
    MOVE.L  A0,D0
    MOVE.L  (A7)+,D6
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_TickGlobalCounters   (TickGlobalCounters??)
; ARGS:
;   (none)
; RET:
;   D0: 0
; CLOBBERS:
;   D0-D1, A0-A1
; CALLS:
;   ESQ_ColdReboot, LAB_0C82, LAB_0A4A
; READS:
;   LAB_2363, LAB_2205, LAB_2325, LAB_234A, LAB_22A5, LAB_22AA, LAB_22AB
; WRITES:
;   LAB_2363, LAB_2205, LAB_2264, LAB_2325, LAB_234A, LAB_22A5, LAB_1DDF,
;   LAB_1B11..LAB_1B18
; DESC:
;   Increments global timing counters, performs periodic resets, and updates
;   accumulator fields with saturation flags.
; NOTES:
;   Triggers ESQ_ColdReboot when LAB_2363 reaches $5460.
;------------------------------------------------------------------------------
ESQ_TickGlobalCounters:
LAB_00D3:
    MOVE.W  LAB_2363,D0
    ADDQ.W  #1,D0
    CMPI.W  #$5460,D0
    BNE.S   LAB_00D4

    JSR     ESQ_ColdReboot

LAB_00D4:
    MOVE.W  D0,LAB_2363
    JSR     LAB_0C82

    MOVE.W  LAB_2205,D0
    ADDQ.W  #1,D0
    MOVEQ   #60,D1
    CMP.W   D1,D0
    BNE.W   LAB_00D8

    MOVE.W  D0,LAB_2264
    MOVE.W  LAB_2325,D0
    BMI.W   LAB_00D5

    SUBQ.W  #1,D0
    MOVE.W  D0,LAB_2325

LAB_00D5:
    MOVE.W  LAB_234A,D0
    BMI.W   LAB_00D6

    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_234A

LAB_00D6:
    MOVE.W  LAB_22A5,D0
    BMI.W   LAB_00D7

    BEQ.W   LAB_00D7

    SUBQ.W  #1,D0
    MOVE.W  D0,LAB_22A5
    BNE.W   LAB_00D7

    MOVE.W  #1,LAB_1DDF

LAB_00D7:
    LEA     LAB_1B06,A0
    MOVEA.L (A0),A1
    MOVE.W  12(A1),D1
    ADDQ.W  #1,D1
    MOVE.W  D1,12(A1)
    LEA     LAB_1B07,A0
    MOVEA.L (A0),A1
    MOVE.W  12(A1),D1
    ADDQ.W  #1,D1
    MOVE.W  D1,12(A1)
    MOVEQ   #0,D0

LAB_00D8:
    MOVE.W  D0,LAB_2205
    TST.W   LAB_22AA
    BEQ.W   LAB_00E0

    MOVE.W  LAB_1B0D,D0
    BEQ.S   LAB_00DA

    MOVE.W  LAB_1B11,D1
    ADD.W   D0,D1
    CMPI.W  #$4000,D1
    BLT.S   LAB_00D9

    MOVE.W  #1,LAB_1B15
    MOVEQ   #0,D1

LAB_00D9:
    MOVE.W  D1,LAB_1B11

LAB_00DA:
    MOVE.W  LAB_1B0E,D0
    BEQ.S   LAB_00DC

    MOVE.W  LAB_1B12,D1
    ADD.W   D0,D1
    CMPI.W  #$4000,D1
    BLT.S   LAB_00DB

    MOVE.W  #1,LAB_1B16
    MOVEQ   #0,D1

LAB_00DB:
    MOVE.W  D1,LAB_1B12

LAB_00DC:
    MOVE.W  LAB_1B0F,D0
    BEQ.S   LAB_00DE

    MOVE.W  LAB_1B13,D1
    ADD.W   D0,D1
    CMPI.W  #$4000,D1
    BLT.S   LAB_00DD

    MOVE.W  #1,LAB_1B17
    MOVEQ   #0,D1

LAB_00DD:
    MOVE.W  D1,LAB_1B13

LAB_00DE:
    MOVE.W  LAB_1B10,D0
    BEQ.S   LAB_00E0

    MOVE.W  LAB_1B14,D1
    ADD.W   D0,D1
    CMPI.W  #$4000,D1
    BLT.S   LAB_00DF

    MOVE.W  #1,LAB_1B18
    MOVEQ   #0,D1

LAB_00DF:
    MOVE.W  D1,LAB_1B14

LAB_00E0:
    TST.W   LAB_22AB
    BEQ.W   LAB_00E1

    JSR     LAB_0A4A

LAB_00E1:
    MOVEQ   #0,D0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_SeedMinuteEventThresholds   (SeedMinuteEventThresholds??)
; ARGS:
;   stack +4: baseMinute
;   stack +8: baseOffset
; RET:
;   (none)
; CLOBBERS:
;   D0-D2
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   LAB_1B09, LAB_1B0A, LAB_1B0B, LAB_1B0C
; DESC:
;   Computes minute thresholds based on two base values.
; NOTES:
;   Stores (60-base), (30-base), (baseOffset), (baseOffset+30).
;------------------------------------------------------------------------------
ESQ_SeedMinuteEventThresholds:
LAB_00E2:
    MOVE.L  4(A7),D0
    MOVE.L  8(A7),D1
    MOVEQ   #60,D2
    SUB.W   D0,D2
    MOVE.W  D2,LAB_1B0A
    MOVEQ   #30,D2
    SUB.W   D0,D2
    MOVE.W  D2,LAB_1B09
    MOVEQ   #0,D2
    ADD.W   D1,D2
    MOVE.W  D2,LAB_1B0C
    MOVEQ   #30,D2
    ADD.W   D1,D2
    MOVE.W  D2,LAB_1B0B
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_ColdReboot   (ColdRebootOrSupervisor??)
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
ESQ_ColdReboot:
    MOVEA.L AbsExecBase,A6
    CMPI.W  #$24,20(A6)
    BLT.S   ESQ_ColdRebootViaSupervisor

    JMP     _LVOColdReboot(A6)

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_ColdRebootViaSupervisor   (ColdRebootViaSupervisor??)
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
    LEA     ESQ_SupervisorColdReboot(PC),A5
    JSR     _LVOSupervisor(A6)

;!======

    ; Alignment
    ALIGN_WORD

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_SupervisorColdReboot   (SupervisorColdReboot??)
; ARGS:
;   (none)
; RET:
;   none (does not return)
; CLOBBERS:
;   D0/D1/A0
; CALLS:
;   (none)
; READS:
;   [$00FFFFEC]??, [A0+4]??
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
    SUBA.L  -20(A0),A0  ; [0x00FFFFEC] = ?? (ROM base offset?)
    MOVEA.L 4(A0),A0    ; [A0+4] = reset vector?? (to be jumped to)
    SUBQ.L  #2,A0       ; Adjust vector address (align/format?) ??
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
; FUNC: ESQ_TryRomWriteTest   (TryRomWriteTest??)
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
LAB_00E6:
    MOVEQ   #1,D0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_InvokeGcommandInit   (InvokeGcommandInit??)
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
LAB_00E7:
    MOVEM.L A0-A1,-(A7)
    JSR     GCOMMAND_ProcessCtrlCommand

    ADDQ.L  #8,A7
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_DrawVerticalBevel   (DrawVerticalBevel??)
; ARGS:
;   stack +4: rastPort
;   stack +8: x
;   stack +12: y
;   stack +16: height
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A3, A6
; CALLS:
;   graphics.library Move/Draw/SetDrMd/SetAPen
; READS:
;   (none)
; WRITES:
;   RastPort
; DESC:
;   Draws a multi-line vertical beveled edge at x/y with pen 1.
; NOTES:
;   Repeats offset strokes to create a thicker edge.
;------------------------------------------------------------------------------
ESQ_DrawVerticalBevel:
LAB_00E8:
    LINK.W  A5,#-4
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    MOVE.L  20(A5),D5

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L A3,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVE.W  #(-1),34(A3)
    BSET    #0,33(A3)
    MOVE.B  #15,30(A3)
    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVE.L  D5,D0
    SUBQ.L  #1,D0
    MOVEA.L A3,A1
    MOVE.L  D6,D1
    JSR     _LVODraw(A6)

    MOVE.W  #(-1),34(A3)
    BSET    #0,33(A3)
    MOVE.B  #15,30(A3)
    MOVE.L  D6,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,16(A7)
    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  16(A7),D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVE.L  D5,D0
    SUBQ.L  #2,D0
    MOVE.L  D6,D1
    ADDQ.L  #1,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.W  #(-1),34(A3)
    BSET    #0,33(A3)
    MOVE.B  #15,30(A3)
    MOVE.L  D6,D0
    ADDQ.L  #2,D0
    MOVE.L  D0,16(A7)
    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  16(A7),D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVE.L  D5,D0
    SUBQ.L  #3,D0
    MOVE.L  D6,D1
    ADDQ.L  #2,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.W  #(-1),34(A3)
    BSET    #0,33(A3)
    MOVE.B  #15,30(A3)
    MOVE.L  D6,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,16(A7)
    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  16(A7),D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVE.L  D5,D0
    SUBQ.L  #4,D0
    MOVE.L  D6,D1
    ADDQ.L  #3,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======

; The moves and draws seem like this is making some kind of
; outlined box... maybe with a shadow or bevel?
;------------------------------------------------------------------------------
; FUNC: ESQ_DrawVerticalBevelPair   (DrawVerticalBevelPair??)
; ARGS:
;   stack +4: rastPort
;   stack +8: leftX
;   stack +12: topY
;   stack +16: rightX
;   stack +20: bottomY
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A3, A6
; CALLS:
;   graphics.library Move/Draw/SetDrMd/SetAPen
; READS:
;   (none)
; WRITES:
;   RastPort
; DESC:
;   Draws two vertical beveled edges using pen 1 and pen 2.
; NOTES:
;   Offsets by +/-1..3 to thicken edges.
;------------------------------------------------------------------------------
ESQ_DrawVerticalBevelPair:
LAB_00E9:
    MOVEM.L D4-D7/A3,-(A7)

    MOVEA.L 24(A7),A3
    MOVE.L  28(A7),D7
    MOVE.L  32(A7),D6
    MOVE.L  36(A7),D5
    MOVE.L  40(A7),D4

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L A3,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVE.W  #(-1),34(A3)
    BSET    #0,33(A3)
    MOVE.B  #$f,30(A3)

    MOVEA.L A3,A1
    MOVE.L  D7,D0               ; x
    MOVE.L  D6,D1               ; y
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  D4,D1               ; y
    JSR     _LVODraw(A6)

    MOVE.L  D7,D0

    ADDQ.L  #1,D0               ; x
    MOVEA.L A3,A1               ; rastport
    MOVE.L  D6,D1               ; y
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVEA.L A3,A1
    MOVE.L  D4,D1
    JSR     _LVODraw(A6)

    MOVE.L  D7,D0
    ADDQ.L  #2,D0               ; x
    MOVEA.L A3,A1               ; rastport
    MOVE.L  D6,D1               ; y
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    ADDQ.L  #2,D0
    MOVEA.L A3,A1
    MOVE.L  D4,D1
    JSR     _LVODraw(A6)

    MOVE.L  D7,D0               ; x = D7
    ADDQ.L  #3,D0               ; x = x + 3
    MOVEA.L A3,A1               ; rastport
    MOVE.L  D6,D1               ; y = D1
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    ADDQ.L  #3,D0
    MOVEA.L A3,A1
    MOVE.L  D4,D1
    JSR     _LVODraw(A6)

    MOVEA.L A3,A1               ; rastport
    MOVEQ   #2,D0               ; pen number
    JSR     _LVOSetAPen(A6)

    MOVE.W  #(-1),34(A3)
    BSET    #0,33(A3)
    MOVE.B  #$f,30(A3)

    MOVEA.L A3,A1               ; rastport
    MOVE.L  D5,D0               ; x
    MOVE.L  D4,D1               ; y
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVE.L  D5,D0
    MOVE.L  D6,D1
    JSR     _LVODraw(A6)

    MOVE.L  D5,D0
    SUBQ.L  #1,D0
    MOVEA.L A3,A1
    MOVE.L  D4,D1
    JSR     _LVOMove(A6)

    MOVE.L  D5,D0
    SUBQ.L  #1,D0
    MOVEA.L A3,A1
    MOVE.L  D6,D1
    JSR     _LVODraw(A6)

    MOVE.L  D5,D0
    SUBQ.L  #2,D0
    MOVEA.L A3,A1
    MOVE.L  D4,D1
    JSR     _LVOMove(A6)

    MOVE.L  D5,D0
    SUBQ.L  #2,D0
    MOVEA.L A3,A1
    MOVE.L  D6,D1
    JSR     _LVODraw(A6)

    MOVE.L  D5,D0               ; x = D5
    SUBQ.L  #3,D0               ; x = x - 3
    MOVEA.L A3,A1               ; rastport
    MOVE.L  D4,D1               ; y
    JSR     _LVOMove(A6)

    MOVE.L  D5,D0               ; x = D5
    SUBQ.L  #3,D0               ; x = x - 3
    MOVEA.L A3,A1               ; rastport
    MOVE.L  D6,D1               ; y = D6
    JSR     _LVODraw(A6)

    MOVEM.L (A7)+,D4-D7/A3
    RTS

;!======

; drawing some lines
;------------------------------------------------------------------------------
; FUNC: ESQ_DrawHorizontalBevel   (DrawHorizontalBevel??)
; ARGS:
;   stack +4: rastPort
;   stack +8: leftX
;   stack +12: rightX
;   stack +16: y
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A3, A6
; CALLS:
;   graphics.library Move/Draw/SetDrMd/SetAPen
; READS:
;   (none)
; WRITES:
;   RastPort
; DESC:
;   Draws a multi-line horizontal beveled edge at y with pen 2.
; NOTES:
;   Repeats offset strokes to create a thicker edge.
;------------------------------------------------------------------------------
ESQ_DrawHorizontalBevel:
LAB_00EA:
    LINK.W  A5,#-4
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  20(A5),D6
    MOVE.L  24(A5),D5

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L A3,A1
    MOVEQ   #2,D0
    JSR     _LVOSetAPen(A6)

    MOVE.W  #(-1),34(A3)
    BSET    #0,33(A3)
    MOVE.B  #$f,30(A3)
    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVE.L  D5,D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  D5,D1
    JSR     _LVODraw(A6)

    MOVE.L  D5,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,16(A7)
    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVE.L  16(A7),D1
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVE.L  D5,D1
    SUBQ.L  #1,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.L  D5,D0
    SUBQ.L  #2,D0
    MOVE.L  D0,16(A7)
    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVE.L  16(A7),D1
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    ADDQ.L  #2,D0
    MOVE.L  D5,D1
    SUBQ.L  #2,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.L  D5,D0
    SUBQ.L  #3,D0
    MOVE.L  D0,16(A7)
    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVE.L  16(A7),D1
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    ADDQ.L  #3,D0
    MOVE.L  D5,D1
    SUBQ.L  #3,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVEA.L A3,A1
    MOVEQ   #6,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVE.L  D5,D1
    JSR     _LVOMove(A6)

    MOVE.L  D6,D0
    SUBQ.L  #3,D0
    MOVE.L  D5,D1
    SUBQ.L  #3,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_DrawBeveledFrame   (DrawBeveledFrame??)
; ARGS:
;   stack +4: rastPort
;   stack +8: leftX
;   stack +12: topY
;   stack +16: rightX
;   stack +20: bottomY
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A3
; CALLS:
;   ESQ_DrawVerticalBevelPair, ESQ_DrawVerticalBevel
; READS:
;   (none)
; WRITES:
;   RastPort
; DESC:
;   Draws a beveled frame with left/right edges and a corner accent.
; NOTES:
;   Composes LAB_00E9 + LAB_00E8 helpers.
;------------------------------------------------------------------------------
ESQ_DrawBeveledFrame:
LAB_00EB:
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVE.L  28(A7),D7
    MOVE.L  32(A7),D6
    MOVE.L  36(A7),D5
    MOVE.L  40(A7),D4

    MOVE.L  D4,-(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   ESQ_DrawVerticalBevelPair

    MOVE.L  D4,(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   ESQ_DrawVerticalBevel

    LEA     36(A7),A7

    MOVEA.L A3,A1
    MOVEQ   #2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    ADDQ.L  #3,D0
    MOVE.L  D6,D1
    ADDQ.L  #3,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVEM.L (A7)+,D4-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_DrawBevelFrameWithTop   (DrawBevelFrameWithTop??)
; ARGS:
;   stack +4: rastPort
;   stack +8: leftX
;   stack +12: topY
;   stack +16: rightX
;   stack +20: bottomY
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A3
; CALLS:
;   ESQ_DrawVerticalBevelPair, ESQ_DrawHorizontalBevel
; READS:
;   (none)
; WRITES:
;   RastPort
; DESC:
;   Draws a beveled frame with a top horizontal edge.
; NOTES:
;   Composes LAB_00E9 + LAB_00EA helpers.
;------------------------------------------------------------------------------
ESQ_DrawBevelFrameWithTop:
LAB_00EC:
    MOVEM.L D4-D7/A3,-(A7)

    MOVEA.L 24(A7),A3
    MOVE.L  28(A7),D7
    MOVE.L  32(A7),D6
    MOVE.L  36(A7),D5
    MOVE.L  40(A7),D4
    MOVE.L  D4,-(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   ESQ_DrawVerticalBevelPair

    MOVE.L  D4,(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   ESQ_DrawHorizontalBevel

    LEA     36(A7),A7

    MOVEM.L (A7)+,D4-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_DrawBevelFrameWithTopRight   (DrawBevelFrameWithTopRight??)
; ARGS:
;   stack +4: rastPort
;   stack +8: leftX
;   stack +12: topY
;   stack +16: rightX
;   stack +20: bottomY
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A3
; CALLS:
;   ESQ_DrawBeveledFrame, ESQ_DrawHorizontalBevel
; READS:
;   (none)
; WRITES:
;   RastPort
; DESC:
;   Draws a beveled frame plus a top edge and right-side accent.
; NOTES:
;   Composes LAB_00EB + LAB_00EA helpers.
;------------------------------------------------------------------------------
ESQ_DrawBevelFrameWithTopRight:
LAB_00ED:
    MOVEM.L D4-D7/A3,-(A7)

    MOVEA.L 24(A7),A3
    MOVE.L  28(A7),D7
    MOVE.L  32(A7),D6
    MOVE.L  36(A7),D5
    MOVE.L  40(A7),D4
    MOVE.L  D4,-(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   ESQ_DrawBeveledFrame

    MOVE.L  D4,(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   ESQ_DrawHorizontalBevel

    LEA     36(A7),A7

    MOVEM.L (A7)+,D4-D7/A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

    include "subroutines/image/process_ilbm_image.s"

    include "modules/brush.s"

    include "modules/cleanup.s"

    include "modules/coi.s"

    include "modules/ctasks.s"

    include "modules/diskio.s"

    include "modules/diskio2.s"

    include "modules/displib.s"

    include "modules/disptext.s"

    include "modules/dst.s"

    include "modules/ed2.s"

    include "modules/esq.s"

    include "modules/esqdisp.s"

    include "modules/esqfunc.s"

    include "modules/esqiff.s"

    include "modules/esqpars.s"

    include "modules/esqpars2.s"

    include "modules/flib.s"

    include "modules/gcommand.s"

    include "modules/kybd.s"

    include "modules/ladfunc.s"

    include "modules/locavail.s"

    include "modules/newgrid.s"

    include "modules/newgrid2.s"

    include "modules/p_type.s"

    include "modules/parseini.s"

    include "modules/script.s"

    include "modules/textdisp.s"

    include "modules/tliba1.s"

    include "modules/wdisp.s"

    SECTION S_1,DATA,CHIP
    include "data/common.s"

    include "data/brush.s"

    include "data/cleanup.s"

    include "data/clock.s"

    include "data/coi.s"

    include "data/ctasks.s"

    include "data/diskio.s"

    include "data/diskio2.s"

    include "data/displib.s"

    include "data/disptext.s"

    include "data/dst.s"

    include "data/ed2.s"

    include "data/esq.s"

    include "data/esqdisp.s"

    include "data/esqfunc.s"

    include "data/esqiff.s"

    include "data/esqpars.s"

    include "data/esqpars2.s"

    include "data/flib.s"

    include "data/gcommand.s"

    include "data/kybd.s"

    include "data/ladfunc.s"

    include "data/locavail.s"

    include "data/newgrid.s"

    include "data/newgrid2.s"

    include "data/p_type.s"

    include "data/parseini.s"

    include "data/script.s"

    include "data/textdisp.s"

    include "data/tliba1.s"

    include "data/wdisp.s"
