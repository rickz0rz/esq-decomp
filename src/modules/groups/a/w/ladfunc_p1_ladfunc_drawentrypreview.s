    XDEF    _LADFUNC_DrawEntryPreview


;------------------------------------------------------------------------------
; FUNC: _LADFUNC_DrawEntryPreview   (Draw entry previewuncertain)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +28: arg_4 (via 32(A5))
;   stack +32: arg_5 (via 36(A5))
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   _GROUP_AW_JMPTBL_TLIBA3_BuildDisplayContextForViewMode, _LVOSetFont, _LVOTextLength,
;   _NEWGRID_JMPTBL_MATH_DivS32, _NEWGRID_JMPTBL_MEMORY_AllocateMemory,
;   _NEWGRID_JMPTBL_MEMORY_DeallocateMemory, _LVOSetDrMd, _LVOSetRast,
;   _GROUP_AW_JMPTBL_ESQIFF_RunCopperDropTransition, _GROUP_AW_JMPTBL_ESQIFF_RunCopperRiseTransition,
;   _LADFUNC_GetPackedPenHighNibble, _LADFUNC_DrawEntryLineWithAttrs
; READS:
;   _LADFUNC_EntryPtrTable, _KYBD_CustomPaletteTriplesRBase.._KYBD_CustomPaletteTriplesBBase, _ED_TextLimit, _Global_HANDLE_H26F_FONT,
;   _Global_HANDLE_PREVUEC_FONT
; WRITES:
;   _WDISP_PaletteTriplesRBase.._WDISP_PaletteTriplesBBase, _WDISP_AccumulatorFlushPending, _WDISP_DisplayContextBase
; DESC:
;   Builds line buffers and renders a preview for the selected entry.
; NOTES:
;   Splits text/attr streams on newline/control markers (24/25/26).
;------------------------------------------------------------------------------
_LADFUNC_DrawEntryPreview:
    LINK.W  A5,#-40
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVE.L  8(A5),D7
    PEA     3.W
    CLR.L   -(A7)
    PEA     4.W
    JSR     _GROUP_AW_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(PC)

    MOVE.L  D0,_WDISP_DisplayContextBase
    MOVEA.L D0,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVEA.L _Global_HANDLE_H26F_FONT,A0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    LEA     _Global_STR_SINGLE_SPACE_2,A0
    MOVEQ   #1,D0
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,44(A7)
    MOVE.L  #624,D0
    MOVE.L  44(A7),D1
    JSR     _NEWGRID_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D0,D6
    MOVE.L  D6,D0
    ADDQ.L  #1,D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    MOVE.L  D0,-(A7)
    PEA     857.W
    PEA     _Global_STR_LADFUNC_C_16
    JSR     _NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    MOVE.L  D6,-(A7)
    PEA     858.W
    PEA     _Global_STR_LADFUNC_C_17
    MOVE.L  D0,-4(A5)
    JSR     _NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     36(A7),A7
    MOVE.L  D0,-16(A5)
    TST.L   -4(A5)
    BEQ.W   .cleanup

    TST.L   D0
    BEQ.W   .cleanup

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _LADFUNC_EntryPtrTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    MOVE.L  6(A2),-8(A5)
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  10(A1),-12(A5)
    CLR.W   _WDISP_AccumulatorFlushPending
    JSR     _GROUP_AW_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVEQ   #1,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    JSR     _GROUP_AW_JMPTBL_ESQIFF_RunCopperDropTransition(PC)

    MOVEQ   #0,D4

.copy_default_palette:
    MOVEQ   #24,D0
    CMP.L   D0,D4
    BGE.S   .palette_ready

    LEA     _WDISP_PaletteTriplesRBase,A0
    ADDA.L  D4,A0
    LEA     _KYBD_CustomPaletteTriplesRBase,A1
    ADDA.L  D4,A1
    MOVE.B  (A1),(A0)
    ADDQ.L  #1,D4
    BRA.S   .copy_default_palette

.palette_ready:
    MOVEA.L -8(A5),A0

.scan_text_end:
    TST.B   (A0)+
    BNE.S   .scan_text_end

    SUBQ.L  #1,A0
    SUBA.L  -8(A5),A0
    MOVE.L  A0,D5
    MOVEQ   #0,D0
    MOVEA.L -12(A5),A0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    BSR.W   _LADFUNC_GetPackedPenHighNibble

    ADDQ.W  #4,A7
    MOVEQ   #0,D4
    MOVE.B  D0,D4
    MOVE.L  D4,D0
    LSL.L   #2,D0
    SUB.L   D4,D0
    LEA     _KYBD_CustomPaletteTriplesRBase,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),_WDISP_PaletteTriplesRBase
    LEA     _KYBD_CustomPaletteTriplesGBase,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),_WDISP_PaletteTriplesGBase
    LEA     _KYBD_CustomPaletteTriplesBBase,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),_WDISP_PaletteTriplesBBase
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVE.L  D4,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVEQ   #0,D0
    MOVE.L  D0,D4
    MOVE.L  D0,-32(A5)
    MOVE.L  D0,-36(A5)

.row_loop:
    CMP.L   _ED_TextLimit,D4
    BGE.W   .after_rows

.row_char_loop:
    MOVE.L  -32(A5),D0
    CMP.L   D5,D0
    BGE.W   .render_line

    MOVE.L  -36(A5),D1
    CMP.L   D6,D1
    BGE.W   .render_line

    MOVEA.L -8(A5),A0
    MOVE.B  0(A0,D0.L),D2
    MOVEQ   #10,D3
    CMP.B   D3,D2
    BEQ.S   .skip_linebreak

    MOVEQ   #13,D3
    CMP.B   D3,D2
    BNE.S   .handle_line_start

.skip_linebreak:
    ADDQ.L  #1,-32(A5)
    BRA.S   .row_char_loop

.handle_line_start:
    TST.L   D1
    BNE.S   .handle_control

    MOVE.B  0(A0,D0.L),D2
    MOVEQ   #24,D3
    CMP.B   D3,D2
    BEQ.S   .handle_control

    MOVEQ   #25,D3
    CMP.B   D3,D2
    BEQ.S   .handle_control

    MOVEQ   #26,D2
    CMP.B   0(A0,D0.L),D2
    BEQ.S   .handle_control

    MOVEA.L -4(A5),A1
    MOVE.B  D3,0(A1,D1.L)
    ADDQ.L  #1,-36(A5)
    MOVEA.L -12(A5),A2
    MOVEA.L -16(A5),A3
    MOVE.B  0(A2,D0.L),0(A3,D1.L)
    BRA.S   .row_char_loop

.handle_control:
    TST.L   D1
    BLE.S   .copy_char

    MOVE.B  0(A0,D0.L),D2
    MOVEQ   #24,D3
    CMP.B   D3,D2
    BEQ.S   .render_line

    MOVEQ   #25,D3
    CMP.B   D3,D2
    BEQ.S   .render_line

    MOVEQ   #26,D2
    CMP.B   0(A0,D0.L),D2
    BNE.S   .copy_char

    BRA.S   .render_line

.copy_char:
    MOVEA.L -12(A5),A1
    MOVEA.L -16(A5),A2
    MOVE.B  0(A1,D0.L),0(A2,D1.L)
    ADDQ.L  #1,-36(A5)
    ADDQ.L  #1,-32(A5)
    MOVEA.L -4(A5),A1
    MOVE.B  0(A0,D0.L),0(A1,D1.L)
    BRA.W   .row_char_loop

.render_line:
    MOVEA.L -4(A5),A0
    MOVE.L  -36(A5),D0
    CLR.B   0(A0,D0.L)
    MOVEA.L _WDISP_DisplayContextBase,A1
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A1
    MOVE.L  -16(A5),-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  A1,-(A7)
    BSR.W   _LADFUNC_DrawEntryLineWithAttrs

    LEA     16(A7),A7
    ADDQ.L  #1,D4
    CLR.L   -36(A5)
    BRA.W   .row_loop

.after_rows:
    JSR     _GROUP_AW_JMPTBL_ESQIFF_RunCopperRiseTransition(PC)

.cleanup:
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    TST.L   -4(A5)
    BEQ.S   .free_attr_buf

    MOVE.L  D6,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     926.W
    PEA     _Global_STR_LADFUNC_C_18
    JSR     _NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.free_attr_buf:
    TST.L   -16(A5)
    BEQ.S   .return

    MOVE.L  D6,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     928.W
    PEA     _Global_STR_LADFUNC_C_19
    JSR     _NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.return:
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======