    XDEF    LADFUNC_ResetEntryTextBuffers


;------------------------------------------------------------------------------
; FUNC: LADFUNC_ResetEntryTextBuffers   (Rebuild entry text buffersuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A2/A7/D0/D6/D7
; CALLS:
;   _ESQPARS_ReplaceOwnedString, _NEWGRID_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   _LADFUNC_EntryPtrTable, Global_STR_LADFUNC_C_4
; WRITES:
;   entry buffers via _LADFUNC_EntryPtrTable
; DESC:
;   Recomputes per-entry text buffers for banner rectangles.
; NOTES:
;   Loop count is 47 iterations (D7 from 0..46).
;------------------------------------------------------------------------------
LADFUNC_ResetEntryTextBuffers:
    LINK.W  A5,#-8
    MOVEM.L D6-D7/A2,-(A7)
    MOVEQ   #0,D7

.entry_loop:
    MOVEQ   #46,D0
    CMP.W   D0,D7
    BGE.W   .done

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _LADFUNC_EntryPtrTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   (A1)
    BEQ.W   .next_entry

    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    TST.L   6(A2)
    BEQ.W   .next_entry

    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEA.L 6(A1),A0

.scan_text:
    TST.B   (A0)+
    BNE.S   .scan_text

    SUBQ.L  #1,A0
    SUBA.L  6(A1),A0
    MOVE.L  A0,D6
    TST.L   D6
    BLE.S   .update_entry

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _LADFUNC_EntryPtrTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    TST.L   10(A2)
    BEQ.S   .update_entry

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  D6,-(A7)
    MOVE.L  10(A1),-(A7)
    PEA     212.W
    PEA     Global_STR_LADFUNC_C_4
    JSR     _NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.update_entry:
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _LADFUNC_EntryPtrTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  6(A1),-(A7)
    CLR.L   -(A7)
    MOVE.L  A2,24(A7)
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVEA.L 16(A7),A0
    MOVE.L  D0,6(A0)

.next_entry:
    ADDQ.W  #1,D7
    BRA.W   .entry_loop

.done:
    BSR.W   _LADFUNC_ClearBannerRectEntries

    MOVEM.L (A7)+,D6-D7/A2
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LADFUNC_UpdateHighlightCycle   (Update highlight cycleuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A7/D0/D1
; CALLS:
;   NEWGRID_JMPTBL_MATH_DivS32, _LADFUNC_BuildHighlightLinesFromText
; READS:
;   WDISP_HighlightActive, LADFUNC_HighlightCycleCountdown, LADFUNC_HighlightCycleCountdownReload, _LADFUNC_EntryCount, _LADFUNC_EntryPtrTable
; WRITES:
;   _LADFUNC_EntryCount, LADFUNC_HighlightCycleCountdown
; DESC:
;   Advances the highlighted entry when active and refreshes the display.
; NOTES:
;   Resets LADFUNC_HighlightCycleCountdown from LADFUNC_HighlightCycleCountdownReload when the countdown underflows.
;------------------------------------------------------------------------------
    MOVE.W  WDISP_HighlightActive,D0
    SUBQ.W  #1,D0
    BNE.S   .maybe_reset

    MOVE.W  LADFUNC_HighlightCycleCountdown,D0
    BLE.S   .maybe_reset

.find_next_highlight:
    MOVE.W  _LADFUNC_EntryCount,D0
    EXT.L   D0
    ADDQ.L  #1,D0
    MOVEQ   #46,D1
    JSR     NEWGRID_JMPTBL_MATH_DivS32(PC)

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
    MOVE.W  LADFUNC_HighlightCycleCountdown,D0
    MOVE.L  D0,D1
    SUBQ.W  #1,D1
    MOVE.W  D1,LADFUNC_HighlightCycleCountdown

.maybe_reset:
    MOVE.W  WDISP_HighlightActive,D0
    SUBQ.W  #1,D0
    BNE.S   .return

    MOVE.W  LADFUNC_HighlightCycleCountdown,D0
    MOVEQ   #1,D1
    CMP.W   D1,D0
    BGE.S   .return

    MOVE.W  LADFUNC_HighlightCycleCountdownReload,LADFUNC_HighlightCycleCountdown

.return:
    RTS

;!======