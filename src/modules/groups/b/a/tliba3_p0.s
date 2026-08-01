    XDEF    _TLIBA3_DrawCenteredWrappedTextLines


;------------------------------------------------------------------------------
; FUNC: _TLIBA3_DrawCenteredWrappedTextLines   (_TLIBA3_DrawCenteredWrappedTextLines)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +9: arg_3 (via 13(A5))
;   stack +10: arg_4 (via 14(A5))
;   stack +11: arg_5 (via 15(A5))
;   stack +12: arg_6 (via 16(A5))
;   stack +13: arg_7 (via 17(A5))
;   stack +14: arg_8 (via 18(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D5/D6/D7
; CALLS:
;   _UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition, _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd, _LVOTextLength
; READS:
;   _Global_REF_GRAPHICS_LIBRARY, LAB_181F
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_TLIBA3_DrawCenteredWrappedTextLines:
    LINK.W  A5,#-20
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  16(A5),D7
    CLR.B   -18(A5)

    MOVE.B  28(A3),-15(A5)
    MOVE.B  25(A3),-16(A5)
    MOVE.B  26(A3),-17(A5)
    MOVE.B  24(A3),-14(A5)
    MOVEA.L 4(A3),A0
    MOVE.B  5(A0),-13(A5)
    MOVEA.L A3,A1

    MOVEQ   #1,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L A3,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEQ   #7,D0
    JSR     _LVOSetBPen(A6)

    MOVEA.L 4(A3),A0
    MOVEQ   #0,D5
    MOVE.W  (A0),D5
    ASL.L   #3,D5

.lab_181F:
    MOVEA.L A2,A0

.lab_1820:
    TST.B   (A0)+
    BNE.S   .lab_1820

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,-12(A5)

.lab_1821:
    MOVE.L  -12(A5),D0
    TST.L   D0
    BLE.S   .lab_1823

    MOVEA.L A3,A1
    MOVEA.L A2,A0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D5,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .lab_1822

    ADDQ.L  #1,D1

.lab_1822:
    ASR.L   #1,D1
    MOVE.L  D1,D6
    BGE.S   .lab_1823

    SUBQ.L  #1,-12(A5)
    BRA.S   .lab_1821

.lab_1823:
    TST.B   -18(A5)
    BEQ.S   .lab_1824

    MOVEQ   #0,D0
    BRA.S   .lab_1825

.lab_1824:
    MOVE.L  -12(A5),D0
    MOVE.B  0(A2,D0.L),D0
    EXT.W   D0
    EXT.L   D0

.lab_1825:
    MOVE.L  -12(A5),D1
    CLR.B   0(A2,D1.L)
    MOVE.B  D0,-18(A5)
    TST.L   D6
    BMI.S   .lab_1826

    MOVE.L  A2,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  A3,-(A7)
    JSR     _UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7

.lab_1826:
    MOVEA.L 52(A3),A0
    MOVEQ   #0,D0
    MOVE.W  20(A0),D0
    ADDQ.L  #1,D0
    ADD.L   D0,D7
    MOVEA.L A2,A0
    ADDA.L  -12(A5),A0
    MOVE.B  -18(A5),(A0)
    MOVEA.L A0,A2
    TST.B   (A2)
    BNE.W   .lab_181F

    MOVE.B  -16(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A3,A1
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.B  -17(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A3,A1
    JSR     _LVOSetBPen(A6)

    MOVE.B  -15(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A3,A1
    JSR     _LVOSetDrMd(A6)

    MOVE.B  -14(A5),24(A3)
    MOVEA.L 4(A3),A0
    MOVE.B  -13(A5),5(A0)

    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======