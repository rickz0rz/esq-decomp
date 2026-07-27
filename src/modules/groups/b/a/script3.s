    XDEF    GENERATE_GRID_DATE_STRING





;!======

;------------------------------------------------------------------------------
; FUNC: GENERATE_GRID_DATE_STRING   (GenerateGridDateStringuncertain)
; ARGS:
;   stack +8: outBuffer (char *)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1/A0-A1/A3
; CALLS:
;   _PARSEINI_JMPTBL_WDISP_SPrintf
; READS:
;   _CLOCK_CurrentDayOfWeekIndex/2275/2276/2277, Global_JMPTBL_DAYS_OF_WEEK, Global_JMPTBL_MONTHS
; WRITES:
;   outBuffer
; DESC:
;   Formats the current grid date string into outBuffer.
; NOTES:
;   Uses Global_STR_GRID_DATE_FORMAT_STRING as the template.
;------------------------------------------------------------------------------
GENERATE_GRID_DATE_STRING:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3

    MOVE.W  _CLOCK_CurrentDayOfWeekIndex,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     Global_JMPTBL_DAYS_OF_WEEK,A0
    ADDA.L  D0,A0
    MOVE.W  _CLOCK_CurrentMonthIndex,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     Global_JMPTBL_MONTHS,A1
    ADDA.L  D0,A1
    MOVE.W  _CLOCK_CurrentDayOfMonth,D0
    EXT.L   D0
    MOVE.W  _CLOCK_CurrentYearValue,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  (A1),-(A7)
    MOVE.L  (A0),-(A7)
    PEA     Global_STR_GRID_DATE_FORMAT_STRING
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_WDISP_SPrintf(PC)

    LEA     24(A7),A7
    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_CopyWeatherUpdateForString   (CopyWeatherUpdateForStringuncertain)
; ARGS:
;   stack +8: outBuffer (char *)
; RET:
;   (none)
; CLOBBERS:
;   A0-A1/A3
; CALLS:
;   (none)
; READS:
;   Global_STR_WEATHER_UPDATE_FOR
; WRITES:
;   outBuffer
; DESC:
;   Copies the "Weather Update For" string into outBuffer.
; NOTES:
;   Previously unlabeled; appears unused in current build.
;------------------------------------------------------------------------------
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3

    LEA     Global_STR_WEATHER_UPDATE_FOR,A0
    MOVEA.L A3,A1

.copy_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_loop

    MOVEA.L (A7)+,A3
    RTS

;!======