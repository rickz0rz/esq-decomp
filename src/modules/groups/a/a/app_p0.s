    XDEF    _ESQ_CaptureCtrlBit3Stream


;------------------------------------------------------------------------------
; FUNC: _ESQ_CaptureCtrlBit3Stream   (CaptureCiabPraBit3Stream)
; ARGS:
;   (none)
; RET:
;   D0: 0
; CLOBBERS:
;   D0-D1, A5
; CALLS:
;   _GET_BIT_3_OF_CIAB_PRA_INTO_D1, _ESQ_StoreCtrlSampleEntry
; READS:
;   _CTRL_Bit3CapturePhase, _CTRL_Bit3CaptureDelayCounter, _CTRL_Bit3SampleSlotIndex, _CTRL_SampleEntryCount
; WRITES:
;   _CTRL_Bit3CapturePhase, _CTRL_Bit3CaptureDelayCounter, _CTRL_Bit3SampleSlotIndex, _CTRL_Bit3SampleScratch, _CTRL_SampleEntryCount, _CTRL_SampleEntryScratch
; DESC:
;   Samples CIAB PRA bit 3 over time, builds bytes from samples, and stores
;   them into the _CTRL_SampleEntryScratch ring buffer.
; NOTES:
;   Uses _CTRL_Bit3CapturePhase/1AF9/1AFD as sampling state. Sample buffer is _CTRL_Bit3SampleScratch.
;------------------------------------------------------------------------------
_ESQ_CaptureCtrlBit3Stream:
    TST.W   _CTRL_Bit3CapturePhase
    BNE.S   .advance_state

    BSR.W   _GET_BIT_3_OF_CIAB_PRA_INTO_D1

    TST.B   D1
    BPL.W   .return

    ADDQ.W  #1,_CTRL_Bit3CapturePhase
    MOVE.W  #4,_CTRL_Bit3CaptureDelayCounter
    MOVE.W  #0,_CTRL_Bit3SampleSlotIndex
    RTS

.advance_state:
    MOVE.W  _CTRL_Bit3CapturePhase,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_CTRL_Bit3CapturePhase
    MOVE.W  _CTRL_Bit3CaptureDelayCounter,D1
    CMP.W   D0,D1
    BGT.W   .return

    MOVEQ   #4,D1
    CMP.W   D1,D0
    BGT.W   .collect_samples

    BSR.W   _GET_BIT_3_OF_CIAB_PRA_INTO_D1

    TST.B   D1
    BPL.S   .reset_state

    MOVE.W  #14,_CTRL_Bit3CaptureDelayCounter
    MOVEQ   #7,D0
    LEA     _CTRL_Bit3SampleScratch,A5
    MOVEQ   #0,D1

.clear_sample_buffer_loop:
    MOVE.B  D1,(A5)+
    DBF     D0,.clear_sample_buffer_loop
    RTS

.reset_state:
    MOVEQ   #0,D0
    MOVE.W  D0,_CTRL_Bit3CaptureDelayCounter
    MOVE.W  D0,_CTRL_Bit3SampleSlotIndex
    MOVE.W  D0,_CTRL_Bit3CapturePhase
    RTS

.collect_samples:
    MOVEQ   #94,D1
    CMP.W   D1,D0
    BGE.S   .assemble_and_store

    BSR.W   _GET_BIT_3_OF_CIAB_PRA_INTO_D1

    LEA     _CTRL_Bit3SampleScratch,A5
    ADDA.W  _CTRL_Bit3SampleSlotIndex,A5
    MOVE.B  D1,(A5)
    ADDQ.W  #1,_CTRL_Bit3SampleSlotIndex
    ADDI.W  #10,_CTRL_Bit3CaptureDelayCounter
    RTS

.assemble_and_store:
    BSR.S   _GET_BIT_3_OF_CIAB_PRA_INTO_D1

    TST.B   D1
    BMI.S   .reset_state_and_exit

    LEA     _CTRL_Bit3SampleScratch,A5
    ADDA.W  _CTRL_Bit3SampleSlotIndex,A5
    MOVE.W  _CTRL_Bit3SampleSlotIndex,D1
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
    LEA     _CTRL_SampleEntryScratch,A1
    MOVE.W  _CTRL_SampleEntryCount,D1
    ADDA.W  D1,A1
    MOVE.B  D0,(A1)
    BEQ.S   .flush_on_zero

    ADDQ.W  #1,D1
    CMPI.W  #5,D1
    BLT.S   .store_index

    MOVE.B  #0,(A1)

.flush_on_zero:
    BSR.W   _ESQ_StoreCtrlSampleEntry

    MOVEQ   #0,D1

.store_index:
    MOVE.W  D1,_CTRL_SampleEntryCount

.reset_state_and_exit:
    MOVEQ   #0,D0
    MOVE.W  D0,_CTRL_Bit3CaptureDelayCounter
    MOVE.W  D0,_CTRL_Bit3SampleSlotIndex
    MOVE.W  D0,_CTRL_Bit3CapturePhase

.return:
    RTS

;!======