    XDEF    _SCRIPT_AssertCtrlLine
    XDEF    SCRIPT_AssertCtrlLineIfEnabled
    XDEF    SCRIPT_AssertCtrlLineNow
    XDEF    SCRIPT_ClearCtrlLineIfEnabled
    XDEF    _SCRIPT_DeassertCtrlLine
    XDEF    SCRIPT_DeassertCtrlLineNow
    XDEF    SCRIPT_ESQ_CaptureCtrlBit4StreamBufferByte
    XDEF    SCRIPT_GetCtrlLineFlag
    XDEF    SCRIPT_ReadHandshakeBit3Flag
    XDEF    _SCRIPT_ReadHandshakeBit5Mask
    XDEF    SCRIPT_ReadNextRbfByte
    XDEF    SCRIPT_PollHandshakeAndApplyTimeout
    XDEF    _SCRIPT_UpdateSerialShadowFromCtrlByte


;------------------------------------------------------------------------------
; FUNC: SCRIPT_ReadNextRbfByte   (ReadNextRbfByte)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   D0
; CALLS:
;   SCRIPT2_JMPTBL_ESQ_ReadSerialRbfByte
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Thin wrapper around ESQ_ReadSerialRbfByte.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
SCRIPT_ReadNextRbfByte:
    JSR     SCRIPT2_JMPTBL_ESQ_ReadSerialRbfByte(PC)

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_ESQ_CaptureCtrlBit4StreamBufferByte   (Routine at SCRIPT_ESQ_CaptureCtrlBit4StreamBufferByte)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   SCRIPT2_JMPTBL_ESQ_CaptureCtrlBit4StreamBufferByte
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
SCRIPT_ESQ_CaptureCtrlBit4StreamBufferByte:
    JSR     SCRIPT2_JMPTBL_ESQ_CaptureCtrlBit4StreamBufferByte(PC)

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _SCRIPT_UpdateSerialShadowFromCtrlByte   (Latch low control bits and write serial word)
; ARGS:
;   stack +8: ctrlByte (u8)
; RET:
;   D0: none
; CLOBBERS:
;   A7/D0/D1/D7
; CALLS:
;   _SCRIPT_WriteCtrlShadowToSerdat
; READS:
;   _SCRIPT_SerialShadowWord
; WRITES:
;   _SCRIPT_SerialShadowWord, _SCRIPT_SerialInputLatch
; DESC:
;   Stores ctrlByte in _SCRIPT_SerialInputLatch, merges low 2 bits into the
;   serial shadow word, then writes the updated word to serial hardware.
; NOTES:
;   Preserves non-control bits with mask $FC.
;------------------------------------------------------------------------------
_SCRIPT_UpdateSerialShadowFromCtrlByte:
    MOVE.L  D7,-(A7)

    MOVE.B  11(A7),D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.W  D0,_SCRIPT_SerialInputLatch
    ANDI.B  #$3,D7
    MOVEQ   #0,D0
    MOVE.W  _SCRIPT_SerialShadowWord,D0
    MOVEQ   #126,D1
    ADD.L   D1,D1
    AND.L   D1,D0
    OR.B    D0,D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.W  D0,_SCRIPT_SerialShadowWord
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,-(A7)
    BSR.W   _SCRIPT_WriteCtrlShadowToSerdat

    ADDQ.W  #4,A7

    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _SCRIPT_AssertCtrlLine   (AssertCtrlLine)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1
; CALLS:
;   _SCRIPT_WriteCtrlShadowToSerdat
; READS:
;   _SCRIPT_SerialShadowWord
; WRITES:
;   _SCRIPT_CtrlLineAssertedFlag, _SCRIPT_SerialShadowWord, SERDAT
; DESC:
;   Sets the CTRL/serial output bit in the shadow register and pushes it to
;   the serial data register.
; NOTES:
;   _SCRIPT_CtrlLineAssertedFlag appears to mirror the asserted/deasserted state.
;   Bit 5 ($20) is treated as the CTRL/handshake output bit in the serial shadow word;
;   physical line mapping (e.g., RTS on attached hardware) is board/cable dependent ??.
;------------------------------------------------------------------------------
_SCRIPT_AssertCtrlLine:
    MOVE.W  #1,_SCRIPT_CtrlLineAssertedFlag
    MOVE.W  _SCRIPT_SerialShadowWord,D0
    MOVE.L  D0,D1
    ORI.W   #32,D1
    MOVE.W  D1,_SCRIPT_SerialShadowWord
    MOVEQ   #0,D0
    MOVE.W  D1,D0
    MOVE.L  D0,-(A7)
    BSR.W   _SCRIPT_WriteCtrlShadowToSerdat

    ADDQ.W  #4,A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_AssertCtrlLineIfEnabled   (AssertCtrlLineIfEnabled)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1
; CALLS:
;   _SCRIPT_AssertCtrlLine
; READS:
;   _SCRIPT_CtrlInterfaceEnabledFlag
; WRITES:
;   _SCRIPT_CtrlLineAssertedFlag, _SCRIPT_SerialShadowWord, SERDAT
; DESC:
;   Asserts the CTRL/serial output bit when the control interface is enabled.
; NOTES:
;   _SCRIPT_CtrlInterfaceEnabledFlag acts as an enable gate.
;------------------------------------------------------------------------------
SCRIPT_AssertCtrlLineIfEnabled:
    TST.W   _SCRIPT_CtrlInterfaceEnabledFlag
    BEQ.S   .return_status

    BSR.S   _SCRIPT_AssertCtrlLine

.return_status:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _SCRIPT_DeassertCtrlLine   (DeassertCtrlLine)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1
; CALLS:
;   _SCRIPT_WriteCtrlShadowToSerdat
; READS:
;   _SCRIPT_SerialShadowWord
; WRITES:
;   _SCRIPT_CtrlLineAssertedFlag, _SCRIPT_SerialShadowWord, SERDAT
; DESC:
;   Clears the CTRL/serial output bit in the shadow register and pushes it to
;   the serial data register.
; NOTES:
;   _SCRIPT_CtrlLineAssertedFlag appears to mirror the asserted/deasserted state.
;------------------------------------------------------------------------------
_SCRIPT_DeassertCtrlLine:
    CLR.W   _SCRIPT_CtrlLineAssertedFlag
    MOVE.W  _SCRIPT_SerialShadowWord,D0
    MOVE.L  D0,D1
    ANDI.W  #$ffdf,D1
    MOVE.W  D1,_SCRIPT_SerialShadowWord
    MOVEQ   #0,D0
    MOVE.W  D1,D0
    MOVE.L  D0,-(A7)
    BSR.W   _SCRIPT_WriteCtrlShadowToSerdat

    ADDQ.W  #4,A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_ClearCtrlLineIfEnabled   (ClearCtrlLineIfEnabled)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0/D1
; CALLS:
;   _SCRIPT_DeassertCtrlLine
; READS:
;   _SCRIPT_CtrlInterfaceEnabledFlag
; WRITES:
;   _SCRIPT_CtrlLineAssertedFlag, _SCRIPT_SerialShadowWord (via _SCRIPT_DeassertCtrlLine)
; DESC:
;   Clears the CTRL/serial output bit when the control interface is enabled.
; NOTES:
;   _SCRIPT_DeassertCtrlLine updates _SCRIPT_SerialShadowWord and sends SERDAT.
;------------------------------------------------------------------------------
SCRIPT_ClearCtrlLineIfEnabled:
    TST.W   _SCRIPT_CtrlInterfaceEnabledFlag
    BEQ.S   .return_status

    BSR.S   _SCRIPT_DeassertCtrlLine

.return_status:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_AssertCtrlLineNow   (Assert CTRL line immediately)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1
; CALLS:
;   _SCRIPT_AssertCtrlLine
; READS:
;   _SCRIPT_SerialShadowWord
; WRITES:
;   _SCRIPT_CtrlLineAssertedFlag, _SCRIPT_SerialShadowWord, SERDAT
; DESC:
;   Unconditionally asserts the CTRL/serial output bit.
;------------------------------------------------------------------------------
SCRIPT_AssertCtrlLineNow:
    BSR.S   _SCRIPT_AssertCtrlLine

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_DeassertCtrlLineNow   (Deassert CTRL line immediately)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1
; CALLS:
;   _SCRIPT_DeassertCtrlLine
; READS:
;   _SCRIPT_SerialShadowWord
; WRITES:
;   _SCRIPT_CtrlLineAssertedFlag, _SCRIPT_SerialShadowWord, SERDAT
; DESC:
;   Unconditionally deasserts the CTRL/serial output bit.
;------------------------------------------------------------------------------
SCRIPT_DeassertCtrlLineNow:
    BSR.S   _SCRIPT_DeassertCtrlLine

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_PollHandshakeAndApplyTimeout   (PollHandshakeAndApplyTimeout)
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
SCRIPT_PollHandshakeAndApplyTimeout:
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

;------------------------------------------------------------------------------
; FUNC: SCRIPT_ReadHandshakeBit3Flag   (ReadHandshakeBit3Flag)
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
SCRIPT_ReadHandshakeBit3Flag:
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

;------------------------------------------------------------------------------
; FUNC: SCRIPT_GetCtrlLineFlag   (GetCtrlLineFlag)
; ARGS:
;   (none)
; RET:
;   D0: _SCRIPT_CtrlLineAssertedFlag (shadow flag)
; CLOBBERS:
;   D0
; CALLS:
;   (none)
; READS:
;   _SCRIPT_CtrlLineAssertedFlag
; WRITES:
;   (none)
; DESC:
;   Returns the cached CTRL line asserted flag.
;------------------------------------------------------------------------------
SCRIPT_GetCtrlLineFlag:
    MOVE.L  D7,-(A7)
    MOVE.W  _SCRIPT_CtrlLineAssertedFlag,D7
    MOVE.L  D7,D0
    MOVE.L  (A7)+,D7
    RTS

;!======
