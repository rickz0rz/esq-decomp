    XDEF    _TLIBA2_ResolveEntryWindowWithDefaultRange


;------------------------------------------------------------------------------
; FUNC: _TLIBA2_ResolveEntryWindowWithDefaultRange   (Wrapper with zeroed range outputs)
; ARGS:
;   stack +8: A3 = primary entry state/context pointer
;   stack +12: A2 = secondary entry table pointer
;   stack +16: D7 = entry index
; RET:
;   D0: result/status from _TLIBA2_ResolveEntryWindowAndSlotCount
; CLOBBERS:
;   D0/D7/A2-A3
; CALLS:
;   _TLIBA2_ResolveEntryWindowAndSlotCount
; DESC:
;   Convenience wrapper that forwards to _TLIBA2_ResolveEntryWindowAndSlotCount
;   with both output-range arguments set to zero.
;------------------------------------------------------------------------------
_TLIBA2_ResolveEntryWindowWithDefaultRange:
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEA.L 20(A7),A2
    MOVE.L  24(A7),D7
    CLR.L   -(A7)
    CLR.L   -(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _TLIBA2_ResolveEntryWindowAndSlotCount

    LEA     20(A7),A7
    MOVEM.L (A7)+,D7/A2-A3
    RTS

;!======