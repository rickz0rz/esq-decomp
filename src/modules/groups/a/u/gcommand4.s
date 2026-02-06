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
;   GROUP_AU_JMPTBL_BRUSH_PopulateBrushList, _LVOForbid,
;   GROUP_AU_JMPTBL_BRUSH_AppendBrushNode
; READS:
;   190(A3), ESQIFF_LogoBrushListHead
; WRITES:
;   CTASKS_IffTaskState, ESQIFF_LogoBrushListHead
; DESC:
;   Persist the brush list returned from BRUSH_PopulateBrushList into the active slot.
; NOTES:
;   Only swaps ESQIFF_LogoBrushListHead when the current brush mode equals 4 and the new list exists.
;------------------------------------------------------------------------------

; Persist the brush list returned from BRUSH_PopulateBrushList into the active slot.
GCOMMAND_SaveBrushResult:
    LINK.W  A5,#-4
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A5),A3
    CLR.L   -4(A5)
    MOVEQ   #0,D0
    MOVE.B  190(A3),D0
    MOVE.W  D0,CTASKS_IffTaskState
    PEA     -4(A5)
    MOVE.L  A3,-(A7)
    JSR     GROUP_AU_JMPTBL_BRUSH_PopulateBrushList(PC)

    ADDQ.W  #8,A7
    MOVE.W  CTASKS_IffTaskState,D0
    SUBQ.W  #4,D0
    BNE.S   .lab_0DF6

    TST.L   -4(A5)
    BEQ.S   .lab_0DF6

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    MOVE.L  -4(A5),-(A7)
    MOVE.L  ESQIFF_LogoBrushListHead,-(A7)
    JSR     GROUP_AU_JMPTBL_BRUSH_AppendBrushNode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,ESQIFF_LogoBrushListHead
    ADDQ.L  #1,ESQIFF_LogoBrushListCount
    MOVEA.L AbsExecBase,A6
    JSR     _LVOPermit(A6)

    BRA.S   .lab_0DF8

.lab_0DF6:
    MOVE.W  CTASKS_IffTaskState,D0
    SUBQ.W  #5,D0
    BNE.S   .lab_0DF7

    TST.L   -4(A5)
    BEQ.S   .lab_0DF7

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    MOVE.L  -4(A5),-(A7)
    MOVE.L  ESQIFF_GAdsBrushListHead,-(A7)
    JSR     GROUP_AU_JMPTBL_BRUSH_AppendBrushNode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,ESQIFF_GAdsBrushListHead
    ADDQ.L  #1,ESQIFF_GAdsBrushListCount
    MOVEA.L AbsExecBase,A6
    JSR     _LVOPermit(A6)

    BRA.S   .lab_0DF8

.lab_0DF7:
    MOVE.W  CTASKS_IffTaskState,D0
    SUBQ.W  #6,D0
    BNE.S   .lab_0DF8

    TST.L   -4(A5)
    BEQ.S   .lab_0DF8

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    MOVE.L  -4(A5),WDISP_WeatherStatusBrushListHead
    JSR     _LVOPermit(A6)

.lab_0DF8:
    MOVEA.L (A7)+,A3
    UNLK    A5
    RTS
