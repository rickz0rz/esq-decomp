    XDEF    TLIBA2_ComputeBroadcastTimeWindow
    XDEF    TLIBA2_FindLastCharInString
    XDEF    TLIBA2_ParseEntryTimeWindow
    XDEF    TLIBA2_ResolveEntryWindowAndSlotCount
    XDEF    TLIBA2_ResolveEntryWindowWithDefaultRange
    XDEF    TLIBA_FindFirstWildcardMatchIndex
    XDEF    TLIBA2_JMPTBL_DST_AddTimeOffset
    XDEF    TLIBA2_JMPTBL_ESQ_TestBit1Based

;------------------------------------------------------------------------------
; FUNC: TLIBA2_FindLastCharInString   (FindLastCharInStringuncertain)
; ARGS:
;   stack +8: str (char *)
;   stack +12: targetChar (byte)
; RET:
;   D0: pointer to last match, or 0 if none
; CLOBBERS:
;   D0/D7/A0-A1/A3
; CALLS:
;   (none)
; READS:
;   str
; WRITES:
;   (none)
; DESC:
;   Scans to the end of str, then searches backward for targetChar.
; NOTES:
;   Returns 0 when no match is found.
;------------------------------------------------------------------------------
TLIBA2_FindLastCharInString:
    LINK.W  A5,#-8
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.B  15(A5),D7
    CLR.L   -8(A5)
    MOVEA.L A3,A0

.if_ne_17D4:
    TST.B   (A0)+
    BNE.S   .if_ne_17D4

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D0
    MOVEA.L A3,A1
    ADDA.L  D0,A1
    SUBQ.L  #1,A1
    MOVE.L  A1,-4(A5)

.if_cc_17D5:
    MOVEA.L -4(A5),A0
    MOVE.B  (A0),D0
    CMP.B   D7,D0
    BNE.S   .if_ne_17D6

    MOVE.L  A0,-8(A5)
    BRA.S   .skip_17D7

.if_ne_17D6:
    SUBQ.L  #1,-4(A5)
    MOVEA.L -4(A5),A0
    CMPA.L  A3,A0
    BCC.S   .if_cc_17D5

.skip_17D7:
    MOVE.L  -8(A5),D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA2_ResolveEntryWindowAndSlotCount   (Resolve explicit time range or compute slot count fallback)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +16: arg_4 (via 20(A5))
;   stack +20: arg_5 (via 24(A5))
;   stack +24: arg_6 (via 28(A5))
;   stack +30: arg_7 (via 34(A5))
;   stack +34: arg_8 (via 38(A5))
;   stack +56: arg_9 (via 60(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D5/D6/D7
; CALLS:
;   TLIBA_FindFirstWildcardMatchIndex, MATH_DivS32, MATH_Mulu32,
;   PARSE_ReadSignedLongSkipClass3_Alt, TLIBA2_FindLastCharInString,
;   TLIBA2_JMPTBL_ESQ_TestBit1Based
; READS:
;   TEXTDISP_SecondaryEntryPtrTable, TEXTDISP_SecondaryTitlePtrTable, if_eq_17DB, return_17E5
; WRITES:
;   (none observed)
; DESC:
;   Tries to parse an explicit "(HH:MM)" range from the entry text. When no
;   explicit range is present, counts matching/eligible slots and optionally
;   derives a half-hour based fallback window.
; NOTES:
;   Uses text and bitfield gates in both primary and secondary tables.
;------------------------------------------------------------------------------
TLIBA2_ResolveEntryWindowAndSlotCount:
    LINK.W  A5,#-40
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  16(A5),D7
    MOVE.L  24(A5),D6
    MOVEQ   #0,D5
    CLR.L   -34(A5)
    BTST    #0,D6
    BEQ.W   .if_eq_17DB

    BTST    #1,7(A2,D7.L)
    BEQ.W   .if_eq_17DB

    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEA.L 56(A2,D0.L),A0
    PEA     34.W
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-12(A5)
    BSR.W   TLIBA2_FindLastCharInString

    ADDQ.W  #8,A7
    MOVE.L  D0,-28(A5)
    BEQ.W   .if_eq_17DB

    PEA     40.W
    MOVE.L  D0,-(A7)
    BSR.W   TLIBA2_FindLastCharInString

    ADDQ.W  #8,A7
    MOVE.L  D0,-16(A5)
    TST.L   D0
    BEQ.W   .if_eq_17DB

    PEA     41.W
    MOVE.L  D0,-(A7)
    BSR.W   TLIBA2_FindLastCharInString

    ADDQ.W  #8,A7
    MOVE.L  D0,-20(A5)
    TST.L   D0
    BEQ.W   .if_eq_17DB

    PEA     58.W
    MOVE.L  -16(A5),-(A7)
    BSR.W   TLIBA2_FindLastCharInString

    ADDQ.W  #8,A7
    MOVE.L  D0,-24(A5)
    TST.L   D0
    BEQ.S   .if_eq_17DB

    MOVEA.L D0,A0
    CLR.B   (A0)
    MOVEQ   #32,D0
    MOVEA.L -16(A5),A0
    CMP.B   1(A0),D0
    BNE.S   .if_ne_17D9

    LEA     2(A0),A1
    MOVE.L  A1,-(A7)
    JSR     PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVEA.L 20(A5),A0
    MOVE.L  D0,(A0)
    BRA.S   .skip_17DA

.if_ne_17D9:
    LEA     1(A0),A1
    MOVE.L  A1,-(A7)
    JSR     PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVEA.L 20(A5),A0
    MOVE.L  D0,(A0)

.skip_17DA:
    MOVEA.L -24(A5),A0
    MOVE.B  #$3a,(A0)
    MOVEA.L -20(A5),A0
    CLR.B   (A0)
    MOVEA.L -24(A5),A0
    ADDQ.L  #1,A0
    MOVE.L  A0,-(A7)
    JSR     PARSE_ReadSignedLongSkipClass3_Alt(PC)

    MOVEA.L 20(A5),A0
    MOVE.L  D0,4(A0)
    MOVEA.L -20(A5),A0
    MOVE.B  #$29,(A0)
    MOVE.L  -34(A5),D0
    BRA.W   .return_17E5

.if_eq_17DB:
    MOVE.L  D7,D0
    ASL.L   #2,D0
    TST.L   56(A2,D0.L)
    BEQ.S   .loop_17DC

    ADDQ.L  #1,D7
    ADDQ.L  #1,-34(A5)

.loop_17DC:
    MOVEQ   #49,D0
    CMP.L   D0,D7
    BGE.S   .skip_17DF

    LEA     28(A3),A0
    MOVE.L  D7,-(A7)
    MOVE.L  A0,-(A7)
    JSR     TLIBA2_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   .if_ne_17DE

    MOVE.L  D7,D0
    ASL.L   #2,D0
    TST.L   56(A2,D0.L)
    BEQ.S   .if_eq_17DD

    MOVEQ   #1,D5
    BRA.S   .skip_17DF

.if_eq_17DD:
    ADDQ.L  #1,D7
    ADDQ.L  #1,-34(A5)
    BRA.S   .loop_17DC

.if_ne_17DE:
    MOVEQ   #1,D5

.skip_17DF:
    TST.W   D5
    BNE.S   .branch_17E2

    MOVE.L  A2,-(A7)
    BSR.W   TLIBA_FindFirstWildcardMatchIndex

    ADDQ.W  #4,A7
    MOVE.L  D0,-38(A5)
    ADDQ.L  #1,D0
    BEQ.S   .branch_17E2

    MOVE.L  -38(A5),D0
    ASL.L   #2,D0
    LEA     TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    LEA     TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    MOVEQ   #1,D7

.loop_17E0:
    MOVEQ   #49,D0
    CMP.L   D0,D7
    BGE.S   .branch_17E2

    MOVEA.L -4(A5),A0
    ADDA.W  #$1c,A0
    MOVE.L  D7,-(A7)
    MOVE.L  A0,-(A7)
    JSR     TLIBA2_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   .branch_17E2

    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    TST.L   56(A0,D0.L)
    BEQ.S   .if_eq_17E1

    BTST    #7,7(A0,D7.L)
    BEQ.S   .branch_17E2

.if_eq_17E1:
    ADDQ.L  #1,D7
    ADDQ.L  #1,-34(A5)
    BRA.S   .loop_17E0

.branch_17E2:
    BTST    #0,D6
    BEQ.S   .if_eq_17E4

    MOVE.L  -34(A5),D0
    MOVE.L  D0,D1
    TST.L   D1
    BPL.S   .if_pl_17E3

    ADDQ.L  #1,D1

.if_pl_17E3:
    ASR.L   #1,D1
    MOVEA.L 20(A5),A0
    MOVE.L  D1,(A0)
    MOVEQ   #2,D1
    JSR     MATH_DivS32(PC)

    MOVEQ   #30,D0
    JSR     MATH_Mulu32(PC)

    MOVE.L  D0,4(A0)

.if_eq_17E4:
    MOVE.L  -34(A5),D0

.return_17E5:
    MOVEM.L -60(A5),D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA2_ResolveEntryWindowWithDefaultRange   (Wrapper with zeroed range outputs)
; ARGS:
;   stack +8: A3 = primary entry state/context pointer
;   stack +12: A2 = secondary entry table pointer
;   stack +16: D7 = entry index
; RET:
;   D0: result/status from TLIBA2_ResolveEntryWindowAndSlotCount
; CLOBBERS:
;   D0/D7/A2-A3
; CALLS:
;   TLIBA2_ResolveEntryWindowAndSlotCount
; DESC:
;   Convenience wrapper that forwards to TLIBA2_ResolveEntryWindowAndSlotCount
;   with both output-range arguments set to zero.
;------------------------------------------------------------------------------
TLIBA2_ResolveEntryWindowWithDefaultRange:
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEA.L 20(A7),A2
    MOVE.L  24(A7),D7
    CLR.L   -(A7)
    CLR.L   -(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   TLIBA2_ResolveEntryWindowAndSlotCount

    LEA     20(A7),A7
    MOVEM.L (A7)+,D7/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA_FindFirstWildcardMatchIndex   (Find first wildcard match index)
; ARGS:
;   stack +8: wildcardPattern (char *)
; RET:
;   D0: matched index, or -1 if no title matches
; CLOBBERS:
;   D0/D6/D7/A0-A1/A3
; CALLS:
;   UNKNOWN_JMPTBL_ESQ_WildcardMatch
; READS:
;   TEXTDISP_SecondaryGroupEntryCount, TEXTDISP_SecondaryTitlePtrTable
; WRITES:
;   (none observed)
; DESC:
;   Scans secondary titles and returns the first index whose title wildcard-
;   matches the supplied pattern.
; NOTES:
;   Match is accepted when ESQ_WildcardMatch returns zero.
;------------------------------------------------------------------------------
TLIBA_FindFirstWildcardMatchIndex:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEQ   #-1,D6
    MOVEQ   #0,D7

.loop_17E7:
    MOVEQ   #0,D0
    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.L   D0,D7
    BGE.S   .return_17E9

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,-(A7)
    MOVE.L  A3,-(A7)
    JSR     UNKNOWN_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .if_ne_17E8

    MOVE.L  D7,D6
    BRA.S   .return_17E9

.if_ne_17E8:
    ADDQ.L  #1,D7
    BRA.S   .loop_17E7

.return_17E9:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA2_ParseEntryTimeWindow   (Parse "(HH:MM)" style window from entry text)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +16: arg_4 (via 20(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D6/D7
; CALLS:
;   PARSE_ReadSignedLongSkipClass3_Alt, UNKNOWN7_FindCharWrapper
; READS:
;   branch_17F0
; WRITES:
;   (none observed)
; DESC:
;   Extracts time values from the selected entry text into the output pair.
;   Requires delimiter sequence including ':' and ')' before accepting.
; NOTES:
;   Returns 1 on successful parse, 0 otherwise.
;------------------------------------------------------------------------------
TLIBA2_ParseEntryTimeWindow:
    LINK.W  A5,#-24
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVEA.L 16(A5),A2
    MOVEQ   #0,D6
    MOVE.L  A3,D0
    BEQ.S   .if_eq_17EB

    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEA.L 56(A3,D0.L),A0
    BRA.S   .skip_17EC

.if_eq_17EB:
    SUBA.L  A0,A0

.skip_17EC:
    MOVE.L  A0,-4(A5)
    BEQ.W   .branch_17F0

    PEA     40.W
    MOVE.L  A0,-(A7)
    JSR     UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.W   .branch_17F0

    PEA     58.W
    MOVE.L  D0,-(A7)
    JSR     UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-16(A5)
    TST.L   D0
    BEQ.W   .branch_17F0

    PEA     41.W
    MOVE.L  D0,-(A7)
    JSR     UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)
    TST.L   D0
    BEQ.S   .branch_17F0

    PEA     34.W
    MOVE.L  -4(A5),-(A7)
    JSR     UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-20(A5)
    BEQ.S   .if_eq_17ED

    MOVEA.L -12(A5),A0
    CMPA.L  D0,A0
    BCC.S   .branch_17F0

.if_eq_17ED:
    MOVEA.L -16(A5),A0
    CLR.B   (A0)
    MOVEQ   #32,D0
    MOVEA.L -8(A5),A0
    CMP.B   1(A0),D0
    BNE.S   .if_ne_17EE

    LEA     2(A0),A1
    MOVE.L  A1,-(A7)
    JSR     PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,(A2)
    BRA.S   .skip_17EF

.if_ne_17EE:
    LEA     1(A0),A1
    MOVE.L  A1,-(A7)
    JSR     PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,(A2)

.skip_17EF:
    MOVEA.L -16(A5),A0
    MOVE.B  #$3a,(A0)
    MOVEA.L -12(A5),A0
    CLR.B   (A0)
    MOVEA.L -16(A5),A0
    ADDQ.L  #1,A0
    MOVE.L  A0,-(A7)
    JSR     PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,4(A2)
    MOVEA.L -12(A5),A0
    MOVE.B  #$29,(A0)
    MOVEQ   #1,D6

.branch_17F0:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA2_ComputeBroadcastTimeWindow   (Build adjusted date/time window for an entry)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
;   stack +8: arg_3 (via 12(A5))
;   stack +12: arg_4 (via 16(A5))
;   stack +16: arg_5 (via 20(A5))
;   stack +18: arg_6 (via 22(A5))
;   stack +20: arg_7 (via 24(A5))
;   stack +22: arg_8 (via 26(A5))
;   stack +24: arg_9 (via 28(A5))
;   stack +26: arg_10 (via 30(A5))
;   stack +28: arg_11 (via 32(A5))
;   stack +30: arg_12 (via 34(A5))
;   stack +32: arg_13 (via 36(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D2/D3/D5/D6/D7
; CALLS:
;   TLIBA2_ParseEntryTimeWindow, TLIBA2_JMPTBL_DST_AddTimeOffset
; READS:
;   TEXTDISP_PrimaryGroupCode, CLOCK_CurrentDayOfWeekIndex, DATA_WDISP_BSS_LONG_237B, DATA_WDISP_BSS_LONG_237C, DATA_WDISP_BSS_LONG_237D, copy_months_loop, copy_time_fields, ffe2
; WRITES:
;   (none observed)
; DESC:
;   Computes an adjusted time window, applies DST/date offsets, and writes
;   normalized time fields to the provided output structures.
; NOTES:
;   Optionally clamps/overrides the upper bound when parsed entry times exist.
;------------------------------------------------------------------------------
TLIBA2_ComputeBroadcastTimeWindow:
    LINK.W  A5,#-36
    MOVEM.L D2-D3/D5-D7/A2-A3/A6,-(A7)
    MOVE.W  10(A5),D7
    MOVEA.L 12(A5),A3
    MOVE.L  16(A5),D6
    MOVE.L  20(A5),D5
    MOVEA.L 24(A5),A2
    LEA     CLOCK_CurrentDayOfWeekIndex,A0
    LEA     DATA_WDISP_BSS_LONG_237B,A1
    MOVEA.L A1,A6
    MOVEQ   #4,D0

.copy_months_loop:
    MOVE.L  (A0)+,(A6)+
    DBF     D0,.copy_months_loop
    MOVE.W  (A0),(A6)
    MOVE.W  DATA_WDISP_BSS_LONG_237C,D0
    MOVEQ   #12,D1
    CMP.W   D1,D0
    BNE.S   .if_ne_17F3

    MOVE.W  DATA_WDISP_BSS_LONG_237D,D2
    BEQ.S   .if_eq_17F4

.if_ne_17F3:
    MOVEQ   #5,D2
    CMP.W   D2,D0
    BGE.S   .branch_17FD

    MOVE.W  DATA_WDISP_BSS_LONG_237D,D0
    BNE.S   .branch_17FD

.if_eq_17F4:
    MOVE.L  D5,D0
    MOVEQ   #39,D2
    SUB.L   D2,D0
    TST.L   D0
    BPL.S   .if_pl_17F5

    ADDQ.L  #1,D0

.if_pl_17F5:
    ASR.L   #1,D0
    MOVE.W  D0,-32(A5)
    MOVEQ   #38,D0
    CMP.L   D0,D5
    BLE.S   .if_le_17F9

    MOVE.L  D5,D0
    MOVEQ   #1,D3
    AND.L   D3,D0
    SUBQ.L  #1,D0
    BNE.S   .if_ne_17F6

    MOVEQ   #0,D0
    MOVE.W  D0,-34(A5)
    BRA.S   .skip_17F7

.if_ne_17F6:
    MOVEQ   #30,D0
    MOVE.W  D0,-34(A5)

.skip_17F7:
    MOVE.L  D5,D0
    SUB.L   D2,D0
    TST.L   D0
    BPL.S   .if_pl_17F8

    ADDQ.L  #1,D0

.if_pl_17F8:
    ASR.L   #1,D0
    MOVE.W  D0,-32(A5)
    BRA.S   .skip_1801

.if_le_17F9:
    MOVE.L  D5,D0
    MOVEQ   #1,D3
    AND.L   D3,D0
    SUBQ.L  #1,D0
    BNE.S   .if_ne_17FA

    MOVEQ   #0,D0
    MOVE.W  D0,-34(A5)
    BRA.S   .skip_17FB

.if_ne_17FA:
    MOVE.W  #$ffe2,-34(A5)

.skip_17FB:
    SUB.L   D5,D2
    TST.L   D2
    BPL.S   .if_pl_17FC

    ADDQ.L  #1,D2

.if_pl_17FC:
    ASR.L   #1,D2
    NEG.L   D2
    MOVE.W  D2,-32(A5)
    BRA.S   .skip_1801

.branch_17FD:
    MOVE.L  D5,D0
    MOVEQ   #1,D2
    AND.L   D2,D0
    SUBQ.L  #1,D0
    BNE.S   .if_ne_17FE

    MOVEQ   #0,D0
    MOVE.W  D0,-34(A5)
    BRA.S   .skip_17FF

.if_ne_17FE:
    MOVEQ   #30,D0
    MOVE.W  D0,-34(A5)

.skip_17FF:
    MOVE.L  D5,D2
    SUBQ.L  #1,D2
    TST.L   D2
    BPL.S   .if_pl_1800

    ADDQ.L  #1,D2

.if_pl_1800:
    ASR.L   #1,D2
    ADDQ.L  #5,D2
    MOVE.W  D2,-32(A5)

.skip_1801:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #0,D2
    MOVE.B  TEXTDISP_PrimaryGroupCode,D2
    CMP.L   D2,D0
    BEQ.S   .if_eq_1802

    MOVEQ   #24,D0
    ADD.W   D0,-32(A5)

.if_eq_1802:
    LEA     -30(A5),A0
    MOVEQ   #4,D0

.copy_time_fields:
    MOVE.L  (A1)+,(A0)+
    DBF     D0,.copy_time_fields
    MOVE.W  (A1),(A0)
    MOVE.W  D1,-22(A5)
    MOVEQ   #0,D0
    MOVE.W  D0,-20(A5)
    MOVE.W  D0,-12(A5)
    MOVE.W  -32(A5),D0
    EXT.L   D0
    MOVE.W  -34(A5),D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -30(A5)
    JSR     TLIBA2_JMPTBL_DST_AddTimeOffset(PC)

    LEA     12(A7),A7
    MOVE.W  -24(A5),D0
    EXT.L   D0
    MOVE.L  D0,(A2)
    MOVE.W  -28(A5),D0
    EXT.L   D0
    MOVE.L  D0,4(A2)
    MOVE.W  -26(A5),D0
    EXT.L   D0
    MOVE.L  D0,8(A2)
    MOVE.W  -22(A5),D0
    EXT.L   D0
    MOVEA.L 28(A5),A0
    MOVE.L  D0,(A0)
    MOVE.W  -20(A5),D1
    EXT.L   D1
    MOVE.L  D1,4(A0)
    MOVEQ   #12,D0
    CMP.L   (A0),D0
    BNE.S   .if_ne_1804

    MOVE.W  -12(A5),D1
    BNE.S   .if_ne_1804

    MOVEQ   #0,D2
    MOVE.L  D2,(A0)
    BRA.S   .skip_1805

.if_ne_1804:
    MOVE.L  (A0),D1
    CMP.L   D0,D1
    BGE.S   .skip_1805

    MOVE.W  -12(A5),D2
    ADDQ.W  #1,D2
    BNE.S   .skip_1805

    MOVEQ   #12,D0
    ADD.L   D0,(A0)

.skip_1805:
    MOVE.L  A3,D0
    BEQ.S   .if_eq_1806

    PEA     -8(A5)
    MOVE.L  D6,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   TLIBA2_ParseEntryTimeWindow

    LEA     12(A7),A7
    MOVE.W  D0,-36(A5)
    BRA.S   .skip_1807

.if_eq_1806:
    MOVEQ   #0,D0
    MOVE.W  D0,-36(A5)

.skip_1807:
    TST.W   D0
    BEQ.S   .return_1808

    MOVE.L  -4(A5),D0
    MOVEA.L 28(A5),A0
    CMP.L   4(A0),D0
    BLE.S   .return_1808

    MOVE.L  D0,4(A0)

.return_1808:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA2_JMPTBL_DST_AddTimeOffset   (JumpStub_DST_AddTimeOffset)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   DST_AddTimeOffset
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to DST_AddTimeOffset.
;------------------------------------------------------------------------------
TLIBA2_JMPTBL_DST_AddTimeOffset:
    JMP     DST_AddTimeOffset

;------------------------------------------------------------------------------
; FUNC: TLIBA2_JMPTBL_ESQ_TestBit1Based   (JumpStub_ESQ_TestBit1Based)
; ARGS:
;   (none)
; RET:
;   D0: result from ESQ_TestBit1Based
; CLOBBERS:
;   (none)
; CALLS:
;   ESQ_TestBit1Based
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to ESQ_TestBit1Based.
;------------------------------------------------------------------------------
TLIBA2_JMPTBL_ESQ_TestBit1Based:
    JMP     ESQ_TestBit1Based

;!======

    ; Alignment
    RTS
    DC.W    $0000
