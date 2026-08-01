    XDEF    _CLEANUP_DrawDateTimeBannerRow


;------------------------------------------------------------------------------
; FUNC: _CLEANUP_DrawDateTimeBannerRow   (DrawDateTimeBannerRowuncertain)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A0-A1/A5-A6
; CALLS:
;   _LVOSetAPen, _LVORectFill, _CLEANUP_DrawDateBannerSegment,
;   _CLEANUP_DrawBannerSpacerSegment, _CLEANUP_DrawTimeBannerSegment
; READS:
;   _Global_REF_RASTPORT_1, _Global_REF_GRAPHICS_LIBRARY, _Global_REF_696_400_BITMAP
; WRITES:
;   RastPort BitMap (temporary swap)
; DESC:
;   Clears the banner row and draws left date, middle spacer, and right time.
;------------------------------------------------------------------------------
_CLEANUP_DrawDateTimeBannerRow:
    LINK.W  A5,#-4
    MOVEM.L D2-D3,-(A7)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  4(A0),-4(A5)
    MOVE.L  #_Global_REF_696_400_BITMAP,4(A0)
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.W  32(A0),D0
    ANDI.W  #$fff7,D0
    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.W  D0,32(A0)
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEQ   #34,D1
    MOVE.L  #695,D2
    MOVEQ   #67,D3
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVORectFill(A6)

    BSR.W   _CLEANUP_DrawDateBannerSegment

    BSR.W   _CLEANUP_DrawBannerSpacerSegment

    BSR.W   _CLEANUP_DrawTimeBannerSegment

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  -4(A5),4(A0)

    MOVEM.L (A7)+,D2-D3
    UNLK    A5
    RTS

;!======