    XDEF    ESQ_CheckAvailableFastMemory
    XDEF    ESQ_CheckCompatibleVideoChip
    XDEF    ESQ_CheckTopazFontGuard
    XDEF    ESQ_FormatDiskErrorMessage

;------------------------------------------------------------------------------
; FUNC: ESQ_CheckAvailableFastMemory
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
ESQ_CheckAvailableFastMemory:

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
; FUNC: ESQ_CheckCompatibleVideoChip
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
ESQ_CheckCompatibleVideoChip:
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
; FUNC: ESQ_CheckTopazFontGuard   (CheckTopazFontGuarduncertain)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A6
; CALLS:
;   GROUP_MAIN_B_JMPTBL_DOS_Delay, _LVOSetAPen, _LVORectFill, _LVOMove, _LVOText,
;   _LVOSizeWindow, _LVORemakeDisplay, _LVOFreeMem,
;   GROUP_MAIN_B_JMPTBL_MATH_Mulu32, GROUP_MAIN_B_JMPTBL_STREAM_BufferedWriteString, GROUP_MAIN_B_JMPTBL_BUFFER_FlushAllAndCloseWithCode
; READS:
;   Global_REF_INTUITION_LIBRARY, Global_REF_GRAPHICS_LIBRARY, Global_STR_TOPAZ_FONT,
;   ESQIFF_SecondaryLineHeadPtr_HiWord, ESQ_TopazGuardRastPortAnchor,
;   Global_STR_PLEASE_STANDBY_1, Global_STR_ATTENTION_SYSTEM_ENGINEER_1,
;   Global_STR_REPORT_CODE_ER003
; WRITES:
;   (none)
; DESC:
;   Checks topaz font/intuition state and may display a warning/lockup screen.
; NOTES:
;   - Soft-locks in a loop for the engineer warning path.
;------------------------------------------------------------------------------
ESQ_CheckTopazFontGuard:
    LINK.W  A5,#-32
    MOVEM.L D2-D7,-(A7)

.strTopazFont1  = -4
.lab1DE9        = -8
.strTopazFont2  = -12

; Testing out address math here. None of this _feels_ right but it's
; still compiling to the same hash. It looks like this is just doing
; some trampolining to get to the desired end address.

;LAB_0018:  ; unreferenced
    MOVEA.L Global_REF_INTUITION_LIBRARY,A0
    MOVE.L  (Global_STR_TOPAZ_FONT-Global_REF_INTUITION_LIBRARY)+4(A0),.strTopazFont1(A5)
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #(ESQIFF_SecondaryLineHeadPtr_HiWord-Global_STR_TOPAZ_FONT),A0
    MOVE.L  A0,.lab1DE9(A5)
    MOVEQ   #2,D0
    CMP.B   5(A0),D0
    BNE.W   .show_rerun_error

    MOVEA.L Global_REF_INTUITION_LIBRARY,A0
    MOVE.L  (Global_STR_TOPAZ_FONT-Global_REF_INTUITION_LIBRARY)(A0),.strTopazFont2(A5)
    MOVE.W  20(A0),D0                   ; 20 = Library__lib_Version
    MOVEQ   #33,D1
    CMP.W   D1,D0                       ; Sub 33 from the obtained version
    BHI.W   .bypassSystemEngineerLockup ; Compare the library to the requested version, if it's greater or higher jump

    ; Delay 250 ticks or 5 seconds
    PEA     250.W
    JSR     GROUP_MAIN_B_JMPTBL_DOS_Delay(PC)

    ADDQ.W  #4,A7

    ; Trampoline to ESQ_TopazGuardRastPortAnchor in A0
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #(ESQ_TopazGuardRastPortAnchor-Global_STR_TOPAZ_FONT),A0

    ; Set the primary pen to 2
    MOVEA.L A0,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    ; Trampoline to ESQ_TopazGuardRastPortAnchor in A0
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #(ESQ_TopazGuardRastPortAnchor-Global_STR_TOPAZ_FONT),A0

    ; Draw a filled rect from 0,0 to 639,56
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVE.L  #639,D2
    MOVEQ   #56,D3
    NOT.B   D3
    JSR     _LVORectFill(A6)

    ; Trampoline to ESQ_TopazGuardRastPortAnchor in A0
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #(ESQ_TopazGuardRastPortAnchor-Global_STR_TOPAZ_FONT),A0

    ; Set the primary pen to 1
    MOVEA.L A0,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    ; Trampoline to ESQ_TopazGuardRastPortAnchor in A0
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #(ESQ_TopazGuardRastPortAnchor-Global_STR_TOPAZ_FONT),A0

    ; Move the pen to 20,100
    MOVEA.L A0,A1
    MOVEQ   #20,D0
    MOVEQ   #100,D1
    JSR     _LVOMove(A6)

    ; Trampoline to ESQ_TopazGuardRastPortAnchor in A0
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #(ESQ_TopazGuardRastPortAnchor-Global_STR_TOPAZ_FONT),A0

    ; Draw "Please Standby..." text
    MOVEA.L A0,A1
    LEA     Global_STR_PLEASE_STANDBY_1,A0
    MOVEQ   #(Global_STR_PLEASE_STANDBY_1_Length)-1,D0
    ; -1 to remove null padding
    JSR     _LVOText(A6)

    ; Trampoline to ESQ_TopazGuardRastPortAnchor in A0
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #(ESQ_TopazGuardRastPortAnchor-Global_STR_TOPAZ_FONT),A0

    ; Move the pen to 20,113
    MOVEA.L A0,A1
    MOVEQ   #20,D0
    MOVEQ   #113,D1
    JSR     _LVOMove(A6)

    ; Trampoline to ESQ_TopazGuardRastPortAnchor in A0
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #(ESQ_TopazGuardRastPortAnchor-Global_STR_TOPAZ_FONT),A0

    ; Draw "ATTENTION! SYSTEM ENGINEER" text
    MOVEA.L A0,A1
    LEA     Global_STR_ATTENTION_SYSTEM_ENGINEER_1,A0
    MOVEQ   #26,D0
    JSR     _LVOText(A6)

    ; Trampoline to ESQ_TopazGuardRastPortAnchor in A0
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #(ESQ_TopazGuardRastPortAnchor-Global_STR_TOPAZ_FONT),A0

    ; Move the pen to 20,126
    MOVEA.L A0,A1
    MOVEQ   #20,D0
    MOVEQ   #126,D1
    JSR     _LVOMove(A6)

    ; Trampoline to ESQ_TopazGuardRastPortAnchor in A0
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #(ESQ_TopazGuardRastPortAnchor-Global_STR_TOPAZ_FONT),A0
    ; Draw "Report Code ER003 to TV Guide Technical Services." text
    ; Fun fact: that string is 49 characters so it gets truncated...
    MOVEA.L A0,A1
    LEA     Global_STR_REPORT_CODE_ER003,A0
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
    MOVEA.L Global_REF_INTUITION_LIBRARY,A6
    JSR     _LVOSizeWindow(A6)

    PEA     100.W
    JSR     GROUP_MAIN_B_JMPTBL_DOS_Delay(PC)

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
    JSR     GROUP_MAIN_B_JMPTBL_MATH_Mulu32(PC)

    LSR.L   #3,D0
    MOVE.L  D5,D1
    ADD.L   D0,D1
    MOVE.L  D1,-32(A5)

    MOVEA.L Global_REF_INTUITION_LIBRARY,A6
    JSR     _LVORemakeDisplay(A6)

    MOVEA.L D4,A0
    MOVE.L  -32(A5),D0
    SUB.L   D4,D0
    MOVEA.L A0,A1

    MOVEA.L AbsExecBase,A6
    JSR     _LVOFreeMem(A6)

    BRA.S   .done

.show_rerun_error:
    PEA     Global_STR_YOU_CANNOT_RE_RUN_THE_SOFTWARE
    JSR     GROUP_MAIN_B_JMPTBL_STREAM_BufferedWriteString(PC)

    CLR.L   (A7)
    JSR     GROUP_MAIN_B_JMPTBL_BUFFER_FlushAllAndCloseWithCode(PC)

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
;   DISKIO_QueryVolumeSoftErrorCount, DISKIO_QueryDiskUsagePercentAndSetBufferSize, GROUP_AE_JMPTBL_WDISP_SPrintf
; READS:
;   COMMON_QueryDiskSoftErrorCountScratch, COMMON_QueryDiskUsagePercentScratch, Global_STR_DISK_ERRORS_FORMATTED,
;   Global_STR_DISK_IS_FULL_FORMATTED, DISKIO_ErrorMessageScratch
; WRITES:
;   DISKIO_ErrorMessageScratch (formatted text buffer)
; DESC:
;   Builds a disk error message into DISKIO_ErrorMessageScratch based on disk error counts.
; NOTES:
;   - Uses DISKIO_QueryVolumeSoftErrorCount and DISKIO_QueryDiskUsagePercentAndSetBufferSize helpers for error count retrieval.
;   - Destination DISKIO_ErrorMessageScratch has 41 bytes total capacity.
;   - Current practical bounds:
;       "Disk Errors: %ld\\n" with 16-bit source <= 65535 => 19 chars + NUL
;       "Disk is %ld%% full" with percent source <= 100 => 17 chars + NUL
;   - Conservative signed-32 worst-case for either %ld path is 25 chars + NUL
;     (headroom 15 bytes, i.e. below a 16-byte comfort margin).
;------------------------------------------------------------------------------
ESQ_FormatDiskErrorMessage:
    MOVEM.L D6-D7,-(A7)

    SetOffsetForStack   2

    PEA     COMMON_QueryDiskSoftErrorCountScratch
    JSR     DISKIO_QueryVolumeSoftErrorCount(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D6
    TST.L   D6
    BLE.S   .createDiskIsFullMessage

    MOVE.L  D6,-(A7)
    ; DISKIO_ErrorMessageScratch is 41 bytes:
    ; - practical 16-bit count path (<=65535) uses 19 chars + NUL
    ; - signed-32 worst-case uses 25 chars + NUL
    PEA     Global_STR_DISK_ERRORS_FORMATTED
    PEA     DISKIO_ErrorMessageScratch
    JSR     GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    LEA     .stackOffsetBytes+4(A7),A7
    BRA.S   .done

.createDiskIsFullMessage:
    PEA     COMMON_QueryDiskUsagePercentScratch
    JSR     DISKIO_QueryDiskUsagePercentAndSetBufferSize(PC)

    MOVE.L  D0,D7
    MOVE.L  D7,(A7)
    ; DISKIO_ErrorMessageScratch is 41 bytes:
    ; - normal 0..100 percent path uses at most 17 chars + NUL
    ; - signed-32 worst-case uses 25 chars + NUL
    PEA     Global_STR_DISK_IS_FULL_FORMATTED
    PEA     DISKIO_ErrorMessageScratch
    JSR     GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    LEA     .stackOffsetBytes+4(A7),A7

.done:
    MOVEQ   #0,D0
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000
