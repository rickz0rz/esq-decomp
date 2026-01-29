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

    JSR     GCOMMAND_ResetHighlightMessages(PC)

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
    JSR     JMP_TBL_CLEANUP_DrawClockFormatList(PC)

    JSR     JMP_TBL_CLEANUP_DrawClockFormatFrame(PC)

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

; Switch case
LAB_1013:
    DC.W    LAB_1013_0016-LAB_1013-2
    DC.W    LAB_1013_0050-LAB_1013-2
    DC.W    LAB_1013_009E-LAB_1013-2
    DC.W    LAB_1013_00EE-LAB_1013-2
    DC.W    LAB_1013_0138-LAB_1013-2
    DC.W    LAB_1013_0182-LAB_1013-2
    DC.W    LAB_1013_01D6-LAB_1013-2
    DC.W    LAB_1013_022A-LAB_1013-2
    DC.W    LAB_1013_027E-LAB_1013-2
    DC.W    LAB_1013_02EC-LAB_1013-2
    DC.W    LAB_1013_00C6-LAB_1013-2
    DC.W    LAB_1013_0356-LAB_1013-2

LAB_1013_0016:
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

LAB_1013_0050:
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

LAB_1013_009E:
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

LAB_1013_00C6:
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

LAB_1013_00EE:
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

LAB_1013_0138:
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

LAB_1013_0182:
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

LAB_1013_01D6:
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

LAB_1013_022A:
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

LAB_1013_027E:
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

LAB_1013_02EC:
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

LAB_1013_0356:
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
    JSR     GCOMMAND_UpdatePresetEntryCache(PC)

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

JMP_TBL_CLEANUP_DrawClockFormatList:
LAB_1022:
    JMP     CLEANUP_DrawClockFormatList

LAB_1023:
    JMP     LAB_058A

LAB_1024:
    ; Reuse cleanup module to draw the shared clock banner.
    JMP     CLEANUP_DrawClockBanner

JMP_TBL_ALLOCATE_MEMORY_3:
    JMP     ALLOCATE_MEMORY

LAB_1026:
    JMP     LAB_0588

JMP_TBL_CLEANUP_DrawClockFormatFrame:
LAB_1027:
    JMP     CLEANUP_DrawClockFormatFrame

LAB_1028:
    JMP     LAB_05D3

LAB_1029:
    JMP     LAB_1970

LAB_102A:
    JMP     LAB_18C2

JMP_TBL_LAB_1A06_6:
    JMP     LAB_1A06
