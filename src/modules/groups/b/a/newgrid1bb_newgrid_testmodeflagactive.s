    XDEF    _NEWGRID_TestModeFlagActive


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_TestModeFlagActive   (Test mode-specific gate flag)
; ARGS:
;   stack +8: D7 = mode selector (0/1)
; RET:
;   D0: 1 if flag set, 0 otherwise
; CLOBBERS:
;   D0-D7
; CALLS:
;   none
; READS:
;   _CONFIG_NewgridSelectionCode34PrimaryEnabledFlag, _CONFIG_NewgridSelectionCode34AltEnabledFlag
; DESC:
;   Returns whether the corresponding global flag is set for the mode.
;------------------------------------------------------------------------------
_NEWGRID_TestModeFlagActive:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    TST.L   D7
    BNE.S   .check_mode1

    MOVE.B  _CONFIG_NewgridSelectionCode34PrimaryEnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BEQ.S   .return_true

.check_mode1:
    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   .return_false

    MOVE.B  _CONFIG_NewgridSelectionCode34AltEnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BEQ.S   .return_true

.return_false:
    MOVEQ   #0,D0
    BRA.S   .return

.return_true:
    MOVEQ   #1,D0

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======