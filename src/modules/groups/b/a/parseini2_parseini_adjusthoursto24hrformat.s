    XDEF    _PARSEINI_AdjustHoursTo24HrFormat


;------------------------------------------------------------------------------
; FUNC: _PARSEINI_AdjustHoursTo24HrFormat   (12h→24h adjust helper)
; ARGS:
;   stack +14: D7 = hour (0-12?)
;   stack +18: D6 = AM/PM flag? (-1 for PM)
; RET:
;   D0: adjusted hour (long)
; CLOBBERS:
;   D0/D1/D6-D7
; CALLS:
;   none
; READS/WRITES:
;   none (pure)
; DESC:
;   Converts 12-hour clock fields to 24-hour format: returns 0 for 12 AM,
;   adds 12 when PM flag is set and hour < 12.
; NOTES:
;   Expects flag -1 to indicate PM; keeps hour unchanged otherwise.
;------------------------------------------------------------------------------
_PARSEINI_AdjustHoursTo24HrFormat:
    MOVEM.L D6-D7,-(A7)
    MOVE.W  14(A7),D7
    MOVE.W  18(A7),D6

    ; If we're over 12 hours, jump.
    MOVEQ   #12,D0
    CMP.W   D0,D7
    BNE.S   .add12ToHour

    ; If D6 is not 0, jump.
    TST.W   D6
    BNE.S   .add12ToHour

    ; Return 0 if we're 12 AM.
    MOVEQ   #0,D7
    BRA.S   .return

.add12ToHour:
    CMP.W   D0,D7
    BGE.S   .return

    MOVEQ   #-1,D1
    CMP.W   D1,D6
    BNE.S   .return

    ADDI.W  #12,D7

.return:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEM.L (A7)+,D6-D7
    RTS

;!======