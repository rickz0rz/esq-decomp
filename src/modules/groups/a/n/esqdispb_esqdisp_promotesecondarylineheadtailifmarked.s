    XDEF    _ESQDISP_PromoteSecondaryLineHeadTailIfMarked


;------------------------------------------------------------------------------
; FUNC: _ESQDISP_PromoteSecondaryLineHeadTailIfMarked   (Promote secondary line head/tail pointers when flagged)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A7
; CALLS:
;   _ESQIFF2_ClearLineHeadTailByMode
; READS:
;   _ESQIFF_SecondaryLineHeadPtr, _ESQIFF_SecondaryLineTailPtr, _ESQDISP_SecondaryLinePromotePendingFlag
; WRITES:
;   _ESQIFF_PrimaryLineHeadPtr, _ESQIFF_PrimaryLineTailPtr, _ESQIFF_SecondaryLineHeadPtr, _ESQIFF_SecondaryLineTailPtr, _ESQDISP_SecondaryLinePromotePendingFlag
; DESC:
;   If the secondary line chain is marked pending, clears primary line chain for mode 1,
;   moves secondary head/tail pointers into primary, then clears secondary pointers.
; NOTES:
;   Always clears _ESQDISP_SecondaryLinePromotePendingFlag before return.
;------------------------------------------------------------------------------
_ESQDISP_PromoteSecondaryLineHeadTailIfMarked:
    TST.W   _ESQDISP_SecondaryLinePromotePendingFlag
    BEQ.S   .clear_pending_line_promote_flag

    PEA     1.W
    JSR     _ESQIFF2_ClearLineHeadTailByMode(PC)

    ADDQ.W  #4,A7
    MOVE.L  _ESQIFF_SecondaryLineHeadPtr,_ESQIFF_PrimaryLineHeadPtr
    MOVE.L  _ESQIFF_SecondaryLineTailPtr,_ESQIFF_PrimaryLineTailPtr
    SUBA.L  A0,A0
    MOVE.L  A0,_ESQIFF_SecondaryLineHeadPtr
    MOVE.L  A0,_ESQIFF_SecondaryLineTailPtr

.clear_pending_line_promote_flag:
    CLR.W   _ESQDISP_SecondaryLinePromotePendingFlag
    RTS

;!======