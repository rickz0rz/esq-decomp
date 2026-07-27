    XDEF    _BRUSH_FreeBrushList
    XDEF    BRUSH_FreeBrushList_Return



; Walks the BRUSH list at (A3), releasing rasters and child allocations.
;------------------------------------------------------------------------------
; FUNC: _BRUSH_FreeBrushList   (Routine at _BRUSH_FreeBrushList)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +16: arg_4 (via 20(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A5/A7/D0/D1/D2/D3/D6/D7
; CALLS:
;   _GROUP_AB_JMPTBL_GRAPHICS_FreeRaster, _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   _Global_STR_BRUSH_C_5, _Global_STR_BRUSH_C_6, _Global_STR_BRUSH_C_7, BRUSH_FreeBrushList_Return, branch, lab_0121
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_BRUSH_FreeBrushList:
    LINK.W  A5,#-20
    MOVEM.L D2-D3/D6-D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7

    SUBA.L  A0,A0
    MOVE.L  A0,-20(A5)
    MOVE.L  A0,-16(A5)
    TST.L   (A3)
    BEQ.W   BRUSH_FreeBrushList_Return

    MOVE.L  (A3),-8(A5)

.branch:
    TST.L   -8(A5)
    BEQ.W   .lab_0121

    MOVEA.L -8(A5),A0
    MOVE.L  368(A0),-12(A5)
    MOVEQ   #0,D6

.lab_011D:
    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.B  184(A0),D0
    CMP.L   D0,D6
    BGE.S   .lab_011E

    MOVE.L  D6,D0
    ASL.L   #2,D0
    MOVEQ   #0,D1
    MOVE.W  176(A0),D1
    MOVEQ   #0,D2
    MOVE.W  178(A0),D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,D3
    ADDI.L  #$90,D3
    MOVE.L  0(A0,D3.L),-(A7)
    PEA     549.W
    PEA     _Global_STR_BRUSH_C_5
    JSR     _GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(PC)

    LEA     20(A7),A7
    ADDQ.L  #1,D6
    BRA.S   .lab_011D

.lab_011E:
    MOVEA.L -8(A5),A0
    MOVE.L  364(A0),-16(A5)

.branch_1:
    TST.L   -16(A5)
    BEQ.S   .branch_2

    MOVEA.L -16(A5),A0
    MOVE.L  8(A0),-20(A5)
    PEA     12.W
    MOVE.L  A0,-(A7)
    PEA     561.W
    PEA     _Global_STR_BRUSH_C_6
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  -20(A5),-16(A5)
    BRA.S   .branch_1

.branch_2:
    PEA     372.W
    MOVE.L  -8(A5),-(A7)
    PEA     567.W
    PEA     _Global_STR_BRUSH_C_7
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  -12(A5),-8(A5)
    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.W   .branch

.lab_0121:
    MOVE.L  -8(A5),(A3)

;------------------------------------------------------------------------------
; FUNC: BRUSH_FreeBrushList_Return   (Routine at BRUSH_FreeBrushList_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D2
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
BRUSH_FreeBrushList_Return:
    MOVEM.L (A7)+,D2-D3/D6-D7/A3
    UNLK    A5
    RTS

;!======