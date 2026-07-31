    XDEF    _GCOMMAND_BuildBannerTables

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_BuildBannerTables   (Reset counters and rebuild both banner copper tables)
; ARGS:
;   stack +8: arg0 (byte, low byte used)
;   stack +12: arg1 (word, low word used)
;   stack +16: arg2 (byte, low byte used)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0-A6
; CALLS:
;   _LVODisable, _LVOEnable, _GCOMMAND_ResetPresetWorkTables,
;   GCOMMAND_ClearBannerQueue, _GCOMMAND_CopyImageDataToBitmap
; READS:
;   GCOMMAND_BannerRowByteOffsetResetValue, _ESQSHARED4_InterleaveCopyTailOffsetReset, _Global_REF_696_400_BITMAP
; WRITES:
;   GCOMMAND_BannerPhaseIndexCurrent, GCOMMAND_BannerRowByteOffsetCurrent, GCOMMAND_BannerRowByteOffsetPrevious, _GCOMMAND_BannerQueueSlotPrevious..GCOMMAND_BannerRowIndexCurrent, ESQSHARED4_InterleaveCopyTailOffsetCurrent, ED2_HighlightTickEnabledFlag, _ESQPARS2_ReadModeFlags
; DESC:
;   Resets banner-related globals and rebuilds the banner tables into the bitmap.
; NOTES:
;   Argument bytes/words are forwarded into _GCOMMAND_CopyImageDataToBitmap calls.
;   Seeds queue slots to 97/96 and row indices to 84/85 before first tick.
;------------------------------------------------------------------------------
_GCOMMAND_BuildBannerTables:
    LINK.W  A5,#-4
    MOVEM.L D2/D5-D7,-(A7)
    MOVE.B  11(A5),D7
    MOVE.W  14(A5),D6
    MOVE.B  19(A5),D5
    MOVE.B  D7,-1(A5)
    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    BSR.W   _GCOMMAND_ResetPresetWorkTables

    MOVEQ   #0,D0
    MOVE.L  D0,GCOMMAND_BannerPhaseIndexCurrent
    MOVE.L  D0,GCOMMAND_BannerRowByteOffsetPrevious
    MOVE.L  GCOMMAND_BannerRowByteOffsetResetValue,D0
    MOVE.L  D0,GCOMMAND_BannerRowByteOffsetCurrent
    MOVE.L  _ESQSHARED4_InterleaveCopyTailOffsetReset,ESQSHARED4_InterleaveCopyTailOffsetCurrent
    MOVEQ   #97,D0
    MOVE.W  D0,_GCOMMAND_BannerQueueSlotPrevious
    SUBQ.W  #1,D0
    MOVE.W  D0,_GCOMMAND_BannerQueueSlotCurrent
    MOVEQ   #84,D0
    MOVE.L  D0,GCOMMAND_BannerRowIndexPrevious
    MOVEQ   #85,D0
    MOVE.L  D0,GCOMMAND_BannerRowIndexCurrent
    MOVEQ   #0,D0
    MOVE.W  D6,D0
    MOVEQ   #0,D1
    MOVE.B  D5,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -1(A5)
    MOVE.L  GCOMMAND_BannerRowByteOffsetCurrent,-(A7)
    PEA     2992.W
    PEA     _ESQ_CopperListBannerA
    PEA     _Global_REF_696_400_BITMAP
    BSR.W   _GCOMMAND_CopyImageDataToBitmap

    MOVE.B  D7,-1(A5)
    MOVEQ   #88,D0
    ADD.L   GCOMMAND_BannerRowByteOffsetCurrent,D0
    MOVEQ   #0,D1
    MOVE.W  D6,D1
    MOVEQ   #0,D2
    MOVE.B  D5,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    PEA     -1(A5)
    MOVE.L  D0,-(A7)
    PEA     3080.W
    PEA     _ESQ_CopperListBannerB
    PEA     _Global_REF_696_400_BITMAP
    BSR.W   _GCOMMAND_CopyImageDataToBitmap

    BSR.W   GCOMMAND_ClearBannerQueue

    MOVE.W  #1,ED2_HighlightTickEnabledFlag
    MOVE.W  #$100,_ESQPARS2_ReadModeFlags
    MOVEA.L AbsExecBase,A6
    JSR     _LVOEnable(A6)

    MOVEM.L -20(A5),D2/D5-D7
    UNLK    A5
    RTS

;!======