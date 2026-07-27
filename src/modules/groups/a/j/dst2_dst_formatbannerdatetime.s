    XDEF    _DST_FormatBannerDateTime


;------------------------------------------------------------------------------
; FUNC: _DST_FormatBannerDateTime   (Format banner date/time string.)
; ARGS:
;   stack +68: arg_1 (via 72(A5))
; RET:
;   D0: none
; CLOBBERS:
;   A0/A1/A2/A3/A6/A7/D0/D1/D2/D3/D4/D5/D6
; CALLS:
;   _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   _Global_JMPTBL_SHORT_DAYS_OF_WEEK, _Global_JMPTBL_SHORT_MONTHS, _DST_FMT_PCT_S_COLON_PCT_S_PCT_S_PCT_02D_PCT_..DST_STR_NORM_YEAR
; WRITES:
;   (none observed)
; DESC:
;   Builds a formatted banner string using day/month tables and flags.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DST_FormatBannerDateTime:
    LINK.W  A5,#-40
    MOVEM.L D2-D6/A2-A3/A6,-(A7)
    MOVEA.L 80(A7),A3
    ; Build formatted banner string from date/time fields.

    ; 84(A7) is copied into (A2), which itself points to the day number.
    ; This is then copied into D0 and shifted by 2 to multiply by 4 becoming
    ; an index off of _Global_JMPTBL_SHORT_DAYS_OF_WEEK and stored into A0.
    MOVEA.L 84(A7),A2
    MOVE.W  (A2),D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _Global_JMPTBL_SHORT_DAYS_OF_WEEK,A0
    ADDA.L  D0,A0

    ; 2(A2) is copied into (D0), which itself points to the month number.
    ; This is then copied into D0 and again shifted by 2 to multiply by 4 becoming
    ; an index off of _Global_JMPTBL_SHORT_MONTHS and stored into A1.
    MOVE.W  2(A2),D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _Global_JMPTBL_SHORT_MONTHS,A1
    ADDA.L  D0,A1

    ; Copy 4(A2) into D0 and sign extend
    MOVE.W  4(A2),D0
    EXT.L   D0

    ; Copy 6(A2) into D1 and sign extend
    MOVE.W  6(A2),D1
    EXT.L   D1

    ; Copy 16(A2) into D2 and sign extend
    MOVE.W  16(A2),D2
    EXT.L   D2

    ; Copy 8(A2) into D3 and sign extend
    MOVE.W  8(A2),D3
    EXT.L   D3

    ; Copy 10(A2) into D4 and sign extend
    MOVE.W  10(A2),D4
    EXT.L   D4

    ; Copy 12(A2) into D5 and sign extend
    MOVE.W  12(A2),D5
    EXT.L   D5

    ; Select format strings based on flags in A2.
    TST.W   18(A2)
    BEQ.S   .use_pm_string

    LEA     _DST_TAG_PM,A6
    BRA.S   .ampm_string_ready

.use_pm_string:
    LEA     DST_TAG_AM,A6

.ampm_string_ready:
    ; Copy A6 into 64(A7), then 1 into D6. Compare 14(A2) to D6 and if it's not equal,
    ; branch to use_day_suffix_1 -- otherwise, load the address for _DST_TAG_DST
    ; ("DST") into A6 and branch to .day_suffix_ready
    MOVE.L  A6,64(A7)
    MOVEQ   #1,D6
    CMP.W   14(A2),D6
    BNE.S   .use_day_suffix_1

    ; A6 points to "DST"
    LEA     _DST_TAG_DST,A6
    BRA.S   .day_suffix_ready

.use_day_suffix_1:
    ; A6 points to "STD"
    LEA     DST_TAG_STD,A6

.day_suffix_ready:
    MOVE.L  A6,68(A7)
    TST.W   20(A2)
    BEQ.S   .use_dst_on_string

    ; A6 points to "Leap year"
    LEA     _DST_STR_LEAP_YEAR,A6
    BRA.S   .dst_string_ready

.use_dst_on_string:
    ; A6 points to "Norm year"
    LEA     DST_STR_NORM_YEAR,A6

.dst_string_ready:
    ; Setup the stack and call a printf function with the string
    ; "%s:  %s%s%02d, '%d (%03d) %2d:%02d:%02d %s %s %s"
    MOVE.L  A6,-(A7)
    MOVE.L  72(A7),-(A7)
    MOVE.L  72(A7),-(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  (A1),-(A7)
    MOVE.L  (A0),-(A7)
    MOVE.L  A3,-(A7)
    PEA     _DST_FMT_PCT_S_COLON_PCT_S_PCT_S_PCT_02D_PCT_
    JSR     _GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEM.L -72(A5),D2-D6/A2-A3/A6
    UNLK    A5
    RTS

;!======