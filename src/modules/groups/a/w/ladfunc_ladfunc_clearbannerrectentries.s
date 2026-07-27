    XDEF    _LADFUNC_ClearBannerRectEntries


;------------------------------------------------------------------------------
; FUNC: _LADFUNC_ClearBannerRectEntries   (Clear banner rect entriesuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A3/A7/D0/D1/D7
; CALLS:
;   (none)
; READS:
;   _LADFUNC_EntryPtrTable, _ED_DiagScrollSpeedChar
; WRITES:
;   _LADFUNC_EntryPtrTable entry fields, _ED_TextLimit, LADFUNC_HighlightCycleCountdown, _LADFUNC_EntryCount, _LADFUNC_ParsedEntryCount,
;   WDISP_HighlightActive, _WDISP_HighlightIndex
; DESC:
;   Clears entry fields and resets highlight/row-count globals.
; NOTES:
;   Loop count is 47 iterations (D7 from 0..46).
;------------------------------------------------------------------------------
_LADFUNC_ClearBannerRectEntries:
    MOVEM.L D7/A3,-(A7)
    MOVEQ   #0,D7

.entry_loop:
    MOVEQ   #46,D0
    CMP.W   D0,D7
    BGE.S   .after_loop

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _LADFUNC_EntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A3
    MOVEQ   #0,D0
    MOVE.W  D0,(A3)
    MOVE.W  D0,2(A3)
    MOVE.W  D0,4(A3)
    SUBA.L  A0,A0
    MOVE.L  A0,6(A3)
    MOVE.L  A0,10(A3)
    ADDQ.W  #1,D7
    BRA.S   .entry_loop

.after_loop:
    MOVEQ   #0,D0
    MOVE.W  D0,LADFUNC_HighlightCycleCountdown
    MOVE.W  D0,_LADFUNC_EntryCount
    MOVE.W  D0,_LADFUNC_ParsedEntryCount
    MOVE.W  D0,WDISP_HighlightActive
    MOVE.W  D0,_WDISP_HighlightIndex
    MOVEQ   #0,D0
    MOVE.B  _ED_DiagScrollSpeedChar,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.L  D0,_ED_TextLimit
    MOVEM.L (A7)+,D7/A3
    RTS

;!======