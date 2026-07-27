    XDEF    _P_TYPE_FreeEntry


;------------------------------------------------------------------------------
; FUNC: _P_TYPE_FreeEntry   (Free entry struct and optional payload buffer)
; ARGS:
;   stack +8: entryPtr (struct PTypeEntry *)
; RET:
;   D0: none
; CLOBBERS:
;   A3/A7/D0
; CALLS:
;   _SCRIPT_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   _Global_STR_P_TYPE_C_4, Global_STR_P_TYPE_C_5
; WRITES:
;   (none observed)
; DESC:
;   Frees payload buffer at +6 (if non-null) and then frees the 10-byte entry.
; NOTES:
;   Safe to call with null entry pointer.
;------------------------------------------------------------------------------
_P_TYPE_FreeEntry:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.L  A3,D0
    BEQ.S   .return_1364

    TST.L   6(A3)
    BEQ.S   .if_eq_1363

    MOVE.L  2(A3),D0
    MOVE.L  D0,-(A7)
    MOVE.L  6(A3),-(A7)
    PEA     92.W
    PEA     _Global_STR_P_TYPE_C_4
    JSR     _SCRIPT_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.if_eq_1363:
    PEA     10.W
    MOVE.L  A3,-(A7)
    PEA     95.W
    PEA     Global_STR_P_TYPE_C_5
    JSR     _SCRIPT_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.return_1364:
    MOVEA.L (A7)+,A3
    RTS

;!======