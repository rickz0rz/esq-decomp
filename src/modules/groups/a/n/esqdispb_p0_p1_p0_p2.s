    XDEF    _ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty
    XDEF    ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty_Return


;------------------------------------------------------------------------------
; FUNC: _ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty   (Mirror primary entries into secondary group when empty)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D2/D3/D7
; CALLS:
;   _ESQDISP_FillProgramInfoHeaderFields, _ESQSHARED_CreateGroupEntryAndTitle
; READS:
;   _TEXTDISP_SecondaryGroupCode, _TEXTDISP_SecondaryGroupEntryCount, _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryEntryPtrTable, _TEXTDISP_SecondaryEntryPtrTablePreSlot, ff7f
; WRITES:
;   _ESQDISP_PrimarySecondaryMirrorFlag
; DESC:
;   If secondary group has no entries, clones each primary entry into a newly created
;   secondary entry/title record and copies the per-slot program-info header fields.
;   Sets a flag when mirroring was performed, clears it when secondary was already populated.
; NOTES:
;   Loop walks primary indices from 0 to (PrimaryGroupEntryCount-1).
;------------------------------------------------------------------------------
_ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty:
    LINK.W  A5,#-12
    MOVEM.L D2-D3/D7/A2-A3/A6,-(A7)
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    BNE.W   .mark_no_mirror_needed

    MOVEQ   #0,D7

.loop_primary_entries_for_mirror:
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D7
    BGE.W   .set_mirror_performed_flag

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D0
    MOVEQ   #0,D1
    MOVEA.L -4(A5),A0
    MOVE.B  27(A0),D1
    LEA     12(A0),A1
    LEA     1(A0),A2
    LEA     28(A0),A3
    LEA     19(A0),A6
    MOVE.L  A6,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _ESQSHARED_CreateGroupEntryAndTitle(PC)

    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ASL.L   #2,D1
    LEA     _TEXTDISP_SecondaryEntryPtrTablePreSlot,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  40(A0),D0
    ANDI.W  #$ff7f,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #0,D0
    MOVE.W  46(A0),D0
    MOVEQ   #0,D2
    MOVE.B  41(A0),D2
    MOVEQ   #0,D3
    MOVE.B  42(A0),D3
    LEA     43(A0),A2
    MOVE.L  A2,(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A1,-8(A5)
    BSR.W   _ESQDISP_FillProgramInfoHeaderFields

    LEA     44(A7),A7
    ADDQ.L  #1,D7
    BRA.W   .loop_primary_entries_for_mirror

.set_mirror_performed_flag:
    MOVE.W  #1,_ESQDISP_PrimarySecondaryMirrorFlag
    BRA.S   ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty_Return

.mark_no_mirror_needed:
    CLR.W   _ESQDISP_PrimarySecondaryMirrorFlag

;------------------------------------------------------------------------------
; FUNC: ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty_Return   (Return tail for secondary mirror helper)
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
;   Restores saved registers and returns from secondary-mirror helper.
; NOTES:
;   Shared return tail for both "mirrored" and "already populated" paths.
;------------------------------------------------------------------------------
ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty_Return:
    MOVEM.L (A7)+,D2-D3/D7/A2-A3/A6
    UNLK    A5
    RTS

;!======