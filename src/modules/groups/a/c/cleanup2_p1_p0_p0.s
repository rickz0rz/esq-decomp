    XDEF    _CLEANUP_DrawBannerSpacerSegment
    XDEF    _CLEANUP_DrawDateBannerSegment
    XDEF    _CLEANUP_DrawTimeBannerSegment


;------------------------------------------------------------------------------
; FUNC: _CLEANUP_DrawDateBannerSegment   (DrawDateBannerSegmentuncertain)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A0-A1/A5-A6
; CALLS:
;   _LVOSetAPen, _LVORectFill, _RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY,
;   _BEVEL_DrawBevelFrameWithTopRight
; READS:
;   _Global_REF_RASTPORT_1, _Global_REF_GRAPHICS_LIBRARY, _Global_REF_696_400_BITMAP
; WRITES:
;   RastPort BitMap (temporary swap)
; DESC:
;   Draws the left banner segment containing the short date (day/month).
; NOTES:
;   - Temporarily swaps the rastport bitmap to _Global_REF_696_400_BITMAP.
;------------------------------------------------------------------------------
_CLEANUP_DrawDateBannerSegment:
    LINK.W  A5,#-4
    MOVEM.L D2-D3,-(A7)

.rastPortBitmap = -4

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  Struct_RastPort__BitMap(A0),.rastPortBitmap(A5)
    MOVE.L  #_Global_REF_696_400_BITMAP,Struct_RastPort__BitMap(A0)
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.W  Struct_RastPort__Flags(A0),D0
    ANDI.W  #$fff7,D0
    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.W  D0,Struct_RastPort__Flags(A0)
    MOVEA.L A0,A1
    MOVEQ   #40,D0
    MOVEQ   #34,D1
    MOVEQ   #0,D2
    NOT.B   D2
    MOVEQ   #67,D3
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVORectFill(A6)

    BSR.W   _RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY

    PEA     67.W
    PEA     255.W
    PEA     34.W
    CLR.L   -(A7)
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _BEVEL_DrawBevelFrameWithTopRight(PC)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  .rastPortBitmap(A5),Struct_RastPort__BitMap(A0)

    MOVEM.L -12(A5),D2-D3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _CLEANUP_DrawBannerSpacerSegment   (DrawBannerSpacerSegmentuncertain)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A0-A1/A5-A6
; CALLS:
;   _LVOSetAPen, _LVORectFill, _BEVEL_DrawBevelFrameWithTopRight
; READS:
;   _Global_REF_RASTPORT_1, _Global_REF_GRAPHICS_LIBRARY, _Global_REF_696_400_BITMAP
; WRITES:
;   RastPort BitMap (temporary swap)
; DESC:
;   Clears/draws the middle banner segment (no text).
;------------------------------------------------------------------------------
_CLEANUP_DrawBannerSpacerSegment:
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
    MOVE.L  #256,D0
    MOVEQ   #34,D1
    MOVE.L  #447,D2
    MOVEQ   #67,D3
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVORectFill(A6)

    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    PEA     34.W
    PEA     256.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _BEVEL_DrawBevelFrameWithTopRight(PC)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  -4(A5),4(A0)
    MOVEM.L -12(A5),D2-D3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _CLEANUP_DrawTimeBannerSegment   (DrawTimeBannerSegmentuncertain)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A0-A1/A5-A6
; CALLS:
;   _LVOSetAPen, _LVORectFill, _CLEANUP_DrawGridTimeBanner, _BEVEL_DrawBevelFrameWithTopRight
; READS:
;   _Global_REF_RASTPORT_1, _Global_REF_GRAPHICS_LIBRARY, _Global_REF_696_400_BITMAP
; WRITES:
;   RastPort BitMap (temporary swap)
; DESC:
;   Draws the right banner segment containing the time string.
;------------------------------------------------------------------------------
_CLEANUP_DrawTimeBannerSegment:
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
    MOVE.L  #448,D0
    MOVEQ   #34,D1
    MOVE.L  #663,D2
    MOVEQ   #67,D3
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVORectFill(A6)

    BSR.W   _CLEANUP_DrawGridTimeBanner

    PEA     67.W
    PEA     695.W
    PEA     34.W
    PEA     448.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _BEVEL_DrawBevelFrameWithTopRight(PC)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  -4(A5),4(A0)
    MOVEM.L -12(A5),D2-D3
    UNLK    A5
    RTS

;!======