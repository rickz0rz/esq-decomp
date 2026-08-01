    XDEF    _ESQ_CaptureCtrlBit4Stream


;------------------------------------------------------------------------------
; FUNC: _ESQ_CaptureCtrlBit4Stream   (CaptureCiabPraBit4Stream)
; ARGS:
;   (none)
; RET:
;   D0: 0 (on reset path)
; CLOBBERS:
;   D0-D1, A5
; CALLS:
;   _GET_BIT_4_OF_CIAB_PRA_INTO_D1
; READS:
;   _CTRL_Bit4CapturePhase, _CTRL_Bit4CaptureDelayCounter, _CTRL_Bit4SampleSlotIndex
; WRITES:
;   _CTRL_Bit4CapturePhase, _CTRL_Bit4CaptureDelayCounter, _CTRL_Bit4SampleSlotIndex, _CTRL_Bit4SampleScratch, _CTRL_BUFFER, _CTRL_H, _CTRL_HPreviousSample,
;   _CTRL_HDeltaMax, _CTRL_BufferedByteCount
; DESC:
;   Samples CIAB PRA bit 4 over time, assembles bytes, and appends them to
;   _CTRL_BUFFER.
; NOTES:
;   Uses _CTRL_Bit4CapturePhase/1AF8/1AFB as sampling state. Buffer wraps at $01F4.
;------------------------------------------------------------------------------
_ESQ_CaptureCtrlBit4Stream:
    TST.W   _CTRL_Bit4CapturePhase            ; Test _CTRL_Bit4CapturePhase...
    BNE.S   .advance_state       ; and if it's not equal to zero, jump to LAB_0042

    JSR     _GET_BIT_4_OF_CIAB_PRA_INTO_D1(PC)        ; Read the bit from CIAB_PRA and store bit 4's value in D1

    TST.B   D1                  ; Test the value (this cheaply is seeing if it's 1 or 0)
    BPL.W   .return              ; If it's 1, jump to LAB_004D (which is just RTS) so exit this subroutine.

    ADDQ.W  #1,_CTRL_Bit4CapturePhase
    MOVE.W  #4,_CTRL_Bit4CaptureDelayCounter
    MOVE.W  #0,_CTRL_Bit4SampleSlotIndex
    RTS

.advance_state:
    MOVE.W  _CTRL_Bit4CapturePhase,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_CTRL_Bit4CapturePhase
    MOVE.W  _CTRL_Bit4CaptureDelayCounter,D1
    CMP.W   D0,D1
    BGT.W   .return

    MOVEQ   #4,D1
    CMP.W   D1,D0
    BGT.W   .collect_samples

    JSR     _GET_BIT_4_OF_CIAB_PRA_INTO_D1(PC)

    TST.B   D1
    BPL.S   .reset_state

    MOVE.W  #14,_CTRL_Bit4CaptureDelayCounter
    MOVEQ   #7,D0
    LEA     _CTRL_Bit4SampleScratch,A5
    MOVEQ   #0,D1

.clear_sample_buffer_loop:
    MOVE.B  D1,(A5)+
    DBF     D0,.clear_sample_buffer_loop

    RTS

.reset_state:
    MOVEQ   #0,D0           ; Set D0 to 0
    MOVE.W  D0,_CTRL_Bit4CaptureDelayCounter     ; Set _CTRL_Bit4CaptureDelayCounter to D0 (0)
    MOVE.W  D0,_CTRL_Bit4SampleSlotIndex     ; Set _CTRL_Bit4SampleSlotIndex to D0 (0)
    MOVE.W  D0,_CTRL_Bit4CapturePhase     ; Set _CTRL_Bit4CapturePhase to D0 (0)
    RTS

.collect_samples:
    MOVEQ   #94,D1              ; Move 94 ('^') into D1
    CMP.W   D1,D0
    BGE.S   .assemble_and_store

    JSR     _GET_BIT_4_OF_CIAB_PRA_INTO_D1(PC)

    LEA     _CTRL_Bit4SampleScratch,A5
    ADDA.W  _CTRL_Bit4SampleSlotIndex,A5
    MOVE.B  D1,(A5)
    ADDQ.W  #1,_CTRL_Bit4SampleSlotIndex
    ADDI.W  #10,_CTRL_Bit4CaptureDelayCounter
    RTS

.assemble_and_store:
    JSR     _GET_BIT_4_OF_CIAB_PRA_INTO_D1(PC)

    TST.B   D1
    BMI.S   .reset_state_and_exit

    LEA     _CTRL_Bit4SampleScratch,A5
    ADDA.W  _CTRL_Bit4SampleSlotIndex,A5
    MOVE.W  _CTRL_Bit4SampleSlotIndex,D1
    SUBQ.W  #1,D1
    MOVEQ   #0,D0

.build_byte_loop:
    TST.B   -(A5)
    BMI.S   .clear_bit

    BSET    D1,D0
    BRA.S   .next_bit

.clear_bit:
    BCLR    D1,D0

.next_bit:
    DBF     D1,.build_byte_loop
    LEA     _CTRL_BUFFER,A1
    MOVE.W  _CTRL_H,D1
    ADDA.W  D1,A1
    MOVE.B  D0,(A1)+
    ADDQ.W  #1,D1
    CMPI.W  #$1f4,D1
    BNE.S   .store_tail

    MOVEQ   #0,D1

.store_tail:
    MOVE.W  D1,_CTRL_H
    MOVE.W  D1,D0
    MOVE.W  _CTRL_HPreviousSample,D1
    SUB.W   D1,D0
    BCC.W   .fill_count_ok

    ADDI.W  #$1f4,D0

.fill_count_ok:
    MOVE.W  D0,_CTRL_BufferedByteCount
    CMP.W   _CTRL_HDeltaMax,D0
    BCS.W   .reset_state_and_exit

    MOVE.W  D0,_CTRL_HDeltaMax

.reset_state_and_exit:
    MOVEQ   #0,D0
    MOVE.W  D0,_CTRL_Bit4CaptureDelayCounter
    MOVE.W  D0,_CTRL_Bit4SampleSlotIndex
    MOVE.W  D0,_CTRL_Bit4CapturePhase

.return:
    RTS

;!======