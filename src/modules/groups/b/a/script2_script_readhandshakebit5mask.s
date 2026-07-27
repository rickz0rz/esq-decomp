    XDEF    _SCRIPT_ReadHandshakeBit5Mask


;------------------------------------------------------------------------------
; FUNC: _SCRIPT_ReadHandshakeBit5Mask   (ReadHandshakeBit5Mask)
; ARGS:
;   (none)
; RET:
;   D0: CIAB_PRA & $20 (0 or 0x20)
; CLOBBERS:
;   D0-D1/D6-D7
; CALLS:
;   (none)
; READS:
;   CIAB_PRA
; WRITES:
;   (none)
; DESC:
;   Returns CIAB port A bit 5 masked into D0.
; NOTES:
;   Bit meaning is hardware-defined (handshake/status line).
;   This mask is used by CTRL timeout/presence logic and is a practical hook point
;   when experimenting with alternate handshake semantics.
;------------------------------------------------------------------------------
_SCRIPT_ReadHandshakeBit5Mask:
    MOVEM.L D6-D7,-(A7)

    MOVEQ   #0,D7
    MOVE.B  CIAB_PRA,D7
    MOVEQ   #0,D0
    MOVE.W  D7,D0
    MOVEQ   #32,D1
    AND.L   D1,D0
    MOVE.L  D0,D6
    MOVE.L  D6,D0

    MOVEM.L (A7)+,D6-D7
    RTS

;!======