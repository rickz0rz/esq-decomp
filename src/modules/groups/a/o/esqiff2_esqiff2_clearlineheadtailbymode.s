    XDEF    _ESQIFF2_ClearLineHeadTailByMode


;------------------------------------------------------------------------------
; FUNC: _ESQIFF2_ClearLineHeadTailByMode   (Clear primary/secondary line head+tail owned strings by mode)
; ARGS:
;   stack +4: mode (1=primary, 2=secondary)
; RET:
;   D0: replacement pointer from final _ESQPARS_ReplaceOwnedString call
; CLOBBERS:
;   A7/D0/D7
; CALLS:
;   _ESQPARS_ReplaceOwnedString
; READS:
;   _ESQIFF_PrimaryLineHeadPtr, _ESQIFF_PrimaryLineTailPtr, ESQIFF_SecondaryLineHeadPtr, _ESQIFF_SecondaryLineTailPtr
; WRITES:
;   _ESQIFF_PrimaryLineHeadPtr, _ESQIFF_PrimaryLineTailPtr, ESQIFF_SecondaryLineHeadPtr, _ESQIFF_SecondaryLineTailPtr
; DESC:
;   Releases and clears the selected line-head and line-tail owned strings for the
;   requested group mode.
; NOTES:
;   Uses _ESQPARS_ReplaceOwnedString(new=NULL, old=current) for each pointer.
;------------------------------------------------------------------------------
_ESQIFF2_ClearLineHeadTailByMode:
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7
    MOVEQ   #2,D0
    CMP.W   D0,D7
    BNE.S   .clear_primary_line_head_tail

    MOVE.L  ESQIFF_SecondaryLineHeadPtr,-(A7)
    CLR.L   -(A7)
    BSR.W   _ESQPARS_ReplaceOwnedString

    MOVE.L  D0,ESQIFF_SecondaryLineHeadPtr
    MOVE.L  _ESQIFF_SecondaryLineTailPtr,(A7)
    CLR.L   -(A7)
    BSR.W   _ESQPARS_ReplaceOwnedString

    LEA     12(A7),A7
    MOVE.L  D0,_ESQIFF_SecondaryLineTailPtr
    BRA.S   .return_clear_line_head_tail

.clear_primary_line_head_tail:
    MOVE.L  _ESQIFF_PrimaryLineHeadPtr,-(A7)
    CLR.L   -(A7)
    BSR.W   _ESQPARS_ReplaceOwnedString

    MOVE.L  D0,_ESQIFF_PrimaryLineHeadPtr
    MOVE.L  _ESQIFF_PrimaryLineTailPtr,(A7)
    CLR.L   -(A7)
    BSR.W   _ESQPARS_ReplaceOwnedString

    LEA     12(A7),A7
    MOVE.L  D0,_ESQIFF_PrimaryLineTailPtr

.return_clear_line_head_tail:
    MOVE.L  (A7)+,D7
    RTS

;!======