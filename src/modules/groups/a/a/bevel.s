;------------------------------------------------------------------------------
; FUNC: BEVEL_DrawVerticalBevel   (DrawVerticalBeveluncertain)
; ARGS:
;   stack +4: rastPort
;   stack +8: x
;   stack +12: y
;   stack +16: height
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A3, A6
; CALLS:
;   graphics.library Move/Draw/SetDrMd/SetAPen
; READS:
;   (none)
; WRITES:
;   RastPort
; DESC:
;   Draws a multi-line vertical beveled edge at x/y with pen 1.
; NOTES:
;   Repeats offset strokes to create a thicker edge.
;------------------------------------------------------------------------------
BEVEL_DrawVerticalBevel:
    LINK.W  A5,#-4
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    MOVE.L  20(A5),D5

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L A3,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVE.W  #(-1),34(A3)
    BSET    #0,33(A3)
    MOVE.B  #15,30(A3)
    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVE.L  D5,D0
    SUBQ.L  #1,D0
    MOVEA.L A3,A1
    MOVE.L  D6,D1
    JSR     _LVODraw(A6)

    MOVE.W  #(-1),34(A3)
    BSET    #0,33(A3)
    MOVE.B  #15,30(A3)
    MOVE.L  D6,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,16(A7)
    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  16(A7),D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVE.L  D5,D0
    SUBQ.L  #2,D0
    MOVE.L  D6,D1
    ADDQ.L  #1,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.W  #(-1),34(A3)
    BSET    #0,33(A3)
    MOVE.B  #15,30(A3)
    MOVE.L  D6,D0
    ADDQ.L  #2,D0
    MOVE.L  D0,16(A7)
    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  16(A7),D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVE.L  D5,D0
    SUBQ.L  #3,D0
    MOVE.L  D6,D1
    ADDQ.L  #2,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.W  #(-1),34(A3)
    BSET    #0,33(A3)
    MOVE.B  #15,30(A3)
    MOVE.L  D6,D0
    ADDQ.L  #3,D0
    MOVE.L  D0,16(A7)
    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  16(A7),D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVE.L  D5,D0
    SUBQ.L  #4,D0
    MOVE.L  D6,D1
    ADDQ.L  #3,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======

; The moves and draws seem like this is making some kind of
; outlined box... maybe with a shadow or bevel?
;------------------------------------------------------------------------------
; FUNC: BEVEL_DrawVerticalBevelPair   (DrawVerticalBevelPairuncertain)
; ARGS:
;   stack +4: rastPort
;   stack +8: leftX
;   stack +12: topY
;   stack +16: rightX
;   stack +20: bottomY
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A3, A6
; CALLS:
;   graphics.library Move/Draw/SetDrMd/SetAPen
; READS:
;   (none)
; WRITES:
;   RastPort
; DESC:
;   Draws two vertical beveled edges using pen 1 and pen 2.
; NOTES:
;   Offsets by +/-1..3 to thicken edges.
;------------------------------------------------------------------------------
BEVEL_DrawVerticalBevelPair:
    MOVEM.L D4-D7/A3,-(A7)

    MOVEA.L 24(A7),A3
    MOVE.L  28(A7),D7
    MOVE.L  32(A7),D6
    MOVE.L  36(A7),D5
    MOVE.L  40(A7),D4

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L A3,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVE.W  #(-1),34(A3)
    BSET    #0,33(A3)
    MOVE.B  #$f,30(A3)

    MOVEA.L A3,A1
    MOVE.L  D7,D0               ; x
    MOVE.L  D6,D1               ; y
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  D4,D1               ; y
    JSR     _LVODraw(A6)

    MOVE.L  D7,D0

    ADDQ.L  #1,D0               ; x
    MOVEA.L A3,A1               ; rastport
    MOVE.L  D6,D1               ; y
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVEA.L A3,A1
    MOVE.L  D4,D1
    JSR     _LVODraw(A6)

    MOVE.L  D7,D0
    ADDQ.L  #2,D0               ; x
    MOVEA.L A3,A1               ; rastport
    MOVE.L  D6,D1               ; y
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    ADDQ.L  #2,D0
    MOVEA.L A3,A1
    MOVE.L  D4,D1
    JSR     _LVODraw(A6)

    MOVE.L  D7,D0               ; x = D7
    ADDQ.L  #3,D0               ; x = x + 3
    MOVEA.L A3,A1               ; rastport
    MOVE.L  D6,D1               ; y = D1
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    ADDQ.L  #3,D0
    MOVEA.L A3,A1
    MOVE.L  D4,D1
    JSR     _LVODraw(A6)

    MOVEA.L A3,A1               ; rastport
    MOVEQ   #2,D0               ; pen number
    JSR     _LVOSetAPen(A6)

    MOVE.W  #(-1),34(A3)
    BSET    #0,33(A3)
    MOVE.B  #$f,30(A3)

    MOVEA.L A3,A1               ; rastport
    MOVE.L  D5,D0               ; x
    MOVE.L  D4,D1               ; y
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVE.L  D5,D0
    MOVE.L  D6,D1
    JSR     _LVODraw(A6)

    MOVE.L  D5,D0
    SUBQ.L  #1,D0
    MOVEA.L A3,A1
    MOVE.L  D4,D1
    JSR     _LVOMove(A6)

    MOVE.L  D5,D0
    SUBQ.L  #1,D0
    MOVEA.L A3,A1
    MOVE.L  D6,D1
    JSR     _LVODraw(A6)

    MOVE.L  D5,D0
    SUBQ.L  #2,D0
    MOVEA.L A3,A1
    MOVE.L  D4,D1
    JSR     _LVOMove(A6)

    MOVE.L  D5,D0
    SUBQ.L  #2,D0
    MOVEA.L A3,A1
    MOVE.L  D6,D1
    JSR     _LVODraw(A6)

    MOVE.L  D5,D0               ; x = D5
    SUBQ.L  #3,D0               ; x = x - 3
    MOVEA.L A3,A1               ; rastport
    MOVE.L  D4,D1               ; y
    JSR     _LVOMove(A6)

    MOVE.L  D5,D0               ; x = D5
    SUBQ.L  #3,D0               ; x = x - 3
    MOVEA.L A3,A1               ; rastport
    MOVE.L  D6,D1               ; y = D6
    JSR     _LVODraw(A6)

    MOVEM.L (A7)+,D4-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: BEVEL_DrawHorizontalBevel   (DrawHorizontalBeveluncertain)
; ARGS:
;   stack +4: rastPort
;   stack +8: leftX
;   stack +12: rightX
;   stack +16: y
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A3, A6
; CALLS:
;   graphics.library Move/Draw/SetDrMd/SetAPen
; READS:
;   (none)
; WRITES:
;   RastPort
; DESC:
;   Draws a multi-line horizontal beveled edge at y with pen 2.
; NOTES:
;   Repeats offset strokes to create a thicker edge.
;------------------------------------------------------------------------------
BEVEL_DrawHorizontalBevel:
    LINK.W  A5,#-4
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  20(A5),D6
    MOVE.L  24(A5),D5

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L A3,A1
    MOVEQ   #2,D0
    JSR     _LVOSetAPen(A6)

    MOVE.W  #(-1),34(A3)
    BSET    #0,33(A3)
    MOVE.B  #$f,30(A3)
    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVE.L  D5,D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  D5,D1
    JSR     _LVODraw(A6)

    MOVE.L  D5,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,16(A7)
    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVE.L  16(A7),D1
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVE.L  D5,D1
    SUBQ.L  #1,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.L  D5,D0
    SUBQ.L  #2,D0
    MOVE.L  D0,16(A7)
    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVE.L  16(A7),D1
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    ADDQ.L  #2,D0
    MOVE.L  D5,D1
    SUBQ.L  #2,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVE.L  D5,D0
    SUBQ.L  #3,D0
    MOVE.L  D0,16(A7)
    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVE.L  16(A7),D1
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    ADDQ.L  #3,D0
    MOVE.L  D5,D1
    SUBQ.L  #3,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVEA.L A3,A1
    MOVEQ   #6,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVE.L  D5,D1
    JSR     _LVOMove(A6)

    MOVE.L  D6,D0
    SUBQ.L  #3,D0
    MOVE.L  D5,D1
    SUBQ.L  #3,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: BEVEL_DrawBeveledFrame   (DrawBeveledFrameuncertain)
; ARGS:
;   stack +4: rastPort
;   stack +8: leftX
;   stack +12: topY
;   stack +16: rightX
;   stack +20: bottomY
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A3
; CALLS:
;   BEVEL_DrawVerticalBevelPair, BEVEL_DrawVerticalBevel
; READS:
;   (none)
; WRITES:
;   RastPort
; DESC:
;   Draws a beveled frame with left/right edges and a corner accent.
; NOTES:
;   Composes BEVEL_DrawVerticalBevelPair + BEVEL_DrawVerticalBevel helpers.
;------------------------------------------------------------------------------
BEVEL_DrawBeveledFrame:
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVE.L  28(A7),D7
    MOVE.L  32(A7),D6
    MOVE.L  36(A7),D5
    MOVE.L  40(A7),D4

    MOVE.L  D4,-(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   BEVEL_DrawVerticalBevelPair

    MOVE.L  D4,(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   BEVEL_DrawVerticalBevel

    LEA     36(A7),A7

    MOVEA.L A3,A1
    MOVEQ   #2,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    ADDQ.L  #3,D0
    MOVE.L  D6,D1
    ADDQ.L  #3,D1
    MOVEA.L A3,A1
    JSR     _LVODraw(A6)

    MOVEM.L (A7)+,D4-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: BEVEL_DrawBevelFrameWithTop   (DrawBevelFrameWithTopuncertain)
; ARGS:
;   stack +4: rastPort
;   stack +8: leftX
;   stack +12: topY
;   stack +16: rightX
;   stack +20: bottomY
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A3
; CALLS:
;   BEVEL_DrawVerticalBevelPair, BEVEL_DrawHorizontalBevel
; READS:
;   (none)
; WRITES:
;   RastPort
; DESC:
;   Draws a beveled frame with a top horizontal edge.
; NOTES:
;   Composes BEVEL_DrawVerticalBevelPair + BEVEL_DrawHorizontalBevel helpers.
;------------------------------------------------------------------------------
BEVEL_DrawBevelFrameWithTop:
    MOVEM.L D4-D7/A3,-(A7)

    MOVEA.L 24(A7),A3
    MOVE.L  28(A7),D7
    MOVE.L  32(A7),D6
    MOVE.L  36(A7),D5
    MOVE.L  40(A7),D4
    MOVE.L  D4,-(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   BEVEL_DrawVerticalBevelPair

    MOVE.L  D4,(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   BEVEL_DrawHorizontalBevel

    LEA     36(A7),A7

    MOVEM.L (A7)+,D4-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: BEVEL_DrawBevelFrameWithTopRight   (DrawBevelFrameWithTopRightuncertain)
; ARGS:
;   stack +4: rastPort
;   stack +8: leftX
;   stack +12: topY
;   stack +16: rightX
;   stack +20: bottomY
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A3
; CALLS:
;   BEVEL_DrawBeveledFrame, BEVEL_DrawHorizontalBevel
; READS:
;   (none)
; WRITES:
;   RastPort
; DESC:
;   Draws a beveled frame plus a top edge and right-side accent.
; NOTES:
;   Composes BEVEL_DrawBeveledFrame + BEVEL_DrawHorizontalBevel helpers.
;------------------------------------------------------------------------------
BEVEL_DrawBevelFrameWithTopRight:
    MOVEM.L D4-D7/A3,-(A7)

    MOVEA.L 24(A7),A3
    MOVE.L  28(A7),D7
    MOVE.L  32(A7),D6
    MOVE.L  36(A7),D5
    MOVE.L  40(A7),D4
    MOVE.L  D4,-(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   BEVEL_DrawBeveledFrame

    MOVE.L  D4,(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   BEVEL_DrawHorizontalBevel

    LEA     36(A7),A7

    MOVEM.L (A7)+,D4-D7/A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD
