    XDEF    _NEWGRID_ClearHighlightArea


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_ClearHighlightArea   (Clear highlight overlay region)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A6
; CALLS:
;   _LVODisable/_LVOEnable, _GCOMMAND_ResetHighlightMessages, _LVOSetAPen, _LVORectFill
; READS:
;   _NEWGRID_RefreshStateFlag
; WRITES:
;   none
; DESC:
;   Resets highlight message state and fills the highlight area if inactive.
; NOTES:
;   Uses Exec Disable/Enable around message reset.
;------------------------------------------------------------------------------
_NEWGRID_ClearHighlightArea:
    MOVEM.L D2-D3,-(A7)

    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    JSR     _GCOMMAND_ResetHighlightMessages(PC)

    MOVEA.L AbsExecBase,A6
    JSR     _LVOEnable(A6)

    TST.L   _NEWGRID_RefreshStateFlag
    BNE.S   .return

    MOVEA.L _NEWGRID_MainRastPortPtr,A1
    MOVEQ   #7,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    ; Draw a filled rect from 0,68 to 695,267
    MOVEA.L _NEWGRID_MainRastPortPtr,A1
    MOVEQ   #0,D0
    MOVEQ   #68,D1
    MOVE.L  #695,D2
    MOVE.L  #267,D3
    JSR     _LVORectFill(A6)

.return:
    MOVEM.L (A7)+,D2-D3
    RTS

;!======