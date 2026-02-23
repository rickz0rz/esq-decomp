    XDEF    GCOMMAND_LoadCommandFile
    XDEF    GCOMMAND_LoadDefaultTable
    XDEF    GCOMMAND_LoadMplexFile
    XDEF    GCOMMAND_LoadMplexTemplate
    XDEF    GCOMMAND_LoadPPV3Template
    XDEF    GCOMMAND_LoadPPVTemplate
    XDEF    GCOMMAND_ParseCommandOptions
    XDEF    GCOMMAND_ParseCommandString
    XDEF    GCOMMAND_ParsePPVCommand

;------------------------------------------------------------------------------
; FUNC: GCOMMAND_LoadDefaultTable   (Load the built-in gcommand table template into the working buffer (Global_PTR_WORK_BUFFER).)
; ARGS:
;   (none)
; RET:
;   D0: 1 (success flag)
; CLOBBERS:
;   D0/D7/A0/A1/A5/A6
; CALLS:
;   GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer, _LVOCopyMem, ESQPARS_ReplaceOwnedString, NEWGRID_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_DefaultTable, Global_PTR_WORK_BUFFER, Global_REF_LONG_FILE_SCRATCH, GCOMMAND_DigitalNicheEnabledFlag, AbsExecBase, Global_STR_GCOMMAND_C_1
; WRITES:
;   Global_PTR_WORK_BUFFER, GCOMMAND_DigitalNicheListingsTemplatePtr, -8(A5)
; DESC:
;   Load the built-in gcommand table template into the working buffer (Global_PTR_WORK_BUFFER).
; NOTES:
;   Copies a 32-byte template into the active table and frees the prior block.
;------------------------------------------------------------------------------
GCOMMAND_LoadDefaultTable:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    PEA     GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_DefaultTable
    JSR     GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BEQ.S   .return

    MOVEA.L Global_PTR_WORK_BUFFER,A0
    MOVE.L  Global_REF_LONG_FILE_SCRATCH,D7
    MOVE.L  A0,-8(A5)
    LEA     GCOMMAND_DigitalNicheEnabledFlag,A1
    MOVEQ   #32,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    MOVEQ   #32,D0
    ADD.L   D0,Global_PTR_WORK_BUFFER
    SUBA.L  A0,A0
    MOVE.L  A0,GCOMMAND_DigitalNicheListingsTemplatePtr
    MOVE.L  A0,-(A7)
    MOVE.L  Global_PTR_WORK_BUFFER,-(A7)
    JSR     ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,GCOMMAND_DigitalNicheListingsTemplatePtr
    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -8(A5),-(A7)
    PEA     335.W
    PEA     Global_STR_GCOMMAND_C_1
    JSR     NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     20(A7),A7

.return:
    MOVEQ   #1,D0
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_LoadCommandFile   (Load a command definition from disk (GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_CommandFile) and copy it into the workspace.)
; ARGS:
;   (none)
; RET:
;   D0: status/value from final disk helper call
; CLOBBERS:
;   D0/D7/A0/A1/A5
; CALLS:
;   GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer, GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes, GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush
; READS:
;   MODE_NEWFILE, GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_CommandFile, GCOMMAND_DigitalNicheEnabledFlag
; WRITES:
;   -40(A5)..-8(A5) request buffer locals
; DESC:
;   Load a command definition from disk (GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_CommandFile) and copy it into the workspace.
; NOTES:
;   Builds a 32-byte request block from GCOMMAND_DigitalNicheEnabledFlag and performs two read-style helper calls.
;------------------------------------------------------------------------------
GCOMMAND_LoadCommandFile:
    LINK.W  A5,#-40
    MOVE.L  D7,-(A7)
    PEA     MODE_NEWFILE.W
    PEA     GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_CommandFile
    JSR     GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    TST.L   D7
    BEQ.S   .return

    LEA     GCOMMAND_DigitalNicheEnabledFlag,A0
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
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(PC)

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
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    MOVE.L  D7,(A7)
    JSR     GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush(PC)

    LEA     20(A7),A7

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_ParseCommandOptions   (Parse digital-niche command options string)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
;   stack +8: arg_3 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A5/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, GCOMMAND_LoadCommandFile, GROUP_AW_JMPTBL_STRING_CopyPadNul, ESQPARS_ReplaceOwnedString, FLIB2_LoadDigitalNicheDefaults, LADFUNC_ParseHexDigit
; READS:
;   GCOMMAND_NicheParseScratchSeedWord, WDISP_CharClassTable, GCOMMAND_DigitalNicheListingsTemplatePtr, return
; WRITES:
;   GCOMMAND_DigitalNicheEnabledFlag, GCOMMAND_NicheTextPen, GCOMMAND_NicheFramePen, GCOMMAND_NicheEditorLayoutPen, GCOMMAND_NicheEditorRowPen, GCOMMAND_NicheModeCycleCount, GCOMMAND_NicheForceMode5Flag, GCOMMAND_NicheWorkflowMode, GCOMMAND_DigitalNicheListingsTemplatePtr
; DESC:
;   Parses a command/options string into global gcommand state.
; NOTES:
;   Tail bytes after parsed options are appended to
;   GCOMMAND_DigitalNicheListingsTemplatePtr via ESQPARS_ReplaceOwnedString.
;------------------------------------------------------------------------------
GCOMMAND_ParseCommandOptions:
    LINK.W  A5,#-20
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D6
    LEA     GCOMMAND_NicheParseScratchSeedWord,A0
    LEA     -12(A5),A1
    MOVE.B  (A0)+,(A1)+
    MOVE.B  (A0)+,(A1)+
    MOVE.B  (A0)+,(A1)+
    MOVE.B  (A0)+,(A1)+
    MOVEQ   #0,D5
    MOVEQ   #0,D4
    BSR.W   FLIB2_LoadDigitalNicheDefaults

    MOVE.L  A3,D0
    BEQ.W   .return

    TST.B   (A3)
    BEQ.W   .return

    PEA     2.W
    MOVE.L  A3,-(A7)
    PEA     -12(A5)
    JSR     GROUP_AW_JMPTBL_STRING_CopyPadNul(PC)

    CLR.B   -10(A5)
    PEA     -12(A5)
    JSR     ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    LEA     16(A7),A7
    MOVE.L  D0,D7
    ADDQ.L  #2,D7
    MOVEQ   #2,D6
    CMP.L   D7,D6
    BGE.S   .opt2_start

    ; Opt0: casefolded Y/N flag -> GCOMMAND_DigitalNicheEnabledFlag.
    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A0
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
    MOVE.B  D0,GCOMMAND_DigitalNicheEnabledFlag

.opt1_done:
    ADDQ.L  #1,D6

.opt2_start:
    ; Opt1: digit 1..3 -> GCOMMAND_NicheTextPen.
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

    MOVE.L  D4,GCOMMAND_NicheTextPen

.opt2_done:
    ADDQ.L  #1,D6

.opt3_start:
    ; Opt2: numeric char via LADFUNC_ParseHexDigit if valid (table bit #7) -> GCOMMAND_NicheFramePen.
    CMP.L   D7,D6
    BGE.S   .opt4_start

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   .opt3_done

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,GCOMMAND_NicheFramePen

.opt3_done:
    ADDQ.L  #1,D6

.opt4_start:
    ; Opt3: digit 1..3 -> GCOMMAND_NicheEditorLayoutPen.
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

    MOVE.L  D4,GCOMMAND_NicheEditorLayoutPen

.opt4_done:
    ADDQ.L  #1,D6

.opt5_start:
    ; Opt4: numeric char via LADFUNC_ParseHexDigit if valid (table bit #7) -> GCOMMAND_NicheEditorRowPen.
    CMP.L   D7,D6
    BGE.S   .opt6_start

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   .opt5_done

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,GCOMMAND_NicheEditorRowPen

.opt5_done:
    ADDQ.L  #1,D6

.opt6_start:
    ; Opt5: casefolded mode flag (F/B/L/N) -> GCOMMAND_NicheWorkflowMode.
    CMP.L   D7,D6
    BGE.S   .opt7_start

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A0
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
    MOVE.B  D0,GCOMMAND_NicheWorkflowMode

.opt6_done:
    ADDQ.L  #1,D6

.opt7_start:
    ; Opt6: digit 0..9 with special-case '1' toggle -> GCOMMAND_NicheModeCycleCount/GCOMMAND_NicheForceMode5Flag.
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
    MOVE.L  D1,GCOMMAND_NicheModeCycleCount
    MOVE.L  D0,GCOMMAND_NicheForceMode5Flag
    BRA.S   .opt7_done

.opt7_not_one:
    TST.L   D4
    BMI.S   .opt7_done

    MOVEQ   #9,D1
    CMP.L   D1,D4
    BGT.S   .opt7_done

    MOVE.L  D4,GCOMMAND_NicheModeCycleCount
    CLR.L   GCOMMAND_NicheForceMode5Flag

.opt7_done:
    ADDQ.L  #1,D6

.tail_len_choose:
    ; Tail: append remaining substring to GCOMMAND_DigitalNicheListingsTemplatePtr.
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

    MOVE.L  GCOMMAND_DigitalNicheListingsTemplatePtr,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,GCOMMAND_DigitalNicheListingsTemplatePtr

.return:
    BSR.W   GCOMMAND_LoadCommandFile

    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_LoadMplexTemplate   (Load the Digital_Mplex template and stage it in GCOMMAND_MplexListingsTemplatePtr/GCOMMAND_MplexAtTemplatePtr.)
; ARGS:
;   stack +8: arg_1 (via 12(A5))
;   stack +12: arg_2 (via 16(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D7
; CALLS:
;   GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold, GROUP_AS_JMPTBL_STR_FindCharPtr, GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer, ESQPARS_ReplaceOwnedString, NEWGRID_JMPTBL_MEMORY_DeallocateMemory, _LVOCopyMem
; READS:
;   AbsExecBase, Global_REF_LONG_FILE_SCRATCH, Global_STR_GCOMMAND_C_2, GCOMMAND_PATH_DF0_COLON_DIGITAL_MPLEX_DOT_DAT_TemplateLoad, GCOMMAND_FMT_PCT_T_MplexTemplateLoad, Global_PTR_WORK_BUFFER, GCOMMAND_DigitalMplexEnabledFlag, GCOMMAND_MplexListingsTemplatePtr, GCOMMAND_MplexAtTemplatePtr, return
; WRITES:
;   Global_PTR_WORK_BUFFER, GCOMMAND_MplexListingsTemplatePtr, GCOMMAND_MplexAtTemplatePtr
; DESC:
;   Load the Digital_Mplex template and stage it in GCOMMAND_MplexListingsTemplatePtr/GCOMMAND_MplexAtTemplatePtr.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
GCOMMAND_LoadMplexTemplate:
    LINK.W  A5,#-16
    MOVE.L  D7,-(A7)
    PEA     GCOMMAND_PATH_DF0_COLON_DIGITAL_MPLEX_DOT_DAT_TemplateLoad
    JSR     GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BEQ.W   .return

    MOVEA.L Global_PTR_WORK_BUFFER,A0
    MOVE.L  Global_REF_LONG_FILE_SCRATCH,D7
    MOVE.L  A0,-4(A5)
    LEA     GCOMMAND_DigitalMplexEnabledFlag,A1
    MOVEQ   #52,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    MOVEQ   #52,D0
    ADD.L   D0,Global_PTR_WORK_BUFFER
    SUBA.L  A0,A0
    MOVE.L  A0,GCOMMAND_MplexListingsTemplatePtr
    MOVE.L  A0,GCOMMAND_MplexAtTemplatePtr
    PEA     18.W
    MOVE.L  Global_PTR_WORK_BUFFER,-(A7)
    JSR     GROUP_AS_JMPTBL_STR_FindCharPtr(PC)

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
    MOVE.L  GCOMMAND_MplexAtTemplatePtr,-(A7)
    MOVE.L  Global_PTR_WORK_BUFFER,-(A7)
    JSR     ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,GCOMMAND_MplexAtTemplatePtr
    MOVE.L  GCOMMAND_MplexListingsTemplatePtr,(A7)
    MOVE.L  -12(A5),-(A7)
    JSR     ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,GCOMMAND_MplexListingsTemplatePtr
    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     575.W
    PEA     Global_STR_GCOMMAND_C_2
    JSR     NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     24(A7),A7
    CLR.L   -16(A5)
    TST.L   GCOMMAND_MplexAtTemplatePtr
    BEQ.S   .check_suffix_slot

    MOVEA.L GCOMMAND_MplexAtTemplatePtr,A0
    TST.B   (A0)
    BEQ.S   .check_suffix_slot

    PEA     GCOMMAND_FMT_PCT_T_MplexTemplateLoad
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
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +16: arg_4 (via 20(A5))
;   stack +60: arg_5 (via 64(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A7/D0/D7
; CALLS:
;   GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer, GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush, GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes
; READS:
;   GCOMMAND_PATH_DF0_COLON_DIGITAL_MPLEX_DOT_DAT_TemplateSave, GCOMMAND_MplexTemplateFieldSeparatorByteStorage, GCOMMAND_DigitalMplexEnabledFlag, MODE_NEWFILE, copy_template_loop, return
; WRITES:
;   (none observed)
; DESC:
;   Load Digital_Mplex.dat from disk and merge it into the workspace buffers.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
GCOMMAND_LoadMplexFile:
    LINK.W  A5,#-64
    MOVE.L  D7,-(A7)
    PEA     MODE_NEWFILE.W
    PEA     GCOMMAND_PATH_DF0_COLON_DIGITAL_MPLEX_DOT_DAT_TemplateSave
    JSR     GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    TST.L   D7
    BEQ.W   .return

    LEA     GCOMMAND_DigitalMplexEnabledFlag,A0
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
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(PC)

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
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,(A7)
    PEA     GCOMMAND_MplexTemplateFieldSeparatorByteStorage
    MOVE.L  D7,-(A7)
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(PC)

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
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    MOVE.L  D7,(A7)
    JSR     GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush(PC)

    LEA     36(A7),A7

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_ParseCommandString   (Parse a command line into token flags, returning indices for gcommand execution.)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
;   stack +7: arg_3 (via 11(A5))
;   stack +8: arg_4 (via 12(A5))
;   stack +15: arg_5 (via 19(A5))
;   stack +20: arg_6 (via 24(A5))
;   stack +24: arg_7 (via 28(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D2/D4/D5/D6/D7
; CALLS:
;   ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, GCOMMAND_LoadMplexFile, GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold, GROUP_AS_JMPTBL_STR_FindCharPtr, GROUP_AW_JMPTBL_STRING_CopyPadNul, ESQPARS_ReplaceOwnedString, FLIB2_LoadDigitalMplexDefaults, LADFUNC_ParseHexDigit
; READS:
;   GCOMMAND_MplexParseScratchSeedWord, GCOMMAND_FMT_PCT_T_MplexTemplateParse, WDISP_CharClassTable, GCOMMAND_MplexListingsTemplatePtr, GCOMMAND_MplexAtTemplatePtr, after_tail_append, return
; WRITES:
;   GCOMMAND_DigitalMplexEnabledFlag, GCOMMAND_MplexModeCycleCount, GCOMMAND_MplexSearchRowLimit, GCOMMAND_MplexClockOffsetMinutes, GCOMMAND_MplexMessageTextPen, GCOMMAND_MplexMessageFramePen, GCOMMAND_MplexEditorLayoutPen, GCOMMAND_MplexEditorRowPen, GCOMMAND_MplexDetailLayoutPen, GCOMMAND_MplexDetailInitialLineIndex, GCOMMAND_MplexDetailRowPen, GCOMMAND_MplexWorkflowMode, GCOMMAND_MplexDetailLayoutFlag, GCOMMAND_MplexListingsTemplatePtr, GCOMMAND_MplexAtTemplatePtr
; DESC:
;   Parse a command line into token flags, returning indices for gcommand execution.
; NOTES:
;   Uses byte $12 as a split marker and clamps appended tail text to 127 bytes
;   before replacing/appending owned template pointers.
;------------------------------------------------------------------------------
GCOMMAND_ParseCommandString:
    LINK.W  A5,#-28
    MOVEM.L D2/D4-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D6
    LEA     GCOMMAND_MplexParseScratchSeedWord,A0
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
    BSR.W   FLIB2_LoadDigitalMplexDefaults

    MOVE.L  A3,D0
    BEQ.W   .return

    TST.B   (A3)
    BEQ.W   .return

    PEA     2.W
    MOVE.L  A3,-(A7)
    PEA     -12(A5)
    JSR     GROUP_AW_JMPTBL_STRING_CopyPadNul(PC)

    CLR.B   -10(A5)
    PEA     -12(A5)
    JSR     ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    LEA     16(A7),A7
    MOVE.L  D0,D7
    ADDQ.L  #2,D7
    MOVEQ   #2,D6
    CMP.L   D7,D6
    BGE.S   .opt2_start

    ; Opt0: casefolded Y/N flag -> GCOMMAND_DigitalMplexEnabledFlag.
    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A0
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
    MOVE.B  D0,GCOMMAND_DigitalMplexEnabledFlag

.opt1_done:
    ADDQ.L  #1,D6

.opt2_start:
    ; Opt1: digit 0..9 -> GCOMMAND_MplexModeCycleCount.
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

    MOVE.L  D4,GCOMMAND_MplexModeCycleCount

.opt2_done:
    ADDQ.L  #1,D6

.opt3_start:
    ; Opt2: two-digit numeric (0..99) with digit validation -> GCOMMAND_MplexSearchRowLimit.
    CMP.L   D7,D6
    BGE.S   .opt4_start

    MOVE.B  0(A3,D6.L),-12(A5)
    MOVE.B  1(A3,D6.L),-11(A5)
    CLR.B   -10(A5)
    PEA     -12(A5)
    JSR     ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

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
    LEA     WDISP_CharClassTable,A0
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

    MOVE.L  D4,GCOMMAND_MplexSearchRowLimit

.opt3_done:
    ADDQ.L  #2,D6

.opt4_start:
    ; Opt3: two-digit numeric (0..29) with digit validation -> GCOMMAND_MplexClockOffsetMinutes.
    CMP.L   D7,D6
    BGE.S   .opt5_start

    MOVE.B  0(A3,D6.L),-12(A5)
    MOVE.B  1(A3,D6.L),-11(A5)
    CLR.B   -10(A5)
    PEA     -12(A5)
    JSR     ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

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
    LEA     WDISP_CharClassTable,A0
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

    MOVE.L  D4,GCOMMAND_MplexClockOffsetMinutes

.opt4_done:
    ADDQ.L  #2,D6

.opt5_start:
    ; Opt4: digit 1..3 -> GCOMMAND_MplexMessageTextPen.
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

    MOVE.L  D4,GCOMMAND_MplexMessageTextPen

.opt5_done:
    ADDQ.L  #1,D6

.opt6_start:
    ; Opt5: numeric char via LADFUNC_ParseHexDigit if valid (table bit #7) -> GCOMMAND_MplexMessageFramePen.
    CMP.L   D7,D6
    BGE.S   .opt7_start

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   .opt6_done

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,GCOMMAND_MplexMessageFramePen

.opt6_done:
    ADDQ.L  #1,D6

.opt7_start:
    ; Opt6: digit 1..3 -> GCOMMAND_MplexEditorLayoutPen.
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

    MOVE.L  D4,GCOMMAND_MplexEditorLayoutPen

.opt7_done:
    ADDQ.L  #1,D6

.opt8_start:
    ; Opt7: numeric char via LADFUNC_ParseHexDigit if valid (table bit #7) -> GCOMMAND_MplexEditorRowPen.
    CMP.L   D7,D6
    BGE.S   .opt9_start

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   .opt8_done

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,GCOMMAND_MplexEditorRowPen

.opt8_done:
    ADDQ.L  #1,D6

.opt9_start:
    ; Opt8: digit 1..3 -> GCOMMAND_MplexDetailLayoutPen.
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

    MOVE.L  D4,GCOMMAND_MplexDetailLayoutPen

.opt9_done:
    ADDQ.L  #1,D6

.opt10_start:
    ; Opt9: digit 1..3 -> GCOMMAND_MplexDetailInitialLineIndex.
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

    MOVE.L  D4,GCOMMAND_MplexDetailInitialLineIndex

.opt10_done:
    ADDQ.L  #1,D6

.opt11_start:
    ; Opt10: numeric char via LADFUNC_ParseHexDigit if valid (table bit #7) -> GCOMMAND_MplexDetailRowPen.
    CMP.L   D7,D6
    BGE.S   .opt12_start

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   .opt11_done

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,GCOMMAND_MplexDetailRowPen

.opt11_done:
    ADDQ.L  #1,D6

.opt12_start:
    ; Opt11: casefolded mode flag (F/B/L/N) -> GCOMMAND_MplexWorkflowMode.
    CMP.L   D7,D6
    BGE.S   .opt13_start

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A0
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
    MOVE.B  D0,GCOMMAND_MplexWorkflowMode

.opt12_done:
    ADDQ.L  #1,D6

.opt13_start:
    ; Opt12: casefolded Y/N flag -> GCOMMAND_MplexDetailLayoutFlag.
    CMP.L   D7,D6
    BGE.S   .tail_len_choose

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A0
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
    MOVE.B  D0,GCOMMAND_MplexDetailLayoutFlag

.opt13_done:
    ADDQ.L  #1,D6

.tail_len_choose:
    ; Tail: append remaining substring to GCOMMAND_MplexAtTemplatePtr/GCOMMAND_MplexListingsTemplatePtr.
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
    JSR     GROUP_AS_JMPTBL_STR_FindCharPtr(PC)

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
    ; Append the clamped tail to GCOMMAND_MplexAtTemplatePtr.
    MOVEA.L A3,A0
    ADDA.L  D7,A0
    TST.B   (A0)
    BEQ.S   .append_tail_to_e3

    MOVE.L  GCOMMAND_MplexAtTemplatePtr,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,GCOMMAND_MplexAtTemplatePtr

.append_tail_to_e3:
    ; If the split buffer is non-empty, append to GCOMMAND_MplexListingsTemplatePtr.
    TST.L   -24(A5)
    BEQ.S   .after_tail_append

    MOVEA.L -24(A5),A0
    TST.B   (A0)
    BEQ.S   .after_tail_append

    MOVE.L  GCOMMAND_MplexListingsTemplatePtr,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,GCOMMAND_MplexListingsTemplatePtr
    BRA.S   .after_tail_append

.append_e3_only:
    ; If split buffer allocation failed, only append tail to GCOMMAND_MplexAtTemplatePtr.
    MOVEA.L A3,A0
    ADDA.L  D7,A0
    TST.B   (A0)
    BEQ.S   .after_tail_append

    MOVE.L  GCOMMAND_MplexAtTemplatePtr,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,GCOMMAND_MplexAtTemplatePtr

.after_tail_append:
    CLR.L   -28(A5)
    TST.L   GCOMMAND_MplexAtTemplatePtr
    BEQ.S   .check_suffix_slot

    MOVEA.L GCOMMAND_MplexAtTemplatePtr,A0
    TST.B   (A0)
    BEQ.S   .check_suffix_slot

    PEA     GCOMMAND_FMT_PCT_T_MplexTemplateParse
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
    SUB.L   GCOMMAND_MplexAtTemplatePtr,D0
    MOVE.L  D0,D4
    ADDQ.L  #1,D4
    MOVEA.L GCOMMAND_MplexAtTemplatePtr,A0
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
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D1/D5/D6/D7
; CALLS:
;   GCOMMAND_LoadPPVTemplate, GROUP_AS_JMPTBL_STR_FindCharPtr, GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer, ESQPARS_ReplaceOwnedString, NEWGRID_JMPTBL_MEMORY_DeallocateMemory, _LVOCopyMem, _LVODeleteFile
; READS:
;   AbsExecBase, Global_REF_DOS_LIBRARY_2, Global_REF_LONG_FILE_SCRATCH, Global_STR_GCOMMAND_C_3, GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV3_DOT_DAT_TemplatePrimaryLoad, GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV_DOT_DAT_TemplateFallbackLoad, GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV_DOT_DAT_TemplateFallbackDelete, Global_PTR_WORK_BUFFER, GCOMMAND_DigitalPpvEnabledFlag, GCOMMAND_PPVListingsTemplatePtr, GCOMMAND_PPVPeriodTemplatePtr, return
; WRITES:
;   Global_PTR_WORK_BUFFER, GCOMMAND_PPVListingsTemplatePtr, GCOMMAND_PPVPeriodTemplatePtr
; DESC:
;   Load the Digital_PPV3 template into the working buffer tables.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
GCOMMAND_LoadPPV3Template:
    LINK.W  A5,#-20
    MOVEM.L D5-D7,-(A7)
    MOVEQ   #0,D6
    MOVEQ   #0,D5
    PEA     GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV3_DOT_DAT_TemplatePrimaryLoad
    JSR     GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BEQ.S   .try_fallback_template

    ; Found primary template (Digital_PPV3).
    MOVEQ   #56,D6
    BRA.S   .template_ready

.try_fallback_template:
    ; Fall back to alternate template (Digital_PPV).
    PEA     GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV_DOT_DAT_TemplateFallbackLoad
    JSR     GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BEQ.S   .template_ready

    MOVEQ   #52,D6
    LEA     GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV_DOT_DAT_TemplateFallbackDelete,A0
    MOVE.L  A0,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVODeleteFile(A6)

    MOVEQ   #1,D5

.template_ready:
    TST.L   D6
    BEQ.W   .return

    MOVEA.L Global_PTR_WORK_BUFFER,A0
    MOVE.L  Global_REF_LONG_FILE_SCRATCH,D7
    MOVE.L  A0,-4(A5)
    MOVE.L  D6,D0
    LEA     GCOMMAND_DigitalPpvEnabledFlag,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    SUBA.L  A0,A0
    MOVE.L  A0,GCOMMAND_PPVPeriodTemplatePtr
    MOVE.L  A0,GCOMMAND_PPVListingsTemplatePtr
    ADD.L   D6,Global_PTR_WORK_BUFFER
    PEA     18.W
    MOVE.L  Global_PTR_WORK_BUFFER,-(A7)
    JSR     GROUP_AS_JMPTBL_STR_FindCharPtr(PC)

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
    MOVE.L  GCOMMAND_PPVPeriodTemplatePtr,-(A7)
    MOVE.L  Global_PTR_WORK_BUFFER,-(A7)
    JSR     ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,GCOMMAND_PPVPeriodTemplatePtr
    MOVE.L  GCOMMAND_PPVListingsTemplatePtr,(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,GCOMMAND_PPVListingsTemplatePtr
    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     993.W
    PEA     Global_STR_GCOMMAND_C_3
    JSR     NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

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
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +16: arg_3 (via 20(A5))
;   stack +20: arg_4 (via 24(A5))
;   stack +64: arg_5 (via 68(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A7/D0/D7
; CALLS:
;   GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer, GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush, GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes
; READS:
;   GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV3_DOT_DAT_TemplateSave, GCOMMAND_PpvTemplateFieldSeparatorByteStorage, GCOMMAND_DigitalPpvEnabledFlag, MODE_NEWFILE, copy_template_loop, return
; WRITES:
;   (none observed)
; DESC:
;   Load the PPV table template into the workspace buffers.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
GCOMMAND_LoadPPVTemplate:
    LINK.W  A5,#-68
    MOVE.L  D7,-(A7)
    PEA     MODE_NEWFILE.W
    PEA     GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV3_DOT_DAT_TemplateSave
    JSR     GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    TST.L   D7
    BEQ.W   .return

    LEA     GCOMMAND_DigitalPpvEnabledFlag,A0
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
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(PC)

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
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,(A7)
    PEA     GCOMMAND_PpvTemplateFieldSeparatorByteStorage
    MOVE.L  D7,-(A7)
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(PC)

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
    JSR     GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    MOVE.L  D7,(A7)
    JSR     GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush(PC)

    LEA     36(A7),A7

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_ParsePPVCommand   (Parse a PPV command string into tokens/indices for execution.)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +5: arg_2 (via 9(A5))
;   stack +6: arg_3 (via 10(A5))
;   stack +7: arg_4 (via 11(A5))
;   stack +8: arg_5 (via 12(A5))
;   stack +15: arg_6 (via 19(A5))
;   stack +20: arg_7 (via 24(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D2/D4/D5/D6/D7
; CALLS:
;   ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, GCOMMAND_LoadPPVTemplate, GROUP_AS_JMPTBL_STR_FindCharPtr, GROUP_AW_JMPTBL_STRING_CopyPadNul, ESQPARS_ReplaceOwnedString, FLIB2_LoadDigitalPpvDefaults, LADFUNC_ParseHexDigit
; READS:
;   GCOMMAND_PpvParseScratchSeedLong, WDISP_CharClassTable, GCOMMAND_PPVListingsTemplatePtr, GCOMMAND_PPVPeriodTemplatePtr, return
; WRITES:
;   GCOMMAND_DigitalPpvEnabledFlag, GCOMMAND_PpvModeCycleCount, GCOMMAND_PpvSelectionWindowMinutes, GCOMMAND_PpvSelectionToleranceMinutes, GCOMMAND_PpvMessageTextPen, GCOMMAND_PpvMessageFramePen, GCOMMAND_PpvEditorLayoutPen, GCOMMAND_PpvEditorRowPen, GCOMMAND_PpvShowtimesLayoutPen, GCOMMAND_PpvShowtimesInitialLineIndex, GCOMMAND_PpvShowtimesRowPen, GCOMMAND_PpvShowtimesWorkflowMode, GCOMMAND_PpvDetailLayoutFlag, GCOMMAND_PPVListingsTemplatePtr, GCOMMAND_PPVPeriodTemplatePtr, GCOMMAND_PpvShowtimesRowSpan
; DESC:
;   Parse a PPV command string into tokens/indices for execution.
; NOTES:
;   Uses byte $12 as a split marker and clamps appended tail text to 127 bytes
;   before replacing/appending owned PPV template pointers.
;------------------------------------------------------------------------------
GCOMMAND_ParsePPVCommand:
    LINK.W  A5,#-24
    MOVEM.L D2/D4-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D6
    LEA     GCOMMAND_PpvParseScratchSeedLong,A0
    LEA     -12(A5),A1
    MOVE.B  (A0)+,(A1)+
    MOVE.B  (A0)+,(A1)+
    MOVE.B  (A0)+,(A1)+
    MOVE.B  (A0)+,(A1)+
    MOVEQ   #0,D5
    MOVEQ   #0,D4
    MOVE.B  #$12,-19(A5)
    CLR.L   -24(A5)
    BSR.W   FLIB2_LoadDigitalPpvDefaults

    MOVE.L  A3,D0
    BEQ.W   .return

    TST.B   (A3)
    BEQ.W   .return

    PEA     2.W
    MOVE.L  A3,-(A7)
    PEA     -12(A5)
    JSR     GROUP_AW_JMPTBL_STRING_CopyPadNul(PC)

    CLR.B   -10(A5)
    PEA     -12(A5)
    JSR     ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    LEA     16(A7),A7
    MOVE.L  D0,D7
    ADDQ.L  #2,D7
    MOVEQ   #2,D6
    CMP.L   D7,D6
    BGE.S   .opt2_start

    ; Opt0: casefolded Y/N flag -> GCOMMAND_DigitalPpvEnabledFlag.
    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A0
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
    MOVE.B  D0,GCOMMAND_DigitalPpvEnabledFlag

.opt1_done:
    ADDQ.L  #1,D6

.opt2_start:
    ; Opt1: digit 0..9 -> GCOMMAND_PpvModeCycleCount.
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

    MOVE.L  D4,GCOMMAND_PpvModeCycleCount

.opt2_done:
    ADDQ.L  #1,D6

.opt3_start:
    ; Opt2: three-digit numeric (0..999) with digit validation -> GCOMMAND_PpvSelectionWindowMinutes.
    CMP.L   D7,D6
    BGE.S   .opt4_start

    MOVE.B  0(A3,D6.L),-12(A5)
    MOVE.B  1(A3,D6.L),-11(A5)
    MOVE.B  2(A3,D6.L),-10(A5)
    CLR.B   -9(A5)
    PEA     -12(A5)
    JSR     ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D4
    TST.L   D4
    BMI.S   .opt3_done

    CMPI.L  #$3e7,D4
    BGT.S   .opt3_done

    MOVE.B  -12(A5),D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A0
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

    MOVE.L  D4,GCOMMAND_PpvSelectionWindowMinutes

.opt3_done:
    ADDQ.L  #3,D6

.opt4_start:
    ; Opt3: three-digit numeric (0..999) with digit validation -> GCOMMAND_PpvSelectionToleranceMinutes.
    CMP.L   D7,D6
    BGE.S   .opt5_start

    MOVE.B  0(A3,D6.L),-12(A5)
    MOVE.B  1(A3,D6.L),-11(A5)
    MOVE.B  2(A3,D6.L),-10(A5)
    CLR.B   -9(A5)
    PEA     -12(A5)
    JSR     ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D4
    TST.L   D4
    BMI.S   .opt4_done

    CMPI.L  #$3e7,D4
    BGT.S   .opt4_done

    MOVE.B  -12(A5),D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A0
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

    MOVE.L  D4,GCOMMAND_PpvSelectionToleranceMinutes

.opt4_done:
    ADDQ.L  #3,D6

.opt5_start:
    ; Opt4: digit 1..3 -> GCOMMAND_PpvMessageTextPen.
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

    MOVE.L  D4,GCOMMAND_PpvMessageTextPen

.opt5_done:
    ADDQ.L  #1,D6

.opt6_start:
    ; Opt5: numeric char via LADFUNC_ParseHexDigit if valid (table bit #7) -> GCOMMAND_PpvMessageFramePen.
    CMP.L   D7,D6
    BGE.S   .opt7_start

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   .opt6_done

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,GCOMMAND_PpvMessageFramePen

.opt6_done:
    ADDQ.L  #1,D6

.opt7_start:
    ; Opt6: digit 1..3 -> GCOMMAND_PpvEditorLayoutPen.
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

    MOVE.L  D4,GCOMMAND_PpvEditorLayoutPen

.opt7_done:
    ADDQ.L  #1,D6

.opt8_start:
    ; Opt7: numeric char via LADFUNC_ParseHexDigit if valid (table bit #7) -> GCOMMAND_PpvEditorRowPen.
    CMP.L   D7,D6
    BGE.S   .opt9_start

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   .opt8_done

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,GCOMMAND_PpvEditorRowPen

.opt8_done:
    ADDQ.L  #1,D6

.opt9_start:
    ; Opt8: digit 1..3 -> GCOMMAND_PpvShowtimesLayoutPen.
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

    MOVE.L  D4,GCOMMAND_PpvShowtimesLayoutPen

.opt9_done:
    ADDQ.L  #1,D6

.opt10_start:
    ; Opt9: digit 1..3 -> GCOMMAND_PpvShowtimesInitialLineIndex.
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

    MOVE.L  D4,GCOMMAND_PpvShowtimesInitialLineIndex

.opt10_done:
    ADDQ.L  #1,D6

.opt11_start:
    ; Opt10: numeric char via LADFUNC_ParseHexDigit if valid (table bit #7) -> GCOMMAND_PpvShowtimesRowPen.
    CMP.L   D7,D6
    BGE.S   .opt12_start

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   .opt11_done

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,GCOMMAND_PpvShowtimesRowPen

.opt11_done:
    ADDQ.L  #1,D6

.opt12_start:
    ; Opt11: casefolded mode flag (F/B/L/N) -> GCOMMAND_PpvShowtimesWorkflowMode.
    CMP.L   D7,D6
    BGE.S   .opt13_start

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A0
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
    MOVE.B  D0,GCOMMAND_PpvShowtimesWorkflowMode

.opt12_done:
    ADDQ.L  #1,D6

.opt13_start:
    ; Opt12: casefolded Y/N flag -> GCOMMAND_PpvDetailLayoutFlag.
    CMP.L   D7,D6
    BGE.S   .opt14_start

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A0
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
    MOVE.B  D0,GCOMMAND_PpvDetailLayoutFlag

.opt13_done:
    ADDQ.L  #1,D6

.opt14_start:
    ; Opt13: two-char numeric (uncertain) -> GCOMMAND_PpvShowtimesRowSpan.
    CMP.L   D7,D6
    BGE.S   .tail_len_choose

    MOVEA.L A3,A0
    ADDA.L  D6,A0
    PEA     2.W
    MOVE.L  A0,-(A7)
    PEA     -12(A5)
    JSR     GROUP_AW_JMPTBL_STRING_CopyPadNul(PC)

    CLR.B   -10(A5)
    PEA     -12(A5)
    JSR     ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    LEA     16(A7),A7
    MOVE.L  D0,D4
    TST.L   D4
    BPL.S   .opt14_store

    MOVEQ   #96,D0
    CMP.L   D0,D4
    BGT.S   .opt14_done

.opt14_store:
    MOVE.L  D4,GCOMMAND_PpvShowtimesRowSpan

.opt14_done:
    ADDQ.L  #2,D6

.tail_len_choose:
    ; Tail: append remaining substring to GCOMMAND_PPVPeriodTemplatePtr/GCOMMAND_PPVListingsTemplatePtr.
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
    JSR     GROUP_AS_JMPTBL_STR_FindCharPtr(PC)

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
    ; Append clamped tail to GCOMMAND_PPVPeriodTemplatePtr.
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
    MOVE.L  GCOMMAND_PPVPeriodTemplatePtr,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,GCOMMAND_PPVPeriodTemplatePtr

.append_tail_to_f2:
    ; Append split buffer to GCOMMAND_PPVListingsTemplatePtr if present.
    TST.L   -24(A5)
    BEQ.S   .return

    MOVEA.L -24(A5),A0
    TST.B   (A0)
    BEQ.S   .return

    MOVE.L  GCOMMAND_PPVListingsTemplatePtr,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,GCOMMAND_PPVListingsTemplatePtr
    BRA.S   .return

.append_tail_fallback:
    ; Fallback: append tail to GCOMMAND_PPVPeriodTemplatePtr without split buffer.
    TST.B   0(A3,D7.L)
    BEQ.S   .return

    MOVEA.L A3,A0
    ADDA.L  D6,A0
    MOVE.L  GCOMMAND_PPVPeriodTemplatePtr,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,GCOMMAND_PPVPeriodTemplatePtr

.return:
    BSR.W   GCOMMAND_LoadPPVTemplate

    MOVEM.L (A7)+,D2/D4-D7/A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD
