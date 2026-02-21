    XDEF    ESQDISP_AllocateHighlightBitmaps
    XDEF    ESQDISP_ApplyStatusMaskToIndicators
    XDEF    ESQDISP_ComputeScheduleOffsetForRow
    XDEF    ESQDISP_DrawStatusBanner_Impl
    XDEF    ESQDISP_FillProgramInfoHeaderFields
    XDEF    ESQDISP_GetEntryAuxPointerByMode
    XDEF    ESQDISP_GetEntryPointerByMode
    XDEF    ESQDISP_InitHighlightMessagePattern
    XDEF    ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty
    XDEF    ESQDISP_NormalizeClockAndRedrawBanner
    XDEF    ESQDISP_ParseProgramInfoCommandRecord
    XDEF    ESQDISP_PollInputModeAndRefreshSelection
    XDEF    ESQDISP_ProcessGridMessagesIfIdle
    XDEF    ESQDISP_PromoteSecondaryGroupToPrimary
    XDEF    ESQDISP_PromoteSecondaryLineHeadTailIfMarked
    XDEF    ESQDISP_PropagatePrimaryTitleMetadataToSecondary
    XDEF    ESQDISP_QueueHighlightDrawMessage
    XDEF    ESQDISP_RefreshStatusIndicatorsFromCurrentMask
    XDEF    ESQDISP_SetStatusIndicatorColorSlot
    XDEF    ESQDISP_TestEntryBits0And2
    XDEF    ESQDISP_TestEntryBits0And2_Core
    XDEF    ESQDISP_TestEntryGridEligibility
    XDEF    ESQDISP_TestWordIsZeroBooleanize
    XDEF    ESQDISP_UpdateStatusMaskAndRefresh
    XDEF    ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages
    XDEF    ESQDISP_JMPTBL_GRAPHICS_AllocRaster
    XDEF    ESQDISP_AllocateHighlightBitmaps_Return
    XDEF    ESQDISP_DrawStatusBanner_Impl_Return
    XDEF    ESQDISP_FillProgramInfoHeaderFields_Return
    XDEF    ESQDISP_InitHighlightMessagePattern_Return
    XDEF    ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty_Return
    XDEF    ESQDISP_ParseProgramInfoCommandRecord_Return
    XDEF    ESQDISP_PropagatePrimaryTitleMetadataToSecondary_Return
    XDEF    ESQDISP_TestEntryGridEligibility_Return
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
;   ESQDISP_JMPTBL_GRAPHICS_AllocRaster, _LVOBltClear, _LVOInitBitMap
; READS:
;   Global_REF_GRAPHICS_LIBRARY, Global_STR_ESQDISP_C, WDISP_HighlightRasterHeightPx
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
    MOVE.W  WDISP_HighlightRasterHeightPx,D0
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

    MOVE.W  WDISP_HighlightRasterHeightPx,D1
    MOVE.L  D1,-(A7)                    ; Height
    PEA     696.W                       ; Width
    PEA     79.W                        ; Line Number
    PEA     Global_STR_ESQDISP_C          ; Calling File
    MOVE.L  D0,28(A7)
    JSR     ESQDISP_JMPTBL_GRAPHICS_AllocRaster(PC)

    LEA     16(A7),A7
    MOVE.L  12(A7),D1
    MOVE.L  D0,8(A3,D1.L)
    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVE.W  WDISP_HighlightRasterHeightPx,D1
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
; FUNC: ESQDISP_InitHighlightMessagePattern   (Seed highlight message pattern bytes)
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
ESQDISP_InitHighlightMessagePattern:
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
;   ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode, _LVOInitRastPort, _LVOPutMsg, _LVOSetDrMd, _LVOSetFont
; READS:
;   AbsExecBase, Global_HANDLE_PREVUEC_FONT, Global_REF_GRAPHICS_LIBRARY, ESQ_HighlightMsgPort, ESQ_HighlightReplyPort
; WRITES:
;   highlight message header/rastport fields at A3, message flags via A3+112 target
; DESC:
;   Populates message metadata and embedded RastPort state, validates selection
;   parameters, then posts the message to ESQ_HighlightMsgPort.
; NOTES:
;   Uses ESQ_HighlightReplyPort as reply target for async highlight processing.
;------------------------------------------------------------------------------
ESQDISP_QueueHighlightDrawMessage:
    LINK.W  A5,#-4
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2

    MOVE.B  #$5,8(A3)
    MOVE.W  #$a0,18(A3)
    MOVE.L  ESQ_HighlightReplyPort,14(A3)
    MOVE.L  8(A2),20(A3)
    MOVE.L  12(A2),24(A3)
    MOVE.L  16(A2),28(A3)
    CLR.W   52(A3)
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    JSR     ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode(PC)

    CLR.L   32(A3)
    MOVE.L  A3,(A7)
    BSR.S   ESQDISP_InitHighlightMessagePattern

    ADDQ.W  #8,A7
    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitRastPort(A6)

    MOVE.L  A2,64(A3)
    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEA.L Global_HANDLE_PREVUEC_FONT,A0
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
    MOVEA.L ESQ_HighlightMsgPort,A0
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
;   ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages
; READS:
;   DATA_ESQ_BSS_WORD_1DF2, NEWGRID_MessagePumpSuspendFlag, Global_UIBusyFlag
; WRITES:
;   (none observed)
; DESC:
;   Forwards to NEWGRID message processing only when no modal/input-busy gate is set.
; NOTES:
;   Gated by DATA_ESQ_BSS_WORD_1DF2, Global_UIBusyFlag, and NEWGRID_MessagePumpSuspendFlag.
;------------------------------------------------------------------------------
ESQDISP_ProcessGridMessagesIfIdle:
    TST.W   DATA_ESQ_BSS_WORD_1DF2
    BNE.S   .lab_08C3

    TST.W   Global_UIBusyFlag
    BNE.S   .lab_08C3

    TST.L   NEWGRID_MessagePumpSuspendFlag
    BNE.S   .lab_08C3

    JSR     ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages(PC)

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
;   Global_REF_696_400_BITMAP, Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, DATA_ESQ_BSS_BYTE_1DEE, DATA_ESQDISP_CONST_LONG_1E80
; WRITES:
;   DATA_ESQDISP_CONST_LONG_1E80, status-indicator rectangle in Global_REF_RASTPORT_1
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
    TST.B   DATA_ESQ_BSS_BYTE_1DEE
    BEQ.S   .resolve_cached_color_or_direct_apply

    MOVEQ   #-1,D0
    CMP.L   D0,D7
    BEQ.W   .return

    MOVE.L  D6,D1
    ASL.L   #2,D1
    LEA     DATA_ESQDISP_CONST_LONG_1E80,A0
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
    LEA     DATA_ESQDISP_CONST_LONG_1E80,A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    MOVE.L  (A1),D7
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    MOVE.L  D0,(A1)

.apply_if_slot_color_changed:
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     DATA_ESQDISP_CONST_LONG_1E80,A0
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
    MOVEA.L Global_REF_RASTPORT_1,A0
    MOVE.B  25(A0),D5
    EXT.W   D5
    EXT.L   D5
    MOVE.L  4(A0),-4(A5)
    MOVE.L  #Global_REF_696_400_BITMAP,4(A0)
    MOVEQ   #7,D0
    CMP.L   D0,D7
    BEQ.S   .readPixelAt655x55

    MOVEQ   #6,D0
    CMP.L   D0,D7
    BNE.S   .set_pen_and_fill_indicator

.readPixelAt655x55:
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVE.L  #655,D0
    MOVEQ   #55,D1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOReadPixel(A6)

    MOVE.L  D0,D7

.set_pen_and_fill_indicator:
    MOVE.L  D7,D0
    MOVEA.L Global_REF_RASTPORT_1,A1
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
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVE.L  24(A7),D2
    JSR     _LVORectFill(A6)

    MOVE.L  D5,D0
    MOVEA.L Global_REF_RASTPORT_1,A1
    JSR     _LVOSetAPen(A6)

    MOVEA.L Global_REF_RASTPORT_1,A0
    MOVE.L  -4(A5),4(A0)

.return:
    MOVEM.L (A7)+,D2-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_ApplyStatusMaskToIndicators   (Map status-bit mask to two indicator color slots)
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
ESQDISP_ApplyStatusMaskToIndicators:
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
;   ESQDISP_ApplyStatusMaskToIndicators
; READS:
;   DATA_ESQDISP_BSS_LONG_1E81, fff
; WRITES:
;   DATA_ESQDISP_BSS_LONG_1E81
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
    MOVE.L  DATA_ESQDISP_BSS_LONG_1E81,D5
    TST.L   D6
    BEQ.S   .lab_08DB

    OR.L    D7,DATA_ESQDISP_BSS_LONG_1E81
    BRA.S   .lab_08DC

.lab_08DB:
    MOVE.L  D7,D0
    NOT.L   D0
    AND.L   D0,DATA_ESQDISP_BSS_LONG_1E81

.lab_08DC:
    ANDI.L  #$fff,DATA_ESQDISP_BSS_LONG_1E81
    MOVE.L  DATA_ESQDISP_BSS_LONG_1E81,D0
    CMP.L   D0,D5
    BEQ.S   ESQDISP_UpdateStatusMaskAndRefresh_Return

    MOVE.L  D0,-(A7)
    BSR.W   ESQDISP_ApplyStatusMaskToIndicators

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

;------------------------------------------------------------------------------
; FUNC: ESQDISP_RefreshStatusIndicatorsFromCurrentMask   (Reapply current status mask to indicators)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7
; CALLS:
;   ESQDISP_ApplyStatusMaskToIndicators
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Re-runs status-indicator coloring from the already stored global mask value.
; NOTES:
;   Calls ESQDISP_ApplyStatusMaskToIndicators with sentinel mask `-1`.
;------------------------------------------------------------------------------
ESQDISP_RefreshStatusIndicatorsFromCurrentMask:
    PEA     -1.W
    BSR.W   ESQDISP_ApplyStatusMaskToIndicators

    ADDQ.W  #4,A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_ComputeScheduleOffsetForRow   (Compute schedule offset for row/time)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Builds a time/row-derived schedule offset and normalizes it for display-grid
;   stepping.
; NOTES:
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
; FUNC: ESQDISP_ComputeScheduleOffsetForRow   (Compute schedule offset for row/time)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1/D5/D6/D7
; CALLS:
;   DST_BuildBannerTimeWord, DISPLIB_NormalizeValueByStep
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Builds a packed time word from (row, slot), folds it with row index, then
;   normalizes via DISPLIB_NormalizeValueByStep(value, 1, 48).
; NOTES:
;   Returns normalized offset in D0.
;------------------------------------------------------------------------------
ESQDISP_ComputeScheduleOffsetForRow:
    MOVEM.L D5-D7,-(A7)
    MOVE.W  18(A7),D7
    MOVE.B  23(A7),D6
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     DST_BuildBannerTimeWord(PC)

    MOVE.L  D0,D1
    EXT.L   D1
    ADD.L   D1,D1
    MOVE.L  D7,D0
    EXT.L   D0
    ADD.L   D1,D0
    MOVE.L  D0,D5
    MOVE.L  D5,D0
    EXT.L   D0
    PEA     48.W
    PEA     1.W
    MOVE.L  D0,-(A7)
    JSR     DISPLIB_NormalizeValueByStep(PC)

    LEA     20(A7),A7
    MOVE.L  D0,D5
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   NEWGRID_ProcessGridMessages
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages:
    JMP     NEWGRID_ProcessGridMessages

;------------------------------------------------------------------------------
; FUNC: ESQDISP_JMPTBL_GRAPHICS_AllocRaster   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   GRAPHICS_AllocRaster
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQDISP_JMPTBL_GRAPHICS_AllocRaster:
    JMP     GRAPHICS_AllocRaster

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_FillProgramInfoHeaderFields   (Populate program-info header fields)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/A3/A7/D0/D4/D5/D6/D7
; CALLS:
;   ESQFUNC_JMPTBL_STRING_CopyPadNul
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Writes status/time/flag bytes into the program-info header and copies a
;   2-byte code string into header offset 43, then zero-terminates offset 45.
; NOTES:
;   Returns early if destination pointer is NULL.
;------------------------------------------------------------------------------
ESQDISP_FillProgramInfoHeaderFields:
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVEA.L 28(A7),A3
    MOVE.B  35(A7),D7
    MOVE.W  38(A7),D6
    MOVE.B  43(A7),D5
    MOVE.B  47(A7),D4
    MOVEA.L 48(A7),A2
    MOVE.L  A3,D0
    BEQ.S   ESQDISP_FillProgramInfoHeaderFields_Return

    MOVE.B  D7,40(A3)
    MOVE.W  D6,46(A3)
    MOVE.B  D5,41(A3)
    MOVE.B  D4,42(A3)
    LEA     43(A3),A0
    PEA     2.W
    MOVE.L  A2,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ESQFUNC_JMPTBL_STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    CLR.B   45(A3)

;------------------------------------------------------------------------------
; FUNC: ESQDISP_FillProgramInfoHeaderFields_Return   (Return tail for program-info header fill)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D4
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Shared return tail for ESQDISP_FillProgramInfoHeaderFields.
; NOTES:
;   Restores D4-D7/A2-A3 and returns.
;------------------------------------------------------------------------------
ESQDISP_FillProgramInfoHeaderFields_Return:
    MOVEM.L (A7)+,D4-D7/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_ParseProgramInfoCommandRecord   (Parse program-info command record)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +12: arg_2 (via 16(A5))
;   stack +16: arg_3 (via 20(A5))
;   stack +20: arg_4 (via 24(A5))
;   stack +21: arg_5 (via 25(A5))
;   stack +23: arg_6 (via 27(A5))
;   stack +24: arg_7 (via 28(A5))
;   stack +25: arg_8 (via 29(A5))
;   stack +26: arg_9 (via 30(A5))
;   stack +27: arg_10 (via 31(A5))
;   stack +28: arg_11 (via 32(A5))
;   stack +32: arg_12 (via 36(A5))
;   stack +36: arg_13 (via 40(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D2/D3/D5/D6/D7
; CALLS:
;   ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit, ESQFUNC_JMPTBL_STRING_CopyPadNul, ESQIFF_JMPTBL_MATH_Mulu32, ESQDISP_FillProgramInfoHeaderFields
; READS:
;   ESQDISP_ParseProgramInfoCommandRecord_Return, DATA_ESQDISP_TAG_00_1E8A, WDISP_CharClassTable, TEXTDISP_SecondaryGroupCode, TEXTDISP_SecondaryGroupPresentFlag, TEXTDISP_SecondaryGroupEntryCount, TEXTDISP_PrimaryGroupCode, TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_PrimaryEntryPtrTable, TEXTDISP_SecondaryEntryPtrTable, branch, ff, lab_0918
; WRITES:
;   (none observed)
; DESC:
;   Parses group/slot identifiers plus digit fields, resolves target entry tables,
;   and writes program-info header fields for matching entries.
; NOTES:
;   Uses WDISP_CharClassTable digit checks before numeric accumulation.
;------------------------------------------------------------------------------
ESQDISP_ParseProgramInfoCommandRecord:
    LINK.W  A5,#-40
    MOVEM.L D2-D3/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D6
    MOVE.B  (A3)+,D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    MOVEQ   #0,D1
    MOVE.B  TEXTDISP_SecondaryGroupCode,D1
    MOVE.L  D0,-16(A5)
    CMP.L   D0,D1
    BNE.S   .lab_08E5

    MOVE.B  TEXTDISP_SecondaryGroupPresentFlag,D1
    SUBQ.B  #1,D1
    BNE.S   .lab_08E5

    MOVEQ   #0,D6
    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D6
    MOVE.L  #TEXTDISP_SecondaryEntryPtrTable,-40(A5)
    BRA.S   .lab_08E6

.lab_08E5:
    MOVEQ   #0,D1
    MOVE.B  TEXTDISP_PrimaryGroupCode,D1
    CMP.L   D1,D0
    BNE.S   .lab_08E6

    MOVEQ   #0,D6
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D6
    MOVE.L  #TEXTDISP_PrimaryEntryPtrTable,-40(A5)       ; A5 is some struct, what's at -40(A5)?

.lab_08E6:
    MOVE.B  (A3),D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   .lab_08E7

    MOVE.B  (A3),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    BRA.S   .lab_08E8

.lab_08E7:
    MOVEQ   #0,D0

.lab_08E8:
    MOVE.L  D0,D5
    ADDQ.L  #1,A3
    MOVE.B  (A3),D0
    EXT.W   D0
    EXT.L   D0
    ADDA.L  D0,A0
    BTST    #2,(A0)
    BEQ.S   .lab_08E9

    MOVE.B  (A3),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    BRA.S   .lab_08EA

.lab_08E9:
    MOVEQ   #0,D0

.lab_08EA:
    ADD.L   D0,D5
    ADDQ.L  #1,A3
    TST.L   D6
    BLE.W   ESQDISP_ParseProgramInfoCommandRecord_Return

    MOVEQ   #6,D0
    CMP.L   D0,D5
    BLT.W   ESQDISP_ParseProgramInfoCommandRecord_Return

    CLR.B   -25(A5)

.lab_08EB:
    MOVEQ   #18,D0
    CMP.B   (A3),D0
    BNE.W   ESQDISP_ParseProgramInfoCommandRecord_Return

    ADDQ.L  #1,A3
    MOVE.L  A3,-20(A5)
    CLR.L   -24(A5)
    MOVEQ   #0,D7

.lab_08EC:
    MOVEQ   #6,D0
    CMP.L   D0,D7
    BGE.S   .lab_08EE

    ADDQ.L  #1,A3
    MOVEQ   #4,D0
    CMP.B   (A3),D0
    BNE.S   .lab_08ED

    CLR.B   (A3)+
    MOVE.L  A3,-24(A5)
    ADDA.L  D5,A3
    BRA.S   .lab_08EE

.lab_08ED:
    ADDQ.L  #1,D7
    BRA.S   .lab_08EC

.lab_08EE:
    TST.L   -24(A5)
    BEQ.S   .lab_08EB

    MOVEQ   #0,D7

.branch:
    CMP.L   D6,D7
    BGE.S   .lab_08EB

    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEA.L -40(A5),A0
    MOVEA.L 0(A0,D0.L),A0
    LEA     12(A0),A1
    MOVEA.L -20(A5),A0

.lab_08F0:
    MOVE.B  (A1)+,D0
    CMP.B   (A0)+,D0
    BNE.W   .lab_0918

    TST.B   D0
    BNE.S   .lab_08F0

    BNE.W   .lab_0918

    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEA.L -40(A5),A0
    MOVE.L  0(A0,D0.L),-36(A5)
    MOVEA.L -36(A5),A0
    MOVE.B  40(A0),D0
    MOVE.W  46(A0),-32(A5)
    MOVE.B  D0,-28(A5)
    TST.L   D5
    BLE.S   .lab_08F4

    MOVEA.L -24(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    BTST    #1,(A2)
    BEQ.S   .lab_08F1

    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .lab_08F2

.lab_08F1:
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0

.lab_08F2:
    MOVEQ   #89,D1
    CMP.L   D1,D0
    BNE.S   .lab_08F3

    BSET    #1,-28(A5)
    BRA.S   .lab_08F4

.lab_08F3:
    BCLR    #1,-28(A5)

.lab_08F4:
    MOVEQ   #1,D0
    CMP.L   D0,D5
    BLE.S   .lab_08F8

    MOVEA.L -24(A5),A0
    MOVE.B  1(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    BTST    #1,(A2)
    BEQ.S   .lab_08F5

    MOVE.B  1(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .lab_08F6

.lab_08F5:
    MOVE.B  1(A0),D0
    EXT.W   D0
    EXT.L   D0

.lab_08F6:
    MOVEQ   #89,D1
    CMP.L   D1,D0
    BNE.S   .lab_08F7

    BSET    #2,-28(A5)
    BRA.S   .lab_08F8

.lab_08F7:
    BCLR    #2,-28(A5)

.lab_08F8:
    MOVEQ   #2,D0
    CMP.L   D0,D5
    BLE.S   .lab_08F9

    MOVEA.L -24(A5),A0
    MOVE.B  2(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.S   .lab_08F9

    MOVE.B  2(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .lab_08FA

.lab_08F9:
    MOVEQ   #0,D1
    NOT.B   D1

.lab_08FA:
    MOVE.B  D1,-29(A5)
    MOVEQ   #0,D0
    CMP.B   D0,D1
    BCS.S   .lab_08FB

    MOVEQ   #15,D0
    CMP.B   D0,D1
    BLS.S   .lab_08FC

.lab_08FB:
    MOVE.B  #$ff,-29(A5)

.lab_08FC:
    MOVEQ   #3,D0
    CMP.L   D0,D5
    BLE.S   .lab_08FD

    MOVEA.L -24(A5),A0
    MOVE.B  3(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.S   .lab_08FD

    MOVE.B  3(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .lab_08FE

.lab_08FD:
    MOVEQ   #0,D1
    NOT.B   D1

.lab_08FE:
    MOVE.B  D1,-30(A5)
    MOVEQ   #1,D0
    CMP.B   D0,D1
    BCS.S   .lab_08FF

    MOVEQ   #3,D0
    CMP.B   D0,D1
    BLS.S   .branch_1

.lab_08FF:
    MOVE.B  #$ff,-30(A5)

.branch_1:
    MOVEQ   #5,D0
    CMP.L   D0,D5
    BLE.S   .branch_2

    MOVEA.L -24(A5),A0
    ADDQ.L  #4,A0
    PEA     2.W
    MOVE.L  A0,-(A7)
    PEA     -27(A5)
    JSR     ESQFUNC_JMPTBL_STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    BRA.S   .branch_4

.branch_2:
    LEA     DATA_ESQDISP_TAG_00_1E8A,A0
    LEA     -27(A5),A1

.branch_3:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .branch_3

.branch_4:
    MOVEQ   #6,D0
    CMP.L   D0,D5
    BLE.S   .branch_8

    MOVEA.L -24(A5),A0
    MOVE.B  6(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    BTST    #1,(A2)
    BEQ.S   .branch_5

    MOVE.B  6(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .branch_6

.branch_5:
    MOVE.B  6(A0),D0
    EXT.W   D0
    EXT.L   D0

.branch_6:
    MOVEQ   #89,D1
    CMP.L   D1,D0
    BNE.S   .branch_7

    BSET    #0,-31(A5)
    BRA.S   .branch_8

.branch_7:
    BCLR    #0,-31(A5)

.branch_8:
    MOVEQ   #7,D0
    CMP.L   D0,D5
    BLE.S   .branch_12

    MOVEA.L -24(A5),A0
    MOVE.B  7(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    BTST    #1,(A2)
    BEQ.S   .branch_9

    MOVE.B  7(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .branch_10

.branch_9:
    MOVE.B  7(A0),D0
    EXT.W   D0
    EXT.L   D0

.branch_10:
    MOVEQ   #89,D1
    CMP.L   D1,D0
    BNE.S   .branch_11

    BSET    #1,-31(A5)
    BRA.S   .branch_12

.branch_11:
    BCLR    #1,-31(A5)

.branch_12:
    MOVEQ   #8,D0
    CMP.L   D0,D5
    BLE.S   .branch_16

    MOVEA.L -24(A5),A0
    MOVE.B  8(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    BTST    #1,(A2)
    BEQ.S   .branch_13

    MOVE.B  8(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .branch_14

.branch_13:
    MOVE.B  8(A0),D0
    EXT.W   D0
    EXT.L   D0

.branch_14:
    MOVEQ   #89,D1
    CMP.L   D1,D0
    BNE.S   .branch_15

    BSET    #2,-31(A5)
    BRA.S   .branch_16

.branch_15:
    BCLR    #2,-31(A5)

.branch_16:
    MOVEQ   #9,D0
    CMP.L   D0,D5
    BLE.S   .branch_20

    MOVEA.L -24(A5),A0
    MOVE.B  9(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    BTST    #1,(A2)
    BEQ.S   .branch_17

    MOVE.B  9(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .branch_18

.branch_17:
    MOVE.B  9(A0),D0
    EXT.W   D0
    EXT.L   D0

.branch_18:
    MOVEQ   #89,D1
    CMP.L   D1,D0
    BNE.S   .branch_19

    BSET    #3,-31(A5)
    BRA.S   .branch_20

.branch_19:
    BCLR    #3,-31(A5)

.branch_20:
    MOVEQ   #10,D0
    CMP.L   D0,D5
    BLE.S   .branch_24

    MOVEA.L -24(A5),A0
    MOVE.B  10(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #1,(A1)
    BEQ.S   .branch_21

    MOVE.B  10(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .branch_22

.branch_21:
    MOVE.B  10(A0),D0
    EXT.W   D0
    EXT.L   D0

.branch_22:
    MOVEQ   #89,D1
    CMP.L   D1,D0
    BNE.S   .branch_23

    BSET    #4,-31(A5)
    BRA.S   .branch_24

.branch_23:
    BCLR    #4,-31(A5)

.branch_24:
    MOVEQ   #0,D0
    MOVE.B  -28(A5),D0
    MOVEQ   #0,D1
    MOVE.W  -32(A5),D1
    MOVEQ   #0,D2
    MOVE.B  -29(A5),D2
    MOVEQ   #0,D3
    MOVE.B  -30(A5),D3
    PEA     -27(A5)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -36(A5),-(A7)
    BSR.W   ESQDISP_FillProgramInfoHeaderFields

    LEA     24(A7),A7

.lab_0918:
    ADDQ.L  #1,D7
    BRA.W   .branch

;------------------------------------------------------------------------------
; FUNC: ESQDISP_ParseProgramInfoCommandRecord_Return   (Return tail for program-info parser)
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
;   Shared return tail for ESQDISP_ParseProgramInfoCommandRecord.
; NOTES:
;   Restores D2-D3/D5-D7/A2-A3 and frame state.
;------------------------------------------------------------------------------
ESQDISP_ParseProgramInfoCommandRecord_Return:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_TestEntryGridEligibility   (Test per-slot grid eligibility)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D6/D7
; CALLS:
;   (none)
; READS:
;   fc
; WRITES:
;   (none observed)
; DESC:
;   Returns 1 when the requested slot index is valid and either entry slot bit4
;   is set or the slot value byte (base+0xFC+idx) lies in range 5..10.
; NOTES:
;   Valid slot range is 1..48; otherwise returns 0.
;------------------------------------------------------------------------------
ESQDISP_TestEntryGridEligibility:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVE.W  22(A7),D7

    MOVEQ   #0,D6
    TST.W   D7
    BLE.S   ESQDISP_TestEntryGridEligibility_Return

    MOVEQ   #49,D0
    CMP.W   D0,D7
    BGE.S   ESQDISP_TestEntryGridEligibility_Return

    MOVE.L  A3,D0
    BEQ.S   ESQDISP_TestEntryGridEligibility_Return

    BTST    #4,7(A3,D7.W)
    BNE.S   .lab_091C

    MOVE.L  D7,D0
    ADDI.W  #$fc,D0
    CMPI.B  #$5,0(A3,D0.W)
    BCS.S   .lab_091B

    MOVE.L  D7,D0
    ADDI.W  #$fc,D0
    CMPI.B  #$a,0(A3,D0.W)
    BLS.S   .lab_091C

.lab_091B:
    MOVEQ   #0,D0
    BRA.S   .lab_091D

.lab_091C:
    MOVEQ   #1,D0

.lab_091D:
    MOVE.L  D0,D6

;------------------------------------------------------------------------------
; FUNC: ESQDISP_TestEntryGridEligibility_Return   (Return tail for grid eligibility test)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D6
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Shared return tail for ESQDISP_TestEntryGridEligibility.
; NOTES:
;   Returns D6 in D0.
;------------------------------------------------------------------------------
ESQDISP_TestEntryGridEligibility_Return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_TestEntryBits0And2   (Test entry flags bit0+bit2)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Alias entry that immediately falls through to `_Core` implementation below.
; NOTES:
;   Kept as exported compatibility label for existing callsites.
;------------------------------------------------------------------------------
ESQDISP_TestEntryBits0And2:
;------------------------------------------------------------------------------
; FUNC: ESQDISP_TestEntryBits0And2_Core   (Test entry flags bit0 and bit2)
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
;   (none observed)
; DESC:
;   Returns 1 only when both bit0 and bit2 are set in entry status byte +40.
; NOTES:
;   Returns 0 for NULL entry pointers.
;------------------------------------------------------------------------------
ESQDISP_TestEntryBits0And2_Core:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3

    MOVEQ   #0,D7
    MOVE.L  A3,D0
    BEQ.S   .return

    BTST    #0,40(A3)
    BEQ.S   .bits_not_set

    BTST    #2,40(A3)
    BEQ.S   .bits_not_set

    MOVEQ   #1,D0
    BRA.S   .store_result

.bits_not_set:
    MOVEQ   #0,D0

.store_result:
    MOVE.L  D0,D7

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_GetEntryPointerByMode   (Get entry pointer by mode/index)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Alias documentation header; full behavior contract is defined in the
;   immediately following detailed header block.
; NOTES:
;   Preserved as entry marker before expanded ARGS/READS section.
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
; FUNC: ESQDISP_GetEntryPointerByMode   (Get entry pointer by mode/index)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A7/D0/D6/D7
; CALLS:
;   (none)
; READS:
;   TEXTDISP_SecondaryGroupEntryCount, TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_PrimaryEntryPtrTable, TEXTDISP_SecondaryEntryPtrTable
; WRITES:
;   (none observed)
; DESC:
;   Returns entry pointer for index in primary mode (1) or secondary mode (2),
;   with bounds checks against each group's entry count.
; NOTES:
;   Returns NULL for out-of-range index or unsupported mode.
;------------------------------------------------------------------------------
ESQDISP_GetEntryPointerByMode:
    LINK.W  A5,#-4
    MOVEM.L D6-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    CLR.L   -4(A5)

    MOVEQ   #1,D0
    CMP.L   D0,D6
    BNE.S   .lab_0924

    TST.L   D7
    BMI.S   .return

    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    BRA.S   .return

.lab_0924:
    MOVEQ   #2,D0
    CMP.L   D0,D6
    BNE.S   .return

    TST.L   D7
    BMI.S   .return

    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,-4(A5)

.return:
    MOVE.L  -4(A5),D0
    MOVEM.L (A7)+,D6-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_GetEntryAuxPointerByMode   (Get auxiliary pointer by mode/index)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Wrapper/prototype header for mode/index title-table lookup.
; NOTES:
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
; FUNC: ESQDISP_GetEntryAuxPointerByMode   (Get title-table pointer by mode/index)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A7/D0/D1/D5/D6/D7
; CALLS:
;   (none)
; READS:
;   TEXTDISP_SecondaryGroupEntryCount, TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_PrimaryTitlePtrTable, TEXTDISP_SecondaryTitlePtrTable
; WRITES:
;   (none observed)
; DESC:
;   Returns title-table pointer for index in primary mode (1) or secondary mode
;   (2), with bounds checks against each group's entry count.
; NOTES:
;   Returns NULL for out-of-range index or unsupported mode.
;------------------------------------------------------------------------------
ESQDISP_GetEntryAuxPointerByMode:
    LINK.W  A5,#-4
    MOVEM.L D6-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    CLR.L   -4(A5)

    MOVEQ   #1,D0
    CMP.L   D0,D6
    BNE.S   .lab_0927

    TST.L   D7
    BMI.S   .return

    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    BRA.S   .return

.lab_0927:
    MOVEQ   #2,D0
    CMP.L   D0,D6
    BNE.S   .return

    TST.L   D7
    BMI.S   .return

    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,-4(A5)

.return:
    MOVE.L  -4(A5),D0
    MOVEM.L (A7)+,D6-D7
    UNLK    A5
    RTS

;!======

; Unreferenced Code
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7

    MOVEQ   #23,D1
    CMP.W   D1,D7
    SGT     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0

    MOVE.L  (A7)+,D7
    RTS

;!======

; Unreferenced Code
    MOVEM.L D5-D7,-(A7)
    MOVE.W  18(A7),D7
    MOVE.W  22(A7),D6

    MOVEQ   #-1,D0
    CMP.W   D0,D6
    BNE.S   .lab_0929

    CMPI.W  #$16e,D7
    BLE.S   .lab_0929

    MOVEQ   #1,D5
    BRA.S   .lab_092B

.lab_0929:
    TST.W   D6
    BNE.S   .lab_092A

    CMPI.W  #$16d,D7
    BLE.S   .lab_092A

    MOVEQ   #1,D5
    BRA.S   .lab_092B

.lab_092A:
    MOVEQ   #0,D5

.lab_092B:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7
    RTS

;!======

; Unreferenced Code
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7

    TST.W   D7
    SMI     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0

    MOVE.L  (A7)+,D7
    RTS

;!======

; Unreferenced Code
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7

    MOVEQ   #1,D1
    CMP.W   D1,D7
    SLT     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0

    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_PollInputModeAndRefreshSelection   (Debounce input mode and refresh selection)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A5/A7/D0/D1/D7
; CALLS:
;   ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh, ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode
; READS:
;   DATA_ESQDISP_CONST_BYTE_1E8B, bfd0ee
; WRITES:
;   DATA_ESQDISP_CONST_BYTE_1E8B, DATA_ESQDISP_BSS_LONG_1E8C, Global_RefreshTickCounter
; DESC:
;   Polls CIAB input mode bits with debounce; when stable change is detected,
;   updates mode state and either resets selection or redraws rast mode.
; NOTES:
;   Requires >5 consecutive polls before committing mode change.
;------------------------------------------------------------------------------
ESQDISP_PollInputModeAndRefreshSelection:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    MOVE.W  #(-1),Global_RefreshTickCounter
    MOVE.L  #$bfd0ee,-6(A5) ; uncertain, between PRA_CIAB and PRB_CIAB
    MOVEQ   #4,D7
    MOVEA.L -6(A5),A0
    AND.B   (A0),D7
    MOVE.B  DATA_ESQDISP_CONST_BYTE_1E8B,D0
    CMP.B   D7,D0
    BEQ.S   .lab_092D

    ADDQ.L  #1,DATA_ESQDISP_BSS_LONG_1E8C
    BRA.S   .lab_092E

.lab_092D:
    MOVEQ   #0,D0
    MOVE.L  D0,DATA_ESQDISP_BSS_LONG_1E8C

.lab_092E:
    CMPI.L  #$5,DATA_ESQDISP_BSS_LONG_1E8C
    BLE.S   .return

    MOVE.L  D7,D0
    MOVE.B  D0,DATA_ESQDISP_CONST_BYTE_1E8B
    MOVEQ   #0,D1
    MOVE.L  D1,DATA_ESQDISP_BSS_LONG_1E8C
    TST.B   D0
    BNE.S   .lab_092F

    MOVE.L  D1,-(A7)
    JSR     ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(PC)

    ADDQ.W  #4,A7
    BRA.S   .return

.lab_092F:
    JSR     ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh(PC)

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_NormalizeClockAndRedrawBanner   (Normalize clock and redraw banner/status)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A3/A5/A7
; CALLS:
;   DST_RefreshBannerBuffer, DST_UpdateBannerQueue, ESQFUNC_JMPTBL_CLEANUP_DrawClockBanner, ESQFUNC_JMPTBL_PARSEINI_NormalizeClockData, ESQDISP_DrawStatusBanner_Impl
; READS:
;   Global_REF_696_400_BITMAP, Global_REF_RASTPORT_1, DST_BannerWindowPrimary, CLOCK_DaySlotIndex
; WRITES:
;   (none observed)
; DESC:
;   Normalizes clock data, updates banner queue/buffer, draws clock banner on
;   the 696x400 bitmap, then redraws status banner with highlight enabled.
; NOTES:
;   Temporarily swaps rastport bitmap pointer during clock banner draw.
;------------------------------------------------------------------------------
ESQDISP_NormalizeClockAndRedrawBanner:
    LINK.W  A5,#-4
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  A3,-(A7)
    PEA     CLOCK_DaySlotIndex
    JSR     ESQFUNC_JMPTBL_PARSEINI_NormalizeClockData(PC)

    PEA     DST_BannerWindowPrimary
    JSR     DST_UpdateBannerQueue(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .lab_0932

    JSR     DST_RefreshBannerBuffer(PC)

.lab_0932:
    MOVEA.L Global_REF_RASTPORT_1,A0
    MOVE.L  4(A0),-4(A5)
    MOVE.L  #Global_REF_696_400_BITMAP,4(A0)
    JSR     ESQFUNC_JMPTBL_CLEANUP_DrawClockBanner(PC)

    MOVEA.L Global_REF_RASTPORT_1,A0
    MOVE.L  -4(A5),4(A0)
    PEA     1.W
    BSR.W   ESQDISP_DrawStatusBanner_Impl

    MOVEA.L -8(A5),A3
    UNLK    A5
    RTS

;!======

; Draw the status banner into rastport 1 (with optional highlight).
ESQDISP_DrawStatusBanner:
;------------------------------------------------------------------------------
; FUNC: ESQDISP_DrawStatusBanner_Impl   (Render status banner rows and sync slot state)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A6/A7/D0/D1/D2/D3/D5/D6/D7
; CALLS:
;   ESQFUNC_JMPTBL_ESQ_ClampBannerCharRange, ESQFUNC_JMPTBL_ESQ_GetHalfHourSlotIndex, ESQFUNC_JMPTBL_LOCAVAIL_SyncSecondaryFilterForCurrentGroup, ESQFUNC_JMPTBL_P_TYPE_EnsureSecondaryList, ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState, ESQIFF_JMPTBL_MATH_Mulu32, ESQDISP_PropagatePrimaryTitleMetadataToSecondary, _LVOSetAPen
; READS:
;   Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, DATA_ESQ_STR_B_1DC8, DATA_ESQ_STR_E_1DC9, DATA_ESQDISP_CONST_WORD_1E85, DATA_ESQDISP_BSS_WORD_1E8D, DATA_ESQDISP_CONST_WORD_1E8E, DATA_ESQDISP_CONST_WORD_1E8F, WDISP_StatusDayEntry0, WDISP_StatusDayEntry1, WDISP_StatusDayEntry2, WDISP_StatusDayEntry3, CLOCK_DaySlotIndex, DATA_WDISP_BSS_WORD_223B, DATA_WDISP_BSS_WORD_223C, DATA_WDISP_BSS_WORD_223D, DST_PrimaryCountdown, WDISP_BannerSlotCursor, CLOCK_HalfHourSlotIndex, DATA_WDISP_BSS_WORD_227C, lab_0942, lab_0943, lab_0944
; WRITES:
;   DATA_COMMON_BSS_LONG_1B08, DATA_ESQDISP_BSS_LONG_1E88, DATA_ESQDISP_BSS_WORD_1E8D, DATA_ESQDISP_CONST_WORD_1E8E, DATA_ESQDISP_CONST_WORD_1E8F, DATA_TLIBA1_CONST_LONG_219B, TEXTDISP_SecondaryGroupCode, TEXTDISP_PrimaryGroupCode, CLOCK_HalfHourSlotIndex
; DESC:
;   Computes the current half-hour banner slot, applies optional range clamp,
;   updates highlight/banner state, and renders status text for active day entries.
; NOTES:
;   May trigger one-time secondary metadata/list propagation when threshold
;   conditions are met near function tail.
;------------------------------------------------------------------------------
ESQDISP_DrawStatusBanner_Impl:
    LINK.W  A5,#-4
    MOVEM.L D2-D3/D5-D7/A2,-(A7)
    MOVE.W  38(A7),D7
    MOVEQ   #0,D5
    MOVEA.L Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    PEA     CLOCK_DaySlotIndex
    JSR     ESQFUNC_JMPTBL_ESQ_GetHalfHourSlotIndex(PC)

    ADDQ.W  #4,A7
    MOVE.W  D0,CLOCK_HalfHourSlotIndex
    TST.W   DATA_ESQDISP_CONST_WORD_1E85
    BEQ.S   .lab_0934

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVEQ   #0,D0
    MOVE.B  DATA_ESQ_STR_B_1DC8,D0
    MOVEQ   #0,D2
    MOVE.B  DATA_ESQ_STR_E_1DC9,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    JSR     ESQFUNC_JMPTBL_ESQ_ClampBannerCharRange(PC)

    LEA     12(A7),A7

.lab_0934:
    JSR     ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState(PC)

    TST.W   D7
    BEQ.S   .lab_0935

    MOVEQ   #1,D0
    MOVE.W  D0,DATA_COMMON_BSS_LONG_1B08

.lab_0935:
    MOVE.W  CLOCK_HalfHourSlotIndex,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCS.S   .lab_0937

    MOVEQ   #39,D1
    CMP.W   D1,D0
    BCC.S   .lab_0937

    MOVE.W  WDISP_BannerSlotCursor,D1
    EXT.L   D1
    MOVEQ   #0,D2
    NOT.B   D2
    AND.L   D2,D1
    MOVE.B  D1,TEXTDISP_PrimaryGroupCode
    MOVE.W  DATA_WDISP_BSS_WORD_223C,D0
    MOVEQ   #31,D3
    CMP.W   D3,D0
    BNE.S   .lab_0936

    MOVE.W  DATA_WDISP_BSS_WORD_223B,D0
    MOVEQ   #11,D3
    CMP.W   D3,D0
    BNE.S   .lab_0936

    MOVE.B  #$1,TEXTDISP_SecondaryGroupCode
    BRA.S   .lab_093A

.lab_0936:
    MOVEQ   #0,D0
    MOVE.B  D1,D0
    ADDQ.L  #1,D0
    AND.L   D2,D0
    MOVE.B  D0,TEXTDISP_SecondaryGroupCode
    BRA.S   .lab_093A

.lab_0937:
    MOVE.W  WDISP_BannerSlotCursor,D1
    EXT.L   D1
    MOVEQ   #0,D2
    NOT.B   D2
    AND.L   D2,D1
    MOVE.B  D1,TEXTDISP_SecondaryGroupCode
    MOVE.W  WDISP_BannerSlotCursor,D0
    SUBQ.W  #1,D0
    BNE.S   .lab_0939

    MOVE.W  DATA_WDISP_BSS_WORD_223D,D0
    EXT.L   D0
    SUBQ.L  #1,D0
    MOVEQ   #3,D1
    AND.L   D1,D0
    BNE.S   .lab_0938

    MOVE.B  #$6e,TEXTDISP_PrimaryGroupCode
    BRA.S   .lab_093A

.lab_0938:
    MOVE.B  #$6d,TEXTDISP_PrimaryGroupCode
    BRA.S   .lab_093A

.lab_0939:
    MOVE.W  WDISP_BannerSlotCursor,D0
    EXT.L   D0
    SUBQ.L  #1,D0
    AND.L   D2,D0
    MOVE.B  D0,TEXTDISP_PrimaryGroupCode

.lab_093A:
    MOVE.W  DST_PrimaryCountdown,D0
    MOVE.W  DATA_ESQDISP_BSS_WORD_1E8D,D1
    CMP.W   D0,D1
    BEQ.S   .lab_093C

    MOVE.W  D0,DATA_ESQDISP_BSS_WORD_1E8D
    SUBQ.W  #1,D0
    BNE.S   .lab_093C

    MOVE.W  CLOCK_HalfHourSlotIndex,D0
    SUBQ.W  #3,D0
    BNE.S   .lab_093B

    MOVEQ   #0,D0
    MOVE.W  D0,DATA_ESQDISP_CONST_WORD_1E8E
    BRA.S   .lab_093C

.lab_093B:
    MOVE.W  CLOCK_HalfHourSlotIndex,D0
    MOVEQ   #46,D1
    CMP.W   D1,D0
    BNE.S   .lab_093C

    CLR.W   DATA_ESQDISP_CONST_WORD_1E8F

.lab_093C:
    MOVEQ   #0,D6

.lab_093D:
    TST.L   D5
    BNE.S   .lab_0941

    MOVEQ   #4,D0
    CMP.L   D0,D6
    BGE.S   .lab_0941

    MOVE.L  D6,D0
    MOVEQ   #20,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     WDISP_StatusDayEntry0,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   16(A1)
    BNE.S   .lab_093E

    MOVE.W  DATA_WDISP_BSS_WORD_227C,D1
    EXT.L   D1
    ADD.L   D6,D1
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    CMP.L   (A1),D1
    BEQ.S   .lab_093F

.lab_093E:
    MOVE.W  DATA_WDISP_BSS_WORD_227C,D0
    EXT.L   D0
    ADD.L   D6,D0
    MOVE.L  D0,24(A7)
    MOVE.L  D6,D0
    MOVEQ   #20,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    ADDA.L  D0,A0
    MOVE.L  24(A7),D0
    ADDI.L  #$100,D0
    CMP.L   (A0),D0
    BEQ.S   .lab_093F

    MOVEQ   #0,D0
    BRA.S   .lab_0940

.lab_093F:
    MOVEQ   #1,D0

.lab_0940:
    MOVE.L  D0,D5
    ADDQ.L  #1,D6
    BRA.S   .lab_093D

.lab_0941:
    TST.L   D5
    BEQ.S   .lab_0945

    LEA     WDISP_StatusDayEntry1,A0
    MOVEA.L A0,A1
    LEA     WDISP_StatusDayEntry0,A2
    MOVEQ   #4,D0

.lab_0942:
    MOVE.L  (A1)+,(A2)+
    DBF     D0,.lab_0942
    LEA     WDISP_StatusDayEntry2,A0
    MOVEA.L A0,A1
    LEA     WDISP_StatusDayEntry1,A2
    MOVEQ   #4,D0

.lab_0943:
    MOVE.L  (A1)+,(A2)+
    DBF     D0,.lab_0943
    LEA     WDISP_StatusDayEntry3,A0
    LEA     WDISP_StatusDayEntry2,A1
    MOVEQ   #4,D0

.lab_0944:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.lab_0944
    MOVEQ   #1,D0
    MOVE.L  D0,DATA_TLIBA1_CONST_LONG_219B

.lab_0945:
    MOVE.W  CLOCK_HalfHourSlotIndex,D0
    SUBQ.W  #1,D0
    BNE.S   .lab_0946

    MOVEQ   #0,D0
    MOVE.W  D0,DATA_ESQDISP_CONST_WORD_1E8E

.lab_0946:
    MOVE.W  CLOCK_HalfHourSlotIndex,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCS.S   .lab_0947

    TST.W   DATA_ESQDISP_CONST_WORD_1E8E
    BNE.S   .lab_0947

    MOVEQ   #1,D1
    MOVE.L  D1,DATA_ESQDISP_BSS_LONG_1E88
    MOVE.W  #1,DATA_ESQDISP_CONST_WORD_1E8E

.lab_0947:
    MOVEQ   #44,D1
    CMP.W   D1,D0
    BNE.S   .lab_0948

    MOVEQ   #0,D1
    MOVE.W  D1,DATA_ESQDISP_CONST_WORD_1E8F

.lab_0948:
    MOVEQ   #45,D1
    CMP.W   D1,D0
    BCS.S   ESQDISP_DrawStatusBanner_Impl_Return

    TST.W   DATA_ESQDISP_CONST_WORD_1E8F
    BNE.S   ESQDISP_DrawStatusBanner_Impl_Return

    BSR.W   ESQDISP_PropagatePrimaryTitleMetadataToSecondary

    JSR     ESQFUNC_JMPTBL_LOCAVAIL_SyncSecondaryFilterForCurrentGroup(PC)

    JSR     ESQFUNC_JMPTBL_P_TYPE_EnsureSecondaryList(PC)

    MOVE.W  #1,DATA_ESQDISP_CONST_WORD_1E8F

;------------------------------------------------------------------------------
; FUNC: ESQDISP_DrawStatusBanner_Impl_Return   (Return tail for status-banner renderer)
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
;   Restores saved registers/frame and returns to caller.
; NOTES:
;   Shared exit for all draw/early-return paths.
;------------------------------------------------------------------------------
ESQDISP_DrawStatusBanner_Impl_Return:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty   (Mirror primary entries into secondary group when empty)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D2/D3/D7
; CALLS:
;   ESQDISP_FillProgramInfoHeaderFields, ESQSHARED_CreateGroupEntryAndTitle
; READS:
;   TEXTDISP_SecondaryGroupCode, TEXTDISP_SecondaryGroupEntryCount, TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_PrimaryEntryPtrTable, TEXTDISP_SecondaryEntryPtrTablePreSlot, ff7f
; WRITES:
;   DATA_ESQDISP_BSS_WORD_1E87
; DESC:
;   If secondary group has no entries, clones each primary entry into a newly created
;   secondary entry/title record and copies the per-slot program-info header fields.
;   Sets a flag when mirroring was performed, clears it when secondary was already populated.
; NOTES:
;   Loop walks primary indices from 0 to (PrimaryGroupEntryCount-1).
;------------------------------------------------------------------------------
ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty:
    LINK.W  A5,#-12
    MOVEM.L D2-D3/D7/A2-A3/A6,-(A7)
    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D0
    BNE.W   .mark_no_mirror_needed

    MOVEQ   #0,D7

.loop_primary_entries_for_mirror:
    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D7
    BGE.W   .set_mirror_performed_flag

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    MOVEQ   #0,D0
    MOVE.B  TEXTDISP_SecondaryGroupCode,D0
    MOVEQ   #0,D1
    MOVEA.L -4(A5),A0
    MOVE.B  27(A0),D1
    LEA     12(A0),A1
    LEA     1(A0),A2
    LEA     28(A0),A3
    LEA     19(A0),A6
    MOVE.L  A6,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQSHARED_CreateGroupEntryAndTitle(PC)

    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ASL.L   #2,D1
    LEA     TEXTDISP_SecondaryEntryPtrTablePreSlot,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  40(A0),D0
    ANDI.W  #$ff7f,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #0,D0
    MOVE.W  46(A0),D0
    MOVEQ   #0,D2
    MOVE.B  41(A0),D2
    MOVEQ   #0,D3
    MOVE.B  42(A0),D3
    LEA     43(A0),A2
    MOVE.L  A2,(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A1,-8(A5)
    BSR.W   ESQDISP_FillProgramInfoHeaderFields

    LEA     44(A7),A7
    ADDQ.L  #1,D7
    BRA.W   .loop_primary_entries_for_mirror

.set_mirror_performed_flag:
    MOVE.W  #1,DATA_ESQDISP_BSS_WORD_1E87
    BRA.S   ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty_Return

.mark_no_mirror_needed:
    CLR.W   DATA_ESQDISP_BSS_WORD_1E87

;------------------------------------------------------------------------------
; FUNC: ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty_Return   (Return tail for secondary mirror helper)
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
;   Restores saved registers and returns from secondary-mirror helper.
; NOTES:
;   Shared return tail for both "mirrored" and "already populated" paths.
;------------------------------------------------------------------------------
ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty_Return:
    MOVEM.L (A7)+,D2-D3/D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_PropagatePrimaryTitleMetadataToSecondary   (Propagate primary title metadata to matching secondary entries)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   ESQSHARED_JMPTBL_ESQ_TestBit1Based, ESQSHARED_JMPTBL_ESQ_WildcardMatch, ESQPARS_ReplaceOwnedString
; READS:
;   TEXTDISP_SecondaryGroupEntryCount, TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_PrimaryEntryPtrTable, TEXTDISP_SecondaryEntryPtrTable, TEXTDISP_PrimaryTitlePtrTable, TEXTDISP_SecondaryTitlePtrTable
; WRITES:
;   (none observed)
; DESC:
;   For each secondary entry lacking an owned title string and with the slot bit clear,
;   finds wildcard-matching primary titles and copies slot metadata/string ownership from
;   primary to secondary. Marks secondary title/entry flags when propagation succeeds.
; NOTES:
;   Slot scan is descending and bounded by entry class (0..47 or 44..47 window).
;------------------------------------------------------------------------------
ESQDISP_PropagatePrimaryTitleMetadataToSecondary:
    LINK.W  A5,#-40
    MOVEM.L D2-D7/A2-A3/A6,-(A7)
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.W   ESQDISP_PropagatePrimaryTitleMetadataToSecondary_Return

    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.W   D1,D0
    BLS.W   ESQDISP_PropagatePrimaryTitleMetadataToSecondary_Return

    MOVEQ   #0,D7

.loop_secondary_entries:
    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.L   D0,D7
    BGE.W   ESQDISP_PropagatePrimaryTitleMetadataToSecondary_Return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    TST.L   60(A1)
    BNE.W   .next_secondary_entry

    LEA     TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    LEA     28(A1),A0
    PEA     1.W
    MOVE.L  A0,-(A7)
    JSR     ESQSHARED_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   .next_secondary_entry

    MOVEQ   #0,D4
    MOVEQ   #0,D6

.loop_primary_candidates:
    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D6
    BGE.W   .next_secondary_entry

    TST.L   D4
    BNE.W   .next_secondary_entry

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    MOVE.L  A2,-(A7)
    MOVE.L  A1,-(A7)
    JSR     ESQSHARED_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.W   .next_primary_candidate

    MOVEQ   #48,D5
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    BTST    #5,27(A1)
    BEQ.S   .set_slot_scan_floor_low

    MOVEQ   #0,D0
    BRA.S   .store_slot_scan_floor

.set_slot_scan_floor_low:
    MOVEQ   #44,D0

.store_slot_scan_floor:
    MOVE.L  D0,-20(A5)

.loop_slots_descending:
    CMP.L   -20(A5),D5
    BLE.W   .next_primary_candidate

    TST.L   D4
    BNE.W   .next_primary_candidate

    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    LEA     28(A1),A0
    MOVE.L  D5,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ESQSHARED_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   .next_slot_descending

    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryTitlePtrTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    MOVE.L  D5,D1
    ASL.L   #2,D1
    ADDA.L  D1,A2
    TST.L   56(A2)
    BEQ.W   .next_slot_descending

    MOVE.L  D7,D2
    ASL.L   #2,D2
    LEA     TEXTDISP_SecondaryTitlePtrTable,A1
    MOVEA.L A1,A2
    ADDA.L  D2,A2
    MOVEA.L (A2),A3
    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVEA.L (A2),A6
    ADDA.L  D5,A6
    MOVEQ   #0,D3
    MOVE.B  7(A6),D3
    ORI.W   #$80,D3
    MOVE.B  D3,8(A3)
    MOVEA.L A1,A2
    ADDA.L  D2,A2
    MOVEA.L (A2),A3
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    ADDA.L  D1,A2
    ADDA.L  D2,A1
    MOVEA.L (A1),A0
    MOVE.L  60(A0),-(A7)
    MOVE.L  56(A2),-(A7)
    MOVE.L  A3,60(A7)
    JSR     ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVEA.L 52(A7),A0
    MOVE.L  D0,60(A0)
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     TEXTDISP_SecondaryTitlePtrTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    MOVE.L  D6,D1
    ASL.L   #2,D1
    LEA     TEXTDISP_PrimaryTitlePtrTable,A1
    MOVEA.L A1,A3
    ADDA.L  D1,A3
    MOVEA.L (A3),A6
    ADDA.L  D5,A6
    MOVE.B  252(A6),253(A2)
    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVEA.L (A2),A3
    MOVEA.L A1,A2
    ADDA.L  D1,A2
    MOVEA.L (A2),A6
    ADDA.L  D5,A6
    MOVE.B  301(A6),302(A3)
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    ADDA.L  D1,A1
    MOVEA.L (A1),A0
    ADDA.L  D5,A0
    MOVE.B  350(A0),351(A2)
    LEA     TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEQ   #0,D0
    MOVE.B  40(A1),D0
    MOVE.L  D0,D1
    ORI.W   #$80,D1
    MOVE.B  D1,40(A1)
    MOVEQ   #1,D4

.next_slot_descending:
    SUBQ.L  #1,D5
    BRA.W   .loop_slots_descending

.next_primary_candidate:
    ADDQ.L  #1,D6
    BRA.W   .loop_primary_candidates

.next_secondary_entry:
    ADDQ.L  #1,D7
    BRA.W   .loop_secondary_entries

;------------------------------------------------------------------------------
; FUNC: ESQDISP_PropagatePrimaryTitleMetadataToSecondary_Return   (Return tail for title-metadata propagation)
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
;   Restores saved registers and returns from title-metadata propagation helper.
; NOTES:
;   Early exits branch here when primary/secondary counts are zero.
;------------------------------------------------------------------------------
ESQDISP_PropagatePrimaryTitleMetadataToSecondary_Return:
    MOVEM.L (A7)+,D2-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_PromoteSecondaryGroupToPrimary   (Promote secondary group entries/titles into primary tables)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A1/A2/A3/A7/D0/D1/D7
; CALLS:
;   ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache, ESQPARS_RemoveGroupEntryAndReleaseStrings
; READS:
;   DATA_CTASKS_BSS_BYTE_1B90, DATA_CTASKS_BSS_BYTE_1B92, TEXTDISP_SecondaryGroupPresentFlag, TEXTDISP_SecondaryGroupEntryCount, TEXTDISP_PrimaryEntryPtrTable, TEXTDISP_SecondaryEntryPtrTable, TEXTDISP_PrimaryTitlePtrTable, TEXTDISP_SecondaryTitlePtrTable, TEXTDISP_SecondaryGroupHeaderCode, TEXTDISP_SecondaryGroupRecordChecksum, TEXTDISP_SecondaryGroupRecordLength, ff
; WRITES:
;   DATA_CTASKS_BSS_BYTE_1B8F, DATA_CTASKS_BSS_BYTE_1B90, DATA_CTASKS_BSS_BYTE_1B91, DATA_CTASKS_BSS_BYTE_1B92, TEXTDISP_SecondaryGroupPresentFlag, TEXTDISP_SecondaryGroupEntryCount, TEXTDISP_PrimaryGroupEntryCount, TEXTDISP_PrimaryGroupHeaderCode, TEXTDISP_PrimaryGroupRecordChecksum, TEXTDISP_PrimaryGroupRecordLength, TEXTDISP_PrimaryGroupPresentFlag, TEXTDISP_GroupMutationState, TEXTDISP_SecondaryGroupRecordChecksum, TEXTDISP_SecondaryGroupRecordLength, NEWGRID_RefreshStateFlag
; DESC:
;   Clears existing mode-1 group via parser helper, then when a secondary group is
;   present moves all secondary entry/title pointers into primary tables, copies group
;   header metadata, clears secondary state, and rebuilds the NEWGRID index cache.
; NOTES:
;   Pointer arrays are moved by index and secondary table slots are nulled after transfer.
;------------------------------------------------------------------------------
ESQDISP_PromoteSecondaryGroupToPrimary:
    MOVEM.L D7/A2-A3,-(A7)
    PEA     1.W
    JSR     ESQPARS_RemoveGroupEntryAndReleaseStrings(PC)

    ADDQ.W  #4,A7
    MOVEQ   #1,D0
    MOVE.L  D0,NEWGRID_RefreshStateFlag
    MOVEQ   #0,D0
    MOVE.W  D0,TEXTDISP_GroupMutationState
    CLR.B   TEXTDISP_PrimaryGroupRecordChecksum
    MOVE.W  D0,TEXTDISP_PrimaryGroupRecordLength
    MOVE.B  TEXTDISP_SecondaryGroupPresentFlag,D1
    SUBQ.B  #1,D1
    BNE.W   .sync_task_state_and_reindex

    MOVE.L  D0,D7

.loop_move_secondary_slots:
    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.W   D0,D7
    BGE.S   .copy_secondary_group_metadata

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    LEA     TEXTDISP_SecondaryEntryPtrTable,A1
    MOVEA.L A1,A2
    ADDA.L  D0,A2
    MOVE.L  (A2),(A0)
    LEA     TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    LEA     TEXTDISP_SecondaryTitlePtrTable,A2
    MOVEA.L A2,A3
    ADDA.L  D0,A3
    MOVE.L  (A3),(A0)
    ADDA.L  D0,A1
    SUBA.L  A0,A0
    MOVE.L  A0,(A1)
    ADDA.L  D0,A2
    MOVE.L  A0,(A2)
    ADDQ.W  #1,D7
    BRA.S   .loop_move_secondary_slots

.copy_secondary_group_metadata:
    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,TEXTDISP_PrimaryGroupEntryCount
    MOVE.B  TEXTDISP_SecondaryGroupRecordChecksum,TEXTDISP_PrimaryGroupRecordChecksum
    MOVE.B  TEXTDISP_SecondaryGroupHeaderCode,TEXTDISP_PrimaryGroupHeaderCode
    MOVE.W  TEXTDISP_SecondaryGroupRecordLength,TEXTDISP_PrimaryGroupRecordLength
    MOVE.B  #$1,TEXTDISP_PrimaryGroupPresentFlag
    MOVEQ   #0,D0
    MOVE.W  D0,TEXTDISP_SecondaryGroupEntryCount
    MOVEQ   #0,D1
    MOVE.B  D1,TEXTDISP_SecondaryGroupRecordChecksum
    MOVE.W  D0,TEXTDISP_SecondaryGroupRecordLength
    MOVE.B  D1,TEXTDISP_SecondaryGroupPresentFlag
    MOVE.W  #3,TEXTDISP_GroupMutationState

.sync_task_state_and_reindex:
    MOVE.B  DATA_CTASKS_BSS_BYTE_1B92,DATA_CTASKS_BSS_BYTE_1B91
    MOVE.B  DATA_CTASKS_BSS_BYTE_1B90,DATA_CTASKS_BSS_BYTE_1B8F
    MOVE.B  #$ff,DATA_CTASKS_BSS_BYTE_1B92
    CLR.B   DATA_CTASKS_BSS_BYTE_1B90
    JSR     ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache(PC)

    MOVEM.L (A7)+,D7/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_PromoteSecondaryLineHeadTailIfMarked   (Promote secondary line head/tail pointers when flagged)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A7
; CALLS:
;   ESQIFF2_ClearLineHeadTailByMode
; READS:
;   ESQIFF_SecondaryLineHeadPtr, ESQIFF_SecondaryLineTailPtr, DATA_WDISP_BSS_WORD_228F
; WRITES:
;   ESQIFF_PrimaryLineHeadPtr, ESQIFF_PrimaryLineTailPtr, ESQIFF_SecondaryLineHeadPtr, ESQIFF_SecondaryLineTailPtr, DATA_WDISP_BSS_WORD_228F
; DESC:
;   If the secondary line chain is marked pending, clears primary line chain for mode 1,
;   moves secondary head/tail pointers into primary, then clears secondary pointers.
; NOTES:
;   Always clears DATA_WDISP_BSS_WORD_228F before return.
;------------------------------------------------------------------------------
ESQDISP_PromoteSecondaryLineHeadTailIfMarked:
    TST.W   DATA_WDISP_BSS_WORD_228F
    BEQ.S   .clear_pending_line_promote_flag

    PEA     1.W
    JSR     ESQIFF2_ClearLineHeadTailByMode(PC)

    ADDQ.W  #4,A7
    MOVE.L  ESQIFF_SecondaryLineHeadPtr,ESQIFF_PrimaryLineHeadPtr
    MOVE.L  ESQIFF_SecondaryLineTailPtr,ESQIFF_PrimaryLineTailPtr
    SUBA.L  A0,A0
    MOVE.L  A0,ESQIFF_SecondaryLineHeadPtr
    MOVE.L  A0,ESQIFF_SecondaryLineTailPtr

.clear_pending_line_promote_flag:
    CLR.W   DATA_WDISP_BSS_WORD_228F
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_TestWordIsZeroBooleanize   (Booleanize word==0 into long 0 or -1)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D7
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Tests a stack-passed word and returns `-1` when it is zero, else returns `0`.
; NOTES:
;   Uses `SEQ` + `NEG` + sign-extension idiom to normalize boolean result.
;------------------------------------------------------------------------------
ESQDISP_TestWordIsZeroBooleanize:
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7
    TST.W   D7
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D7
    MOVE.L  D7,D0
    MOVE.L  (A7)+,D7
    RTS
