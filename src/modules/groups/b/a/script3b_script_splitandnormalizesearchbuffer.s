    XDEF    _SCRIPT_SplitAndNormalizeSearchBuffer



;------------------------------------------------------------------------------
; FUNC: _SCRIPT_SplitAndNormalizeSearchBuffer   (SplitAndNormalizeSearchBuffer)
; ARGS:
;   stack +16: parseBuffer (char *)
;   stack +20: parseLen (long)
; RET:
;   D0: none
; CLOBBERS:
;   A0/A1/A3/A7/D0/D6/D7
; CALLS:
;   _SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters
; READS:
;   _TEXTDISP_PrimarySearchText, _TEXTDISP_SecondarySearchText, c8
; WRITES:
;   _TEXTDISP_PrimarySearchText, _TEXTDISP_SecondarySearchText
; DESC:
;   Splits raw search text around delimiter 18 and copies primary/secondary
;   portions into dedicated buffers.
; NOTES:
;   Calls _SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters with max length 128 for non-empty strings.
;------------------------------------------------------------------------------
_SCRIPT_SplitAndNormalizeSearchBuffer:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVE.L  20(A7),D7
    MOVEQ   #18,D0
    CMP.B   1(A3),D0
    BNE.S   .split_search_check_trailing_delimiter

    LEA     2(A3),A0
    LEA     _TEXTDISP_SecondarySearchText,A1

.split_search_copy_secondary_only:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .split_search_copy_secondary_only

    MOVEQ   #0,D0
    MOVE.B  D0,_TEXTDISP_PrimarySearchText
    BRA.S   .split_search_filter_primary

.split_search_check_trailing_delimiter:
    CMP.B   -1(A3,D7.L),D0
    BNE.S   .split_search_find_mid_delimiter

    CLR.B   -1(A3,D7.L)
    LEA     1(A3),A0
    LEA     _TEXTDISP_PrimarySearchText,A1

.split_search_copy_primary_only:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .split_search_copy_primary_only

    CLR.B   _TEXTDISP_SecondarySearchText
    BRA.S   .split_search_filter_primary

.split_search_find_mid_delimiter:
    MOVEQ   #1,D6

.split_search_find_mid_delimiter_loop:
    MOVEQ   #18,D0
    CMP.B   0(A3,D6.W),D0
    BEQ.S   .split_search_split_at_delimiter

    CMPI.W  #$c8,D6
    BGE.S   .split_search_split_at_delimiter

    ADDQ.W  #1,D6
    BRA.S   .split_search_find_mid_delimiter_loop

.split_search_split_at_delimiter:
    CLR.B   0(A3,D6.W)
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     1(A0),A1
    LEA     _TEXTDISP_SecondarySearchText,A0

.split_search_copy_secondary_part:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .split_search_copy_secondary_part

    LEA     1(A3),A0
    LEA     _TEXTDISP_PrimarySearchText,A1

.split_search_copy_primary_part:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .split_search_copy_primary_part

.split_search_filter_primary:
    LEA     _TEXTDISP_PrimarySearchText,A0
    MOVE.L  A0,D0
    BEQ.S   .split_search_filter_secondary

    TST.B   _TEXTDISP_PrimarySearchText
    BEQ.S   .split_search_filter_secondary

    PEA     128.W
    MOVE.L  A0,-(A7)
    JSR     _SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(PC)

    ADDQ.W  #8,A7

.split_search_filter_secondary:
    LEA     _TEXTDISP_SecondarySearchText,A0
    MOVE.L  A0,D0
    BEQ.S   .return

    TST.B   _TEXTDISP_SecondarySearchText
    BEQ.S   .return

    PEA     128.W
    MOVE.L  A0,-(A7)
    JSR     _SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(PC)

    ADDQ.W  #8,A7

.return:
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======