    XDEF    _BRUSH_FreeBrushResources


; Release auxiliary allocations attached to each brush node in the list at A3.
;------------------------------------------------------------------------------
; FUNC: _BRUSH_FreeBrushResources   (Routine at _BRUSH_FreeBrushResources)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A3/A5/A7
; CALLS:
;   _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   _Global_STR_BRUSH_C_9
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_BRUSH_FreeBrushResources:
    LINK.W  A5,#-8
    MOVE.L  A3,-(A7)

    MOVEA.L 8(A5),A3
    CLR.L   -4(A5)
    MOVE.L  (A3),-8(A5)

.free_resources_loop:
    TST.L   -8(A5)
    BEQ.S   .return

    MOVEA.L -8(A5),A0
    MOVE.L  234(A0),-4(A5)
    PEA     238.W
    MOVE.L  A0,-(A7)
    PEA     887.W
    PEA     _Global_STR_BRUSH_C_9
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  -4(A5),-8(A5)
    BRA.S   .free_resources_loop

.return:
    CLR.L   (A3)

    MOVEA.L (A7)+,A3
    UNLK    A5
    RTS

;!======