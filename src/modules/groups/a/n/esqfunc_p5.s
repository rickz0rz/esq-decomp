    XDEF    _ESQFUNC_TrimTextToPixelWidthWordBoundary
    XDEF    ESQFUNC_TrimTextToPixelWidthWordBoundary_Return


;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_TrimTextToPixelWidthWordBoundary   (Trim text length to fit pixel width at word boundary)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A6/A7/D0/D6/D7
; CALLS:
;   _LVOTextLength
; READS:
;   _Global_REF_GRAPHICS_LIBRARY, _WDISP_CharClassTable
; WRITES:
;   (none observed)
; DESC:
;   Measures text width and repeatedly shrinks candidate length to a class-3
;   boundary until TextLength(text[0..len]) fits within max pixel width.
; NOTES:
;   Uses _WDISP_CharClassTable bit3 as boundary classifier.
;------------------------------------------------------------------------------
_ESQFUNC_TrimTextToPixelWidthWordBoundary:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.L  24(A7),D7
    MOVEA.L 28(A7),A2
    MOVEA.L A2,A0

.loop_find_text_nul:
    TST.B   (A0)+
    BNE.S   .loop_find_text_nul

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,D6

.loop_fit_text_to_pixel_width:
    TST.L   D6
    BLE.S   ESQFUNC_TrimTextToPixelWidthWordBoundary_Return

    MOVEA.L A3,A1
    MOVEA.L A2,A0
    MOVE.L  D6,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    CMP.L   D7,D0
    BLE.S   ESQFUNC_TrimTextToPixelWidthWordBoundary_Return

.scan_backward_to_word_boundary:
    SUBQ.L  #1,D6
    TST.L   D6
    BLE.S   .rewind_over_trailing_class3_chars

    MOVE.B  -1(A2,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #3,(A0)
    BEQ.S   .scan_backward_to_word_boundary

.rewind_over_trailing_class3_chars:
    TST.L   D6
    BLE.S   .loop_fit_text_to_pixel_width

    MOVE.B  -1(A2,D6.L),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #3,(A0)
    BEQ.S   .loop_fit_text_to_pixel_width

    SUBQ.L  #1,D6
    BRA.S   .rewind_over_trailing_class3_chars

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_TrimTextToPixelWidthWordBoundary_Return   (Return tail for pixel-width text trim helper)
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
;   Returns selected text length in D0 and restores saved registers.
; NOTES:
;   Shared return from fit success and lower-bound exits.
;------------------------------------------------------------------------------
ESQFUNC_TrimTextToPixelWidthWordBoundary_Return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS
