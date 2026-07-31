    XDEF    _GCOMMAND_ClearBannerQueue

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_ClearBannerQueue   (Clear queued banner control bytes)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D7, A0
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   _ESQPARS2_BannerQueueAttentionCountdown, _ESQPARS2_BannerQueueBuffer
; DESC:
;   Clears the banner queue buffer and resets the queue state.
; NOTES:
;   Zeros 98 bytes in _ESQPARS2_BannerQueueBuffer and sets _ESQPARS2_BannerQueueAttentionCountdown to -1.
;------------------------------------------------------------------------------
_GCOMMAND_ClearBannerQueue:
    MOVE.L  D7,-(A7)
    MOVE.W  #(-1),_ESQPARS2_BannerQueueAttentionCountdown
    MOVEQ   #0,D7

.clear_loop:
    MOVEQ   #98,D0
    CMP.L   D0,D7
    BGE.S   .return

    LEA     _ESQPARS2_BannerQueueBuffer,A0
    ADDA.L  D7,A0
    CLR.B   (A0)
    ADDQ.L  #1,D7
    BRA.S   .clear_loop

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======