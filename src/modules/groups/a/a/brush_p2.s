    XDEF    BRUSH_PopulateBrushList


; Load every brush descriptor reachable via the singly linked list rooted at A3.
; Successful loads are appended to the list pointed at A2.
;------------------------------------------------------------------------------
; FUNC: BRUSH_PopulateBrushList   (Routine at BRUSH_PopulateBrushList)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +16: arg_3 (via 20(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0
; CALLS:
;   BRUSH_LoadBrushAsset, _BRUSH_NormalizeBrushNames, _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, _LVOForbid, _LVOPermit
; READS:
;   AbsExecBase, Global_STR_BRUSH_C_8
; WRITES:
;   _BRUSH_LoadInProgressFlag, _PARSEINI_ParsedDescriptorListHead
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
BRUSH_PopulateBrushList:
    LINK.W  A5,#-12
    MOVEM.L A2-A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    SUBA.L  A0,A0
    MOVE.L  A0,-12(A5)
    MOVE.L  A0,-8(A5)
    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    MOVEQ   #1,D0
    MOVE.L  D0,_BRUSH_LoadInProgressFlag
    JSR     _LVOPermit(A6)

    CLR.L   (A2)

.populate_loop_next_descriptor:
    MOVE.L  A3,D0
    BEQ.S   .populate_finalize

    MOVE.L  A3,-(A7)
    BSR.W   BRUSH_LoadBrushAsset

    MOVE.L  234(A3),-12(A5)
    PEA     238.W
    MOVE.L  A3,-(A7)
    PEA     845.W
    PEA     Global_STR_BRUSH_C_8
    MOVE.L  D0,-4(A5)
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     20(A7),A7
    MOVEA.L -12(A5),A3
    TST.L   -4(A5)
    BEQ.S   .populate_loop_next_descriptor

    TST.L   (A2)
    BNE.S   .populate_append_to_tail

    MOVEA.L -4(A5),A0
    MOVE.L  A0,(A2)
    BRA.S   .populate_record_tail

.populate_append_to_tail:
    MOVEA.L -4(A5),A0
    MOVEA.L -8(A5),A1
    MOVE.L  A0,368(A1)

.populate_record_tail:
    MOVE.L  A0,-8(A5)
    BRA.S   .populate_loop_next_descriptor

.populate_finalize:
    CLR.L   _PARSEINI_ParsedDescriptorListHead
    MOVE.L  A2,-(A7)
    BSR.W   _BRUSH_NormalizeBrushNames

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    MOVEQ   #0,D0
    MOVE.L  D0,_BRUSH_LoadInProgressFlag
    JSR     _LVOPermit(A6)

    MOVEM.L -20(A5),A2-A3
    UNLK    A5
    RTS

;!======