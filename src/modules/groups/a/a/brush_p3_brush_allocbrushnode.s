    XDEF    _BRUSH_AllocBrushNode


; Allocate a linked brush node and splice it into the optional list at A2.
;------------------------------------------------------------------------------
; FUNC: _BRUSH_AllocBrushNode   (Routine at _BRUSH_AllocBrushNode)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A7/D0
; CALLS:
;   _GROUP_AG_JMPTBL_MEMORY_AllocateMemory
; READS:
;   _BRUSH_LastAllocatedNode, _Global_STR_BRUSH_C_19, MEMF_CLEAR, MEMF_PUBLIC
; WRITES:
;   _BRUSH_LastAllocatedNode
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_BRUSH_AllocBrushNode:
    MOVEM.L A2-A3,-(A7)

    MOVEA.L 12(A7),A3
    MOVEA.L 16(A7),A2
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     238.W
    PEA     1352.W
    PEA     _Global_STR_BRUSH_C_19
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,_BRUSH_LastAllocatedNode   ; expose allocation for cleanup/error handlers
    TST.L   D0
    BEQ.S   .allocnode_return

    MOVEA.L A3,A0
    MOVEA.L D0,A1

.allocnode_copy_header_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .allocnode_copy_header_loop

    MOVEQ   #1,D0
    MOVEA.L _BRUSH_LastAllocatedNode,A0
    MOVE.L  D0,194(A0)
    CLR.B   190(A0)
    MOVEQ   #0,D0
    MOVE.L  D0,222(A0)
    MOVE.L  D0,226(A0)
    MOVE.L  A2,D0
    BEQ.S   .allocnode_link_previous_tail

    MOVE.L  A0,234(A2)

.allocnode_link_previous_tail:
    CLR.L   234(A0)

.allocnode_return:
    MOVE.L  _BRUSH_LastAllocatedNode,D0
    MOVEM.L (A7)+,A2-A3
    RTS

;!======