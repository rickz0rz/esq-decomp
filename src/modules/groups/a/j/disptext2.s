
;------------------------------------------------------------------------------
; FUNC: LAB_05C7   (Convert seconds to time struct??)
; ARGS:
;   stack +8: D7 = seconds??
;   stack +12: A3 = output struct
; RET:
;   D0: A3
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   GROUP_AG_JMPTBL_LAB_1A07, GROUP_AJ_JMPTBL_LAB_1A06, LAB_0660, LAB_066E, LAB_0668
; READS:
;   LAB_1CF5
; WRITES:
;   A3+0/2/4/6/8/10/12/16/20
; DESC:
;   Converts a seconds value into fields stored in the output struct.
; NOTES:
;   Uses repeated division/modulo with 60/24 and year/day tables.
;------------------------------------------------------------------------------
LAB_05C7:
    MOVEM.L D4-D7/A3,-(A7)
    MOVE.L  24(A7),D7
    MOVEA.L 28(A7),A3
    TST.L   D7
    BPL.S   .LAB_05C8

    MOVEQ   #0,D7

.LAB_05C8:
    MOVE.L  D7,D0
    MOVEQ   #60,D1
    JSR     GROUP_AG_JMPTBL_LAB_1A07(PC)

    MOVE.W  D1,12(A3)
    MOVE.L  D7,D0
    MOVEQ   #60,D1
    JSR     GROUP_AG_JMPTBL_LAB_1A07(PC)

    MOVE.L  D0,D7
    MOVE.L  D7,D0
    MOVEQ   #60,D1
    JSR     GROUP_AG_JMPTBL_LAB_1A07(PC)

    MOVE.W  D1,10(A3)
    MOVE.L  D7,D0
    MOVEQ   #60,D1
    JSR     GROUP_AG_JMPTBL_LAB_1A07(PC)

    MOVE.L  D0,D7
    MOVE.L  D7,D0
    MOVE.L  #$88f8,D1
    JSR     GROUP_AG_JMPTBL_LAB_1A07(PC)

    MOVE.L  D0,D5
    MOVE.L  D5,D0
    ASL.L   #2,D0
    MOVE.W  D0,6(A3)
    ADDI.W  #$7b2,6(A3)
    MOVE.L  D5,D0
    MOVE.L  #$5b5,D1
    JSR     GROUP_AJ_JMPTBL_LAB_1A06(PC)

    MOVE.L  D0,D4
    MOVE.L  D7,D0
    MOVE.L  #$88f8,D1
    JSR     GROUP_AG_JMPTBL_LAB_1A07(PC)

    MOVE.L  D1,D7

.LAB_05C9:
    MOVE.L  #$2238,D6
    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0660

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   .LAB_05CA

    MOVEQ   #24,D0
    ADD.L   D0,D6

.LAB_05CA:
    CMP.L   D6,D7
    BLT.S   .LAB_05CB

    MOVE.L  D6,D0
    MOVEQ   #24,D1
    JSR     GROUP_AG_JMPTBL_LAB_1A07(PC)

    ADD.L   D0,D4
    ADDQ.W  #1,6(A3)
    SUB.L   D6,D7
    BRA.S   .LAB_05C9

.LAB_05CB:
    MOVE.L  D7,D0
    MOVEQ   #24,D1
    JSR     GROUP_AG_JMPTBL_LAB_1A07(PC)

    MOVE.W  D1,8(A3)
    MOVE.L  D7,D0
    MOVEQ   #24,D1
    JSR     GROUP_AG_JMPTBL_LAB_1A07(PC)

    MOVE.L  D0,D7
    MOVE.L  D7,D0
    ADDQ.L  #4,D0
    ADD.L   D0,D4
    MOVE.L  D4,D0
    MOVEQ   #7,D1
    JSR     LAB_066E(PC)

    MOVE.W  D1,(A3)
    ADDQ.L  #1,D7
    MOVE.L  D7,D0
    MOVE.W  D0,16(A3)
    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0660

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   .LAB_05CC

    MOVEQ   #-1,D0
    BRA.S   .LAB_05CD

.LAB_05CC:
    MOVEQ   #0,D0

.LAB_05CD:
    MOVE.W  D0,20(A3)
    ADDQ.W  #1,D0
    BNE.S   .LAB_05CF

    MOVEQ   #60,D0
    CMP.L   D0,D7
    BLE.S   .LAB_05CE

    SUBQ.L  #1,D7
    BRA.S   .LAB_05CF

.LAB_05CE:
    CMP.L   D0,D7
    BNE.S   .LAB_05CF

    MOVE.W  #1,2(A3)
    MOVE.W  #$1d,4(A3)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0668

    ADDQ.W  #4,A7
    MOVE.L  A3,D0
    BRA.S   .return

.LAB_05CF:
    CLR.W   2(A3)

.LAB_05D0:
    LEA     LAB_1CF5,A0
    MOVE.W  2(A3),D0
    MOVEA.L A0,A1
    ADDA.W  D0,A1
    MOVE.B  (A1),D1
    EXT.W   D1
    EXT.L   D1
    CMP.L   D7,D1
    BGE.S   .LAB_05D1

    ADDA.W  D0,A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    SUB.L   D0,D7
    ADDQ.W  #1,2(A3)
    BRA.S   .LAB_05D0

.LAB_05D1:
    MOVE.L  D7,D0
    MOVE.W  D0,4(A3)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0668

    ADDQ.W  #4,A7
    MOVE.L  A3,D0

.return:
    MOVEM.L (A7)+,D4-D7/A3
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_05D3   (Normalize time struct to seconds??)
; ARGS:
;   stack +8: A3 = time struct
; RET:
;   D0: seconds or -1 on invalid
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   LAB_0665, LAB_0660, GROUP_AG_JMPTBL_LAB_1A06, LAB_0668
; READS:
;   A3+2/4/6/8/10/12/16
; WRITES:
;   A3+2/4/6/8/10/12/16/20
; DESC:
;   Normalizes fields in the time struct and computes total seconds.
; NOTES:
;   Uses DIVS #10 and SWAP idioms for decimal extraction.
;------------------------------------------------------------------------------
LAB_05D3:
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVE.W  6(A3),D0
    CMPI.W  #$76c,D0
    BGE.S   LAB_05D4

    ADDI.W  #$76c,6(A3)

LAB_05D4:
    MOVE.W  6(A3),D0
    CMPI.W  #$7b2,D0
    BLT.S   LAB_05D5

    CMPI.W  #$7f6,D0
    BLE.S   LAB_05D6

LAB_05D5:
    MOVEQ   #-1,D0
    BRA.W   LAB_05E0

LAB_05D6:
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0665

    ADDQ.W  #4,A7
    MOVE.W  12(A3),D0
    EXT.L   D0
    MOVEQ   #60,D1
    DIVS    D1,D0
    ADD.W   D0,10(A3)
    MOVE.W  12(A3),D0
    EXT.L   D0
    DIVS    D1,D0
    SWAP    D0
    MOVE.W  D0,12(A3)
    MOVE.W  10(A3),D0
    EXT.L   D0
    DIVS    D1,D0
    ADD.W   D0,8(A3)
    MOVE.W  10(A3),D0
    EXT.L   D0
    DIVS    D1,D0
    SWAP    D0
    MOVE.W  D0,10(A3)
    MOVE.W  8(A3),D0
    EXT.L   D0
    MOVEQ   #24,D1
    DIVS    D1,D0
    ADD.W   D0,4(A3)
    MOVE.W  8(A3),D0
    EXT.L   D0
    DIVS    D1,D0
    ADD.W   D0,16(A3)
    MOVE.W  8(A3),D0
    EXT.L   D0
    DIVS    D1,D0
    SWAP    D0
    MOVE.W  D0,8(A3)
    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0660

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   LAB_05D7

    MOVE.L  #366,D0
    BRA.S   LAB_05D8

LAB_05D7:
    MOVE.L  #$16d,D0

LAB_05D8:
    MOVE.L  D0,D6

LAB_05D9:
    MOVE.W  16(A3),D0
    EXT.L   D0
    CMP.L   D6,D0
    BLE.S   LAB_05DC

    MOVE.W  16(A3),D0
    EXT.L   D0
    SUB.L   D6,D0
    MOVE.W  D0,16(A3)
    ADDQ.W  #1,6(A3)
    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0660

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   LAB_05DA

    MOVE.L  #366,D0
    BRA.S   LAB_05DB

LAB_05DA:
    MOVE.L  #$16d,D0

LAB_05DB:
    MOVE.L  D0,D6
    BRA.S   LAB_05D9

LAB_05DC:
    MOVE.W  6(A3),D0
    EXT.L   D0
    SUBI.L  #$7b0,D0
    TST.L   D0
    BPL.S   LAB_05DD

    ADDQ.L  #3,D0

LAB_05DD:
    ASR.L   #2,D0
    MOVE.L  D0,D7
    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0660

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   LAB_05DE

    SUBQ.L  #1,D7

LAB_05DE:
    MOVE.W  6(A3),D0
    EXT.L   D0
    SUBI.L  #$7b2,D0
    MOVE.L  #$16d,D1
    JSR     GROUP_AG_JMPTBL_LAB_1A06(PC)

    ADD.L   D7,D0
    MOVE.W  16(A3),D1
    EXT.L   D1
    ADD.L   D1,D0
    MOVE.L  D0,D5
    SUBQ.L  #1,D5
    MOVE.L  D5,D0
    MOVE.L  #$15180,D1
    JSR     GROUP_AG_JMPTBL_LAB_1A06(PC)

    MOVE.W  8(A3),D1
    MULS    #$e10,D1
    ADD.L   D1,D0
    MOVE.W  10(A3),D1
    MULS    #$3c,D1
    ADD.L   D1,D0
    MOVE.W  12(A3),D1
    EXT.L   D1
    ADD.L   D1,D0
    MOVE.L  D0,D4
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0668

    ADDQ.W  #4,A7
    TST.L   D4
    BLE.S   LAB_05DF

    MOVE.L  D4,D0
    BRA.S   LAB_05E0

LAB_05DF:
    MOVEQ   #-1,D0

LAB_05E0:
    MOVEM.L (A7)+,D4-D7/A3
    RTS

;!======

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_05E1   (Build time struct from date/time??)
; ARGS:
;   stack +8: A3 = time struct
;   stack +12: A2 = output struct
;   stack +18: D7 = ?? (base day)
;   stack +22: D6 = ?? (flag)
; RET:
;   D0: seconds?
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   LAB_05D3, GROUP_AG_JMPTBL_LAB_1A06, LAB_05C7
; READS:
;   A2
; WRITES:
;   A2 fields, A2+14 cleared
; DESC:
;   Computes a derived time value and fills output fields.
; NOTES:
;   Uses offset of 0x36 and 0x0E10 scaling.
;------------------------------------------------------------------------------
LAB_05E1:
    LINK.W  A5,#-12
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  18(A5),D7
    MOVE.W  22(A5),D6
    MOVE.L  A3,-(A7)
    BSR.W   LAB_05D3

    ADDQ.W  #4,A7
    MOVE.L  D0,D5
    MOVE.L  D7,D0
    SUBI.W  #$36,D0
    MOVEM.W D0,-10(A5)
    MOVEQ   #1,D1
    CMP.W   D1,D6
    BNE.S   LAB_05E2

    MOVEQ   #1,D1
    BRA.S   LAB_05E3

LAB_05E2:
    MOVEQ   #0,D1

LAB_05E3:
    EXT.L   D0
    MOVE.W  D1,-12(A5)
    EXT.L   D1
    SUB.L   D1,D0
    MOVE.L  #$e10,D1
    JSR     GROUP_AG_JMPTBL_LAB_1A06(PC)

    MOVE.L  D5,D4
    ADD.L   D0,D4
    MOVE.L  A2,-(A7)
    MOVE.L  D4,-(A7)
    BSR.W   LAB_05C7

    CLR.W   14(A2)
    MOVE.L  D4,D0
    MOVEM.L -36(A5),D4-D7/A2-A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_05E4   (Populate time struct from LAB_2241)
; ARGS:
;   stack +8: A3 = output struct
; RET:
;   D0: seconds?
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   LAB_05E1
; READS:
;   LAB_2241, LAB_223A
; WRITES:
;   output struct
; DESC:
;   Wrapper that builds a time struct using global base data.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_05E4:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.W  LAB_2241,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     54.W
    MOVE.L  A3,-(A7)
    PEA     LAB_223A
    BSR.W   LAB_05E1

    LEA     16(A7),A7
    MOVE.L  D0,D7
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_05E5   (Compare value against struct bounds)
; ARGS:
;   stack +8: A3 = struct pointer
;   stack +12: D7 = value
; RET:
;   D0: 0/1 ??
; CLOBBERS:
;   D0-D7/A3 ??
; CALLS:
;   none
; READS:
;   A3+8/12/16
; WRITES:
;   -11(A5) (flags)
; DESC:
;   Compares value against two bounds and returns a derived selector.
; NOTES:
;   Switch-like sequence on flags in -11(A5).
;------------------------------------------------------------------------------
LAB_05E5:
    LINK.W  A5,#-12
    MOVEM.L D2/D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVEQ   #0,D0
    MOVE.B  D0,-11(A5)
    MOVE.L  A3,D1
    BNE.S   LAB_05E6

    MOVEQ   #0,D0
    BRA.W   LAB_05F5

LAB_05E6:
    MOVE.L  12(A3),D0
    MOVE.L  8(A3),D1
    CMP.L   D0,D1
    BGE.S   LAB_05E7

    MOVE.B  -11(A5),D2
    MOVE.L  D1,D5
    MOVE.L  D0,D4
    MOVE.B  D2,-11(A5)
    BRA.S   LAB_05E9

LAB_05E7:
    CMP.L   D0,D1
    BLE.S   LAB_05E8

    BSET    #4,-11(A5)
    MOVE.L  D0,D5
    MOVE.L  D1,D4
    BRA.S   LAB_05E9

LAB_05E8:
    MOVEQ   #0,D0
    BRA.S   LAB_05F5

LAB_05E9:
    CMP.L   D5,D7
    BGE.S   LAB_05EA

    MOVE.B  -11(A5),D0
    MOVE.B  D0,-11(A5)
    BRA.S   LAB_05EC

LAB_05EA:
    CMP.L   D4,D7
    BGE.S   LAB_05EB

    BSET    #0,-11(A5)
    BRA.S   LAB_05EC

LAB_05EB:
    BSET    #1,-11(A5)

LAB_05EC:
    MOVEQ   #0,D0
    MOVE.B  -11(A5),D0
    TST.W   D0
    BEQ.S   LAB_05ED

    SUBQ.W  #1,D0
    BEQ.S   LAB_05EE

    SUBQ.W  #1,D0
    BEQ.S   LAB_05EF

    SUBI.W  #14,D0
    BEQ.S   LAB_05F0

    SUBQ.W  #1,D0
    BEQ.S   LAB_05F1

    SUBQ.W  #1,D0
    BEQ.S   LAB_05F2

    BRA.S   LAB_05F3

LAB_05ED:
    MOVEQ   #0,D6
    BRA.S   LAB_05F4

LAB_05EE:
    MOVEQ   #1,D6
    BRA.S   LAB_05F4

LAB_05EF:
    MOVEQ   #0,D6
    BRA.S   LAB_05F4

LAB_05F0:
    MOVEQ   #1,D6
    BRA.S   LAB_05F4

LAB_05F1:
    MOVEQ   #0,D6
    BRA.S   LAB_05F4

LAB_05F2:
    MOVEQ   #1,D6
    BRA.S   LAB_05F4

LAB_05F3:
    MOVEQ   #0,D6

LAB_05F4:
    MOVE.L  D6,D0

LAB_05F5:
    MOVEM.L (A7)+,D2/D4-D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_05F6   (Update A3 based on time comparison??)
; ARGS:
;   stack +8: A3 = struct pointer
; RET:
;   D0: boolean changed
; CLOBBERS:
;   D0-D7/A3 ??
; CALLS:
;   LAB_05E4, LAB_05E5
; READS:
;   A3+16
; WRITES:
;   A3+16
; DESC:
;   Recomputes a selection value and stores it if changed.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_05F6:
    LINK.W  A5,#-32
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D6
    MOVE.L  A3,D0
    BEQ.S   LAB_05F7

    PEA     -26(A5)
    BSR.W   LAB_05E4

    MOVE.L  D0,D7
    MOVE.L  D7,(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_05E5

    ADDQ.W  #8,A7
    MOVE.L  D0,D5
    MOVE.W  16(A3),D0
    CMP.W   D5,D0
    BEQ.S   LAB_05F7

    MOVE.W  D5,16(A3)
    MOVEQ   #1,D6

LAB_05F7:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_05F8   (Copy two date structs and recalc)
; ARGS:
;   stack +8: A3 = dest struct
;   stack +12: A2 = src1 pointer
;   stack +16: A0 = src2 pointer
; RET:
;   D0: ??
; CLOBBERS:
;   D0/A0-A3 ??
; CALLS:
;   LAB_05D3
; READS:
;   A2, A0
; WRITES:
;   A3+0/4/8/12
; DESC:
;   Copies two 22-byte blocks into A3 and recalculates time values.
; NOTES:
;   DBF loops run (Dn+1) iterations (22 bytes).
;------------------------------------------------------------------------------
LAB_05F8:
    LINK.W  A5,#0
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  A3,D0
    BEQ.S   LAB_05FB

    TST.L   (A3)
    BEQ.S   LAB_05FB

    TST.L   4(A3)
    BEQ.S   LAB_05FB

    MOVEQ   #21,D0
    MOVEA.L A2,A0
    MOVEA.L (A3),A1

LAB_05F9:
    MOVE.B  (A0)+,(A1)+
    DBF     D0,LAB_05F9
    MOVEQ   #21,D0
    MOVEA.L 16(A5),A0
    MOVEA.L 4(A3),A1

LAB_05FA:
    MOVE.B  (A0)+,(A1)+
    DBF     D0,LAB_05FA
    MOVE.L  A2,-(A7)
    BSR.W   LAB_05D3

    MOVE.L  D0,8(A3)
    MOVE.L  16(A5),(A7)
    BSR.W   LAB_05D3

    ADDQ.W  #4,A7
    MOVE.L  D0,12(A3)

LAB_05FB:
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_05FC   (Parse date/time from string??)
; ARGS:
;   stack +8: A3 = output struct
;   stack +12: A2 = input string
;   stack +19: D7 = ?? (flags)
; RET:
;   D0: boolean success
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   LAB_05C1, LAB_0470, LAB_0468, GROUP_AG_JMPTBL_LAB_1A07, LAB_0660, LAB_0668, LAB_05D3, LAB_05C7
; READS:
;   LAB_223D
; WRITES:
;   A3 fields
; DESC:
;   Parses a date/time string into a struct and validates ranges.
; NOTES:
;   Uses 0x12/0x0B offsets in the parsed buffer.
;------------------------------------------------------------------------------
LAB_05FC:
    LINK.W  A5,#-20
    MOVEM.L D2/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.B  19(A5),D7
    MOVEQ   #0,D5
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A2,-(A7)
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)
    BEQ.W   LAB_0602

    MOVE.L  A3,D0
    BEQ.W   LAB_0602

    MOVEQ   #21,D0
    MOVEQ   #0,D1
    MOVEA.L A3,A0

LAB_05FD:
    MOVE.B  D1,(A0)+
    DBF     D0,LAB_05FD
    MOVEA.L -12(A5),A0
    ADDQ.L  #1,A0
    PEA     7.W
    MOVE.L  A0,-(A7)
    PEA     -8(A5)
    JSR     LAB_0470(PC)

    CLR.B   -1(A5)
    PEA     -8(A5)
    JSR     LAB_0468(PC)

    LEA     16(A7),A7
    MOVE.L  D0,D6
    MOVE.L  D6,D0
    MOVE.L  #1000,D1
    JSR     GROUP_AG_JMPTBL_LAB_1A07(PC)

    MOVE.W  D0,6(A3)
    MOVE.L  D6,D0
    MOVE.L  #1000,D1
    JSR     GROUP_AG_JMPTBL_LAB_1A07(PC)

    MOVE.W  D1,16(A3)
    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.W  LAB_223D,D2
    EXT.L   D2
    SUB.L   D2,D0
    BGE.S   LAB_05FE

    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.W  LAB_223D,D2
    EXT.L   D2
    SUB.L   D2,D0
    NEG.L   D0
    BRA.S   LAB_05FF

LAB_05FE:
    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.W  LAB_223D,D2
    EXT.L   D2
    SUB.L   D2,D0

LAB_05FF:
    MOVEQ   #1,D2
    CMP.L   D2,D0
    BGT.W   LAB_0602

    MOVEQ   #1,D0
    CMP.W   D0,D1
    BLE.W   LAB_0602

    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0660

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   LAB_0600

    MOVEQ   #1,D0
    BRA.S   LAB_0601

LAB_0600:
    MOVEQ   #0,D0

LAB_0601:
    ADDI.L  #366,D0
    MOVE.W  16(A3),D1
    EXT.L   D1
    CMP.L   D0,D1
    BGE.S   LAB_0602

    MOVEA.L -12(A5),A0
    ADDQ.L  #8,A0
    MOVE.L  A0,-(A7)
    JSR     LAB_0468(PC)

    ADDQ.W  #4,A7
    MOVE.W  D0,8(A3)
    TST.W   D0
    BMI.S   LAB_0602

    MOVEQ   #24,D1
    CMP.W   D1,D0
    BGE.S   LAB_0602

    MOVEA.L -12(A5),A0
    ADDA.W  #11,A0
    MOVE.L  A0,-(A7)
    JSR     LAB_0468(PC)

    ADDQ.W  #4,A7
    MOVE.W  D0,10(A3)
    TST.W   D0
    BMI.S   LAB_0602

    MOVEQ   #60,D1
    CMP.W   D1,D0
    BGE.S   LAB_0602

    MOVEQ   #0,D0
    MOVE.W  D0,12(A3)
    MOVE.W  D0,14(A3)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0668

    MOVE.L  A3,(A7)
    BSR.W   LAB_05D3

    MOVE.L  A3,(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_05C7

    ADDQ.W  #8,A7
    MOVEQ   #1,D5

LAB_0602:
    TST.W   D5
    BNE.S   LAB_0604

    MOVEQ   #21,D0
    MOVEQ   #0,D1
    MOVEA.L A3,A0

LAB_0603:
    MOVE.B  D1,(A0)+
    DBF     D0,LAB_0603

LAB_0604:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D2/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_0605   (Dump time structs to stream??)
; ARGS:
;   stack +8: D7 = stream/handle
;   stack +12: A3 = struct pair
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   GROUP_AM_JMPTBL_WDISP_SPrintf, GROUP_AI_JMPTBL_UNKNOWN6_AppendDataAtNull, GROUP_AG_JMPTBL_LAB_1A07, LAB_03A0
; READS:
;   LAB_1CF8..LAB_1D00
; WRITES:
;   local buffer -87(A5)
; DESC:
;   Formats two optional time structs into text and writes to the stream.
; NOTES:
;   Uses local buffer with append helper.
;------------------------------------------------------------------------------
LAB_0605:
    LINK.W  A5,#-140
    MOVEM.L D6-D7/A3,-(A7)
    MOVE.L  8(A5),D7
    MOVEA.L 12(A5),A3
    CLR.B   -87(A5)
    MOVE.L  A3,D0
    BEQ.W   LAB_060D

    MOVEA.L (A3),A0
    MOVE.L  A0,-4(A5)
    MOVE.L  A0,D0
    BEQ.W   LAB_0608

    PEA     4.W
    PEA     LAB_1CF8
    PEA     -138(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -138(A5)
    PEA     -87(A5)
    JSR     GROUP_AI_JMPTBL_UNKNOWN6_AppendDataAtNull(PC)

    MOVEA.L -4(A5),A0
    MOVE.W  6(A0),D0
    EXT.L   D0
    MOVE.W  16(A0),D1
    EXT.L   D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1CF9
    PEA     -138(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -138(A5)
    PEA     -87(A5)
    JSR     GROUP_AI_JMPTBL_UNKNOWN6_AppendDataAtNull(PC)

    LEA     40(A7),A7
    MOVEA.L -4(A5),A0
    MOVE.W  8(A0),D0
    EXT.L   D0
    MOVEQ   #12,D1
    JSR     GROUP_AG_JMPTBL_LAB_1A07(PC)

    TST.W   18(A0)
    BEQ.S   LAB_0606

    MOVEQ   #12,D0
    BRA.S   LAB_0607

LAB_0606:
    MOVEQ   #0,D0

LAB_0607:
    ADD.L   D0,D1
    MOVE.L  D1,D6
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.W  10(A0),D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1CFA
    PEA     -138(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -138(A5)
    PEA     -87(A5)
    JSR     GROUP_AI_JMPTBL_UNKNOWN6_AppendDataAtNull(PC)

    LEA     24(A7),A7
    BRA.S   LAB_0609

LAB_0608:
    PEA     LAB_1CFB
    PEA     -87(A5)
    JSR     GROUP_AI_JMPTBL_UNKNOWN6_AppendDataAtNull(PC)

    ADDQ.W  #8,A7

LAB_0609:
    MOVEA.L 4(A3),A0
    MOVE.L  A0,-4(A5)
    MOVE.L  A0,D0
    BEQ.W   LAB_060C

    PEA     19.W
    PEA     LAB_1CFC
    PEA     -138(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -138(A5)
    PEA     -87(A5)
    JSR     GROUP_AI_JMPTBL_UNKNOWN6_AppendDataAtNull(PC)

    MOVEA.L -4(A5),A0
    MOVE.W  6(A0),D0
    EXT.L   D0
    MOVE.W  16(A0),D1
    EXT.L   D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1CFD
    PEA     -138(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -138(A5)
    PEA     -87(A5)
    JSR     GROUP_AI_JMPTBL_UNKNOWN6_AppendDataAtNull(PC)

    LEA     40(A7),A7
    MOVEA.L -4(A5),A0
    MOVE.W  8(A0),D0
    EXT.L   D0
    MOVEQ   #12,D1
    JSR     GROUP_AG_JMPTBL_LAB_1A07(PC)

    TST.W   18(A0)
    BEQ.S   LAB_060A

    MOVEQ   #12,D0
    BRA.S   LAB_060B

LAB_060A:
    MOVEQ   #0,D0

LAB_060B:
    ADD.L   D0,D1
    MOVE.L  D1,D6
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.W  10(A0),D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     LAB_1CFE
    PEA     -138(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -138(A5)
    PEA     -87(A5)
    JSR     GROUP_AI_JMPTBL_UNKNOWN6_AppendDataAtNull(PC)

    LEA     24(A7),A7
    BRA.S   LAB_060E

LAB_060C:
    PEA     LAB_1CFF
    PEA     -87(A5)
    JSR     GROUP_AI_JMPTBL_UNKNOWN6_AppendDataAtNull(PC)

    ADDQ.W  #8,A7
    BRA.S   LAB_060E

LAB_060D:
    PEA     LAB_1D00
    PEA     -87(A5)
    JSR     GROUP_AI_JMPTBL_UNKNOWN6_AppendDataAtNull(PC)

    ADDQ.W  #8,A7

LAB_060E:
    LEA     -87(A5),A0
    MOVEA.L A0,A1

LAB_060F:
    TST.B   (A1)+
    BNE.S   LAB_060F

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D7,-(A7)
    JSR     LAB_03A0(PC)

    MOVEM.L -152(A5),D6-D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_0610   (Save time structs to file)
; ARGS:
;   stack +8: A3 = struct pair
; RET:
;   D0: boolean success
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   DISKIO_OpenFileWithBuffer, LAB_03A0, LAB_0605, LAB_039A
; READS:
;   LAB_1CF7, LAB_1D01, LAB_1D02
; WRITES:
;   file
; DESC:
;   Writes formatted struct data to a file using a buffered handle.
; NOTES:
;   Requires both struct pointers to be non-null.
;------------------------------------------------------------------------------
LAB_0610:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.L  A3,D0
    BEQ.S   .LAB_0611

    TST.L   (A3)
    BEQ.S   .LAB_0611

    TST.L   4(A3)
    BEQ.S   .LAB_0611

    PEA     MODE_NEWFILE.W
    MOVE.L  LAB_1CF7,-(A7)
    JSR     DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    TST.L   D7
    BEQ.S   .LAB_0611

    PEA     4.W
    PEA     LAB_1D01
    MOVE.L  D7,-(A7)
    JSR     LAB_03A0(PC)

    MOVE.L  4(A3),(A7)
    MOVE.L  D7,-(A7)
    BSR.W   LAB_0605

    PEA     4.W
    PEA     LAB_1D02
    MOVE.L  D7,-(A7)
    JSR     LAB_03A0(PC)

    MOVE.L  (A3),(A7)
    MOVE.L  D7,-(A7)
    BSR.W   LAB_0605

    MOVE.L  D7,(A7)
    JSR     LAB_039A(PC)

    LEA     32(A7),A7
    MOVEQ   #1,D0
    BRA.S   .return

.LAB_0611:
    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,D7/A3
    RTS
