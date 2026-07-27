    XDEF    _SCRIPT_PollHandshakeAndApplyTimeout


;------------------------------------------------------------------------------
; FUNC: _SCRIPT_PollHandshakeAndApplyTimeout   (PollHandshakeAndApplyTimeout)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1
; CALLS:
;   _SCRIPT_ReadHandshakeBit5Mask
; READS:
;   _SCRIPT_CtrlInterfaceEnabledFlag, CIAB_PRA
; WRITES:
;   _SCRIPT_CtrlLineAssertedTicks, _ESQIFF_ExternalAssetFlags, _LADFUNC_EntryCount
; DESC:
;   Polls the CTRL line and increments a counter while it stays asserted; once
;   a threshold is reached, resets related counters/flags.
; NOTES:
;   Uses CIAB_PRA bitmask (via _SCRIPT_ReadHandshakeBit5Mask).
;   This is the handshake-input poll path used by control-timeout logic, separate
;   from the byte-stream parser that consumes serial payload bytes.
;------------------------------------------------------------------------------
_SCRIPT_PollHandshakeAndApplyTimeout:
    TST.W   _SCRIPT_CtrlInterfaceEnabledFlag
    BEQ.S   .return_status

    BSR.W   _SCRIPT_ReadHandshakeBit5Mask

    TST.B   D0
    BEQ.S   .return_status

    MOVE.W  _SCRIPT_CtrlLineAssertedTicks,D0
    MOVE.L  D0,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,_SCRIPT_CtrlLineAssertedTicks
    MOVEQ   #20,D0
    CMP.W   D0,D1
    BCS.S   .return_status

    MOVEQ   #0,D0
    MOVE.W  D0,_ESQIFF_ExternalAssetFlags
    MOVE.W  #$24,_LADFUNC_EntryCount
    MOVE.W  D0,_SCRIPT_CtrlLineAssertedTicks

.return_status:
    RTS

;!======