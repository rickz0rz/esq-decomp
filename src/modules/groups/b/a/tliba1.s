    XDEF    _TLIBA1_DrawTextWithInsetSegments


;!======

;------------------------------------------------------------------------------
; FUNC: _TLIBA1_DrawTextWithInsetSegments   (Draw text with inline $13/$14 inset segments)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +16: arg_4 (via 20(A5))
;   stack +19: arg_5 (via 23(A5))
;   stack +23: arg_6 (via 27(A5))
;   stack +24: arg_7 (via 28(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D5/D6/D7
; CALLS:
;   _MEMORY_AllocateMemory, _MEMORY_DeallocateMemory, _SCRIPT_DrawInsetTextWithFrame, _STR_FindCharPtr, _LVOMove, _LVOText
; READS:
;   Global_REF_GRAPHICS_LIBRARY, _Global_STR_TLIBA1_C_1, _Global_STR_TLIBA1_C_2, MEMF_CLEAR, MEMF_PUBLIC, if_eq_1768, if_ne_1763, return_176B
; WRITES:
;   (none observed)
; DESC:
;   Copies source text into a scratch buffer, splits on control bytes $13/$14,
;   draws plain spans directly, and renders inset spans via SCRIPT helper.
; NOTES:
;   Gracefully returns when input text is null/empty or allocation fails.
;------------------------------------------------------------------------------
_TLIBA1_DrawTextWithInsetSegments:
    LINK.W  A5,#-20
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    MOVE.B  23(A5),D5
    MOVEA.L 28(A5),A2
    CLR.L   -16(A5)
    MOVE.L  A2,D0
    BEQ.S   .if_eq_1762

    TST.B   (A2)
    BEQ.S   .if_eq_1762

    MOVEA.L A2,A0

.if_ne_1760:
    TST.B   (A0)+
    BNE.S   .if_ne_1760

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-20(A5)
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     1842.W
    PEA     _Global_STR_TLIBA1_C_1
    JSR     _MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-16(A5)
    MOVEA.L A2,A0
    MOVEA.L D0,A1

.if_ne_1761:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .if_ne_1761

.if_eq_1762:
    TST.L   -16(A5)
    BEQ.W   .return_176B

    MOVEA.L -16(A5),A0
    PEA     19.W
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-12(A5)
    JSR     _STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    TST.L   -8(A5)
    BEQ.W   .if_eq_1768

.if_ne_1763:
    MOVEA.L -12(A5),A0
    PEA     20.W
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-4(A5)
    JSR     _STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)
    TST.L   -8(A5)
    BEQ.S   .if_eq_1764

    MOVEQ   #0,D1
    MOVEA.L -8(A5),A0
    MOVE.B  D1,(A0)+
    MOVE.L  A0,-8(A5)

.if_eq_1764:
    TST.L   D0
    BEQ.S   .if_eq_1765

    MOVEA.L D0,A0
    CLR.B   (A0)+
    MOVE.L  A0,-12(A5)

.if_eq_1765:
    TST.L   -4(A5)
    BEQ.S   .if_eq_1767

    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.S   .if_eq_1767

.if_ne_1766:
    TST.B   (A0)+
    BNE.S   .if_ne_1766

    SUBQ.L  #1,A0
    SUBA.L  -4(A5),A0
    MOVEA.L A3,A1
    MOVE.L  A0,D0
    MOVEA.L -4(A5),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOText(A6)

.if_eq_1767:
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVEQ   #0,D1
    MOVE.B  27(A5),D1
    MOVE.L  -8(A5),-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    JSR     _SCRIPT_DrawInsetTextWithFrame(PC)

    LEA     16(A7),A7
    PEA     19.W
    MOVE.L  -12(A5),-(A7)
    JSR     _STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BNE.W   .if_ne_1763

.if_eq_1768:
    TST.L   -12(A5)
    BEQ.S   .if_eq_176A

    MOVEA.L -12(A5),A0
    TST.B   (A0)
    BEQ.S   .if_eq_176A

.if_ne_1769:
    TST.B   (A0)+
    BNE.S   .if_ne_1769

    SUBQ.L  #1,A0
    SUBA.L  -12(A5),A0
    MOVEA.L A3,A1
    MOVE.L  A0,D0
    MOVEA.L -12(A5),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOText(A6)

.if_eq_176A:
    MOVE.L  -20(A5),-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     1885.W
    PEA     _Global_STR_TLIBA1_C_2
    JSR     _MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.return_176B:
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======