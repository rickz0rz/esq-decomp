    XDEF    _TLIBA3_BuildDisplayContextForViewMode


;------------------------------------------------------------------------------
; FUNC: _TLIBA3_BuildDisplayContextForViewMode   (_TLIBA3_BuildDisplayContextForViewMode)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +14: arg_2 (via 18(A5))
;   stack +54: arg_3 (via 58(A5))
;   stack +66: arg_4 (via 70(A5))
;   stack +70: arg_5 (via 74(A5))
;   stack +80: arg_6 (via 84(A5))
;   stack +118: arg_7 (via 122(A5))
;   stack +156: arg_8 (via 160(A5))
;   stack +194: arg_9 (via 198(A5))
;   stack +232: arg_10 (via 236(A5))
;   stack +240: arg_11 (via 244(A5))
;   stack +244: arg_12 (via 248(A5))
;   stack +248: arg_13 (via 252(A5))
;   stack +252: arg_14 (via 256(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A5/A7/D0/D1/D2/D3/D5/D6/D7
; CALLS:
;   _TLIBA3_BuildDisplayContextForViewMode, _MATH_Mulu32, _TLIBA3_InitPatternTable, TLIBA3_JMPTBL_GCOMMAND_ApplyHighlightFlag
; READS:
;   LAB_1840, LAB_1847, LAB_1848, LAB_184D, LAB_184E, _ESQ_CopperEffectTemplateRowsSet0, _ESQ_CopperEffectTemplateRowsSet1, _TLIBA1_PatternTableInitGuard, _TLIBA1_CurrentViewModeIndex, _TLIBA3_VmArrayRuntimeTable, _TLIBA3_VmArrayPatternTable, fffe, ffff
; WRITES:
;   _TLIBA1_CurrentViewModeIndex, _WDISP_DisplayContextBase
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_TLIBA3_BuildDisplayContextForViewMode:
    LINK.W  A5,#-256
    MOVEM.L D2-D3/D5-D7/A2,-(A7)
    MOVE.L  8(A5),D7
    MOVE.W  18(A5),D6

    MOVE.L  D7,_TLIBA1_CurrentViewModeIndex
    TST.W   _TLIBA1_PatternTableInitGuard
    BNE.S   .lab_183F

    BSR.W   _TLIBA3_InitPatternTable

.lab_183F:
    MOVE.L  #_ESQ_CopperEffectTemplateRowsSet0,-4(A5)
    MOVE.L  #_ESQ_CopperEffectTemplateRowsSet1,-8(A5)
    MOVE.L  D7,D0
    MOVEQ   #76,D1
    JSR     _MATH_Mulu32(PC)

    LEA     _TLIBA3_VmArrayPatternTable,A0
    ADDA.L  D0,A0
    LEA     -84(A5),A1
    MOVEA.L A1,A2
    MOVEQ   #18,D0

.lab_1840:
    MOVE.L  (A0)+,(A2)+
    DBF     D0,.lab_1840
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    LEA     _TLIBA3_VmArrayRuntimeTable,A0
    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVEQ   #0,D1
    MOVE.W  (A2),D1
    MOVE.L  #$8004,D2
    AND.L   D2,D1
    CMPI.L  #$8004,D1
    BNE.S   .lab_1841

    MOVEQ   #-2,D1
    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVEQ   #0,D0
    MOVE.W  2(A2),D0
    MOVEQ   #15,D2
    ADD.L   D2,D0
    ASR.L   #3,D0
    MOVE.L  #$fffe,D3
    AND.L   D3,D0
    SUBQ.L  #2,D0
    MOVE.L  D0,-248(A5)
    MOVE.L  D1,-244(A5)
    BRA.S   .lab_1844

.lab_1841:
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    MOVEA.L A0,A2
    ADDA.L  D0,A2
    BTST    #7,(A2)
    BEQ.S   .lab_1842

    MOVEQ   #-2,D0
    MOVE.L  D0,-248(A5)
    MOVE.L  D0,-244(A5)
    BRA.S   .lab_1844

.lab_1842:
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    MOVEA.L A0,A2
    ADDA.L  D0,A2
    BTST    #2,1(A2)
    BEQ.S   .lab_1843

    MOVEQ   #0,D1
    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVEQ   #0,D0
    MOVE.W  2(A2),D0
    MOVEQ   #15,D2
    ADD.L   D2,D0
    ASR.L   #3,D0
    MOVE.L  #$fffe,D3
    AND.L   D3,D0
    MOVE.L  D0,-248(A5)
    MOVE.L  D1,-244(A5)
    BRA.S   .lab_1844

.lab_1843:
    MOVEQ   #0,D0
    MOVE.L  D0,-248(A5)
    MOVE.L  D0,-244(A5)

.lab_1844:
    TST.L   D7
    BNE.S   .lab_1845

    MOVEQ   #0,D0
    MOVE.L  D0,-244(A5)
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVEQ   #0,D0
    MOVE.W  2(A2),D0
    MOVEQ   #15,D1
    ADD.L   D1,D0
    ASR.L   #3,D0
    ANDI.L  #$fffe,D0
    MOVE.W  -74(A5),D1
    ADDQ.W  #4,D1
    MOVE.W  D1,-74(A5)
    MOVE.W  -70(A5),D1
    SUBQ.W  #4,D1
    MOVE.W  D1,-70(A5)
    MOVE.L  D0,-248(A5)

.lab_1845:
    MOVEQ   #-1,D0
    CMP.W   D0,D6
    BEQ.S   .lab_1846

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    ANDI.W  #$8fff,D0
    MOVE.L  D6,D1
    EXT.L   D1
    ASL.L   #8,D1
    ASL.L   #4,D1
    OR.L    D1,D0
    MOVE.W  D0,-58(A5)

.lab_1846:
    MOVEA.L A1,A0
    LEA     -160(A5),A2
    MOVEQ   #18,D0

.lab_1847:
    MOVE.L  (A0)+,(A2)+
    DBF     D0,.lab_1847
    LEA     -236(A5),A0
    MOVEQ   #18,D0

.lab_1848:
    MOVE.L  (A1)+,(A0)+
    DBF     D0,.lab_1848
    LEA     -122(A5),A0
    CLR.L   -256(A5)
    MOVE.L  A0,-252(A5)

.lab_1849:
    CMPI.L  #$5,-256(A5)
    BGE.S   .lab_184A

    MOVEQ   #0,D0
    MOVEA.L -252(A5),A0
    MOVE.W  (A0),D0
    SWAP    D0
    CLR.W   D0
    MOVEQ   #0,D1
    MOVE.W  4(A0),D1
    ADD.L   D1,D0
    MOVE.L  D0,D5
    ADD.L   -244(A5),D5
    MOVE.L  D5,D0
    SWAP    D0
    EXT.L   D0
    MOVE.W  D0,(A0)
    MOVE.L  D5,D0
    ANDI.L  #$ffff,D0
    MOVE.W  D0,4(A0)
    ADDQ.L  #8,-252(A5)
    ADDQ.L  #1,-256(A5)
    BRA.S   .lab_1849

.lab_184A:
    LEA     -198(A5),A0
    CLR.L   -256(A5)
    MOVE.L  A0,-252(A5)

.lab_184B:
    CMPI.L  #$5,-256(A5)
    BGE.S   .lab_184C

    MOVEQ   #0,D0
    MOVEA.L -252(A5),A0
    MOVE.W  (A0),D0
    SWAP    D0
    CLR.W   D0
    MOVEQ   #0,D1
    MOVE.W  4(A0),D1
    ADD.L   D1,D0
    MOVE.L  D0,D5
    ADD.L   -248(A5),D5
    MOVE.L  D5,D0
    SWAP    D0
    EXT.L   D0
    MOVE.W  D0,(A0)
    MOVE.L  D5,D0
    ANDI.L  #$ffff,D0
    MOVE.W  D0,4(A0)
    ADDQ.L  #8,-252(A5)
    ADDQ.L  #1,-256(A5)
    BRA.S   .lab_184B

.lab_184C:
    LEA     -160(A5),A0
    MOVEA.L -4(A5),A1
    MOVEQ   #18,D0

.lab_184D:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.lab_184D
    LEA     -236(A5),A0
    MOVEA.L -8(A5),A1
    MOVEQ   #18,D0

.lab_184E:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.lab_184E
    JSR     TLIBA3_JMPTBL_GCOMMAND_ApplyHighlightFlag(PC)

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    LEA     _TLIBA3_VmArrayRuntimeTable,A0
    ADDA.L  D0,A0
    MOVE.L  A0,D0
    MOVEM.L (A7)+,D2-D3/D5-D7/A2
    UNLK    A5
    RTS

;!======

    ; Dead code.
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     -1.W
    MOVE.L  D0,-(A7)
    MOVE.L  _TLIBA1_CurrentViewModeIndex,-(A7)
    BSR.W   _TLIBA3_BuildDisplayContextForViewMode

    LEA     12(A7),A7
    MOVE.L  D0,_WDISP_DisplayContextBase
    MOVE.L  (A7)+,D7
    RTS

;!======