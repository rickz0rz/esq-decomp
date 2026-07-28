    XDEF    NEWGRID_DrawGridEntry
    XDEF    NEWGRID_UpdatePresetEntry


;------------------------------------------------------------------------------
; FUNC: NEWGRID_UpdatePresetEntry   (Update preset entry mapping)
; ARGS:
;   stack +8: A3 = dst pointer
;   stack +12: A2 = src pointer
;   stack +18: D7 = index
;   stack +20: D6 = key
; RET:
;   D0: updated index
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode, _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode, _NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex, _NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex
; READS:
;   _TEXTDISP_SecondaryGroupPresentFlag, _TEXTDISP_SecondaryGroupEntryCount, _TEXTDISP_SecondaryEntryPtrTable, _NEWGRID_SecondaryIndexCachePtr
; WRITES:
;   _NEWGRID_SecondaryIndexCachePtr table entries
; DESC:
;   Updates preset entry mapping based on key/index and validates against list.
; NOTES:
;   Uses lookup table _TEXTDISP_SecondaryEntryPtrTable and caches indices in _NEWGRID_SecondaryIndexCachePtr.
;------------------------------------------------------------------------------
NEWGRID_UpdatePresetEntry:
    LINK.W  A5,#-16
    MOVEM.L D4-D7/A2-A3/A6,-(A7)

    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  18(A5),D7
    MOVE.L  20(A5),D6
    MOVEQ   #0,D4
    MOVE.L  (A3),-12(A5)
    MOVE.L  (A2),-16(A5)
    MOVEQ   #48,D0
    CMP.W   D0,D7
    BLE.S   .normalized_index

    SUBI.W  #$30,D7
    MOVEQ   #1,D4

.normalized_index:
    PEA     1.W
    MOVE.L  D6,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     1.W
    MOVE.L  D6,-(A7)
    MOVE.L  D0,-12(A5)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-16(A5)
    TST.L   -12(A5)
    BEQ.W   .done

    TST.L   D0
    BEQ.W   .done

    MOVEQ   #1,D1
    CMP.W   D1,D7
    BEQ.S   .check_entry_enabled

    PEA     _CLOCK_DaySlotIndex
    JSR     _NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(PC)

    ADDQ.W  #4,A7
    SUBQ.W  #1,D0
    BEQ.S   .check_entry_enabled

    TST.L   D4
    BEQ.W   .done

.check_entry_enabled:
    TST.B   _TEXTDISP_SecondaryGroupPresentFlag
    BEQ.W   .done

    TST.L   _NEWGRID_SecondaryIndexCachePtr
    BEQ.S   .cache_miss

    MOVE.L  D6,D0
    ASL.L   #2,D0
    MOVEA.L _NEWGRID_SecondaryIndexCachePtr,A0
    MOVE.L  0(A0,D0.L),D5
    TST.L   D5
    BMI.S   .rebuild_cache_entry

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.L   D0,D5
    BGE.S   .rebuild_cache_entry

    MOVEA.L -12(A5),A0
    ADDA.W  #12,A0
    MOVE.L  D5,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryEntryPtrTable,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A6
    LEA     12(A6),A1

.compare_string_loop:
    MOVE.B  (A0)+,D0
    CMP.B   (A1)+,D0
    BNE.S   .rebuild_cache_entry

    TST.B   D0
    BNE.S   .compare_string_loop

    BEQ.S   .update_entry

.rebuild_cache_entry:
    MOVE.L  -16(A5),-(A7)
    JSR     _NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D5
    MOVE.L  D6,D0
    ASL.L   #2,D0
    MOVEA.L _NEWGRID_SecondaryIndexCachePtr,A0
    MOVE.L  D5,0(A0,D0.L)
    BRA.S   .update_entry

.cache_miss:
    MOVE.L  -16(A5),-(A7)
    JSR     _NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D5

.update_entry:
    PEA     2.W
    MOVE.L  D5,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     2.W
    MOVE.L  D5,-(A7)
    MOVE.L  D0,-12(A5)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-16(A5)

.done:
    MOVE.L  -12(A5),(A3)
    MOVE.L  -16(A5),(A2)
    MOVE.L  D7,D0

    MOVEM.L (A7)+,D4-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawGridEntry   (Draw grid entry line)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: A2 = entry list
;   stack +22: D7 = row index
;   stack +26: D6 = column index
;   stack +28: D5 = flags
; RET:
;   D0: none observed
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID_DrawGridCellText, _NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex, _NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex, _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode, _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode
; READS:
;   NEWGRID_GridEntryDelimiterBar, _NEWGRID_GridOperationId, _GCOMMAND_NicheTextPen
; WRITES:
;   local buffer -19(A5)
; DESC:
;   Draws a single grid entry row using text and selection state.
; NOTES:
;   Validates entry pointers and row bounds before drawing.
;------------------------------------------------------------------------------
NEWGRID_DrawGridEntry:
    LINK.W  A5,#-20
    MOVEM.L D5-D7/A2-A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  22(A5),D7
    MOVE.W  26(A5),D6
    MOVE.L  28(A5),D5
    LEA     NEWGRID_GridEntryDelimiterBar,A0
    LEA     -19(A5),A1
    MOVE.B  (A0)+,(A1)+
    MOVE.B  (A0)+,(A1)+
    MOVE.B  (A0)+,(A1)+
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L 16(A5),A0
    MOVEA.L 56(A0,D0.L),A0
    MOVE.L  A0,-16(A5)
    MOVE.L  A2,D0
    BEQ.W   .draw_missing_entry

    TST.L   16(A5)
    BEQ.W   .draw_missing_entry

    TST.W   D7
    BLE.W   .draw_missing_entry

    MOVEQ   #49,D0
    CMP.W   D0,D7
    BGE.W   .draw_missing_entry

    MOVE.L  A0,D0
    BEQ.W   .draw_missing_entry

    TST.B   (A0)
    BEQ.W   .draw_missing_entry

    MOVE.L  32(A5),D0
    MOVEQ   #3,D1
    CMP.L   D1,D0
    BEQ.S   .check_time_prefix

    ADDQ.L  #1,D0
    BNE.S   .no_time_prefix

.check_time_prefix:
    ; detect time prefix to skip
    MOVEQ   #40,D0
    CMP.B   (A0),D0
    BNE.S   .no_time_prefix

    MOVEQ   #58,D0
    CMP.B   3(A0),D0
    BNE.S   .no_time_prefix

    MOVEQ   #8,D0
    BRA.S   .apply_prefix_offset

.no_time_prefix:
    MOVEQ   #0,D0

.apply_prefix_offset:
    ADD.L   D0,-16(A5)
    MOVEA.L -16(A5),A0
    MOVEA.L _NEWGRID_EntryTextScratchPtr,A1

.copy_entry_string:
    ; copy entry text into scratch buffer
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_entry_string

    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVEA.L 16(A5),A0
    MOVE.B  498(A0),D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  _NEWGRID_EntryTextScratchPtr,-(A7)
    BSR.W   _NEWGRID_Apply24HourFormatting

    LEA     12(A7),A7
    MOVEA.L 16(A5),A0
    BTST    #1,7(A0,D7.W)
    BNE.S   .check_custom_render

    BTST    #4,27(A2)
    BEQ.W   .draw_empty_entry

.check_custom_render:
    TST.L   D5
    BEQ.S   .split_primary_line

    MOVEQ   #3,D0
    CMP.W   D0,D6
    BNE.S   .split_primary_line

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  32(A5),-(A7)
    MOVE.L  _NEWGRID_EntryTextScratchPtr,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A2,-(A7)
    JSR     NEWGRID2_JMPTBL_COI_RenderClockFormatEntryVariant(PC)

    MOVE.L  _NEWGRID_EntryTextScratchPtr,(A7)
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    LEA     24(A7),A7
    BRA.W   .done

.split_primary_line:
    ; split primary line on delimiter (offset 34)
    PEA     34.W
    MOVE.L  _NEWGRID_EntryTextScratchPtr,-(A7)
    JSR     _PARSEINI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    BEQ.S   .after_split_search

    ADDQ.L  #1,-4(A5)
    PEA     34.W
    MOVE.L  -4(A5),-(A7)
    JSR     _PARSEINI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)

.after_split_search:
    TST.L   D0
    BEQ.S   .draw_primary_line

    PEA     _NEWGRID_EntrySplitDelimiterMask
    MOVE.L  D0,-(A7)
    JSR     _PARSEINI_JMPTBL_STR_FindAnyCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    BEQ.S   .trim_primary_leading

    MOVE.L  D0,-4(A5)

.trim_primary_leading:
    ; skip leading spaces
    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.S   .terminate_primary

    MOVEQ   #32,D0
    CMP.B   (A0),D0
    BEQ.S   .terminate_primary

    ADDQ.L  #1,-4(A5)
    BRA.S   .trim_primary_leading

.terminate_primary:
    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.S   .clear_primary_ptr

    CLR.B   (A0)+
    MOVE.L  A0,-4(A5)
    BRA.S   .draw_primary_line

.clear_primary_ptr:
    CLR.L   -4(A5)

.draw_primary_line:
    MOVE.L  _NEWGRID_EntryTextScratchPtr,-(A7)
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    ADDQ.W  #8,A7
    TST.L   D5
    BEQ.W   .post_draw

    TST.L   -4(A5)
    BEQ.W   .post_draw

    MOVEQ   #1,D0
    CMP.W   D0,D6
    BLE.W   .post_draw

    PEA     40.W
    MOVE.L  -4(A5),-(A7)
    JSR     _PARSEINI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.S   .check_subtitle

    MOVEQ   #41,D1
    MOVEA.L D0,A0
    CMP.B   5(A0),D1
    BNE.S   .check_subtitle

    LEA     6(A0),A1
    MOVE.L  A1,-4(A5)

.trim_secondary_leading:
    ; skip leading spaces
    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.S   .terminate_secondary

    MOVEQ   #32,D0
    CMP.B   (A0),D0
    BEQ.S   .terminate_secondary

    ADDQ.L  #1,-4(A5)
    BRA.S   .trim_secondary_leading

.terminate_secondary:
    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.S   .clear_secondary_ptr

    CLR.B   (A0)+
    MOVE.L  A0,-4(A5)
    BRA.S   .draw_secondary_line

.clear_secondary_ptr:
    CLR.L   -4(A5)

.draw_secondary_line:
    MOVE.L  -8(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_LayoutSourceToLines(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .check_subtitle

    MOVE.L  -8(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    ADDQ.W  #8,A7

.check_subtitle:
    TST.L   -4(A5)
    BEQ.W   .post_draw

    MOVE.L  -4(A5),-(A7)
    JSR     _NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,-8(A5)
    BEQ.S   .after_subtitle_parse

    PEA     44.W
    MOVE.L  D0,-(A7)
    JSR     _PARSEINI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)
    BEQ.S   .fallback_subtitle

    PEA     46.W
    MOVE.L  D0,-(A7)
    JSR     _PARSEINI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    BNE.S   .after_subtitle_parse

    MOVE.L  -12(A5),-4(A5)
    CLR.L   -12(A5)
    MOVEA.L -4(A5),A0
    MOVE.B  #$2e,(A0)
    BRA.S   .after_subtitle_parse

.fallback_subtitle:
    PEA     46.W
    MOVE.L  -8(A5),-(A7)
    JSR     _PARSEINI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    BNE.S   .after_subtitle_parse

    SUBA.L  A0,A0
    MOVE.L  A0,-8(A5)

.after_subtitle_parse:
    TST.L   -8(A5)
    BEQ.W   .post_draw

.trim_subtitle_leading:
    ; skip leading spaces
    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.S   .terminate_subtitle

    MOVEQ   #32,D0
    CMP.B   (A0),D0
    BEQ.S   .terminate_subtitle

    ADDQ.L  #1,-4(A5)
    BRA.S   .trim_subtitle_leading

.terminate_subtitle:
    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.S   .clear_subtitle_ptr

    CLR.B   (A0)+
    MOVE.L  A0,-4(A5)
    BRA.S   .draw_subtitle_line

.clear_subtitle_ptr:
    CLR.L   -4(A5)

.draw_subtitle_line:
    MOVE.L  -8(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_LayoutSourceToLines(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .draw_subtitle_fallback

    MOVE.L  -8(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    ADDQ.W  #8,A7
    BRA.S   .post_draw

.draw_subtitle_fallback:
    TST.L   -12(A5)
    BEQ.S   .post_draw

    MOVEA.L -12(A5),A0
    MOVE.B  #$2e,(A0)
    CLR.B   1(A0)
    LEA     2(A0),A1
    MOVE.L  A1,-(A7)
    JSR     _NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    MOVE.L  -8(A5),(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-12(A5)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_LayoutSourceToLines(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .draw_subtitle_alt

    MOVE.L  -8(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    ADDQ.W  #8,A7
    BRA.S   .post_draw

.draw_subtitle_alt:
    MOVE.L  -12(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_LayoutSourceToLines(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .post_draw

    MOVE.L  -12(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    ADDQ.W  #8,A7

.post_draw:
    TST.L   -4(A5)
    BEQ.S   .post_split_draw

    PEA     -19(A5)
    MOVE.L  -4(A5),-(A7)
    JSR     _PARSEINI_JMPTBL_STR_FindAnyCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    BEQ.S   .post_split_draw

    MOVEA.L D0,A0
    ADDQ.L  #1,A0
    PEA     -19(A5)
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-4(A5)
    JSR     _PARSEINI_JMPTBL_STR_FindAnyCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)

.split_loop:
    TST.L   -12(A5)
    BEQ.S   .finalize_split

    MOVEA.L -12(A5),A0
    ADDQ.L  #1,A0
    MOVE.L  A0,-4(A5)
    PEA     -19(A5)
    MOVE.L  -4(A5),-(A7)
    JSR     _PARSEINI_JMPTBL_STR_FindAnyCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)
    BRA.S   .split_loop

.finalize_split:
    MOVEA.L -4(A5),A0
    CLR.B   (A0)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    ADDQ.W  #8,A7

.post_split_draw:
    MOVE.L  32(A5),D0
    MOVEQ   #-1,D1
    CMP.L   D1,D0
    BNE.S   .done

    TST.L   D5
    BEQ.S   .done

    MOVEQ   #1,D1
    CMP.W   D1,D6
    BLE.S   .done

    MOVEA.L _NEWGRID_EntryTextScratchPtr,A0
    CLR.B   (A0)
    MOVE.L  D7,D1
    EXT.L   D1
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  16(A5),-(A7)
    MOVE.L  A2,-(A7)
    JSR     NEWGRID2_JMPTBL_COI_RenderClockFormatEntryVariant(PC)

    MOVE.L  _NEWGRID_EntryTextScratchPtr,(A7)
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    LEA     24(A7),A7
    BRA.S   .done

.draw_empty_entry:
    MOVE.L  _NEWGRID_EntryTextScratchPtr,-(A7)
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    ADDQ.W  #8,A7
    BRA.S   .done

.draw_missing_entry:
    MOVE.L  SCRIPT_PtrNoDataPlaceholder,-(A7)
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    ADDQ.W  #8,A7

.done:
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======