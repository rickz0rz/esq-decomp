    XDEF    _ESQPARS_ReplaceOwnedString
    XDEF    ESQPARS_ReplaceOwnedString_Return


;------------------------------------------------------------------------------
; FUNC: _ESQPARS_ReplaceOwnedString   (Replace owned heap string)
; ARGS:
;   stack +4: A3 source string pointer (new text, NUL-terminated)
;   stack +8: A2 owned string pointer (old text to release, may be NULL)
; RET:
;   D0: newly allocated replacement pointer, or NULL
; CLOBBERS:
;   A0/A1/A2/A3/A6/A7/D0/D1/D6/D7
; CALLS:
;   _ESQIFF_JMPTBL_MEMORY_AllocateMemory, _ESQIFF_JMPTBL_MEMORY_DeallocateMemory, _LVOAvailMem
; READS:
;   AbsExecBase, _Global_STR_ESQPARS_C_5, _Global_STR_ESQPARS_C_6, MEMF_PUBLIC
; WRITES:
;   (none observed)
; DESC:
;   Replaces an owned heap string by freeing the prior pointer (if non-NULL),
;   then allocating/copying the replacement source string.
; NOTES:
;   Deallocates old text before attempting new allocation.
;   If source is NULL or empty, returns NULL after release.
;   Allocation only runs when AvailMem(MEMF_PUBLIC) > $2710.
;   Callers must tolerate NULL on low-memory or empty-input paths.
;------------------------------------------------------------------------------
_ESQPARS_ReplaceOwnedString:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEA.L 24(A7),A2

    MOVE.L  A2,D0
    BEQ.S   .check_new_source

    MOVEA.L A2,A0

.measure_old_len_loop:
    TST.B   (A0)+
    BNE.S   .measure_old_len_loop

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,D0
    MOVE.L  D0,D7
    ADDQ.L  #1,D7
    MOVE.L  D7,-(A7)
    MOVE.L  A2,-(A7)
    PEA     1081.W
    PEA     _Global_STR_ESQPARS_C_5
    JSR     _ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.check_new_source:
    MOVE.L  A3,D0
    BNE.S   .measure_new_len

    MOVEQ   #0,D0
    BRA.S   ESQPARS_ReplaceOwnedString_Return

.measure_new_len:
    MOVEA.L A3,A0

.measure_new_len_loop:
    TST.B   (A0)+
    BNE.S   .measure_new_len_loop

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D0
    MOVE.L  D0,D6
    ADDQ.L  #1,D6
    MOVEQ   #1,D0
    CMP.L   D0,D6
    BNE.S   .maybe_allocate_new

    MOVEQ   #0,D0
    BRA.S   ESQPARS_ReplaceOwnedString_Return

.maybe_allocate_new:
    ; Low-memory guard: skip allocation unless free public memory exceeds $2710.
    SUBA.L  A2,A2
    MOVEQ   #1,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAvailMem(A6)

    CMPI.L  #$2710,D0
    BLE.S   .copy_new_text

    PEA     (MEMF_PUBLIC).W
    MOVE.L  D6,-(A7)
    PEA     1100.W
    PEA     _Global_STR_ESQPARS_C_6
    JSR     _ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A2

.copy_new_text:
    MOVE.L  A2,D0
    BEQ.S   .return_ptr

    ; Copy replacement string including NUL terminator.
    MOVEA.L A3,A0
    MOVEA.L A2,A1

.copy_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_loop

.return_ptr:
    MOVE.L  A2,D0

;------------------------------------------------------------------------------
; FUNC: ESQPARS_ReplaceOwnedString_Return   (Shared epilogue for owned-string replacement)
; ARGS:
;   (none observed)
; RET:
;   D0: replacement pointer (or NULL)
; CLOBBERS:
;   D6
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Restores saved registers and returns replacement pointer in D0.
; NOTES:
;   Shared return for empty-source, low-memory, and successful-copy paths.
;------------------------------------------------------------------------------
ESQPARS_ReplaceOwnedString_Return:
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======