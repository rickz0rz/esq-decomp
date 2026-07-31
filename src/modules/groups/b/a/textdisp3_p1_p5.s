    XDEF    TEXTDISP_SelectBestMatchFromList
    XDEF    _TEXTDISP_UpdateChannelRangeFlags



;------------------------------------------------------------------------------
; FUNC: TEXTDISP_SelectBestMatchFromList   (Score candidates and select banner entry)
; ARGS:
;   stack +8: filterPtr (A3)
;   stack +14: matchCount (word)
;   stack +18: channelCode (word)
;   stack +20: tagPtr (A2)
; RET:
;   D0: status code (0/1/2)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _TEXTDISP_FindEntryMatchIndex, _TEXTDISP_ComputeTimeOffset
; READS:
;   _TEXTDISP_ActiveGroupId, _TEXTDISP_PrimaryTitlePtrTable/2237, _TEXTDISP_PrimaryGroupCode/222D, _CLOCK_HalfHourSlotIndex, _TEXTDISP_CurrentMatchIndex, _TEXTDISP_CandidateIndexList
; WRITES:
;   _TEXTDISP_BannerFallbackEntryIndex-2379, _TEXTDISP_BannerCharFallback, _TEXTDISP_BannerFallbackValidFlag, _TEXTDISP_BannerCharSelected
; DESC:
;   Walks candidate indices, evaluates timing/channel constraints, and updates
;   global selection state for text display.
; NOTES:
;   Uses tagPtr to detect \"SPT\" and adjusts selection rules accordingly.
;------------------------------------------------------------------------------
TEXTDISP_SelectBestMatchFromList:
    LINK.W  A5,#-24
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.W  18(A5),D6
    MOVEA.L 20(A5),A2
    MOVE.W  #$fffa,-12(A5)
    MOVE.W  #$5a1,-20(A5)
    MOVE.W  #$fa5f,-22(A5)
    MOVEQ   #0,D0
    MOVE.B  D0,_TEXTDISP_BannerFallbackValidFlag
    MOVE.B  D0,_TEXTDISP_BannerSelectedValidFlag
    MOVE.B  #$64,_TEXTDISP_BannerCharSelected
    LEA     TEXTDISP_Tag_SPT_Select,A0
    MOVEA.L A2,A1
    MOVE.B  D0,-23(A5)

.compare_spt_prefix:
    MOVE.B  (A0)+,D1
    CMP.B   (A1)+,D1
    BNE.S   .set_spt_flag

    TST.B   D1
    BNE.S   .compare_spt_prefix

    BNE.S   .set_spt_flag

    MOVE.B  #$8,-13(A5)
    BRA.S   .init_channel_range

.set_spt_flag:
    MOVE.B  D0,-13(A5)

.init_channel_range:
    MOVE.W  #$31,-6(A5)
    MOVE.W  -6(A5),D0
    MOVE.B  D0,_TEXTDISP_BannerCharFallback
    TST.W   D6
    BNE.S   .ensure_channel_default

    MOVEQ   #48,D6

.ensure_channel_default:
    MOVEQ   #48,D0
    CMP.W   D0,D6
    BLT.S   .check_channel_range_alt

    MOVEQ   #67,D0
    CMP.W   D0,D6
    BLE.S   .channel_enabled

.check_channel_range_alt:
    MOVEQ   #72,D0
    CMP.W   D0,D6
    BLT.W   .return_error

    MOVEQ   #77,D0
    CMP.W   D0,D6
    BGT.W   .return_error

.channel_enabled:
    MOVE.L  D6,D0
    EXT.L   D0
    LEA     _Global_STR_TEXTDISP_C_3,A0
    ADDA.L  D0,A0
    MOVE.W  _CLOCK_CurrentDayOfWeekIndex,D0
    EXT.L   D0
    MOVEQ   #1,D1
    ASL.L   D0,D1
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    AND.L   D1,D0
    TST.L   D0
    BEQ.W   .return_error

    MOVEQ   #0,D5

.candidate_loop:
    CMP.W   D7,D5
    BGE.W   .finalize_candidates

    LEA     _TEXTDISP_CandidateIndexList,A0
    ADDA.W  D5,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.W  D0,_TEXTDISP_CurrentMatchIndex
    MOVEQ   #0,D0
    MOVE.B  -13(A5),D0
    MOVE.L  D0,-(A7)
    PEA     1.W
    MOVE.L  A3,-(A7)
    BSR.W   _TEXTDISP_FindEntryMatchIndex

    LEA     12(A7),A7
    MOVE.W  D0,-4(A5)
    MOVEQ   #49,D1
    CMP.W   D1,D0
    BGE.W   .ensure_entry_index

    TST.W   _TEXTDISP_ActiveGroupId
    BEQ.S   .compute_time_group2

    MOVEQ   #0,D1
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D1
    EXT.L   D1
    MOVE.W  _TEXTDISP_CurrentMatchIndex,D2
    EXT.L   D2
    ASL.L   #2,D2
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D2,A0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  (A0),-(A7)
    MOVE.L  D1,-(A7)
    BSR.W   _TEXTDISP_ComputeTimeOffset

    LEA     12(A7),A7
    MOVE.W  D0,-18(A5)
    BRA.S   .after_time_offset

.compute_time_group2:
    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D0
    EXT.L   D0
    MOVE.W  _TEXTDISP_CurrentMatchIndex,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D1,A0
    MOVE.W  -4(A5),D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  (A0),-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   _TEXTDISP_ComputeTimeOffset

    LEA     12(A7),A7
    MOVE.W  D0,-18(A5)

.after_time_offset:
    TST.W   _TEXTDISP_ActiveGroupId
    BNE.S   .compute_special_flag

    CLR.B   -23(A5)
    BRA.S   .compute_entry_index

.compute_special_flag:
    MOVE.W  _CLOCK_HalfHourSlotIndex,D1
    MOVE.W  -4(A5),D2
    CMP.W   D1,D2
    BLT.S   .set_special_true

    CMP.W   D2,D1
    BNE.S   .set_special_false

    TST.W   D0
    BGT.S   .set_special_false

.set_special_true:
    MOVEQ   #1,D0
    BRA.S   .store_special_flag

.set_special_false:
    MOVEQ   #0,D0

.store_special_flag:
    MOVE.B  D0,-23(A5)

.compute_entry_index:
    TST.W   _TEXTDISP_ActiveGroupId
    BEQ.S   .set_group2_min

    MOVEQ   #0,D0
    MOVE.W  _CLOCK_HalfHourSlotIndex,D0
    BRA.S   .compare_min_index

.set_group2_min:
    MOVEQ   #1,D0

.compare_min_index:
    MOVE.W  -4(A5),D1
    EXT.L   D1
    CMP.L   D0,D1
    BGT.S   .use_current_index

    MOVEQ   #0,D0
    MOVE.B  -13(A5),D0
    MOVE.L  D0,-(A7)
    PEA     2.W
    MOVE.L  A3,-(A7)
    BSR.W   _TEXTDISP_FindEntryMatchIndex

    LEA     12(A7),A7
    MOVE.W  D0,-16(A5)
    MOVEQ   #49,D1
    CMP.W   D1,D0
    BGE.S   .mark_found_primary

    MOVE.B  #$1,_TEXTDISP_BannerFallbackValidFlag
    BRA.S   .compute_time_secondary

.mark_found_primary:
    MOVE.W  -4(A5),D0
    MOVE.W  D0,-16(A5)
    BRA.S   .compute_time_secondary

.use_current_index:
    MOVE.W  -4(A5),D0
    MOVE.W  D0,-16(A5)

.compute_time_secondary:
    TST.W   _TEXTDISP_ActiveGroupId
    BEQ.S   .compute_time_secondary_group2

    MOVEQ   #0,D1
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D1
    EXT.L   D1
    MOVE.W  _TEXTDISP_CurrentMatchIndex,D2
    EXT.L   D2
    ASL.L   #2,D2
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D2,A0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  (A0),-(A7)
    MOVE.L  D1,-(A7)
    BSR.W   _TEXTDISP_ComputeTimeOffset

    LEA     12(A7),A7
    MOVE.W  D0,-18(A5)
    BRA.S   .after_secondary_time

.compute_time_secondary_group2:
    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D0
    EXT.L   D0
    MOVE.W  _TEXTDISP_CurrentMatchIndex,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D1,A0
    MOVE.W  -16(A5),D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  (A0),-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   _TEXTDISP_ComputeTimeOffset

    LEA     12(A7),A7
    MOVE.W  D0,-18(A5)

.after_secondary_time:
    TST.W   _TEXTDISP_ActiveGroupId
    BEQ.S   .select_entry_table

    MOVE.W  _CLOCK_HalfHourSlotIndex,D1
    MOVE.W  -4(A5),D2
    CMP.W   D1,D2
    BNE.S   .select_entry_table

    TST.W   D0
    BLE.S   .select_entry_table

    MOVEQ   #0,D0
    MOVE.B  -13(A5),D0
    MOVE.L  D0,-(A7)
    PEA     3.W
    MOVE.L  A3,-(A7)
    BSR.W   _TEXTDISP_FindEntryMatchIndex

    LEA     12(A7),A7
    MOVE.W  D0,-4(A5)

.select_entry_table:
    TST.W   _TEXTDISP_ActiveGroupId
    BEQ.S   .select_group2_table

    MOVE.W  _TEXTDISP_CurrentMatchIndex,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-10(A5)
    BRA.S   .after_entry_table

.select_group2_table:
    MOVE.W  _TEXTDISP_CurrentMatchIndex,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-10(A5)

.after_entry_table:
    MOVE.W  -18(A5),D0
    TST.W   D0
    BLE.S   .check_best_match

    MOVE.W  -16(A5),D1
    EXT.L   D1
    ADD.L   D1,D1
    MOVE.W  -12(A5),D2
    MOVEA.L -10(A5),A0
    MOVE.L  D1,D3
    ADDI.L  #400,D3
    CMP.W   0(A0,D3.L),D2
    BLS.S   .check_best_match

    MOVEQ   #1,D1
    MOVE.B  D1,_TEXTDISP_BannerSelectedValidFlag
    MOVE.W  -16(A5),D3
    MOVE.B  D3,_TEXTDISP_BannerCharSelected
    MOVE.W  _TEXTDISP_CurrentMatchIndex,D4
    MOVE.B  D4,_TEXTDISP_BannerSelectedEntryIndex
    MOVE.B  -23(A5),D2
    MOVE.B  D2,_TEXTDISP_BannerSelectedIsSpecialFlag

.check_best_match:
    TST.W   D0
    BLE.S   .check_alt_match

    CMP.W   -20(A5),D0
    BGE.S   .check_alt_match

    MOVEQ   #1,D1
    MOVE.B  D1,_TEXTDISP_BannerFallbackValidFlag
    MOVE.W  -16(A5),D1
    MOVE.B  D1,_TEXTDISP_BannerCharFallback
    MOVE.W  _TEXTDISP_CurrentMatchIndex,D2
    MOVE.B  D2,_TEXTDISP_BannerFallbackEntryIndex
    MOVE.B  -23(A5),D3
    MOVE.B  D3,_TEXTDISP_BannerFallbackIsSpecialFlag
    MOVE.W  D0,-20(A5)
    BRA.W   .update_last_seen

.check_alt_match:
    TST.B   _TEXTDISP_BannerSelectedValidFlag
    BNE.S   .check_fallback_match

    TST.W   D0
    BGT.S   .check_fallback_match

    MOVE.W  -22(A5),D1
    CMP.W   D1,D0
    BLE.S   .check_fallback_match

    MOVE.W  -16(A5),D2
    EXT.L   D2
    ADD.L   D2,D2
    MOVE.W  -12(A5),D3
    MOVEA.L -10(A5),A0
    MOVE.L  D2,D4
    ADDI.L  #400,D4
    CMP.W   0(A0,D4.L),D3
    BLS.S   .check_fallback_match

    MOVE.W  -16(A5),D2
    MOVE.B  D2,_TEXTDISP_BannerCharSelected
    MOVE.W  _TEXTDISP_CurrentMatchIndex,D3
    MOVE.B  D3,_TEXTDISP_BannerSelectedEntryIndex
    MOVE.B  -23(A5),D4
    MOVE.B  D4,_TEXTDISP_BannerSelectedIsSpecialFlag

.check_fallback_match:
    TST.B   _TEXTDISP_BannerFallbackValidFlag
    BNE.S   .update_last_seen

    TST.W   D0
    BGT.S   .update_last_seen

    CMP.W   -22(A5),D0
    BLE.S   .update_last_seen

    MOVE.W  -16(A5),D1
    MOVE.B  D1,_TEXTDISP_BannerCharFallback
    MOVE.W  _TEXTDISP_CurrentMatchIndex,D2
    MOVE.B  D2,_TEXTDISP_BannerFallbackEntryIndex
    MOVE.B  -23(A5),_TEXTDISP_BannerFallbackIsSpecialFlag
    MOVE.W  D0,-22(A5)

.update_last_seen:
    MOVE.W  -16(A5),D0
    EXT.L   D0
    ADD.L   D0,D0
    MOVEA.L -10(A5),A0
    MOVE.L  D0,D1
    ADDI.L  #400,D1
    MOVE.W  0(A0,D1.L),-12(A5)
    MOVE.W  -4(A5),D0
    MOVE.W  _TEXTDISP_FindModeActiveFlag,D1
    MOVE.W  D0,-6(A5)
    SUBQ.W  #1,D1
    BNE.S   .ensure_entry_index

    MOVEQ   #2,D0
    BRA.W   .return

.ensure_entry_index:
    MOVEQ   #49,D0
    CMP.W   -6(A5),D0
    BNE.S   .next_candidate

    TST.W   _TEXTDISP_SbeFilterActiveFlag
    BNE.S   .next_candidate

    MOVEQ   #0,D0
    MOVE.B  -13(A5),D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _TEXTDISP_FindEntryMatchIndex

    LEA     12(A7),A7
    MOVE.W  _TEXTDISP_CurrentMatchIndex,D1
    MOVE.B  D1,_TEXTDISP_BannerFallbackEntryIndex
    MOVE.W  D0,-6(A5)

.next_candidate:
    ADDQ.W  #1,D5
    BRA.W   .candidate_loop

.finalize_candidates:
    CMPI.W  #$31,-6(A5)
    BGE.S   .normalize_channel_code

    CMPI.W  #$3d,-20(A5)
    BGE.S   .bump_usage_count

    MOVEQ   #100,D0
    MOVE.B  D0,_TEXTDISP_BannerCharSelected

.bump_usage_count:
    MOVE.B  _TEXTDISP_BannerCharSelected,D0
    MOVEQ   #100,D1
    CMP.B   D1,D0
    BEQ.S   .return_ok

    TST.W   _TEXTDISP_ActiveGroupId
    BEQ.S   .load_group2_table_for_usage

    MOVEQ   #0,D1
    MOVE.B  _TEXTDISP_BannerSelectedEntryIndex,D1
    MOVE.L  D1,D2
    EXT.L   D2
    ASL.L   #2,D2
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D2,A0
    MOVE.L  (A0),-10(A5)
    BRA.S   .after_usage_table

.load_group2_table_for_usage:
    MOVEQ   #0,D1
    MOVE.B  _TEXTDISP_BannerSelectedEntryIndex,D1
    MOVE.L  D1,D2
    EXT.L   D2
    ASL.L   #2,D2
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D2,A0
    MOVE.L  (A0),-10(A5)

.after_usage_table:
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,D0
    EXT.L   D0
    ADD.L   D0,D0
    MOVEA.L -10(A5),A0
    MOVE.L  D0,D1
    ADDI.L  #400,D1
    ADDQ.W  #1,0(A0,D1.L)

.return_ok:
    MOVEQ   #2,D0
    BRA.S   .return

.normalize_channel_code:
    MOVEQ   #48,D0
    CMP.W   D0,D6
    BLE.S   .check_channel_range_1

    MOVEQ   #58,D0
    CMP.W   D0,D6
    BLT.S   .set_default_channel

.check_channel_range_1:
    MOVEQ   #62,D0
    CMP.W   D0,D6
    BLE.S   .check_channel_range_2

    MOVEQ   #68,D0
    CMP.W   D0,D6
    BLT.S   .set_default_channel

.check_channel_range_2:
    MOVEQ   #71,D0
    CMP.W   D0,D6
    BLE.S   .channel_ok

    MOVEQ   #78,D0
    CMP.W   D0,D6
    BGE.S   .channel_ok

.set_default_channel:
    MOVEQ   #68,D6
    MOVEQ   #1,D0
    BRA.S   .return

.channel_ok:
    MOVEQ   #0,D0
    BRA.S   .return

.return_error:
    MOVEQ   #1,D0

.return:
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_UpdateChannelRangeFlags   (Update channel range flags)
; ARGS:
;   none
; RET:
;   none
; CLOBBERS:
;   D0-D7
; CALLS:
;   _TEXTDISP_FindEntryMatchIndex
; READS:
;   _TEXTDISP_ChannelSourceMode, _TEXTDISP_PrimaryChannelCode/234E, _CLOCK_CurrentDayOfWeekIndex
; WRITES:
;   _TEXTDISP_BannerCharFallback, _TEXTDISP_BannerCharSelected
; DESC:
;   Validates current channel and updates flags used by text display.
; NOTES:
;   Falls back to defaults when channel is out of range.
;------------------------------------------------------------------------------
_TEXTDISP_UpdateChannelRangeFlags:
    LINK.W  A5,#-8
    MOVEM.L D2/D7,-(A7)
    MOVE.W  _TEXTDISP_ChannelSourceMode,D0
    SUBQ.W  #1,D0
    BNE.S   .use_alt_channel_source

    MOVE.L  #_TEXTDISP_PrimarySearchText,-4(A5)
    MOVE.W  _TEXTDISP_PrimaryChannelCode,D7
    BRA.S   .ensure_channel_default

.use_alt_channel_source:
    LEA     _TEXTDISP_SecondarySearchText,A0
    MOVE.W  _TEXTDISP_SecondaryChannelCode,D7
    MOVE.L  A0,-4(A5)

.ensure_channel_default:
    TST.W   D7
    BNE.S   .check_channel_range_primary

    MOVEQ   #48,D7

.check_channel_range_primary:
    MOVEQ   #48,D0
    CMP.W   D0,D7
    BLT.S   .check_channel_range_alt

    MOVEQ   #67,D0
    CMP.W   D0,D7
    BLE.S   .channel_enabled

.check_channel_range_alt:
    MOVEQ   #72,D0
    CMP.W   D0,D7
    BLT.S   .fallback_defaults

    MOVEQ   #77,D0
    CMP.W   D0,D7
    BGT.S   .fallback_defaults

.channel_enabled:
    MOVE.L  D7,D0
    EXT.L   D0
    LEA     _Global_STR_TEXTDISP_C_3,A0
    ADDA.L  D0,A0
    MOVE.W  _CLOCK_CurrentDayOfWeekIndex,D0
    EXT.L   D0
    MOVEQ   #1,D1
    MOVE.L  D1,D2
    ASL.L   D0,D2
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    AND.L   D2,D0
    TST.L   D0
    BEQ.S   .fallback_defaults

    CLR.L   -(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   _TEXTDISP_FindEntryMatchIndex

    LEA     12(A7),A7
    MOVE.B  D0,_TEXTDISP_BannerCharFallback
    BRA.S   .return

.fallback_defaults:
    MOVE.B  #$64,_TEXTDISP_BannerCharSelected
    MOVE.B  #$31,_TEXTDISP_BannerCharFallback

.return:
    MOVEM.L (A7)+,D2/D7
    UNLK    A5
    RTS

;!======