    XDEF    _LADFUNC_AllocBannerRectEntries


;------------------------------------------------------------------------------
; FUNC: _LADFUNC_AllocBannerRectEntries   (Allocate banner rect entriesuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A7/D0/D7
; CALLS:
;   _NEWGRID_JMPTBL_MEMORY_AllocateMemory
; READS:
;   _LADFUNC_EntryPtrTable, _Global_STR_LADFUNC_C_1
; WRITES:
;   _LADFUNC_EntryPtrTable (entry pointers)
; DESC:
;   Allocates 14-byte structs for each banner rectangle slot.
; NOTES:
;   Loop count is 47 iterations (D7 from 0..46).
;------------------------------------------------------------------------------
_LADFUNC_AllocBannerRectEntries:
    LINK.W  A5,#-4
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7

.alloc_loop:
    MOVEQ   #46,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _LADFUNC_EntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     14.W
    PEA     116.W
    PEA     _Global_STR_LADFUNC_C_1
    MOVE.L  A0,20(A7)
    JSR     _NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L 4(A7),A0
    MOVE.L  D0,(A0)
    ADDQ.L  #1,D7
    BRA.S   .alloc_loop

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======