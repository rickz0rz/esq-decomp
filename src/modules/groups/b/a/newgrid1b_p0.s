    XDEF    _NEWGRID_UpdatePresetEntry



;------------------------------------------------------------------------------
; FUNC: _NEWGRID_UpdatePresetEntry   (Update preset entry mapping)
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
_NEWGRID_UpdatePresetEntry:
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