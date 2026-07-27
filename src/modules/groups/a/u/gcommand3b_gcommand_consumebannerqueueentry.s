    XDEF    _GCOMMAND_ConsumeBannerQueueEntry

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_ConsumeBannerQueueEntry   (Consume one queued banner control byte and apply mode changes)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D2, A0-A1
; CALLS:
;   (none)
; READS:
;   _GCOMMAND_BannerQueueSlotCurrent, _ESQPARS2_BannerQueueBuffer, _ESQPARS2_BannerQueueAttentionDelayTicks
; WRITES:
;   _ESQPARS2_BannerQueueAttentionCountdown, _ESQPARS2_ReadModeFlags, _ESQDISP_StatusIndicatorDeferredApplyFlag, _GCOMMAND_HighlightHoldoffTickCount, _ESQDISP_StatusRefreshPendingFlag, _ESQPARS2_BannerQueueBuffer
; DESC:
;   Consumes the current banner queue entry and updates highlight flags.
; NOTES:
;   Recognizes 0xFF and 0xFE as control bytes with special handling.
;   0xFF arms countdown/attention path; 0xFE forces read mode `$0101`.
;------------------------------------------------------------------------------
_GCOMMAND_ConsumeBannerQueueEntry:
    MOVE.L  D2,-(A7)
    LEA     _ESQPARS2_BannerQueueBuffer,A0
    MOVE.W  _GCOMMAND_BannerQueueSlotCurrent,D0
    MOVEA.L A0,A1
    ADDA.W  D0,A1
    TST.B   (A1)
    BEQ.S   .clear_entry

    MOVEA.L A0,A1
    ADDA.W  D0,A1
    MOVEQ   #0,D1
    MOVE.B  (A1),D1
    MOVEQ   #0,D2
    NOT.B   D2
    CMP.L   D2,D1
    BNE.S   .check_0xfe

    MOVE.W  _ESQPARS2_BannerQueueAttentionDelayTicks,D1
    SUBQ.W  #1,D1
    MOVE.W  D1,_ESQPARS2_BannerQueueAttentionCountdown
    MOVEQ   #1,D2
    MOVE.B  D2,_ESQDISP_StatusIndicatorDeferredApplyFlag
    BRA.S   .clear_entry

.check_0xfe:
    MOVEA.L A0,A1
    ADDA.W  D0,A1
    MOVEQ   #0,D1
    MOVE.B  (A1),D1
    MOVEQ   #127,D2
    ADD.L   D2,D2
    CMP.L   D2,D1
    BNE.S   .store_value

    MOVE.W  #$101,_ESQPARS2_ReadModeFlags
    BRA.S   .clear_entry

.store_value:
    MOVEA.L A0,A1
    ADDA.W  D0,A1
    MOVEQ   #0,D1
    MOVE.B  (A1),D1
    MOVE.W  D1,_ESQPARS2_ReadModeFlags

.clear_entry:
    ADDA.W  D0,A0
    MOVEQ   #0,D0
    MOVE.B  D0,(A0)
    MOVE.W  _ESQPARS2_BannerQueueAttentionCountdown,D1
    BLT.S   .return

    MOVE.L  D1,D2
    SUBQ.W  #1,D2
    MOVE.W  D2,_ESQPARS2_BannerQueueAttentionCountdown
    MOVE.B  #$2,_GCOMMAND_HighlightHoldoffTickCount
    TST.W   D2
    BPL.S   .return

    MOVE.B  D0,_ESQDISP_StatusIndicatorDeferredApplyFlag
    MOVE.B  #$1,_ESQDISP_StatusRefreshPendingFlag

.return:
    MOVE.L  (A7)+,D2
    RTS

;!======