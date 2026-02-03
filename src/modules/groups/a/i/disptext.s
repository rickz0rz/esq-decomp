;!======
;------------------------------------------------------------------------------
; FUNC: LAB_056A   (Append to display text buffer??)
; ARGS:
;   stack +8: A3 = string pointer
; RET:
;   D0: boolean success (0/-1)
; CLOBBERS:
;   D0-D1/D7/A0-A1/A6 ??
; CALLS:
;   _LVOAvailMem, GROUP_AG_JMPTBL_MEMORY_AllocateMemory, GROUP_AI_JMPTBL_UNKNOWN6_AppendDataAtNull, GROUP_AE_JMPTBL_LAB_0B44
; READS:
;   LAB_21D3
; WRITES:
;   LAB_21D3
; DESC:
;   Appends a string to the global display-text buffer, reallocating if needed.
; NOTES:
;   Booleanize pattern: SNE/NEG/EXT.
;------------------------------------------------------------------------------
LAB_056A:
    LINK.W  A5,#-8
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    CLR.L   -8(A5)
    TST.L   LAB_21D3
    BEQ.W   LAB_056F

    MOVEA.L LAB_21D3,A0

LAB_056B:
    TST.B   (A0)+
    BNE.S   LAB_056B

    SUBQ.L  #1,A0
    SUBA.L  LAB_21D3,A0
    MOVEA.L A3,A1

LAB_056C:
    TST.B   (A1)+
    BNE.S   LAB_056C

    SUBQ.L  #1,A1
    SUBA.L  A3,A1
    MOVE.L  A0,D0
    MOVE.L  A1,D1
    ADD.L   D1,D0
    MOVE.L  D0,D7
    ADDQ.L  #1,D7
    MOVEQ   #1,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAvailMem(A6)

    CMPI.L  #$2710,D0
    BLE.S   LAB_056D

    PEA     (MEMF_PUBLIC).W
    MOVE.L  D7,-(A7)
    PEA     127.W
    PEA     GLOB_STR_DISPTEXT_C_1
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)

LAB_056D:
    TST.L   -8(A5)
    BEQ.S   LAB_0570

    MOVEA.L LAB_21D3,A0
    MOVEA.L -8(A5),A1

LAB_056E:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_056E

    MOVE.L  A3,-(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     GROUP_AI_JMPTBL_UNKNOWN6_AppendDataAtNull(PC)

    MOVE.L  LAB_21D3,(A7)
    CLR.L   -(A7)
    JSR     GROUP_AE_JMPTBL_LAB_0B44(PC)

    LEA     12(A7),A7
    MOVEA.L -8(A5),A0
    MOVE.L  A0,LAB_21D3
    BRA.S   LAB_0570

LAB_056F:
    MOVE.L  LAB_21D3,-(A7)
    MOVE.L  A3,-(A7)
    JSR     GROUP_AE_JMPTBL_LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_21D3

LAB_0570:
    TST.L   LAB_21D3
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_0571   (Format text into line buffer with width constraint??)
; ARGS:
;   stack +8: A3 = font/rastport??
;   stack +12: A2 = source string
;   stack +16: A0 = output buffer
;   stack +20: D7 = max width
; RET:
;   D0: updated A2 (next source position)
; CLOBBERS:
;   D0-D7/A0-A3/A6 ??
; CALLS:
;   _LVOTextLength, GROUP_AI_JMPTBL_UNKNOWN6_AppendDataAtNull, LAB_05C4, LAB_05C6
; READS:
;   LAB_1CEA..LAB_1CEC, LAB_21D6/21D9/21DA/21DC
; WRITES:
;   output buffer, LAB_21DC
; DESC:
;   Builds a line from the source string, inserting separators and trimming to fit.
; NOTES:
;   Uses 0x13/0x12 separators (see data tables).
;------------------------------------------------------------------------------
LAB_0571:
    LINK.W  A5,#-76
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  20(A5),D7
    MOVEA.L A3,A1
    LEA     LAB_1CEA,A0
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVEA.L 16(A5),A0
    CLR.B   (A0)
    MOVE.L  D0,-16(A5)

LAB_0572:
    MOVE.L  A2,D0
    BEQ.W   LAB_057D

    TST.B   (A2)
    BEQ.W   LAB_057D

    CMP.L   -16(A5),D7
    BLE.W   LAB_057D

    MOVEA.L 16(A5),A0
    TST.B   (A0)
    BEQ.S   LAB_0573

    PEA     LAB_1CEB
    MOVE.L  A0,-(A7)
    JSR     GROUP_AI_JMPTBL_UNKNOWN6_AppendDataAtNull(PC)

    ADDQ.W  #8,A7
    SUB.L   -16(A5),D7

LAB_0573:
    MOVE.L  A2,-(A7)
    JSR     LAB_05C4(PC)

    MOVEA.L D0,A2
    MOVE.L  A2,-20(A5)
    PEA     LAB_1CEC
    PEA     50.W
    PEA     -73(A5)
    MOVE.L  A2,-(A7)
    JSR     LAB_05C6(PC)

    LEA     20(A7),A7
    MOVEA.L D0,A2
    LEA     -73(A5),A0
    MOVEA.L A0,A1

LAB_0574:
    TST.B   (A1)+
    BNE.S   LAB_0574

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D6
    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D5
    MOVEA.L -20(A5),A0
    MOVE.B  (A0),D0
    MOVEQ   #19,D1
    CMP.B   D1,D0
    BNE.S   LAB_0575

    ADDQ.L  #8,D5

LAB_0575:
    CMP.L   D7,D5
    BLE.S   LAB_057C

    MOVE.W  LAB_21D6,D2
    MOVEQ   #2,D3
    CMP.W   D3,D2
    BCC.S   LAB_0576

    MOVE.L  LAB_21DA,D2
    BRA.S   LAB_0577

LAB_0576:
    MOVEQ   #0,D2

LAB_0577:
    MOVE.L  LAB_21D9,D3
    SUB.L   D2,D3
    MOVE.L  D3,D4
    CMP.L   D4,D5
    BLE.S   LAB_057B

    CMP.B   D1,D0
    BEQ.W   LAB_0572

LAB_0578:
    CMP.L   D7,D5
    BLE.S   LAB_0579

    TST.L   D6
    BLE.S   LAB_0579

    SUBQ.L  #1,D6
    MOVEA.L A3,A1
    MOVE.L  D6,D0
    LEA     -73(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D5
    BRA.S   LAB_0578

LAB_0579:
    TST.L   D6
    BLE.S   LAB_057A

    CLR.B   -73(A5,D6.L)
    PEA     -73(A5)
    MOVE.L  16(A5),-(A7)
    JSR     GROUP_AI_JMPTBL_UNKNOWN6_AppendDataAtNull(PC)

    ADDQ.W  #8,A7

LAB_057A:
    MOVEA.L -20(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D6,A1
    MOVEA.L A1,A2
    MOVEQ   #0,D7
    BRA.W   LAB_0572

LAB_057B:
    MOVEA.L -20(A5),A2
    MOVEQ   #0,D7
    BRA.W   LAB_0572

LAB_057C:
    PEA     -73(A5)
    MOVE.L  16(A5),-(A7)
    JSR     GROUP_AI_JMPTBL_UNKNOWN6_AppendDataAtNull(PC)

    ADDQ.W  #8,A7
    SUB.L   D5,D7
    MOVEQ   #19,D1
    MOVEA.L -20(A5),A0
    CMP.B   (A0),D1
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.W  LAB_21DC,D1
    EXT.L   D1
    OR.L    D0,D1
    MOVE.W  D1,LAB_21DC
    BRA.W   LAB_0572

LAB_057D:
    TST.B   (A2)
    BNE.S   LAB_057E

    SUBA.L  A2,A2

LAB_057E:
    MOVE.L  A2,D0
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_057F   (Build display line pointer table??)
; ARGS:
;   stack +8: D7 = ?? (nonzero enables table build)
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   none
; READS:
;   LAB_21D3/21D4/21D6/21D7/21DB
; WRITES:
;   LAB_21D4, LAB_21DB
; DESC:
;   Builds per-line pointer table based on offsets when not locked.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_057F:
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVE.L  24(A7),D7
    TST.L   LAB_21DB
    BNE.S   LAB_0584

    MOVE.L  LAB_21D3,LAB_21D4
    MOVEQ   #0,D0
    MOVE.W  LAB_21D6,D0
    ADD.L   D0,D0
    LEA     LAB_21D7,A0
    ADDA.L  D0,A0
    TST.W   (A0)
    BEQ.S   LAB_0580

    MOVEQ   #1,D0
    BRA.S   LAB_0581

LAB_0580:
    MOVEQ   #0,D0

LAB_0581:
    MOVEQ   #0,D1
    MOVE.W  LAB_21D6,D1
    ADD.L   D0,D1
    MOVE.L  D1,D5
    MOVEQ   #1,D6

LAB_0582:
    CMP.L   D5,D6
    BGE.S   LAB_0583

    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     LAB_21D4,A0
    ADDA.L  D0,A0
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     LAB_21D3,A1
    ADDA.L  D0,A1
    MOVE.L  D6,D0
    ADD.L   D0,D0
    LEA     LAB_21D6,A2
    ADDA.L  D0,A2
    MOVEA.L (A1),A3
    MOVEQ   #0,D0
    MOVE.W  (A2),D0
    ADDA.L  D0,A3
    MOVE.L  A3,(A0)
    ADDQ.L  #1,D6
    BRA.S   LAB_0582

LAB_0583:
    MOVE.L  D7,LAB_21DB

LAB_0584:
    MOVEM.L (A7)+,D5-D7/A2-A3
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_0585   (Finalize pending line table??)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D1/A0 ??
; CALLS:
;   LAB_057F
; READS:
;   LAB_21DB, LAB_21D6, LAB_21D7
; WRITES:
;   LAB_21D5, LAB_21D6
; DESC:
;   Ensures line table state is current and clears LAB_21D6 when needed.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_0585:
    TST.L   LAB_21DB
    BNE.S   LAB_0587

    MOVE.W  LAB_21D6,D0
    MOVE.W  D0,LAB_21D5
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ADD.L   D1,D1
    LEA     LAB_21D7,A0
    ADDA.L  D1,A0
    TST.W   (A0)
    BEQ.S   LAB_0586

    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_21D5

LAB_0586:
    PEA     1.W
    BSR.W   LAB_057F

    ADDQ.W  #4,A7
    CLR.W   LAB_21D6

LAB_0587:
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_0588   (Initialize disptext buffers)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0/A7 ??
; CALLS:
;   LAB_0563, GROUP_AG_JMPTBL_MEMORY_AllocateMemory
; READS:
;   LAB_1CED
; WRITES:
;   LAB_21D3, LAB_1CED, GLOB_REF_1000_BYTES_ALLOCATED_1/2
; DESC:
;   Allocates working buffers for display text if initialization flag set.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_0588:
    TST.L   LAB_1CED
    BEQ.S   .return

    CLR.L   LAB_21D3
    BSR.W   LAB_0563

    CLR.L   LAB_1CED

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     1000.W
    PEA     320.W
    PEA     GLOB_STR_DISPTEXT_C_2
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    PEA     1000.W
    PEA     321.W
    PEA     GLOB_STR_DISPTEXT_C_3
    MOVE.L  D0,GLOB_REF_1000_BYTES_ALLOCATED_1
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     28(A7),A7
    MOVE.L  D0,GLOB_REF_1000_BYTES_ALLOCATED_2

.return:
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_058A   (Free disptext buffers)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   D0/A7 ??
; CALLS:
;   LAB_0566, GROUP_AG_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   GLOB_REF_1000_BYTES_ALLOCATED_1/2
; WRITES:
;   GLOB_REF_1000_BYTES_ALLOCATED_1/2
; DESC:
;   Releases the 1000-byte buffers used by display text.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_058A:
    BSR.W   LAB_0566

    TST.L   GLOB_REF_1000_BYTES_ALLOCATED_1
    BEQ.S   .freeSecondBlock

    PEA     1000.W
    MOVE.L  GLOB_REF_1000_BYTES_ALLOCATED_1,-(A7)
    PEA     338.W
    PEA     GLOB_STR_DISPTEXT_C_4
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    CLR.L   GLOB_REF_1000_BYTES_ALLOCATED_1

.freeSecondBlock:
    TST.L   GLOB_REF_1000_BYTES_ALLOCATED_2
    BEQ.S   .return

    PEA     1000.W
    MOVE.L  GLOB_REF_1000_BYTES_ALLOCATED_2,-(A7)
    PEA     343.W
    PEA     GLOB_STR_DISPTEXT_C_5
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    CLR.L   GLOB_REF_1000_BYTES_ALLOCATED_2

.return:
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_058D   (Set display layout params??)
; ARGS:
;   stack +8: D7 = width?? (1..624)
;   stack +12: D6 = line count?? (1..20)
;   stack +16: D5 = ?? (passed to LAB_0567)
; RET:
;   D0: 1 if applied, 0 if clamped/no change
; CLOBBERS:
;   D0-D7 ??
; CALLS:
;   LAB_0566, LAB_0567
; READS:
;   LAB_21D9, LAB_21D5
; WRITES:
;   LAB_21D9, LAB_21D5
; DESC:
;   Updates layout parameters and returns whether the requested values matched.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_058D:
    MOVEM.L D5-D7,-(A7)
    MOVE.L  16(A7),D7
    MOVE.L  20(A7),D6
    MOVE.L  24(A7),D5
    BSR.W   LAB_0566

    TST.L   D7
    BMI.S   LAB_058E

    CMPI.L  #624,D7
    BGT.S   LAB_058E

    MOVE.L  D7,LAB_21D9

LAB_058E:
    TST.L   D6
    BLE.S   LAB_058F

    MOVEQ   #20,D0
    CMP.L   D0,D6
    BGT.S   LAB_058F

    MOVE.L  D6,D0
    MOVE.W  D0,LAB_21D5

LAB_058F:
    MOVE.L  D5,-(A7)
    BSR.W   LAB_0567

    ADDQ.W  #4,A7
    MOVE.L  LAB_21D9,D0
    CMP.L   D7,D0
    BNE.S   LAB_0590

    MOVEQ   #0,D0
    MOVE.W  LAB_21D5,D0
    CMP.L   D6,D0
    BNE.S   LAB_0590

    MOVEQ   #1,D0
    BRA.S   LAB_0591

LAB_0590:
    MOVEQ   #0,D0

LAB_0591:
    MOVEM.L (A7)+,D5-D7
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_0592   (Compute padding widths??)
; ARGS:
;   stack +8: A3 = font/rastport??
;   stack +12: D7 = ?? (width)
;   stack +16: D6 = ?? (width)
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D7/A0-A3/A6 ??
; CALLS:
;   LAB_05C0, _LVOTextLength
; READS:
;   LAB_21DA
; WRITES:
;   LAB_21DA
; DESC:
;   Computes combined text lengths for two optional markers and stores in LAB_21DA.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_0592:
    LINK.W  A5,#-12
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    PEA     -4(A5)
    PEA     -3(A5)
    PEA     -2(A5)
    PEA     -1(A5)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    JSR     LAB_05C0(PC)

    LEA     24(A7),A7
    TST.B   -1(A5)
    BEQ.S   LAB_0593

    MOVEA.L A3,A1
    LEA     -1(A5),A0
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    BRA.S   LAB_0594

LAB_0593:
    MOVEQ   #0,D0

LAB_0594:
    MOVE.L  D0,D5
    TST.B   -3(A5)
    BEQ.S   LAB_0595

    MOVEA.L A3,A1
    LEA     -3(A5),A0
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    BRA.S   LAB_0596

LAB_0595:
    MOVEQ   #0,D0

LAB_0596:
    MOVE.L  D0,D4
    MOVE.L  D5,D0
    ADD.L   D4,D0
    MOVE.L  D0,LAB_21DA
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_0597   (Layout source text into lines)
; ARGS:
;   stack +8: A3 = font/rastport??
;   stack +12: A2 = source string
; RET:
;   D0: boolean success (0/-1)
; CLOBBERS:
;   D0-D7/A0-A3/A6 ??
; CALLS:
;   LAB_0571, _LVOTextLength
; READS:
;   LAB_21D3/21D4/21D5/21D6/21D7/21D9/21DA/21DB
; WRITES:
;   LAB_21D6
; DESC:
;   Iterates over lines, measuring and formatting text into the line buffer.
; NOTES:
;   Uses line offset tables LAB_21D4/LAB_21D7.
;------------------------------------------------------------------------------
LAB_0597:
    LINK.W  A5,#-276
    MOVEM.L D2/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEQ   #0,D7
    TST.L   LAB_21DB
    BNE.W   LAB_059E

    MOVE.W  LAB_21D6,D0
    MOVE.W  LAB_21D5,D1
    CMP.W   D1,D0
    BCC.W   LAB_059E

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ADD.L   D1,D1
    LEA     LAB_21D7,A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    TST.W   (A1)
    BEQ.S   LAB_0598

    MOVEQ   #0,D2
    MOVE.W  D0,D2
    ASL.L   #2,D2
    LEA     LAB_21D4,A1
    ADDA.L  D2,A1
    ADDA.L  D1,A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    MOVE.L  A1,28(A7)
    MOVEA.L A3,A1
    MOVEA.L 28(A7),A0
    MOVEA.L (A0),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  LAB_21D9,D1
    MOVE.L  D1,D2
    SUB.L   D0,D2
    MOVE.L  D2,D6
    BRA.S   LAB_0599

LAB_0598:
    MOVE.L  LAB_21D9,D6

LAB_0599:
    MOVE.W  LAB_21D6,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCC.S   LAB_059A

    SUB.L   LAB_21DA,D6

LAB_059A:
    MOVEQ   #0,D2
    MOVE.W  D0,D2
    ADD.L   D2,D2
    LEA     LAB_21D7,A0
    ADDA.L  D2,A0
    TST.W   (A0)
    BEQ.S   LAB_059C

    MOVEA.L A3,A1
    LEA     LAB_1CF2,A0
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D5
    CMP.L   D5,D6
    BLE.S   LAB_059B

    SUB.L   D5,D6
    BRA.S   LAB_059C

LAB_059B:
    ADDQ.L  #1,D7
    MOVEQ   #0,D0
    MOVE.W  LAB_21D6,D0
    ADD.L   D7,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_21D5,D1
    CMP.L   D1,D0
    BGE.S   LAB_059C

    MOVE.L  LAB_21D9,D6

LAB_059C:
    MOVE.L  A2,D0
    BEQ.S   LAB_059E

    TST.B   (A2)
    BEQ.S   LAB_059E

    MOVEQ   #0,D0
    MOVE.W  LAB_21D6,D0
    ADD.L   D7,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_21D5,D1
    CMP.L   D1,D0
    BGE.S   LAB_059E

    MOVE.L  D6,-(A7)
    PEA     -268(A5)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0571

    LEA     16(A7),A7
    MOVEA.L D0,A2
    MOVE.L  LAB_21D9,D6
    MOVE.W  LAB_21D6,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCC.S   LAB_059D

    SUB.L   LAB_21DA,D6

LAB_059D:
    MOVE.L  A2,D0
    BEQ.S   LAB_059C

    ADDQ.L  #1,D7
    BRA.S   LAB_059C

LAB_059E:
    MOVE.L  A2,D1
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVEM.L (A7)+,D2/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_059F   (Layout and append into output buffer)
; ARGS:
;   stack +8: A3 = font/rastport??
;   stack +12: A2 = source string
; RET:
;   D0: boolean success (0/-1)
; CLOBBERS:
;   D0-D7/A0-A3/A6 ??
; CALLS:
;   LAB_0571, LAB_0567, GROUP_AI_JMPTBL_UNKNOWN6_AppendDataAtNull, _LVOTextLength
; READS:
;   LAB_21D3/21D4/21D5/21D6/21D7/21D8/21D9/21DA/21DB
; WRITES:
;   LAB_21D6, LAB_21D7, GLOB_REF_1000_BYTES_ALLOCATED_2
; DESC:
;   Builds line segments into the scratch buffer and appends to global text.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_059F:
    LINK.W  A5,#-276
    MOVEM.L D2/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    TST.L   LAB_21DB
    BNE.W   LAB_05A9

    MOVE.W  LAB_21D6,D0
    MOVE.W  LAB_21D5,D1
    CMP.W   D1,D0
    BCC.W   LAB_05A9

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ADD.L   D1,D1
    LEA     LAB_21D7,A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    TST.W   (A1)
    BEQ.S   LAB_05A0

    MOVEQ   #0,D2
    MOVE.W  D0,D2
    ASL.L   #2,D2
    LEA     LAB_21D4,A1
    ADDA.L  D2,A1
    ADDA.L  D1,A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    MOVE.L  A1,28(A7)
    MOVEA.L A3,A1
    MOVEA.L 28(A7),A0
    MOVEA.L (A0),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  LAB_21D9,D1
    MOVE.L  D1,D2
    SUB.L   D0,D2
    MOVE.L  D2,D7
    BRA.S   LAB_05A1

LAB_05A0:
    MOVE.L  LAB_21D9,D7

LAB_05A1:
    MOVE.W  LAB_21D6,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCC.S   LAB_05A2

    SUB.L   LAB_21DA,D7

LAB_05A2:
    MOVEA.L GLOB_REF_1000_BYTES_ALLOCATED_2,A0
    CLR.B   (A0)
    MOVEQ   #0,D0
    MOVE.W  LAB_21D6,D0
    ADD.L   D0,D0
    LEA     LAB_21D7,A1
    ADDA.L  D0,A1
    TST.W   (A1)
    BEQ.S   LAB_05A5

    MOVEA.L A3,A1
    LEA     LAB_1CF3,A0
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D6
    CMP.L   D6,D7
    BLE.S   LAB_05A4

    LEA     LAB_1CF4,A0
    MOVEA.L GLOB_REF_1000_BYTES_ALLOCATED_2,A1

LAB_05A3:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_05A3

    SUB.L   D6,D7
    MOVEQ   #0,D0
    MOVE.W  LAB_21D6,D0
    ADD.L   D0,D0
    LEA     LAB_21D7,A0
    ADDA.L  D0,A0
    ADDQ.W  #1,(A0)
    BRA.S   LAB_05A5

LAB_05A4:
    MOVEQ   #0,D0
    MOVE.W  LAB_21D6,D0
    ASL.L   #2,D0
    LEA     LAB_21D8,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    BSR.W   LAB_0567

    ADDQ.W  #4,A7
    MOVE.W  LAB_21D6,D0
    MOVE.W  LAB_21D5,D1
    CMP.W   D1,D0
    BCC.S   LAB_05A5

    MOVE.L  LAB_21D9,D7

LAB_05A5:
    MOVE.L  A2,D0
    BEQ.W   LAB_05A8

    TST.B   (A2)
    BEQ.W   LAB_05A8

    MOVE.W  LAB_21D6,D0
    MOVE.W  LAB_21D5,D1
    CMP.W   D1,D0
    BCC.W   LAB_05A8

    MOVE.L  D7,-(A7)
    PEA     -268(A5)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0571

    MOVEA.L D0,A2
    LEA     -268(A5),A0
    MOVEA.L A0,A1

LAB_05A6:
    TST.B   (A1)+
    BNE.S   LAB_05A6

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D5
    MOVE.L  A0,(A7)
    MOVE.L  GLOB_REF_1000_BYTES_ALLOCATED_2,-(A7)
    JSR     GROUP_AI_JMPTBL_UNKNOWN6_AppendDataAtNull(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D0
    MOVE.W  LAB_21D6,D0
    ADD.L   D0,D0
    LEA     LAB_21D7,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    MOVE.L  D0,D1
    ADD.L   D5,D1
    MOVE.W  D1,(A0)
    MOVE.L  LAB_21D9,D7
    MOVE.W  LAB_21D6,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCC.S   LAB_05A7

    SUB.L   LAB_21DA,D7

LAB_05A7:
    MOVE.L  A2,D1
    BEQ.W   LAB_05A5

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ASL.L   #2,D1
    LEA     LAB_21D8,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-(A7)
    BSR.W   LAB_0567

    ADDQ.W  #4,A7
    BRA.W   LAB_05A5

LAB_05A8:
    MOVEA.L GLOB_REF_1000_BYTES_ALLOCATED_2,A0
    TST.B   (A0)
    BEQ.S   LAB_05A9

    MOVE.L  A0,-(A7)
    BSR.W   LAB_056A

    CLR.L   (A7)
    BSR.W   LAB_057F

    ADDQ.W  #4,A7

LAB_05A9:
    MOVE.L  A2,D1
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVEM.L (A7)+,D2/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_05AA   (Build layout for a source string)
; ARGS:
;   stack +8: A3 = font/rastport??
;   stack +12: ?? (source string)
; RET:
;   D0: boolean success
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   LAB_05C3, LAB_059F
; READS:
;   LAB_21DB, GLOB_REF_1000_BYTES_ALLOCATED_1
; WRITES:
;   GLOB_REF_1000_BYTES_ALLOCATED_1 (via LAB_05C3)
; DESC:
;   Prepares output buffer and runs layout; returns success flag.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_05AA:
    LINK.W  A5,#-8
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D7
    TST.L   LAB_21DB
    BNE.S   LAB_05AB

    LEA     16(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  12(A5),-(A7)
    MOVE.L  GLOB_REF_1000_BYTES_ALLOCATED_1,-(A7)
    MOVE.L  A0,-8(A5)
    JSR     LAB_05C3(PC)

    MOVE.L  GLOB_REF_1000_BYTES_ALLOCATED_1,(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_059F

    LEA     16(A7),A7
    MOVE.L  D0,D7

LAB_05AB:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_05AC   (Set current line index)
; ARGS:
;   stack +8: D7 = line index (1..3)
; RET:
;   D0: ??
; CLOBBERS:
;   D0/D7 ??
; CALLS:
;   LAB_0567
; READS:
;   LAB_21DB
; WRITES:
;   (via LAB_0567)
; DESC:
;   Updates current line selection if valid and not locked.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_05AC:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    TST.L   LAB_21DB
    BNE.S   .return

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BLT.S   .return

    MOVEQ   #3,D0
    CMP.L   D0,D7
    BGT.S   .return

    MOVE.L  D7,-(A7)
    BSR.W   LAB_0567

    ADDQ.W  #4,A7

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_05AE   (Compute visible line count??)
; ARGS:
;   stack +8: D7 = ?? (line index)
; RET:
;   D0: line count or offset
; CLOBBERS:
;   D0-D7 ??
; CALLS:
;   LAB_0585, GROUP_AG_JMPTBL_LAB_1A06, LAB_05C1
; READS:
;   LAB_21D5/21D6/21DC/21D3, LAB_2328
; WRITES:
;   ??
; DESC:
;   Computes a derived line count with optional prefix adjustments.
; NOTES:
;   Uses booleanize pattern on LAB_21DC.
;------------------------------------------------------------------------------
LAB_05AE:
    LINK.W  A5,#-12
    MOVEM.L D5-D7,-(A7)
    MOVE.L  8(A5),D7
    BSR.W   LAB_0585

    MOVEQ   #0,D0
    MOVE.W  LAB_21D5,D0
    CMP.L   D7,D0
    BGE.S   LAB_05AF

    MOVE.L  D7,D1
    BRA.S   LAB_05B0

LAB_05AF:
    MOVEQ   #0,D1
    MOVE.W  D0,D1

LAB_05B0:
    MOVE.L  D1,D6
    MOVEQ   #0,D1
    MOVE.W  LAB_2328,D1
    MOVE.L  D6,D0
    JSR     GROUP_AG_JMPTBL_LAB_1A06(PC)

    TST.L   D0
    BPL.S   LAB_05B1

    ADDQ.L  #3,D0

LAB_05B1:
    ASR.L   #2,D0
    MOVE.L  D0,D5
    MOVEQ   #1,D0
    CMP.L   D0,D6
    BNE.S   LAB_05B2

    MOVEQ   #2,D0
    BRA.S   LAB_05B3

LAB_05B2:
    MOVEQ   #0,D0

LAB_05B3:
    ADD.L   D0,D5
    TST.W   LAB_21DC
    BEQ.S   LAB_05B4

    MOVE.W  LAB_21D5,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ASL.L   #2,D1
    LEA     LAB_21D3,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,-12(A5)
    BEQ.S   LAB_05B4

    PEA     19.W
    MOVE.L  A1,-(A7)
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   LAB_05B4

    PEA     20.W
    MOVE.L  -12(A5),-(A7)
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   LAB_05B4

    ADDQ.L  #2,D5

LAB_05B4:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_05B5   (Get total line count)
; ARGS:
;   (none)
; RET:
;   D0: LAB_21D5
; CLOBBERS:
;   D0 ??
; CALLS:
;   LAB_0585
; READS:
;   LAB_21D5
; WRITES:
;   ??
; DESC:
;   Returns the total number of lines after ensuring state is current.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_05B5:
    BSR.W   LAB_0585

    MOVEQ   #0,D0
    MOVE.W  LAB_21D5,D0
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_05B6   (Has multiple lines??)
; ARGS:
;   (none)
; RET:
;   D0: boolean
; CLOBBERS:
;   D0-D1 ??
; CALLS:
;   LAB_0585
; READS:
;   LAB_21D5/21D6
; WRITES:
;   ??
; DESC:
;   Returns true when more than one line is available.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_05B6:
    BSR.W   LAB_0585

    MOVE.W  LAB_21D6,D0
    BNE.S   .LAB_05B7

    MOVE.W  LAB_21D5,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .LAB_05B7

    MOVEQ   #1,D0
    BRA.S   .return

.LAB_05B7:
    MOVEQ   #0,D0

.return:
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_05B9   (Is last line selected??)
; ARGS:
;   (none)
; RET:
;   D0: boolean
; CLOBBERS:
;   D0-D2 ??
; CALLS:
;   LAB_0585
; READS:
;   LAB_21D5/21D6
; WRITES:
;   ??
; DESC:
;   Returns true if current line index is the last line.
; NOTES:
;   Booleanize pattern: SEQ/NEG/EXT.
;------------------------------------------------------------------------------
LAB_05B9:
    MOVE.L  D2,-(A7)
    BSR.W   LAB_0585

    MOVEQ   #0,D0
    MOVE.W  LAB_21D5,D0
    SUBQ.L  #1,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_21D6,D1
    CMP.L   D0,D1
    SEQ     D2
    NEG.B   D2
    EXT.W   D2
    EXT.L   D2
    MOVE.L  D2,D0
    MOVE.L  (A7)+,D2
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_05BA   (Is current line last??)
; ARGS:
;   (none)
; RET:
;   D0: boolean
; CLOBBERS:
;   D0-D2 ??
; CALLS:
;   LAB_0585
; READS:
;   LAB_21D5/21D6
; WRITES:
;   ??
; DESC:
;   Returns true if LAB_21D6 equals LAB_21D5.
; NOTES:
;   Booleanize pattern: SEQ/NEG/EXT.
;------------------------------------------------------------------------------
LAB_05BA:
    MOVE.L  D2,-(A7)
    BSR.W   LAB_0585

    MOVE.W  LAB_21D6,D0
    MOVE.W  LAB_21D5,D1
    CMP.W   D1,D0
    SEQ     D2
    NEG.B   D2
    EXT.W   D2
    EXT.L   D2
    MOVE.L  D2,D0
    MOVE.L  (A7)+,D2
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_05BB   (Measure current line text length)
; ARGS:
;   stack +8: A3 = font/rastport??
; RET:
;   D0: text length
; CLOBBERS:
;   D0-D1/A0-A1/A6 ??
; CALLS:
;   LAB_0585, _LVOTextLength
; READS:
;   LAB_21D4/21D6/21D7
; WRITES:
;   ??
; DESC:
;   Measures text length for the current line.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_05BB:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    BSR.W   LAB_0585

    MOVEQ   #0,D0
    MOVE.W  LAB_21D6,D0
    ASL.L   #2,D0
    LEA     LAB_21D4,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.W  LAB_21D6,D0
    ADD.L   D0,D0
    LEA     LAB_21D7,A1
    ADDA.L  D0,A1
    MOVEQ   #0,D0
    MOVE.W  (A1),D0
    MOVEA.L A3,A1
    MOVEA.L (A0),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVEA.L (A7)+,A3
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_05BC   (Render one line of display text)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: D7 = x
;   stack +16: D6 = y
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D7/A0-A3/A6 ??
; CALLS:
;   LAB_0585, _LVOSetAPen, _LVOSetDrMd, _LVOMove, _LVOText, LAB_05C1, LAB_05C2
; READS:
;   LAB_21D4/21D6/21D7/21D9/21DC/21B1/21B2/21D8
; WRITES:
;   LAB_21D6, LAB_1CE8
; DESC:
;   Draws the current line at the given position, honoring highlight markers.
; NOTES:
;   Uses 0x13/0x14 control markers when LAB_21DC set.
;------------------------------------------------------------------------------
LAB_05BC:
    LINK.W  A5,#-12
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    BSR.W   LAB_0585

    MOVEQ   #0,D0
    MOVE.L  D0,LAB_1CE8
    MOVE.L  LAB_21D9,D1
    TST.L   D1
    BLE.W   LAB_05BF

    MOVE.W  LAB_21D6,D1
    MOVE.W  LAB_21D5,D2
    CMP.W   D2,D1
    BCC.W   LAB_05BF

    MOVEQ   #0,D2
    MOVE.W  D1,D2
    ASL.L   #2,D2
    LEA     LAB_21D4,A0
    MOVEA.L A0,A1
    ADDA.L  D2,A1
    TST.L   (A1)
    BEQ.W   LAB_05BF

    MOVEQ   #0,D2
    MOVE.W  D1,D2
    ASL.L   #2,D2
    ADDA.L  D2,A0
    MOVE.L  (A0),-6(A5)
    MOVEQ   #0,D3
    MOVE.W  D1,D3
    ADD.L   D3,D3
    LEA     LAB_21D7,A0
    ADDA.L  D3,A0
    MOVEQ   #0,D4
    MOVE.W  (A0),D4
    TST.L   D4
    BLE.W   LAB_05BF

    LEA     LAB_21D8,A0
    ADDA.L  D2,A0
    MOVEA.L A3,A1
    MOVE.L  (A0),D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L -6(A5),A0
    MOVE.B  0(A0,D4.L),D5
    CLR.B   0(A0,D4.L)
    TST.W   LAB_21DC
    BEQ.S   LAB_05BD

    PEA     19.W
    MOVE.L  A0,-(A7)
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   LAB_05BD

    PEA     20.W
    MOVE.L  -6(A5),-(A7)
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   LAB_05BD

    MOVEQ   #0,D0
    MOVE.B  LAB_21B2,D0
    MOVEQ   #0,D1
    MOVE.B  LAB_21B1,D1
    MOVE.L  -6(A5),-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_05C2(PC)

    LEA     24(A7),A7
    MOVEQ   #4,D0
    MOVE.L  D0,LAB_1CE8
    BRA.S   LAB_05BE

LAB_05BD:
    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVE.L  D4,D0
    MOVEA.L -6(A5),A0
    JSR     _LVOText(A6)

LAB_05BE:
    MOVEA.L -6(A5),A0
    MOVE.B  D5,0(A0,D4.L)
    MOVE.W  LAB_21D6,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_21D6

LAB_05BF:
    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS
