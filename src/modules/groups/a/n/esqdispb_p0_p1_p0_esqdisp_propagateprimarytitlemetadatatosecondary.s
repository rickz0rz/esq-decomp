    XDEF    _ESQDISP_PropagatePrimaryTitleMetadataToSecondary
    XDEF    ESQDISP_PropagatePrimaryTitleMetadataToSecondary_Return


;------------------------------------------------------------------------------
; FUNC: _ESQDISP_PropagatePrimaryTitleMetadataToSecondary   (Propagate primary title metadata to matching secondary entries)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   _ESQSHARED_JMPTBL_ESQ_TestBit1Based, _ESQSHARED_JMPTBL_ESQ_WildcardMatch, _ESQPARS_ReplaceOwnedString
; READS:
;   _TEXTDISP_SecondaryGroupEntryCount, _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryEntryPtrTable, _TEXTDISP_SecondaryEntryPtrTable, _TEXTDISP_PrimaryTitlePtrTable, _TEXTDISP_SecondaryTitlePtrTable
; WRITES:
;   (none observed)
; DESC:
;   For each secondary entry lacking an owned title string and with the slot bit clear,
;   finds wildcard-matching primary titles and copies slot metadata/string ownership from
;   primary to secondary. Marks secondary title/entry flags when propagation succeeds.
; NOTES:
;   Slot scan is descending and bounded by entry class (0..47 or 44..47 window).
;------------------------------------------------------------------------------
_ESQDISP_PropagatePrimaryTitleMetadataToSecondary:
    LINK.W  A5,#-40
    MOVEM.L D2-D7/A2-A3/A6,-(A7)
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.W   ESQDISP_PropagatePrimaryTitleMetadataToSecondary_Return

    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.W   D1,D0
    BLS.W   ESQDISP_PropagatePrimaryTitleMetadataToSecondary_Return

    MOVEQ   #0,D7

.loop_secondary_entries:
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.L   D0,D7
    BGE.W   ESQDISP_PropagatePrimaryTitleMetadataToSecondary_Return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    TST.L   60(A1)
    BNE.W   .next_secondary_entry

    LEA     _TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    LEA     28(A1),A0
    PEA     1.W
    MOVE.L  A0,-(A7)
    JSR     _ESQSHARED_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   .next_secondary_entry

    MOVEQ   #0,D4
    MOVEQ   #0,D6

.loop_primary_candidates:
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D6
    BGE.W   .next_secondary_entry

    TST.L   D4
    BNE.W   .next_secondary_entry

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    MOVE.L  A2,-(A7)
    MOVE.L  A1,-(A7)
    JSR     _ESQSHARED_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.W   .next_primary_candidate

    MOVEQ   #48,D5
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    BTST    #5,Struct_PrimaryEntry__EditorFlagsByte(A1)
    BEQ.S   .set_slot_scan_floor_low

    MOVEQ   #0,D0
    BRA.S   .store_slot_scan_floor

.set_slot_scan_floor_low:
    MOVEQ   #44,D0

.store_slot_scan_floor:
    MOVE.L  D0,-20(A5)

.loop_slots_descending:
    CMP.L   -20(A5),D5
    BLE.W   .next_primary_candidate

    TST.L   D4
    BNE.W   .next_primary_candidate

    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    LEA     Struct_PrimaryEntry__SelectionBitsetBase(A1),A0
    MOVE.L  D5,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _ESQSHARED_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   .next_slot_descending

    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    MOVE.L  D5,D1
    ASL.L   #2,D1
    ADDA.L  D1,A2
    TST.L   Struct_TitleAuxRecord__SelectorTextPtrBase(A2)
    BEQ.W   .next_slot_descending

    MOVE.L  D7,D2
    ASL.L   #2,D2
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A1
    MOVEA.L A1,A2
    ADDA.L  D2,A2
    MOVEA.L (A2),A3
    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVEA.L (A2),A6
    ADDA.L  D5,A6
    MOVEQ   #0,D3
    MOVE.B  Struct_TitleAuxRecord__SelectorFlagsByteBase(A6),D3
    ORI.W   #$80,D3
    MOVE.B  D3,8(A3)
    MOVEA.L A1,A2
    ADDA.L  D2,A2
    MOVEA.L (A2),A3
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    ADDA.L  D1,A2
    ADDA.L  D2,A1
    MOVEA.L (A1),A0
    MOVE.L  Struct_TitleAuxRecord__OwnedStringPtr(A0),-(A7)      ; dst owned-string slot (secondary title record)
    MOVE.L  Struct_TitleAuxRecord__SelectorTextPtrBase(A2),-(A7) ; src selector text pointer slot (+56 + selector*4)
    MOVE.L  A3,60(A7)
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVEA.L 52(A7),A0
    MOVE.L  D0,Struct_TitleAuxRecord__OwnedStringPtr(A0)
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    MOVE.L  D6,D1
    ASL.L   #2,D1
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A1
    MOVEA.L A1,A3
    ADDA.L  D1,A3
    MOVEA.L (A3),A6
    ADDA.L  D5,A6
    MOVE.B  252(A6),253(A2)
    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVEA.L (A2),A3
    MOVEA.L A1,A2
    ADDA.L  D1,A2
    MOVEA.L (A2),A6
    ADDA.L  D5,A6
    MOVE.B  301(A6),302(A3)
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    ADDA.L  D1,A1
    MOVEA.L (A1),A0
    ADDA.L  D5,A0
    MOVE.B  350(A0),351(A2)
    LEA     _TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEQ   #0,D0
    MOVE.B  40(A1),D0
    MOVE.L  D0,D1
    ORI.W   #$80,D1
    MOVE.B  D1,40(A1)
    MOVEQ   #1,D4

.next_slot_descending:
    SUBQ.L  #1,D5
    BRA.W   .loop_slots_descending

.next_primary_candidate:
    ADDQ.L  #1,D6
    BRA.W   .loop_primary_candidates

.next_secondary_entry:
    ADDQ.L  #1,D7
    BRA.W   .loop_secondary_entries

;------------------------------------------------------------------------------
; FUNC: ESQDISP_PropagatePrimaryTitleMetadataToSecondary_Return   (Return tail for title-metadata propagation)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D2
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Restores saved registers and returns from title-metadata propagation helper.
; NOTES:
;   Early exits branch here when primary/secondary counts are zero.
;------------------------------------------------------------------------------
ESQDISP_PropagatePrimaryTitleMetadataToSecondary_Return:
    MOVEM.L (A7)+,D2-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======