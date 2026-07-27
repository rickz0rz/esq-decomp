    XDEF    ESQDISP_AllocateHighlightBitmaps
    XDEF    _ESQDISP_ApplyStatusMaskToIndicators
    XDEF    _ESQDISP_InitHighlightMessagePattern
    XDEF    ESQDISP_ProcessGridMessagesIfIdle
    XDEF    ESQDISP_QueueHighlightDrawMessage
    XDEF    ESQDISP_SetStatusIndicatorColorSlot
    XDEF    ESQDISP_UpdateStatusMaskAndRefresh
    XDEF    ESQDISP_AllocateHighlightBitmaps_Return
    XDEF    ESQDISP_InitHighlightMessagePattern_Return
    XDEF    ESQDISP_UpdateStatusMaskAndRefresh_Return


;------------------------------------------------------------------------------
; FUNC: ESQDISP_AllocateHighlightBitmaps   (Initialize 3-plane bitmap and allocate plane rasters)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A6/A7/D0/D1/D2/D7
; CALLS:
;   _ESQDISP_JMPTBL_GRAPHICS_AllocRaster, _LVOBltClear, _LVOInitBitMap
; READS:
;   Global_REF_GRAPHICS_LIBRARY, _Global_STR_ESQDISP_C, _WDISP_HighlightRasterHeightPx
; WRITES:
;   A3+8/A3+12/A3+16 raster plane pointers
; DESC:
;   Initializes a 696-wide, 3-plane highlight bitmap descriptor and allocates one
;   raster per plane using configured highlight height.
; NOTES:
;   Clears each allocated plane with BltClear before returning.
;------------------------------------------------------------------------------
ESQDISP_AllocateHighlightBitmaps:
    LINK.W  A5,#-4
    MOVEM.L D2/D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVEQ   #0,D0
    MOVE.W  _WDISP_HighlightRasterHeightPx,D0
    MOVEA.L A3,A0
    MOVE.L  D0,D2
    MOVEQ   #3,D0
    MOVE.L  #696,D1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitBitMap(A6)

    MOVEQ   #0,D7

.alloc_plane_loop:
    MOVEQ   #3,D0
    CMP.L   D0,D7
    BGE.S   ESQDISP_AllocateHighlightBitmaps_Return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEQ   #0,D1

    MOVE.W  _WDISP_HighlightRasterHeightPx,D1
    MOVE.L  D1,-(A7)                    ; Height
    PEA     696.W                       ; Width
    PEA     79.W                        ; Line Number
    PEA     _Global_STR_ESQDISP_C          ; Calling File
    MOVE.L  D0,28(A7)
    JSR     _ESQDISP_JMPTBL_GRAPHICS_AllocRaster(PC)

    LEA     16(A7),A7
    MOVE.L  12(A7),D1
    MOVE.L  D0,8(A3,D1.L)
    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVE.W  _WDISP_HighlightRasterHeightPx,D1
    MULU    #$58,D1
    MOVE.L  D0,12(A7)
    MOVE.L  D1,D0
    MOVE.L  12(A7),D2
    MOVEA.L 8(A3,D2.L),A1
    MOVEQ   #0,D1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOBltClear(A6)

    ADDQ.L  #1,D7
    BRA.S   .alloc_plane_loop

;------------------------------------------------------------------------------
; FUNC: ESQDISP_AllocateHighlightBitmaps_Return   (Return tail for highlight bitmap allocator)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D2
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Restores saved registers/frame state and returns to caller.
; NOTES:
;   Shared exit for allocation loop bound check.
;------------------------------------------------------------------------------
ESQDISP_AllocateHighlightBitmaps_Return:
    MOVEM.L (A7)+,D2/D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _ESQDISP_InitHighlightMessagePattern   (Seed highlight message pattern bytes)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D7
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   A3+55..A3+58
; DESC:
;   Writes ascending pattern bytes 4..7 into message structure offsets 55..58.
; NOTES:
;   Uses a fixed 4-byte loop.
;------------------------------------------------------------------------------
_ESQDISP_InitHighlightMessagePattern:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7

.init_pattern_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   ESQDISP_InitHighlightMessagePattern_Return

    MOVE.L  D7,D0
    ADDQ.L  #4,D0
    MOVE.B  D0,55(A3,D7.L)
    ADDQ.L  #1,D7
    BRA.S   .init_pattern_loop

;------------------------------------------------------------------------------
; FUNC: ESQDISP_InitHighlightMessagePattern_Return   (Return tail for message-pattern initializer)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D7
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Restores D7/A3 and returns.
; NOTES:
;   Shared exit from 4-iteration seed loop.
;------------------------------------------------------------------------------
ESQDISP_InitHighlightMessagePattern_Return:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_QueueHighlightDrawMessage   (Prepare highlight-draw message and enqueue to port)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0
; CALLS:
;   _ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode, _LVOInitRastPort, _LVOPutMsg, _LVOSetDrMd, _LVOSetFont
; READS:
;   AbsExecBase, _Global_HANDLE_PREVUEC_FONT, Global_REF_GRAPHICS_LIBRARY, _ESQ_HighlightMsgPort, _ESQ_HighlightReplyPort
; WRITES:
;   highlight message header/rastport fields at A3, message flags via A3+112 target
; DESC:
;   Populates message metadata and embedded RastPort state, validates selection
;   parameters, then posts the message to _ESQ_HighlightMsgPort.
; NOTES:
;   Uses _ESQ_HighlightReplyPort as reply target for async highlight processing.
;------------------------------------------------------------------------------
ESQDISP_QueueHighlightDrawMessage:
    LINK.W  A5,#-4
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2

    MOVE.B  #$5,8(A3)
    MOVE.W  #$a0,18(A3)
    MOVE.L  _ESQ_HighlightReplyPort,14(A3)
    MOVE.L  8(A2),20(A3)
    MOVE.L  12(A2),24(A3)
    MOVE.L  16(A2),28(A3)
    CLR.W   52(A3)
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    JSR     _ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode(PC)

    CLR.L   32(A3)
    MOVE.L  A3,(A7)
    BSR.S   _ESQDISP_InitHighlightMessagePattern

    ADDQ.W  #8,A7
    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitRastPort(A6)

    MOVE.L  A2,64(A3)
    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVE.L  112(A3),-4(A5)
    MOVEA.L -4(A5),A0
    MOVE.B  #$1,55(A0)
    BSET    #0,53(A0)
    MOVEA.L A3,A1
    MOVEA.L _ESQ_HighlightMsgPort,A0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOPutMsg(A6)

    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_ProcessGridMessagesIfIdle   (Pump grid messages when UI is idle)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages
; READS:
;   _ESQDISP_GridMessagePumpBlockFlag, _NEWGRID_MessagePumpSuspendFlag, _Global_UIBusyFlag
; WRITES:
;   (none observed)
; DESC:
;   Forwards to NEWGRID message processing only when no modal/input-busy gate is set.
; NOTES:
;   Gated by _ESQDISP_GridMessagePumpBlockFlag, _Global_UIBusyFlag, and _NEWGRID_MessagePumpSuspendFlag.
;------------------------------------------------------------------------------
ESQDISP_ProcessGridMessagesIfIdle:
    TST.W   _ESQDISP_GridMessagePumpBlockFlag
    BNE.S   .lab_08C3

    TST.W   _Global_UIBusyFlag
    BNE.S   .lab_08C3

    TST.L   _NEWGRID_MessagePumpSuspendFlag
    BNE.S   .lab_08C3

    JSR     _ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages(PC)

.lab_08C3:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_SetStatusIndicatorColorSlot   (Cache/apply color and paint one status-indicator box)
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
;   _Global_REF_696_400_BITMAP, Global_REF_GRAPHICS_LIBRARY, _Global_REF_RASTPORT_1, _ESQDISP_StatusIndicatorDeferredApplyFlag, ESQDISP_StatusIndicatorColorCache
; WRITES:
;   ESQDISP_StatusIndicatorColorCache, status-indicator rectangle in _Global_REF_RASTPORT_1
; DESC:
;   Updates cached color for indicator slot and, when UI is drawable, repaints the
;   slot rectangle at x=655..661 using either supplied color or sampled fallback.
; NOTES:
;   Busy mode stores pending color only; `D7==-1` requests use of cached color.
;   Slot selector `D6` maps to y=40 (slot 1) or y=57 (slot 0).
;------------------------------------------------------------------------------
ESQDISP_SetStatusIndicatorColorSlot:
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
    LEA     ESQDISP_StatusIndicatorColorCache,A0
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
    LEA     ESQDISP_StatusIndicatorColorCache,A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    MOVE.L  (A1),D7
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    MOVE.L  D0,(A1)

.apply_if_slot_color_changed:
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     ESQDISP_StatusIndicatorColorCache,A0
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

;------------------------------------------------------------------------------
; FUNC: _ESQDISP_ApplyStatusMaskToIndicators   (Map status-bit mask to two indicator color slots)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D7
; CALLS:
;   ESQDISP_SetStatusIndicatorColorSlot
; READS:
;   status mask argument (D7 bits)
; WRITES:
;   (none observed)
; DESC:
;   Decodes grouped status bits and updates two indicator slots (mode 1 + mode 0)
;   by forwarding selected color IDs to ESQDISP_SetStatusIndicatorColorSlot.
; NOTES:
;   `D7==-1` forces default reset behavior for both indicator groups.
;------------------------------------------------------------------------------
_ESQDISP_ApplyStatusMaskToIndicators:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    MOVEQ   #-1,D0
    CMP.L   D0,D7
    BNE.S   .evaluate_primary_indicator_group

    PEA     1.W
    MOVE.L  D0,-(A7)
    BSR.W   ESQDISP_SetStatusIndicatorColorSlot

    ADDQ.W  #8,A7
    BRA.S   .evaluate_secondary_indicator_group

.evaluate_primary_indicator_group:
    BTST    #4,D7
    BEQ.S   .primary_no_bit4

    BTST    #5,D7
    BEQ.S   .primary_bit4_only

    PEA     1.W
    PEA     4.W
    BSR.W   ESQDISP_SetStatusIndicatorColorSlot

    ADDQ.W  #8,A7
    BRA.S   .evaluate_secondary_indicator_group

.primary_bit4_only:
    PEA     1.W
    PEA     2.W
    BSR.W   ESQDISP_SetStatusIndicatorColorSlot

    ADDQ.W  #8,A7
    BRA.S   .evaluate_secondary_indicator_group

.primary_no_bit4:
    PEA     1.W
    PEA     7.W
    BSR.W   ESQDISP_SetStatusIndicatorColorSlot

    ADDQ.W  #8,A7

.evaluate_secondary_indicator_group:
    MOVEQ   #-1,D0
    CMP.L   D0,D7
    BNE.S   .secondary_eval_bit8

    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    BSR.W   ESQDISP_SetStatusIndicatorColorSlot

    ADDQ.W  #8,A7
    BRA.W   .return

.secondary_eval_bit8:
    BTST    #8,D7
    BEQ.S   .secondary_eval_bit0

    CLR.L   -(A7)
    PEA     4.W
    BSR.W   ESQDISP_SetStatusIndicatorColorSlot

    ADDQ.W  #8,A7
    BRA.S   .return

.secondary_eval_bit0:
    BTST    #0,D7
    BEQ.S   .secondary_no_bit0

    BTST    #2,D7
    BEQ.S   .secondary_bit0_without_bit2

    CLR.L   -(A7)
    PEA     4.W
    BSR.W   ESQDISP_SetStatusIndicatorColorSlot

    ADDQ.W  #8,A7
    BRA.S   .return

.secondary_bit0_without_bit2:
    BTST    #1,D7
    BEQ.S   .secondary_bit0_fallback

    CLR.L   -(A7)
    PEA     2.W
    BSR.W   ESQDISP_SetStatusIndicatorColorSlot

    ADDQ.W  #8,A7
    BRA.S   .return

.secondary_bit0_fallback:
    CLR.L   -(A7)
    PEA     1.W
    BSR.W   ESQDISP_SetStatusIndicatorColorSlot

    ADDQ.W  #8,A7
    BRA.S   .return

.secondary_no_bit0:
    BTST    #2,D7
    BEQ.S   .secondary_no_bit0_no_bit2

    CLR.L   -(A7)
    PEA     3.W
    BSR.W   ESQDISP_SetStatusIndicatorColorSlot

    ADDQ.W  #8,A7
    BRA.S   .return

.secondary_no_bit0_no_bit2:
    BTST    #1,D7
    BEQ.S   .secondary_no_bits_1_2

    CLR.L   -(A7)
    PEA     3.W
    BSR.W   ESQDISP_SetStatusIndicatorColorSlot

    ADDQ.W  #8,A7
    BRA.S   .return

.secondary_no_bits_1_2:
    CLR.L   -(A7)
    PEA     7.W
    BSR.W   ESQDISP_SetStatusIndicatorColorSlot

    ADDQ.W  #8,A7

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_UpdateStatusMaskAndRefresh   (UpdateStatusMaskAndRefresh)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D5/D6/D7
; CALLS:
;   _ESQDISP_ApplyStatusMaskToIndicators
; READS:
;   ESQDISP_StatusIndicatorMask, fff
; WRITES:
;   ESQDISP_StatusIndicatorMask
; DESC:
;   Sets or clears bits in the global status mask, clamps to 12 bits, and only
;   refreshes status indicators when the effective mask changed.
; NOTES:
;   D6 controls operation mode: non-zero = OR-in mask, zero = clear mask bits.
;------------------------------------------------------------------------------
ESQDISP_UpdateStatusMaskAndRefresh:
    MOVEM.L D5-D7,-(A7)
    MOVE.L  16(A7),D7
    MOVE.L  20(A7),D6
    MOVEQ   #-1,D5
    MOVE.L  ESQDISP_StatusIndicatorMask,D5
    TST.L   D6
    BEQ.S   .lab_08DB

    OR.L    D7,ESQDISP_StatusIndicatorMask
    BRA.S   .lab_08DC

.lab_08DB:
    MOVE.L  D7,D0
    NOT.L   D0
    AND.L   D0,ESQDISP_StatusIndicatorMask

.lab_08DC:
    ANDI.L  #$fff,ESQDISP_StatusIndicatorMask
    MOVE.L  ESQDISP_StatusIndicatorMask,D0
    CMP.L   D0,D5
    BEQ.S   ESQDISP_UpdateStatusMaskAndRefresh_Return

    MOVE.L  D0,-(A7)
    BSR.W   _ESQDISP_ApplyStatusMaskToIndicators

    ADDQ.W  #4,A7

;------------------------------------------------------------------------------
; FUNC: ESQDISP_UpdateStatusMaskAndRefresh_Return   (UpdateStatusMaskAndRefresh_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D5
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Shared return tail for ESQDISP_UpdateStatusMaskAndRefresh.
; NOTES:
;   Restores D5-D7 and returns.
;------------------------------------------------------------------------------
ESQDISP_UpdateStatusMaskAndRefresh_Return:
    MOVEM.L (A7)+,D5-D7
    RTS

;!======
