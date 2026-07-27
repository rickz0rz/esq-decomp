    XDEF    _ESQ_ReverseBitsIn6Bytes


;------------------------------------------------------------------------------
; FUNC: _ESQ_ReverseBitsIn6Bytes   (ReverseBitsIn6Bytesuncertain)
; ARGS:
;   stack +4: dst (6 bytes)
;   stack +8: src (6 bytes)
; RET:
;   (none)
; CLOBBERS:
;   D0-D4, A0-A1
; CALLS:
;   (none)
; READS:
;   [src]
; WRITES:
;   [dst]
; DESC:
;   Copies six bytes, bit-reversing each non-0/0xFF byte.
; NOTES:
;   Preserves 0x00 and 0xFF without reversal.
;------------------------------------------------------------------------------
_ESQ_ReverseBitsIn6Bytes:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    MOVEM.L D2-D4,-(A7)
    MOVEQ   #5,D0

.copy_loop:
    MOVE.B  (A1)+,D4
    BEQ.S   .store_byte

    CMPI.B  #$ff,D4
    BEQ.S   .store_byte

    MOVEQ   #0,D3
    MOVE.L  D3,D1
    MOVE.B  D4,D1
    MOVE.L  D3,D4
    MOVEQ   #7,D2

.reverse_loop:
    BTST    D2,D1
    BEQ.S   .next_bit

    BSET    D3,D4

.next_bit:
    ADDQ.W  #1,D3
    DBF     D2,.reverse_loop

.store_byte:
    MOVE.B  D4,(A0)+
    DBF     D0,.copy_loop

    MOVEM.L (A7)+,D2-D4
    RTS

;!======