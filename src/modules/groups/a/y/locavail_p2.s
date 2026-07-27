    XDEF    LOCAVAIL_MapFilterTokenCharToClass
    XDEF    LOCAVAIL_ParseFilterStateFromBuffer
    XDEF    LOCAVAIL_MapFilterTokenCharToClass_Return
    XDEF    LOCAVAIL_ParseFilterStateFromBuffer_Return


;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_ParseFilterStateFromBuffer   (Parse serialized filter-state buffer)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +14: arg_3 (via 18(A5))
;   stack +18: arg_4 (via 22(A5))
;   stack +20: arg_5 (via 24(A5))
;   stack +24: arg_6 (via 28(A5))
;   stack +47: arg_7 (via 51(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D5/D6/D7
; CALLS:
;   _GROUP_AS_JMPTBL_STR_FindCharPtr, _LOCAVAIL_ResetFilterStateStruct, _LOCAVAIL_CopyFilterStateStructRetainRefs, LOCAVAIL_AllocNodeArraysForState, _LOCAVAIL_FreeResourceChain, NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, _NEWGRID_JMPTBL_MATH_Mulu32, _NEWGRID_JMPTBL_MEMORY_AllocateMemory
; READS:
;   Global_STR_LOCAVAIL_C_6, LOCAVAIL_TAG_FV, _WDISP_CharClassTable, MEMF_CLEAR, MEMF_PUBLIC, branch, branch_14, branch_15, branch_16, branch_17, branch_5, e11, lab_0F2E, lab_0F2F, lab_0F31, lab_0F32, lab_0F33
; WRITES:
;   (none observed)
; DESC:
;   Parses filter-state header/tags and node payloads from a serialized buffer,
;   allocating/resetting state arrays as needed and restoring filter resources.
; NOTES:
;   Uses FV-tag gating and per-node numeric parsing via ReadSignedLong helper.
;------------------------------------------------------------------------------
LOCAVAIL_ParseFilterStateFromBuffer:
    LINK.W  A5,#-52
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEQ   #1,D5
    PEA     -24(A5)
    BSR.W   _LOCAVAIL_ResetFilterStateStruct

    ADDQ.W  #4,A7
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-24(A5)
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-51(A5)
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   .lab_0F17

    MOVE.B  -51(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .lab_0F18

.lab_0F17:
    MOVE.B  -51(A5),D0
    EXT.W   D0
    EXT.L   D0

.lab_0F18:
    MOVE.B  D0,-51(A5)
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     LOCAVAIL_TAG_FV
    JSR     _GROUP_AS_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.W   .lab_0F32

    MOVE.B  -51(A5),D0
    MOVE.B  D0,-18(A5)
    MOVEQ   #0,D7

.lab_0F19:
    MOVEQ   #2,D0
    CMP.L   D0,D7
    BGE.S   .lab_0F1A

    MOVEA.L D7,A0
    ADDQ.L  #1,D7
    MOVE.L  A0,D0
    MOVE.B  (A3)+,-51(A5,D0.L)
    BRA.S   .lab_0F19

.lab_0F1A:
    CLR.B   -51(A5,D7.L)
    PEA     -51(A5)
    JSR     NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    MOVE.L  D0,-22(A5)
    PEA     -24(A5)
    BSR.W   LOCAVAIL_AllocNodeArraysForState

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.W   .lab_0F31

    MOVEQ   #0,D7

.branch:
    TST.L   D5
    BEQ.W   .lab_0F33

    CMP.L   -22(A5),D7
    BGE.W   .lab_0F33

    MOVE.B  (A3)+,D0
    MOVEQ   #18,D1
    CMP.B   D1,D0
    BNE.W   .lab_0F2F

    MOVE.L  D7,D0
    MOVEQ   #10,D1
    JSR     _NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVEA.L -4(A5),A0
    ADDA.L  D0,A0
    MOVEQ   #0,D6
    MOVE.L  A0,-28(A5)

.lab_0F1C:
    MOVEQ   #2,D0
    CMP.L   D0,D6
    BGE.S   .lab_0F1D

    MOVEA.L D6,A0
    ADDQ.L  #1,D6
    MOVE.L  A0,D0
    MOVE.B  (A3)+,-51(A5,D0.L)
    BRA.S   .lab_0F1C

.lab_0F1D:
    CLR.B   -51(A5,D6.L)
    PEA     -51(A5)
    JSR     NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVEA.L -28(A5),A0
    MOVE.B  D0,(A0)
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.W   .lab_0F2E

    MOVEQ   #100,D1
    CMP.B   D1,D0
    BCC.W   .lab_0F2E

    MOVEQ   #0,D6

.branch_1:
    MOVEQ   #4,D0
    CMP.L   D0,D6
    BGE.S   .branch_2

    MOVEA.L D6,A0
    ADDQ.L  #1,D6
    MOVE.L  A0,D0
    MOVE.B  (A3)+,-51(A5,D0.L)
    BRA.S   .branch_1

.branch_2:
    CLR.B   -51(A5,D6.L)
    PEA     -51(A5)
    JSR     NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVEA.L -28(A5),A0
    MOVE.W  D0,2(A0)
    BLE.W   .branch_16

    CMPI.W  #$e11,D0
    BGE.W   .branch_16

    MOVEQ   #0,D6

.branch_3:
    MOVEQ   #2,D0
    CMP.L   D0,D6
    BGE.S   .branch_4

    MOVEA.L D6,A0
    ADDQ.L  #1,D6
    MOVE.L  A0,D0
    MOVE.B  (A3)+,-51(A5,D0.L)
    BRA.S   .branch_3

.branch_4:
    CLR.B   -51(A5,D6.L)
    PEA     -51(A5)
    JSR     NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVEA.L -28(A5),A0
    MOVE.W  D0,4(A0)
    TST.W   D0
    BLE.W   .branch_15

    MOVEQ   #100,D1
    CMP.W   D1,D0
    BGE.W   .branch_15

    EXT.L   D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     341.W
    PEA     Global_STR_LOCAVAIL_C_6
    JSR     _NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L -28(A5),A0
    MOVE.L  D0,6(A0)
    BEQ.W   .branch_14

    MOVEQ   #0,D6

.branch_5:
    TST.L   D5
    BEQ.W   .branch_17

    MOVEA.L -28(A5),A0
    MOVE.W  4(A0),D0
    EXT.L   D0
    CMP.L   D0,D6
    BGE.W   .branch_17

    MOVE.B  (A3)+,D0
    MOVE.B  D0,-51(A5)
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   .branch_6

    MOVE.B  -51(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .branch_7

.branch_6:
    MOVE.B  -51(A5),D0
    EXT.W   D0
    EXT.L   D0

.branch_7:
    MOVEQ   #48,D1
    SUB.L   D1,D0
    BEQ.S   .branch_11

    MOVEQ   #23,D1
    SUB.L   D1,D0
    BEQ.S   .branch_8

    SUBQ.L  #2,D0
    BEQ.S   .branch_10

    SUBQ.L  #3,D0
    BEQ.S   .branch_11

    SUBQ.L  #8,D0
    BEQ.S   .branch_9

    SUBQ.L  #1,D0
    BEQ.S   .branch_11

    SUBQ.L  #1,D0
    BNE.S   .branch_12

    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  #$1,(A0)
    BRA.S   .branch_13

.branch_8:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  #$2,(A0)
    BRA.S   .branch_13

.branch_9:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  #$3,(A0)
    BRA.S   .branch_13

.branch_10:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    MOVE.B  #$4,(A0)
    BRA.S   .branch_13

.branch_11:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    CLR.B   (A0)
    BRA.S   .branch_13

.branch_12:
    MOVEA.L -28(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D6,A0
    CLR.B   (A0)
    MOVEQ   #0,D5

.branch_13:
    ADDQ.L  #1,D6
    BRA.W   .branch_5

.branch_14:
    MOVEQ   #0,D5
    BRA.S   .branch_17

.branch_15:
    MOVEQ   #0,D5
    BRA.S   .branch_17

.branch_16:
    MOVEQ   #0,D5
    BRA.S   .branch_17

.lab_0F2E:
    MOVEQ   #0,D5
    BRA.S   .branch_17

.lab_0F2F:
    MOVEQ   #0,D5

.branch_17:
    ADDQ.L  #1,D7
    BRA.W   .branch

.lab_0F31:
    TST.L   -22(A5)
    BEQ.S   .lab_0F33

    MOVEQ   #0,D5
    BRA.S   .lab_0F33

.lab_0F32:
    MOVEQ   #0,D5

.lab_0F33:
    TST.L   D5
    BEQ.S   .branch_18

    MOVE.L  A2,-(A7)
    BSR.W   _LOCAVAIL_FreeResourceChain

    PEA     -24(A5)
    MOVE.L  A2,-(A7)
    BSR.W   _LOCAVAIL_CopyFilterStateStructRetainRefs

    LEA     12(A7),A7
    BRA.S   LOCAVAIL_ParseFilterStateFromBuffer_Return

.branch_18:
    PEA     -24(A5)
    BSR.W   _LOCAVAIL_FreeResourceChain

    ADDQ.W  #4,A7

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_ParseFilterStateFromBuffer_Return   (Return parse success/failure and unwind frame)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D5
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Returns parser success flag (D5) and restores saved registers/frame.
; NOTES:
;   Shared return target for both success and cleanup-failure paths.
;------------------------------------------------------------------------------
LOCAVAIL_ParseFilterStateFromBuffer_Return:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_MapFilterTokenCharToClass   (Map token character to filter-class index)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A7/D0/D1/D6/D7
; CALLS:
;   (none)
; READS:
;   _WDISP_CharClassTable
; WRITES:
;   (none observed)
; DESC:
;   Converts numeric/alphabetic token chars into compact class indices used by
;   filter parsing logic; returns 0 for unsupported characters.
; NOTES:
;   Digits map via `'0'` base; alphabetic classes map via `'7'`-relative base.
;------------------------------------------------------------------------------
LOCAVAIL_MapFilterTokenCharToClass:
    MOVEM.L D6-D7,-(A7)
    MOVE.B  15(A7),D7
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   .class_is_not_digit

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D6
    MOVEQ   #48,D1
    SUB.L   D1,D6
    BRA.S   LOCAVAIL_MapFilterTokenCharToClass_Return

.class_is_not_digit:
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #3,D0
    AND.B   (A1),D0
    TST.B   D0
    BEQ.S   .class_unknown

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   .skip_uppercase_fold

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .class_alpha_ready

.skip_uppercase_fold:
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0

.class_alpha_ready:
    MOVE.L  D0,D6
    MOVEQ   #55,D1
    SUB.L   D1,D6
    BRA.S   LOCAVAIL_MapFilterTokenCharToClass_Return

.class_unknown:
    MOVEQ   #0,D6

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_MapFilterTokenCharToClass_Return   (Return token character class index)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A7/D0/D1/D6/D7
; CALLS:
;   _NEWGRID_JMPTBL_MATH_Mulu32
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Returns computed class index from D6.
; NOTES:
;   Class 0 indicates unrecognized token character.
;------------------------------------------------------------------------------
LOCAVAIL_MapFilterTokenCharToClass_Return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7
    RTS

;!======