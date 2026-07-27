    XDEF    DST_WriteRtcFromGlobals
    XDEF    DST_HandleBannerCommand32_33
    XDEF    DST_UpdateBannerQueue


;------------------------------------------------------------------------------
; FUNC: DST_HandleBannerCommand32_33   (Handle banner command $32/$33 and enqueue text)
; ARGS:
;   stack +7: arg_1 (via 11(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +18: arg_3 (via 22(A5))
;   stack +40: arg_4 (via 44(A5))
;   stack +48: arg_5 (via 52(A5))
; RET:
;   D0: none
; CLOBBERS:
;   A3/A7/D0/D7
; CALLS:
;   DATETIME_ParseString, DATETIME_CopyPairAndRecalc, DST_UpdateBannerQueue
; READS:
;   DST_BannerWindowSecondary, _DST_BannerWindowPrimary
; WRITES:
;   (none observed)
; DESC:
;   Parses two string segments and enqueues them to the appropriate buffer.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DST_HandleBannerCommand32_33:
    LINK.W  A5,#-44
    MOVEM.L D7/A3,-(A7)
    MOVE.B  11(A5),D7
    MOVEA.L 12(A5),A3
    MOVE.B  D7,D0
    EXT.W   D0
    SUBI.W  #$32,D0
    BEQ.S   .case_cmd_32

    SUBQ.W  #1,D0
    BEQ.S   .case_cmd_33

    BRA.S   .return

.case_cmd_32:
    ; Parse two string segments and enqueue into DST_BannerWindowSecondary.
    PEA     4.W
    MOVE.L  A3,-(A7)
    PEA     -22(A5)
    BSR.W   DATETIME_ParseString

    PEA     19.W
    MOVE.L  A3,-(A7)
    PEA     -44(A5)
    BSR.W   DATETIME_ParseString

    PEA     -44(A5)
    PEA     -22(A5)
    MOVE.L  DST_BannerWindowSecondary,-(A7)
    BSR.W   DATETIME_CopyPairAndRecalc

    LEA     36(A7),A7
    BRA.S   .return

.case_cmd_33:
    ; Parse two string segments and enqueue into _DST_BannerWindowPrimary.
    PEA     4.W
    MOVE.L  A3,-(A7)
    PEA     -22(A5)
    BSR.W   DATETIME_ParseString

    PEA     19.W
    MOVE.L  A3,-(A7)
    PEA     -44(A5)
    BSR.W   DATETIME_ParseString

    PEA     -44(A5)
    PEA     -22(A5)
    MOVE.L  _DST_BannerWindowPrimary,-(A7)
    BSR.W   DATETIME_CopyPairAndRecalc

    LEA     36(A7),A7

.return:
    PEA     _DST_BannerWindowPrimary
    BSR.W   DST_UpdateBannerQueue

    MOVEM.L -52(A5),D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DST_WriteRtcFromGlobals   (Jump stub to PARSEINI RTC write helper)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   GROUP_AJ_JMPTBL_PARSEINI_WriteRtcFromGlobals
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin wrapper that dispatches GROUP_AJ_JMPTBL_PARSEINI_WriteRtcFromGlobals.
; NOTES:
;   Kept as a local stub so DST queue code can call a stable in-module symbol.
;------------------------------------------------------------------------------
DST_WriteRtcFromGlobals:
    JSR     GROUP_AJ_JMPTBL_PARSEINI_WriteRtcFromGlobals(PC)

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DST_UpdateBannerQueue   (Update the rotating banner queue)
; ARGS:
;   (none observed)
; RET:
;   D0: update flag (0/1?)
; CLOBBERS:
;   A0/A3/A7/D0/D1/D6/D7
; CALLS:
;   _DATETIME_UpdateSelectionField, _DST_AddTimeOffset, _DST_AllocateBannerStruct, _DST_RefreshBannerBuffer, DST_WriteRtcFromGlobals
; READS:
;   _DST_PrimaryCountdown, _DST_SecondaryCountdown, _ESQ_SecondarySlotModeFlagChar
; WRITES:
;   _DST_PrimaryCountdown, _DST_SecondaryCountdown
; DESC:
;   Ticks the banner queue timers and refreshes buffers when entries change.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
; Update the rotating banner queue; free resources when entries expire.
DST_UpdateBannerQueue:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEQ   #0,D6
    MOVE.L  A3,D0
    BEQ.W   .return

    ; Slot 0 update: tick timer and free if expired.
    TST.L   (A3)
    BEQ.S   .slot0_empty

    MOVEA.L (A3),A0
    MOVE.W  _DST_PrimaryCountdown,16(A0)
    MOVE.L  (A3),-(A7)
    BSR.W   _DATETIME_UpdateSelectionField

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   .slot0_done

    MOVEA.L (A3),A0
    TST.W   16(A0)
    BEQ.S   .slot0_timer_zero

    MOVEQ   #1,D0
    BRA.S   .slot0_timer_ready

.slot0_timer_zero:
    MOVEQ   #-1,D0

.slot0_timer_ready:
    MOVE.L  D0,D7
    MOVE.L  D7,D0
    EXT.L   D0
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    PEA     _CLOCK_DaySlotIndex
    BSR.W   _DST_AddTimeOffset

    MOVEA.L (A3),A0
    MOVE.W  16(A0),_DST_PrimaryCountdown
    BSR.S   DST_WriteRtcFromGlobals

    LEA     12(A7),A7
    MOVEQ   #1,D6
    BRA.S   .slot0_done

.slot0_empty:
    ; No active entry: count down _DST_PrimaryCountdown and free when it hits 1.
    MOVE.W  _DST_PrimaryCountdown,D0
    SUBQ.W  #1,D0
    BNE.S   .slot0_done

    CLR.L   -(A7)
    PEA     -1.W
    PEA     _CLOCK_DaySlotIndex
    BSR.W   _DST_AddTimeOffset

    LEA     12(A7),A7
    CLR.W   _DST_PrimaryCountdown
    MOVEQ   #1,D6

.slot0_done:
    ; Slot 1 update depends on _ESQ_SecondarySlotModeFlagChar mode.
    MOVE.B  _ESQ_SecondarySlotModeFlagChar,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .slot1_mode_off

    TST.L   4(A3)
    BEQ.S   .slot1_empty

    MOVEA.L 4(A3),A0
    MOVE.W  _DST_SecondaryCountdown,16(A0)
    MOVE.L  4(A3),-(A7)
    BSR.W   _DATETIME_UpdateSelectionField

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   .after_slot1

    MOVEA.L 4(A3),A0
    MOVE.W  16(A0),D0
    MOVE.W  D0,_DST_SecondaryCountdown
    MOVEQ   #1,D6
    BRA.S   .after_slot1

.slot1_empty:
    MOVE.W  _DST_SecondaryCountdown,D0
    SUBQ.W  #1,D0
    BNE.S   .after_slot1

    MOVEQ   #0,D0
    MOVE.W  D0,_DST_SecondaryCountdown
    MOVEQ   #1,D6
    BRA.S   .after_slot1

.slot1_mode_off:
    ; Non-'Y' mode: only refresh slot 1 when timer hits 1.
    MOVE.W  _DST_SecondaryCountdown,D0
    SUBQ.W  #1,D0
    BNE.S   .after_slot1

    MOVE.L  4(A3),-(A7)
    BSR.W   _DST_AllocateBannerStruct

    ADDQ.W  #4,A7
    MOVE.L  D0,4(A3)
    CLR.W   _DST_SecondaryCountdown
    MOVEQ   #1,D6

.after_slot1:
    TST.L   D6
    BEQ.S   .return

    ; At least one slot changed: rebuild the staging buffer.
    BSR.W   _DST_RefreshBannerBuffer

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======