    XDEF    _ESQDISP_PromoteSecondaryGroupToPrimary


;------------------------------------------------------------------------------
; FUNC: _ESQDISP_PromoteSecondaryGroupToPrimary   (Promote secondary group entries/titles into primary tables)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A1/A2/A3/A7/D0/D1/D7
; CALLS:
;   _ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache, _ESQPARS_RemoveGroupEntryAndReleaseStrings
; READS:
;   _CTASKS_SecondaryOiWritePendingFlag, _CTASKS_PendingSecondaryOiDiskId, _TEXTDISP_SecondaryGroupPresentFlag, _TEXTDISP_SecondaryGroupEntryCount, _TEXTDISP_PrimaryEntryPtrTable, _TEXTDISP_SecondaryEntryPtrTable, _TEXTDISP_PrimaryTitlePtrTable, _TEXTDISP_SecondaryTitlePtrTable, _TEXTDISP_SecondaryGroupHeaderCode, _TEXTDISP_SecondaryGroupRecordChecksum, _TEXTDISP_SecondaryGroupRecordLength, ff
; WRITES:
;   _CTASKS_PrimaryOiWritePendingFlag, _CTASKS_SecondaryOiWritePendingFlag, _CTASKS_PendingPrimaryOiDiskId, _CTASKS_PendingSecondaryOiDiskId, _TEXTDISP_SecondaryGroupPresentFlag, _TEXTDISP_SecondaryGroupEntryCount, _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryGroupHeaderCode, _TEXTDISP_PrimaryGroupRecordChecksum, _TEXTDISP_PrimaryGroupRecordLength, _TEXTDISP_PrimaryGroupPresentFlag, _TEXTDISP_GroupMutationState, _TEXTDISP_SecondaryGroupRecordChecksum, _TEXTDISP_SecondaryGroupRecordLength, _NEWGRID_RefreshStateFlag
; DESC:
;   Clears existing mode-1 group via parser helper, then when a secondary group is
;   present moves all secondary entry/title pointers into primary tables, copies group
;   header metadata, clears secondary state, and rebuilds the NEWGRID index cache.
; NOTES:
;   Pointer arrays are moved by index and secondary table slots are nulled after transfer.
;------------------------------------------------------------------------------
_ESQDISP_PromoteSecondaryGroupToPrimary:
    MOVEM.L D7/A2-A3,-(A7)
    PEA     1.W
    JSR     _ESQPARS_RemoveGroupEntryAndReleaseStrings(PC)

    ADDQ.W  #4,A7
    MOVEQ   #1,D0
    MOVE.L  D0,_NEWGRID_RefreshStateFlag
    MOVEQ   #0,D0
    MOVE.W  D0,_TEXTDISP_GroupMutationState
    CLR.B   _TEXTDISP_PrimaryGroupRecordChecksum
    MOVE.W  D0,_TEXTDISP_PrimaryGroupRecordLength
    MOVE.B  _TEXTDISP_SecondaryGroupPresentFlag,D1
    SUBQ.B  #1,D1
    BNE.W   .sync_task_state_and_reindex

    MOVE.L  D0,D7

.loop_move_secondary_slots:
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.W   D0,D7
    BGE.S   .copy_secondary_group_metadata

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    LEA     _TEXTDISP_SecondaryEntryPtrTable,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    MOVE.L  (A2),(A0)
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A2
    MOVEA.L A2,A3
    ADDA.L  D0,A3
    MOVE.L  (A3),(A0)
    ADDA.L  D0,A1
    SUBA.L  A0,A0
    MOVE.L  A0,(A1)
    ADDA.L  D0,A2
    MOVE.L  A0,(A2)
    ADDQ.W  #1,D7
    BRA.S   .loop_move_secondary_slots

.copy_secondary_group_metadata:
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,_TEXTDISP_PrimaryGroupEntryCount
    MOVE.B  _TEXTDISP_SecondaryGroupRecordChecksum,_TEXTDISP_PrimaryGroupRecordChecksum
    MOVE.B  _TEXTDISP_SecondaryGroupHeaderCode,_TEXTDISP_PrimaryGroupHeaderCode
    MOVE.W  _TEXTDISP_SecondaryGroupRecordLength,_TEXTDISP_PrimaryGroupRecordLength
    MOVE.B  #$1,_TEXTDISP_PrimaryGroupPresentFlag
    MOVEQ   #0,D0
    MOVE.W  D0,_TEXTDISP_SecondaryGroupEntryCount
    MOVEQ   #0,D1
    MOVE.B  D1,_TEXTDISP_SecondaryGroupRecordChecksum
    MOVE.W  D0,_TEXTDISP_SecondaryGroupRecordLength
    MOVE.B  D1,_TEXTDISP_SecondaryGroupPresentFlag
    MOVE.W  #3,_TEXTDISP_GroupMutationState

.sync_task_state_and_reindex:
    MOVE.B  _CTASKS_PendingSecondaryOiDiskId,_CTASKS_PendingPrimaryOiDiskId
    MOVE.B  _CTASKS_SecondaryOiWritePendingFlag,_CTASKS_PrimaryOiWritePendingFlag
    MOVE.B  #$ff,_CTASKS_PendingSecondaryOiDiskId
    CLR.B   _CTASKS_SecondaryOiWritePendingFlag
    JSR     _ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache(PC)

    MOVEM.L (A7)+,D7/A2-A3
    RTS

;!======