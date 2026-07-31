    XDEF    _TEXTDISP_SetRastForMode



;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_SetRastForMode   (Set rast + palette for mode)
; ARGS:
;   stack +8: modeIndex (word)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D2/D7/A0-A1/A6
; CALLS:
;   _WDISP_JMPTBL_ESQIFF_RunCopperDropTransition, _TLIBA3_BuildDisplayContextForViewMode, _LVOSetRast
; READS:
;   _WDISP_PaletteTriplesRBase-2297, _Global_REF_RASTPORT_2, Global_REF_GRAPHICS_LIBRARY
; WRITES:
;   _WDISP_DisplayContextBase, _WDISP_PaletteTriplesRBase-2297, _WDISP_AccumulatorFlushPending
; DESC:
;   Allocates/sets the working rastport and updates palette bytes based on mode.
; NOTES:
;   Mode 0 uses args (3,0,0); nonzero uses (4,0,7).
;------------------------------------------------------------------------------
_TEXTDISP_SetRastForMode:
    MOVEM.L D2/D7,-(A7)
    MOVE.W  14(A7),D7
    CLR.W   _WDISP_AccumulatorFlushPending
    JSR     _WDISP_JMPTBL_ESQIFF_RunCopperDropTransition(PC)

    TST.W   D7
    BNE.S   .mode_nonzero

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     3.W
    JSR     _TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     12(A7),A7
    MOVE.L  D0,_WDISP_DisplayContextBase
    BRA.S   .return

.mode_nonzero:
    PEA     4.W
    CLR.L   -(A7)
    PEA     7.W
    JSR     _TLIBA3_BuildDisplayContextForViewMode(PC)

    LEA     12(A7),A7
    MOVE.L  D0,_WDISP_DisplayContextBase
    MOVE.L  D7,D1
    MOVEQ   #3,D2
    MULS    D2,D1
    LEA     _WDISP_PaletteTriplesRBase,A0
    ADDA.L  D1,A0
    MOVE.B  (A0),_WDISP_PaletteTriplesRBase
    MOVE.L  D7,D0
    MULS    D2,D0
    LEA     _WDISP_PaletteTriplesGBase,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),_WDISP_PaletteTriplesGBase
    MOVE.L  D7,D0
    MULS    D2,D0
    LEA     _WDISP_PaletteTriplesBBase,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),_WDISP_PaletteTriplesBBase
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEA.L A0,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

.return:
    MOVEM.L (A7)+,D2/D7
    RTS

;!======