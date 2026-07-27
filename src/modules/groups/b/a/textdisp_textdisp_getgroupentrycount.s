    XDEF    _TEXTDISP_GetGroupEntryCount


;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_GetGroupEntryCount   (Lookup entry count for group)
; ARGS:
;   stack +12: groupId (long)
; RET:
;   D0: count (word, zero if unsupported)
; CLOBBERS:
;   D0/D6-D7
; READS:
;   _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_SecondaryGroupEntryCount
; DESC:
;   Returns the entry count for group 1 or 2.
; NOTES:
;   Unknown behavior for other group IDs.
;------------------------------------------------------------------------------
_TEXTDISP_GetGroupEntryCount:
    MOVEM.L D6-D7,-(A7)
    MOVE.L  12(A7),D7
    MOVE.L  D7,D0
    SUBQ.L  #1,D0
    BEQ.S   .use_count_primary

    SUBQ.L  #1,D0
    BEQ.S   .use_count_secondary

    BRA.S   .use_count_zero

.use_count_primary:
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D6
    BRA.S   .return

.use_count_secondary:
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D6
    BRA.S   .return

.use_count_zero:
    MOVEQ   #0,D6

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7
    RTS

;!======