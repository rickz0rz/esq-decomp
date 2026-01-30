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

;------------------------------------------------------------------------------
; FUNC: GCOMMAND_LoadDefaultTable   (Load the built-in gcommand table template into the working buffer (LAB_21BC).)
; ARGS:
;   ??
; RET:
;   D0: ?? (non-zero on success?)
; CLOBBERS:
;   ??
; CALLS:
;   ??
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Load the built-in gcommand table template into the working buffer (LAB_21BC).
; NOTES:
;   ??
;------------------------------------------------------------------------------
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
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_LoadCommandFile   (Load a command definition from disk (LAB_1F68) and copy it into the workspace.)
; ARGS:
;   ??
; RET:
;   D0: ??
; CLOBBERS:
;   ??
; CALLS:
;   ??
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Load a command definition from disk (LAB_1F68) and copy it into the workspace.
; NOTES:
;   ??
;------------------------------------------------------------------------------

; Load a command definition from disk (LAB_1F68) and copy it into the workspace.
GCOMMAND_LoadCommandFile:
    LINK.W  A5,#-40
    MOVE.L  D7,-(A7)
    PEA     MODE_NEWFILE.W
    PEA     LAB_1F68
    JSR     JMP_TBL_DISKIO_OpenFileWithBuffer_1(PC)

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
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_ParseCommandOptions   (ParseCommandOptions??)
; ARGS:
;   ??
; RET:
;   D0: ??
; CLOBBERS:
;   ??
; CALLS:
;   ??
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Parses a command/options string into global gcommand state.
; NOTES:
;   ??
;------------------------------------------------------------------------------
GCOMMAND_ParseCommandOptions:
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
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_LoadMplexTemplate   (Load the Digital_Mplex template and stage it in LAB_22E2/LAB_22E3.)
; ARGS:
;   ??
; RET:
;   D0: ??
; CLOBBERS:
;   ??
; CALLS:
;   ??
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Load the Digital_Mplex template and stage it in LAB_22E2/LAB_22E3.
; NOTES:
;   ??
;------------------------------------------------------------------------------

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
    JSR     GCOMMAND_JMP_TBL_LAB_1979(PC)

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
    JSR     GCOMMAND_JMP_TBL_LAB_00C3(PC)

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
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_LoadMplexFile   (Load Digital_Mplex.dat from disk and merge it into the workspace buffers.)
; ARGS:
;   ??
; RET:
;   D0: ??
; CLOBBERS:
;   ??
; CALLS:
;   ??
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Load Digital_Mplex.dat from disk and merge it into the workspace buffers.
; NOTES:
;   ??
;------------------------------------------------------------------------------

; Load Digital_Mplex.dat from disk and merge it into the workspace buffers.
GCOMMAND_LoadMplexFile:
LAB_0CEC:
    LINK.W  A5,#-64
    MOVE.L  D7,-(A7)
    PEA     MODE_NEWFILE.W
    PEA     LAB_1F6D
    JSR     JMP_TBL_DISKIO_OpenFileWithBuffer_1(PC)

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
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_ParseCommandString   (Parse a command line into token flags, returning indices for gcommand execution.)
; ARGS:
;   ??
; RET:
;   D0: ??
; CLOBBERS:
;   ??
; CALLS:
;   ??
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Parse a command line into token flags, returning indices for gcommand execution.
; NOTES:
;   ??
;------------------------------------------------------------------------------

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
    JSR     GCOMMAND_JMP_TBL_LAB_1979(PC)

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
    JSR     GCOMMAND_JMP_TBL_LAB_00C3(PC)

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
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_LoadPPV3Template   (Load the Digital_PPV3 template into the working buffer tables.)
; ARGS:
;   ??
; RET:
;   D0: ??
; CLOBBERS:
;   ??
; CALLS:
;   ??
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Load the Digital_PPV3 template into the working buffer tables.
; NOTES:
;   ??
;------------------------------------------------------------------------------

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
    JSR     GCOMMAND_JMP_TBL_LAB_1979(PC)

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
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_LoadPPVTemplate   (Load the PPV table template into the workspace buffers.)
; ARGS:
;   ??
; RET:
;   D0: ??
; CLOBBERS:
;   ??
; CALLS:
;   ??
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Load the PPV table template into the workspace buffers.
; NOTES:
;   ??
;------------------------------------------------------------------------------

; Load the PPV table template into the workspace buffers.
GCOMMAND_LoadPPVTemplate:
LAB_0D23:
    LINK.W  A5,#-68
    MOVE.L  D7,-(A7)
    PEA     MODE_NEWFILE.W
    PEA     LAB_1F75
    JSR     JMP_TBL_DISKIO_OpenFileWithBuffer_1(PC)

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
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_ParsePPVCommand   (Parse a PPV command string into tokens/indices for execution.)
; ARGS:
;   ??
; RET:
;   D0: ??
; CLOBBERS:
;   ??
; CALLS:
;   ??
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Parse a PPV command string into tokens/indices for execution.
; NOTES:
;   ??
;------------------------------------------------------------------------------

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
    JSR     GCOMMAND_JMP_TBL_LAB_1979(PC)

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
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_JMP_TBL_LAB_1979   (JumpStub_LAB_1979)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   (none)
; CALLS:
;   LAB_1979
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LAB_1979.
;------------------------------------------------------------------------------
GCOMMAND_JMP_TBL_LAB_1979:
LAB_0D57:
    JMP     LAB_1979

;------------------------------------------------------------------------------
; FUNC: GCOMMAND_JMP_TBL_LAB_00C3   (JumpStub_LAB_00C3)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   (none)
; CALLS:
;   ESQ_FindSubstringCaseFold
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to ESQ_FindSubstringCaseFold.
;------------------------------------------------------------------------------
GCOMMAND_JMP_TBL_LAB_00C3:
LAB_0D58:
    JMP     ESQ_FindSubstringCaseFold
