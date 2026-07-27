    XDEF    _PARSEINI_UpdateCtrlHDeltaMax


;------------------------------------------------------------------------------
; FUNC: _PARSEINI_UpdateCtrlHDeltaMax   (UpdateCtrlHDeltaMaxuncertain)
; ARGS:
;   (none)
; RET:
;   D0: current delta (non-negative, wrapped)
; CLOBBERS:
;   D0/D7
; CALLS:
;   (none)
; READS:
;   _CTRL_H, _CTRL_HPreviousSample, _CTRL_HDeltaMax
; WRITES:
;   _CTRL_HDeltaMax
; DESC:
;   Computes _CTRL_H - _CTRL_HPreviousSample (wrapped by +500 if negative) and updates the
;   recorded max delta when the new value exceeds the previous max.
; NOTES:
;   Wrap size 500 suggests a ring buffer or modulo counter.
;------------------------------------------------------------------------------
_PARSEINI_UpdateCtrlHDeltaMax:
    MOVE.L  D7,-(A7)

    MOVEQ   #0,D0
    MOVE.W  _CTRL_H,D0
    MOVEQ   #0,D1
    MOVE.W  _CTRL_HPreviousSample,D1
    SUB.L   D1,D0
    MOVE.L  D0,D7
    TST.L   D7
    BPL.S   .delta_ok

    ADDI.L  #500,D7

.delta_ok:
    MOVEQ   #0,D0
    MOVE.W  _CTRL_HDeltaMax,D0
    CMP.L   D7,D0
    BGE.S   .return_status

    MOVE.L  D7,D0
    MOVE.W  D0,_CTRL_HDeltaMax

.return_status:
    MOVE.L  D7,D0
    MOVE.L  (A7)+,D7
    RTS

;!======