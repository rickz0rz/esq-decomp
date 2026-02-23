    XDEF    SCRIPT_DrawInsetTextWithFrame
    XDEF    SCRIPT_GetBannerCharOrFallback
    XDEF    SCRIPT_ResetBannerCharDefaults
    XDEF    SCRIPT_SetupHighlightEffect

;------------------------------------------------------------------------------
; FUNC: SCRIPT_ResetBannerCharDefaults   (ResetBannerCharDefaultsuncertain)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   TEXTDISP_BannerCharSelected, TEXTDISP_BannerCharFallback, TEXTDISP_CurrentMatchIndex
; DESC:
;   Resets banner-char defaults and clears the cached value.
; NOTES:
;   Values are hard-coded ($64, $31, -1) pending further context.
;------------------------------------------------------------------------------
SCRIPT_ResetBannerCharDefaults:
    MOVE.B  #$64,TEXTDISP_BannerCharSelected
    MOVE.B  #$31,TEXTDISP_BannerCharFallback
    MOVE.W  #(-1),TEXTDISP_CurrentMatchIndex
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_GetBannerCharOrFallback   (GetBannerCharOrFallbackuncertain)
; ARGS:
;   (none)
; RET:
;   D0: banner char value
; CLOBBERS:
;   D0-D1/D7
; CALLS:
;   (none)
; READS:
;   TEXTDISP_BannerCharSelected, TEXTDISP_BannerCharFallback
; WRITES:
;   (none)
; DESC:
;   Returns TEXTDISP_BannerCharSelected unless it is 100, in which case returns TEXTDISP_BannerCharFallback.
; NOTES:
;   Likely selects a fallback character when a sentinel is present.
;------------------------------------------------------------------------------
SCRIPT_GetBannerCharOrFallback:
    MOVE.L  D7,-(A7)
    MOVE.B  TEXTDISP_BannerCharSelected,D0
    MOVEQ   #100,D1
    CMP.B   D1,D0
    BEQ.S   .return_fallback

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .return

.return_fallback:
    MOVEQ   #0,D0
    MOVE.B  TEXTDISP_BannerCharFallback,D0
    MOVE.L  D0,D1

.return:
    MOVE.L  D1,D7
    MOVE.L  D7,D0
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_DrawInsetTextWithFrame   (DrawInsetTextWithFrameuncertain)
; ARGS:
;   (none observed)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _LVOTextLength, _LVOText, _LVOSetAPen, TEXTDISP_JMPTBL_CLEANUP_DrawInsetRectFrame
; READS:
;   RastPort fields at 36/38/58/25 offsets
; WRITES:
;   RastPort fields (36/38), output via graphics.library
; DESC:
;   Draws an inset frame around text and renders the string with optional pen overrides.
; NOTES:
;   Uses -1 as a sentinel for “no override”.
;------------------------------------------------------------------------------
SCRIPT_DrawInsetTextWithFrame:
    LINK.W  A5,#-8
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVEA.L 36(A7),A3
    MOVE.B  43(A7),D7
    MOVE.B  47(A7),D6
    MOVEA.L 48(A7),A2
    MOVE.L  A2,D0
    BEQ.W   .return

    TST.B   (A2)
    BEQ.W   .return

    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVEQ   #0,D1
    NOT.B   D1
    CMP.L   D1,D0
    BEQ.S   .after_frame

    ADDQ.W  #4,36(A3)
    MOVE.L  D6,D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A2,A0

.text_length_loop:
    TST.B   (A0)+
    BNE.S   .text_length_loop

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  D0,20(A7)
    MOVE.L  A0,24(A7)
    MOVEA.L A3,A1
    MOVEA.L A2,A0
    MOVE.L  24(A7),D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    EXT.L   D0
    MOVE.W  58(A3),D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  28(A7),-(A7)
    MOVE.L  A3,-(A7)
    JSR     TEXTDISP_JMPTBL_CLEANUP_DrawInsetRectFrame(PC)

    LEA     16(A7),A7

.after_frame:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #0,D1
    NOT.B   D1
    CMP.L   D1,D0
    BEQ.S   .skip_set_pen

    MOVE.B  25(A3),D5
    EXT.W   D5
    EXT.L   D5
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEA.L A3,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

.skip_set_pen:
    MOVEA.L A2,A0

.text_draw_length_loop:
    TST.B   (A0)+
    BNE.S   .text_draw_length_loop

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,20(A7)
    MOVEA.L A3,A1
    MOVEA.L A2,A0
    MOVE.L  20(A7),D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOText(A6)

    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #0,D1
    NOT.B   D1
    CMP.L   D1,D0
    BEQ.S   .skip_restore_pen

    MOVEA.L A3,A1
    MOVE.L  D5,D0
    JSR     _LVOSetAPen(A6)

.skip_restore_pen:
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVEQ   #0,D1
    NOT.B   D1
    CMP.L   D1,D0
    BEQ.S   .return

    SUBQ.W  #2,38(A3)
    ADDQ.W  #4,36(A3)

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_SetupHighlightEffect   (SetupHighlightEffectuncertain)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +16: arg_2 (via 20(A5))
;   stack +20: arg_3 (via 24(A5))
;   stack +24: arg_4 (via 28(A5))
;   stack +28: arg_5 (via 32(A5))
;   stack +157: arg_6 (via 161(A5))
;   stack +162: arg_7 (via 166(A5))
;   stack +166: arg_8 (via 170(A5))
;   stack +168: arg_9 (via 172(A5))
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A3
; CALLS:
;   TLIBA3_ClearViewModeRastPort, TLIBA3_BuildDisplayContextForViewMode, WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight
; READS:
;   WDISP_DisplayContextBase, copper/effect state
; WRITES:
;   WDISP_DisplayContextBase and effect parameters
; DESC:
;   Initializes highlight/copper effect state and kicks a banner transition.
; NOTES:
;   Exact effect semantics still under investigation.
;------------------------------------------------------------------------------
SCRIPT_SetupHighlightEffect:
    LINK.W  A5,#-176
    MOVEM.L D2/D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    CLR.L   -(A7)
    PEA     4.W
    JSR     TLIBA3_ClearViewModeRastPort(PC)

    PEA     3.W
    CLR.L   -(A7)
    PEA     4.W
    JSR     TLIBA3_BuildDisplayContextForViewMode(PC)

    MOVE.L  D0,WDISP_DisplayContextBase
    JSR     WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    MOVEQ   #0,D5
    MOVEA.L WDISP_DisplayContextBase,A0
    MOVE.W  4(A0),D5
    MOVEQ   #0,D0
    MOVE.W  2(A0),D0
    MOVE.L  D0,-20(A5)
    JSR     WDISP_JMPTBL_ESQIFF_RunCopperDropTransition(PC)

    JSR     WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples(PC)

    LEA     20(A7),A7
    MOVEA.L WDISP_DisplayContextBase,A0
    MOVE.W  (A0),D0
    BTST    #2,D0
    BEQ.S   .is_not_mode2

    MOVEQ   #2,D0
    BRA.S   .use_mode2

.is_not_mode2:
    MOVEQ   #1,D0

.use_mode2:
    MOVE.L  D0,20(A7)
    MOVE.L  D5,D0
    MOVE.L  20(A7),D1
    JSR     MATH_DivS32(PC)

    MOVE.W  D0,-172(A5)
    ADDI.W  #22,D0
    MOVE.W  D0,-172(A5)
    EXT.L   D0
    PEA     500.W
    MOVE.L  D0,-(A7)
    JSR     SCRIPT_BeginBannerCharTransition(PC)

    ADDQ.W  #8,A7
    MOVE.L  A3,D0
    BEQ.W   .return

    TST.B   (A3)
    BEQ.W   .return

    MOVEA.L WDISP_DisplayContextBase,A0
    ADDA.W  #((Global_REF_RASTPORT_2-WDISP_DisplayContextBase)+2),A0
    MOVE.W  #1,WDISP_AccumulatorCaptureActive
    CLR.W   WDISP_AccumulatorFlushPending
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     3.W
    MOVE.L  A0,-4(A5)
    JSR     TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     12(A7),A7
    MOVE.L  D0,WDISP_DisplayContextBase
    CLR.L   -28(A5)
    MOVE.L  A3,-170(A5)

.copy_printable_prefix:
    MOVEA.L -170(A5),A0
    TST.B   (A0)
    BEQ.S   .finalize_prefix

    MOVE.L  -28(A5),D0
    MOVEQ   #64,D1
    ADD.L   D1,D1
    CMP.L   D1,D0
    BGE.S   .finalize_prefix

    MOVE.B  (A0),D1
    MOVEQ   #32,D2
    CMP.B   D2,D1
    BCS.S   .skip_char_store

    LEA     -161(A5),A0
    ADDA.L  D0,A0
    ADDQ.L  #1,-28(A5)
    MOVE.B  D1,(A0)

.skip_char_store:
    ADDQ.L  #1,-170(A5)
    BRA.S   .copy_printable_prefix

.finalize_prefix:
    MOVEA.L -170(A5),A0
    TST.B   (A0)
    BEQ.S   .measure_prefix

    MOVEQ   #0,D0
    MOVE.B  D0,(A0)

.measure_prefix:
    LEA     -161(A5),A0
    MOVE.L  -28(A5),D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    CLR.B   (A1)
    MOVEA.L -4(A5),A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    TST.B   CLOCK_AlignedInsetRenderGateFlag
    BEQ.S   .no_extra_pad

    MOVEQ   #0,D1
    MOVE.B  CLEANUP_AlignedInsetNibblePrimary,D1
    MOVEQ   #0,D2
    NOT.B   D2
    CMP.L   D2,D1
    BEQ.S   .no_extra_pad

    MOVEQ   #8,D1
    BRA.S   .apply_extra_pad

.no_extra_pad:
    MOVEQ   #0,D1

.apply_extra_pad:
    ADD.L   D1,D0
    MOVE.L  -20(A5),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .center_offset_ready

    ADDQ.L  #1,D1

.center_offset_ready:
    ASR.L   #1,D1
    MOVE.L  D1,D7
    MOVE.L  D5,D6
    MOVEQ   #26,D1
    SUB.L   D1,D6
    MOVE.L  D0,-24(A5)
    MOVEA.L -4(A5),A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L -4(A5),A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D7,D0
    MOVE.L  D6,D1
    MOVEA.L -4(A5),A1
    JSR     _LVOMove(A6)

    MOVEA.L A3,A0
    MOVEQ   #0,D0
    MOVE.L  D0,-32(A5)
    MOVE.L  D0,-28(A5)
    MOVE.L  A0,-166(A5)
    MOVE.L  A0,-170(A5)

.parse_control_loop:
    TST.L   -32(A5)
    BNE.W   .finish_render

    MOVEQ   #0,D0
    MOVEA.L -166(A5),A0
    MOVE.B  (A0),D0
    TST.W   D0
    BEQ.S   .handle_end_of_string

    SUBI.W  #19,D0
    BEQ.W   .handle_skip_control

    SUBQ.W  #1,D0
    BEQ.W   .handle_inset_control

    SUBQ.W  #4,D0
    BEQ.S   .handle_color_control

    SUBQ.W  #1,D0
    BEQ.S   .handle_color_control

    BRA.W   .append_printable_char

.handle_end_of_string:
    MOVE.L  -28(A5),D0
    TST.L   D0
    BLE.S   .mark_done

    MOVEA.L -4(A5),A1
    MOVEA.L -170(A5),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOText(A6)

.mark_done:
    MOVEQ   #1,D0
    MOVE.L  D0,-32(A5)
    BRA.W   .advance_parse_ptr

.handle_color_control:
    MOVE.L  -28(A5),D0
    TST.L   D0
    BLE.S   .after_color_flush

    MOVEA.L -4(A5),A1
    MOVEA.L -170(A5),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOText(A6)

.after_color_flush:
    MOVEQ   #24,D0
    MOVEA.L -166(A5),A0
    CMP.B   (A0),D0
    BNE.S   .select_pen_alt

    MOVEQ   #1,D0
    BRA.S   .apply_pen_change

.select_pen_alt:
    MOVEQ   #3,D0

.apply_pen_change:
    MOVEA.L -4(A5),A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L -166(A5),A0
    ADDQ.L  #1,A0
    CLR.L   -28(A5)
    MOVE.L  A0,-170(A5)
    BRA.W   .advance_parse_ptr

.handle_skip_control:
    MOVE.L  -28(A5),D0
    TST.L   D0
    BLE.S   .after_skip_flush

    MOVEA.L -4(A5),A1
    MOVEA.L -170(A5),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOText(A6)

.after_skip_flush:
    MOVEA.L -166(A5),A0
    ADDQ.L  #1,A0
    CLR.L   -28(A5)
    MOVE.L  A0,-170(A5)
    BRA.S   .advance_parse_ptr

.handle_inset_control:
    MOVE.L  -28(A5),-(A7)
    MOVE.L  -170(A5),-(A7)
    PEA     -161(A5)
    JSR     STRING_CopyPadNul(PC)

    LEA     -161(A5),A0
    MOVEA.L A0,A1
    ADDA.L  -28(A5),A1
    CLR.B   (A1)
    MOVEQ   #0,D0
    MOVE.B  CLEANUP_AlignedInsetNibbleSecondary,D0
    MOVEQ   #0,D1
    MOVE.B  CLEANUP_AlignedInsetNibblePrimary,D1
    MOVE.L  A0,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   SCRIPT_DrawInsetTextWithFrame

    LEA     24(A7),A7
    MOVEA.L -166(A5),A0
    ADDQ.L  #1,A0
    CLR.L   -28(A5)
    CLR.B   CLOCK_AlignedInsetRenderGateFlag
    MOVE.L  A0,-170(A5)
    BRA.S   .advance_parse_ptr

.append_printable_char:
    MOVEA.L -166(A5),A0
    CMPI.B  #' ',(A0)
    BCS.S   .advance_parse_ptr

    ADDQ.L  #1,-28(A5)

.advance_parse_ptr:
    ADDQ.L  #1,-166(A5)
    BRA.W   .parse_control_loop

.finish_render:
    PEA     3.W
    CLR.L   -(A7)
    PEA     4.W
    JSR     TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     12(A7),A7
    MOVE.L  D0,WDISP_DisplayContextBase

.return:
    JSR     TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition(PC)

    MOVEM.L (A7)+,D2/D5-D7/A3
    UNLK    A5
    RTS
