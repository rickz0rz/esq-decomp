;------------------------------------------------------------------------------
; FUNC: ESQ_HandleSerialRbfInterrupt
; ARGS:
;   A0: interrupt contextuncertain (reads 24(A0), writes 156(A0))
;   A1: base of receive ring bufferuncertain (offset by head index)
; RET:
;   D0: 0
; CLOBBERS:
;   D0-D1, A1
; CALLS:
;   (none)
; READS:
;   GLOB_WORD_H_VALUE, GLOB_WORD_T_VALUE, GLOB_WORD_MAX_VALUE, ESQPARS2_ReadModeFlags
; WRITES:
;   (A1+head), DATA_WDISP_BSS_WORD_228A, GLOB_WORD_H_VALUE, DATA_WDISP_BSS_WORD_228C, GLOB_WORD_MAX_VALUE,
;   ESQPARS2_ReadModeFlags, DATA_SCRIPT_BSS_LONG_20AB, 156(A0)
; DESC:
;   Stores a received byte into the RBF ring buffer, updates head/fill counts,
;   and tracks max fill and overflow threshold.
; NOTES:
;   Buffer wraps at $FA00. Sets ESQPARS2_ReadModeFlags to $102 when fill reaches $DAC0.
;------------------------------------------------------------------------------
ESQ_HandleSerialRbfInterrupt:
    MOVEQ   #0,D0
    MOVE.W  GLOB_WORD_H_VALUE,D0
    ADDA.L  D0,A1
    MOVE.W  24(A0),D1
    MOVE.B  D1,(A1)
    BTST    #15,D1
    BEQ.S   .skip_error_count

    MOVE.W  DATA_WDISP_BSS_WORD_228A,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,DATA_WDISP_BSS_WORD_228A

.skip_error_count:
    ADDQ.W  #1,D0
    CMPI.W  #$fa00,D0
    BNE.S   .head_update_done

    MOVEQ   #0,D0

.head_update_done:
    MOVE.W  D0,GLOB_WORD_H_VALUE
    MOVE.W  GLOB_WORD_T_VALUE,D1
    SUB.W   D1,D0
    BCC.W   .fill_count_ok

    ADDI.W  #$fa00,D0

.fill_count_ok:
    MOVE.W  D0,DATA_WDISP_BSS_WORD_228C
    CMP.W   GLOB_WORD_MAX_VALUE,D0
    BCS.W   .skip_max_update

    MOVE.W  D0,GLOB_WORD_MAX_VALUE

.skip_max_update:
    CMPI.W  #$dac0,D0
    BCS.W   .return

    CMPI.W  #$102,ESQPARS2_ReadModeFlags
    BEQ.W   .return

    MOVE.W  #$102,ESQPARS2_ReadModeFlags
    ADDI.L  #$1,DATA_SCRIPT_BSS_LONG_20AB

.return:
    MOVE.W  #$800,156(A0)
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_ReadSerialRbfByte   (ReadSerialRbfByte)
; ARGS:
;   (none)
; RET:
;   D0: next byte from RBF ring buffer (low byte)
; CLOBBERS:
;   D0-D1, A0
; CALLS:
;   (none)
; READS:
;   GLOB_WORD_T_VALUE, GLOB_WORD_H_VALUE, ESQPARS2_ReadModeFlags, GLOB_REF_INTB_RBF_64K_BUFFER
; WRITES:
;   GLOB_WORD_T_VALUE, ESQPARS2_ReadModeFlags
; DESC:
;   Reads one byte from the RBF ring buffer and advances the tail index.
; NOTES:
;   Clears ESQPARS2_ReadModeFlags when fill drops below $BB80 (if previously set to $102).
;------------------------------------------------------------------------------
ESQ_ReadSerialRbfByte:
    MOVEQ   #0,D1
    MOVE.L  D1,D0
    MOVE.W  GLOB_WORD_T_VALUE,D1
    MOVEA.L GLOB_REF_INTB_RBF_64K_BUFFER,A0
    ADDA.L  D1,A0
    MOVE.B  (A0),D0
    ADDQ.W  #1,D1
    CMPI.W  #$fa00,D1
    BNE.S   .tail_update_done

    MOVEQ   #0,D1

.tail_update_done:
    MOVE.W  D1,GLOB_WORD_T_VALUE
    MOVE.L  D0,-(A7)
    MOVE.W  GLOB_WORD_H_VALUE,D0
    SUB.W   D1,D0
    BCC.W   .fill_count_ok

    ADDI.W  #$fa00,D0

.fill_count_ok:
    CMPI.W  #$102,ESQPARS2_ReadModeFlags
    BNE.W   .return

    CMPI.W  #$bb80,D0   ; Box off.
    BCC.W   .return

    MOVE.W  #0,ESQPARS2_ReadModeFlags

.return:
    MOVE.L  (A7)+,D0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_InitAudio1Dma   (InitAudioChannel1Dma)
; ARGS:
;   (none)
; RET:
;   D0: 0
; CLOBBERS:
;   D0, A0-A1
; CALLS:
;   (none)
; READS:
;   GLOB_PTR_AUD1_DMA
; WRITES:
;   AUD1LCH, AUD1LEN, AUD1VOL, AUD1PER, DMACON, DATA_COMMON_BSS_WORD_1AF8, DATA_COMMON_BSS_WORD_1AFA, DATA_COMMON_BSS_WORD_1B03
; DESC:
;   Initializes audio channel 1 DMA and clears related CTRL capture state.
;------------------------------------------------------------------------------
ESQ_InitAudio1Dma:
    MOVEA.L #BLTDDAT,A0
    LEA     GLOB_PTR_AUD1_DMA,A1
    MOVE.L  A1,(AUD1LCH-BLTDDAT)(A0)    ; Store DMA data in GLOB_PTR_AUD1_DMA
    MOVE.W  #1,(AUD1LEN-BLTDDAT)(A0)
    MOVE.W  #0,(AUD1VOL-BLTDDAT)(A0)
    MOVE.W  #$65b,(AUD1PER-BLTDDAT)(A0)
    MOVE.W  #$8202,(DMACON-BLTDDAT)(A0)
    MOVEQ   #0,D0
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1AF8
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1AFA
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1B03
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_CaptureCtrlBit3Stream   (CaptureCiabPraBit3Stream)
; ARGS:
;   (none)
; RET:
;   D0: 0
; CLOBBERS:
;   D0-D1, A5
; CALLS:
;   GET_BIT_3_OF_CIAB_PRA_INTO_D1, ESQ_StoreCtrlSampleEntry
; READS:
;   DATA_COMMON_BSS_WORD_1AFC, DATA_COMMON_BSS_WORD_1AF9, DATA_COMMON_BSS_WORD_1AFD, DATA_COMMON_BSS_WORD_1B03
; WRITES:
;   DATA_COMMON_BSS_WORD_1AFC, DATA_COMMON_BSS_WORD_1AF9, DATA_COMMON_BSS_WORD_1AFD, DATA_COMMON_BSS_LONG_1AFF, DATA_COMMON_BSS_WORD_1B03, DATA_COMMON_BSS_LONG_1B04
; DESC:
;   Samples CIAB PRA bit 3 over time, builds bytes from samples, and stores
;   them into the DATA_COMMON_BSS_LONG_1B04 ring buffer.
; NOTES:
;   Uses DATA_COMMON_BSS_WORD_1AFC/1AF9/1AFD as sampling state. Sample buffer is DATA_COMMON_BSS_LONG_1AFF.
;------------------------------------------------------------------------------
ESQ_CaptureCtrlBit3Stream:
    TST.W   DATA_COMMON_BSS_WORD_1AFC
    BNE.S   .advance_state

    JSR     GET_BIT_3_OF_CIAB_PRA_INTO_D1

    TST.B   D1
    BPL.W   .return

    ADDQ.W  #1,DATA_COMMON_BSS_WORD_1AFC
    MOVE.W  #4,DATA_COMMON_BSS_WORD_1AF9
    MOVE.W  #0,DATA_COMMON_BSS_WORD_1AFD
    RTS

.advance_state:
    MOVE.W  DATA_COMMON_BSS_WORD_1AFC,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1AFC
    MOVE.W  DATA_COMMON_BSS_WORD_1AF9,D1
    CMP.W   D0,D1
    BGT.W   .return

    MOVEQ   #4,D1
    CMP.W   D1,D0
    BGT.W   .collect_samples

    JSR     GET_BIT_3_OF_CIAB_PRA_INTO_D1

    TST.B   D1
    BPL.S   .reset_state

    MOVE.W  #14,DATA_COMMON_BSS_WORD_1AF9
    MOVEQ   #7,D0
    LEA     DATA_COMMON_BSS_LONG_1AFF,A5
    MOVEQ   #0,D1

.clear_sample_buffer_loop:
    MOVE.B  D1,(A5)+
    DBF     D0,.clear_sample_buffer_loop
    RTS

.reset_state:
    MOVEQ   #0,D0
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1AF9
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1AFD
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1AFC
    RTS

.collect_samples:
    MOVEQ   #94,D1
    CMP.W   D1,D0
    BGE.S   .assemble_and_store

    JSR     GET_BIT_3_OF_CIAB_PRA_INTO_D1

    LEA     DATA_COMMON_BSS_LONG_1AFF,A5
    ADDA.W  DATA_COMMON_BSS_WORD_1AFD,A5
    MOVE.B  D1,(A5)
    ADDQ.W  #1,DATA_COMMON_BSS_WORD_1AFD
    ADDI.W  #10,DATA_COMMON_BSS_WORD_1AF9
    RTS

.assemble_and_store:
    JSR     GET_BIT_3_OF_CIAB_PRA_INTO_D1

    TST.B   D1
    BMI.S   .reset_state_and_exit

    LEA     DATA_COMMON_BSS_LONG_1AFF,A5
    ADDA.W  DATA_COMMON_BSS_WORD_1AFD,A5
    MOVE.W  DATA_COMMON_BSS_WORD_1AFD,D1
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
    LEA     DATA_COMMON_BSS_LONG_1B04,A1
    MOVE.W  DATA_COMMON_BSS_WORD_1B03,D1
    ADDA.W  D1,A1
    MOVE.B  D0,(A1)
    BEQ.S   .flush_on_zero

    ADDQ.W  #1,D1
    CMPI.W  #5,D1
    BLT.S   .store_index

    MOVE.B  #0,(A1)

.flush_on_zero:
    JSR     ESQ_StoreCtrlSampleEntry

    MOVEQ   #0,D1

.store_index:
    MOVE.W  D1,DATA_COMMON_BSS_WORD_1B03

.reset_state_and_exit:
    MOVEQ   #0,D0
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1AF9
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1AFD
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1AFC

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: GET_BIT_3_OF_CIAB_PRA_INTO_D1   (GetCiabPraBit3)
; ARGS:
;   (none)
; RET:
;   D1: $FF if CIAB_PRA bit 3 is 0, else 0
; CLOBBERS:
;   D1, A5
; CALLS:
;   (none)
; READS:
;   CIAB_PRA
; WRITES:
;   (none)
; DESC:
;   Reads CIAB_PRA and returns an inverted boolean for bit 3 in D1.
;------------------------------------------------------------------------------
GET_BIT_3_OF_CIAB_PRA_INTO_D1:
    MOVEQ   #0,D1           ; Copy 0 into D1 to clear all bytes
    MOVEA.L #CIAB_PRA,A5    ; Copy the address of CIAB_PRA into A5
    MOVE.B  (A5),D1         ; Get contents of the least significant byte at A5 and copy into D1
    BTST    #3,D1           ; Test bit 3, set Z to true if it's 0
    SEQ     D1              ; SEQ sets D1 to $FF when Z=1, otherwise 0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: GET_BIT_4_OF_CIAB_PRA_INTO_D1   (GetCiabPraBit4)
; ARGS:
;   (none)
; RET:
;   D1: $FF if CIAB_PRA bit 4 is 0, else 0
; CLOBBERS:
;   D1, A5
; CALLS:
;   (none)
; READS:
;   CIAB_PRA
; WRITES:
;   (none)
; DESC:
;   Reads CIAB_PRA and returns an inverted boolean for bit 4 in D1.
;------------------------------------------------------------------------------
GET_BIT_4_OF_CIAB_PRA_INTO_D1:
    MOVEQ   #0,D1           ; Copy 0 into D1 to clear all bytes
    MOVEA.L #CIAB_PRA,A5    ; Copy the address of CIAB_PRA into A5
    MOVE.B  (A5),D1         ; Get contents of the least significant byte at A5 and copy into D1
    BTST    #4,D1           ; Test bit 4, set Z to true if it's 0
    SEQ     D1              ; SEQ sets D1 to $FF when Z=1, otherwise 0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_PollCtrlInput   (PollCtrlInput)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, A0-A1, A4-A5
; CALLS:
;   ESQ_CaptureCtrlBit4Stream, ESQ_CaptureCtrlBit3Stream
; READS:
;   DATA_ESQ_STR_B_1DC8
; WRITES:
;   INTREQ
; DESC:
;   Updates CTRL sampling state and acknowledges the audio channel 1 interrupt.
; NOTES:
;   Only captures the bit-3 stream when DATA_ESQ_STR_B_1DC8+18 holds 'N'.
;------------------------------------------------------------------------------
ESQ_PollCtrlInput:
    MOVE.L  A5,-(A7)
    MOVE.L  A4,-(A7)

    JSR     ESQ_CaptureCtrlBit4Stream

    LEA     DATA_ESQ_STR_B_1DC8,A4
    MOVE.B  18(A4),D1
    CMPI.B  #"N",D1
    BNE.S   .lab_0040

    JSR     ESQ_CaptureCtrlBit3Stream(PC)

.lab_0040:
    MOVEA.L #BLTDDAT,A0
    MOVE.W  #$100,(INTREQ-BLTDDAT)(A0)
    ; Looking at that, 0100 means bit 8 starting from the right as 0 is set
    ; so we're setting "Audio channel 1 block finished"

    MOVEA.L (A7)+,A4
    MOVEA.L (A7)+,A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_CaptureCtrlBit4Stream   (CaptureCiabPraBit4Stream)
; ARGS:
;   (none)
; RET:
;   D0: 0 (on reset path)
; CLOBBERS:
;   D0-D1, A5
; CALLS:
;   GET_BIT_4_OF_CIAB_PRA_INTO_D1
; READS:
;   DATA_COMMON_BSS_WORD_1AFA, DATA_COMMON_BSS_WORD_1AF8, DATA_COMMON_BSS_WORD_1AFB
; WRITES:
;   DATA_COMMON_BSS_WORD_1AFA, DATA_COMMON_BSS_WORD_1AF8, DATA_COMMON_BSS_WORD_1AFB, DATA_COMMON_BSS_LONG_1AFE, CTRL_BUFFER, CTRL_H, CTRL_HPreviousSample,
;   CTRL_HDeltaMax, DATA_WDISP_BSS_WORD_2284
; DESC:
;   Samples CIAB PRA bit 4 over time, assembles bytes, and appends them to
;   CTRL_BUFFER.
; NOTES:
;   Uses DATA_COMMON_BSS_WORD_1AFA/1AF8/1AFB as sampling state. Buffer wraps at $01F4.
;------------------------------------------------------------------------------
ESQ_CaptureCtrlBit4Stream:
    TST.W   DATA_COMMON_BSS_WORD_1AFA            ; Test DATA_COMMON_BSS_WORD_1AFA...
    BNE.S   .advance_state       ; and if it's not equal to zero, jump to LAB_0042

    JSR     GET_BIT_4_OF_CIAB_PRA_INTO_D1(PC)        ; Read the bit from CIAB_PRA and store bit 4's value in D1

    TST.B   D1                  ; Test the value (this cheaply is seeing if it's 1 or 0)
    BPL.W   .return              ; If it's 1, jump to LAB_004D (which is just RTS) so exit this subroutine.

    ADDQ.W  #1,DATA_COMMON_BSS_WORD_1AFA
    MOVE.W  #4,DATA_COMMON_BSS_WORD_1AF8
    MOVE.W  #0,DATA_COMMON_BSS_WORD_1AFB
    RTS

.advance_state:
    MOVE.W  DATA_COMMON_BSS_WORD_1AFA,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1AFA
    MOVE.W  DATA_COMMON_BSS_WORD_1AF8,D1
    CMP.W   D0,D1
    BGT.W   .return

    MOVEQ   #4,D1
    CMP.W   D1,D0
    BGT.W   .collect_samples

    JSR     GET_BIT_4_OF_CIAB_PRA_INTO_D1(PC)

    TST.B   D1
    BPL.S   .reset_state

    MOVE.W  #14,DATA_COMMON_BSS_WORD_1AF8
    MOVEQ   #7,D0
    LEA     DATA_COMMON_BSS_LONG_1AFE,A5
    MOVEQ   #0,D1

.clear_sample_buffer_loop:
    MOVE.B  D1,(A5)+
    DBF     D0,.clear_sample_buffer_loop

    RTS

.reset_state:
    MOVEQ   #0,D0           ; Set D0 to 0
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1AF8     ; Set DATA_COMMON_BSS_WORD_1AF8 to D0 (0)
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1AFB     ; Set DATA_COMMON_BSS_WORD_1AFB to D0 (0)
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1AFA     ; Set DATA_COMMON_BSS_WORD_1AFA to D0 (0)
    RTS

.collect_samples:
    MOVEQ   #94,D1              ; Move 94 ('^') into D1
    CMP.W   D1,D0
    BGE.S   .assemble_and_store

    JSR     GET_BIT_4_OF_CIAB_PRA_INTO_D1(PC)

    LEA     DATA_COMMON_BSS_LONG_1AFE,A5
    ADDA.W  DATA_COMMON_BSS_WORD_1AFB,A5
    MOVE.B  D1,(A5)
    ADDQ.W  #1,DATA_COMMON_BSS_WORD_1AFB
    ADDI.W  #10,DATA_COMMON_BSS_WORD_1AF8
    RTS

.assemble_and_store:
    JSR     GET_BIT_4_OF_CIAB_PRA_INTO_D1(PC)

    TST.B   D1
    BMI.S   .reset_state_and_exit

    LEA     DATA_COMMON_BSS_LONG_1AFE,A5
    ADDA.W  DATA_COMMON_BSS_WORD_1AFB,A5
    MOVE.W  DATA_COMMON_BSS_WORD_1AFB,D1
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
    LEA     CTRL_BUFFER,A1
    MOVE.W  CTRL_H,D1
    ADDA.W  D1,A1
    MOVE.B  D0,(A1)+
    ADDQ.W  #1,D1
    CMPI.W  #$1f4,D1
    BNE.S   .store_tail

    MOVEQ   #0,D1

.store_tail:
    MOVE.W  D1,CTRL_H
    MOVE.W  D1,D0
    MOVE.W  CTRL_HPreviousSample,D1
    SUB.W   D1,D0
    BCC.W   .fill_count_ok

    ADDI.W  #$1f4,D0

.fill_count_ok:
    MOVE.W  D0,DATA_WDISP_BSS_WORD_2284
    CMP.W   CTRL_HDeltaMax,D0
    BCS.W   .reset_state_and_exit

    MOVE.W  D0,CTRL_HDeltaMax

.reset_state_and_exit:
    MOVEQ   #0,D0
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1AF8
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1AFB
    MOVE.W  D0,DATA_COMMON_BSS_WORD_1AFA

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_CaptureCtrlBit4StreamBufferByte   (ESQ_CaptureCtrlBit4StreamBufferByte)
; ARGS:
;   (none)
; RET:
;   D0: next byte from CTRL_BUFFER (low byte)
; CLOBBERS:
;   D0-D1, A0
; CALLS:
;   (none)
; READS:
;   CTRL_HPreviousSample, CTRL_BUFFER
; WRITES:
;   CTRL_HPreviousSample
; DESC:
;   Reads one byte from CTRL_BUFFER and advances the tail index.
; NOTES:
;   Buffer wraps at $01F4.
;------------------------------------------------------------------------------
ESQ_CaptureCtrlBit4StreamBufferByte:
    MOVEQ   #0,D1
    MOVE.L  D1,D0
    MOVE.W  CTRL_HPreviousSample,D1
    LEA     CTRL_BUFFER,A0
    ADDA.L  D1,A0
    MOVE.B  (A0),D0
    ADDQ.W  #1,D1
    CMPI.W  #$1f4,D1
    BNE.S   .tail_update_done

    MOVEQ   #0,D1

.tail_update_done:
    MOVE.W  D1,CTRL_HPreviousSample
    RTS

;!======

    ; Alignment
    ALIGN_WORD
