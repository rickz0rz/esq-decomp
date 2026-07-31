    XDEF    _PARSEINI_UpdateClockFromRtc


;------------------------------------------------------------------------------
; FUNC: _PARSEINI_UpdateClockFromRtc   (UpdateClockFromRtcuncertain)
; ARGS:
;   (none)
; RET:
;   D0: none (status is implicit via globals)
; CLOBBERS:
;   D0-D7/A0-A1
; CALLS:
;   _PARSEINI2_JMPTBL_BATTCLOCK_GetSecondsFromBatteryBackedClock, _PARSEINI2_JMPTBL_CLOCK_ConvertAmigaSecondsToClockData,
;   _PARSEINI2_JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch, _PARSEINI_NormalizeClockData
; READS:
;   _Global_REF_UTILITY_LIBRARY, _Global_REF_BATTCLOCK_RESOURCE
; WRITES:
;   _CLOCK_DaySlotIndex (date/time fields via _PARSEINI_NormalizeClockData)
; DESC:
;   Reads the battery-backed clock, validates the resulting date/time fields,
;   and updates the global date/time structure used by the UI.
; NOTES:
;   If the clock data is invalid or unavailable, a fallback/default is written.
;------------------------------------------------------------------------------
_PARSEINI_UpdateClockFromRtc:
    LINK.W  A5,#-40
    MOVEM.L D2-D7,-(A7)

.clockData  = -18
.localSec   = -28
.localMin   = -30
.localHour  = -32
.localYear  = -34
.localMDay  = -36
.localMonth = -38
.localWDay  = -40

    TST.L   _Global_REF_UTILITY_LIBRARY
    BEQ.W   .return_status

    TST.L   _Global_REF_BATTCLOCK_RESOURCE
    BEQ.W   .return_status

    JSR     _PARSEINI2_JMPTBL_BATTCLOCK_GetSecondsFromBatteryBackedClock(PC)

    MOVE.L  D0,D7
    PEA     .clockData(A5)
    MOVE.L  D7,-(A7)
    JSR     _PARSEINI2_JMPTBL_CLOCK_ConvertAmigaSecondsToClockData(PC)

    PEA     .clockData(A5)
    JSR     _PARSEINI2_JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch(PC)

    LEA     12(A7),A7
    TST.L   D0
    BEQ.W   .fallback_default_date

    MOVE.W  (.clockData+Struct_ClockData__WDay)(A5),D0
    MOVE.W  D0,.localWDay(A5)

    MOVE.W  (.clockData+Struct_ClockData__Month)(A5),D1
    MOVE.L  D1,D2
    SUBQ.W  #1,D2
    MOVE.W  D2,.localMonth(A5)  ; -1 because the index of the jump table.

    MOVE.W  (.clockData+Struct_ClockData__MDay)(A5),D2
    MOVE.L  D2,D3
    SUBQ.W  #1,D3
    MOVE.W  D3,.localMDay(A5)   ; -1 because the index of the jump table.

    MOVE.W  (.clockData+Struct_ClockData__Year)(A5),D3
    MOVE.W  D3,.localYear(A5)

    MOVE.W  (.clockData+Struct_ClockData__Hour)(A5),D4
    MOVE.W  D4,.localHour(A5)

    MOVE.W  (.clockData+Struct_ClockData__Min)(A5),D5
    MOVE.W  D5,.localMin(A5)

    MOVE.W  (.clockData+Struct_ClockData__Sec)(A5),D6
    MOVE.W  D6,.localSec(A5)

    MOVE.W  _DST_PrimaryCountdown,-26(A5)

    MOVEQ   #0,D6
    CMP.W   D6,D0
    BCS.S   .invalid_date_data

    MOVEQ   #6,D5
    CMP.W   D5,D0
    BHI.S   .invalid_date_data

    CMP.W   D6,D1
    BCS.S   .invalid_date_data

    MOVEQ   #11,D0      ; Month?
    CMP.W   D0,D1
    BHI.S   .invalid_date_data

    CMP.W   D6,D2
    BCS.S   .invalid_date_data

    MOVEQ   #31,D0      ; Day number
    CMP.W   D0,D2
    BHI.S   .invalid_date_data

    CMP.W   D6,D3
    BCS.S   .invalid_date_data

    CMPI.W  #9999,D3    ; Year
    BHI.S   .invalid_date_data

    CMP.W   D6,D4
    BCS.S   .invalid_date_data

    MOVEQ   #23,D0      ; Hour
    CMP.W   D0,D4
    BHI.S   .invalid_date_data

    MOVE.W  -16(A5),D0
    CMP.W   D6,D0
    BCS.S   .invalid_date_data

    MOVEQ   #59,D1      ; Minutes
    CMP.W   D1,D0
    BHI.S   .invalid_date_data

    MOVE.W  -18(A5),D0
    CMP.W   D6,D0
    BCS.S   .invalid_date_data

    CMP.W   D1,D0

.invalid_date_data:
    PEA     -40(A5)
    PEA     _CLOCK_DaySlotIndex
    BSR.W   _PARSEINI_NormalizeClockData

    ADDQ.W  #8,A7
    BRA.S   .return_status

.fallback_default_date:
    PEA     _PARSEINI_FallbackClockDataRecord
    PEA     _CLOCK_DaySlotIndex
    BSR.W   _PARSEINI_NormalizeClockData

    ADDQ.W  #8,A7

.return_status:
    MOVEM.L (A7)+,D2-D7
    UNLK    A5
    RTS

;!======