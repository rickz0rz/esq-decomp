;------------------------------------------------------------------------------
; FUNC: LADFUNC_UpdateHighlightState   (UpdateHighlightState)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/A0
; CALLS:
;   (none)
; READS:
;   LAB_1BC4, LAB_2251, LAB_2270
; WRITES:
;   WDISP_HighlightActive, WDISP_HighlightIndex, [A3] fields
; DESC:
;   Clears highlight state and walks banner rectangles to mark the active one.
; NOTES:
;   Loop count is 47 iterations (D7 from 0..46) via compare against 46.
;------------------------------------------------------------------------------
; Mark banner rectangles that should be highlighted based on the current cursor slot.
LADFUNC_UpdateHighlightState:
    MOVEM.L D7/A3,-(A7)
    MOVEQ   #0,D0
    MOVE.W  D0,WDISP_HighlightActive
    MOVE.W  D0,WDISP_HighlightIndex
    MOVE.B  LAB_1BC4,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_0E08

    MOVEQ   #0,D7

.LAB_0E06:
    MOVEQ   #46,D0
    CMP.L   D0,D7
    BGE.S   .LAB_0E08

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A3
    CLR.W   4(A3)
    MOVE.W  LAB_2270,D0
    MOVE.W  (A3),D1
    CMP.W   D0,D1
    BGT.S   .LAB_0E07

    MOVE.W  2(A3),D1
    CMP.W   D0,D1
    BLT.S   .LAB_0E07

    TST.L   6(A3)
    BEQ.S   .LAB_0E07

    MOVEQ   #1,D0
    MOVE.W  D0,4(A3)
    MOVE.W  D0,WDISP_HighlightActive

.LAB_0E07:
    ADDQ.L  #1,D7
    BRA.S   .LAB_0E06

.LAB_0E08:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

LAB_0E09:
    LINK.W  A5,#-4
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7

.LAB_0E0A:
    MOVEQ   #46,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     14.W
    PEA     116.W
    PEA     GLOB_STR_LADFUNC_C_1
    MOVE.L  A0,20(A7)
    JSR     GROUPC_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L 4(A7),A0
    MOVE.L  D0,(A0)
    ADDQ.L  #1,D7
    BRA.S   .LAB_0E0A

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

LAB_0E0C:
    MOVEM.L D6-D7/A2,-(A7)
    MOVEQ   #0,D7

LAB_0E0D:
    MOVEQ   #46,D0
    CMP.L   D0,D7
    BGE.W   LAB_0E13

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   (A1)
    BEQ.W   LAB_0E12

    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    TST.L   6(A2)
    BEQ.S   LAB_0E0F

    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEA.L 6(A1),A0

LAB_0E0E:
    TST.B   (A0)+
    BNE.S   LAB_0E0E

    SUBQ.L  #1,A0
    SUBA.L  6(A1),A0
    MOVE.L  A0,D6
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  6(A1),-(A7)
    CLR.L   -(A7)
    JSR     LAB_0B44(PC)

    ADDQ.W  #8,A7
    BRA.S   LAB_0E10

LAB_0E0F:
    MOVEQ   #0,D6

LAB_0E10:
    TST.L   D6
    BLE.S   LAB_0E11

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    TST.L   10(A2)
    BEQ.S   LAB_0E11

    MOVE.L  D7,D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  D6,-(A7)
    MOVE.L  10(A1),-(A7)
    PEA     147.W
    PEA     GLOB_STR_LADFUNC_C_2
    JSR     GROUPC_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

LAB_0E11:
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    PEA     14.W
    MOVE.L  (A0),-(A7)
    PEA     150.W
    PEA     GLOB_STR_LADFUNC_C_3
    JSR     GROUPC_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    CLR.L   (A0)

LAB_0E12:
    ADDQ.L  #1,D7
    BRA.W   LAB_0E0D

LAB_0E13:
    MOVEM.L (A7)+,D6-D7/A2
    RTS

;!======

LAB_0E14:
    MOVEM.L D7/A3,-(A7)
    MOVEQ   #0,D7

LAB_0E15:
    MOVEQ   #46,D0
    CMP.W   D0,D7
    BGE.S   LAB_0E16

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A3
    MOVEQ   #0,D0
    MOVE.W  D0,(A3)
    MOVE.W  D0,2(A3)
    MOVE.W  D0,4(A3)
    SUBA.L  A0,A0
    MOVE.L  A0,6(A3)
    MOVE.L  A0,10(A3)
    ADDQ.W  #1,D7
    BRA.S   LAB_0E15

LAB_0E16:
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_2291
    MOVE.W  D0,LAB_2265
    MOVE.W  D0,LAB_2293
    MOVE.W  D0,WDISP_HighlightActive
    MOVE.W  D0,WDISP_HighlightIndex
    MOVEQ   #0,D0
    MOVE.B  LAB_1DCD,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.L  D0,LAB_21FB
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

LAB_0E17:
    LINK.W  A5,#-8
    MOVEM.L D6-D7/A2,-(A7)
    MOVEQ   #0,D7

LAB_0E18:
    MOVEQ   #46,D0
    CMP.W   D0,D7
    BGE.W   LAB_0E1C

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   (A1)
    BEQ.W   LAB_0E1B

    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    TST.L   6(A2)
    BEQ.W   LAB_0E1B

    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEA.L 6(A1),A0

LAB_0E19:
    TST.B   (A0)+
    BNE.S   LAB_0E19

    SUBQ.L  #1,A0
    SUBA.L  6(A1),A0
    MOVE.L  A0,D6
    TST.L   D6
    BLE.S   LAB_0E1A

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    TST.L   10(A2)
    BEQ.S   LAB_0E1A

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  D6,-(A7)
    MOVE.L  10(A1),-(A7)
    PEA     212.W
    PEA     GLOB_STR_LADFUNC_C_4
    JSR     GROUPC_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

LAB_0E1A:
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  6(A1),-(A7)
    CLR.L   -(A7)
    MOVE.L  A2,24(A7)
    JSR     LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVEA.L 16(A7),A0
    MOVE.L  D0,6(A0)

LAB_0E1B:
    ADDQ.W  #1,D7
    BRA.W   LAB_0E18

LAB_0E1C:
    BSR.W   LAB_0E14

    MOVEM.L (A7)+,D6-D7/A2
    UNLK    A5
    RTS

;!======

    MOVE.W  WDISP_HighlightActive,D0
    SUBQ.W  #1,D0
    BNE.S   LAB_0E1E

    MOVE.W  LAB_2291,D0
    BLE.S   LAB_0E1E

LAB_0E1D:
    MOVE.W  LAB_2265,D0
    EXT.L   D0
    ADDQ.L  #1,D0
    MOVEQ   #46,D1
    JSR     JMPTBL_LAB_1A07_3(PC)

    MOVE.W  D1,LAB_2265
    MOVE.W  LAB_2265,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEQ   #1,D0
    CMP.W   4(A1),D0
    BNE.S   LAB_0E1D

    MOVE.W  LAB_2265,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  6(A1),-(A7)
    BSR.W   LAB_0E20

    ADDQ.W  #4,A7
    MOVE.W  LAB_2291,D0
    MOVE.L  D0,D1
    SUBQ.W  #1,D1
    MOVE.W  D1,LAB_2291

LAB_0E1E:
    MOVE.W  WDISP_HighlightActive,D0
    SUBQ.W  #1,D0
    BNE.S   LAB_0E1F

    MOVE.W  LAB_2291,D0
    MOVEQ   #1,D1
    CMP.W   D1,D0
    BGE.S   LAB_0E1F

    MOVE.W  LAB_2292,LAB_2291

LAB_0E1F:
    RTS

;!======

LAB_0E20:
    LINK.W  A5,#-92
    MOVEM.L D2-D3/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D0
    MOVE.W  LAB_2254,D0
    ADD.L   D0,D0
    LEA     LAB_225B,A0
    ADDA.L  D0,A0
    MOVE.W  #4,(A0)
    MOVE.W  LAB_2254,D0
    MOVE.L  D0,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,LAB_2254
    MOVEQ   #20,D0
    CMP.W   D0,D1
    BCS.S   LAB_0E21

    MOVEQ   #0,D0
    MOVE.W  D0,LAB_2254

LAB_0E21:
    MOVEQ   #0,D6
    MOVE.L  #624,D7
    MOVE.B  (A3),D5
    MOVEQ   #24,D0
    CMP.B   D0,D5
    BEQ.S   LAB_0E22

    MOVEQ   #25,D0
    CMP.B   D0,D5
    BEQ.S   LAB_0E22

    MOVEQ   #26,D0
    CMP.B   D0,D5
    BNE.S   LAB_0E23

LAB_0E22:
    ADDQ.L  #1,A3

LAB_0E23:
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-7(A5)
    TST.B   D0
    BEQ.W   LAB_0E29

    MOVEQ   #13,D1
    CMP.B   D1,D0
    BEQ.S   LAB_0E23

    MOVEQ   #10,D1
    CMP.B   D1,D0
    BNE.S   LAB_0E24

    BRA.S   LAB_0E23

LAB_0E24:
    TST.L   D7
    BLE.S   LAB_0E25

    MOVEQ   #24,D1
    CMP.B   D1,D0
    BEQ.S   LAB_0E25

    MOVEQ   #25,D1
    CMP.B   D1,D0
    BEQ.S   LAB_0E25

    MOVEQ   #26,D1
    CMP.B   D1,D0
    BNE.S   LAB_0E28

LAB_0E25:
    MOVEQ   #0,D0
    MOVE.W  D6,D0
    CLR.B   -89(A5,D0.L)
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVE.L  D0,-(A7)
    PEA     -89(A5)
    JSR     LAB_0EEB(PC)

    ADDQ.W  #8,A7
    MOVEQ   #0,D0
    MOVE.W  LAB_2254,D0
    ASL.L   #2,D0
    LEA     LAB_225A,A0
    ADDA.L  D0,A0
    LEA     -89(A5),A1
    MOVEA.L (A0),A2

LAB_0E26:
    MOVE.B  (A1)+,(A2)+
    BNE.S   LAB_0E26

    MOVEQ   #0,D0
    MOVE.W  LAB_2254,D0
    ADD.L   D0,D0
    LEA     LAB_225B,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.W  D0,(A0)
    MOVE.W  LAB_2254,D1
    MOVE.L  D1,D2
    ADDQ.W  #1,D2
    MOVE.W  D2,LAB_2254
    MOVEQ   #20,D1
    CMP.W   D1,D2
    BCS.S   LAB_0E27

    MOVE.W  D0,LAB_2254

LAB_0E27:
    MOVE.L  D0,D6
    MOVE.L  #624,D7
    MOVE.B  -7(A5),D5
    BRA.W   LAB_0E23

LAB_0E28:
    MOVE.L  D6,D1
    ADDQ.W  #1,D6
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.B  D0,-89(A5,D2.L)
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    LEA     -7(A5),A0
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    SUB.L   D0,D7
    BRA.W   LAB_0E23

LAB_0E29:
    MOVEQ   #0,D0
    MOVE.W  D6,D0
    CLR.B   -89(A5,D0.L)
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVE.L  D0,-(A7)
    PEA     -89(A5)
    JSR     LAB_0EEB(PC)

    ADDQ.W  #8,A7
    MOVEQ   #0,D0
    MOVE.W  LAB_2254,D0
    ASL.L   #2,D0
    LEA     LAB_225A,A0
    ADDA.L  D0,A0
    LEA     -89(A5),A1
    MOVEA.L (A0),A2

LAB_0E2A:
    MOVE.B  (A1)+,(A2)+
    BNE.S   LAB_0E2A

    MOVEQ   #0,D0
    MOVE.W  LAB_2254,D0
    ADD.L   D0,D0
    LEA     LAB_225B,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #0,D0
    MOVE.W  D0,(A1)
    MOVE.W  LAB_2254,D1
    MOVE.L  D1,D2
    ADDQ.W  #1,D2
    MOVE.W  D2,LAB_2254
    MOVEQ   #20,D1
    CMP.W   D1,D2
    BCS.S   LAB_0E2B

    MOVE.W  D0,LAB_2254

LAB_0E2B:
    MOVEQ   #0,D2
    MOVE.W  LAB_2254,D2
    ADD.L   D2,D2
    ADDA.L  D2,A0
    MOVE.W  #4,(A0)
    MOVE.W  LAB_2254,D2
    MOVE.L  D2,D3
    ADDQ.W  #1,D3
    MOVE.W  D3,LAB_2254
    CMP.W   D1,D3
    BCS.S   LAB_0E2C

    MOVE.W  D0,LAB_2254

LAB_0E2C:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_0E2D:
    MOVE.L  D7,-(A7)
    MOVE.B  11(A7),D7
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   LAB_0E2E

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    BRA.S   LAB_0E32

LAB_0E2E:
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.S   LAB_0E31

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   LAB_0E2F

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   LAB_0E30

LAB_0E2F:
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0

LAB_0E30:
    MOVEQ   #55,D1
    SUB.L   D1,D0
    BRA.S   LAB_0E32

LAB_0E31:
    MOVEQ   #0,D0

LAB_0E32:
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_0E33:
    LINK.W  A5,#-416
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVE.B  11(A5),D7
    MOVEA.L 12(A5),A3
    PEA     1.W
    PEA     2.W
    BSR.W   LAB_0EE5

    ADDQ.W  #8,A7
    MOVE.B  (A3)+,D5
    MOVEQ   #0,D1
    MOVE.B  D5,D1
    MOVE.B  D0,-413(A5)
    MOVEQ   #73,D0
    ADD.L   D0,D0
    CMP.L   D0,D1
    BNE.S   LAB_0E36

    MOVEQ   #76,D0
    CMP.B   D0,D7
    BEQ.S   LAB_0E34

    MOVEQ   #116,D0
    CMP.B   D0,D7
    BNE.S   LAB_0E35

LAB_0E34:
    MOVE.W  LAB_2299,D0
    SUBQ.W  #1,D0
    BNE.S   LAB_0E35

    MOVE.B  LAB_1BC4,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     LAB_1FBF
    JSR     GROUP_AS_JMPTBL_LAB_1979(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   LAB_0E35

    BSR.W   LAB_0E17

LAB_0E35:
    MOVEQ   #0,D0
    BRA.W   LAB_0E47

LAB_0E36:
    MOVEQ   #76,D0
    CMP.B   D0,D7
    BEQ.S   LAB_0E37

    MOVEQ   #116,D0
    CMP.B   D0,D7
    BNE.S   LAB_0E3A

LAB_0E37:
    MOVE.B  LAB_1BC4,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     LAB_1FC0
    JSR     GROUP_AS_JMPTBL_LAB_1979(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   LAB_0E38

    MOVEQ   #46,D0
    CMP.B   D0,D5
    BCC.S   LAB_0E38

    MOVE.W  LAB_2293,D0
    MOVE.L  D0,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,LAB_2293
    MOVEQ   #46,D0
    CMP.W   D0,D1
    BLT.S   LAB_0E39

LAB_0E38:
    MOVEQ   #0,D0
    BRA.W   LAB_0E47

LAB_0E39:
    SUBQ.B  #1,D5
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     LAB_2251,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A2
    BRA.S   LAB_0E3B

LAB_0E3A:
    MOVEQ   #0,D0
    BRA.W   LAB_0E47

LAB_0E3B:
    MOVE.W  #1,(A2)
    MOVE.W  #$30,2(A2)
    MOVEQ   #0,D6
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     304.W
    PEA     367.W
    PEA     GLOB_STR_LADFUNC_C_5
    JSR     GROUPC_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-412(A5)
    BEQ.W   LAB_0E45

LAB_0E3C:
    MOVE.B  (A3)+,D4
    TST.B   D4
    BEQ.W   LAB_0E40

    CMPI.W  #$190,D6
    BGE.W   LAB_0E40

    MOVEQ   #3,D0
    CMP.B   D0,D4
    BNE.S   LAB_0E3E

    MOVE.B  (A3)+,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0E2D

    ADDQ.W  #4,A7
    MOVE.L  D0,D4
    MOVEQ   #0,D0
    CMP.B   D0,D4
    BCS.S   LAB_0E3D

    MOVEQ   #7,D0
    CMP.B   D0,D4
    BHI.S   LAB_0E3D

    MOVEQ   #0,D0
    MOVE.B  D4,D0
    MOVEQ   #0,D1
    MOVE.B  -413(A5),D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0EE6

    ADDQ.W  #8,A7
    MOVE.B  D0,-413(A5)

LAB_0E3D:
    MOVE.B  (A3)+,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0E2D

    ADDQ.W  #4,A7
    MOVE.L  D0,D4
    MOVEQ   #0,D0
    CMP.B   D0,D4
    BCS.S   LAB_0E3C

    MOVEQ   #7,D0
    CMP.B   D0,D4
    BHI.S   LAB_0E3C

    MOVEQ   #0,D0
    MOVE.B  -413(A5),D0
    MOVEQ   #0,D1
    MOVE.B  D4,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0EE7

    ADDQ.W  #8,A7
    MOVE.B  D0,-413(A5)
    BRA.S   LAB_0E3C

LAB_0E3E:
    MOVEQ   #20,D0
    CMP.B   D0,D4
    BNE.S   LAB_0E3F

    MOVEQ   #0,D0
    MOVE.B  (A3)+,D0
    MOVE.W  D0,(A2)
    MOVEQ   #0,D1
    MOVE.B  (A3)+,D1
    MOVE.W  D1,2(A2)
    MOVE.W  (A2),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0AC6(PC)

    MOVE.B  D0,D1
    EXT.W   D1
    MOVE.W  D1,(A2)
    MOVE.W  2(A2),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    JSR     LAB_0AC6(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,D1
    EXT.W   D1
    MOVE.W  D1,2(A2)
    BRA.W   LAB_0E3C

LAB_0E3F:
    MOVEA.L -412(A5),A0
    MOVE.B  -413(A5),0(A0,D6.W)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    LEA     -407(A5),A0
    ADDA.W  D0,A0
    MOVE.B  D4,(A0)
    BRA.W   LAB_0E3C

LAB_0E40:
    LEA     -407(A5),A0
    MOVEA.L A0,A1
    ADDA.W  D6,A1
    CLR.B   (A1)
    MOVE.L  6(A2),-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,6(A2)
    TST.L   10(A2)
    BEQ.S   LAB_0E41

    PEA     304.W
    MOVE.L  10(A2),-(A7)
    PEA     412.W
    PEA     GLOB_STR_LADFUNC_C_6
    JSR     GROUPC_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

LAB_0E41:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     413.W
    PEA     GLOB_STR_LADFUNC_C_7
    JSR     GROUPC_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,10(A2)
    TST.L   D0
    BEQ.S   LAB_0E44

    MOVE.L  D6,D1
    EXT.L   D1
    MOVEA.L -412(A5),A0
    MOVEA.L D0,A1
    BRA.S   LAB_0E43

LAB_0E42:
    MOVE.B  (A0)+,(A1)+

LAB_0E43:
    SUBQ.L  #1,D1
    BCC.S   LAB_0E42

LAB_0E44:
    PEA     304.W
    MOVE.L  -412(A5),-(A7)
    PEA     416.W
    PEA     GLOB_STR_LADFUNC_C_8
    JSR     GROUPC_JMPTBL_MEMORY_DeallocateMemory(PC)

    BSR.W   LADFUNC_UpdateHighlightState

    LEA     16(A7),A7
    BRA.S   LAB_0E46

LAB_0E45:
    MOVEQ   #0,D0
    BRA.S   LAB_0E47

LAB_0E46:
    MOVEQ   #1,D0

LAB_0E47:
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_0E48:
    LINK.W  A5,#-36
    MOVEM.L D4-D7,-(A7)
    PEA     1.W
    PEA     2.W
    BSR.W   LAB_0EE5

    ADDQ.W  #8,A7
    MOVE.B  D0,-25(A5)
    TST.L   LAB_1B9F
    BNE.S   LAB_0E49

    MOVEQ   #0,D0
    BRA.W   LAB_0E56

LAB_0E49:
    CLR.L   LAB_1B9F
    CLR.B   -15(A5)
    PEA     MODE_NEWFILE.W
    PEA     LAB_1FB6
    JSR     JMPTBL_DISKIO_OpenFileWithBuffer_1(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_2320
    TST.L   D0
    BNE.S   LAB_0E4A

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_1B9F
    MOVEQ   #-1,D0
    BRA.W   LAB_0E56

LAB_0E4A:
    MOVEQ   #0,D6

LAB_0E4B:
    MOVEQ   #46,D0
    CMP.W   D0,D6
    BGE.W   LAB_0E55

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    MOVEA.L -4(A5),A0
    MOVE.W  (A0),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_2320,-(A7)
    JSR     LAB_0F96(PC)

    MOVEA.L -4(A5),A0
    MOVE.W  2(A0),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_2320,-(A7)
    JSR     LAB_0F96(PC)

    LEA     12(A7),A7
    MOVEA.L -4(A5),A0
    TST.L   6(A0)
    BNE.S   LAB_0E4C

    LEA     -15(A5),A1
    MOVE.L  A1,-8(A5)
    BRA.S   LAB_0E4D

LAB_0E4C:
    MOVEA.L 6(A0),A0
    MOVE.L  A0,-8(A5)

LAB_0E4D:
    MOVEA.L -8(A5),A0

LAB_0E4E:
    TST.B   (A0)+
    BNE.S   LAB_0E4E

    SUBQ.L  #1,A0
    SUBA.L  -8(A5),A0
    MOVE.L  A0,D7
    MOVEQ   #0,D4
    MOVE.L  D4,D5

LAB_0E4F:
    CMP.L   D7,D5
    BGE.W   LAB_0E54

    CMP.L   D4,D7
    BEQ.S   LAB_0E50

    MOVEA.L -4(A5),A1
    MOVEA.L 10(A1),A0
    ADDA.L  D4,A0
    MOVE.B  (A0),D0
    MOVE.B  -25(A5),D1
    CMP.B   D1,D0
    BEQ.S   LAB_0E53

LAB_0E50:
    TST.L   D4
    BLE.S   LAB_0E52

    MOVEQ   #0,D0
    MOVE.B  -25(A5),D0
    MOVE.L  D0,-(A7)
    PEA     3.W
    PEA     LAB_1FC5
    PEA     -35(A5)
    JSR     JMPTBL_PRINTF_3(PC)

    LEA     -35(A5),A0
    MOVEA.L A0,A1

LAB_0E51:
    TST.B   (A1)+
    BNE.S   LAB_0E51

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  LAB_2320,-(A7)
    JSR     LAB_0F97(PC)

    MOVEA.L -8(A5),A0
    ADDA.L  D5,A0
    MOVE.L  D4,D0
    SUB.L   D5,D0
    MOVE.L  D0,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  LAB_2320,-(A7)
    JSR     LAB_0F97(PC)

    LEA     32(A7),A7
    MOVE.L  D4,D5

LAB_0E52:
    CMP.L   D7,D5
    BGE.S   LAB_0E53

    MOVEA.L -4(A5),A1
    MOVEA.L 10(A1),A0
    ADDA.L  D4,A0
    MOVE.B  (A0),-25(A5)

LAB_0E53:
    ADDQ.L  #1,D4
    BRA.W   LAB_0E4F

LAB_0E54:
    PEA     1.W
    PEA     LAB_1FC6
    MOVE.L  LAB_2320,-(A7)
    JSR     LAB_0F97(PC)

    LEA     12(A7),A7
    ADDQ.W  #1,D6
    BRA.W   LAB_0E4B

LAB_0E55:
    MOVE.L  LAB_2320,-(A7)
    JSR     LAB_0F98(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_1B9F

LAB_0E56:
    MOVEM.L -52(A5),D4-D7
    UNLK    A5
    RTS

;!======

; load text ads?
LAB_0E57:
    LINK.W  A5,#-40
    MOVEM.L D2/D4-D7,-(A7)

    PEA     1.W
    PEA     2.W
    BSR.W   LAB_0EE5

    PEA     LAB_1FB6
    MOVE.B  D0,-29(A5)
    JSR     LAB_0F9B(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D0
    BNE.S   LAB_0E58

    MOVEQ   #-1,D0
    BRA.W   LAB_0E68

LAB_0E58:
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,D6
    MOVE.L  LAB_21BC,-12(A5)
    BSR.W   LAB_0E17

    MOVEQ   #0,D7

LAB_0E59:
    MOVEQ   #46,D0
    CMP.L   D0,D7
    BGE.W   LAB_0E67

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    JSR     LAB_0F95(PC)

    MOVEA.L -4(A5),A0
    MOVE.W  D0,(A0)
    JSR     LAB_0F95(PC)

    MOVEA.L -4(A5),A0
    MOVE.W  D0,2(A0)
    JSR     LAB_0F94(PC)

    MOVEA.L D0,A0

LAB_0E5A:
    TST.B   (A0)+
    BNE.S   LAB_0E5A

    SUBQ.L  #1,A0
    SUBA.L  D0,A0
    MOVE.L  A0,D4
    MOVE.L  D0,-34(A5)
    MOVE.L  D0,-8(A5)

LAB_0E5B:
    TST.L   D4
    BLE.S   LAB_0E5D

    MOVEA.L -34(A5),A0
    TST.B   (A0)
    BEQ.S   LAB_0E5D

    MOVEQ   #3,D0
    CMP.B   (A0),D0
    BNE.S   LAB_0E5C

    SUBQ.L  #3,D4
    ADDQ.L  #2,-34(A5)

LAB_0E5C:
    ADDQ.L  #1,-34(A5)
    BRA.S   LAB_0E5B

LAB_0E5D:
    TST.L   D4
    BLE.W   LAB_0E64

    MOVE.L  D4,D0
    ADDQ.L  #1,D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     591.W
    PEA     GLOB_STR_LADFUNC_C_9
    JSR     GROUPC_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L -4(A5),A0
    MOVE.L  D0,6(A0)
    TST.L   D0
    BNE.S   LAB_0E5E

    MOVEQ   #-1,D0
    BRA.W   LAB_0E68

LAB_0E5E:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D4,-(A7)
    PEA     600.W
    PEA     GLOB_STR_LADFUNC_C_10
    JSR     GROUPC_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L -4(A5),A0
    MOVE.L  D0,10(A0)
    BNE.S   LAB_0E5F

    MOVEQ   #-1,D0
    BRA.W   LAB_0E68

LAB_0E5F:
    MOVEQ   #0,D5
    MOVE.L  -8(A5),-34(A5)

LAB_0E60:
    CMP.L   D4,D5
    BGE.W   LAB_0E63

    MOVEA.L -34(A5),A0
    TST.B   (A0)
    BEQ.W   LAB_0E63

    MOVE.B  (A0),D0
    MOVEQ   #3,D1
    CMP.B   D1,D0
    BNE.S   LAB_0E61

    ADDQ.L  #1,-34(A5)
    MOVEA.L -34(A5),A0
    MOVE.B  (A0)+,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-34(A5)
    BSR.W   LAB_0E2D

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #0,D0
    MOVE.B  -29(A5),D0
    MOVE.L  D0,(A7)
    MOVE.L  D1,-(A7)
    BSR.W   LAB_0EE6

    MOVE.L  -34(A5),-34(A5)
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEA.L -34(A5),A0
    MOVE.B  (A0),D2
    EXT.W   D2
    EXT.L   D2
    MOVE.L  D2,(A7)
    MOVE.B  D0,-29(A5)
    MOVE.L  D1,28(A7)
    BSR.W   LAB_0E2D

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  28(A7),-(A7)
    BSR.W   LAB_0EE7

    LEA     12(A7),A7
    MOVE.B  D0,-29(A5)
    BRA.S   LAB_0E62

LAB_0E61:
    MOVEA.L -4(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D5,A0
    MOVE.B  D0,(A0)
    MOVEA.L 10(A1),A0
    ADDA.L  D5,A0
    ADDQ.L  #1,D5
    MOVE.B  -29(A5),(A0)

LAB_0E62:
    ADDQ.L  #1,-34(A5)
    BRA.W   LAB_0E60

LAB_0E63:
    MOVEA.L -4(A5),A1
    MOVEA.L 6(A1),A0
    MOVEA.L A0,A1
    ADDA.L  D5,A1
    CLR.B   (A1)
    BRA.S   LAB_0E66

LAB_0E64:
    MOVEA.L -4(A5),A0
    TST.L   6(A0)
    BEQ.S   LAB_0E66

    MOVEA.L -4(A5),A1
    MOVEA.L 6(A1),A0

LAB_0E65:
    TST.B   (A0)+
    BNE.S   LAB_0E65

    SUBQ.L  #1,A0
    SUBA.L  6(A1),A0
    MOVE.L  A0,D4
    MOVE.L  D4,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  6(A1),-(A7)
    PEA     638.W
    PEA     GLOB_STR_LADFUNC_C_11
    JSR     GROUPC_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    SUBA.L  A0,A0
    MOVEA.L -4(A5),A1
    MOVE.L  A0,6(A1)
    TST.L   10(A1)
    BEQ.S   LAB_0E66

    MOVE.L  D4,-(A7)
    MOVE.L  10(A1),-(A7)
    PEA     642.W
    PEA     GLOB_STR_LADFUNC_C_12
    JSR     GROUPC_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L -4(A5),A0
    CLR.L   10(A0)

LAB_0E66:
    ADDQ.L  #1,D7
    BRA.W   LAB_0E59

LAB_0E67:
    MOVE.L  D6,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    PEA     653.W
    PEA     GLOB_STR_LADFUNC_C_13
    JSR     GROUPC_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #0,D0

LAB_0E68:
    MOVEM.L -60(A5),D2/D4-D7

    UNLK    A5
    RTS

;!======

LAB_0E69:
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVE.L  28(A7),D7
    MOVE.L  32(A7),D6
    MOVE.B  39(A7),D5
    MOVEA.L 40(A7),A2
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0EE9

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEA.L A3,A1
    MOVE.L  D1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVE.L  D0,(A7)
    BSR.W   LAB_0EE8

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEA.L A3,A1
    MOVE.L  D1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetBPen(A6)

    MOVE.L  A2,(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_DISPLAY_TEXT_AT_POSITION_3(PC)

    LEA     16(A7),A7
    MOVEM.L (A7)+,D5-D7/A2-A3
    RTS

;!======

LAB_0E6A:
    LINK.W  A5,#-44
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVEA.L 16(A5),A2
    MOVEQ   #0,D6
    MOVEA.L A3,A1
    LEA     GLOB_STR_SINGLE_SPACE_1,A0
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,-26(A5)
    MOVE.L  #624,D0
    MOVE.L  -26(A5),D1
    JSR     JMPTBL_LAB_1A07_3(PC)

    MOVE.L  D0,-22(A5)
    MOVEQ   #40,D1
    CMP.L   D1,D0
    BLE.S   LAB_0E6B

    MOVE.L  D1,-22(A5)

LAB_0E6B:
    MOVE.L  -22(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     712.W
    PEA     GLOB_STR_LADFUNC_C_14
    JSR     GROUPC_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.W   LAB_0E82

    MOVE.B  (A2),D1
    MOVEQ   #24,D2
    CMP.B   D2,D1
    BEQ.S   LAB_0E6C

    MOVEQ   #25,D2
    CMP.B   D2,D1
    BEQ.S   LAB_0E6C

    MOVEQ   #26,D2
    CMP.B   D2,D1
    BNE.S   LAB_0E6D

LAB_0E6C:
    MOVE.L  D1,D6
    MOVEA.L 20(A5),A0
    MOVE.B  (A0)+,D5
    ADDQ.L  #1,A2
    MOVE.L  A0,20(A5)

LAB_0E6D:
    MOVEA.L A2,A0

LAB_0E6E:
    TST.B   (A0)+
    BNE.S   LAB_0E6E

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,-10(A5)
    MOVE.L  -22(A5),D1
    CMPA.L  D1,A0
    BLE.S   LAB_0E6F

    MOVE.L  D1,-10(A5)

LAB_0E6F:
    MOVE.L  -10(A5),D2
    MOVE.L  D1,D3
    SUB.L   D2,D3
    MOVEM.L D3,-30(A5)
    BLE.S   LAB_0E70

    TST.B   D6
    BNE.S   LAB_0E70

    MOVEA.L 20(A5),A0
    MOVE.B  0(A0,D2.L),D5

LAB_0E70:
    MOVEA.L 4(A3),A0
    MOVEQ   #0,D2
    MOVE.W  (A0),D2
    ASL.L   #3,D2
    MOVE.L  -26(A5),D0
    JSR     GROUPC_JMPTBL_LAB_1A06(PC)

    SUB.L   D0,D2
    TST.L   D2
    BPL.S   LAB_0E71

    ADDQ.L  #1,D2

LAB_0E71:
    ASR.L   #1,D2
    MOVEA.L 52(A3),A1
    MOVEQ   #0,D0
    MOVE.W  20(A1),D0
    MOVE.L  LAB_21FB,D1
    JSR     GROUPC_JMPTBL_LAB_1A06(PC)

    MOVEQ   #0,D1
    MOVE.W  2(A0),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   LAB_0E72

    ADDQ.L  #1,D1

LAB_0E72:
    ASR.L   #1,D1
    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVEQ   #0,D4
    MOVE.W  20(A1),D4
    MOVE.L  D1,-38(A5)
    MOVE.L  D4,D1
    JSR     GROUPC_JMPTBL_LAB_1A06(PC)

    ADD.L   D0,-38(A5)
    MOVE.L  D2,-34(A5)
    BGE.S   LAB_0E73

    MOVEQ   #0,D0
    MOVE.L  D0,-34(A5)

LAB_0E73:
    MOVE.L  -38(A5),D0
    TST.L   D0
    BPL.S   LAB_0E74

    MOVEQ   #0,D0
    MOVE.L  D0,-38(A5)

LAB_0E74:
    MOVEQ   #24,D0
    CMP.B   D0,D6
    BNE.S   LAB_0E75

    MOVEQ   #2,D0
    MOVE.L  D0,-14(A5)
    BRA.S   LAB_0E77

LAB_0E75:
    MOVEQ   #26,D0
    CMP.B   D0,D6
    BNE.S   LAB_0E76

    MOVEQ   #1,D0
    MOVE.L  D0,-14(A5)
    BRA.S   LAB_0E77

LAB_0E76:
    MOVEQ   #0,D0
    MOVE.L  D0,-14(A5)

LAB_0E77:
    TST.L   -14(A5)
    BEQ.S   LAB_0E7A

    TST.L   D3
    BEQ.S   LAB_0E7A

    MOVE.L  D3,D0
    MOVE.L  -14(A5),D1
    JSR     JMPTBL_LAB_1A07_3(PC)

    MOVEQ   #32,D1
    MOVEA.L -4(A5),A0
    BRA.S   LAB_0E79

LAB_0E78:
    MOVE.B  D1,(A0)+

LAB_0E79:
    SUBQ.L  #1,D0
    BCC.S   LAB_0E78

    MOVE.L  -30(A5),D0
    MOVE.L  -14(A5),D1
    JSR     JMPTBL_LAB_1A07_3(PC)

    MOVEA.L -4(A5),A0
    CLR.B   0(A0,D0.L)
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -38(A5),-(A7)
    MOVE.L  -34(A5),-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0E69

    LEA     20(A7),A7
    MOVE.L  -30(A5),D0
    MOVE.L  -14(A5),D1
    JSR     JMPTBL_LAB_1A07_3(PC)

    MOVE.L  -26(A5),D1
    MOVE.L  D0,32(A7)
    JSR     GROUPC_JMPTBL_LAB_1A06(PC)

    ADD.L   D0,-34(A5)
    MOVE.L  32(A7),D0
    SUB.L   D0,-30(A5)

LAB_0E7A:
    CLR.L   -14(A5)

LAB_0E7B:
    MOVE.L  -14(A5),D0
    CMP.L   -10(A5),D0
    BGE.W   LAB_0E7E

    CLR.L   -18(A5)

LAB_0E7C:
    MOVE.L  -14(A5),D0
    MOVE.L  -18(A5),D1
    MOVE.L  D1,D2
    ADD.L   D0,D2
    CMP.L   -10(A5),D2
    BGE.S   LAB_0E7D

    MOVEA.L 20(A5),A0
    MOVE.B  0(A0,D0.L),D3
    CMP.B   0(A0,D2.L),D3
    BNE.S   LAB_0E7D

    ADD.L   D1,D0
    MOVEA.L -4(A5),A0
    MOVE.B  0(A2,D0.L),0(A0,D1.L)
    ADDQ.L  #1,-18(A5)
    BRA.S   LAB_0E7C

LAB_0E7D:
    MOVEA.L -4(A5),A0
    MOVE.L  -18(A5),D0
    CLR.B   0(A0,D0.L)
    MOVEQ   #0,D0
    MOVEA.L 20(A5),A1
    MOVE.L  -14(A5),D1
    MOVE.B  0(A1,D1.L),D0
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -38(A5),-(A7)
    MOVE.L  -34(A5),-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0E69

    LEA     20(A7),A7
    MOVE.L  -26(A5),D0
    MOVE.L  -18(A5),D1
    JSR     GROUPC_JMPTBL_LAB_1A06(PC)

    ADD.L   D0,-34(A5)
    MOVE.L  -18(A5),D0
    ADD.L   D0,-14(A5)
    BRA.W   LAB_0E7B

LAB_0E7E:
    TST.L   -30(A5)
    BEQ.S   LAB_0E81

    MOVE.L  -30(A5),D0
    MOVEQ   #32,D1
    MOVEA.L -4(A5),A0
    BRA.S   LAB_0E80

LAB_0E7F:
    MOVE.B  D1,(A0)+

LAB_0E80:
    SUBQ.L  #1,D0
    BCC.S   LAB_0E7F

    MOVEA.L -4(A5),A0
    MOVE.L  -30(A5),D0
    CLR.B   0(A0,D0.L)
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -38(A5),-(A7)
    MOVE.L  -34(A5),-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0E69

    LEA     20(A7),A7

LAB_0E81:
    MOVE.L  -22(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     824.W
    PEA     GLOB_STR_LADFUNC_C_15
    JSR     GROUPC_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

LAB_0E82:
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_0E83:
    LINK.W  A5,#-40
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVE.L  8(A5),D7
    PEA     3.W
    CLR.L   -(A7)
    PEA     4.W
    JSR     LAB_0EEA(PC)

    MOVE.L  D0,LAB_2216
    MOVEA.L D0,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    MOVEA.L GLOB_HANDLE_H26F_FONT,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    LEA     GLOB_STR_SINGLE_SPACE_2,A0
    MOVEQ   #1,D0
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,44(A7)
    MOVE.L  #624,D0
    MOVE.L  44(A7),D1
    JSR     JMPTBL_LAB_1A07_3(PC)

    MOVE.L  D0,D6
    MOVE.L  D6,D0
    ADDQ.L  #1,D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    MOVE.L  D0,-(A7)
    PEA     857.W
    PEA     GLOB_STR_LADFUNC_C_16
    JSR     GROUPC_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    MOVE.L  D6,-(A7)
    PEA     858.W
    PEA     GLOB_STR_LADFUNC_C_17
    MOVE.L  D0,-4(A5)
    JSR     GROUPC_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     36(A7),A7
    MOVE.L  D0,-16(A5)
    TST.L   -4(A5)
    BEQ.W   LAB_0E8F

    TST.L   D0
    BEQ.W   LAB_0E8F

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    MOVE.L  6(A2),-8(A5)
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  10(A1),-12(A5)
    CLR.W   LAB_22AB
    JSR     LAB_0EF1(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    JSR     LAB_0EED(PC)

    MOVEQ   #0,D4

LAB_0E84:
    MOVEQ   #24,D0
    CMP.L   D0,D4
    BGE.S   LAB_0E85

    LEA     LAB_2295,A0
    ADDA.L  D4,A0
    LEA     LAB_1FB8,A1
    ADDA.L  D4,A1
    MOVE.B  (A1),(A0)
    ADDQ.L  #1,D4
    BRA.S   LAB_0E84

LAB_0E85:
    MOVEA.L -8(A5),A0

LAB_0E86:
    TST.B   (A0)+
    BNE.S   LAB_0E86

    SUBQ.L  #1,A0
    SUBA.L  -8(A5),A0
    MOVE.L  A0,D5
    MOVEQ   #0,D0
    MOVEA.L -12(A5),A0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0EE8

    ADDQ.W  #4,A7
    MOVEQ   #0,D4
    MOVE.B  D0,D4
    MOVE.L  D4,D0
    LSL.L   #2,D0
    SUB.L   D4,D0
    LEA     LAB_1FB8,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),LAB_2295
    LEA     LAB_1FB9,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),LAB_2296
    LEA     LAB_1FBA,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),LAB_2297
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    MOVE.L  D4,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVEQ   #0,D0
    MOVE.L  D0,D4
    MOVE.L  D0,-32(A5)
    MOVE.L  D0,-36(A5)

LAB_0E87:
    CMP.L   LAB_21FB,D4
    BGE.W   LAB_0E8E

LAB_0E88:
    MOVE.L  -32(A5),D0
    CMP.L   D5,D0
    BGE.W   LAB_0E8D

    MOVE.L  -36(A5),D1
    CMP.L   D6,D1
    BGE.W   LAB_0E8D

    MOVEA.L -8(A5),A0
    MOVE.B  0(A0,D0.L),D2
    MOVEQ   #10,D3
    CMP.B   D3,D2
    BEQ.S   LAB_0E89

    MOVEQ   #13,D3
    CMP.B   D3,D2
    BNE.S   LAB_0E8A

LAB_0E89:
    ADDQ.L  #1,-32(A5)
    BRA.S   LAB_0E88

LAB_0E8A:
    TST.L   D1
    BNE.S   LAB_0E8B

    MOVE.B  0(A0,D0.L),D2
    MOVEQ   #24,D3
    CMP.B   D3,D2
    BEQ.S   LAB_0E8B

    MOVEQ   #25,D3
    CMP.B   D3,D2
    BEQ.S   LAB_0E8B

    MOVEQ   #26,D2
    CMP.B   0(A0,D0.L),D2
    BEQ.S   LAB_0E8B

    MOVEA.L -4(A5),A1
    MOVE.B  D3,0(A1,D1.L)
    ADDQ.L  #1,-36(A5)
    MOVEA.L -12(A5),A2
    MOVEA.L -16(A5),A3
    MOVE.B  0(A2,D0.L),0(A3,D1.L)
    BRA.S   LAB_0E88

LAB_0E8B:
    TST.L   D1
    BLE.S   LAB_0E8C

    MOVE.B  0(A0,D0.L),D2
    MOVEQ   #24,D3
    CMP.B   D3,D2
    BEQ.S   LAB_0E8D

    MOVEQ   #25,D3
    CMP.B   D3,D2
    BEQ.S   LAB_0E8D

    MOVEQ   #26,D2
    CMP.B   0(A0,D0.L),D2
    BNE.S   LAB_0E8C

    BRA.S   LAB_0E8D

LAB_0E8C:
    MOVEA.L -12(A5),A1
    MOVEA.L -16(A5),A2
    MOVE.B  0(A1,D0.L),0(A2,D1.L)
    ADDQ.L  #1,-36(A5)
    ADDQ.L  #1,-32(A5)
    MOVEA.L -4(A5),A1
    MOVE.B  0(A0,D0.L),0(A1,D1.L)
    BRA.W   LAB_0E88

LAB_0E8D:
    MOVEA.L -4(A5),A0
    MOVE.L  -36(A5),D0
    CLR.B   0(A0,D0.L)
    MOVEA.L LAB_2216,A1
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A1
    MOVE.L  -16(A5),-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  A1,-(A7)
    BSR.W   LAB_0E6A

    LEA     16(A7),A7
    ADDQ.L  #1,D4
    CLR.L   -36(A5)
    BRA.W   LAB_0E87

LAB_0E8E:
    JSR     LAB_0EEC(PC)

LAB_0E8F:
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    TST.L   -4(A5)
    BEQ.S   LAB_0E90

    MOVE.L  D6,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     926.W
    PEA     GLOB_STR_LADFUNC_C_18
    JSR     GROUPC_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

LAB_0E90:
    TST.L   -16(A5)
    BEQ.S   LAB_0E91

    MOVE.L  D6,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     928.W
    PEA     GLOB_STR_LADFUNC_C_19
    JSR     GROUPC_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

LAB_0E91:
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_0E92:
    LINK.W  A5,#-120
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEA.L A3,A0

LAB_0E93:
    TST.B   (A0)+
    BNE.S   LAB_0E93

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D0
    MOVE.L  D0,-116(A5)
    ADDQ.L  #1,D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     1025.W
    PEA     GLOB_STR_LADFUNC_C_20
    JSR     GROUPC_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    MOVE.L  -116(A5),-(A7)
    PEA     1026.W
    PEA     GLOB_STR_LADFUNC_C_21
    MOVE.L  D0,-6(A5)
    JSR     GROUPC_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     28(A7),A7
    MOVE.L  D0,-10(A5)
    TST.L   -6(A5)
    BEQ.W   LAB_0EAC

    TST.L   D0
    BEQ.W   LAB_0EAC

    MOVEA.L A3,A0
    MOVEA.L -6(A5),A1

LAB_0E94:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_0E94

    MOVE.L  -116(A5),D0
    MOVEA.L A2,A0
    MOVEA.L -10(A5),A1
    BRA.S   LAB_0E96

LAB_0E95:
    MOVE.B  (A0)+,(A1)+

LAB_0E96:
    SUBQ.L  #1,D0
    BCC.S   LAB_0E95

    MOVEQ   #0,D7
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D5
    MOVE.L  D0,-100(A5)
    MOVE.L  D0,-104(A5)
    MOVE.L  D0,-112(A5)

LAB_0E97:
    CMP.L   LAB_21FB,D5
    BGE.W   LAB_0EAB

LAB_0E98:
    MOVEA.L -6(A5),A0
    MOVE.L  -100(A5),D0
    TST.B   0(A0,D0.L)
    BEQ.W   LAB_0E9F

    MOVE.L  -104(A5),D1
    MOVEQ   #40,D2
    CMP.L   D2,D1
    BGE.W   LAB_0E9F

    MOVE.B  0(A0,D0.L),D2
    MOVEQ   #10,D3
    CMP.B   D3,D2
    BEQ.S   LAB_0E99

    MOVEQ   #13,D3
    CMP.B   D3,D2
    BNE.S   LAB_0E9A

LAB_0E99:
    ADDQ.L  #1,-100(A5)
    BRA.S   LAB_0E98

LAB_0E9A:
    TST.B   D7
    BNE.S   LAB_0E9D

    MOVE.B  0(A0,D0.L),D2
    MOVEQ   #24,D3
    CMP.B   D3,D2
    BEQ.S   LAB_0E9B

    MOVEQ   #25,D4
    CMP.B   D4,D2
    BEQ.S   LAB_0E9B

    MOVEQ   #26,D2
    CMP.B   0(A0,D0.L),D2
    BNE.S   LAB_0E9C

LAB_0E9B:
    MOVE.B  0(A0,D0.L),D7
    ADDQ.L  #1,-100(A5)
    MOVEA.L -10(A5),A1
    MOVE.B  0(A1,D0.L),D6
    BRA.S   LAB_0E98

LAB_0E9C:
    MOVE.L  D4,D7
    MOVEA.L -10(A5),A1
    MOVE.B  0(A1,D0.L),D6
    BRA.S   LAB_0E98

LAB_0E9D:
    MOVE.B  0(A0,D0.L),D2
    MOVEQ   #24,D3
    CMP.B   D3,D2
    BEQ.S   LAB_0E9F

    MOVEQ   #25,D3
    CMP.B   D3,D2
    BEQ.S   LAB_0E9F

    MOVEQ   #26,D2
    CMP.B   0(A0,D0.L),D2
    BNE.S   LAB_0E9E

    BRA.S   LAB_0E9F

LAB_0E9E:
    MOVE.B  0(A0,D0.L),-51(A5,D1.L)
    ADDQ.L  #1,-104(A5)
    ADDQ.L  #1,-100(A5)
    MOVEA.L -10(A5),A0
    MOVE.B  0(A0,D0.L),-91(A5,D1.L)
    BRA.W   LAB_0E98

LAB_0E9F:
    MOVE.L  -104(A5),D0
    CLR.B   -51(A5,D0.L)
    LEA     -51(A5),A0
    MOVEA.L A0,A1

LAB_0EA0:
    TST.B   (A1)+
    BNE.S   LAB_0EA0

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEQ   #40,D1
    SUB.L   D0,D1
    MOVEM.L D1,-120(A5)
    MOVEQ   #24,D0
    CMP.B   D0,D7
    BNE.S   LAB_0EA1

    MOVEQ   #2,D0
    MOVE.L  D0,-104(A5)
    BRA.S   LAB_0EA3

LAB_0EA1:
    MOVEQ   #26,D0
    CMP.B   D0,D7
    BNE.S   LAB_0EA2

    MOVEQ   #1,D0
    MOVE.L  D0,-104(A5)
    BRA.S   LAB_0EA3

LAB_0EA2:
    MOVEQ   #0,D0
    MOVE.L  D0,-104(A5)

LAB_0EA3:
    MOVE.L  -104(A5),D0
    TST.L   D0
    BLE.S   LAB_0EA6

    TST.L   D1
    BLE.S   LAB_0EA6

    CLR.L   -108(A5)

LAB_0EA4:
    MOVE.L  -120(A5),D0
    MOVE.L  -104(A5),D1
    JSR     JMPTBL_LAB_1A07_3(PC)

    MOVE.L  -108(A5),D1
    CMP.L   D0,D1
    BGE.S   LAB_0EA5

    MOVE.L  -112(A5),D0
    MOVE.B  #$20,0(A3,D0.L)
    MOVE.B  D6,0(A2,D0.L)
    ADDQ.L  #1,-108(A5)
    ADDQ.L  #1,-112(A5)
    BRA.S   LAB_0EA4

LAB_0EA5:
    MOVE.L  -120(A5),D0
    MOVE.L  -104(A5),D1
    JSR     JMPTBL_LAB_1A07_3(PC)

    SUB.L   D0,-120(A5)

LAB_0EA6:
    CLR.L   -108(A5)

LAB_0EA7:
    MOVE.L  -108(A5),D0
    TST.B   -51(A5,D0.L)
    BEQ.S   LAB_0EA8

    MOVE.L  -112(A5),D1
    MOVE.B  -51(A5,D0.L),0(A3,D1.L)
    MOVE.B  -91(A5,D0.L),0(A2,D1.L)
    ADDQ.L  #1,-108(A5)
    ADDQ.L  #1,-112(A5)
    BRA.S   LAB_0EA7

LAB_0EA8:
    MOVE.L  -120(A5),D0
    TST.L   D0
    BLE.S   LAB_0EAA

    CLR.L   -108(A5)

LAB_0EA9:
    MOVE.L  -108(A5),D0
    CMP.L   -120(A5),D0
    BGE.S   LAB_0EAA

    MOVE.L  -112(A5),D0
    MOVE.B  #$20,0(A3,D0.L)
    MOVE.B  D6,0(A2,D0.L)
    ADDQ.L  #1,-108(A5)
    ADDQ.L  #1,-112(A5)
    BRA.S   LAB_0EA9

LAB_0EAA:
    ADDQ.L  #1,D5
    CLR.L   -104(A5)
    MOVEQ   #0,D7
    BRA.W   LAB_0E97

LAB_0EAB:
    MOVE.L  -112(A5),D0
    CLR.B   0(A3,D0.L)

LAB_0EAC:
    TST.L   -6(A5)
    BEQ.S   LAB_0EAD

    MOVE.L  -116(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -6(A5),-(A7)
    PEA     1146.W
    PEA     GLOB_STR_LADFUNC_C_22
    JSR     GROUPC_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

LAB_0EAD:
    TST.L   -10(A5)
    BEQ.S   LAB_0EAE

    MOVE.L  -116(A5),-(A7)
    MOVE.L  -10(A5),-(A7)
    PEA     1148.W
    PEA     GLOB_STR_LADFUNC_C_23
    JSR     GROUPC_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

LAB_0EAE:
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_0EAF:
    LINK.W  A5,#-4
    MOVEM.L D6-D7/A2-A3/A6,-(A7)
    MOVE.L  32(A7),D7
    MOVEA.L 36(A7),A3
    MOVEA.L 40(A7),A2
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    TST.L   6(A1)
    BNE.S   LAB_0EB4

    MOVE.L  LAB_21FB,D0
    MOVEQ   #40,D1
    JSR     GROUPC_JMPTBL_LAB_1A06(PC)

    MOVEQ   #32,D1
    MOVEA.L A3,A0
    BRA.S   LAB_0EB1

LAB_0EB0:
    MOVE.B  D1,(A0)+

LAB_0EB1:
    SUBQ.L  #1,D0
    BCC.S   LAB_0EB0

    MOVE.L  LAB_21FB,D0
    MOVEQ   #40,D1
    JSR     GROUPC_JMPTBL_LAB_1A06(PC)

    CLR.B   0(A3,D0.L)
    PEA     1.W
    PEA     2.W
    BSR.W   LAB_0EE5

    ADDQ.W  #8,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  LAB_21FB,D0
    MOVE.L  D1,20(A7)
    MOVEQ   #40,D1
    JSR     GROUPC_JMPTBL_LAB_1A06(PC)

    MOVE.L  20(A7),D1
    MOVEA.L A2,A0
    BRA.S   LAB_0EB3

LAB_0EB2:
    MOVE.B  D1,(A0)+

LAB_0EB3:
    SUBQ.L  #1,D0
    BCC.S   LAB_0EB2

    BRA.S   LAB_0EB9

LAB_0EB4:
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEA.L 6(A1),A0
    MOVEA.L A3,A6

LAB_0EB5:
    MOVE.B  (A0)+,(A6)+
    BNE.S   LAB_0EB5

    MOVEA.L A3,A0

LAB_0EB6:
    TST.B   (A0)+
    BNE.S   LAB_0EB6

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D6
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  D6,D0
    MOVEA.L 10(A1),A0
    MOVEA.L A2,A6
    BRA.S   LAB_0EB8

LAB_0EB7:
    MOVE.B  (A0)+,(A6)+

LAB_0EB8:
    SUBQ.L  #1,D0
    BCC.S   LAB_0EB7

    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0E92

    ADDQ.W  #8,A7

LAB_0EB9:
    MOVEM.L (A7)+,D6-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

LAB_0EBA:
    LINK.W  A5,#-108
    MOVEM.L D2-D3/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEA.L A3,A0

LAB_0EBB:
    TST.B   (A0)+
    BNE.S   LAB_0EBB

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D0
    MOVE.L  D0,-108(A5)
    ADDQ.L  #1,D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     1214.W
    PEA     GLOB_STR_LADFUNC_C_24
    JSR     GROUPC_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    MOVE.L  -108(A5),-(A7)
    PEA     1215.W
    PEA     GLOB_STR_LADFUNC_C_25
    MOVE.L  D0,-6(A5)
    JSR     GROUPC_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     28(A7),A7
    MOVE.L  D0,-10(A5)
    TST.L   -6(A5)
    BEQ.W   LAB_0ED8

    TST.L   D0
    BEQ.W   LAB_0ED8

    MOVEA.L A3,A0
    MOVEA.L -6(A5),A1

LAB_0EBC:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_0EBC

    MOVE.L  -108(A5),D0
    MOVEA.L A2,A0
    MOVEA.L -10(A5),A1
    BRA.S   LAB_0EBE

LAB_0EBD:
    MOVE.B  (A0)+,(A1)+

LAB_0EBE:
    SUBQ.L  #1,D0
    BCC.S   LAB_0EBD

    MOVEQ   #0,D0
    MOVE.L  D0,D5
    MOVE.L  D0,-104(A5)

LAB_0EBF:
    CMP.L   LAB_21FB,D5
    BGE.W   LAB_0ED7

    MOVE.L  D5,D0
    MOVEQ   #40,D1
    JSR     GROUPC_JMPTBL_LAB_1A06(PC)

    MOVEA.L -6(A5),A0
    ADDA.L  D0,A0
    PEA     40.W
    MOVE.L  A0,-(A7)
    PEA     -51(A5)
    JSR     LAB_0EF2(PC)

    LEA     12(A7),A7
    CLR.B   -11(A5)
    LEA     -51(A5),A0
    MOVEA.L A0,A1

LAB_0EC0:
    TST.B   (A1)+
    BNE.S   LAB_0EC0

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  D5,D0
    MOVEQ   #40,D1
    JSR     GROUPC_JMPTBL_LAB_1A06(PC)

    MOVEA.L -10(A5),A0
    ADDA.L  D0,A0
    MOVE.L  A1,-100(A5)
    MOVE.L  A1,D0
    LEA     -91(A5),A1
    BRA.S   LAB_0EC2

LAB_0EC1:
    MOVE.B  (A0)+,(A1)+

LAB_0EC2:
    SUBQ.L  #1,D0
    BCC.S   LAB_0EC1

    MOVE.L  -100(A5),D0
    MOVEQ   #40,D1
    CMP.L   D1,D0
    BGE.S   LAB_0EC7

    LEA     -51(A5),A0
    ADDA.L  D0,A0
    SUB.L   D0,D1
    MOVEQ   #32,D0
    BRA.S   LAB_0EC4

LAB_0EC3:
    MOVE.B  D0,(A0)+

LAB_0EC4:
    SUBQ.L  #1,D1
    BCC.S   LAB_0EC3

    LEA     -91(A5),A0
    MOVE.L  -100(A5),D0
    ADDA.L  D0,A0
    MOVEQ   #0,D1
    MOVE.B  -92(A5,D0.L),D1
    MOVEQ   #40,D2
    SUB.L   D0,D2
    BRA.S   LAB_0EC6

LAB_0EC5:
    MOVE.B  D1,(A0)+

LAB_0EC6:
    SUBQ.L  #1,D2
    BCC.S   LAB_0EC5

LAB_0EC7:
    MOVE.B  -51(A5),D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BNE.S   LAB_0EC9

    MOVE.B  -12(A5),D0
    CMP.B   D1,D0
    BNE.S   LAB_0EC8

    MOVEQ   #24,D7
    BRA.S   LAB_0ECA

LAB_0EC8:
    MOVEQ   #26,D7
    BRA.S   LAB_0ECA

LAB_0EC9:
    MOVEQ   #25,D7

LAB_0ECA:
    MOVE.B  D7,D0
    EXT.W   D0
    SUBI.W  #$18,D0
    BEQ.S   LAB_0ECB

    SUBQ.W  #1,D0
    BEQ.W   LAB_0ECE

    SUBQ.W  #1,D0
    BEQ.W   LAB_0ED1

    BRA.W   LAB_0ED4

LAB_0ECB:
    MOVE.B  -91(A5),D6
    CLR.L   -100(A5)

LAB_0ECC:
    MOVE.L  -100(A5),D0
    MOVEQ   #20,D1
    CMP.L   D1,D0
    BGE.S   LAB_0ECD

    MOVEQ   #32,D1
    CMP.B   -51(A5,D0.L),D1
    BNE.S   LAB_0ECD

    MOVEQ   #39,D2
    MOVE.L  D2,D3
    SUB.L   D0,D3
    CMP.B   -51(A5,D3.L),D1
    BNE.S   LAB_0ECD

    MOVE.B  -91(A5,D0.L),D1
    CMP.B   D6,D1
    BNE.S   LAB_0ECD

    SUB.L   D0,D2
    MOVE.B  -91(A5,D2.L),D0
    CMP.B   D6,D0
    BNE.S   LAB_0ECD

    ADDQ.L  #1,-100(A5)
    BRA.S   LAB_0ECC

LAB_0ECD:
    MOVE.L  -100(A5),D0
    TST.L   D0
    BLE.W   LAB_0ED4

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
    JSR     LAB_0EEF(PC)

    LEA     -91(A5),A0
    MOVE.L  -100(A5),D0
    ADDA.L  D0,A0
    ADD.L   D0,D0
    MOVEQ   #40,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    PEA     -91(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_0EEF(PC)

    LEA     20(A7),A7
    BRA.W   LAB_0ED4

LAB_0ECE:
    MOVE.B  -52(A5),D6
    CLR.L   -100(A5)

LAB_0ECF:
    MOVE.L  -100(A5),D0
    MOVEQ   #40,D1
    CMP.L   D1,D0
    BGE.S   LAB_0ED0

    MOVEQ   #39,D1
    SUB.L   D0,D1
    MOVEQ   #32,D0
    CMP.B   -51(A5,D1.L),D0
    BNE.S   LAB_0ED0

    MOVE.B  -91(A5,D1.L),D0
    CMP.B   D6,D0
    BNE.S   LAB_0ED0

    ADDQ.L  #1,-100(A5)
    BRA.S   LAB_0ECF

LAB_0ED0:
    MOVE.L  -100(A5),D0
    TST.L   D0
    BLE.S   LAB_0ED4

    MOVEQ   #40,D1
    SUB.L   D0,D1
    CLR.B   -51(A5,D1.L)
    BRA.S   LAB_0ED4

LAB_0ED1:
    MOVE.B  -91(A5),D6
    CLR.L   -100(A5)

LAB_0ED2:
    MOVE.L  -100(A5),D0
    MOVEQ   #40,D1
    CMP.L   D1,D0
    BGE.S   LAB_0ED3

    MOVEQ   #32,D1
    CMP.B   -51(A5,D0.L),D1
    BNE.S   LAB_0ED3

    MOVE.B  -91(A5,D0.L),D0
    CMP.B   D6,D0
    BNE.S   LAB_0ED3

    ADDQ.L  #1,-100(A5)
    BRA.S   LAB_0ED2

LAB_0ED3:
    MOVE.L  -100(A5),D0
    TST.L   D0
    BLE.S   LAB_0ED4

    LEA     -51(A5),A0
    ADDA.L  D0,A0
    MOVEQ   #40,D1
    SUB.L   D0,D1
    ADDQ.L  #1,D1
    MOVE.L  D1,-(A7)
    PEA     -51(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_0EEF(PC)

    LEA     -91(A5),A0
    MOVE.L  -100(A5),D0
    ADDA.L  D0,A0
    MOVEQ   #40,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    PEA     -91(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_0EEF(PC)

    LEA     20(A7),A7

LAB_0ED4:
    MOVE.L  -104(A5),D0
    MOVE.B  D7,0(A3,D0.L)
    ADDQ.L  #1,-104(A5)
    MOVE.B  D6,0(A2,D0.L)
    CLR.L   -100(A5)

LAB_0ED5:
    MOVE.L  -100(A5),D0
    TST.B   -51(A5,D0.L)
    BEQ.S   LAB_0ED6

    MOVE.L  -104(A5),D1
    MOVE.B  -51(A5,D0.L),0(A3,D1.L)
    ADDQ.L  #1,-104(A5)
    MOVE.B  -91(A5,D0.L),0(A2,D1.L)
    ADDQ.L  #1,-100(A5)
    BRA.S   LAB_0ED5

LAB_0ED6:
    ADDQ.L  #1,D5
    BRA.W   LAB_0EBF

LAB_0ED7:
    MOVE.L  -104(A5),D0
    CLR.B   0(A3,D0.L)

LAB_0ED8:
    TST.L   -6(A5)
    BEQ.S   LAB_0ED9

    MOVE.L  -108(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -6(A5),-(A7)
    PEA     1322.W
    PEA     GLOB_STR_LADFUNC_C_26
    JSR     GROUPC_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

LAB_0ED9:
    TST.L   -10(A5)
    BEQ.S   LAB_0EDA

    MOVE.L  -108(A5),-(A7)
    MOVE.L  -10(A5),-(A7)
    PEA     1324.W
    PEA     GLOB_STR_LADFUNC_C_27
    JSR     GROUPC_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

LAB_0EDA:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_0EDB:
    LINK.W  A5,#-8
    MOVEM.L D6-D7/A2-A3/A6,-(A7)
    MOVE.L  36(A7),D7
    MOVEA.L 40(A7),A3
    MOVEA.L 44(A7),A2
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0EBA

    ADDQ.W  #8,A7
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   (A1)
    BNE.S   LAB_0EDC

    ADDA.L  D0,A0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     14.W
    PEA     1362.W
    PEA     GLOB_STR_LADFUNC_C_28
    MOVE.L  A0,36(A7)
    JSR     GROUPC_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L 20(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   (A1)
    BEQ.S   LAB_0EDC

    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A6
    MOVEQ   #0,D1
    MOVE.W  D1,(A6)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A6
    MOVE.W  D1,2(A6)

LAB_0EDC:
    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   (A1)
    BEQ.W   LAB_0EE4

    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A6
    TST.L   6(A6)
    BEQ.S   LAB_0EDE

    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEA.L 6(A1),A0

LAB_0EDD:
    TST.B   (A0)+
    BNE.S   LAB_0EDD

    SUBQ.L  #1,A0
    SUBA.L  6(A1),A0
    MOVE.L  A0,D6
    BRA.S   LAB_0EDF

LAB_0EDE:
    MOVEQ   #0,D6

LAB_0EDF:
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A6
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  6(A1),-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A6,32(A7)
    JSR     LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVEA.L 24(A7),A0
    MOVE.L  D0,6(A0)
    TST.L   D6
    BEQ.S   LAB_0EE0

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A6
    TST.L   10(A6)
    BEQ.S   LAB_0EE0

    MOVE.L  D7,D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  D6,-(A7)
    MOVE.L  10(A1),-(A7)
    PEA     1386.W
    PEA     GLOB_STR_LADFUNC_C_29
    JSR     GROUPC_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

LAB_0EE0:
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEA.L 6(A1),A0

LAB_0EE1:
    TST.B   (A0)+
    BNE.S   LAB_0EE1

    SUBQ.L  #1,A0
    SUBA.L  6(A1),A0
    MOVE.L  A0,D6
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D6,-(A7)
    PEA     1389.W
    PEA     GLOB_STR_LADFUNC_C_30
    MOVE.L  A1,36(A7)
    JSR     GROUPC_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L 20(A7),A0
    MOVE.L  D0,10(A0)
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A6
    TST.L   10(A6)
    BEQ.S   LAB_0EE4

    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  D6,D0
    MOVEA.L A2,A0
    MOVEA.L 10(A1),A6
    BRA.S   LAB_0EE3

LAB_0EE2:
    MOVE.B  (A0)+,(A6)+

LAB_0EE3:
    SUBQ.L  #1,D0
    BCC.S   LAB_0EE2

LAB_0EE4:
    MOVEM.L (A7)+,D6-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

LAB_0EE5:
    MOVEM.L D2/D6-D7,-(A7)
    MOVE.B  19(A7),D7
    MOVE.B  23(A7),D6
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #15,D1
    AND.L   D1,D0
    ASL.L   #4,D0
    MOVEQ   #0,D2
    MOVE.B  D6,D2
    AND.L   D1,D2
    OR.L    D2,D0
    MOVEM.L (A7)+,D2/D6-D7
    RTS

;!======

LAB_0EE6:
    MOVEM.L D2/D6-D7,-(A7)
    MOVE.B  19(A7),D7
    MOVE.B  23(A7),D6
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #15,D1
    AND.L   D1,D0
    ASL.L   #4,D0
    MOVEQ   #0,D2
    MOVE.B  D6,D2
    AND.L   D1,D2
    OR.L    D2,D0
    MOVEM.L (A7)+,D2/D6-D7
    RTS

;!======

LAB_0EE7:
    MOVEM.L D2/D6-D7,-(A7)
    MOVE.B  19(A7),D7
    MOVE.B  23(A7),D6
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #120,D1
    ADD.L   D1,D1
    AND.L   D1,D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    MOVEQ   #15,D2
    AND.L   D2,D1
    OR.L    D1,D0
    MOVEM.L (A7)+,D2/D6-D7
    RTS

;!======

LAB_0EE8:
    MOVE.L  D7,-(A7)
    MOVE.B  11(A7),D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    ASR.L   #4,D0
    MOVEQ   #15,D1
    AND.L   D1,D0
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_0EE9:
    MOVE.L  D7,-(A7)
    MOVE.B  11(A7),D7
    MOVE.L  D7,D0
    ANDI.B  #$f,D0
    MOVE.L  (A7)+,D7
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000

;!======

LAB_0EEA:
    JMP     LAB_183E

LAB_0EEB:
    JMP     LAB_0552

LAB_0EEC:
    JMP     LAB_0A48

LAB_0EED:
    JMP     LAB_0A49

JMPTBL_DISPLAY_TEXT_AT_POSITION_3:
    JMP     DISPLAY_TEXT_AT_POSITION

LAB_0EEF:
    JMP     LAB_1AAE

JMPTBL_PRINTF_3:
    JMP     WDISP_SPrintf

LAB_0EF1:
    JMP     ESQ_SetCopperEffect_OffDisableHighlight

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000
