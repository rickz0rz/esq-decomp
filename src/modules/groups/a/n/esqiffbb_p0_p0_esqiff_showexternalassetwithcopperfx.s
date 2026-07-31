    XDEF    _ESQIFF_ShowExternalAssetWithCopperFx
    XDEF    ESQIFF_ShowExternalAssetWithCopperFx_Return



;------------------------------------------------------------------------------
; FUNC: _ESQIFF_ShowExternalAssetWithCopperFx   (Blit external asset with copper transition effects)
; ARGS:
;   stack +6: arg_1 (via 10(A5))
;   stack +10: arg_2 (via 14(A5))
;   stack +14: arg_3 (via 18(A5))
;   stack +18: arg_4 (via 22(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D1/D2/D4/D5/D6/D7
; CALLS:
;   _ESQIFF_JMPTBL_BRUSH_SelectBrushSlot, _ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode, _ESQIFF_JMPTBL_MATH_DivS32, _ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition, _ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex, _ESQIFF_RunCopperRiseTransition, _ESQIFF_RunCopperDropTransition, _LVOCopyMem, _LVOSetAPen, _LVOSetRast
; READS:
;   AbsExecBase, Global_REF_GRAPHICS_LIBRARY, _Global_REF_RASTPORT_2, _ACCUMULATOR_Row0_CaptureValue, _ACCUMULATOR_Row1_CaptureValue, _ACCUMULATOR_Row2_CaptureValue, _ESQIFF_GAdsBrushListHead, _ESQIFF_LogoBrushListHead, _SCRIPT_BannerTransitionActive, _WDISP_DisplayContextBase, _WDISP_PaletteTriplesRBase, _WDISP_AccumulatorRowTable, _WDISP_AccumulatorRow0_Value, _WDISP_AccumulatorRow0_CopperIndexStart, _WDISP_AccumulatorRow0_CopperIndexEnd, _WDISP_AccumulatorRow1_Value, _WDISP_AccumulatorRow1_CopperIndexStart, _WDISP_AccumulatorRow1_CopperIndexEnd, _WDISP_AccumulatorRow2_Value, _WDISP_AccumulatorRow2_CopperIndexStart, _WDISP_AccumulatorRow2_CopperIndexEnd, _WDISP_AccumulatorRow3_Value, _WDISP_AccumulatorRow3_CopperIndexStart, _WDISP_AccumulatorRow3_CopperIndexEnd, e8
; WRITES:
;   _ACCUMULATOR_Row0_CaptureValue, _ACCUMULATOR_Row1_CaptureValue, _ACCUMULATOR_Row2_CaptureValue, _ACCUMULATOR_Row3_CaptureValue, _ACCUMULATOR_Row0_Sum, _ACCUMULATOR_Row1_Sum, _ACCUMULATOR_Row2_Sum, _ACCUMULATOR_Row3_Sum, _ACCUMULATOR_Row0_SaturateFlag, _ACCUMULATOR_Row1_SaturateFlag, _ACCUMULATOR_Row2_SaturateFlag, _ACCUMULATOR_Row3_SaturateFlag, _ESQFUNC_MissingAssetRetryMask, _WDISP_DisplayContextBase, _WDISP_AccumulatorCaptureActive, _WDISP_AccumulatorFlushPending
; DESC:
;   Selects source brush list by mode, performs drop/rise copper transitions, builds
;   a display context, blits the external asset, and captures accumulator thresholds
;   used by subsequent copper palette motion.
; NOTES:
;   Missing-asset path sets _ESQFUNC_MissingAssetRetryMask bits to request deferred retries.
;------------------------------------------------------------------------------
_ESQIFF_ShowExternalAssetWithCopperFx:
    LINK.W  A5,#-36
    MOVEM.L D2/D4-D7,-(A7)
    MOVE.W  10(A5),D7
    TST.W   D7
    BEQ.S   .select_primary_or_secondary_brush_head

    MOVE.L  _ESQIFF_GAdsBrushListHead,-22(A5)

.select_primary_or_secondary_brush_head:
    TST.W   D7
    BNE.S   .ensure_brush_head_available

    MOVEA.L _ESQIFF_LogoBrushListHead,A0
    MOVE.L  A0,-22(A5)

.ensure_brush_head_available:
    TST.L   -22(A5)
    BEQ.W   .set_missing_asset_pending_flags

    BSR.W   _ESQIFF_RunCopperDropTransition

    MOVEQ   #20,D6
    MOVEA.L -22(A5),A0
    ADD.W   178(A0),D6
    BTST    #2,199(A0)
    BEQ.S   .set_transition_divisor_two

    MOVEQ   #2,D0
    BRA.S   .compute_transition_steps

.set_transition_divisor_two:
    MOVEQ   #1,D0

.compute_transition_steps:
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  D0,20(A7)
    MOVE.L  D1,D0
    MOVE.L  20(A7),D1
    JSR     _ESQIFF_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D0,D6
    MOVEQ   #120,D0
    CMP.W   D0,D6
    BLE.S   .clamp_transition_steps

    MOVE.L  D0,D6

.clamp_transition_steps:
    ADDI.W  #22,D6
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     1000.W
    MOVE.L  D0,-(A7)
    JSR     _ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition(PC)

    ADDQ.W  #8,A7

.wait_banner_transition_idle:
    TST.W   _SCRIPT_BannerTransitionActive
    BNE.S   .wait_banner_transition_idle

    MOVE.W  #1,_WDISP_AccumulatorCaptureActive
    CLR.W   _WDISP_AccumulatorFlushPending
    MOVEQ   #0,D5

.loop_copy_accumulator_rows:
    MOVEQ   #4,D0
    CMP.L   D0,D5
    BGE.S   .select_display_context_mode

    MOVE.L  D5,D0
    ASL.L   #3,D0
    MOVEA.L -22(A5),A0
    ADDA.L  D0,A0
    LEA     200(A0),A1
    LEA     _WDISP_AccumulatorRowTable,A0
    ADDA.L  D0,A0
    MOVE.L  A0,28(A7)
    MOVEA.L A1,A0
    MOVEA.L 28(A7),A1
    MOVEQ   #8,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    ADDQ.L  #1,D5
    BRA.S   .loop_copy_accumulator_rows

.select_display_context_mode:
    CLR.W   _WDISP_AccumulatorCaptureActive
    MOVE.W  #1,_WDISP_AccumulatorFlushPending
    MOVE.L  #$8004,D0
    MOVEA.L -22(A5),A0
    AND.L   196(A0),D0
    CMPI.L  #$8004,D0
    BNE.S   .select_mode_flag198_bit7

    MOVEQ   #0,D0
    MOVE.B  184(A0),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    PEA     4.W
    JSR     _ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     12(A7),A7
    MOVE.L  D0,_WDISP_DisplayContextBase
    MOVEQ   #20,D4
    BRA.S   .clear_rast_and_blit_asset

.select_mode_flag198_bit7:
    BTST    #7,198(A0)
    BEQ.S   .select_mode_flag199_bit2

    MOVEQ   #0,D0
    MOVE.B  184(A0),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    PEA     6.W
    JSR     _ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     12(A7),A7
    MOVE.L  D0,_WDISP_DisplayContextBase
    MOVEQ   #10,D4
    BRA.S   .clear_rast_and_blit_asset

.select_mode_flag199_bit2:
    BTST    #2,199(A0)
    BEQ.S   .select_mode_fallback

    MOVEQ   #0,D0
    MOVE.B  184(A0),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    PEA     5.W
    JSR     _ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     12(A7),A7
    MOVE.L  D0,_WDISP_DisplayContextBase
    MOVEQ   #20,D4
    BRA.S   .clear_rast_and_blit_asset

.select_mode_fallback:
    MOVEQ   #0,D0
    MOVE.B  184(A0),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    PEA     7.W
    JSR     _ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     12(A7),A7
    MOVE.L  D0,_WDISP_DisplayContextBase
    MOVEQ   #10,D4

.clear_rast_and_blit_asset:
    MOVEA.L D0,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVEQ   #7,D0
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVEA.L _WDISP_DisplayContextBase,A0
    MOVE.W  2(A0),D0
    SUBQ.L  #1,D0
    MOVEQ   #0,D1
    MOVE.W  4(A0),D1
    SUBQ.L  #1,D1
    LEA     10(A0),A1
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  -22(A5),-(A7)
    JSR     _ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(PC)

    LEA     28(A7),A7
    MOVEA.L -22(A5),A0
    TST.L   328(A0)
    BEQ.S   .refresh_palette_triples_from_asset

    MOVEQ   #1,D0
    CMP.L   328(A0),D0
    BNE.S   .capture_accumulator_thresholds

.refresh_palette_triples_from_asset:
    PEA     5.W
    JSR     _ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    MOVEQ   #0,D0
    MOVEA.L -22(A5),A0
    MOVE.B  184(A0),D0
    MOVE.L  D0,(A7)
    MOVE.L  D1,-14(A5)
    JSR     _ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    MOVEQ   #0,D5
    MOVE.L  D1,-18(A5)

.branch:
    CMP.L   -18(A5),D5
    BGE.S   .capture_accumulator_thresholds

    CMP.L   -14(A5),D5
    BGE.S   .capture_accumulator_thresholds

    LEA     _WDISP_PaletteTriplesRBase,A0
    ADDA.L  D5,A0
    MOVEA.L -22(A5),A1
    MOVE.L  D5,D0
    ADDI.L  #$e8,D0
    MOVE.B  0(A1,D0.L),(A0)
    ADDQ.L  #1,D5
    BRA.S   .branch

.capture_accumulator_thresholds:
    MOVE.B  _WDISP_AccumulatorRow0_CopperIndexStart,D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BCC.S   .branch_1

    MOVE.B  _WDISP_AccumulatorRow0_CopperIndexEnd,D0
    CMP.B   D1,D0
    BCC.S   .branch_1

    MOVE.W  _WDISP_AccumulatorRow0_Value,D0
    CMPI.W  #$4000,D0
    BGE.S   .branch_1

    MOVE.W  D0,_ACCUMULATOR_Row0_CaptureValue
    BRA.S   .branch_2

.branch_1:
    MOVEQ   #0,D0
    MOVE.W  D0,_ACCUMULATOR_Row0_CaptureValue

.branch_2:
    MOVE.B  _WDISP_AccumulatorRow1_CopperIndexStart,D2
    CMP.B   D1,D2
    BCC.S   .branch_3

    MOVE.B  _WDISP_AccumulatorRow1_CopperIndexEnd,D2
    CMP.B   D1,D2
    BCC.S   .branch_3

    MOVE.W  _WDISP_AccumulatorRow1_Value,D2
    CMPI.W  #$4000,D2
    BGE.S   .branch_3

    MOVE.W  D2,_ACCUMULATOR_Row1_CaptureValue
    BRA.S   .branch_4

.branch_3:
    MOVEQ   #0,D2
    MOVE.W  D2,_ACCUMULATOR_Row1_CaptureValue

.branch_4:
    MOVE.B  _WDISP_AccumulatorRow2_CopperIndexStart,D0
    CMP.B   D1,D0
    BCC.S   .branch_5

    MOVE.B  _WDISP_AccumulatorRow2_CopperIndexEnd,D0
    CMP.B   D1,D0
    BCC.S   .branch_5

    MOVE.W  _WDISP_AccumulatorRow2_Value,D0
    CMPI.W  #$4000,D0
    BGE.S   .branch_5

    MOVE.W  D0,_ACCUMULATOR_Row2_CaptureValue
    BRA.S   .branch_6

.branch_5:
    MOVEQ   #0,D0
    MOVE.W  D0,_ACCUMULATOR_Row2_CaptureValue

.branch_6:
    MOVE.B  _WDISP_AccumulatorRow3_CopperIndexStart,D2
    CMP.B   D1,D2
    BCC.S   .branch_7

    MOVE.B  _WDISP_AccumulatorRow3_CopperIndexEnd,D2
    CMP.B   D1,D2
    BCC.S   .branch_7

    MOVE.W  _WDISP_AccumulatorRow3_Value,D1
    CMPI.W  #$4000,D1
    BGE.S   .branch_7

    MOVE.W  D1,_ACCUMULATOR_Row3_CaptureValue
    BRA.S   .branch_8

.branch_7:
    MOVEQ   #0,D1
    MOVE.W  D1,_ACCUMULATOR_Row3_CaptureValue

.branch_8:
    TST.W   _ACCUMULATOR_Row0_CaptureValue
    BNE.S   .branch_9

    TST.W   _ACCUMULATOR_Row1_CaptureValue
    BNE.S   .branch_9

    TST.W   _ACCUMULATOR_Row2_CaptureValue
    BNE.S   .branch_9

    TST.W   D1
    BEQ.S   .branch_10

.branch_9:
    MOVE.W  #1,_WDISP_AccumulatorCaptureActive
    BRA.S   .branch_11

.branch_10:
    MOVEQ   #0,D0
    MOVE.W  D0,_WDISP_AccumulatorCaptureActive

.branch_11:
    MOVEQ   #0,D0
    MOVE.W  D0,_ACCUMULATOR_Row0_Sum
    MOVE.W  D0,_ACCUMULATOR_Row0_SaturateFlag
    MOVE.W  D0,_ACCUMULATOR_Row1_Sum
    MOVE.W  D0,_ACCUMULATOR_Row1_SaturateFlag
    MOVE.W  D0,_ACCUMULATOR_Row2_Sum
    MOVE.W  D0,_ACCUMULATOR_Row2_SaturateFlag
    MOVE.W  D0,_ACCUMULATOR_Row3_Sum
    MOVE.W  D0,_ACCUMULATOR_Row3_SaturateFlag
    BSR.W   _ESQIFF_RunCopperRiseTransition

    BRA.S   ESQIFF_ShowExternalAssetWithCopperFx_Return

.set_missing_asset_pending_flags:
    TST.W   D7
    BEQ.S   .branch_12

    MOVEQ   #1,D0
    BRA.S   .branch_13

.branch_12:
    MOVEQ   #2,D0

.branch_13:
    OR.L    D0,_ESQFUNC_MissingAssetRetryMask

;------------------------------------------------------------------------------
; FUNC: ESQIFF_ShowExternalAssetWithCopperFx_Return   (Return tail for external-asset copper blit)
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
;   Restores registers/frame and returns from external-asset copper blit helper.
; NOTES:
;   Shared return for successful blit and missing-asset fallback paths.
;------------------------------------------------------------------------------
ESQIFF_ShowExternalAssetWithCopperFx_Return:
    MOVEM.L (A7)+,D2/D4-D7
    UNLK    A5
    RTS

;!======