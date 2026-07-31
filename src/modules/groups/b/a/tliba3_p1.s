    XDEF    _TLIBA3_DrawHorizontalScaleTicks



;------------------------------------------------------------------------------
; FUNC: _TLIBA3_DrawHorizontalScaleTicks   (_TLIBA3_DrawHorizontalScaleTicks)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +80: arg_3 (via 84(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A6/A7/D0/D1/D5/D6/D7
; CALLS:
;   _MATH_DivS32, _MATH_Mulu32, _WDISP_SPrintf, _LVODraw, _LVOMove, _LVOText, _LVOTextLength
; READS:
;   Global_REF_GRAPHICS_LIBRARY, LAB_182E, LAB_1832, TLIBA1_FMT_PCT_03LD_HorizontalScaleTick, return
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_TLIBA3_DrawHorizontalScaleTicks:
    LINK.W  A5,#-92
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7

    MOVE.L  D7,D5
    MOVEQ   #25,D0
    ADD.L   D0,D5
    MOVEA.L A3,A1
    MOVE.L  D7,D1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L 4(A3),A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    ASL.L   #3,D0
    SUBQ.L  #1,D0
    MOVEA.L A3,A1
    MOVE.L  D7,D1
    JSR     _LVODraw(A6)

    MOVEQ   #0,D6

.lab_182E:
    MOVEA.L 4(A3),A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    ASL.L   #3,D0
    SUBQ.L  #1,D0
    CMP.L   D0,D6
    BGE.W   .return

    MOVE.L  D6,D0
    MOVEQ   #25,D1
    JSR     _MATH_DivS32(PC)

    TST.L   D1
    BNE.W   .lab_1832

    TST.L   D6
    BEQ.W   .lab_1832

    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVE.L  D7,D1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    MOVEQ   #20,D1
    ADD.L   D1,D0
    MOVE.L  D0,16(A7)
    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVE.L  16(A7),D1
    JSR     _LVODraw(A6)

    MOVE.L  D6,-(A7)
    PEA     TLIBA1_FMT_PCT_03LD_HorizontalScaleTick
    PEA     -84(A5)
    JSR     _WDISP_SPrintf(PC)

    LEA     12(A7),A7
    LEA     -84(A5),A0
    MOVEA.L A0,A1

.lab_182F:
    TST.B   (A1)+
    BNE.S  .lab_182F

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,16(A7)
    MOVEA.L A3,A1
    MOVE.L  16(A7),D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    TST.L   D0
    BPL.S   .lab_1830

    ADDQ.L  #1,D0

.lab_1830:
    ASR.L   #1,D0
    MOVE.L  D6,D1
    SUB.L   D0,D1
    MOVE.L  D6,D0
    MOVE.L  D1,16(A7)
    MOVEQ   #2,D1
    JSR     _MATH_DivS32(PC)

    MOVEQ   #10,D0
    JSR     _MATH_Mulu32(PC)

    MOVE.L  D5,D1
    ADD.L   D0,D1
    MOVEA.L A3,A1
    MOVE.L  16(A7),D0
    JSR     _LVOMove(A6)

    LEA     -84(A5),A0
    MOVEA.L A0,A1

.lab_1831:
    TST.B   (A1)+
    BNE.S   .lab_1831

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,16(A7)
    MOVEA.L A3,A1
    MOVE.L  16(A7),D0
    JSR     _LVOText(A6)

    BRA.S   .lab_1833

.lab_1832:
    MOVE.L  D6,D0
    MOVEQ   #5,D1
    JSR     _MATH_DivS32(PC)

    TST.L   D1
    BNE.S   .lab_1833

    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVE.L  D7,D1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVE.L  D7,D0
    MOVEQ   #10,D1
    ADD.L   D1,D0
    MOVE.L  D0,16(A7)
    MOVEA.L A3,A1
    MOVE.L  D6,D0
    MOVE.L  16(A7),D1
    JSR     _LVODraw(A6)

.lab_1833:
    ADDQ.L  #1,D6
    BRA.W   .lab_182E

.return:
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======