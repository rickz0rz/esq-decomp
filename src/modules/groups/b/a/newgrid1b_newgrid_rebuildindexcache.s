    XDEF    _NEWGRID_RebuildIndexCache




;------------------------------------------------------------------------------
; FUNC: _NEWGRID_RebuildIndexCache   (Rebuild lookup cache)
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
_NEWGRID_RebuildIndexCache:
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