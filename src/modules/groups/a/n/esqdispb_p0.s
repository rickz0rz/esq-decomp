    XDEF    ESQDISP_FillProgramInfoHeaderFields
    XDEF    ESQDISP_ParseProgramInfoCommandRecord
    XDEF    ESQDISP_TestEntryGridEligibility
    XDEF    _ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages
    XDEF    _ESQDISP_JMPTBL_GRAPHICS_AllocRaster
    XDEF    ESQDISP_FillProgramInfoHeaderFields_Return
    XDEF    ESQDISP_ParseProgramInfoCommandRecord_Return
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