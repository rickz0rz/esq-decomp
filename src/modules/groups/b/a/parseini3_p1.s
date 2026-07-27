    XDEF    _PARSEINI_CheckCtrlHChange


;------------------------------------------------------------------------------
; FUNC: _PARSEINI_CheckCtrlHChange
; ARGS:
;   (none)
; RET:
;   D0: boolean (nonzero when change detected and action taken)
; CLOBBERS:
;   D0-D2/D7
; CALLS:
;   _SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh
; READS:
;   _CTRL_H, _CTRL_HPreviousSample, _PARSEINI_CtrlHChangeGateFlag, _PARSEINI_CtrlHClockSnapshot-20A8, PARSEINI_ClockChangeActiveFlag
; WRITES:
;   _PARSEINI_CtrlHClockSnapshot-20A8
; DESC:
;   Compares current _CTRL_H to previous value, optionally triggers _SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh when
;   changes are detected and control flags permit.
; NOTES:
;   Uses _PARSEINI_CtrlHChangeGateFlag as gate; resets PARSEINI_ClockChangeActiveFlag when no change.
;------------------------------------------------------------------------------
_PARSEINI_CheckCtrlHChange:
    MOVEM.L D2/D7,-(A7)

    MOVEQ   #0,D7
    MOVE.W  _CTRL_H,D0
    MOVE.W  _CTRL_HPreviousSample,D1
    CMP.W   D1,D0
    SNE     D2
    NEG.B   D2
    EXT.W   D2
    EXT.L   D2
    MOVE.L  D2,D7
    TST.W   D7
    BEQ.S   .no_change_or_gate_closed

    TST.W   _PARSEINI_CtrlHChangeGateFlag
    BEQ.S   .no_change_or_gate_closed

    MOVE.W  _Global_REF_CLOCKDATA_STRUCT,_PARSEINI_CtrlHClockSnapshot
    CLR.W   _PARSEINI_CtrlHChangeGateCounter
    MOVEQ   #1,D0
    CMP.W   _PARSEINI_CtrlHChangePendingFlag,D0
    BEQ.S   .return

    PEA     1.W
    PEA     16.W
    MOVE.W  D0,_PARSEINI_CtrlHChangePendingFlag
    JSR     _SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(PC)

    ADDQ.W  #8,A7
    BRA.S   .return

.no_change_or_gate_closed:
    TST.W   _PARSEINI_CtrlHChangePendingFlag
    BEQ.S   .return

    MOVE.W  _Global_REF_CLOCKDATA_STRUCT,D0
    MOVE.W  _PARSEINI_CtrlHClockSnapshot,D1
    CMP.W   D0,D1
    BEQ.S   .return

    MOVE.W  D0,_PARSEINI_CtrlHClockSnapshot
    TST.W   _PARSEINI_CtrlHChangeGateFlag
    BEQ.S   .clear_ctrlh_pending

    ADDQ.W  #1,_PARSEINI_CtrlHChangeGateCounter
    CMPI.W  #3,_PARSEINI_CtrlHChangeGateCounter
    BLT.S   .return

.clear_ctrlh_pending:
    CLR.W   _PARSEINI_CtrlHChangePendingFlag
    CLR.L   -(A7)
    PEA     16.W
    JSR     _SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(PC)

    ADDQ.W  #8,A7

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D2/D7
    RTS
