;!======

SETUP_INTERRUPT_INTB_VERTB:
    ; Allocate 22 bytes to memory for interrupt struct
    PEA     (MEMF_PUBLIC).W                 ; Memory Type
    PEA     22.W                            ; Bytes to Allocate
    PEA     1159.W                          ; Line Number
    PEA     GLOB_STR_ESQFUNC_C_1            ; Calling File
    JSR     JMP_TBL_ALLOCATE_MEMORY_2(PC)

    LEA     16(A7),A7

    MOVE.L  D0,GLOB_REF_INTERRUPT_STRUCT_INTB_VERTB
    MOVEA.L D0,A0
    MOVE.B  #$2,8(A0)

    MOVEA.L GLOB_REF_INTERRUPT_STRUCT_INTB_VERTB,A0
    CLR.B   9(A0)

    MOVEA.L GLOB_REF_INTERRUPT_STRUCT_INTB_VERTB,A0
    MOVE.L  #GLOB_STR_VERTICAL_BLANK_INT,10(A0)

    MOVEA.L GLOB_REF_INTERRUPT_STRUCT_INTB_VERTB,A0
    MOVE.L  #LAB_2290,14(A0)
    LEA     LAB_09BB(PC),A0

    MOVEA.L GLOB_REF_INTERRUPT_STRUCT_INTB_VERTB,A1
    MOVE.L  A0,18(A1)
    MOVEQ   #INTB_VERTB,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAddIntVector(A6)

    RTS

;!======

SETUP_INTERRUPT_INTB_AUD1:
    ; Allocate 22 bytes to memory for interrupt struct
    PEA     (MEMF_CHIP).W                   ; Memory Type
    PEA     22.W                            ; Bytes to Allocate
    PEA     1172.W                          ; Line Number
    PEA     GLOB_STR_ESQFUNC_C_2            ; Calling File
    JSR     JMP_TBL_ALLOCATE_MEMORY_2(PC)

    LEA     16(A7),A7

    MOVE.L  D0,GLOB_REF_INTERRUPT_STRUCT_INTB_AUD1
    MOVEA.L D0,A0
    MOVE.B  #$2,8(A0)

    MOVEA.L GLOB_REF_INTERRUPT_STRUCT_INTB_AUD1,A0
    CLR.B   9(A0)

    MOVEA.L GLOB_REF_INTERRUPT_STRUCT_INTB_AUD1,A0
    MOVE.L  #GLOB_STR_JOYSTICK_INT,10(A0)

    MOVEA.L GLOB_REF_INTERRUPT_STRUCT_INTB_AUD1,A0
    MOVE.L  #LAB_1B04,14(A0)
    LEA     LAB_09BF(PC),A0

    MOVEA.L GLOB_REF_INTERRUPT_STRUCT_INTB_AUD1,A1
    MOVE.L  A0,18(A1)
    MOVEQ   #INTB_AUD1,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOSetIntVector(A6)

    MOVE.L  D0,GLOB_REF_INTB_AUD1_INTERRUPT
    RTS

;!======

SETUP_INTERRUPT_INTB_RBF:
    ; Allocate 22 bytes to memory for interrupt struct
    PEA     (MEMF_PUBLIC).W                 ; Memory Type
    PEA     22.W                            ; Bytes to Allocate
    PEA     1195.W                          ; Line Number
    PEA     GLOB_STR_ESQFUNC_C_3            ; Calling File
    JSR     JMP_TBL_ALLOCATE_MEMORY_2(PC)

    MOVE.L  D0,GLOB_REF_INTERRUPT_STRUCT_INTB_RBF

    ; Allocate 64,000 bytes to memory
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)  ; Memory Type
    MOVE.L  #64000,-(A7)                    ; Bytes to Allocate
    PEA     1197.W                          ; Line Number
    PEA     GLOB_STR_ESQFUNC_C_4            ; Calling File
    JSR     JMP_TBL_ALLOCATE_MEMORY_2(PC)

    LEA     28(A7),A7

    MOVE.L  D0,GLOB_REF_INTB_RBF_64K_BUFFER

    MOVEA.L GLOB_REF_INTERRUPT_STRUCT_INTB_RBF,A0
    MOVE.B  #2,8(A0)

    MOVEA.L GLOB_REF_INTERRUPT_STRUCT_INTB_RBF,A0
    CLR.B   9(A0)

    MOVEA.L GLOB_REF_INTERRUPT_STRUCT_INTB_RBF,A0
    MOVE.L  #GLOB_STR_RS232_RECEIVE_HANDLER,10(A0)

    MOVEA.L GLOB_REF_INTERRUPT_STRUCT_INTB_RBF,A0
    MOVE.L  GLOB_REF_INTB_RBF_64K_BUFFER,14(A0)

    LEA     JMP_TBL_INTB_RBF_EXEC(PC),A0
    MOVEA.L GLOB_REF_INTERRUPT_STRUCT_INTB_RBF,A1

    ; Setup IntVector on INTB_RBF (interrupt 11 aka "serial port recieve buffer full") pointing to 18(A1)
    MOVE.L  A0,18(A1)
    MOVEQ   #INTB_RBF,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOSetIntVector(A6)

    MOVE.L  D0,GLOB_REF_INTB_RBF_INTERRUPT
    RTS

;!======

LAB_0963:
    LINK.W  A5,#-4
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7

.LAB_0964:
    MOVEQ   #20,D0
    CMP.W   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_225A,A0
    ADDA.L  D0,A0

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)     ; Memory Type
    PEA     60.W                                ; Bytes to Allocate
    PEA     1222.W                              ; Line Number
    PEA     GLOB_STR_ESQFUNC_C_5                ; Calling File
    MOVE.L  A0,20(A7)
    JSR     JMP_TBL_ALLOCATE_MEMORY_2(PC)

    LEA     16(A7),A7
    MOVEA.L 4(A7),A0
    MOVE.L  D0,(A0)
    ADDQ.W  #1,D7
    BRA.S   .LAB_0964

.return:
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_2254
    MOVE.W  D0,LAB_225D
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

LAB_0966:
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7

LAB_0967:
    MOVEQ   #20,D0
    CMP.W   D0,D7
    BGE.S   LAB_0968

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_225A,A0
    ADDA.L  D0,A0

    ; Deallocate 60 bytes from A0
    PEA     60.W
    MOVE.L  (A0),-(A7)
    PEA     1235.W
    PEA     GLOB_STR_ESQFUNC_C_6
    JSR     JMP_TBL_DEALLOCATE_MEMORY_2(PC)

    LEA     16(A7),A7
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_225A,A0
    ADDA.L  D0,A0
    CLR.L   (A0)
    ADDQ.W  #1,D7
    BRA.S   LAB_0967

LAB_0968:
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_0969:
    JSR     LAB_09A9(PC)

    TST.L   LAB_2318
    BNE.S   .LAB_096B

    TST.L   LAB_231A
    BNE.S   .LAB_096A

    MOVE.W  LAB_234A,D0
    ADDQ.W  #1,D0
    BNE.S   .LAB_096C

    CLR.W   LAB_234A
    BRA.S   .LAB_096C

.LAB_096A:
    MOVE.W  #(-1),LAB_234A
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     90.W
    PEA     GLOB_STR_DISK_0_IS_WRITE_PROTECTED
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    LEA     12(A7),A7
    BRA.S   .LAB_096C

.LAB_096B:
    MOVE.W  #(-1),LAB_234A
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     90.W
    PEA     GLOB_STR_YOU_MUST_REINSERT_SYSTEM_DISK_INTO_DRIVE_0
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    LEA     12(A7),A7

.LAB_096C:
    RTS

;!======

LAB_096D:
    JSR     LAB_09B1(PC)

    TST.W   D0
    BNE.S   .return

    BSR.W   LAB_097E

    BRA.S   LAB_096D

.return:
    RTS

;!======

LAB_096F:
    MOVE.L  D7,-(A7)
    MOVE.W  LAB_1F45,D7
    MOVE.W  #$100,LAB_1F45
    MOVE.W  #1,LAB_1E86
    BSR.W   LAB_094F

    JSR     LAB_09C0(PC)

    BSR.W   LAB_0959

    BSR.W   LAB_094A

    BSR.W   LAB_095D

    JSR     LAB_0BEA(PC)

    JSR     LAB_0BF9(PC)

    PEA     LAB_2324
    PEA     LAB_2321
    JSR     LAB_0BF7(PC)

    PEA     LAB_21DF
    JSR     LAB_0610(PC)

    JSR     LAB_09A8(PC)

    JSR     LAB_0BFC(PC)

    BSR.W   LAB_0969

    LEA     12(A7),A7
    MOVE.W  D7,LAB_1F45
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_0970:
    TST.W   LAB_1FB0
    BEQ.S   .LAB_0971

    JSR     LAB_09A9(PC)

.LAB_0971:
    MOVEQ   #1,D0
    CMP.L   LAB_1E84,D0
    BNE.S   .LAB_0972

    BSR.W   LAB_092C

.LAB_0972:
    TST.W   LAB_2263
    BNE.S   .LAB_0973

    JSR     LAB_08C2(PC)

.LAB_0973:
    JSR     LAB_0671(PC)

    TST.W   LAB_2263
    BNE.S   .LAB_0974

    JSR     LAB_09BC(PC)

.LAB_0974:
    TST.W   LAB_2264
    BEQ.W   .LAB_097C

    JSR     ESQFUNC_JMP_TBL_CLEANUP_ProcessAlerts(PC)

    TST.L   LAB_1E88
    BEQ.S   .LAB_0975

    CLR.L   LAB_1E88
    BSR.W   LAB_096F

.LAB_0975:
    TST.W   LAB_1B83
    BEQ.W   .LAB_097C

    BTST    #1,LAB_1EE5
    BEQ.S   .LAB_0976

    TST.W   LAB_2263
    BNE.S   .LAB_0976

    BCLR    #1,LAB_1EE5
    JSR     LAB_09B0(PC)

    BRA.S   .LAB_0977

.LAB_0976:
    BTST    #0,LAB_1EE5
    BEQ.S   .LAB_0977

    TST.W   LAB_2263
    BNE.S   .LAB_0977

    BCLR    #0,LAB_1EE5
    PEA     1.W
    JSR     LAB_0A7C(PC)

    ADDQ.W  #4,A7

.LAB_0977:
    TST.L   GLOB_REF_LONG_DF0_LOGO_LST_DATA
    BNE.S   .LAB_0978

    TST.W   LAB_2263
    BNE.S   .LAB_0978

    MOVE.W  LAB_22A9,D0
    MOVE.L  D0,D1
    ANDI.W  #$fffd,D1
    MOVE.W  D1,LAB_22A9

.LAB_0978:
    MOVE.B  LAB_1DD6,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_0979

    TST.L   GLOB_REF_LONG_GFX_G_ADS_DATA
    BNE.S   .LAB_0979

    TST.W   LAB_2263
    BNE.S   .LAB_0979

    MOVE.W  LAB_22A9,D0
    ANDI.W  #$fffe,D0
    MOVE.W  D0,LAB_22A9

.LAB_0979:
    TST.L   LAB_1B25
    BNE.S   .LAB_097A

    TST.L   LAB_1B23
    BEQ.S   .LAB_097A

    CLR.L   -(A7)
    JSR     LAB_09F9(PC)

    ADDQ.W  #4,A7

.LAB_097A:
    CMPI.L  #$1,LAB_1B28
    BGE.S   .LAB_097B

    CLR.L   -(A7)
    JSR     LAB_0A76(PC)

    ADDQ.W  #4,A7
    BRA.S   .LAB_097C

.LAB_097B:
    MOVE.B  LAB_1DD6,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_097C

    CMPI.L  #$2,LAB_1B27
    BGE.S   .LAB_097C

    TST.W   LAB_2263
    BNE.S   .LAB_097C

    PEA     1.W
    JSR     LAB_0A76(PC)

    ADDQ.W  #4,A7

.LAB_097C:
    JSR     LAB_09BE(PC)

    TST.B   LAB_1E89
    BEQ.S   .return

    TST.B   LAB_1FA9
    BNE.S   .return

    CLR.B   LAB_1E89
    JSR     LAB_08DE(PC)

.return:
    RTS

;!======

LAB_097E:
    TST.W   LAB_1DE5
    BEQ.S   .return

    BSR.W   LAB_0970

.return:
    RTS

;!======

    JSR     LAB_08C2(PC)

    TST.W   LAB_2264
    BEQ.S   .LAB_0980

    JSR     ESQFUNC_JMP_TBL_CLEANUP_ProcessAlerts(PC)

.LAB_0980:
    JSR     LAB_09BE(PC)

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_PruneEntryTextPointers   (PruneEntryTextPointers??)
; ARGS:
;   stack +10: maxIndex (D7)
; RET:
;   D0: none
; CLOBBERS:
;   D0/D4-D7/A0-A1
; CALLS:
;   LAB_0B44 (deallocate)
; READS:
;   LAB_2231, LAB_2233, LAB_2236
; WRITES:
;   LAB_2236[entry].field56[] (pointer array cleared)
; DESC:
;   Walks the entry tables and frees extra non-null text pointers up to the
;   given index, leaving the first non-null pointer intact.
; NOTES:
;   The inner loop runs down from min(maxIndex, 34).
;------------------------------------------------------------------------------
ESQFUNC_PruneEntryTextPointers:
LAB_0981:
    LINK.W  A5,#-20
    MOVEM.L D4-D7,-(A7)

    MOVE.W  10(A5),D7
    MOVEQ   #0,D4

.entry_loop:
    MOVE.W  LAB_2231,D0
    CMP.W   D0,D4
    BGE.S   .return_status

    MOVE.L  D4,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    LEA     LAB_2236,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    MOVEQ   #0,D6
    MOVEQ   #34,D0
    CMP.W   D0,D7
    BGT.S   .cap_limit

    MOVE.L  D7,D0
    EXT.L   D0
    BRA.S   .set_limit

.cap_limit:
    MOVEQ   #34,D0

.set_limit:
    MOVE.L  D0,D5

.slot_loop:
    TST.W   D5
    BMI.S   .next_entry

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    MOVEA.L 56(A0,D0.L),A0
    MOVE.L  A0,-12(A5)
    MOVE.L  A0,D0
    BEQ.S   .next_slot

    TST.W   D6
    BEQ.S   .mark_first_seen

    MOVE.L  A0,-(A7)
    CLR.L   -(A7)
    JSR     LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    CLR.L   56(A0,D0.L)
    BRA.S   .next_slot

.mark_first_seen:
    MOVEQ   #1,D6

.next_slot:
    SUBQ.W  #1,D5
    BRA.S   .slot_loop

.next_entry:
    ADDQ.W  #1,D4
    BRA.S   .entry_loop

.return_status:
    MOVEM.L (A7)+,D4-D7
    UNLK    A5
    RTS

;!======

LAB_098A:
    LINK.W  A5,#0

    MOVE.L  D7,-(A7)
    MOVE.L  12(A5),D7
    MOVE.W  #1,LAB_1ECD
    TST.L   LAB_2260
    BEQ.S   LAB_098B

    MOVEQ   #0,D0
    MOVE.L  D0,LAB_225F
    MOVE.L  D0,LAB_2260
    MOVE.W  #$90,LAB_1F53
    MOVE.W  #$230,LAB_1F54
    JSR     LAB_0C9B

LAB_098B:
    TST.L   D7
    BNE.S   LAB_098C

    MOVEQ   #0,D0
    MOVE.L  D0,LAB_2261
    BRA.S   LAB_098D

LAB_098C:
    MOVEQ   #2,D0
    MOVE.L  D0,LAB_2261
    TST.L   LAB_2262
    BNE.S   LAB_098D

    CLR.L   LAB_225F

LAB_098D:
    MOVE.L  D7,LAB_2262
    MOVE.L  (A7)+,D7

    UNLK    A5
    RTS

;!======

; Draw the contents of the ESC -> Version screen
DRAW_ESC_MENU_VERSION_SCREEN:
    LINK.W  A5,#-84

    CLR.W   LAB_2252

    ; GLOB_REF_RASTPORT_1 seems to be a rastport that's used a lot in here.
    MOVEA.L GLOB_REF_RASTPORT_1,A1

    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    ; Build "Build Number: '%ld%s'" string
    MOVE.L  GLOB_PTR_STR_BUILD_ID,-(A7)     ; parameter 2
    MOVE.L  GLOB_LONG_BUILD_NUMBER,-(A7)    ; parameter 1
    PEA     GLOB_STR_BUILD_NUMBER_FORMATTED ; format string
    PEA     -81(A5)                         ; result string pointer
    JSR     JMP_TBL_PRINTF_2(PC)            ; call printf

    ; Display string at position
    PEA     -81(A5)                         ; string
    PEA     330.W                           ; y
    PEA     175.W                           ; x
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)                  ; rastport
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    LEA     32(A7),A7

    MOVEQ   #1,D0                           ; Set D0 to 1
    CMP.L   GLOB_LONG_ROM_VERSION_CHECK,D0  ; And compare GLOB_LONG_ROM_VERSION_CHECK with it.
    BNE.S   .setRomVersion2_04              ; If it's not equal, jump to LAB_098F

    LEA     GLOB_STR_ROM_VERSION_1_3,A0     ; Load the effective address of the 1.3 string to A0
    BRA.S   LAB_0990                        ; and jump to LAB_0990

.setRomVersion2_04:
    LEA     GLOB_STR_ROM_VERSION_2_04,A0    ; Load the effective address of the 2.04 string to A0

LAB_0990:
    MOVE.L  A0,-(A7)                        ; parameter 1
    PEA     GLOB_STR_ROM_VERSION_FORMATTED  ; format string
    PEA     -81(A5)                         ; result string pointer
    JSR     JMP_TBL_PRINTF_2(PC)            ; call printf

    PEA     -81(A5)                         ; string
    PEA     360.W                           ; y
    PEA     175.W                           ; x
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)                  ; rastport
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    PEA     GLOB_STR_PUSH_ANY_KEY_TO_CONTINUE_1 ; string
    PEA     390.W                           ; y
    PEA     175.W                           ; x
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)                  ; rastport
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_DrawMemoryStatusScreen   (DrawMemoryStatusScreen)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1
; CALLS:
;   _LVOSetAPen, _LVOSetDrMd, _LVOAvailMem, JMP_TBL_PRINTF_2,
;   JMP_TBL_DISPLAY_TEXT_AT_POSITION_1, JMP_TBL_CALCULATE_H_T_C_MAX_VALUES,
;   ESQFUNC_JMP_TBL_PARSEINI_UpdateCtrlHDeltaMax
; READS:
;   LAB_2252, LAB_226A, LAB_1DF0, LAB_2285, DATACErrs, LAB_2287,
;   LAB_2347/2348/2349, LAB_228A, GLOB_WORD_H_VALUE, GLOB_WORD_T_VALUE,
;   GLOB_WORD_MAX_VALUE, CTRL_H, LAB_2282, LAB_2283, LAB_2230/LAB_222D,
;   LAB_2238/LAB_2239, LAB_224A/LAB_222E, LAB_223C/223B/2244/223D,
;   LAB_2276/2275/227E/2277, LAB_2241/227B/225C, LAB_223E,
;   GLOB_WORD_CURRENT_HOUR, LAB_2270
; WRITES:
;   LAB_2252 (early return gate), temporary text buffer on stack
; DESC:
;   Draws the ESC diagnostics memory/status screen with data/CTRL counts,
;   available memory totals, and various clock/calendar diagnostics.
; NOTES:
;   Uses LAB_1DF0 bitmask to select which memory types to show.
;------------------------------------------------------------------------------
; draw the screen showing available memory
ESQFUNC_DrawMemoryStatusScreen:
LAB_0991:
    LINK.W  A5,#-80
    MOVEM.L D2-D7,-(A7)

    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  4(A0),-76(A5)
    MOVE.L  #GLOB_REF_696_400_BITMAP,4(A0)
    TST.W   LAB_2252
    BEQ.W   .return

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    MOVE.W  LAB_226A,D0
    BNE.W   .draw_calendar_section

    MOVEQ   #0,D0
    MOVE.W  LAB_2285,D0
    MOVE.W  DATACErrs,D1
    EXT.L   D1
    MOVE.W  LAB_2287,D2
    EXT.L   D2

    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     GLOB_STR_DATA_CMDS_CERRS_LERRS
    PEA     -72(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    PEA     -72(A5)
    PEA     112.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    MOVEQ   #0,D0
    MOVE.W  LAB_2347,D0
    MOVE.W  LAB_2348,D1
    EXT.L   D1
    MOVE.W  LAB_2349,D2
    EXT.L   D2

    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     GLOB_STR_CTRL_CMDS_CERRS_LERRS
    PEA     -72(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    PEA     -72(A5)
    PEA     142.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    LEA     68(A7),A7
    MOVEQ   #7,D0
    AND.L   LAB_1DF0,D0
    SUBQ.L  #7,D0
    BNE.S   .check_chip_only

    MOVE.L  #$20002,D1          ; Attributes: 0x20000 = Largest
    MOVEA.L AbsExecBase,A6      ; so 0x20002 = Largest | Chip
    JSR     _LVOAvailMem(A6)

    MOVE.L  D0,D7

    MOVEQ   #4,D1               ; Attributes: 0x4 = Fast
    JSR     _LVOAvailMem(A6)

    MOVE.L  D0,D6

    MOVEQ   #2,D1               ; Attributes: 0x2 = Chip
    SWAP    D1
    JSR     _LVOAvailMem(A6)

    MOVE.L  D0,D5

    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    PEA     GLOB_STR_L_CHIP_FAST_MAX
    PEA     -72(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    LEA     20(A7),A7
    BRA.W   .draw_memory_section

.check_chip_only:
    MOVEQ   #1,D0
    AND.L   LAB_1DF0,D0
    SUBQ.L  #1,D0
    BNE.S   .check_fast_only

    MOVEQ   #2,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAvailMem(A6)

    MOVE.L  D0,D7
    MOVE.L  D7,-(A7)
    PEA     GLOB_STR_CHIP_PLACEHOLDER
    PEA     -72(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    LEA     12(A7),A7
    BRA.S   .draw_memory_section

.check_fast_only:
    MOVEQ   #2,D0
    AND.L   LAB_1DF0,D0
    SUBQ.L  #2,D0
    BNE.S   .check_max_only

    MOVEQ   #4,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAvailMem(A6)

    MOVE.L  D0,D6
    MOVE.L  D6,-(A7)
    PEA     GLOB_STR_FAST_PLACEHOLDER
    PEA     -72(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    LEA     12(A7),A7
    BRA.S   .draw_memory_section

.check_max_only:
    MOVEQ   #4,D0
    AND.L   LAB_1DF0,D0
    SUBQ.L  #4,D0
    BNE.S   .show_disabled

    MOVEQ   #2,D1
    SWAP    D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAvailMem(A6)

    MOVE.L  D0,D5
    MOVE.L  D5,-(A7)
    PEA     GLOB_STR_MAX_PLACEHOLDER
    PEA     -72(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    LEA     12(A7),A7
    BRA.S   .draw_memory_section

.show_disabled:
    PEA     GLOB_STR_MEMORY_TYPES_DISABLED
    PEA     -72(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    ADDQ.W  #8,A7

.draw_memory_section:
    PEA     -72(A5)
    PEA     172.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    MOVEQ   #0,D0
    MOVE.W  LAB_228A,D0
    MOVE.L  D0,(A7)
    PEA     GLOB_STR_DATA_OVERRUNS_FORMATTED
    PEA     -72(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    PEA     -72(A5)
    PEA     202.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    JSR     JMP_TBL_CALCULATE_H_T_C_MAX_VALUES(PC)

    MOVE.L  D0,D4
    MOVEQ   #0,D0
    MOVE.W  GLOB_WORD_H_VALUE,D0
    MOVEQ   #0,D1
    MOVE.W  GLOB_WORD_T_VALUE,D1
    MOVEQ   #0,D2
    MOVE.W  GLOB_WORD_MAX_VALUE,D2
    MOVE.L  D2,(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     GLOB_STR_DATA_H_T_C_MAX_FORMATTED
    PEA     -72(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    PEA     -72(A5)
    PEA     232.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    LEA     76(A7),A7
    JSR     ESQFUNC_JMP_TBL_PARSEINI_UpdateCtrlHDeltaMax(PC)

    MOVE.L  D0,D4
    MOVEQ   #0,D0
    MOVE.W  CTRL_H,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2282,D1
    MOVEQ   #0,D2
    MOVE.W  LAB_2283,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     GLOB_STR_CTRL_H_T_C_MAX_FORMATTED
    PEA     -72(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    PEA     -72(A5)
    PEA     262.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    LEA     40(A7),A7

.draw_calendar_section:
    MOVE.W  LAB_226A,D0
    SUBQ.W  #1,D0
    BNE.W   .return

    MOVEQ   #0,D0
    MOVE.B  LAB_2230,D0
    MOVEQ   #0,D1
    MOVE.B  LAB_222D,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     GLOB_STR_JULIAN_DAY_NEXT_FORMATTED
    PEA     -72(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    PEA     -72(A5)                                 ; Text address to display
    PEA     112.W                                   ; X position
    PEA     40.W                                    ; Y position
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)               ; Rastport
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    MOVEQ   #0,D0
    MOVE.B  LAB_2238,D0
    MOVEQ   #0,D1
    MOVE.B  LAB_2239,D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     GLOB_STR_JDAY1_JDAY2_FORMATTED
    PEA     -72(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    PEA     -72(A5)
    PEA     142.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    MOVEQ   #0,D0
    MOVE.B  LAB_224A,D0
    MOVEQ   #0,D1
    MOVE.B  LAB_222E,D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     GLOB_STR_CURCLU_NXTCLU_FORMATTED
    PEA     -72(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    LEA     72(A7),A7
    PEA     -72(A5)
    PEA     172.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    MOVE.W  LAB_223C,D0
    EXT.L   D0
    MOVE.W  LAB_223B,D1
    EXT.L   D1
    MOVE.W  LAB_2244,D2
    EXT.L   D2
    MOVE.W  LAB_223D,D3
    EXT.L   D3
    MOVE.L  D3,(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     GLOB_STR_C_DATE_C_MONTH_LP_YR_FORMATTED
    PEA     -72(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    PEA     -72(A5)
    PEA     202.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    MOVE.W  LAB_2276,D0
    EXT.L   D0
    MOVE.W  LAB_2275,D1
    EXT.L   D1
    MOVE.W  LAB_227E,D2
    EXT.L   D2
    MOVE.W  LAB_2277,D3
    EXT.L   D3
    MOVE.L  D3,(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     GLOB_STR_B_DATE_B_MONTH_LP_YR_FORMATTED
    PEA     -72(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    LEA     72(A7),A7
    PEA     -72(A5)
    PEA     232.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    MOVE.W  LAB_2241,D0
    EXT.L   D0
    MOVE.W  LAB_227B,D1
    EXT.L   D1
    MOVE.W  LAB_225C,D2
    EXT.L   D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     GLOB_STR_C_DST_B_DST_PSHIFT_FORMATTED
    PEA     -72(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    PEA     -72(A5)
    PEA     262.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    MOVE.W  LAB_223E,D0
    EXT.L   D0
    MOVE.W  GLOB_WORD_CURRENT_HOUR,D1
    EXT.L   D1
    MOVEQ   #0,D2
    MOVE.W  LAB_2270,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     GLOB_STR_C_HOUR_B_HOUR_CS_FORMATTED
    PEA     -72(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    PEA     -72(A5)
    PEA     292.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMP_TBL_DISPLAY_TEXT_AT_POSITION_1(PC)

    LEA     80(A7),A7

.return:
    MOVEA.L GLOB_REF_RASTPORT_1,A0
    MOVE.L  -76(A5),4(A0)

    MOVEM.L (A7)+,D2-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_DrawDiagnosticsScreen   (DrawDiagnosticsScreen??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1
; CALLS:
;   _LVOSetFont, ESQFUNC_JMP_TBL_SCRIPT_ReadCiaBBit5Mask,
;   ESQFUNC_JMP_TBL_SCRIPT_GetCtrlLineFlag, ESQFUNC_JMP_TBL_SCRIPT_ReadCiaBBit3Flag,
;   JMP_TBL_PRINTF_2, JMP_TBL_DISPLAY_TEXT_AT_POSITION_1,
;   ESQFUNC_JMP_TBL_PARSEINI_UpdateCtrlHDeltaMax
; READS:
;   LAB_1EB6, LAB_2118, LAB_1EB8/1EB9, LAB_1EBA/1EBB, LAB_1EBC/1EBD,
;   GLOB_HANDLE_TOPAZ_FONT, GLOB_REF_GRAPHICS_LIBRARY, LAB_2216
; WRITES:
;   LAB_1E26/1E27/1E28/1E29/1E2A, LAB_1E55/1E56/1E57 (status fields),
;   LAB_1E26/1E27/1E28/1E29/1E2A (cleared/initialized), stack buffers
; DESC:
;   Builds and renders the ESC diagnostics screen, selecting status strings
;   based on multiple subsystem checks and a mode selector.
; NOTES:
;   Uses several helper probes (CIA bit/flag reads) to choose message text.
;------------------------------------------------------------------------------
; Printing of more diagnostic data
ESQFUNC_DrawDiagnosticsScreen:
LAB_0999:
    LINK.W  A5,#-164
    MOVEM.L D2-D7,-(A7)

    LEA     LAB_1EB6,A0
    LEA     -148(A5),A1
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.W  #$fff,D0
    MOVE.W  D0,LAB_1E27
    MOVE.W  D0,LAB_1E56
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_1E26
    MOVE.W  D0,LAB_1E55
    MOVE.W  D0,LAB_1E28
    MOVE.W  D0,LAB_1E57
    MOVE.W  D0,LAB_1E29
    MOVE.W  D0,LAB_1E2A

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    MOVEA.L GLOB_HANDLE_TOPAZ_FONT,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    JSR     ESQFUNC_JMP_TBL_SCRIPT_ReadCiaBBit5Mask(PC)

    TST.B   D0
    BEQ.S   .status_a_false

    LEA     LAB_1EB8,A0

    BRA.S   .status_a_selected

.status_a_false:
    LEA     LAB_1EB9,A0

.status_a_selected:
    MOVE.L  A0,24(A7)
    JSR     ESQFUNC_JMP_TBL_SCRIPT_GetCtrlLineFlag(PC)

    TST.B   D0
    BEQ.S   .status_b_false

    LEA     LAB_1EBA,A0
    BRA.S   .status_b_selected

.status_b_false:
    LEA     LAB_1EBB,A0

.status_b_selected:
    MOVE.L  A0,28(A7)
    JSR     ESQFUNC_JMP_TBL_SCRIPT_ReadCiaBBit3Flag(PC)

    TST.B   D0
    BEQ.S   .status_c_false

    LEA     LAB_1EBC,A0
    BRA.S   .status_c_selected

.status_c_false:
    LEA     LAB_1EBD,A0

.status_c_selected:
    MOVE.W  LAB_2118,D0
    SUBQ.W  #2,D0
    BNE.S   .select_mode_two

    LEA     LAB_1EBE,A1
    BRA.S   .format_main_line

.select_mode_two:
    MOVE.W  LAB_2118,D0
    SUBQ.W  #1,D0
    BNE.S   .select_mode_one

    LEA     LAB_1EBF,A1
    BRA.S   .format_main_line

.select_mode_one:
    LEA     LAB_1EC0,A1

.format_main_line:
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  36(A7),-(A7)
    MOVE.L  36(A7),-(A7)
    PEA     LAB_1EB7
    PEA     -132(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     92.W
    PEA     -132(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    MOVE.W  LAB_2346,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     -148(A5),A0
    ADDA.L  D0,A0
    MOVE.W  LAB_1F45,D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  (A0),-(A7)
    PEA     LAB_1EC1
    PEA     -132(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     110.W
    PEA     -132(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    MOVEQ   #0,D0
    MOVE.W  LAB_1DDE,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_1DDF,D1
    MOVE.L  LAB_2323,(A7)
    MOVE.L  LAB_2322,-(A7)
    MOVE.L  LAB_1FE8,-(A7)
    MOVE.L  LAB_1FE7,-(A7)
    MOVE.L  LAB_1FE6,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1EC2
    PEA     -132(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    LEA     92(A7),A7
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     128.W
    PEA     -132(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    LEA     12(A7),A7
    MOVE.W  LAB_223B,D0
    EXT.L   D0
    MOVE.W  LAB_223C,D1
    EXT.L   D1
    MOVE.W  LAB_223D,D2
    EXT.L   D2
    MOVE.W  LAB_223E,D3
    EXT.L   D3
    MOVE.W  LAB_223F,D4
    EXT.L   D4
    MOVE.W  GLOB_REF_CLOCKDATA_STRUCT,D5
    EXT.L   D5
    TST.W   LAB_2243
    BEQ.S   LAB_09A3

    LEA     LAB_1EC4,A0
    BRA.S   LAB_09A4

LAB_09A3:
    LEA     LAB_1EC5,A0

LAB_09A4:
    MOVE.W  LAB_2325,D6
    EXT.L   D6
    MOVE.L  D6,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1EC3
    PEA     -132(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     146.W
    PEA     -132(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    MOVE.L  #$20002,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAvailMem(A6)

    MOVE.L  D0,76(A7)
    MOVEQ   #4,D1
    JSR     _LVOAvailMem(A6)

    MOVE.L  D0,80(A7)
    MOVEQ   #2,D1
    SWAP    D1
    JSR     _LVOAvailMem(A6)

    MOVE.L  D0,(A7)
    MOVE.L  80(A7),-(A7)
    MOVE.L  80(A7),-(A7)
    PEA     LAB_1EC6
    PEA     -132(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    LEA     68(A7),A7
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     164.W
    PEA     -132(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    JSR     JMP_TBL_CALCULATE_H_T_C_MAX_VALUES(PC)

    MOVE.L  D0,D7
    MOVEQ   #0,D0
    MOVE.W  LAB_2285,D0
    MOVE.W  DATACErrs,D1
    EXT.L   D1
    MOVE.W  LAB_2287,D2
    EXT.L   D2
    MOVEQ   #0,D3
    MOVE.W  GLOB_WORD_MAX_VALUE,D3
    MOVE.L  D7,(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1EC7
    PEA     -132(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     182.W
    PEA     -132(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    MOVEQ   #0,D0
    MOVE.W  LAB_2347,D0
    MOVE.W  LAB_2348,D1
    EXT.L   D1
    MOVE.W  LAB_2349,D2
    EXT.L   D2
    MOVEQ   #0,D3
    MOVE.W  LAB_2283,D3
    MOVE.L  D0,72(A7)
    MOVE.L  D1,76(A7)
    MOVE.L  D2,80(A7)
    MOVE.L  D3,84(A7)
    JSR     ESQFUNC_JMP_TBL_PARSEINI_UpdateCtrlHDeltaMax(PC)

    MOVE.L  D0,(A7)
    MOVE.L  84(A7),-(A7)
    MOVE.L  84(A7),-(A7)
    MOVE.L  84(A7),-(A7)
    MOVE.L  84(A7),-(A7)
    PEA     LAB_1EC8
    PEA     -132(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    LEA     72(A7),A7
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     200.W
    PEA     -132(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,LAB_1EB1
    MOVE.W  LAB_234A,D0
    EXT.L   D0
    TST.W   LAB_1E87
    BEQ.S   LAB_09A5

    LEA     GLOB_STR_TRUE_2,A0
    BRA.S   LAB_09A6

LAB_09A5:
    LEA     GLOB_STR_FALSE_2,A0

LAB_09A6:
    MOVE.W  LAB_211C,D1
    EXT.L   D1
    MOVE.B  LAB_1D13,D2
    EXT.W   D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_1EB1,-(A7)
    PEA     LAB_1EC9
    PEA     -132(A5)
    JSR     JMP_TBL_PRINTF_2(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    PEA     218.W
    PEA     -132(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_09AD(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    MOVEM.L -188(A5),D2-D7
    UNLK    A5
    RTS

;!======

LAB_09A7:
    JMP     LAB_167E

LAB_09A8:
    JMP     LAB_136C

LAB_09A9:
    JMP     LAB_03CF

ESQFUNC_JMP_TBL_PARSEINI_UpdateCtrlHDeltaMax:
LAB_09AA:
    JMP     PARSEINI_UpdateCtrlHDeltaMax

LAB_09AB:
    JMP     ESQ_ClampBannerCharRange

ESQFUNC_JMP_TBL_SCRIPT_ReadCiaBBit3Flag:
LAB_09AC:
    JMP     SCRIPT_ReadCiaBBit3Flag

LAB_09AD:
    JMP     LAB_181E

ESQFUNC_JMP_TBL_SCRIPT_GetCtrlLineFlag:
LAB_09AE:
    JMP     SCRIPT_GetCtrlLineFlag

LAB_09AF:
    JMP     LAB_0F91

LAB_09B0:
    JMP     LAB_167D

LAB_09B1:
    JMP     LAB_148E

LAB_09B2:
    JMP     LAB_0E2D

ESQFUNC_JMP_TBL_CLEANUP_ProcessAlerts:
LAB_09B3:
    ; Update on-screen alerts and pending timers (cleanup module owns the UI state).
    JMP     CLEANUP_ProcessAlerts

LAB_09B4:
    JMP     ESQ_GetHalfHourSlotIndex

ESQFUNC_JMP_TBL_CLEANUP_DrawClockBanner:
LAB_09B5:
    JMP     CLEANUP_DrawClockBanner

JMP_TBL_CALCULATE_H_T_C_MAX_VALUES:
    JMP     CALCULATE_H_T_C_MAX_VALUES

LAB_09B7:
    JMP     LADFUNC_UpdateHighlightState

LAB_09B8:
    JMP     LAB_136A

ESQFUNC_JMP_TBL_SCRIPT_ReadCiaBBit5Mask:
LAB_09B9:
    JMP     SCRIPT_ReadCiaBBit5Mask

LAB_09BA:
    JMP     LAB_1477

LAB_09BB:
    JMP     ESQ_TickGlobalCounters

LAB_09BC:
    JMP     SCRIPT_HandleSerialCtrlCmd

JMP_TBL_INTB_RBF_EXEC:
    JMP     INTB_RBF_EXEC

LAB_09BE:
    JMP     LAB_168B

LAB_09BF:
    JMP     ESQ_PollCtrlInput

LAB_09C0:
    JMP     LAB_0F93

LAB_09C1:
    JMP     LAB_1955

;!======

    MOVEQ   #97,D0

;!======

LAB_09C2:
    LINK.W  A5,#-32
    MOVEM.L D2/D4-D7,-(A7)
    MOVE.W  10(A5),D7
    MOVE.L  LAB_1ED1,-4(A5)
    MOVEQ   #0,D5
    TST.W   D7
    BNE.S   .LAB_09C3

    MOVE.L  BRUSH_ScriptPrimarySelection,-24(A5) ; prefer script-selected brush if present
    BRA.S   .LAB_09C4

.LAB_09C3:
    MOVEA.L BRUSH_ScriptSecondarySelection,A0 ; fall back to secondary slot when requested
    MOVE.L  A0,-24(A5)

.LAB_09C4:
    TST.L   -24(A5)
    BNE.W   .LAB_09CF

    MOVE.W  LAB_2153,D0
    SUBQ.W  #1,D0
    BNE.S   .LAB_09C5

    MOVE.W  LAB_2364,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    BRA.S   .LAB_09C6

.LAB_09C5:
    MOVE.W  LAB_2364,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2235,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)

.LAB_09C6:
    MOVEA.L -8(A5),A0
    ADDA.W  #$2b,A0
    PEA     2.W
    PEA     LAB_1EE6
    MOVE.L  A0,-(A7)
    JSR     JMP_TBL_LAB_195B_2(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .LAB_09C7

    MOVE.L  BRUSH_SelectedNode,-4(A5)
    MOVEQ   #1,D5
    BRA.W   .LAB_09D0

.LAB_09C7:
    MOVEA.L -8(A5),A0
    ADDA.W  #$2b,A0
    PEA     2.W
    PEA     LAB_1EE7
    MOVE.L  A0,-(A7)
    JSR     JMP_TBL_LAB_195B_2(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .LAB_09CD

.LAB_09C8:
    TST.L   -4(A5)
    BEQ.S   .LAB_09CC

    TST.L   D5
    BNE.S   .LAB_09CC

    MOVEA.L -4(A5),A0
    MOVE.L  364(A0),-20(A5)

.LAB_09C9:
    TST.L   -20(A5)
    BEQ.S   .LAB_09CB

    TST.L   D5
    BNE.S   .LAB_09CB

    MOVEA.L -8(A5),A0
    ADDA.W  #12,A0
    MOVE.L  -20(A5),-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0C76(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .LAB_09CA

    MOVEQ   #1,D5

.LAB_09CA:
    MOVEA.L -20(A5),A0
    MOVE.L  8(A0),-20(A5)
    BRA.S   .LAB_09C9

.LAB_09CB:
    TST.L   D5
    BNE.S   .LAB_09C8

    MOVEA.L -4(A5),A0
    MOVE.L  368(A0),-4(A5)
    BRA.S   .LAB_09C8

.LAB_09CC:
    TST.L   D5
    BNE.S   .LAB_09D0

    MOVEA.L -8(A5),A0
    BTST    #4,27(A0)
    BEQ.S   .LAB_09D0

    TST.L   LAB_1ED0
    BEQ.S   .LAB_09D0

    MOVEQ   #1,D5
    MOVE.L  LAB_1ED0,-4(A5)
    BRA.S   .LAB_09D0

.LAB_09CD:
    TST.L   -4(A5)
    BEQ.S   .LAB_09D0

    TST.L   D5
    BNE.S   .LAB_09D0

    MOVEA.L -8(A5),A0
    ADDA.W  #$2b,A0
    MOVEA.L -4(A5),A1
    ADDA.W  #$21,A1
    PEA     2.W
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     JMP_TBL_LAB_195B_2(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .LAB_09CE

    MOVEQ   #1,D5

.LAB_09CE:
    TST.L   D5
    BNE.S   .LAB_09CD

    MOVEA.L -4(A5),A0
    MOVE.L  368(A0),-4(A5)
    BRA.S   .LAB_09CD

.LAB_09CF:
    MOVEQ   #1,D5
    MOVE.L  -24(A5),-4(A5)

.LAB_09D0:
    TST.L   D5
    BNE.S   .LAB_09D1

    MOVE.L  BRUSH_SelectedNode,-4(A5)

.LAB_09D1:
    MOVEA.L GLOB_REF_RASTPORT_2,A1
    MOVEQ   #31,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #31,D0
    JSR     _LVOSetRast(A6)

    TST.L   -4(A5)
    BEQ.S   .LAB_09D3

    TST.L   BRUSH_SelectedNode
    BNE.S   .LAB_09D2

    TST.L   D5
    BEQ.S   .LAB_09D3

.LAB_09D2:
    MOVEQ   #0,D0
    MOVEA.L LAB_2216,A0
    MOVE.W  2(A0),D0
    SUBQ.L  #1,D0
    MOVEQ   #0,D1
    MOVE.W  4(A0),D1
    SUBQ.L  #1,D1
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  GLOB_REF_RASTPORT_2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     LAB_0AB4(PC)

    LEA     28(A7),A7

.LAB_09D3:
    TST.L   -4(A5)
    BEQ.W   .LAB_09D9

    MOVEA.L -4(A5),A0
    TST.L   328(A0)
    BEQ.S   .LAB_09D4

    MOVE.L  328(A0),D0
    MOVEQ   #1,D1
    CMP.L   D1,D0
    BEQ.S   .LAB_09D4

    SUBQ.L  #3,D0
    BNE.S   .LAB_09D6

.LAB_09D4:
    PEA     5.W
    JSR     LAB_0BF4(PC)

    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    MOVE.L  D1,D4
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  184(A0),D0
    MOVE.L  D0,(A7)
    JSR     LAB_0BF4(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    MOVEQ   #0,D6
    MOVE.L  D1,-32(A5)

.LAB_09D5:
    CMP.L   -32(A5),D6
    BGE.S   .LAB_09D6

    CMP.L   D4,D6
    BGE.S   .LAB_09D6

    LEA     LAB_2295,A0
    ADDA.L  D6,A0
    MOVEA.L -4(A5),A1
    MOVE.L  D6,D0
    ADDI.L  #$e8,D0
    MOVE.B  0(A1,D0.L),(A0)
    ADDQ.L  #1,D6
    BRA.S   .LAB_09D5

.LAB_09D6:
    MOVEQ   #1,D0
    MOVEA.L -4(A5),A0
    CMP.L   328(A0),D0
    BNE.S   .LAB_09D7

    BSR.W   LAB_0A45

    BRA.S   .return

.LAB_09D7:
    MOVEQ   #3,D0
    CMP.L   328(A0),D0
    BNE.S   .return

    MOVEQ   #0,D6

.LAB_09D8:
    MOVEQ   #12,D0
    CMP.L   D0,D6
    BGE.S   .return

    LEA     LAB_2295,A0
    ADDA.L  D6,A0
    LEA     LAB_1ECC,A1
    ADDA.L  D6,A1
    MOVE.B  (A1),(A0)
    ADDQ.L  #1,D6
    BRA.S   .LAB_09D8

.LAB_09D9:
    BSR.W   LAB_0A45

.return:
    MOVEQ   #1,D0
    MOVEM.L (A7)+,D2/D4-D7
    UNLK    A5
    RTS

;!======

LAB_09DB:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    CLR.L   -4(A5)
    CLR.L   -(A7)
    PEA     LAB_1ED4
    JSR     LAB_0AA4(PC)

    ADDQ.W  #8,A7
    MOVEQ   #0,D7

.LAB_09DC:
    MOVEQ   #6,D0
    CMP.L   D0,D7
    BGE.W   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_1EDE,A0
    ADDA.L  D0,A0
    MOVE.L  -4(A5),-(A7)
    MOVE.L  (A0),-(A7)
    JSR     LAB_0AA7(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    MOVE.L  D7,D0
    CMPI.L  #$6,D0
    BCC.S   .LAB_09DF

    ADD.W   D0,D0
    MOVE.W  .LAB_09DD(PC,D0.W),D0
    JMP     .LAB_09DD+2(PC,D0.W)

; switch/jumptable
.LAB_09DD:
    DC.W    .LAB_09DD_000A-.LAB_09DD-2
	DC.W    .LAB_09DD_0016-.LAB_09DD-2
    DC.W    .LAB_09DD_0022-.LAB_09DD-2
	DC.W    .LAB_09DD_002E-.LAB_09DD-2
    DC.W    .LAB_09DD_003A-.LAB_09DD-2
    DC.W    .LAB_09DD_0046-.LAB_09DD-2

.LAB_09DD_000A:
    MOVEA.L -4(A5),A0
    MOVE.B  #$8,190(A0)
    BRA.S   .LAB_09DF

.LAB_09DD_0016:
    MOVEA.L -4(A5),A0
    MOVE.B  #$9,190(A0)
    BRA.S   .LAB_09DF

.LAB_09DD_0022:
    MOVEA.L -4(A5),A0
    MOVE.B  #$9,190(A0)
    BRA.S   .LAB_09DF

.LAB_09DD_002E:
    MOVEA.L -4(A5),A0
    MOVE.B  #$9,190(A0)
    BRA.S   .LAB_09DF

.LAB_09DD_003A:
    MOVEA.L -4(A5),A0
    MOVE.B  #$9,190(A0)
    BRA.S   .LAB_09DF

.LAB_09DD_0046:
    MOVEA.L -4(A5),A0
    MOVE.B  #$9,190(A0)

.LAB_09DF:
    TST.L   LAB_1B22
    BNE.S   .LAB_09E0

    MOVE.L  -4(A5),LAB_1B22

.LAB_09E0:
    ADDQ.L  #1,D7
    BRA.W   .LAB_09DC

.return:
    PEA     LAB_1ED4
    MOVE.L  LAB_1B22,-(A7)
    JSR     LAB_0AAA(PC)

    CLR.L   LAB_1B22
    MOVE.L  -12(A5),D7
    UNLK    A5
    RTS

;!======

LAB_09E2:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.L  24(A7),D7
    MOVEA.L 28(A7),A2
    MOVEA.L A2,A0

LAB_09E3:
    TST.B   (A0)+
    BNE.S   LAB_09E3

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,D6

LAB_09E4:
    TST.L   D6
    BLE.S   LAB_09E7

    MOVEA.L A3,A1
    MOVEA.L A2,A0
    MOVE.L  D6,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    CMP.L   D7,D0
    BLE.S   LAB_09E7

LAB_09E5:
    SUBQ.L  #1,D6
    TST.L   D6
    BLE.S   LAB_09E6

    MOVE.B  -1(A2,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #3,(A0)
    BEQ.S   LAB_09E5

LAB_09E6:
    TST.L   D6
    BLE.S   LAB_09E4

    MOVE.B  -1(A2,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #3,(A0)
    BEQ.S   LAB_09E4

    SUBQ.L  #1,D6
    BRA.S   LAB_09E6

LAB_09E7:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS
