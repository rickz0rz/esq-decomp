    XDEF    PARSEINI_MonitorClockChange


;------------------------------------------------------------------------------
; FUNC: PARSEINI_MonitorClockChange   (Monitor clock-change edge and status mask)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0-D2/D7
; CALLS:
;   _SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh
; READS:
;   _Global_WORD_H_VALUE, _Global_WORD_T_VALUE, _Global_REF_CLOCKDATA_STRUCT,
;   PARSEINI_ClockSecondsSnapshot-20A8
; WRITES:
;   PARSEINI_ClockSecondsSnapshot-20A8
; DESC:
;   Tracks transitions between H/T mismatch and stable states, latches RTC second
;   samples, and toggles a status-mask bit via ESQDISP_UpdateStatusMaskAndRefresh.
; NOTES:
;   Uses a 3-sample threshold before clearing PARSEINI_ClockChangeActiveFlag.
;------------------------------------------------------------------------------
PARSEINI_MonitorClockChange:
    MOVEM.L D2/D7,-(A7)

    MOVEQ   #0,D7       ; Prefill D7 with 0x00000000
    MOVE.W  _Global_WORD_H_VALUE,D0     ; Not sure what these two bytes are but they're stored into D0 and D1
    MOVE.W  _Global_WORD_T_VALUE,D1
    CMP.W   D1,D0       ; Compare D1 and D0 (D1 - D0)
    SNE     D2          ; If the zero flag is set (they're equal), D2 is 0xFF else 0x00
    NEG.B   D2          ; negate the above. now, zero flag is 0x00 else 0xFF
    EXT.W   D2          ; extend most significant byte D2 to a word... so now D2 is either 0x0000 or 0xFFFF
    EXT.L   D2          ; then again sign extend D2 to a longword (0x00000000 or 0xFFFFFFFF)
    MOVE.L  D2,D7       ; Move D2 into D7
    TST.W   D7          ; Test D7 against 0
    BEQ.S   .check_clockdata_update   ; If D7 is now 0, jump to .check_clockdata_update

    MOVE.W  _Global_REF_CLOCKDATA_STRUCT,PARSEINI_ClockSecondsSnapshot  ; Get the first word of the clockdata struct, which is seconds
    MOVEQ   #1,D0               ; Move 1 into D0
    CMP.W   PARSEINI_ClockChangeActiveFlag,D0         ; Compare PARSEINI_ClockChangeActiveFlag - D0 (1)
    BEQ.S   .return             ; If PARSEINI_ClockChangeActiveFlag was 1, then return

    MOVEQ   #1,D1           ; Push 1 into D1
    MOVE.L  D1,-(A7)        ; Push D1 onto the stack
    MOVE.L  D1,-(A7)        ; Push it again onto the stack
    MOVE.W  D0,PARSEINI_ClockChangeActiveFlag     ; Push the least 2 sig bytes in D0 into PARSEINI_ClockChangeActiveFlag
    JSR     _SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(PC)    ; JSR

    ADDQ.W  #8,A7           ; Add 8 to whatever value is in the stack (the stack pointer) clearing the last two values in the stack (D1 x2).
    BRA.S   .return

.check_clockdata_update:
    TST.W   PARSEINI_ClockChangeActiveFlag
    BEQ.S   .return

    MOVE.W  _Global_REF_CLOCKDATA_STRUCT,D0
    MOVE.W  PARSEINI_ClockSecondsSnapshot,D1
    CMP.W   D0,D1
    BEQ.S   .return

    ADDQ.W  #1,PARSEINI_ClockChangeSampleCounter
    MOVE.W  D0,PARSEINI_ClockSecondsSnapshot
    CMPI.W  #3,PARSEINI_ClockChangeSampleCounter
    BLT.S   .return

    CLR.W   PARSEINI_ClockChangeActiveFlag
    CLR.L   -(A7)
    PEA     1.W
    JSR     _SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(PC)

    ADDQ.W  #8,A7

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D2/D7
    RTS

;!======