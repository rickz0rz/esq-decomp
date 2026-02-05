
;!======

;------------------------------------------------------------------------------
; FUNC: GENERATE_GRID_DATE_STRING   (GenerateGridDateString??)
; ARGS:
;   stack +8: outBuffer (char *)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1/A0-A1/A3
; CALLS:
;   JMPTBL_PRINTF_4
; READS:
;   LAB_2274/2275/2276/2277, GLOB_JMPTBL_DAYS_OF_WEEK, GLOB_JMPTBL_MONTHS
; WRITES:
;   outBuffer
; DESC:
;   Formats the current grid date string into outBuffer.
; NOTES:
;   Uses GLOB_STR_GRID_DATE_FORMAT_STRING as the template.
;------------------------------------------------------------------------------
GENERATE_GRID_DATE_STRING:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3

    MOVE.W  LAB_2274,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     GLOB_JMPTBL_DAYS_OF_WEEK,A0
    ADDA.L  D0,A0
    MOVE.W  LAB_2275,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     GLOB_JMPTBL_MONTHS,A1
    ADDA.L  D0,A1
    MOVE.W  LAB_2276,D0
    EXT.L   D0
    MOVE.W  LAB_2277,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  (A1),-(A7)
    MOVE.L  (A0),-(A7)
    PEA     GLOB_STR_GRID_DATE_FORMAT_STRING
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_PRINTF_4(PC)

    LEA     24(A7),A7
    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_CopyWeatherUpdateForString   (CopyWeatherUpdateForString??)
; ARGS:
;   stack +8: outBuffer (char *)
; RET:
;   (none)
; CLOBBERS:
;   A0-A1/A3
; CALLS:
;   (none)
; READS:
;   GLOB_STR_WEATHER_UPDATE_FOR
; WRITES:
;   outBuffer
; DESC:
;   Copies the "Weather Update For" string into outBuffer.
; NOTES:
;   Previously unlabeled; appears unused in current build.
;------------------------------------------------------------------------------
SCRIPT_CopyWeatherUpdateForString:
LAB_14C5:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3

    LEA     GLOB_STR_WEATHER_UPDATE_FOR,A0
    MOVEA.L A3,A1

.copy_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_loop

    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_CheckPathExists   (CheckPathExists??)
; ARGS:
;   stack +8: path (char *)
; RET:
;   D0: 1 if lock/unlock succeeds, 0 otherwise
; CLOBBERS:
;   D0-D2/D6-D7/A3
; CALLS:
;   _LVOLock, _LVOUnLock
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Attempts a DOS lock on path and returns whether it succeeds.
; NOTES:
;   Uses lock mode -2 (shared read).
;------------------------------------------------------------------------------
SCRIPT_CheckPathExists:
LAB_14C6:
    MOVEM.L D2/D6-D7/A3,-(A7)
    MOVEA.L 20(A7),A3

    MOVEQ   #0,D7
    MOVEQ   #0,D6
    MOVE.L  A3,D1
    MOVEQ   #-2,D2
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOLock(A6)

    MOVE.L  D0,D7
    TST.L   D7
    BEQ.S   .return

    MOVE.L  D7,D1
    JSR     _LVOUnLock(A6)

    MOVEQ   #1,D6

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D2/D6-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_UpdateBannerCharTransition   (UpdateBannerCharTransition??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A4
; CALLS:
;   SCRIPT_JMPTBL_GCOMMAND_GetBannerChar, SCRIPT_JMPTBL_GCOMMAND_AdjustBannerCopperOffset
; READS:
;   LAB_2120/LAB_2121/LAB_212A, LAB_2352/2353/2354
; WRITES:
;   LAB_2121/LAB_212A, banner character (via SCRIPT_JMPTBL_GCOMMAND_AdjustBannerCopperOffset)
; DESC:
;   Advances an in-progress banner character transition toward its target.
; NOTES:
;   Disables the transition when the target is reached.
;------------------------------------------------------------------------------
SCRIPT_UpdateBannerCharTransition:
LAB_14C8:
    MOVEM.L D2-D7/A4,-(A7)

    LEA     GLOB_REF_LONG_FILE_SCRATCH,A4
    TST.W   LAB_2121
    BEQ.W   .done

    JSR     SCRIPT_JMPTBL_GCOMMAND_GetBannerChar(PC)

    MOVE.L  D0,D6
    MOVEQ   #0,D0
    MOVE.B  LAB_2352,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D1,D0
    BNE.S   .advance_step

    MOVEQ   #0,D1
    MOVE.W  D1,LAB_2121
    MOVE.W  D1,LAB_212A
    BRA.W   .done

.advance_step:
    MOVE.W  LAB_2353,D5
    MOVE.W  LAB_2120,D1
    MOVEQ   #0,D2
    CMP.W   D2,D1
    BLS.S   .calc_candidate

    ADDQ.W  #1,LAB_212A
    MOVE.W  LAB_212A,D3
    CMP.W   D1,D3
    BLT.S   .calc_candidate

    MOVE.W  LAB_2354,D3
    ADD.W   D3,D5
    MOVE.W  D2,LAB_212A

.calc_candidate:
    MOVE.L  D5,D7
    ADD.W   D6,D7
    MOVE.W  LAB_2354,D3
    TST.W   D3
    BPL.S   .check_positive_step

    MOVE.L  D7,D4
    EXT.L   D4
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    CMP.L   D1,D4
    BLT.S   .snap_to_target

.check_positive_step:
    TST.W   D3
    BLE.S   .check_zero_step

    MOVE.L  D7,D1
    EXT.L   D1
    MOVEQ   #0,D3
    MOVE.B  D0,D3
    CMP.L   D3,D1
    BGT.S   .snap_to_target

.check_zero_step:
    TST.W   LAB_2353
    BNE.S   .apply_step

    TST.W   LAB_2120
    BNE.S   .apply_step

.snap_to_target:
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D6,D0
    EXT.L   D0
    SUB.L   D0,D1
    MOVE.L  D1,D5

.apply_step:
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     SCRIPT_JMPTBL_GCOMMAND_AdjustBannerCopperOffset(PC)

    ADDQ.W  #4,A7

.done:
    MOVEM.L (A7)+,D2-D7/A4
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_BeginBannerCharTransition   (BeginBannerCharTransition??)
; ARGS:
;   stack +10: targetChar?? (word, low 16 bits used)
;   stack +14: rateOrDelay?? (word, low 16 bits used)
; RET:
;   D0: 1 if a transition was started, 0 otherwise
; CLOBBERS:
;   D0-D7
; CALLS:
;   GCOMMAND_GetBannerChar, JMPTBL_MATH_DivS32_4, JMPTBL_MATH_Mulu32_7
; READS:
;   LAB_1BC7/LAB_1BC8, GLOB_WORD_SELECT_CODE_IS_RAVESC, LAB_2121
; WRITES:
;   LAB_2352/2353/2354, LAB_2120, LAB_2121, LAB_211F
; DESC:
;   Prepares parameters for a banner-char transition toward a target value.
; NOTES:
;   Clamps target to 130..226 and rate to 0..$1D4C. Uses current banner char
;   from GCOMMAND_GetBannerChar; returns 0 if already at target or busy.
;------------------------------------------------------------------------------
SCRIPT_BeginBannerCharTransition:
    LINK.W  A5,#-12
    MOVEM.L D2/D4-D7,-(A7)

    MOVE.W  10(A5),D7
    MOVE.W  14(A5),D6

    MOVEQ   #0,D5
    MOVE.B  LAB_1BC7,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .return

    CMPI.W  #130,D7
    BGE.S   .LAB_14D1

    MOVE.W  #130,D7
    BRA.S   .LAB_14D2

.LAB_14D1:
    CMPI.W  #226,D7
    BLE.S   .LAB_14D2

    MOVE.W  #226,D7

.LAB_14D2:
    MOVEQ   #0,D0
    CMP.W   D0,D6
    BCC.S   .LAB_14D3

    MOVE.L  D0,D6
    BRA.S   .LAB_14D4

.LAB_14D3:
    CMPI.W  #$1d4c,D6
    BLS.S   .LAB_14D4

    MOVE.W  #$1d4c,D6

.LAB_14D4:
    JSR     SCRIPT_JMPTBL_GCOMMAND_GetBannerChar(PC)

    MOVE.W  D0,-12(A5)
    TST.W   LAB_2121
    BNE.W   .return

    CMP.W   D7,D0
    BEQ.W   .return

    MOVE.L  D7,D1
    MOVE.L  D7,D2
    EXT.L   D2
    EXT.L   D0
    SUB.L   D0,D2
    MOVE.L  D2,D4
    MOVE.B  D1,LAB_2352
    TST.W   GLOB_WORD_SELECT_CODE_IS_RAVESC
    BNE.S   .selectCodeIsNotRAVSEC

    MOVE.B  LAB_1BC8,D0
    MOVEQ   #'M',D1
    CMP.B   D1,D0
    BNE.S   .configValueLAB_1BC8isNotM

.selectCodeIsNotRAVSEC:
    TST.L   D4
    BPL.S   .LAB_14D6

    MOVE.L  #7500,D0
    BRA.S   .LAB_14D7

.LAB_14D6:
    MOVEQ   #0,D0

.LAB_14D7:
    MOVE.L  D0,D6

.configValueLAB_1BC8isNotM:
    MOVE.L  D6,D0
    MULU    #60,D0
    MOVE.L  #1000,D1
    JSR     JMPTBL_MATH_DivS32_4(PC)

    MOVE.L  D0,-10(A5)
    BGT.S   .LAB_14D9

    MOVE.L  D4,D1
    MOVE.W  D1,LAB_2353
    BRA.S   .LAB_14E0

.LAB_14D9:
    TST.L   D4
    BPL.S   .LAB_14DA

    MOVEQ   #-1,D1
    BRA.S   .LAB_14DB

.LAB_14DA:
    MOVEQ   #1,D1

.LAB_14DB:
    MOVE.W  D1,LAB_2354
    TST.L   D4
    BPL.S   .LAB_14DC

    MOVE.L  D4,D2
    NEG.L   D2
    BRA.S   .LAB_14DD

.LAB_14DC:
    MOVE.L  D4,D2

.LAB_14DD:
    MOVE.L  D2,D4
    MOVE.L  D4,D0
    MOVE.L  -10(A5),D1
    JSR     JMPTBL_MATH_DivS32_4(PC)

    MOVE.W  D0,LAB_2353
    EXT.L   D0
    MOVE.L  -10(A5),D1
    JSR     JMPTBL_MATH_Mulu32_7(PC)

    SUB.L   D0,D4
    BLE.S   .LAB_14DE

    MOVE.L  -10(A5),D0
    MOVE.L  D4,D1
    JSR     JMPTBL_MATH_DivS32_4(PC)

    MOVE.W  D0,LAB_2120
    BRA.S   .LAB_14DF

.LAB_14DE:
    CLR.W   LAB_2120

.LAB_14DF:
    MOVE.W  LAB_2353,D0
    MULS    LAB_2354,D0
    MOVE.W  D0,LAB_2353

.LAB_14E0:
    MOVE.L  D6,D0
    MOVEQ   #1,D5
    MOVE.W  D5,LAB_2121
    MOVE.W  D0,LAB_211F

.return:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D2/D4-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_14E2   (??)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   ??
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   ??
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_14E2:
    MOVEM.L D2-D3/D7,-(A7)

    JSR     SCRIPT_JMPTBL_GCOMMAND_GetBannerChar(PC)

    MOVE.L  D0,D7
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_2121
    MOVE.W  GLOB_REF_WORD_HEX_CODE_8E,D1
    MOVEQ   #0,D2
    MOVE.B  D1,D2
    MOVE.L  D7,D3
    EXT.L   D3
    SUB.L   D3,D2
    MOVE.B  D1,LAB_2352
    MOVE.W  D2,LAB_2353
    BGE.S   .LAB_14E3

    MOVEQ   #-1,D1
    BRA.S   .LAB_14E4

.LAB_14E3:
    MOVEQ   #1,D1

.LAB_14E4:
    MOVE.W  D0,LAB_2120
    MOVE.W  D1,LAB_2354
    TST.W   D2
    BEQ.S   .LAB_14E5

    MOVE.W  #1,LAB_2121
    BRA.S   .return

.LAB_14E5:
    MOVE.W  D0,LAB_2121

.return:
    MOVEM.L (A7)+,D2-D3/D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_InitCtrlContext   (InitCtrlContext??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0/D7/A3
; CALLS:
;   SCRIPT_SetCtrlContextMode
; READS:
;   SCRIPT_CTRL_CONTEXT (control context base)
; WRITES:
;   SCRIPT_CTRL_CONTEXT (initializes context)
; DESC:
;   Initializes the script CTRL/control context block with a mode flag of 1.
; NOTES:
;   Wrapper around SCRIPT_SetCtrlContextMode which fully clears/initializes the context struct.
;------------------------------------------------------------------------------
SCRIPT_InitCtrlContext:
    PEA     1.W
    PEA     SCRIPT_CTRL_CONTEXT
    BSR.W   SCRIPT_SetCtrlContextMode

    ADDQ.W  #8,A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_HandleSerialCtrlCmd   (HandleSerialCtrlCmd)
; ARGS:
;   (none)
; RET:
;   D0: none (status handled via globals)
; CLOBBERS:
;   D0-D7/A0-A1
; CALLS:
;   SCRIPT_ESQ_CaptureCtrlBit4StreamBufferByte, PARSEINI_CheckCtrlHChange, SCRIPT_HandleBrushCommand, LAB_1560,
;   GROUP_BA_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight, LAB_167E, LAB_154C, SCRIPT_JMPTBL_LAB_08DA, LAB_167D
; READS:
;   GLOB_WORD_SELECT_CODE_IS_RAVESC, LAB_1BC8, LAB_1DF3, LAB_1E84, LAB_212B
;   GLOB_REF_CLOCKDATA_STRUCT, GLOB_WORD_CLOCK_SECONDS
;   SCRIPT_CTRL_READ_INDEX, SCRIPT_CTRL_CHECKSUM, SCRIPT_CTRL_STATE,
;   LAB_2346/2347/2348/2349/234A, SCRIPT_CTRL_CMD_BUFFER
; WRITES:
;   LAB_234A, LAB_212B, GLOB_WORD_CLOCK_SECONDS,
;   SCRIPT_CTRL_READ_INDEX, SCRIPT_CTRL_CHECKSUM, SCRIPT_CTRL_STATE,
;   SCRIPT_CTRL_CMD_BUFFER, LAB_2347/2348/2349
; DESC:
;   Polls the CTRL input buffer and advances a small state machine to parse
;   serial control commands; dispatches actions via a jump table.
; NOTES:
;   The jump table is a compiler switch/jumptable on the input byte (0..21).
;   SCRIPT_CTRL_STATE acts as a parser state: 0=idle, 1/2/3=substates ??.
;------------------------------------------------------------------------------
SCRIPT_HandleSerialCtrlCmd:
    MOVEM.L D6-D7,-(A7)

    TST.W   GLOB_WORD_SELECT_CODE_IS_RAVESC
    BNE.S   .selectCodeIsNotRAVSEC

    MOVE.B  LAB_1BC8,D0
    MOVEQ   #'M',D1
    CMP.B   D1,D0
    BNE.S   .LAB_14EA

.selectCodeIsNotRAVSEC:
    MOVE.W  #(-1),LAB_234A
    BRA.S   .LAB_14EC

.LAB_14EA:
    TST.W   LAB_1DF3
    BEQ.S   .LAB_14EB

    MOVEQ   #0,D0
    MOVE.W  D0,LAB_234A
    BRA.W   .return

.LAB_14EB:
    MOVEQ   #1,D0
    CMP.L   LAB_1E84,D0
    BEQ.W   .return

.LAB_14EC:
    TST.W   LAB_212B
    BEQ.S   .LAB_14ED

    MOVE.W  GLOB_REF_CLOCKDATA_STRUCT,D0
    MOVE.W  GLOB_WORD_CLOCK_SECONDS,D1
    CMP.W   D1,D0
    BEQ.S   .LAB_14ED

    ADDQ.W  #1,GLOB_WORD_CLOCK_SECONDS
    CMPI.W  #3,GLOB_WORD_CLOCK_SECONDS
    BLT.S   .LAB_14ED

    CLR.W   LAB_212B
    CLR.L   -(A7)
    PEA     32.W
    JSR     SCRIPT_JMPTBL_LAB_08DA(PC)

    ADDQ.W  #8,A7

.LAB_14ED:
    JSR     PARSEINI_CheckCtrlHChange(PC)

    MOVE.L  D0,D6
    TST.W   LAB_2263
    BNE.W   .return

    TST.W   D6
    BEQ.W   .return

    MOVE.W  LAB_234A,D0
    ADDQ.W  #1,D0
    BEQ.S   .LAB_14EE

    CLR.W   LAB_234A

.LAB_14EE:
    JSR     SCRIPT_ESQ_CaptureCtrlBit4StreamBufferByte(PC)

    MOVE.L  D0,D7
    MOVE.W  SCRIPT_CTRL_STATE,D0
    TST.W   D0
    BEQ.S   .LAB_14EF

    SUBQ.W  #1,D0
    BEQ.W   .LAB_14F2

    SUBQ.W  #1,D0
    BEQ.W   .LAB_14F4

    SUBQ.W  #1,D0
    BEQ.W   .LAB_14FA

    BRA.W   .LAB_14FB

.LAB_14EF:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    SUBQ.W  #1,D0
    BLT.W   .finish_29ABA

    CMPI.W  #22,D0
    BGE.W   .finish_29ABA

    ADD.W   D0,D0
    MOVE.W  .LAB_14F0(PC,D0.W),D0
    JMP     .LAB_14F0+2(PC,D0.W)

; switch/jumptable
.LAB_14F0:
    DC.W    .LAB_14F0_0040-.LAB_14F0-2
    DC.W    .LAB_14F0_0036-.LAB_14F0-2
    DC.W    .LAB_14F0_0036-.LAB_14F0-2
    DC.W    .LAB_14F0_0036-.LAB_14F0-2
    DC.W    .LAB_14F0_0036-.LAB_14F0-2
    DC.W    .LAB_14F0_01A0-.LAB_14F0-2
    DC.W    .LAB_14F0_0036-.LAB_14F0-2
    DC.W    .LAB_14F0_01A0-.LAB_14F0-2
    DC.W    .LAB_14F0_01A0-.LAB_14F0-2
    DC.W    .LAB_14F0_01A0-.LAB_14F0-2
    DC.W    .LAB_14F0_0036-.LAB_14F0-2
    DC.W    .LAB_14F0_0040-.LAB_14F0-2
    DC.W    .LAB_14F0_002A-.LAB_14F0-2
    DC.W    .LAB_14F0_01A0-.LAB_14F0-2
    DC.W    .LAB_14F0_0040-.LAB_14F0-2
    DC.W    .LAB_14F0_0036-.LAB_14F0-2
    DC.W    .LAB_14F0_0036-.LAB_14F0-2
    DC.W    .LAB_14F0_01A0-.LAB_14F0-2
    DC.W    .LAB_14F0_01A0-.LAB_14F0-2
    DC.W    .LAB_14F0_0036-.LAB_14F0-2
    DC.W    .LAB_14F0_01A0-.LAB_14F0-2
    DC.W    .LAB_14F0_0036-.LAB_14F0-2

.LAB_14F0_002A:
    MOVE.W  #3,SCRIPT_CTRL_STATE
    BRA.W   .finish_29ABA    

.LAB_14F0_0036:
    TST.W   GLOB_WORD_SELECT_CODE_IS_RAVESC
    BNE.W   .return

.LAB_14F0_0040:
    MOVEQ   #1,D0
    LEA     SCRIPT_CTRL_CMD_BUFFER,A0
    ADDA.W  SCRIPT_CTRL_READ_INDEX,A0
    MOVE.B  D7,(A0)
    MOVEQ   #0,D1
    MOVE.B  D7,D1
    MOVE.W  D1,SCRIPT_CTRL_CHECKSUM
    MOVE.W  LAB_2347,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,LAB_2347
    MOVE.W  D0,SCRIPT_CTRL_STATE
    BRA.W   .finish_29ABA

.LAB_14F2:
    MOVE.W  SCRIPT_CTRL_READ_INDEX,D0
    MOVE.L  D0,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,SCRIPT_CTRL_READ_INDEX
    LEA     SCRIPT_CTRL_CMD_BUFFER,A0
    ADDA.W  D1,A0
    MOVE.L  D7,D0
    MOVE.B  D0,(A0)
    MOVEQ   #13,D1
    CMP.B   D1,D0
    BNE.S   .LAB_14F3

    MOVE.W  #2,SCRIPT_CTRL_STATE

.LAB_14F3:
    MOVE.W  SCRIPT_CTRL_CHECKSUM,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  D7,D1
    EOR.L   D1,D0
    MOVE.W  D0,SCRIPT_CTRL_CHECKSUM
    BRA.W   .finish_29ABA

.LAB_14F4:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.W  SCRIPT_CTRL_CHECKSUM,D1
    EXT.L   D1
    CMP.L   D1,D0
    BNE.S   .LAB_14F8

    TST.W   GLOB_WORD_SELECT_CODE_IS_RAVESC
    BEQ.S   .LAB_14F5

    MOVE.W  SCRIPT_CTRL_READ_INDEX,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     SCRIPT_CTRL_CMD_BUFFER
    PEA     SCRIPT_CTRL_CONTEXT
    BSR.W   SCRIPT_HandleBrushCommand

    BSR.W   LAB_1560

    JSR     GROUP_BA_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    CLR.L   (A7)
    JSR     LAB_167E(PC)

    LEA     12(A7),A7
    BRA.S   .LAB_14F9

.LAB_14F5:
    MOVE.W  LAB_1DDE,D0
    BEQ.S   .LAB_14F6

    SUBQ.W  #1,D0
    BNE.S   .LAB_14F7

.LAB_14F6:
    MOVE.W  SCRIPT_CTRL_READ_INDEX,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     SCRIPT_CTRL_CMD_BUFFER
    PEA     SCRIPT_CTRL_CONTEXT
    BSR.W   SCRIPT_HandleBrushCommand

    PEA     SCRIPT_CTRL_CONTEXT
    BSR.W   LAB_154C

    LEA     16(A7),A7
    BRA.S   .LAB_14F9

.LAB_14F7:
    MOVE.W  LAB_211B,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_211B
    BRA.S   .LAB_14F9

.LAB_14F8:
    PEA     1.W
    PEA     32.W
    JSR     SCRIPT_JMPTBL_LAB_08DA(PC)

    ADDQ.W  #8,A7
    MOVE.W  GLOB_REF_CLOCKDATA_STRUCT,GLOB_WORD_CLOCK_SECONDS
    MOVEQ   #1,D0
    MOVE.W  LAB_2348,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,LAB_2348
    MOVE.W  D0,LAB_212B

.LAB_14F9:
    MOVEQ   #0,D0
    MOVE.W  D0,SCRIPT_CTRL_CHECKSUM
    MOVE.W  D0,SCRIPT_CTRL_READ_INDEX
    MOVE.W  D0,SCRIPT_CTRL_STATE
    BRA.S   .finish_29ABA

.LAB_14FA:
    CLR.W   SCRIPT_CTRL_STATE
    BRA.S   .finish_29ABA

.LAB_14FB:
    MOVEQ   #0,D0
    MOVE.W  D0,SCRIPT_CTRL_CHECKSUM
    MOVE.W  D0,SCRIPT_CTRL_READ_INDEX
    MOVE.W  D0,SCRIPT_CTRL_STATE

.LAB_14F0_01A0:
.finish_29ABA:
    MOVE.W  SCRIPT_CTRL_READ_INDEX,D0
    CMPI.W  #198,D0
    BLE.S   .return

    MOVE.W  LAB_2349,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2349
    MOVEQ   #0,D0
    MOVE.W  D0,SCRIPT_CTRL_CHECKSUM
    MOVE.W  D0,SCRIPT_CTRL_READ_INDEX
    MOVE.W  LAB_2346,D1
    MOVE.W  D0,SCRIPT_CTRL_STATE
    TST.W   D1
    BNE.S   .return

    JSR     LAB_167D(PC)

.return:
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

; Dispatch helper for brush-control script commands (handles primary/secondary selection requests).
SCRIPT_HandleBrushCommand:
    LINK.W  A5,#-36
    MOVEM.L D2-D7/A2-A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  16(A5),D7

    MOVEQ   #1,D6
    MOVEQ   #1,D0
    MOVE.L  D0,-8(A5)
    MOVE.W  LAB_2346,D5
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1584

    ADDQ.W  #4,A7
    CLR.L   LAB_2351
    CLR.B   0(A2,D7.L)
    MOVEQ   #0,D0
    MOVE.B  (A2),D0
    SUBQ.W  #1,D0
    BLT.W   .LAB_1543

    CMPI.W  #22,D0
    BGE.W   .LAB_1543

    ADD.W   D0,D0
    MOVE.W  .LAB_14FF(PC,D0.W),D0
    JMP     .LAB_14FF+2(PC,D0.W)

; switch/jumptable
.LAB_14FF:
    DC.W    .LAB_14FF_0390-.LAB_14FF-2
    DC.W    .LAB_14FF_002A-.LAB_14FF-2
    DC.W    .LAB_14FF_081C-.LAB_14FF-2
    DC.W    .LAB_14FF_01E4-.LAB_14FF-2
    DC.W    .LAB_14FF_01C8-.LAB_14FF-2
    DC.W    .LAB_14FF_081C-.LAB_14FF-2
    DC.W    .LAB_14FF_06DE-.LAB_14FF-2
    DC.W    .LAB_14FF_081C-.LAB_14FF-2
    DC.W    .LAB_14FF_081C-.LAB_14FF-2
    DC.W    .LAB_14FF_081C-.LAB_14FF-2
    DC.W    .LAB_14FF_0224-.LAB_14FF-2
    DC.W    .LAB_14FF_02E0-.LAB_14FF-2
    DC.W    .LAB_14FF_081C-.LAB_14FF-2
    DC.W    .LAB_14FF_081C-.LAB_14FF-2
    DC.W    .LAB_14FF_06A0-.LAB_14FF-2
    DC.W    .LAB_14FF_06D2-.LAB_14FF-2
    DC.W    .LAB_14FF_0812-.LAB_14FF-2
    DC.W    .LAB_14FF_081C-.LAB_14FF-2
    DC.W    .LAB_14FF_081C-.LAB_14FF-2
    DC.W    .LAB_14FF_01B6-.LAB_14FF-2
    DC.W    .LAB_14FF_081C-.LAB_14FF-2
    DC.W    .LAB_14FF_06EA-.LAB_14FF-2

.LAB_14FF_002A:
    MOVEQ   #0,D0
    LEA     3(A2),A0
    PEA     2.W
    MOVE.L  A0,-(A7)
    PEA     LAB_212C
    MOVE.L  D0,-20(A5)
    MOVE.L  D0,-16(A5)
    JSR     JMPTBL_STRING_CompareN_3(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .LAB_1501

    MOVE.L  BRUSH_SelectedNode,BRUSH_ScriptPrimarySelection    ; default primary selection to current brush
    MOVEQ   #1,D0
    MOVE.L  D0,-16(A5)

.LAB_1501:
    LEA     1(A2),A0
    PEA     2.W
    MOVE.L  A0,-(A7)
    PEA     LAB_212D
    JSR     JMPTBL_STRING_CompareN_3(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .LAB_1502

    MOVE.L  BRUSH_SelectedNode,BRUSH_ScriptSecondarySelection  ; same for secondary fallback
    MOVEQ   #1,D0
    MOVE.L  D0,-20(A5)

.LAB_1502:
    LEA     3(A2),A0
    PEA     2.W
    MOVE.L  A0,-(A7)
    PEA     LAB_212E
    JSR     JMPTBL_STRING_CompareN_3(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .LAB_1503

    TST.L   -16(A5)
    BNE.S   .LAB_1503

    CLR.L   BRUSH_ScriptPrimarySelection
    MOVEQ   #1,D0
    MOVE.L  D0,-16(A5)

.LAB_1503:
    LEA     1(A2),A0
    PEA     2.W
    MOVE.L  A0,-(A7)
    PEA     LAB_212F
    JSR     JMPTBL_STRING_CompareN_3(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .LAB_1504

    TST.L   -20(A5)
    BNE.S   .LAB_1504

    CLR.L   BRUSH_ScriptSecondarySelection
    MOVEQ   #1,D0
    MOVE.L  D0,-20(A5)

.LAB_1504:
    TST.L   -16(A5)
    BEQ.S   .LAB_1505

    TST.L   -20(A5)
    BNE.W   .LAB_1543

.LAB_1505:
    MOVE.L  LAB_1ED1,-12(A5)

.LAB_1506:
    ; Scan available brushes to pick the first entries matching the requested names.
    TST.L   -12(A5)
    BEQ.W   .LAB_1509

    MOVEA.L -12(A5),A0
    ADDA.W  #$21,A0
    LEA     3(A2),A1
    PEA     2.W
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     JMPTBL_STRING_CompareN_3(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .LAB_1507

    TST.L   -16(A5)
    BNE.S   .LAB_1507

    MOVE.L  -12(A5),BRUSH_ScriptPrimarySelection
    MOVEQ   #1,D0
    MOVE.L  D0,-16(A5)
    BEQ.S   .LAB_1507

    TST.L   -20(A5)
    BNE.S   .LAB_1509

.LAB_1507:
    MOVEA.L -12(A5),A0
    ADDA.W  #$21,A0
    LEA     1(A2),A1
    PEA     2.W
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     JMPTBL_STRING_CompareN_3(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .LAB_1508

    TST.L   -20(A5)
    BNE.S   .LAB_1508

    MOVE.L  -12(A5),BRUSH_ScriptSecondarySelection
    MOVEQ   #1,D0
    MOVE.L  D0,-20(A5)
    TST.L   -16(A5)
    BEQ.S   .LAB_1508

    TST.L   D0
    BNE.S   .LAB_1509

.LAB_1508:
    MOVEA.L -12(A5),A0
    MOVE.L  368(A0),-12(A5)
    BRA.W   .LAB_1506

.LAB_1509:
    TST.L   -16(A5)
    BNE.S   .LAB_150A

    MOVEA.L BRUSH_SelectedNode,A0
    MOVE.L  A0,BRUSH_ScriptPrimarySelection

.LAB_150A:
    TST.L   -20(A5)
    BNE.W   .LAB_1543

    MOVE.L  BRUSH_SelectedNode,BRUSH_ScriptSecondarySelection
    BRA.W   .LAB_1543

.LAB_14FF_01B6:
    MOVE.L  A2,-(A7)
    JSR     LAB_136D(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,LAB_211D
    BRA.W   .LAB_1543

.LAB_14FF_01C8:
    MOVEQ   #0,D0
    MOVE.B  1(A2),D0
    MOVE.W  D0,LAB_234D
    MOVEQ   #0,D0
    MOVE.B  2(A2),D0
    MOVE.W  D0,LAB_234E
    BRA.W   .LAB_1543

.LAB_14FF_01E4:
    MOVE.B  1(A2),D0
    MOVEQ   #76,D1
    CMP.B   D1,D0
    BNE.S   .LAB_150B

    MOVE.W  #1,LAB_2356
    BRA.W   .LAB_1543

.LAB_150B:
    MOVEQ   #82,D1
    CMP.B   D1,D0
    BNE.S   .LAB_150C

    MOVEQ   #0,D0
    MOVE.W  D0,LAB_2356
    BRA.W   .LAB_1543

.LAB_150C:
    TST.W   LAB_2356
    BEQ.S   .LAB_150D

    MOVEQ   #0,D0
    BRA.S   .LAB_150E

.LAB_150D:
    MOVEQ   #1,D0

.LAB_150E:
    MOVE.W  D0,LAB_2356
    BRA.W   .LAB_1543

.LAB_14FF_0224:
    MOVE.B  LAB_1BC9,D0
    MOVEQ   #49,D1
    CMP.B   D1,D0
    BNE.W   .LAB_1543

    MOVEA.L A2,A0

.LAB_150F:
    TST.B   (A0)+
    BNE.S   .LAB_150F

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    CMPA.W  #12,A0
    BNE.W   .LAB_1543

    LEA     4(A2),A0
    PEA     4.W
    MOVE.L  A0,-(A7)
    PEA     -28(A5)
    JSR     SCRIPT_JMPTBL_STRING_CopyPadNul(PC)

    PEA     -28(A5)
    JSR     SCRIPT_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    LEA     16(A7),A7
    MOVEQ   #-48,D1
    ADD.B   1(A2),D1
    MOVE.B  D1,-18(A5)
    MOVEQ   #-48,D2
    ADD.B   2(A2),D2
    MOVE.B  D2,-17(A5)
    MOVEQ   #-48,D3
    ADD.B   3(A2),D3
    MOVE.B  D3,-16(A5)
    MOVE.L  D0,-32(A5)
    SUBI.L  #1900,D0
    MOVE.B  D0,-15(A5)
    MOVEQ   #-48,D0
    ADD.B   8(A2),D0
    MOVE.B  D0,-14(A5)
    MOVEQ   #-48,D0
    ADD.B   9(A2),D0
    MOVE.B  D0,-13(A5)
    MOVEQ   #-48,D0
    ADD.B   10(A2),D0
    MOVE.B  D0,-12(A5)
    MOVEQ   #-48,D3
    ADD.B   11(A2),D3
    MOVE.B  D3,-11(A5)
    CLR.B   -10(A5)
    MOVEQ   #7,D3
    CMP.B   D3,D1
    BGE.W   .LAB_1543

    MOVEQ   #12,D1
    CMP.B   D1,D2
    BGE.W   .LAB_1543

    MOVEQ   #60,D1
    CMP.B   D1,D0
    BGE.W   .LAB_1543

    PEA     -18(A5)
    JSR     SCRIPT_JMPTBL_LAB_0B4E(PC)

    ADDQ.W  #4,A7
    BRA.W   .LAB_1543

.LAB_14FF_02E0:
    MOVE.L  LAB_1FE7,D0
    MOVEQ   #1,D1
    CMP.L   D1,D0
    BEQ.S   .LAB_1510

    SUBQ.L  #2,D0
    BNE.S   .LAB_1511

.LAB_1510:
    MOVE.W  #(-1),LAB_2364
    MOVEQ   #2,D0
    MOVE.L  D0,LAB_2351
    BRA.W   .LAB_1543

.LAB_1511:
    CMP.L   LAB_1FE6,D1
    BEQ.S   .LAB_1513

    MOVE.B  LAB_1DD6,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_1512

    TST.L   LAB_1B27
    BNE.S   .LAB_1516

.LAB_1512:
    TST.W   WDISP_HighlightActive
    BNE.S   .LAB_1516

.LAB_1513:
    PEA     LAB_211D
    JSR     LAB_136F(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .LAB_1514

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_2351
    BRA.W   .LAB_1543

.LAB_1514:
    MOVEQ   #49,D0
    CMP.B   1(A2),D0
    BNE.S   .LAB_1515

    MOVE.L  D7,-(A7)
    MOVE.L  A2,-(A7)
    CLR.L   -(A7)
    BSR.W   LAB_1545

    LEA     12(A7),A7
    MOVE.L  D0,D6
    BRA.W   .LAB_1543

.LAB_1515:
    MOVEQ   #51,D0
    CMP.B   1(A2),D0
    BNE.W   .LAB_1543

    MOVE.W  #(-1),LAB_2364
    MOVEQ   #2,D0
    MOVE.L  D0,LAB_2351
    BRA.W   .LAB_1543

.LAB_1516:
    MOVEQ   #4,D0
    MOVE.L  D0,LAB_2351
    CLR.W   LAB_2357
    BRA.W   .LAB_1543

.LAB_14FF_0390:
    PEA     LAB_211D
    JSR     LAB_136F(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .LAB_1517

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_2351
    BRA.W   .LAB_1543

.LAB_1517:
    MOVEQ   #0,D0
    MOVE.B  1(A2),D0
    SUBI.W  #$31,D0
    BEQ.W   .LAB_152E

    SUBQ.W  #2,D0
    BEQ.W   .LAB_1529

    SUBQ.W  #1,D0
    BEQ.W   .LAB_152C

    SUBQ.W  #1,D0
    BEQ.W   .LAB_1521

    SUBQ.W  #1,D0
    BEQ.W   .LAB_152C

    SUBQ.W  #1,D0
    BEQ.S   .LAB_151A

    SUBQ.W  #1,D0
    BEQ.W   .LAB_152F

    SUBI.W  #12,D0
    BEQ.W   .LAB_152B

    SUBQ.W  #2,D0
    BEQ.S   .LAB_1518

    SUBI.W  #17,D0
    BEQ.S   .LAB_1519

    SUBQ.W  #1,D0
    BNE.W   .LAB_1543

.LAB_1518:
    MOVEQ   #9,D0
    MOVE.L  D0,LAB_2351
    MOVE.B  1(A2),LAB_2127
    MOVE.B  2(A2),LAB_2128
    LEA     3(A2),A0
    MOVE.L  LAB_2129,-(A7)
    MOVE.L  A0,-(A7)
    JSR     JMPTBL_LAB_0B44_2(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_2129
    CLR.L   -8(A5)
    MOVE.W  #(-2),LAB_211E
    BRA.W   .LAB_1543

.LAB_1519:
    MOVEQ   #8,D0
    MOVE.L  D0,LAB_2351
    MOVE.B  2(A2),LAB_2126
    BRA.W   .LAB_1543

.LAB_151A:
    TST.W   LAB_2357
    BNE.S   .LAB_151B

    MOVEQ   #0,D6
    BRA.W   .LAB_1543

.LAB_151B:
    MOVE.W  LAB_2365,D0
    SUBQ.W  #1,D0
    BNE.S   .LAB_151C

    MOVEQ   #2,D0
    BRA.S   .LAB_151D

.LAB_151C:
    MOVEQ   #3,D0

.LAB_151D:
    MOVEQ   #0,D1
    MOVE.B  0(A2,D0.L),D1
    MOVE.W  D1,LAB_234F
    MOVEQ   #48,D0
    CMP.W   D0,D1
    BNE.S   .LAB_151E

    MOVEQ   #0,D6
    BRA.W   .LAB_1543

.LAB_151E:
    MOVE.W  LAB_2364,D0
    ADDQ.W  #1,D0
    BNE.S   .LAB_151F

    MOVE.W  LAB_2368,D0
    ADDQ.W  #1,D0
    BNE.S   .LAB_151F

    MOVEQ   #0,D6
    BRA.W   .LAB_1543

.LAB_151F:
    MOVE.W  LAB_2364,D0
    ADDQ.W  #1,D0
    BNE.S   .LAB_1520

    MOVE.W  LAB_2368,LAB_2364

.LAB_1520:
    JSR     TEXTDISP_UpdateChannelRangeFlags(PC)

    MOVEQ   #5,D0
    MOVE.L  D0,LAB_2351
    BRA.W   .LAB_1543

.LAB_1521:
    MOVE.B  LAB_1BC7,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_1522

    MOVE.W  #(-1),LAB_211E
    MOVEQ   #1,D0
    MOVE.L  D0,LAB_2351
    BRA.W   .LAB_1543

.LAB_1522:
    MOVEQ   #0,D0
    MOVE.B  2(A2),D0
    LEA     LAB_21A8,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.W   .LAB_1528

    MOVEQ   #0,D1
    MOVE.B  3(A2),D1
    ADDA.L  D1,A0
    BTST    #7,(A0)
    BEQ.W   .LAB_1528

    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     SCRIPT_JMPTBL_LADFUNC_ParseHexDigit(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    ASL.L   #4,D1
    MOVE.B  3(A2),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  D1,36(A7)
    JSR     SCRIPT_JMPTBL_LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  32(A7),D0
    ADD.L   D1,D0
    MOVEQ   #0,D1
    MOVE.B  4(A2),D1
    LEA     LAB_21A8,A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    MOVE.W  D0,LAB_211E
    BTST    #2,(A1)
    BEQ.S   .LAB_1523

    MOVEQ   #0,D0
    MOVE.B  5(A2),D0
    ADDA.L  D0,A0
    BTST    #2,(A0)
    BEQ.S   .LAB_1523

    MOVEQ   #0,D2
    MOVE.B  D1,D2
    MOVEQ   #48,D1
    SUB.L   D1,D2
    MOVE.L  D2,D0
    MOVE.L  #1000,D1
    JSR     JMPTBL_MATH_Mulu32_7(PC)

    MOVEQ   #0,D1
    MOVE.B  5(A2),D1
    MOVEQ   #48,D2
    SUB.L   D2,D1
    MOVE.L  D0,32(A7)
    MOVEQ   #100,D0
    JSR     JMPTBL_MATH_Mulu32_7(PC)

    MOVE.L  32(A7),D1
    ADD.L   D0,D1
    MOVE.W  D1,LAB_211F
    BRA.S   .LAB_1524

.LAB_1523:
    MOVE.W  #1000,LAB_211F

.LAB_1524:
    TST.B   6(A2)
    BNE.S   .checkIfSelectCodeIsRAVESC

    MOVE.W  #(-1),LAB_2364
    MOVEQ   #2,D0
    MOVE.L  D0,LAB_2351
    BRA.W   .LAB_1543

.checkIfSelectCodeIsRAVESC:
    TST.W   GLOB_WORD_SELECT_CODE_IS_RAVESC
    BNE.S   .selectCodeIsRAVESC

    MOVE.B  LAB_1BC8,D0
    MOVEQ   #'M',D1
    CMP.B   D1,D0
    BEQ.S   .selectCodeIsRAVESC

    LEA     6(A2),A0
    MOVE.L  A0,-(A7)
    JSR     TEXTDISP_FindEntryIndexByWildcard(PC)

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   .selectCodeIsNotRAVESC

.selectCodeIsRAVESC:
    MOVEQ   #3,D0
    MOVE.L  D0,LAB_2351
    BRA.W   .LAB_1543

.selectCodeIsNotRAVESC:
    MOVEQ   #-1,D0
    MOVEQ   #1,D1
    MOVE.L  D1,LAB_2351
    MOVE.W  D0,LAB_211E
    BRA.W   .LAB_1543

.LAB_1528:
    MOVE.W  #(-1),LAB_211E
    MOVEQ   #1,D0
    MOVE.L  D0,LAB_2351
    BRA.W   .LAB_1543

.LAB_1529:
    MOVE.W  #(-1),LAB_2364
    MOVE.B  LAB_1DCE,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .LAB_152A

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_2351
    BRA.W   .LAB_1543

.LAB_152A:
    MOVEQ   #2,D0
    MOVE.L  D0,LAB_2351
    BRA.W   .LAB_1543

.LAB_152B:
    MOVE.W  #(-1),LAB_2364
    MOVEQ   #1,D0
    MOVE.L  D0,LAB_2351
    BRA.W   .LAB_1543

.LAB_152C:
    LEA     2(A2),A0
    MOVE.L  A0,-(A7)
    JSR     TEXTDISP_FindEntryIndexByWildcard(PC)

    ADDQ.W  #4,A7
    TST.W   D0
    BNE.S   .LAB_152D

    MOVEQ   #0,D6
    MOVEQ   #1,D0
    MOVE.L  D0,LAB_2351
    BRA.W   .LAB_1543

.LAB_152D:
    MOVEQ   #3,D0
    MOVE.L  D0,LAB_2351
    BRA.W   .LAB_1543

.LAB_152E:
    MOVE.L  D7,-(A7)
    MOVE.L  A2,-(A7)
    CLR.L   -(A7)
    BSR.W   LAB_1545

    LEA     12(A7),A7
    MOVE.L  D0,D6
    BRA.W   .LAB_1543

.LAB_152F:
    MOVE.L  D7,-(A7)
    MOVE.L  A2,-(A7)
    PEA     1.W
    BSR.W   LAB_1545

    LEA     12(A7),A7
    MOVE.L  D0,D6
    BRA.W   .LAB_1543

.LAB_14FF_06A0:
    LEA     1(A2),A0
    MOVE.L  A0,-(A7)
    JSR     SCRIPT_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVEQ   #63,D1
    SUB.L   D0,D1
    MOVE.B  D1,LAB_1B05
    MOVEQ   #63,D0
    CMP.B   D0,D1

    BGT.S   .LAB_1530

    TST.B   D1
    BPL.S   .LAB_1531

.LAB_1530:
    MOVE.B  D0,LAB_1B05

.LAB_1531:
    MOVEQ   #13,D0
    MOVE.L  D0,LAB_2351
    BRA.W   .LAB_1543

.LAB_14FF_06D2:
    MOVEQ   #14,D0
    MOVE.L  D0,LAB_2351
    BRA.W   .LAB_1543

.LAB_14FF_06DE:
    MOVEQ   #15,D0
    MOVE.L  D0,LAB_2351
    BRA.W   .LAB_1543

.LAB_14FF_06EA:
    MOVEQ   #57,D0
    CMP.B   1(A2),D0
    BNE.S   .LAB_1532

    PEA     1.W
    JSR     SCRIPT_JMPTBL_LAB_0F13(PC)

    LEA     2(A2),A0
    PEA     LAB_2321
    MOVE.L  A0,-(A7)
    JSR     SCRIPT_JMPTBL_LAB_0F3D(PC)

    LEA     12(A7),A7
    BRA.W   .LAB_1543

.LAB_1532:
    MOVEQ   #1,D0
    CMP.L   LAB_1FE6,D0
    BNE.S   .LAB_1533

    MOVEQ   #56,D0
    CMP.B   1(A2),D0
    BNE.S   .LAB_1533

    CLR.L   -(A7)
    JSR     SCRIPT_JMPTBL_LAB_0F13(PC)

    ADDQ.W  #4,A7
    BRA.W   .LAB_1543

.LAB_1533:
    MOVEQ   #1,D0
    CMP.L   LAB_1FE6,D0
    BNE.S   .LAB_1534

    MOVEQ   #0,D6
    BRA.W   .LAB_1543

.LAB_1534:
    MOVEQ   #0,D0
    MOVE.B  LAB_1DD7,D0
    LEA     LAB_21A8,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #1,(A1)
    BEQ.S   .LAB_1535

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #32,D2
    SUB.L   D2,D1
    BRA.S   .LAB_1536

.LAB_1535:
    MOVEQ   #0,D1
    MOVE.B  D0,D1

.LAB_1536:
    MOVEQ   #89,D2
    CMP.L   D2,D1
    BNE.S   .LAB_1537

    MOVE.B  1(A2),D1
    MOVEQ   #48,D3
    CMP.B   D3,D1
    BEQ.S   .LAB_153A

.LAB_1537:
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    BTST    #1,(A1)
    BEQ.S   .LAB_1538

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #32,D3
    SUB.L   D3,D1
    BRA.S   .LAB_1539

.LAB_1538:
    MOVEQ   #0,D1
    MOVE.B  D0,D1

.LAB_1539:
    MOVEQ   #76,D3
    CMP.L   D3,D1
    BNE.S   .LAB_153B

    MOVE.B  1(A2),D1
    MOVEQ   #50,D4
    CMP.B   D4,D1
    BNE.S   .LAB_153B

.LAB_153A:
    MOVE.W  #3,LAB_2346
    BRA.S   .LAB_1543

.LAB_153B:
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    BTST    #1,(A1)
    BEQ.S   .LAB_153C

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #32,D4
    SUB.L   D4,D1
    BRA.S   .LAB_153D

.LAB_153C:
    MOVEQ   #0,D1
    MOVE.B  D0,D1

.LAB_153D:
    CMP.L   D2,D1
    BNE.S   .LAB_153E

    MOVE.B  1(A2),D1
    MOVEQ   #49,D2
    CMP.B   D2,D1
    BEQ.S   .LAB_1541

.LAB_153E:
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    ADDA.L  D1,A0
    BTST    #1,(A0)
    BEQ.S   .LAB_153F

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #32,D2
    SUB.L   D2,D1
    BRA.S   .LAB_1540

.LAB_153F:
    MOVEQ   #0,D1
    MOVE.B  D0,D1

.LAB_1540:
    CMP.L   D3,D1
    BNE.S   .LAB_1542

    MOVEQ   #51,D0
    CMP.B   1(A2),D0
    BNE.S   .LAB_1542

.LAB_1541:
    JSR     SCRIPT_ReadCiaBBit5Mask(PC)

    TST.B   D0
    BEQ.S   .LAB_1542

    MOVEQ   #10,D0
    MOVE.L  D0,LAB_2351
    BRA.S   .LAB_1543

.LAB_1542:
    MOVEQ   #0,D6
    BRA.S   .LAB_1543

.LAB_14FF_0812:
    MOVE.L  D7,-(A7)
    MOVE.L  A2,-(A7)
    BSR.W   LAB_1554

    ADDQ.W  #8,A7

.LAB_14FF_081C:
.LAB_1543:
    MOVE.L  A3,-(A7)
    BSR.W   LAB_158C

    ADDQ.W  #4,A7
    TST.L   -8(A5)
    BEQ.S   .return

    TST.L   LAB_2351
    BEQ.S   .return

    CLR.L   -(A7)
    MOVEQ   #0,D0
    NOT.B   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    JSR     TEXTDISP_HandleScriptCommand(PC)

    LEA     12(A7),A7

.return:
    MOVE.W  D5,LAB_2346
    MOVE.L  D6,D0

    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_1545   (??)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   ??
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   ??
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_1545:
    LINK.W  A5,#-4
    MOVEM.L D5-D7/A3,-(A7)
    MOVE.L  8(A5),D7
    MOVEA.L 12(A5),A3
    MOVEQ   #1,D6
    MOVE.L  D7,LAB_2350
    MOVE.W  #1,LAB_2357
    MOVEQ   #3,D5

.loop_1546:
    MOVEQ   #18,D0
    CMP.B   0(A3,D5.W),D0
    BEQ.S   .branch_1547

    MOVEQ   #30,D0
    CMP.W   D0,D5
    BGE.S   .branch_1547

    ADDQ.W  #1,D5
    BRA.S   .loop_1546

.branch_1547:
    CLR.B   0(A3,D5.W)
    TST.W   LAB_2356
    BNE.S   .if_ne_1548

    MOVE.L  D5,D0
    EXT.L   D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     1(A0),A1
    MOVE.W  LAB_234E,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     LAB_234C
    MOVE.L  A1,-(A7)
    JSR     TEXTDISP_SelectGroupAndEntry(PC)

    LEA     12(A7),A7
    SUBQ.W  #1,D0
    BNE.S   .if_ne_1548

    MOVEQ   #7,D0
    MOVE.L  D0,LAB_2351
    BRA.S   .skip_154B

.if_ne_1548:
    LEA     2(A3),A0
    MOVE.W  LAB_234D,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     LAB_234B
    MOVE.L  A0,-(A7)
    JSR     TEXTDISP_SelectGroupAndEntry(PC)

    LEA     12(A7),A7
    SUBQ.W  #1,D0
    BNE.S   .if_ne_1549

    MOVEQ   #6,D0
    MOVE.L  D0,LAB_2351
    BRA.S   .skip_154B

.if_ne_1549:
    TST.W   LAB_2356
    BEQ.S   .branch_154A

    MOVE.L  D5,D0
    EXT.L   D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     1(A0),A1
    MOVE.W  LAB_234E,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     LAB_234C
    MOVE.L  A1,-(A7)
    JSR     TEXTDISP_SelectGroupAndEntry(PC)

    LEA     12(A7),A7
    SUBQ.W  #1,D0
    BNE.S   .branch_154A

    MOVEQ   #7,D0
    MOVE.L  D0,LAB_2351
    BRA.S   .skip_154B

.branch_154A:
    MOVEQ   #0,D6
    CLR.W   LAB_2357
    MOVEQ   #1,D0
    MOVE.L  D0,LAB_2351

.skip_154B:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_154C   (??)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   ??
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   ??
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_154C:
    MOVEM.L D2/A3,-(A7)
    MOVEA.L 12(A7),A3
    PEA     LAB_2321
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_LAB_0F7D(PC)

    MOVE.L  A3,(A7)
    BSR.W   LAB_1584

    ADDQ.W  #8,A7
    TST.L   LAB_2125
    BEQ.S   .LAB_154D

    MOVEQ   #3,D0
    MOVE.W  D0,LAB_2346
    MOVEQ   #0,D0
    MOVE.L  D0,LAB_2125

.LAB_154D:
    MOVE.B  LAB_1BC8,D0
    MOVEQ   #77,D1
    CMP.B   D1,D0
    BNE.S   .LAB_154E

    MOVE.L  LAB_2351,D0
    TST.L   D0
    BLE.S   .LAB_154E

    MOVEQ   #10,D1
    CMP.L   D1,D0
    BGE.S   .LAB_154E

    MOVEQ   #2,D2
    MOVE.L  D2,LAB_2351

.LAB_154E:
    MOVE.W  LAB_2346,D0
    SUBQ.W  #2,D0
    BNE.S   .LAB_154F

    TST.W   LAB_211A
    BEQ.S   .LAB_1551

    MOVE.L  LAB_2351,D0
    MOVEQ   #10,D1
    CMP.L   D1,D0
    BLE.S   .LAB_1551

.LAB_154F:
    MOVE.L  LAB_2351,D0
    TST.L   D0
    BLE.S   .return

    MOVEQ   #15,D1
    CMP.L   D1,D0
    BGT.S   .return

    BSR.W   LAB_1565

    TST.W   D0
    BNE.S   .return

    MOVEQ   #1,D0
    CMP.L   LAB_2351,D0
    BEQ.S   .LAB_1550

    BSR.W   LAB_1560

.LAB_1550:
    PEA     LAB_2351
    BSR.W   LAB_157A

    ADDQ.W  #4,A7
    BRA.S   .return

.LAB_1551:
    CLR.W   LAB_211A

.return:
    MOVE.W  LAB_2364,LAB_236E
    MOVE.L  A3,-(A7)
    BSR.W   LAB_158C

    ADDQ.W  #4,A7
    MOVEM.L (A7)+,D2/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_1553   (??)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   ??
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   ??
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_1553:
    MOVEQ   #0,D0
    MOVE.B  D0,LAB_234C
    MOVE.B  D0,LAB_234B
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_234E
    MOVE.W  D0,LAB_234D
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_1554   (??)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   ??
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   ??
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_1554:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVE.L  20(A7),D7
    MOVEQ   #18,D0
    CMP.B   1(A3),D0
    BNE.S   .LAB_1556

    LEA     2(A3),A0
    LEA     LAB_234C,A1

.LAB_1555:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_1555

    MOVEQ   #0,D0
    MOVE.B  D0,LAB_234B
    BRA.S   .LAB_155D

.LAB_1556:
    CMP.B   -1(A3,D7.L),D0
    BNE.S   .LAB_1558

    CLR.B   -1(A3,D7.L)
    LEA     1(A3),A0
    LEA     LAB_234B,A1

.LAB_1557:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_1557

    CLR.B   LAB_234C
    BRA.S   .LAB_155D

.LAB_1558:
    MOVEQ   #1,D6

.LAB_1559:
    MOVEQ   #18,D0
    CMP.B   0(A3,D6.W),D0
    BEQ.S   .LAB_155A

    CMPI.W  #$c8,D6
    BGE.S   .LAB_155A

    ADDQ.W  #1,D6
    BRA.S   .LAB_1559

.LAB_155A:
    CLR.B   0(A3,D6.W)
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     1(A0),A1
    LEA     LAB_234C,A0

.LAB_155B:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .LAB_155B

    LEA     1(A3),A0
    LEA     LAB_234B,A1

.LAB_155C:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_155C

.LAB_155D:
    LEA     LAB_234B,A0
    MOVE.L  A0,D0
    BEQ.S   .LAB_155E

    TST.B   LAB_234B
    BEQ.S   .LAB_155E

    PEA     128.W
    MOVE.L  A0,-(A7)
    JSR     SCRIPT_JMPTBL_LAB_0C31(PC)

    ADDQ.W  #8,A7

.LAB_155E:
    LEA     LAB_234C,A0
    MOVE.L  A0,D0
    BEQ.S   .return

    TST.B   LAB_234C
    BEQ.S   .return

    PEA     128.W
    MOVE.L  A0,-(A7)
    JSR     SCRIPT_JMPTBL_LAB_0C31(PC)

    ADDQ.W  #8,A7

.return:
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_1560   (??)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   ??
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   ??
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_1560:
    MOVEM.L D2/D7,-(A7)
    JSR     SCRIPT_JMPTBL_GCOMMAND_GetBannerChar(PC)

    MOVE.L  D0,D7
    MOVEQ   #-2,D0
    CMP.W   LAB_211E,D0
    BNE.S   .LAB_1561

    MOVEQ   #-1,D0
    MOVE.W  D0,LAB_211E
    BRA.S   .LAB_1563

.LAB_1561:
    MOVE.W  LAB_211E,D0
    MOVEQ   #-1,D1
    CMP.W   D1,D0
    BEQ.S   .LAB_1562

    EXT.L   D0
    MOVE.W  LAB_211F,D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   SCRIPT_BeginBannerCharTransition

    ADDQ.W  #8,A7
    MOVE.W  #(-1),LAB_211E
    BRA.S   .LAB_1563

.LAB_1562:
    MOVE.W  GLOB_REF_WORD_HEX_CODE_8E,D0
    CMP.W   D0,D7
    BEQ.S   .LAB_1563

    EXT.L   D0
    MOVE.W  LAB_211F,D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   SCRIPT_BeginBannerCharTransition

    ADDQ.W  #8,A7
    MOVE.W  #(-1),LAB_211E

.LAB_1563:
    TST.W   LAB_2122
    BEQ.S   .return

    MOVEQ   #0,D0
    MOVE.W  D0,LAB_1F45
    MOVE.W  D0,LAB_2122

.return:
    MOVEM.L (A7)+,D2/D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_1565   (??)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   ??
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   ??
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_1565:
    MOVE.L  D7,-(A7)

    MOVE.W  LAB_2346,D0
    SUBQ.W  #1,D0
    BNE.W   .LAB_156E

    MOVE.B  LAB_1BB3,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .LAB_1566

    MOVE.W  GLOB_REF_WORD_HEX_CODE_8E,D0
    ADDI.W  #28,D0
    EXT.L   D0
    PEA     1000.W
    MOVE.L  D0,-(A7)
    BSR.W   SCRIPT_BeginBannerCharTransition

    ADDQ.W  #8,A7

.LAB_1566:
    CLR.W   LAB_2119
    MOVE.W  #(-1),LAB_2364
    MOVE.W  #2,LAB_2346
    MOVE.W  #1,LAB_211A
    JSR     GROUP_BA_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    CLR.L   -(A7)
    JSR     LAB_167E(PC)

    ADDQ.W  #4,A7
    MOVE.B  LAB_1BC8,D0
    MOVEQ   #77,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_1567

    MOVEQ   #83,D1
    CMP.B   D1,D0
    BNE.S   .LAB_156C

.LAB_1567:
    MOVE.B  LAB_1BC6,D0
    EXT.W   D0
    SUBI.W  #$42,D0
    BEQ.S   .LAB_156A

    SUBI.W  #10,D0
    BEQ.S   .LAB_1568

    SUBQ.W  #2,D0
    BEQ.S   .LAB_156B

    SUBQ.W  #4,D0
    BEQ.S   .LAB_1569

    BRA.S   .LAB_156B

.LAB_1568:
    MOVEQ   #1,D7
    BRA.S   .LAB_156D

.LAB_1569:
    MOVEQ   #2,D7
    BRA.S   .LAB_156D

.LAB_156A:
    MOVEQ   #3,D7
    BRA.S   .LAB_156D

.LAB_156B:
    MOVEQ   #0,D7
    BRA.S   .LAB_156D

.LAB_156C:
    MOVEQ   #0,D7

.LAB_156D:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,-(A7)
    JSR     LAB_14B1(PC)

    BSR.W   LAB_1553

    ADDQ.W  #4,A7
    MOVEQ   #1,D0
    BRA.S   .LAB_1570

.LAB_156E:
    MOVE.W  LAB_2346,D0
    SUBQ.W  #3,D0
    BNE.S   .LAB_156F

    JSR     SCRIPT_DeassertCtrlLineNow(PC)

    MOVEQ   #0,D0
    MOVE.W  D0,LAB_211A

.LAB_156F:
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_2346

.LAB_1570:
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_UpdateCtrlStateMachine   (UpdateCtrlStateMachine??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1
; CALLS:
;   SCRIPT_DeassertCtrlLineNow, LAB_167D, UNKNOWN7_FindCharWrapper, SCRIPT_ReadCiaBBit3Flag
; READS:
;   LAB_2346, LAB_2118, LAB_2119, LAB_1DD7, LAB_2263
; WRITES:
;   LAB_2346, LAB_2118, LAB_2119
; DESC:
;   Advances a small control state machine and triggers follow-up actions when
;   counters hit thresholds.
; NOTES:
;   Uses LAB_1DD7 via UNKNOWN7_FindCharWrapper to probe a control flag string.
;------------------------------------------------------------------------------
SCRIPT_UpdateCtrlStateMachine:
LAB_1571:
    BSR.W   .refresh_ctrl_state

    MOVE.W  LAB_2346,D0
    SUBQ.W  #2,D0
    BNE.S   .reset_state

    MOVE.W  LAB_2118,D0
    SUBQ.W  #1,D0
    BNE.S   .check_state_two

    MOVE.W  LAB_2119,D0
    MOVE.L  D0,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,LAB_2119
    MOVEQ   #3,D0
    CMP.W   D0,D1
    BLT.S   .return_status

    CLR.W   LAB_2119
    MOVE.W  D0,LAB_2346
    JSR     SCRIPT_DeassertCtrlLineNow(PC)

    JSR     LAB_167D(PC)

    BRA.S   .return_status

.check_state_two:
    MOVE.W  LAB_2118,D0
    SUBQ.W  #2,D0
    BNE.S   .check_banner_active

    MOVEQ   #0,D0
    MOVE.W  D0,LAB_2119
    BRA.S   .return_status

.check_banner_active:
    TST.W   LAB_2263
    BEQ.S   .return_status

    MOVE.W  #3,LAB_2346
    BRA.S   .return_status

.reset_state:
    CLR.W   LAB_2119

.return_status:
    RTS

;!======

.refresh_ctrl_state:
    MOVEQ   #0,D0
    MOVE.B  LAB_1DD7,D0
    MOVE.L  D0,-(A7)
    PEA     LAB_2130
    JSR     UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .clear_state

    JSR     SCRIPT_ReadCiaBBit3Flag(PC)

    TST.B   D0
    BEQ.S   .set_state_one

    MOVE.W  #2,LAB_2118
    BRA.S   .refresh_done

.set_state_one:
    MOVE.W  #1,LAB_2118
    BRA.S   .refresh_done

.clear_state:
    CLR.W   LAB_2118

.refresh_done:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_157A   (??)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   ??
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   ??
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_157A:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.L  (A3),D0
    SUBQ.L  #1,D0
    BLT.W   .LAB_157E

    CMPI.L  #$f,D0
    BGE.W   .LAB_157E

    ADD.W   D0,D0
    MOVE.W  .LAB_157B(PC,D0.W),D0
    JMP     .LAB_157B+2(PC,D0.W)

; switch/jumptable
.LAB_157B:
    DC.W    .LAB_157B_008A-.LAB_157B-2
    DC.W    .LAB_157B_0092-.LAB_157B-2
    DC.W    .LAB_157B_00CE-.LAB_157B-2
    DC.W    .LAB_157B_00EE-.LAB_157B-2
    DC.W    .LAB_157B_011E-.LAB_157B-2
    DC.W    .LAB_157B_0140-.LAB_157B-2
    DC.W    .LAB_157B_015E-.LAB_157B-2
    DC.W    .LAB_157B_0178-.LAB_157B-2
    DC.W    .LAB_157B_0192-.LAB_157B-2
    DC.W    .LAB_157B_01BE-.LAB_157B-2
    DC.W    .LAB_157B_0042-.LAB_157B-2
    DC.W    .LAB_157B_006A-.LAB_157B-2
    DC.W    .LAB_157B_0082-.LAB_157B-2
    DC.W    .LAB_157B_001C-.LAB_157B-2
    DC.W    .LAB_157B_0030-.LAB_157B-2

.LAB_157B_001C:
    MOVE.W  #1,LAB_2122
    MOVE.W  #256,LAB_1F45
    BRA.W   .return

.LAB_157B_0030:
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_2122
    MOVE.W  D0,LAB_1F45
    BRA.W   .return

.LAB_157B_0042:
    JSR     GROUP_BA_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    CLR.L   -(A7)
    JSR     LAB_167E(PC)

    ADDQ.W  #4,A7
    MOVE.W  GLOB_REF_WORD_HEX_CODE_8E,D0
    ADDI.W  #28,D0
    MOVE.W  #1000,LAB_211F
    MOVE.W  D0,LAB_211E
    BRA.W   .return

.LAB_157B_006A:
    MOVE.W  GLOB_REF_WORD_HEX_CODE_8E,D0
    MOVE.W  #1000,LAB_211F
    MOVE.W  D0,LAB_211E
    BRA.W   .return

.LAB_157B_0082:
    JSR     SCRIPT_JMPTBL_ESQ_SetCopperEffect_Custom(PC)

    BRA.W   .return

.LAB_157B_008A:
    JSR     LAB_167D(PC)

    BRA.W   .return

.LAB_157B_0092:
    MOVE.W  #(-1),LAB_2364
    JSR     GROUP_BA_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    CLR.L   -(A7)
    JSR     LAB_167E(PC)

    ADDQ.W  #4,A7
    MOVE.B  LAB_1BC8,D0
    MOVEQ   #77,D1
    CMP.B   D1,D0
    BNE.S   .LAB_157D

    PEA     3.W
    JSR     LAB_14B1(PC)

    ADDQ.W  #4,A7
    BRA.W   .return

.LAB_157D:
    PEA     1.W
    JSR     LAB_14B1(PC)

    ADDQ.W  #4,A7
    BRA.W   .return

.LAB_157B_00CE:
    MOVE.W  #(-1),LAB_2364
    JSR     GROUP_BA_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    CLR.L   -(A7)
    JSR     LAB_167E(PC)

    PEA     1.W
    JSR     LAB_14B1(PC)

    ADDQ.W  #8,A7
    BRA.W   .return

.LAB_157B_00EE
    MOVE.W  #(-1),LAB_2364
    MOVE.W  LAB_1DDE,D0
    BNE.W   .return

    PEA     3.W
    JSR     LAB_14B1(PC)

    ADDQ.W  #4,A7
    MOVE.W  #3,LAB_1DDE
    MOVE.W  #1,LAB_1DDF
    BRA.W   .return

.LAB_157B_011E:
    MOVE.W  LAB_2365,D0
    EXT.L   D0
    MOVE.W  LAB_234F,D1
    EXT.L   D1
    CLR.L   -(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     SCRIPT_JMPTBL_CLEANUP_RenderAlignedStatusScreen(PC)

    LEA     12(A7),A7
    BRA.W   .return

.LAB_157B_0140:
    MOVE.L  LAB_2350,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     53.W
    PEA     1.W
    JSR     SCRIPT_JMPTBL_CLEANUP_RenderAlignedStatusScreen(PC)

    LEA     12(A7),A7
    BRA.W   .return

.LAB_157B_015E:
    MOVE.L  LAB_2350,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     53.W
    CLR.L   -(A7)
    JSR     SCRIPT_JMPTBL_CLEANUP_RenderAlignedStatusScreen(PC)

    LEA     12(A7),A7
    BRA.S   .return

.LAB_157B_0178:
    MOVE.W  #(-1),LAB_2364
    MOVEQ   #0,D0
    MOVE.B  LAB_2126,D0
    MOVE.L  D0,-(A7)
    JSR     LAB_18AD(PC)

    ADDQ.W  #4,A7
    BRA.S   .return

.LAB_157B_0192:
    MOVE.W  #(-1),LAB_2364
    MOVEQ   #0,D0
    MOVE.B  LAB_2127,D0
    MOVEQ   #0,D1
    MOVE.B  LAB_2128,D1
    MOVE.L  LAB_2129,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     TEXTDISP_HandleScriptCommand(PC)

    LEA     12(A7),A7
    BRA.S   .return

.LAB_157B_01BE:
    JSR     SCRIPT_AssertCtrlLineNow(PC)

    MOVE.W  #1,LAB_2346
    BRA.S   .return

.LAB_157E:
    MOVE.W  #(-1),LAB_2364
    MOVE.W  LAB_211C,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_211C

.return:
    BSR.W   LAB_1553

    CLR.L   (A3)
    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_SetCtrlContextMode   (SetCtrlContextMode??)
; ARGS:
;   stack +12: ctxPtr (A3)
;   stack +18: modeFlag?? (D7)
; RET:
;   D0: none
; CLOBBERS:
;   D0/D7/A3
; CALLS:
;   SCRIPT_ResetCtrlContext
; READS:
;   (none)
; WRITES:
;   A3+0, A3+2, and full context via SCRIPT_ResetCtrlContext
; DESC:
;   Stores a mode flag into the CTRL context header and reinitializes it.
; NOTES:
;   Calls SCRIPT_ResetCtrlContext to clear and reset the rest of the structure.
;------------------------------------------------------------------------------
SCRIPT_SetCtrlContextMode:
LAB_1580:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.W  18(A7),D7
    MOVE.W  D7,(A3)
    MOVE.W  #1,2(A3)
    MOVE.L  A3,-(A7)
    BSR.W   SCRIPT_ResetCtrlContext

    ADDQ.W  #4,A7
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_ResetCtrlContext   (ResetCtrlContext??)
; ARGS:
;   stack +12: ctxPtr (A3)
; RET:
;   D0: none
; CLOBBERS:
;   D0/D1/D7/A3
; CALLS:
;   JMPTBL_LAB_0B44_2
; READS:
;   A3+440 (resource handle??)
; WRITES:
;   A3 fields: +26/+226 strings, +426 flag, +436..+439, +440 handle, and
;   clears ranges at +428..+431 and +0x1B0..+0x1B3 (4 bytes each).
; DESC:
;   Clears and initializes the CTRL context structure and refreshes a resource.
; NOTES:
;   The loop runs 4 iterations (D7 = 0..3), clearing two 4-byte subranges.
;------------------------------------------------------------------------------
SCRIPT_ResetCtrlContext:
LAB_1581:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D0
    MOVE.B  D0,436(A3)
    MOVE.B  #120,437(A3)
    MOVE.B  D0,438(A3)
    MOVE.B  D0,439(A3)
    MOVE.L  440(A3),-(A7)
    CLR.L   -(A7)
    JSR     JMPTBL_LAB_0B44_2(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,440(A3)
    MOVEQ   #0,D0
    MOVE.B  D0,226(A3)
    MOVE.B  D0,26(A3)
    MOVEQ   #0,D0
    MOVE.W  D0,6(A3)
    MOVE.W  D0,4(A3)
    MOVE.W  D0,10(A3)
    MOVE.W  D0,12(A3)
    MOVE.W  D0,14(A3)
    MOVEQ   #0,D1
    MOVE.L  D1,16(A3)
    MOVE.L  D1,20(A3)
    MOVE.W  D0,24(A3)
    MOVE.W  #1,426(A3)
    MOVE.L  D1,D7

.LAB_1582:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVEQ   #0,D0
    MOVE.L  D7,D1
    ADDI.L  #428,D1
    MOVE.B  D0,0(A3,D1.L)
    MOVE.L  D7,D1
    ADDI.L  #$1b0,D1
    MOVE.B  D0,0(A3,D1.L)
    ADDQ.L  #1,D7
    BRA.S   .LAB_1582

.return:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_1584   (??)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   ??
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   ??
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_1584:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.B  436(A3),LAB_211D
    MOVE.B  437(A3),LAB_2126
    MOVE.B  438(A3),LAB_2127
    MOVE.B  439(A3),LAB_2128
    MOVE.L  LAB_2129,-(A7)
    MOVE.L  440(A3),-(A7)
    JSR     JMPTBL_LAB_0B44_2(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_2129
    MOVE.W  2(A3),LAB_2356
    MOVE.W  4(A3),LAB_234D
    MOVE.W  6(A3),LAB_234E
    LEA     26(A3),A0
    LEA     LAB_234B,A1

.LAB_1585:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_1585

    LEA     226(A3),A0
    LEA     LAB_234C,A1

.LAB_1586:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_1586

    MOVE.W  8(A3),LAB_2364
    MOVE.W  10(A3),LAB_2357
    MOVE.W  12(A3),LAB_2365
    MOVE.W  14(A3),LAB_234F
    MOVE.L  16(A3),LAB_2350
    MOVE.L  20(A3),LAB_2351
    MOVE.W  LAB_2346,D0
    SUBQ.W  #2,D0
    BNE.S   .LAB_1587

    MOVE.W  24(A3),D0
    MOVEQ   #3,D1
    CMP.W   D1,D0
    BEQ.S   .LAB_1588

.LAB_1587:
    MOVE.W  LAB_2346,D0
    BNE.S   .LAB_1589

    MOVE.W  24(A3),D0
    MOVEQ   #1,D1
    CMP.W   D1,D0
    BNE.S   .LAB_1589

.LAB_1588:
    MOVE.W  D0,LAB_2346

.LAB_1589:
    MOVE.W  426(A3),LAB_2153
    MOVEQ   #0,D7

.LAB_158A:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .return

    LEA     LAB_2372,A0
    ADDA.L  D7,A0
    MOVE.L  D7,D0
    ADDI.L  #$1ac,D0
    MOVE.B  0(A3,D0.L),(A0)
    LEA     LAB_2376,A0
    ADDA.L  D7,A0
    MOVE.L  D7,D0
    ADDI.L  #$1b0,D0
    MOVE.B  0(A3,D0.L),(A0)
    ADDQ.L  #1,D7
    BRA.S   .LAB_158A

.return:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_158C   (??)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   ??
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   ??
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_158C:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3

    MOVE.B  LAB_211D,436(A3)
    MOVE.B  LAB_2126,437(A3)
    MOVE.B  LAB_2127,438(A3)
    MOVE.B  LAB_2128,439(A3)
    MOVE.L  440(A3),-(A7)
    MOVE.L  LAB_2129,-(A7)
    JSR     JMPTBL_LAB_0B44_2(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,440(A3)
    MOVE.W  LAB_2356,2(A3)
    MOVE.W  LAB_234D,4(A3)
    MOVE.W  LAB_234E,6(A3)
    LEA     26(A3),A0
    LEA     LAB_234B,A1

.LAB_158D:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .LAB_158D

    LEA     226(A3),A0
    LEA     LAB_234C,A1

.LAB_158E:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .LAB_158E

    MOVE.W  LAB_2364,8(A3)
    MOVE.W  LAB_2357,10(A3)
    MOVE.W  LAB_2365,12(A3)
    MOVE.W  LAB_234F,14(A3)
    MOVE.L  LAB_2350,16(A3)
    MOVE.L  LAB_2351,20(A3)
    MOVE.W  LAB_2346,24(A3)
    MOVE.W  LAB_2153,426(A3)
    MOVEQ   #0,D7

.LAB_158F:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .return

    LEA     LAB_2372,A0
    ADDA.L  D7,A0
    MOVE.L  D7,D0
    ADDI.L  #$1ac,D0
    MOVE.B  (A0),0(A3,D0.L)
    LEA     LAB_2376,A0
    ADDA.L  D7,A0
    MOVE.L  D7,D0
    ADDI.L  #$1b0,D0
    MOVE.B  (A0),0(A3,D0.L)
    ADDQ.L  #1,D7
    BRA.S   .LAB_158F

.return:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_1591   (??)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   ??
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   ??
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_1591:
    CLR.L   -(A7)
    MOVEQ   #0,D0
    NOT.B   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    JSR     TEXTDISP_HandleScriptCommand(PC)

    PEA     SCRIPT_CTRL_CONTEXT
    BSR.W   SCRIPT_ResetCtrlContext

    LEA     16(A7),A7
    RTS

;!======

JMPTBL_LAB_0F7D:
    JMP     LAB_0F7D

JMPTBL_MATH_DivS32_4:
    JMP     MATH_DivS32

;------------------------------------------------------------------------------
; FUNC: SCRIPT_JMPTBL_LAB_0C31   (JumpStub_LAB_0C31)
; ARGS:
;   (none)
; RET:
;   D0: (see LAB_0C31) ??
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_0C31
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_0C31.
; NOTES:
;   ??
;------------------------------------------------------------------------------
SCRIPT_JMPTBL_LAB_0C31:
LAB_1594:
    JMP     LAB_0C31

JMPTBL_STRING_CompareN_3:
    JMP     STRING_CompareN

;------------------------------------------------------------------------------
; FUNC: SCRIPT_JMPTBL_LAB_08DA   (JumpStub_LAB_08DA)
; ARGS:
;   (none)
; RET:
;   D0: (see LAB_08DA) ??
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_08DA
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_08DA.
; NOTES:
;   ??
;------------------------------------------------------------------------------
SCRIPT_JMPTBL_LAB_08DA:
LAB_1596:
    JMP     LAB_08DA

;------------------------------------------------------------------------------
; FUNC: SCRIPT_JMPTBL_GCOMMAND_GetBannerChar   (JumpStub_GCOMMAND_GetBannerChar)
; ARGS:
;   (none)
; RET:
;   D0: banner char (see GCOMMAND_GetBannerChar)
; CLOBBERS:
;   (none)
; CALLS:
;   GCOMMAND_GetBannerChar
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to GCOMMAND_GetBannerChar.
;------------------------------------------------------------------------------
SCRIPT_JMPTBL_GCOMMAND_GetBannerChar:
LAB_1597:
    JMP     GCOMMAND_GetBannerChar

;------------------------------------------------------------------------------
; FUNC: SCRIPT_JMPTBL_LADFUNC_ParseHexDigit   (JumpStub_LADFUNC_ParseHexDigit)
; ARGS:
;   (none)
; RET:
;   D0: parsed digit (see LADFUNC_ParseHexDigit)
; CLOBBERS:
;   (none)
; CALLS:
;   LADFUNC_ParseHexDigit
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LADFUNC_ParseHexDigit.
;------------------------------------------------------------------------------
SCRIPT_JMPTBL_LADFUNC_ParseHexDigit:
LAB_1598:
    JMP     LADFUNC_ParseHexDigit

;------------------------------------------------------------------------------
; FUNC: SCRIPT_JMPTBL_LAB_0B4E   (JumpStub_LAB_0B4E)
; ARGS:
;   (none)
; RET:
;   D0: (see LAB_0B4E) ??
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_0B4E
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_0B4E.
; NOTES:
;   ??
;------------------------------------------------------------------------------
SCRIPT_JMPTBL_LAB_0B4E:
LAB_1599:
    JMP     LAB_0B4E

;------------------------------------------------------------------------------
; FUNC: SCRIPT_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt   (JumpStub_PARSE_ReadSignedLongSkipClass3_Alt)
; ARGS:
;   (none)
; RET:
;   D0: parsed value (see PARSE_ReadSignedLongSkipClass3_Alt)
; CLOBBERS:
;   (none)
; CALLS:
;   PARSE_ReadSignedLongSkipClass3_Alt
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to PARSE_ReadSignedLongSkipClass3_Alt.
;------------------------------------------------------------------------------
SCRIPT_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt:
LAB_159A:
    JMP     PARSE_ReadSignedLongSkipClass3_Alt

;------------------------------------------------------------------------------
; FUNC: SCRIPT_JMPTBL_GCOMMAND_AdjustBannerCopperOffset   (JumpStub_GCOMMAND_AdjustBannerCopperOffset)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   GCOMMAND_AdjustBannerCopperOffset
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to GCOMMAND_AdjustBannerCopperOffset.
;------------------------------------------------------------------------------
SCRIPT_JMPTBL_GCOMMAND_AdjustBannerCopperOffset:
LAB_159B:
    JMP     GCOMMAND_AdjustBannerCopperOffset

;------------------------------------------------------------------------------
; FUNC: SCRIPT_JMPTBL_ESQ_SetCopperEffect_Custom   (JumpStub_ESQ_SetCopperEffect_Custom)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   ESQ_SetCopperEffect_Custom
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to ESQ_SetCopperEffect_Custom.
;------------------------------------------------------------------------------
SCRIPT_JMPTBL_ESQ_SetCopperEffect_Custom:
LAB_159C:
    JMP     ESQ_SetCopperEffect_Custom

;------------------------------------------------------------------------------
; FUNC: SCRIPT_JMPTBL_CLEANUP_RenderAlignedStatusScreen   (JumpStub_CLEANUP_RenderAlignedStatusScreen)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   CLEANUP_RenderAlignedStatusScreen
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to CLEANUP_RenderAlignedStatusScreen.
;------------------------------------------------------------------------------
SCRIPT_JMPTBL_CLEANUP_RenderAlignedStatusScreen:
LAB_159D:
    JMP     CLEANUP_RenderAlignedStatusScreen

;------------------------------------------------------------------------------
; FUNC: SCRIPT_JMPTBL_LAB_0F3D   (JumpStub_LAB_0F3D)
; ARGS:
;   (none)
; RET:
;   D0: (see LAB_0F3D) ??
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_0F3D
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_0F3D.
; NOTES:
;   ??
;------------------------------------------------------------------------------
SCRIPT_JMPTBL_LAB_0F3D:
LAB_159E:
    JMP     LAB_0F3D

JMPTBL_MATH_Mulu32_7:
    JMP     MATH_Mulu32

;------------------------------------------------------------------------------
; FUNC: SCRIPT_JMPTBL_LAB_0F13   (JumpStub_LAB_0F13)
; ARGS:
;   (none)
; RET:
;   D0: (see LAB_0F13) ??
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_0F13
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_0F13.
; NOTES:
;   ??
;------------------------------------------------------------------------------
SCRIPT_JMPTBL_LAB_0F13:
LAB_15A0:
    JMP     LAB_0F13

;------------------------------------------------------------------------------
; FUNC: SCRIPT_JMPTBL_STRING_CopyPadNul   (JumpStub_STRING_CopyPadNul)
; ARGS:
;   (none)
; RET:
;   D0: (see STRING_CopyPadNul) ??
; CLOBBERS:
;   (none)
; CALLS:
;   STRING_CopyPadNul
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to STRING_CopyPadNul.
;------------------------------------------------------------------------------
SCRIPT_JMPTBL_STRING_CopyPadNul:
LAB_15A1:
    JMP     STRING_CopyPadNul
