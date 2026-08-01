    XDEF    _TLIBA3_InitRuntimeEntry


;------------------------------------------------------------------------------
; FUNC: _TLIBA3_InitRuntimeEntry   (_TLIBA3_InitRuntimeEntry)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +10: arg_2 (via 14(A5))
;   stack +14: arg_3 (via 18(A5))
;   stack +18: arg_4 (via 22(A5))
;   stack +22: arg_5 (via 26(A5))
;   stack +26: arg_6 (via 30(A5))
;   stack +31: arg_7 (via 35(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D2/D4/D5/D6/D7
; CALLS:
;   _MATH_Mulu32, _LVOInitBitMap
; READS:
;   _Global_REF_GRAPHICS_LIBRARY, _Global_REF_RASTPORT_1, LAB_1854, _WDISP_DisplayContextPlanePointer0, _TLIBA3_VmArrayRuntimeTable
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_TLIBA3_InitRuntimeEntry:
    LINK.W  A5,#-4
    MOVEM.L D2/D4-D7/A2-A3,-(A7)
    MOVE.L  8(A5),D7
    MOVE.W  14(A5),D6
    MOVE.W  18(A5),D5
    MOVE.W  22(A5),D4
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    LEA     _TLIBA3_VmArrayRuntimeTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  D6,(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  D5,2(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  D4,4(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  26(A5),6(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.W  30(A5),8(A1)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    LEA     10(A1),A2
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #24,D1

.lab_1854:
    MOVE.L  (A1)+,(A2)+
    DBF     D1,.lab_1854
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L A0,A2
    ADDA.L  D0,A2
    LEA     110(A2),A3
    MOVE.L  A3,14(A1)
    ADDA.L  D0,A0
    LEA     110(A0),A1
    MOVEQ   #0,D0
    MOVE.B  35(A5),D0
    MOVEQ   #0,D1
    MOVE.W  D5,D1
    MOVEQ   #0,D2
    MOVE.W  D4,D2
    MOVEA.L A1,A0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitBitMap(A6)

    CLR.L   -4(A5)

.lab_1855:
    MOVE.L  -4(A5),D0
    MOVEQ   #5,D1
    CMP.L   D1,D0
    BGE.S   .lab_1856

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    LEA     _TLIBA3_VmArrayRuntimeTable,A0
    ADDA.L  D0,A0
    MOVE.L  -4(A5),D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    LEA     _WDISP_DisplayContextPlanePointer0,A1
    ADDA.L  D0,A1
    MOVE.L  (A1),118(A0)
    ADDQ.L  #1,-4(A5)
    BRA.S   .lab_1855

.lab_1856:
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    LEA     _TLIBA3_VmArrayRuntimeTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #0,D1
    MOVE.W  D1,150(A1)
    ADDA.L  D0,A0
    MOVE.W  D1,152(A0)
    MOVEM.L (A7)+,D2/D4-D7/A2-A3
    UNLK    A5
    RTS

;!======