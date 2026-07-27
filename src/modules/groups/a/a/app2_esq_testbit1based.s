    XDEF    _ESQ_TestBit1Based


; int32_t test_bit_1based(const uint8_t *base, uint32_t bit_index)
; {
;     uint32_t n = bit_index - 1;          // 1-based -> 0-based
;     uint32_t byte_i = (n & 0xFFFF) >> 3; // because LSR.W
;     uint32_t bit_i  = n & 7;
;     return (base[byte_i] & (1u << bit_i)) ? -1 : 0;
; }
;------------------------------------------------------------------------------
; FUNC: _ESQ_TestBit1Based   (TestBit1Based)
; ARGS:
;   stack +4: base (byte array)
;   stack +8: bitIndex (1-based)
; RET:
;   D0: -1 if bit is set, 0 if clear
; CLOBBERS:
;   D0-D1, A0
; CALLS:
;   (none)
; READS:
;   [base]
; WRITES:
;   (none)
; DESC:
;   Tests a 1-based bit index in a byte array.
; NOTES:
;   Uses LSR.W so index is masked to 16 bits before byte addressing.
;------------------------------------------------------------------------------
_ESQ_TestBit1Based:
    MOVEA.L 4(A7),A0
    MOVE.L  8(A7),D0
    MOVEQ   #0,D1
    SUBQ.L  #1,D0
    MOVE.B  D0,D1
    ANDI.L  #$7,D1
    LSR.W   #3,D0
    BTST    D1,0(A0,D0.W)
    SNE     D0
    EXT.W   D0
    EXT.L   D0
    RTS

;!======