    XDEF    _TEXTDISP_SelectGroupAndEntry


;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_SelectGroupAndEntry   (Try primary/secondary group selection)
; ARGS:
;   stack +24: filterStrPtr (A3)
;   stack +28: outPtr (A2)
;   stack +34: entryIndex (word)
; RET:
;   D0: 1 if selection found, 0 otherwise
; CLOBBERS:
;   D0-D7/A2-A3
; CALLS:
;   _TEXTDISP_BuildMatchIndexList, _TEXTDISP_SelectBestMatchFromList
; READS:
;   _TEXTDISP_SecondaryGroupRecordLength, _TEXTDISP_CandidateIndexList/2376/2377/2372
; WRITES:
;   _TEXTDISP_PrimaryFirstMatchIndex, _TEXTDISP_SecondaryFirstMatchIndex, _TEXTDISP_CurrentMatchIndex, _TEXTDISP_SbeFilterActiveFlag, _TEXTDISP_ActiveGroupId
; DESC:
;   Attempts to resolve a filter across groups and updates selection globals.
; NOTES:
;   Uses _TEXTDISP_ActiveGroupId to switch between group 1/2.
;------------------------------------------------------------------------------
_TEXTDISP_SelectGroupAndEntry:
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVEA.L 28(A7),A2
    MOVE.W  34(A7),D7
    MOVEQ   #-1,D0
    MOVE.W  D0,_TEXTDISP_PrimaryFirstMatchIndex
    MOVE.W  D0,_TEXTDISP_SecondaryFirstMatchIndex
    CLR.W   _TEXTDISP_SbeFilterActiveFlag
    MOVE.W  #1,_TEXTDISP_ActiveGroupId
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _TEXTDISP_BuildMatchIndexList

    ADDQ.W  #8,A7
    MOVE.L  D0,D6
    TST.W   D6
    BEQ.S   .check_group1_result

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D7,D1
    EXT.L   D1
    MOVE.L  A3,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A2,-(A7)
    BSR.W   _TEXTDISP_SelectBestMatchFromList

    LEA     16(A7),A7
    MOVE.L  D0,D5
    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_CandidateIndexList,D0
    MOVE.W  D0,_TEXTDISP_PrimaryFirstMatchIndex

.check_group1_result:
    TST.W   D6
    BEQ.S   .try_group2

    TST.W   D5
    BNE.S   .after_group2

.try_group2:
    MOVE.W  _TEXTDISP_SecondaryGroupRecordLength,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .after_group2

    MOVE.W  D1,_TEXTDISP_ActiveGroupId
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _TEXTDISP_BuildMatchIndexList

    ADDQ.W  #8,A7
    MOVE.L  D0,D6
    TST.W   D6
    BEQ.S   .after_group2

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D7,D1
    EXT.L   D1
    MOVE.L  A3,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A2,-(A7)
    BSR.W   _TEXTDISP_SelectBestMatchFromList

    LEA     16(A7),A7
    MOVE.L  D0,D5
    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_CandidateIndexList,D0
    MOVE.W  D0,_TEXTDISP_SecondaryFirstMatchIndex

.after_group2:
    TST.W   D6
    BEQ.S   .no_match

    TST.W   D5
    BNE.S   .select_index

.no_match:
    MOVEQ   #1,D0
    MOVE.W  D0,_TEXTDISP_ActiveGroupId
    MOVEQ   #0,D0
    BRA.S   .return

.select_index:
    MOVEQ   #2,D0
    CMP.W   D0,D5
    BNE.S   .use_primary_index

    MOVE.B  _TEXTDISP_BannerCharSelected,D0
    MOVEQ   #100,D1
    CMP.B   D1,D0
    BNE.S   .use_alt_index

    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_BannerFallbackEntryIndex,D0
    BRA.S   .store_selected_index

.use_alt_index:
    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_BannerSelectedEntryIndex,D0

.store_selected_index:
    MOVE.W  D0,_TEXTDISP_CurrentMatchIndex
    BRA.S   .return_success

.use_primary_index:
    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_CandidateIndexList,D0
    MOVE.W  D0,_TEXTDISP_CurrentMatchIndex

.return_success:
    MOVEQ   #1,D0

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3
    RTS

;!======