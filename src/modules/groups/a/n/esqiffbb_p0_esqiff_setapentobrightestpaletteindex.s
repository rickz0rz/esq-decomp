    XDEF    _ESQIFF_SetApenToBrightestPaletteIndex




;------------------------------------------------------------------------------
; FUNC: _ESQIFF_SetApenToBrightestPaletteIndex   (Set APen to brightest palette triple within active depth)
; ARGS:
;   stack +10: arg_1 (via 14(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D1/D2/D4/D5/D6/D7
; CALLS:
;   _LVOSetAPen
; READS:
;   Global_REF_GRAPHICS_LIBRARY, _Global_REF_RASTPORT_2, _WDISP_DisplayContextBase, _WDISP_PaletteTriplesRBase, _WDISP_PaletteTriplesGBase, _WDISP_PaletteTriplesBBase, _WDISP_PaletteDepthLog2
; WRITES:
;   (none observed)
; DESC:
;   Scans active palette entries, picks the index with highest summed RGB
;   intensity, and applies it to the display-context rastport APen.
; NOTES:
;   Palette scan upper bound is derived from active depth bit (`22AE`).
;------------------------------------------------------------------------------
_ESQIFF_SetApenToBrightestPaletteIndex:
    LINK.W  A5,#-16
    MOVEM.L D2/D4-D7,-(A7)
    MOVEQ   #0,D0
    MOVE.B  _WDISP_PaletteDepthLog2,D0
    MOVEQ   #1,D1
    ASL.L   D0,D1
    MOVE.L  D1,D4
    MOVEQ   #0,D0
    MOVE.B  _WDISP_PaletteTriplesRBase,D0
    MOVEQ   #0,D1
    MOVE.B  _WDISP_PaletteTriplesGBase,D1
    ADD.L   D1,D0
    MOVEQ   #0,D1
    MOVE.B  _WDISP_PaletteTriplesBBase,D1
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
    LEA     _WDISP_PaletteTriplesGBase,A1
    ADDA.L  D0,A1
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVEQ   #0,D2
    MOVE.B  (A1),D2
    ADD.L   D2,D0
    MOVE.L  D7,D2
    MULS    D1,D2
    LEA     _WDISP_PaletteTriplesBBase,A0
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
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVE.L  -14(A5),D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEM.L (A7)+,D2/D4-D7
    UNLK    A5
    RTS

;!======