    XDEF    _COI_EnsureAnimObjectAllocated


;------------------------------------------------------------------------------
; FUNC: _COI_EnsureAnimObjectAllocated   (Routine at _COI_EnsureAnimObjectAllocated)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A5/A7/D0
; CALLS:
;   _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString, _GROUP_AG_JMPTBL_MEMORY_AllocateMemory
; READS:
;   _Global_STR_COI_C_2, _COI_STR_DEFAULT_TOKEN_TEMPLATE_B, MEMF_CLEAR, MEMF_PUBLIC, Struct_AnimOb_Size
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_COI_EnsureAnimObjectAllocated:
    LINK.W  A5,#-8
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  A3,D0
    BEQ.S   .return

    MOVEA.L 48(A3),A0
    MOVE.L  A0,-4(A5)
    BNE.S   .return

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     Struct_AnimOb_Size.W
    PEA     1458.W
    PEA     _Global_STR_COI_C_2
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVE.L  D0,48(A3)
    MOVEA.L D0,A0
    MOVE.L  28(A0),(A7)
    PEA     _COI_STR_DEFAULT_TOKEN_TEMPLATE_B
    MOVE.L  D0,24(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     20(A7),A7
    MOVEA.L 4(A7),A0
    MOVE.L  D0,28(A0)
    MOVEA.L 48(A3),A0
    MOVEQ   #-1,D0
    MOVE.L  D0,32(A0)

.return:
    MOVEA.L (A7)+,A3
    UNLK    A5
    RTS

;!======