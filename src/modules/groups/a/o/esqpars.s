    XDEF    ESQPARS_ClearAliasStringPointers
    XDEF    _ESQPARS_RemoveGroupEntryAndReleaseStrings
    XDEF    ESQPARS_RemoveGroupEntryAndReleaseStrings_Return



;!======

;------------------------------------------------------------------------------
; FUNC: ESQPARS_ClearAliasStringPointers   (Free alias records and clear pointer table)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   A0/A1/A5/A7/D0/D7
; CALLS:
;   _ESQIFF_JMPTBL_MEMORY_DeallocateMemory, _ESQPARS_ReplaceOwnedString
; READS:
;   _TEXTDISP_AliasCount, _TEXTDISP_AliasPtrTable, Global_STR_ESQPARS_C_1
; WRITES:
;   _TEXTDISP_AliasPtrTable entries, alias record string-pointer fields
; DESC:
;   Walks alias pointer entries and releases both owned strings for each alias
;   record, then frees the alias record and nulls its table slot.
; NOTES:
;   Iterates alias indices 0..(_TEXTDISP_AliasCount-1).
;------------------------------------------------------------------------------
ESQPARS_ClearAliasStringPointers:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7

.alias_loop:
    MOVE.W  _TEXTDISP_AliasCount,D0
    CMP.W   D0,D7
    BGE.S   .done

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_AliasPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,-6(A5)
    MOVE.L  A1,D0
    BEQ.S   .next_alias

    MOVE.L  (A1),-(A7)
    CLR.L   -(A7)
    BSR.W   _ESQPARS_ReplaceOwnedString

    MOVEA.L -6(A5),A0
    MOVE.L  D0,(A0)
    MOVE.L  4(A0),(A7)
    CLR.L   -(A7)
    BSR.W   _ESQPARS_ReplaceOwnedString

    MOVEA.L -6(A5),A0
    MOVE.L  D0,4(A0)
    PEA     8.W
    MOVE.L  A0,-(A7)
    PEA     945.W
    PEA     Global_STR_ESQPARS_C_1
    JSR     _ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     28(A7),A7
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_AliasPtrTable,A0
    ADDA.L  D0,A0
    CLR.L   (A0)

.next_alias:
    ADDQ.W  #1,D7
    BRA.S   .alias_loop

.done:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _ESQPARS_RemoveGroupEntryAndReleaseStrings   (Release all group entry/title allocations)
; ARGS:
;   stack +6: group selector (2 = secondary group, otherwise primary) ??
; RET:
;   D0: none
; CLOBBERS:
;   A0/A1/A2/A5/A7/D0/D1/D5/D6/D7
; CALLS:
;   _ESQIFF_JMPTBL_MEMORY_DeallocateMemory, ESQPARS_JMPTBL_COI_FreeEntryResources, ESQPARS_JMPTBL_SCRIPT_ResetCtrlContextAndClearStatusLine, _ESQIFF2_ClearLineHeadTailByMode
; READS:
;   _TEXTDISP_SecondaryGroupEntryCount, _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryEntryPtrTable, _TEXTDISP_SecondaryEntryPtrTable,
;   _TEXTDISP_PrimaryTitlePtrTable, _TEXTDISP_SecondaryTitlePtrTable, Global_STR_ESQPARS_C_2, Global_STR_ESQPARS_C_3, Global_STR_ESQPARS_C_4
; WRITES:
;   _TEXTDISP_SecondaryGroupPresentFlag, _TEXTDISP_SecondaryGroupEntryCount, _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryGroupPresentFlag,
;   selected entry/title pointer-table slots
; DESC:
;   Clears selected group entry slots from the end toward index 0, releasing
;   per-title strings, title tables, and entry resources/records.
; NOTES:
;   Performs the same cleanup flow for both primary/secondary groups.
;------------------------------------------------------------------------------
_ESQPARS_RemoveGroupEntryAndReleaseStrings:
    LINK.W  A5,#-16
    MOVEM.L D5-D7/A2,-(A7)
    MOVE.W  10(A5),D7
    JSR     ESQPARS_JMPTBL_SCRIPT_ResetCtrlContextAndClearStatusLine(PC)

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   _ESQIFF2_ClearLineHeadTailByMode

    ADDQ.W  #4,A7
    MOVEQ   #2,D0
    CMP.W   D0,D7
    BNE.S   .use_primary_group

    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    MOVE.L  D0,D5
    SUBQ.W  #1,D5
    MOVEQ   #0,D0
    MOVE.W  D0,_TEXTDISP_SecondaryGroupEntryCount
    MOVEQ   #0,D1
    MOVE.B  D1,_TEXTDISP_SecondaryGroupPresentFlag
    BRA.S   .release_entry_loop

.use_primary_group:
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.L  D0,D5
    SUBQ.W  #1,D5
    CLR.W   _TEXTDISP_PrimaryGroupEntryCount
    CLR.B   _TEXTDISP_PrimaryGroupPresentFlag

.release_entry_loop:
    TST.W   D5
    BMI.W   ESQPARS_RemoveGroupEntryAndReleaseStrings_Return

    MOVEQ   #2,D0
    CMP.W   D0,D7
    BNE.S   .select_primary_tables

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryEntryPtrTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  (A1),-4(A5)
    ADDA.L  D0,A0
    SUBA.L  A1,A1
    MOVE.L  A1,(A0)
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A0
    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVE.L  (A2),-8(A5)
    ADDA.L  D0,A0
    MOVE.L  A1,(A0)
    BRA.S   .init_title_slot_index

.select_primary_tables:
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  (A1),-4(A5)
    ADDA.L  D0,A0
    SUBA.L  A1,A1
    MOVE.L  A1,(A0)
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVE.L  (A2),-8(A5)
    ADDA.L  D0,A0
    MOVE.L  A1,(A0)

.init_title_slot_index:
    MOVEQ   #0,D6

.release_title_slot_loop:
    TST.L   -8(A5)
    BEQ.S   .free_title_table

    MOVEQ   #49,D0
    CMP.W   D0,D6
    BGE.S   .free_title_table

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    MOVEA.L 56(A0,D0.L),A0
    MOVE.L  A0,-12(A5)
    MOVE.L  A0,D0
    BEQ.S   .next_title_slot

.scan_title_len_loop:
    TST.B   (A0)+
    BNE.S   .scan_title_len_loop

    SUBQ.L  #1,A0
    SUBA.L  -12(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    PEA     1025.W
    PEA     Global_STR_ESQPARS_C_2
    JSR     _ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    CLR.L   56(A0,D0.L)

.next_title_slot:
    ADDQ.W  #1,D6
    BRA.S   .release_title_slot_loop

.free_title_table:
    TST.L   -8(A5)
    BEQ.S   .free_entry_record

    PEA     500.W
    MOVE.L  -8(A5),-(A7)
    PEA     1031.W
    PEA     Global_STR_ESQPARS_C_3
    JSR     _ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.free_entry_record:
    MOVE.L  -4(A5),-(A7)
    JSR     ESQPARS_JMPTBL_COI_FreeEntryResources(PC)

    ADDQ.W  #4,A7
    TST.L   -4(A5)
    BEQ.S   .next_entry

    PEA     52.W
    MOVE.L  -4(A5),-(A7)
    PEA     1040.W
    PEA     Global_STR_ESQPARS_C_4
    JSR     _ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.next_entry:
    SUBQ.W  #1,D5
    BRA.W   .release_entry_loop

;------------------------------------------------------------------------------
; FUNC: ESQPARS_RemoveGroupEntryAndReleaseStrings_Return   (Return tail for group-entry release helper)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D5
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Restores saved registers/frame and returns from group-entry release helper.
; NOTES:
;   Shared return for all release-loop completion paths.
;------------------------------------------------------------------------------
ESQPARS_RemoveGroupEntryAndReleaseStrings_Return:
    MOVEM.L (A7)+,D5-D7/A2
    UNLK    A5
    RTS

;!======