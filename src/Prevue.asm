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

    include "modules/app.s"
    include "modules/app2.s"
    include "modules/app3.s"

    include "modules/bevel.s"

    include "subroutines/image/process_ilbm_image.s"

    include "modules/brush.s"

    include "modules/cleanup.s"
    include "modules/cleanup2.s"
    include "modules/cleanup3.s"
    include "modules/cleanup4.s"

    include "modules/coi.s"

    include "modules/ctasks.s"

    include "modules/diskio.s"
    include "modules/diskio2.s"

    include "modules/displib.s"

    include "modules/disptext.s"
    include "modules/disptext2.s"

    include "modules/dst.s"

    include "modules/ed.s"
    include "modules/ed2.s"
    include "modules/ed3.s"

    include "modules/esq.s"

    include "modules/esqdisp.s"

    include "modules/esqfunc.s"

    include "modules/esqiff.s"
    include "modules/esqiff2.s"

    include "modules/esqpars.s"
    include "modules/esqpars2.s"
    include "modules/esqpars3.s"

    include "modules/flib.s"
    include "modules/flib2.s"

    include "modules/gcommand.s"
    include "modules/gcommand2.s"
    include "modules/gcommand3.s"
    include "modules/gcommand4.s"
    include "modules/gcommand5.s"

    include "modules/kybd.s"

    include "modules/ladfunc.s"
    include "modules/ladfunc2.s"

    include "modules/locavail.s"
    include "modules/locavail2.s"

    include "modules/newgrid.s"
    include "modules/newgrid1.s"
    include "modules/newgrid2.s"

    include "modules/p_type.s"

    include "modules/parseini.s"

    include "modules/script.s"
    include "modules/script2.s"
    include "modules/script3.s"
    include "modules/script4.s"

    include "modules/textdisp.s"
    include "modules/textdisp2.s"
    include "modules/textdisp3.s"

    include "modules/tliba1.s"
    include "modules/tliba2.s"
    include "modules/tliba3.s"

    include "modules/wdisp.s"

    include "modules/submod/unknown.s"
    include "modules/submod/unknown2.s"
    include "modules/submod/unknown3.s"
    include "modules/submod/unknown4.s"
    include "modules/submod/unknown5.s"
    include "modules/submod/unknown6.s"
    include "modules/submod/unknown7.s"
    include "modules/submod/unknown8.s"
    include "modules/submod/unknown9.s"
    include "modules/submod/unknown10.s"
    include "modules/submod/unknown11.s"
    include "modules/submod/unknown12.s"
    include "modules/submod/unknown13.s"
    include "modules/submod/unknown14.s"
    include "modules/submod/unknown15.s"
    include "modules/submod/unknown16.s"
    include "modules/submod/unknown17.s"
    include "modules/submod/unknown18.s"
    include "modules/submod/unknown19.s"
    include "modules/submod/unknown20.s"
    include "modules/submod/unknown21.s"
    include "modules/submod/unknown22.s"
    include "modules/submod/unknown23.s"
    include "modules/submod/unknown24.s"
    include "modules/submod/unknown25.s"
    include "modules/submod/unknown26.s"
    include "modules/submod/unknown27.s"
    include "modules/submod/unknown28.s"
    include "modules/submod/unknown29.s"
    include "modules/submod/unknown30.s"
    include "modules/submod/unknown31.s"
    include "modules/submod/unknown32.s"
    include "modules/submod/unknown33.s"
    include "modules/submod/unknown34.s"
    include "modules/submod/unknown35.s"
    include "modules/submod/unknown36.s"
    include "modules/submod/unknown37.s"
    include "modules/submod/unknown38.s"
    include "modules/submod/unknown39.s"
    include "modules/submod/unknown40.s"
    include "modules/submod/unknown41.s"
    include "modules/submod/unknown42.s"

;!================
; Data Section
;!================

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
