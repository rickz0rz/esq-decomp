    XDEF    _LADFUNC_ResetEntryTextBuffers



;------------------------------------------------------------------------------
; FUNC: _LADFUNC_ResetEntryTextBuffers   (Rebuild entry text buffersuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A2/A7/D0/D6/D7
; CALLS:
;   _ESQPARS_ReplaceOwnedString, _NEWGRID_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   _LADFUNC_EntryPtrTable, _Global_STR_LADFUNC_C_4
; WRITES:
;   entry buffers via _LADFUNC_EntryPtrTable
; DESC:
;   Recomputes per-entry text buffers for banner rectangles.
; NOTES:
;   Loop count is 47 iterations (D7 from 0..46).
;------------------------------------------------------------------------------
_LADFUNC_ResetEntryTextBuffers:
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
    PEA     _Global_STR_LADFUNC_C_4
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