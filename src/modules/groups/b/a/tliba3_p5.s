    XDEF    _TLIBA3_InitRuntimeEntries
    XDEF    TLIBA3_SetFontForAllViewModes
    XDEF    TLIBA3_JMPTBL_GCOMMAND_ApplyHighlightFlag


;------------------------------------------------------------------------------
; FUNC: _TLIBA3_InitRuntimeEntries   (_TLIBA3_InitRuntimeEntries)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0/D1/D7
; CALLS:
;   _TLIBA3_InitRuntimeEntry
; READS:
;   Global_REF_GRAPHICS_LIBRARY, c300, c304
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_TLIBA3_InitRuntimeEntries:
    MOVE.L  D7,-(A7)

    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A0
    MOVE.W  206(A0),D0
    MOVE.L  D0,D7
    ANDI.W  #2,D7
    MOVEQ   #0,D0
    MOVE.W  D7,D0
    ADDI.L  #$c304,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    PEA     4.W
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    PEA     360.W
    PEA     240.W
    PEA     352.W
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   _TLIBA3_InitRuntimeEntry

    MOVEQ   #0,D0
    MOVE.W  D7,D0
    ADDI.L  #$c304,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    PEA     4.W
    CLR.L   -(A7)
    PEA     16.W
    PEA     240.W
    PEA     352.W
    MOVE.L  D1,-(A7)
    PEA     1.W
    BSR.W   _TLIBA3_InitRuntimeEntry

    MOVEQ   #0,D0
    MOVE.W  D7,D0
    ADDI.L  #$c304,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    PEA     4.W
    CLR.L   -(A7)
    PEA     8.W
    PEA     240.W
    PEA     696.W
    MOVE.L  D1,-(A7)
    PEA     2.W
    BSR.W   _TLIBA3_InitRuntimeEntry

    LEA     84(A7),A7
    MOVEQ   #0,D0
    MOVE.W  D7,D0
    ADDI.L  #$8304,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    PEA     1.W
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     240.W
    PEA     696.W
    MOVE.L  D1,-(A7)
    PEA     3.W
    BSR.W   _TLIBA3_InitRuntimeEntry

    MOVEQ   #0,D0
    MOVE.W  D7,D0
    ADDI.L  #$c304,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVEQ   #4,D0
    MOVE.L  D0,(A7)
    CLR.L   -(A7)
    PEA     44.W
    PEA     240.W
    PEA     640.W
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   _TLIBA3_InitRuntimeEntry

    LEA     52(A7),A7
    MOVE.L  D7,D0
    ADDI.W  #$4304,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVEQ   #5,D0
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    PEA     44.W
    PEA     240.W
    PEA     320.W
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   _TLIBA3_InitRuntimeEntry

    MOVEQ   #0,D0
    MOVE.W  D7,D0
    ADDI.L  #$c300,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    PEA     4.W
    CLR.L   -(A7)
    PEA     44.W
    PEA     120.W
    PEA     640.W
    MOVE.L  D1,-(A7)
    PEA     6.W
    BSR.W   _TLIBA3_InitRuntimeEntry

    LEA     56(A7),A7
    MOVE.L  D7,D0
    ADDI.W  #$4300,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    PEA     5.W
    CLR.L   -(A7)
    PEA     44.W
    PEA     120.W
    PEA     320.W
    MOVE.L  D1,-(A7)
    PEA     7.W
    BSR.W   _TLIBA3_InitRuntimeEntry

    MOVEQ   #0,D0
    MOVE.W  D7,D0
    ADDI.L  #$c304,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    PEA     4.W
    CLR.L   -(A7)
    PEA     16.W
    PEA     296.W
    PEA     320.W
    MOVE.L  D1,-(A7)
    PEA     8.W
    BSR.W   _TLIBA3_InitRuntimeEntry

    LEA     56(A7),A7

    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA3_SetFontForAllViewModes   (TLIBA3_SetFontForAllViewModes)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A6/A7/D0/D1/D7
; CALLS:
;   _MATH_Mulu32, _LVOSetFont
; READS:
;   Global_REF_GRAPHICS_LIBRARY, _TLIBA3_VmArrayRuntimeTable
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
TLIBA3_SetFontForAllViewModes:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7

.lab_1859:
    MOVEQ   #9,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    LEA     _TLIBA3_VmArrayRuntimeTable,A0
    ADDA.L  D0,A0
    LEA     10(A0),A1
    MOVEA.L A3,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    ADDQ.L  #1,D7
    BRA.S   .lab_1859

.return:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA3_JMPTBL_GCOMMAND_ApplyHighlightFlag   (TLIBA3_JMPTBL_GCOMMAND_ApplyHighlightFlag)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   _GCOMMAND_ApplyHighlightFlag
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
TLIBA3_JMPTBL_GCOMMAND_ApplyHighlightFlag:
    JMP     _GCOMMAND_ApplyHighlightFlag

;!======

    ; Alignment
    MOVEQ   #97,D0
