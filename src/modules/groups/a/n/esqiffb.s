    XDEF    ESQIFF_DeallocateAdsAndLogoLstData
    XDEF    ESQIFF_HandleBrushIniReloadHotkey
    XDEF    ESQIFF_PlayNextExternalAssetFrame
    XDEF    ESQIFF_RunCopperDropTransition
    XDEF    ESQIFF_RunCopperRiseTransition
    XDEF    ESQIFF_RunPendingCopperAnimations
    XDEF    ESQIFF_ServiceExternalAssetSourceState
    XDEF    ESQIFF_ServicePendingCopperPaletteMoves
    XDEF    ESQIFF_SetApenToBrightestPaletteIndex
    XDEF    ESQIFF_ShowExternalAssetWithCopperFx
    XDEF    ESQIFF_JMPTBL_BRUSH_AllocBrushNode
    XDEF    ESQIFF_JMPTBL_BRUSH_CloneBrushRecord
    XDEF    ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate
    XDEF    ESQIFF_JMPTBL_BRUSH_FindType3Brush
    XDEF    ESQIFF_JMPTBL_BRUSH_FreeBrushList
    XDEF    ESQIFF_JMPTBL_BRUSH_PopBrushHead
    XDEF    ESQIFF_JMPTBL_BRUSH_PopulateBrushList
    XDEF    ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel
    XDEF    ESQIFF_JMPTBL_BRUSH_SelectBrushSlot
    XDEF    ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess
    XDEF    ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle
    XDEF    ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle
    XDEF    ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle
    XDEF    ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary
    XDEF    ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets
    XDEF    ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd
    XDEF    ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart
    XDEF    ESQIFF_JMPTBL_ESQ_NoOp
    XDEF    ESQIFF_JMPTBL_ESQ_NoOp_006A
    XDEF    ESQIFF_JMPTBL_ESQ_NoOp_0074
    XDEF    ESQIFF_JMPTBL_MATH_DivS32
    XDEF    ESQIFF_JMPTBL_MATH_Mulu32
    XDEF    ESQIFF_JMPTBL_MEMORY_AllocateMemory
    XDEF    ESQIFF_JMPTBL_MEMORY_DeallocateMemory
    XDEF    ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode
    XDEF    ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled
    XDEF    ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition
    XDEF    ESQIFF_JMPTBL_STRING_CompareN
    XDEF    ESQIFF_JMPTBL_STRING_CompareNoCase
    XDEF    ESQIFF_JMPTBL_STRING_CompareNoCaseN
    XDEF    ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner
    XDEF    ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard
    XDEF    ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode
    XDEF    ESQIFF_JMPTBL_DOS_OpenFileWithMode
    XDEF    ESQIFF_PlayNextExternalAssetFrame_Return
    XDEF    ESQIFF_ShowExternalAssetWithCopperFx_Return

;------------------------------------------------------------------------------
; FUNC: ESQIFF_RunCopperRiseTransition   (RunCopperRiseTransition)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQIFF_RunPendingCopperAnimations
; READS:
;   (none observed)
; WRITES:
;   COPPER_AnimationLane3_Countdown
; DESC:
;   Arms copper rise-transition countdown state and runs pending copper animation
;   servicing immediately.
; NOTES:
;   Writes COPPER_AnimationLane3_Countdown = 15 before invoking ESQIFF_RunPendingCopperAnimations.
;------------------------------------------------------------------------------
ESQIFF_RunCopperRiseTransition:
    MOVE.W  #15,COPPER_AnimationLane3_Countdown
    BSR.W   ESQIFF_RunPendingCopperAnimations

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_RunCopperDropTransition   (RunCopperDropTransition)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQIFF_RunPendingCopperAnimations
; READS:
;   (none observed)
; WRITES:
;   COPPER_AnimationLane2_Countdown
; DESC:
;   Arms copper drop-transition countdown state and runs pending copper animation
;   servicing immediately.
; NOTES:
;   Writes COPPER_AnimationLane2_Countdown = 15 before invoking ESQIFF_RunPendingCopperAnimations.
;------------------------------------------------------------------------------
ESQIFF_RunCopperDropTransition:
    MOVE.W  #15,COPPER_AnimationLane2_Countdown
    BSR.W   ESQIFF_RunPendingCopperAnimations

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_ServicePendingCopperPaletteMoves   (Service pending copper index moves for four accumulator rows)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A4/A7/D0/D1
; CALLS:
;   ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd, ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart
; READS:
;   Global_REF_LONG_FILE_SCRATCH, ACCUMULATOR_Row0_SaturateFlag, ACCUMULATOR_Row1_SaturateFlag, ACCUMULATOR_Row2_SaturateFlag, ACCUMULATOR_Row3_SaturateFlag, WDISP_AccumulatorRow0_MoveFlags, WDISP_AccumulatorRow0_CopperIndexStart, WDISP_AccumulatorRow0_CopperIndexEnd, WDISP_AccumulatorRow1_MoveFlags, WDISP_AccumulatorRow1_CopperIndexStart, WDISP_AccumulatorRow1_CopperIndexEnd, WDISP_AccumulatorRow2_MoveFlags, WDISP_AccumulatorRow2_CopperIndexStart, WDISP_AccumulatorRow2_CopperIndexEnd, WDISP_AccumulatorRow3_MoveFlags, WDISP_AccumulatorRow3_CopperIndexStart, WDISP_AccumulatorRow3_CopperIndexEnd
; WRITES:
;   ACCUMULATOR_Row0_SaturateFlag, ACCUMULATOR_Row1_SaturateFlag, ACCUMULATOR_Row2_SaturateFlag, ACCUMULATOR_Row3_SaturateFlag
; DESC:
;   Checks per-row move countdown words and, when armed, steps the configured
;   copper index range toward start or end for rows 0..3.
; NOTES:
;   Uses move-flag bit1 as direction: set=toward end, clear=toward start.
;------------------------------------------------------------------------------
ESQIFF_ServicePendingCopperPaletteMoves:
    MOVE.L  A4,-(A7)
    LEA     Global_REF_LONG_FILE_SCRATCH,A4
    MOVE.W  ACCUMULATOR_Row0_SaturateFlag,D0
    SUBQ.W  #1,D0
    BNE.S   .service_row1_pending_move

    TST.W   WDISP_AccumulatorRow0_MoveFlags
    BEQ.S   .service_row1_pending_move

    CLR.W   ACCUMULATOR_Row0_SaturateFlag
    MOVE.W  WDISP_AccumulatorRow0_MoveFlags,D0
    BTST    #1,D0
    BEQ.S   .move_row0_toward_start

    MOVEQ   #0,D0
    MOVE.B  WDISP_AccumulatorRow0_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_AccumulatorRow0_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(PC)

    ADDQ.W  #8,A7
    BRA.S   .service_row1_pending_move

.move_row0_toward_start:
    MOVEQ   #0,D0
    MOVE.B  WDISP_AccumulatorRow0_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_AccumulatorRow0_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart(PC)

    ADDQ.W  #8,A7

.service_row1_pending_move:
    MOVE.W  ACCUMULATOR_Row1_SaturateFlag,D0
    SUBQ.W  #1,D0
    BNE.S   .service_row2_pending_move

    TST.W   WDISP_AccumulatorRow1_MoveFlags
    BEQ.S   .service_row2_pending_move

    CLR.W   ACCUMULATOR_Row1_SaturateFlag
    MOVE.W  WDISP_AccumulatorRow1_MoveFlags,D0
    BTST    #1,D0
    BEQ.S   .move_row1_toward_start

    MOVEQ   #0,D0
    MOVE.B  WDISP_AccumulatorRow1_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_AccumulatorRow1_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(PC)

    ADDQ.W  #8,A7
    BRA.S   .service_row2_pending_move

.move_row1_toward_start:
    MOVEQ   #0,D0
    MOVE.B  WDISP_AccumulatorRow1_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_AccumulatorRow1_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart(PC)

    ADDQ.W  #8,A7

.service_row2_pending_move:
    MOVE.W  ACCUMULATOR_Row2_SaturateFlag,D0
    SUBQ.W  #1,D0
    BNE.S   .service_row3_pending_move

    TST.W   WDISP_AccumulatorRow2_MoveFlags
    BEQ.S   .service_row3_pending_move

    CLR.W   ACCUMULATOR_Row2_SaturateFlag
    MOVE.W  WDISP_AccumulatorRow2_MoveFlags,D0
    BTST    #1,D0
    BEQ.S   .move_row2_toward_start

    MOVEQ   #0,D0
    MOVE.B  WDISP_AccumulatorRow2_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_AccumulatorRow2_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(PC)

    ADDQ.W  #8,A7
    BRA.S   .service_row3_pending_move

.move_row2_toward_start:
    MOVEQ   #0,D0
    MOVE.B  WDISP_AccumulatorRow2_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_AccumulatorRow2_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart(PC)

    ADDQ.W  #8,A7

.service_row3_pending_move:
    MOVE.W  ACCUMULATOR_Row3_SaturateFlag,D0
    SUBQ.W  #1,D0
    BNE.S   .return_service_pending_copper_moves

    TST.W   WDISP_AccumulatorRow3_MoveFlags
    BEQ.S   .return_service_pending_copper_moves

    CLR.W   ACCUMULATOR_Row3_SaturateFlag
    MOVE.W  WDISP_AccumulatorRow3_MoveFlags,D0
    BTST    #1,D0
    BEQ.S   .move_row3_toward_start

    MOVEQ   #0,D0
    MOVE.B  WDISP_AccumulatorRow3_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_AccumulatorRow3_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(PC)

    ADDQ.W  #8,A7
    BRA.S   .return_service_pending_copper_moves

.move_row3_toward_start:
    MOVEQ   #0,D0
    MOVE.B  WDISP_AccumulatorRow3_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_AccumulatorRow3_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart(PC)

    ADDQ.W  #8,A7

.return_service_pending_copper_moves:
    MOVEA.L (A7)+,A4
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_SetApenToBrightestPaletteIndex   (Set APen to brightest palette triple within active depth)
; ARGS:
;   stack +10: arg_1 (via 14(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D1/D2/D4/D5/D6/D7
; CALLS:
;   _LVOSetAPen
; READS:
;   Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_2, WDISP_DisplayContextBase, _WDISP_PaletteTriplesRBase, WDISP_PaletteTriplesGBase, WDISP_PaletteTriplesBBase, WDISP_PaletteDepthLog2
; WRITES:
;   (none observed)
; DESC:
;   Scans active palette entries, picks the index with highest summed RGB
;   intensity, and applies it to the display-context rastport APen.
; NOTES:
;   Palette scan upper bound is derived from active depth bit (`22AE`).
;------------------------------------------------------------------------------
ESQIFF_SetApenToBrightestPaletteIndex:
    LINK.W  A5,#-16
    MOVEM.L D2/D4-D7,-(A7)
    MOVEQ   #0,D0
    MOVE.B  WDISP_PaletteDepthLog2,D0
    MOVEQ   #1,D1
    ASL.L   D0,D1
    MOVE.L  D1,D4
    MOVEQ   #0,D0
    MOVE.B  _WDISP_PaletteTriplesRBase,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_PaletteTriplesGBase,D1
    ADD.L   D1,D0
    MOVEQ   #0,D1
    MOVE.B  WDISP_PaletteTriplesBBase,D1
    ADD.L   D1,D0
    MOVE.L  D0,D6
    CLR.L   -14(A5)
    MOVEQ   #1,D7

.loop_palette_entries:
    MOVE.L  D7,D0
    EXT.L   D0
    CMP.L   D4,D0
    BGE.S   .apply_best_palette_index

    MOVE.L  D7,D0
    MOVEQ   #3,D1
    MULS    D1,D0
    LEA     _WDISP_PaletteTriplesRBase,A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    MULS    D1,D0
    LEA     WDISP_PaletteTriplesGBase,A1
    ADDA.L  D0,A1
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVEQ   #0,D2
    MOVE.B  (A1),D2
    ADD.L   D2,D0
    MOVE.L  D7,D2
    MULS    D1,D2
    LEA     WDISP_PaletteTriplesBBase,A0
    ADDA.L  D2,A0
    MOVEQ   #0,D1
    MOVE.B  (A0),D1
    ADD.L   D1,D0
    MOVE.L  D0,D5
    CMP.W   D5,D6
    BGE.S   .next_palette_entry

    MOVE.L  D5,D6
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-14(A5)

.next_palette_entry:
    ADDQ.W  #1,D7
    BRA.S   .loop_palette_entries

.apply_best_palette_index:
    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVE.L  -14(A5),D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEM.L (A7)+,D2/D4-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_ShowExternalAssetWithCopperFx   (Blit external asset with copper transition effects)
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
;   ESQIFF_JMPTBL_BRUSH_SelectBrushSlot, ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode, ESQIFF_JMPTBL_MATH_DivS32, ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition, ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex, ESQIFF_RunCopperRiseTransition, ESQIFF_RunCopperDropTransition, _LVOCopyMem, _LVOSetAPen, _LVOSetRast
; READS:
;   AbsExecBase, Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_2, ACCUMULATOR_Row0_CaptureValue, ACCUMULATOR_Row1_CaptureValue, ACCUMULATOR_Row2_CaptureValue, ESQIFF_GAdsBrushListHead, ESQIFF_LogoBrushListHead, SCRIPT_BannerTransitionActive, WDISP_DisplayContextBase, _WDISP_PaletteTriplesRBase, WDISP_AccumulatorRowTable, WDISP_AccumulatorRow0_Value, WDISP_AccumulatorRow0_CopperIndexStart, WDISP_AccumulatorRow0_CopperIndexEnd, WDISP_AccumulatorRow1_Value, WDISP_AccumulatorRow1_CopperIndexStart, WDISP_AccumulatorRow1_CopperIndexEnd, WDISP_AccumulatorRow2_Value, WDISP_AccumulatorRow2_CopperIndexStart, WDISP_AccumulatorRow2_CopperIndexEnd, WDISP_AccumulatorRow3_Value, WDISP_AccumulatorRow3_CopperIndexStart, WDISP_AccumulatorRow3_CopperIndexEnd, e8
; WRITES:
;   ACCUMULATOR_Row0_CaptureValue, ACCUMULATOR_Row1_CaptureValue, ACCUMULATOR_Row2_CaptureValue, ACCUMULATOR_Row3_CaptureValue, ACCUMULATOR_Row0_Sum, ACCUMULATOR_Row1_Sum, ACCUMULATOR_Row2_Sum, ACCUMULATOR_Row3_Sum, ACCUMULATOR_Row0_SaturateFlag, ACCUMULATOR_Row1_SaturateFlag, ACCUMULATOR_Row2_SaturateFlag, ACCUMULATOR_Row3_SaturateFlag, ESQFUNC_MissingAssetRetryMask, WDISP_DisplayContextBase, WDISP_AccumulatorCaptureActive, WDISP_AccumulatorFlushPending
; DESC:
;   Selects source brush list by mode, performs drop/rise copper transitions, builds
;   a display context, blits the external asset, and captures accumulator thresholds
;   used by subsequent copper palette motion.
; NOTES:
;   Missing-asset path sets ESQFUNC_MissingAssetRetryMask bits to request deferred retries.
;------------------------------------------------------------------------------
ESQIFF_ShowExternalAssetWithCopperFx:
    LINK.W  A5,#-36
    MOVEM.L D2/D4-D7,-(A7)
    MOVE.W  10(A5),D7
    TST.W   D7
    BEQ.S   .select_primary_or_secondary_brush_head

    MOVE.L  ESQIFF_GAdsBrushListHead,-22(A5)

.select_primary_or_secondary_brush_head:
    TST.W   D7
    BNE.S   .ensure_brush_head_available

    MOVEA.L ESQIFF_LogoBrushListHead,A0
    MOVE.L  A0,-22(A5)

.ensure_brush_head_available:
    TST.L   -22(A5)
    BEQ.W   .set_missing_asset_pending_flags

    BSR.W   ESQIFF_RunCopperDropTransition

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
    JSR     ESQIFF_JMPTBL_MATH_DivS32(PC)

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
    JSR     ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition(PC)

    ADDQ.W  #8,A7

.wait_banner_transition_idle:
    TST.W   SCRIPT_BannerTransitionActive
    BNE.S   .wait_banner_transition_idle

    MOVE.W  #1,WDISP_AccumulatorCaptureActive
    CLR.W   WDISP_AccumulatorFlushPending
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
    LEA     WDISP_AccumulatorRowTable,A0
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
    CLR.W   WDISP_AccumulatorCaptureActive
    MOVE.W  #1,WDISP_AccumulatorFlushPending
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
    JSR     ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     12(A7),A7
    MOVE.L  D0,WDISP_DisplayContextBase
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
    JSR     ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     12(A7),A7
    MOVE.L  D0,WDISP_DisplayContextBase
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
    JSR     ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     12(A7),A7
    MOVE.L  D0,WDISP_DisplayContextBase
    MOVEQ   #20,D4
    BRA.S   .clear_rast_and_blit_asset

.select_mode_fallback:
    MOVEQ   #0,D0
    MOVE.B  184(A0),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    PEA     7.W
    JSR     ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     12(A7),A7
    MOVE.L  D0,WDISP_DisplayContextBase
    MOVEQ   #10,D4

.clear_rast_and_blit_asset:
    MOVEA.L D0,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVEQ   #7,D0
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVEA.L WDISP_DisplayContextBase,A0
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
    JSR     ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(PC)

    LEA     28(A7),A7
    MOVEA.L -22(A5),A0
    TST.L   328(A0)
    BEQ.S   .refresh_palette_triples_from_asset

    MOVEQ   #1,D0
    CMP.L   328(A0),D0
    BNE.S   .capture_accumulator_thresholds

.refresh_palette_triples_from_asset:
    PEA     5.W
    JSR     ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    MOVEQ   #0,D0
    MOVEA.L -22(A5),A0
    MOVE.B  184(A0),D0
    MOVE.L  D0,(A7)
    MOVE.L  D1,-14(A5)
    JSR     ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

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
    MOVE.B  WDISP_AccumulatorRow0_CopperIndexStart,D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BCC.S   .branch_1

    MOVE.B  WDISP_AccumulatorRow0_CopperIndexEnd,D0
    CMP.B   D1,D0
    BCC.S   .branch_1

    MOVE.W  WDISP_AccumulatorRow0_Value,D0
    CMPI.W  #$4000,D0
    BGE.S   .branch_1

    MOVE.W  D0,ACCUMULATOR_Row0_CaptureValue
    BRA.S   .branch_2

.branch_1:
    MOVEQ   #0,D0
    MOVE.W  D0,ACCUMULATOR_Row0_CaptureValue

.branch_2:
    MOVE.B  WDISP_AccumulatorRow1_CopperIndexStart,D2
    CMP.B   D1,D2
    BCC.S   .branch_3

    MOVE.B  WDISP_AccumulatorRow1_CopperIndexEnd,D2
    CMP.B   D1,D2
    BCC.S   .branch_3

    MOVE.W  WDISP_AccumulatorRow1_Value,D2
    CMPI.W  #$4000,D2
    BGE.S   .branch_3

    MOVE.W  D2,ACCUMULATOR_Row1_CaptureValue
    BRA.S   .branch_4

.branch_3:
    MOVEQ   #0,D2
    MOVE.W  D2,ACCUMULATOR_Row1_CaptureValue

.branch_4:
    MOVE.B  WDISP_AccumulatorRow2_CopperIndexStart,D0
    CMP.B   D1,D0
    BCC.S   .branch_5

    MOVE.B  WDISP_AccumulatorRow2_CopperIndexEnd,D0
    CMP.B   D1,D0
    BCC.S   .branch_5

    MOVE.W  WDISP_AccumulatorRow2_Value,D0
    CMPI.W  #$4000,D0
    BGE.S   .branch_5

    MOVE.W  D0,ACCUMULATOR_Row2_CaptureValue
    BRA.S   .branch_6

.branch_5:
    MOVEQ   #0,D0
    MOVE.W  D0,ACCUMULATOR_Row2_CaptureValue

.branch_6:
    MOVE.B  WDISP_AccumulatorRow3_CopperIndexStart,D2
    CMP.B   D1,D2
    BCC.S   .branch_7

    MOVE.B  WDISP_AccumulatorRow3_CopperIndexEnd,D2
    CMP.B   D1,D2
    BCC.S   .branch_7

    MOVE.W  WDISP_AccumulatorRow3_Value,D1
    CMPI.W  #$4000,D1
    BGE.S   .branch_7

    MOVE.W  D1,ACCUMULATOR_Row3_CaptureValue
    BRA.S   .branch_8

.branch_7:
    MOVEQ   #0,D1
    MOVE.W  D1,ACCUMULATOR_Row3_CaptureValue

.branch_8:
    TST.W   ACCUMULATOR_Row0_CaptureValue
    BNE.S   .branch_9

    TST.W   ACCUMULATOR_Row1_CaptureValue
    BNE.S   .branch_9

    TST.W   ACCUMULATOR_Row2_CaptureValue
    BNE.S   .branch_9

    TST.W   D1
    BEQ.S   .branch_10

.branch_9:
    MOVE.W  #1,WDISP_AccumulatorCaptureActive
    BRA.S   .branch_11

.branch_10:
    MOVEQ   #0,D0
    MOVE.W  D0,WDISP_AccumulatorCaptureActive

.branch_11:
    MOVEQ   #0,D0
    MOVE.W  D0,ACCUMULATOR_Row0_Sum
    MOVE.W  D0,ACCUMULATOR_Row0_SaturateFlag
    MOVE.W  D0,ACCUMULATOR_Row1_Sum
    MOVE.W  D0,ACCUMULATOR_Row1_SaturateFlag
    MOVE.W  D0,ACCUMULATOR_Row2_Sum
    MOVE.W  D0,ACCUMULATOR_Row2_SaturateFlag
    MOVE.W  D0,ACCUMULATOR_Row3_Sum
    MOVE.W  D0,ACCUMULATOR_Row3_SaturateFlag
    BSR.W   ESQIFF_RunCopperRiseTransition

    BRA.S   ESQIFF_ShowExternalAssetWithCopperFx_Return

.set_missing_asset_pending_flags:
    TST.W   D7
    BEQ.S   .branch_12

    MOVEQ   #1,D0
    BRA.S   .branch_13

.branch_12:
    MOVEQ   #2,D0

.branch_13:
    OR.L    D0,ESQFUNC_MissingAssetRetryMask

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

;------------------------------------------------------------------------------
; FUNC: ESQIFF_ServiceExternalAssetSourceState   (Service external-asset source select and queue state)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1/D7
; CALLS:
;   ESQDISP_ProcessGridMessagesIfIdle, ESQIFF_ReloadExternalAssetCatalogBuffers, ESQIFF_QueueNextExternalAssetIffJob
; READS:
;   Global_WORD_SELECT_CODE_IS_RAVESC, COI_AttentionOverlayBusyFlag, ESQIFF_ExternalAssetFlags, DISKIO_Drive0WriteProtectedCode, DISKIO_DriveWriteProtectStatusCodeDrive1
; WRITES:
;   ESQIFF_AssetSourceSelect, ESQIFF_GAdsSourceEnabled
; DESC:
;   Sets source-selection flags by mode, conditionally reloads external catalogs,
;   then queues the next external asset IFF job.
; NOTES:
;   Skips reload/queue work during RAVESC select mode or COI busy gate.
;------------------------------------------------------------------------------
ESQIFF_ServiceExternalAssetSourceState:
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7
    TST.W   Global_WORD_SELECT_CODE_IS_RAVESC
    BNE.S   .return

    JSR     ESQDISP_ProcessGridMessagesIfIdle(PC)

    TST.W   COI_AttentionOverlayBusyFlag
    BNE.S   .return

    TST.W   D7
    BEQ.S   .configure_source_for_secondary_mode

    MOVEQ   #0,D0
    MOVE.W  D0,ESQIFF_AssetSourceSelect
    MOVEQ   #-1,D1
    MOVE.W  D1,ESQIFF_GAdsSourceEnabled
    BRA.S   .reload_logo_catalog_if_needed

.configure_source_for_secondary_mode:
    CLR.W   ESQIFF_GAdsSourceEnabled
    MOVE.W  #(-1),ESQIFF_AssetSourceSelect

.reload_logo_catalog_if_needed:
    TST.L   DISKIO_Drive0WriteProtectedCode
    BNE.S   .reload_gads_catalog_if_needed

    MOVE.W  ESQIFF_ExternalAssetFlags,D0
    ANDI.W  #2,D0
    SUBQ.W  #2,D0
    BEQ.S   .reload_gads_catalog_if_needed

    CLR.L   -(A7)
    BSR.W   ESQIFF_ReloadExternalAssetCatalogBuffers

    ADDQ.W  #4,A7

.reload_gads_catalog_if_needed:
    TST.L   DISKIO_DriveWriteProtectStatusCodeDrive1
    BNE.S   .queue_next_asset_after_reload_checks

    MOVE.W  ESQIFF_ExternalAssetFlags,D0
    ANDI.W  #1,D0
    SUBQ.W  #1,D0
    BEQ.S   .queue_next_asset_after_reload_checks

    PEA     1.W
    BSR.W   ESQIFF_ReloadExternalAssetCatalogBuffers

    ADDQ.W  #4,A7

.queue_next_asset_after_reload_checks:
    JSR     ESQDISP_ProcessGridMessagesIfIdle(PC)

    BSR.W   ESQIFF_QueueNextExternalAssetIffJob

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_PlayNextExternalAssetFrame   (Render and retire next external asset frame)
; ARGS:
;   stack +6: arg_1 (via 10(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D1/D6/D7
; CALLS:
;   ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode, ESQIFF_JMPTBL_BRUSH_PopBrushHead, ESQIFF_JMPTBL_ESQ_NoOp, ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode, ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled, ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner, GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight, ESQDISP_ProcessGridMessagesIfIdle, _ESQIFF_RestoreBasePaletteTriples, ESQIFF_RunCopperRiseTransition, ESQIFF_RunCopperDropTransition, ESQIFF_SetApenToBrightestPaletteIndex, ESQIFF_ShowExternalAssetWithCopperFx, ESQIFF_ServiceExternalAssetSourceState, _LVOForbid, _LVOPermit, _LVOSetAPen, _LVOSetDrMd, _LVOSetRast
; READS:
;   AbsExecBase, Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_2, TEXTDISP_DeferredActionCountdown, ESQIFF_GAdsBrushListHead, ESQIFF_LogoBrushListHead, WDISP_DisplayContextBase, TEXTDISP_PrimaryGroupEntryCount, WDISP_AccumulatorCaptureActive, ESQIFF_ExternalAssetStateTable, ESQIFF_ExternalAssetPathCommaFlag
; WRITES:
;   ESQIFF_GAdsBrushListCount, ESQIFF_LogoBrushListCount, ESQIFF_GAdsBrushListHead, ESQIFF_LogoBrushListHead, WDISP_DisplayContextBase, WDISP_AccumulatorCaptureActive, _TEXTDISP_CurrentMatchIndex
; DESC:
;   Chooses source brush head, renders one frame with copper/display setup, pops the
;   consumed brush node from the active list, then services source-state queueing.
; NOTES:
;   Mode 0 path may redraw channel banner using stored match index snapshot.
;------------------------------------------------------------------------------
ESQIFF_PlayNextExternalAssetFrame:
    LINK.W  A5,#-8
    MOVEM.L D6-D7,-(A7)
    MOVE.W  10(A5),D7
    BSR.W   ESQIFF_RunCopperDropTransition

    TST.W   D7
    BEQ.S   .check_logo_head_fallback

    TST.L   ESQIFF_GAdsBrushListHead
    BNE.S   .validate_asset_list_and_match_index

.check_logo_head_fallback:
    TST.W   D7
    BNE.W   .fallback_restore_base_palette

    TST.L   ESQIFF_LogoBrushListHead
    BEQ.W   .fallback_restore_base_palette

.validate_asset_list_and_match_index:
    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    MOVE.W  ESQIFF_ExternalAssetStateTable,D1
    CMP.W   D1,D0
    BCC.S   .prepare_display_context_for_asset_blit

    TST.W   D7
    BNE.S   .prepare_display_context_for_asset_blit

    TST.W   ESQIFF_ExternalAssetPathCommaFlag
    BNE.S   .prepare_display_context_for_asset_blit

    BSR.W   _ESQIFF_RestoreBasePaletteTriples

    JSR     GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    PEA     2.W
    JSR     ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(PC)

    ADDQ.W  #4,A7
    BRA.W   .run_rise_transition_and_service_source

.prepare_display_context_for_asset_blit:
    JSR     GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    PEA     1.W
    CLR.L   -(A7)
    PEA     4.W
    JSR     ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(PC)

    MOVE.L  D0,WDISP_DisplayContextBase
    MOVEA.L D0,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    JSR     ESQDISP_ProcessGridMessagesIfIdle(PC)

    LEA     12(A7),A7
    TST.W   D7
    BEQ.S   .select_logo_head_for_blit

    MOVEA.L ESQIFF_GAdsBrushListHead,A0
    BRA.S   .run_asset_frame_side_effects

.select_logo_head_for_blit:
    MOVEA.L ESQIFF_LogoBrushListHead,A0

.run_asset_frame_side_effects:
    MOVE.L  A0,-6(A5)
    JSR     ESQIFF_JMPTBL_ESQ_NoOp(PC)

    MOVEQ   #1,D0
    CMP.W   D0,D7
    BNE.S   .render_selected_asset_frame

    MOVE.W  TEXTDISP_DeferredActionCountdown,D0
    SUBQ.W  #2,D0
    BEQ.S   .assert_ctrl_line_for_deferred_tick

    MOVE.W  TEXTDISP_DeferredActionCountdown,D0
    SUBQ.W  #3,D0
    BNE.S   .render_selected_asset_frame

.assert_ctrl_line_for_deferred_tick:
    JSR     ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled(PC)

.render_selected_asset_frame:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   ESQIFF_ShowExternalAssetWithCopperFx

    ADDQ.W  #4,A7
    TST.W   D7
    BNE.S   .pop_rendered_asset_head

    TST.W   ESQIFF_ExternalAssetPathCommaFlag
    BNE.S   .pop_rendered_asset_head

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    BSR.W   ESQIFF_SetApenToBrightestPaletteIndex

    MOVE.W  ESQIFF_ExternalAssetStateTable,_TEXTDISP_CurrentMatchIndex
    PEA     2.W
    PEA     1.W
    JSR     ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner(PC)

    ADDQ.W  #8,A7
    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

.pop_rendered_asset_head:
    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    TST.W   D7
    BEQ.S   .pop_logo_brush_head

    SUBQ.L  #1,ESQIFF_GAdsBrushListCount
    MOVE.L  ESQIFF_GAdsBrushListHead,-(A7)
    JSR     ESQIFF_JMPTBL_BRUSH_PopBrushHead(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,ESQIFF_GAdsBrushListHead
    BRA.S   .permit_after_pop

.pop_logo_brush_head:
    SUBQ.L  #1,ESQIFF_LogoBrushListCount
    MOVE.L  ESQIFF_LogoBrushListHead,-(A7)
    JSR     ESQIFF_JMPTBL_BRUSH_PopBrushHead(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,ESQIFF_LogoBrushListHead

.permit_after_pop:
    MOVEA.L AbsExecBase,A6
    JSR     _LVOPermit(A6)

    BRA.S   .run_rise_transition_and_service_source

.fallback_restore_base_palette:
    BSR.W   _ESQIFF_RestoreBasePaletteTriples

    JSR     GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    PEA     2.W
    JSR     ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(PC)

    ADDQ.W  #4,A7

.run_rise_transition_and_service_source:
    MOVE.W  WDISP_AccumulatorCaptureActive,D6
    CLR.W   WDISP_AccumulatorCaptureActive
    BSR.W   ESQIFF_RunCopperRiseTransition

    MOVE.W  D6,WDISP_AccumulatorCaptureActive
    TST.W   D7
    BEQ.S   .service_source_mode_zero

    PEA     1.W
    BSR.W   ESQIFF_ServiceExternalAssetSourceState

    ADDQ.W  #4,A7
    BRA.S   ESQIFF_PlayNextExternalAssetFrame_Return

.service_source_mode_zero:
    CLR.L   -(A7)
    BSR.W   ESQIFF_ServiceExternalAssetSourceState

    ADDQ.W  #4,A7

;------------------------------------------------------------------------------
; FUNC: ESQIFF_PlayNextExternalAssetFrame_Return   (Return tail for external asset frame player)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D6
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Restores saved registers/frame and returns from frame-player helper.
; NOTES:
;   Shared return for both render and fallback/no-asset paths.
;------------------------------------------------------------------------------
ESQIFF_PlayNextExternalAssetFrame_Return:
    MOVEM.L (A7)+,D6-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_DeallocateAdsAndLogoLstData   (Free loaded external catalog blobs)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0
; CALLS:
;   ESQIFF_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   Global_REF_LONG_DF0_LOGO_LST_DATA, Global_REF_LONG_DF0_LOGO_LST_FILESIZE, Global_REF_LONG_GFX_G_ADS_DATA, Global_REF_LONG_GFX_G_ADS_FILESIZE, Global_STR_ESQIFF_C_7, Global_STR_ESQIFF_C_8
; WRITES:
;   Global_REF_LONG_DF0_LOGO_LST_DATA, Global_REF_LONG_DF0_LOGO_LST_FILESIZE, Global_REF_LONG_GFX_G_ADS_DATA, Global_REF_LONG_GFX_G_ADS_FILESIZE
; DESC:
;   Frees loaded `gfx/g_ads.data` and `df0:logo.lst` memory buffers when both
;   pointer and filesize are non-zero, then clears their globals.
; NOTES:
;   Passes `(size+1)` to deallocator, matching allocation strategy.
;------------------------------------------------------------------------------
ESQIFF_DeallocateAdsAndLogoLstData:
    TST.L   Global_REF_LONG_GFX_G_ADS_DATA
    BEQ.S   .deallocLogoLstData

    TST.L   Global_REF_LONG_GFX_G_ADS_FILESIZE
    BEQ.S   .deallocLogoLstData

    MOVE.L  Global_REF_LONG_GFX_G_ADS_FILESIZE,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  Global_REF_LONG_GFX_G_ADS_DATA,-(A7)
    PEA     1988.W
    PEA     Global_STR_ESQIFF_C_7
    JSR     ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    CLR.L   Global_REF_LONG_GFX_G_ADS_DATA
    CLR.L   Global_REF_LONG_GFX_G_ADS_FILESIZE

.deallocLogoLstData:
    TST.L   Global_REF_LONG_DF0_LOGO_LST_DATA
    BEQ.S   .return

    TST.L   Global_REF_LONG_DF0_LOGO_LST_FILESIZE
    BEQ.S   .return

    MOVE.L  Global_REF_LONG_DF0_LOGO_LST_FILESIZE,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  Global_REF_LONG_DF0_LOGO_LST_DATA,-(A7)
    PEA     1994.W
    PEA     Global_STR_ESQIFF_C_8
    JSR     ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    CLR.L   Global_REF_LONG_DF0_LOGO_LST_DATA
    CLR.L   Global_REF_LONG_DF0_LOGO_LST_FILESIZE

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_RunPendingCopperAnimations   (Service all active copper animation countdown lanes)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D1
; CALLS:
;   ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary, ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets, ESQIFF_JMPTBL_ESQ_NoOp_006A, ESQIFF_JMPTBL_ESQ_NoOp_0074
; READS:
;   COPPER_AnimationLane0_Countdown, COPPER_AnimationLane1_Countdown, COPPER_AnimationLane2_Countdown, COPPER_AnimationLane3_Countdown
; WRITES:
;   COPPER_AnimationLane0_Countdown, COPPER_AnimationLane1_Countdown, COPPER_AnimationLane2_Countdown, COPPER_AnimationLane3_Countdown
; DESC:
;   Services four countdown lanes in sequence, invoking the corresponding copper
;   helper while each lane is non-zero and decrementing per step.
; NOTES:
;   Loops until all lanes (`1B19..1B1C`) reach zero.
;------------------------------------------------------------------------------
ESQIFF_RunPendingCopperAnimations:
    MOVE.W  COPPER_AnimationLane0_Countdown,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .service_lane_1b1a

    JSR     ESQIFF_JMPTBL_ESQ_NoOp_006A(PC)

    MOVE.W  COPPER_AnimationLane0_Countdown,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,COPPER_AnimationLane0_Countdown
    BRA.S   ESQIFF_RunPendingCopperAnimations

.service_lane_1b1a:
    MOVE.W  COPPER_AnimationLane1_Countdown,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .service_lane_1b1b

    JSR     ESQIFF_JMPTBL_ESQ_NoOp_0074(PC)

    MOVE.W  COPPER_AnimationLane1_Countdown,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,COPPER_AnimationLane1_Countdown
    BRA.S   .service_lane_1b1a

.service_lane_1b1b:
    MOVE.W  COPPER_AnimationLane2_Countdown,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .service_lane_1b1c

    JSR     ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary(PC)

    MOVE.W  COPPER_AnimationLane2_Countdown,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,COPPER_AnimationLane2_Countdown
    BRA.S   .service_lane_1b1b

.service_lane_1b1c:
    MOVE.W  COPPER_AnimationLane3_Countdown,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .return_run_pending_copper_animations

    JSR     ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets(PC)

    MOVE.W  COPPER_AnimationLane3_Countdown,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,COPPER_AnimationLane3_Countdown
    BRA.S   .service_lane_1b1c

.return_run_pending_copper_animations:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_HandleBrushIniReloadHotkey   (Handle brush.ini reload hotkey and refresh brush lists)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D7
; CALLS:
;   ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate, ESQIFF_JMPTBL_BRUSH_FindType3Brush, ESQIFF_JMPTBL_BRUSH_FreeBrushList, ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel, ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle, ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle, GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch, GROUP_AU_JMPTBL_BRUSH_PopulateBrushList
; READS:
;   BRUSH_SelectedNode, Global_STR_DF0_BRUSH_INI_2, PARSEINI_ParsedDescriptorListHead, ESQIFF_BrushIniListHead, ESQIFF_TAG_DT, ESQIFF_TAG_DITHER
; WRITES:
;   BRUSH_SelectedNode, ESQFUNC_FallbackType3BrushNode
; DESC:
;   On hotkey `'a'`, refreshes brush.ini data, rebuilds brush lists, selects
;   preferred brush tags, and updates cached type-3 brush pointer.
; NOTES:
;   Calls disk refresh/reset helpers before and after parse/rebuild sequence.
;------------------------------------------------------------------------------
ESQIFF_HandleBrushIniReloadHotkey:
    MOVE.L  D7,-(A7)

    MOVE.B  11(A7),D7
    MOVEQ   #97,D0
    CMP.B   D0,D7
    BNE.S   .return

    JSR     ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle(PC)

    CLR.L   -(A7)
    PEA     ESQIFF_BrushIniListHead
    JSR     ESQIFF_JMPTBL_BRUSH_FreeBrushList(PC)

    PEA     Global_STR_DF0_BRUSH_INI_2
    JSR     GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(PC)

    PEA     ESQIFF_BrushIniListHead
    MOVE.L  PARSEINI_ParsedDescriptorListHead,-(A7)
    JSR     GROUP_AU_JMPTBL_BRUSH_PopulateBrushList(PC)

    PEA     ESQIFF_TAG_DT
    JSR     ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel(PC)

    LEA     24(A7),A7
    TST.L   BRUSH_SelectedNode
    BNE.S   .ensure_type3_brush_cache

    PEA     ESQIFF_BrushIniListHead
    PEA     ESQIFF_TAG_DITHER
    JSR     ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,BRUSH_SelectedNode

.ensure_type3_brush_cache:
    PEA     ESQIFF_BrushIniListHead
    JSR     ESQIFF_JMPTBL_BRUSH_FindType3Brush(PC)

    MOVE.L  D0,ESQFUNC_FallbackType3BrushNode
    JSR     ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle(PC)

    ADDQ.W  #4,A7

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

    ; Alignment bytes
    DC.W    $0000

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_STRING_CompareNoCase   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STRING_CompareNoCase
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_STRING_CompareNoCase:
    JMP     STRING_CompareNoCase

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   TLIBA3_BuildDisplayContextForViewMode
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode:
    JMP     TLIBA3_BuildDisplayContextForViewMode

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DISKIO_GetFilesizeFromHandle
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle:
    JMP     DISKIO_GetFilesizeFromHandle

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_MATH_DivS32   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   MATH_DivS32
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_MATH_DivS32:
    JMP     MATH_DivS32

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   TEXTDISP_FindEntryIndexByWildcard
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard:
    JMP     TEXTDISP_FindEntryIndexByWildcard

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_STRING_CompareN   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STRING_CompareN
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_STRING_CompareN:
    JMP     STRING_CompareN

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_ESQ_NoOp   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_NoOp
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_ESQ_NoOp:
    JMP     ESQ_NoOp

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   TEXTDISP_DrawChannelBanner
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner:
    JMP     TEXTDISP_DrawChannelBanner

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_MoveCopperEntryTowardStart
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart:
    JMP     ESQ_MoveCopperEntryTowardStart

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_MEMORY_DeallocateMemory   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   MEMORY_DeallocateMemory
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_MEMORY_DeallocateMemory:
    JMP     MEMORY_DeallocateMemory

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DISKIO_ForceUiRefreshIfIdle
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle:
    JMP     DISKIO_ForceUiRefreshIfIdle

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_CloneBrushRecord   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_CloneBrushRecord
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_CloneBrushRecord:
    JMP     BRUSH_CloneBrushRecord

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_MoveCopperEntryTowardEnd
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd:
    JMP     ESQ_MoveCopperEntryTowardEnd

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_FindBrushByPredicate
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate:
    JMP     BRUSH_FindBrushByPredicate

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_FreeBrushList   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_FreeBrushList
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_FreeBrushList:
    JMP     BRUSH_FreeBrushList

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_FindType3Brush   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_FindType3Brush
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_FindType3Brush:
    JMP     BRUSH_FindType3Brush

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_PopBrushHead   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_PopBrushHead
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_PopBrushHead:
    JMP     BRUSH_PopBrushHead

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_AllocBrushNode   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_AllocBrushNode
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_AllocBrushNode:
    JMP     BRUSH_AllocBrushNode

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_ESQ_NoOp_006A   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_NoOp_006A
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_ESQ_NoOp_006A:
    JMP     ESQ_NoOp_006A

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   NEWGRID_ValidateSelectionCode
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode:
    JMP     NEWGRID_ValidateSelectionCode

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_PopulateBrushList   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_PopulateBrushList
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_PopulateBrushList:
    JMP     BRUSH_PopulateBrushList

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_ESQ_NoOp_0074   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_NoOp_0074
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_ESQ_NoOp_0074:
    JMP     ESQ_NoOp_0074

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_STRING_CompareNoCaseN   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STRING_CompareNoCaseN
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_STRING_CompareNoCaseN:
    JMP     STRING_CompareNoCaseN

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   SCRIPT_AssertCtrlLineIfEnabled
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled:
    JMP     SCRIPT_AssertCtrlLineIfEnabled

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   SCRIPT_BeginBannerCharTransition
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition:
    JMP     SCRIPT_BeginBannerCharTransition

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_MEMORY_AllocateMemory   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   MEMORY_AllocateMemory
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_MEMORY_AllocateMemory:
    JMP     MEMORY_AllocateMemory

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   CTASKS_StartIffTaskProcess
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess:
    JMP     CTASKS_StartIffTaskProcess

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_DOS_OpenFileWithMode   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DOS_OpenFileWithMode
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_DOS_OpenFileWithMode:
    JMP     DOS_OpenFileWithMode

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_IncCopperListsTowardsTargets
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets:
    JMP     ESQ_IncCopperListsTowardsTargets

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_DecCopperListsPrimary
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary:
    JMP     ESQ_DecCopperListsPrimary

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_SelectBrushSlot   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_SelectBrushSlot
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_SelectBrushSlot:
    JMP     BRUSH_SelectBrushSlot

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   BRUSH_SelectBrushByLabel
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel:
    JMP     BRUSH_SelectBrushByLabel

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_MATH_Mulu32   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   MATH_Mulu32
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_MATH_Mulu32:
    JMP     MATH_Mulu32

;------------------------------------------------------------------------------
; FUNC: ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DISKIO_ResetCtrlInputStateIfIdle
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle:
    JMP     DISKIO_ResetCtrlInputStateIfIdle
