    XDEF    _SCRIPT_DrawInsetTextWithFrame



;------------------------------------------------------------------------------
; FUNC: _SCRIPT_DrawInsetTextWithFrame   (DrawInsetTextWithFrameuncertain)
; ARGS:
;   (none observed)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _LVOTextLength, _LVOText, _LVOSetAPen, _TEXTDISP_JMPTBL_CLEANUP_DrawInsetRectFrame
; READS:
;   RastPort fields at 36/38/58/25 offsets
; WRITES:
;   RastPort fields (36/38), output via graphics.library
; DESC:
;   Draws an inset frame around text and renders the string with optional pen overrides.
; NOTES:
;   Uses -1 as a sentinel for “no override”.
;------------------------------------------------------------------------------
_SCRIPT_DrawInsetTextWithFrame:
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
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    EXT.L   D0
    MOVE.W  58(A3),D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  28(A7),-(A7)
    MOVE.L  A3,-(A7)
    JSR     _TEXTDISP_JMPTBL_CLEANUP_DrawInsetRectFrame(PC)

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
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
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
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
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