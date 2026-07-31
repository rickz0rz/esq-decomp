    XDEF    _ESQ_CheckTopazFontGuard


;------------------------------------------------------------------------------
; FUNC: _ESQ_CheckTopazFontGuard   (CheckTopazFontGuarduncertain)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A6
; CALLS:
;   _GROUP_MAIN_B_JMPTBL_DOS_Delay, _LVOSetAPen, _LVORectFill, _LVOMove, _LVOText,
;   _LVOSizeWindow, _LVORemakeDisplay, _LVOFreeMem,
;   _GROUP_MAIN_B_JMPTBL_MATH_Mulu32, _GROUP_MAIN_B_JMPTBL_STREAM_BufferedWriteString, _GROUP_MAIN_B_JMPTBL_BUFFER_FlushAllAndCloseWithCode
; READS:
;   _Global_REF_INTUITION_LIBRARY, Global_REF_GRAPHICS_LIBRARY, Global_STR_TOPAZ_FONT,
;   ESQIFF_SecondaryLineHeadPtr_HiWord, ESQ_TopazGuardRastPortAnchor,
;   _Global_STR_PLEASE_STANDBY_1, _Global_STR_ATTENTION_SYSTEM_ENGINEER_1,
;   _Global_STR_REPORT_CODE_ER003
; WRITES:
;   (none)
; DESC:
;   Checks topaz font/intuition state and may display a warning/lockup screen.
; NOTES:
;   - Soft-locks in a loop for the engineer warning path.
;------------------------------------------------------------------------------
_ESQ_CheckTopazFontGuard:
    LINK.W  A5,#-32
    MOVEM.L D2-D7,-(A7)

.strTopazFont1  = -4
.lab1DE9        = -8
.strTopazFont2  = -12

; Testing out address math here. None of this _feels_ right but it's
; still compiling to the same hash. It looks like this is just doing
; some trampolining to get to the desired end address.

;LAB_0018:  ; unreferenced
    MOVEA.L _Global_REF_INTUITION_LIBRARY,A0
    MOVE.L  Offset_TopazFontName_FromIntuitionLibraryRef+4(A0),.strTopazFont1(A5)
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #Offset_SecondaryLineHeadHiWord_FromTopazFont,A0
    MOVE.L  A0,.lab1DE9(A5)
    MOVEQ   #2,D0
    CMP.B   5(A0),D0
    BNE.W   .show_rerun_error

    MOVEA.L _Global_REF_INTUITION_LIBRARY,A0
    MOVE.L  Offset_TopazFontName_FromIntuitionLibraryRef(A0),.strTopazFont2(A5)
    MOVE.W  20(A0),D0                   ; 20 = Library__lib_Version
    MOVEQ   #33,D1
    CMP.W   D1,D0                       ; Sub 33 from the obtained version
    BHI.W   .bypassSystemEngineerLockup ; Compare the library to the requested version, if it's greater or higher jump

    ; Delay 250 ticks or 5 seconds
    PEA     250.W
    JSR     _GROUP_MAIN_B_JMPTBL_DOS_Delay(PC)

    ADDQ.W  #4,A7

    ; Trampoline to ESQ_TopazGuardRastPortAnchor in A0
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #Offset_TopazGuardRastPortAnchor_FromTopazFont,A0

    ; Set the primary pen to 2
    MOVEA.L A0,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    ; Trampoline to ESQ_TopazGuardRastPortAnchor in A0
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #Offset_TopazGuardRastPortAnchor_FromTopazFont,A0

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
    ADDA.W  #Offset_TopazGuardRastPortAnchor_FromTopazFont,A0

    ; Set the primary pen to 1
    MOVEA.L A0,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    ; Trampoline to ESQ_TopazGuardRastPortAnchor in A0
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #Offset_TopazGuardRastPortAnchor_FromTopazFont,A0

    ; Move the pen to 20,100
    MOVEA.L A0,A1
    MOVEQ   #20,D0
    MOVEQ   #100,D1
    JSR     _LVOMove(A6)

    ; Trampoline to ESQ_TopazGuardRastPortAnchor in A0
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #Offset_TopazGuardRastPortAnchor_FromTopazFont,A0

    ; Draw "Please Standby..." text
    MOVEA.L A0,A1
    LEA     _Global_STR_PLEASE_STANDBY_1,A0
    MOVEQ   #(Global_STR_PLEASE_STANDBY_1_Length)-1,D0
    ; -1 to remove null padding
    JSR     _LVOText(A6)

    ; Trampoline to ESQ_TopazGuardRastPortAnchor in A0
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #Offset_TopazGuardRastPortAnchor_FromTopazFont,A0

    ; Move the pen to 20,113
    MOVEA.L A0,A1
    MOVEQ   #20,D0
    MOVEQ   #113,D1
    JSR     _LVOMove(A6)

    ; Trampoline to ESQ_TopazGuardRastPortAnchor in A0
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #Offset_TopazGuardRastPortAnchor_FromTopazFont,A0

    ; Draw "ATTENTION! SYSTEM ENGINEER" text
    MOVEA.L A0,A1
    LEA     _Global_STR_ATTENTION_SYSTEM_ENGINEER_1,A0
    MOVEQ   #26,D0
    JSR     _LVOText(A6)

    ; Trampoline to ESQ_TopazGuardRastPortAnchor in A0
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #Offset_TopazGuardRastPortAnchor_FromTopazFont,A0

    ; Move the pen to 20,126
    MOVEA.L A0,A1
    MOVEQ   #20,D0
    MOVEQ   #126,D1
    JSR     _LVOMove(A6)

    ; Trampoline to ESQ_TopazGuardRastPortAnchor in A0
    MOVEA.L .strTopazFont1(A5),A0
    ADDA.W  #Offset_TopazGuardRastPortAnchor_FromTopazFont,A0
    ; Draw "Report Code ER003 to TV Guide Technical Services." text
    ; Fun fact: that string is 49 characters so it gets truncated...
    MOVEA.L A0,A1
    LEA     _Global_STR_REPORT_CODE_ER003,A0
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
    MOVEA.L _Global_REF_INTUITION_LIBRARY,A6
    JSR     _LVOSizeWindow(A6)

    PEA     100.W
    JSR     _GROUP_MAIN_B_JMPTBL_DOS_Delay(PC)

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
    JSR     _GROUP_MAIN_B_JMPTBL_MATH_Mulu32(PC)

    LSR.L   #3,D0
    MOVE.L  D5,D1
    ADD.L   D0,D1
    MOVE.L  D1,-32(A5)

    MOVEA.L _Global_REF_INTUITION_LIBRARY,A6
    JSR     _LVORemakeDisplay(A6)

    MOVEA.L D4,A0
    MOVE.L  -32(A5),D0
    SUB.L   D4,D0
    MOVEA.L A0,A1

    MOVEA.L AbsExecBase,A6
    JSR     _LVOFreeMem(A6)

    BRA.S   .done

.show_rerun_error:
    PEA     _Global_STR_YOU_CANNOT_RE_RUN_THE_SOFTWARE
    JSR     _GROUP_MAIN_B_JMPTBL_STREAM_BufferedWriteString(PC)

    CLR.L   (A7)
    JSR     _GROUP_MAIN_B_JMPTBL_BUFFER_FlushAllAndCloseWithCode(PC)

    ADDQ.W  #4,A7

.done:
    MOVEM.L (A7)+,D2-D7
    UNLK    A5
    RTS

;!======