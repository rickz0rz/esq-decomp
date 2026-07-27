    XDEF    _ESQFUNC_FreeExtraTitleTextPointers


;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_FreeExtraTitleTextPointers   (PruneEntryTextPointersuncertain)
; ARGS:
;   stack +10: maxIndex (D7)
; RET:
;   D0: none
; CLOBBERS:
;   D0/D4-D7/A0-A1
; CALLS:
;   _ESQPARS_ReplaceOwnedString (deallocate)
; READS:
;   _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryEntryPtrTable, _TEXTDISP_PrimaryTitlePtrTable
; WRITES:
;   _TEXTDISP_PrimaryTitlePtrTable[entry].field56[] (pointer array cleared)
; DESC:
;   Walks the entry tables and frees extra non-null text pointers up to the
;   given index, leaving the first non-null pointer intact.
; NOTES:
;   The inner loop runs down from min(maxIndex, 34).
;------------------------------------------------------------------------------
_ESQFUNC_FreeExtraTitleTextPointers:
    LINK.W  A5,#-20
    MOVEM.L D4-D7,-(A7)

    MOVE.W  10(A5),D7
    MOVEQ   #0,D4

.entry_loop:
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.W   D0,D4
    BGE.S   .return_status

    MOVE.L  D4,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    MOVEQ   #0,D6
    MOVEQ   #34,D0
    CMP.W   D0,D7
    BGT.S   .cap_limit

    MOVE.L  D7,D0
    EXT.L   D0
    BRA.S   .set_limit

.cap_limit:
    MOVEQ   #34,D0

.set_limit:
    MOVE.L  D0,D5

.slot_loop:
    TST.W   D5
    BMI.S   .next_entry

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    MOVEA.L 56(A0,D0.L),A0
    MOVE.L  A0,-12(A5)
    MOVE.L  A0,D0
    BEQ.S   .next_slot

    TST.W   D6
    BEQ.S   .mark_first_seen

    MOVE.L  A0,-(A7)
    CLR.L   -(A7)
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    CLR.L   56(A0,D0.L)
    BRA.S   .next_slot

.mark_first_seen:
    MOVEQ   #1,D6

.next_slot:
    SUBQ.W  #1,D5
    BRA.S   .slot_loop

.next_entry:
    ADDQ.W  #1,D4
    BRA.S   .entry_loop

.return_status:
    MOVEM.L (A7)+,D4-D7
    UNLK    A5
    RTS

;!======