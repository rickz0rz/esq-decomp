    XDEF    _MATH_DivS32
    XDEF    _MATH_DivU32
    XDEF    _MATH_Mulu32
    XDEF    __CXD22
    XDEF    __CXD33
    XDEF    __CXM33


;------------------------------------------------------------------------------
; FUNC: _MATH_Mulu32   (Unsigned 32-bit multiply helper.)
; ARGS:
;   D0 = multiplicand
;   D1 = multiplier
; RET:
;   D0: lower 32 bits of product
; CLOBBERS:
;   D0-D3
; DESC:
;   Computes a 32-bit product using 16-bit MULU pieces.
;------------------------------------------------------------------------------
__CXM33:                 ; SAS/C calls the 32-bit multiply helper by this name
_MATH_Mulu32:
    MOVEM.L D2-D3,-(A7)

    MOVE.L  D0,D2
    MOVE.L  D1,D3
    SWAP    D2          ; D2 swaps upper and lower words
    SWAP    D3          ; Same for D3
    MULU    D1,D2       ; Multiply D1 and D2 unsigned (just the lower word?), store in D2
    MULU    D0,D3       ; Multiple D0 and D3 unsigned, store in D3
    MULU    D1,D0       ;
    ADD.W   D3,D2       ; Add lower D3 and D2 words into D2
    SWAP    D2          ; Make the lower D2 word upper
    CLR.W   D2          ; Clear the lower D2 word
    ADD.L   D2,D0       ; Add D2 into D0

    MOVEM.L (A7)+,D2-D3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _MATH_DivS32   (Signed 32-bit division helper.)
; ARGS:
;   D0 = dividend
;   D1 = divisor
; RET:
;   D0 = quotient
;   D1 = REMAINDER, sign-corrected. THIS IS A RETURN VALUE, NOT SCRATCH.
; CLOBBERS:
;   D2-D3
; CALLS:
;   _MATH_DivU32 (unsigned division core)
; DESC:
;   Handles signed division by normalizing signs and dispatching to unsigned.
; NOTES:
;   The auto-generated header used to say "RET: D0: result/status", which reads
;   as though D1 were scratch. It is not, and the four NEG.L D1 instructions
;   below are the proof -- they correct the sign of the remainder and would be
;   dead code otherwise.
;
;   SAS/C reads D1 for the `%` operator. Compile `long r(long a, long b)
;   { return a % b; }` and 6.51 emits BSR.W __CXD33 followed by MOVE.L D1,D0.
;   `/` reads D0 and ignores D1. So a C definition of this routine cannot serve
;   `%` unless every `%` site is first rewritten as x - (x/y)*y, which reads
;   only D0. See AGENTS.md, "The proven blockers were NOT blockers".
;------------------------------------------------------------------------------
__CXD33:                 ; SAS/C calls the signed 32-bit divide helper by this name
_MATH_DivS32:
    TST.L   D0
    BPL.W   .dividend_pos

    NEG.L   D0
    TST.L   D1
    BPL.W   .divisor_pos_after_neg

    NEG.L   D1
    BSR.W   _MATH_DivU32

    NEG.L   D1
    RTS

.divisor_pos_after_neg:
    BSR.W   _MATH_DivU32

    NEG.L   D0
    NEG.L   D1
    RTS

.dividend_pos:
    TST.L   D1
    BPL.W   _MATH_DivU32

    NEG.L   D1
    BSR.W   _MATH_DivU32

    NEG.L   D0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _MATH_DivU32   (Unsigned 32-bit division core.)
; ARGS:
;   D0 = dividend
;   D1 = divisor
; RET:
;   D0: result/status
; CLOBBERS:
;   D0-D3
;------------------------------------------------------------------------------
; SAS/C names this helper __CXD22 and __CXD33's signed sibling __CXD33. The
; digit pair is the operand class, not the width: 3 is signed long, 2 is
; unsigned long. So `unsigned long % 7` compiles to a call to __CXD22 and
; `long / 24` to __CXD33, and both take the same registers -- dividend in D0,
; divisor in D1, quotient back in D0 and REMAINDER in D1, which is exactly this
; routine's contract. The alias is a label, so it emits no bytes and both gates
; stay green.
__CXD22:
_MATH_DivU32:
    MOVE.L  D2,-(A7)

    SWAP    D1
    MOVE.W  D1,D2
    BNE.W   .div_long

    SWAP    D0
    SWAP    D1
    SWAP    D2
    MOVE.W  D0,D2
    BEQ.W   .div_simple_done

    DIVU    D1,D2
    MOVE.W  D2,D0

.div_simple_done:
    SWAP    D0
    MOVE.W  D0,D2
    DIVU    D1,D2
    MOVE.W  D2,D0
    SWAP    D2
    MOVE.W  D2,D1

    MOVE.L  (A7)+,D2
    RTS

.div_long:
    MOVE.L  D3,-(A7)
    MOVEQ   #16,D3
    CMPI.W  #$80,D1
    BCC.W   .shift8

    ROL.L   #8,D1
    SUBQ.W  #8,D3

.shift8:
    CMPI.W  #$800,D1
    BCC.W   .shift4

    ROL.L   #4,D1
    SUBQ.W  #4,D3

.shift4:
    CMPI.W  #$2000,D1
    BCC.W   .shift2

    ROL.L   #2,D1
    SUBQ.W  #2,D3

.shift2:
    TST.W   D1
    BMI.W   .shift1

    ROL.L   #1,D1
    SUBQ.W  #1,D3

.shift1:
    MOVE.W  D0,D2
    LSR.L   D3,D0
    SWAP    D2
    CLR.W   D2
    LSR.L   D3,D2
    SWAP    D3
    DIVU    D1,D0
    MOVE.W  D0,D3
    MOVE.W  D2,D0
    MOVE.W  D3,D2
    SWAP    D1
    MULU    D1,D2
    SUB.L   D2,D0
    BCC.W   .div_finalize

    SUBQ.W  #1,D3
    ADD.L   D1,D0

.adjust_loop:
    BCC.S   .adjust_loop

.div_finalize:
    MOVEQ   #0,D1
    MOVE.W  D3,D1
    SWAP    D3
    ROL.L   D3,D0
    SWAP    D0
    EXG     D0,D1
    MOVE.L  (A7)+,D3
    MOVE.L  (A7)+,D2
    RTS

;!======