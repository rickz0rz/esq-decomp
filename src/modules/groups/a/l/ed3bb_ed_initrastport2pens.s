    XDEF    _ED_InitRastport2Pens



;------------------------------------------------------------------------------
; FUNC: _ED_InitRastport2Pens   (Init rastport 2 pensuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A5/A6/D0
; CALLS:
;   _LVOSetDrMd, _LVOSetAPen, _LVOSetBPen
; READS:
;   _WDISP_DisplayContextBase, _ED_Rastport2PenModeSelector, _Global_REF_GRAPHICS_LIBRARY
; WRITES:
;   (none)
; DESC:
;   Sets drawing mode and pen defaults for the secondary rastport.
; NOTES:
;   Uses _ED_Rastport2PenModeSelector to select alternate pen setup.
;------------------------------------------------------------------------------
_ED_InitRastport2Pens:
    LINK.W  A5,#-4
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVE.L  A0,-4(A5)
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L -4(A5),A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEQ   #14,D0
    CMP.L   _ED_Rastport2PenModeSelector,D0
    BNE.S   .after_alt_pens

    MOVEA.L -4(A5),A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L -4(A5),A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

.after_alt_pens:
    UNLK    A5
    RTS

;!======