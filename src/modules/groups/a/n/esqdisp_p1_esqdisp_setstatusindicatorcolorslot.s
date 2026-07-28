    XDEF    _ESQDISP_SetStatusIndicatorColorSlot



;------------------------------------------------------------------------------
; FUNC: _ESQDISP_SetStatusIndicatorColorSlot   (Cache/apply color and paint one status-indicator box)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   _LVOReadPixel, _LVORectFill, _LVOSetAPen
; READS:
;   _Global_REF_696_400_BITMAP, Global_REF_GRAPHICS_LIBRARY, _Global_REF_RASTPORT_1, _ESQDISP_StatusIndicatorDeferredApplyFlag, _ESQDISP_StatusIndicatorColorCache
; WRITES:
;   _ESQDISP_StatusIndicatorColorCache, status-indicator rectangle in _Global_REF_RASTPORT_1
; DESC:
;   Updates cached color for indicator slot and, when UI is drawable, repaints the
;   slot rectangle at x=655..661 using either supplied color or sampled fallback.
; NOTES:
;   Busy mode stores pending color only; `D7==-1` requests use of cached color.
;   Slot selector `D6` maps to y=40 (slot 1) or y=57 (slot 0).
;------------------------------------------------------------------------------
_ESQDISP_SetStatusIndicatorColorSlot:
    LINK.W  A5,#-20
    MOVEM.L D2-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6

    TST.L   D6
    BEQ.S   .validate_slot_index

    MOVEQ   #1,D0
    CMP.L   D0,D6
    BNE.W   .return

.validate_slot_index:
    TST.B   _ESQDISP_StatusIndicatorDeferredApplyFlag
    BEQ.S   .resolve_cached_color_or_direct_apply

    MOVEQ   #-1,D0
    CMP.L   D0,D7
    BEQ.W   .return

    MOVE.L  D6,D1
    ASL.L   #2,D1
    LEA     _ESQDISP_StatusIndicatorColorCache,A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    MOVE.L  D7,(A1)
    BRA.W   .return

.resolve_cached_color_or_direct_apply:
    MOVEQ   #-1,D0
    CMP.L   D0,D7
    BNE.S   .apply_if_slot_color_changed

    MOVE.L  D6,D1
    ASL.L   #2,D1
    LEA     _ESQDISP_StatusIndicatorColorCache,A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    MOVE.L  (A1),D7
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    MOVE.L  D0,(A1)

.apply_if_slot_color_changed:
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     _ESQDISP_StatusIndicatorColorCache,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  (A1),D1
    CMP.L   D7,D1
    BEQ.W   .return

    ADDA.L  D0,A0
    MOVE.L  D7,(A0)
    MOVE.L  #$28f,D4
    MOVEQ   #1,D0
    CMP.L   D0,D6
    BNE.S   .use_slot0_y

    MOVEQ   #40,D0
    MOVE.L  D0,-16(A5)
    BRA.S   .setup_indicator_rastport

.use_slot0_y:
    MOVEQ   #57,D0
    MOVE.L  D0,-16(A5)

.setup_indicator_rastport:
    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.B  25(A0),D5
    EXT.W   D5
    EXT.L   D5
    MOVE.L  4(A0),-4(A5)
    MOVE.L  #_Global_REF_696_400_BITMAP,4(A0)
    MOVEQ   #7,D0
    CMP.L   D0,D7
    BEQ.S   .readPixelAt655x55

    MOVEQ   #6,D0
    CMP.L   D0,D7
    BNE.S   .set_pen_and_fill_indicator

.readPixelAt655x55:
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVE.L  #655,D0
    MOVEQ   #55,D1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOReadPixel(A6)

    MOVE.L  D0,D7

.set_pen_and_fill_indicator:
    MOVE.L  D7,D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.L  D4,D0
    ADDQ.L  #6,D0
    MOVE.L  -16(A5),D1
    MOVE.L  D1,D2
    ADDQ.L  #4,D2
    MOVE.L  D0,24(A7)
    MOVE.L  D4,D0
    MOVE.L  D2,D3
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVE.L  24(A7),D2
    JSR     _LVORectFill(A6)

    MOVE.L  D5,D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  -4(A5),4(A0)

.return:
    MOVEM.L (A7)+,D2-D7
    UNLK    A5
    RTS

;!======