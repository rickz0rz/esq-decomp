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

SECSTRT_0:                                  ; PC: 0021EE58
    MOVEM.L D1-D6/A0-A6,-(A7)               ; Backup registers to the stack

    MOVEA.L A0,A2                           ; A0 is a pointer to the command string at startup, copy to A2
    MOVE.L  D0,D2                           ; D0 is the length of the command string at startup, copy to D2
    LEA     GLOB_REF_LONG_FILE_SCRATCH,A4   ; Copy address of GLOB_REF_LONG_FILE_SCRATCH into A4 (0x3BB24) - 00017118
    MOVEA.L AbsExecBase.W,A6                ; 00000004 but this address is dynamically translated at runtime to 002007a0 (confirmed by checking exec.library when dumping libs in fs-uae)
    LEA     BUFFER_5929_LONGWORDS,A3        ; 00016e80
    MOVEQ   #0,D1
    MOVE.L  #5929,D0
    BRA.S   .5929BufferCounterCompare

.copyByteFromD1To5929Buffer:
    MOVE.L  D1,(A3)+                        ; Copy longword 0 into A3 (BUFFER_5929_LONGWORDS) addr and increment to zero that memory.

.5929BufferCounterCompare:
    DBF     D0,.copyByteFromD1To5929Buffer  ; If our counter (D1) is not zero then jump to .copyByteFromD1To5929Buffer else continue

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
    BNE.S   .successfullyMadeLocalDOSLib    ; Jump to .successfullyMadeLocalDOSLib if D0 is not 0 (D0 is the addr returned, 0 = didn't load)

    MOVEQ   #100,D0                         ; If it wasn't opened, set D0 to 100...
    BRA.W   LAB_000A                        ; and jump to LAB_000A

.successfullyMadeLocalDOSLib:
    MOVEA.L Struct_ExecBase__ThisTask(A6),A3                                                                ; A6 002007a0 + 276 = 002008b4 (ThisTask pointer) into A3: MOVEA.L (A6, $0114) == $002008b4,A3
    MOVE.L  ((Struct_ExecBase__TaskWait-Struct_ExecBase__ThisTask)+Struct_List__lh_TailPred)(A3),-612(A4)   ; Move the address at A3 002008b4 + 152 = 00200A06 and move it's value in to -612(A4): MOVE.L (A3, $0098) == $0021e170,(A4, -$0264) == $00016eb4 [0021EEB2]
    TST.L   (Struct_ExecBase__SoftInts-Struct_ExecBase__ThisTask)+(Struct_SoftIntList__sh_Pad)(A3)          ; This is checking SoftInts[1] (starting at zero)
    BEQ.S   .LAB_0005

    MOVE.L  A7,D0
    SUB.L   4(A7),D0
    ADDI.L  #128,D0
    MOVE.L  D0,-660(A4)
    MOVEA.L ((Struct_ExecBase__SoftInts-Struct_ExecBase__ThisTask)+Struct_SoftIntList__sh_Pad)(A3),A0       ; Again, like above. SoftInts[1]
    ADDA.L  A0,A0
    ADDA.L  A0,A0
    MOVEA.L 16(A0),A1
    ADDA.L  A1,A1
    ADDA.L  A1,A1
    MOVE.L  D2,D0
    MOVEQ   #0,D1
    MOVE.B  (A1)+,D1
    MOVE.L  A1,-592(A4)
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

.LAB_0003:
    MOVE.B  0(A2,D0.W),0(A7,D2.W)
    SUBQ.L  #1,D2
    DBF     D0,.LAB_0003

    MOVE.B  #$20,0(A7,D2.W)
    SUBQ.L  #1,D2

.LAB_0004:
    MOVE.B  0(A1,D2.W),0(A7,D2.W)
    DBF     D2,.LAB_0004

    MOVEA.L A7,A1
    MOVE.L  A1,-(A7)
    BRA.S   .LAB_0008

.LAB_0005:
    MOVE.L  58(A3),-660(A4)
    MOVEQ   #127,D0 ; ...
    ADDQ.L  #1,D0   ; 128 into D0
    ADD.L   D0,-660(A4)

    LEA     92(A3),A0
    JSR     _LVOWaitPort(A6) ; A6 should still have AbsExecBase in it at this point

    LEA     92(A3),A0
    JSR     _LVOGetMsg(A6)

    MOVE.L  D0,savedMsg(A4)
    MOVE.L  D0,-(A7)
    MOVEA.L D0,A2
    MOVE.L  36(A2),D0
    BEQ.S   .LAB_0006

    MOVEA.L LocalDosLibraryDisplacement(A4),A6
    MOVEA.L D0,A0
    MOVE.L  0(A0),D1
    MOVE.L  D1,-612(A4)
    JSR     _LVOCurrentDir(A6)

.LAB_0006:
    MOVE.L  32(A2),D1
    BEQ.S   .LAB_0007

    MOVE.L  #1005,D2
    JSR     _LVOSupervisor(A6)

    MOVE.L  D0,-596(A4)
    BEQ.S   .LAB_0007

    LSL.L   #2,D0
    MOVEA.L D0,A0
    MOVE.L  8(A0),164(A3)

.LAB_0007:
    MOVEA.L -604(A4),A0
    MOVE.L  A0,-(A7)
    PEA     -664(A4)
    MOVEA.L 36(A0),A0
    MOVE.L  4(A0),-592(A4)

.LAB_0008:
    JSR     LAB_0010(PC)

    JSR     LAB_0012(PC)

    MOVEQ   #0,D0
    BRA.S   LAB_000A

;!======

LAB_0009:
    MOVE.L  4(A7),D0

LAB_000A:
    MOVE.L  D0,-(A7)
    MOVE.L  -620(A4),D0
    BEQ.S   .LAB_000B

    MOVEA.L D0,A0
    JSR     (A0)

.LAB_000B:
    JSR     LAB_0011(PC)

    MOVEA.L AbsExecBase,A6
    MOVEA.L LocalDosLibraryDisplacement(A4),A1
    JSR     _LVOCloseLibrary(A6)

    JSR     LAB_000F(PC)

    TST.L   savedMsg(A4)
    BEQ.S   .restoreRegistersAndTerminate

    MOVE.L  -596(A4),D1
    BEQ.S   .LAB_000C

    JSR     _LVOexecPrivate1(A6) ; this might be inaccurate?

.LAB_000C:
    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    MOVEA.L savedMsg(A4),A1
    JSR     _LVOReplyMsg(A6)

.restoreRegistersAndTerminate:
    MOVE.L  (A7)+,D0
    MOVEA.L savedStackPointer(A4),A7
    MOVEM.L (A7)+,D1-D6/A0-A6
    RTS

;!======

LOCAL_STR_DOS_LIBRARY:
    NStr    "dos.library"

LAB_000F:
    JMP     LAB_1910

LAB_0010:
    JMP     LAB_190F

LAB_0011:
    JMP     LAB_1A26

LAB_0012:
    JMP     LAB_1A76

;!======

; If the system has at least 600,000 bytes of fast memory, keep HAS_REQUESTED_FAST_MEMORY set to 0.
; Otherwise, set it to 1.
CHECK_AVAILABLE_FAST_MEMORY:

.desiredMemory  = 600000

    MOVEQ   #2,D1                           ; Set 2 to D1...
    MOVEA.L AbsExecBase,A6                  ; Check the available memory for type 2 (fast memory) in D1, and
    JSR     _LVOAvailMem(A6)                ; store the result in D0.

    CMPI.L  #(.desiredMemory),D0            ; See if we have more than 600,000 bytes of available memory
    BGE.S   .skipFastMemorySet              ; If we have equal to or more than our target, jump to .skipFastMemorySet

    MOVE.W  #1,HAS_REQUESTED_FAST_MEMORY    ; Set HAS_REQUESTED_FAST_MEMORY to 0x0001 (it's 0x0000 by default)

.skipFastMemorySet:
    RTS

;!======

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
    BEQ.S   .return                     ; If equal, jump to .return

    CMPI.W  #$2000,D6                   ; Compare it with high byte of $2000 (00110000 00000000) aka $20 to see if we're chip 2
    BEQ.S   .return                     ; If equal, jump to .return

    CMPI.W  #$3300,D6                   ; Compare it with high byte of $3300 (00110011 00000000) aka $33 to see if we're chip 3
    BEQ.S   .return                     ; If equal, jump to .return

    MOVE.W  #1,IS_COMPATIBLE_VIDEO_CHIP ; Set $0001 (true) into IS_COMPATIBLE_VIDEO_CHIP

.return:
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

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
    BNE.W   .LAB_001C

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
.softLockAtAttentionSystemEngineer:
    BRA.S   .softLockAtAttentionSystemEngineer

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

    BRA.S   .LAB_001D

.LAB_001C:
    PEA     GLOB_STR_YOU_CANNOT_RE_RUN_THE_SOFTWARE
    JSR     JMP_TBL_LAB_1911(PC)

    CLR.L   (A7)
    JSR     JMP_TBL_LIBRARIES_LOAD_FAILED_1(PC)

    ADDQ.W  #4,A7

.LAB_001D:
    MOVEM.L (A7)+,D2-D7
    UNLK    A5
    RTS

;!======

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
    BRA.S   .LAB_0020

.createDiskIsFullMessage:
    PEA     LAB_1AF6
    JSR     LAB_03C0(PC)

    MOVE.L  D0,D7
    MOVE.L  D7,(A7)
    PEA     GLOB_STR_DISK_IS_FULL_FORMATTED
    PEA     LAB_2249
    JSR     JMP_TBL_PRINTF_1(PC)

    LEA     .stackOffsetBytes+4(A7),A7

.LAB_0020:
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

INTB_RBF_EXEC:
    MOVEQ   #0,D0
    MOVE.W  GLOB_WORD_H_VALUE,D0
    ADDA.L  D0,A1
    MOVE.W  24(A0),D1
    MOVE.B  D1,(A1)
    BTST    #15,D1
    BEQ.S   .LAB_0026

    MOVE.W  LAB_228A,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,LAB_228A

.LAB_0026:
    ADDQ.W  #1,D0
    CMPI.W  #$fa00,D0
    BNE.S   .LAB_0027

    MOVEQ   #0,D0

.LAB_0027:
    MOVE.W  D0,GLOB_WORD_H_VALUE
    MOVE.W  GLOB_WORD_T_VALUE,D1
    SUB.W   D1,D0
    BCC.W   .LAB_0028

    ADDI.W  #$fa00,D0

.LAB_0028:
    MOVE.W  D0,LAB_228C
    CMP.W   GLOB_WORD_MAX_VALUE,D0
    BCS.W   .LAB_0029

    MOVE.W  D0,GLOB_WORD_MAX_VALUE

.LAB_0029:
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

LAB_002B:
    MOVEQ   #0,D1
    MOVE.L  D1,D0
    MOVE.W  GLOB_WORD_T_VALUE,D1
    MOVEA.L GLOB_REF_INTB_RBF_64K_BUFFER,A0
    ADDA.L  D1,A0
    MOVE.B  (A0),D0
    ADDQ.W  #1,D1
    CMPI.W  #$fa00,D1
    BNE.S   .LAB_002C

    MOVEQ   #0,D1

.LAB_002C:
    MOVE.W  D1,GLOB_WORD_T_VALUE
    MOVE.L  D0,-(A7)
    MOVE.W  GLOB_WORD_H_VALUE,D0
    SUB.W   D1,D0
    BCC.W   .LAB_002D

    ADDI.W  #$fa00,D0

.LAB_002D:
    CMPI.W  #$102,LAB_1F45
    BNE.W   .LAB_002E

    CMPI.W  #$bb80,D0   ; Box off.
    BCC.W   .LAB_002E

    MOVE.W  #0,LAB_1F45

.LAB_002E:
    MOVE.L  (A7)+,D0
    RTS

;!======

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

LAB_0030:
    TST.W   LAB_1AFC
    BNE.S   LAB_0031

    JSR     GET_BIT_3_OF_CIAB_PRA_INTO_D1

    TST.B   D1
    BPL.W   LAB_003C

    ADDQ.W  #1,LAB_1AFC
    MOVE.W  #4,LAB_1AF9
    MOVE.W  #0,LAB_1AFD
    RTS

;!======

LAB_0031:
    MOVE.W  LAB_1AFC,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_1AFC
    MOVE.W  LAB_1AF9,D1
    CMP.W   D0,D1
    BGT.W   LAB_003C

    MOVEQ   #4,D1
    CMP.W   D1,D0
    BGT.W   LAB_0034

    JSR     GET_BIT_3_OF_CIAB_PRA_INTO_D1

    TST.B   D1
    BPL.S   LAB_0033

    MOVE.W  #14,LAB_1AF9
    MOVEQ   #7,D0
    LEA     LAB_1AFF,A5
    MOVEQ   #0,D1

.LAB_0032:
    MOVE.B  D1,(A5)+
    DBF     D0,.LAB_0032
    RTS

;!======

LAB_0033:
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_1AF9
    MOVE.W  D0,LAB_1AFD
    MOVE.W  D0,LAB_1AFC
    RTS

;!======

LAB_0034:
    MOVEQ   #94,D1
    CMP.W   D1,D0
    BGE.S   LAB_0035

    JSR     GET_BIT_3_OF_CIAB_PRA_INTO_D1

    LEA     LAB_1AFF,A5
    ADDA.W  LAB_1AFD,A5
    MOVE.B  D1,(A5)
    ADDQ.W  #1,LAB_1AFD
    ADDI.W  #10,LAB_1AF9
    RTS

;!======

LAB_0035:
    JSR     GET_BIT_3_OF_CIAB_PRA_INTO_D1

    TST.B   D1
    BMI.S   LAB_003B

    LEA     LAB_1AFF,A5
    ADDA.W  LAB_1AFD,A5
    MOVE.W  LAB_1AFD,D1
    SUBQ.W  #1,D1
    MOVEQ   #0,D0

LAB_0036:
    TST.B   -(A5)
    BMI.S   LAB_0037

    BSET    D1,D0
    BRA.S   LAB_0038

LAB_0037:
    BCLR    D1,D0

LAB_0038:
    DBF     D1,LAB_0036
    LEA     LAB_1B04,A1
    MOVE.W  LAB_1B03,D1
    ADDA.W  D1,A1
    MOVE.B  D0,(A1)
    BEQ.S   LAB_0039

    ADDQ.W  #1,D1
    CMPI.W  #5,D1
    BLT.S   LAB_003A

    MOVE.B  #0,(A1)

LAB_0039:
    JSR     LAB_0050

    MOVEQ   #0,D1

LAB_003A:
    MOVE.W  D1,LAB_1B03

LAB_003B:
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_1AF9
    MOVE.W  D0,LAB_1AFD
    MOVE.W  D0,LAB_1AFC

LAB_003C:
    RTS

;!======

GET_BIT_3_OF_CIAB_PRA_INTO_D1:
    MOVEQ   #0,D1           ; Copy 0 into D1 to clear all bytes
    MOVEA.L #CIAB_PRA,A5    ; Copy the address of CIAB_PRA into A5
    MOVE.B  (A5),D1         ; Get contents of the least significant byte at A5 and copy into D1
    BTST    #3,D1           ; Test bit 3, set Z to true if it's 0
    SEQ     D1              ; SEQ (set equal) sets D1 to 0 if Z is 0, otherwise 1 if it's 1
    RTS

;!======

GET_BIT_4_OF_CIAB_PRA_INTO_D1:
    MOVEQ   #0,D1           ; Copy 0 into D1 to clear all bytes
    MOVEA.L #CIAB_PRA,A5    ; Copy the address of CIAB_PRA into A5
    MOVE.B  (A5),D1         ; Get contents of the least significant byte at A5 and copy into D1
    BTST    #4,D1           ; Test bit 4, set Z to true if it's 0
    SEQ     D1              ; SEQ (set equal) sets D1 to 0 if Z is 0, otherwise 1 if it's 1
    RTS

;!======

callCTRL:
    MOVE.L  A5,-(A7)
    MOVE.L  A4,-(A7)

    JSR     readCTRL

    LEA     LAB_1DC8,A4
    MOVE.B  18(A4),D1
    CMPI.B  #"N",D1
    BNE.S   .LAB_0040

    JSR     LAB_0030(PC)

.LAB_0040:
    MOVEA.L #BLTDDAT,A0
    MOVE.W  #$100,(INTREQ-BLTDDAT)(A0)
    ; Looking at that, 0100 means bit 8 starting from the right as 0 is set
    ; so we're setting "Audio channel 1 block finished"

    MOVEA.L (A7)+,A4
    MOVEA.L (A7)+,A5
    RTS

;!======

readCTRL:
    TST.W   LAB_1AFA            ; Test LAB_1AFA...
    BNE.S   LAB_0042            ; and if it's not equal to zero, jump to LAB_0042

    JSR     GET_BIT_4_OF_CIAB_PRA_INTO_D1(PC)        ; Read the bit from CIAB_PRA and store bit 4's value in D1

    TST.B   D1                  ; Test the value (this cheaply is seeing if it's 1 or 0)
    BPL.W   LAB_004D            ; If it's 1, jump to LAB_004D (which is just RTS) so exit this subroutine.

    ADDQ.W  #1,LAB_1AFA
    MOVE.W  #4,LAB_1AF8
    MOVE.W  #0,LAB_1AFB
    RTS

;!======

LAB_0042:
    MOVE.W  LAB_1AFA,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_1AFA
    MOVE.W  LAB_1AF8,D1
    CMP.W   D0,D1
    BGT.W   LAB_004D

    MOVEQ   #4,D1
    CMP.W   D1,D0
    BGT.W   LAB_0045

    JSR     GET_BIT_4_OF_CIAB_PRA_INTO_D1(PC)

    TST.B   D1
    BPL.S   LAB_0044

    MOVE.W  #14,LAB_1AF8
    MOVEQ   #7,D0
    LEA     LAB_1AFE,A5
    MOVEQ   #0,D1

.LAB_0043:
    MOVE.B  D1,(A5)+
    DBF     D0,.LAB_0043

    RTS

;!======

LAB_0044:
    MOVEQ   #0,D0           ; Set D0 to 0
    MOVE.W  D0,LAB_1AF8     ; Set LAB_1AF8 to D0 (0)
    MOVE.W  D0,LAB_1AFB     ; Set LAB_1AFB to D0 (0)
    MOVE.W  D0,LAB_1AFA     ; Set LAB_1AFA to D0 (0)
    RTS

;!======

LAB_0045:
    MOVEQ   #94,D1              ; Move 94 ('^') into D1
    CMP.W   D1,D0
    BGE.S   LAB_0046

    JSR     GET_BIT_4_OF_CIAB_PRA_INTO_D1(PC)

    LEA     LAB_1AFE,A5
    ADDA.W  LAB_1AFB,A5
    MOVE.B  D1,(A5)
    ADDQ.W  #1,LAB_1AFB
    ADDI.W  #10,LAB_1AF8
    RTS

;!======

LAB_0046:
    JSR     GET_BIT_4_OF_CIAB_PRA_INTO_D1(PC)

    TST.B   D1
    BMI.S   .LAB_004C

    LEA     LAB_1AFE,A5
    ADDA.W  LAB_1AFB,A5
    MOVE.W  LAB_1AFB,D1
    SUBQ.W  #1,D1
    MOVEQ   #0,D0

.LAB_0047:
    TST.B   -(A5)
    BMI.S   .LAB_0048

    BSET    D1,D0
    BRA.S   .LAB_0049

.LAB_0048:
    BCLR    D1,D0

.LAB_0049:
    DBF     D1,.LAB_0047
    LEA     CTRL_BUFFER,A1
    MOVE.W  CTRL_H,D1
    ADDA.W  D1,A1
    MOVE.B  D0,(A1)+
    ADDQ.W  #1,D1
    CMPI.W  #$1f4,D1
    BNE.S   .LAB_004A

    MOVEQ   #0,D1

.LAB_004A:
    MOVE.W  D1,CTRL_H
    MOVE.W  D1,D0
    MOVE.W  LAB_2282,D1
    SUB.W   D1,D0
    BCC.W   .LAB_004B

    ADDI.W  #$1f4,D0

.LAB_004B:
    MOVE.W  D0,LAB_2284
    CMP.W   LAB_2283,D0
    BCS.W   .LAB_004C

    MOVE.W  D0,LAB_2283

.LAB_004C:
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_1AF8
    MOVE.W  D0,LAB_1AFB
    MOVE.W  D0,LAB_1AFA

LAB_004D:
    RTS

;!======

getCTRLBuffer:
    MOVEQ   #0,D1
    MOVE.L  D1,D0
    MOVE.W  LAB_2282,D1
    LEA     CTRL_BUFFER,A0
    ADDA.L  D1,A0
    MOVE.B  (A0),D0
    ADDQ.W  #1,D1
    CMPI.W  #$1f4,D1
    BNE.S   .LAB_004F

    MOVEQ   #0,D1

.LAB_004F:
    MOVE.W  D1,LAB_2282
    RTS

;!======

    ; Alignment
    DC.W    $0000

;!======

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
    BLT.S   .LAB_0052

    MOVEQ   #0,D0

.LAB_0052:
    MOVE.L  D0,LAB_231B
    MOVEM.L (A7)+,D0-D1/A0-A1
    RTS

;!======

LAB_0053:
    MOVE.B  #0,D0
    MOVE.B  #$3f,D1
    JSR     LAB_0058

    RTS

;!======

LAB_0054:
    MOVEA.L #CIAB_PRA,A1
    MOVE.B  (A1),D1
    BSET    #6,D1
    BSET    #7,D1
    MOVE.B  D1,(A1)
    MOVE.B  #$3f,D0
    MOVE.B  LAB_1B05,D1
    JSR     LAB_0058

    RTS

;!======

LAB_0055:
    MOVEA.L #CIAB_PRA,A1
    MOVE.B  (A1),D1
    BCLR    #6,D1
    BCLR    #7,D1
    MOVE.B  D1,(A1)
    MOVE.B  #$3f,D0
    MOVE.B  #$3f,D1
    JSR     LAB_0058

    RTS

;!======

LAB_0056:
    MOVEA.L #CIAB_PRA,A1
    MOVE.B  (A1),D1
    BCLR    #6,D1
    BSET    #7,D1
    MOVE.B  D1,(A1)
    MOVE.B  #0,D0
    MOVE.B  #0,D1
    JSR     LAB_0058

    JSR     LAB_0D6E

    RTS

;!======

LAB_0057:
    MOVEA.L #CIAB_PRA,A1
    MOVE.B  (A1),D1
    BSET    #6,D1
    BSET    #7,D1
    MOVE.B  D1,(A1)
    MOVE.B  #$3f,D0
    MOVE.B  #0,D1
    JSR     LAB_0058

    JSR     LAB_0D6D

    RTS

;!======

LAB_0058:
    MOVE.B  D0,LAB_1B01
    MOVE.B  D1,LAB_1B02
    MOVE.W  #5,LAB_1B00
    JSR     LAB_0059

    RTS

;!======

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
    BNE.S   .LAB_005A

    MOVEQ   #0,D0

.LAB_005A:
    ROL.L   #5,D0
    MOVEM.L D2-D4/A6,-(A7)
    MOVEA.W #$100,A6
    MOVE.W  D1,D3
    BCLR    #8,D3
    MOVEQ   #15,D4

.LAB_005B:
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
    DBF     D4,.LAB_005B

    MOVE.W  D1,(A0)
    MOVE.W  D1,(A1)
    MOVE.W  D1,136(A0)
    MOVE.W  D1,136(A1)
    MOVEM.L (A7)+,D2-D4/A6
    MOVEQ   #0,D0
    RTS

;!======

LAB_005C:
    RTS

;!======

    MOVE.B  #0,D0
    MOVE.B  D0,LAB_1E2B
    MOVE.B  D0,LAB_1E58
    RTS

;!======

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

.LAB_005E:
    CMP.W   D1,D2
    BMI.W   .LAB_0060

    MOVE.W  0(A1,D3.W),0(A1,D2.W)
    CMP.W   D2,D4
    BMI.W   .LAB_005F

    MOVE.W  0(A1,D3.W),0(A0,D2.W)

.LAB_005F:
    SUBI.W  #4,D2
    SUBI.W  #4,D3
    BRA.S   .LAB_005E

.LAB_0060:
    MOVE.W  D0,0(A1,D1.W)
    CMP.W   D2,D4
    BMI.W   .return

    BEQ.W   .return

    MOVE.W  D0,0(A0,D1.W)

.return:
    MOVEM.L (A7)+,D2-D4
    RTS

;!======

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

.LAB_0063:
    CMP.W   D2,D1
    BPL.W   .LAB_0065

    MOVE.W  0(A1,D3.W),0(A1,D1.W)
    CMP.W   D4,D1
    BPL.W   .LAB_0064

    MOVE.W  0(A1,D3.W),0(A0,D1.W)

.LAB_0064:
    ADDI.W  #4,D1
    ADDI.W  #4,D3
    BRA.S   .LAB_0063

.LAB_0065:
    MOVE.W  D0,0(A1,D1.W)
    CMP.W   D4,D1
    BPL.W   .return

    MOVE.W  D0,0(A0,D1.W)

.return:
    MOVEM.L (A7)+,D2-D4
    RTS

;!======

LAB_0067:
    MOVEM.L D2-D5/A2-A3,-(A7)
    LEA     LAB_1E26,A2
    LEA     LAB_1E55,A3
    MOVE.W  #0,D5
    MOVEQ   #7,D4

.LAB_0068:
    MOVE.W  0(A2,D5.W),D0
    JSR     LAB_006D

    MOVE.W  D0,0(A2,D5.W)
    MOVE.W  D0,0(A3,D5.W)
    ADDQ.W  #4,D5
    DBF     D4,.LAB_0068
    MOVEQ   #23,D4

.LAB_0069:
    MOVE.W  0(A2,D5.W),D0
    JSR     LAB_006D

    MOVE.W  D0,0(A2,D5.W)
    ADDQ.W  #4,D5
    DBF     D4,.LAB_0069
    MOVEM.L (A7)+,D2-D5/A2-A3
    RTS

;!======

LAB_006A:
    RTS

;!======

    MOVEM.L D2-D5/A2-A3,-(A7)
    LEA     LAB_1E2E,A2
    LEA     LAB_1E5B,A3
    MOVE.W  #0,D5
    MOVEQ   #7,D4

.LAB_006B:
    CMPI.W  #4,D5
    BEQ.W   .LAB_006C

    MOVE.W  0(A2,D5.W),D0
    JSR     LAB_006D

    MOVE.W  D0,0(A2,D5.W)
    MOVE.W  D0,0(A3,D5.W)

.LAB_006C:
    ADDQ.W  #4,D5
    DBF     D4,.LAB_006B
    MOVEM.L (A7)+,D2-D5/A2-A3
    RTS

;!======

LAB_006D:
    MOVE.W  D0,D1
    MOVE.W  D0,D2
    ANDI.W  #$f00,D1
    ANDI.W  #$f0,D2
    ANDI.W  #15,D0
    TST.W   D1
    BEQ.S   .LAB_006E

    SUBI.W  #$100,D1

.LAB_006E:
    TST.W   D2
    BEQ.S   .LAB_006F

    SUBI.W  #16,D2

.LAB_006F:
    TST.W   D0
    BEQ.S   .LAB_0070

    SUBI.W  #1,D0

.LAB_0070:
    ADD.W   D1,D0
    ADD.W   D2,D0
    RTS

;!======

LAB_0071:
    MOVEM.L D2-D6/A2-A3,-(A7)
    LEA     LAB_2295,A1
    LEA     LAB_1E26,A2
    LEA     LAB_1E55,A3
    MOVE.W  #0,D5
    MOVEQ   #7,D4

.LAB_0072:
    MOVE.W  0(A2,D5.W),D0
    JSR     LAB_0077

    MOVE.W  D0,0(A2,D5.W)
    MOVE.W  D0,0(A3,D5.W)
    ADDQ.W  #4,D5
    DBF     D4,.LAB_0072
    MOVEQ   #23,D4

.LAB_0073:
    MOVE.W  0(A2,D5.W),D0
    JSR     LAB_0077

    MOVE.W  D0,0(A2,D5.W)
    ADDQ.W  #4,D5
    DBF     D4,.LAB_0073
    MOVEM.L (A7)+,D2-D6/A2-A3
    RTS

;!======

LAB_0074:
    RTS

;!======

; Unreachable Code
    MOVEM.L D2-D5/A2-A3,-(A7)
    LEA     LAB_1E2E,A2
    LEA     LAB_1E5B,A3
    MOVE.W  #0,D5
    MOVEQ   #7,D4

.LAB_0075:
    CMPI.W  #4,D5
    BEQ.W   .LAB_0076

    MOVE.W  0(A2,D5.W),D0
    JSR     LAB_0077

    MOVE.W  D0,0(A2,D5.W)
    MOVE.W  D0,0(A3,D5.W)

.LAB_0076:
    ADDQ.W  #4,D5
    DBF     D4,.LAB_0075
    MOVEM.L (A7)+,D2-D5/A2-A3
    RTS

;!======

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
    BEQ.S   .LAB_0078

    ADDI.W  #$100,D1

.LAB_0078:
    MOVEQ   #0,D3
    MOVE.B  (A1)+,D3
    LSL.W   #4,D3
    CMP.W   D3,D2
    BEQ.S   .LAB_0079

    ADDI.W  #16,D2

.LAB_0079:
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
    BNE.W   .LAB_007C

    MOVEQ   #2,D4
    BRA.W   .return

.LAB_007C:
    CMP.W   D3,D0
    BGE.W   .LAB_0082

    CMP.W   LAB_1B0C,D0
    BEQ.W   .LAB_007D

    CMP.W   LAB_1B0B,D0
    BNE.W   .LAB_007E

.LAB_007D:
    MOVEQ   #5,D4
    BRA.W   .return

.LAB_007E:
    CMPI.W  #20,D0
    BEQ.W   .LAB_007F

    CMPI.W  #$32,D0
    BNE.W   .LAB_0080

.LAB_007F:
    MOVEQ   #4,D4
    BRA.W   .return

.LAB_0080:
    CMP.W   LAB_1B09,D0
    BEQ.W   .LAB_0081

    CMP.W   LAB_1B0A,D0
    BNE.W   .return

.LAB_0081:
    MOVEQ   #3,D4
    BRA.W   .return

.LAB_0082:
    MOVE.W  D2,10(A0)
    MOVEQ   #2,D4
    MOVE.W  8(A0),D0
    ADD.W   D1,D0
    MOVE.W  D0,8(A0)
    MOVEQ   #12,D3
    CMP.W   D3,D0
    BLT.W   .return

    BEQ.S   .LAB_0083

    MOVE.W  D1,8(A0)
    BRA.W   .return

.LAB_0083:
    EORI.W   #$ffff,18(A0)
    BMI.W   .return

    MOVE.W  0(A0),D0
    ADD.W   D1,D0
    MOVE.W  D0,0(A0)
    MOVEQ   #7,D3
    CMP.W   D3,D0
    BNE.S   .LAB_0084

    MOVE.W  D2,0(A0)

.LAB_0084:
    MOVE.W  16(A0),D0
    ADD.W   D1,D0
    MOVE.W  D0,16(A0)
    MOVE.W  #$16e,D3
    TST.W   20(A0)
    BEQ.S   .LAB_0085

    ADD.W   D1,D3

.LAB_0085:
    CMP.W   D3,D0
    BLT.S   .LAB_0087

    MOVE.W  6(A0),D0
    ADD.W   D1,D0
    MOVE.W  D0,6(A0)
    MOVE.W  D1,16(A0)
    MOVEQ   #0,D1
    ANDI.W  #3,D0
    BNE.S   .LAB_0086

    MOVE.W  #(-1),D1

.LAB_0086:
    MOVE.W  D1,20(A0)

.LAB_0087:
    JSR     LAB_0089

.return:
    MOVE.W  D4,D0
    MOVEM.L (A7)+,D2-D4
    RTS

;!======

; Unreachable Code
    MOVEA.L 4(A7),A0

LAB_0089:
    MOVE.L  D2,-(A7)
    MOVE.W  16(A0),D0
    MOVEQ   #0,D2
    LEA     LAB_1B1D,A1
    TST.W   20(A0)
    BEQ.S   .LAB_008A

    ADDA.L  #$18,A1

.LAB_008A:
    MOVE.W  (A1)+,D1
    CMP.W   D1,D0
    BLE.S   .return

    SUB.W   D1,D0
    ADDQ.W  #1,D2
    BRA.S   .LAB_008A

.return:
    MOVE.W  D2,2(A0)
    MOVE.W  D0,4(A0)
    MOVE.L  (A7)+,D2
    RTS

;!======

LAB_008C:
    MOVEA.L 4(A7),A0
    MOVE.W  2(A0),D1
    MOVEQ   #0,D0
    LEA     LAB_1B1D,A1
    DBF     D1,.LAB_008D

    BRA.S   .return

.LAB_008D:
    TST.W   20(A0)
    BEQ.S   .LAB_008E

    ADDA.L  #$18,A1

.LAB_008E:
    ADD.W   (A1)+,D0
    DBF     D1,.LAB_008E

.return:
    ADD.W   4(A0),D0
    MOVE.W  D0,16(A0)
    RTS

;!======

LAB_0090:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    MOVE.L  D2,-(A7)
    ADDA.L  #$b,A0
    MOVE.B  #0,(A0)
    MOVE.B  #$4d,-(A0)
    TST.W   18(A1)
    BPL.S   .LAB_0091

    MOVE.B  #$50,-(A0)
    BRA.S   .LAB_0092

.LAB_0091:
    MOVE.B  #$41,-(A0)

.LAB_0092:
    MOVE.B  #$20,-(A0)
    MOVE.W  12(A1),D2
    EXT.L   D2
    DIVS    #10,D2
    SWAP    D2
    ADDI.B  #$30,D2
    MOVE.B  D2,-(A0)
    SWAP    D2
    ADDI.B  #$30,D2
    MOVE.B  D2,-(A0)
    MOVE.B  #$3a,-(A0)
    MOVE.W  10(A1),D1
    EXT.L   D1
    DIVS    #10,D1
    SWAP    D1
    ADDI.B  #$30,D1
    MOVE.B  D1,-(A0)
    SWAP    D1
    ADDI.B  #$30,D1
    MOVE.B  D1,-(A0)
    MOVE.B  #$3a,-(A0)
    MOVE.W  8(A1),D0
    EXT.L   D0
    DIVS    #10,D0
    SWAP    D0
    ADDI.B  #$30,D0
    MOVE.B  D0,-(A0)
    SWAP    D0
    TST.B   D0
    BEQ.S   .LAB_0093

    ADDI.B  #$30,D0
    BRA.S   .return

.LAB_0093:
    MOVE.B  #$20,D0

.return:
    MOVE.B  D0,-(A0)
    MOVE.L  (A7)+,D2
    RTS

;!======

LAB_0095:
    MOVEA.L 4(A7),A0
    MOVE.L  D2,-(A7)
    MOVEQ   #0,D0
    MOVEQ   #12,D1
    MOVE.W  8(A0),D0
    TST.W   18(A0)
    BPL.S   LAB_0096

    ADD.W   D1,D0
    BRA.S   LAB_0097

LAB_0096:
    CMP.W   D1,D0
    BNE.S   LAB_0097

    MOVEQ   #0,D0

LAB_0097:
    MOVEQ   #24,D1
    CMP.W   D1,D0
    BEQ.S   LAB_0098

    ADD.W   D0,D0

LAB_0098:
    MOVE.W  10(A0),D2
    MOVEQ   #30,D1
    CMP.W   D1,D2
    BLT.S   LAB_0099

    ADDQ.W  #1,D0

LAB_0099:
    LEA     LAB_1B1E,A1
    MOVE.B  0(A1,D0.W),D0
    MOVE.L  (A7)+,D2
    RTS

;!======

LAB_009A:
    MOVE.L  4(A7),D0
    MOVE.L  8(A7),D1
    MOVEA.L 12(A7),A0
    MOVEM.L D2-D4,-(A7)
    MOVE.L  A0,D2
    MOVEQ   #65,D3
    CMP.W   D3,D1
    BLT.S   LAB_009B

    MOVEQ   #67,D3
    CMP.W   D3,D1
    BLT.S   LAB_009C

LAB_009B:
    MOVEQ   #65,D1

LAB_009C:
    MOVEQ   #65,D3
    CMP.W   D3,D2
    BLT.S   LAB_009D

    MOVEQ   #73,D3
    CMP.W   D3,D2
    BLE.S   LAB_009E

LAB_009D:
    MOVEQ   #69,D2

LAB_009E:
    MOVEQ   #65,D3
    SUB.W   D3,D1
    SUB.W   D3,D2
    ADDQ.W  #1,D2
    MOVEQ   #48,D4
    MOVE.W  D0,D3
    TST.W   D1
    BEQ.S   LAB_009F

    SUB.W   D1,D0
    CMPI.W  #1,D0
    BGE.S   LAB_009F

    ADD.W   D4,D0

LAB_009F:
    ADD.W   D2,D3
    CMP.W   D4,D3
    BLE.S   LAB_00A0

    SUB.W   D4,D3

LAB_00A0:
    MOVE.W  D0,LAB_226F
    MOVE.W  D3,LAB_2280
    MOVEM.L (A7)+,D2-D4
    RTS

;!======

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

LAB_00A7:
    MOVEA.L 4(A7),A0
    MOVE.L  8(A7),D0
    MOVEM.L D2-D4,-(A7)
    MOVE.L  D0,D4

LAB_00A8:
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVE.L  D0,D2
    MOVEQ   #91,D3

LAB_00A9:
    MOVE.B  (A0)+,D2
    BEQ.W   LAB_00B0

    CMP.B   D3,D2
    BNE.S   LAB_00A9

    SUBQ.W  #1,A0
    MOVEQ   #40,D3
    MOVE.B  D3,(A0)+
    TST.B   D4
    BEQ.S   LAB_00AE

    MOVE.B  (A0)+,D1
    CMPI.B  #$20,D1
    BEQ.S   LAB_00AA

    MOVEQ   #10,D0

LAB_00AA:
    MOVE.B  (A0)+,D1
    SUBI.B  #$30,D1
    ADD.B   D1,D0
    MOVEQ   #12,D1
    ADD.B   D4,D0
    CMPI.B  #$1,D0
    BGE.S   LAB_00AB

    ADD.B   D1,D0
    BRA.S   LAB_00AC

LAB_00AB:
    CMP.B   D1,D0
    BLE.S   LAB_00AC

    SUB.B   D1,D0
    BRA.S   LAB_00AB

LAB_00AC:
    MOVEQ   #10,D1
    MOVEQ   #32,D2
    MOVEA.L A0,A1
    CMP.B   D1,D0
    BLT.S   LAB_00AD

    SUB.B   D1,D0
    MOVEQ   #49,D2

LAB_00AD:
    ADDI.B  #$30,D0
    MOVE.B  D0,-(A1)
    MOVE.B  D2,-(A1)

LAB_00AE:
    MOVEQ   #93,D3

LAB_00AF:
    MOVE.B  (A0)+,D2
    BEQ.S   LAB_00B0

    CMP.B   D3,D2
    BNE.S   LAB_00AF

    SUBQ.W  #1,A0
    MOVEQ   #41,D3
    MOVE.B  D3,(A0)+
    BRA.S   LAB_00A8

LAB_00B0:
    MOVEM.L (A7)+,D2-D4
    RTS

;!======

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

LAB_00B3:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    MOVEM.L D2-D4,-(A7)
    MOVEQ   #5,D0

.LAB_00B4:
    MOVE.B  (A1)+,D4
    BEQ.S   .LAB_00B7

    CMPI.B  #$ff,D4
    BEQ.S   .LAB_00B7

    MOVEQ   #0,D3
    MOVE.L  D3,D1
    MOVE.B  D4,D1
    MOVE.L  D3,D4
    MOVEQ   #7,D2

.LAB_00B5:
    BTST    D2,D1
    BEQ.S   .LAB_00B6

    BSET    D3,D4

.LAB_00B6:
    ADDQ.W  #1,D3
    DBF     D2,.LAB_00B5

.LAB_00B7:
    MOVE.B  D4,(A0)+
    DBF     D0,.LAB_00B4

    MOVEM.L (A7)+,D2-D4
    RTS

;!======

GENERATE_CHECKSUM_BYTE_INTO_D0:
    MOVEQ   #0,D0           ; Move 0 into D0
    MOVE.B  LAB_2253,D0     ; Move the byte in LAB_2253 to D0
    TST.B   LAB_2206        ; Test LAB_2206 against 0
    BNE.S   .return         ; If it's not equal, jump to .LAB_00BA

    MOVE.L  4(A7),D0        ; D0
    MOVEA.L 8(A7),A0        ; LAB_229A
    MOVE.L  12(A7),D1       ; 256
    MOVE.L  D2,-(A7)
    MOVE.L  D1,D2
    SUBQ.W  #1,D2
    EORI.B  #$ff,D0
    MOVEQ   #0,D1

.doWhileNotNull:
    MOVE.B  (A0)+,D1
    EOR.B   D1,D0
    DBF     D2,.doWhileNotNull

    ANDI.L  #$ff,D0
    MOVE.L  (A7)+,D2

.return:
    RTS

;!======

; Unreachable Code
LAB_00BB_Unreachable:
    MOVEA.L 4(A7),A0
    MOVE.L  D2,-(A7)
    MOVEQ   #0,D0
    MOVE.W  D0,D1
    MOVEQ   #34,D2

.LAB_00BB:
    MOVE.B  (A0)+,D1
    BEQ.S   .return

    CMP.B   D2,D1
    BNE.S   .LAB_00BB

.LAB_00BC:
    MOVE.B  (A0)+,D1
    BEQ.S   .return

    CMP.B   D2,D1
    BNE.S   .LAB_00BC

    MOVE.B  D0,(A0)

.return:
    MOVE.L  (A7)+,D2
    RTS

;!======

LAB_00BE:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    CMPA.L  #0,A0
    BEQ.S   LAB_00C0

    CMPA.L  #0,A1
    BEQ.S   LAB_00C0

    MOVEQ   #0,D0

.LAB_00BF:
    MOVE.B  (A0)+,D0
    MOVE.B  (A1)+,D1
    CMPI.B  #$2a,D1
    BEQ.S   LAB_00C2

    TST.B   D0
    BEQ.S   LAB_00C1

    CMPI.B  #$3f,D1
    BEQ.S   .LAB_00BF

    SUB.B   D1,D0
    BEQ.S   .LAB_00BF

LAB_00C0:
    MOVE.B  #$1,D0
    RTS

;!======

LAB_00C1:
    TST.B   D1
    BNE.S   LAB_00C0

LAB_00C2:
    MOVE.B  #0,D0
    RTS

;!======

LAB_00C3:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    MOVEM.L A2-A3,-(A7)

    MOVEQ   #0,D0
    TST.B   (A1)
    BEQ.S   LAB_00C6

    MOVEA.L A0,A3
    MOVEA.L A1,A2

LAB_00C4:
    TST.B   (A0)
    BNE.S   LAB_00C7

    TST.B   (A2)
    BNE.S   LAB_00C6

LAB_00C5:
    MOVE.L  A3,D0

LAB_00C6:
    MOVEM.L (A7)+,A2-A3
    RTS

;!======

LAB_00C7:
    TST.B   (A2)
    BEQ.S   LAB_00C5

    MOVE.B  (A0)+,D1
    CMP.B   (A2),D1
    BNE.S   LAB_00C8

    TST.B   (A2)+
    BRA.S   LAB_00C4

LAB_00C8:
    BCHG    #5,D1
    CMP.B   (A2),D1
    BNE.S   LAB_00C9

    TST.B   (A2)+
    BRA.S   LAB_00C4

LAB_00C9:
    MOVE.L  A2,D2
    CMPA.L  D2,A1
    BEQ.S   LAB_00CA

    MOVE.L  A0,D1
    SUBI.L  #$1,D1
    MOVEA.L D1,A0

LAB_00CA:
    MOVEA.L A0,A3
    MOVEA.L A1,A2
    BRA.S   LAB_00C4

LAB_00CB:
    MOVEA.L 4(A7),A0
    MOVE.L  8(A7),D0
    MOVE.L  12(A7),D1
    ADDA.L  D1,A0
    MOVE.B  #0,(A0)
    SUBQ.W  #1,D1

LAB_00CC:
    EXT.L   D0
    DIVS    #10,D0
    SWAP    D0
    MOVE.B  D0,-(A0)
    ADDI.B  #$30,(A0)
    SWAP    D0
    DBF     D1,LAB_00CC

    RTS

;!======

LAB_00CD:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    MOVE.L  12(A7),D0

    MOVEQ   #0,D1
    MOVE.L  D7,-(A7)
    MOVE.L  D6,-(A7)

LAB_00CE:
    CMP.W   D0,D1
    BGE.W   LAB_00D2

    MOVE.B  (A0)+,D7
    TST.B   D7
    BMI.W   LAB_00D0

    ADDQ.B  #1,D7

LAB_00CF:
    TST.B   D7
    BLE.S   LAB_00CE

    MOVE.B  (A0)+,(A1)+
    ADDQ.W  #1,D1
    CMP.W   D0,D1
    BGE.W   LAB_00D2

    SUBQ.B  #1,D7
    BRA.S   LAB_00CF

LAB_00D0:
    EXT.W   D7
    EXT.L   D7
    CMPI.L  #$ff,D7
    BEQ.S   LAB_00CE

    NEG.L   D7
    ADDQ.L  #1,D7
    MOVE.B  (A0)+,D6

LAB_00D1:
    TST.B   D7
    BLE.S   LAB_00CE

    MOVE.B  D6,(A1)+
    ADDQ.W  #1,D1
    CMP.W   D0,D1
    BGE.W   LAB_00D2

    SUBQ.B  #1,D7
    BRA.S   LAB_00D1

LAB_00D2:
    MOVE.L  A0,D0
    MOVE.L  (A7)+,D6
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_00D3:
    MOVE.W  LAB_2363,D0
    ADDQ.W  #1,D0
    CMPI.W  #$5460,D0
    BNE.S   LAB_00D4

    JSR     LAB_00E3

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

LAB_00E3:
    MOVEA.L AbsExecBase,A6
    CMPI.W  #$24,20(A6)
    BLT.S   LAB_00E4

    JMP     _LVOColdReboot(A6)

;!======

LAB_00E4:
    LEA     LAB_00E5(PC),A5
    JSR     _LVOSupervisor(A6)

;!======

    ; Alignment
    DC.W    $0000

;!======

LAB_00E5:
    LEA     $1000000,A0
    SUBA.L  -20(A0),A0  ; 0xFFFFEC
    MOVEA.L 4(A0),A0
    SUBQ.L  #2,A0
    RESET
    JMP     (A0)

    MOVE.L  #$FBFFFC,D0 ; Something in the system rom.
    MOVEA.L D0,A0
    MOVE.W  (A0),D1
    MOVE.W  #$55AA,(A0) ; Are we dynamically patching the rom?
    MOVE.W  (A0),D0
    CMPI.W  #$55AA,D0
    BNE.W   LAB_00E6

    MOVE.W  #$AA55,(A0)
    MOVE.W  (A0),D0
    CMPI.W  #$AA55,D0
    BNE.W   LAB_00E6

    MOVE.W  D1,(A0)
    MOVEQ   #0,D0
    RTS

;!======

LAB_00E6:
    MOVEQ   #1,D0
    RTS

;!======

LAB_00E7:
    MOVEM.L A0-A1,-(A7)
    JSR     LAB_0DFB

    ADDQ.L  #8,A7
    RTS

;!======

    ; Alignment
    DC.W    $0000

;!======

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
    BSR.W   LAB_00E9

    MOVE.L  D4,(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_00E8

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
    BSR.W   LAB_00E9

    MOVE.L  D4,(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_00EA

    LEA     36(A7),A7

    MOVEM.L (A7)+,D4-D7/A3
    RTS

;!======

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
    BSR.W   LAB_00EB

    MOVE.L  D4,(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_00EA

    LEA     36(A7),A7

    MOVEM.L (A7)+,D4-D7/A3
    RTS

;!======

    ; Alignment
    DC.W    $0000

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
