;!======

LAB_0FA4:
    TST.W   LAB_1FFE
    BNE.W   LAB_0FA6

    MOVE.W  #1,LAB_1FFE
    JSR     LAB_1333(PC)

    JSR     LAB_1026(PC)

    JSR     LAB_1240(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     100.W
    PEA     99.W
    PEA     GLOB_STR_NEWGRID_C_1
    JSR     JMP_TBL_ALLOCATE_MEMORY_3(PC)

    LEA     16(A7),A7
    MOVE.L  D0,GLOB_REF_GRID_RASTPORT_MAYBE_1
    TST.L   D0
    BEQ.W   LAB_0FA6

    MOVEA.L D0,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitRastPort(A6)

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A0
    MOVE.L  #GLOB_REF_696_400_BITMAP,4(A0)
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     100.W
    PEA     112.W
    PEA     GLOB_STR_NEWGRID_C_2
    JSR     JMP_TBL_ALLOCATE_MEMORY_3(PC)

    LEA     16(A7),A7
    MOVE.L  D0,GLOB_REF_GRID_RASTPORT_MAYBE_2
    TST.L   D0
    BEQ.W   LAB_0FA6

    MOVEA.L D0,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitRastPort(A6)

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_2,A0
    MOVE.L  #LAB_221F,4(A0)
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_2,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_2,A1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    BSR.W   DRAW_FILLED_RECT_0_0_TO_695_1_PEN_7

    MOVEQ   #8,D0
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    LEA     GLOB_STR_44_44_44,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.W  D0,LAB_2329
    ADDI.W  #12,D0
    MOVE.W  D0,LAB_232A
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  #624,D0
    SUB.L   D1,D0
    MOVEQ   #3,D1
    JSR     JMP_TBL_LAB_1A07_3(PC)

    MOVE.W  D0,LAB_232B
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D0
    MOVE.W  20(A0),D0
    SUBQ.L  #1,D0
    ADD.L   D0,D0
    ADDQ.L  #8,D0
    MOVE.W  D0,LAB_2328
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,D0
    MOVEQ   #2,D1
    JSR     JMP_TBL_LAB_1A07_3(PC)

    TST.L   D1
    BEQ.S   LAB_0FA5

    MOVE.W  LAB_2328,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,LAB_2328

LAB_0FA5:
    BSR.W   DRAW_FILLED_RECT_0_0_TO_695_1_PEN_7

LAB_0FA6:
    RTS

;!======

LAB_0FA7:
    TST.L   GLOB_REF_GRID_RASTPORT_MAYBE_1
    BEQ.S   LAB_0FA8

    PEA     100.W
    MOVE.L  GLOB_REF_GRID_RASTPORT_MAYBE_1,-(A7)
    PEA     148.W
    PEA     GLOB_STR_NEWGRID_C_3
    JSR     JMP_TBL_DEALLOCATE_MEMORY_3(PC)

    LEA     16(A7),A7

LAB_0FA8:
    JSR     LAB_1335(PC)

    JSR     LAB_1023(PC)

    CLR.W   LAB_1FFE
    JSR     LAB_1243(PC)

    RTS

;!======

LAB_0FA9:
    MOVEM.L D2-D3,-(A7)

    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    JSR     LAB_0DD5(PC)

    MOVEA.L AbsExecBase,A6
    JSR     _LVOEnable(A6)

    TST.L   LAB_225F
    BNE.S   LAB_0FAA

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEQ   #7,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    ; Draw a filled rect from 0,68 to 695,267
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEQ   #0,D0
    MOVEQ   #68,D1
    MOVE.L  #695,D2
    MOVE.L  #267,D3
    JSR     _LVORectFill(A6)

LAB_0FAA:
    MOVEM.L (A7)+,D2-D3
    RTS

;!======

LAB_0FAB:
    MOVEM.L D6-D7,-(A7)
    MOVE.L  12(A7),D7

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   .LAB_0FAC

    TST.B   LAB_222E
    BEQ.S   .LAB_0FAD

    MOVE.W  LAB_222F,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .LAB_0FAD

.LAB_0FAC:
    TST.B   LAB_224A
    BEQ.S   .LAB_0FAD

    MOVE.W  LAB_2231,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .LAB_0FAD

    MOVEQ   #0,D0
    BRA.S   .return

.LAB_0FAD:
    MOVEQ   #1,D0

.return:
    MOVE.L  D0,D6
    MOVE.L  D6,D0

    MOVEM.L (A7)+,D6-D7
    RTS

;!======

LAB_0FAF:
    LINK.W  A5,#-40
    MOVEM.L D5-D7,-(A7)
    MOVEQ   #0,D5
    LEA     LAB_200B,A0
    LEA     -38(A5),A1
    MOVEQ   #6,D0

.LAB_0FB0:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.LAB_0FB0
    MOVE.B  LAB_1BB7,D0
    MOVEQ   #'Y',D1
    CMP.B   D1,D0
    BNE.S   .LAB_0FB3

    MOVE.L  LAB_1BBE,D0
    TST.L   D0
    BLE.S   .LAB_0FB2

    MOVE.L  LAB_2003,D1
    TST.L   D1
    BGT.S   .LAB_0FB1

    MOVE.L  LAB_200A,D7
    MOVE.L  D0,LAB_2003
    BRA.S   .LAB_0FB3

.LAB_0FB1:
    SUBQ.L  #1,LAB_2003
    MOVEQ   #12,D6
    MOVEQ   #1,D5
    BRA.S   .LAB_0FB3

.LAB_0FB2:
    MOVEQ   #12,D6
    MOVEQ   #1,D5

.LAB_0FB3:
    TST.W   D5
    BNE.W   .return

    MOVE.L  LAB_200A,D0
    ASL.L   #2,D0
    MOVE.L  -38(A5,D0.L),D6
    MOVEQ   #12,D0
    CMP.L   D0,D6
    BNE.S   .LAB_0FB4

    MOVEQ   #0,D0
    MOVE.L  D0,LAB_200A
    BRA.S   .LAB_0FB5

.LAB_0FB4:
    ADDQ.L  #1,LAB_200A

.LAB_0FB5:
    MOVE.B  LAB_1BB7,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .LAB_0FB9

    MOVE.L  D6,D0
    SUBQ.L  #5,D0
    BLT.W   .LAB_0FB8

    CMPI.L  #$8,D0
    BGE.W   .LAB_0FB8

    ADD.W   D0,D0
    MOVE.W  .LAB_0FB6(PC,D0.W),D0
    JMP     .LAB_0FB6+2(PC,D0.W)

; This is a switch statement that's turned into a jump table.
.LAB_0FB6:
    DC.W    .LAB_0FB6_0044-.LAB_0FB6-2
    DC.W    .LAB_0FB6_000E-.LAB_0FB6-2
    DC.W    .LAB_0FB6_0020-.LAB_0FB6-2
    DC.W    .LAB_0FB6_0032-.LAB_0FB6-2
    DC.W    .LAB_0FB6_0056-.LAB_0FB6-2
    DC.W    .LAB_0FB6_0068-.LAB_0FB6-2
    DC.W    .LAB_0FB6_0078-.LAB_0FB6-2
    DC.W    .LAB_0FB6_0078-.LAB_0FB6-2

.LAB_0FB6_000E:
    MOVE.B  LAB_1BA4,D0
    SNE     D1
    NEG.B   D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,D5
    BRA.S   .LAB_0FB8

.LAB_0FB6_0020:
    MOVE.B  LAB_1BA5,D0
    SNE     D1
    NEG.B   D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,D5
    BRA.S   .LAB_0FB8

.LAB_0FB6_0032:
    MOVE.B  LAB_1BAD,D0
    SNE     D1
    NEG.B   D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,D5
    BRA.S   .LAB_0FB8

.LAB_0FB6_0044:
    TST.L   LAB_22D1
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D5
    BRA.S   .LAB_0FB8

.LAB_0FB6_0056:
    TST.L   LAB_22D6
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D5
    BRA.S   .LAB_0FB8

.LAB_0FB6_0068:
    TST.L   LAB_22E5
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D5

.LAB_0FB6_0078:
.LAB_0FB8:
    TST.W   D5
    BNE.W   .LAB_0FB3

    MOVE.L  LAB_200A,D0
    CMP.L   D7,D0
    BNE.W   .LAB_0FB3

    MOVEQ   #12,D6
    MOVEQ   #1,D5
    BRA.W   .LAB_0FB3

.LAB_0FB9:
    MOVE.L  D6,D0
    SUBQ.L  #5,D0
    BLT.W   .LAB_0FB3

    CMPI.L  #$8,D0
    BGE.W   .LAB_0FB3

    ADD.W   D0,D0
    MOVE.W  .LAB_0FBA(PC,D0.W),D0
    JMP     .LAB_0FBA+2(PC,D0.W)

; This is a switch statement that's turned into a jump table.
.LAB_0FBA:
    DC.W    .LAB_0FC2_008C-.LAB_0FBA-2
    DC.W    .LAB_0FBA_000E-.LAB_0FBA-2
    DC.W    .LAB_0FBD_0038-.LAB_0FBA-2
    DC.W    .LAB_0FBF_0062-.LAB_0FBA-2
    DC.W    .LAB_0FC3_00B6-.LAB_0FBA-2
    DC.W    .LAB_0FC5_00E0-.LAB_0FBA-2
    DC.W    .LAB_0FB3-.LAB_0FBA-2
    DC.W    .LAB_0FC7_010A-.LAB_0FBA-2

.LAB_0FBA_000E:
    MOVE.B  (LAB_1BA4).L,D0
    TST.B   D0
    BLE.S   .LAB_0FBC

    SUBQ.B  #1,LAB_2005
    BGT.S   .LAB_0FBC

    MOVEQ   #1,D1
    BRA.S   .LAB_0FBD

.LAB_0FBC:
    MOVEQ   #0,D1

.LAB_0FBD:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .LAB_0FB3

    MOVE.B  D0,LAB_2005
    BRA.W   .LAB_0FB3

.LAB_0FBD_0038:
    MOVE.B  LAB_1BA5,D0
    TST.B   D0
    BLE.S   .LAB_0FBE

    SUBQ.B  #1,LAB_2004
    BGT.S   .LAB_0FBE

    MOVEQ   #1,D1
    BRA.S   .LAB_0FBF

.LAB_0FBE:
    MOVEQ   #0,D1

.LAB_0FBF:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .LAB_0FB3

    MOVE.B  D0,LAB_2004
    BRA.W   .LAB_0FB3

.LAB_0FBF_0062:
    MOVE.B  LAB_1BAD,D0
    TST.B   D0
    BLE.S   .LAB_0FC0

    SUBQ.B  #1,LAB_2006
    BGT.S   .LAB_0FC0

    MOVEQ   #1,D1
    BRA.S   .LAB_0FC1

.LAB_0FC0:
    MOVEQ   #0,D1

.LAB_0FC1:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .LAB_0FB3

    MOVE.B  D0,LAB_2006
    BRA.W   .LAB_0FB3

.LAB_0FC2_008C:
    MOVE.L  LAB_22D1,D0
    TST.L   D0
    BLE.S   .LAB_0FC2

    SUBQ.B  #1,LAB_2007
    BGT.S   .LAB_0FC2

    MOVEQ   #1,D1
    BRA.S   .LAB_0FC3

.LAB_0FC2:
    MOVEQ   #0,D1

.LAB_0FC3:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .LAB_0FB3

    MOVE.B  D0,LAB_2007
    BRA.W   .LAB_0FB3

.LAB_0FC3_00B6:
    MOVE.L  LAB_22D6,D0
    TST.L   D0
    BLE.S   .LAB_0FC4

    SUBQ.B  #1,LAB_2008
    BGT.S   .LAB_0FC4

    MOVEQ   #1,D1
    BRA.S   .LAB_0FC5

.LAB_0FC4:
    MOVEQ   #0,D1

.LAB_0FC5:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .LAB_0FB3

    MOVE.B  D0,LAB_2008
    BRA.W   .LAB_0FB3

.LAB_0FC5_00E0:
    MOVE.L  LAB_22E5,D0
    TST.L   D0
    BLE.S   .LAB_0FC6

    SUBQ.B  #1,LAB_2009
    BGT.S   .LAB_0FC6

    MOVEQ   #1,D1
    BRA.S   .LAB_0FC7

.LAB_0FC6:
    MOVEQ   #0,D1

.LAB_0FC7:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .LAB_0FB3

    MOVE.B  D0,LAB_2009
    BRA.W   .LAB_0FB3

.LAB_0FC7_010A:
    MOVEQ   #1,D5
    BRA.W   .LAB_0FB3

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D5-D7
    UNLK    A5
    RTS

;!======

LAB_0FC9:
    MOVEM.L D6-D7,-(A7)
    MOVE.L  12(A7),D7
    MOVE.W  18(A7),D6
    MOVE.L  D7,D0
    CMPI.L  #$d,D0
    BCC.S   LAB_0FCF

    ADD.W   D0,D0
    MOVE.W  LAB_0FCA(PC,D0.W),D0
    JMP     LAB_0FCA+2(PC,D0.W)

; This is a switch statement that's turned into a jump table.
LAB_0FCA:
    DC.W    LAB_0FCA_0018-LAB_0FCA-2
    DC.W    LAB_0FCA_001C-LAB_0FCA-2
    DC.W    LAB_0FCA_0020-LAB_0FCA-2
    DC.W    LAB_0FCA_0024-LAB_0FCA-2
    DC.W    LAB_0FCA_003E-LAB_0FCA-2
    DC.W    LAB_0FCA_0050-LAB_0FCA-2
    DC.W    LAB_0FCA_0050-LAB_0FCA-2
    DC.W    LAB_0FCA_0050-LAB_0FCA-2
    DC.W    LAB_0FCA_0050-LAB_0FCA-2
    DC.W    LAB_0FCA_0050-LAB_0FCA-2
    DC.W    LAB_0FCA_0050-LAB_0FCA-2
    DC.W    LAB_0FCA_0058-LAB_0FCA-2
    DC.W    LAB_0FCA_0018-LAB_0FCA-2

LAB_0FCA_0018:
    MOVEQ   #1,D7
    BRA.S   LAB_0FD0

LAB_0FCA_001C:
    MOVEQ   #2,D7
    BRA.S   LAB_0FD0

LAB_0FCA_0020:
    MOVEQ   #3,D7
    BRA.S   LAB_0FD0

LAB_0FCA_0024:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0FAB

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   LAB_0FCC

    MOVEQ   #11,D0
    BRA.S   LAB_0FCD

LAB_0FCC:
    MOVEQ   #4,D0

LAB_0FCD:
    MOVE.L  D0,D7
    BRA.S   LAB_0FD0

LAB_0FCA_003E:
    TST.L   LAB_22D2
    BEQ.S   LAB_0FCE

    MOVEQ   #5,D7
    CLR.L   LAB_22D1
    BRA.S   LAB_0FD0

LAB_0FCA_0050:
LAB_0FCE:
    BSR.W   LAB_0FAF

    MOVE.L  D0,D7
    BRA.S   LAB_0FD0

LAB_0FCA_0058:
    MOVEQ   #1,D7
    BRA.S   LAB_0FD0

LAB_0FCF:
    MOVEQ   #0,D7

LAB_0FD0:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

LAB_0FD1:
    LINK.W  A5,#-108
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7

    LEA     60(A3),A0
    MOVE.L  A0,-102(A5)

    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_102F(PC)

    MOVEA.L -102(A5),A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L -102(A5),A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVE.L  #695,D2
    MOVEQ   #33,D3
    JSR     _LVORectFill(A6)

    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVE.L  D3,(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -102(A5),-(A7)
    JSR     LAB_133D(PC)

    LEA     28(A7),A7
    MOVEQ   #0,D6

LAB_0FD2:
    MOVEQ   #3,D0
    CMP.L   D0,D6
    BGE.W   LAB_0FDB

    MOVE.L  D7,D0
    ADD.L   D6,D0
    MOVEQ   #48,D1
    CMP.L   D1,D0
    BLE.S   LAB_0FD3

    SUB.L   D1,D0
    BRA.S   LAB_0FD4

LAB_0FD3:
    MOVE.L  D7,D0
    ADD.L   D6,D0

LAB_0FD4:
    MOVE.L  D0,D5
    PEA     -97(A5)
    MOVE.L  D5,-(A7)
    JSR     LAB_1348(PC)

    ADDQ.W  #8,A7
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_232B,D1
    MOVE.L  D0,28(A7)
    MOVE.L  D6,D0
    JSR     JMP_TBL_LAB_1A06_6(PC)

    MOVE.L  28(A7),D1
    ADD.L   D0,D1
    MOVE.L  D1,D4
    MOVEQ   #36,D0
    ADD.L   D0,D4
    MOVEQ   #2,D0
    CMP.L   D0,D6
    BNE.S   LAB_0FD5

    MOVE.L  #695,D0
    BRA.S   LAB_0FD6

LAB_0FD5:
    MOVEQ   #0,D0
    MOVE.W  LAB_232B,D0
    ADD.L   D4,D0
    SUBQ.L  #1,D0

LAB_0FD6:
    PEA     33.W
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  -102(A5),-(A7)
    MOVE.L  D0,-16(A5)
    JSR     LAB_133D(PC)

    LEA     20(A7),A7

    MOVEA.L -102(A5),A1
    MOVEQ   #3,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    LEA     -97(A5),A0
    MOVEA.L A0,A1

LAB_0FD7:
    TST.B   (A1)+
    BNE.S   LAB_0FD7

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEA.L -102(A5),A1
    JSR     _LVOTextLength(A6)

    MOVEQ   #0,D1
    MOVE.W  LAB_232B,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   LAB_0FD8

    ADDQ.L  #1,D1

LAB_0FD8:
    ASR.L   #1,D1
    ADDQ.L  #2,D1
    ADD.L   D1,D4
    MOVEA.L -102(A5),A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    MOVEQ   #34,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   LAB_0FD9

    ADDQ.L  #1,D1

LAB_0FD9:
    ASR.L   #1,D1
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    ADD.L   D0,D1
    SUBQ.L  #1,D1
    MOVE.L  D4,D0
    JSR     _LVOMove(A6)

    LEA     -97(A5),A0
    MOVEA.L A0,A1

LAB_0FDA:
    TST.B   (A1)+
    BNE.S   LAB_0FDA

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEA.L -102(A5),A1
    JSR     _LVOText(A6)

    ADDQ.L  #1,D6
    BRA.W   LAB_0FD2

LAB_0FDB:
    MOVE.W  #17,52(A3)
    PEA     64.W
    MOVE.L  A3,-(A7)
    JSR     LAB_1038(PC)

    MOVEQ   #0,D0
    MOVE.W  52(A3),D0
    MOVE.L  D0,32(A3)

    MOVEM.L -136(A5),D2-D7/A3
    UNLK    A5
    RTS

;!======

LAB_0FDC:

.rastport   = -108

    LINK.W  A5,#-116
    MOVEM.L D2-D3/D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    LEA     60(A3),A0
    PEA     -100(A5)
    MOVE.L  A0,.rastport(A5)
    JSR     JMP_TBL_GENERATE_GRID_DATE_STRING(PC)

    MOVEA.L .rastport(A5),A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    PEA     7.W
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_102F(PC)

    MOVEA.L .rastport(A5),A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    ; Fill in the blue background for behind the date string
    MOVEA.L .rastport(A5),A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVE.L  #695,D2
    MOVEQ   #33,D3
    JSR     _LVORectFill(A6)

    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVE.L  D3,(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  .rastport(A5),-(A7)
    JSR     LAB_133D(PC)

    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    PEA     33.W
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  .rastport(A5),-(A7)
    JSR     LAB_133D(PC)

    MOVEA.L .rastport(A5),A1
    MOVEQ   #3,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVE.W  LAB_232B,D1
    MULU    #3,D1
    LEA     -100(A5),A0
    MOVEA.L A0,A1

.LAB_0FDD:
    TST.B   (A1)+
    BNE.S   .LAB_0FDD

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  D0,68(A7)
    MOVE.L  D1,72(A7)
    MOVE.L  A1,D0
    MOVEA.L .rastport(A5),A1
    JSR     _LVOTextLength(A6)

    MOVE.L  72(A7),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .LAB_0FDE

    ADDQ.L  #1,D1

.LAB_0FDE:
    ASR.L   #1,D1
    MOVE.L  68(A7),D0
    ADD.L   D1,D0
    MOVE.L  D0,D7
    MOVEQ   #36,D1
    ADD.L   D1,D7
    MOVEA.L .rastport(A5),A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    MOVEQ   #34,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .LAB_0FDF

    ADDQ.L  #1,D1

.LAB_0FDF:
    ASR.L   #1,D1
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    ADD.L   D0,D1
    SUBQ.L  #1,D1
    MOVE.L  D7,D0
    JSR     _LVOMove(A6)

    LEA     -100(A5),A0
    MOVEA.L A0,A1

.LAB_0FE0:
    TST.B   (A1)+
    BNE.S   .LAB_0FE0

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEA.L .rastport(A5),A1
    JSR     _LVOText(A6)

    MOVEQ   #17,D0
    MOVE.W  D0,52(A3)
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,32(A3)

    MOVEM.L -132(A5),D2-D3/D7/A3
    UNLK    A5
    RTS

;!======

LAB_0FE1:
    LINK.W  A5,#-4
    MOVEM.L D2/A2-A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVEQ   #4,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0FF4

    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    LEA     60(A3),A0
    LEA     60(A3),A1
    MOVEA.L GLOB_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION,A2

LAB_0FE2:
    TST.B   (A2)+
    BNE.S   LAB_0FE2

    SUBQ.L  #1,A2
    SUBA.L  GLOB_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION,A2
    MOVE.L  A0,32(A7)
    MOVE.L  A2,D0

    ; Get the length of the Awaiting Listings Data text and subtract it from 624
    MOVEA.L GLOB_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION,A0
    JSR     _LVOTextLength(A6)

    MOVE.L  #624,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .awaitingListingsDataStringLengthIsPositive     ; If it's plus, jump to awaitingListingsDataStringLengthIsPositive

    ADDQ.L  #1,D1                                           ; Add 1, effectively rolling the value over?

.awaitingListingsDataStringLengthIsPositive:
    ASR.L   #1,D1                                           ; Shift D1 right 1
    MOVEQ   #36,D0                                          ; 36 into D0
    ADD.L   D0,D1                                           ; Add D0 (36) into D1
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    SUB.L   D2,D0
    TST.L   D0
    BPL.S   LAB_0FE4

    ADDQ.L  #1,D0

LAB_0FE4:
    ASR.L   #1,D0
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    ADD.L   D2,D0
    SUBQ.L  #1,D0
    PEA     1.W
    MOVE.L  GLOB_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION,-(A7)
    PEA     612.W
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  52(A7),-(A7)
    BSR.W   LAB_0FFB

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,(A7)
    PEA     695.W
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_133D(PC)

    LEA     60(A7),A7
    MOVE.W  LAB_2328,D0
    LSR.W   #1,D0

    MOVE.W  D0,52(A3)
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,32(A3)

    MOVEM.L (A7)+,D2/A2-A3
    UNLK    A5
    RTS

;!======

LAB_0FE5:
    LINK.W  A5,#-28
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3

    MOVEA.L A3,A0
    LEA     -26(A5),A1
    MOVEQ   #4,D0

.LAB_0FE6:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.LAB_0FE6

    MOVE.W  (A0),(A1)
    PEA     -26(A5)
    JSR     LAB_134A(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D7
    MOVE.W  D0,D7
    MOVE.W  -16(A5),D0
    MOVEQ   #50,D1
    CMP.W   D1,D0
    BGE.S   .LAB_0FE7

    MOVEQ   #20,D1
    CMP.W   D1,D0
    BLT.S   .return

    MOVEQ   #29,D1
    CMP.W   D1,D0
    BGT.S   .return

.LAB_0FE7:
    ADDQ.L  #1,D7
    MOVEQ   #48,D0
    CMP.L   D0,D7
    BLE.S   .return

    MOVEQ   #1,D7

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======

LAB_0FE9:
    LINK.W  A5,#-28
    MOVEM.L D2/D7/A3,-(A7)
    MOVEA.L 8(A5),A3

    MOVEA.L A3,A0
    LEA     -26(A5),A1
    MOVEQ   #4,D0

.LAB_0FEA:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.LAB_0FEA

    MOVE.W  (A0),(A1)
    PEA     -26(A5)
    JSR     LAB_134A(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D7
    MOVE.W  D0,D7
    MOVEQ   #60,D0
    MOVE.L  LAB_22D8,D1
    SUB.L   D1,D0
    MOVE.W  -16(A5),D2
    EXT.L   D2
    CMP.L   D0,D2
    BGE.S   .LAB_0FEB

    MOVEQ   #30,D0
    SUB.L   D1,D0
    MOVE.W  -16(A5),D1
    EXT.L   D1
    CMP.L   D0,D1
    BLT.S   .return

    MOVE.W  -16(A5),D0
    MOVEQ   #29,D1
    CMP.W   D1,D0
    BGT.S   .return

.LAB_0FEB:
    ADDQ.L  #1,D7
    MOVEQ   #48,D0
    CMP.L   D0,D7
    BLE.S   .return

    MOVEQ   #1,D7

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D2/D7/A3
    UNLK    A5
    RTS

;!======

LAB_0FED:
    LINK.W  A5,#-28
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3

    MOVEQ   #21,D0
    MOVEA.L A3,A0
    LEA     -22(A5),A1

.LAB_0FEE:
    MOVE.B  (A0)+,(A1)+
    DBF     D0,.LAB_0FEE
    PEA     -22(A5)
    JSR     LAB_1028(PC)

    MOVE.L  D0,D7
    MOVEQ   #0,D0
    MOVE.B  LAB_1DD8,D0
    MOVEQ   #30,D1
    JSR     JMP_TBL_LAB_1A07_3(PC)

    MOVEQ   #60,D0
    JSR     JMP_TBL_LAB_1A06_6(PC)

    SUB.L   D0,D7
    PEA     -22(A5)
    MOVE.L  D7,-(A7)
    JSR     LAB_101F(PC)

    PEA     -22(A5)
    BSR.W   LAB_0FE5

    MOVEM.L -36(A5),D7/A3
    UNLK    A5
    RTS

;!======

LAB_0FEF:
    LINK.W  A5,#-28
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3

    MOVEQ   #21,D0
    MOVEA.L A3,A0
    LEA     -22(A5),A1

.LAB_0FF0:
    MOVE.B  (A0)+,(A1)+
    DBF     D0,.LAB_0FF0

    PEA     -22(A5)
    JSR     LAB_1028(PC)

    MOVE.L  D0,D7
    MOVEQ   #0,D0
    MOVE.B  LAB_1DD8,D0
    MOVEQ   #30,D1
    JSR     JMP_TBL_LAB_1A07_3(PC)

    MOVEQ   #60,D0
    JSR     JMP_TBL_LAB_1A06_6(PC)

    SUB.L   D0,D7
    PEA     -22(A5)
    MOVE.L  D7,-(A7)
    JSR     LAB_101F(PC)

    PEA     -22(A5)
    BSR.W   LAB_0FE9

    MOVEM.L -36(A5),D7/A3
    UNLK    A5
    RTS

;!======

; This is clearly a re-usable subroutine to draw a rectangle
DRAW_FILLED_RECT_0_0_TO_695_1_PEN_7:
    MOVEM.L D2-D3,-(A7)

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_2,A1
    MOVEQ   #7,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    ; Draw a filled rect from 0,0 to 695,1
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_2,A1
    MOVEQ   #0,D0               ; x.min = 0
    MOVE.L  D0,D1               ; y.min = 0
    MOVE.L  #695,D2             ; x.max = 695
    MOVEQ   #1,D3               ; y.max = 1
    JSR     _LVORectFill(A6)

    MOVEM.L (A7)+,D2-D3
    RTS

;!======

; This is clearly a re-usable subroutine to draw a few rectangles given
; it's preserving some registers.
LAB_0FF2:
    MOVEM.L D2-D3/D5-D7/A3,-(A7)

    SetOffsetForStack 6

    MOVEA.L .stackOffsetBytes+4(A7),A3
    MOVE.L  .stackOffsetBytes+8(A7),D7
    MOVE.L  .stackOffsetBytes+12(A7),D6
    MOVE.L  .stackOffsetBytes+16(A7),D5

    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVEA.L A3,A1
    MOVE.L  D0,D2
    MOVE.L  D5,D3
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    JSR     _LVORectFill(A6)

    MOVEA.L A3,A1
    MOVE.L  D6,D0
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    MOVEA.L A3,A1
    MOVEQ   #0,D1
    MOVE.L  #695,D2
    JSR     _LVORectFill(A6)

    MOVEM.L (A7)+,D2-D3/D5-D7/A3
    RTS

;!======

LAB_0FF3:
    PEA     1.W
    MOVEQ   #6,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  GLOB_REF_GRID_RASTPORT_MAYBE_2,-(A7)
    BSR.S   LAB_0FF2

    LEA     16(A7),A7
    RTS

;!======

LAB_0FF4:
    LINK.W  A5,#-8
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  16(A5),D7
    MOVE.L  20(A5),D6
    MOVE.L  24(A5),D5

    LEA     60(A3),A0
    MOVE.L  D7,-(A7)
    PEA     -1.W
    MOVE.L  A3,-(A7)
    MOVE.L  A0,28(A7)
    JSR     LAB_102F(PC)

    MOVE.L  D6,(A7)
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D0,40(A7)
    JSR     LAB_102F(PC)

    MOVE.L  D5,(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  44(A7),-(A7)
    MOVE.L  44(A7),-(A7)
    BSR.W   LAB_0FF2

    MOVEM.L -24(A5),D5-D7/A3
    UNLK    A5
    RTS

;!======

LAB_0FF5:
    LINK.W  A5,#-12
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D7
    MOVE.L  A3,D0
    BEQ.S   LAB_0FFA

    LEA     19(A3),A0
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-12(A5)
    JSR     LAB_134B(PC)

    LEA     1(A3),A0
    MOVE.L  A0,(A7)
    MOVE.L  D0,-12(A5)
    MOVE.L  A0,-8(A5)
    JSR     LAB_134B(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,-8(A5)
    TST.L   -12(A5)
    BEQ.S   LAB_0FF6

    MOVEA.L -12(A5),A0
    TST.B   (A0)
    BNE.S   LAB_0FF8

LAB_0FF6:
    TST.L   D0
    BEQ.S   LAB_0FF7

    MOVEA.L D0,A0
    TST.B   (A0)
    BNE.S   LAB_0FF8

LAB_0FF7:
    BTST    #5,27(A3)
    BEQ.S   LAB_0FF8

    MOVEQ   #1,D0
    BRA.S   LAB_0FF9

LAB_0FF8:
    MOVEQ   #0,D0

LAB_0FF9:
    MOVE.L  D0,D7

LAB_0FFA:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======

LAB_0FFB:
    LINK.W  A5,#-80
    MOVEM.L D5-D7/A2-A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    MOVE.L  20(A5),D5
    MOVEA.L 24(A5),A2

    MOVEQ   #0,D0
    MOVE.L  D0,-16(A5)
    MOVE.L  D0,-12(A5)
    MOVE.L  A2,D0
    BEQ.S   .LAB_0FFC

    MOVE.L  A2,-(A7)
    JSR     LAB_134B(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,-20(A5)
    BRA.S   .LAB_0FFD

.LAB_0FFC:
    SUBA.L  A0,A0
    MOVE.L  A0,-20(A5)

.LAB_0FFD:
    MOVE.L  -20(A5),-24(A5)
    MOVEA.L A3,A1

    ; Get the width of a single space
    LEA     GLOB_STR_SINGLE_SPACE,A0
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,-8(A5)
    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    JSR     _LVOMove(A6)

.LAB_0FFE:
    TST.L   -20(A5)
    BEQ.W   .return

    PEA     LAB_200D
    PEA     50.W
    PEA     -74(A5)
    MOVE.L  -20(A5),-(A7)
    JSR     LAB_1029(PC)

    MOVE.L  D0,(A7)
    MOVE.L  D0,-20(A5)
    JSR     LAB_134B(PC)

    LEA     16(A7),A7
    MOVE.B  -74(A5),D1
    MOVE.L  D0,-20(A5)
    TST.B   D1
    BNE.S   .LAB_0FFF

    MOVEQ   #0,D0
    BRA.W   .return

.LAB_0FFF:
    LEA     -74(A5),A0
    MOVEA.L A0,A1

.LAB_1000:
    TST.B   (A1)+
    BNE.S   .LAB_1000

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,20(A7)
    MOVEA.L A3,A1
    MOVE.L  20(A7),D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D5,D1
    SUB.L   -12(A5),D1
    MOVE.L  D0,-4(A5)
    CMP.L   D1,D0
    BGT.S   .LAB_1003

    TST.L   28(A5)
    BEQ.S   .LAB_1002

    LEA     -74(A5),A0
    MOVEA.L A0,A1

.LAB_1001:
    TST.B   (A1)+
    BNE.S   .LAB_1001

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,20(A7)
    MOVEA.L A3,A1
    MOVE.L  20(A7),D0
    JSR     _LVOText(A6)

.LAB_1002:
    MOVE.L  -4(A5),D0
    ADD.L   D0,-12(A5)
    MOVE.L  -20(A5),-24(A5)
    BRA.S   .LAB_1009

.LAB_1003:
    CMP.L   D5,D0
    BLE.S   .LAB_1008

    LEA     -74(A5),A0
    MOVEA.L A0,A1

.LAB_1004:
    TST.B   (A1)+
    BNE.S   .LAB_1004

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,-16(A5)

.LAB_1005:
    MOVE.L  -16(A5),D0
    TST.L   D0
    BLE.S   .LAB_1006

    MOVEA.L A3,A1
    LEA     -74(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D5,D1
    SUB.L   -12(A5),D1
    CMP.L   D1,D0
    BLE.S   .LAB_1006

    SUBQ.L  #1,-16(A5)
    BRA.S   .LAB_1005

.LAB_1006:
    MOVE.L  -16(A5),D0
    TST.L   D0
    BLE.S   .LAB_1007

    TST.L   28(A5)
    BEQ.S   .LAB_1007

    MOVEA.L A3,A1
    LEA     -74(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOText(A6)

.LAB_1007:
    MOVEA.L -24(A5),A0
    MOVEA.L A0,A1
    ADDA.L  -16(A5),A1
    MOVE.L  A1,D0
    BRA.S   .return

.LAB_1008:
    MOVE.L  -24(A5),D0
    BRA.S   .return

.LAB_1009:
    MOVEA.L -20(A5),A0
    TST.B   (A0)
    BEQ.W   .LAB_0FFE

    MOVE.L  -8(A5),D0
    ADD.L   -12(A5),D0
    CMP.L   D5,D0
    BGT.S   .LAB_100B

    TST.L   28(A5)
    BEQ.S   .LAB_100A

    ; Draw a single space
    MOVEA.L A3,A1
    LEA     LAB_200E,A0
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOText(A6)

.LAB_100A:
    MOVE.L  -8(A5),D0
    ADD.L   D0,-12(A5)
    BRA.W   .LAB_0FFE

.LAB_100B:
    MOVE.L  -24(A5),D0

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_100D:
    LINK.W  A5,#-4
    TST.W   LAB_2263
    BNE.W   LAB_101D

    MOVE.W  LAB_1F45,D0
    CMPI.W  #$101,D0
    BNE.S   LAB_100E

    CLR.W   LAB_1F45
    BRA.W   LAB_101D

LAB_100E:
    TST.L   LAB_225F
    BEQ.S   LAB_100F

    MOVEQ   #1,D0
    CMP.L   LAB_225F,D0
    BNE.S   LAB_1010

LAB_100F:
    MOVEQ   #0,D0
    MOVE.L  D0,LAB_200F

LAB_1010:
    TST.L   LAB_200F
    BNE.S   LAB_1011

    BSR.W   LAB_0FA4

    BSR.W   LAB_0FA9

    JSR     LAB_1024(PC)

    PEA     LAB_2274
    BSR.W   LAB_0FED

    MOVE.L  D0,(A7)
    JSR     LAB_1022(PC)

    JSR     LAB_1027(PC)

    CLR.W   LAB_1F45
    MOVEQ   #2,D0
    MOVE.L  D0,LAB_225F
    JSR     LAB_1332(PC)

    CLR.L   (A7)
    MOVE.L  LAB_200F,-(A7)
    BSR.W   LAB_0FC9

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_200F

LAB_1011:
    MOVEA.L LAB_1DC6,A0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOGetMsg(A6)

    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.W   LAB_101D

    MOVEA.L D0,A0
    CLR.W   52(A0)
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_1038(PC)

    ADDQ.W  #8,A7
    MOVEA.L -4(A5),A0
    CLR.L   32(A0)

LAB_1012:
    MOVE.L  LAB_200F,D0
    SUBQ.L  #1,D0
    BLT.W   LAB_101B

    CMPI.L  #12,D0
    BGE.W   LAB_101B

    ADD.W   D0,D0
    MOVE.W  LAB_1013(PC,D0.W),D0
    JMP     LAB_1013+2(PC,D0.W)

; TODO: Switch case
LAB_1013:
    DC.W    $0016
    DC.W    $0050
    DC.W    $009e
    DC.W    $00ee
    DC.W    $0138
    DC.W    $0182
    DC.W    $01d6
    DC.W    $022a
    DC.W    $027e
    DC.W    $02ec
    DC.W    $00c6
    DC.W    $0356

    MOVEA.L -4(A5),A0
    ADDA.W  #$3c,A0
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_102A(PC)

    ADDQ.W  #8,A7
    TST.W   D0
    BNE.W   LAB_101B

    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_200F,-(A7)
    BSR.W   LAB_0FC9

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_200F
    BRA.W   LAB_101B

    PEA     LAB_223A
    BSR.W   LAB_0FE5

    PEA     LAB_2274
    MOVE.W  D0,LAB_2010
    BSR.W   LAB_0FED

    MOVE.W  D0,LAB_2011
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   LAB_0FD1

    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_200F,-(A7)
    BSR.W   LAB_0FC9

    LEA     16(A7),A7
    MOVE.L  D0,LAB_200F
    BRA.W   LAB_101B

    MOVE.L  -4(A5),-(A7)
    BSR.W   LAB_0FDC

    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_200F,-(A7)
    BSR.W   LAB_0FC9

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_200F
    BRA.W   LAB_101B

    MOVE.L  -4(A5),-(A7)
    BSR.W   LAB_0FE1

    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_200F,-(A7)
    BSR.W   LAB_0FC9

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_200F
    BRA.W   LAB_101B

    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.W  LAB_2011,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     1.W
    JSR     LAB_132A(PC)

    LEA     16(A7),A7
    TST.L   D0
    BNE.W   LAB_101B

    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_200F,-(A7)
    BSR.W   LAB_0FC9

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_200F
    BRA.W   LAB_101B

    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.W  LAB_2011,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     5.W
    JSR     LAB_132A(PC)

    LEA     16(A7),A7
    TST.L   D0
    BNE.W   LAB_101B

    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_200F,-(A7)
    BSR.W   LAB_0FC9

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_200F
    BRA.W   LAB_101B

    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.W  LAB_2011,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     2.W
    JSR     LAB_132A(PC)

    LEA     16(A7),A7
    TST.L   D0
    BEQ.S   LAB_1015

    MOVE.W  #1,LAB_2012
    BRA.W   LAB_101B

LAB_1015:
    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_200F,-(A7)
    BSR.W   LAB_0FC9

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_200F
    BRA.W   LAB_101B

    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.W  LAB_2011,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     3.W
    JSR     LAB_132A(PC)

    LEA     16(A7),A7
    TST.L   D0
    BEQ.S   LAB_1016

    MOVE.W  #1,LAB_2012
    BRA.W   LAB_101B

LAB_1016:
    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_200F,-(A7)
    BSR.W   LAB_0FC9

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_200F
    BRA.W   LAB_101B

    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.W  LAB_2011,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     4.W
    JSR     LAB_132A(PC)

    LEA     16(A7),A7
    TST.L   D0
    BEQ.S   LAB_1017

    MOVE.W  #1,LAB_2012
    BRA.W   LAB_101B

LAB_1017:
    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_200F,-(A7)
    BSR.W   LAB_0FC9

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_200F
    BRA.W   LAB_101B

    PEA     LAB_223A
    BSR.W   LAB_0FE9

    PEA     LAB_2274
    MOVE.W  D0,LAB_2010
    BSR.W   LAB_0FEF

    MOVE.W  LAB_2010,D1
    EXT.L   D1
    MOVE.W  D0,LAB_2011
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     6.W
    JSR     LAB_132A(PC)

    LEA     20(A7),A7
    TST.L   D0
    BEQ.S   LAB_1018

    MOVE.W  #1,LAB_2012
    BRA.W   LAB_101B

LAB_1018:
    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_200F,-(A7)
    BSR.W   LAB_0FC9

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_200F
    BRA.W   LAB_101B

    PEA     LAB_223A
    BSR.W   LAB_0FE5

    PEA     LAB_2274
    MOVE.W  D0,LAB_2010
    BSR.W   LAB_0FED

    MOVE.W  LAB_2010,D1
    EXT.L   D1
    MOVE.W  D0,LAB_2011
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     7.W
    JSR     LAB_132A(PC)

    LEA     20(A7),A7
    TST.L   D0
    BEQ.S   LAB_1019

    MOVE.W  #1,LAB_2012
    BRA.S   LAB_101B

LAB_1019:
    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_200F,-(A7)
    BSR.W   LAB_0FC9

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_200F
    BRA.S   LAB_101B

    TST.W   LAB_2012
    BEQ.S   LAB_101A

    MOVE.W  LAB_2011,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   LAB_0FD1

    ADDQ.W  #8,A7
    CLR.W   LAB_2012

LAB_101A:
    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_200F,-(A7)
    BSR.W   LAB_0FC9

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_200F

LAB_101B:
    MOVEA.L -4(A5),A0
    CMPI.W  #0,52(A0)
    BLS.W   LAB_1012

    MOVE.L  -4(A5),-(A7)
    JSR     LAB_0D8E(PC)

    ADDQ.W  #4,A7
    MOVEA.L LAB_1DC5,A0
    MOVEA.L -4(A5),A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOPutMsg(A6)

    TST.W   LAB_2012
    BEQ.S   LAB_101C

    BSR.W   LAB_0FF3

    BRA.S   LAB_101D

LAB_101C:
    BSR.W   DRAW_FILLED_RECT_0_0_TO_695_1_PEN_7

LAB_101D:
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

JMP_TBL_LAB_1A07_3:
    JMP     LAB_1A07

LAB_101F:
    JMP     LAB_05C7

JMP_TBL_GENERATE_GRID_DATE_STRING:
    JMP     GENERATE_GRID_DATE_STRING

JMP_TBL_DEALLOCATE_MEMORY_3:
    JMP     DEALLOCATE_MEMORY

LAB_1022:
    JMP     LAB_01EE

LAB_1023:
    JMP     LAB_058A

LAB_1024:
    ; Reuse cleanup module to draw the shared clock banner.
    JMP     CLEANUP_DrawClockBanner

JMP_TBL_ALLOCATE_MEMORY_3:
    JMP     ALLOCATE_MEMORY

LAB_1026:
    JMP     LAB_0588

LAB_1027:
    JMP     LAB_01FD

LAB_1028:
    JMP     LAB_05D3

LAB_1029:
    JMP     LAB_1970

LAB_102A:
    JMP     LAB_18C2

JMP_TBL_LAB_1A06_6:
    JMP     LAB_1A06

;!======

LAB_102C:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7

LAB_102D:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   LAB_102E

    MOVE.L  D7,D1
    ADDQ.L  #4,D1
    MOVE.B  D1,55(A3,D7.L)
    MOVE.L  D7,D1
    ASL.L   #2,D1
    CLR.L   36(A3,D1.L)
    ADDQ.L  #1,D7
    BRA.S   LAB_102D

LAB_102E:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

LAB_102F:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.W  26(A7),D7
    MOVE.L  28(A7),D6
    MOVE.L  D7,D0
    ADDQ.W  #1,D0
    BEQ.S   LAB_1030

    SUBQ.W  #1,D0
    BEQ.S   LAB_1031

    SUBQ.W  #1,D0
    BEQ.S   LAB_1032

    SUBQ.W  #1,D0
    BEQ.S   LAB_1033

    BRA.S   LAB_1034

LAB_1030:
    MOVEQ   #7,D5
    BRA.S   LAB_1035

LAB_1031:
    MOVEQ   #4,D5
    BRA.S   LAB_1035

LAB_1032:
    MOVEQ   #5,D5
    BRA.S   LAB_1035

LAB_1033:
    MOVEQ   #6,D5
    BRA.S   LAB_1035

LAB_1034:
    MOVEQ   #4,D5

LAB_1035:
    MOVE.L  D5,D0
    SUBQ.L  #4,D0
    MOVE.L  D0,D7
    TST.L   D6
    BMI.S   LAB_1036

    MOVEQ   #16,D0
    CMP.L   D0,D6
    BGT.S   LAB_1036

    MOVE.L  D6,D0
    MOVE.B  D0,55(A3,D7.W)
    BRA.S   LAB_1037

LAB_1036:
    MOVE.B  #$7,55(A3,D7.W)

LAB_1037:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======

LAB_1038:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.L  16(A7),D7
    MOVEQ   #0,D0
    MOVE.B  54(A3),D0
    CMP.L   D7,D0
    BGE.W   LAB_1045

    MOVE.L  D7,D0
    MOVEQ   #16,D1
    SUB.L   D1,D0
    BEQ.S   LAB_1039

    MOVEQ   #16,D1
    SUB.L   D1,D0
    BEQ.W   LAB_103A

    SUBQ.L  #1,D0
    BEQ.W   LAB_103C

    SUBQ.L  #1,D0
    BEQ.W   LAB_103E

    SUBQ.L  #1,D0
    BEQ.W   LAB_1040

    SUBQ.L  #1,D0
    BEQ.W   LAB_1041

    SUBQ.L  #1,D0
    BEQ.W   LAB_1042

    MOVEQ   #11,D1
    SUB.L   D1,D0
    BEQ.S   LAB_103B

    SUBQ.L  #1,D0
    BEQ.W   LAB_103D

    SUBQ.L  #1,D0
    BEQ.W   LAB_103E

    SUBQ.L  #1,D0
    BEQ.W   LAB_1040

    SUBQ.L  #1,D0
    BEQ.W   LAB_1041

    SUBQ.L  #1,D0
    BEQ.W   LAB_1042

    MOVEQ   #11,D1
    SUB.L   D1,D0
    BEQ.W   LAB_1043

    SUBQ.L  #1,D0
    BEQ.W   LAB_1043

    SUBQ.L  #1,D0
    BEQ.W   LAB_1043

    SUBQ.L  #1,D0
    BEQ.W   LAB_1043

    SUBQ.L  #1,D0
    BEQ.W   LAB_1043

    BRA.W   LAB_1044

LAB_1039:
    MOVE.B  LAB_1BBF,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   LAB_1046

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.W   LAB_1046

LAB_103A:
    MOVE.B  LAB_1BB2,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   LAB_1046

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.W   LAB_1046

LAB_103B:
    MOVE.B  LAB_1BB9,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   LAB_1046

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.W   LAB_1046

LAB_103C:
    MOVE.B  LAB_22CC,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   LAB_1046

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.W   LAB_1046

LAB_103D:
    MOVE.B  LAB_1BB9,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   LAB_1046

    MOVE.B  LAB_22CC,D0
    CMP.B   D1,D0
    BNE.S   LAB_1046

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.S   LAB_1046

LAB_103E:
    MOVE.B  LAB_1BAE,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BEQ.S   LAB_103F

    MOVE.B  LAB_1BB1,D0
    CMP.B   D1,D0
    BNE.S   LAB_1046

LAB_103F:
    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.S   LAB_1046

LAB_1040:
    MOVE.B  LAB_1BAF,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   LAB_1046

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.S   LAB_1046

LAB_1041:
    MOVE.B  LAB_22D5,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   LAB_1046

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.S   LAB_1046

LAB_1042:
    MOVE.B  LAB_22E4,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   LAB_1046

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.S   LAB_1046

LAB_1043:
    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.S   LAB_1046

LAB_1044:
    CLR.B   54(A3)
    BRA.S   LAB_1046

LAB_1045:
    TST.L   D7
    BNE.S   LAB_1046

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)

LAB_1046:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

LAB_1047:
    LINK.W  A5,#-36
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  20(A5),D7
    TST.W   GLOB_WORD_SELECT_CODE_IS_RAVESC
    BEQ.S   LAB_1049

    MOVEA.L 16(A5),A0
    LEA     -26(A5),A1

LAB_1048:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_1048

    MOVE.B  #$2d,-24(A5)
    CLR.B   -23(A5)
    MOVEA.L 16(A5),A0
    ADDQ.L  #2,A0
    MOVE.L  A0,-(A7)
    PEA     -26(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_3(PC)

    ADDQ.W  #8,A7
    LEA     -26(A5),A0
    MOVE.L  A0,16(A5)

LAB_1049:
    MOVEQ   #0,D0
    MOVE.W  LAB_2329,D0
    TST.L   D0
    BPL.S   LAB_104A

    ADDQ.L  #1,D0

LAB_104A:
    ASR.L   #1,D0
    MOVE.L  D0,D5
    MOVEQ   #42,D1
    ADD.L   D1,D5
    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    MOVE.L  D0,D1
    TST.L   D1
    BPL.S   LAB_104B

    ADDQ.L  #1,D1

LAB_104B:
    ASR.L   #1,D1
    MOVEA.L 52(A3),A0
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    SUB.L   D2,D1
    SUBQ.L  #4,D1
    TST.L   D1
    BPL.S   LAB_104C

    ADDQ.L  #1,D1

LAB_104C:
    ASR.L   #1,D1
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    ADD.L   D2,D1
    MOVE.L  D1,D4
    ADDQ.L  #3,D4
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    TST.L   D1
    BPL.S   LAB_104D

    ADDQ.L  #1,D1

LAB_104D:
    ASR.L   #1,D1
    TST.L   D7
    BNE.S   LAB_1050

    MOVEQ   #0,D2
    MOVE.W  D0,D2
    TST.L   D2
    BPL.S   LAB_104E

    ADDQ.L  #1,D2

LAB_104E:
    ASR.L   #1,D2
    MOVEQ   #0,D3
    MOVE.W  26(A0),D3
    SUB.L   D3,D2
    TST.L   D2
    BPL.S   LAB_104F

    ADDQ.L  #1,D2

LAB_104F:
    ASR.L   #1,D2
    MOVEQ   #0,D3
    MOVE.W  26(A0),D3
    ADD.L   D3,D2
    SUBQ.L  #1,D2
    BRA.S   LAB_1053

LAB_1050:
    MOVEQ   #0,D2
    MOVE.W  D0,D2
    TST.L   D2
    BPL.S   LAB_1051

    ADDQ.L  #1,D2

LAB_1051:
    ASR.L   #1,D2
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    SUB.L   D0,D2
    SUBQ.L  #4,D2
    TST.L   D2
    BPL.S   LAB_1052

    ADDQ.L  #1,D2

LAB_1052:
    ASR.L   #1,D2
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    ADD.L   D0,D2
    SUBQ.L  #1,D2

LAB_1053:
    ADD.L   D2,D1
    MOVEM.L D1,-16(A5)
    MOVEQ   #5,D0
    CMP.L   LAB_2014,D0
    BNE.S   LAB_1054

    MOVEA.L A3,A1
    MOVE.L  LAB_22CD,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    BRA.S   LAB_1055

LAB_1054:
    MOVEA.L A3,A1
    MOVEQ   #3,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

LAB_1055:
    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L A2,A0

LAB_1056:
    TST.B   (A0)+
    BNE.S   LAB_1056

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,D0
    TST.L   D0
    BLE.S   LAB_105D

    MOVEA.L A2,A0

LAB_1057:
    TST.B   (A0)+
    BNE.S   LAB_1057

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,D6

LAB_1058:
    TST.L   D6
    BLE.S   LAB_1059

    MOVEQ   #32,D0
    CMP.B   -1(A2,D6.L),D0
    BNE.S   LAB_1059

    SUBQ.L  #1,D6
    BRA.S   LAB_1058

LAB_1059:
    MOVEA.L A3,A1
    MOVEA.L A2,A0
    MOVE.L  D6,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    TST.L   D0
    BPL.S   LAB_105A

    ADDQ.L  #1,D0

LAB_105A:
    ASR.L   #1,D0
    MOVE.L  D5,D1
    SUB.L   D0,D1
    MOVE.B  LAB_1BA3,D0
    MOVEQ   #83,D2
    CMP.B   D2,D0
    BNE.S   LAB_105B

    MOVE.L  D4,D0
    BRA.S   LAB_105C

LAB_105B:
    MOVE.L  -16(A5),D0

LAB_105C:
    MOVE.L  D0,36(A7)
    MOVEA.L A3,A1
    MOVE.L  D1,D0
    MOVE.L  36(A7),D1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVEA.L A2,A0
    MOVE.L  D6,D0
    JSR     _LVOText(A6)

LAB_105D:
    MOVEA.L 16(A5),A0

LAB_105E:
    TST.B   (A0)+
    BNE.S   LAB_105E

    SUBQ.L  #1,A0
    SUBA.L  16(A5),A0
    MOVE.L  A0,D0
    TST.L   D0
    BLE.S   LAB_1065

    MOVEA.L 16(A5),A0

LAB_105F:
    TST.B   (A0)+
    BNE.S   LAB_105F

    SUBQ.L  #1,A0
    SUBA.L  16(A5),A0
    MOVE.L  A0,D6

LAB_1060:
    TST.L   D6
    BLE.S   LAB_1061

    MOVEQ   #32,D0
    MOVEA.L 16(A5),A0
    CMP.B   -1(A0,D6.L),D0
    BNE.S   LAB_1061

    SUBQ.L  #1,D6
    BRA.S   LAB_1060

LAB_1061:
    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVEA.L 16(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    TST.L   D0
    BPL.S   LAB_1062

    ADDQ.L  #1,D0

LAB_1062:
    ASR.L   #1,D0
    MOVE.L  D5,D1
    SUB.L   D0,D1
    MOVE.B  LAB_1BA3,D0
    MOVEQ   #83,D2
    CMP.B   D2,D0
    BNE.S   LAB_1063

    MOVE.L  -16(A5),D0
    BRA.S   LAB_1064

LAB_1063:
    MOVE.L  D4,D0

LAB_1064:
    MOVE.L  D0,36(A7)
    MOVEA.L A3,A1
    MOVE.L  D1,D0
    MOVE.L  36(A7),D1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVEA.L 16(A5),A0
    JSR     _LVOText(A6)

LAB_1065:
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_1066:
    LINK.W  A5,#-8
    MOVEM.L D2/D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  16(A5),D7
    LEA     1(A2),A0
    LEA     19(A2),A1
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-4(A5)
    MOVE.L  A1,-8(A5)
    JSR     LAB_134B(PC)

    MOVE.L  -8(A5),(A7)
    MOVE.L  D0,-4(A5)
    JSR     LAB_134B(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,-8(A5)
    TST.L   D7
    BNE.S   LAB_1067

    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2328,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1352(PC)

    LEA     20(A7),A7
    BRA.S   LAB_1068

LAB_1067:
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2328,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_133D(PC)

    LEA     20(A7),A7

LAB_1068:
    MOVE.L  D7,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1047

    MOVEM.L -24(A5),D2/D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_1069:
    LINK.W  A5,#-4
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.B  19(A5),D6
    MOVE.B  GLOB_REF_STR_USE_24_HR_CLOCK,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   LAB_106A

    MOVE.L  A3,D0
    BEQ.S   LAB_106A

    PEA     40.W
    MOVE.L  A3,-(A7)
    JSR     LAB_1455(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   LAB_106A

    MOVEQ   #58,D0
    MOVEA.L -4(A5),A0
    CMP.B   3(A0),D0
    BNE.S   LAB_106A

    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_134D(PC)

    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     GLOB_JMP_TBL_HALF_HOURS_24_HR_FMT,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    MOVE.B  (A1),D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,1(A0)
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_134D(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     GLOB_JMP_TBL_HALF_HOURS_24_HR_FMT,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    ADDQ.L  #1,A1
    MOVE.B  (A1),D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,2(A0)

LAB_106A:
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======

LAB_106B:
    LINK.W  A5,#-4
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEQ   #0,D7
    CMPI.B  #$40,54(A3)
    BCC.S   LAB_106D

    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    TST.L   D0
    BPL.S   LAB_106C

    ADDQ.L  #3,D0

LAB_106C:
    ASR.L   #2,D0
    MOVEQ   #0,D1
    MOVE.W  52(A3),D1
    MOVE.L  D0,8(A7)
    MOVE.L  D1,D0
    MOVE.L  8(A7),D1
    JSR     JMP_TBL_LAB_1A07_3(PC)

    MOVE.L  D0,D7

LAB_106D:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======

LAB_106E:
    MOVE.L  D7,-(A7)
    MOVEQ   #1,D0
    CMP.L   LAB_2261,D0
    BEQ.S   LAB_106F

    MOVEQ   #6,D0

LAB_106F:
    MOVE.L  D0,D7
    MOVE.L  D7,D0
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_1070:
    LINK.W  A5,#-16
    MOVEM.L D5-D7,-(A7)
    TST.L   LAB_2013
    BEQ.W   LAB_1076

    MOVE.W  LAB_1F45,D5
    MOVE.W  #$100,LAB_1F45
    MOVEQ   #0,D7

LAB_1071:
    CMPI.L  #$12e,D7
    BGE.S   LAB_1072

    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEQ   #-1,D1
    MOVEA.L LAB_2013,A0
    MOVE.L  D1,0(A0,D0.L)
    ADDQ.L  #1,D7
    BRA.S   LAB_1071

LAB_1072:
    MOVEQ   #0,D7

LAB_1073:
    MOVEQ   #0,D0
    MOVE.W  LAB_2231,D0
    CMP.L   D0,D7
    BGE.S   LAB_1075

    PEA     1.W
    MOVE.L  D7,-(A7)
    JSR     LAB_1345(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-14(A5)
    TST.L   D0
    BEQ.S   LAB_1074

    MOVEA.L D0,A0
    ADDA.W  #12,A0
    MOVE.L  A0,-(A7)
    JSR     LAB_133B(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D6
    MOVEQ   #-1,D0
    CMP.L   D0,D6
    BLE.S   LAB_1074

    MOVEQ   #0,D0
    MOVE.W  LAB_222F,D0
    CMP.L   D0,D6
    BGE.S   LAB_1074

    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEA.L LAB_2013,A0
    MOVE.L  D6,0(A0,D0.L)

LAB_1074:
    ADDQ.L  #1,D7
    BRA.S   LAB_1073

LAB_1075:
    MOVE.W  D5,LAB_1F45

LAB_1076:
    MOVEM.L (A7)+,D5-D7
    UNLK    A5
    RTS

;!======

LAB_1077:
    LINK.W  A5,#-16
    MOVEM.L D4-D7/A2-A3/A6,-(A7)

    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  18(A5),D7
    MOVE.L  20(A5),D6
    MOVEQ   #0,D4
    MOVE.L  (A3),-12(A5)
    MOVE.L  (A2),-16(A5)
    MOVEQ   #48,D0
    CMP.W   D0,D7
    BLE.S   LAB_1078

    SUBI.W  #$30,D7
    MOVEQ   #1,D4

LAB_1078:
    PEA     1.W
    MOVE.L  D6,-(A7)
    JSR     LAB_1345(PC)

    PEA     1.W
    MOVE.L  D6,-(A7)
    MOVE.L  D0,-12(A5)
    JSR     LAB_133E(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-16(A5)
    TST.L   -12(A5)
    BEQ.W   LAB_107E

    TST.L   D0
    BEQ.W   LAB_107E

    MOVEQ   #1,D1
    CMP.W   D1,D7
    BEQ.S   LAB_1079

    PEA     LAB_223A
    JSR     LAB_134A(PC)

    ADDQ.W  #4,A7
    SUBQ.W  #1,D0
    BEQ.S   LAB_1079

    TST.L   D4
    BEQ.W   LAB_107E

LAB_1079:
    TST.B   LAB_222E
    BEQ.W   LAB_107E

    TST.L   LAB_2013
    BEQ.S   LAB_107C

    MOVE.L  D6,D0
    ASL.L   #2,D0
    MOVEA.L LAB_2013,A0
    MOVE.L  0(A0,D0.L),D5
    TST.L   D5
    BMI.S   LAB_107B

    MOVEQ   #0,D0
    MOVE.W  LAB_222F,D0
    CMP.L   D0,D5
    BGE.S   LAB_107B

    MOVEA.L -12(A5),A0
    ADDA.W  #12,A0
    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     LAB_2235,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A6
    LEA     12(A6),A1

LAB_107A:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.S   LAB_107B

    TST.B   D0
    BNE.S   LAB_107A

    BEQ.S   LAB_107D

LAB_107B:
    MOVE.L  -16(A5),-(A7)
    JSR     LAB_133B(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D5
    MOVE.L  D6,D0
    ASL.L   #2,D0
    MOVEA.L LAB_2013,A0
    MOVE.L  D5,0(A0,D0.L)
    BRA.S   LAB_107D

LAB_107C:
    MOVE.L  -16(A5),-(A7)
    JSR     LAB_133B(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D5

LAB_107D:
    PEA     2.W
    MOVE.L  D5,-(A7)
    JSR     LAB_1345(PC)

    PEA     2.W
    MOVE.L  D5,-(A7)
    MOVE.L  D0,-12(A5)
    JSR     LAB_133E(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-16(A5)

LAB_107E:
    MOVE.L  -12(A5),(A3)
    MOVE.L  -16(A5),(A2)
    MOVE.L  D7,D0

    MOVEM.L (A7)+,D4-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

LAB_107F:
    LINK.W  A5,#-20
    MOVEM.L D5-D7/A2-A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  22(A5),D7
    MOVE.W  26(A5),D6
    MOVE.L  28(A5),D5
    LEA     LAB_2019,A0
    LEA     -19(A5),A1
    MOVE.B  (A0)+,(A1)+
    MOVE.B  (A0)+,(A1)+
    MOVE.B  (A0)+,(A1)+
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L 16(A5),A0
    MOVEA.L 56(A0,D0.L),A0
    MOVE.L  A0,-16(A5)
    MOVE.L  A2,D0
    BEQ.W   LAB_109D

    TST.L   16(A5)
    BEQ.W   LAB_109D

    TST.W   D7
    BLE.W   LAB_109D

    MOVEQ   #49,D0
    CMP.W   D0,D7
    BGE.W   LAB_109D

    MOVE.L  A0,D0
    BEQ.W   LAB_109D

    TST.B   (A0)
    BEQ.W   LAB_109D

    MOVE.L  32(A5),D0
    MOVEQ   #3,D1
    CMP.L   D1,D0
    BEQ.S   LAB_1080

    ADDQ.L  #1,D0
    BNE.S   LAB_1081

LAB_1080:
    MOVEQ   #40,D0
    CMP.B   (A0),D0
    BNE.S   LAB_1081

    MOVEQ   #58,D0
    CMP.B   3(A0),D0
    BNE.S   LAB_1081

    MOVEQ   #8,D0
    BRA.S   LAB_1082

LAB_1081:
    MOVEQ   #0,D0

LAB_1082:
    ADD.L   D0,-16(A5)
    MOVEA.L -16(A5),A0
    MOVEA.L LAB_2335,A1

LAB_1083:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_1083

    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVEA.L 16(A5),A0
    MOVE.B  498(A0),D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_2335,-(A7)
    BSR.W   LAB_1069

    LEA     12(A7),A7
    MOVEA.L 16(A5),A0
    BTST    #1,7(A0,D7.W)
    BNE.S   LAB_1084

    BTST    #4,27(A2)
    BEQ.W   LAB_109C

LAB_1084:
    TST.L   D5
    BEQ.S   LAB_1085

    MOVEQ   #3,D0
    CMP.W   D0,D6
    BNE.S   LAB_1085

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  32(A5),-(A7)
    MOVE.L  LAB_2335,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A2,-(A7)
    JSR     LAB_1342(PC)

    MOVE.L  LAB_2335,(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1339(PC)

    LEA     24(A7),A7
    BRA.W   LAB_109E

LAB_1085:
    PEA     34.W
    MOVE.L  LAB_2335,-(A7)
    JSR     LAB_1455(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    BEQ.S   LAB_1086

    ADDQ.L  #1,-4(A5)
    PEA     34.W
    MOVE.L  -4(A5),-(A7)
    JSR     LAB_1455(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)

LAB_1086:
    TST.L   D0
    BEQ.S   LAB_108A

    PEA     LAB_2018
    MOVE.L  D0,-(A7)
    JSR     LAB_1469(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    BEQ.S   LAB_1087

    MOVE.L  D0,-4(A5)

LAB_1087:
    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.S   LAB_1088

    MOVEQ   #32,D0
    CMP.B   (A0),D0
    BEQ.S   LAB_1088

    ADDQ.L  #1,-4(A5)
    BRA.S   LAB_1087

LAB_1088:
    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.S   LAB_1089

    CLR.B   (A0)+
    MOVE.L  A0,-4(A5)
    BRA.S   LAB_108A

LAB_1089:
    CLR.L   -4(A5)

LAB_108A:
    MOVE.L  LAB_2335,-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1339(PC)

    ADDQ.W  #8,A7
    TST.L   D5
    BEQ.W   LAB_1098

    TST.L   -4(A5)
    BEQ.W   LAB_1098

    MOVEQ   #1,D0
    CMP.W   D0,D6
    BLE.W   LAB_1098

    PEA     40.W
    MOVE.L  -4(A5),-(A7)
    JSR     LAB_1455(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.S   LAB_108F

    MOVEQ   #41,D1
    MOVEA.L D0,A0
    CMP.B   5(A0),D1
    BNE.S   LAB_108F

    LEA     6(A0),A1
    MOVE.L  A1,-4(A5)

LAB_108B:
    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.S   LAB_108C

    MOVEQ   #32,D0
    CMP.B   (A0),D0
    BEQ.S   LAB_108C

    ADDQ.L  #1,-4(A5)
    BRA.S   LAB_108B

LAB_108C:
    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.S   LAB_108D

    CLR.B   (A0)+
    MOVE.L  A0,-4(A5)
    BRA.S   LAB_108E

LAB_108D:
    CLR.L   -4(A5)

LAB_108E:
    MOVE.L  -8(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1340(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   LAB_108F

    MOVE.L  -8(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1339(PC)

    ADDQ.W  #8,A7

LAB_108F:
    TST.L   -4(A5)
    BEQ.W   LAB_1098

    MOVE.L  -4(A5),-(A7)
    JSR     LAB_134B(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,-8(A5)
    BEQ.S   LAB_1091

    PEA     44.W
    MOVE.L  D0,-(A7)
    JSR     LAB_1455(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)
    BEQ.S   LAB_1090

    PEA     46.W
    MOVE.L  D0,-(A7)
    JSR     LAB_1455(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    BNE.S   LAB_1091

    MOVE.L  -12(A5),-4(A5)
    CLR.L   -12(A5)
    MOVEA.L -4(A5),A0
    MOVE.B  #$2e,(A0)
    BRA.S   LAB_1091

LAB_1090:
    PEA     46.W
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_1455(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    BNE.S   LAB_1091

    SUBA.L  A0,A0
    MOVE.L  A0,-8(A5)

LAB_1091:
    TST.L   -8(A5)
    BEQ.W   LAB_1098

LAB_1092:
    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.S   LAB_1093

    MOVEQ   #32,D0
    CMP.B   (A0),D0
    BEQ.S   LAB_1093

    ADDQ.L  #1,-4(A5)
    BRA.S   LAB_1092

LAB_1093:
    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.S   LAB_1094

    CLR.B   (A0)+
    MOVE.L  A0,-4(A5)
    BRA.S   LAB_1095

LAB_1094:
    CLR.L   -4(A5)

LAB_1095:
    MOVE.L  -8(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1340(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   LAB_1096

    MOVE.L  -8(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1339(PC)

    ADDQ.W  #8,A7
    BRA.S   LAB_1098

LAB_1096:
    TST.L   -12(A5)
    BEQ.S   LAB_1098

    MOVEA.L -12(A5),A0
    MOVE.B  #$2e,(A0)
    CLR.B   1(A0)
    LEA     2(A0),A1
    MOVE.L  A1,-(A7)
    JSR     LAB_134B(PC)

    MOVE.L  -8(A5),(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-12(A5)
    JSR     LAB_1340(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   LAB_1097

    MOVE.L  -8(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1339(PC)

    ADDQ.W  #8,A7
    BRA.S   LAB_1098

LAB_1097:
    MOVE.L  -12(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1340(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   LAB_1098

    MOVE.L  -12(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1339(PC)

    ADDQ.W  #8,A7

LAB_1098:
    TST.L   -4(A5)
    BEQ.S   LAB_109B

    PEA     -19(A5)
    MOVE.L  -4(A5),-(A7)
    JSR     LAB_1469(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    BEQ.S   LAB_109B

    MOVEA.L D0,A0
    ADDQ.L  #1,A0
    PEA     -19(A5)
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-4(A5)
    JSR     LAB_1469(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)

LAB_1099:
    TST.L   -12(A5)
    BEQ.S   LAB_109A

    MOVEA.L -12(A5),A0
    ADDQ.L  #1,A0
    MOVE.L  A0,-4(A5)
    PEA     -19(A5)
    MOVE.L  -4(A5),-(A7)
    JSR     LAB_1469(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)
    BRA.S   LAB_1099

LAB_109A:
    MOVEA.L -4(A5),A0
    CLR.B   (A0)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1339(PC)

    ADDQ.W  #8,A7

LAB_109B:
    MOVE.L  32(A5),D0
    MOVEQ   #-1,D1
    CMP.L   D1,D0
    BNE.S   LAB_109E

    TST.L   D5
    BEQ.S   LAB_109E

    MOVEQ   #1,D1
    CMP.W   D1,D6
    BLE.S   LAB_109E

    MOVEA.L LAB_2335,A0
    CLR.B   (A0)
    MOVE.L  D7,D1
    EXT.L   D1
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  16(A5),-(A7)
    MOVE.L  A2,-(A7)
    JSR     LAB_1342(PC)

    MOVE.L  LAB_2335,(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1339(PC)

    LEA     24(A7),A7
    BRA.S   LAB_109E

LAB_109C:
    MOVE.L  LAB_2335,-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1339(PC)

    ADDQ.W  #8,A7
    BRA.S   LAB_109E

LAB_109D:
    MOVE.L  LAB_2111,-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1339(PC)

    ADDQ.W  #8,A7

LAB_109E:
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_109F:
    LINK.W  A5,#-4
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  18(A5),D7
    MOVE.L  24(A5),D6
    MOVE.L  D6,-(A7)
    PEA     20.W
    PEA     612.W
    JSR     LAB_1358(PC)

    LEA     12(A7),A7
    MOVE.L  A2,D0
    BEQ.S   LAB_10A0

    BTST    #4,27(A2)
    BEQ.S   LAB_10A0

    MOVE.L  D7,D0
    EXT.L   D0
    PEA     5.W
    MOVE.L  D0,-(A7)
    MOVE.L  A2,-(A7)
    JSR     LAB_134F(PC)

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   LAB_10A0

    MOVE.L  D7,D0
    EXT.L   D0
    PEA     6.W
    MOVE.L  D0,-(A7)
    MOVE.L  A2,-(A7)
    JSR     LAB_1337(PC)

    LEA     12(A7),A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   LAB_10A0

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A2,-(A7)
    JSR     LAB_1341(PC)

    MOVE.L  20(A5),(A7)
    PEA     20.W
    MOVE.L  -4(A5),-(A7)
    PEA     19.W
    PEA     LAB_201A
    MOVE.L  A3,-(A7)
    JSR     LAB_133C(PC)

    LEA     28(A7),A7
    BRA.S   LAB_10A1

LAB_10A0:
    MOVE.L  20(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1339(PC)

    ADDQ.W  #8,A7

LAB_10A1:
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_10A2:
    LINK.W  A5,#-28
    MOVEM.L D2-D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    JSR     LAB_1350(PC)

    TST.L   D0
    BNE.W   LAB_10B4

    LEA     60(A3),A0
    MOVE.L  D7,-(A7)
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A0,40(A7)
    BSR.W   LAB_102F

    MOVEA.L 40(A7),A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    ADDQ.L  #3,D0
    MOVEA.L A0,A1
    MOVE.L  D0,D3
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVE.L  #695,D2
    JSR     _LVORectFill(A6)

    MOVEQ   #42,D5
    CLR.L   -16(A5)
    JSR     LAB_133A(PC)

    LEA     12(A7),A7
    SUBQ.L  #1,D0
    BNE.S   LAB_10A4

    LEA     60(A3),A0
    MOVE.L  A0,-(A7)
    JSR     LAB_1357(PC)

    ADDQ.W  #4,A7
    MOVE.L  #612,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   LAB_10A3

    ADDQ.L  #1,D1

LAB_10A3:
    ASR.L   #1,D1
    ADD.L   D1,D5
    MOVEQ   #4,D0
    MOVE.L  D0,-16(A5)

LAB_10A4:
    JSR     LAB_1359(PC)

    MOVEQ   #0,D6
    MOVE.L  D0,-24(A5)

LAB_10A5:
    MOVEQ   #2,D0
    CMP.L   D0,D6
    BGE.W   LAB_10B0

    JSR     LAB_1350(PC)

    TST.L   D0
    BNE.W   LAB_10B0

    TST.L   D6
    BNE.S   LAB_10A8

    TST.L   -24(A5)
    BEQ.S   LAB_10A8

    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    TST.L   D0
    BPL.S   LAB_10A6

    ADDQ.L  #1,D0

LAB_10A6:
    ASR.L   #1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    SUB.L   D1,D0
    SUBQ.L  #4,D0
    TST.L   D0
    BPL.S   LAB_10A7

    ADDQ.L  #1,D0

LAB_10A7:
    ASR.L   #1,D0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D0
    MOVE.L  D0,D4
    ADDQ.L  #3,D4
    BRA.S   LAB_10AE

LAB_10A8:
    JSR     LAB_1351(PC)

    TST.L   D0
    BEQ.S   LAB_10AB

    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    MOVE.L  D0,D1
    TST.L   D1
    BPL.S   LAB_10A9

    ADDQ.L  #1,D1

LAB_10A9:
    ASR.L   #1,D1
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    SUB.L   D2,D1
    SUBQ.L  #4,D1
    TST.L   D1
    BPL.S   LAB_10AA

    ADDQ.L  #1,D1

LAB_10AA:
    ASR.L   #1,D1
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    ADD.L   D2,D1
    MOVE.L  -16(A5),D2
    ADD.L   D2,D1
    MOVE.L  D1,D4
    SUBQ.L  #1,D4
    BRA.S   LAB_10AE

LAB_10AB:
    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    TST.L   D0
    BPL.S   LAB_10AC

    ADDQ.L  #1,D0

LAB_10AC:
    ASR.L   #1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    SUB.L   D1,D0
    TST.L   D0
    BPL.S   LAB_10AD

    ADDQ.L  #1,D0

LAB_10AD:
    ASR.L   #1,D0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D0
    MOVE.L  -16(A5),D1
    ADD.L   D0,D1
    MOVE.L  D1,D4
    SUBQ.L  #1,D4

LAB_10AE:
    LEA     60(A3),A0
    MOVE.L  D4,-(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_1346(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D6
    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    TST.L   D0
    BPL.S   LAB_10AF

    ADDQ.L  #1,D0

LAB_10AF:
    ASR.L   #1,D0
    ADD.L   LAB_1CE8,D0
    ADD.L   D0,-16(A5)
    BRA.W   LAB_10A5

LAB_10B0:
    JSR     LAB_1350(PC)

    MOVE.L  D0,-20(A5)
    TST.L   -24(A5)
    BEQ.S   LAB_10B1

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,-(A7)
    PEA     695.W
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_133F(PC)

    LEA     20(A7),A7

LAB_10B1:
    TST.L   -20(A5)
    BEQ.S   LAB_10B2

    LEA     60(A3),A0
    MOVE.L  -16(A5),D0
    SUBQ.L  #1,D0
    MOVE.L  D0,-(A7)
    PEA     695.W
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_135A(PC)

    LEA     20(A7),A7

LAB_10B2:
    MOVE.L  -16(A5),D0
    BPL.S   LAB_10B3

    ADDQ.L  #1,D0

LAB_10B3:
    ASR.L   #1,D0
    MOVE.W  D0,52(A3)

LAB_10B4:
    MOVE.L  -20(A5),D0
    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======

LAB_10B5:
    LINK.W  A5,#-8
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.W  18(A5),D6
    MOVE.L  A3,D0
    BNE.S   LAB_10B6

    MOVEQ   #4,D0
    MOVE.L  D0,LAB_201B
    BRA.W   LAB_10BD

LAB_10B6:
    MOVE.L  LAB_201B,D0
    MOVEQ   #5,D1
    CMP.L   D1,D0
    BNE.S   LAB_10B7

    MOVEQ   #-1,D1
    MOVE.L  D1,32(A3)
    BRA.W   LAB_10BA

LAB_10B7:
    SUBQ.L  #4,D0
    BNE.W   LAB_10B9

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D7,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -8(A5)
    PEA     -4(A5)
    BSR.W   LAB_1077

    LEA     16(A7),A7
    MOVE.L  D0,D6
    TST.L   -4(A5)
    BEQ.W   LAB_10BA

    TST.L   -8(A5)
    BEQ.W   LAB_10BA

    MOVEA.L -4(A5),A0
    ADDA.W  #$1c,A0
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_1355(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   LAB_10BA

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     LAB_1353(PC)

    MOVE.L  D0,D6
    MOVE.L  -4(A5),(A7)
    BSR.W   LAB_1103

    LEA     12(A7),A7
    MOVEA.L -8(A5),A0
    MOVEA.L A0,A1
    ADDA.W  D6,A1
    MOVE.L  D0,LAB_2333
    BTST    #2,7(A1)
    BEQ.S   LAB_10B8

    MOVEQ   #5,D0
    MOVE.L  D0,LAB_2333

LAB_10B8:
    LEA     60(A3),A1
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    ASL.L   #2,D1
    ADDA.L  D1,A0
    MOVE.L  LAB_2334,-(A7)
    MOVE.L  56(A0),-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A1,-(A7)
    BSR.W   LAB_109F

    CLR.L   (A7)
    JSR     LAB_1344(PC)

    LEA     20(A7),A7
    MOVE.L  D0,32(A3)
    BRA.S   LAB_10BA

LAB_10B9:
    MOVEQ   #4,D0
    MOVE.L  D0,LAB_201B

LAB_10BA:
    MOVE.L  LAB_2333,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_10A2

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   LAB_10BB

    MOVEQ   #4,D0
    BRA.S   LAB_10BC

LAB_10BB:
    MOVEQ   #5,D0

LAB_10BC:
    MOVE.L  D0,LAB_201B

LAB_10BD:
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======

LAB_10BE:
    LINK.W  A5,#0
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVEA.L 16(A5),A3
    MOVEA.L 20(A5),A2
    MOVE.L  D7,D0
    TST.L   D0
    BEQ.S   LAB_10C1

    SUBQ.L  #1,D0
    BEQ.S   LAB_10BF

    SUBQ.L  #1,D0
    BEQ.S   LAB_10C0

    BRA.S   LAB_10C1

LAB_10BF:
    MOVE.B  #$80,(A3)
    MOVE.B  #$81,(A2)
    BRA.S   LAB_10C2

LAB_10C0:
    MOVE.B  #$82,(A3)
    MOVE.B  #$83,(A2)
    BRA.S   LAB_10C2

LAB_10C1:
    MOVEQ   #0,D0
    MOVE.B  D0,(A3)
    MOVE.B  D0,(A2)

LAB_10C2:
    MOVE.L  D6,D0
    TST.L   D0
    BEQ.S   LAB_10C5

    SUBQ.L  #1,D0
    BEQ.S   LAB_10C3

    SUBQ.L  #1,D0
    BEQ.S   LAB_10C4

    BRA.S   LAB_10C5

LAB_10C3:
    MOVEA.L 24(A5),A0
    MOVE.B  #$88,(A0)
    MOVEA.L 28(A5),A0
    MOVE.B  #$89,(A0)
    BRA.S   LAB_10C6

LAB_10C4:
    MOVEA.L 24(A5),A0
    MOVE.B  #$8a,(A0)
    MOVEA.L 28(A5),A0
    MOVE.B  #$8b,(A0)
    BRA.S   LAB_10C6

LAB_10C5:
    MOVEQ   #0,D0
    MOVEA.L 24(A5),A0
    MOVE.B  D0,(A0)
    MOVEA.L 28(A5),A0
    MOVE.B  D0,(A0)

LAB_10C6:
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_10C7:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEA.L 24(A7),A2
    MOVE.W  30(A7),D7
    MOVE.L  A3,D0
    BEQ.S   LAB_10CB

    MOVE.L  A2,D0
    BEQ.S   LAB_10CB

    TST.W   D7
    BLE.S   LAB_10CB

    MOVEQ   #49,D0
    CMP.W   D0,D7
    BGE.S   LAB_10CB

    LEA     28(A3),A0
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_1355(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BEQ.S   LAB_10C8

    MOVEQ   #0,D6
    BRA.S   LAB_10CC

LAB_10C8:
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    TST.L   56(A2,D0.L)
    BEQ.S   LAB_10C9

    BTST    #7,7(A2,D7.W)
    BEQ.S   LAB_10CA

LAB_10C9:
    MOVEQ   #3,D6
    BRA.S   LAB_10CC

LAB_10CA:
    MOVEQ   #2,D6
    BRA.S   LAB_10CC

LAB_10CB:
    MOVEQ   #1,D6

LAB_10CC:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======

LAB_10CD:
    LINK.W  A5,#-16
    MOVEM.L D4-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVE.L  16(A5),D5
    MOVE.W  22(A5),D4
    CLR.L   -12(A5)
    MOVEQ   #48,D0
    CMP.W   D0,D4
    BGT.S   LAB_10CE

    MOVEQ   #1,D0
    CMP.W   D0,D4
    BNE.S   LAB_10D0

LAB_10CE:
    PEA     2.W
    MOVE.L  D5,-(A7)
    JSR     LAB_1345(PC)

    PEA     2.W
    MOVE.L  D5,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     LAB_133E(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)

LAB_10CF:
    MOVEQ   #48,D0
    CMP.W   D0,D4
    BLE.S   LAB_10D1

    SUBI.W  #$30,D4
    BRA.S   LAB_10CF

LAB_10D0:
    PEA     1.W
    MOVE.L  D6,-(A7)
    JSR     LAB_1345(PC)

    PEA     1.W
    MOVE.L  D6,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     LAB_133E(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)

LAB_10D1:
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   LAB_10C7

    LEA     12(A7),A7
    MOVE.L  D0,-16(A5)
    MOVE.L  D7,D0
    TST.L   D0
    BEQ.S   LAB_10D2

    SUBQ.L  #1,D0
    BEQ.S   LAB_10D3

    SUBQ.L  #1,D0
    BEQ.S   LAB_10D6

    SUBQ.L  #1,D0
    BEQ.S   LAB_10D6

    BRA.S   LAB_10D7

LAB_10D2:
    TST.L   -16(A5)
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-12(A5)
    BRA.S   LAB_10D7

LAB_10D3:
    MOVE.L  -16(A5),D0
    MOVEQ   #1,D1
    CMP.L   D1,D0
    BEQ.S   LAB_10D4

    SUBQ.L  #3,D0
    BEQ.S   LAB_10D4

    MOVEQ   #0,D0
    BRA.S   LAB_10D5

LAB_10D4:
    MOVEQ   #1,D0

LAB_10D5:
    MOVE.L  D0,-12(A5)
    BRA.S   LAB_10D7

LAB_10D6:
    MOVEQ   #3,D1
    CMP.L   -16(A5),D1
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-12(A5)

LAB_10D7:
    MOVE.L  -12(A5),D0
    MOVEM.L (A7)+,D4-D7
    UNLK    A5
    RTS

;!======

LAB_10D8:
    LINK.W  A5,#0
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  22(A5),D7
    MOVE.W  26(A5),D6
    MOVE.L  28(A5),D5
    MOVE.L  D5,D0
    TST.L   D0
    BEQ.S   LAB_10DA

    SUBQ.L  #1,D0
    BEQ.S   LAB_10DB

    SUBQ.L  #1,D0
    BNE.S   LAB_10DB

    TST.W   LAB_2015
    BEQ.S   LAB_10D9

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.B  LAB_1BB8,D2
    MOVEQ   #89,D4
    CMP.B   D4,D2
    SEQ     D3
    NEG.B   D3
    EXT.W   D3
    EXT.L   D3
    PEA     2.W
    MOVE.L  D3,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  16(A5),-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_107F

    LEA     28(A7),A7
    BRA.S   LAB_10DC

LAB_10D9:
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     2.W
    PEA     1.W
    PEA     3.W
    MOVE.L  D0,-(A7)
    MOVE.L  16(A5),-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_107F

    LEA     28(A7),A7
    BRA.S   LAB_10DC

LAB_10DA:
    MOVE.L  LAB_2115,-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1339(PC)

    ADDQ.W  #8,A7
    BRA.S   LAB_10DC

LAB_10DB:
    MOVE.L  LAB_2111,-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1339(PC)

    ADDQ.W  #8,A7

LAB_10DC:
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_10DD:
    LINK.W  A5,#-20
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.W  18(A5),D6
    MOVE.L  20(A5),D5
    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVE.W  LAB_232B,D1
    MULU    D7,D1
    ADD.L   D1,D0
    MOVE.L  D0,D4
    MOVEQ   #36,D1
    ADD.L   D1,D4
    CLR.L   -8(A5)
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    ADD.L   D1,D0
    MOVE.L  A0,-20(A5)
    MOVEQ   #3,D1
    CMP.L   D1,D0
    BLT.S   LAB_10DE

    MOVE.L  #695,D0
    BRA.S   LAB_10DF

LAB_10DE:
    MOVE.W  LAB_232B,D0
    MULU    D6,D0
    MOVE.L  D4,D1
    ADD.L   D0,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,D0

LAB_10DF:
    MOVEQ   #0,D1
    MOVE.W  LAB_2328,D1
    SUBQ.L  #1,D1
    MOVE.L  D0,-12(A5)
    MOVE.L  D1,-16(A5)
    MOVEQ   #0,D0
    NOT.B   D0
    CMP.L   D0,D5
    BEQ.S   LAB_10E0

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D5,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_102F

    LEA     12(A7),A7
    MOVEA.L -20(A5),A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.L  D4,D0
    MOVEA.L -20(A5),A1
    MOVE.L  -8(A5),D1
    MOVE.L  -12(A5),D2
    MOVE.L  -16(A5),D3
    JSR     _LVORectFill(A6)

LAB_10E0:
    MOVEQ   #3,D0
    CMP.W   D0,D6
    BNE.S   LAB_10E1

    MOVE.B  LAB_1BB8,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   LAB_10E1

    MOVE.L  -16(A5),-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  -20(A5),-(A7)
    JSR     LAB_1352(PC)

    LEA     20(A7),A7
    BRA.S   LAB_10E2

LAB_10E1:
    MOVE.L  -16(A5),-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  -20(A5),-(A7)
    JSR     LAB_133D(PC)

    LEA     20(A7),A7

LAB_10E2:
    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======

LAB_10E3:
    LINK.W  A5,#-20
    MOVEM.L D2/D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    JSR     LAB_0FF4(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #42,D1
    ADD.L   D1,D0
    MOVEQ   #0,D5
    MOVE.L  D5,D4
    MOVE.L  D0,-12(A5)

LAB_10E4:
    MOVEQ   #2,D0
    CMP.L   D0,D5
    BGE.W   LAB_10EC

    JSR     LAB_1350(PC)

    TST.L   D0
    BNE.W   LAB_10EC

    MOVE.L  D4,-16(A5)
    JSR     LAB_1351(PC)

    TST.L   D0
    BEQ.S   LAB_10E7

    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    MOVE.L  D0,D1
    TST.L   D1
    BPL.S   LAB_10E5

    ADDQ.L  #1,D1

LAB_10E5:
    ASR.L   #1,D1
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    SUB.L   D2,D1
    SUBQ.L  #4,D1
    TST.L   D1
    BPL.S   LAB_10E6

    ADDQ.L  #1,D1

LAB_10E6:
    ASR.L   #1,D1
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    ADD.L   D2,D1
    SUBQ.L  #1,D1
    ADD.L   D1,-16(A5)
    BRA.S   LAB_10EA

LAB_10E7:
    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    TST.L   D0
    BPL.S   LAB_10E8

    ADDQ.L  #1,D0

LAB_10E8:
    ASR.L   #1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    SUB.L   D1,D0
    TST.L   D0
    BPL.S   LAB_10E9

    ADDQ.L  #1,D0

LAB_10E9:
    ASR.L   #1,D0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D0
    SUBQ.L  #1,D0
    ADD.L   D0,-16(A5)

LAB_10EA:
    LEA     60(A3),A0
    MOVE.L  -16(A5),-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_1346(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D5
    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    TST.L   D0
    BPL.S   LAB_10EB

    ADDQ.L  #1,D0

LAB_10EB:
    ASR.L   #1,D0
    ADD.L   D0,D4
    BRA.W   LAB_10E4

LAB_10EC:
    JSR     LAB_1350(PC)

    MOVE.L  D0,-20(A5)
    BEQ.S   LAB_10ED

    ADD.L   LAB_1CE8,D4
    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVE.L  D4,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_1349(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    MOVE.L  D4,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,(A7)
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_1349(PC)

    LEA     36(A7),A7
    BRA.S   LAB_10EE

LAB_10ED:
    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVE.L  D4,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_1356(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    MOVE.L  D4,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,(A7)
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_1356(PC)

    LEA     36(A7),A7

LAB_10EE:
    MOVE.L  D4,D0
    TST.L   D0
    BPL.S   LAB_10EF

    ADDQ.L  #1,D0

LAB_10EF:
    ASR.L   #1,D0
    MOVE.W  D0,52(A3)
    MOVE.L  -20(A5),D0
    MOVEM.L (A7)+,D2/D4-D7/A3
    UNLK    A5
    RTS

;!======

LAB_10F0:
    LINK.W  A5,#-36
    MOVEM.L D2-D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.W  18(A5),D6
    MOVE.L  20(A5),D5
    LEA     60(A3),A0
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  D5,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A0,-4(A5)
    BSR.W   LAB_10DD

    PEA     -36(A5)
    PEA     -35(A5)
    PEA     -34(A5)
    PEA     -33(A5)
    MOVE.L  28(A5),-(A7)
    MOVE.L  24(A5),-(A7)
    BSR.W   LAB_10BE

    LEA     40(A7),A7
    TST.B   -33(A5)
    BEQ.S   LAB_10F1

    MOVEA.L -4(A5),A1
    LEA     -33(A5),A0
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    BRA.S   LAB_10F2

LAB_10F1:
    MOVEQ   #0,D0

LAB_10F2:
    MOVE.L  D0,-24(A5)
    TST.B   -35(A5)
    BEQ.S   LAB_10F3

    MOVEA.L -4(A5),A1
    LEA     -35(A5),A0
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    BRA.S   LAB_10F4

LAB_10F3:
    MOVEQ   #0,D0

LAB_10F4:
    MOVEQ   #0,D1
    MOVE.W  LAB_232A,D1
    MOVE.W  LAB_232B,D2
    MOVE.L  D7,D3
    MULS    D2,D3
    ADD.L   D3,D1
    ADD.L   -24(A5),D1
    MOVEQ   #42,D2
    ADD.L   D2,D1
    MOVEQ   #0,D2
    MOVE.W  LAB_2328,D2
    MOVE.L  D2,D3
    TST.L   D3
    BPL.S   LAB_10F5

    ADDQ.L  #1,D3

LAB_10F5:
    ASR.L   #1,D3
    MOVEA.L -4(A5),A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D4
    MOVE.W  26(A0),D4
    SUB.L   D4,D3
    SUBQ.L  #4,D3
    TST.L   D3
    BPL.S   LAB_10F6

    ADDQ.L  #1,D3

LAB_10F6:
    ASR.L   #1,D3
    MOVEQ   #0,D4
    MOVE.W  26(A0),D4
    ADD.L   D4,D3
    ADDQ.L  #3,D3
    MOVEQ   #0,D4
    MOVE.W  D2,D4
    TST.L   D4
    BPL.S   LAB_10F7

    ADDQ.L  #1,D4

LAB_10F7:
    ASR.L   #1,D4
    MOVE.L  D0,-28(A5)
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    SUB.L   D0,D4
    SUBQ.L  #4,D4
    TST.L   D4
    BPL.S   LAB_10F8

    ADDQ.L  #1,D4

LAB_10F8:
    ASR.L   #1,D4
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    ADD.L   D0,D4
    MOVEQ   #0,D0
    MOVE.W  D2,D0
    TST.L   D0
    BPL.S   LAB_10F9

    ADDQ.L  #1,D0

LAB_10F9:
    ASR.L   #1,D0
    ADD.L   D0,D4
    SUBQ.L  #1,D4
    MOVEQ   #0,D0
    MOVE.W  D2,D0
    TST.L   D0
    BPL.S   LAB_10FA

    ADDQ.L  #1,D0

LAB_10FA:
    ASR.L   #1,D0
    MOVE.L  D4,-16(A5)
    MOVEQ   #0,D4
    MOVE.W  26(A0),D4
    SUB.L   D4,D0
    TST.L   D0
    BPL.S   LAB_10FB

    ADDQ.L  #1,D0

LAB_10FB:
    ASR.L   #1,D0
    MOVEQ   #0,D4
    MOVE.W  26(A0),D4
    ADD.L   D4,D0
    MOVEQ   #0,D4
    MOVE.W  D2,D4
    TST.L   D4
    BPL.S   LAB_10FC

    ADDQ.L  #1,D4

LAB_10FC:
    ASR.L   #1,D4
    ADD.L   D4,D0
    SUBQ.L  #1,D0
    MOVE.L  D3,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  D0,-20(A5)
    MOVE.L  D1,-8(A5)
    MOVE.L  D3,-12(A5)
    JSR     LAB_1346(PC)

    JSR     LAB_1350(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   LAB_10FF

    JSR     LAB_1351(PC)

    TST.L   D0
    BEQ.S   LAB_10FD

    MOVE.L  -16(A5),D0
    BRA.S   LAB_10FE

LAB_10FD:
    MOVE.L  -20(A5),D0

LAB_10FE:
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     LAB_1346(PC)

    LEA     12(A7),A7

LAB_10FF:
    TST.B   -33(A5)
    BEQ.S   LAB_1100

    MOVE.L  -24(A5),D0
    SUB.L   D0,-8(A5)
    MOVEA.L -4(A5),A1
    MOVE.L  -8(A5),D0
    MOVE.L  -12(A5),D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L -4(A5),A1
    LEA     -33(A5),A0
    MOVEQ   #1,D0
    JSR     _LVOText(A6)

    MOVEA.L -4(A5),A1
    MOVE.L  -8(A5),D0
    MOVE.L  -16(A5),D1
    JSR     _LVOMove(A6)

    MOVEA.L -4(A5),A1
    LEA     -34(A5),A0
    MOVEQ   #1,D0
    JSR     _LVOText(A6)

LAB_1100:
    TST.B   -35(A5)
    BEQ.S   LAB_1101

    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVE.W  LAB_232B,D1
    MULU    #3,D1
    ADD.L   D1,D0
    SUB.L   -28(A5),D0
    MOVEQ   #29,D1
    ADD.L   D1,D0
    MOVE.L  D0,-8(A5)
    MOVEA.L -4(A5),A1
    MOVE.L  -12(A5),D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L -4(A5),A1
    LEA     -35(A5),A0
    MOVEQ   #1,D0
    JSR     _LVOText(A6)

    MOVEA.L -4(A5),A1
    MOVE.L  -8(A5),D0
    MOVE.L  -16(A5),D1
    JSR     _LVOMove(A6)

    MOVEA.L -4(A5),A1
    LEA     -36(A5),A0
    MOVEQ   #1,D0
    JSR     _LVOText(A6)

LAB_1101:
    JSR     LAB_1350(PC)

    MOVE.L  D0,-32(A5)
    BEQ.S   LAB_1102

    MOVEQ   #3,D0
    CMP.W   D0,D6
    BNE.S   LAB_1102

    MOVE.B  LAB_1BB8,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   LAB_1102

    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2328,D1
    ADD.L   LAB_1CE8,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,-(A7)
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     LAB_135A(PC)

    LEA     20(A7),A7

LAB_1102:
    MOVE.L  -32(A5),D0
    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======

LAB_1103:
    MOVEM.L D2/D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEQ   #0,D7
    MOVEQ   #0,D7
    NOT.B   D7
    MOVE.L  A3,D0
    BEQ.S   LAB_1107

    MOVEQ   #0,D0
    MOVE.B  41(A3),D0
    MOVEQ   #0,D1
    NOT.B   D1
    CMP.L   D1,D0
    BEQ.S   LAB_1104

    MOVEQ   #0,D7
    MOVE.B  D0,D7
    BRA.S   LAB_1107

LAB_1104:
    BTST    #1,27(A3)
    BEQ.S   LAB_1105

    MOVEQ   #4,D7
    BRA.S   LAB_1107

LAB_1105:
    BTST    #6,27(A3)
    BEQ.S   LAB_1106

    MOVEQ   #5,D7
    BRA.S   LAB_1107

LAB_1106:
    BTST    #4,27(A3)
    BEQ.S   LAB_1107

    MOVEQ   #7,D7

LAB_1107:
    MOVEQ   #0,D0
    NOT.B   D0
    CMP.L   D0,D7
    BNE.S   LAB_110B

    MOVE.L  LAB_2014,D0
    SUBQ.L  #1,D0
    BLT.S   LAB_110A

    CMPI.L  #$7,D0
    BGE.S   LAB_110A

    ADD.W   D0,D0
    MOVE.W  LAB_1108(PC,D0.W),D0
    JMP     LAB_1108+2(PC,D0.W)

; TODO: Switch case
LAB_1108:
    DC.W    $0028
    DC.W    $000c
    DC.W    $000c
    DC.W    $000c
    DC.W    $0010
    DC.W    $0018
    DC.W    $0020

    MOVEQ   #6,D7
    BRA.S   LAB_110B

    MOVE.L  LAB_22CE,D7
    BRA.S   LAB_110B

    MOVE.L  LAB_22DF,D7
    BRA.S   LAB_110B

    MOVE.L  LAB_22EE,D7
    BRA.S   LAB_110B

LAB_110A:
    MOVEQ   #7,D7

LAB_110B:
    TST.L   D7
    BMI.S   LAB_110C

    MOVEQ   #15,D0
    CMP.L   D0,D7
    BLE.S   LAB_110D

LAB_110C:
    MOVEQ   #7,D7

LAB_110D:
    MOVEQ   #0,D0
    NOT.B   D0
    MOVE.L  D0,LAB_2334
    MOVE.L  A3,D1
    BEQ.S   LAB_110E

    MOVEQ   #0,D1
    MOVE.B  42(A3),D1
    CMP.L   D0,D1
    BEQ.S   LAB_110E

    MOVEQ   #0,D2
    MOVE.B  D1,D2
    MOVE.L  D2,LAB_2334

LAB_110E:
    CMP.L   LAB_2334,D0
    BNE.S   LAB_1112

    MOVE.L  LAB_2014,D0
    SUBQ.L  #1,D0
    BLT.S   LAB_1111

    CMPI.L  #$7,D0
    BGE.S   LAB_1111

    ADD.W   D0,D0
    MOVE.W  LAB_110F(PC,D0.W),D0
    JMP     LAB_110F+2(PC,D0.W)

; TODO: Switch case
LAB_110F:
    DC.W    $0030
    DC.W    $0030
    DC.W    $0030
    DC.W    $0030
    DC.W    $000c
    DC.W    $0018
    DC.W    $0024


    MOVE.L  LAB_22CD,LAB_2334
    BRA.S   LAB_1112

    MOVE.L  LAB_22DD,LAB_2334
    BRA.S   LAB_1112

    MOVE.L  LAB_22EC,LAB_2334
    BRA.S   LAB_1112

LAB_1111:
    MOVEQ   #1,D0
    MOVE.L  D0,LAB_2334

LAB_1112:
    MOVE.L  LAB_2334,D0
    MOVEQ   #1,D1
    CMP.L   D1,D0
    BLT.S   LAB_1113

    MOVEQ   #3,D2
    CMP.L   D2,D0
    BLE.S   LAB_1114

LAB_1113:
    MOVE.L  D1,LAB_2334

LAB_1114:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D2/D7/A3
    RTS

;!======

LAB_1115:
    LINK.W  A5,#-48
    MOVEM.L D2-D3/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.W  18(A5),D6
    MOVEQ   #-1,D5
    MOVEQ   #1,D0
    MOVE.L  D0,-46(A5)
    MOVE.L  A3,D0
    BNE.S   LAB_1116

    MOVEQ   #4,D0
    MOVE.L  D0,LAB_201C
    BRA.W   LAB_113F

LAB_1116:
    MOVE.L  LAB_201C,D0
    SUBQ.L  #4,D0
    BEQ.S   LAB_1117

    SUBQ.L  #1,D0
    BNE.W   LAB_113E

    MOVE.L  LAB_232D,-(A7)
    MOVE.L  LAB_232E,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_10E3

    MOVEQ   #-1,D0
    MOVE.L  D0,32(A3)
    JSR     LAB_1350(PC)

    LEA     12(A7),A7
    TST.L   D0
    BEQ.W   LAB_113F

    MOVEQ   #4,D0
    MOVE.L  D0,LAB_201C
    BRA.W   LAB_113F

LAB_1117:
    MOVEQ   #44,D0
    CMP.W   D0,D6
    BGT.S   LAB_1118

    MOVEQ   #1,D0
    CMP.W   D0,D6
    BEQ.S   LAB_1118

    PEA     LAB_223A
    JSR     LAB_134A(PC)

    ADDQ.W  #4,A7
    SUBQ.W  #1,D0
    BNE.S   LAB_1119

LAB_1118:
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2236,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,-(A7)
    JSR     LAB_133B(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D5
    BRA.S   LAB_111A

LAB_1119:
    MOVEQ   #-1,D5

LAB_111A:
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    BSR.W   LAB_1103

    ADDQ.W  #4,A7
    MOVE.L  D0,LAB_2333
    MOVEQ   #5,D0
    CMP.L   LAB_2014,D0
    BNE.S   LAB_111B

    MOVE.L  LAB_22CE,LAB_232E
    BRA.S   LAB_111C

LAB_111B:
    MOVEQ   #7,D0
    MOVE.L  D0,LAB_232E

LAB_111C:
    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_2333,-(A7)
    MOVE.L  LAB_232E,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    JSR     LAB_0FF4(PC)

    LEA     20(A7),A7
    CLR.W   -18(A5)

LAB_111D:
    MOVE.W  -18(A5),D0
    MOVEQ   #3,D1
    CMP.W   D1,D0
    BGE.W   LAB_113A

    SUBA.L  A0,A0
    CLR.W   -22(A5)
    MOVEQ   #0,D1
    MOVEQ   #0,D2
    NOT.B   D2
    MOVE.L  D6,D3
    EXT.L   D3
    EXT.L   D0
    ADD.L   D0,D3
    MOVE.L  D1,-34(A5)
    MOVE.L  D1,-38(A5)
    MOVE.L  D2,LAB_232D
    MOVE.L  D2,LAB_232C
    MOVE.L  A0,-12(A5)
    MOVE.L  A0,-4(A5)
    MOVEQ   #48,D0
    CMP.L   D0,D3
    BGT.S   LAB_111E

    MOVEQ   #1,D0
    CMP.W   D0,D6
    BEQ.S   LAB_111E

    PEA     LAB_223A
    JSR     LAB_134A(PC)

    ADDQ.W  #4,A7
    SUBQ.W  #1,D0
    BNE.S   LAB_1121

LAB_111E:
    PEA     2.W
    MOVE.L  D5,-(A7)
    JSR     LAB_1345(PC)

    PEA     2.W
    MOVE.L  D5,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     LAB_133E(PC)

    LEA     16(A7),A7
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.W  -18(A5),D2
    EXT.L   D2
    ADD.L   D2,D1
    MOVE.L  D0,-12(A5)
    MOVEQ   #48,D0
    CMP.L   D0,D1
    BLE.S   LAB_111F

    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.W  -18(A5),D2
    EXT.L   D2
    ADD.L   D2,D1
    SUB.L   D0,D1
    BRA.S   LAB_1120

LAB_111F:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.W  -18(A5),D1
    EXT.L   D1
    ADD.L   D1,D0
    MOVE.L  D0,D1

LAB_1120:
    MOVE.W  D1,-24(A5)
    MOVE.W  D1,-20(A5)
    ADDI.W  #$30,D1
    MOVE.W  D1,-26(A5)
    BRA.S   LAB_1122

LAB_1121:
    PEA     1.W
    MOVE.L  D7,-(A7)
    JSR     LAB_1345(PC)

    PEA     1.W
    MOVE.L  D7,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     LAB_133E(PC)

    LEA     16(A7),A7
    MOVE.L  D6,D1
    MOVE.W  -18(A5),D2
    ADD.W   D2,D1
    MOVE.L  D0,-12(A5)
    MOVE.W  D1,-26(A5)
    MOVE.W  D1,-24(A5)
    MOVE.W  D1,-20(A5)

LAB_1122:
    TST.L   -4(A5)
    BEQ.W   LAB_1136

    TST.L   -12(A5)
    BEQ.W   LAB_1136

    TST.W   -18(A5)
    BNE.S   LAB_1123

    MOVEA.L -4(A5),A0
    MOVE.L  A0,-8(A5)

LAB_1123:
    MOVE.W  -24(A5),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   LAB_10C7

    LEA     12(A7),A7
    MOVE.W  #1,-22(A5)
    MOVE.L  D0,-30(A5)

LAB_1124:
    MOVE.W  -18(A5),D0
    EXT.L   D0
    MOVE.W  -22(A5),D1
    EXT.L   D1
    ADD.L   D1,D0
    MOVEQ   #3,D1
    CMP.L   D1,D0
    BGE.S   LAB_1125

    MOVE.W  -26(A5),D0
    ADD.W   -22(A5),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  -30(A5),-(A7)
    BSR.W   LAB_10CD

    LEA     16(A7),A7
    TST.L   D0
    BEQ.S   LAB_1125

    ADDQ.W  #1,-22(A5)
    BRA.S   LAB_1124

LAB_1125:
    MOVEQ   #3,D0
    CMP.L   -30(A5),D0
    BNE.S   LAB_1127

    MOVE.W  -24(A5),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     LAB_1353(PC)

    LEA     12(A7),A7
    MOVE.W  D0,-20(A5)
    BNE.S   LAB_1126

    MOVEQ   #1,D1
    MOVE.L  D1,-30(A5)
    BRA.S   LAB_1127

LAB_1126:
    MOVEQ   #2,D1
    MOVE.L  D1,-30(A5)

LAB_1127:
    MOVEQ   #2,D0
    CMP.L   -30(A5),D0
    BNE.W   LAB_1134

    TST.W   -18(A5)
    BNE.W   LAB_112D

    MOVE.W  -24(A5),D1
    EXT.L   D1
    MOVE.W  -20(A5),D2
    EXT.L   D2
    SUB.L   D2,D1
    MOVEQ   #1,D2
    CMP.L   D2,D1
    BLE.S   LAB_1128

    MOVE.L  D0,-34(A5)
    BRA.W   LAB_112D

LAB_1128:
    MOVE.W  -24(A5),D0
    EXT.L   D0
    MOVE.W  -20(A5),D1
    EXT.L   D1
    SUB.L   D1,D0
    SUBQ.L  #1,D0
    BNE.S   LAB_1129

    MOVE.L  D2,-34(A5)
    BRA.S   LAB_112D

LAB_1129:
    MOVEQ   #1,D0
    CMP.W   -24(A5),D0
    BNE.S   LAB_112B

    MOVEA.L -12(A5),A0
    BTST    #7,8(A0)
    BEQ.S   LAB_112B

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2233,A1
    ADDA.L  D0,A1
    LEA     LAB_2236,A2
    ADDA.L  D0,A2
    PEA     48.W
    MOVE.L  (A2),-(A7)
    MOVE.L  (A1),-(A7)
    BSR.W   LAB_10C7

    LEA     12(A7),A7
    SUBQ.L  #2,D0
    BEQ.S   LAB_112A

    MOVEQ   #2,D0
    MOVE.L  D0,-34(A5)
    BRA.S   LAB_112D

LAB_112A:
    MOVEQ   #1,D0
    MOVE.L  D0,-34(A5)
    BRA.S   LAB_112D

LAB_112B:
    MOVEQ   #2,D0
    CMP.W   -24(A5),D0
    BNE.S   LAB_112D

    MOVEQ   #1,D0
    CMP.W   -20(A5),D0
    BNE.S   LAB_112D

    MOVEA.L -12(A5),A0
    BTST    #7,8(A0)
    BNE.S   LAB_112C

    MOVE.L  D2,-34(A5)
    BRA.S   LAB_112D

LAB_112C:
    MOVEQ   #2,D0
    MOVE.L  D0,-34(A5)

LAB_112D:
    MOVE.W  -18(A5),D0
    EXT.L   D0
    MOVE.W  -22(A5),D1
    EXT.L   D1
    ADD.L   D1,D0
    SUBQ.L  #3,D0
    BNE.S   LAB_112F

    MOVE.W  -26(A5),D0
    ADD.W   -22(A5),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  -30(A5),-(A7)
    BSR.W   LAB_10CD

    LEA     16(A7),A7
    TST.L   D0
    BEQ.S   LAB_112F

    MOVE.W  -26(A5),D0
    ADD.W   -22(A5),D0
    ADDQ.W  #1,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  -30(A5),-(A7)
    BSR.W   LAB_10CD

    LEA     16(A7),A7
    TST.L   D0
    BEQ.S   LAB_112E

    MOVEQ   #2,D0
    MOVE.L  D0,-38(A5)
    BRA.S   LAB_112F

LAB_112E:
    MOVEQ   #1,D0
    MOVE.L  D0,-38(A5)

LAB_112F:
    MOVE.L  LAB_2334,D0
    MOVE.L  D0,LAB_232C
    MOVEA.L -12(A5),A0
    MOVE.W  -20(A5),D0
    BTST    #2,7(A0,D0.W)
    BEQ.S   LAB_1130

    MOVEQ   #5,D0
    MOVE.L  D0,LAB_232D
    BRA.S   LAB_1131

LAB_1130:
    MOVE.L  #$ff,LAB_232D

LAB_1131:
    MOVE.W  -22(A5),D0
    MOVEQ   #3,D1
    CMP.W   D1,D0
    BNE.S   LAB_1132

    MOVE.B  LAB_1BB8,D1
    MOVEQ   #89,D2
    CMP.B   D2,D1
    BNE.S   LAB_1132

    MOVEQ   #20,D1
    BRA.S   LAB_1133

LAB_1132:
    MOVEQ   #2,D1

LAB_1133:
    MOVE.W  LAB_232B,D2
    MULU    D0,D2
    MOVEQ   #12,D0
    SUB.L   D0,D2
    MOVE.L  LAB_232C,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-42(A5)
    JSR     LAB_1358(PC)

    LEA     60(A3),A0
    MOVE.L  -38(A5),(A7)
    MOVE.L  -34(A5),-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_1354(PC)

    LEA     60(A3),A0
    MOVE.W  -20(A5),D0
    EXT.L   D0
    MOVE.W  -22(A5),D1
    EXT.L   D1
    MOVE.L  -30(A5),(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_10D8

    LEA     40(A7),A7
    BRA.W   LAB_1138

LAB_1134:
    MOVE.W  -22(A5),D0
    MOVEQ   #3,D1
    CMP.W   D1,D0
    BGE.S   LAB_1135

    MOVEQ   #1,D1
    MOVE.L  #$ff,LAB_232D
    MOVE.W  LAB_232B,D2
    MULU    D0,D2
    MOVEQ   #12,D0
    SUB.L   D0,D2
    MOVE.L  D1,-(A7)
    PEA     2.W
    MOVE.L  D2,-(A7)
    MOVE.L  D1,LAB_232C
    JSR     LAB_1358(PC)

    LEA     60(A3),A0
    MOVE.W  -20(A5),D0
    EXT.L   D0
    MOVE.W  -22(A5),D1
    EXT.L   D1
    MOVE.L  -30(A5),(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_10D8

    LEA     32(A7),A7
    BRA.S   LAB_1138

LAB_1135:
    CLR.L   -46(A5)
    BRA.S   LAB_1138

LAB_1136:
    MOVEQ   #3,D0
    MOVE.L  D0,D1
    SUB.W   -18(A5),D1
    MOVEM.W D1,-22(A5)
    CMP.W   D0,D1
    BGE.S   LAB_1137

    MOVEQ   #1,D0
    MOVE.L  #$ff,LAB_232D
    MOVE.W  LAB_232B,D2
    MULU    D1,D2
    MOVEQ   #12,D1
    SUB.L   D1,D2
    MOVE.L  D0,-(A7)
    PEA     2.W
    MOVE.L  D2,-(A7)
    MOVE.L  D0,LAB_232C
    MOVE.L  D0,-30(A5)
    JSR     LAB_1358(PC)

    LEA     60(A3),A0
    MOVE.W  -20(A5),D0
    EXT.L   D0
    MOVE.W  -22(A5),D1
    EXT.L   D1
    MOVE.L  -30(A5),(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_10D8

    LEA     32(A7),A7
    BRA.S   LAB_1138

LAB_1137:
    MOVEQ   #0,D0
    MOVE.L  D0,-46(A5)

LAB_1138:
    TST.L   -46(A5)
    BEQ.S   LAB_1139

    MOVE.W  -18(A5),D0
    EXT.L   D0
    MOVE.W  -22(A5),D1
    EXT.L   D1
    MOVE.L  -38(A5),-(A7)
    MOVE.L  -34(A5),-(A7)
    MOVE.L  LAB_232D,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_10F0

    LEA     24(A7),A7

LAB_1139:
    MOVE.W  -22(A5),D0
    ADD.W   D0,-18(A5)
    BRA.W   LAB_111D

LAB_113A:
    TST.L   -46(A5)
    BEQ.W   LAB_113D

    MOVEQ   #3,D0
    CMP.W   -22(A5),D0
    BNE.S   LAB_113B

    MOVE.B  LAB_1BB8,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   LAB_113B

    JSR     LAB_1350(PC)

    TST.L   D0
    BNE.S   LAB_113B

    LEA     60(A3),A0
    CLR.L   -(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_1066

    LEA     12(A7),A7
    MOVEQ   #5,D0
    MOVE.L  D0,LAB_201C
    MOVEQ   #0,D0
    NOT.B   D0
    CMP.L   LAB_232D,D0
    BNE.S   LAB_113C

    MOVE.L  LAB_2333,LAB_232D
    BRA.S   LAB_113C

LAB_113B:
    LEA     60(A3),A0
    PEA     1.W
    MOVE.L  -8(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_1066

    LEA     12(A7),A7
    MOVEQ   #4,D0
    MOVE.L  D0,LAB_201C

LAB_113C:
    MOVE.W  LAB_2328,D0
    LSR.W   #1,D0
    MOVE.W  D0,52(A3)
    PEA     2.W
    JSR     LAB_1344(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,32(A3)
    BRA.S   LAB_113F

LAB_113D:
    CLR.W   52(A3)
    MOVEQ   #4,D0
    MOVE.L  D0,LAB_201C
    BRA.S   LAB_113F

LAB_113E:
    MOVEQ   #4,D0
    MOVE.L  D0,LAB_201C

LAB_113F:
    MOVE.L  LAB_201C,D0
    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_1140:
    LINK.W  A5,#-8
    MOVEM.L D5-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVEQ   #0,D5
    MOVE.L  D7,D0
    SUBQ.L  #3,D0
    BEQ.S   LAB_1141

    SUBQ.L  #1,D0
    BEQ.S   LAB_1142

    BRA.S   LAB_1143

LAB_1141:
    MOVEQ   #0,D6
    BRA.S   LAB_1144

LAB_1142:
    ADDQ.L  #1,D6
    BRA.S   LAB_1144

LAB_1143:
    MOVEQ   #1,D5

LAB_1144:
    TST.L   D5
    BNE.S   LAB_1148

    TST.B   LAB_224A
    BEQ.S   LAB_1148

LAB_1145:
    TST.L   D5
    BNE.S   LAB_1147

    MOVEQ   #0,D0
    MOVE.W  LAB_2231,D0
    CMP.L   D0,D6
    BGE.S   LAB_1147

    PEA     1.W
    MOVE.L  D6,-(A7)
    JSR     LAB_1345(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   LAB_1146

    MOVEA.L D0,A0
    BTST    #0,47(A0)
    BEQ.S   LAB_1146

    BTST    #7,40(A0)
    BEQ.S   LAB_1146

    MOVEQ   #1,D5
    BRA.S   LAB_1145

LAB_1146:
    ADDQ.L  #1,D6
    BRA.S   LAB_1145

LAB_1147:
    TST.L   D5
    BNE.S   LAB_1148

    MOVEQ   #-1,D6

LAB_1148:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D5-D7
    UNLK    A5
    RTS

;!======

LAB_1149:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVE.W  22(A7),D7
    MOVEQ   #0,D6
    MOVE.L  A3,D0
    BNE.S   LAB_114C

    MOVEQ   #5,D0
    CMP.L   LAB_201F,D0
    BNE.S   LAB_114B

    MOVE.L  LAB_201E,D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    JSR     LAB_0FF5(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   LAB_114A

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_10B5

    LEA     12(A7),A7
    BRA.S   LAB_114B

LAB_114A:
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1115

    LEA     12(A7),A7

LAB_114B:
    MOVEQ   #0,D0
    MOVE.L  D0,LAB_201F
    MOVE.L  D0,LAB_201E
    BRA.W   LAB_1154

LAB_114C:
    MOVE.L  LAB_201F,D0
    TST.L   D0
    BEQ.S   LAB_114D

    SUBQ.L  #3,D0
    BEQ.S   LAB_114E

    SUBQ.L  #1,D0
    BEQ.S   LAB_114E

    SUBQ.L  #1,D0
    BEQ.S   LAB_114F

    BRA.W   LAB_1153

LAB_114D:
    CLR.L   LAB_201D
    MOVEQ   #3,D0
    MOVE.L  D0,LAB_201F

LAB_114E:
    MOVE.L  LAB_201E,-(A7)
    MOVE.L  LAB_201F,-(A7)
    BSR.W   LAB_1140

    ADDQ.W  #8,A7
    MOVEQ   #1,D6
    MOVE.L  D0,LAB_201E

LAB_114F:
    MOVE.L  LAB_201E,D0
    MOVEQ   #-1,D1
    CMP.L   D1,D0
    BEQ.W   LAB_1153

    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    JSR     LAB_0FF5(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   LAB_1150

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_201E,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_10B5

    LEA     12(A7),A7
    MOVE.L  D0,LAB_201F
    BRA.S   LAB_1151

LAB_1150:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_201E,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1115

    LEA     12(A7),A7
    MOVE.L  D0,LAB_201F
    TST.L   D6
    BEQ.S   LAB_1151

    CMPI.L  #$1,LAB_201D
    BGE.S   LAB_1151

    SUBQ.L  #5,D0
    BNE.S   LAB_1151

    MOVE.B  LAB_1BB9,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   LAB_1151

    PEA     48.W
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1038

    BSR.W   LAB_106E

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_201D

LAB_1151:
    MOVE.B  LAB_1BB2,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   LAB_1152

    TST.L   D6
    BEQ.S   LAB_1152

    CMPI.L  #$1,LAB_201D
    BGE.S   LAB_1152

    PEA     32.W
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1038

    BSR.W   LAB_106E

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_201D

LAB_1152:
    MOVE.L  LAB_201D,D0
    TST.L   D0
    BLE.S   LAB_1154

    MOVE.L  A3,-(A7)
    BSR.W   LAB_106B

    ADDQ.W  #4,A7
    SUB.L   D0,LAB_201D
    BRA.S   LAB_1154

LAB_1153:
    CLR.L   LAB_201F

LAB_1154:
    MOVE.L  LAB_201F,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

LAB_1155:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.L  24(A7),D7
    MOVE.L  28(A7),D6
    MOVEA.L 32(A7),A2
    MOVE.L  A3,D0
    BNE.S   LAB_1156

    MOVEQ   #4,D0
    MOVE.L  D0,LAB_2020
    BRA.S   LAB_115E

LAB_1156:
    MOVE.L  LAB_2020,D0
    SUBQ.L  #4,D0
    BEQ.S   LAB_1157

    SUBQ.L  #1,D0
    BEQ.S   LAB_115A

    BRA.S   LAB_115D

LAB_1157:
    MOVE.L  D7,-(A7)
    PEA     20.W
    PEA     612.W
    JSR     LAB_1358(PC)

    LEA     60(A3),A0
    MOVE.L  A2,(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_1339(PC)

    CLR.L   (A7)
    JSR     LAB_1344(PC)

    MOVE.L  D0,32(A3)
    MOVE.L  D6,(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_10A2

    LEA     20(A7),A7
    TST.L   D0
    BEQ.S   LAB_1158

    MOVEQ   #4,D0
    BRA.S   LAB_1159

LAB_1158:
    MOVEQ   #5,D0

LAB_1159:
    MOVE.L  D0,LAB_2020
    BRA.S   LAB_115E

LAB_115A:
    MOVEQ   #-1,D0
    MOVE.L  D0,32(A3)
    MOVE.L  D6,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_10A2

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   LAB_115B

    MOVEQ   #4,D0
    BRA.S   LAB_115C

LAB_115B:
    MOVEQ   #5,D0

LAB_115C:
    MOVE.L  D0,LAB_2020
    BRA.S   LAB_115E

LAB_115D:
    MOVEQ   #4,D0
    MOVE.L  D0,LAB_2020

LAB_115E:
    MOVE.L  LAB_2020,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======

LAB_115F:
    LINK.W  A5,#-8
    MOVEM.L D5-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVEQ   #0,D5
    MOVE.L  D7,D0
    TST.L   D0
    BEQ.S   LAB_1160

    SUBQ.L  #4,D0
    BEQ.S   LAB_1161

    BRA.S   LAB_1162

LAB_1160:
    MOVEQ   #0,D6
    BRA.S   LAB_1163

LAB_1161:
    ADDQ.L  #1,D6
    BRA.S   LAB_1163

LAB_1162:
    MOVEQ   #1,D5

LAB_1163:
    TST.L   D5
    BNE.S   LAB_1167

LAB_1164:
    TST.L   D5
    BNE.S   LAB_1166

    MOVEQ   #0,D0
    MOVE.W  LAB_2231,D0
    CMP.L   D0,D6
    BGE.S   LAB_1166

    TST.B   LAB_224A
    BEQ.S   LAB_1166

    PEA     1.W
    MOVE.L  D6,-(A7)
    JSR     LAB_1345(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.S   LAB_1165

    MOVEA.L D0,A0
    BTST    #2,47(A0)
    BEQ.S   LAB_1165

    BTST    #7,40(A0)
    BEQ.S   LAB_1165

    MOVEQ   #1,D5
    BRA.S   LAB_1164

LAB_1165:
    ADDQ.L  #1,D6
    BRA.S   LAB_1164

LAB_1166:
    TST.L   D5
    BNE.S   LAB_1167

    MOVEQ   #-1,D6

LAB_1167:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D5-D7
    UNLK    A5
    RTS

;!======

LAB_1168:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVE.W  22(A7),D7
    MOVEQ   #0,D6
    MOVE.L  A3,D0
    BNE.S   LAB_116D

    MOVE.L  LAB_2022,D0
    SUBQ.L  #2,D0
    BEQ.S   LAB_1169

    SUBQ.L  #3,D0
    BEQ.S   LAB_116A

    SUBQ.L  #2,D0
    BNE.S   LAB_116C

LAB_1169:
    CLR.L   -(A7)
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1155

    LEA     16(A7),A7
    BRA.S   LAB_116C

LAB_116A:
    MOVE.L  LAB_2021,D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    JSR     LAB_0FF5(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   LAB_116B

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_10B5

    LEA     12(A7),A7
    BRA.S   LAB_116C

LAB_116B:
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1115

    LEA     12(A7),A7

LAB_116C:
    MOVEQ   #0,D0
    MOVE.L  D0,LAB_2022
    MOVE.L  D0,LAB_2021
    BRA.W   LAB_117A

LAB_116D:
    MOVE.L  LAB_2022,D0
    CMPI.L  #$8,D0
    BCC.W   LAB_117A

    ADD.W   D0,D0
    MOVE.W  LAB_116E(PC,D0.W),D0
    JMP     LAB_116E+2(PC,D0.W)

; TODO: Switch case
LAB_116E:
    DC.W    LAB_116E_000E-LAB_116E-2
    DC.W    $01e6
    DC.W    $003a
    DC.W    $0092
    DC.W    $0092
    DC.W    $00ac
    DC.W    $01e6
    DC.W    $0194

LAB_116E_000E:
    CLR.L   LAB_2023
    MOVE.L  LAB_2021,-(A7)
    MOVE.L  LAB_2022,-(A7)
    BSR.W   LAB_115F

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_2021
    ADDQ.L  #1,D0
    BEQ.W   LAB_117A

    MOVEQ   #2,D0
    MOVE.L  D0,LAB_2022
    MOVE.B  LAB_22D3,D0
    MOVEQ   #66,D1
    CMP.B   D1,D0
    BEQ.S   LAB_1170

    MOVEQ   #70,D1
    CMP.B   D1,D0
    BNE.S   LAB_1172

LAB_1170:
    MOVE.L  LAB_22D4,-(A7)
    MOVE.L  LAB_22D0,-(A7)
    MOVE.L  LAB_22CF,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1155

    LEA     16(A7),A7
    MOVE.L  D0,LAB_2022
    SUBQ.L  #5,D0
    BNE.S   LAB_1171

    MOVEQ   #2,D0
    MOVE.L  D0,LAB_2022
    BRA.W   LAB_117A

LAB_1171:
    MOVEQ   #3,D0
    MOVE.L  D0,LAB_2022
    BRA.W   LAB_117A

LAB_1172:
    MOVEQ   #3,D0
    MOVE.L  D0,LAB_2022
    MOVE.L  LAB_2021,-(A7)
    MOVE.L  LAB_2022,-(A7)
    BSR.W   LAB_115F

    ADDQ.W  #8,A7
    MOVEQ   #1,D6
    MOVE.L  D0,LAB_2021
    MOVE.L  LAB_2021,D0
    MOVEQ   #-1,D1
    CMP.L   D1,D0
    BEQ.W   LAB_1176

    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    JSR     LAB_0FF5(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   LAB_1173

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_2021,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_10B5

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2022
    BRA.S   LAB_1174

LAB_1173:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_2021,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1115

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2022
    TST.L   D6
    BEQ.S   LAB_1174

    CMPI.L  #$1,LAB_2023
    BGE.S   LAB_1174

    SUBQ.L  #5,D0
    BNE.S   LAB_1174

    MOVE.B  LAB_1BB9,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   LAB_1174

    PEA     49.W
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1038

    BSR.W   LAB_106E

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_2023

LAB_1174:
    MOVE.B  LAB_22CC,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   LAB_1175

    TST.L   D6
    BEQ.S   LAB_1175

    CMPI.L  #$1,LAB_2023
    BGE.S   LAB_1175

    PEA     33.W
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1038

    BSR.W   LAB_106E

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_2023

LAB_1175:
    MOVE.L  LAB_2023,D0
    TST.L   D0
    BLE.S   LAB_117A

    MOVE.L  A3,-(A7)
    BSR.W   LAB_106B

    ADDQ.W  #4,A7
    SUB.L   D0,LAB_2023
    BRA.S   LAB_117A

LAB_1176:
    MOVEQ   #7,D0
    MOVE.L  D0,LAB_2022
    MOVE.B  LAB_22D3,D0
    MOVEQ   #66,D1
    CMP.B   D1,D0
    BEQ.S   LAB_1177

    MOVEQ   #76,D1
    CMP.B   D1,D0
    BNE.S   LAB_1179

LAB_1177:
    MOVE.L  LAB_22D4,-(A7)
    MOVE.L  LAB_22D0,-(A7)
    MOVE.L  LAB_22CF,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1155

    LEA     16(A7),A7
    MOVE.L  D0,LAB_2022
    SUBQ.L  #5,D0
    BNE.S   LAB_1178

    MOVEQ   #7,D0
    MOVE.L  D0,LAB_2022
    BRA.S   LAB_117A

LAB_1178:
    MOVEQ   #0,D0
    MOVE.L  D0,LAB_2022
    BRA.S   LAB_117A

LAB_1179:
    CLR.L   LAB_2022

LAB_117A:
    MOVE.L  LAB_2022,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

LAB_117B:
    LINK.W  A5,#-172
    MOVEM.L D2/D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  18(A5),D7
    PEA     33.W
    MOVEQ   #6,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    JSR     LAB_0FF4(PC)

    MOVEA.L LAB_210B,A0
    LEA     -128(A5),A1

LAB_117C:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_117C

    MOVE.L  D7,D0
    EXT.L   D0
    PEA     -159(A5)
    MOVE.L  D0,-(A7)
    JSR     LAB_1348(PC)

    PEA     -159(A5)
    PEA     -128(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_3(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    PEA     33.W
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_133D(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    PEA     33.W
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_133D(PC)

    LEA     76(A7),A7
    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #3,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVE.W  LAB_232B,D1
    MULU    #3,D1
    LEA     60(A3),A1
    LEA     -128(A5),A2
    MOVEA.L A2,A6

LAB_117D:
    TST.B   (A6)+
    BNE.S   LAB_117D

    SUBQ.L  #1,A6
    SUBA.L  A2,A6
    MOVE.L  D0,24(A7)
    MOVE.L  D1,28(A7)
    MOVE.L  A0,20(A7)
    MOVEA.L A2,A0
    MOVE.L  A6,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  28(A7),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   LAB_117E

    ADDQ.L  #1,D1

LAB_117E:
    ASR.L   #1,D1
    MOVE.L  24(A7),D0
    ADD.L   D1,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    MOVEQ   #34,D2
    SUB.L   D1,D2
    TST.L   D2
    BPL.S   LAB_117F

    ADDQ.L  #1,D2

LAB_117F:
    ASR.L   #1,D2
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D2
    SUBQ.L  #1,D2
    MOVE.L  D2,D1
    MOVEA.L 20(A7),A1
    JSR     _LVOMove(A6)

    LEA     60(A3),A0
    MOVEA.L A2,A1

LAB_1180:
    TST.B   (A1)+
    BNE.S   LAB_1180

    SUBQ.L  #1,A1
    SUBA.L  A2,A1
    MOVE.L  A1,24(A7)
    MOVEA.L A0,A1
    MOVEA.L A2,A0
    MOVE.L  24(A7),D0
    JSR     _LVOText(A6)

    MOVEQ   #17,D0
    MOVE.W  D0,52(A3)
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,32(A3)
    PEA     65.W
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1038

    MOVEM.L -192(A5),D2/D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

LAB_1181:
    LINK.W  A5,#-24
    MOVEM.L D2/D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,-(A7)
    MOVEQ   #6,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    JSR     LAB_0FF4(PC)

    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVE.L  D0,D6
    MOVEQ   #42,D1
    ADD.L   D1,D6
    JSR     LAB_1359(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D7
    MOVE.L  D7,D4
    MOVE.L  D0,-20(A5)

LAB_1182:
    MOVEQ   #2,D0
    CMP.L   D0,D7
    BGE.W   LAB_118D

    JSR     LAB_1350(PC)

    TST.L   D0
    BNE.W   LAB_118D

    MOVE.L  D4,D5
    TST.L   D7
    BNE.S   LAB_1185

    TST.L   -20(A5)
    BEQ.S   LAB_1185

    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    TST.L   D0
    BPL.S   LAB_1183

    ADDQ.L  #1,D0

LAB_1183:
    ASR.L   #1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    SUB.L   D1,D0
    SUBQ.L  #4,D0
    TST.L   D0
    BPL.S   LAB_1184

    ADDQ.L  #1,D0

LAB_1184:
    ASR.L   #1,D0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D0
    ADDQ.L  #3,D0
    ADD.L   D0,D5
    BRA.S   LAB_118B

LAB_1185:
    JSR     LAB_1351(PC)

    TST.L   D0
    BEQ.S   LAB_1188

    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    MOVE.L  D0,D1
    TST.L   D1
    BPL.S   LAB_1186

    ADDQ.L  #1,D1

LAB_1186:
    ASR.L   #1,D1
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    SUB.L   D2,D1
    SUBQ.L  #4,D1
    TST.L   D1
    BPL.S   LAB_1187

    ADDQ.L  #1,D1

LAB_1187:
    ASR.L   #1,D1
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    ADD.L   D2,D1
    SUBQ.L  #1,D1
    ADD.L   D1,D5
    BRA.S   LAB_118B

LAB_1188:
    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    TST.L   D0
    BPL.S   LAB_1189

    ADDQ.L  #1,D0

LAB_1189:
    ASR.L   #1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    SUB.L   D1,D0
    TST.L   D0
    BPL.S   LAB_118A

    ADDQ.L  #1,D0

LAB_118A:
    ASR.L   #1,D0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D0
    SUBQ.L  #1,D0
    ADD.L   D0,D5

LAB_118B:
    LEA     60(A3),A0
    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_1346(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D7
    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    TST.L   D0
    BPL.S   LAB_118C

    ADDQ.L  #1,D0

LAB_118C:
    ASR.L   #1,D0
    ADD.L   LAB_1CE8,D0
    ADD.L   D0,D4
    BRA.W   LAB_1182

LAB_118D:
    JSR     LAB_1350(PC)

    MOVE.L  D0,-24(A5)
    TST.L   -20(A5)
    BEQ.W   LAB_118F

    MOVEQ   #0,D4
    MOVE.W  LAB_2328,D4
    TST.L   D0
    BEQ.S   LAB_118E

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVE.L  D4,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_133D(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    MOVE.L  D4,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,(A7)
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_133D(PC)

    LEA     36(A7),A7
    BRA.W   LAB_1191

LAB_118E:
    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVE.L  D4,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_1352(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    MOVE.L  D4,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,(A7)
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_1352(PC)

    LEA     36(A7),A7
    BRA.W   LAB_1191

LAB_118F:
    TST.L   D0
    BEQ.S   LAB_1190

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVE.L  D4,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_1349(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    MOVE.L  D4,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,(A7)
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_1349(PC)

    LEA     36(A7),A7
    BRA.S   LAB_1191

LAB_1190:
    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVE.L  D4,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_1356(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    MOVE.L  D4,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,(A7)
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_1356(PC)

    LEA     36(A7),A7

LAB_1191:
    MOVE.L  D4,D0
    TST.L   D0
    BPL.S   LAB_1192

    ADDQ.L  #1,D0

LAB_1192:
    ASR.L   #1,D0
    MOVE.W  D0,52(A3)
    MOVE.L  -24(A5),D0
    MOVEM.L (A7)+,D2/D4-D7/A3
    UNLK    A5
    RTS

;!======

LAB_1193:
    LINK.W  A5,#-8
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.W  18(A5),D6
    MOVE.L  A3,D0
    BNE.S   LAB_1194

    MOVEQ   #4,D0
    MOVE.L  D0,LAB_2024
    BRA.W   LAB_11A2

LAB_1194:
    MOVE.L  LAB_2024,D0
    SUBQ.L  #4,D0
    BEQ.S   LAB_1195

    SUBQ.L  #1,D0
    BEQ.W   LAB_119E

    BRA.W   LAB_11A1

LAB_1195:
    PEA     1.W
    MOVE.L  D7,-(A7)
    JSR     LAB_1345(PC)

    PEA     1.W
    MOVE.L  D7,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     LAB_133E(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.S   LAB_1197

    MOVEQ   #1,D1
    CMP.W   D1,D6
    BEQ.S   LAB_1196

    PEA     LAB_223A
    JSR     LAB_134A(PC)

    ADDQ.W  #4,A7
    SUBQ.W  #1,D0
    BNE.S   LAB_1197

LAB_1196:
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_133B(PC)

    MOVE.L  D0,D7
    PEA     2.W
    MOVE.L  D7,-(A7)
    JSR     LAB_1345(PC)

    PEA     2.W
    MOVE.L  D7,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     LAB_133E(PC)

    LEA     20(A7),A7
    MOVE.L  D0,-8(A5)

LAB_1197:
    TST.L   -4(A5)
    BEQ.W   LAB_11A2

    TST.L   -8(A5)
    BEQ.W   LAB_11A2

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    TST.L   56(A0,D0.L)
    BEQ.W   LAB_11A2

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L 56(A0,D0.L),A0
    TST.B   (A0)
    BEQ.W   LAB_11A2

    MOVE.W  LAB_232B,D0
    MULU    #3,D0
    MOVEQ   #12,D1
    SUB.L   D1,D0
    PEA     1.W
    PEA     20.W
    MOVE.L  D0,-(A7)
    JSR     LAB_1358(PC)

    LEA     12(A7),A7
    TST.W   LAB_2017
    BEQ.S   LAB_1198

    LEA     60(A3),A0
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     4.W
    PEA     1.W
    PEA     2.W
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_107F

    LEA     28(A7),A7
    BRA.S   LAB_1199

LAB_1198:
    LEA     60(A3),A0
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     4.W
    PEA     1.W
    PEA     3.W
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_107F

    LEA     28(A7),A7

LAB_1199:
    PEA     2.W
    JSR     LAB_1344(PC)

    MOVE.L  D0,32(A3)
    MOVE.L  A3,(A7)
    BSR.W   LAB_1181

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   LAB_119A

    MOVEQ   #4,D0
    BRA.S   LAB_119B

LAB_119A:
    MOVEQ   #5,D0

LAB_119B:
    LEA     60(A3),A0
    MOVE.L  D0,LAB_2024
    SUBQ.L  #4,D0
    BNE.S   LAB_119C

    MOVEQ   #1,D0
    BRA.S   LAB_119D

LAB_119C:
    MOVEQ   #0,D0

LAB_119D:
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_1066

    LEA     12(A7),A7
    BRA.S   LAB_11A2

LAB_119E:
    MOVEQ   #-1,D0
    MOVE.L  D0,32(A3)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1181

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   LAB_119F

    MOVEQ   #4,D0
    BRA.S   LAB_11A0

LAB_119F:
    MOVEQ   #5,D0

LAB_11A0:
    MOVE.L  D0,LAB_2024
    BRA.S   LAB_11A2

LAB_11A1:
    MOVEQ   #4,D0
    MOVE.L  D0,LAB_2024

LAB_11A2:
    MOVE.L  LAB_2024,D0
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======

LAB_11A3:
    LINK.W  A5,#-12
    MOVEM.L D4-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVE.W  18(A5),D5
    MOVEQ   #0,D4
    MOVE.L  D7,D0
    TST.L   D0
    BEQ.S   LAB_11A4

    SUBQ.L  #4,D0
    BEQ.S   LAB_11A5

    BRA.S   LAB_11A6

LAB_11A4:
    MOVEQ   #0,D6
    BRA.S   LAB_11A7

LAB_11A5:
    ADDQ.L  #1,D6
    BRA.S   LAB_11A7

LAB_11A6:
    MOVEQ   #1,D4

LAB_11A7:
    TST.L   D4
    BNE.W   LAB_11AC

    TST.B   LAB_224A
    BEQ.W   LAB_11AC

LAB_11A8:
    TST.L   D4
    BNE.W   LAB_11AB

    MOVEQ   #0,D0
    MOVE.W  LAB_2231,D0
    CMP.L   D0,D6
    BGE.W   LAB_11AB

    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  D6,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -8(A5)
    PEA     -4(A5)
    BSR.W   LAB_1077

    LEA     16(A7),A7
    TST.L   -4(A5)
    BEQ.W   LAB_11AA

    TST.L   -8(A5)
    BEQ.S   LAB_11AA

    MOVEA.L -4(A5),A0
    MOVE.W  46(A0),D0
    BTST    #1,D0
    BEQ.S   LAB_11AA

    MOVE.B  40(A0),D0
    BTST    #7,D0
    BEQ.S   LAB_11AA

    LEA     28(A0),A1
    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     LAB_1355(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   LAB_11AA

    MOVE.L  -4(A5),-(A7)
    JSR     LAB_0FF5(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BNE.S   LAB_11AA

    MOVEA.L -8(A5),A0
    MOVEA.L A0,A1
    ADDA.W  D5,A1
    BTST    #1,7(A1)
    BNE.S   LAB_11A9

    MOVEA.L -4(A5),A1
    MOVE.B  27(A1),D0
    BTST    #4,D0
    BEQ.S   LAB_11AA

LAB_11A9:
    MOVEA.L A0,A1
    ADDA.W  D5,A1
    BTST    #7,7(A1)
    BNE.S   LAB_11AA

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    TST.L   56(A0)
    BEQ.S   LAB_11AA

    MOVEQ   #1,D4
    BRA.W   LAB_11A8

LAB_11AA:
    ADDQ.L  #1,D6
    BRA.W   LAB_11A8

LAB_11AB:
    TST.L   D4
    BNE.S   LAB_11AC

    MOVEQ   #-1,D6

LAB_11AC:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D4-D7
    UNLK    A5
    RTS

;!======

LAB_11AD:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.W  26(A7),D7
    MOVE.W  30(A7),D6
    MOVEQ   #0,D5
    MOVE.L  A3,D0
    BNE.S   LAB_11AF

    MOVEQ   #5,D0
    CMP.L   LAB_2027,D0
    BNE.S   LAB_11AE

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1193

    LEA     12(A7),A7

LAB_11AE:
    MOVEQ   #0,D0
    MOVE.L  D0,LAB_2027
    MOVE.L  D0,LAB_2026
    BRA.W   LAB_11B4

LAB_11AF:
    MOVE.L  LAB_2027,D0
    CMPI.L  #$6,D0
    BCC.W   LAB_11B3

    ADD.W   D0,D0
    MOVE.W  LAB_11B0(PC,D0.W),D0
    JMP     LAB_11B0+2(PC,D0.W)

; TODO: Switch case
LAB_11B0:
    DC.W    $000a
    DC.W    $003e
    DC.W    $00e8
    DC.W    $0060
    DC.W    $0060
    DC.W    $0082

    CLR.L   LAB_2025
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_2026,-(A7)
    MOVE.L  LAB_2027,-(A7)
    BSR.W   LAB_11A3

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2026
    ADDQ.L  #1,D0
    BEQ.W   LAB_11B4

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_2027
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_117B

    LEA     12(A7),A7
    MOVEQ   #3,D0
    MOVE.L  D0,LAB_2027
    BRA.W   LAB_11B4

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_2026,-(A7)
    MOVE.L  LAB_2027,-(A7)
    BSR.W   LAB_11A3

    LEA     12(A7),A7
    MOVEQ   #1,D5
    MOVE.L  D0,LAB_2026
    MOVE.L  LAB_2026,D0
    MOVEQ   #-1,D1
    CMP.L   D1,D0
    BEQ.S   LAB_11B3

    MOVE.L  D7,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1193

    LEA     12(A7),A7
    MOVE.B  LAB_1BAF,D1
    MOVE.L  D0,LAB_2027
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BNE.S   LAB_11B4

    TST.L   D5
    BEQ.S   LAB_11B2

    CMPI.L  #$1,LAB_2025
    BGE.S   LAB_11B2

    PEA     51.W
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1038

    BSR.W   LAB_106E

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_2025

LAB_11B2:
    MOVE.L  A3,-(A7)
    BSR.W   LAB_106B

    ADDQ.W  #4,A7
    SUB.L   D0,LAB_2025
    BRA.S   LAB_11B4

LAB_11B3:
    CLR.L   LAB_2027

LAB_11B4:
    MOVE.L  LAB_2027,D0
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======

LAB_11B5:
    LINK.W  A5,#-16
    MOVEM.L D4-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVE.W  18(A5),D5
    MOVEQ   #0,D4
    MOVE.L  D7,D0
    TST.L   D0
    BEQ.S   LAB_11B6

    SUBQ.L  #4,D0
    BEQ.S   LAB_11B7

    SUBQ.L  #2,D0
    BNE.S   LAB_11B8

LAB_11B6:
    MOVEQ   #0,D6
    BRA.S   LAB_11B9

LAB_11B7:
    ADDQ.L  #1,D6
    BRA.S   LAB_11B9

LAB_11B8:
    MOVEQ   #1,D4

LAB_11B9:
    TST.L   D4
    BNE.W   LAB_11BD

LAB_11BA:
    TST.L   D4
    BNE.W   LAB_11BC

    MOVEQ   #0,D0
    MOVE.W  LAB_2231,D0
    CMP.L   D0,D6
    BGE.W   LAB_11BC

    TST.B   LAB_224A
    BEQ.W   LAB_11BC

    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  D6,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -14(A5)
    PEA     -10(A5)
    BSR.W   LAB_1077

    LEA     16(A7),A7
    MOVE.W  D0,-6(A5)
    TST.L   -10(A5)
    BEQ.S   LAB_11BB

    TST.L   -14(A5)
    BEQ.S   LAB_11BB

    MOVEA.L -10(A5),A0
    MOVE.W  46(A0),D0
    BTST    #3,D0
    BEQ.S   LAB_11BB

    MOVE.B  40(A0),D0
    BTST    #7,D0
    BEQ.S   LAB_11BB

    LEA     28(A0),A1
    MOVE.W  -6(A5),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     LAB_1355(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   LAB_11BB

    MOVEA.L -14(A5),A0
    MOVEA.L A0,A1
    ADDA.W  D5,A1
    BTST    #7,7(A1)
    BNE.S   LAB_11BB

    MOVE.W  -6(A5),D0
    EXT.L   D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    TST.L   56(A0)
    BEQ.S   LAB_11BB

    MOVEQ   #1,D4
    BRA.W   LAB_11BA

LAB_11BB:
    ADDQ.L  #1,D6
    BRA.W   LAB_11BA

LAB_11BC:
    TST.L   D4
    BNE.S   LAB_11BD

    MOVEQ   #-1,D6

LAB_11BD:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D4-D7
    UNLK    A5
    RTS

;!======

LAB_11BE:
    LINK.W  A5,#-180
    MOVEM.L D2/D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    PEA     33.W
    MOVE.L  LAB_22DA,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    JSR     LAB_0FF4(PC)

    MOVE.L  D7,D0
    EXT.L   D0
    PEA     -163(A5)
    MOVE.L  D0,-(A7)
    JSR     LAB_1348(PC)

    PEA     -163(A5)
    JSR     LAB_134B(PC)

    MOVE.L  D0,(A7)
    MOVE.L  LAB_22E3,-(A7)
    PEA     -132(A5)
    MOVE.L  D0,-168(A5)
    JSR     JMP_TBL_PRINTF_4(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    PEA     33.W
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_133D(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    PEA     33.W
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_133D(PC)

    LEA     80(A7),A7
    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVE.L  LAB_22D9,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    LEA     -132(A5),A0
    MOVEA.L A0,A1

LAB_11BF:
    TST.B   (A1)+
    BNE.S   LAB_11BF

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D6

LAB_11C0:
    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVE.L  D6,D0
    LEA     -132(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.W  LAB_232B,D1
    MULU    #3,D1
    MOVEQ   #12,D2
    SUB.L   D2,D1
    CMP.L   D1,D0
    BLE.S   LAB_11C1

    SUBQ.L  #1,D6
    BRA.S   LAB_11C0

LAB_11C1:
    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVE.W  LAB_232B,D1
    MULU    #3,D1
    LEA     60(A3),A1
    MOVE.L  D0,20(A7)
    MOVE.L  D1,24(A7)
    MOVE.L  A0,16(A7)
    MOVE.L  D6,D0
    LEA     -132(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  24(A7),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   LAB_11C2

    ADDQ.L  #1,D1

LAB_11C2:
    ASR.L   #1,D1
    MOVE.L  20(A7),D0
    ADD.L   D1,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    MOVEQ   #34,D2
    SUB.L   D1,D2
    TST.L   D2
    BPL.S   LAB_11C3

    ADDQ.L  #1,D2

LAB_11C3:
    ASR.L   #1,D2
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D2
    SUBQ.L  #1,D2
    MOVE.L  D2,D1
    MOVEA.L 16(A7),A1
    JSR     _LVOMove(A6)

    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVE.L  D6,D0
    LEA     -132(A5),A0
    JSR     _LVOText(A6)

    MOVEQ   #17,D0
    MOVE.W  D0,52(A3)
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,32(A3)
    PEA     66.W
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1038

    MOVEM.L -196(A5),D2/D6-D7/A3
    UNLK    A5
    RTS

;!======

LAB_11C4:
    LINK.W  A5,#-20
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    LEA     60(A3),A0
    MOVE.L  LAB_22DF,-(A7)
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A0,-20(A5)
    BSR.W   LAB_102F

    LEA     12(A7),A7
    MOVEA.L -20(A5),A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,D3
    MOVEA.L -20(A5),A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVE.L  #695,D2
    JSR     _LVORectFill(A6)

    MOVEQ   #42,D6
    MOVEQ   #0,D7
    MOVE.L  D7,D4

LAB_11C5:
    MOVEQ   #2,D0
    CMP.L   D0,D7
    BGE.W   LAB_11D0

    JSR     LAB_1350(PC)

    TST.L   D0
    BNE.W   LAB_11D0

    MOVE.L  D4,D5
    JSR     LAB_1359(PC)

    TST.L   D0
    BEQ.S   LAB_11C8

    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,-(A7)
    PEA     695.W
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -20(A5),-(A7)
    JSR     LAB_133F(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    TST.L   D0
    BPL.S   LAB_11C6

    ADDQ.L  #1,D0

LAB_11C6:
    ASR.L   #1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    SUB.L   D1,D0
    SUBQ.L  #4,D0
    TST.L   D0
    BPL.S   LAB_11C7

    ADDQ.L  #1,D0

LAB_11C7:
    ASR.L   #1,D0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D0
    ADDQ.L  #3,D0
    ADD.L   D0,D5
    BRA.S   LAB_11CE

LAB_11C8:
    JSR     LAB_1351(PC)

    TST.L   D0
    BEQ.S   LAB_11CB

    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    MOVE.L  D0,D1
    TST.L   D1
    BPL.S   LAB_11C9

    ADDQ.L  #1,D1

LAB_11C9:
    ASR.L   #1,D1
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    SUB.L   D2,D1
    SUBQ.L  #4,D1
    TST.L   D1
    BPL.S   LAB_11CA

    ADDQ.L  #1,D1

LAB_11CA:
    ASR.L   #1,D1
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    ADD.L   D2,D1
    SUBQ.L  #1,D1
    ADD.L   D1,D5
    BRA.S   LAB_11CE

LAB_11CB:
    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    TST.L   D0
    BPL.S   LAB_11CC

    ADDQ.L  #1,D0

LAB_11CC:
    ASR.L   #1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    SUB.L   D1,D0
    TST.L   D0
    BPL.S   LAB_11CD

    ADDQ.L  #1,D0

LAB_11CD:
    ASR.L   #1,D0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D0
    SUBQ.L  #1,D0
    ADD.L   D0,D5

LAB_11CE:
    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  -20(A5),-(A7)
    JSR     LAB_1346(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D7
    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    TST.L   D0
    BPL.S   LAB_11CF

    ADDQ.L  #1,D0

LAB_11CF:
    ASR.L   #1,D0
    ADD.L   LAB_1CE8,D0
    ADD.L   D0,D4
    BRA.W   LAB_11C5

LAB_11D0:
    JSR     LAB_1350(PC)

    TST.L   D0
    BEQ.S   LAB_11D1

    MOVE.L  D4,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,-(A7)
    PEA     695.W
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -20(A5),-(A7)
    JSR     LAB_135A(PC)

    LEA     20(A7),A7

LAB_11D1:
    MOVE.L  D4,D0
    TST.L   D0
    BPL.S   LAB_11D2

    ADDQ.L  #1,D0

LAB_11D2:
    ASR.L   #1,D0
    MOVE.W  D0,52(A3)
    JSR     LAB_1350(PC)

    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======

LAB_11D3:
    LINK.W  A5,#-60
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.W  18(A5),D6
    SUBA.L  A0,A0
    MOVE.L  A0,-4(A5)
    MOVE.L  A0,-8(A5)
    MOVE.L  A3,D0
    BNE.S   LAB_11D4

    MOVEQ   #4,D0
    MOVE.L  D0,LAB_2028
    BRA.W   LAB_11DE

LAB_11D4:
    MOVE.L  LAB_2028,D0
    SUBQ.L  #4,D0
    BEQ.S   LAB_11D5

    SUBQ.L  #1,D0
    BEQ.W   LAB_11DA

    BRA.W   LAB_11DD

LAB_11D5:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D7,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -8(A5)
    PEA     -4(A5)
    BSR.W   LAB_1077

    LEA     16(A7),A7
    MOVE.L  D0,D6
    TST.L   -4(A5)
    BEQ.W   LAB_11DE

    TST.L   -8(A5)
    BEQ.W   LAB_11DE

    MOVE.L  LAB_22DD,-(A7)
    PEA     20.W
    PEA     612.W
    JSR     LAB_1358(PC)

    LEA     12(A7),A7
    MOVE.B  LAB_22E1,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BNE.S   LAB_11D6

    LEA     60(A3),A0
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     4.W
    PEA     1.W
    PEA     2.W
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_107F

    LEA     28(A7),A7
    BRA.S   LAB_11D7

LAB_11D6:
    LEA     60(A3),A0
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     4.W
    PEA     1.W
    PEA     3.W
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_107F

    LEA     28(A7),A7

LAB_11D7:
    MOVE.L  LAB_22DE,-(A7)
    JSR     LAB_1338(PC)

    MOVEA.L -4(A5),A0
    MOVEA.L A0,A1
    ADDA.W  #19,A1
    LEA     1(A0),A2
    MOVE.L  A2,(A7)
    MOVE.L  A1,-(A7)
    PEA     LAB_2029
    PEA     -58(A5)
    JSR     JMP_TBL_PRINTF_4(PC)

    LEA     60(A3),A0
    PEA     -58(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_1339(PC)

    MOVE.L  A3,(A7)
    BSR.W   LAB_11C4

    LEA     24(A7),A7
    TST.L   D0
    BEQ.S   LAB_11D8

    MOVEQ   #4,D0
    BRA.S   LAB_11D9

LAB_11D8:
    MOVEQ   #5,D0

LAB_11D9:
    PEA     2.W
    MOVE.L  D0,LAB_2028
    JSR     LAB_1344(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,32(A3)
    BRA.S   LAB_11DE

LAB_11DA:
    MOVE.L  A3,-(A7)
    BSR.W   LAB_11C4

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   LAB_11DB

    MOVEQ   #4,D0
    BRA.S   LAB_11DC

LAB_11DB:
    MOVEQ   #5,D0

LAB_11DC:
    MOVEQ   #-1,D1
    MOVE.L  D1,32(A3)
    MOVE.L  D0,LAB_2028
    BRA.S   LAB_11DE

LAB_11DD:
    MOVEQ   #4,D0
    MOVE.L  D0,LAB_2028

LAB_11DE:
    MOVE.L  LAB_2028,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_11DF:
    MOVEM.L D2/D5-D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVE.W  30(A7),D7
    MOVE.W  34(A7),D6
    MOVEQ   #0,D5
    MOVE.L  A3,D0
    BNE.S   LAB_11E4

    MOVE.L  LAB_202F,D0
    SUBQ.L  #2,D0
    BEQ.S   LAB_11E0

    SUBQ.L  #3,D0
    BEQ.S   LAB_11E1

    SUBQ.L  #2,D0
    BNE.S   LAB_11E3

LAB_11E0:
    CLR.L   -(A7)
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1155

    LEA     16(A7),A7
    BRA.S   LAB_11E3

LAB_11E1:
    MOVE.L  LAB_202E,D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    JSR     LAB_0FF5(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   LAB_11E2

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_10B5

    LEA     12(A7),A7
    BRA.S   LAB_11E3

LAB_11E2:
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_11D3

    LEA     12(A7),A7

LAB_11E3:
    MOVEQ   #0,D0
    MOVE.L  D0,LAB_202F
    MOVE.L  D0,LAB_202E
    BRA.W   LAB_11FE

LAB_11E4:
    MOVE.L  LAB_202F,D0
    CMPI.L  #$8,D0
    BCC.W   LAB_11FD

    ADD.W   D0,D0
    MOVE.W  LAB_11E5(PC,D0.W),D0
    JMP     LAB_11E5+2(PC,D0.W)

; TODO: Switch case
LAB_11E5:
    DC.W    $000e
    DC.W    $00c2
    DC.W    $00f4
    DC.W    $0148
    DC.W    $0148
    DC.W    $0170
    DC.W    $0238
    DC.W    $029c

    MOVE.B  LAB_22E0,D0
    MOVEQ   #66,D1
    CMP.B   D1,D0
    BEQ.S   LAB_11E7

    MOVEQ   #70,D2
    CMP.B   D2,D0
    BEQ.S   LAB_11E7

    MOVEQ   #0,D2
    BRA.S   LAB_11E8

LAB_11E7:
    MOVEQ   #1,D2

LAB_11E8:
    MOVE.L  D2,LAB_202B
    CMP.B   D1,D0
    BEQ.S   LAB_11E9

    MOVEQ   #76,D1
    CMP.B   D1,D0
    BEQ.S   LAB_11E9

    MOVEQ   #0,D0
    BRA.S   LAB_11EA

LAB_11E9:
    MOVEQ   #1,D0

LAB_11EA:
    MOVE.L  D7,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  LAB_202E,-(A7)
    MOVE.L  LAB_202F,-(A7)
    MOVE.L  D0,LAB_202C
    BSR.W   LAB_11B5

    LEA     12(A7),A7
    CLR.W   LAB_202D
    MOVE.L  D0,LAB_202E

LAB_11EB:
    MOVE.L  LAB_202E,D0
    MOVEQ   #-1,D1
    CMP.L   D1,D0
    BNE.S   LAB_11EC

    MOVE.W  LAB_202D,D1
    EXT.L   D1
    CMP.L   LAB_22D7,D1
    BGE.S   LAB_11EC

    ADDQ.W  #1,LAB_202D
    MOVE.L  D7,D1
    ADD.W   LAB_202D,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_202F,-(A7)
    BSR.W   LAB_11B5

    LEA     12(A7),A7
    MOVE.L  D0,LAB_202E
    BRA.S   LAB_11EB

LAB_11EC:
    MOVEQ   #-1,D0
    CMP.L   LAB_202E,D0
    BEQ.W   LAB_11FE

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_202F
    MOVE.L  D6,D0
    ADD.W   LAB_202D,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_11BE

    ADDQ.W  #8,A7
    CLR.L   LAB_202A
    TST.L   LAB_202B
    BEQ.S   LAB_11ED

    MOVEQ   #2,D0
    BRA.S   LAB_11EE

LAB_11ED:
    MOVEQ   #3,D0

LAB_11EE:
    MOVE.L  D0,LAB_202F
    BRA.W   LAB_11FE

    TST.L   LAB_202B
    BEQ.S   LAB_11F0

    MOVE.L  LAB_22E2,-(A7)
    MOVE.L  LAB_22DC,-(A7)
    MOVE.L  LAB_22DB,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1155

    LEA     16(A7),A7
    MOVE.L  D0,LAB_202F
    SUBQ.L  #5,D0
    BNE.S   LAB_11EF

    MOVEQ   #2,D0
    MOVE.L  D0,LAB_202F
    BRA.W   LAB_11FE

LAB_11EF:
    CLR.L   LAB_202B
    MOVEQ   #3,D0
    MOVE.L  D0,LAB_202F
    BRA.W   LAB_11FE

LAB_11F0:
    MOVEQ   #3,D0
    MOVE.L  D0,LAB_202F
    MOVE.L  D7,D0
    ADD.W   LAB_202D,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_202E,-(A7)
    MOVE.L  LAB_202F,-(A7)
    BSR.W   LAB_11B5

    LEA     12(A7),A7
    MOVEQ   #1,D5
    MOVE.L  D0,LAB_202E
    MOVE.L  LAB_202E,D0
    MOVEQ   #-1,D1
    CMP.L   D1,D0
    BEQ.W   LAB_11F6

    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    JSR     LAB_0FF5(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   LAB_11F1

    MOVE.L  D7,D0
    ADD.W   LAB_202D,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_202E,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_10B5

    LEA     12(A7),A7
    MOVE.L  D0,LAB_202F
    BRA.S   LAB_11F2

LAB_11F1:
    MOVE.L  D7,D0
    ADD.W   LAB_202D,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_202E,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_11D3

    LEA     12(A7),A7
    MOVE.L  D0,LAB_202F

LAB_11F2:
    MOVE.B  LAB_22D5,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   LAB_11FE

    TST.L   D5
    BEQ.S   LAB_11F5

    CMPI.L  #$1,LAB_202A
    BGE.S   LAB_11F5

    MOVE.B  LAB_22E1,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BNE.S   LAB_11F3

    MOVEQ   #36,D0
    BRA.S   LAB_11F4

LAB_11F3:
    MOVEQ   #52,D0

LAB_11F4:
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1038

    BSR.W   LAB_106E

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_202A

LAB_11F5:
    MOVE.L  A3,-(A7)
    BSR.W   LAB_106B

    ADDQ.W  #4,A7
    SUB.L   D0,LAB_202A
    BRA.W   LAB_11FE

LAB_11F6:
    MOVEQ   #6,D0
    MOVE.L  D0,LAB_202F

LAB_11F7:
    MOVE.L  LAB_202E,D0
    MOVEQ   #-1,D1
    CMP.L   D1,D0
    BNE.S   LAB_11F8

    MOVE.W  LAB_202D,D1
    EXT.L   D1
    CMP.L   LAB_22D7,D1
    BGE.S   LAB_11F8

    ADDQ.W  #1,LAB_202D
    MOVE.L  D7,D1
    ADD.W   LAB_202D,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_202F,-(A7)
    BSR.W   LAB_11B5

    LEA     12(A7),A7
    MOVE.L  D0,LAB_202E
    BRA.S   LAB_11F7

LAB_11F8:
    MOVEQ   #-1,D0
    CMP.L   LAB_202E,D0
    BNE.S   LAB_11F9

    MOVEQ   #7,D0
    MOVE.L  D0,LAB_202F
    BRA.S   LAB_11FA

LAB_11F9:
    MOVEQ   #1,D0
    MOVE.L  D0,LAB_202F
    BRA.S   LAB_11FE

LAB_11FA:
    TST.L   LAB_202C
    BEQ.S   LAB_11FC

    MOVE.L  LAB_22E2,-(A7)
    MOVE.L  LAB_22DC,-(A7)
    MOVE.L  LAB_22DB,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1155

    LEA     16(A7),A7
    MOVE.L  D0,LAB_202F
    SUBQ.L  #5,D0
    BNE.S   LAB_11FB

    MOVEQ   #7,D0
    MOVE.L  D0,LAB_202F
    BRA.S   LAB_11FE

LAB_11FB:
    MOVEQ   #0,D0
    MOVE.L  D0,LAB_202F
    MOVE.L  D0,LAB_202C
    BRA.S   LAB_11FE

LAB_11FC:
    CLR.L   LAB_202F
    BRA.S   LAB_11FE

LAB_11FD:
    CLR.L   LAB_202F

LAB_11FE:
    MOVE.L  LAB_202F,D0
    MOVEM.L (A7)+,D2/D5-D7/A3
    RTS

;!======

LAB_11FF:
    LINK.W  A5,#-16
    MOVEM.L D5-D7,-(A7)
    MOVE.W  10(A5),D7
    MOVEQ   #1,D0
    CMP.W   D0,D7
    BLE.S   LAB_1203

    MOVEQ   #0,D6

LAB_1200:
    MOVEQ   #0,D0
    MOVE.W  LAB_2231,D0
    CMP.L   D0,D6
    BGE.S   LAB_1203

    TST.B   LAB_224A
    BEQ.S   LAB_1203

    PEA     1.W
    MOVE.L  D6,-(A7)
    JSR     LAB_1345(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    MOVEA.L D0,A0
    BTST    #4,47(A0)
    BEQ.S   LAB_1202

    PEA     1.W
    MOVE.L  D6,-(A7)
    JSR     LAB_133E(PC)

    ADDQ.W  #8,A7
    MOVEQ   #1,D5
    MOVE.L  D0,-8(A5)

LAB_1201:
    MOVEQ   #49,D0
    CMP.L   D0,D5
    BGE.S   LAB_1202

    MOVEA.L -8(A5),A0
    BCLR    #5,7(A0,D5.L)
    ADDQ.L  #1,D5
    BRA.S   LAB_1201

LAB_1202:
    ADDQ.L  #1,D6
    BRA.S   LAB_1200

LAB_1203:
    MOVEQ   #0,D6

LAB_1204:
    MOVEQ   #0,D0
    MOVE.W  LAB_222F,D0
    CMP.L   D0,D6
    BGE.S   LAB_1207

    TST.B   LAB_222E
    BEQ.S   LAB_1207

    PEA     2.W
    MOVE.L  D6,-(A7)
    JSR     LAB_1345(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    MOVEA.L D0,A0
    BTST    #4,47(A0)
    BEQ.S   LAB_1206

    PEA     2.W
    MOVE.L  D6,-(A7)
    JSR     LAB_133E(PC)

    ADDQ.W  #8,A7
    MOVEQ   #1,D5
    MOVE.L  D0,-8(A5)

LAB_1205:
    MOVEQ   #49,D0
    CMP.L   D0,D5
    BGE.S   LAB_1206

    MOVEA.L -8(A5),A0
    BCLR    #5,7(A0,D5.L)
    ADDQ.L  #1,D5
    BRA.S   LAB_1205

LAB_1206:
    ADDQ.L  #1,D6
    BRA.S   LAB_1204

LAB_1207:
    MOVEM.L (A7)+,D5-D7
    UNLK    A5
    RTS

;!======

LAB_1208:
    LINK.W  A5,#-8
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.L  A3,D0
    BEQ.W   LAB_1213

    SUBA.L  A0,A0
    MOVE.L  A0,(A3)
    MOVE.L  A0,4(A3)
    MOVEQ   #0,D0
    MOVE.L  D0,8(A3)
    TST.W   D7
    BEQ.S   LAB_120E

    MOVEQ   #0,D1
    MOVE.W  LAB_2231,D1
    MOVE.L  D1,12(A3)
    MOVE.L  D0,D6

LAB_1209:
    CMP.L   12(A3),D6
    BGE.S   LAB_120B

    PEA     1.W
    MOVE.L  D6,-(A7)
    JSR     LAB_1345(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    MOVEA.L D0,A0
    BTST    #4,47(A0)
    BEQ.S   LAB_120A

    MOVE.L  D6,12(A3)

LAB_120A:
    ADDQ.L  #1,D6
    BRA.S   LAB_1209

LAB_120B:
    MOVE.L  12(A3),16(A3)
    MOVEQ   #0,D6
    MOVE.W  LAB_2231,D6

LAB_120C:
    CMP.L   16(A3),D6
    BLE.S   LAB_120F

    MOVE.L  D6,D0
    SUBQ.L  #1,D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    JSR     LAB_1345(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    MOVEA.L D0,A0
    BTST    #4,47(A0)
    BEQ.S   LAB_120D

    MOVE.L  D6,16(A3)

LAB_120D:
    SUBQ.L  #1,D6
    BRA.S   LAB_120C

LAB_120E:
    MOVEQ   #0,D0
    MOVE.L  D0,12(A3)
    MOVE.L  D0,16(A3)

LAB_120F:
    MOVE.W  D7,20(A3)
    MOVEQ   #48,D0
    CMP.W   D0,D7
    BGE.S   LAB_1211

    MOVEQ   #1,D0
    CMP.W   D0,D7
    BEQ.S   LAB_1210

    PEA     LAB_223A
    JSR     LAB_134A(PC)

    ADDQ.W  #4,A7
    SUBQ.W  #1,D0
    BNE.S   LAB_1211

LAB_1210:
    MOVEQ   #48,D0
    ADD.W   D0,20(A3)

LAB_1211:
    MOVE.W  20(A3),D0
    MOVE.W  D0,22(A3)
    MOVEQ   #29,D0
    ADD.L   LAB_22E6,D0
    MOVEQ   #30,D1
    JSR     JMP_TBL_LAB_1A07_4(PC)

    MOVE.W  20(A3),D1
    EXT.L   D1
    ADD.L   D0,D1
    MOVE.W  D1,24(A3)
    MOVEQ   #96,D0
    CMP.W   D0,D1
    BLE.S   LAB_1212

    MOVE.W  D0,24(A3)

LAB_1212:
    ADDQ.W  #1,24(A3)

LAB_1213:
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======

LAB_1214:
    LINK.W  A5,#-16
    MOVEM.L D5-D7/A3,-(A7)
    MOVE.L  8(A5),D7
    MOVEA.L 12(A5),A3
    MOVEQ   #0,D6
    MOVE.L  D7,D0
    TST.L   D0
    BEQ.S   LAB_1215

    SUBQ.L  #4,D0
    BEQ.S   LAB_1216

    BRA.S   LAB_1217

LAB_1215:
    MOVE.L  12(A3),LAB_2030
    MOVE.W  22(A3),D0
    MOVE.W  D0,LAB_2031
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_11FF

    ADDQ.W  #4,A7
    BRA.S   LAB_1218

LAB_1216:
    ADDQ.L  #1,LAB_2030
    BRA.S   LAB_1218

LAB_1217:
    MOVEQ   #1,D6

LAB_1218:
    TST.L   D6
    BNE.W   LAB_122A

    MOVEQ   #0,D0
    MOVE.W  LAB_2231,D0
    MOVE.L  12(A3),D1
    CMP.L   D0,D1
    BGT.S   LAB_1219

    TST.L   D1
    BPL.S   LAB_121A

LAB_1219:
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,12(A3)

LAB_121A:
    MOVEQ   #0,D0
    MOVE.W  LAB_2231,D0
    MOVE.L  16(A3),D1
    CMP.L   D0,D1
    BGT.S   LAB_121B

    TST.L   D1
    BPL.S   LAB_121C

LAB_121B:
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,16(A3)

LAB_121C:
    TST.L   D6
    BNE.W   LAB_1226

    MOVE.W  LAB_2031,D0
    TST.W   D0
    BLE.W   LAB_1226

    CMP.W   24(A3),D0
    BGE.W   LAB_1226

LAB_121D:
    TST.L   D6
    BNE.W   LAB_1225

    MOVE.L  LAB_2030,D0
    CMP.L   16(A3),D0
    BGE.W   LAB_1225

    TST.B   LAB_224A
    BEQ.W   LAB_1225

    MOVE.W  LAB_2031,D1
    EXT.L   D1
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    PEA     -8(A5)
    PEA     -4(A5)
    BSR.W   LAB_1077

    LEA     16(A7),A7
    MOVE.L  D0,D5
    TST.L   -4(A5)
    BEQ.W   LAB_1224

    TST.L   -8(A5)
    BEQ.W   LAB_1224

    MOVEA.L -4(A5),A0
    MOVE.W  46(A0),D0
    BTST    #4,D0
    BEQ.W   LAB_1224

    MOVE.B  40(A0),D0
    BTST    #7,D0
    BEQ.W   LAB_1224

    MOVE.W  LAB_2031,D0
    CMP.W   22(A3),D0
    BNE.S   LAB_121E

    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_1353(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5

LAB_121E:
    TST.W   D5
    BLE.W   LAB_1224

    MOVEA.L -4(A5),A0
    ADDA.W  #$1c,A0
    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_1355(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   LAB_1224

    MOVEA.L -8(A5),A0
    MOVEA.L A0,A1
    ADDA.W  D5,A1
    BTST    #5,7(A1)
    BNE.W   LAB_1224

    MOVE.L  -4(A5),-(A7)
    JSR     LAB_0FF5(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   LAB_1221

    MOVE.W  LAB_2031,D0
    MOVE.W  22(A3),D1
    CMP.W   D0,D1
    BNE.S   LAB_121F

    MOVE.L  D5,D1
    EXT.L   D1
    ASL.L   #2,D1
    MOVEA.L -8(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    TST.L   56(A1)
    BEQ.S   LAB_121F

    MOVEQ   #1,D1
    BRA.S   LAB_1220

LAB_121F:
    MOVEQ   #0,D1

LAB_1220:
    MOVE.L  D1,D6
    BRA.S   LAB_1224

LAB_1221:
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    ADDA.L  D0,A0
    TST.L   56(A0)
    BEQ.S   LAB_1222

    MOVEA.L -8(A5),A0
    ADDA.W  LAB_2031,A0
    BTST    #7,7(A0)
    BNE.S   LAB_1222

    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  LAB_22E7,-(A7)
    MOVE.L  LAB_22E6,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     LAB_1347(PC)

    LEA     20(A7),A7
    TST.L   D0
    BEQ.S   LAB_1222

    MOVEQ   #1,D1
    BRA.S   LAB_1223

LAB_1222:
    MOVEQ   #0,D1

LAB_1223:
    MOVE.L  D1,D6

LAB_1224:
    TST.L   D6
    BNE.W   LAB_121D

    ADDQ.L  #1,LAB_2030
    BRA.W   LAB_121D

LAB_1225:
    TST.L   D6
    BNE.W   LAB_121C

    ADDQ.W  #1,LAB_2031
    MOVE.L  12(A3),LAB_2030
    BRA.W   LAB_121C

LAB_1226:
    TST.L   D6
    BEQ.S   LAB_1229

    MOVE.L  -4(A5),(A3)
    MOVE.L  -8(A5),4(A3)
    MOVE.L  LAB_2030,8(A3)
    CMPI.W  #$30,LAB_2031
    BLE.S   LAB_1227

    MOVEQ   #49,D0
    CMP.W   D0,D5
    BGE.S   LAB_1227

    MOVEQ   #48,D0
    BRA.S   LAB_1228

LAB_1227:
    MOVEQ   #0,D0

LAB_1228:
    MOVE.L  D5,D1
    EXT.L   D1
    ADD.L   D0,D1
    MOVE.W  D1,20(A3)
    MOVEA.L -8(A5),A0
    ADDA.W  D5,A0
    BSET    #5,7(A0)
    BRA.S   LAB_122A

LAB_1229:
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1208

    ADDQ.W  #8,A7

LAB_122A:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======

LAB_122B:
    LINK.W  A5,#-12
    MOVEM.L D2/D7/A3,-(A7)
    MOVEA.L 32(A7),A3
    PEA     33.W
    MOVE.L  LAB_22E9,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    JSR     LAB_0FF4(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    PEA     33.W
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_133D(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    PEA     33.W
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_133D(PC)

    LEA     60(A7),A7
    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVE.L  LAB_22E8,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L LAB_22F2,A0

LAB_122C:
    TST.B   (A0)+
    BNE.S   LAB_122C

    SUBQ.L  #1,A0
    SUBA.L  LAB_22F2,A0
    MOVE.L  A0,D7

LAB_122D:
    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVE.L  D7,D0
    MOVEA.L LAB_22F2,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.W  LAB_232B,D1
    MULU    #3,D1
    MOVEQ   #12,D2
    SUB.L   D2,D1
    CMP.L   D1,D0
    BLE.S   LAB_122E

    SUBQ.L  #1,D7
    BRA.S   LAB_122D

LAB_122E:
    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVE.W  LAB_232B,D1
    MULU    #3,D1
    LEA     60(A3),A1
    MOVE.L  D0,16(A7)
    MOVE.L  D1,20(A7)
    MOVE.L  A0,12(A7)
    MOVE.L  D7,D0
    MOVEA.L LAB_22F2,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  20(A7),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   LAB_122F

    ADDQ.L  #1,D1

LAB_122F:
    ASR.L   #1,D1
    MOVE.L  16(A7),D0
    ADD.L   D1,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    MOVEQ   #34,D2
    SUB.L   D1,D2
    TST.L   D2
    BPL.S   LAB_1230

    ADDQ.L  #1,D2

LAB_1230:
    ASR.L   #1,D2
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D2
    SUBQ.L  #1,D2
    MOVE.L  D2,D1
    MOVEA.L 12(A7),A1
    JSR     _LVOMove(A6)

    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVE.L  D7,D0
    MOVEA.L LAB_22F2,A0
    JSR     _LVOText(A6)

    MOVEQ   #17,D0
    MOVE.W  D0,52(A3)
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,32(A3)
    PEA     68.W
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1038

    MOVEM.L -24(A5),D2/D7/A3
    UNLK    A5
    RTS

;!======

LAB_1231:
    LINK.W  A5,#-20
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    LEA     60(A3),A0
    MOVE.L  LAB_22EE,-(A7)
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A0,-20(A5)
    BSR.W   LAB_102F

    LEA     12(A7),A7
    MOVEA.L -20(A5),A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,D3
    MOVEA.L -20(A5),A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVE.L  #695,D2
    JSR     _LVORectFill(A6)

    MOVEQ   #42,D6
    MOVEQ   #0,D7
    MOVE.L  D7,D4

LAB_1232:
    MOVEQ   #2,D0
    CMP.L   D0,D7
    BGE.W   LAB_123D

    JSR     LAB_1350(PC)

    TST.L   D0
    BNE.W   LAB_123D

    MOVE.L  D4,D5
    JSR     LAB_1359(PC)

    TST.L   D0
    BEQ.S   LAB_1235

    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,-(A7)
    PEA     695.W
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -20(A5),-(A7)
    JSR     LAB_133F(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    TST.L   D0
    BPL.S   LAB_1233

    ADDQ.L  #1,D0

LAB_1233:
    ASR.L   #1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    SUB.L   D1,D0
    SUBQ.L  #4,D0
    TST.L   D0
    BPL.S   LAB_1234

    ADDQ.L  #1,D0

LAB_1234:
    ASR.L   #1,D0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D0
    ADDQ.L  #3,D0
    ADD.L   D0,D5
    BRA.S   LAB_123B

LAB_1235:
    JSR     LAB_1351(PC)

    TST.L   D0
    BEQ.S   LAB_1238

    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    MOVE.L  D0,D1
    TST.L   D1
    BPL.S   LAB_1236

    ADDQ.L  #1,D1

LAB_1236:
    ASR.L   #1,D1
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    SUB.L   D2,D1
    SUBQ.L  #4,D1
    TST.L   D1
    BPL.S   LAB_1237

    ADDQ.L  #1,D1

LAB_1237:
    ASR.L   #1,D1
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    ADD.L   D2,D1
    SUBQ.L  #1,D1
    ADD.L   D1,D5
    BRA.S   LAB_123B

LAB_1238:
    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    TST.L   D0
    BPL.S   LAB_1239

    ADDQ.L  #1,D0

LAB_1239:
    ASR.L   #1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    SUB.L   D1,D0
    TST.L   D0
    BPL.S   LAB_123A

    ADDQ.L  #1,D0

LAB_123A:
    ASR.L   #1,D0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D0
    SUBQ.L  #1,D0
    ADD.L   D0,D5

LAB_123B:
    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  -20(A5),-(A7)
    JSR     LAB_1346(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D7
    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    TST.L   D0
    BPL.S   LAB_123C

    ADDQ.L  #1,D0

LAB_123C:
    ASR.L   #1,D0
    ADD.L   LAB_1CE8,D0
    ADD.L   D0,D4
    BRA.W   LAB_1232

LAB_123D:
    JSR     LAB_1350(PC)

    TST.L   D0
    BEQ.S   LAB_123E

    MOVE.L  D4,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,-(A7)
    PEA     695.W
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -20(A5),-(A7)
    JSR     LAB_135A(PC)

    LEA     20(A7),A7

LAB_123E:
    MOVE.L  D4,D0
    TST.L   D0
    BPL.S   LAB_123F

    ADDQ.L  #1,D0

LAB_123F:
    ASR.L   #1,D0
    MOVE.W  D0,52(A3)
    JSR     LAB_1350(PC)

    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======

LAB_1240:
    MOVEM.L D7/A2,-(A7)
    MOVEQ   #0,D7

LAB_1241:
    MOVEQ   #10,D0
    CMP.L   D0,D7
    BGE.S   LAB_1242

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2338,A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    ASL.L   #3,D0
    LEA     LAB_2336,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    MOVE.L  A2,(A0)
    ADDA.L  D0,A1
    CLR.L   4(A1)
    ADDQ.L  #1,D7
    BRA.S   LAB_1241

LAB_1242:
    MOVEM.L (A7)+,D7/A2
    RTS

;!======

LAB_1243:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D0
    MOVE.L  D0,LAB_2339
    MOVE.L  D0,D7

LAB_1244:
    MOVEQ   #10,D0
    CMP.L   D0,D7
    BGE.S   LAB_1245

    MOVE.L  D7,D0
    ASL.L   #3,D0
    LEA     LAB_2336,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  #$3100,(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    ADDA.L  D0,A0
    MOVE.L  4(A0),-(A7)
    CLR.L   -(A7)
    MOVE.L  A1,16(A7)
    JSR     LAB_146B(PC)

    ADDQ.W  #8,A7
    MOVEA.L 8(A7),A0
    MOVE.L  D0,4(A0)
    ADDQ.L  #1,D7
    BRA.S   LAB_1244

LAB_1245:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

LAB_1246:
    LINK.W  A5,#-28
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    CLR.L   -20(A5)
    PEA     58.W
    MOVE.L  A3,-(A7)
    JSR     LAB_1455(PC)

    MOVEA.L D0,A0
    LEA     1(A0),A1
    MOVE.L  A1,(A7)
    MOVE.L  A1,-4(A5)
    JSR     LAB_159A(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D6
    MOVE.L  D7,D0
    ASL.L   #8,D0
    ADD.L   D0,D6
    MOVE.L  LAB_2339,D0
    MOVEQ   #10,D1
    CMP.L   D1,D0
    BGE.W   LAB_124C

    ASL.L   #3,D0
    LEA     LAB_2336,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  D6,(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    ADDA.L  D0,A0
    MOVE.L  4(A0),-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A1,32(A7)
    JSR     LAB_146B(PC)

    ADDQ.W  #8,A7
    MOVEA.L 24(A7),A0
    MOVE.L  D0,4(A0)
    MOVE.L  LAB_2339,D5

LAB_1247:
    TST.L   D5
    BLE.S   LAB_1248

    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     LAB_2337,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    CMP.L   (A1),D6
    BGE.S   LAB_1248

    SUBQ.L  #1,D5
    BRA.S   LAB_1247

LAB_1248:
    TST.L   D5
    BEQ.S   LAB_1249

    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     LAB_2337,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    CMP.L   (A1),D6
    BEQ.S   LAB_124C

LAB_1249:
    MOVE.L  LAB_2339,D4

LAB_124A:
    CMP.L   D5,D4
    BLE.S   LAB_124B

    MOVE.L  D4,D0
    ASL.L   #2,D0
    LEA     LAB_2338,A0
    ADDA.L  D0,A0
    MOVE.L  D4,D0
    ASL.L   #2,D0
    LEA     LAB_2337,A1
    ADDA.L  D0,A1
    MOVE.L  (A1),(A0)
    SUBQ.L  #1,D4
    BRA.S   LAB_124A

LAB_124B:
    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     LAB_2338,A0
    ADDA.L  D0,A0
    MOVE.L  LAB_2339,D0
    MOVE.L  D0,D1
    ASL.L   #3,D1
    LEA     LAB_2336,A1
    ADDA.L  D1,A1
    MOVE.L  A1,(A0)
    ADDQ.L  #1,LAB_2339
    MOVEQ   #1,D0
    MOVE.L  D0,-20(A5)

LAB_124C:
    MOVE.L  -20(A5),D0
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

LAB_124D:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEA.L LAB_2338,A0
    MOVE.L  4(A0),-(A7)
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_3(PC)

    ADDQ.W  #8,A7
    MOVEQ   #1,D7

LAB_124E:
    CMP.L   LAB_2339,D7
    BGE.S   LAB_124F

    PEA     LAB_2032
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_3(PC)

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2338,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  4(A1),(A7)
    MOVE.L  A3,-(A7)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_3(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D7
    BRA.S   LAB_124E

LAB_124F:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

LAB_1250:
    LINK.W  A5,#-108
    MOVEM.L D5-D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    TST.L   (A2)
    BEQ.W   LAB_127C

    TST.L   4(A2)
    BEQ.W   LAB_127C

    MOVEA.L (A2),A0
    BTST    #4,47(A0)
    BEQ.W   LAB_127C

    TST.B   LAB_224A
    BEQ.W   LAB_127C

    TST.L   16(A5)
    BEQ.W   LAB_127C

    MOVEA.L 16(A5),A1
    CLR.B   (A1)
    MOVE.W  20(A2),D6
    MOVE.L  D6,D5
    MOVEQ   #48,D0
    CMP.W   D0,D6
    BLE.S   LAB_1251

    SUBI.W  #$30,D6

LAB_1251:
    MOVEA.L 4(A2),A0
    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L 56(A1),A6
    MOVE.L  A6,-54(A5)
    MOVE.L  A6,D0
    BEQ.S   LAB_1254

    TST.B   (A6)
    BEQ.S   LAB_1254

    MOVEQ   #40,D0
    CMP.B   (A6),D0
    BNE.S   LAB_1252

    MOVEQ   #58,D0
    CMP.B   3(A6),D0
    BNE.S   LAB_1252

    MOVEQ   #8,D0
    BRA.S   LAB_1253

LAB_1252:
    MOVEQ   #0,D0

LAB_1253:
    ADD.L   D0,-54(A5)
    BRA.S   LAB_1255

LAB_1254:
    CLR.L   -54(A5)

LAB_1255:
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    MOVE.L  (A2),-(A7)
    JSR     LAB_1337(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     2.W
    MOVE.L  D1,-(A7)
    MOVE.L  (A2),-(A7)
    MOVE.L  D0,-58(A5)
    JSR     LAB_1337(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     6.W
    MOVE.L  D1,-(A7)
    MOVE.L  (A2),-(A7)
    MOVE.L  D0,-62(A5)
    JSR     LAB_1337(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     7.W
    MOVE.L  D1,-(A7)
    MOVE.L  (A2),-(A7)
    MOVE.L  D0,-66(A5)
    JSR     LAB_1337(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  4(A2),(A7)
    MOVE.L  D1,-(A7)
    PEA     -49(A5)
    MOVE.L  D0,-70(A5)
    JSR     LAB_16F7(PC)

    LEA     56(A7),A7
    MOVE.L  #$264,-16(A5)
    TST.L   -62(A5)
    BEQ.S   LAB_1257

    MOVEA.L -62(A5),A0
    TST.B   (A0)
    BEQ.S   LAB_1257

    LEA     60(A3),A1

LAB_1256:
    TST.B   (A0)+
    BNE.S   LAB_1256

    SUBQ.L  #1,A0
    SUBA.L  -62(A5),A0
    MOVE.L  A0,D0
    MOVEA.L -62(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    LEA     60(A3),A0
    MOVE.L  D0,24(A7)
    MOVEA.L A0,A1
    LEA     GLOB_STR_SINGLE_SPACE_3,A0
    MOVEQ   #1,D0
    JSR     _LVOTextLength(A6)

    MOVE.L  24(A7),D1
    ADD.L   D0,D1
    SUB.L   D1,-16(A5)

LAB_1257:
    LEA     60(A3),A0
    MOVEA.L A0,A1
    LEA     GLOB_STR_COMMA_AND_SINGLE_SPACE_1,A0
    MOVEQ   #2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,-20(A5)
    TST.L   -54(A5)
    BEQ.W   LAB_127C

    BSR.W   LAB_1243

    MOVEQ   #0,D0
    MOVE.W  LAB_2231,D0
    MOVE.L  12(A2),D1
    CMP.L   D0,D1
    BGT.S   LAB_1258

    TST.L   D1
    BPL.S   LAB_1259

LAB_1258:
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,12(A2)

LAB_1259:
    MOVEQ   #0,D0
    MOVE.W  LAB_2231,D0
    MOVE.L  16(A2),D1
    CMP.L   D0,D1
    BGT.S   LAB_125A

    TST.L   D1
    BPL.S   LAB_125B

LAB_125A:
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,16(A2)

LAB_125B:
    MOVE.W  22(A2),D0
    EXT.L   D0
    ADD.L   LAB_22F3,D0
    ADDQ.L  #1,D0
    MOVE.W  D0,-8(A5)
    MOVEQ   #97,D1
    CMP.W   D1,D0
    BLE.S   LAB_125C

    MOVE.W  D1,-8(A5)

LAB_125C:
    MOVE.W  22(A2),D6

LAB_125D:
    CMP.W   -8(A5),D6
    BGE.W   LAB_1278

    MOVE.L  -16(A5),D0
    TST.L   D0
    BPL.S   LAB_125E

    CMP.W   24(A2),D6
    BGE.W   LAB_1278

LAB_125E:
    MOVE.L  12(A2),-12(A5)

LAB_125F:
    MOVE.L  -12(A5),D0
    CMP.L   16(A2),D0
    BGE.W   LAB_1277

    MOVE.L  -16(A5),D1
    TST.L   D1
    BPL.S   LAB_1260

    CMP.W   24(A2),D6
    BGE.W   LAB_1277

LAB_1260:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  -12(A5),-(A7)
    MOVE.L  D0,-(A7)
    PEA     -98(A5)
    PEA     -94(A5)
    BSR.W   LAB_1077

    LEA     16(A7),A7
    MOVE.L  D0,D7
    TST.L   -94(A5)
    BEQ.W   LAB_1276

    TST.L   -98(A5)
    BEQ.W   LAB_1276

    MOVEA.L -94(A5),A0
    MOVE.W  46(A0),D0
    BTST    #4,D0
    BEQ.W   LAB_1276

    MOVE.B  40(A0),D0
    BTST    #7,D0
    BEQ.W   LAB_1276

    CMP.W   22(A2),D6
    BNE.S   LAB_1261

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -98(A5),-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_1353(PC)

    MOVE.L  D0,D7
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  LAB_22E7,(A7)
    MOVE.L  LAB_22E6,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -98(A5),-(A7)
    MOVE.L  -94(A5),-(A7)
    JSR     LAB_1347(PC)

    LEA     28(A7),A7
    TST.L   D0
    BNE.S   LAB_1261

    SUBA.L  A0,A0
    MOVE.L  A0,-98(A5)

LAB_1261:
    TST.L   -98(A5)
    BEQ.W   LAB_1276

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -98(A5),A0
    ADDA.L  D0,A0
    TST.L   56(A0)
    BEQ.W   LAB_1276

    MOVEA.L -98(A5),A0
    ADDA.W  D7,A0
    MOVEQ   #-96,D0
    AND.B   7(A0),D0
    TST.B   D0
    BNE.W   LAB_1276

    MOVEA.L -94(A5),A0
    ADDA.W  #$1c,A0
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_1355(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   LAB_1276

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -98(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L A0,A6
    ADDA.L  D0,A6
    MOVEA.L 56(A6),A6
    MOVEQ   #40,D1
    CMP.B   (A6),D1
    BNE.S   LAB_1262

    ADDA.L  D0,A0
    MOVEA.L 56(A0),A6
    ADDQ.L  #3,A6
    MOVEQ   #58,D0
    CMP.B   (A6),D0
    BNE.S   LAB_1262

    MOVEQ   #8,D0
    BRA.S   LAB_1263

LAB_1262:
    MOVEQ   #0,D0

LAB_1263:
    MOVEA.L 56(A1),A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    MOVE.L  -94(A5),-(A7)
    MOVE.L  A0,-74(A5)
    JSR     LAB_1337(PC)

    MOVE.L  D7,D1
    EXT.L   D1
    PEA     2.W
    MOVE.L  D1,-(A7)
    MOVE.L  -94(A5),-(A7)
    MOVE.L  D0,-78(A5)
    JSR     LAB_1337(PC)

    MOVE.L  D7,D1
    EXT.L   D1
    PEA     6.W
    MOVE.L  D1,-(A7)
    MOVE.L  -94(A5),-(A7)
    MOVE.L  D0,-82(A5)
    JSR     LAB_1337(PC)

    MOVE.L  D7,D1
    EXT.L   D1
    PEA     7.W
    MOVE.L  D1,-(A7)
    MOVE.L  -94(A5),-(A7)
    MOVE.L  D0,-86(A5)
    JSR     LAB_1337(PC)

    LEA     48(A7),A7
    MOVE.L  D0,-90(A5)
    TST.L   -74(A5)
    BEQ.W   LAB_1276

    MOVEA.L -54(A5),A0
    MOVEA.L -74(A5),A1
    CMPA.L  A0,A1
    BEQ.W   LAB_1276

LAB_1264:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.W   LAB_1276

    TST.B   D0
    BNE.S   LAB_1264

    BNE.W   LAB_1276

    MOVEA.L -58(A5),A0
    MOVEA.L -78(A5),A1
    CMPA.L  A0,A1
    BEQ.S   LAB_1266

    MOVE.L  A0,D0
    BEQ.W   LAB_1276

    MOVE.L  A1,D0
    BEQ.W   LAB_1276

LAB_1265:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.W   LAB_1276

    TST.B   D0
    BNE.S   LAB_1265

    BNE.W   LAB_1276

LAB_1266:
    MOVEA.L -62(A5),A0
    MOVEA.L -82(A5),A1
    CMPA.L  A0,A1
    BEQ.S   LAB_1268

    MOVE.L  A0,D0
    BEQ.W   LAB_1276

    MOVE.L  A1,D0
    BEQ.W   LAB_1276

LAB_1267:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.W   LAB_1276

    TST.B   D0
    BNE.S   LAB_1267

    BNE.W   LAB_1276

LAB_1268:
    MOVEA.L -66(A5),A0
    MOVEA.L -86(A5),A1
    CMPA.L  A0,A1
    BEQ.S   LAB_126A

    MOVE.L  A0,D0
    BEQ.W   LAB_1276

    MOVE.L  A1,D0
    BEQ.W   LAB_1276

LAB_1269:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.W   LAB_1276

    TST.B   D0
    BNE.S   LAB_1269

    BNE.W   LAB_1276

LAB_126A:
    MOVEA.L -70(A5),A0
    MOVEA.L -90(A5),A1
    CMPA.L  A0,A1
    BEQ.S   LAB_126C

    MOVE.L  A0,D0
    BEQ.W   LAB_1276

    MOVE.L  A1,D0
    BEQ.W   LAB_1276

LAB_126B:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.W   LAB_1276

    TST.B   D0
    BNE.S   LAB_126B

    BNE.W   LAB_1276

LAB_126C:
    MOVEA.L -98(A5),A0
    ADDA.W  D7,A0
    BSET    #5,7(A0)
    MOVE.L  -16(A5),D0
    TST.L   D0
    BLE.W   LAB_1276

    MOVEA.L 16(A5),A0
    TST.B   (A0)
    BNE.S   LAB_1270

    LEA     GLOB_STR_SHOWTIMES_AND_SINGLE_SPACE,A0
    MOVEA.L 16(A5),A1

LAB_126D:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_126D

    PEA     -49(A5)
    JSR     LAB_134B(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-28(A5)
    BSR.W   LAB_1246

    ADDQ.W  #8,A7
    LEA     60(A3),A0
    LEA     GLOB_STR_SHOWTIMES_AND_SINGLE_SPACE,A1
    MOVEA.L A1,A6

LAB_126E:
    TST.B   (A6)+
    BNE.S   LAB_126E

    SUBQ.L  #1,A6
    SUBA.L  A1,A6
    MOVEA.L A0,A1
    MOVE.L  A6,D0
    LEA     GLOB_STR_SHOWTIMES_AND_SINGLE_SPACE,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    SUB.L   D0,-16(A5)
    LEA     60(A3),A0
    MOVEA.L -28(A5),A1

LAB_126F:
    TST.B   (A1)+
    BNE.S   LAB_126F

    SUBQ.L  #1,A1
    SUBA.L  -28(A5),A1
    MOVE.L  A1,28(A7)
    MOVEA.L A0,A1
    MOVEA.L -28(A5),A0
    MOVE.L  28(A7),D0
    JSR     _LVOTextLength(A6)

    SUB.L   D0,-16(A5)

LAB_1270:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  -98(A5),-(A7)
    MOVE.L  D0,-(A7)
    PEA     -49(A5)
    JSR     LAB_16F7(PC)

    PEA     -49(A5)
    JSR     LAB_134B(PC)

    LEA     16(A7),A7
    LEA     60(A3),A0
    MOVEA.L D0,A1

LAB_1271:
    TST.B   (A1)+
    BNE.S   LAB_1271

    SUBQ.L  #1,A1
    SUBA.L  D0,A1
    MOVE.L  D0,-28(A5)
    MOVE.L  A1,28(A7)
    MOVEA.L A0,A1
    MOVEA.L D0,A0
    MOVE.L  28(A7),D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  -20(A5),D1
    ADD.L   D0,D1
    MOVEM.L D1,-24(A5)
    MOVE.L  -16(A5),D0
    CMP.L   D1,D0
    BLT.S   LAB_1274

    MOVEQ   #48,D0
    CMP.W   D0,D6
    BLE.S   LAB_1272

    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #48,D1
    ADD.L   D1,D0
    BRA.S   LAB_1273

LAB_1272:
    MOVE.L  D7,D0
    EXT.L   D0

LAB_1273:
    MOVE.L  D0,-(A7)
    MOVE.L  -28(A5),-(A7)
    BSR.W   LAB_1246

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   LAB_1276

LAB_1274:
    LEA     60(A3),A0
    MOVEA.L -28(A5),A1

LAB_1275:
    TST.B   (A1)+
    BNE.S   LAB_1275

    SUBQ.L  #1,A1
    SUBA.L  -28(A5),A1
    MOVE.L  A1,28(A7)
    MOVEA.L A0,A1
    MOVEA.L -28(A5),A0
    MOVE.L  28(A7),D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  -20(A5),D1
    ADD.L   D0,D1
    SUB.L   D1,-16(A5)

LAB_1276:
    ADDQ.L  #1,-12(A5)
    BRA.W   LAB_125F

LAB_1277:
    ADDQ.W  #1,D6
    BRA.W   LAB_125D

LAB_1278:
    MOVEA.L 16(A5),A0
    TST.B   (A0)
    BNE.S   LAB_127A

    LEA     GLOB_STR_SHOWING_AT_AND_SINGLE_SPACE,A0
    MOVEA.L 16(A5),A1

LAB_1279:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_1279

    PEA     -49(A5)
    JSR     LAB_134B(PC)

    MOVE.L  D0,(A7)
    MOVE.L  16(A5),-(A7)
    MOVE.L  D0,-28(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_3(PC)

    ADDQ.W  #8,A7
    BRA.S   LAB_127B

LAB_127A:
    MOVE.L  A0,-(A7)
    BSR.W   LAB_124D

    ADDQ.W  #4,A7

LAB_127B:
    TST.L   -62(A5)
    BEQ.S   LAB_127C

    MOVEA.L -62(A5),A0
    TST.B   (A0)
    BEQ.S   LAB_127C

    PEA     LAB_2035
    MOVE.L  16(A5),-(A7)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_3(PC)

    MOVE.L  -62(A5),(A7)
    MOVE.L  16(A5),-(A7)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_3(PC)

    LEA     12(A7),A7

LAB_127C:
    MOVEM.L (A7)+,D5-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

LAB_127D:
    LINK.W  A5,#-132
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  A3,D0
    BNE.S   LAB_127E

    MOVEQ   #4,D0
    MOVE.L  D0,LAB_2036
    BRA.W   LAB_1289

LAB_127E:
    MOVE.L  LAB_2036,D0
    SUBQ.L  #4,D0
    BEQ.S   LAB_127F

    SUBQ.L  #1,D0
    BEQ.W   LAB_1285

    BRA.W   LAB_1288

LAB_127F:
    TST.L   (A2)
    BEQ.W   LAB_1289

    TST.L   4(A2)
    BEQ.W   LAB_1289

    MOVE.L  LAB_22EC,-(A7)
    PEA     20.W
    PEA     612.W
    JSR     LAB_1358(PC)

    LEA     12(A7),A7
    MOVE.W  20(A2),D7
    MOVEQ   #48,D0
    CMP.W   D0,D7
    BLE.S   LAB_1280

    SUBI.W  #$30,D7

LAB_1280:
    MOVE.B  LAB_22F0,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BNE.S   LAB_1281

    LEA     60(A3),A0
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     -1.W
    PEA     1.W
    PEA     2.W
    MOVE.L  D0,-(A7)
    MOVE.L  4(A2),-(A7)
    MOVE.L  (A2),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_107F

    LEA     28(A7),A7
    BRA.S   LAB_1282

LAB_1281:
    LEA     60(A3),A0
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     -1.W
    PEA     1.W
    PEA     3.W
    MOVE.L  D0,-(A7)
    MOVE.L  4(A2),-(A7)
    MOVE.L  (A2),-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_107F

    LEA     28(A7),A7

LAB_1282:
    MOVE.L  LAB_22ED,-(A7)
    JSR     LAB_1338(PC)

    PEA     -130(A5)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1250

    LEA     60(A3),A0
    PEA     -130(A5)
    MOVE.L  A0,-(A7)
    JSR     LAB_1339(PC)

    MOVE.L  A3,(A7)
    BSR.W   LAB_1231

    LEA     24(A7),A7
    TST.L   D0
    BEQ.S   LAB_1283

    MOVEQ   #4,D0
    BRA.S   LAB_1284

LAB_1283:
    MOVEQ   #5,D0

LAB_1284:
    PEA     2.W
    MOVE.L  D0,LAB_2036
    JSR     LAB_1344(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,32(A3)
    BRA.S   LAB_1289

LAB_1285:
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1231

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   LAB_1286

    MOVEQ   #4,D0
    BRA.S   LAB_1287

LAB_1286:
    MOVEQ   #5,D0

LAB_1287:
    MOVEQ   #-1,D1
    MOVE.L  D1,32(A3)
    MOVE.L  D0,LAB_2036
    BRA.S   LAB_1289

LAB_1288:
    MOVEQ   #4,D0
    MOVE.L  D0,LAB_2036

LAB_1289:
    MOVE.L  LAB_2036,D0
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_128A:
    LINK.W  A5,#-4
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVEQ   #0,D6
    MOVE.L  A3,D0
    BNE.W   LAB_128F

    MOVE.L  LAB_2037,D0
    SUBQ.L  #2,D0
    BEQ.S   LAB_128B

    SUBQ.L  #3,D0
    BEQ.S   LAB_128C

    SUBQ.L  #2,D0
    BNE.S   LAB_128E

LAB_128B:
    CLR.L   -(A7)
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1155

    LEA     16(A7),A7
    MOVE.L  D0,LAB_2037
    BRA.S   LAB_128E

LAB_128C:
    MOVE.L  LAB_232F,-(A7)
    JSR     LAB_0FF5(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   LAB_128D

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_10B5

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2037
    BRA.S   LAB_128E

LAB_128D:
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_127D

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_2037

LAB_128E:
    CLR.L   -(A7)
    PEA     LAB_232F
    BSR.W   LAB_1208

    ADDQ.W  #8,A7
    MOVEQ   #0,D0
    MOVE.L  D0,LAB_2037
    BRA.W   LAB_129D

LAB_128F:
    MOVE.L  LAB_2037,D0
    CMPI.L  #$8,D0
    BCC.W   LAB_129C

    ADD.W   D0,D0
    MOVE.W  LAB_1290(PC,D0.W),D0
    JMP     LAB_1290+2(PC,D0.W)

; TODO: Switch case
LAB_1290:
    DC.W    $000e
    DC.W    $0040
    DC.W    $005a
    DC.W    $00b2
    DC.W    $00b2
    DC.W    $00c6
    DC.W    $01b6

    BCHG    D0,-(A2)
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     LAB_232F
    BSR.W   LAB_1208

    PEA     LAB_232F
    MOVE.L  LAB_2037,-(A7)
    BSR.W   LAB_1214

    LEA     16(A7),A7
    TST.L   D0
    BEQ.W   LAB_129D

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_2037
    MOVE.L  A3,-(A7)
    BSR.W   LAB_122B

    ADDQ.W  #4,A7
    CLR.L   LAB_2038
    MOVEQ   #2,D0
    MOVE.L  D0,LAB_2037
    BRA.W   LAB_129D

    MOVE.B  LAB_22EF,D0
    MOVEQ   #66,D1
    CMP.B   D1,D0
    BEQ.S   LAB_1292

    MOVEQ   #70,D1
    CMP.B   D1,D0
    BNE.S   LAB_1294

LAB_1292:
    MOVE.L  LAB_22F1,-(A7)
    MOVE.L  LAB_22EB,-(A7)
    MOVE.L  LAB_22EA,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1155

    LEA     16(A7),A7
    MOVE.L  D0,LAB_2037
    SUBQ.L  #5,D0
    BNE.S   LAB_1293

    MOVEQ   #2,D0
    MOVE.L  D0,LAB_2037
    BRA.W   LAB_129D

LAB_1293:
    MOVEQ   #3,D0
    MOVE.L  D0,LAB_2037
    BRA.W   LAB_129D

LAB_1294:
    MOVEQ   #3,D0
    MOVE.L  D0,LAB_2037
    PEA     LAB_232F
    MOVE.L  LAB_2037,-(A7)
    BSR.W   LAB_1214

    ADDQ.W  #8,A7
    MOVEQ   #1,D6
    TST.L   LAB_232F
    BEQ.W   LAB_1298

    MOVE.L  LAB_232F,-(A7)
    JSR     LAB_0FF5(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   LAB_1295

    MOVE.W  LAB_2331,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_2330,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_10B5

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2037
    BRA.S   LAB_1296

LAB_1295:
    PEA     LAB_232F
    MOVE.L  A3,-(A7)
    BSR.W   LAB_127D

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_2037

LAB_1296:
    MOVE.B  LAB_22E4,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   LAB_129D

    TST.L   D6
    BEQ.S   LAB_1297

    CMPI.L  #$1,LAB_2038
    BGE.S   LAB_1297

    PEA     53.W
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1038

    BSR.W   LAB_106E

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_2038

LAB_1297:
    MOVE.L  A3,-(A7)
    BSR.W   LAB_106B

    ADDQ.W  #4,A7
    SUB.L   D0,LAB_2038
    BRA.S   LAB_129D

LAB_1298:
    MOVEQ   #7,D0
    MOVE.L  D0,LAB_2037
    MOVE.B  LAB_22EF,D0
    MOVEQ   #66,D1
    CMP.B   D1,D0
    BEQ.S   LAB_1299

    MOVEQ   #76,D1
    CMP.B   D1,D0
    BNE.S   LAB_129B

LAB_1299:
    MOVE.L  LAB_22F1,-(A7)
    MOVE.L  LAB_22EB,-(A7)
    MOVE.L  LAB_22EA,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1155

    LEA     16(A7),A7
    MOVE.L  D0,LAB_2037
    SUBQ.L  #5,D0
    BNE.S   LAB_129A

    MOVEQ   #7,D0
    MOVE.L  D0,LAB_2037
    BRA.S   LAB_129D

LAB_129A:
    MOVEQ   #0,D0
    MOVE.L  D0,LAB_2037
    BRA.S   LAB_129D

LAB_129B:
    CLR.L   LAB_2037
    BRA.S   LAB_129D

LAB_129C:
    CLR.L   LAB_2037

LAB_129D:
    TST.L   LAB_2037
    BNE.S   LAB_129E

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_11FF

    ADDQ.W  #4,A7

LAB_129E:
    MOVE.L  LAB_2037,D0
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======

LAB_129F:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    TST.L   D7
    BNE.S   LAB_12A0

    MOVE.B  LAB_1BAE,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BEQ.S   LAB_12A2

LAB_12A0:
    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   LAB_12A1

    MOVE.B  LAB_1BB1,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BEQ.S   LAB_12A2

LAB_12A1:
    MOVEQ   #0,D0
    BRA.S   LAB_12A3

LAB_12A2:
    MOVEQ   #1,D0

LAB_12A3:
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_12A4:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEA.L 24(A7),A2
    MOVE.L  28(A7),D7
    MOVEQ   #0,D6
    TST.L   D7
    BEQ.S   LAB_12A5

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   LAB_12AA

LAB_12A5:
    MOVE.L  A3,D0
    BEQ.S   LAB_12A8

    MOVE.L  A2,D0
    BEQ.S   LAB_12A8

    BTST    #7,40(A3)
    BEQ.S   LAB_12A8

    TST.L   D7
    BNE.S   LAB_12A6

    BTST    #2,27(A3)
    BNE.S   LAB_12A7

LAB_12A6:
    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   LAB_12A8

    MOVE.L  A3,-(A7)
    JSR     LAB_1343(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   LAB_12A8

LAB_12A7:
    MOVEQ   #1,D1
    BRA.S   LAB_12A9

LAB_12A8:
    MOVEQ   #0,D1

LAB_12A9:
    MOVE.L  D1,D6

LAB_12AA:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======

LAB_12AB:
    LINK.W  A5,#-16
    MOVEM.L D4-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.W  14(A5),D6
    MOVEQ   #1,D0
    CMP.W   D0,D6
    BLE.S   LAB_12AF

    MOVEQ   #0,D5

LAB_12AC:
    MOVEQ   #0,D0
    MOVE.W  LAB_2231,D0
    CMP.L   D0,D5
    BGE.S   LAB_12AF

    TST.B   LAB_224A
    BEQ.S   LAB_12AF

    PEA     1.W
    MOVE.L  D5,-(A7)
    JSR     LAB_1345(PC)

    PEA     1.W
    MOVE.L  D5,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     LAB_133E(PC)

    MOVE.L  D7,(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-8(A5)
    BSR.W   LAB_12A4

    LEA     24(A7),A7
    TST.L   D0
    BEQ.S   LAB_12AE

    MOVEQ   #1,D4

LAB_12AD:
    MOVEQ   #49,D0
    CMP.L   D0,D4
    BGE.S   LAB_12AE

    MOVEA.L -8(A5),A0
    BCLR    #5,7(A0,D4.L)
    ADDQ.L  #1,D4
    BRA.S   LAB_12AD

LAB_12AE:
    ADDQ.L  #1,D5
    BRA.S   LAB_12AC

LAB_12AF:
    MOVEQ   #0,D5

LAB_12B0:
    MOVEQ   #0,D0
    MOVE.W  LAB_222F,D0
    CMP.L   D0,D5
    BGE.S   LAB_12B3

    TST.B   LAB_222E
    BEQ.S   LAB_12B3

    PEA     2.W
    MOVE.L  D5,-(A7)
    JSR     LAB_1345(PC)

    PEA     2.W
    MOVE.L  D5,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     LAB_133E(PC)

    MOVE.L  D7,(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-8(A5)
    BSR.W   LAB_12A4

    LEA     24(A7),A7
    TST.L   D0
    BEQ.S   LAB_12B2

    MOVEQ   #1,D4

LAB_12B1:
    MOVEQ   #49,D0
    CMP.L   D0,D4
    BGE.S   LAB_12B2

    MOVEA.L -8(A5),A0
    BCLR    #5,7(A0,D4.L)
    ADDQ.L  #1,D4
    BRA.S   LAB_12B1

LAB_12B2:
    ADDQ.L  #1,D5
    BRA.S   LAB_12B0

LAB_12B3:
    MOVEM.L (A7)+,D4-D7
    UNLK    A5
    RTS

;!======

LAB_12B4:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.W  26(A7),D7
    MOVE.L  28(A7),D6
    MOVE.L  A3,D0
    BEQ.S   LAB_12BA

    SUBA.L  A0,A0
    MOVE.L  A0,(A3)
    MOVE.L  A0,4(A3)
    CLR.L   8(A3)
    MOVE.W  D7,20(A3)
    MOVEQ   #48,D0
    CMP.W   D0,D7
    BGE.S   LAB_12B6

    MOVEQ   #1,D0
    CMP.W   D0,D7
    BEQ.S   LAB_12B5

    PEA     LAB_223A
    JSR     LAB_134A(PC)

    ADDQ.W  #4,A7
    SUBQ.W  #1,D0
    BNE.S   LAB_12B6

LAB_12B5:
    MOVEQ   #48,D0
    ADD.W   D0,20(A3)

LAB_12B6:
    MOVE.W  20(A3),D0
    MOVE.W  D0,22(A3)
    TST.L   D6
    BNE.S   LAB_12B7

    MOVE.B  LAB_1BA7,D0
    EXT.W   D0
    EXT.L   D0
    BRA.S   LAB_12B8

LAB_12B7:
    MOVE.B  LAB_1BBC,D0
    EXT.W   D0
    EXT.L   D0

LAB_12B8:
    MOVE.L  D0,D5
    MOVE.W  20(A3),D0
    EXT.L   D0
    ADD.L   D5,D0
    MOVE.W  D0,24(A3)
    MOVEQ   #96,D1
    CMP.W   D1,D0
    BLE.S   LAB_12B9

    MOVE.W  D1,24(A3)

LAB_12B9:
    ADDQ.W  #1,24(A3)

LAB_12BA:
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======

LAB_12BB:
    LINK.W  A5,#-16
    MOVEM.L D4-D7/A3,-(A7)
    MOVE.L  8(A5),D7
    MOVEA.L 12(A5),A3
    MOVE.L  16(A5),D6
    MOVEQ   #0,D5
    MOVE.L  D7,D0
    CMPI.L  #$6,D0
    BCC.S   LAB_12BE

    ADD.W   D0,D0
    MOVE.W  LAB_12BC(PC,D0.W),D0
    JMP     LAB_12BC+2(PC,D0.W)

; TODO: Switch case
LAB_12BC:
    DC.W    $000a
    DC.W    $0028
    DC.W    $0044
    DC.W    $0040
	DC.W    $0038
    DC.W    $0040

    CLR.L   (LAB_2039).L
    MOVE.W  22(A3),D0
    MOVE.W  D0,LAB_203A
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    BSR.W   LAB_12AB

    ADDQ.W  #8,A7
    BRA.S   LAB_12BF

    ADDQ.L  #1,LAB_2039
    MOVE.W  22(A3),LAB_203A
    BRA.S   LAB_12BF

    ADDQ.W  #1,LAB_203A
    BRA.S   LAB_12BF

    MOVEQ   #1,D5
    BRA.S   LAB_12BF

LAB_12BE:
    MOVEQ   #5,D7

LAB_12BF:
    TST.L   D5
    BNE.W   LAB_12CE

LAB_12C0:
    TST.L   D5
    BNE.W   LAB_12CB

    MOVEQ   #0,D0
    MOVE.W  LAB_2231,D0
    MOVE.L  LAB_2039,D1
    CMP.L   D0,D1
    BGE.W   LAB_12CB

    TST.B   LAB_224A
    BEQ.W   LAB_12CB

    MOVEQ   #5,D0
    CMP.L   D0,D7
    BEQ.W   LAB_12CB

    MOVE.W  LAB_203A,D0
    EXT.L   D0
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -8(A5)
    PEA     -4(A5)
    BSR.W   LAB_1077

    MOVE.L  D6,(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   LAB_12A4

    LEA     24(A7),A7
    TST.L   D0
    BEQ.W   LAB_12C9

LAB_12C1:
    TST.L   D5
    BNE.W   LAB_12C9

    MOVE.W  LAB_203A,D0
    TST.W   D0
    BLE.W   LAB_12C9

    CMP.W   24(A3),D0
    BGE.W   LAB_12C9

    MOVEQ   #49,D1
    CMP.W   D1,D0
    BNE.S   LAB_12C2

    EXT.L   D0
    MOVE.L  LAB_2039,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -8(A5)
    PEA     -4(A5)
    BSR.W   LAB_1077

    LEA     16(A7),A7
    MOVE.L  D0,D4
    BRA.S   LAB_12C3

LAB_12C2:
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    CMP.W   D1,D4
    BLE.S   LAB_12C3

    SUBI.W  #$30,D4

LAB_12C3:
    TST.L   -4(A5)
    BEQ.W   LAB_12C8

    TST.L   -8(A5)
    BEQ.W   LAB_12C8

    MOVE.W  LAB_203A,D0
    CMP.W   22(A3),D0
    BNE.S   LAB_12C4

    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     LAB_1353(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D4

LAB_12C4:
    TST.W   D4
    BLE.W   LAB_12C6

    MOVEA.L -4(A5),A0
    ADDA.W  #$1c,A0
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_1355(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   LAB_12C6

    MOVEA.L -8(A5),A0
    MOVEA.L A0,A1
    ADDA.W  D4,A1
    BTST    #5,7(A1)
    BNE.S   LAB_12C6

    MOVEA.L A0,A1
    ADDA.W  LAB_203A,A1
    BTST    #7,7(A1)
    BNE.S   LAB_12C6

    MOVE.L  D4,D0
    EXT.L   D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    TST.L   56(A0)
    BEQ.S   LAB_12C6

    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  LAB_1BBD,-(A7)
    PEA     1440.W
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     LAB_1347(PC)

    LEA     20(A7),A7
    TST.L   D0
    BEQ.S   LAB_12C6

    MOVEQ   #1,D0
    CMP.L   D0,D6
    BNE.S   LAB_12C5

    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_1679(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   LAB_12C6

LAB_12C5:
    MOVEQ   #1,D1
    BRA.S   LAB_12C7

LAB_12C6:
    MOVEQ   #0,D1

LAB_12C7:
    MOVE.L  D1,D5

LAB_12C8:
    TST.L   D5
    BNE.W   LAB_12C1

    ADDQ.W  #1,LAB_203A
    BRA.W   LAB_12C1

LAB_12C9:
    TST.L   D5
    BNE.W   LAB_12C0

    MOVEQ   #4,D0
    CMP.L   D0,D7
    BNE.S   LAB_12CA

    MOVEQ   #5,D7
    BRA.W   LAB_12C0

LAB_12CA:
    MOVE.W  22(A3),LAB_203A
    ADDQ.L  #1,LAB_2039
    BRA.W   LAB_12C0

LAB_12CB:
    TST.L   D5
    BEQ.S   LAB_12CE

    MOVEQ   #5,D0
    CMP.L   D0,D7
    BEQ.S   LAB_12CE

    MOVE.L  -4(A5),(A3)
    MOVE.L  -8(A5),4(A3)
    MOVE.L  LAB_2039,8(A3)
    CMPI.W  #$30,LAB_203A
    BLE.S   LAB_12CC

    MOVEQ   #49,D0
    CMP.W   D0,D4
    BGE.S   LAB_12CC

    MOVEQ   #48,D0
    BRA.S   LAB_12CD

LAB_12CC:
    MOVEQ   #0,D0

LAB_12CD:
    MOVE.L  D4,D1
    EXT.L   D1
    ADD.L   D0,D1
    MOVE.W  D1,20(A3)
    MOVEA.L -8(A5),A0
    ADDA.W  D4,A0
    BSET    #5,7(A0)

LAB_12CE:
    TST.L   D5
    BNE.S   LAB_12CF

    SUBA.L  A0,A0
    MOVE.L  A0,(A3)
    MOVE.L  A0,4(A3)

LAB_12CF:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

LAB_12D0:
    LINK.W  A5,#-84
    MOVEM.L D5-D7/A2-A3/A6,-(A7)
    MOVEA.L 12(A5),A3
    MOVEA.L 16(A5),A2
    MOVE.L  20(A5),D7
    CLR.B   (A2)
    MOVE.W  20(A3),D5
    TST.L   (A3)
    BEQ.W   LAB_12EE

    TST.L   4(A3)
    BEQ.W   LAB_12EE

    MOVE.L  A2,D0
    BEQ.W   LAB_12EE

    TST.W   D5
    BLE.W   LAB_12EE

    MOVEQ   #97,D0
    CMP.W   D0,D5
    BGE.W   LAB_12EE

    MOVEQ   #48,D0
    CMP.W   D0,D5
    BLE.S   LAB_12D1

    SUBI.W  #$30,D5

LAB_12D1:
    MOVEA.L 4(A3),A0
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L 56(A1),A6
    MOVE.L  A6,-36(A5)
    MOVE.L  A6,D0
    BEQ.W   LAB_12EE

    TST.B   (A6)
    BEQ.W   LAB_12EE

    MOVEQ   #40,D0
    CMP.B   (A6),D0
    BNE.S   LAB_12D2

    MOVEQ   #58,D0
    CMP.B   3(A6),D0
    BNE.S   LAB_12D2

    MOVEQ   #8,D0
    BRA.S   LAB_12D3

LAB_12D2:
    MOVEQ   #0,D0

LAB_12D3:
    ADD.L   D0,-36(A5)
    MOVE.L  D5,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    MOVE.L  (A3),-(A7)
    JSR     LAB_1337(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    PEA     2.W
    MOVE.L  D1,-(A7)
    MOVE.L  (A3),-(A7)
    MOVE.L  D0,-40(A5)
    JSR     LAB_1337(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    PEA     6.W
    MOVE.L  D1,-(A7)
    MOVE.L  (A3),-(A7)
    MOVE.L  D0,-44(A5)
    JSR     LAB_1337(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    PEA     7.W
    MOVE.L  D1,-(A7)
    MOVE.L  (A3),-(A7)
    MOVE.L  D0,-48(A5)
    JSR     LAB_1337(PC)

    LEA     48(A7),A7
    MOVE.L  D0,-52(A5)
    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   LAB_12D4

    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  4(A3),-(A7)
    JSR     LAB_1679(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   LAB_12D4

    MOVEQ   #1,D1
    BRA.S   LAB_12D5

LAB_12D4:
    MOVEQ   #0,D1

LAB_12D5:
    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  4(A3),-(A7)
    MOVE.L  D0,-(A7)
    PEA     -31(A5)
    MOVE.B  D1,-53(A5)
    JSR     LAB_16F7(PC)

    LEA     12(A7),A7
    MOVE.L  (A3),-80(A5)
    MOVE.L  4(A3),-84(A5)
    MOVEQ   #32,D0
    ADD.W   20(A3),D0
    MOVEM.W D0,-6(A5)
    MOVEQ   #96,D1
    CMP.W   D1,D0
    BLE.S   LAB_12D6

    MOVE.W  D1,-6(A5)

LAB_12D6:
    ADDQ.W  #1,-6(A5)
    MOVE.W  20(A3),D5
    ADDQ.W  #1,D5

LAB_12D7:
    CMP.W   -6(A5),D5
    BGE.W   LAB_12EC

    MOVEQ   #49,D0
    CMP.W   D0,D5
    BNE.S   LAB_12D8

    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  8(A3),-(A7)
    MOVE.L  D0,-(A7)
    PEA     -84(A5)
    PEA     -80(A5)
    BSR.W   LAB_1077

    LEA     16(A7),A7

LAB_12D8:
    MOVEQ   #48,D0
    CMP.W   D0,D5
    BLE.S   LAB_12D9

    MOVE.L  D5,D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    BRA.S   LAB_12DA

LAB_12D9:
    MOVE.L  D5,D0
    EXT.L   D0

LAB_12DA:
    MOVE.L  D0,D6
    TST.L   -80(A5)
    BEQ.W   LAB_12EB

    TST.L   -84(A5)
    BEQ.W   LAB_12EB

    MOVEA.L -80(A5),A0
    ADDA.W  #$1c,A0
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_1355(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   LAB_12EB

    MOVEA.L -84(A5),A0
    MOVEA.L A0,A1
    ADDA.W  D6,A1
    BTST    #5,7(A1)
    BNE.W   LAB_12EB

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   56(A1)
    BEQ.W   LAB_12EB

    MOVEA.L A0,A1
    ADDA.W  D6,A1
    BTST    #7,7(A1)
    BNE.W   LAB_12EB

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L 56(A1),A6
    MOVE.L  A6,-58(A5)
    MOVE.L  A6,D0
    BEQ.S   LAB_12DD

    TST.B   (A6)
    BEQ.S   LAB_12DD

    MOVEQ   #40,D0
    CMP.B   (A6),D0
    BNE.S   LAB_12DB

    MOVEQ   #58,D0
    CMP.B   3(A6),D0
    BNE.S   LAB_12DB

    MOVEQ   #8,D0
    BRA.S   LAB_12DC

LAB_12DB:
    MOVEQ   #0,D0

LAB_12DC:
    ADD.L   D0,-58(A5)

LAB_12DD:
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    MOVE.L  -80(A5),-(A7)
    JSR     LAB_1337(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     2.W
    MOVE.L  D1,-(A7)
    MOVE.L  -80(A5),-(A7)
    MOVE.L  D0,-62(A5)
    JSR     LAB_1337(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     6.W
    MOVE.L  D1,-(A7)
    MOVE.L  -80(A5),-(A7)
    MOVE.L  D0,-66(A5)
    JSR     LAB_1337(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     7.W
    MOVE.L  D1,-(A7)
    MOVE.L  -80(A5),-(A7)
    MOVE.L  D0,-70(A5)
    JSR     LAB_1337(PC)

    LEA     48(A7),A7
    MOVE.L  D0,-74(A5)
    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   LAB_12DE

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -84(A5),-(A7)
    JSR     LAB_1679(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   LAB_12DE

    MOVEQ   #1,D1
    BRA.S   LAB_12DF

LAB_12DE:
    MOVEQ   #0,D1

LAB_12DF:
    MOVE.B  D1,-75(A5)
    TST.L   -58(A5)
    BEQ.W   LAB_12EB

    MOVEA.L -36(A5),A0
    MOVEA.L -58(A5),A1
    CMPA.L  A0,A1
    BEQ.W   LAB_12EB

LAB_12E0:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.W   LAB_12EB

    TST.B   D0
    BNE.S   LAB_12E0

    BNE.W   LAB_12EB

    MOVE.B  -53(A5),D0
    CMP.B   D1,D0
    BNE.W   LAB_12EB

    MOVEA.L -40(A5),A0
    MOVEA.L -62(A5),A1
    CMPA.L  A0,A1
    BEQ.S   LAB_12E2

    MOVE.L  A0,D0
    BEQ.W   LAB_12EB

    MOVE.L  A1,D0
    BEQ.W   LAB_12EB

LAB_12E1:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.W   LAB_12EB

    TST.B   D0
    BNE.S   LAB_12E1

    BNE.W   LAB_12EB

LAB_12E2:
    MOVEA.L -44(A5),A0
    MOVEA.L -66(A5),A1
    CMPA.L  A0,A1
    BEQ.S   LAB_12E4

    MOVE.L  A0,D0
    BEQ.W   LAB_12EB

    MOVE.L  A1,D0
    BEQ.W   LAB_12EB

LAB_12E3:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.W   LAB_12EB

    TST.B   D0
    BNE.S   LAB_12E3

    BNE.W   LAB_12EB

LAB_12E4:
    MOVEA.L -48(A5),A0
    MOVEA.L -70(A5),A1
    CMPA.L  A0,A1
    BEQ.S   LAB_12E6

    MOVE.L  A0,D0
    BEQ.W   LAB_12EB

    MOVE.L  A1,D0
    BEQ.W   LAB_12EB

LAB_12E5:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.W   LAB_12EB

    TST.B   D0
    BNE.S   LAB_12E5

    BNE.W   LAB_12EB

LAB_12E6:
    MOVEA.L -52(A5),A0
    MOVEA.L -74(A5),A1
    CMPA.L  A0,A1
    BEQ.S   LAB_12E8

    MOVE.L  A0,D0
    BEQ.S   LAB_12EB

    MOVE.L  A1,D0
    BEQ.S   LAB_12EB

LAB_12E7:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.S   LAB_12EB

    TST.B   D0
    BNE.S   LAB_12E7

    BNE.S   LAB_12EB

LAB_12E8:
    TST.B   (A2)
    BNE.S   LAB_12EA

    LEA     GLOB_STR_SHOWTIMES_AND_SINGLE_SPACE,A0
    MOVEA.L A2,A1

LAB_12E9:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_12E9

    PEA     -31(A5)
    JSR     LAB_134B(PC)

    MOVE.L  D0,(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  D0,-10(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_3(PC)

    ADDQ.W  #8,A7

LAB_12EA:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  -84(A5),-(A7)
    MOVE.L  D0,-(A7)
    PEA     -31(A5)
    JSR     LAB_16F7(PC)

    PEA     -31(A5)
    JSR     LAB_134B(PC)

    PEA     LAB_203B
    MOVE.L  A2,-(A7)
    MOVE.L  D0,-10(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_3(PC)

    MOVE.L  -10(A5),(A7)
    MOVE.L  A2,-(A7)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_3(PC)

    LEA     28(A7),A7
    MOVEA.L -84(A5),A0
    ADDA.W  D6,A0
    BSET    #5,7(A0)

LAB_12EB:
    ADDQ.W  #1,D5
    BRA.W   LAB_12D7

LAB_12EC:
    TST.B   (A2)
    BNE.S   LAB_12EE

    LEA     GLOB_STR_SHOWING_AT_AND_SINGLE_SPACE,A0
    MOVEA.L A2,A1

LAB_12ED:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_12ED

    PEA     -31(A5)
    JSR     LAB_134B(PC)

    MOVE.L  D0,(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  D0,-10(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_3(PC)

    ADDQ.W  #8,A7

LAB_12EE:
    MOVEM.L (A7)+,D5-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

LAB_12EF:
    LINK.W  A5,#-168
    MOVEM.L D2/D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  16(A5),D7
    MOVE.L  A2,D0
    BEQ.W   LAB_12FC

    LEA     19(A2),A0
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-4(A5)
    JSR     LAB_134B(PC)

    LEA     1(A2),A0
    MOVE.L  A0,(A7)
    MOVE.L  D0,-4(A5)
    MOVE.L  A0,-8(A5)
    JSR     LAB_134B(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,-8(A5)
    TST.L   D7
    BNE.S   LAB_12F1

    MOVEA.L LAB_210D,A0
    LEA     -136(A5),A1

LAB_12F0:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_12F0

    BRA.S   LAB_12F3

LAB_12F1:
    MOVEA.L LAB_2109,A0
    LEA     -136(A5),A1

LAB_12F2:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_12F2

LAB_12F3:
    MOVEA.L -4(A5),A0

LAB_12F4:
    TST.B   (A0)+
    BNE.S   LAB_12F4

    SUBQ.L  #1,A0
    SUBA.L  -4(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     -136(A5)
    JSR     LAB_134C(PC)

    LEA     12(A7),A7
    TST.L   -8(A5)
    BEQ.S   LAB_12F7

    MOVEA.L -8(A5),A0
    TST.B   (A0)
    BEQ.S   LAB_12F7

    MOVE.L  LAB_210F,-(A7)
    PEA     -136(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_3(PC)

    ADDQ.W  #8,A7
    TST.W   GLOB_WORD_SELECT_CODE_IS_RAVESC
    BEQ.S   LAB_12F6

    MOVEA.L -8(A5),A0
    LEA     -146(A5),A1

LAB_12F5:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_12F5

    CLR.B   -144(A5)
    PEA     -146(A5)
    PEA     -136(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_3(PC)

    PEA     LAB_203C
    PEA     -136(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_3(PC)

    MOVEA.L -8(A5),A0
    ADDQ.L  #2,A0
    MOVE.L  A0,(A7)
    PEA     -136(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_3(PC)

    LEA     20(A7),A7
    BRA.S   LAB_12F7

LAB_12F6:
    MOVE.L  -8(A5),-(A7)
    PEA     -136(A5)
    JSR     JMP_TBL_APPEND_DATA_AT_NULL_3(PC)

    ADDQ.W  #8,A7

LAB_12F7:
    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #6,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,-(A7)
    MOVEQ   #6,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    JSR     LAB_0FF4(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    PEA     33.W
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_133D(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    PEA     33.W
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_133D(PC)

    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #3,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVE.W  LAB_232B,D1
    MULU    #3,D1
    LEA     60(A3),A1
    LEA     -136(A5),A6
    MOVE.L  A0,80(A7)
    MOVEA.L A6,A0

LAB_12F8:
    TST.B   (A0)+
    BNE.S   LAB_12F8

    SUBQ.L  #1,A0
    SUBA.L  A6,A0
    MOVE.L  D0,84(A7)
    MOVE.L  D1,88(A7)
    MOVE.L  A0,96(A7)
    MOVEA.L A6,A0
    MOVE.L  96(A7),D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  88(A7),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   LAB_12F9

    ADDQ.L  #1,D1

LAB_12F9:
    ASR.L   #1,D1
    MOVE.L  84(A7),D0
    ADD.L   D1,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    MOVEQ   #34,D2
    SUB.L   D1,D2
    TST.L   D2
    BPL.S   LAB_12FA

    ADDQ.L  #1,D2

LAB_12FA:
    ASR.L   #1,D2
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D2
    SUBQ.L  #1,D2
    MOVE.L  D2,D1
    MOVEA.L 80(A7),A1
    JSR     _LVOMove(A6)

    LEA     60(A3),A0
    LEA     -136(A5),A1
    MOVEA.L A1,A6

LAB_12FB:
    TST.B   (A6)+
    BNE.S   LAB_12FB

    SUBQ.L  #1,A6
    SUBA.L  A1,A6
    MOVEA.L A0,A1
    MOVE.L  A6,D0
    LEA     -136(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOText(A6)

    MOVEQ   #17,D0
    MOVE.W  D0,52(A3)
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,32(A3)
    PEA     67.W
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1038

    LEA     68(A7),A7

LAB_12FC:
    MOVEM.L (A7)+,D2/D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

LAB_12FD:
    LINK.W  A5,#-20
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    LEA     60(A3),A0
    PEA     6.W
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A0,-20(A5)
    BSR.W   LAB_102F

    LEA     12(A7),A7
    MOVEA.L -20(A5),A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,D3
    MOVEA.L -20(A5),A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVE.L  #695,D2
    JSR     _LVORectFill(A6)

    MOVEQ   #42,D6
    MOVEQ   #0,D7
    MOVE.L  D7,D4

.LAB_12FE:
    MOVEQ   #2,D0
    CMP.L   D0,D7
    BGE.W   .LAB_1309

    JSR     LAB_1350(PC)

    TST.L   D0
    BNE.W   .LAB_1309

    MOVE.L  D4,D5
    JSR     LAB_1359(PC)

    TST.L   D0
    BEQ.S   .LAB_1301

    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,-(A7)
    PEA     695.W
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -20(A5),-(A7)
    JSR     LAB_133F(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    TST.L   D0
    BPL.S   .LAB_12FF

    ADDQ.L  #1,D0

.LAB_12FF:
    ASR.L   #1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    SUB.L   D1,D0
    SUBQ.L  #4,D0
    TST.L   D0
    BPL.S   .LAB_1300

    ADDQ.L  #1,D0

.LAB_1300:
    ASR.L   #1,D0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D0
    ADDQ.L  #3,D0
    ADD.L   D0,D5
    BRA.S   .LAB_1307

.LAB_1301:
    JSR     LAB_1351(PC)

    TST.L   D0
    BEQ.S   .LAB_1304

    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    MOVE.L  D0,D1
    TST.L   D1
    BPL.S   .LAB_1302

    ADDQ.L  #1,D1

.LAB_1302:
    ASR.L   #1,D1
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    SUB.L   D2,D1
    SUBQ.L  #4,D1
    TST.L   D1
    BPL.S   .LAB_1303

    ADDQ.L  #1,D1

.LAB_1303:
    ASR.L   #1,D1
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    ADD.L   D2,D1
    SUBQ.L  #1,D1
    ADD.L   D1,D5
    BRA.S   .LAB_1307

.LAB_1304:
    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    TST.L   D0
    BPL.S   .LAB_1305

    ADDQ.L  #1,D0

.LAB_1305:
    ASR.L   #1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    SUB.L   D1,D0
    TST.L   D0
    BPL.S   .LAB_1306

    ADDQ.L  #1,D0

.LAB_1306:
    ASR.L   #1,D0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D0
    SUBQ.L  #1,D0
    ADD.L   D0,D5

.LAB_1307:
    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  -20(A5),-(A7)
    JSR     LAB_1346(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D7
    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    TST.L   D0
    BPL.S   .LAB_1308

    ADDQ.L  #1,D0

.LAB_1308:
    ASR.L   #1,D0
    ADD.L   LAB_1CE8,D0
    ADD.L   D0,D4
    BRA.W   .LAB_12FE

.LAB_1309:
    JSR     LAB_1350(PC)

    TST.L   D0
    BEQ.S   .LAB_130A

    MOVE.L  D4,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,-(A7)
    PEA     695.W
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -20(A5),-(A7)
    JSR     LAB_135A(PC)

    LEA     20(A7),A7

.LAB_130A:
    MOVE.L  D4,D0
    TST.L   D0
    BPL.S   .return

    ADDQ.L  #1,D0

.return:
    ASR.L   #1,D0
    MOVE.W  D0,52(A3)
    JSR     LAB_1350(PC)

    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======

LAB_130C:
    LINK.W  A5,#-8
    MOVEM.L D5-D7/A3,-(A7)
    MOVE.L  8(A5),D7
    MOVEA.L 12(A5),A3
    MOVEQ   #0,D5
    MOVE.L  A3,D0
    BEQ.S   .return

    MOVEA.L 48(A3),A0
    MOVE.L  A0,-4(A5)
    MOVE.L  A0,D0
    BEQ.S   .return

    MOVE.L  A0,D0
    BEQ.S   .return

    MOVE.B  1(A0),D6
    MOVE.B  D6,D0
    EXT.W   D0
    SUBI.W  #'N',D0 ; Does it equal 'N'?
    BEQ.S   .equalsN

    SUBQ.W  #('P'-'N'),D0 ; Does it equal 'P'?
    BEQ.S   .equalsP

    SUBI.W  #('n'-'P'),D0 ; Does it equal 'n'?
    BEQ.S   .equalsN

    SUBQ.W  #('p'-'n'),D0 ; Does it equal 'p'?
    BEQ.S   .equalsP

    BRA.S   .equalsNeither

.equalsN:
    MOVEQ   #0,D5
    BRA.S   .return

.equalsP:
    ; Is D7 less than 18?
    MOVEQ   #18,D0
    CMP.L   D0,D7
    BLE.S   .return

    ; Is D7 greater than 22?
    MOVEQ   #22,D0
    CMP.L   D0,D7
    BGE.S   .return

    ; If it's between 18 and 22 put 1 in D5 and return.
    MOVEQ   #1,D5
    BRA.S   .return

.equalsNeither:
    MOVEQ   #1,D5

.return:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS
