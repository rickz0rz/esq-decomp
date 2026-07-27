    XDEF    _SCRIPT_ReadHandshakeBit3Flag


;------------------------------------------------------------------------------
; FUNC: _SCRIPT_ReadHandshakeBit3Flag   (ReadHandshakeBit3Flag)
; ARGS:
;   (none)
; RET:
;   D0: 1 if CIAB_PRA bit3 set, else 0
; CLOBBERS:
;   D0/D6-D7
; CALLS:
;   (none)
; READS:
;   CIAB_PRA
; WRITES:
;   (none)
; DESC:
;   Reads CIAB port A bit 3 and returns it as a boolean.
; NOTES:
;   Bit meaning is hardware-defined (handshake/status line).
;   Often treated as a sideband/status line in custom transfer setups ??.
;------------------------------------------------------------------------------
_SCRIPT_ReadHandshakeBit3Flag:
    MOVEM.L D6-D7,-(A7)

    MOVEQ   #0,D7
    MOVE.B  CIAB_PRA,D7
    BTST    #3,D7
    BEQ.S   .clear_flag

    MOVEQ   #1,D6
    BRA.S   .return_status

.clear_flag:
    MOVEQ   #0,D6

.return_status:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7
    RTS

;!======