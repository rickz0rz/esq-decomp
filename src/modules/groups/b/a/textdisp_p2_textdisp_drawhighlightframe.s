    XDEF    _TEXTDISP_DrawHighlightFrame


;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_DrawHighlightFrame   (Draw highlight overlay)
; ARGS:
;   stack +8: entryPtr (A3)
; RET:
;   none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _TLIBA3_ClearViewModeRastPort, _TLIBA3_BuildDisplayContextForViewMode, _ESQ_SetCopperEffect_OnEnableHighlight,
;   _WDISP_JMPTBL_ESQIFF_RunCopperDropTransition/0A45, _MATH_Mulu32, _MATH_DivS32,
;   _SCRIPT_BeginBannerCharTransition, _TLIBA1_DrawFormattedTextBlock, _TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition, _TEXTDISP_ResetSelectionState
; READS:
;   entry+220, _CONFIG_LRBN_FlagChar, _TEXTDISP_EntryTextBaseWidthPx
; WRITES:
;   _WDISP_DisplayContextBase, _WDISP_AccumulatorCaptureActive/_WDISP_AccumulatorFlushPending, _TEXTDISP_LinePenOverrideEnabledFlag
; DESC:
;   Enables the highlight copper effect, computes bounds, and draws the frame.
; NOTES:
;   Uses banner transitions when in certain region modes.
;------------------------------------------------------------------------------
_TEXTDISP_DrawHighlightFrame:
    LINK.W  A5,#-32
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  A3,D0
    BEQ.W   .return

    TST.B   220(A3)
    BEQ.W   .return

    CLR.L   -(A7)
    PEA     8.W
    JSR     _TLIBA3_ClearViewModeRastPort(PC)

    PEA     3.W
    CLR.L   -(A7)
    PEA     8.W
    JSR     _TLIBA3_BuildDisplayContextForViewMode(PC)

    MOVE.L  D0,_WDISP_DisplayContextBase
    JSR     _WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D0
    MOVEA.L _WDISP_DisplayContextBase,A0
    MOVE.W  4(A0),D0
    MOVEQ   #-22,D1
    ADD.L   _TEXTDISP_EntryTextBaseWidthPx,D1
    MOVE.W  (A0),D2
    MOVE.L  D0,-22(A5)
    MOVE.L  D1,-26(A5)
    BTST    #2,D2
    BEQ.S   .select_grid_cols

    MOVEQ   #2,D0
    BRA.S   .calc_grid_width

.select_grid_cols:
    MOVEQ   #1,D0

.calc_grid_width:
    JSR     _MATH_Mulu32(PC)

    MOVE.L  D0,-26(A5)
    MOVE.L  -22(A5),D1
    CMP.L   D0,D1
    BLT.S   .clamp_width

    MOVE.L  D0,D1

.clamp_width:
    MOVEQ   #0,D0
    MOVE.W  2(A0),D0
    MOVE.W  #1,_WDISP_AccumulatorCaptureActive
    CLR.W   _WDISP_AccumulatorFlushPending
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVE.L  D0,-18(A5)
    MOVE.L  D1,-22(A5)
    MOVE.L  A0,-4(A5)
    JSR     _WDISP_JMPTBL_ESQIFF_RunCopperDropTransition(PC)

    JSR     _WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples(PC)

    MOVE.B  _CONFIG_LRBN_FlagChar,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .after_banner

    MOVEA.L _WDISP_DisplayContextBase,A0
    MOVE.W  (A0),D0
    BTST    #2,D0
    BEQ.S   .use_cols_2

    MOVEQ   #2,D0
    BRA.S   .after_cols

.use_cols_2:
    MOVEQ   #1,D0

.after_cols:
    MOVE.L  D0,28(A7)
    MOVE.L  -22(A5),D0
    MOVE.L  28(A7),D1
    JSR     _MATH_DivS32(PC)

    MOVE.L  D0,D7
    ADDI.W  #22,D7
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     500.W
    MOVE.L  D0,-(A7)
    JSR     _SCRIPT_BeginBannerCharTransition(PC)

    ADDQ.W  #8,A7

.after_banner:
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     3.W
    JSR     _TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     12(A7),A7
    MOVE.L  D0,_WDISP_DisplayContextBase
    MOVE.L  #$fffffee4,D0
    ADD.L   -18(A5),D0
    TST.L   D0
    BPL.S   .calc_rect

    ADDQ.L  #1,D0

.calc_rect:
    ASR.L   #1,D0
    MOVE.L  D0,D6
    MOVEQ   #0,D4
    MOVE.L  D6,D5
    ADDI.W  #$11b,D5
    MOVE.L  -22(A5),D0
    SUBQ.L  #1,D0
    MOVE.W  D0,-14(A5)
    MOVEA.L -4(A5),A1
    MOVEQ   #0,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVE.W  #1,_TEXTDISP_LinePenOverrideEnabledFlag
    LEA     220(A3),A0
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D4,D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    MOVE.W  -14(A5),D3
    EXT.L   D3
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     _TLIBA1_DrawFormattedTextBlock(PC)

    PEA     3.W
    CLR.L   -(A7)
    PEA     8.W
    JSR     _TLIBA3_BuildDisplayContextForViewMode(PC)

    MOVE.L  D0,_WDISP_DisplayContextBase
    JSR     _TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition(PC)

    MOVE.L  A3,(A7)
    BSR.W   _TEXTDISP_ResetSelectionState

    LEA     36(A7),A7

.return:
    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======