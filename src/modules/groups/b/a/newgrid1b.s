    XDEF    NEWGRID_DrawEntryFlagBadge
    XDEF    NEWGRID_DrawEntryRowOrPlaceholder
    XDEF    NEWGRID_DrawGridCellBackground
    XDEF    NEWGRID_DrawGridEntry
    XDEF    NEWGRID_DrawGridFrameAndRows
    XDEF    NEWGRID_GetEntryStateCode
    XDEF    NEWGRID_RebuildIndexCache
    XDEF    NEWGRID_SetSelectionMarkers
    XDEF    NEWGRID_TestEntryState
    XDEF    NEWGRID_UpdateGridState
    XDEF    NEWGRID_UpdatePresetEntry



;------------------------------------------------------------------------------
; FUNC: NEWGRID_RebuildIndexCache   (Rebuild lookup cache)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0
; CALLS:
;   _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode, _NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex
; READS:
;   _NEWGRID_SecondaryIndexCachePtr, _ESQPARS2_ReadModeFlags, _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_SecondaryGroupEntryCount
; WRITES:
;   _NEWGRID_SecondaryIndexCachePtr, _ESQPARS2_ReadModeFlags
; DESC:
;   Clears and repopulates the cache table at _NEWGRID_SecondaryIndexCachePtr based on current entries.
; NOTES:
;   Temporarily sets _ESQPARS2_ReadModeFlags to 0x0100 while rebuilding.
;------------------------------------------------------------------------------
NEWGRID_RebuildIndexCache:
    LINK.W  A5,#-16
    MOVEM.L D5-D7,-(A7)
    TST.L   _NEWGRID_SecondaryIndexCachePtr
    BEQ.W   .done

    MOVE.W  _ESQPARS2_ReadModeFlags,D5
    MOVE.W  #$100,_ESQPARS2_ReadModeFlags
    MOVEQ   #0,D7

.clear_cache_loop:
    CMPI.L  #$12e,D7
    BGE.S   .rebuild_start

    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEQ   #-1,D1
    MOVEA.L _NEWGRID_SecondaryIndexCachePtr,A0
    MOVE.L  D1,0(A0,D0.L)
    ADDQ.L  #1,D7
    BRA.S   .clear_cache_loop

.rebuild_start:
    MOVEQ   #0,D7

.rebuild_loop:
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D7
    BGE.S   .restore_flags

    PEA     1.W
    MOVE.L  D7,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-14(A5)
    TST.L   D0
    BEQ.S   .next_entry

    MOVEA.L D0,A0
    ADDA.W  #12,A0
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D6
    MOVEQ   #-1,D0
    CMP.L   D0,D6
    BLE.S   .next_entry

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.L   D0,D6
    BGE.S   .next_entry

    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEA.L _NEWGRID_SecondaryIndexCachePtr,A0
    MOVE.L  D6,0(A0,D0.L)

.next_entry:
    ADDQ.L  #1,D7
    BRA.S   .rebuild_loop

.restore_flags:
    MOVE.W  D5,_ESQPARS2_ReadModeFlags

.done:
    MOVEM.L (A7)+,D5-D7
    UNLK    A5
    RTS

;!======

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
    JSR     PARSEINI_JMPTBL_STR_FindAnyCharPtr(PC)

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
    JSR     PARSEINI_JMPTBL_STR_FindAnyCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    BEQ.S   .post_split_draw

    MOVEA.L D0,A0
    ADDQ.L  #1,A0
    PEA     -19(A5)
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-4(A5)
    JSR     PARSEINI_JMPTBL_STR_FindAnyCharPtr(PC)

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
    JSR     PARSEINI_JMPTBL_STR_FindAnyCharPtr(PC)

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

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawEntryFlagBadge   (Draw entry flag indicator)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +14: arg_3 (via 18(A5))
;   stack +16: arg_4 (via 20(A5))
;   stack +20: arg_5 (via 24(A5))
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A2-A3
; CALLS:
;   _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams, _NEWGRID2_JMPTBL_CLEANUP_TestEntryFlagYAndBit1, _NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer, _NEWGRID2_JMPTBL_CLEANUP_UpdateEntryFlagBytes, _NEWGRID2_JMPTBL_DISPTEXT_BuildLayoutForSource, _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer
; READS:
;   27(A2)
; WRITES:
;   none
; DESC:
;   Draws a badge/flag indicator for entries with specific flags set.
; NOTES:
;   Uses cleanup/test helpers to validate the entry before drawing.
;------------------------------------------------------------------------------
NEWGRID_DrawEntryFlagBadge:
    LINK.W  A5,#-4
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  18(A5),D7
    MOVE.L  24(A5),D6
    MOVE.L  D6,-(A7)
    PEA     20.W
    PEA     612.W
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(PC)

    LEA     12(A7),A7
    MOVE.L  A2,D0
    BEQ.S   .fallback_draw

    BTST    #4,27(A2)
    BEQ.S   .fallback_draw

    MOVE.L  D7,D0
    EXT.L   D0
    PEA     5.W
    MOVE.L  D0,-(A7)
    MOVE.L  A2,-(A7)
    JSR     _NEWGRID2_JMPTBL_CLEANUP_TestEntryFlagYAndBit1(PC)

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .fallback_draw

    MOVE.L  D7,D0
    EXT.L   D0
    PEA     6.W
    MOVE.L  D0,-(A7)
    MOVE.L  A2,-(A7)
    JSR     _NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    LEA     12(A7),A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   .fallback_draw

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A2,-(A7)
    JSR     _NEWGRID2_JMPTBL_CLEANUP_UpdateEntryFlagBytes(PC)

    MOVE.L  20(A5),(A7)
    PEA     20.W
    MOVE.L  -4(A5),-(A7)
    PEA     19.W
    PEA     _NEWGRID_EntryDetailFmtStr
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_BuildLayoutForSource(PC)

    LEA     28(A7),A7
    BRA.S   .done

.fallback_draw:
    MOVE.L  20(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    ADDQ.W  #8,A7

.done:
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawGridFrameAndRows   (Draw grid frame and row dividers)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +16: arg_4 (via 20(A5))
;   stack +20: arg_5 (via 24(A5))
; RET:
;   D0: status from _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast, _NEWGRID_SetRowColor, _LVOSetAPen, _LVORectFill, NEWGRID2_JMPTBL_DISPTEXT_GetTotalLineCount, NEWGRID2_JMPTBL_DISPTEXT_MeasureCurrentLineLength,
;   NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines, _NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected, _NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine, NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel, NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel
; READS:
;   _NEWGRID_RowHeightPx, _DISPTEXT_ControlMarkerXOffsetPx
; WRITES:
;   52(A3)
; DESC:
;   Draws the grid background/frame and row separator lines, updating layout.
; NOTES:
;   Uses rounding before ASR to keep centering stable for negative values.
;------------------------------------------------------------------------------
NEWGRID_DrawGridFrameAndRows:
    LINK.W  A5,#-28
    MOVEM.L D2-D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    TST.L   D0
    BNE.W   .done

    LEA     60(A3),A0
    MOVE.L  D7,-(A7)
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A0,40(A7)
    BSR.W   _NEWGRID_SetRowColor

    MOVEA.L 40(A7),A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    ADDQ.L  #3,D0
    MOVEA.L A0,A1
    MOVE.L  D0,D3
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVE.L  #695,D2
    JSR     _LVORectFill(A6)

    MOVEQ   #42,D5
    CLR.L   -16(A5)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_GetTotalLineCount(PC)

    LEA     12(A7),A7
    SUBQ.L  #1,D0
    BNE.S   .after_header

    LEA     60(A3),A0
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_MeasureCurrentLineLength(PC)

    ADDQ.W  #4,A7
    MOVE.L  #612,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .center_header

    ADDQ.L  #1,D1

.center_header:
    ASR.L   #1,D1
    ADD.L   D1,D5
    MOVEQ   #4,D0
    MOVE.L  D0,-16(A5)

.after_header:
    JSR     NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines(PC)

    MOVEQ   #0,D6
    MOVE.L  D0,-24(A5)

.row_loop:
    MOVEQ   #2,D0
    CMP.L   D0,D6
    BGE.W   .after_rows

    JSR     _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    TST.L   D0
    BNE.W   .after_rows

    TST.L   D6
    BNE.S   .row_flag_path

    TST.L   -24(A5)
    BEQ.S   .row_flag_path

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    TST.L   D0
    BPL.S   .row_half_width

    ADDQ.L  #1,D0

.row_half_width:
    ASR.L   #1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    SUB.L   D1,D0
    SUBQ.L  #4,D0
    TST.L   D0
    BPL.S   .row_half_width_adjust

    ADDQ.L  #1,D0

.row_half_width_adjust:
    ASR.L   #1,D0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D0
    MOVE.L  D0,D4
    ADDQ.L  #3,D4
    BRA.S   .draw_row_line

.row_flag_path:
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected(PC)

    TST.L   D0
    BEQ.S   .row_default_path

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    MOVE.L  D0,D1
    TST.L   D1
    BPL.S   .row_flag_half_width

    ADDQ.L  #1,D1

.row_flag_half_width:
    ASR.L   #1,D1
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    SUB.L   D2,D1
    SUBQ.L  #4,D1
    TST.L   D1
    BPL.S   .row_flag_half_width_adjust

    ADDQ.L  #1,D1

.row_flag_half_width_adjust:
    ASR.L   #1,D1
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    ADD.L   D2,D1
    MOVE.L  -16(A5),D2
    ADD.L   D2,D1
    MOVE.L  D1,D4
    SUBQ.L  #1,D4
    BRA.S   .draw_row_line

.row_default_path:
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    TST.L   D0
    BPL.S   .row_default_half_width

    ADDQ.L  #1,D0

.row_default_half_width:
    ASR.L   #1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    SUB.L   D1,D0
    TST.L   D0
    BPL.S   .row_default_half_width_adjust

    ADDQ.L  #1,D0

.row_default_half_width_adjust:
    ASR.L   #1,D0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D0
    MOVE.L  -16(A5),D1
    ADD.L   D0,D1
    MOVE.L  D1,D4
    SUBQ.L  #1,D4

.draw_row_line:
    LEA     60(A3),A0
    MOVE.L  D4,-(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D6
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    TST.L   D0
    BPL.S   .advance_row

    ADDQ.L  #1,D0

.advance_row:
    ASR.L   #1,D0
    ADD.L   _DISPTEXT_ControlMarkerXOffsetPx,D0
    ADD.L   D0,-16(A5)
    BRA.W   .row_loop

.after_rows:
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(PC)

    MOVE.L  D0,-20(A5)
    TST.L   -24(A5)
    BEQ.S   .draw_bottom_bevel

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,-(A7)
    PEA     695.W
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel(PC)

    LEA     20(A7),A7

.draw_bottom_bevel:
    TST.L   -20(A5)
    BEQ.S   .draw_top_bevel

    LEA     60(A3),A0
    MOVE.L  -16(A5),D0
    SUBQ.L  #1,D0
    MOVE.L  D0,-(A7)
    PEA     695.W
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel(PC)

    LEA     20(A7),A7

.draw_top_bevel:
    MOVE.L  -16(A5),D0
    BPL.S   .store_header_width

    ADDQ.L  #1,D0

.store_header_width:
    ASR.L   #1,D0
    MOVE.W  D0,52(A3)

.done:
    MOVE.L  -20(A5),D0
    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_UpdateGridState   (Advance grid state machine)
; ARGS:
;   stack +8: A3 = grid struct
;   stack +12: D7 = key/index
;   stack +18: D6 = row index
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID_UpdatePresetEntry, NEWGRID_DrawEntryFlagBadge,
;   NEWGRID_DrawGridFrameAndRows, NEWGRID2_JMPTBL_ESQ_TestBit1Based, NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex, NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount
; READS:
;   NEWGRID_GridStateFrameLatch
; WRITES:
;   NEWGRID_GridStateFrameLatch, NEWGRID_SelectedGridEntryPtr, 32(A3)
; DESC:
;   Updates grid state, resolves the selected entry, and redraws frame content.
; NOTES:
;   State machine uses NEWGRID_GridStateFrameLatch values 4/5.
;------------------------------------------------------------------------------
NEWGRID_UpdateGridState:
    LINK.W  A5,#-8
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.W  18(A5),D6
    MOVE.L  A3,D0
    BNE.S   .check_state

    MOVEQ   #4,D0
    MOVE.L  D0,NEWGRID_GridStateFrameLatch
    BRA.W   .done

.check_state:
    MOVE.L  NEWGRID_GridStateFrameLatch,D0
    MOVEQ   #5,D1
    CMP.L   D1,D0
    BNE.S   .state_is_five

    MOVEQ   #-1,D1
    MOVE.L  D1,32(A3)
    BRA.W   .update_frame_state

.state_is_five:
    SUBQ.L  #4,D0
    BNE.W   .force_state_4

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D7,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -8(A5)
    PEA     -4(A5)
    BSR.W   NEWGRID_UpdatePresetEntry

    LEA     16(A7),A7
    MOVE.L  D0,D6
    TST.L   -4(A5)
    BEQ.W   .update_frame_state

    TST.L   -8(A5)
    BEQ.W   .update_frame_state

    MOVEA.L -4(A5),A0
    ADDA.W  #$1c,A0
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   .update_frame_state

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(PC)

    MOVE.L  D0,D6
    MOVE.L  -4(A5),(A7)
    BSR.W   _NEWGRID_SelectEntryPen

    LEA     12(A7),A7
    MOVEA.L -8(A5),A0
    MOVEA.L A0,A1
    ADDA.W  D6,A1
    MOVE.L  D0,NEWGRID_SelectedGridEntryPtr
    BTST    #2,7(A1)
    BEQ.S   .set_entry_mode

    MOVEQ   #5,D0
    MOVE.L  D0,NEWGRID_SelectedGridEntryPtr

.set_entry_mode:
    LEA     60(A3),A1
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    ASL.L   #2,D1
    ADDA.L  D1,A0
    MOVE.L  _NEWGRID_OverridePenIndex,-(A7)
    MOVE.L  56(A0),-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A1,-(A7)
    BSR.W   NEWGRID_DrawEntryFlagBadge

    CLR.L   (A7)
    JSR     NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(PC)

    LEA     20(A7),A7
    MOVE.L  D0,32(A3)
    BRA.S   .update_frame_state

.force_state_4:
    MOVEQ   #4,D0
    MOVE.L  D0,NEWGRID_GridStateFrameLatch

.update_frame_state:
    MOVE.L  NEWGRID_SelectedGridEntryPtr,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawGridFrameAndRows

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .set_state_4

    MOVEQ   #4,D0
    BRA.S   .store_state

.set_state_4:
    MOVEQ   #5,D0

.store_state:
    MOVE.L  D0,NEWGRID_GridStateFrameLatch

.done:
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_SetSelectionMarkers   (Set glyph markers based on indices)
; ARGS:
;   stack +8: D7 = primary selector
;   stack +12: D6 = secondary selector
;   stack +16: A3 = primary dst byte
;   stack +20: A2 = secondary dst byte
;   stack +24: A0 = tertiary dst byte
;   stack +28: A0 = quaternary dst byte
; RET:
;   D0: none
; CLOBBERS:
;   D0/D6-D7/A0-A3
; CALLS:
;   none
; DESC:
;   Writes marker bytes based on selector values (0/1/2).
; NOTES:
;   Uses fixed byte codes 0x80..0x8B for marker glyphs.
;------------------------------------------------------------------------------
NEWGRID_SetSelectionMarkers:
    LINK.W  A5,#0
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVEA.L 16(A5),A3
    MOVEA.L 20(A5),A2
    MOVE.L  D7,D0
    TST.L   D0
    BEQ.S   .case_primary_default

    SUBQ.L  #1,D0
    BEQ.S   .case_primary1

    SUBQ.L  #1,D0
    BEQ.S   .case_primary2

    BRA.S   .case_primary_default

.case_primary1:
    MOVE.B  #$80,(A3)
    MOVE.B  #$81,(A2)
    BRA.S   .after_primary

.case_primary2:
    MOVE.B  #$82,(A3)
    MOVE.B  #$83,(A2)
    BRA.S   .after_primary

.case_primary_default:
    MOVEQ   #0,D0
    MOVE.B  D0,(A3)
    MOVE.B  D0,(A2)

.after_primary:
    MOVE.L  D6,D0
    TST.L   D0
    BEQ.S   .case_secondary_default

    SUBQ.L  #1,D0
    BEQ.S   .case_secondary1

    SUBQ.L  #1,D0
    BEQ.S   .case_secondary2

    BRA.S   .case_secondary_default

.case_secondary1:
    MOVEA.L 24(A5),A0
    MOVE.B  #$88,(A0)
    MOVEA.L 28(A5),A0
    MOVE.B  #$89,(A0)
    BRA.S   .done

.case_secondary2:
    MOVEA.L 24(A5),A0
    MOVE.B  #$8a,(A0)
    MOVEA.L 28(A5),A0
    MOVE.B  #$8b,(A0)
    BRA.S   .done

.case_secondary_default:
    MOVEQ   #0,D0
    MOVEA.L 24(A5),A0
    MOVE.B  D0,(A0)
    MOVEA.L 28(A5),A0
    MOVE.B  D0,(A0)

.done:
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_GetEntryStateCode   (Compute entry state code)
; ARGS:
;   stack +8: A3 = grid struct
;   stack +12: A2 = entry list
;   stack +18: D7 = row index
; RET:
;   D0: state code (1..3)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID2_JMPTBL_ESQ_TestBit1Based
; READS:
;   7(A2,D7), 56(A2,index)
; DESC:
;   Computes a state code based on entry flags and availability.
; NOTES:
;   Returns 1 for invalid/out-of-range.
;------------------------------------------------------------------------------
NEWGRID_GetEntryStateCode:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEA.L 24(A7),A2
    MOVE.W  30(A7),D7
    MOVE.L  A3,D0
    BEQ.S   .invalid

    MOVE.L  A2,D0
    BEQ.S   .invalid

    TST.W   D7
    BLE.S   .invalid

    MOVEQ   #49,D0
    CMP.W   D0,D7
    BGE.S   .invalid

    LEA     28(A3),A0
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BEQ.S   .check_entry_flags

    MOVEQ   #0,D6
    BRA.S   .done

.check_entry_flags:
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    TST.L   56(A2,D0.L)
    BEQ.S   .set_state3

    BTST    #7,7(A2,D7.W)
    BEQ.S   .set_state2

.set_state3:
    MOVEQ   #3,D6
    BRA.S   .done

.set_state2:
    MOVEQ   #2,D6
    BRA.S   .done

.invalid:
    MOVEQ   #1,D6

.done:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_TestEntryState   (Test entry state against mode)
; ARGS:
;   stack +8: D7 = mode selector
;   stack +12: D6 = key
;   stack +16: D5 = entry pointer
;   stack +22: D4 = selector value
; RET:
;   D0: boolean (-1/0) result
; CLOBBERS:
;   D0-D7
; CALLS:
;   NEWGRID_GetEntryStateCode, _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode, _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode
; DESC:
;   Determines whether an entry matches the requested selector/mode.
; NOTES:
;   Uses SNE/NEG/EXT to booleanize in mode 0.
;------------------------------------------------------------------------------
NEWGRID_TestEntryState:
    LINK.W  A5,#-16
    MOVEM.L D4-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVE.L  16(A5),D5
    MOVE.W  22(A5),D4
    CLR.L   -12(A5)
    MOVEQ   #48,D0
    CMP.W   D0,D4
    BGT.S   .use_second_key

    MOVEQ   #1,D0
    CMP.W   D0,D4
    BNE.S   .use_first_key

.use_second_key:
    PEA     2.W
    MOVE.L  D5,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     2.W
    MOVE.L  D5,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)

.normalize_key:
    MOVEQ   #48,D0
    CMP.W   D0,D4
    BLE.S   .compute_state

    SUBI.W  #$30,D4
    BRA.S   .normalize_key

.use_first_key:
    PEA     1.W
    MOVE.L  D6,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     1.W
    MOVE.L  D6,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)

.compute_state:
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   NEWGRID_GetEntryStateCode

    LEA     12(A7),A7
    MOVE.L  D0,-16(A5)
    MOVE.L  D7,D0
    TST.L   D0
    BEQ.S   .mode0

    SUBQ.L  #1,D0
    BEQ.S   .mode1

    SUBQ.L  #1,D0
    BEQ.S   .mode2

    SUBQ.L  #1,D0
    BEQ.S   .mode2

    BRA.S   .done

.mode0:
    TST.L   -16(A5)
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-12(A5)
    BRA.S   .done

.mode1:
    MOVE.L  -16(A5),D0
    MOVEQ   #1,D1
    CMP.L   D1,D0
    BEQ.S   .mode1_match

    SUBQ.L  #3,D0
    BEQ.S   .mode1_match

    MOVEQ   #0,D0
    BRA.S   .mode1_done

.mode1_match:
    MOVEQ   #1,D0

.mode1_done:
    MOVE.L  D0,-12(A5)
    BRA.S   .done

.mode2:
    MOVEQ   #3,D1
    CMP.L   -16(A5),D1
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-12(A5)

.done:
    MOVE.L  -12(A5),D0
    MOVEM.L (A7)+,D4-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawEntryRowOrPlaceholder   (Draw entry row or placeholder)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +18: arg_4 (via 22(A5))
;   stack +22: arg_5 (via 26(A5))
;   stack +24: arg_6 (via 28(A5))
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID_DrawGridEntry, _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer
; READS:
;   NEWGRID_EntryPlaceholderModeFlag, CONFIG_NewgridPlaceholderBevelFlag, SCRIPT_PtrNoDataPlaceholder, SCRIPT_PtrOffAirPlaceholder
; DESC:
;   Draws the grid entry for a row when data is present, otherwise draws a
;   placeholder label depending on the flags.
;------------------------------------------------------------------------------
NEWGRID_DrawEntryRowOrPlaceholder:
    LINK.W  A5,#0
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  22(A5),D7
    MOVE.W  26(A5),D6
    MOVE.L  28(A5),D5
    MOVE.L  D5,D0
    TST.L   D0
    BEQ.S   .draw_empty_placeholder

    SUBQ.L  #1,D0
    BEQ.S   .draw_missing_placeholder

    SUBQ.L  #1,D0
    BNE.S   .draw_missing_placeholder

    TST.W   NEWGRID_EntryPlaceholderModeFlag
    BEQ.S   .draw_simple_row

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.B  CONFIG_NewgridPlaceholderBevelFlag,D2
    MOVEQ   #89,D4
    CMP.B   D4,D2
    SEQ     D3
    NEG.B   D3
    EXT.W   D3
    EXT.L   D3
    PEA     2.W
    MOVE.L  D3,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  16(A5),-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawGridEntry

    LEA     28(A7),A7
    BRA.S   .done

.draw_simple_row:
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     2.W
    PEA     1.W
    PEA     3.W
    MOVE.L  D0,-(A7)
    MOVE.L  16(A5),-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawGridEntry

    LEA     28(A7),A7
    BRA.S   .done

.draw_empty_placeholder:
    MOVE.L  SCRIPT_PtrOffAirPlaceholder,-(A7)
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    ADDQ.W  #8,A7
    BRA.S   .done

.draw_missing_placeholder:
    MOVE.L  SCRIPT_PtrNoDataPlaceholder,-(A7)
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    ADDQ.W  #8,A7

.done:
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawGridCellBackground   (Draw cell background/frame)
; ARGS:
;   stack +8: A3 = rastport
;   stack +14: D7 = row index
;   stack +18: D6 = column index
;   stack +20: D5 = color selector
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _NEWGRID_SetRowColor, _LVOSetAPen, _LVORectFill, NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame, _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight
; READS:
;   _NEWGRID_RowHeightPx, _NEWGRID_ColumnStartXPx, _NEWGRID_ColumnWidthPx, CONFIG_NewgridPlaceholderBevelFlag
; DESC:
;   Fills a grid cell background and draws its frame based on row/column and
;   clock format flags.
;------------------------------------------------------------------------------
NEWGRID_DrawGridCellBackground:
    LINK.W  A5,#-20
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.W  18(A5),D6
    MOVE.L  20(A5),D5
    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVE.W  _NEWGRID_ColumnWidthPx,D1
    MULU    D7,D1
    ADD.L   D1,D0
    MOVE.L  D0,D4
    MOVEQ   #36,D1
    ADD.L   D1,D4
    CLR.L   -8(A5)
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    ADD.L   D1,D0
    MOVE.L  A0,-20(A5)
    MOVEQ   #3,D1
    CMP.L   D1,D0
    BLT.S   .compute_cell_right

    MOVE.L  #695,D0
    BRA.S   .store_bounds

.compute_cell_right:
    MOVE.W  _NEWGRID_ColumnWidthPx,D0
    MULU    D6,D0
    MOVE.L  D4,D1
    ADD.L   D0,D1
    SUBQ.L  #1,D1
    MOVE.L  D1,D0

.store_bounds:
    MOVEQ   #0,D1
    MOVE.W  _NEWGRID_RowHeightPx,D1
    SUBQ.L  #1,D1
    MOVE.L  D0,-12(A5)
    MOVE.L  D1,-16(A5)
    MOVEQ   #0,D0
    NOT.B   D0
    CMP.L   D0,D5
    BEQ.S   .skip_background_fill

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D5,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_SetRowColor

    LEA     12(A7),A7
    MOVEA.L -20(A5),A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.L  D4,D0
    MOVEA.L -20(A5),A1
    MOVE.L  -8(A5),D1
    MOVE.L  -12(A5),D2
    MOVE.L  -16(A5),D3
    JSR     _LVORectFill(A6)

.skip_background_fill:
    MOVEQ   #3,D0
    CMP.W   D0,D6
    BNE.S   .draw_normal_frame

    MOVE.B  CONFIG_NewgridPlaceholderBevelFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .draw_normal_frame

    MOVE.L  -16(A5),-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  -20(A5),-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame(PC)

    LEA     20(A7),A7
    BRA.S   .done

.draw_normal_frame:
    MOVE.L  -16(A5),-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  -20(A5),-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     20(A7),A7

.done:
    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======