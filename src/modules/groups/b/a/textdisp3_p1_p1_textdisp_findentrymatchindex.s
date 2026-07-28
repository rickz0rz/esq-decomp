    XDEF    _TEXTDISP_FindEntryMatchIndex



;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_FindEntryMatchIndex   (Find entry index by text match)
; ARGS:
;   stack +8: textPtr
;   stack +14: mode (word, 1/2/3)
;   stack +19: requiredFlagsMask (byte)
; RET:
;   D0: entry index (0..48) or 49 if not found
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _TEXTDISP_FindControlToken, _TEXTDISP_FindQuotedSpan,
;   _TLIBA1_JMPTBL_DISPLIB_FindPreviousValidEntryIndex, _TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode, _TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode,
;   _TLIBA2_JMPTBL_ESQ_TestBit1Based, _STRING_CompareNoCase,
;   _TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold
; READS:
;   _TEXTDISP_ActiveGroupId, _TEXTDISP_CurrentMatchIndex, _TEXTDISP_PrimaryEntryPtrTable/2235/2236/2237, _WDISP_CharClassTable
; DESC:
;   Scans entries for a name match using optional control tokens and
;   case-insensitive comparisons. Supports forward/backward modes.
; NOTES:
;   Returns 49 when input is empty or no match is found.
;------------------------------------------------------------------------------
_TEXTDISP_FindEntryMatchIndex:
    LINK.W  A5,#-56
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVE.W  14(A5),D7
    MOVE.B  19(A5),D6
    MOVEQ   #0,D0
    SUBA.L  A0,A0
    MOVE.L  A0,-34(A5)
    MOVE.L  A0,-38(A5)
    MOVE.L  D0,-22(A5)
    MOVE.L  D0,-18(A5)
    MOVEA.L 8(A5),A0
    TST.B   (A0)
    BNE.S   .have_input

    MOVEQ   #49,D0
    BRA.W   .return

.have_input:
    MOVE.W  _TEXTDISP_ActiveGroupId,D0
    SUBQ.W  #1,D0
    BNE.S   .select_group_default

    MOVEQ   #0,D0
    MOVE.W  _CLOCK_HalfHourSlotIndex,D0
    BRA.S   .store_group_count

.select_group_default:
    MOVEQ   #1,D0

.store_group_count:
    MOVE.L  D0,D5
    MOVE.W  _TEXTDISP_ActiveGroupId,D0
    SUBQ.W  #1,D0
    BNE.S   .load_group2_tables

    MOVE.W  _TEXTDISP_CurrentMatchIndex,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    JSR     _TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    MOVEA.L D0,A3
    MOVE.W  _TEXTDISP_CurrentMatchIndex,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    JSR     _TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A2
    BRA.S   .dispatch_mode

.load_group2_tables:
    MOVE.W  _TEXTDISP_CurrentMatchIndex,D0
    EXT.L   D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    JSR     _TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    MOVEA.L D0,A3
    MOVE.W  _TEXTDISP_CurrentMatchIndex,D0
    EXT.L   D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    JSR     _TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A2

.dispatch_mode:
    MOVEQ   #2,D0
    CMP.W   D0,D7
    BNE.S   .mode_forward

    MOVE.W  _TEXTDISP_ActiveGroupId,D0
    SUBQ.W  #1,D0
    BNE.S   .group1_count

    MOVEQ   #0,D0
    MOVE.W  _CLOCK_HalfHourSlotIndex,D0
    ADDQ.L  #1,D0
    BRA.S   .store_group1_count

.group1_count:
    MOVEQ   #1,D0

.store_group1_count:
    MOVE.L  D0,D5
    BRA.W   .begin_scan

.mode_forward:
    MOVEQ   #1,D0
    CMP.W   D0,D7
    BNE.S   .mode_backward

    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A2,-(A7)
    JSR     _TLIBA1_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5
    TST.W   D5
    BEQ.S   .mode_forward_fallback

    BTST    #7,7(A3,D5.W)
    BEQ.S   .begin_scan

.mode_forward_fallback:
    MOVE.W  _TEXTDISP_ActiveGroupId,D0
    SUBQ.W  #1,D0
    BNE.S   .mode_forward_group2_count

    MOVEQ   #0,D0
    MOVE.W  _CLOCK_HalfHourSlotIndex,D0
    BRA.S   .mode_forward_store_default

.mode_forward_group2_count:
    MOVEQ   #1,D0

.mode_forward_store_default:
    MOVE.L  D0,D5
    BRA.S   .begin_scan

.mode_backward:
    MOVEQ   #3,D0
    CMP.W   D0,D7
    BNE.S   .mode_default

    MOVE.L  D5,D0
    EXT.L   D0
    SUBQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A2,-(A7)
    JSR     _TLIBA1_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5
    TST.W   D5
    BEQ.S   .mode_backward_fallback

    BTST    #7,7(A3,D5.W)
    BEQ.S   .begin_scan

.mode_backward_fallback:
    MOVE.W  _TEXTDISP_ActiveGroupId,D0
    SUBQ.W  #1,D0
    BNE.S   .mode_backward_group2_count

    MOVEQ   #0,D0
    MOVE.W  _CLOCK_HalfHourSlotIndex,D0
    BRA.S   .mode_backward_store_default

.mode_backward_group2_count:
    MOVEQ   #1,D0

.mode_backward_store_default:
    MOVE.L  D0,D5
    BRA.S   .begin_scan

.mode_default:
    MOVEQ   #1,D5

.begin_scan:
    MOVE.L  8(A5),-(A7)
    BSR.W   _TEXTDISP_FindControlToken

    PEA     -26(A5)
    MOVE.L  D0,-(A7)
    PEA     -34(A5)
    MOVE.L  8(A5),-(A7)
    MOVE.L  D0,-52(A5)
    BSR.W   _TEXTDISP_FindQuotedSpan

    LEA     20(A7),A7
    MOVEA.L -34(A5),A0
    ADDA.L  D0,A0
    MOVE.B  (A0),D1
    CLR.B   (A0)
    MOVE.L  D0,-44(A5)
    MOVE.B  D1,-39(A5)

.scan_loop:
    MOVEQ   #49,D0
    CMP.W   D0,D5
    BGE.W   .restore_input_char

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    TST.L   56(A3,D0.L)
    BEQ.W   .next_entry

    MOVE.B  7(A3,D5.W),D0
    AND.B   D6,D0
    CMP.B   D6,D0
    BNE.W   .next_entry

    LEA     28(A2),A0
    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _TLIBA2_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   .next_entry

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L 56(A3,D0.L),A0
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-14(A5)
    BSR.W   _TEXTDISP_FindControlToken

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.L  D0,-56(A5)
    MOVE.L  D1,-18(A5)
    MOVE.L  D1,-22(A5)
    TST.L   -52(A5)
    BNE.S   .compare_control_token

    MOVEQ   #1,D1
    MOVE.L  D1,-22(A5)
    BRA.S   .compare_entry_text

.compare_control_token:
    TST.L   D0
    BEQ.S   .compare_entry_text

    MOVEA.L -52(A5),A0
    MOVE.B  (A0),D1
    MOVEA.L D0,A0
    CMP.B   (A0),D1
    BNE.S   .compare_entry_text

    MOVEQ   #1,D1
    MOVE.L  D1,-22(A5)

.compare_entry_text:
    MOVEQ   #1,D1
    CMP.L   -22(A5),D1
    BNE.W   .check_match

    PEA     -30(A5)
    MOVE.L  D0,-(A7)
    PEA     -38(A5)
    MOVE.L  -14(A5),-(A7)
    BSR.W   _TEXTDISP_FindQuotedSpan

    LEA     16(A7),A7
    MOVEA.L -38(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.B  (A1),D1
    CLR.B   (A1)
    MOVE.L  D0,-48(A5)
    MOVE.B  D1,-40(A5)
    TST.L   -26(A5)
    BEQ.S   .substring_match

    TST.L   -30(A5)
    BEQ.S   .restore_entry_char

    MOVE.L  -44(A5),D1
    CMP.L   D0,D1
    BNE.S   .restore_entry_char

    MOVE.L  -38(A5),-(A7)
    MOVE.L  -34(A5),-(A7)
    JSR     _STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    SEQ     D1
    NEG.B   D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,-18(A5)
    BRA.S   .restore_entry_char

.substring_match:
    MOVE.L  -44(A5),D1
    CMP.L   D0,D1
    BGT.S   .restore_entry_char

    MOVE.L  -34(A5),-(A7)
    MOVE.L  -38(A5),-(A7)
    JSR     _TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    SNE     D1
    NEG.B   D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,-18(A5)

.restore_entry_char:
    MOVEA.L -38(A5),A0
    ADDA.L  -48(A5),A0
    MOVE.B  -40(A5),D0
    MOVE.B  D0,(A0)

.check_match:
    TST.L   -18(A5)
    BEQ.S   .next_entry

    TST.L   -22(A5)
    BNE.S   .restore_input_char

.next_entry:
    ADDQ.W  #1,D5
    BRA.W   .scan_loop

.restore_input_char:
    MOVEA.L -34(A5),A0
    ADDA.L  -44(A5),A0
    MOVE.B  -39(A5),D0
    MOVE.B  D0,(A0)
    MOVE.L  D5,D0

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======