    XDEF    _LADFUNC_RepackEntryTextAndAttrBuffers
    XDEF    LADFUNC_RepackEntryTextAndAttrBuffers_Return


;------------------------------------------------------------------------------
; FUNC: _LADFUNC_RepackEntryTextAndAttrBuffers   (Routine at _LADFUNC_RepackEntryTextAndAttrBuffers)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
;   stack +7: arg_3 (via 11(A5))
;   stack +8: arg_4 (via 12(A5))
;   stack +47: arg_5 (via 51(A5))
;   stack +48: arg_6 (via 52(A5))
;   stack +87: arg_7 (via 91(A5))
;   stack +96: arg_8 (via 100(A5))
;   stack +100: arg_9 (via 104(A5))
;   stack +104: arg_10 (via 108(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D2/D3/D5/D6/D7
; CALLS:
;   _GROUP_AW_JMPTBL_MEM_Move, _GROUP_AW_JMPTBL_STRING_CopyPadNul, _NEWGRID_JMPTBL_MATH_Mulu32, _NEWGRID_JMPTBL_MEMORY_AllocateMemory, _NEWGRID_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   _Global_STR_LADFUNC_C_24, _Global_STR_LADFUNC_C_25, _Global_STR_LADFUNC_C_26, _Global_STR_LADFUNC_C_27, _ED_TextLimit, MEMF_CLEAR, MEMF_PUBLIC, branch, lab_0ECE, lab_0ED1, lab_0ED4, lab_0ED7, lab_0ED8
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_LADFUNC_RepackEntryTextAndAttrBuffers:
    LINK.W  A5,#-108
    MOVEM.L D2-D3/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEA.L A3,A0

.lab_0EBB:
    TST.B   (A0)+
    BNE.S   .lab_0EBB

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D0
    MOVE.L  D0,-108(A5)
    ADDQ.L  #1,D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     1214.W
    PEA     _Global_STR_LADFUNC_C_24
    JSR     _NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    MOVE.L  -108(A5),-(A7)
    PEA     1215.W
    PEA     _Global_STR_LADFUNC_C_25
    MOVE.L  D0,-6(A5)
    JSR     _NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     28(A7),A7
    MOVE.L  D0,-10(A5)
    TST.L   -6(A5)
    BEQ.W   .lab_0ED8

    TST.L   D0
    BEQ.W   .lab_0ED8

    MOVEA.L A3,A0
    MOVEA.L -6(A5),A1

.lab_0EBC:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .lab_0EBC

    MOVE.L  -108(A5),D0
    MOVEA.L A2,A0
    MOVEA.L -10(A5),A1
    BRA.S   .lab_0EBE

.lab_0EBD:
    MOVE.B  (A0)+,(A1)+

.lab_0EBE:
    SUBQ.L  #1,D0
    BCC.S   .lab_0EBD

    MOVEQ   #0,D0
    MOVE.L  D0,D5
    MOVE.L  D0,-104(A5)

.branch:
    CMP.L   _ED_TextLimit,D5
    BGE.W   .lab_0ED7

    MOVE.L  D5,D0
    MOVEQ   #40,D1
    JSR     _NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVEA.L -6(A5),A0
    ADDA.L  D0,A0
    PEA     40.W
    MOVE.L  A0,-(A7)
    PEA     -51(A5)
    JSR     _GROUP_AW_JMPTBL_STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    CLR.B   -11(A5)
    LEA     -51(A5),A0
    MOVEA.L A0,A1

.lab_0EC0:
    TST.B   (A1)+
    BNE.S   .lab_0EC0

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  D5,D0
    MOVEQ   #40,D1
    JSR     _NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVEA.L -10(A5),A0
    ADDA.L  D0,A0
    MOVE.L  A1,-100(A5)
    MOVE.L  A1,D0
    LEA     -91(A5),A1
    BRA.S   .lab_0EC2

.lab_0EC1:
    MOVE.B  (A0)+,(A1)+

.lab_0EC2:
    SUBQ.L  #1,D0
    BCC.S   .lab_0EC1

    MOVE.L  -100(A5),D0
    MOVEQ   #40,D1
    CMP.L   D1,D0
    BGE.S   .lab_0EC7

    LEA     -51(A5),A0
    ADDA.L  D0,A0
    SUB.L   D0,D1
    MOVEQ   #32,D0
    BRA.S   .lab_0EC4

.lab_0EC3:
    MOVE.B  D0,(A0)+

.lab_0EC4:
    SUBQ.L  #1,D1
    BCC.S   .lab_0EC3

    LEA     -91(A5),A0
    MOVE.L  -100(A5),D0
    ADDA.L  D0,A0
    MOVEQ   #0,D1
    MOVE.B  -92(A5,D0.L),D1
    MOVEQ   #40,D2
    SUB.L   D0,D2
    BRA.S   .lab_0EC6

.lab_0EC5:
    MOVE.B  D1,(A0)+

.lab_0EC6:
    SUBQ.L  #1,D2
    BCC.S   .lab_0EC5

.lab_0EC7:
    MOVE.B  -51(A5),D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BNE.S   .lab_0EC9

    MOVE.B  -12(A5),D0
    CMP.B   D1,D0
    BNE.S   .lab_0EC8

    MOVEQ   #24,D7
    BRA.S   .lab_0ECA

.lab_0EC8:
    MOVEQ   #26,D7
    BRA.S   .lab_0ECA

.lab_0EC9:
    MOVEQ   #25,D7

.lab_0ECA:
    MOVE.B  D7,D0
    EXT.W   D0
    SUBI.W  #$18,D0
    BEQ.S   .lab_0ECB

    SUBQ.W  #1,D0
    BEQ.W   .lab_0ECE

    SUBQ.W  #1,D0
    BEQ.W   .lab_0ED1

    BRA.W   .lab_0ED4

.lab_0ECB:
    MOVE.B  -91(A5),D6
    CLR.L   -100(A5)

.lab_0ECC:
    MOVE.L  -100(A5),D0
    MOVEQ   #20,D1
    CMP.L   D1,D0
    BGE.S   .lab_0ECD

    MOVEQ   #32,D1
    CMP.B   -51(A5,D0.L),D1
    BNE.S   .lab_0ECD

    MOVEQ   #39,D2
    MOVE.L  D2,D3
    SUB.L   D0,D3
    CMP.B   -51(A5,D3.L),D1
    BNE.S   .lab_0ECD

    MOVE.B  -91(A5,D0.L),D1
    CMP.B   D6,D1
    BNE.S   .lab_0ECD

    SUB.L   D0,D2
    MOVE.B  -91(A5,D2.L),D0
    CMP.B   D6,D0
    BNE.S   .lab_0ECD

    ADDQ.L  #1,-100(A5)
    BRA.S   .lab_0ECC

.lab_0ECD:
    MOVE.L  -100(A5),D0
    TST.L   D0
    BLE.W   .lab_0ED4

    MOVEQ   #40,D1
    MOVE.L  D1,D2
    SUB.L   D0,D2
    CLR.B   -51(A5,D2.L)
    LEA     -51(A5),A0
    ADDA.L  D0,A0
    ADD.L   D0,D0
    SUB.L   D0,D1
    ADDQ.L  #1,D1
    MOVE.L  D1,-(A7)
    PEA     -51(A5)
    MOVE.L  A0,-(A7)
    JSR     _GROUP_AW_JMPTBL_MEM_Move(PC)

    LEA     -91(A5),A0
    MOVE.L  -100(A5),D0
    ADDA.L  D0,A0
    ADD.L   D0,D0
    MOVEQ   #40,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    PEA     -91(A5)
    MOVE.L  A0,-(A7)
    JSR     _GROUP_AW_JMPTBL_MEM_Move(PC)

    LEA     20(A7),A7
    BRA.W   .lab_0ED4

.lab_0ECE:
    MOVE.B  -52(A5),D6
    CLR.L   -100(A5)

.lab_0ECF:
    MOVE.L  -100(A5),D0
    MOVEQ   #40,D1
    CMP.L   D1,D0
    BGE.S   .lab_0ED0

    MOVEQ   #39,D1
    SUB.L   D0,D1
    MOVEQ   #32,D0
    CMP.B   -51(A5,D1.L),D0
    BNE.S   .lab_0ED0

    MOVE.B  -91(A5,D1.L),D0
    CMP.B   D6,D0
    BNE.S   .lab_0ED0

    ADDQ.L  #1,-100(A5)
    BRA.S   .lab_0ECF

.lab_0ED0:
    MOVE.L  -100(A5),D0
    TST.L   D0
    BLE.S   .lab_0ED4

    MOVEQ   #40,D1
    SUB.L   D0,D1
    CLR.B   -51(A5,D1.L)
    BRA.S   .lab_0ED4

.lab_0ED1:
    MOVE.B  -91(A5),D6
    CLR.L   -100(A5)

.branch_1:
    MOVE.L  -100(A5),D0
    MOVEQ   #40,D1
    CMP.L   D1,D0
    BGE.S   .lab_0ED3

    MOVEQ   #32,D1
    CMP.B   -51(A5,D0.L),D1
    BNE.S   .lab_0ED3

    MOVE.B  -91(A5,D0.L),D0
    CMP.B   D6,D0
    BNE.S   .lab_0ED3

    ADDQ.L  #1,-100(A5)
    BRA.S   .branch_1

.lab_0ED3:
    MOVE.L  -100(A5),D0
    TST.L   D0
    BLE.S   .lab_0ED4

    LEA     -51(A5),A0
    ADDA.L  D0,A0
    MOVEQ   #40,D1
    SUB.L   D0,D1
    ADDQ.L  #1,D1
    MOVE.L  D1,-(A7)
    PEA     -51(A5)
    MOVE.L  A0,-(A7)
    JSR     _GROUP_AW_JMPTBL_MEM_Move(PC)

    LEA     -91(A5),A0
    MOVE.L  -100(A5),D0
    ADDA.L  D0,A0
    MOVEQ   #40,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    PEA     -91(A5)
    MOVE.L  A0,-(A7)
    JSR     _GROUP_AW_JMPTBL_MEM_Move(PC)

    LEA     20(A7),A7

.lab_0ED4:
    MOVE.L  -104(A5),D0
    MOVE.B  D7,0(A3,D0.L)
    ADDQ.L  #1,-104(A5)
    MOVE.B  D6,0(A2,D0.L)
    CLR.L   -100(A5)

.branch_2:
    MOVE.L  -100(A5),D0
    TST.B   -51(A5,D0.L)
    BEQ.S   .branch_3

    MOVE.L  -104(A5),D1
    MOVE.B  -51(A5,D0.L),0(A3,D1.L)
    ADDQ.L  #1,-104(A5)
    MOVE.B  -91(A5,D0.L),0(A2,D1.L)
    ADDQ.L  #1,-100(A5)
    BRA.S   .branch_2

.branch_3:
    ADDQ.L  #1,D5
    BRA.W   .branch

.lab_0ED7:
    MOVE.L  -104(A5),D0
    CLR.B   0(A3,D0.L)

.lab_0ED8:
    TST.L   -6(A5)
    BEQ.S   .branch_4

    MOVE.L  -108(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -6(A5),-(A7)
    PEA     1322.W
    PEA     _Global_STR_LADFUNC_C_26
    JSR     _NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.branch_4:
    TST.L   -10(A5)
    BEQ.S   LADFUNC_RepackEntryTextAndAttrBuffers_Return

    MOVE.L  -108(A5),-(A7)
    MOVE.L  -10(A5),-(A7)
    PEA     1324.W
    PEA     _Global_STR_LADFUNC_C_27
    JSR     _NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

;------------------------------------------------------------------------------
; FUNC: LADFUNC_RepackEntryTextAndAttrBuffers_Return   (Routine at LADFUNC_RepackEntryTextAndAttrBuffers_Return)
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
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
LADFUNC_RepackEntryTextAndAttrBuffers_Return:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======