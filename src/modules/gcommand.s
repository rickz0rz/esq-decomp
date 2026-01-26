;!======

    XDEF    GCOMMAND_LoadDefaultTable
    XDEF    GCOMMAND_LoadCommandFile
    XDEF    GCOMMAND_LoadMplexTemplate
    XDEF    GCOMMAND_LoadMplexFile
    XDEF    GCOMMAND_SaveBrushResult
    XDEF    GCOMMAND_LoadPPVTemplate
    XDEF    GCOMMAND_ParsePPVCommand
    XDEF    GCOMMAND_SeedBannerDefaults
    XDEF    GCOMMAND_SeedBannerFromPrefs
    XDEF    GCOMMAND_FindPathSeparator
    XDEF    GCOMMAND_ApplyHighlightFlag
    XDEF    GCOMMAND_EnableHighlight
    XDEF    GCOMMAND_DisableHighlight
    XDEF    GCOMMAND_SetPresetEntry
    XDEF    GCOMMAND_ExpandPresetBlock
    XDEF    GCOMMAND_MapKeycodeToPreset
    XDEF    GCOMMAND_GetBannerChar
    XDEF    GCOMMAND_LoadPPV3Template

; Load the built-in gcommand table template into the working buffer (LAB_21BC).
GCOMMAND_LoadDefaultTable:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    PEA     LAB_1F66
    JSR     LAB_0F9B(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BEQ.S   LAB_0CCA

    MOVEA.L LAB_21BC,A0
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,D7
    MOVE.L  A0,-8(A5)
    LEA     LAB_22CC,A1
    MOVEQ   #32,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    MOVEQ   #32,D0
    ADD.L   D0,LAB_21BC
    SUBA.L  A0,A0
    MOVE.L  A0,LAB_22D4
    MOVE.L  A0,-(A7)
    MOVE.L  LAB_21BC,-(A7)
    JSR     LAB_0B44(PC)

    MOVE.L  D0,LAB_22D4
    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -8(A5),-(A7)
    PEA     335.W
    PEA     GLOB_STR_GCOMMAND_C_1
    JSR     JMP_TBL_DEALLOCATE_MEMORY_3(PC)

    LEA     20(A7),A7

LAB_0CCA:
    MOVEQ   #1,D0
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

; Load a command definition from disk (LAB_1F68) and copy it into the workspace.
GCOMMAND_LoadCommandFile:
    LINK.W  A5,#-40
    MOVE.L  D7,-(A7)
    PEA     MODE_NEWFILE.W
    PEA     LAB_1F68
    JSR     JMP_TBL_LOAD_FILE_CONTENTS_INTO_MEMORY_MAYBE_1(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    TST.L   D7
    BEQ.S   LAB_0CCE

    LEA     LAB_22CC,A0
    LEA     -40(A5),A1
    MOVEQ   #7,D0

LAB_0CCC:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,LAB_0CCC
    MOVE.L  -12(A5),-8(A5)
    CLR.L   -12(A5)
    PEA     32.W
    PEA     -40(A5)
    MOVE.L  D7,-(A7)
    JSR     LAB_0F97(PC)

    MOVEA.L -8(A5),A0
    MOVE.L  A0,-12(A5)

LAB_0CCD:
    TST.B   (A0)+
    BNE.S   LAB_0CCD

    SUBQ.L  #1,A0
    SUBA.L  -12(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  D7,-(A7)
    JSR     LAB_0F97(PC)

    MOVE.L  D7,(A7)
    JSR     LAB_0F98(PC)

    LEA     20(A7),A7

LAB_0CCE:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

LAB_0CCF:
    LINK.W  A5,#-20
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D6
    LEA     LAB_1F69,A0
    LEA     -12(A5),A1
    MOVE.B  (A0)+,(A1)+
    MOVE.B  (A0)+,(A1)+
    MOVE.B  (A0)+,(A1)+
    MOVE.B  (A0)+,(A1)+
    MOVEQ   #0,D5
    MOVEQ   #0,D4
    BSR.W   LAB_0CC5

    MOVE.L  A3,D0
    BEQ.W   LAB_0CE7

    TST.B   (A3)
    BEQ.W   LAB_0CE7

    PEA     2.W
    MOVE.L  A3,-(A7)
    PEA     -12(A5)
    JSR     LAB_0EF2(PC)

    CLR.B   -10(A5)
    PEA     -12(A5)
    JSR     LAB_0BFA(PC)

    LEA     16(A7),A7
    MOVE.L  D0,D7
    ADDQ.L  #2,D7
    MOVEQ   #2,D6
    CMP.L   D7,D6
    BGE.S   LAB_0CD4

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #1,(A1)
    BEQ.S   LAB_0CD0

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   LAB_0CD1

LAB_0CD0:
    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0

LAB_0CD1:
    MOVE.L  D0,D5
    MOVEQ   #89,D0
    CMP.B   D0,D5
    BEQ.S   LAB_0CD2

    MOVEQ   #78,D0
    CMP.B   D0,D5
    BNE.S   LAB_0CD3

LAB_0CD2:
    MOVE.L  D5,D0
    MOVE.B  D0,LAB_22CC

LAB_0CD3:
    ADDQ.L  #1,D6

LAB_0CD4:
    CMP.L   D7,D6
    BGE.S   LAB_0CD6

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    SUB.L   D1,D4
    MOVEQ   #1,D0
    CMP.L   D0,D4
    BLT.S   LAB_0CD5

    MOVEQ   #3,D1
    CMP.L   D1,D4
    BGT.S   LAB_0CD5

    MOVE.L  D4,LAB_22CD

LAB_0CD5:
    ADDQ.L  #1,D6

LAB_0CD6:
    CMP.L   D7,D6
    BGE.S   LAB_0CD8

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   LAB_0CD7

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0E2D(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,LAB_22CE

LAB_0CD7:
    ADDQ.L  #1,D6

LAB_0CD8:
    CMP.L   D7,D6
    BGE.S   LAB_0CDA

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    SUB.L   D1,D4
    MOVEQ   #1,D0
    CMP.L   D0,D4
    BLT.S   LAB_0CD9

    MOVEQ   #3,D1
    CMP.L   D1,D4
    BGT.S   LAB_0CD9

    MOVE.L  D4,LAB_22CF

LAB_0CD9:
    ADDQ.L  #1,D6

LAB_0CDA:
    CMP.L   D7,D6
    BGE.S   LAB_0CDC

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   LAB_0CDB

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0E2D(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,LAB_22D0

LAB_0CDB:
    ADDQ.L  #1,D6

LAB_0CDC:
    CMP.L   D7,D6
    BGE.S   LAB_0CE1

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   LAB_0CDD

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   LAB_0CDE

LAB_0CDD:
    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0

LAB_0CDE:
    MOVE.L  D0,D5
    MOVEQ   #70,D0
    CMP.B   D0,D5
    BEQ.S   LAB_0CDF

    MOVEQ   #66,D0
    CMP.B   D0,D5
    BEQ.S   LAB_0CDF

    MOVEQ   #76,D0
    CMP.B   D0,D5
    BEQ.S   LAB_0CDF

    MOVEQ   #78,D0
    CMP.B   D0,D5
    BNE.S   LAB_0CE0

LAB_0CDF:
    MOVE.L  D5,D0
    MOVE.B  D0,LAB_22D3

LAB_0CE0:
    ADDQ.L  #1,D6

LAB_0CE1:
    CMP.L   D7,D6
    BGE.S   LAB_0CE4

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    SUB.L   D1,D4
    MOVEQ   #1,D0
    CMP.L   D0,D4
    BNE.S   LAB_0CE2

    MOVEQ   #0,D1
    MOVE.L  D1,LAB_22D1
    MOVE.L  D0,LAB_22D2
    BRA.S   LAB_0CE3

LAB_0CE2:
    TST.L   D4
    BMI.S   LAB_0CE3

    MOVEQ   #9,D1
    CMP.L   D1,D4
    BGT.S   LAB_0CE3

    MOVE.L  D4,LAB_22D1
    CLR.L   LAB_22D2

LAB_0CE3:
    ADDQ.L  #1,D6

LAB_0CE4:
    CMP.L   D7,D6
    BLE.S   LAB_0CE5

    MOVE.L  D6,D0
    BRA.S   LAB_0CE6

LAB_0CE5:
    MOVE.L  D7,D0

LAB_0CE6:
    MOVE.L  D0,D7
    MOVEA.L A3,A0
    ADDA.L  D7,A0
    TST.B   (A0)
    BEQ.S   LAB_0CE7

    MOVE.L  LAB_22D4,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_22D4

LAB_0CE7:
    BSR.W   GCOMMAND_LoadCommandFile

    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======

; Load the Digital_Mplex template and stage it in LAB_22E2/LAB_22E3.
GCOMMAND_LoadMplexTemplate:
LAB_0CE8:
    LINK.W  A5,#-16
    MOVE.L  D7,-(A7)
    PEA     LAB_1F6A
    JSR     LAB_0F9B(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BEQ.W   LAB_0CEB

    MOVEA.L LAB_21BC,A0
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,D7
    MOVE.L  A0,-4(A5)
    LEA     LAB_22D5,A1
    MOVEQ   #52,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    MOVEQ   #52,D0
    ADD.L   D0,LAB_21BC
    SUBA.L  A0,A0
    MOVE.L  A0,LAB_22E2
    MOVE.L  A0,LAB_22E3
    PEA     18.W
    MOVE.L  LAB_21BC,-(A7)
    JSR     LAB_0D57(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)
    TST.L   D0
    BEQ.S   LAB_0CE9

    MOVEA.L D0,A0
    TST.B   (A0)
    BEQ.S   LAB_0CE9

    CLR.B   (A0)+
    MOVE.L  A0,-12(A5)

LAB_0CE9:
    MOVE.L  LAB_22E3,-(A7)
    MOVE.L  LAB_21BC,-(A7)
    JSR     LAB_0B44(PC)

    MOVE.L  D0,LAB_22E3
    MOVE.L  LAB_22E2,(A7)
    MOVE.L  -12(A5),-(A7)
    JSR     LAB_0B44(PC)

    MOVE.L  D0,LAB_22E2
    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     575.W
    PEA     GLOB_STR_GCOMMAND_C_2
    JSR     JMP_TBL_DEALLOCATE_MEMORY_3(PC)

    LEA     24(A7),A7
    CLR.L   -16(A5)
    TST.L   LAB_22E3
    BEQ.S   LAB_0CEA

    MOVEA.L LAB_22E3,A0
    TST.B   (A0)
    BEQ.S   LAB_0CEA

    PEA     LAB_1F6C
    MOVE.L  A0,-(A7)
    JSR     LAB_0D58(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-16(A5)

LAB_0CEA:
    TST.L   -16(A5)
    BEQ.S   LAB_0CEB

    MOVEA.L -16(A5),A0
    TST.B   (A0)
    BEQ.S   LAB_0CEB

    MOVE.B  #$73,1(A0)

LAB_0CEB:
    MOVEQ   #1,D0
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

; Load Digital_Mplex.dat from disk and merge it into the workspace buffers.
GCOMMAND_LoadMplexFile:
LAB_0CEC:
    LINK.W  A5,#-64
    MOVE.L  D7,-(A7)
    PEA     MODE_NEWFILE.W
    PEA     LAB_1F6D
    JSR     JMP_TBL_LOAD_FILE_CONTENTS_INTO_MEMORY_MAYBE_1(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    TST.L   D7
    BEQ.W   LAB_0CF0

    LEA     LAB_22D5,A0
    LEA     -64(A5),A1
    MOVEQ   #12,D0

LAB_0CED:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,LAB_0CED
    MOVE.L  -16(A5),-8(A5)
    MOVE.L  -20(A5),-12(A5)
    SUBA.L  A0,A0
    MOVE.L  A0,-16(A5)
    MOVE.L  A0,-20(A5)
    PEA     52.W
    PEA     -64(A5)
    MOVE.L  D7,-(A7)
    JSR     LAB_0F97(PC)

    MOVEA.L -8(A5),A0
    MOVE.L  A0,-16(A5)
    MOVE.L  -12(A5),-20(A5)

LAB_0CEE:
    TST.B   (A0)+
    BNE.S   LAB_0CEE

    SUBQ.L  #1,A0
    SUBA.L  -16(A5),A0
    MOVE.L  A0,(A7)
    MOVE.L  -16(A5),-(A7)
    MOVE.L  D7,-(A7)
    JSR     LAB_0F97(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,(A7)
    PEA     LAB_1F6E
    MOVE.L  D7,-(A7)
    JSR     LAB_0F97(PC)

    MOVEA.L -20(A5),A0

LAB_0CEF:
    TST.B   (A0)+
    BNE.S   LAB_0CEF

    SUBQ.L  #1,A0
    SUBA.L  -20(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -20(A5),-(A7)
    MOVE.L  D7,-(A7)
    JSR     LAB_0F97(PC)

    MOVE.L  D7,(A7)
    JSR     LAB_0F98(PC)

    LEA     36(A7),A7

LAB_0CF0:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

; Parse a command line into token flags, returning indices for gcommand execution.
GCOMMAND_ParseCommandString:
LAB_0CF1:
    LINK.W  A5,#-28
    MOVEM.L D2/D4-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D6
    LEA     LAB_1F6F,A0
    LEA     -12(A5),A1
    MOVE.B  (A0)+,(A1)+
    MOVE.B  (A0)+,(A1)+
    MOVE.B  (A0)+,(A1)+
    MOVE.B  (A0)+,(A1)+
    MOVEQ   #0,D5
    MOVEQ   #0,D4
    MOVE.B  #$12,-19(A5)
    SUBA.L  A0,A0
    MOVE.L  A0,-28(A5)
    MOVE.L  A0,-24(A5)
    BSR.W   LAB_0CC6

    MOVE.L  A3,D0
    BEQ.W   LAB_0D1D

    TST.B   (A3)
    BEQ.W   LAB_0D1D

    PEA     2.W
    MOVE.L  A3,-(A7)
    PEA     -12(A5)
    JSR     LAB_0EF2(PC)

    CLR.B   -10(A5)
    PEA     -12(A5)
    JSR     LAB_0BFA(PC)

    LEA     16(A7),A7
    MOVE.L  D0,D7
    ADDQ.L  #2,D7
    MOVEQ   #2,D6
    CMP.L   D7,D6
    BGE.S   LAB_0CF6

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   LAB_0CF2

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   LAB_0CF3

LAB_0CF2:
    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0

LAB_0CF3:
    MOVE.L  D0,D5
    MOVEQ   #89,D0
    CMP.B   D0,D5
    BEQ.S   LAB_0CF4

    MOVEQ   #78,D0
    CMP.B   D0,D5
    BNE.S   LAB_0CF5

LAB_0CF4:
    MOVE.L  D5,D0
    MOVE.B  D0,LAB_22D5

LAB_0CF5:
    ADDQ.L  #1,D6

LAB_0CF6:
    CMP.L   D7,D6
    BGE.S   LAB_0CF8

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    SUB.L   D1,D4
    BLT.S   LAB_0CF7

    MOVEQ   #9,D0
    CMP.L   D0,D4
    BGT.S   LAB_0CF7

    MOVE.L  D4,LAB_22D6

LAB_0CF7:
    ADDQ.L  #1,D6

LAB_0CF8:
    CMP.L   D7,D6
    BGE.S   LAB_0CFA

    MOVE.B  0(A3,D6.L),-12(A5)
    MOVE.B  1(A3,D6.L),-11(A5)
    CLR.B   -10(A5)
    PEA     -12(A5)
    JSR     LAB_0BFA(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D4
    TST.L   D4
    BMI.S   LAB_0CF9

    MOVEQ   #99,D0
    CMP.L   D0,D4
    BGT.S   LAB_0CF9

    MOVE.B  -12(A5),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   LAB_0CF9

    MOVE.B  -11(A5),D0
    EXT.W   D0
    EXT.L   D0
    ADDA.L  D0,A0
    BTST    #2,(A0)
    BEQ.S   LAB_0CF9

    MOVE.L  D4,LAB_22D7

LAB_0CF9:
    ADDQ.L  #2,D6

LAB_0CFA:
    CMP.L   D7,D6
    BGE.S   LAB_0CFC

    MOVE.B  0(A3,D6.L),-12(A5)
    MOVE.B  1(A3,D6.L),-11(A5)
    CLR.B   -10(A5)
    PEA     -12(A5)
    JSR     LAB_0BFA(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D4
    TST.L   D4
    BMI.S   LAB_0CFB

    MOVEQ   #29,D0
    CMP.L   D0,D4
    BGT.S   LAB_0CFB

    MOVE.B  -12(A5),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   LAB_0CFB

    MOVE.B  -11(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   LAB_0CFB

    MOVE.L  D4,LAB_22D8

LAB_0CFB:
    ADDQ.L  #2,D6

LAB_0CFC:
    CMP.L   D7,D6
    BGE.S   LAB_0CFE

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    SUB.L   D1,D4
    MOVEQ   #1,D0
    CMP.L   D0,D4
    BLT.S   LAB_0CFD

    MOVEQ   #3,D1
    CMP.L   D1,D4
    BGT.S   LAB_0CFD

    MOVE.L  D4,LAB_22D9

LAB_0CFD:
    ADDQ.L  #1,D6

LAB_0CFE:
    CMP.L   D7,D6
    BGE.S   LAB_0D00

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   LAB_0CFF

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0E2D(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,LAB_22DA

LAB_0CFF:
    ADDQ.L  #1,D6

LAB_0D00:
    CMP.L   D7,D6
    BGE.S   LAB_0D02

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    SUB.L   D1,D4
    MOVEQ   #1,D0
    CMP.L   D0,D4
    BLT.S   LAB_0D01

    MOVEQ   #3,D1
    CMP.L   D1,D4
    BGT.S   LAB_0D01

    MOVE.L  D4,LAB_22DB

LAB_0D01:
    ADDQ.L  #1,D6

LAB_0D02:
    CMP.L   D7,D6
    BGE.S   LAB_0D04

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   LAB_0D03

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0E2D(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,LAB_22DC

LAB_0D03:
    ADDQ.L  #1,D6

LAB_0D04:
    CMP.L   D7,D6
    BGE.S   LAB_0D06

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    SUB.L   D1,D4
    MOVEQ   #1,D0
    CMP.L   D0,D4
    BLT.S   LAB_0D05

    MOVEQ   #3,D2
    CMP.L   D2,D4
    BGT.S   LAB_0D05

    MOVE.L  D4,LAB_22DD

LAB_0D05:
    ADDQ.L  #1,D6

LAB_0D06:
    CMP.L   D7,D6
    BGE.S   LAB_0D08

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    SUB.L   D1,D4
    MOVEQ   #1,D0
    CMP.L   D0,D4
    BLT.S   LAB_0D07

    MOVEQ   #3,D1
    CMP.L   D1,D4
    BGT.S   LAB_0D07

    MOVE.L  D4,LAB_22DE

LAB_0D07:
    ADDQ.L  #1,D6

LAB_0D08:
    CMP.L   D7,D6
    BGE.S   LAB_0D0A

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   LAB_0D09

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0E2D(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,LAB_22DF

LAB_0D09:
    ADDQ.L  #1,D6

LAB_0D0A:
    CMP.L   D7,D6
    BGE.S   LAB_0D0F

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #1,(A1)
    BEQ.S   LAB_0D0B

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   LAB_0D0C

LAB_0D0B:
    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0

LAB_0D0C:
    MOVE.L  D0,D5
    MOVEQ   #70,D0
    CMP.B   D0,D5
    BEQ.S   LAB_0D0D

    MOVEQ   #66,D0
    CMP.B   D0,D5
    BEQ.S   LAB_0D0D

    MOVEQ   #76,D0
    CMP.B   D0,D5
    BEQ.S   LAB_0D0D

    MOVEQ   #78,D0
    CMP.B   D0,D5
    BNE.S   LAB_0D0E

LAB_0D0D:
    MOVE.L  D5,D0
    MOVE.B  D0,LAB_22E0

LAB_0D0E:
    ADDQ.L  #1,D6

LAB_0D0F:
    CMP.L   D7,D6
    BGE.S   LAB_0D14

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   LAB_0D10

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   LAB_0D11

LAB_0D10:
    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0

LAB_0D11:
    MOVE.L  D0,D5
    MOVEQ   #89,D0
    CMP.B   D0,D5
    BEQ.S   LAB_0D12

    MOVEQ   #78,D0
    CMP.B   D0,D5
    BNE.S   LAB_0D13

LAB_0D12:
    MOVE.L  D5,D0
    MOVE.B  D0,LAB_22E1

LAB_0D13:
    ADDQ.L  #1,D6

LAB_0D14:
    CMP.L   D7,D6
    BLE.S   LAB_0D15

    MOVE.L  D6,D0
    BRA.S   LAB_0D16

LAB_0D15:
    MOVE.L  D7,D0

LAB_0D16:
    MOVE.L  D0,D7
    MOVEA.L A3,A0
    ADDA.L  D7,A0
    TST.B   (A0)
    BEQ.W   LAB_0D1B

    MOVE.B  -19(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0D57(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-24(A5)
    TST.L   D0
    BEQ.S   LAB_0D1A

    MOVEA.L D0,A0
    TST.B   (A0)
    BEQ.S   LAB_0D1A

    CLR.B   (A0)+
    MOVEA.L A3,A1
    ADDA.L  D7,A1
    MOVEA.L A1,A2

LAB_0D17:
    TST.B   (A2)+
    BNE.S   LAB_0D17

    SUBQ.L  #1,A2
    SUBA.L  A1,A2
    MOVE.L  A0,-24(A5)
    MOVE.L  A2,D0
    MOVEQ   #127,D1
    CMP.L   D1,D0
    BLE.S   LAB_0D18

    CLR.B   127(A3,D7.L)

LAB_0D18:
    MOVEA.L A3,A0
    ADDA.L  D7,A0
    TST.B   (A0)
    BEQ.S   LAB_0D19

    MOVE.L  LAB_22E3,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_22E3

LAB_0D19:
    TST.L   -24(A5)
    BEQ.S   LAB_0D1B

    MOVEA.L -24(A5),A0
    TST.B   (A0)
    BEQ.S   LAB_0D1B

    MOVE.L  LAB_22E2,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_22E2
    BRA.S   LAB_0D1B

LAB_0D1A:
    MOVEA.L A3,A0
    ADDA.L  D7,A0
    TST.B   (A0)
    BEQ.S   LAB_0D1B

    MOVE.L  LAB_22E3,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_22E3

LAB_0D1B:
    CLR.L   -28(A5)
    TST.L   LAB_22E3
    BEQ.S   LAB_0D1C

    MOVEA.L LAB_22E3,A0
    TST.B   (A0)
    BEQ.S   LAB_0D1C

    PEA     LAB_1F70
    MOVE.L  A0,-(A7)
    JSR     LAB_0D58(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-28(A5)

LAB_0D1C:
    TST.L   -28(A5)
    BEQ.S   LAB_0D1D

    MOVEA.L -28(A5),A0
    TST.B   (A0)
    BEQ.S   LAB_0D1D

    MOVE.L  A0,D0
    SUB.L   LAB_22E3,D0
    MOVE.L  D0,D4
    ADDQ.L  #1,D4
    MOVEA.L LAB_22E3,A0
    ADDA.L  D4,A0
    MOVE.B  #$73,(A0)

LAB_0D1D:
    BSR.W   GCOMMAND_LoadMplexFile

    MOVEM.L (A7)+,D2/D4-D7/A2-A3
    UNLK    A5
    RTS

;!======

; Load the Digital_PPV3 template into the working buffer tables.
GCOMMAND_LoadPPV3Template:
LAB_0D1E:
    LINK.W  A5,#-20
    MOVEM.L D5-D7,-(A7)
    MOVEQ   #0,D6
    MOVEQ   #0,D5
    PEA     LAB_1F71
    JSR     LAB_0F9B(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BEQ.S   LAB_0D1F

    MOVEQ   #56,D6
    BRA.S   LAB_0D20

LAB_0D1F:
    PEA     LAB_1F72
    JSR     LAB_0F9B(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BEQ.S   LAB_0D20

    MOVEQ   #52,D6
    LEA     LAB_1F73,A0
    MOVE.L  A0,D1
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVODeleteFile(A6)

    MOVEQ   #1,D5

LAB_0D20:
    TST.L   D6
    BEQ.W   LAB_0D22

    MOVEA.L LAB_21BC,A0
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,D7
    MOVE.L  A0,-4(A5)
    MOVE.L  D6,D0
    LEA     LAB_22E4,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    SUBA.L  A0,A0
    MOVE.L  A0,LAB_22F2
    MOVE.L  A0,LAB_22F1
    ADD.L   D6,LAB_21BC
    PEA     18.W
    MOVE.L  LAB_21BC,-(A7)
    JSR     LAB_0D57(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.S   LAB_0D21

    MOVEA.L D0,A0
    TST.B   (A0)
    BEQ.S   LAB_0D21

    CLR.B   (A0)+
    MOVE.L  A0,-8(A5)

LAB_0D21:
    MOVE.L  LAB_22F2,-(A7)
    MOVE.L  LAB_21BC,-(A7)
    JSR     LAB_0B44(PC)

    MOVE.L  D0,LAB_22F2
    MOVE.L  LAB_22F1,(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_0B44(PC)

    MOVE.L  D0,LAB_22F1
    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     993.W
    PEA     GLOB_STR_GCOMMAND_C_3
    JSR     JMP_TBL_DEALLOCATE_MEMORY_3(PC)

    LEA     24(A7),A7
    TST.L   D5
    BEQ.S   LAB_0D22

    BSR.W   GCOMMAND_LoadPPVTemplate

LAB_0D22:
    MOVEQ   #1,D0
    MOVEM.L (A7)+,D5-D7
    UNLK    A5
    RTS

;!======

; Load the PPV table template into the workspace buffers.
GCOMMAND_LoadPPVTemplate:
LAB_0D23:
    LINK.W  A5,#-68
    MOVE.L  D7,-(A7)
    PEA     MODE_NEWFILE.W
    PEA     LAB_1F75
    JSR     JMP_TBL_LOAD_FILE_CONTENTS_INTO_MEMORY_MAYBE_1(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    TST.L   D7
    BEQ.W   LAB_0D27

    LEA     LAB_22E4,A0
    LEA     -68(A5),A1
    MOVEQ   #13,D0

LAB_0D24:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,LAB_0D24
    MOVE.L  -20(A5),-8(A5)
    MOVE.L  -24(A5),-12(A5)
    SUBA.L  A0,A0
    MOVE.L  A0,-20(A5)
    MOVE.L  A0,-24(A5)
    PEA     56.W
    PEA     -68(A5)
    MOVE.L  D7,-(A7)
    JSR     LAB_0F97(PC)

    MOVEA.L -8(A5),A0
    MOVE.L  A0,-20(A5)
    MOVE.L  -12(A5),-24(A5)

LAB_0D25:
    TST.B   (A0)+
    BNE.S   LAB_0D25

    SUBQ.L  #1,A0
    SUBA.L  -20(A5),A0
    MOVE.L  A0,(A7)
    MOVE.L  -20(A5),-(A7)
    MOVE.L  D7,-(A7)
    JSR     LAB_0F97(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,(A7)
    PEA     LAB_1F76
    MOVE.L  D7,-(A7)
    JSR     LAB_0F97(PC)

    MOVEA.L -24(A5),A0

LAB_0D26:
    TST.B   (A0)+
    BNE.S   LAB_0D26

    SUBQ.L  #1,A0
    SUBA.L  -24(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -24(A5),-(A7)
    MOVE.L  D7,-(A7)
    JSR     LAB_0F97(PC)

    MOVE.L  D7,(A7)
    JSR     LAB_0F98(PC)

    LEA     36(A7),A7

LAB_0D27:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

; Parse a PPV command string into tokens/indices for execution.
GCOMMAND_ParsePPVCommand:
LAB_0D28:
    LINK.W  A5,#-24
    MOVEM.L D2/D4-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D6
    LEA     LAB_1F77,A0
    LEA     -12(A5),A1
    MOVE.B  (A0)+,(A1)+
    MOVE.B  (A0)+,(A1)+
    MOVE.B  (A0)+,(A1)+
    MOVE.B  (A0)+,(A1)+
    MOVEQ   #0,D5
    MOVEQ   #0,D4
    MOVE.B  #$12,-19(A5)
    CLR.L   -24(A5)
    BSR.W   LAB_0CC7

    MOVE.L  A3,D0
    BEQ.W   LAB_0D56

    TST.B   (A3)
    BEQ.W   LAB_0D56

    PEA     2.W
    MOVE.L  A3,-(A7)
    PEA     -12(A5)
    JSR     LAB_0EF2(PC)

    CLR.B   -10(A5)
    PEA     -12(A5)
    JSR     LAB_0BFA(PC)

    LEA     16(A7),A7
    MOVE.L  D0,D7
    ADDQ.L  #2,D7
    MOVEQ   #2,D6
    CMP.L   D7,D6
    BGE.S   LAB_0D2D

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   LAB_0D29

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   LAB_0D2A

LAB_0D29:
    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0

LAB_0D2A:
    MOVE.L  D0,D5
    MOVEQ   #89,D0
    CMP.B   D0,D5
    BEQ.S   LAB_0D2B

    MOVEQ   #78,D0
    CMP.B   D0,D5
    BNE.S   LAB_0D2C

LAB_0D2B:
    MOVE.L  D5,D0
    MOVE.B  D0,LAB_22E4

LAB_0D2C:
    ADDQ.L  #1,D6

LAB_0D2D:
    CMP.L   D7,D6
    BGE.S   LAB_0D2F

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    SUB.L   D1,D4
    BLT.S   LAB_0D2E

    MOVEQ   #9,D0
    CMP.L   D0,D4
    BGT.S   LAB_0D2E

    MOVE.L  D4,LAB_22E5

LAB_0D2E:
    ADDQ.L  #1,D6

LAB_0D2F:
    CMP.L   D7,D6
    BGE.S   LAB_0D31

    MOVE.B  0(A3,D6.L),-12(A5)
    MOVE.B  1(A3,D6.L),-11(A5)
    MOVE.B  2(A3,D6.L),-10(A5)
    CLR.B   -9(A5)
    PEA     -12(A5)
    JSR     LAB_0BFA(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D4
    TST.L   D4
    BMI.S   LAB_0D30

    CMPI.L  #$3e7,D4
    BGT.S   LAB_0D30

    MOVE.B  -12(A5),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   LAB_0D30

    MOVE.B  -11(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   LAB_0D30

    MOVE.B  -10(A5),D0
    EXT.W   D0
    EXT.L   D0
    ADDA.L  D0,A0
    BTST    #2,(A0)
    BEQ.S   LAB_0D30

    MOVE.L  D4,LAB_22E6

LAB_0D30:
    ADDQ.L  #3,D6

LAB_0D31:
    CMP.L   D7,D6
    BGE.S   LAB_0D33

    MOVE.B  0(A3,D6.L),-12(A5)
    MOVE.B  1(A3,D6.L),-11(A5)
    MOVE.B  2(A3,D6.L),-10(A5)
    CLR.B   -9(A5)
    PEA     -12(A5)
    JSR     LAB_0BFA(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D4
    TST.L   D4
    BMI.S   LAB_0D32

    CMPI.L  #$3e7,D4
    BGT.S   LAB_0D32

    MOVE.B  -12(A5),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   LAB_0D32

    MOVE.B  -11(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   LAB_0D32

    MOVE.B  -10(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   LAB_0D32

    MOVE.L  D4,LAB_22E7

LAB_0D32:
    ADDQ.L  #3,D6

LAB_0D33:
    CMP.L   D7,D6
    BGE.S   LAB_0D35

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    SUB.L   D1,D4
    MOVEQ   #1,D0
    CMP.L   D0,D4
    BLT.S   LAB_0D34

    MOVEQ   #3,D1
    CMP.L   D1,D4
    BGT.S   LAB_0D34

    MOVE.L  D4,LAB_22E8

LAB_0D34:
    ADDQ.L  #1,D6

LAB_0D35:
    CMP.L   D7,D6
    BGE.S   LAB_0D37

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   LAB_0D36

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0E2D(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,LAB_22E9

LAB_0D36:
    ADDQ.L  #1,D6

LAB_0D37:
    CMP.L   D7,D6
    BGE.S   LAB_0D39

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    SUB.L   D1,D4
    MOVEQ   #1,D0
    CMP.L   D0,D4
    BLT.S   LAB_0D38

    MOVEQ   #3,D1
    CMP.L   D1,D4
    BGT.S   LAB_0D38

    MOVE.L  D4,LAB_22EA

LAB_0D38:
    ADDQ.L  #1,D6

LAB_0D39:
    CMP.L   D7,D6
    BGE.S   LAB_0D3B

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   LAB_0D3A

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0E2D(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,LAB_22EB

LAB_0D3A:
    ADDQ.L  #1,D6

LAB_0D3B:
    CMP.L   D7,D6
    BGE.S   LAB_0D3D

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    SUB.L   D1,D4
    MOVEQ   #1,D0
    CMP.L   D0,D4
    BLT.S   LAB_0D3C

    MOVEQ   #3,D2
    CMP.L   D2,D4
    BGT.S   LAB_0D3C

    MOVE.L  D4,LAB_22EC

LAB_0D3C:
    ADDQ.L  #1,D6

LAB_0D3D:
    CMP.L   D7,D6
    BGE.S   LAB_0D3F

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    SUB.L   D1,D4
    MOVEQ   #1,D0
    CMP.L   D0,D4
    BLT.S   LAB_0D3E

    MOVEQ   #3,D1
    CMP.L   D1,D4
    BGT.S   LAB_0D3E

    MOVE.L  D4,LAB_22ED

LAB_0D3E:
    ADDQ.L  #1,D6

LAB_0D3F:
    CMP.L   D7,D6
    BGE.S   LAB_0D41

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   LAB_0D40

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0E2D(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,LAB_22EE

LAB_0D40:
    ADDQ.L  #1,D6

LAB_0D41:
    CMP.L   D7,D6
    BGE.S   LAB_0D46

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #1,(A1)
    BEQ.S   LAB_0D42

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   LAB_0D43

LAB_0D42:
    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0

LAB_0D43:
    MOVE.L  D0,D5
    MOVEQ   #70,D0
    CMP.B   D0,D5
    BEQ.S   LAB_0D44

    MOVEQ   #66,D0
    CMP.B   D0,D5
    BEQ.S   LAB_0D44

    MOVEQ   #76,D0
    CMP.B   D0,D5
    BEQ.S   LAB_0D44

    MOVEQ   #78,D0
    CMP.B   D0,D5
    BNE.S   LAB_0D45

LAB_0D44:
    MOVE.L  D5,D0
    MOVE.B  D0,LAB_22EF

LAB_0D45:
    ADDQ.L  #1,D6

LAB_0D46:
    CMP.L   D7,D6
    BGE.S   LAB_0D4B

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   LAB_0D47

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   LAB_0D48

LAB_0D47:
    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0

LAB_0D48:
    MOVE.L  D0,D5
    MOVEQ   #89,D0
    CMP.B   D0,D5
    BEQ.S   LAB_0D49

    MOVEQ   #78,D0
    CMP.B   D0,D5
    BNE.S   LAB_0D4A

LAB_0D49:
    MOVE.L  D5,D0
    MOVE.B  D0,LAB_22F0

LAB_0D4A:
    ADDQ.L  #1,D6

LAB_0D4B:
    CMP.L   D7,D6
    BGE.S   LAB_0D4E

    MOVEA.L A3,A0
    ADDA.L  D6,A0
    PEA     2.W
    MOVE.L  A0,-(A7)
    PEA     -12(A5)
    JSR     LAB_0EF2(PC)

    CLR.B   -10(A5)
    PEA     -12(A5)
    JSR     LAB_0BFA(PC)

    LEA     16(A7),A7
    MOVE.L  D0,D4
    TST.L   D4
    BPL.S   LAB_0D4C

    MOVEQ   #96,D0
    CMP.L   D0,D4
    BGT.S   LAB_0D4D

LAB_0D4C:
    MOVE.L  D4,LAB_22F3

LAB_0D4D:
    ADDQ.L  #2,D6

LAB_0D4E:
    CMP.L   D7,D6
    BLE.S   LAB_0D4F

    MOVE.L  D6,D0
    BRA.S   LAB_0D50

LAB_0D4F:
    MOVE.L  D7,D0

LAB_0D50:
    MOVE.L  D0,D7
    MOVEA.L A3,A0
    ADDA.L  D7,A0
    TST.B   (A0)
    BEQ.W   LAB_0D56

    MOVE.B  -19(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0D57(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-24(A5)
    TST.L   D0
    BEQ.S   LAB_0D55

    MOVEA.L D0,A0
    MOVE.B  (A0),D1
    CMP.B   -19(A5),D1
    BNE.S   LAB_0D55

    CLR.B   (A0)+
    MOVEA.L A3,A1
    ADDA.L  D7,A1
    MOVEA.L A1,A2

LAB_0D51:
    TST.B   (A2)+
    BNE.S   LAB_0D51

    SUBQ.L  #1,A2
    SUBA.L  A1,A2
    MOVE.L  A0,-24(A5)
    MOVE.L  A2,D0
    MOVEQ   #127,D1
    CMP.L   D1,D0
    BLE.S   LAB_0D52

    CLR.B   127(A3,D7.L)

LAB_0D52:
    MOVEA.L A3,A0
    ADDA.L  D7,A0
    MOVEA.L A0,A1

LAB_0D53:
    TST.B   (A1)+
    BNE.S   LAB_0D53

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    TST.L   D0
    BLE.S   LAB_0D54

    MOVEA.L A3,A0
    ADDA.L  D7,A0
    MOVE.L  LAB_22F2,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_22F2

LAB_0D54:
    TST.L   -24(A5)
    BEQ.S   LAB_0D56

    MOVEA.L -24(A5),A0
    TST.B   (A0)
    BEQ.S   LAB_0D56

    MOVE.L  LAB_22F1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_22F1
    BRA.S   LAB_0D56

LAB_0D55:
    TST.B   0(A3,D7.L)
    BEQ.S   LAB_0D56

    MOVEA.L A3,A0
    ADDA.L  D6,A0
    MOVE.L  LAB_22F2,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_22F2

LAB_0D56:
    BSR.W   GCOMMAND_LoadPPVTemplate

    MOVEM.L (A7)+,D2/D4-D7/A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_0D57:
    JMP     LAB_1979

LAB_0D58:
    JMP     LAB_00C3

;!======

; Return a pointer to the final path separator (':' or '/') in the buffer.
GCOMMAND_FindPathSeparator:
LAB_0D59:
    LINK.W  A5,#-8
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L A3,A0

.LAB_0D5A:
    TST.B   (A0)+
    BNE.S   .LAB_0D5A

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D7
    TST.L   D7
    BEQ.S   .LAB_0D5F

    MOVEA.L A3,A0
    ADDA.L  D7,A0
    SUBQ.L  #1,A0
    MOVE.L  A0,-4(A5)

.LAB_0D5B:
    MOVEA.L -4(A5),A0
    MOVE.B  (A0),D0
    MOVEQ   #':',D1
    CMP.B   D1,D0
    BEQ.S   .LAB_0D5C

    MOVEQ   #'/',D1
    CMP.B   D1,D0
    BNE.S   .LAB_0D5D

.LAB_0D5C:
    ADDQ.L  #1,-4(A5)
    BRA.S   .return

.LAB_0D5D:
    MOVEQ   #1,D0
    CMP.L   D0,D7
    BEQ.S   .LAB_0D5E

    SUBQ.L  #1,-4(A5)

.LAB_0D5E:
    SUBQ.L  #1,D7
    BNE.S   .LAB_0D5B

    BRA.S   .return

.LAB_0D5F:
    MOVEA.L A3,A0
    MOVE.L  A0,-4(A5)

.return:
    MOVE.L  -4(A5),D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======

LAB_0D61:
    MOVEM.L D2/D6-D7,-(A7)
    MOVEQ   #0,D7
    MOVEQ   #0,D6
    LEA     LAB_1F9E,A0
    MOVE.L  A0,D1
    MOVEQ   #-2,D2
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOLock(A6)

    MOVE.L  D0,D7
    TST.L   D7
    BEQ.S   LAB_0D62

    MOVE.L  D7,D1
    JSR     _LVOUnLock(A6)

    MOVEQ   #0,D7
    LEA     LAB_1F9F,A0
    MOVE.L  A0,D1
    JSR     _LVOLock(A6)

    MOVE.L  D0,D7
    TST.L   D7
    BEQ.S   LAB_0D62

    MOVE.L  D7,D1
    JSR     _LVOUnLock(A6)

    MOVEQ   #0,D7
    CLR.L   -(A7)
    PEA     LAB_1FA0
    JSR     LAB_0D64(PC)

    MOVE.L  D0,D6
    CLR.L   (A7)
    PEA     LAB_1FA1
    JSR     LAB_0D64(PC)

    MOVE.L  D0,D6

    JSR     LAB_0D63(PC)

    JSR     LAB_0D65(PC)

    LEA     12(A7),A7

LAB_0D62:
    MOVEM.L (A7)+,D2/D6-D7
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_0D63:
    JMP     LAB_071B

LAB_0D64:
    JMP     LAB_1ADF

LAB_0D65:
    JMP     LAB_071A

;!======

    ; Alignment
    MOVEQ   #97,D0

;!======

; Interpret a keyboard scan code and map it to a preset palette index.
GCOMMAND_MapKeycodeToPreset:
LAB_0D66:
    MOVEM.L D6-D7,-(A7)
    MOVE.B  15(A7),D7
    MOVEQ   #0,D6
    MOVE.L  D7,D0
    ANDI.B  #$30,D0
    MOVEQ   #48,D1
    CMP.B   D1,D0
    BNE.S   LAB_0D67

    MOVE.L  LAB_1BCA,D6
    BRA.S   LAB_0D69

LAB_0D67:
    MOVE.L  D7,D0
    ANDI.B  #$20,D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BNE.S   LAB_0D68

    BSR.W   GCOMMAND_GetBannerChar

    MOVE.W  GLOB_REF_WORD_HEX_CODE_8E,D1
    CMP.W   D0,D1
    BNE.S   LAB_0D69

    MOVE.L  LAB_1BCA,D6
    BRA.S   LAB_0D69

LAB_0D68:
    MOVE.L  D7,D0
    ANDI.B  #$40,D0
    MOVEQ   #64,D1
    CMP.B   D1,D0
    BNE.S   LAB_0D69

    MOVEQ   #-1,D6

LAB_0D69:
    LEA     LAB_1F48,A0
    ADDA.W  LAB_2309,A0
    MOVE.B  D6,(A0)
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

; Update all banner layout rows to reflect the current highlight flag.
GCOMMAND_ApplyHighlightFlag:
LAB_0D6A:
    LINK.W  A5,#-12
    MOVE.L  D7,-(A7)
    TST.W   GCOMMAND_HighlightFlag
    BEQ.S   LAB_0D6B

    MOVEQ   #2,D0
    BRA.S   LAB_0D6C

LAB_0D6B:
    MOVEQ   #0,D0

LAB_0D6C:
    MOVE.L  D0,D7
    MOVE.L  #LAB_1E25,-4(A5)
    MOVEQ   #-3,D0
    MOVEA.L -4(A5),A0
    AND.W   26(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,26(A0)
    MOVE.L  #LAB_1E54,-4(A5)
    MOVEQ   #-3,D0
    MOVEA.L -4(A5),A0
    AND.W   26(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,26(A0)
    MOVE.L  #LAB_1E2B,-8(A5)
    MOVEQ   #-3,D0
    MOVEA.L -8(A5),A0
    AND.W   30(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,30(A0)
    MOVEQ   #-3,D1
    AND.W   114(A0),D1
    OR.W    D7,D1
    MOVE.W  D1,114(A0)
    MOVEQ   #-3,D0
    AND.W   678(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,678(A0)
    MOVEQ   #-3,D1
    AND.W   726(A0),D1
    OR.W    D7,D1
    MOVE.W  D1,726(A0)
    MOVEQ   #-3,D0
    AND.W   3922(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,3922(A0)
    MOVE.L  #LAB_1E58,-8(A5)
    MOVEQ   #-3,D0
    MOVEA.L -8(A5),A0
    AND.W   30(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,30(A0)
    MOVEQ   #-3,D0
    AND.W   114(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,114(A0)
    MOVEQ   #-3,D0
    AND.W   678(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,678(A0)
    MOVEQ   #-3,D0
    AND.W   726(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,726(A0)
    MOVEQ   #-3,D0
    AND.W   3922(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,3922(A0)
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

GCOMMAND_EnableHighlight:
LAB_0D6D:
    MOVE.W  #1,GCOMMAND_HighlightFlag
    BSR.W   GCOMMAND_ApplyHighlightFlag

    RTS

;!======

GCOMMAND_DisableHighlight:
LAB_0D6E:
    CLR.W   GCOMMAND_HighlightFlag
    BSR.W   GCOMMAND_ApplyHighlightFlag

    RTS

;!======

    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEA.L 24(A7),A2
    MOVE.L  A3,-(A7)
    PEA     LAB_1FAA
    JSR     LAB_0F02(PC)

    PEA     LAB_1FAB
    JSR     LAB_0F02(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D7

LAB_0D6F:
    MOVEQ   #16,D0
    CMP.L   D0,D7
    BGE.S   LAB_0D72

    MOVE.L  D7,D0
    ADD.L   D0,D0
    MOVE.W  0(A2,D0.L),D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D7,-(A7)
    PEA     LAB_1FAC
    JSR     LAB_0F02(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D6

LAB_0D70:
    MOVE.L  D7,D0
    ADD.L   D0,D0
    MOVE.W  0(A2,D0.L),D1
    EXT.L   D1
    CMP.L   D1,D6
    BGE.S   LAB_0D71

    MOVE.L  D7,D0
    ASL.L   #7,D0
    MOVEA.L A2,A0
    ADDA.L  D0,A0
    MOVE.L  D6,D0
    ADD.L   D0,D0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.W  32(A0),D0
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    PEA     LAB_1FAD
    JSR     LAB_0F02(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D6
    BRA.S   LAB_0D70

LAB_0D71:
    ADDQ.L  #1,D7
    BRA.S   LAB_0D6F

LAB_0D72:
    PEA     LAB_1FAE
    JSR     LAB_0F02(PC)

    ADDQ.W  #4,A7
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======

; Update the preset table entry for row D7 with the supplied value D6.
GCOMMAND_SetPresetEntry:
LAB_0D73:
    MOVEM.L D6-D7,-(A7)
    MOVE.L  12(A7),D7
    MOVE.L  16(A7),D6
    TST.L   D7
    BLE.S   LAB_0D74

    MOVEQ   #16,D0
    CMP.L   D0,D7
    BGE.S   LAB_0D74

    TST.L   D6
    BMI.S   LAB_0D74

    CMPI.L  #$1000,D6
    BGE.S   LAB_0D74

    MOVE.L  D7,D0
    ASL.L   #7,D0
    LEA     LAB_22F5,A0
    ADDA.L  D0,A0
    MOVE.L  D6,D0
    MOVE.W  D0,(A0)

LAB_0D74:
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

; Decode a nibble-packed preset block into the preset table via GCOMMAND_SetPresetEntry.
GCOMMAND_ExpandPresetBlock:
LAB_0D75:
    MOVEM.L D2/D5-D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVEQ   #4,D7

LAB_0D76:
    MOVEQ   #8,D0
    CMP.L   D0,D7
    BGE.S   LAB_0D79

    MOVEQ   #0,D5
    MOVEQ   #0,D6

LAB_0D77:
    MOVEQ   #3,D0
    CMP.L   D0,D6
    BGE.S   LAB_0D78

    MOVE.L  D7,D1
    LSL.L   #2,D1
    SUB.L   D7,D1
    ADD.L   D6,D1
    MOVEQ   #2,D0
    SUB.L   D6,D0
    ASL.L   #2,D0
    MOVEQ   #0,D2
    MOVE.B  0(A3,D1.L),D2
    ASL.L   D0,D2
    MOVEQ   #15,D1
    ASL.L   D0,D1
    AND.L   D1,D2
    MOVEQ   #0,D0
    MOVE.W  D5,D0
    ADD.L   D2,D0
    MOVE.L  D0,D5
    ADDQ.L  #1,D6
    BRA.S   LAB_0D77

LAB_0D78:
    MOVEQ   #0,D0
    MOVE.W  D5,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D7,-(A7)
    BSR.W   GCOMMAND_SetPresetEntry

    ADDQ.W  #8,A7
    ADDQ.L  #1,D7
    BRA.S   LAB_0D76

LAB_0D79:
    MOVEM.L (A7)+,D2/D5-D7/A3
    RTS

;!======

LAB_0D7A:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEQ   #1,D5
    MOVEQ   #0,D7

LAB_0D7B:
    TST.L   D5
    BEQ.S   LAB_0D82

    MOVEQ   #16,D0
    CMP.L   D0,D7
    BGE.S   LAB_0D82

    MOVE.L  D7,D0
    ADD.L   D0,D0
    CMPI.W  #1,0(A3,D0.L)
    BLE.S   LAB_0D7C

    CMPI.W  #$40,0(A3,D0.L)
    BGT.S   LAB_0D7C

    MOVEQ   #1,D0
    BRA.S   LAB_0D7D

LAB_0D7C:
    MOVEQ   #0,D0

LAB_0D7D:
    MOVE.L  D0,D5
    MOVEQ   #0,D6

LAB_0D7E:
    TST.L   D5
    BEQ.S   LAB_0D81

    MOVE.L  D7,D0
    ADD.L   D0,D0
    MOVE.W  0(A3,D0.L),D1
    EXT.L   D1
    CMP.L   D1,D6
    BGE.S   LAB_0D81

    MOVE.L  D7,D0
    ASL.L   #7,D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    MOVE.L  D6,D1
    ADD.L   D1,D1
    ADDA.L  D1,A0
    CMPI.W  #0,32(A0)
    BCS.S   LAB_0D7F

    MOVEA.L A3,A0
    ADDA.L  D0,A0
    ADDA.L  D1,A0
    CMPI.W  #$1000,32(A0)
    BCC.S   LAB_0D7F

    MOVEQ   #1,D0
    BRA.S   LAB_0D80

LAB_0D7F:
    MOVEQ   #0,D0

LAB_0D80:
    MOVE.L  D0,D5
    ADDQ.L  #1,D6
    BRA.S   LAB_0D7E

LAB_0D81:
    ADDQ.L  #1,D7
    BRA.S   LAB_0D7B

LAB_0D82:
    TST.L   D5
    BEQ.S   LAB_0D83

    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    MOVEA.L A3,A0
    LEA     LAB_22F4,A1
    MOVE.L  #$820,D0
    JSR     _LVOCopyMem(A6)

    MOVE.W  #1,LAB_1FA3
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    PEA     6.W
    PEA     5.W
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0DA2

    LEA     16(A7),A7
    MOVEA.L AbsExecBase,A6
    JSR     _LVOEnable(A6)

LAB_0D83:
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======

LAB_0D84:
    LINK.W  A5,#-8
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 28(A7),A3
    MOVEQ   #0,D7

LAB_0D85:
    MOVEQ   #16,D0
    CMP.L   D0,D7
    BGE.S   LAB_0D88

    MOVE.L  D7,D0
    ADD.L   D0,D0
    MOVE.W  #16,0(A3,D0.L)
    MOVEQ   #0,D6

LAB_0D86:
    MOVE.L  D7,D0
    ADD.L   D0,D0
    MOVE.W  0(A3,D0.L),D1
    EXT.L   D1
    CMP.L   D1,D6
    BGE.S   LAB_0D87

    MOVE.L  D7,D0
    ASL.L   #7,D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    MOVE.L  D6,D0
    ADD.L   D0,D0
    ADDA.L  D0,A0
    MOVE.L  D0,16(A7)
    MOVE.L  D7,D0
    MOVEQ   #62,D1
    JSR     JMP_TBL_LAB_1A06_6(PC)

    LEA     LAB_1FA2,A1
    ADDA.L  D0,A1
    MOVE.L  16(A7),D0
    ADDA.L  D0,A1
    MOVE.W  (A1),32(A0)
    ADDQ.L  #1,D6
    BRA.S   LAB_0D86

LAB_0D87:
    ADDQ.L  #1,D7
    BRA.S   LAB_0D85

LAB_0D88:
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======

LAB_0D89:
    PEA     LAB_22F4
    BSR.S   LAB_0D84

    ADDQ.W  #4,A7
    RTS

;!======

LAB_0D8A:
    LINK.W  A5,#-12
    MOVEM.L D4-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVEQ   #0,D0
    MOVE.L  D0,-12(A5)
    TST.L   D7
    BMI.S   LAB_0D8D

    MOVEQ   #16,D1
    CMP.L   D1,D7
    BGE.S   LAB_0D8D

    MOVEQ   #4,D1
    CMP.L   D1,D6
    BLE.S   LAB_0D8D

    MOVE.L  D7,D1
    ADD.L   D1,D1
    LEA     LAB_22F4,A0
    ADDA.L  D1,A0
    MOVE.W  (A0),D1
    EXT.L   D1
    MOVE.L  D1,D5
    SUBQ.L  #1,D5
    MOVE.L  D6,D4
    SUBQ.L  #5,D4
    BLE.S   LAB_0D8B

    MOVE.L  D5,D0
    MOVE.L  #1000,D1
    JSR     JMP_TBL_LAB_1A06_6(PC)

    MOVE.L  D4,D1
    JSR     JMP_TBL_LAB_1A07_3(PC)

    BRA.S   LAB_0D8C

LAB_0D8B:
    MOVEQ   #0,D0

LAB_0D8C:
    MOVE.L  D0,-12(A5)

LAB_0D8D:
    MOVEM.L (A7)+,D4-D7
    UNLK    A5
    RTS

;!======

LAB_0D8E:
    LINK.W  A5,#-16
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  32(A3),D6
    TST.L   D6
    BMI.S   LAB_0D90

    MOVEQ   #0,D7
    LEA     36(A3),A0
    LEA     55(A3),A1
    MOVE.L  A0,-8(A5)
    MOVE.L  A1,-16(A5)

LAB_0D8F:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   LAB_0D90

    MOVEQ   #0,D0
    MOVEA.L -16(A5),A0
    MOVE.B  (A0),D0
    MOVE.L  D6,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0D8A

    ADDQ.W  #8,A7
    MOVEA.L -8(A5),A0
    MOVE.L  D0,(A0)
    ADDQ.L  #1,D7
    ADDQ.L  #4,-8(A5)
    ADDQ.L  #1,-16(A5)
    BRA.S   LAB_0D8F

LAB_0D90:
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======

LAB_0D91:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7
    MOVE.L  #LAB_22F6,-8(A5)

LAB_0D92:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   LAB_0D93

    MOVE.L  D7,D0
    ADDQ.L  #4,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D0,(A0)
    MOVEQ   #0,D0
    MOVE.L  D0,4(A0)
    MOVE.L  D0,8(A0)
    MOVE.L  D0,12(A0)
    MOVE.L  D0,16(A0)
    ADDQ.L  #1,D7
    MOVEQ   #24,D0
    ADD.L   D0,-8(A5)
    BRA.S   LAB_0D92

LAB_0D93:
    CLR.W   LAB_1FA3
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

LAB_0D94:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.L  24(A7),D7
    MOVE.L  28(A7),D6
    MOVE.L  32(A7),D5
    TST.L   D7
    BMI.S   LAB_0D96

    MOVEQ   #16,D0
    CMP.L   D0,D7
    BGE.S   LAB_0D96

    MOVE.L  D7,(A3)
    MOVEQ   #0,D0
    MOVE.L  D0,16(A3)
    MOVEQ   #4,D1
    CMP.L   D1,D6
    BLE.S   LAB_0D95

    MOVE.L  D5,12(A3)
    MOVE.L  D7,D1
    ADD.L   D1,D1
    LEA     LAB_22F4,A0
    ADDA.L  D1,A0
    MOVE.W  (A0),D1
    EXT.L   D1
    SUBQ.L  #1,D1
    MOVE.L  D1,4(A3)
    MOVEQ   #2,D1
    MOVE.L  D1,20(A3)
    MOVEQ   #1,D1
    MOVE.L  D1,8(A3)
    BRA.S   LAB_0D97

LAB_0D95:
    TST.L   D6
    BMI.S   LAB_0D97

    MOVE.L  D0,12(A3)
    MOVE.L  D0,4(A3)
    MOVE.L  D0,20(A3)
    MOVE.L  D0,8(A3)
    BRA.S   LAB_0D97

LAB_0D96:
    MOVEQ   #6,D0
    MOVE.L  D0,(A3)
    MOVEQ   #0,D1
    MOVE.L  D1,16(A3)
    MOVE.L  D1,12(A3)
    MOVE.L  D1,4(A3)
    MOVE.L  D1,20(A3)
    MOVE.L  D1,8(A3)
    PEA     1365.W
    MOVE.L  D0,-(A7)
    BSR.W   GCOMMAND_SetPresetEntry

    ADDQ.W  #8,A7

LAB_0D97:
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======

LAB_0D98:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7

LAB_0D99:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   LAB_0D9A

    MOVE.L  D7,D0
    MOVEQ   #24,D1
    JSR     JMP_TBL_LAB_1A06_6(PC)

    LEA     LAB_22F6,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  55(A3,D7.L),D0
    MOVE.L  D7,D1
    ASL.L   #2,D1
    MOVE.L  36(A3,D1.L),-(A7)
    MOVE.L  32(A3),-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_0D94

    LEA     16(A7),A7
    ADDQ.L  #1,D7
    BRA.S   LAB_0D99

LAB_0D9A:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

LAB_0D9B:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7
    MOVE.L  #LAB_22F6,-4(A5)

LAB_0D9C:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   LAB_0DA1

    MOVEA.L -4(A5),A0
    TST.L   20(A0)
    BEQ.S   LAB_0D9D

    SUBQ.L  #1,20(A0)
    BRA.S   LAB_0DA0

LAB_0D9D:
    MOVE.L  12(A0),D0
    TST.L   D0
    BLE.S   LAB_0DA0

    MOVE.L  8(A0),D1
    CMP.L   4(A0),D1
    BGE.S   LAB_0DA0

    ADD.L   D0,16(A0)

LAB_0D9E:
    MOVEA.L -4(A5),A0
    MOVE.L  16(A0),D0
    CMPI.L  #1000,D0
    BLT.S   LAB_0D9F

    ADDQ.L  #1,8(A0)
    SUBI.L  #1000,16(A0)
    BRA.S   LAB_0D9E

LAB_0D9F:
    MOVEA.L -4(A5),A0
    MOVE.L  4(A0),D0
    MOVE.L  8(A0),D1
    CMP.L   D0,D1
    BLE.S   LAB_0DA0

    CLR.L   12(A0)
    MOVE.L  4(A0),8(A0)

LAB_0DA0:
    ADDQ.L  #1,D7
    MOVEQ   #24,D0
    ADD.L   D0,-4(A5)
    BRA.S   LAB_0D9C

LAB_0DA1:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

; Cache banner geometry parameters used by the display routines.
GCOMMAND_UpdateBannerBounds:
LAB_0DA2:
    LINK.W  A5,#-4
    MOVEM.L D4-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVE.L  16(A5),D5
    MOVE.L  20(A5),D4
    MOVE.L  D7,LAB_22FF
    MOVE.L  D6,LAB_2300
    MOVE.L  D5,LAB_2301
    MOVE.L  D4,LAB_2302
    TST.W   LAB_2263
    BEQ.S   LAB_0DA3

    MOVEQ   #0,D0
    BRA.S   LAB_0DA4

LAB_0DA3:
    MOVEQ   #17,D0

LAB_0DA4:
    MOVE.L  D0,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  D0,-4(A5)
    BSR.W   LAB_0D8A

    MOVE.L  D0,LAB_2303
    MOVE.L  -4(A5),(A7)
    MOVE.L  D6,-(A7)
    BSR.W   LAB_0D8A

    MOVE.L  D0,LAB_2304
    MOVE.L  -4(A5),(A7)
    MOVE.L  D5,-(A7)
    BSR.W   LAB_0D8A

    MOVE.L  D0,LAB_2305
    MOVE.L  -4(A5),(A7)
    MOVE.L  D4,-(A7)
    BSR.W   LAB_0D8A

    MOVE.L  D0,LAB_2306
    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    MOVE.W  #1,LAB_1FA4
    JSR     _LVOEnable(A6)

    MOVEM.L -20(A5),D4-D7
    UNLK    A5
    RTS

;!======

LAB_0DA5:
    LINK.W  A5,#-24
    MOVEM.L D2/D6-D7/A2-A3,-(A7)
    MOVE.L  #LAB_1E2B,-4(A5)
    MOVE.L  #LAB_1E58,-8(A5)
    MOVEA.L -4(A5),A0
    ADDA.W  #$80,A0
    MOVEA.L -8(A5),A1
    ADDA.W  #$80,A1
    MOVE.L  A0,-12(A5)
    MOVE.L  A1,-16(A5)
    TST.W   LAB_2263
    BEQ.S   LAB_0DA6

    MOVEQ   #0,D0
    BRA.S   LAB_0DA7

LAB_0DA6:
    MOVEQ   #17,D0

LAB_0DA7:
    MOVE.L  D0,D6
    MOVE.L  LAB_2303,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  LAB_22FF,-(A7)
    PEA     LAB_22F6
    BSR.W   LAB_0D94

    MOVE.L  LAB_2304,(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  LAB_2300,-(A7)
    PEA     LAB_22F8
    BSR.W   LAB_0D94

    MOVE.L  LAB_2305,(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  LAB_2301,-(A7)
    PEA     LAB_22FA
    BSR.W   LAB_0D94

    MOVE.L  LAB_2306,(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  LAB_2302,-(A7)
    PEA     LAB_22FC
    BSR.W   LAB_0D94

    LEA     52(A7),A7
    MOVEQ   #0,D7

LAB_0DA8:
    MOVEQ   #17,D0
    CMP.L   D0,D7
    BGE.W   LAB_0DB1

    MOVE.L  D7,D0
    ASL.L   #5,D0
    MOVE.L  LAB_22F7,D1
    TST.L   D1
    BPL.S   LAB_0DA9

    MOVEQ   #0,D2
    MOVE.B  LAB_1DE0,D2
    BRA.S   LAB_0DAA

LAB_0DA9:
    MOVE.L  LAB_22F6,D2
    ASL.L   #7,D2
    LEA     LAB_22F5,A0
    MOVEA.L A0,A1
    ADDA.L  D2,A1
    ADD.L   D1,D1
    ADDA.L  D1,A1
    MOVEQ   #0,D1
    MOVE.W  (A1),D1
    MOVE.L  D1,D2

LAB_0DAA:
    MOVEA.L -12(A5),A0
    MOVE.W  D2,6(A0,D0.L)
    MOVEA.L -16(A5),A1
    MOVE.W  D2,6(A1,D0.L)
    MOVE.L  D7,D0
    ASL.L   #5,D0
    MOVE.L  LAB_22F9,D1
    TST.L   D1
    BPL.S   LAB_0DAB

    MOVEQ   #0,D2
    MOVE.B  LAB_1DE1,D2
    BRA.S   LAB_0DAC

LAB_0DAB:
    MOVE.L  LAB_22F8,D2
    ASL.L   #7,D2
    LEA     LAB_22F5,A2
    MOVEA.L A2,A3
    ADDA.L  D2,A3
    ADD.L   D1,D1
    ADDA.L  D1,A3
    MOVEQ   #0,D1
    MOVE.W  (A3),D1
    MOVE.L  D1,D2

LAB_0DAC:
    MOVE.W  D2,10(A0,D0.L)
    MOVE.W  D2,10(A1,D0.L)
    MOVE.L  D7,D0
    ASL.L   #5,D0
    MOVE.L  LAB_22FB,D1
    TST.L   D1
    BPL.S   LAB_0DAD

    MOVEQ   #0,D2
    MOVE.B  LAB_1DE2,D2
    BRA.S   LAB_0DAE

LAB_0DAD:
    MOVE.L  LAB_22FA,D2
    ASL.L   #7,D2
    LEA     LAB_22F5,A2
    MOVEA.L A2,A3
    ADDA.L  D2,A3
    ADD.L   D1,D1
    ADDA.L  D1,A3
    MOVEQ   #0,D1
    MOVE.W  (A3),D1
    MOVE.L  D1,D2

LAB_0DAE:
    MOVE.W  D2,14(A0,D0.L)
    MOVE.W  D2,14(A1,D0.L)
    MOVE.L  D7,D0
    ASL.L   #5,D0
    MOVE.L  LAB_22FD,D1
    TST.L   D1
    BPL.S   LAB_0DAF

    MOVEQ   #0,D2
    MOVE.B  LAB_1DE3,D2
    BRA.S   LAB_0DB0

LAB_0DAF:
    MOVE.L  LAB_22FC,D2
    ASL.L   #7,D2
    LEA     LAB_22F5,A0
    ADDA.L  D2,A0
    ADD.L   D1,D1
    ADDA.L  D1,A0
    MOVEQ   #0,D1
    MOVE.W  (A0),D1
    MOVE.L  D1,D2

LAB_0DB0:
    MOVEA.L -12(A5),A0
    MOVE.W  D2,18(A0,D0.L)
    MOVE.W  D2,18(A1,D0.L)
    BSR.W   LAB_0D9B

    ADDQ.L  #1,D7
    BRA.W   LAB_0DA8

LAB_0DB1:
    CLR.W   LAB_1FA4
    MOVEM.L (A7)+,D2/D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

; Return the current banner character stored at LAB_1E2B.
GCOMMAND_GetBannerChar:
LAB_0DB2:
    LINK.W  A5,#-4
    MOVE.L  #LAB_1E2B,-4(A5)
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  (A0),D0
    UNLK    A5
    RTS

;!======

LAB_0DB3:
    MOVEM.L D2-D3/D6-D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVE.L  LAB_230B,D0
    MOVE.L  LAB_230C,D1
    CMP.L   D0,D1
    BEQ.W   LAB_0DB5

    ASL.L   #5,D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     772(A0),A1
    MOVE.L  A1,D2
    CLR.W   D2
    SWAP    D2
    MOVE.L  D2,D7
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     772(A0),A1
    MOVE.L  A1,D0
    MOVE.L  #$ffff,D2
    AND.L   D2,D0
    MOVE.L  D0,D6
    ASL.L   #5,D1
    LEA     3916(A3),A0
    MOVE.L  A0,D0
    CLR.W   D0
    SWAP    D0
    MOVE.L  D1,D3
    ADDI.L  #$2fa,D3
    MOVE.W  D0,0(A3,D3.L)
    LEA     3916(A3),A0
    MOVE.L  A0,D0
    AND.L   D2,D0
    MOVE.L  D1,D3
    ADDI.L  #$2fe,D3
    MOVE.W  D0,0(A3,D3.L)
    MOVE.L  LAB_230B,D0
    MOVEQ   #97,D1
    CMP.L   D1,D0
    BNE.S   LAB_0DB4

    ASL.L   #5,D0
    LEA     3876(A3),A0
    MOVE.L  A0,D1
    CLR.W   D1
    SWAP    D1
    MOVE.L  D0,D3
    ADDI.L  #$2fa,D3
    MOVE.W  D1,0(A3,D3.L)
    LEA     3876(A3),A0
    MOVE.L  A0,D1
    ANDI.L  #$ffff,D1
    MOVE.L  D0,D2
    ADDI.L  #$2fe,D2
    MOVE.W  D1,0(A3,D2.L)
    BRA.S   LAB_0DB5

LAB_0DB4:
    ASL.L   #5,D0
    MOVE.L  D0,D1
    ADDI.L  #$2fa,D1
    MOVE.W  D7,0(A3,D1.L)
    MOVE.L  D0,D1
    ADDI.L  #$2fe,D1
    MOVE.W  D6,0(A3,D1.L)

LAB_0DB5:
    MOVEM.L (A7)+,D2-D3/D6-D7/A3
    RTS

;!======

LAB_0DB6:
    LINK.W  A5,#-12
    MOVEM.L D2/D4-D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  16(A5),D7
    MOVE.L  20(A5),D6
    MOVE.L  24(A5),D5
    MOVEA.L A2,A0
    MOVE.L  D7,D0
    ASL.L   #5,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    LEA     744(A1),A6
    MOVE.L  A6,D1
    CLR.W   D1
    SWAP    D1
    MOVE.W  D1,730(A0)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    LEA     744(A1),A6
    MOVE.L  A6,D0
    MOVE.L  #$ffff,D1
    AND.L   D1,D0
    MOVE.W  D0,734(A0)
    MOVE.L  8(A3),D0
    MOVE.L  D0,D2
    ADD.L   D5,D2
    CLR.W   D2
    SWAP    D2
    MOVE.W  D2,714(A0)
    MOVE.L  8(A3),D0
    ADD.L   D5,D0
    AND.L   D1,D0
    MOVE.W  D0,718(A0)
    MOVE.L  12(A3),D0
    MOVE.L  D0,D2
    ADD.L   D5,D2
    CLR.W   D2
    SWAP    D2
    MOVE.W  D2,694(A0)
    MOVE.L  12(A3),D0
    ADD.L   D5,D0
    AND.L   D1,D0
    MOVE.W  D0,698(A0)
    MOVE.L  16(A3),D0
    MOVE.L  D0,D2
    ADD.L   D5,D2
    CLR.W   D2
    SWAP    D2
    MOVE.W  D2,702(A0)
    MOVE.L  16(A3),D0
    ADD.L   D5,D0
    ANDI.L  #$ffff,D0
    MOVE.W  D0,706(A0)
    MOVEM.L A0,-4(A5)
    TST.L   D7
    BLE.S   LAB_0DB7

    MOVE.L  D7,D0
    BRA.S   LAB_0DB8

LAB_0DB7:
    MOVE.L  D6,D0

LAB_0DB8:
    MOVE.L  D0,D4
    SUBQ.L  #1,D4
    TST.W   LAB_1FA5
    BEQ.S   LAB_0DB9

    TST.L   D4
    BLE.W   LAB_0DBA

LAB_0DB9:
    MOVE.L  D4,D0
    ASL.L   #5,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    LEA     746(A1),A6
    MOVE.L  LAB_22F6,D0
    ASL.L   #7,D0
    LEA     LAB_22F5,A1
    MOVEA.L A1,A0
    ADDA.L  D0,A0
    MOVE.L  LAB_22F7,D0
    ADD.L   D0,D0
    ADDA.L  D0,A0
    MOVE.W  (A0),(A6)
    MOVE.L  A6,-12(A5)
    ADDQ.L  #4,A6
    MOVE.L  LAB_22F8,D0
    ASL.L   #7,D0
    MOVEA.L A1,A0
    ADDA.L  D0,A0
    MOVE.L  LAB_22F9,D0
    ADD.L   D0,D0
    ADDA.L  D0,A0
    MOVE.W  (A0),(A6)
    MOVE.L  A6,-12(A5)
    ADDQ.L  #4,A6
    MOVE.L  LAB_22FA,D0
    ASL.L   #7,D0
    MOVEA.L A1,A0
    ADDA.L  D0,A0
    MOVE.L  LAB_22FB,D0
    ADD.L   D0,D0
    ADDA.L  D0,A0
    MOVE.W  (A0),(A6)
    MOVE.L  A6,-12(A5)
    ADDQ.L  #4,A6
    MOVE.L  LAB_22FC,D0
    ASL.L   #7,D0
    ADDA.L  D0,A1
    MOVE.L  LAB_22FD,D0
    ADD.L   D0,D0
    ADDA.L  D0,A1
    MOVE.W  (A1),(A6)
    MOVE.L  A6,-12(A5)
    BRA.S   LAB_0DBB

LAB_0DBA:
    MOVE.L  D4,D0
    ASL.L   #5,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    LEA     746(A1),A6
    MOVE.W  #$f0,D0
    MOVE.W  D0,(A6)
    MOVE.L  A6,-12(A5)
    ADDQ.L  #4,A6
    MOVE.W  D0,(A6)
    MOVE.L  A6,-12(A5)
    ADDQ.L  #4,A6
    MOVE.W  D0,(A6)
    MOVE.L  A6,-12(A5)
    ADDQ.L  #4,A6
    MOVE.W  D0,(A6)
    MOVE.L  A6,-12(A5)

LAB_0DBB:
    MOVE.L  -4(A5),-(A7)
    BSR.W   LAB_0DB3

    MOVEM.L -44(A5),D2/D4-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

LAB_0DBC:
    MOVE.L  D7,-(A7)
    MOVE.W  #(-1),LAB_1F41
    MOVEQ   #0,D7

LAB_0DBD:
    MOVEQ   #98,D0
    CMP.L   D0,D7
    BGE.S   LAB_0DBE

    LEA     LAB_1F48,A0
    ADDA.L  D7,A0
    CLR.B   (A0)
    ADDQ.L  #1,D7
    BRA.S   LAB_0DBD

LAB_0DBE:
    MOVE.L  (A7)+,D7
    RTS

;!======

    ; Dead code.
    LINK.W  A5,#-16
    MOVEM.L D2-D3/D6-D7,-(A7)
    MOVE.L  #LAB_1E2B,-4(A5)
    MOVE.L  #LAB_1E58,-8(A5)
    MOVEQ   #0,D7

LAB_0DBF:
    MOVEQ   #16,D0
    CMP.L   D0,D7
    BGE.W   LAB_0DC0

    MOVE.L  D7,D6
    ADDQ.L  #1,D6
    MOVE.L  D7,D0
    ASL.L   #5,D0
    MOVE.L  D6,D1
    ASL.L   #5,D1
    MOVEA.L -4(A5),A0
    MOVE.L  D1,D2
    ADDI.L  #$86,D2
    MOVE.L  D0,D3
    ADDI.L  #$86,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$8a,D2
    MOVE.L  D0,D3
    ADDI.L  #$8a,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$8e,D2
    MOVE.L  D0,D3
    ADDI.L  #$8e,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVEA.L -8(A5),A0
    MOVE.L  D1,D2
    ADDI.L  #$86,D2
    MOVE.L  D0,D3
    ADDI.L  #$86,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$8a,D2
    MOVE.L  D0,D3
    ADDI.L  #$8a,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$8e,D2
    MOVE.L  D0,D3
    ADDI.L  #$8e,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    ADDQ.L  #1,D7
    BRA.W   LAB_0DBF

LAB_0DC0:
    MOVE.L  LAB_1FA8,D6
    MOVE.L  D7,D0
    ASL.L   #5,D0
    MOVE.L  D6,D1
    ASL.L   #5,D1
    MOVEA.L -4(A5),A0
    MOVE.L  D1,D2
    ADDI.L  #$2ea,D2
    MOVE.L  D0,D3
    ADDI.L  #$86,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$2ee,D2
    MOVE.L  D0,D3
    ADDI.L  #$8a,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$2f2,D2
    MOVE.L  D0,D3
    ADDI.L  #$8e,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVEA.L -8(A5),A0
    MOVE.L  D1,D2
    ADDI.L  #$2ea,D2
    MOVE.L  D0,D3
    ADDI.L  #$86,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$2ee,D2
    MOVE.L  D0,D3
    ADDI.L  #$8a,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$2f2,D2
    MOVE.L  D0,D3
    ADDI.L  #$8e,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVEM.L (A7)+,D2-D3/D6-D7
    UNLK    A5
    RTS

;!======

LAB_0DC1:
    MOVE.L  D2,-(A7)
    LEA     LAB_1F48,A0
    MOVE.W  LAB_230A,D0
    MOVEA.L A0,A1
    ADDA.W  D0,A1
    TST.B   (A1)
    BEQ.S   LAB_0DC4

    MOVEA.L A0,A1
    ADDA.W  D0,A1
    MOVEQ   #0,D1
    MOVE.B  (A1),D1
    MOVEQ   #0,D2
    NOT.B   D2
    CMP.L   D2,D1
    BNE.S   LAB_0DC2

    MOVE.W  LAB_1F56,D1
    SUBQ.W  #1,D1
    MOVE.W  D1,LAB_1F41
    MOVEQ   #1,D2
    MOVE.B  D2,LAB_1DEE
    BRA.S   LAB_0DC4

LAB_0DC2:
    MOVEA.L A0,A1
    ADDA.W  D0,A1
    MOVEQ   #0,D1
    MOVE.B  (A1),D1
    MOVEQ   #127,D2
    ADD.L   D2,D2
    CMP.L   D2,D1
    BNE.S   LAB_0DC3

    MOVE.W  #$101,LAB_1F45
    BRA.S   LAB_0DC4

LAB_0DC3:
    MOVEA.L A0,A1
    ADDA.W  D0,A1
    MOVEQ   #0,D1
    MOVE.B  (A1),D1
    MOVE.W  D1,LAB_1F45

LAB_0DC4:
    ADDA.W  D0,A0
    MOVEQ   #0,D0
    MOVE.B  D0,(A0)
    MOVE.W  LAB_1F41,D1
    BLT.S   LAB_0DC5

    MOVE.L  D1,D2
    SUBQ.W  #1,D2
    MOVE.W  D2,LAB_1F41
    MOVE.B  #$2,LAB_1FA9
    TST.W   D2
    BPL.S   LAB_0DC5

    MOVE.B  D0,LAB_1DEE
    MOVE.B  #$1,LAB_1E89

LAB_0DC5:
    MOVE.L  (A7)+,D2
    RTS

;!======

LAB_0DC6:
    MOVE.L  LAB_2307,-(A7)
    PEA     98.W
    MOVE.L  LAB_1FA8,-(A7)
    PEA     LAB_1E2B
    PEA     GLOB_REF_696_400_BITMAP
    BSR.W   LAB_0DB6

    MOVEQ   #88,D0
    ADD.L   LAB_2307,D0
    MOVE.L  D0,(A7)
    PEA     98.W
    MOVE.L  LAB_1FA8,-(A7)
    PEA     LAB_1E58
    PEA     GLOB_REF_696_400_BITMAP
    BSR.W   LAB_0DB6

    LEA     36(A7),A7
    MOVE.L  LAB_2308,D0
    MOVEA.L LAB_221C,A0
    ADDA.L  D0,A0
    MOVE.L  A0,LAB_1F2F
    MOVEA.L LAB_221D,A0
    ADDA.L  D0,A0
    MOVE.L  A0,LAB_1F31
    MOVEA.L LAB_221E,A0
    ADDA.L  D0,A0
    MOVE.L  A0,LAB_1F33
    RTS

;!======

LAB_0DC7:
    TST.L   LAB_1FA6
    BNE.S   LAB_0DC9

    MOVEA.L LAB_1DC5,A0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOGetMsg(A6)

    MOVE.L  D0,LAB_1FA6
    TST.L   D0
    BEQ.S   LAB_0DC9

    MOVEA.L D0,A0
    MOVE.L  32(A0),D1
    TST.L   D1
    BMI.S   LAB_0DC8

    MOVE.L  D0,-(A7)
    BSR.W   LAB_0D98

    ADDQ.W  #4,A7

LAB_0DC8:
    MOVEA.L LAB_1FA6,A0
    MOVE.L  20(A0),LAB_230D
    MOVE.L  24(A0),LAB_230E
    MOVE.L  28(A0),LAB_230F
    MOVE.B  54(A0),D0
    TST.B   D0
    BEQ.S   LAB_0DC9

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    BSR.W   GCOMMAND_MapKeycodeToPreset

    ADDQ.W  #4,A7
    MOVEA.L LAB_1FA6,A0
    CLR.B   54(A0)

LAB_0DC9:
    BSR.W   LAB_0DC6

    BSR.W   LAB_0DC1

    TST.L   LAB_1FA6
    BEQ.W   LAB_0DCD

    MOVEA.L LAB_1FA6,A0
    MOVE.W  52(A0),D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BHI.S   LAB_0DCA

    JSR     LAB_0C97(PC)

    BRA.S   LAB_0DCC

LAB_0DCA:
    TST.W   LAB_1FA3
    BEQ.S   LAB_0DCB

    BSR.W   LAB_0D91

LAB_0DCB:
    BSR.W   LAB_0D9B

    MOVEA.L LAB_1FA6,A1
    JSR     LAB_0C93(PC)

    MOVEA.L LAB_1FA6,A0
    MOVE.W  52(A0),D0
    MOVE.L  D0,D1
    SUBQ.W  #1,D1
    MOVEA.L LAB_1FA6,A0
    MOVE.W  D1,52(A0)

LAB_0DCC:
    MOVEA.L LAB_1FA6,A0
    MOVE.W  52(A0),D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BHI.S   LAB_0DCE

    MOVE.L  LAB_230D,20(A0)
    MOVEA.L LAB_1FA6,A0
    MOVE.L  LAB_230E,24(A0)
    MOVEA.L LAB_1FA6,A0
    MOVE.L  LAB_230F,28(A0)
    MOVEA.L LAB_1FA6,A0
    MOVE.W  D1,52(A0)
    CLR.L   32(A0)
    MOVEA.L LAB_1FA6,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOReplyMsg(A6)

    CLR.L   LAB_1FA6
    BRA.S   LAB_0DCE

LAB_0DCD:
    JSR     LAB_0C97(PC)

LAB_0DCE:
    RTS

;!======

LAB_0DCF:
    MOVEM.L D2/A4,-(A7)
    LEA     GLOB_REF_LONG_FILE_SCRATCH,A4
    TST.W   LAB_1FA4
    BEQ.S   LAB_0DD0

    BSR.W   LAB_0DA5

LAB_0DD0:
    ADDQ.L  #1,LAB_1FA8
    MOVE.L  LAB_2307,LAB_2308
    MOVEQ   #98,D0
    CMP.L   LAB_1FA8,D0
    BNE.S   LAB_0DD1

    MOVEQ   #0,D1
    MOVE.L  D1,LAB_1FA8
    MOVE.L  LAB_1FA7,D2
    MOVE.L  D2,LAB_2307
    MOVE.L  LAB_2312,D2
    MOVE.L  D2,LAB_2311
    BRA.S   LAB_0DD2

LAB_0DD1:
    MOVEQ   #88,D1
    ADD.L   D1,D1
    ADD.L   D1,LAB_2307
    MOVEQ   #32,D1
    ADD.L   D1,LAB_2311

LAB_0DD2:
    MOVE.W  LAB_230A,D1
    MOVE.W  D1,LAB_2309
    MOVE.L  D1,D2
    SUBQ.W  #1,D2
    MOVE.W  D2,LAB_230A
    BGE.S   LAB_0DD3

    MOVE.W  #$61,LAB_230A

LAB_0DD3:
    MOVE.L  LAB_230C,D1
    MOVE.L  D1,LAB_230B
    ADDQ.L  #1,LAB_230C
    CMP.L   LAB_230C,D0
    BNE.S   LAB_0DD4

    CLR.L   LAB_230C

LAB_0DD4:
    BSR.W   LAB_0DC7

    MOVEM.L (A7)+,D2/A4
    RTS

;!======

LAB_0DD5:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)

    TST.L   LAB_1FA6
    BEQ.S   .LAB_0DD6

    MOVEA.L LAB_1FA6,A0
    MOVE.L  LAB_230D,20(A0)
    MOVEA.L LAB_1FA6,A0
    MOVE.L  LAB_230E,24(A0)
    MOVEA.L LAB_1FA6,A0
    MOVE.L  LAB_230F,28(A0)

.LAB_0DD6:
    MOVEQ   #0,D7
    MOVE.L  #LAB_22A6,-4(A5)

.LAB_0DD7:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .LAB_0DD8

    MOVEA.L -4(A5),A0
    CLR.W   52(A0)
    CLR.B   54(A0)
    ADDQ.L  #1,D7
    MOVEQ   #80,D0
    ADD.L   D0,D0
    ADD.L   D0,-4(A5)
    BRA.S   .LAB_0DD7

.LAB_0DD8:
    MOVEQ   #98,D0
    MOVEQ   #0,D1
    LEA     LAB_1F48,A0

.LAB_0DD9:
    MOVE.B  D1,(A0)+
    DBF     D0,.LAB_0DD9

    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

LAB_0DDA:
    LINK.W  A5,#-12
    MOVEM.L D4-D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVEA.L 16(A5),A2
    MOVE.B  23(A5),D6
    MOVE.W  26(A5),D5
    MOVE.B  31(A5),D4
    MOVE.L  A3,-4(A5)
    TST.W   LAB_2263
    BEQ.S   LAB_0DDB

    MOVEQ   #0,D0
    BRA.S   LAB_0DDC

LAB_0DDB:
    MOVE.L  D7,D0

LAB_0DDC:
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    MOVE.L  D0,-12(A5)
    BSR.W   LAB_0D8A

    MOVE.L  D0,(A7)
    MOVE.L  -12(A5),-(A7)
    CLR.L   -(A7)
    PEA     LAB_22F6
    BSR.W   LAB_0D94

    MOVE.L  -12(A5),(A7)
    PEA     5.W
    BSR.W   LAB_0D8A

    MOVE.L  D0,(A7)
    MOVE.L  -12(A5),-(A7)
    PEA     5.W
    PEA     LAB_22F8
    BSR.W   LAB_0D94

    MOVE.L  -12(A5),(A7)
    PEA     6.W
    BSR.W   LAB_0D8A

    MOVE.L  D0,(A7)
    MOVE.L  -12(A5),-(A7)
    PEA     6.W
    PEA     LAB_22FA
    BSR.W   LAB_0D94

    MOVE.L  -12(A5),(A7)
    PEA     7.W
    BSR.W   LAB_0D8A

    MOVE.L  D0,(A7)
    MOVE.L  -12(A5),-(A7)
    PEA     7.W
    PEA     LAB_22FC
    BSR.W   LAB_0D94

    LEA     68(A7),A7
    CLR.L   -8(A5)

LAB_0DDD:
    MOVE.L  -8(A5),D0
    CMP.L   D7,D0
    BGE.W   LAB_0DE6

    MOVE.B  (A2),D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,(A0)
    ADD.B   D4,(A2)
    MOVE.B  D6,1(A0)
    MOVE.W  D5,2(A0)
    MOVE.W  #$188,4(A0)
    MOVE.L  LAB_22F7,D0
    TST.L   D0
    BPL.S   LAB_0DDE

    MOVEQ   #0,D1
    MOVE.B  LAB_1DE0,D1
    BRA.S   LAB_0DDF

LAB_0DDE:
    MOVE.L  LAB_22F6,D1
    ASL.L   #7,D1
    LEA     LAB_22F5,A1
    MOVEA.L A1,A6
    ADDA.L  D1,A6
    ADD.L   D0,D0
    ADDA.L  D0,A6
    MOVEQ   #0,D0
    MOVE.W  (A6),D0
    MOVE.L  D0,D1

LAB_0DDF:
    MOVE.W  D1,6(A0)
    MOVE.W  #$18a,8(A0)
    MOVE.L  LAB_22F9,D0
    TST.L   D0
    BPL.S   LAB_0DE0

    MOVEQ   #0,D1
    MOVE.B  LAB_1DE1,D1
    BRA.S   LAB_0DE1

LAB_0DE0:
    MOVE.L  LAB_22F8,D1
    ASL.L   #7,D1
    LEA     LAB_22F5,A1
    MOVEA.L A1,A6
    ADDA.L  D1,A6
    ADD.L   D0,D0
    ADDA.L  D0,A6
    MOVEQ   #0,D0
    MOVE.W  (A6),D0
    MOVE.L  D0,D1

LAB_0DE1:
    MOVE.W  D1,10(A0)
    MOVE.W  #$18c,12(A0)
    MOVE.L  LAB_22FB,D0
    TST.L   D0
    BPL.S   LAB_0DE2

    MOVEQ   #0,D1
    MOVE.B  LAB_1DE2,D1
    BRA.S   LAB_0DE3

LAB_0DE2:
    MOVE.L  LAB_22FA,D1
    ASL.L   #7,D1
    LEA     LAB_22F5,A1
    MOVEA.L A1,A6
    ADDA.L  D1,A6
    ADD.L   D0,D0
    ADDA.L  D0,A6
    MOVEQ   #0,D0
    MOVE.W  (A6),D0
    MOVE.L  D0,D1

LAB_0DE3:
    MOVE.W  D1,14(A0)
    MOVE.W  #$18e,16(A0)
    MOVE.L  LAB_22FD,D0
    TST.L   D0
    BPL.S   LAB_0DE4

    MOVEQ   #0,D1
    MOVE.B  LAB_1DE3,D1
    BRA.S   LAB_0DE5

LAB_0DE4:
    MOVE.L  LAB_22FC,D1
    ASL.L   #7,D1
    LEA     LAB_22F5,A1
    ADDA.L  D1,A1
    ADD.L   D0,D0
    ADDA.L  D0,A1
    MOVEQ   #0,D0
    MOVE.W  (A1),D0
    MOVE.L  D0,D1

LAB_0DE5:
    MOVE.W  D1,18(A0)
    MOVE.W  #$84,20(A0)
    LEA     32(A0),A1
    MOVE.L  A1,D0
    CLR.W   D0
    SWAP    D0
    MOVE.W  D0,22(A0)
    MOVE.W  #$86,24(A0)
    MOVE.L  A1,D0
    ANDI.L  #$ffff,D0
    MOVE.W  D0,26(A0)
    MOVE.W  #$8a,28(A0)
    CLR.W   30(A0)
    BSR.W   LAB_0D9B

    ADDQ.L  #1,-8(A5)
    MOVEQ   #32,D0
    ADD.L   D0,-4(A5)
    BRA.W   LAB_0DDD

LAB_0DE6:
    MOVE.L  -4(A5),D0
    MOVEM.L (A7)+,D4-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

COPY_IMAGE_DATA_TO_BITMAP:
    LINK.W  A5,#-4
    MOVEM.L D2-D7/A2-A3/A6,-(A7)

    UseLinkStackLong    MOVEA.L,1,A3
    UseLinkStackLong    MOVEA.L,2,A2
    UseLinkStackLong    MOVE.L,3,D7
    UseLinkStackLong    MOVE.L,4,D6
    MOVE.W  30(A5),D5
    MOVE.B  35(A5),D4

    MOVE.L  A2,-4(A5)
    MOVEA.L -4(A5),A0
    MOVE.B  #$8e,(A0)
    MOVE.B  #$d9,1(A0)
    MOVE.W  #$fffe,2(A0)
    MOVE.W  #$92,4(A0)
    MOVE.W  #$30,6(A0)
    MOVE.W  #$94,8(A0)
    MOVE.W  #$d8,10(A0)
    MOVE.W  #$8e,12(A0)
    MOVE.W  #$1769,14(A0)
    MOVE.W  #$90,16(A0)
    MOVE.W  #$ffc5,18(A0)
    MOVE.W  #$108,20(A0)
    MOVEQ   #88,D0
    MOVE.W  D0,22(A0)
    MOVE.W  #$10a,24(A0)
    MOVE.W  D0,26(A0)
    MOVE.W  #$100,D0
    MOVE.W  D0,28(A0)
    MOVE.W  #$9306,30(A0)
    MOVE.W  #$102,32(A0)
    MOVEQ   #0,D1
    MOVE.W  D1,34(A0)
    MOVE.W  #$182,D2
    MOVE.W  D2,36(A0)
    MOVEQ   #3,D3
    MOVE.W  D3,38(A0)
    MOVE.W  #$e0,D1
    MOVE.W  D1,40(A0)
    MOVE.L  LAB_2229,D0
    MOVE.L  D0,D1
    CLR.W   D1
    SWAP    D1
    MOVE.W  D1,42(A0)
    MOVE.W  #$e2,D0
    MOVE.W  D0,44(A0)
    MOVE.L  LAB_2229,D1
    MOVE.L  #$ffff,D0
    AND.L   D0,D1
    MOVE.W  D1,46(A0)
    MOVE.W  #$180,48(A0)
    MOVE.W  D3,50(A0)
    MOVE.W  D2,52(A0)
    MOVE.W  D3,54(A0)
    MOVE.W  #$184,56(A0)
    MOVE.W  #$111,58(A0)
    MOVE.W  #$186,60(A0)
    MOVE.W  #$cc0,62(A0)
    MOVE.W  #$188,64(A0)
    MOVE.W  #$512,66(A0)
    MOVE.W  #$18a,68(A0)
    MOVE.W  #$16a,70(A0)
    MOVE.W  #$18c,72(A0)
    MOVE.W  #$555,74(A0)
    MOVE.W  #$18e,76(A0)
    MOVE.W  D3,78(A0)
    MOVEA.L 24(A5),A1
    MOVE.B  (A1),D1
    MOVE.B  D1,80(A0)
    ADD.B   D4,(A1)
    MOVE.B  #$db,81(A0)
    MOVE.W  D5,82(A0)
    MOVE.W  #$e0,84(A0)
    MOVE.L  8(A3),D1
    MOVE.L  D1,D3
    ADD.L   D7,D3
    CLR.W   D3
    SWAP    D3
    MOVE.W  D3,86(A0)
    MOVE.W  #$e2,88(A0)
    MOVE.L  8(A3),D1
    ADD.L   D7,D1
    AND.L   D0,D1
    MOVE.W  D1,90(A0)
    MOVE.W  #$e4,92(A0)
    MOVE.L  12(A3),D1
    MOVE.L  D1,D3
    ADD.L   D7,D3
    CLR.W   D3
    SWAP    D3
    MOVE.W  D3,94(A0)
    MOVE.W  #$e6,96(A0)
    MOVE.L  12(A3),D1
    ADD.L   D7,D1
    AND.L   D0,D1
    MOVE.W  D1,98(A0)
    MOVE.W  #$e8,100(A0)
    MOVE.L  16(A3),D1
    MOVE.L  D1,D3
    ADD.L   D7,D3
    CLR.W   D3
    SWAP    D3
    MOVE.W  D3,102(A0)
    MOVE.W  #$ea,104(A0)
    MOVE.L  16(A3),D1
    ADD.L   D7,D1
    AND.L   D0,D1
    MOVE.W  D1,106(A0)
    MOVE.W  D2,108(A0)
    MOVE.W  #$aaa,110(A0)
    MOVE.W  #$100,112(A0)
    MOVE.W  #$b306,114(A0)
    MOVE.W  #$84,116(A0)
    LEA     132(A0),A6
    MOVE.L  A6,D1
    CLR.W   D1
    SWAP    D1
    MOVE.W  D1,118(A0)
    MOVE.W  #$86,120(A0)
    LEA     132(A0),A6
    MOVE.L  A6,D0
    ANDI.L  #$ffff,D0
    MOVE.W  D0,122(A0)
    MOVE.W  #$8a,124(A0)
    CLR.W   126(A0)
    LEA     128(A0),A6
    MOVEQ   #0,D0
    MOVE.W  D5,D0
    MOVEQ   #0,D1
    MOVE.B  D4,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     221.W
    MOVE.L  A1,-(A7)
    PEA     17.W
    MOVE.L  A6,-(A7)
    BSR.W   LAB_0DDA

    LEA     24(A7),A7
    MOVEA.L 24(A5),A0
    MOVE.B  (A0),D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,672(A0)
    MOVEA.L 24(A5),A1
    ADD.B   D4,(A1)
    MOVE.B  #$d9,673(A0)
    MOVE.W  D5,674(A0)
    MOVE.W  #$100,D0
    MOVE.W  D0,676(A0)
    MOVE.W  #$9306,678(A0)
    MOVE.W  #$182,D1
    MOVE.W  D1,680(A0)
    MOVE.W  #3,682(A0)
    MOVE.W  #$e0,D2
    MOVE.W  D2,684(A0)
    MOVE.L  LAB_2229,D3
    MOVE.L  D3,D0
    CLR.W   D0
    SWAP    D0
    MOVE.W  D0,686(A0)
    MOVE.W  #$e2,D0
    MOVE.W  D0,688(A0)
    MOVE.L  LAB_2229,D3
    MOVE.L  #$ffff,D1
    AND.L   D1,D3
    MOVE.W  D3,690(A0)
    MOVE.W  #$e4,692(A0)
    MOVE.L  12(A3),D3
    MOVE.L  D3,D0
    ADD.L   D6,D0
    CLR.W   D0
    SWAP    D0
    MOVE.W  D0,694(A0)
    MOVE.W  #$e6,696(A0)
    MOVE.L  12(A3),D0
    ADD.L   D6,D0
    AND.L   D1,D0
    MOVE.W  D0,698(A0)
    MOVE.W  #$e8,700(A0)
    MOVE.L  16(A3),D0
    MOVE.L  D0,D3
    ADD.L   D6,D3
    CLR.W   D3
    SWAP    D3
    MOVE.W  D3,702(A0)
    MOVE.W  #$ea,704(A0)
    MOVE.L  16(A3),D0
    ADD.L   D6,D0
    AND.L   D1,D0
    MOVE.W  D0,706(A0)
    MOVE.B  (A1),D0
    MOVE.B  D0,708(A0)
    ADD.B   D4,(A1)
    MOVE.B  #$db,709(A0)
    MOVE.W  D5,710(A0)
    MOVE.W  D2,712(A0)
    MOVE.L  8(A3),D0
    MOVE.L  D0,D2
    ADD.L   D6,D2
    CLR.W   D2
    SWAP    D2
    MOVE.W  D2,714(A0)
    MOVE.W  #$e2,716(A0)
    MOVE.L  8(A3),D0
    ADD.L   D6,D0
    AND.L   D1,D0
    MOVE.W  D0,718(A0)
    MOVE.W  #$182,720(A0)
    MOVE.W  #$aaa,722(A0)
    MOVE.W  #$100,724(A0)
    MOVE.W  #$b306,726(A0)
    MOVE.W  #$84,728(A0)
    LEA     744(A0),A1
    MOVE.L  A1,D0
    CLR.W   D0
    SWAP    D0
    MOVE.W  D0,730(A0)
    MOVE.W  #$86,732(A0)
    LEA     744(A0),A1
    MOVE.L  A1,D0
    ANDI.L  #$ffff,D0
    MOVE.W  D0,734(A0)
    MOVE.W  #$8a,736(A0)
    CLR.W   738(A0)
    LEA     740(A0),A1
    MOVEQ   #0,D0
    MOVE.W  D5,D0
    MOVEQ   #0,D1
    MOVE.B  D4,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     221.W
    MOVE.L  24(A5),-(A7)
    PEA     98.W
    MOVE.L  A1,-(A7)
    BSR.W   LAB_0DDA

    MOVE.L  D6,(A7)
    PEA     98.W
    CLR.L   -(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0DB6

    LEA     40(A7),A7
    MOVEA.L -4(A5),A0
    MOVE.B  #$80,3916(A0)
    MOVEQ   #-39,D0
    MOVE.B  D0,3917(A0)
    MOVE.W  #$80fe,3918(A0)
    MOVE.W  #$100,3920(A0)
    MOVE.W  #$9306,3922(A0)
    MOVE.W  #$182,3924(A0)
    MOVE.W  #3,3926(A0)
    MOVE.W  #$e0,D1
    MOVE.W  D1,3928(A0)
    MOVE.L  LAB_2229,D2
    MOVE.L  D2,D3
    CLR.W   D3
    SWAP    D3
    MOVE.W  D3,3930(A0)
    MOVE.W  #$e2,D2
    MOVE.W  D2,3932(A0)
    MOVE.L  LAB_2229,D3
    MOVE.L  #$ffff,D2
    AND.L   D2,D3
    MOVE.W  D3,3934(A0)
    MOVEQ   #-1,D3
    MOVE.B  D3,3936(A0)
    MOVE.B  D3,3937(A0)
    MOVE.W  #$fffe,3938(A0)
    MOVEA.L 24(A5),A1
    MOVE.B  (A1),D3
    MOVE.B  D3,3876(A0)
    ADD.B   D4,(A1)
    MOVE.B  D0,3877(A0)
    MOVE.W  D5,3878(A0)
    MOVE.W  D1,3880(A0)
    MOVE.L  8(A3),D0
    MOVE.L  D0,D1
    ADD.L   D6,D1
    CLR.W   D1
    SWAP    D1
    MOVE.W  D1,3882(A0)
    MOVE.W  #$e2,3884(A0)
    MOVE.L  8(A3),D0
    ADD.L   D6,D0
    AND.L   D2,D0
    MOVE.W  D0,3886(A0)
    MOVE.W  #$e4,3888(A0)
    MOVE.L  12(A3),D0
    MOVE.L  D0,D1
    ADD.L   D6,D1
    CLR.W   D1
    SWAP    D1
    MOVE.W  D1,3890(A0)
    MOVE.W  #$e6,3892(A0)
    MOVE.L  12(A3),D0
    ADD.L   D6,D0
    AND.L   D2,D0
    MOVE.W  D0,3894(A0)
    MOVE.W  #$e8,3896(A0)
    MOVE.L  16(A3),D0
    MOVE.L  D0,D1
    ADD.L   D6,D1
    CLR.W   D1
    SWAP    D1
    MOVE.W  D1,3898(A0)
    MOVE.W  #$ea,3900(A0)
    MOVE.L  16(A3),D0
    ADD.L   D6,D0
    AND.L   D2,D0
    MOVE.W  D0,3902(A0)
    MOVE.W  #$84,3904(A0)
    LEA     744(A0),A1
    MOVE.L  A1,D0
    CLR.W   D0
    SWAP    D0
    MOVE.W  D0,3906(A0)
    MOVE.W  #$86,3908(A0)
    LEA     744(A0),A1
    MOVE.L  A1,D0
    ANDI.L  #$ffff,D0
    MOVE.W  D0,3910(A0)
    MOVE.W  #$8a,3912(A0)
    CLR.W   3914(A0)

    MOVEM.L (A7)+,D2-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

LAB_0DE8:
    LINK.W  A5,#-4
    MOVEM.L D2/D5-D7,-(A7)
    MOVE.B  11(A5),D7
    MOVE.W  14(A5),D6
    MOVE.B  19(A5),D5
    MOVE.B  D7,-1(A5)
    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    BSR.W   LAB_0D91

    MOVEQ   #0,D0
    MOVE.L  D0,LAB_1FA8
    MOVE.L  D0,LAB_2308
    MOVE.L  LAB_1FA7,D0
    MOVE.L  D0,LAB_2307
    MOVE.L  LAB_2312,LAB_2311
    MOVEQ   #97,D0
    MOVE.W  D0,LAB_2309
    SUBQ.W  #1,D0
    MOVE.W  D0,LAB_230A
    MOVEQ   #84,D0
    MOVE.L  D0,LAB_230B
    MOVEQ   #85,D0
    MOVE.L  D0,LAB_230C
    MOVEQ   #0,D0
    MOVE.W  D6,D0
    MOVEQ   #0,D1
    MOVE.B  D5,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -1(A5)
    MOVE.L  LAB_2307,-(A7)
    PEA     2992.W
    PEA     LAB_1E2B
    PEA     GLOB_REF_696_400_BITMAP
    BSR.W   COPY_IMAGE_DATA_TO_BITMAP

    MOVE.B  D7,-1(A5)
    MOVEQ   #88,D0
    ADD.L   LAB_2307,D0
    MOVEQ   #0,D1
    MOVE.W  D6,D1
    MOVEQ   #0,D2
    MOVE.B  D5,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    PEA     -1(A5)
    MOVE.L  D0,-(A7)
    PEA     3080.W
    PEA     LAB_1E58
    PEA     GLOB_REF_696_400_BITMAP
    BSR.W   COPY_IMAGE_DATA_TO_BITMAP

    BSR.W   LAB_0DBC

    MOVE.W  #1,LAB_1D31
    MOVE.W  #$100,LAB_1F45
    MOVEA.L AbsExecBase,A6
    JSR     _LVOEnable(A6)

    MOVEM.L -20(A5),D2/D5-D7
    UNLK    A5
    RTS

;!======

LAB_0DE9:
    TST.W   LAB_1FAF
    BEQ.S   LAB_0DEA

    CLR.W   LAB_1FAF
    CLR.L   -(A7)
    MOVE.L  #$80fe,-(A7)
    PEA     128.W
    BSR.W   LAB_0DE8

    LEA     12(A7),A7
    MOVEQ   #64,D0
    ADD.L   D0,D0
    MOVE.L  D0,LAB_2310
    ADDI.L  #$264,D0
    MOVE.L  D0,LAB_2312

LAB_0DEA:
    RTS

;!======

LAB_0DEB:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.B  19(A7),D7
    ADD.B   D7,(A3)
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

LAB_0DEC:
    MOVE.L  D7,-(A7)
    MOVE.B  11(A7),D7
    TST.B   D7
    BEQ.S   LAB_0DF0

    MOVE.L  LAB_230C,D0
    MOVE.L  D0,LAB_230B
    MOVE.L  D7,D1
    EXT.W   D1
    EXT.L   D1
    SUB.L   D1,LAB_230C

LAB_0DED:
    MOVE.L  LAB_230C,D0
    MOVEQ   #98,D1
    CMP.L   D1,D0
    BLT.S   LAB_0DEE

    MOVEQ   #98,D1
    SUB.L   D1,LAB_230C
    BRA.S   LAB_0DED

LAB_0DEE:
    MOVE.L  LAB_230C,D0
    TST.L   D0
    BPL.S   LAB_0DEF

    MOVEQ   #98,D1
    ADD.L   D1,LAB_230C
    BRA.S   LAB_0DEE

LAB_0DEF:
    PEA     LAB_1E2B
    BSR.W   LAB_0DB3

    PEA     LAB_1E58
    BSR.W   LAB_0DB3

    ADDQ.W  #8,A7

LAB_0DF0:
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_0DF1:
    LINK.W  A5,#-4
    MOVE.L  D7,-(A7)
    MOVE.B  11(A5),D7
    LEA     LAB_1E2B,A0
    MOVE.L  A0,-4(A5)
    TST.B   D7
    BEQ.S   LAB_0DF2

    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.L  D7,D1
    EXT.W   D1
    EXT.L   D1
    ADD.L   D1,D0
    MOVEQ   #65,D1
    ADD.L   D1,D1
    CMP.L   D1,D0
    BLT.S   LAB_0DF2

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   LAB_0DEB

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     LAB_1E58
    BSR.W   LAB_0DEB

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    BSR.W   LAB_0DEC

    LEA     12(A7),A7

LAB_0DF2:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

; Reset banner buffers to the default values embedded in the binary.
GCOMMAND_SeedBannerDefaults:
LAB_0DF3:
    LINK.W  A5,#-4
    MOVEM.L D2-D3,-(A7)
    PEA     1.W
    MOVE.L  #$fffe,-(A7)
    PEA     32.W
    BSR.W   LAB_0DE8

    MOVE.L  #LAB_1E2B,-4(A5)
    MOVEQ   #31,D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,(A0)
    MOVEQ   #-39,D1
    MOVE.B  D1,1(A0)
    MOVEQ   #-2,D2
    MOVE.W  D2,2(A0)
    MOVEQ   #-8,D3
    MOVE.B  D3,3916(A0)
    MOVE.B  D1,3917(A0)
    MOVE.W  D2,3918(A0)
    MOVE.L  #LAB_1E58,-4(A5)
    MOVEA.L -4(A5),A0
    MOVE.B  D0,(A0)
    MOVE.B  D1,1(A0)
    MOVE.W  D2,2(A0)
    MOVE.B  D3,3916(A0)
    MOVE.B  D1,3917(A0)
    MOVE.W  D2,3918(A0)
    MOVEM.L -12(A5),D2-D3
    UNLK    A5
    RTS

;!======

; Seed banner buffers using values read from preferences.
GCOMMAND_SeedBannerFromPrefs:
LAB_0DF4:
    LINK.W  A5,#-4
    MOVE.L  D2,-(A7)
    CLR.L   -(A7)
    MOVE.L  #$80fe,-(A7)
    PEA     128.W
    BSR.W   LAB_0DE8

    MOVE.L  #LAB_1E2B,-4(A5)
    MOVE.W  GLOB_REF_WORD_HEX_CODE_8E,D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,(A0)
    MOVEQ   #-39,D0
    MOVE.B  D0,1(A0)
    MOVEQ   #-2,D1
    MOVE.W  D1,2(A0)
    MOVE.L  #LAB_1E58,-4(A5)
    MOVE.W  GLOB_REF_WORD_HEX_CODE_8E,D2
    MOVEA.L -4(A5),A0
    MOVE.B  D2,(A0)
    MOVE.B  D0,1(A0)
    MOVE.W  D1,2(A0)
    MOVE.L  -8(A5),D2
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

; Persist the brush list returned from BRUSH_PopulateBrushList into the active slot.
GCOMMAND_SaveBrushResult:
LAB_0DF5:
    LINK.W  A5,#-4
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A5),A3
    CLR.L   -4(A5)
    MOVEQ   #0,D0
    MOVE.B  190(A3),D0
    MOVE.W  D0,LAB_1B84
    PEA     -4(A5)
    MOVE.L  A3,-(A7)
    JSR     LAB_0DFA(PC)

    ADDQ.W  #8,A7
    MOVE.W  LAB_1B84,D0
    SUBQ.W  #4,D0
    BNE.S   .LAB_0DF6

    TST.L   -4(A5)
    BEQ.S   .LAB_0DF6

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    MOVE.L  -4(A5),-(A7)
    MOVE.L  LAB_1ED3,-(A7)
    JSR     LAB_0DF9(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_1ED3
    ADDQ.L  #1,LAB_1B28
    MOVEA.L AbsExecBase,A6
    JSR     _LVOPermit(A6)

    BRA.S   .LAB_0DF8

.LAB_0DF6:
    MOVE.W  LAB_1B84,D0
    SUBQ.W  #5,D0
    BNE.S   .LAB_0DF7

    TST.L   -4(A5)
    BEQ.S   .LAB_0DF7

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    MOVE.L  -4(A5),-(A7)
    MOVE.L  LAB_1ED2,-(A7)
    JSR     LAB_0DF9(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_1ED2
    ADDQ.L  #1,LAB_1B27
    MOVEA.L AbsExecBase,A6
    JSR     _LVOPermit(A6)

    BRA.S   .LAB_0DF8

.LAB_0DF7:
    MOVE.W  LAB_1B84,D0
    SUBQ.W  #6,D0
    BNE.S   .LAB_0DF8

    TST.L   -4(A5)
    BEQ.S   .LAB_0DF8

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    MOVE.L  -4(A5),LAB_1B25
    JSR     _LVOPermit(A6)

.LAB_0DF8:
    MOVEA.L (A7)+,A3
    UNLK    A5
    RTS

;!======

LAB_0DF9:
    JMP     BRUSH_AppendBrushNode

LAB_0DFA:
    JMP     BRUSH_PopulateBrushList

;!======

LAB_0DFB:
    LINK.W  A5,#-4
    MOVEM.L D7/A3-A4,-(A7)
    LEA     GLOB_REF_LONG_FILE_SCRATCH,A4
    MOVEA.L 8(A5),A3
    MOVEQ   #1,D0
    CMP.B   4(A3),D0
    BNE.S   .LAB_0DFC

    MOVE.L  LAB_231B,D0
    LSL.L   #2,D0
    ADD.L   LAB_231B,D0
    LEA     LAB_231D,A0
    ADDA.L  D0,A0
    CLR.L   -(A7)
    PEA     5.W
    MOVE.L  A0,-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_0E04(PC)

    LEA     16(A7),A7
    MOVE.L  D0,D7
    TST.L   D7
    BLE.S   .LAB_0DFE

    MOVEQ   #-1,D0
    CMP.L   D0,D7
    BEQ.S   .LAB_0DFE

    ADDQ.L  #1,LAB_231B
    CMPI.L  #$14,LAB_231B
    BLT.S   .LAB_0DFE

    CLR.L   LAB_231B
    BRA.S   .LAB_0DFE

.LAB_0DFC:
    MOVE.B  4(A3),D0
    MOVEQ   #16,D1
    CMP.B   D1,D0
    BNE.S   .LAB_0DFD

    MOVEQ   #1,D1
    MOVE.W  D1,LAB_1FB0
    BRA.S   .LAB_0DFE

.LAB_0DFD:
    MOVEQ   #15,D1
    CMP.B   D1,D0
    BNE.S   .LAB_0DFE

    MOVE.W  #1,LAB_1FB0

.LAB_0DFE:
    MOVEQ   #0,D0
    MOVEM.L (A7)+,D7/A3-A4
    UNLK    A5
    RTS
