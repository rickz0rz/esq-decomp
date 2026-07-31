    XDEF    _TLIBA1_BuildClockFormatEntryIfVisible


;------------------------------------------------------------------------------
; FUNC: _TLIBA1_BuildClockFormatEntryIfVisible   (Build formatted entry string when slot is active)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
;   stack +8: arg_3 (via 12(A5))
;   stack +10: arg_4 (via 14(A5))
;   stack +12: arg_5 (via 16(A5))
;   stack +16: arg_6 (via 20(A5))
;   stack +18: arg_7 (via 22(A5))
;   stack +20: arg_8 (via 24(A5))
;   stack +24: arg_9 (via 28(A5))
;   stack +26: arg_10 (via 30(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A5/A7/D0/D1/D5/D6/D7
; CALLS:
;   _TLIBA1_FormatClockFormatEntry, _TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode,
;   _TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow, _TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode,
;   _TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode
; READS:
;   _CONFIG_TimeWindowMinutes, _TEXTDISP_ActiveGroupId
; WRITES:
;   (none observed)
; DESC:
;   Gathers timing fields for the active group, tests visibility against the
;   configured time window, then emits a formatted entry string when valid.
; NOTES:
;   Clears output buffer when no visible fields are available.
;------------------------------------------------------------------------------
_TLIBA1_BuildClockFormatEntryIfVisible:
    LINK.W  A5,#-32
    MOVEM.L D5-D7/A3,-(A7)
    MOVE.W  10(A5),D7
    MOVE.W  14(A5),D6
    MOVEA.L 16(A5),A3
    MOVE.W  22(A5),D5
    CLR.W   -30(A5)
    MOVE.W  _TEXTDISP_ActiveGroupId,D0
    SUBQ.W  #1,D0
    BNE.S   .if_ne_17A9

    MOVE.L  D7,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    JSR     _TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    MOVE.L  D7,D1
    EXT.L   D1
    PEA     1.W
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     _TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)
    BRA.S   .skip_17AA

.if_ne_17A9:
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    JSR     _TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    MOVE.L  D7,D1
    EXT.L   D1
    PEA     2.W
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     _TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)

.skip_17AA:
    MOVE.L  D6,D1
    EXT.L   D1
    PEA     5.W
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     _TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     3.W
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-12(A5)
    JSR     _TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     2.W
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-16(A5)
    JSR     _TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     4.W
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-20(A5)
    JSR     _TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     1.W
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-24(A5)
    JSR     _TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(PC)

    LEA     60(A7),A7
    MOVE.L  D0,-28(A5)
    MOVEQ   #-1,D0
    CMP.W   D0,D6
    BEQ.S   .if_eq_17AB

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  _CONFIG_TimeWindowMinutes,-(A7)
    PEA     1440.W
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     _TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(PC)

    LEA     20(A7),A7
    TST.L   D0
    BEQ.S   .if_eq_17AE

.if_eq_17AB:
    TST.L   -12(A5)
    BNE.S   .if_ne_17AC

    TST.L   -16(A5)
    BNE.S   .if_ne_17AC

    TST.L   -20(A5)
    BNE.S   .if_ne_17AC

    TST.L   -24(A5)
    BNE.S   .if_ne_17AC

    TST.L   -28(A5)
    BEQ.S   .if_eq_17AE

.if_ne_17AC:
    MOVE.L  A3,D0
    BEQ.S   .if_eq_17AD

    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -28(A5),-(A7)
    MOVE.L  -24(A5),-(A7)
    MOVE.L  -20(A5),-(A7)
    MOVE.L  -16(A5),-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _TLIBA1_FormatClockFormatEntry

    LEA     28(A7),A7

.if_eq_17AD:
    MOVE.W  #1,-30(A5)
    BRA.S   .skip_17B0

.if_eq_17AE:
    MOVE.L  A3,D0
    BEQ.S   .if_eq_17AF

    CLR.B   (A3)

.if_eq_17AF:
    MOVEQ   #0,D0
    MOVE.W  D0,-30(A5)

.skip_17B0:
    MOVE.W  -30(A5),D0
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======