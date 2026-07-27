    XDEF    _ESQ_GenerateXorChecksumByte


;------------------------------------------------------------------------------
; FUNC: _ESQ_GenerateXorChecksumByte   (GenerateXorChecksumByteuncertain)
; ARGS:
;   stack +4: seed (initial byte, low 8 bits used)
;   stack +8: src (byte buffer)
;   stack +12: length (bytes)
; RET:
;   D0: checksum byte (low 8 bits)
; CLOBBERS:
;   D0-D2, A0
; CALLS:
;   (none)
; READS:
;   _ESQIFF_RecordChecksumByte, _ESQIFF_UseCachedChecksumFlag
; WRITES:
;   (none)
; DESC:
;   Computes an XOR checksum over a buffer, seeded by an inverted byte.
; NOTES:
;   If _ESQIFF_UseCachedChecksumFlag is non-zero, returns _ESQIFF_RecordChecksumByte instead of computing.
;------------------------------------------------------------------------------
_ESQ_GenerateXorChecksumByte:
    MOVEQ   #0,D0
    MOVE.B  _ESQIFF_RecordChecksumByte,D0
    TST.B   _ESQIFF_UseCachedChecksumFlag
    BNE.S   .return

    MOVE.L  4(A7),D0
    MOVEA.L 8(A7),A0
    MOVE.L  12(A7),D1
    MOVE.L  D2,-(A7)
    MOVE.L  D1,D2
    SUBQ.W  #1,D2
    EORI.B  #$ff,D0
    MOVEQ   #0,D1

.xor_loop:
    MOVE.B  (A0)+,D1
    EOR.B   D1,D0
    DBF     D2,.xor_loop

    ANDI.L  #$ff,D0
    MOVE.L  (A7)+,D2

.return:
    RTS

;!======