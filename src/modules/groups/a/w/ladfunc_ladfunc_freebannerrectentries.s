    XDEF    _LADFUNC_FreeBannerRectEntries


;------------------------------------------------------------------------------
; FUNC: _LADFUNC_FreeBannerRectEntries   (Free banner rect entriesuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A2/A7/D0/D6/D7
; CALLS:
;   _ESQPARS_ReplaceOwnedString, _NEWGRID_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   _LADFUNC_EntryPtrTable, _Global_STR_LADFUNC_C_2, _Global_STR_LADFUNC_C_3
; WRITES:
;   _LADFUNC_EntryPtrTable (entry pointers)
; DESC:
;   Frees per-entry buffers (if present) and the entry structs themselves.
; NOTES:
;   Loop count is 47 iterations (D7 from 0..46).
;------------------------------------------------------------------------------
_LADFUNC_FreeBannerRectEntries:
    MOVEM.L D6-D7/A2,-(A7)
    MOVEQ   #0,D7

.entry_loop:
    MOVEQ   #46,D0
    CMP.L   D0,D7
    BGE.W   .done

    MOVE.L  D7,D0
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
    BEQ.S   .no_text

    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEA.L 6(A1),A0

.find_null:
    TST.B   (A0)+
    BNE.S   .find_null

    SUBQ.L  #1,A0
    SUBA.L  6(A1),A0
    MOVE.L  A0,D6
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _LADFUNC_EntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  6(A1),-(A7)
    CLR.L   -(A7)
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    BRA.S   .after_len

.no_text:
    MOVEQ   #0,D6

.after_len:
    TST.L   D6
    BLE.S   .after_free_text

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _LADFUNC_EntryPtrTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    TST.L   10(A2)
    BEQ.S   .after_free_text

    MOVE.L  D7,D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  D6,-(A7)
    MOVE.L  10(A1),-(A7)
    PEA     147.W
    PEA     _Global_STR_LADFUNC_C_2
    JSR     _NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.after_free_text:
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _LADFUNC_EntryPtrTable,A0
    ADDA.L  D0,A0
    PEA     14.W
    MOVE.L  (A0),-(A7)
    PEA     150.W
    PEA     _Global_STR_LADFUNC_C_3
    JSR     _NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _LADFUNC_EntryPtrTable,A0
    ADDA.L  D0,A0
    CLR.L   (A0)

.next_entry:
    ADDQ.L  #1,D7
    BRA.W   .entry_loop

.done:
    MOVEM.L (A7)+,D6-D7/A2
    RTS

;!======