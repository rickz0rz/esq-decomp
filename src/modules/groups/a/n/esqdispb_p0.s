    XDEF    ESQDISP_DrawStatusBanner
    XDEF    ESQDISP_DrawStatusBanner_Impl
    XDEF    ESQDISP_FillProgramInfoHeaderFields
    XDEF    ESQDISP_GetEntryAuxPointerByMode
    XDEF    ESQDISP_GetEntryPointerByMode
    XDEF    ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty
    XDEF    ESQDISP_NormalizeClockAndRedrawBanner
    XDEF    ESQDISP_ParseProgramInfoCommandRecord
    XDEF    ESQDISP_PollInputModeAndRefreshSelection
    XDEF    ESQDISP_PromoteSecondaryGroupToPrimary
    XDEF    ESQDISP_PropagatePrimaryTitleMetadataToSecondary
    XDEF    ESQDISP_TestEntryBits0And2
    XDEF    ESQDISP_TestEntryBits0And2_Core
    XDEF    ESQDISP_TestEntryGridEligibility
    XDEF    _ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages
    XDEF    _ESQDISP_JMPTBL_GRAPHICS_AllocRaster
    XDEF    ESQDISP_DrawStatusBanner_Impl_Return
    XDEF    ESQDISP_FillProgramInfoHeaderFields_Return
    XDEF    ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty_Return
    XDEF    ESQDISP_ParseProgramInfoCommandRecord_Return
    XDEF    ESQDISP_PropagatePrimaryTitleMetadataToSecondary_Return
    XDEF    ESQDISP_TestEntryGridEligibility_Return


    ; Alignment
    ALIGN_WORD

;!======

;------------------------------------------------------------------------------
; FUNC: _ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   NEWGRID_ProcessGridMessages
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages:
    JMP     NEWGRID_ProcessGridMessages

;------------------------------------------------------------------------------
; FUNC: _ESQDISP_JMPTBL_GRAPHICS_AllocRaster   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   GRAPHICS_AllocRaster
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQDISP_JMPTBL_GRAPHICS_AllocRaster:
    JMP     GRAPHICS_AllocRaster

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_FillProgramInfoHeaderFields   (Populate program-info header fields)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/A3/A7/D0/D4/D5/D6/D7
; CALLS:
;   ESQFUNC_JMPTBL_STRING_CopyPadNul
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Writes status/time/flag bytes into the program-info header and copies a
;   2-byte code string into header offset 43, then zero-terminates offset 45.
; NOTES:
;   Returns early if destination pointer is NULL.
;------------------------------------------------------------------------------
ESQDISP_FillProgramInfoHeaderFields:
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVEA.L 28(A7),A3
    MOVE.B  35(A7),D7
    MOVE.W  38(A7),D6
    MOVE.B  43(A7),D5
    MOVE.B  47(A7),D4
    MOVEA.L 48(A7),A2
    MOVE.L  A3,D0
    BEQ.S   ESQDISP_FillProgramInfoHeaderFields_Return

    MOVE.B  D7,40(A3)
    MOVE.W  D6,46(A3)
    MOVE.B  D5,41(A3)
    MOVE.B  D4,42(A3)
    LEA     43(A3),A0
    PEA     2.W
    MOVE.L  A2,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    CLR.B   45(A3)

;------------------------------------------------------------------------------
; FUNC: ESQDISP_FillProgramInfoHeaderFields_Return   (Return tail for program-info header fill)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D4
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Shared return tail for ESQDISP_FillProgramInfoHeaderFields.
; NOTES:
;   Restores D4-D7/A2-A3 and returns.
;------------------------------------------------------------------------------
ESQDISP_FillProgramInfoHeaderFields_Return:
    MOVEM.L (A7)+,D4-D7/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_ParseProgramInfoCommandRecord   (Parse program-info command record)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +12: arg_2 (via 16(A5))
;   stack +16: arg_3 (via 20(A5))
;   stack +20: arg_4 (via 24(A5))
;   stack +21: arg_5 (via 25(A5))
;   stack +23: arg_6 (via 27(A5))
;   stack +24: arg_7 (via 28(A5))
;   stack +25: arg_8 (via 29(A5))
;   stack +26: arg_9 (via 30(A5))
;   stack +27: arg_10 (via 31(A5))
;   stack +28: arg_11 (via 32(A5))
;   stack +32: arg_12 (via 36(A5))
;   stack +36: arg_13 (via 40(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D2/D3/D5/D6/D7
; CALLS:
;   _ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit, ESQFUNC_JMPTBL_STRING_CopyPadNul, ESQIFF_JMPTBL_MATH_Mulu32, ESQDISP_FillProgramInfoHeaderFields
; READS:
;   ESQDISP_ParseProgramInfoCommandRecord_Return, ESQDISP_ProgramInfoZeroTag, _WDISP_CharClassTable, _TEXTDISP_SecondaryGroupCode, _TEXTDISP_SecondaryGroupPresentFlag, _TEXTDISP_SecondaryGroupEntryCount, _TEXTDISP_PrimaryGroupCode, _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryEntryPtrTable, _TEXTDISP_SecondaryEntryPtrTable, branch, ff, lab_0918
; WRITES:
;   (none observed)
; DESC:
;   Parses group/slot identifiers plus digit fields, resolves target entry tables,
;   and writes program-info header fields for matching entries.
; NOTES:
;   Uses _WDISP_CharClassTable digit checks before numeric accumulation.
;------------------------------------------------------------------------------
ESQDISP_ParseProgramInfoCommandRecord:
    LINK.W  A5,#-40
    MOVEM.L D2-D3/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D6
    MOVE.B  (A3)+,D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    MOVEQ   #0,D1
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D1
    MOVE.L  D0,-16(A5)
    CMP.L   D0,D1
    BNE.S   .lab_08E5

    MOVE.B  _TEXTDISP_SecondaryGroupPresentFlag,D1
    SUBQ.B  #1,D1
    BNE.S   .lab_08E5

    MOVEQ   #0,D6
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D6
    MOVE.L  #_TEXTDISP_SecondaryEntryPtrTable,-40(A5)
    BRA.S   .lab_08E6

.lab_08E5:
    MOVEQ   #0,D1
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D1
    CMP.L   D1,D0
    BNE.S   .lab_08E6

    MOVEQ   #0,D6
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D6
    MOVE.L  #_TEXTDISP_PrimaryEntryPtrTable,-40(A5)       ; A5 is some struct, what's at -40(A5)?

.lab_08E6:
    MOVE.B  (A3),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   .lab_08E7

    MOVE.B  (A3),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    BRA.S   .lab_08E8

.lab_08E7:
    MOVEQ   #0,D0

.lab_08E8:
    MOVE.L  D0,D5
    ADDQ.L  #1,A3
    MOVE.B  (A3),D0
    EXT.W   D0
    EXT.L   D0
    ADDA.L  D0,A0
    BTST    #2,(A0)
    BEQ.S   .lab_08E9

    MOVE.B  (A3),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    BRA.S   .lab_08EA

.lab_08E9:
    MOVEQ   #0,D0

.lab_08EA:
    ADD.L   D0,D5
    ADDQ.L  #1,A3
    TST.L   D6
    BLE.W   ESQDISP_ParseProgramInfoCommandRecord_Return

    MOVEQ   #6,D0
    CMP.L   D0,D5
    BLT.W   ESQDISP_ParseProgramInfoCommandRecord_Return

    CLR.B   -25(A5)

.lab_08EB:
    MOVEQ   #18,D0
    CMP.B   (A3),D0
    BNE.W   ESQDISP_ParseProgramInfoCommandRecord_Return

    ADDQ.L  #1,A3
    MOVE.L  A3,-20(A5)
    CLR.L   -24(A5)
    MOVEQ   #0,D7

.lab_08EC:
    MOVEQ   #6,D0
    CMP.L   D0,D7
    BGE.S   .lab_08EE

    ADDQ.L  #1,A3
    MOVEQ   #4,D0
    CMP.B   (A3),D0
    BNE.S   .lab_08ED

    CLR.B   (A3)+
    MOVE.L  A3,-24(A5)
    ADDA.L  D5,A3
    BRA.S   .lab_08EE

.lab_08ED:
    ADDQ.L  #1,D7
    BRA.S   .lab_08EC

.lab_08EE:
    TST.L   -24(A5)
    BEQ.S   .lab_08EB

    MOVEQ   #0,D7

.branch:
    CMP.L   D6,D7
    BGE.S   .lab_08EB

    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEA.L -40(A5),A0
    MOVEA.L 0(A0,D0.L),A0
    LEA     12(A0),A1
    MOVEA.L -20(A5),A0

.lab_08F0:
    MOVE.B  (A1)+,D0
    CMP.B   (A0)+,D0
    BNE.W   .lab_0918

    TST.B   D0
    BNE.S   .lab_08F0

    BNE.W   .lab_0918

    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEA.L -40(A5),A0
    MOVE.L  0(A0,D0.L),-36(A5)
    MOVEA.L -36(A5),A0
    MOVE.B  40(A0),D0
    MOVE.W  46(A0),-32(A5)
    MOVE.B  D0,-28(A5)
    TST.L   D5
    BLE.S   .lab_08F4

    MOVEA.L -24(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    BTST    #1,(A2)
    BEQ.S   .lab_08F1

    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .lab_08F2

.lab_08F1:
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0

.lab_08F2:
    MOVEQ   #89,D1
    CMP.L   D1,D0
    BNE.S   .lab_08F3

    BSET    #1,-28(A5)
    BRA.S   .lab_08F4

.lab_08F3:
    BCLR    #1,-28(A5)

.lab_08F4:
    MOVEQ   #1,D0
    CMP.L   D0,D5
    BLE.S   .lab_08F8

    MOVEA.L -24(A5),A0
    MOVE.B  1(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    BTST    #1,(A2)
    BEQ.S   .lab_08F5

    MOVE.B  1(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .lab_08F6

.lab_08F5:
    MOVE.B  1(A0),D0
    EXT.W   D0
    EXT.L   D0

.lab_08F6:
    MOVEQ   #89,D1
    CMP.L   D1,D0
    BNE.S   .lab_08F7

    BSET    #2,-28(A5)
    BRA.S   .lab_08F8

.lab_08F7:
    BCLR    #2,-28(A5)

.lab_08F8:
    MOVEQ   #2,D0
    CMP.L   D0,D5
    BLE.S   .lab_08F9

    MOVEA.L -24(A5),A0
    MOVE.B  2(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.S   .lab_08F9

    MOVE.B  2(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     _ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .lab_08FA

.lab_08F9:
    MOVEQ   #0,D1
    NOT.B   D1

.lab_08FA:
    MOVE.B  D1,-29(A5)
    MOVEQ   #0,D0
    CMP.B   D0,D1
    BCS.S   .lab_08FB

    MOVEQ   #15,D0
    CMP.B   D0,D1
    BLS.S   .lab_08FC

.lab_08FB:
    MOVE.B  #$ff,-29(A5)

.lab_08FC:
    MOVEQ   #3,D0
    CMP.L   D0,D5
    BLE.S   .lab_08FD

    MOVEA.L -24(A5),A0
    MOVE.B  3(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.S   .lab_08FD

    MOVE.B  3(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     _ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .lab_08FE

.lab_08FD:
    MOVEQ   #0,D1
    NOT.B   D1

.lab_08FE:
    MOVE.B  D1,-30(A5)
    MOVEQ   #1,D0
    CMP.B   D0,D1
    BCS.S   .lab_08FF

    MOVEQ   #3,D0
    CMP.B   D0,D1
    BLS.S   .branch_1

.lab_08FF:
    MOVE.B  #$ff,-30(A5)

.branch_1:
    MOVEQ   #5,D0
    CMP.L   D0,D5
    BLE.S   .branch_2

    MOVEA.L -24(A5),A0
    ADDQ.L  #4,A0
    PEA     2.W
    MOVE.L  A0,-(A7)
    PEA     -27(A5)
    JSR     ESQFUNC_JMPTBL_STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    BRA.S   .branch_4

.branch_2:
    LEA     ESQDISP_ProgramInfoZeroTag,A0
    LEA     -27(A5),A1

.branch_3:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .branch_3

.branch_4:
    MOVEQ   #6,D0
    CMP.L   D0,D5
    BLE.S   .branch_8

    MOVEA.L -24(A5),A0
    MOVE.B  6(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    BTST    #1,(A2)
    BEQ.S   .branch_5

    MOVE.B  6(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .branch_6

.branch_5:
    MOVE.B  6(A0),D0
    EXT.W   D0
    EXT.L   D0

.branch_6:
    MOVEQ   #89,D1
    CMP.L   D1,D0
    BNE.S   .branch_7

    BSET    #0,-31(A5)
    BRA.S   .branch_8

.branch_7:
    BCLR    #0,-31(A5)

.branch_8:
    MOVEQ   #7,D0
    CMP.L   D0,D5
    BLE.S   .branch_12

    MOVEA.L -24(A5),A0
    MOVE.B  7(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    BTST    #1,(A2)
    BEQ.S   .branch_9

    MOVE.B  7(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .branch_10

.branch_9:
    MOVE.B  7(A0),D0
    EXT.W   D0
    EXT.L   D0

.branch_10:
    MOVEQ   #89,D1
    CMP.L   D1,D0
    BNE.S   .branch_11

    BSET    #1,-31(A5)
    BRA.S   .branch_12

.branch_11:
    BCLR    #1,-31(A5)

.branch_12:
    MOVEQ   #8,D0
    CMP.L   D0,D5
    BLE.S   .branch_16

    MOVEA.L -24(A5),A0
    MOVE.B  8(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    BTST    #1,(A2)
    BEQ.S   .branch_13

    MOVE.B  8(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .branch_14

.branch_13:
    MOVE.B  8(A0),D0
    EXT.W   D0
    EXT.L   D0

.branch_14:
    MOVEQ   #89,D1
    CMP.L   D1,D0
    BNE.S   .branch_15

    BSET    #2,-31(A5)
    BRA.S   .branch_16

.branch_15:
    BCLR    #2,-31(A5)

.branch_16:
    MOVEQ   #9,D0
    CMP.L   D0,D5
    BLE.S   .branch_20

    MOVEA.L -24(A5),A0
    MOVE.B  9(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    BTST    #1,(A2)
    BEQ.S   .branch_17

    MOVE.B  9(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .branch_18

.branch_17:
    MOVE.B  9(A0),D0
    EXT.W   D0
    EXT.L   D0

.branch_18:
    MOVEQ   #89,D1
    CMP.L   D1,D0
    BNE.S   .branch_19

    BSET    #3,-31(A5)
    BRA.S   .branch_20

.branch_19:
    BCLR    #3,-31(A5)

.branch_20:
    MOVEQ   #10,D0
    CMP.L   D0,D5
    BLE.S   .branch_24

    MOVEA.L -24(A5),A0
    MOVE.B  10(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #1,(A1)
    BEQ.S   .branch_21

    MOVE.B  10(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .branch_22

.branch_21:
    MOVE.B  10(A0),D0
    EXT.W   D0
    EXT.L   D0

.branch_22:
    MOVEQ   #89,D1
    CMP.L   D1,D0
    BNE.S   .branch_23

    BSET    #4,-31(A5)
    BRA.S   .branch_24

.branch_23:
    BCLR    #4,-31(A5)

.branch_24:
    MOVEQ   #0,D0
    MOVE.B  -28(A5),D0
    MOVEQ   #0,D1
    MOVE.W  -32(A5),D1
    MOVEQ   #0,D2
    MOVE.B  -29(A5),D2
    MOVEQ   #0,D3
    MOVE.B  -30(A5),D3
    PEA     -27(A5)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -36(A5),-(A7)
    BSR.W   ESQDISP_FillProgramInfoHeaderFields

    LEA     24(A7),A7

.lab_0918:
    ADDQ.L  #1,D7
    BRA.W   .branch

;------------------------------------------------------------------------------
; FUNC: ESQDISP_ParseProgramInfoCommandRecord_Return   (Return tail for program-info parser)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D2
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Shared return tail for ESQDISP_ParseProgramInfoCommandRecord.
; NOTES:
;   Restores D2-D3/D5-D7/A2-A3 and frame state.
;------------------------------------------------------------------------------
ESQDISP_ParseProgramInfoCommandRecord_Return:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_TestEntryGridEligibility   (Test per-slot grid eligibility)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D6/D7
; CALLS:
;   (none)
; READS:
;   fc
; WRITES:
;   (none observed)
; DESC:
;   Returns 1 when the requested slot index is valid and either entry slot bit4
;   is set or the slot value byte (base+0xFC+idx) lies in range 5..10.
; NOTES:
;   Valid slot range is 1..48; otherwise returns 0.
;------------------------------------------------------------------------------
ESQDISP_TestEntryGridEligibility:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVE.W  22(A7),D7

    MOVEQ   #0,D6
    TST.W   D7
    BLE.S   ESQDISP_TestEntryGridEligibility_Return

    MOVEQ   #49,D0
    CMP.W   D0,D7
    BGE.S   ESQDISP_TestEntryGridEligibility_Return

    MOVE.L  A3,D0
    BEQ.S   ESQDISP_TestEntryGridEligibility_Return

    BTST    #4,7(A3,D7.W)
    BNE.S   .lab_091C

    MOVE.L  D7,D0
    ADDI.W  #$fc,D0
    CMPI.B  #$5,0(A3,D0.W)
    BCS.S   .lab_091B

    MOVE.L  D7,D0
    ADDI.W  #$fc,D0
    CMPI.B  #$a,0(A3,D0.W)
    BLS.S   .lab_091C

.lab_091B:
    MOVEQ   #0,D0
    BRA.S   .lab_091D

.lab_091C:
    MOVEQ   #1,D0

.lab_091D:
    MOVE.L  D0,D6

;------------------------------------------------------------------------------
; FUNC: ESQDISP_TestEntryGridEligibility_Return   (Return tail for grid eligibility test)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D6
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Shared return tail for ESQDISP_TestEntryGridEligibility.
; NOTES:
;   Returns D6 in D0.
;------------------------------------------------------------------------------
ESQDISP_TestEntryGridEligibility_Return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_TestEntryBits0And2   (Test entry flags bit0+bit2)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Alias entry that immediately falls through to `_Core` implementation below.
; NOTES:
;   Kept as exported compatibility label for existing callsites.
;------------------------------------------------------------------------------
ESQDISP_TestEntryBits0And2:
;------------------------------------------------------------------------------
; FUNC: ESQDISP_TestEntryBits0And2_Core   (Test entry flags bit0 and bit2)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D7
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Returns 1 only when both bit0 and bit2 are set in entry status byte +40.
; NOTES:
;   Returns 0 for NULL entry pointers.
;------------------------------------------------------------------------------
ESQDISP_TestEntryBits0And2_Core:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3

    MOVEQ   #0,D7
    MOVE.L  A3,D0
    BEQ.S   .return

    BTST    #0,40(A3)
    BEQ.S   .bits_not_set

    BTST    #2,40(A3)
    BEQ.S   .bits_not_set

    MOVEQ   #1,D0
    BRA.S   .store_result

.bits_not_set:
    MOVEQ   #0,D0

.store_result:
    MOVE.L  D0,D7

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_GetEntryPointerByMode   (Get entry pointer by mode/index)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Alias documentation header; full behavior contract is defined in the
;   immediately following detailed header block.
; NOTES:
;   Preserved as entry marker before expanded ARGS/READS section.
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
; FUNC: ESQDISP_GetEntryPointerByMode   (Get entry pointer by mode/index)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A7/D0/D6/D7
; CALLS:
;   (none)
; READS:
;   _TEXTDISP_SecondaryGroupEntryCount, _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryEntryPtrTable, _TEXTDISP_SecondaryEntryPtrTable
; WRITES:
;   (none observed)
; DESC:
;   Returns entry pointer for index in primary mode (1) or secondary mode (2),
;   with bounds checks against each group's entry count.
; NOTES:
;   Returns NULL for out-of-range index or unsupported mode.
;------------------------------------------------------------------------------
ESQDISP_GetEntryPointerByMode:
    LINK.W  A5,#-4
    MOVEM.L D6-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    CLR.L   -4(A5)

    MOVEQ   #1,D0
    CMP.L   D0,D6
    BNE.S   .lab_0924

    TST.L   D7
    BMI.S   .return

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    BRA.S   .return

.lab_0924:
    MOVEQ   #2,D0
    CMP.L   D0,D6
    BNE.S   .return

    TST.L   D7
    BMI.S   .return

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,-4(A5)

.return:
    MOVE.L  -4(A5),D0
    MOVEM.L (A7)+,D6-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_GetEntryAuxPointerByMode   (Get auxiliary pointer by mode/index)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Wrapper/prototype header for mode/index title-table lookup.
; NOTES:
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
; FUNC: ESQDISP_GetEntryAuxPointerByMode   (Get title-table pointer by mode/index)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A7/D0/D1/D5/D6/D7
; CALLS:
;   (none)
; READS:
;   _TEXTDISP_SecondaryGroupEntryCount, _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryTitlePtrTable, _TEXTDISP_SecondaryTitlePtrTable
; WRITES:
;   (none observed)
; DESC:
;   Returns title-table pointer for index in primary mode (1) or secondary mode
;   (2), with bounds checks against each group's entry count.
; NOTES:
;   Returns NULL for out-of-range index or unsupported mode.
;------------------------------------------------------------------------------
ESQDISP_GetEntryAuxPointerByMode:
    LINK.W  A5,#-4
    MOVEM.L D6-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    CLR.L   -4(A5)

    MOVEQ   #1,D0
    CMP.L   D0,D6
    BNE.S   .lab_0927

    TST.L   D7
    BMI.S   .return

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    BRA.S   .return

.lab_0927:
    MOVEQ   #2,D0
    CMP.L   D0,D6
    BNE.S   .return

    TST.L   D7
    BMI.S   .return

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,-4(A5)

.return:
    MOVE.L  -4(A5),D0
    MOVEM.L (A7)+,D6-D7
    UNLK    A5
    RTS

;!======

; Unreferenced Code
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7

    MOVEQ   #23,D1
    CMP.W   D1,D7
    SGT     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0

    MOVE.L  (A7)+,D7
    RTS

;!======

; Unreferenced Code
    MOVEM.L D5-D7,-(A7)
    MOVE.W  18(A7),D7
    MOVE.W  22(A7),D6

    MOVEQ   #-1,D0
    CMP.W   D0,D6
    BNE.S   .lab_0929

    CMPI.W  #$16e,D7
    BLE.S   .lab_0929

    MOVEQ   #1,D5
    BRA.S   .lab_092B

.lab_0929:
    TST.W   D6
    BNE.S   .lab_092A

    CMPI.W  #$16d,D7
    BLE.S   .lab_092A

    MOVEQ   #1,D5
    BRA.S   .lab_092B

.lab_092A:
    MOVEQ   #0,D5

.lab_092B:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7
    RTS

;!======

; Unreferenced Code
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7

    TST.W   D7
    SMI     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0

    MOVE.L  (A7)+,D7
    RTS

;!======

; Unreferenced Code
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7

    MOVEQ   #1,D1
    CMP.W   D1,D7
    SLT     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0

    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_PollInputModeAndRefreshSelection   (Debounce input mode and refresh selection)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A5/A7/D0/D1/D7
; CALLS:
;   ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh, ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode
; READS:
;   ESQDISP_LatchedInputModeBit, bfd0ee
; WRITES:
;   ESQDISP_LatchedInputModeBit, ESQDISP_InputModeDebounceCount, _Global_RefreshTickCounter
; DESC:
;   Polls CIAB input mode bits with debounce; when stable change is detected,
;   updates mode state and either resets selection or redraws rast mode.
; NOTES:
;   Requires >5 consecutive polls before committing mode change.
;------------------------------------------------------------------------------
ESQDISP_PollInputModeAndRefreshSelection:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    MOVE.W  #(-1),_Global_RefreshTickCounter
    MOVE.L  #$bfd0ee,-6(A5) ; uncertain, between PRA_CIAB and PRB_CIAB
    MOVEQ   #4,D7
    MOVEA.L -6(A5),A0
    AND.B   (A0),D7
    MOVE.B  ESQDISP_LatchedInputModeBit,D0
    CMP.B   D7,D0
    BEQ.S   .lab_092D

    ADDQ.L  #1,ESQDISP_InputModeDebounceCount
    BRA.S   .lab_092E

.lab_092D:
    MOVEQ   #0,D0
    MOVE.L  D0,ESQDISP_InputModeDebounceCount

.lab_092E:
    CMPI.L  #$5,ESQDISP_InputModeDebounceCount
    BLE.S   .return

    MOVE.L  D7,D0
    MOVE.B  D0,ESQDISP_LatchedInputModeBit
    MOVEQ   #0,D1
    MOVE.L  D1,ESQDISP_InputModeDebounceCount
    TST.B   D0
    BNE.S   .lab_092F

    MOVE.L  D1,-(A7)
    JSR     ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(PC)

    ADDQ.W  #4,A7
    BRA.S   .return

.lab_092F:
    JSR     ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh(PC)

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_NormalizeClockAndRedrawBanner   (Normalize clock and redraw banner/status)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A3/A5/A7
; CALLS:
;   _DST_RefreshBannerBuffer, DST_UpdateBannerQueue, ESQFUNC_JMPTBL_CLEANUP_DrawClockBanner, ESQFUNC_JMPTBL_PARSEINI_NormalizeClockData, ESQDISP_DrawStatusBanner_Impl
; READS:
;   _Global_REF_696_400_BITMAP, _Global_REF_RASTPORT_1, _DST_BannerWindowPrimary, _CLOCK_DaySlotIndex
; WRITES:
;   (none observed)
; DESC:
;   Normalizes clock data, updates banner queue/buffer, draws clock banner on
;   the 696x400 bitmap, then redraws status banner with highlight enabled.
; NOTES:
;   Temporarily swaps rastport bitmap pointer during clock banner draw.
;------------------------------------------------------------------------------
ESQDISP_NormalizeClockAndRedrawBanner:
    LINK.W  A5,#-4
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  A3,-(A7)
    PEA     _CLOCK_DaySlotIndex
    JSR     ESQFUNC_JMPTBL_PARSEINI_NormalizeClockData(PC)

    PEA     _DST_BannerWindowPrimary
    JSR     DST_UpdateBannerQueue(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .lab_0932

    JSR     _DST_RefreshBannerBuffer(PC)

.lab_0932:
    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  4(A0),-4(A5)
    MOVE.L  #_Global_REF_696_400_BITMAP,4(A0)
    JSR     ESQFUNC_JMPTBL_CLEANUP_DrawClockBanner(PC)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  -4(A5),4(A0)
    PEA     1.W
    BSR.W   ESQDISP_DrawStatusBanner_Impl

    MOVEA.L -8(A5),A3
    UNLK    A5
    RTS

;!======

; Draw the status banner into rastport 1 (with optional highlight).
ESQDISP_DrawStatusBanner:
;------------------------------------------------------------------------------
; FUNC: ESQDISP_DrawStatusBanner_Impl   (Render status banner rows and sync slot state)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A6/A7/D0/D1/D2/D3/D5/D6/D7
; CALLS:
;   ESQFUNC_JMPTBL_ESQ_ClampBannerCharRange, ESQFUNC_JMPTBL_ESQ_GetHalfHourSlotIndex, ESQFUNC_JMPTBL_LOCAVAIL_SyncSecondaryFilterForCurrentGroup, ESQFUNC_JMPTBL_P_TYPE_EnsureSecondaryList, ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState, ESQIFF_JMPTBL_MATH_Mulu32, ESQDISP_PropagatePrimaryTitleMetadataToSecondary, _LVOSetAPen
; READS:
;   Global_REF_GRAPHICS_LIBRARY, _Global_REF_RASTPORT_1, _ESQ_STR_B, _ESQ_STR_E, ESQDISP_StatusBannerClampGateFlag, ESQDISP_LastPrimaryCountdownValue, ESQDISP_SecondaryPersistArmGateFlag, ESQDISP_SecondaryPropagationDoneFlag, WDISP_StatusDayEntry0, WDISP_StatusDayEntry1, WDISP_StatusDayEntry2, WDISP_StatusDayEntry3, _CLOCK_DaySlotIndex, CLOCK_CacheMonthIndex0, CLOCK_CacheDayIndex0, CLOCK_CacheYear, _DST_PrimaryCountdown, WDISP_BannerSlotCursor, _CLOCK_HalfHourSlotIndex, CLOCK_CurrentDayOfYear, lab_0942, lab_0943, lab_0944
; WRITES:
;   BANNER_ResetPendingFlag, ESQDISP_SecondaryPersistRequestFlag, ESQDISP_LastPrimaryCountdownValue, ESQDISP_SecondaryPersistArmGateFlag, ESQDISP_SecondaryPropagationDoneFlag, TLIBA1_StatusBannerPropagateGuard, _TEXTDISP_SecondaryGroupCode, _TEXTDISP_PrimaryGroupCode, _CLOCK_HalfHourSlotIndex
; DESC:
;   Computes the current half-hour banner slot, applies optional range clamp,
;   updates highlight/banner state, and renders status text for active day entries.
; NOTES:
;   May trigger one-time secondary metadata/list propagation when threshold
;   conditions are met near function tail.
;------------------------------------------------------------------------------
ESQDISP_DrawStatusBanner_Impl:
    LINK.W  A5,#-4
    MOVEM.L D2-D3/D5-D7/A2,-(A7)
    MOVE.W  38(A7),D7
    MOVEQ   #0,D5
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    PEA     _CLOCK_DaySlotIndex
    JSR     ESQFUNC_JMPTBL_ESQ_GetHalfHourSlotIndex(PC)

    ADDQ.W  #4,A7
    MOVE.W  D0,_CLOCK_HalfHourSlotIndex
    TST.W   ESQDISP_StatusBannerClampGateFlag
    BEQ.S   .lab_0934

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVEQ   #0,D0
    MOVE.B  _ESQ_STR_B,D0
    MOVEQ   #0,D2
    MOVE.B  _ESQ_STR_E,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    JSR     ESQFUNC_JMPTBL_ESQ_ClampBannerCharRange(PC)

    LEA     12(A7),A7

.lab_0934:
    JSR     ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState(PC)

    TST.W   D7
    BEQ.S   .lab_0935

    MOVEQ   #1,D0
    MOVE.W  D0,BANNER_ResetPendingFlag

.lab_0935:
    MOVE.W  _CLOCK_HalfHourSlotIndex,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCS.S   .lab_0937

    MOVEQ   #39,D1
    CMP.W   D1,D0
    BCC.S   .lab_0937

    MOVE.W  WDISP_BannerSlotCursor,D1
    EXT.L   D1
    MOVEQ   #0,D2
    NOT.B   D2
    AND.L   D2,D1
    MOVE.B  D1,_TEXTDISP_PrimaryGroupCode
    MOVE.W  CLOCK_CacheDayIndex0,D0
    MOVEQ   #31,D3
    CMP.W   D3,D0
    BNE.S   .lab_0936

    MOVE.W  CLOCK_CacheMonthIndex0,D0
    MOVEQ   #11,D3
    CMP.W   D3,D0
    BNE.S   .lab_0936

    MOVE.B  #$1,_TEXTDISP_SecondaryGroupCode
    BRA.S   .lab_093A

.lab_0936:
    MOVEQ   #0,D0
    MOVE.B  D1,D0
    ADDQ.L  #1,D0
    AND.L   D2,D0
    MOVE.B  D0,_TEXTDISP_SecondaryGroupCode
    BRA.S   .lab_093A

.lab_0937:
    MOVE.W  WDISP_BannerSlotCursor,D1
    EXT.L   D1
    MOVEQ   #0,D2
    NOT.B   D2
    AND.L   D2,D1
    MOVE.B  D1,_TEXTDISP_SecondaryGroupCode
    MOVE.W  WDISP_BannerSlotCursor,D0
    SUBQ.W  #1,D0
    BNE.S   .lab_0939

    MOVE.W  CLOCK_CacheYear,D0
    EXT.L   D0
    SUBQ.L  #1,D0
    MOVEQ   #3,D1
    AND.L   D1,D0
    BNE.S   .lab_0938

    MOVE.B  #$6e,_TEXTDISP_PrimaryGroupCode
    BRA.S   .lab_093A

.lab_0938:
    MOVE.B  #$6d,_TEXTDISP_PrimaryGroupCode
    BRA.S   .lab_093A

.lab_0939:
    MOVE.W  WDISP_BannerSlotCursor,D0
    EXT.L   D0
    SUBQ.L  #1,D0
    AND.L   D2,D0
    MOVE.B  D0,_TEXTDISP_PrimaryGroupCode

.lab_093A:
    MOVE.W  _DST_PrimaryCountdown,D0
    MOVE.W  ESQDISP_LastPrimaryCountdownValue,D1
    CMP.W   D0,D1
    BEQ.S   .lab_093C

    MOVE.W  D0,ESQDISP_LastPrimaryCountdownValue
    SUBQ.W  #1,D0
    BNE.S   .lab_093C

    MOVE.W  _CLOCK_HalfHourSlotIndex,D0
    SUBQ.W  #3,D0
    BNE.S   .lab_093B

    MOVEQ   #0,D0
    MOVE.W  D0,ESQDISP_SecondaryPersistArmGateFlag
    BRA.S   .lab_093C

.lab_093B:
    MOVE.W  _CLOCK_HalfHourSlotIndex,D0
    MOVEQ   #46,D1
    CMP.W   D1,D0
    BNE.S   .lab_093C

    CLR.W   ESQDISP_SecondaryPropagationDoneFlag

.lab_093C:
    MOVEQ   #0,D6

.lab_093D:
    TST.L   D5
    BNE.S   .lab_0941

    MOVEQ   #4,D0
    CMP.L   D0,D6
    BGE.S   .lab_0941

    MOVE.L  D6,D0
    MOVEQ   #20,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     WDISP_StatusDayEntry0,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   16(A1)
    BNE.S   .lab_093E

    MOVE.W  CLOCK_CurrentDayOfYear,D1
    EXT.L   D1
    ADD.L   D6,D1
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    CMP.L   (A1),D1
    BEQ.S   .lab_093F

.lab_093E:
    MOVE.W  CLOCK_CurrentDayOfYear,D0
    EXT.L   D0
    ADD.L   D6,D0
    MOVE.L  D0,24(A7)
    MOVE.L  D6,D0
    MOVEQ   #20,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    ADDA.L  D0,A0
    MOVE.L  24(A7),D0
    ADDI.L  #$100,D0
    CMP.L   (A0),D0
    BEQ.S   .lab_093F

    MOVEQ   #0,D0
    BRA.S   .lab_0940

.lab_093F:
    MOVEQ   #1,D0

.lab_0940:
    MOVE.L  D0,D5
    ADDQ.L  #1,D6
    BRA.S   .lab_093D

.lab_0941:
    TST.L   D5
    BEQ.S   .lab_0945

    LEA     WDISP_StatusDayEntry1,A0
    MOVEA.L A0,A1
    LEA     WDISP_StatusDayEntry0,A2
    MOVEQ   #4,D0

.lab_0942:
    MOVE.L  (A1)+,(A2)+
    DBF     D0,.lab_0942
    LEA     WDISP_StatusDayEntry2,A0
    MOVEA.L A0,A1
    LEA     WDISP_StatusDayEntry1,A2
    MOVEQ   #4,D0

.lab_0943:
    MOVE.L  (A1)+,(A2)+
    DBF     D0,.lab_0943
    LEA     WDISP_StatusDayEntry3,A0
    LEA     WDISP_StatusDayEntry2,A1
    MOVEQ   #4,D0

.lab_0944:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.lab_0944
    MOVEQ   #1,D0
    MOVE.L  D0,TLIBA1_StatusBannerPropagateGuard

.lab_0945:
    MOVE.W  _CLOCK_HalfHourSlotIndex,D0
    SUBQ.W  #1,D0
    BNE.S   .lab_0946

    MOVEQ   #0,D0
    MOVE.W  D0,ESQDISP_SecondaryPersistArmGateFlag

.lab_0946:
    MOVE.W  _CLOCK_HalfHourSlotIndex,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCS.S   .lab_0947

    TST.W   ESQDISP_SecondaryPersistArmGateFlag
    BNE.S   .lab_0947

    MOVEQ   #1,D1
    MOVE.L  D1,ESQDISP_SecondaryPersistRequestFlag
    MOVE.W  #1,ESQDISP_SecondaryPersistArmGateFlag

.lab_0947:
    MOVEQ   #44,D1
    CMP.W   D1,D0
    BNE.S   .lab_0948

    MOVEQ   #0,D1
    MOVE.W  D1,ESQDISP_SecondaryPropagationDoneFlag

.lab_0948:
    MOVEQ   #45,D1
    CMP.W   D1,D0
    BCS.S   ESQDISP_DrawStatusBanner_Impl_Return

    TST.W   ESQDISP_SecondaryPropagationDoneFlag
    BNE.S   ESQDISP_DrawStatusBanner_Impl_Return

    BSR.W   ESQDISP_PropagatePrimaryTitleMetadataToSecondary

    JSR     ESQFUNC_JMPTBL_LOCAVAIL_SyncSecondaryFilterForCurrentGroup(PC)

    JSR     ESQFUNC_JMPTBL_P_TYPE_EnsureSecondaryList(PC)

    MOVE.W  #1,ESQDISP_SecondaryPropagationDoneFlag

;------------------------------------------------------------------------------
; FUNC: ESQDISP_DrawStatusBanner_Impl_Return   (Return tail for status-banner renderer)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D2
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Restores saved registers/frame and returns to caller.
; NOTES:
;   Shared exit for all draw/early-return paths.
;------------------------------------------------------------------------------
ESQDISP_DrawStatusBanner_Impl_Return:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty   (Mirror primary entries into secondary group when empty)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D2/D3/D7
; CALLS:
;   ESQDISP_FillProgramInfoHeaderFields, ESQSHARED_CreateGroupEntryAndTitle
; READS:
;   _TEXTDISP_SecondaryGroupCode, _TEXTDISP_SecondaryGroupEntryCount, _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryEntryPtrTable, TEXTDISP_SecondaryEntryPtrTablePreSlot, ff7f
; WRITES:
;   ESQDISP_PrimarySecondaryMirrorFlag
; DESC:
;   If secondary group has no entries, clones each primary entry into a newly created
;   secondary entry/title record and copies the per-slot program-info header fields.
;   Sets a flag when mirroring was performed, clears it when secondary was already populated.
; NOTES:
;   Loop walks primary indices from 0 to (PrimaryGroupEntryCount-1).
;------------------------------------------------------------------------------
ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty:
    LINK.W  A5,#-12
    MOVEM.L D2-D3/D7/A2-A3/A6,-(A7)
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    BNE.W   .mark_no_mirror_needed

    MOVEQ   #0,D7

.loop_primary_entries_for_mirror:
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D7
    BGE.W   .set_mirror_performed_flag

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D0
    MOVEQ   #0,D1
    MOVEA.L -4(A5),A0
    MOVE.B  27(A0),D1
    LEA     12(A0),A1
    LEA     1(A0),A2
    LEA     28(A0),A3
    LEA     19(A0),A6
    MOVE.L  A6,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQSHARED_CreateGroupEntryAndTitle(PC)

    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ASL.L   #2,D1
    LEA     TEXTDISP_SecondaryEntryPtrTablePreSlot,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  40(A0),D0
    ANDI.W  #$ff7f,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #0,D0
    MOVE.W  46(A0),D0
    MOVEQ   #0,D2
    MOVE.B  41(A0),D2
    MOVEQ   #0,D3
    MOVE.B  42(A0),D3
    LEA     43(A0),A2
    MOVE.L  A2,(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A1,-8(A5)
    BSR.W   ESQDISP_FillProgramInfoHeaderFields

    LEA     44(A7),A7
    ADDQ.L  #1,D7
    BRA.W   .loop_primary_entries_for_mirror

.set_mirror_performed_flag:
    MOVE.W  #1,ESQDISP_PrimarySecondaryMirrorFlag
    BRA.S   ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty_Return

.mark_no_mirror_needed:
    CLR.W   ESQDISP_PrimarySecondaryMirrorFlag

;------------------------------------------------------------------------------
; FUNC: ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty_Return   (Return tail for secondary mirror helper)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D2
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Restores saved registers and returns from secondary-mirror helper.
; NOTES:
;   Shared return tail for both "mirrored" and "already populated" paths.
;------------------------------------------------------------------------------
ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty_Return:
    MOVEM.L (A7)+,D2-D3/D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_PropagatePrimaryTitleMetadataToSecondary   (Propagate primary title metadata to matching secondary entries)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   ESQSHARED_JMPTBL_ESQ_TestBit1Based, _ESQSHARED_JMPTBL_ESQ_WildcardMatch, _ESQPARS_ReplaceOwnedString
; READS:
;   _TEXTDISP_SecondaryGroupEntryCount, _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryEntryPtrTable, _TEXTDISP_SecondaryEntryPtrTable, _TEXTDISP_PrimaryTitlePtrTable, _TEXTDISP_SecondaryTitlePtrTable
; WRITES:
;   (none observed)
; DESC:
;   For each secondary entry lacking an owned title string and with the slot bit clear,
;   finds wildcard-matching primary titles and copies slot metadata/string ownership from
;   primary to secondary. Marks secondary title/entry flags when propagation succeeds.
; NOTES:
;   Slot scan is descending and bounded by entry class (0..47 or 44..47 window).
;------------------------------------------------------------------------------
ESQDISP_PropagatePrimaryTitleMetadataToSecondary:
    LINK.W  A5,#-40
    MOVEM.L D2-D7/A2-A3/A6,-(A7)
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.W   ESQDISP_PropagatePrimaryTitleMetadataToSecondary_Return

    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.W   D1,D0
    BLS.W   ESQDISP_PropagatePrimaryTitleMetadataToSecondary_Return

    MOVEQ   #0,D7

.loop_secondary_entries:
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.L   D0,D7
    BGE.W   ESQDISP_PropagatePrimaryTitleMetadataToSecondary_Return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    TST.L   60(A1)
    BNE.W   .next_secondary_entry

    LEA     _TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    LEA     28(A1),A0
    PEA     1.W
    MOVE.L  A0,-(A7)
    JSR     ESQSHARED_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   .next_secondary_entry

    MOVEQ   #0,D4
    MOVEQ   #0,D6

.loop_primary_candidates:
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D6
    BGE.W   .next_secondary_entry

    TST.L   D4
    BNE.W   .next_secondary_entry

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    MOVE.L  A2,-(A7)
    MOVE.L  A1,-(A7)
    JSR     _ESQSHARED_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.W   .next_primary_candidate

    MOVEQ   #48,D5
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    BTST    #5,Struct_PrimaryEntry__EditorFlagsByte(A1)
    BEQ.S   .set_slot_scan_floor_low

    MOVEQ   #0,D0
    BRA.S   .store_slot_scan_floor

.set_slot_scan_floor_low:
    MOVEQ   #44,D0

.store_slot_scan_floor:
    MOVE.L  D0,-20(A5)

.loop_slots_descending:
    CMP.L   -20(A5),D5
    BLE.W   .next_primary_candidate

    TST.L   D4
    BNE.W   .next_primary_candidate

    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    LEA     Struct_PrimaryEntry__SelectionBitsetBase(A1),A0
    MOVE.L  D5,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ESQSHARED_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   .next_slot_descending

    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    MOVE.L  D5,D1
    ASL.L   #2,D1
    ADDA.L  D1,A2
    TST.L   Struct_TitleAuxRecord__SelectorTextPtrBase(A2)
    BEQ.W   .next_slot_descending

    MOVE.L  D7,D2
    ASL.L   #2,D2
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A1
    MOVEA.L A1,A2
    ADDA.L  D2,A2
    MOVEA.L (A2),A3
    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVEA.L (A2),A6
    ADDA.L  D5,A6
    MOVEQ   #0,D3
    MOVE.B  Struct_TitleAuxRecord__SelectorFlagsByteBase(A6),D3
    ORI.W   #$80,D3
    MOVE.B  D3,8(A3)
    MOVEA.L A1,A2
    ADDA.L  D2,A2
    MOVEA.L (A2),A3
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    ADDA.L  D1,A2
    ADDA.L  D2,A1
    MOVEA.L (A1),A0
    MOVE.L  Struct_TitleAuxRecord__OwnedStringPtr(A0),-(A7)      ; dst owned-string slot (secondary title record)
    MOVE.L  Struct_TitleAuxRecord__SelectorTextPtrBase(A2),-(A7) ; src selector text pointer slot (+56 + selector*4)
    MOVE.L  A3,60(A7)
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVEA.L 52(A7),A0
    MOVE.L  D0,Struct_TitleAuxRecord__OwnedStringPtr(A0)
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    MOVE.L  D6,D1
    ASL.L   #2,D1
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A1
    MOVEA.L A1,A3
    ADDA.L  D1,A3
    MOVEA.L (A3),A6
    ADDA.L  D5,A6
    MOVE.B  252(A6),253(A2)
    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVEA.L (A2),A3
    MOVEA.L A1,A2
    ADDA.L  D1,A2
    MOVEA.L (A2),A6
    ADDA.L  D5,A6
    MOVE.B  301(A6),302(A3)
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    ADDA.L  D1,A1
    MOVEA.L (A1),A0
    ADDA.L  D5,A0
    MOVE.B  350(A0),351(A2)
    LEA     _TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEQ   #0,D0
    MOVE.B  40(A1),D0
    MOVE.L  D0,D1
    ORI.W   #$80,D1
    MOVE.B  D1,40(A1)
    MOVEQ   #1,D4

.next_slot_descending:
    SUBQ.L  #1,D5
    BRA.W   .loop_slots_descending

.next_primary_candidate:
    ADDQ.L  #1,D6
    BRA.W   .loop_primary_candidates

.next_secondary_entry:
    ADDQ.L  #1,D7
    BRA.W   .loop_secondary_entries

;------------------------------------------------------------------------------
; FUNC: ESQDISP_PropagatePrimaryTitleMetadataToSecondary_Return   (Return tail for title-metadata propagation)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D2
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Restores saved registers and returns from title-metadata propagation helper.
; NOTES:
;   Early exits branch here when primary/secondary counts are zero.
;------------------------------------------------------------------------------
ESQDISP_PropagatePrimaryTitleMetadataToSecondary_Return:
    MOVEM.L (A7)+,D2-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_PromoteSecondaryGroupToPrimary   (Promote secondary group entries/titles into primary tables)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A1/A2/A3/A7/D0/D1/D7
; CALLS:
;   _ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache, _ESQPARS_RemoveGroupEntryAndReleaseStrings
; READS:
;   _CTASKS_SecondaryOiWritePendingFlag, _CTASKS_PendingSecondaryOiDiskId, _TEXTDISP_SecondaryGroupPresentFlag, _TEXTDISP_SecondaryGroupEntryCount, _TEXTDISP_PrimaryEntryPtrTable, _TEXTDISP_SecondaryEntryPtrTable, _TEXTDISP_PrimaryTitlePtrTable, _TEXTDISP_SecondaryTitlePtrTable, _TEXTDISP_SecondaryGroupHeaderCode, _TEXTDISP_SecondaryGroupRecordChecksum, _TEXTDISP_SecondaryGroupRecordLength, ff
; WRITES:
;   _CTASKS_PrimaryOiWritePendingFlag, _CTASKS_SecondaryOiWritePendingFlag, _CTASKS_PendingPrimaryOiDiskId, _CTASKS_PendingSecondaryOiDiskId, _TEXTDISP_SecondaryGroupPresentFlag, _TEXTDISP_SecondaryGroupEntryCount, _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryGroupHeaderCode, _TEXTDISP_PrimaryGroupRecordChecksum, _TEXTDISP_PrimaryGroupRecordLength, _TEXTDISP_PrimaryGroupPresentFlag, _TEXTDISP_GroupMutationState, _TEXTDISP_SecondaryGroupRecordChecksum, _TEXTDISP_SecondaryGroupRecordLength, _NEWGRID_RefreshStateFlag
; DESC:
;   Clears existing mode-1 group via parser helper, then when a secondary group is
;   present moves all secondary entry/title pointers into primary tables, copies group
;   header metadata, clears secondary state, and rebuilds the NEWGRID index cache.
; NOTES:
;   Pointer arrays are moved by index and secondary table slots are nulled after transfer.
;------------------------------------------------------------------------------
ESQDISP_PromoteSecondaryGroupToPrimary:
    MOVEM.L D7/A2-A3,-(A7)
    PEA     1.W
    JSR     _ESQPARS_RemoveGroupEntryAndReleaseStrings(PC)

    ADDQ.W  #4,A7
    MOVEQ   #1,D0
    MOVE.L  D0,_NEWGRID_RefreshStateFlag
    MOVEQ   #0,D0
    MOVE.W  D0,_TEXTDISP_GroupMutationState
    CLR.B   _TEXTDISP_PrimaryGroupRecordChecksum
    MOVE.W  D0,_TEXTDISP_PrimaryGroupRecordLength
    MOVE.B  _TEXTDISP_SecondaryGroupPresentFlag,D1
    SUBQ.B  #1,D1
    BNE.W   .sync_task_state_and_reindex

    MOVE.L  D0,D7

.loop_move_secondary_slots:
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.W   D0,D7
    BGE.S   .copy_secondary_group_metadata

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    LEA     _TEXTDISP_SecondaryEntryPtrTable,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    MOVE.L  (A2),(A0)
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A2
    MOVEA.L A2,A3
    ADDA.L  D0,A3
    MOVE.L  (A3),(A0)
    ADDA.L  D0,A1
    SUBA.L  A0,A0
    MOVE.L  A0,(A1)
    ADDA.L  D0,A2
    MOVE.L  A0,(A2)
    ADDQ.W  #1,D7
    BRA.S   .loop_move_secondary_slots

.copy_secondary_group_metadata:
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,_TEXTDISP_PrimaryGroupEntryCount
    MOVE.B  _TEXTDISP_SecondaryGroupRecordChecksum,_TEXTDISP_PrimaryGroupRecordChecksum
    MOVE.B  _TEXTDISP_SecondaryGroupHeaderCode,_TEXTDISP_PrimaryGroupHeaderCode
    MOVE.W  _TEXTDISP_SecondaryGroupRecordLength,_TEXTDISP_PrimaryGroupRecordLength
    MOVE.B  #$1,_TEXTDISP_PrimaryGroupPresentFlag
    MOVEQ   #0,D0
    MOVE.W  D0,_TEXTDISP_SecondaryGroupEntryCount
    MOVEQ   #0,D1
    MOVE.B  D1,_TEXTDISP_SecondaryGroupRecordChecksum
    MOVE.W  D0,_TEXTDISP_SecondaryGroupRecordLength
    MOVE.B  D1,_TEXTDISP_SecondaryGroupPresentFlag
    MOVE.W  #3,_TEXTDISP_GroupMutationState

.sync_task_state_and_reindex:
    MOVE.B  _CTASKS_PendingSecondaryOiDiskId,_CTASKS_PendingPrimaryOiDiskId
    MOVE.B  _CTASKS_SecondaryOiWritePendingFlag,_CTASKS_PrimaryOiWritePendingFlag
    MOVE.B  #$ff,_CTASKS_PendingSecondaryOiDiskId
    CLR.B   _CTASKS_SecondaryOiWritePendingFlag
    JSR     _ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache(PC)

    MOVEM.L (A7)+,D7/A2-A3
    RTS

;!======