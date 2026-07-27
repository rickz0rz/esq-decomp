    XDEF    GCOMMAND_LoadCommandFile
    XDEF    GCOMMAND_LoadDefaultTable
    XDEF    GCOMMAND_LoadMplexTemplate
    XDEF    GCOMMAND_ParseCommandOptions


;------------------------------------------------------------------------------
; FUNC: GCOMMAND_LoadDefaultTable   (Load the built-in gcommand table template into the working buffer (_Global_PTR_WORK_BUFFER).)
; ARGS:
;   (none)
; RET:
;   D0: 1 (success flag)
; CLOBBERS:
;   D0/D7/A0/A1/A5/A6
; CALLS:
;   _GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer, _LVOCopyMem, _ESQPARS_ReplaceOwnedString, _NEWGRID_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_DefaultTable, _Global_PTR_WORK_BUFFER, _Global_REF_LONG_FILE_SCRATCH, _GCOMMAND_DigitalNicheEnabledFlag, AbsExecBase, Global_STR_GCOMMAND_C_1
; WRITES:
;   _Global_PTR_WORK_BUFFER, _GCOMMAND_DigitalNicheListingsTemplatePtr, -8(A5)
; DESC:
;   Load the built-in gcommand table template into the working buffer (_Global_PTR_WORK_BUFFER).
; NOTES:
;   Copies a 32-byte template into the active table and frees the prior block.
;------------------------------------------------------------------------------
GCOMMAND_LoadDefaultTable:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    PEA     GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_DefaultTable
    JSR     _GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BEQ.S   .return

    MOVEA.L _Global_PTR_WORK_BUFFER,A0
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,D7
    MOVE.L  A0,-8(A5)
    LEA     _GCOMMAND_DigitalNicheEnabledFlag,A1
    MOVEQ   #32,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    MOVEQ   #32,D0
    ADD.L   D0,_Global_PTR_WORK_BUFFER
    SUBA.L  A0,A0
    MOVE.L  A0,_GCOMMAND_DigitalNicheListingsTemplatePtr
    MOVE.L  A0,-(A7)
    MOVE.L  _Global_PTR_WORK_BUFFER,-(A7)
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,_GCOMMAND_DigitalNicheListingsTemplatePtr
    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -8(A5),-(A7)
    PEA     335.W
    PEA     Global_STR_GCOMMAND_C_1
    JSR     _NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

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
;   MODE_NEWFILE, GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_CommandFile, _GCOMMAND_DigitalNicheEnabledFlag
; WRITES:
;   -40(A5)..-8(A5) request buffer locals
; DESC:
;   Load a command definition from disk (GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_CommandFile) and copy it into the workspace.
; NOTES:
;   Builds a 32-byte request block from _GCOMMAND_DigitalNicheEnabledFlag and performs two read-style helper calls.
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

    LEA     _GCOMMAND_DigitalNicheEnabledFlag,A0
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
;   _ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, GCOMMAND_LoadCommandFile, GROUP_AW_JMPTBL_STRING_CopyPadNul, _ESQPARS_ReplaceOwnedString, _FLIB2_LoadDigitalNicheDefaults, _LADFUNC_ParseHexDigit
; READS:
;   GCOMMAND_NicheParseScratchSeedWord, _WDISP_CharClassTable, _GCOMMAND_DigitalNicheListingsTemplatePtr, return
; WRITES:
;   _GCOMMAND_DigitalNicheEnabledFlag, _GCOMMAND_NicheTextPen, _GCOMMAND_NicheFramePen, _GCOMMAND_NicheEditorLayoutPen, _GCOMMAND_NicheEditorRowPen, _GCOMMAND_NicheModeCycleCount, _GCOMMAND_NicheForceMode5Flag, _GCOMMAND_NicheWorkflowMode, _GCOMMAND_DigitalNicheListingsTemplatePtr
; DESC:
;   Parses a command/options string into global gcommand state.
; NOTES:
;   Tail bytes after parsed options are appended to
;   _GCOMMAND_DigitalNicheListingsTemplatePtr via _ESQPARS_ReplaceOwnedString.
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
    BSR.W   _FLIB2_LoadDigitalNicheDefaults

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
    JSR     _ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    LEA     16(A7),A7
    MOVE.L  D0,D7
    ADDQ.L  #2,D7
    MOVEQ   #2,D6
    CMP.L   D7,D6
    BGE.S   .opt2_start

    ; Opt0: casefolded Y/N flag -> _GCOMMAND_DigitalNicheEnabledFlag.
    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A0
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
    MOVE.B  D0,_GCOMMAND_DigitalNicheEnabledFlag

.opt1_done:
    ADDQ.L  #1,D6

.opt2_start:
    ; Opt1: digit 1..3 -> _GCOMMAND_NicheTextPen.
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

    MOVE.L  D4,_GCOMMAND_NicheTextPen

.opt2_done:
    ADDQ.L  #1,D6

.opt3_start:
    ; Opt2: numeric char via _LADFUNC_ParseHexDigit if valid (table bit #7) -> _GCOMMAND_NicheFramePen.
    CMP.L   D7,D6
    BGE.S   .opt4_start

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   .opt3_done

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     _LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,_GCOMMAND_NicheFramePen

.opt3_done:
    ADDQ.L  #1,D6

.opt4_start:
    ; Opt3: digit 1..3 -> _GCOMMAND_NicheEditorLayoutPen.
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

    MOVE.L  D4,_GCOMMAND_NicheEditorLayoutPen

.opt4_done:
    ADDQ.L  #1,D6

.opt5_start:
    ; Opt4: numeric char via _LADFUNC_ParseHexDigit if valid (table bit #7) -> _GCOMMAND_NicheEditorRowPen.
    CMP.L   D7,D6
    BGE.S   .opt6_start

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   .opt5_done

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     _LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,_GCOMMAND_NicheEditorRowPen

.opt5_done:
    ADDQ.L  #1,D6

.opt6_start:
    ; Opt5: casefolded mode flag (F/B/L/N) -> _GCOMMAND_NicheWorkflowMode.
    CMP.L   D7,D6
    BGE.S   .opt7_start

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A0
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
    MOVE.B  D0,_GCOMMAND_NicheWorkflowMode

.opt6_done:
    ADDQ.L  #1,D6

.opt7_start:
    ; Opt6: digit 0..9 with special-case '1' toggle -> _GCOMMAND_NicheModeCycleCount/_GCOMMAND_NicheForceMode5Flag.
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
    MOVE.L  D1,_GCOMMAND_NicheModeCycleCount
    MOVE.L  D0,_GCOMMAND_NicheForceMode5Flag
    BRA.S   .opt7_done

.opt7_not_one:
    TST.L   D4
    BMI.S   .opt7_done

    MOVEQ   #9,D1
    CMP.L   D1,D4
    BGT.S   .opt7_done

    MOVE.L  D4,_GCOMMAND_NicheModeCycleCount
    CLR.L   _GCOMMAND_NicheForceMode5Flag

.opt7_done:
    ADDQ.L  #1,D6

.tail_len_choose:
    ; Tail: append remaining substring to _GCOMMAND_DigitalNicheListingsTemplatePtr.
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

    MOVE.L  _GCOMMAND_DigitalNicheListingsTemplatePtr,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_GCOMMAND_DigitalNicheListingsTemplatePtr

.return:
    BSR.W   GCOMMAND_LoadCommandFile

    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_LoadMplexTemplate   (Load the Digital_Mplex template and stage it in _GCOMMAND_MplexListingsTemplatePtr/_GCOMMAND_MplexAtTemplatePtr.)
; ARGS:
;   stack +8: arg_1 (via 12(A5))
;   stack +12: arg_2 (via 16(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D7
; CALLS:
;   _GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold, _GROUP_AS_JMPTBL_STR_FindCharPtr, _GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer, _ESQPARS_ReplaceOwnedString, _NEWGRID_JMPTBL_MEMORY_DeallocateMemory, _LVOCopyMem
; READS:
;   AbsExecBase, _Global_REF_LONG_FILE_SCRATCH, _Global_STR_GCOMMAND_C_2, _GCOMMAND_PATH_DF0_COLON_DIGITAL_MPLEX_DOT_DAT_TemplateLoad, _GCOMMAND_FMT_PCT_T_MplexTemplateLoad, _Global_PTR_WORK_BUFFER, _GCOMMAND_DigitalMplexEnabledFlag, _GCOMMAND_MplexListingsTemplatePtr, _GCOMMAND_MplexAtTemplatePtr, return
; WRITES:
;   _Global_PTR_WORK_BUFFER, _GCOMMAND_MplexListingsTemplatePtr, _GCOMMAND_MplexAtTemplatePtr
; DESC:
;   Load the Digital_Mplex template and stage it in _GCOMMAND_MplexListingsTemplatePtr/_GCOMMAND_MplexAtTemplatePtr.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
GCOMMAND_LoadMplexTemplate:
    LINK.W  A5,#-16
    MOVE.L  D7,-(A7)
    PEA     _GCOMMAND_PATH_DF0_COLON_DIGITAL_MPLEX_DOT_DAT_TemplateLoad
    JSR     _GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BEQ.W   .return

    MOVEA.L _Global_PTR_WORK_BUFFER,A0
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,D7
    MOVE.L  A0,-4(A5)
    LEA     _GCOMMAND_DigitalMplexEnabledFlag,A1
    MOVEQ   #52,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    MOVEQ   #52,D0
    ADD.L   D0,_Global_PTR_WORK_BUFFER
    SUBA.L  A0,A0
    MOVE.L  A0,_GCOMMAND_MplexListingsTemplatePtr
    MOVE.L  A0,_GCOMMAND_MplexAtTemplatePtr
    PEA     18.W
    MOVE.L  _Global_PTR_WORK_BUFFER,-(A7)
    JSR     _GROUP_AS_JMPTBL_STR_FindCharPtr(PC)

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
    MOVE.L  _GCOMMAND_MplexAtTemplatePtr,-(A7)
    MOVE.L  _Global_PTR_WORK_BUFFER,-(A7)
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,_GCOMMAND_MplexAtTemplatePtr
    MOVE.L  _GCOMMAND_MplexListingsTemplatePtr,(A7)
    MOVE.L  -12(A5),-(A7)
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,_GCOMMAND_MplexListingsTemplatePtr
    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     575.W
    PEA     _Global_STR_GCOMMAND_C_2
    JSR     _NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     24(A7),A7
    CLR.L   -16(A5)
    TST.L   _GCOMMAND_MplexAtTemplatePtr
    BEQ.S   .check_suffix_slot

    MOVEA.L _GCOMMAND_MplexAtTemplatePtr,A0
    TST.B   (A0)
    BEQ.S   .check_suffix_slot

    PEA     _GCOMMAND_FMT_PCT_T_MplexTemplateLoad
    MOVE.L  A0,-(A7)
    JSR     _GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(PC)

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