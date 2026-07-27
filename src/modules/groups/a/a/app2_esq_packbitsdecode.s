    XDEF    _ESQ_PackBitsDecode


;------------------------------------------------------------------------------
; FUNC: _ESQ_PackBitsDecode   (PackBitsDecodeuncertain)
; ARGS:
;   stack +4: src
;   stack +8: dst
;   stack +12: dstLen
; RET:
;   D0: src pointer after decoding
; CLOBBERS:
;   D0-D1, D6-D7, A0-A1
; CALLS:
;   (none)
; READS:
;   [src]
; WRITES:
;   [dst]
; DESC:
;   Decodes PackBits-style RLE from src into dst.
; NOTES:
;   Positive counts copy literal bytes; negative counts repeat next byte.
;------------------------------------------------------------------------------
_ESQ_PackBitsDecode:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    MOVE.L  12(A7),D0

    MOVEQ   #0,D1
    MOVE.L  D7,-(A7)
    MOVE.L  D6,-(A7)

.decode_loop:
    CMP.W   D0,D1
    BGE.W   .done

    MOVE.B  (A0)+,D7
    TST.B   D7
    BMI.W   .repeat_run

    ADDQ.B  #1,D7

.copy_literals:
    TST.B   D7
    BLE.S   .decode_loop

    MOVE.B  (A0)+,(A1)+
    ADDQ.W  #1,D1
    CMP.W   D0,D1
    BGE.W   .done

    SUBQ.B  #1,D7
    BRA.S   .copy_literals

.repeat_run:
    EXT.W   D7
    EXT.L   D7
    CMPI.L  #$ff,D7
    BEQ.S   .decode_loop

    NEG.L   D7
    ADDQ.L  #1,D7
    MOVE.B  (A0)+,D6

.repeat_byte:
    TST.B   D7
    BLE.S   .decode_loop

    MOVE.B  D6,(A1)+
    ADDQ.W  #1,D1
    CMP.W   D0,D1
    BGE.W   .done

    SUBQ.B  #1,D7
    BRA.S   .repeat_byte

.done:
    MOVE.L  A0,D0
    MOVE.L  (A7)+,D6
    MOVE.L  (A7)+,D7
    RTS

;!======