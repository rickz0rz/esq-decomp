LAB_14AF:
    JSR     LAB_14C3(PC)

    RTS

;!======

SCRIPT_GetCtrlBuffer:
    JSR     j_getCTRLBuffer(PC)

    RTS

;!======

LAB_14B1:
    MOVE.L  D7,-(A7)

    MOVE.B  11(A7),D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.W  D0,LAB_2342
    ANDI.B  #$3,D7
    MOVEQ   #0,D0
    MOVE.W  LAB_2341,D0
    MOVEQ   #126,D1
    ADD.L   D1,D1
    AND.L   D1,D0
    OR.B    D0,D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.W  D0,LAB_2341
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,-(A7)
    BSR.W   SCRIPT_WriteSerialDataWord

    ADDQ.W  #4,A7

    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_AssertCtrlLine   (AssertCtrlLine??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1
; CALLS:
;   SCRIPT_WriteSerialDataWord
; READS:
;   LAB_2341
; WRITES:
;   LAB_20AC, LAB_2341, SERDAT
; DESC:
;   Sets the CTRL/serial output bit in the shadow register and pushes it to
;   the serial data register.
; NOTES:
;   LAB_20AC appears to mirror the asserted/deasserted state.
;------------------------------------------------------------------------------
SCRIPT_AssertCtrlLine:
LAB_14B2:
    MOVE.W  #1,LAB_20AC
    MOVE.W  LAB_2341,D0
    MOVE.L  D0,D1
    ORI.W   #32,D1
    MOVE.W  D1,LAB_2341
    MOVEQ   #0,D0
    MOVE.W  D1,D0
    MOVE.L  D0,-(A7)
    BSR.W   SCRIPT_WriteSerialDataWord

    ADDQ.W  #4,A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_AssertCtrlLineIfEnabled   (AssertCtrlLineIfEnabled??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1
; CALLS:
;   SCRIPT_AssertCtrlLine
; READS:
;   LAB_2294
; WRITES:
;   LAB_20AC, LAB_2341, SERDAT
; DESC:
;   Asserts the CTRL/serial output bit when the control interface is enabled.
; NOTES:
;   LAB_2294 acts as an enable gate.
;------------------------------------------------------------------------------
SCRIPT_AssertCtrlLineIfEnabled:
LAB_14B3:
    TST.W   LAB_2294
    BEQ.S   .return_status

    BSR.S   SCRIPT_AssertCtrlLine

.return_status:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_DeassertCtrlLine   (DeassertCtrlLine??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1
; CALLS:
;   SCRIPT_WriteSerialDataWord
; READS:
;   LAB_2341
; WRITES:
;   LAB_20AC, LAB_2341, SERDAT
; DESC:
;   Clears the CTRL/serial output bit in the shadow register and pushes it to
;   the serial data register.
; NOTES:
;   LAB_20AC appears to mirror the asserted/deasserted state.
;------------------------------------------------------------------------------
SCRIPT_DeassertCtrlLine:
LAB_14B5:
    CLR.W   LAB_20AC
    MOVE.W  LAB_2341,D0
    MOVE.L  D0,D1
    ANDI.W  #$ffdf,D1
    MOVE.W  D1,LAB_2341
    MOVEQ   #0,D0
    MOVE.W  D1,D0
    MOVE.L  D0,-(A7)
    BSR.W   SCRIPT_WriteSerialDataWord

    ADDQ.W  #4,A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_ClearCtrlLineIfEnabled   (ClearCtrlLineIfEnabled??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0/D1
; CALLS:
;   SCRIPT_DeassertCtrlLine
; READS:
;   LAB_2294
; WRITES:
;   LAB_20AC, LAB_2341 (via SCRIPT_DeassertCtrlLine)
; DESC:
;   Clears the CTRL/serial output bit when the control interface is enabled.
; NOTES:
;   SCRIPT_DeassertCtrlLine updates LAB_2341 and sends SERDAT.
;------------------------------------------------------------------------------
SCRIPT_ClearCtrlLineIfEnabled:
LAB_14B6:
    TST.W   LAB_2294
    BEQ.S   .return_status

    BSR.S   SCRIPT_DeassertCtrlLine

.return_status:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_AssertCtrlLineNow   (AssertCtrlLineNow??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1
; CALLS:
;   SCRIPT_AssertCtrlLine
; READS:
;   LAB_2341
; WRITES:
;   LAB_20AC, LAB_2341, SERDAT
; DESC:
;   Unconditionally asserts the CTRL/serial output bit.
;------------------------------------------------------------------------------
SCRIPT_AssertCtrlLineNow:
LAB_14B8:
    BSR.S   SCRIPT_AssertCtrlLine

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_DeassertCtrlLineNow   (DeassertCtrlLineNow??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1
; CALLS:
;   SCRIPT_DeassertCtrlLine
; READS:
;   LAB_2341
; WRITES:
;   LAB_20AC, LAB_2341, SERDAT
; DESC:
;   Unconditionally deasserts the CTRL/serial output bit.
;------------------------------------------------------------------------------
SCRIPT_DeassertCtrlLineNow:
LAB_14B9:
    BSR.S   SCRIPT_DeassertCtrlLine

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_UpdateCtrlLineTimeout   (UpdateCtrlLineTimeout??)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1
; CALLS:
;   SCRIPT_ReadCiaBBit5Mask
; READS:
;   LAB_2294, CIAB_PRA
; WRITES:
;   LAB_2343, LAB_22A9, LAB_2265
; DESC:
;   Polls the CTRL line and increments a counter while it stays asserted; once
;   a threshold is reached, resets related counters/flags.
; NOTES:
;   Uses CIAB_PRA bitmask (via SCRIPT_ReadCiaBBit5Mask).
;------------------------------------------------------------------------------
SCRIPT_UpdateCtrlLineTimeout:
LAB_14BA:
    TST.W   LAB_2294
    BEQ.S   .return_status

    BSR.W   SCRIPT_ReadCiaBBit5Mask

    TST.B   D0
    BEQ.S   .return_status

    MOVE.W  LAB_2343,D0
    MOVE.L  D0,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,LAB_2343
    MOVEQ   #20,D0
    CMP.W   D0,D1
    BCS.S   .return_status

    MOVEQ   #0,D0
    MOVE.W  D0,LAB_22A9
    MOVE.W  #$24,LAB_2265
    MOVE.W  D0,LAB_2343

.return_status:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_ReadCiaBBit3Flag   (ReadCiaBBit3Flag??)
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
;------------------------------------------------------------------------------
SCRIPT_ReadCiaBBit3Flag:
LAB_14BC:
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
; FUNC: SCRIPT_ReadCiaBBit5Mask   (ReadCiaBBit5Mask??)
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
;------------------------------------------------------------------------------
SCRIPT_ReadCiaBBit5Mask:
LAB_14BF:
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
; FUNC: SCRIPT_GetCtrlLineFlag   (GetCtrlLineFlag??)
; ARGS:
;   (none)
; RET:
;   D0: LAB_20AC (shadow flag)
; CLOBBERS:
;   D0
; CALLS:
;   (none)
; READS:
;   LAB_20AC
; WRITES:
;   (none)
; DESC:
;   Returns the cached CTRL line asserted flag.
;------------------------------------------------------------------------------
SCRIPT_GetCtrlLineFlag:
LAB_14C0:
    MOVE.L  D7,-(A7)
    MOVE.W  LAB_20AC,D7
    MOVE.L  D7,D0
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_WriteSerialDataWord   (WriteSerialDataWord??)
; ARGS:
;   stack +10: dataWord (low byte used)
; RET:
;   D0: none
; CLOBBERS:
;   D7
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   SERDAT, LAB_2341
; DESC:
;   Writes a byte to SERDAT with bit8 set and mirrors it into LAB_2341.
; NOTES:
;   Uses only the low byte of the provided word.
;------------------------------------------------------------------------------
SCRIPT_WriteSerialDataWord:
LAB_14C1:
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7
    ANDI.W  #$ff,D7
    BSET    #8,D7
    MOVE.W  D7,SERDAT
    MOVE.W  D7,LAB_2341
    MOVE.L  (A7)+,D7
    RTS

;!======

j_getCTRLBuffer:
    JMP     ESQ_ReadCtrlBufferByte

LAB_14C3:
    JMP     ESQ_ReadSerialRbfByte
