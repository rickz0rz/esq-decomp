    XDEF    _ESQ_GetHalfHourSlotIndex


;------------------------------------------------------------------------------
; FUNC: _ESQ_GetHalfHourSlotIndex   (GetHalfHourSlotIndexuncertain)
; ARGS:
;   stack +4: timePtr (struct with time fields)
; RET:
;   D0: slot index (mapped through _CLOCK_HalfHourSlotLookup)
; CLOBBERS:
;   D0-D2, A1
; CALLS:
;   (none)
; READS:
;   8(A0), 10(A0), 18(A0), _CLOCK_HalfHourSlotLookup
; WRITES:
;   (none)
; DESC:
;   Computes a half-hour slot for the time and returns a lookup-mapped value.
; NOTES:
;   Slot = hour*2 (+1 if minutes >= 30), with 12-hour and AM/PM handling.
;------------------------------------------------------------------------------
_ESQ_GetHalfHourSlotIndex:
    MOVEA.L 4(A7),A0
    MOVE.L  D2,-(A7)
    MOVEQ   #0,D0
    MOVEQ   #12,D1
    MOVE.W  8(A0),D0
    TST.W   18(A0)
    BPL.S   .normalize_midnight

    ADD.W   D1,D0
    BRA.S   .wrap_24h

.normalize_midnight:
    CMP.W   D1,D0
    BNE.S   .wrap_24h

    MOVEQ   #0,D0

.wrap_24h:
    MOVEQ   #24,D1
    CMP.W   D1,D0
    BEQ.S   .maybe_add_half

    ADD.W   D0,D0

.maybe_add_half:
    MOVE.W  10(A0),D2
    MOVEQ   #30,D1
    CMP.W   D1,D2
    BLT.S   .return

    ADDQ.W  #1,D0

.return:
    LEA     _CLOCK_HalfHourSlotLookup,A1
    MOVE.B  0(A1,D0.W),D0
    MOVE.L  (A7)+,D2
    RTS

;!======