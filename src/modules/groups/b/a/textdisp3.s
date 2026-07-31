    XDEF    _TEXTDISP_FindEntryIndexByWildcard


;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_FindEntryIndexByWildcard   (Find entry index by pattern)
; ARGS:
;   stack +8: patternPtr
; RET:
;   D0: 1 if found, 0 if not
; CLOBBERS:
;   D0/D7/A2-A3
; CALLS:
;   _UNKNOWN_JMPTBL_ESQ_WildcardMatch
; READS:
;   _TEXTDISP_PrimaryEntryPtrTable, _TEXTDISP_PrimaryTitlePtrTable, _TEXTDISP_CurrentMatchIndex
; WRITES:
;   _TEXTDISP_CurrentMatchIndex
; DESC:
;   Scans entries and updates _TEXTDISP_CurrentMatchIndex with the first match index.
; NOTES:
;   Skips entries with flag bit 3 set.
;------------------------------------------------------------------------------
_TEXTDISP_FindEntryIndexByWildcard:
    LINK.W  A5,#-12
    MOVEM.L D7/A2-A3,-(A7)
    MOVE.W  _TEXTDISP_CurrentMatchIndex,_TEXTDISP_CurrentMatchIndexSaved
    MOVEQ   #0,D7

.loop_entries:
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.W   D0,D7
    BGE.S   .not_found

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A3
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    BTST    #3,27(A2)
    BNE.S   .next_entry

    MOVE.L  8(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     _UNKNOWN_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .next_entry

    MOVE.W  D7,_TEXTDISP_CurrentMatchIndex
    MOVEQ   #1,D0
    BRA.S   .return

.next_entry:
    ADDQ.W  #1,D7
    BRA.S   .loop_entries

.not_found:
    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======