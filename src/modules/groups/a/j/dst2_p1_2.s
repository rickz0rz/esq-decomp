    XDEF    DST_UpdateBannerQueue


;------------------------------------------------------------------------------
; FUNC: DST_UpdateBannerQueue   (Update the rotating banner queue)
; ARGS:
;   (none observed)
; RET:
;   D0: update flag (0/1?)
; CLOBBERS:
;   A0/A3/A7/D0/D1/D6/D7
; CALLS:
;   _DATETIME_UpdateSelectionField, _DST_AddTimeOffset, _DST_AllocateBannerStruct, _DST_RefreshBannerBuffer, _DST_WriteRtcFromGlobals
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
    BSR.S   _DST_WriteRtcFromGlobals

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