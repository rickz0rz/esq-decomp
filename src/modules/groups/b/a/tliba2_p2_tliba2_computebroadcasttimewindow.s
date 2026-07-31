    XDEF    _TLIBA2_ComputeBroadcastTimeWindow



;------------------------------------------------------------------------------
; FUNC: _TLIBA2_ComputeBroadcastTimeWindow   (Build adjusted date/time window for an entry)
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
;   _TLIBA2_ParseEntryTimeWindow, _TLIBA2_JMPTBL_DST_AddTimeOffset
; READS:
;   _TEXTDISP_PrimaryGroupCode, _CLOCK_CurrentDayOfWeekIndex, _TLIBA2_BroadcastWindowClockSnapshotA, _TLIBA2_BroadcastWindowClockSnapshotB, _TLIBA2_BroadcastWindowClockSnapshotC, copy_months_loop, copy_time_fields, ffe2
; WRITES:
;   (none observed)
; DESC:
;   Computes an adjusted time window, applies DST/date offsets, and writes
;   normalized time fields to the provided output structures.
; NOTES:
;   Optionally clamps/overrides the upper bound when parsed entry times exist.
;------------------------------------------------------------------------------
_TLIBA2_ComputeBroadcastTimeWindow:
    LINK.W  A5,#-36
    MOVEM.L D2-D3/D5-D7/A2-A3/A6,-(A7)
    MOVE.W  10(A5),D7
    MOVEA.L 12(A5),A3
    MOVE.L  16(A5),D6
    MOVE.L  20(A5),D5
    MOVEA.L 24(A5),A2
    LEA     _CLOCK_CurrentDayOfWeekIndex,A0
    LEA     _TLIBA2_BroadcastWindowClockSnapshotA,A1
    MOVEA.L A1,A6
    MOVEQ   #4,D0

.copy_months_loop:
    MOVE.L  (A0)+,(A6)+
    DBF     D0,.copy_months_loop
    MOVE.W  (A0),(A6)
    MOVE.W  _TLIBA2_BroadcastWindowClockSnapshotB,D0
    MOVEQ   #12,D1
    CMP.W   D1,D0
    BNE.S   .if_ne_17F3

    MOVE.W  _TLIBA2_BroadcastWindowClockSnapshotC,D2
    BEQ.S   .if_eq_17F4

.if_ne_17F3:
    MOVEQ   #5,D2
    CMP.W   D2,D0
    BGE.S   .branch_17FD

    MOVE.W  _TLIBA2_BroadcastWindowClockSnapshotC,D0
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
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D2
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
    JSR     _TLIBA2_JMPTBL_DST_AddTimeOffset(PC)

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
    BSR.W   _TLIBA2_ParseEntryTimeWindow

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