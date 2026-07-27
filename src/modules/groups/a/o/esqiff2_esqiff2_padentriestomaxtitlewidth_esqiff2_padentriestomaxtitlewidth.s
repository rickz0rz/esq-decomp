    XDEF    _ESQIFF2_PadEntriesToMaxTitleWidth
    XDEF    ESQIFF2_PadEntriesToMaxTitleWidth_Return



;------------------------------------------------------------------------------
; FUNC: _ESQIFF2_PadEntriesToMaxTitleWidth   (Pad entry labels to max title width for selected group)
; ARGS:
;   stack +7: arg_1 (via 11(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +20: arg_3 (via 24(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   _GROUP_AR_JMPTBL_STRING_AppendAtNull
; READS:
;   _TEXTDISP_SecondaryGroupCode, _TEXTDISP_SecondaryGroupEntryCount, _TEXTDISP_PrimaryGroupCode, _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryEntryPtrTable, _TEXTDISP_SecondaryEntryPtrTable, _TEXTDISP_MaxEntryTitleLength
; WRITES:
;   (none observed)
; DESC:
;   For each entry in the selected group, computes current title length and appends
;   spaces so titles reach _TEXTDISP_MaxEntryTitleLength.
; NOTES:
;   Uses a stack-local space buffer and _GROUP_AR_JMPTBL_STRING_AppendAtNull.
;------------------------------------------------------------------------------
_ESQIFF2_PadEntriesToMaxTitleWidth:
    LINK.W  A5,#-24
    MOVEM.L D4-D7,-(A7)
    MOVE.B  11(A5),D7
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D0
    CMP.B   D7,D0
    BNE.S   .check_primary_group_match

    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    MOVE.W  D0,-12(A5)
    BRA.S   .start_entry_padding_loop

.check_primary_group_match:
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D0
    CMP.B   D0,D7
    BNE.S   .return_group_not_matched

    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.W  D0,-12(A5)
    BRA.S   .start_entry_padding_loop

.return_group_not_matched:
    MOVEQ   #0,D0
    BRA.W   ESQIFF2_PadEntriesToMaxTitleWidth_Return

.start_entry_padding_loop:
    MOVEQ   #0,D6

.loop_entries_for_padding:
    CMP.W   -12(A5),D6
    BGE.W   ESQIFF2_PadEntriesToMaxTitleWidth_Return

    MOVE.B  _TEXTDISP_SecondaryGroupCode,D0
    CMP.B   D0,D7
    BNE.S   .load_primary_entry_pointer

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    BRA.S   .measure_current_title_length

.load_primary_entry_pointer:
    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)

.measure_current_title_length:
    MOVEA.L -4(A5),A0
    ADDQ.L  #1,A0
    MOVEA.L A0,A1

.loop_find_title_nul:
    TST.B   (A1)+
    BNE.S   .loop_find_title_nul

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.W  _TEXTDISP_MaxEntryTitleLength,D0
    EXT.L   D0
    MOVE.L  A1,D1
    SUB.L   D1,D0
    MOVE.L  D0,D4
    TST.W   D4
    BLE.S   .next_entry_after_padding

    MOVEQ   #0,D5

.loop_fill_space_buffer:
    MOVEQ   #10,D0
    CMP.W   D0,D5
    BGE.S   .append_space_buffer

    MOVE.B  #$20,-24(A5,D5.W)
    ADDQ.W  #1,D5
    BRA.S   .loop_fill_space_buffer

.append_space_buffer:
    CLR.B   -24(A5,D4.W)
    MOVEA.L -4(A5),A0
    ADDQ.L  #1,A0
    MOVE.L  A0,-(A7)
    PEA     -24(A5)
    JSR     _GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    MOVEA.L -4(A5),A0
    ADDQ.L  #1,A0
    LEA     -24(A5),A1

.copy_padded_title_back:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .copy_padded_title_back

.next_entry_after_padding:
    ADDQ.W  #1,D6
    BRA.W   .loop_entries_for_padding

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_PadEntriesToMaxTitleWidth_Return   (Return tail for title-padding helper)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D4
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Restores D4-D7/frame and returns from title-padding helper.
; NOTES:
;   Shared return for unmatched-group and loop-complete paths.
;------------------------------------------------------------------------------
ESQIFF2_PadEntriesToMaxTitleWidth_Return:
    MOVEM.L (A7)+,D4-D7
    UNLK    A5
    RTS

;!======