    XDEF    _ESQ_InitAudio1Dma


;------------------------------------------------------------------------------
; FUNC: _ESQ_InitAudio1Dma   (InitAudioChannel1Dma)
; ARGS:
;   (none)
; RET:
;   D0: 0
; CLOBBERS:
;   D0, A0-A1
; CALLS:
;   (none)
; READS:
;   _Global_PTR_AUD1_DMA
; WRITES:
;   AUD1LCH, AUD1LEN, AUD1VOL, AUD1PER, DMACON, CTRL_Bit4CaptureDelayCounter, CTRL_Bit4CapturePhase, _CTRL_SampleEntryCount
; DESC:
;   Initializes audio channel 1 DMA and clears related CTRL capture state.
;------------------------------------------------------------------------------
_ESQ_InitAudio1Dma:
    MOVEA.L #BLTDDAT,A0
    LEA     _Global_PTR_AUD1_DMA,A1
    MOVE.L  A1,(AUD1LCH-BLTDDAT)(A0)    ; Store DMA data in _Global_PTR_AUD1_DMA
    MOVE.W  #1,(AUD1LEN-BLTDDAT)(A0)
    MOVE.W  #0,(AUD1VOL-BLTDDAT)(A0)
    MOVE.W  #$65b,(AUD1PER-BLTDDAT)(A0)
    MOVE.W  #$8202,(DMACON-BLTDDAT)(A0)
    MOVEQ   #0,D0
    MOVE.W  D0,CTRL_Bit4CaptureDelayCounter
    MOVE.W  D0,CTRL_Bit4CapturePhase
    MOVE.W  D0,_CTRL_SampleEntryCount
    RTS

;!======