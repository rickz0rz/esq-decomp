    XDEF    _GCOMMAND_ParseCommandString


;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_ParseCommandString   (Parse a command line into token flags, returning indices for gcommand execution.)
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
;   _ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, _GCOMMAND_LoadMplexFile, _GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold, _GROUP_AS_JMPTBL_STR_FindCharPtr, _GROUP_AW_JMPTBL_STRING_CopyPadNul, _ESQPARS_ReplaceOwnedString, _FLIB2_LoadDigitalMplexDefaults, _LADFUNC_ParseHexDigit
; READS:
;   _GCOMMAND_MplexParseScratchSeedWord, _GCOMMAND_FMT_PCT_T_MplexTemplateParse, _WDISP_CharClassTable, _GCOMMAND_MplexListingsTemplatePtr, _GCOMMAND_MplexAtTemplatePtr, after_tail_append, return
; WRITES:
;   _GCOMMAND_DigitalMplexEnabledFlag, _GCOMMAND_MplexModeCycleCount, _GCOMMAND_MplexSearchRowLimit, _GCOMMAND_MplexClockOffsetMinutes, _GCOMMAND_MplexMessageTextPen, _GCOMMAND_MplexMessageFramePen, _GCOMMAND_MplexEditorLayoutPen, _GCOMMAND_MplexEditorRowPen, _GCOMMAND_MplexDetailLayoutPen, _GCOMMAND_MplexDetailInitialLineIndex, _GCOMMAND_MplexDetailRowPen, _GCOMMAND_MplexWorkflowMode, _GCOMMAND_MplexDetailLayoutFlag, _GCOMMAND_MplexListingsTemplatePtr, _GCOMMAND_MplexAtTemplatePtr
; DESC:
;   Parse a command line into token flags, returning indices for gcommand execution.
; NOTES:
;   Uses byte $12 as a split marker and clamps appended tail text to 127 bytes
;   before replacing/appending owned template pointers.
;------------------------------------------------------------------------------
_GCOMMAND_ParseCommandString:
    LINK.W  A5,#-28
    MOVEM.L D2/D4-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D6
    LEA     _GCOMMAND_MplexParseScratchSeedWord,A0
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
    BSR.W   _FLIB2_LoadDigitalMplexDefaults

    MOVE.L  A3,D0
    BEQ.W   .return

    TST.B   (A3)
    BEQ.W   .return

    PEA     2.W
    MOVE.L  A3,-(A7)
    PEA     -12(A5)
    JSR     _GROUP_AW_JMPTBL_STRING_CopyPadNul(PC)

    CLR.B   -10(A5)
    PEA     -12(A5)
    JSR     _ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    LEA     16(A7),A7
    MOVE.L  D0,D7
    ADDQ.L  #2,D7
    MOVEQ   #2,D6
    CMP.L   D7,D6
    BGE.S   .opt2_start

    ; Opt0: casefolded Y/N flag -> _GCOMMAND_DigitalMplexEnabledFlag.
    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A0
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
    MOVE.B  D0,_GCOMMAND_DigitalMplexEnabledFlag

.opt1_done:
    ADDQ.L  #1,D6

.opt2_start:
    ; Opt1: digit 0..9 -> _GCOMMAND_MplexModeCycleCount.
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

    MOVE.L  D4,_GCOMMAND_MplexModeCycleCount

.opt2_done:
    ADDQ.L  #1,D6

.opt3_start:
    ; Opt2: two-digit numeric (0..99) with digit validation -> _GCOMMAND_MplexSearchRowLimit.
    CMP.L   D7,D6
    BGE.S   .opt4_start

    MOVE.B  0(A3,D6.L),-12(A5)
    MOVE.B  1(A3,D6.L),-11(A5)
    CLR.B   -10(A5)
    PEA     -12(A5)
    JSR     _ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

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
    LEA     _WDISP_CharClassTable,A0
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

    MOVE.L  D4,_GCOMMAND_MplexSearchRowLimit

.opt3_done:
    ADDQ.L  #2,D6

.opt4_start:
    ; Opt3: two-digit numeric (0..29) with digit validation -> _GCOMMAND_MplexClockOffsetMinutes.
    CMP.L   D7,D6
    BGE.S   .opt5_start

    MOVE.B  0(A3,D6.L),-12(A5)
    MOVE.B  1(A3,D6.L),-11(A5)
    CLR.B   -10(A5)
    PEA     -12(A5)
    JSR     _ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

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
    LEA     _WDISP_CharClassTable,A0
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

    MOVE.L  D4,_GCOMMAND_MplexClockOffsetMinutes

.opt4_done:
    ADDQ.L  #2,D6

.opt5_start:
    ; Opt4: digit 1..3 -> _GCOMMAND_MplexMessageTextPen.
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

    MOVE.L  D4,_GCOMMAND_MplexMessageTextPen

.opt5_done:
    ADDQ.L  #1,D6

.opt6_start:
    ; Opt5: numeric char via _LADFUNC_ParseHexDigit if valid (table bit #7) -> _GCOMMAND_MplexMessageFramePen.
    CMP.L   D7,D6
    BGE.S   .opt7_start

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   .opt6_done

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     _LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,_GCOMMAND_MplexMessageFramePen

.opt6_done:
    ADDQ.L  #1,D6

.opt7_start:
    ; Opt6: digit 1..3 -> _GCOMMAND_MplexEditorLayoutPen.
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

    MOVE.L  D4,_GCOMMAND_MplexEditorLayoutPen

.opt7_done:
    ADDQ.L  #1,D6

.opt8_start:
    ; Opt7: numeric char via _LADFUNC_ParseHexDigit if valid (table bit #7) -> _GCOMMAND_MplexEditorRowPen.
    CMP.L   D7,D6
    BGE.S   .opt9_start

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   .opt8_done

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     _LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,_GCOMMAND_MplexEditorRowPen

.opt8_done:
    ADDQ.L  #1,D6

.opt9_start:
    ; Opt8: digit 1..3 -> _GCOMMAND_MplexDetailLayoutPen.
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

    MOVE.L  D4,_GCOMMAND_MplexDetailLayoutPen

.opt9_done:
    ADDQ.L  #1,D6

.opt10_start:
    ; Opt9: digit 1..3 -> _GCOMMAND_MplexDetailInitialLineIndex.
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

    MOVE.L  D4,_GCOMMAND_MplexDetailInitialLineIndex

.opt10_done:
    ADDQ.L  #1,D6

.opt11_start:
    ; Opt10: numeric char via _LADFUNC_ParseHexDigit if valid (table bit #7) -> _GCOMMAND_MplexDetailRowPen.
    CMP.L   D7,D6
    BGE.S   .opt12_start

    MOVE.B  0(A3,D6.L),D5
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   .opt11_done

    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     _LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,_GCOMMAND_MplexDetailRowPen

.opt11_done:
    ADDQ.L  #1,D6

.opt12_start:
    ; Opt11: casefolded mode flag (F/B/L/N) -> _GCOMMAND_MplexWorkflowMode.
    CMP.L   D7,D6
    BGE.S   .opt13_start

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A0
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
    MOVE.B  D0,_GCOMMAND_MplexWorkflowMode

.opt12_done:
    ADDQ.L  #1,D6

.opt13_start:
    ; Opt12: casefolded Y/N flag -> _GCOMMAND_MplexDetailLayoutFlag.
    CMP.L   D7,D6
    BGE.S   .tail_len_choose

    MOVE.B  0(A3,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A0
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
    MOVE.B  D0,_GCOMMAND_MplexDetailLayoutFlag

.opt13_done:
    ADDQ.L  #1,D6

.tail_len_choose:
    ; Tail: append remaining substring to _GCOMMAND_MplexAtTemplatePtr/_GCOMMAND_MplexListingsTemplatePtr.
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
    JSR     _GROUP_AS_JMPTBL_STR_FindCharPtr(PC)

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
    ; Append the clamped tail to _GCOMMAND_MplexAtTemplatePtr.
    MOVEA.L A3,A0
    ADDA.L  D7,A0
    TST.B   (A0)
    BEQ.S   .append_tail_to_e3

    MOVE.L  _GCOMMAND_MplexAtTemplatePtr,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_GCOMMAND_MplexAtTemplatePtr

.append_tail_to_e3:
    ; If the split buffer is non-empty, append to _GCOMMAND_MplexListingsTemplatePtr.
    TST.L   -24(A5)
    BEQ.S   .after_tail_append

    MOVEA.L -24(A5),A0
    TST.B   (A0)
    BEQ.S   .after_tail_append

    MOVE.L  _GCOMMAND_MplexListingsTemplatePtr,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_GCOMMAND_MplexListingsTemplatePtr
    BRA.S   .after_tail_append

.append_e3_only:
    ; If split buffer allocation failed, only append tail to _GCOMMAND_MplexAtTemplatePtr.
    MOVEA.L A3,A0
    ADDA.L  D7,A0
    TST.B   (A0)
    BEQ.S   .after_tail_append

    MOVE.L  _GCOMMAND_MplexAtTemplatePtr,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_GCOMMAND_MplexAtTemplatePtr

.after_tail_append:
    CLR.L   -28(A5)
    TST.L   _GCOMMAND_MplexAtTemplatePtr
    BEQ.S   .check_suffix_slot

    MOVEA.L _GCOMMAND_MplexAtTemplatePtr,A0
    TST.B   (A0)
    BEQ.S   .check_suffix_slot

    PEA     _GCOMMAND_FMT_PCT_T_MplexTemplateParse
    MOVE.L  A0,-(A7)
    JSR     _GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-28(A5)

.check_suffix_slot:
    TST.L   -28(A5)
    BEQ.S   .return

    MOVEA.L -28(A5),A0
    TST.B   (A0)
    BEQ.S   .return

    MOVE.L  A0,D0
    SUB.L   _GCOMMAND_MplexAtTemplatePtr,D0
    MOVE.L  D0,D4
    ADDQ.L  #1,D4
    MOVEA.L _GCOMMAND_MplexAtTemplatePtr,A0
    ADDA.L  D4,A0
    MOVE.B  #$73,(A0)

.return:
    BSR.W   _GCOMMAND_LoadMplexFile

    MOVEM.L (A7)+,D2/D4-D7/A2-A3
    UNLK    A5
    RTS

;!======