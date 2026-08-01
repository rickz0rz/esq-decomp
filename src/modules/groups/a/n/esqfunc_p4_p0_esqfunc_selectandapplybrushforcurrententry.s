    XDEF    _ESQFUNC_SelectAndApplyBrushForCurrentEntry


;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_SelectAndApplyBrushForCurrentEntry   (Select and blit brush for current entry context)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
;   stack +16: arg_3 (via 20(A5))
;   stack +20: arg_4 (via 24(A5))
;   stack +28: arg_5 (via 32(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D1/D2/D4/D5/D6/D7
; CALLS:
;   _ESQIFF_JMPTBL_BRUSH_SelectBrushSlot, _ESQIFF_JMPTBL_STRING_CompareN, _ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex, _ESQSHARED_JMPTBL_ESQ_WildcardMatch, _ESQIFF_RestoreBasePaletteTriples, _LVOSetRast
; READS:
;   _BRUSH_ScriptPrimarySelection, _BRUSH_ScriptSecondarySelection, _BRUSH_SelectedNode, _Global_REF_GRAPHICS_LIBRARY, _Global_REF_RASTPORT_2, _ESQFUNC_BasePaletteRgbTriples, _ESQFUNC_FallbackType3BrushNode, _ESQIFF_BrushIniListHead, _ESQFUNC_TAG_00, _ESQFUNC_TAG_11, _TEXTDISP_ActiveGroupId, _WDISP_DisplayContextBase, _TEXTDISP_PrimaryEntryPtrTable, _TEXTDISP_SecondaryEntryPtrTable, _WDISP_PaletteTriplesRBase, _TEXTDISP_CurrentMatchIndex, e8
; WRITES:
;   (none observed)
; DESC:
;   Chooses a brush from script selection or brush.ini metadata for the current
;   entry, clears target rastports, blits the brush, and applies palette-copy rules.
; NOTES:
;   Entry tag bytes at `entry+0x2B` steer tag/wildcard lookup paths.
;------------------------------------------------------------------------------
_ESQFUNC_SelectAndApplyBrushForCurrentEntry:
    LINK.W  A5,#-32
    MOVEM.L D2/D4-D7,-(A7)
    MOVE.W  10(A5),D7
    MOVE.L  _ESQIFF_BrushIniListHead,-4(A5)
    MOVEQ   #0,D5
    TST.W   D7
    BNE.S   .load_secondary_script_selection

    MOVE.L  _BRUSH_ScriptPrimarySelection,-24(A5) ; prefer script-selected brush if present
    BRA.S   .resolve_selection_source

.load_secondary_script_selection:
    MOVEA.L _BRUSH_ScriptSecondarySelection,A0 ; fall back to secondary slot when requested
    MOVE.L  A0,-24(A5)

.resolve_selection_source:
    TST.L   -24(A5)
    BNE.W   .use_script_selected_brush

    MOVE.W  _TEXTDISP_ActiveGroupId,D0
    SUBQ.W  #1,D0
    BNE.S   .load_secondary_current_entry_ptr

    MOVE.W  _TEXTDISP_CurrentMatchIndex,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    BRA.S   .compare_entry_tag_00

.load_secondary_current_entry_ptr:
    MOVE.W  _TEXTDISP_CurrentMatchIndex,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)

.compare_entry_tag_00:
    MOVEA.L -8(A5),A0
    ADDA.W  #$2b,A0
    PEA     2.W
    PEA     _ESQFUNC_TAG_00
    MOVE.L  A0,-(A7)
    JSR     _ESQIFF_JMPTBL_STRING_CompareN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .compare_entry_tag_11

    MOVE.L  _BRUSH_SelectedNode,-4(A5)
    MOVEQ   #1,D5
    BRA.W   .ensure_fallback_selected_brush

.compare_entry_tag_11:
    MOVEA.L -8(A5),A0
    ADDA.W  #$2b,A0
    PEA     2.W
    PEA     _ESQFUNC_TAG_11
    MOVE.L  A0,-(A7)
    JSR     _ESQIFF_JMPTBL_STRING_CompareN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .scan_brush_nodes_by_2char_tag

.scan_brush_nodes_by_wildcard_chain:
    TST.L   -4(A5)
    BEQ.S   .fallback_to_type3_or_selected

    TST.L   D5
    BNE.S   .fallback_to_type3_or_selected

    MOVEA.L -4(A5),A0
    MOVE.L  364(A0),-20(A5)

.loop_match_wildcard_list:
    TST.L   -20(A5)
    BEQ.S   .advance_brush_node_chain

    TST.L   D5
    BNE.S   .advance_brush_node_chain

    MOVEA.L -8(A5),A0
    ADDA.W  #12,A0
    MOVE.L  -20(A5),-(A7)
    MOVE.L  A0,-(A7)
    JSR     _ESQSHARED_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .advance_wildcard_node

    MOVEQ   #1,D5

.advance_wildcard_node:
    MOVEA.L -20(A5),A0
    MOVE.L  8(A0),-20(A5)
    BRA.S   .loop_match_wildcard_list

.advance_brush_node_chain:
    TST.L   D5
    BNE.S   .scan_brush_nodes_by_wildcard_chain

    MOVEA.L -4(A5),A0
    MOVE.L  368(A0),-4(A5)
    BRA.S   .scan_brush_nodes_by_wildcard_chain

.fallback_to_type3_or_selected:
    TST.L   D5
    BNE.S   .ensure_fallback_selected_brush

    MOVEA.L -8(A5),A0
    BTST    #4,27(A0)
    BEQ.S   .ensure_fallback_selected_brush

    TST.L   _ESQFUNC_FallbackType3BrushNode
    BEQ.S   .ensure_fallback_selected_brush

    MOVEQ   #1,D5
    MOVE.L  _ESQFUNC_FallbackType3BrushNode,-4(A5)
    BRA.S   .ensure_fallback_selected_brush

.scan_brush_nodes_by_2char_tag:
    TST.L   -4(A5)
    BEQ.S   .ensure_fallback_selected_brush

    TST.L   D5
    BNE.S   .ensure_fallback_selected_brush

    MOVEA.L -8(A5),A0
    ADDA.W  #$2b,A0
    MOVEA.L -4(A5),A1
    ADDA.W  #$21,A1
    PEA     2.W
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _ESQIFF_JMPTBL_STRING_CompareN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .advance_tag_match_node

    MOVEQ   #1,D5

.advance_tag_match_node:
    TST.L   D5
    BNE.S   .scan_brush_nodes_by_2char_tag

    MOVEA.L -4(A5),A0
    MOVE.L  368(A0),-4(A5)
    BRA.S   .scan_brush_nodes_by_2char_tag

.use_script_selected_brush:
    MOVEQ   #1,D5
    MOVE.L  -24(A5),-4(A5)

.ensure_fallback_selected_brush:
    TST.L   D5
    BNE.S   .clear_rastports_before_brush_blit

    MOVE.L  _BRUSH_SelectedNode,-4(A5)

.clear_rastports_before_brush_blit:
    MOVEA.L _Global_REF_RASTPORT_2,A1
    MOVEQ   #31,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVEQ   #31,D0
    JSR     _LVOSetRast(A6)

    TST.L   -4(A5)
    BEQ.S   .maybe_copy_brush_palette_segment

    TST.L   _BRUSH_SelectedNode
    BNE.S   .blit_selected_brush_to_rast

    TST.L   D5
    BEQ.S   .maybe_copy_brush_palette_segment

.blit_selected_brush_to_rast:
    MOVEQ   #0,D0
    MOVEA.L _WDISP_DisplayContextBase,A0
    MOVE.W  2(A0),D0
    SUBQ.L  #1,D0
    MOVEQ   #0,D1
    MOVE.W  4(A0),D1
    SUBQ.L  #1,D1
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  _Global_REF_RASTPORT_2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     _ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(PC)

    LEA     28(A7),A7

.maybe_copy_brush_palette_segment:
    TST.L   -4(A5)
    BEQ.W   .restore_base_palette_when_no_brush

    MOVEA.L -4(A5),A0
    TST.L   328(A0)
    BEQ.S   .prepare_plane_mask_bounds

    MOVE.L  328(A0),D0
    MOVEQ   #1,D1
    CMP.L   D1,D0
    BEQ.S   .prepare_plane_mask_bounds

    SUBQ.L  #3,D0
    BNE.S   .apply_brush_palette_mode_postprocess

.prepare_plane_mask_bounds:
    PEA     5.W
    JSR     _ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    MOVE.L  D1,D4
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  184(A0),D0
    MOVE.L  D0,(A7)
    JSR     _ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    MOVEQ   #0,D6
    MOVE.L  D1,-32(A5)

.loop_copy_palette_bytes_from_brush:
    CMP.L   -32(A5),D6
    BGE.S   .apply_brush_palette_mode_postprocess

    CMP.L   D4,D6
    BGE.S   .apply_brush_palette_mode_postprocess

    LEA     _WDISP_PaletteTriplesRBase,A0
    ADDA.L  D6,A0
    MOVEA.L -4(A5),A1
    MOVE.L  D6,D0
    ADDI.L  #$e8,D0
    MOVE.B  0(A1,D0.L),(A0)
    ADDQ.L  #1,D6
    BRA.S   .loop_copy_palette_bytes_from_brush

.apply_brush_palette_mode_postprocess:
    MOVEQ   #1,D0
    MOVEA.L -4(A5),A0
    CMP.L   328(A0),D0
    BNE.S   .check_palette_mode_three

    BSR.W   _ESQIFF_RestoreBasePaletteTriples

    BRA.S   .return

.check_palette_mode_three:
    MOVEQ   #3,D0
    CMP.L   328(A0),D0
    BNE.S   .return

    MOVEQ   #0,D6

.loop_restore_first_12_palette_bytes:
    MOVEQ   #12,D0
    CMP.L   D0,D6
    BGE.S   .return

    LEA     _WDISP_PaletteTriplesRBase,A0
    ADDA.L  D6,A0
    LEA     _ESQFUNC_BasePaletteRgbTriples,A1
    ADDA.L  D6,A1
    MOVE.B  (A1),(A0)
    ADDQ.L  #1,D6
    BRA.S   .loop_restore_first_12_palette_bytes

.restore_base_palette_when_no_brush:
    BSR.W   _ESQIFF_RestoreBasePaletteTriples

.return:
    MOVEQ   #1,D0
    MOVEM.L (A7)+,D2/D4-D7
    UNLK    A5
    RTS

;!======