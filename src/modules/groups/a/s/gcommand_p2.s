    XDEF    _GCOMMAND_ParsePPVCommand

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_ParsePPVCommand   (Parse a PPV command string into tokens/indices for execution.)
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
;   _ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, _GCOMMAND_LoadPPVTemplate, _GROUP_AS_JMPTBL_STR_FindCharPtr, _GROUP_AW_JMPTBL_STRING_CopyPadNul, _ESQPARS_ReplaceOwnedString, _FLIB2_LoadDigitalPpvDefaults, _LADFUNC_ParseHexDigit
; READS:
;   _GCOMMAND_PpvParseScratchSeedLong, _WDISP_CharClassTable, _GCOMMAND_PPVListingsTemplatePtr, _GCOMMAND_PPVPeriodTemplatePtr, return
; WRITES:
;   _GCOMMAND_DigitalPpvEnabledFlag, _GCOMMAND_PpvModeCycleCount, _GCOMMAND_PpvSelectionWindowMinutes, _GCOMMAND_PpvSelectionToleranceMinutes, _GCOMMAND_PpvMessageTextPen, _GCOMMAND_PpvMessageFramePen, _GCOMMAND_PpvEditorLayoutPen, _GCOMMAND_PpvEditorRowPen, _GCOMMAND_PpvShowtimesLayoutPen, _GCOMMAND_PpvShowtimesInitialLineIndex, _GCOMMAND_PpvShowtimesRowPen, _GCOMMAND_PpvShowtimesWorkflowMode, _GCOMMAND_PpvDetailLayoutFlag, _GCOMMAND_PPVListingsTemplatePtr, _GCOMMAND_PPVPeriodTemplatePtr, _GCOMMAND_PpvShowtimesRowSpan
; DESC:
;   Parse a PPV command string into tokens/indices for execution.
; NOTES:
;   Uses byte $12 as a split marker and clamps appended tail text to 127 bytes
;   before replacing/appending owned PPV template pointers.
;------------------------------------------------------------------------------
_GCOMMAND_ParsePPVCommand:
    LINK.W  A5,#-24
    MOVEM.L D2/D4-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D6
    LEA     _GCOMMAND_PpvParseScratchSeedLong,A0
    LEA     -12(A5),A1
    MOVE.B  (A0)+,(A1)+
    MOVE.B  (A0)+,(A1)+
    MOVE.B  (A0)+,(A1)+
    MOVE.B  (A0)+,(A1)+
    MOVEQ   #0,D5
    MOVEQ   #0,D4
    MOVE.B  #$12,-19(A5)
    CLR.L   -24(A5)
    BSR.W   _FLIB2_LoadDigitalPpvDefaults

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

    ; Opt0: casefolded Y/N flag -> _GCOMMAND_DigitalPpvEnabledFlag.
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
    MOVE.B  D0,_GCOMMAND_DigitalPpvEnabledFlag

.opt1_done:
    ADDQ.L  #1,D6

.opt2_start:
    ; Opt1: digit 0..9 -> _GCOMMAND_PpvModeCycleCount.
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

    MOVE.L  D4,_GCOMMAND_PpvModeCycleCount

.opt2_done:
    ADDQ.L  #1,D6

.opt3_start:
    ; Opt2: three-digit numeric (0..999) with digit validation -> _GCOMMAND_PpvSelectionWindowMinutes.
    CMP.L   D7,D6
    BGE.S   .opt4_start

    MOVE.B  0(A3,D6.L),-12(A5)
    MOVE.B  1(A3,D6.L),-11(A5)
    MOVE.B  2(A3,D6.L),-10(A5)
    CLR.B   -9(A5)
    PEA     -12(A5)
    JSR     _ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D4
    TST.L   D4
    BMI.S   .opt3_done

    CMPI.L  #$3e7,D4
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

    MOVE.L  D4,_GCOMMAND_PpvSelectionWindowMinutes

.opt3_done:
    ADDQ.L  #3,D6

.opt4_start:
    ; Opt3: three-digit numeric (0..999) with digit validation -> _GCOMMAND_PpvSelectionToleranceMinutes.
    CMP.L   D7,D6
    BGE.S   .opt5_start

    MOVE.B  0(A3,D6.L),-12(A5)
    MOVE.B  1(A3,D6.L),-11(A5)
    MOVE.B  2(A3,D6.L),-10(A5)
    CLR.B   -9(A5)
    PEA     -12(A5)
    JSR     _ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D4
    TST.L   D4
    BMI.S   .opt4_done

    CMPI.L  #$3e7,D4
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

    MOVE.B  -10(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   .opt4_done

    MOVE.L  D4,_GCOMMAND_PpvSelectionToleranceMinutes

.opt4_done:
    ADDQ.L  #3,D6

.opt5_start:
    ; Opt4: digit 1..3 -> _GCOMMAND_PpvMessageTextPen.
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

    MOVE.L  D4,_GCOMMAND_PpvMessageTextPen

.opt5_done:
    ADDQ.L  #1,D6

.opt6_start:
    ; Opt5: numeric char via _LADFUNC_ParseHexDigit if valid (table bit #7) -> _GCOMMAND_PpvMessageFramePen.
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
    MOVE.L  D1,_GCOMMAND_PpvMessageFramePen

.opt6_done:
    ADDQ.L  #1,D6

.opt7_start:
    ; Opt6: digit 1..3 -> _GCOMMAND_PpvEditorLayoutPen.
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

    MOVE.L  D4,_GCOMMAND_PpvEditorLayoutPen

.opt7_done:
    ADDQ.L  #1,D6

.opt8_start:
    ; Opt7: numeric char via _LADFUNC_ParseHexDigit if valid (table bit #7) -> _GCOMMAND_PpvEditorRowPen.
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
    MOVE.L  D1,_GCOMMAND_PpvEditorRowPen

.opt8_done:
    ADDQ.L  #1,D6

.opt9_start:
    ; Opt8: digit 1..3 -> _GCOMMAND_PpvShowtimesLayoutPen.
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

    MOVE.L  D4,_GCOMMAND_PpvShowtimesLayoutPen

.opt9_done:
    ADDQ.L  #1,D6

.opt10_start:
    ; Opt9: digit 1..3 -> _GCOMMAND_PpvShowtimesInitialLineIndex.
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

    MOVE.L  D4,_GCOMMAND_PpvShowtimesInitialLineIndex

.opt10_done:
    ADDQ.L  #1,D6

.opt11_start:
    ; Opt10: numeric char via _LADFUNC_ParseHexDigit if valid (table bit #7) -> _GCOMMAND_PpvShowtimesRowPen.
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
    MOVE.L  D1,_GCOMMAND_PpvShowtimesRowPen

.opt11_done:
    ADDQ.L  #1,D6

.opt12_start:
    ; Opt11: casefolded mode flag (F/B/L/N) -> _GCOMMAND_PpvShowtimesWorkflowMode.
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
    MOVE.B  D0,_GCOMMAND_PpvShowtimesWorkflowMode

.opt12_done:
    ADDQ.L  #1,D6

.opt13_start:
    ; Opt12: casefolded Y/N flag -> _GCOMMAND_PpvDetailLayoutFlag.
    CMP.L   D7,D6
    BGE.S   .opt14_start

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
    MOVE.B  D0,_GCOMMAND_PpvDetailLayoutFlag

.opt13_done:
    ADDQ.L  #1,D6

.opt14_start:
    ; Opt13: two-char numeric (uncertain) -> _GCOMMAND_PpvShowtimesRowSpan.
    CMP.L   D7,D6
    BGE.S   .tail_len_choose

    MOVEA.L A3,A0
    ADDA.L  D6,A0
    PEA     2.W
    MOVE.L  A0,-(A7)
    PEA     -12(A5)
    JSR     _GROUP_AW_JMPTBL_STRING_CopyPadNul(PC)

    CLR.B   -10(A5)
    PEA     -12(A5)
    JSR     _ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    LEA     16(A7),A7
    MOVE.L  D0,D4
    TST.L   D4
    BPL.S   .opt14_store

    MOVEQ   #96,D0
    CMP.L   D0,D4
    BGT.S   .opt14_done

.opt14_store:
    MOVE.L  D4,_GCOMMAND_PpvShowtimesRowSpan

.opt14_done:
    ADDQ.L  #2,D6

.tail_len_choose:
    ; Tail: append remaining substring to _GCOMMAND_PPVPeriodTemplatePtr/_GCOMMAND_PPVListingsTemplatePtr.
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
    JSR     _GROUP_AS_JMPTBL_STR_FindCharPtr(PC)

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
    ; Append clamped tail to _GCOMMAND_PPVPeriodTemplatePtr.
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
    MOVE.L  _GCOMMAND_PPVPeriodTemplatePtr,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_GCOMMAND_PPVPeriodTemplatePtr

.append_tail_to_f2:
    ; Append split buffer to _GCOMMAND_PPVListingsTemplatePtr if present.
    TST.L   -24(A5)
    BEQ.S   .return

    MOVEA.L -24(A5),A0
    TST.B   (A0)
    BEQ.S   .return

    MOVE.L  _GCOMMAND_PPVListingsTemplatePtr,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_GCOMMAND_PPVListingsTemplatePtr
    BRA.S   .return

.append_tail_fallback:
    ; Fallback: append tail to _GCOMMAND_PPVPeriodTemplatePtr without split buffer.
    TST.B   0(A3,D7.L)
    BEQ.S   .return

    MOVEA.L A3,A0
    ADDA.L  D6,A0
    MOVE.L  _GCOMMAND_PPVPeriodTemplatePtr,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_GCOMMAND_PPVPeriodTemplatePtr

.return:
    BSR.W   _GCOMMAND_LoadPPVTemplate

    MOVEM.L (A7)+,D2/D4-D7/A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD
