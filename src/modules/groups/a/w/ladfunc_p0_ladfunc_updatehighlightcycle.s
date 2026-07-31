    XDEF    _LADFUNC_UpdateHighlightCycle


;------------------------------------------------------------------------------
; FUNC: _LADFUNC_UpdateHighlightCycle   (Update highlight cycleuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A7/D0/D1
; CALLS:
;   _NEWGRID_JMPTBL_MATH_DivS32, _LADFUNC_BuildHighlightLinesFromText
; READS:
;   _WDISP_HighlightActive, _LADFUNC_HighlightCycleCountdown, _LADFUNC_HighlightCycleCountdownReload, _LADFUNC_EntryCount, _LADFUNC_EntryPtrTable
; WRITES:
;   _LADFUNC_EntryCount, _LADFUNC_HighlightCycleCountdown
; DESC:
;   Advances the highlighted entry when active and refreshes the display.
; NOTES:
;   Resets _LADFUNC_HighlightCycleCountdown from _LADFUNC_HighlightCycleCountdownReload when the countdown underflows.
;------------------------------------------------------------------------------
;   This block carried no label. The extract for whatever precedes it ran
;   on into it and reported that function as larger than it is. The label
;   below is byte-neutral and separates the two again. It is deliberately
;   not XDEF'd: no other module refers to it.
;------------------------------------------------------------------------------
_LADFUNC_UpdateHighlightCycle:
    MOVE.W  _WDISP_HighlightActive,D0
    SUBQ.W  #1,D0
    BNE.S   .maybe_reset

    MOVE.W  _LADFUNC_HighlightCycleCountdown,D0
    BLE.S   .maybe_reset

.find_next_highlight:
    MOVE.W  _LADFUNC_EntryCount,D0
    EXT.L   D0
    ADDQ.L  #1,D0
    MOVEQ   #46,D1
    JSR     _NEWGRID_JMPTBL_MATH_DivS32(PC)

    MOVE.W  D1,_LADFUNC_EntryCount
    MOVE.W  _LADFUNC_EntryCount,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _LADFUNC_EntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEQ   #1,D0
    CMP.W   4(A1),D0
    BNE.S   .find_next_highlight

    MOVE.W  _LADFUNC_EntryCount,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _LADFUNC_EntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  6(A1),-(A7)
    BSR.W   _LADFUNC_BuildHighlightLinesFromText

    ADDQ.W  #4,A7
    MOVE.W  _LADFUNC_HighlightCycleCountdown,D0
    MOVE.L  D0,D1
    SUBQ.W  #1,D1
    MOVE.W  D1,_LADFUNC_HighlightCycleCountdown

.maybe_reset:
    MOVE.W  _WDISP_HighlightActive,D0
    SUBQ.W  #1,D0
    BNE.S   .return

    MOVE.W  _LADFUNC_HighlightCycleCountdown,D0
    MOVEQ   #1,D1
    CMP.W   D1,D0
    BGE.S   .return

    MOVE.W  _LADFUNC_HighlightCycleCountdownReload,_LADFUNC_HighlightCycleCountdown

.return:
    RTS

;!======