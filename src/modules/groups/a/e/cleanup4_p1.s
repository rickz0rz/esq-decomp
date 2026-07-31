    XDEF    _CLEANUP_FormatEntryStringTokens



;------------------------------------------------------------------------------
; FUNC: _CLEANUP_FormatEntryStringTokens   (FormatEntryStringTokensuncertain)
; ARGS:
;   stack +4: outPtr1 (char**)
;   stack +8: outPtr2 (char**)
;   stack +12: inText (char*)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _GROUP_AI_JMPTBL_STR_FindCharPtr, _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString
; READS:
;   CLOCK_STR_TOKEN_PAIR_DEFAULTS, CLEANUP_TokenPairScratch, CLOCK_STR_TOKEN_OUTPUT_TEMPLATE, _WDISP_CharClassTable
; WRITES:
;   outPtr1/outPtr2 contents
; DESC:
;   Formats an input text string, applying a small token/jumptable filter,
;   and stores the results into two output buffers.
; NOTES:
;   - Uses a switch/jumptable to handle special token bytes.
;------------------------------------------------------------------------------
_CLEANUP_FormatEntryStringTokens:
    LINK.W  A5,#-32
    MOVEM.L D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    TST.L   16(A5)
    BEQ.W   .empty_input

    MOVEA.L 16(A5),A0
    TST.B   (A0)
    BEQ.W   .empty_input

    PEA     58.W
    MOVE.L  A0,-(A7)
    JSR     _GROUP_AI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-26(A5)
    TST.L   D0
    BEQ.W   .empty_input

    LEA     CLOCK_STR_TOKEN_PAIR_DEFAULTS,A0
    LEA     -22(A5),A1
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.W  (A0),(A1)+
    CLR.B   (A1)
    LEA     CLEANUP_TokenPairScratch,A0
    LEA     -11(A5),A1

.copy_prefix_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_prefix_loop

    MOVEQ   #0,D7

.scan_input_loop:
    MOVEQ   #5,D0
    CMP.L   D0,D7
    BGE.S   .after_scan

    MOVEQ   #58,D0
    MOVEA.L 16(A5),A0
    CMP.B   0(A0,D7.L),D0
    BEQ.S   .after_scan

    MOVE.B  0(A0,D7.L),-11(A5,D7.L)
    ADDQ.L  #1,D7
    BRA.S   .scan_input_loop

.after_scan:
    CLR.B   -11(A5,D7.L)
    MOVE.L  (A3),-(A7)
    PEA     -11(A5)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,(A3)
    LEA     CLOCK_STR_TOKEN_OUTPUT_TEMPLATE,A0
    LEA     -11(A5),A1

.copy_suffix_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_suffix_loop

    ADDQ.L  #1,-26(A5)
    MOVEQ   #0,D7

.token_loop:
    MOVEQ   #10,D0
    CMP.L   D0,D7
    BGE.W   .commit_output

    MOVEA.L -26(A5),A0
    TST.B   0(A0,D7.L)
    BEQ.W   .commit_output

    MOVE.L  D7,D0
    CMPI.L  #$9,D0
    BCC.W   .next_token

    ADD.W   D0,D0
    MOVE.W  .token_table(PC,D0.W),D0
    JMP     .token_table+2(PC,D0.W)

; switch/jumptable
.token_table:
	DC.W    .case_alpha_or_copy-.token_table-2
    DC.W    .case_alpha_or_copy-.token_table-2
	DC.W    .case_alpha_or_copy-.token_table-2
    DC.W    .case_alpha_or_copy-.token_table-2
	DC.W    .case_alpha_or_copy-.token_table-2
    DC.W    .case_alpha_or_copy-.token_table-2
	DC.W    .case_flag7_check-.token_table-2
    DC.W    .case_flag7_check-.token_table-2
    DC.W    .case_pair_check-.token_table-2

.case_alpha_or_copy:
    MOVEA.L -26(A5),A0
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     CLOCK_STR_BOOL_CHARS_YyNn
    JSR     _GROUP_AI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .use_default_char

    MOVEA.L -26(A5),A0
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #1,(A1)
    BEQ.S   .copy_raw_char

    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .store_token_char

.copy_raw_char:
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0

.store_token_char:
    MOVE.B  D0,-11(A5,D7.L)
    BRA.W   .next_token

.use_default_char:
    MOVE.B  -22(A5,D7.L),-11(A5,D7.L)
    BRA.W   .next_token

.case_flag7_check:
    MOVEA.L -26(A5),A0
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #7,(A0)
    BEQ.S   .use_default_char_flag7

    MOVEA.L -26(A5),A0
    MOVE.B  0(A0,D7.L),-11(A5,D7.L)
    BRA.W   .next_token

.use_default_char_flag7:
    MOVE.B  -22(A5,D7.L),-11(A5,D7.L)
    BRA.W   .next_token

.case_pair_check:
    MOVEA.L -26(A5),A0
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A1
    MOVEA.L A1,A6
    ADDA.L  D0,A6
    MOVEQ   #7,D0
    AND.B   (A6),D0
    TST.B   D0
    BEQ.S   .copy_default_pair

    MOVE.B  1(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A1,A6
    ADDA.L  D0,A6
    MOVEQ   #7,D0
    AND.B   (A6),D0
    TST.B   D0
    BEQ.S   .copy_default_pair

    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A1,A6
    ADDA.L  D0,A6
    BTST    #1,(A6)
    BEQ.S   .copy_pair_char1

    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .store_pair_char1

.copy_pair_char1:
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0

.store_pair_char1:
    MOVE.B  D0,-11(A5,D7.L)
    ADDQ.L  #1,D7
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    ADDA.L  D0,A1
    BTST    #1,(A1)
    BEQ.S   .copy_pair_char2

    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .store_pair_char2

.copy_pair_char2:
    MOVE.B  0(A0,D7.L),D0
    EXT.W   D0
    EXT.L   D0

.store_pair_char2:
    MOVE.B  D0,-11(A5,D7.L)
    BRA.S   .next_token

.copy_default_pair:
    LEA     -11(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D7,A1
    MOVEA.L D7,A6
    ADDQ.L  #1,D7
    MOVE.L  A6,D0
    MOVE.B  -22(A5,D0.L),(A1)
    MOVE.B  -22(A5,D7.L),-11(A5,D7.L)

.next_token:
    ADDQ.L  #1,D7
    BRA.W   .token_loop

.commit_output:
    MOVE.L  (A2),-(A7)
    PEA     -11(A5)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,(A2)
    BRA.S   .done

.empty_input:
    MOVE.L  (A3),-(A7)
    CLR.L   -(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,(A3)
    MOVE.L  (A2),(A7)
    PEA     CLOCK_STR_EMPTY_TOKEN_TEMPLATE
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     12(A7),A7
    MOVE.L  D0,(A2)

.done:
    MOVEM.L (A7)+,D7/A2-A3/A6
    UNLK    A5
    RTS

;!======