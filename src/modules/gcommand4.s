;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_SaveBrushResult   (Persist the brush list returned from BRUSH_PopulateBrushList into the active slot.)
; ARGS:
;   stack +8: workPtr (brush context)
; RET:
;   (none)
; CLOBBERS:
;   D0, A0, A3, A6
; CALLS:
;   GCOMMAND_JMP_TBL_BRUSH_PopulateBrushList, _LVOForbid,
;   GCOMMAND_JMP_TBL_BRUSH_AppendBrushNode
; READS:
;   190(A3), LAB_1ED3
; WRITES:
;   LAB_1B84, LAB_1ED3
; DESC:
;   Persist the brush list returned from BRUSH_PopulateBrushList into the active slot.
; NOTES:
;   Only swaps LAB_1ED3 when the current brush mode equals 4 and the new list exists.
;------------------------------------------------------------------------------

; Persist the brush list returned from BRUSH_PopulateBrushList into the active slot.
GCOMMAND_SaveBrushResult:
LAB_0DF5:
    LINK.W  A5,#-4
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A5),A3
    CLR.L   -4(A5)
    MOVEQ   #0,D0
    MOVE.B  190(A3),D0
    MOVE.W  D0,LAB_1B84
    PEA     -4(A5)
    MOVE.L  A3,-(A7)
    JSR     GCOMMAND_JMP_TBL_BRUSH_PopulateBrushList(PC)

    ADDQ.W  #8,A7
    MOVE.W  LAB_1B84,D0
    SUBQ.W  #4,D0
    BNE.S   .LAB_0DF6

    TST.L   -4(A5)
    BEQ.S   .LAB_0DF6

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    MOVE.L  -4(A5),-(A7)
    MOVE.L  LAB_1ED3,-(A7)
    JSR     GCOMMAND_JMP_TBL_BRUSH_AppendBrushNode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_1ED3
    ADDQ.L  #1,LAB_1B28
    MOVEA.L AbsExecBase,A6
    JSR     _LVOPermit(A6)

    BRA.S   .LAB_0DF8

.LAB_0DF6:
    MOVE.W  LAB_1B84,D0
    SUBQ.W  #5,D0
    BNE.S   .LAB_0DF7

    TST.L   -4(A5)
    BEQ.S   .LAB_0DF7

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    MOVE.L  -4(A5),-(A7)
    MOVE.L  LAB_1ED2,-(A7)
    JSR     GCOMMAND_JMP_TBL_BRUSH_AppendBrushNode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_1ED2
    ADDQ.L  #1,LAB_1B27
    MOVEA.L AbsExecBase,A6
    JSR     _LVOPermit(A6)

    BRA.S   .LAB_0DF8

.LAB_0DF7:
    MOVE.W  LAB_1B84,D0
    SUBQ.W  #6,D0
    BNE.S   .LAB_0DF8

    TST.L   -4(A5)
    BEQ.S   .LAB_0DF8

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    MOVE.L  -4(A5),LAB_1B25
    JSR     _LVOPermit(A6)

.LAB_0DF8:
    MOVEA.L (A7)+,A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_JMP_TBL_BRUSH_AppendBrushNode   (JumpStub_BRUSH_AppendBrushNode)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   (none)
; CALLS:
;   BRUSH_AppendBrushNode
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to BRUSH_AppendBrushNode.
;------------------------------------------------------------------------------
GCOMMAND_JMP_TBL_BRUSH_AppendBrushNode:
LAB_0DF9:
    JMP     BRUSH_AppendBrushNode

;------------------------------------------------------------------------------
; FUNC: GCOMMAND_JMP_TBL_BRUSH_PopulateBrushList   (JumpStub_BRUSH_PopulateBrushList)
; ARGS:
;   (none)
; RET:
;   D0: ??
; CLOBBERS:
;   (none)
; CALLS:
;   BRUSH_PopulateBrushList
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to BRUSH_PopulateBrushList.
;------------------------------------------------------------------------------
GCOMMAND_JMP_TBL_BRUSH_PopulateBrushList:
LAB_0DFA:
    JMP     BRUSH_PopulateBrushList
