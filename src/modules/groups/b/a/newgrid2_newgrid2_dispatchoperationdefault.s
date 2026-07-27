    XDEF    _NEWGRID2_DispatchOperationDefault


;------------------------------------------------------------------------------
; FUNC: _NEWGRID2_DispatchOperationDefault   (Dispatch default grid operation)
; ARGS:
;   none
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A3
; CALLS:
;   _NEWGRID2_DispatchGridOperation
; DESC:
;   Dispatches the grid operation with zeroed inputs.
;------------------------------------------------------------------------------
_NEWGRID2_DispatchOperationDefault:
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    BSR.W   _NEWGRID2_DispatchGridOperation

    LEA     16(A7),A7
    RTS

;!======