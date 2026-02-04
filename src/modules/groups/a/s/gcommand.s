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
GCOMMAND_LoadDefaultTable:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    PEA     LAB_1F66
    JSR     LAB_0F9B(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BEQ.S   .return

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
    JSR     GROUPC_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     20(A7),A7

.return:
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
GCOMMAND_LoadCommandFile:
    LINK.W  A5,#-40
    MOVE.L  D7,-(A7)
    PEA     MODE_NEWFILE.W
    PEA     LAB_1F68
    JSR     GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    TST.L   D7
    BEQ.S   .return

    LEA     LAB_22CC,A0
    LEA     -40(A5),A1
    MOVEQ   #7,D0

    ; Copy command file IO template onto stack request block.
.copy_template_loop:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.copy_template_loop
    MOVE.L  -12(A5),-8(A5)
    CLR.L   -12(A5)
    PEA     32.W
    PEA     -40(A5)
    MOVE.L  D7,-(A7)
    JSR     LAB_0F97(PC)

    MOVEA.L -8(A5),A0
    MOVE.L  A0,-12(A5)

    ; Find NUL terminator to size the command string.
.scan_string_end:
    TST.B   (A0)+
    BNE.S   .scan_string_end

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

.return:
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
    BEQ.W   .return

    TST.B   (A3)
    BEQ.W   .return

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
    BGE.S   .opt2_start

    ; Opt0: casefolded Y/N flag -> LAB_22CC.
    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #1,(A1)
    BEQ.S   .opt1_use_raw

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .opt1_casefold_done

.opt1_use_raw:
    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0

.opt1_casefold_done:
    MOVE.L  D0,D5
    MOVEQ   #89,D0
    CMP.B   D0,D5
    BEQ.S   .opt1_store_yn

    MOVEQ   #78,D0
    CMP.B   D0,D5
    BNE.S   .opt1_done

.opt1_store_yn:
    MOVE.L  D5,D0
    MOVE.B  D0,LAB_22CC

.opt1_done:
    ADDQ.L  #1,D6

.opt2_start:
    ; Opt1: digit 1..3 -> LAB_22CD.
    CMP.L   D7,D6
    BGE.S   .opt3_start

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    SUB.L   D1,D4
    MOVEQ   #1,D0
    CMP.L   D0,D4
    BLT.S   .opt2_done

    MOVEQ   #3,D1
    CMP.L   D1,D4
    BGT.S   .opt2_done

    MOVE.L  D4,LAB_22CD

.opt2_done:
    ADDQ.L  #1,D6

.opt3_start:
    ; Opt2: numeric char via LAB_0E2D if valid (table bit #7) -> LAB_22CE.
    CMP.L   D7,D6
    BGE.S   .opt4_start

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   .opt3_done

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0E2D(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,LAB_22CE

.opt3_done:
    ADDQ.L  #1,D6

.opt4_start:
    ; Opt3: digit 1..3 -> LAB_22CF.
    CMP.L   D7,D6
    BGE.S   .opt5_start

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    SUB.L   D1,D4
    MOVEQ   #1,D0
    CMP.L   D0,D4
    BLT.S   .opt4_done

    MOVEQ   #3,D1
    CMP.L   D1,D4
    BGT.S   .opt4_done

    MOVE.L  D4,LAB_22CF

.opt4_done:
    ADDQ.L  #1,D6

.opt5_start:
    ; Opt4: numeric char via LAB_0E2D if valid (table bit #7) -> LAB_22D0.
    CMP.L   D7,D6
    BGE.S   .opt6_start

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   .opt5_done

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0E2D(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,LAB_22D0

.opt5_done:
    ADDQ.L  #1,D6

.opt6_start:
    ; Opt5: casefolded mode flag (F/B/L/N) -> LAB_22D3.
    CMP.L   D7,D6
    BGE.S   .opt7_start

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   .opt6_use_raw

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .opt6_casefold_done

.opt6_use_raw:
    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0

.opt6_casefold_done:
    MOVE.L  D0,D5
    MOVEQ   #70,D0
    CMP.B   D0,D5
    BEQ.S   .opt6_store_mode

    MOVEQ   #66,D0
    CMP.B   D0,D5
    BEQ.S   .opt6_store_mode

    MOVEQ   #76,D0
    CMP.B   D0,D5
    BEQ.S   .opt6_store_mode

    MOVEQ   #78,D0
    CMP.B   D0,D5
    BNE.S   .opt6_done

.opt6_store_mode:
    MOVE.L  D5,D0
    MOVE.B  D0,LAB_22D3

.opt6_done:
    ADDQ.L  #1,D6

.opt7_start:
    ; Opt6: digit 0..9 with special-case '1' toggle -> LAB_22D1/LAB_22D2.
    CMP.L   D7,D6
    BGE.S   .tail_len_choose

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    SUB.L   D1,D4
    MOVEQ   #1,D0
    CMP.L   D0,D4
    BNE.S   .opt7_not_one

    MOVEQ   #0,D1
    MOVE.L  D1,LAB_22D1
    MOVE.L  D0,LAB_22D2
    BRA.S   .opt7_done

.opt7_not_one:
    TST.L   D4
    BMI.S   .opt7_done

    MOVEQ   #9,D1
    CMP.L   D1,D4
    BGT.S   .opt7_done

    MOVE.L  D4,LAB_22D1
    CLR.L   LAB_22D2

.opt7_done:
    ADDQ.L  #1,D6

.tail_len_choose:
    ; Tail: append remaining substring to LAB_22D4.
    CMP.L   D7,D6
    BLE.S   .tail_use_d7

    MOVE.L  D6,D0
    BRA.S   .tail_len_ready

.tail_use_d7:
    MOVE.L  D7,D0

.tail_len_ready:
    MOVE.L  D0,D7
    MOVEA.L A3,A0
    ADDA.L  D7,A0
    TST.B   (A0)
    BEQ.S   .return

    MOVE.L  LAB_22D4,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_22D4

.return:
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
GCOMMAND_LoadMplexTemplate:
    LINK.W  A5,#-16
    MOVE.L  D7,-(A7)
    PEA     LAB_1F6A
    JSR     LAB_0F9B(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BEQ.W   .return

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
    JSR     GROUP_AS_JMPTBL_UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)
    TST.L   D0
    BEQ.S   .template_merge

    MOVEA.L D0,A0
    TST.B   (A0)
    BEQ.S   .template_merge

    CLR.B   (A0)+
    MOVE.L  A0,-12(A5)

.template_merge:
    ; Merge template strings into workspace buffers.
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
    JSR     GROUPC_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     24(A7),A7
    CLR.L   -16(A5)
    TST.L   LAB_22E3
    BEQ.S   .check_suffix_slot

    MOVEA.L LAB_22E3,A0
    TST.B   (A0)
    BEQ.S   .check_suffix_slot

    PEA     LAB_1F6C
    MOVE.L  A0,-(A7)
    JSR     GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-16(A5)

.check_suffix_slot:
    ; If the marker substring exists, force the following byte to 's'.
    TST.L   -16(A5)
    BEQ.S   .return

    MOVEA.L -16(A5),A0
    TST.B   (A0)
    BEQ.S   .return

    MOVE.B  #$73,1(A0)

.return:
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
GCOMMAND_LoadMplexFile:
    LINK.W  A5,#-64
    MOVE.L  D7,-(A7)
    PEA     MODE_NEWFILE.W
    PEA     LAB_1F6D
    JSR     GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    TST.L   D7
    BEQ.W   .return

    LEA     LAB_22D5,A0
    LEA     -64(A5),A1
    MOVEQ   #12,D0

    ; Copy file buffer template onto stack request block.
.copy_template_loop:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.copy_template_loop
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

    ; Find first NUL terminator to size the first string.
.scan_first_nul:
    TST.B   (A0)+
    BNE.S   .scan_first_nul

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

    ; Find second NUL terminator to size the second string.
.scan_second_nul:
    TST.B   (A0)+
    BNE.S   .scan_second_nul

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

.return:
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
GCOMMAND_ParseCommandString:
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
    BEQ.W   .return

    TST.B   (A3)
    BEQ.W   .return

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
    BGE.S   .opt2_start

    ; Opt0: casefolded Y/N flag -> LAB_22D5.
    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   .opt1_use_raw

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .opt1_casefold_done

.opt1_use_raw:
    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0

.opt1_casefold_done:
    MOVE.L  D0,D5
    MOVEQ   #89,D0
    CMP.B   D0,D5
    BEQ.S   .opt1_store_yn

    MOVEQ   #78,D0
    CMP.B   D0,D5
    BNE.S   .opt1_done

.opt1_store_yn:
    MOVE.L  D5,D0
    MOVE.B  D0,LAB_22D5

.opt1_done:
    ADDQ.L  #1,D6

.opt2_start:
    ; Opt1: digit 0..9 -> LAB_22D6.
    CMP.L   D7,D6
    BGE.S   .opt3_start

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    SUB.L   D1,D4
    BLT.S   .opt2_done

    MOVEQ   #9,D0
    CMP.L   D0,D4
    BGT.S   .opt2_done

    MOVE.L  D4,LAB_22D6

.opt2_done:
    ADDQ.L  #1,D6

.opt3_start:
    ; Opt2: two-digit numeric (0..99) with digit validation -> LAB_22D7.
    CMP.L   D7,D6
    BGE.S   .opt4_start

    MOVE.B  0(A3,D6.L),-12(A5)
    MOVE.B  1(A3,D6.L),-11(A5)
    CLR.B   -10(A5)
    PEA     -12(A5)
    JSR     LAB_0BFA(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D4
    TST.L   D4
    BMI.S   .opt3_done

    MOVEQ   #99,D0
    CMP.L   D0,D4
    BGT.S   .opt3_done

    MOVE.B  -12(A5),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   .opt3_done

    MOVE.B  -11(A5),D0
    EXT.W   D0
    EXT.L   D0
    ADDA.L  D0,A0
    BTST    #2,(A0)
    BEQ.S   .opt3_done

    MOVE.L  D4,LAB_22D7

.opt3_done:
    ADDQ.L  #2,D6

.opt4_start:
    ; Opt3: two-digit numeric (0..29) with digit validation -> LAB_22D8.
    CMP.L   D7,D6
    BGE.S   .opt5_start

    MOVE.B  0(A3,D6.L),-12(A5)
    MOVE.B  1(A3,D6.L),-11(A5)
    CLR.B   -10(A5)
    PEA     -12(A5)
    JSR     LAB_0BFA(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D4
    TST.L   D4
    BMI.S   .opt4_done

    MOVEQ   #29,D0
    CMP.L   D0,D4
    BGT.S   .opt4_done

    MOVE.B  -12(A5),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   .opt4_done

    MOVE.B  -11(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   .opt4_done

    MOVE.L  D4,LAB_22D8

.opt4_done:
    ADDQ.L  #2,D6

.opt5_start:
    ; Opt4: digit 1..3 -> LAB_22D9.
    CMP.L   D7,D6
    BGE.S   .opt6_start

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    SUB.L   D1,D4
    MOVEQ   #1,D0
    CMP.L   D0,D4
    BLT.S   .opt5_done

    MOVEQ   #3,D1
    CMP.L   D1,D4
    BGT.S   .opt5_done

    MOVE.L  D4,LAB_22D9

.opt5_done:
    ADDQ.L  #1,D6

.opt6_start:
    ; Opt5: numeric char via LAB_0E2D if valid (table bit #7) -> LAB_22DA.
    CMP.L   D7,D6
    BGE.S   .opt7_start

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   .opt6_done

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0E2D(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,LAB_22DA

.opt6_done:
    ADDQ.L  #1,D6

.opt7_start:
    ; Opt6: digit 1..3 -> LAB_22DB.
    CMP.L   D7,D6
    BGE.S   .opt8_start

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    SUB.L   D1,D4
    MOVEQ   #1,D0
    CMP.L   D0,D4
    BLT.S   .opt7_done

    MOVEQ   #3,D1
    CMP.L   D1,D4
    BGT.S   .opt7_done

    MOVE.L  D4,LAB_22DB

.opt7_done:
    ADDQ.L  #1,D6

.opt8_start:
    ; Opt7: numeric char via LAB_0E2D if valid (table bit #7) -> LAB_22DC.
    CMP.L   D7,D6
    BGE.S   .opt9_start

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   .opt8_done

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0E2D(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,LAB_22DC

.opt8_done:
    ADDQ.L  #1,D6

.opt9_start:
    ; Opt8: digit 1..3 -> LAB_22DD.
    CMP.L   D7,D6
    BGE.S   .opt10_start

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    SUB.L   D1,D4
    MOVEQ   #1,D0
    CMP.L   D0,D4
    BLT.S   .opt9_done

    MOVEQ   #3,D2
    CMP.L   D2,D4
    BGT.S   .opt9_done

    MOVE.L  D4,LAB_22DD

.opt9_done:
    ADDQ.L  #1,D6

.opt10_start:
    ; Opt9: digit 1..3 -> LAB_22DE.
    CMP.L   D7,D6
    BGE.S   .opt11_start

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    SUB.L   D1,D4
    MOVEQ   #1,D0
    CMP.L   D0,D4
    BLT.S   .opt10_done

    MOVEQ   #3,D1
    CMP.L   D1,D4
    BGT.S   .opt10_done

    MOVE.L  D4,LAB_22DE

.opt10_done:
    ADDQ.L  #1,D6

.opt11_start:
    ; Opt10: numeric char via LAB_0E2D if valid (table bit #7) -> LAB_22DF.
    CMP.L   D7,D6
    BGE.S   .opt12_start

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   .opt11_done

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0E2D(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,LAB_22DF

.opt11_done:
    ADDQ.L  #1,D6

.opt12_start:
    ; Opt11: casefolded mode flag (F/B/L/N) -> LAB_22E0.
    CMP.L   D7,D6
    BGE.S   .opt13_start

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #1,(A1)
    BEQ.S   .opt12_use_raw

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .opt12_casefold_done

.opt12_use_raw:
    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0

.opt12_casefold_done:
    MOVE.L  D0,D5
    MOVEQ   #70,D0
    CMP.B   D0,D5
    BEQ.S   .opt12_store_mode

    MOVEQ   #66,D0
    CMP.B   D0,D5
    BEQ.S   .opt12_store_mode

    MOVEQ   #76,D0
    CMP.B   D0,D5
    BEQ.S   .opt12_store_mode

    MOVEQ   #78,D0
    CMP.B   D0,D5
    BNE.S   .opt12_done

.opt12_store_mode:
    MOVE.L  D5,D0
    MOVE.B  D0,LAB_22E0

.opt12_done:
    ADDQ.L  #1,D6

.opt13_start:
    ; Opt12: casefolded Y/N flag -> LAB_22E1.
    CMP.L   D7,D6
    BGE.S   .tail_len_choose

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   .opt13_use_raw

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .opt13_casefold_done

.opt13_use_raw:
    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0

.opt13_casefold_done:
    MOVE.L  D0,D5
    MOVEQ   #89,D0
    CMP.B   D0,D5
    BEQ.S   .opt13_store_yn

    MOVEQ   #78,D0
    CMP.B   D0,D5
    BNE.S   .opt13_done

.opt13_store_yn:
    MOVE.L  D5,D0
    MOVE.B  D0,LAB_22E1

.opt13_done:
    ADDQ.L  #1,D6

.tail_len_choose:
    ; Tail: append remaining substring to LAB_22E3/LAB_22E2.
    CMP.L   D7,D6
    BLE.S   .tail_use_d7

    MOVE.L  D6,D0
    BRA.S   .tail_len_ready

.tail_use_d7:
    MOVE.L  D7,D0

.tail_len_ready:
    MOVE.L  D0,D7
    MOVEA.L A3,A0
    ADDA.L  D7,A0
    TST.B   (A0)
    BEQ.W   .after_tail_append

    MOVE.B  -19(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     GROUP_AS_JMPTBL_UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-24(A5)
    TST.L   D0
    BEQ.S   .append_e3_only

    MOVEA.L D0,A0
    TST.B   (A0)
    BEQ.S   .append_e3_only

    CLR.B   (A0)+
    MOVEA.L A3,A1
    ADDA.L  D7,A1
    MOVEA.L A1,A2

    ; Scan tail length and clamp to 127 bytes.
.scan_tail_len:
    TST.B   (A2)+
    BNE.S   .scan_tail_len

    SUBQ.L  #1,A2
    SUBA.L  A1,A2
    MOVE.L  A0,-24(A5)
    MOVE.L  A2,D0
    MOVEQ   #127,D1
    CMP.L   D1,D0
    BLE.S   .truncate_tail_127

    CLR.B   127(A3,D7.L)

.truncate_tail_127:
    ; Append the clamped tail to LAB_22E3.
    MOVEA.L A3,A0
    ADDA.L  D7,A0
    TST.B   (A0)
    BEQ.S   .append_tail_to_e3

    MOVE.L  LAB_22E3,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_22E3

.append_tail_to_e3:
    ; If the split buffer is non-empty, append to LAB_22E2.
    TST.L   -24(A5)
    BEQ.S   .after_tail_append

    MOVEA.L -24(A5),A0
    TST.B   (A0)
    BEQ.S   .after_tail_append

    MOVE.L  LAB_22E2,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_22E2
    BRA.S   .after_tail_append

.append_e3_only:
    ; If split buffer allocation failed, only append tail to LAB_22E3.
    MOVEA.L A3,A0
    ADDA.L  D7,A0
    TST.B   (A0)
    BEQ.S   .after_tail_append

    MOVE.L  LAB_22E3,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_22E3

.after_tail_append:
    CLR.L   -28(A5)
    TST.L   LAB_22E3
    BEQ.S   .check_suffix_slot

    MOVEA.L LAB_22E3,A0
    TST.B   (A0)
    BEQ.S   .check_suffix_slot

    PEA     LAB_1F70
    MOVE.L  A0,-(A7)
    JSR     GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-28(A5)

.check_suffix_slot:
    TST.L   -28(A5)
    BEQ.S   .return

    MOVEA.L -28(A5),A0
    TST.B   (A0)
    BEQ.S   .return

    MOVE.L  A0,D0
    SUB.L   LAB_22E3,D0
    MOVE.L  D0,D4
    ADDQ.L  #1,D4
    MOVEA.L LAB_22E3,A0
    ADDA.L  D4,A0
    MOVE.B  #$73,(A0)

.return:
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
GCOMMAND_LoadPPV3Template:
    LINK.W  A5,#-20
    MOVEM.L D5-D7,-(A7)
    MOVEQ   #0,D6
    MOVEQ   #0,D5
    PEA     LAB_1F71
    JSR     LAB_0F9B(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BEQ.S   .try_fallback_template

    ; Found primary template (Digital_PPV3).
    MOVEQ   #56,D6
    BRA.S   .template_ready

.try_fallback_template:
    ; Fall back to alternate template (Digital_PPV).
    PEA     LAB_1F72
    JSR     LAB_0F9B(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BEQ.S   .template_ready

    MOVEQ   #52,D6
    LEA     LAB_1F73,A0
    MOVE.L  A0,D1
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVODeleteFile(A6)

    MOVEQ   #1,D5

.template_ready:
    TST.L   D6
    BEQ.W   .return

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
    JSR     GROUP_AS_JMPTBL_UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.S   .buffer_ready

    MOVEA.L D0,A0
    TST.B   (A0)
    BEQ.S   .buffer_ready

    ; Split buffer: clear leading byte to terminate the first string.
    CLR.B   (A0)+
    MOVE.L  A0,-8(A5)

.buffer_ready:
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
    JSR     GROUPC_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     24(A7),A7
    TST.L   D5
    BEQ.S   .return

    BSR.W   GCOMMAND_LoadPPVTemplate

.return:
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
GCOMMAND_LoadPPVTemplate:
    LINK.W  A5,#-68
    MOVE.L  D7,-(A7)
    PEA     MODE_NEWFILE.W
    PEA     LAB_1F75
    JSR     GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    TST.L   D7
    BEQ.W   .return

    LEA     LAB_22E4,A0
    LEA     -68(A5),A1
    MOVEQ   #13,D0

    ; Copy file buffer template onto stack request block.
.copy_template_loop:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.copy_template_loop
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

    ; Find first NUL terminator to size the first string.
.scan_first_nul:
    TST.B   (A0)+
    BNE.S   .scan_first_nul

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

    ; Find second NUL terminator to size the second string.
.scan_second_nul:
    TST.B   (A0)+
    BNE.S   .scan_second_nul

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

.return:
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
GCOMMAND_ParsePPVCommand:
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
    BEQ.W   .return

    TST.B   (A3)
    BEQ.W   .return

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
    BGE.S   .opt2_start

    ; Opt0: casefolded Y/N flag -> LAB_22E4.
    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   .opt1_use_raw

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .opt1_casefold_done

.opt1_use_raw:
    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0

.opt1_casefold_done:
    MOVE.L  D0,D5
    MOVEQ   #89,D0
    CMP.B   D0,D5
    BEQ.S   .opt1_store_yn

    MOVEQ   #78,D0
    CMP.B   D0,D5
    BNE.S   .opt1_done

.opt1_store_yn:
    MOVE.L  D5,D0
    MOVE.B  D0,LAB_22E4

.opt1_done:
    ADDQ.L  #1,D6

.opt2_start:
    ; Opt1: digit 0..9 -> LAB_22E5.
    CMP.L   D7,D6
    BGE.S   .opt3_start

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    SUB.L   D1,D4
    BLT.S   .opt2_done

    MOVEQ   #9,D0
    CMP.L   D0,D4
    BGT.S   .opt2_done

    MOVE.L  D4,LAB_22E5

.opt2_done:
    ADDQ.L  #1,D6

.opt3_start:
    ; Opt2: three-digit numeric (0..999) with digit validation -> LAB_22E6.
    CMP.L   D7,D6
    BGE.S   .opt4_start

    MOVE.B  0(A3,D6.L),-12(A5)
    MOVE.B  1(A3,D6.L),-11(A5)
    MOVE.B  2(A3,D6.L),-10(A5)
    CLR.B   -9(A5)
    PEA     -12(A5)
    JSR     LAB_0BFA(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D4
    TST.L   D4
    BMI.S   .opt3_done

    CMPI.L  #$3e7,D4
    BGT.S   .opt3_done

    MOVE.B  -12(A5),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   .opt3_done

    MOVE.B  -11(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   .opt3_done

    MOVE.B  -10(A5),D0
    EXT.W   D0
    EXT.L   D0
    ADDA.L  D0,A0
    BTST    #2,(A0)
    BEQ.S   .opt3_done

    MOVE.L  D4,LAB_22E6

.opt3_done:
    ADDQ.L  #3,D6

.opt4_start:
    ; Opt3: three-digit numeric (0..999) with digit validation -> LAB_22E7.
    CMP.L   D7,D6
    BGE.S   .opt5_start

    MOVE.B  0(A3,D6.L),-12(A5)
    MOVE.B  1(A3,D6.L),-11(A5)
    MOVE.B  2(A3,D6.L),-10(A5)
    CLR.B   -9(A5)
    PEA     -12(A5)
    JSR     LAB_0BFA(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D4
    TST.L   D4
    BMI.S   .opt4_done

    CMPI.L  #$3e7,D4
    BGT.S   .opt4_done

    MOVE.B  -12(A5),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   .opt4_done

    MOVE.B  -11(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   .opt4_done

    MOVE.B  -10(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   .opt4_done

    MOVE.L  D4,LAB_22E7

.opt4_done:
    ADDQ.L  #3,D6

.opt5_start:
    ; Opt4: digit 1..3 -> LAB_22E8.
    CMP.L   D7,D6
    BGE.S   .opt6_start

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    SUB.L   D1,D4
    MOVEQ   #1,D0
    CMP.L   D0,D4
    BLT.S   .opt5_done

    MOVEQ   #3,D1
    CMP.L   D1,D4
    BGT.S   .opt5_done

    MOVE.L  D4,LAB_22E8

.opt5_done:
    ADDQ.L  #1,D6

.opt6_start:
    ; Opt5: numeric char via LAB_0E2D if valid (table bit #7) -> LAB_22E9.
    CMP.L   D7,D6
    BGE.S   .opt7_start

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   .opt6_done

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0E2D(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,LAB_22E9

.opt6_done:
    ADDQ.L  #1,D6

.opt7_start:
    ; Opt6: digit 1..3 -> LAB_22EA.
    CMP.L   D7,D6
    BGE.S   .opt8_start

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    SUB.L   D1,D4
    MOVEQ   #1,D0
    CMP.L   D0,D4
    BLT.S   .opt7_done

    MOVEQ   #3,D1
    CMP.L   D1,D4
    BGT.S   .opt7_done

    MOVE.L  D4,LAB_22EA

.opt7_done:
    ADDQ.L  #1,D6

.opt8_start:
    ; Opt7: numeric char via LAB_0E2D if valid (table bit #7) -> LAB_22EB.
    CMP.L   D7,D6
    BGE.S   .opt9_start

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   .opt8_done

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0E2D(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,LAB_22EB

.opt8_done:
    ADDQ.L  #1,D6

.opt9_start:
    ; Opt8: digit 1..3 -> LAB_22EC.
    CMP.L   D7,D6
    BGE.S   .opt10_start

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    SUB.L   D1,D4
    MOVEQ   #1,D0
    CMP.L   D0,D4
    BLT.S   .opt9_done

    MOVEQ   #3,D2
    CMP.L   D2,D4
    BGT.S   .opt9_done

    MOVE.L  D4,LAB_22EC

.opt9_done:
    ADDQ.L  #1,D6

.opt10_start:
    ; Opt9: digit 1..3 -> LAB_22ED.
    CMP.L   D7,D6
    BGE.S   .opt11_start

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #48,D1
    SUB.L   D1,D4
    MOVEQ   #1,D0
    CMP.L   D0,D4
    BLT.S   .opt10_done

    MOVEQ   #3,D1
    CMP.L   D1,D4
    BGT.S   .opt10_done

    MOVE.L  D4,LAB_22ED

.opt10_done:
    ADDQ.L  #1,D6

.opt11_start:
    ; Opt10: numeric char via LAB_0E2D if valid (table bit #7) -> LAB_22EE.
    CMP.L   D7,D6
    BGE.S   .opt12_start

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   .opt11_done

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0E2D(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,LAB_22EE

.opt11_done:
    ADDQ.L  #1,D6

.opt12_start:
    ; Opt11: casefolded mode flag (F/B/L/N) -> LAB_22EF.
    CMP.L   D7,D6
    BGE.S   .opt13_start

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #1,(A1)
    BEQ.S   .opt12_use_raw

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .opt12_casefold_done

.opt12_use_raw:
    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0

.opt12_casefold_done:
    MOVE.L  D0,D5
    MOVEQ   #70,D0
    CMP.B   D0,D5
    BEQ.S   .opt12_store_mode

    MOVEQ   #66,D0
    CMP.B   D0,D5
    BEQ.S   .opt12_store_mode

    MOVEQ   #76,D0
    CMP.B   D0,D5
    BEQ.S   .opt12_store_mode

    MOVEQ   #78,D0
    CMP.B   D0,D5
    BNE.S   .opt12_done

.opt12_store_mode:
    MOVE.L  D5,D0
    MOVE.B  D0,LAB_22EF

.opt12_done:
    ADDQ.L  #1,D6

.opt13_start:
    ; Opt12: casefolded Y/N flag -> LAB_22F0.
    CMP.L   D7,D6
    BGE.S   .opt14_start

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   .opt13_use_raw

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .opt13_casefold_done

.opt13_use_raw:
    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0

.opt13_casefold_done:
    MOVE.L  D0,D5
    MOVEQ   #89,D0
    CMP.B   D0,D5
    BEQ.S   .opt13_store_yn

    MOVEQ   #78,D0
    CMP.B   D0,D5
    BNE.S   .opt13_done

.opt13_store_yn:
    MOVE.L  D5,D0
    MOVE.B  D0,LAB_22F0

.opt13_done:
    ADDQ.L  #1,D6

.opt14_start:
    ; Opt13: two-char numeric (??) -> LAB_22F3.
    CMP.L   D7,D6
    BGE.S   .tail_len_choose

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
    BPL.S   .opt14_store

    MOVEQ   #96,D0
    CMP.L   D0,D4
    BGT.S   .opt14_done

.opt14_store:
    MOVE.L  D4,LAB_22F3

.opt14_done:
    ADDQ.L  #2,D6

.tail_len_choose:
    ; Tail: append remaining substring to LAB_22F2/LAB_22F1.
    CMP.L   D7,D6
    BLE.S   .tail_use_d7

    MOVE.L  D6,D0
    BRA.S   .tail_len_ready

.tail_use_d7:
    MOVE.L  D7,D0

.tail_len_ready:
    MOVE.L  D0,D7
    MOVEA.L A3,A0
    ADDA.L  D7,A0
    TST.B   (A0)
    BEQ.W   .return

    MOVE.B  -19(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     GROUP_AS_JMPTBL_UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-24(A5)
    TST.L   D0
    BEQ.S   .append_tail_fallback

    MOVEA.L D0,A0
    MOVE.B  (A0),D1
    CMP.B   -19(A5),D1
    BNE.S   .append_tail_fallback

    CLR.B   (A0)+
    MOVEA.L A3,A1
    ADDA.L  D7,A1
    MOVEA.L A1,A2

    ; Scan tail length and clamp to 127 bytes.
.scan_tail_len:
    TST.B   (A2)+
    BNE.S   .scan_tail_len

    SUBQ.L  #1,A2
    SUBA.L  A1,A2
    MOVE.L  A0,-24(A5)
    MOVE.L  A2,D0
    MOVEQ   #127,D1
    CMP.L   D1,D0
    BLE.S   .truncate_tail_127

    CLR.B   127(A3,D7.L)

.truncate_tail_127:
    ; Append clamped tail to LAB_22F2.
    MOVEA.L A3,A0
    ADDA.L  D7,A0
    MOVEA.L A0,A1

    ; Scan remaining tail length for optional split.
.scan_tail_len_2:
    TST.B   (A1)+
    BNE.S   .scan_tail_len_2

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    TST.L   D0
    BLE.S   .append_tail_to_f2

    MOVEA.L A3,A0
    ADDA.L  D7,A0
    MOVE.L  LAB_22F2,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_22F2

.append_tail_to_f2:
    ; Append split buffer to LAB_22F1 if present.
    TST.L   -24(A5)
    BEQ.S   .return

    MOVEA.L -24(A5),A0
    TST.B   (A0)
    BEQ.S   .return

    MOVE.L  LAB_22F1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_22F1
    BRA.S   .return

.append_tail_fallback:
    ; Fallback: append tail to LAB_22F2 without split buffer.
    TST.B   0(A3,D7.L)
    BEQ.S   .return

    MOVEA.L A3,A0
    ADDA.L  D6,A0
    MOVE.L  LAB_22F2,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_22F2

.return:
    BSR.W   GCOMMAND_LoadPPVTemplate

    MOVEM.L (A7)+,D2/D4-D7/A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD
