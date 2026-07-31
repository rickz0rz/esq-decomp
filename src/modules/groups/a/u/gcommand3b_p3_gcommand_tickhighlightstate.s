    XDEF    _GCOMMAND_TickHighlightState

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_TickHighlightState   (Advance banner/highlight ring counters for one tick)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D2, A4
; CALLS:
;   _GCOMMAND_RebuildBannerTablesFromBounds, _GCOMMAND_ServiceHighlightMessages
; READS:
;   _GCOMMAND_BannerRebuildPendingFlag, _GCOMMAND_BannerRowByteOffsetResetValue, _GCOMMAND_BannerPhaseIndexCurrent, _GCOMMAND_BannerRowByteOffsetCurrent, _ESQSHARED4_InterleaveCopyTailOffsetReset, _GCOMMAND_BannerQueueSlotCurrent, _GCOMMAND_BannerRowIndexCurrent
; WRITES:
;   _GCOMMAND_BannerPhaseIndexCurrent, _GCOMMAND_BannerRowByteOffsetCurrent, _ESQSHARED4_InterleaveCopyTailOffsetCurrent, _GCOMMAND_BannerQueueSlotPrevious, _GCOMMAND_BannerQueueSlotCurrent, _GCOMMAND_BannerRowIndexPrevious, _GCOMMAND_BannerRowIndexCurrent
; DESC:
;   Advances highlight/cycle counters and updates related globals.
; NOTES:
;   Counter wrap thresholds inferred from constants (98, 88, 32).
;   98 = queue/table ring length, 88 = second-table byte offset delta.
;------------------------------------------------------------------------------
_GCOMMAND_TickHighlightState:
    MOVEM.L D2/A4,-(A7)
    LEA     _Global_REF_LONG_FILE_SCRATCH,A4
    TST.W   _GCOMMAND_BannerRebuildPendingFlag
    BEQ.S   .skip_rebuild

    BSR.W   _GCOMMAND_RebuildBannerTablesFromBounds

.skip_rebuild:
    ADDQ.L  #1,_GCOMMAND_BannerPhaseIndexCurrent
    MOVE.L  _GCOMMAND_BannerRowByteOffsetCurrent,_GCOMMAND_BannerRowByteOffsetPrevious
    MOVEQ   #98,D0
    CMP.L   _GCOMMAND_BannerPhaseIndexCurrent,D0
    BNE.S   .advance_indices

    MOVEQ   #0,D1
    MOVE.L  D1,_GCOMMAND_BannerPhaseIndexCurrent
    MOVE.L  _GCOMMAND_BannerRowByteOffsetResetValue,D2
    MOVE.L  D2,_GCOMMAND_BannerRowByteOffsetCurrent
    MOVE.L  _ESQSHARED4_InterleaveCopyTailOffsetReset,D2
    MOVE.L  D2,_ESQSHARED4_InterleaveCopyTailOffsetCurrent
    BRA.S   .update_counters

.advance_indices:
    MOVEQ   #88,D1
    ADD.L   D1,D1
    ADD.L   D1,_GCOMMAND_BannerRowByteOffsetCurrent
    MOVEQ   #32,D1
    ADD.L   D1,_ESQSHARED4_InterleaveCopyTailOffsetCurrent

.update_counters:
    MOVE.W  _GCOMMAND_BannerQueueSlotCurrent,D1
    MOVE.W  D1,_GCOMMAND_BannerQueueSlotPrevious
    MOVE.L  D1,D2
    SUBQ.W  #1,D2
    MOVE.W  D2,_GCOMMAND_BannerQueueSlotCurrent
    BGE.S   .maybe_reset_slot

    MOVE.W  #$61,_GCOMMAND_BannerQueueSlotCurrent

.maybe_reset_slot:
    MOVE.L  _GCOMMAND_BannerRowIndexCurrent,D1
    MOVE.L  D1,_GCOMMAND_BannerRowIndexPrevious
    ADDQ.L  #1,_GCOMMAND_BannerRowIndexCurrent
    CMP.L   _GCOMMAND_BannerRowIndexCurrent,D0
    BNE.S   .service_messages

    CLR.L   _GCOMMAND_BannerRowIndexCurrent

.service_messages:
    BSR.W   _GCOMMAND_ServiceHighlightMessages

    MOVEM.L (A7)+,D2/A4
    RTS

;!======