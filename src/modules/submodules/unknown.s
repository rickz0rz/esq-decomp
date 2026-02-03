;!======
;------------------------------------------------------------------------------
; FUNC: LAB_18D7   (Parse record, update globals, and display??)
; ARGS:
;   stack +8: A3 = input buffer pointer??
; RET:
;   D0: ?? (pass/fail via side effects)
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   LAB_1902, LAB_1905, JMPTBL_DISPLAY_TEXT_AT_POSITION_2
; READS:
;   LAB_2252, LAB_2245, LAB_1DEC, GLOB_REF_RASTPORT_1
; WRITES:
;   LAB_1DEC, LAB_227F, LAB_229B, LAB_229C
; DESC:
;   Parses a small record from the input buffer, validates via wildcard match,
;   updates globals, and optionally redraws text.
; NOTES:
;   Uses 0x12 sentinel and max length 10 for local buffer.
;------------------------------------------------------------------------------
LAB_18D7:
    LINK.W  A5,#-16
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3

    MOVE.B  (A3)+,D6
    MOVE.B  (A3)+,D5
    MOVE.B  (A3)+,D4
    ADDQ.L  #1,A3
    MOVEQ   #2,D0
    CMP.B   D0,D4
    BCS.S   .LAB_18D8

    MOVEQ   #6,D0
    CMP.B   D0,D4
    BLS.S   .LAB_18D9

.LAB_18D8:
    MOVEQ   #1,D4

.LAB_18D9:
    MOVEQ   #0,D7

.LAB_18DA:
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-16(A5,D7.W)
    MOVEQ   #18,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_18DB

    MOVEQ   #10,D0
    CMP.W   D0,D7
    BGE.S   .LAB_18DB

    ADDQ.W  #1,D7
    BRA.S   .LAB_18DA

.LAB_18DB:
    MOVEQ   #0,D0
    MOVE.B  D0,-16(A5,D7.W)
    MOVE.B  -16(A5),D1
    TST.B   D1
    BEQ.S   .return

    PEA     -16(A5)
    PEA     LAB_2245
    JSR     LAB_1902(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .return

    MOVE.L  LAB_1DEC,-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1905(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_1DEC
    MOVE.B  D6,LAB_227F
    MOVE.B  D5,LAB_229B
    MOVE.B  D4,LAB_229C
    TST.W   LAB_2252
    BEQ.S   .return

    MOVE.L  LAB_1DEC,-(A7)
    PEA     172.W
    CLR.L   -(A7)
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMPTBL_DISPLAY_TEXT_AT_POSITION_2(PC)

    LEA     16(A7),A7

.return:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_18DD   (Parse list and update LAB_2197 entries??)
; ARGS:
;   stack +8: A3 = input buffer pointer??
; RET:
;   D0: ?? (pass/fail via side effects)
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   LAB_1902, LAB_1903, LAB_1955, LAB_1A23, LAB_1A06
; READS:
;   LAB_2246, LAB_227C, LAB_2277, LAB_2197
; WRITES:
;   LAB_2196, LAB_2197 entries, LAB_229C?? (indirect)
; DESC:
;   Parses a list of records from the input buffer and updates LAB_2197
;   table entries, including optional numeric fields and flags.
; NOTES:
;   Uses 0x12 sentinel and max length 10 for local buffer.
;------------------------------------------------------------------------------
LAB_18DD:
    LINK.W  A5,#-36
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3

    MOVEQ   #0,D7

.LAB_18DE:
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-15(A5,D7.W)
    MOVEQ   #18,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_18DF

    MOVEQ   #10,D0
    CMP.W   D0,D7
    BGE.S   .LAB_18DF

    ADDQ.W  #1,D7
    BRA.S   .LAB_18DE

.LAB_18DF:
    MOVEQ   #0,D0
    MOVE.B  D0,-15(A5,D7.W)
    MOVE.B  -15(A5),D1
    TST.B   D1
    BEQ.W   .return

    PEA     -15(A5)
    PEA     LAB_2246
    JSR     LAB_1902(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.W   .return

    MOVEQ   #0,D7

.LAB_18E0:
    MOVEQ   #4,D0
    CMP.W   D0,D7
    BGE.S   .LAB_18E1

    MOVE.L  D7,D0
    MULS    #20,D0
    LEA     LAB_2197,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #1,D1
    MOVE.L  D1,16(A1)
    MOVE.W  LAB_227C,D1
    ADD.W   D7,D1
    MOVE.L  D1,D6
    ADDQ.W  #1,D6
    ADDA.L  D0,A0
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.W  LAB_2277,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,28(A7)
    JSR     LAB_1903(PC)

    ADDQ.W  #8,A7
    EXT.L   D0
    MOVEA.L 20(A7),A0
    MOVE.L  D0,(A0)
    ADDQ.W  #1,D7
    BRA.S   .LAB_18E0

.LAB_18E1:
    MOVE.B  (A3)+,LAB_2196
    MOVE.B  (A3)+,D5

.LAB_18E2:
    MOVEQ   #43,D0
    CMP.B   D0,D5
    BNE.W   .return

    PEA     3.W
    MOVE.L  A3,-(A7)
    PEA     -25(A5)
    JSR     LAB_1955(PC)

    CLR.B   -22(A5)
    PEA     -25(A5)
    JSR     LAB_1A23(PC)

    LEA     16(A7),A7
    MOVE.L  D0,D6
    ADDQ.L  #3,A3
    MOVEQ   #0,D4

.LAB_18E3:
    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    ADDA.L  D0,A0
    MOVE.L  D6,D0
    EXT.L   D0
    CMP.L   (A0),D0
    BEQ.S   .LAB_18E4

    MOVEQ   #4,D0
    CMP.L   D0,D4
    BGE.S   .LAB_18E4

    ADDQ.L  #1,D4
    BRA.S   .LAB_18E3

.LAB_18E4:
    TST.L   D4
    BMI.S   .LAB_18E5

    MOVEQ   #3,D0
    CMP.L   D0,D4
    BLE.S   .LAB_18E6

.LAB_18E5:
    MOVEQ   #0,D5

.LAB_18E6:
    MOVEQ   #43,D0
    CMP.B   D0,D5
    BNE.W   .LAB_18ED

    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    ADDA.L  D0,A0
    CLR.L   16(A0)
    PEA     1.W
    MOVE.L  A3,-(A7)
    PEA     -25(A5)
    JSR     LAB_1955(PC)

    LEA     12(A7),A7
    CLR.B   -24(A5)
    MOVE.B  -25(A5),D0
    MOVEQ   #63,D1
    CMP.B   D1,D0
    BNE.S   .LAB_18E7

    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #1,D0
    MOVE.L  D0,4(A1)
    BRA.S   .LAB_18E8

.LAB_18E7:
    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    ADDA.L  D0,A0
    PEA     -25(A5)
    MOVE.L  A0,24(A7)
    JSR     LAB_1A23(PC)

    ADDQ.W  #4,A7
    MOVEA.L 20(A7),A0
    MOVE.L  D0,4(A0)

.LAB_18E8:
    ADDQ.L  #1,A3
    PEA     3.W
    MOVE.L  A3,-(A7)
    PEA     -25(A5)
    JSR     LAB_1955(PC)

    LEA     12(A7),A7
    CLR.B   -22(A5)
    MOVE.B  -25(A5),D0
    MOVEQ   #63,D1
    CMP.B   D1,D0
    BNE.S   .LAB_18E9

    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  #(-999),8(A1)
    BRA.S   .LAB_18EA

.LAB_18E9:
    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    ADDA.L  D0,A0
    PEA     -25(A5)
    MOVE.L  A0,24(A7)
    JSR     LAB_1A23(PC)

    ADDQ.W  #4,A7
    MOVEA.L 20(A7),A0
    MOVE.L  D0,8(A0)

.LAB_18EA:
    ADDQ.L  #3,A3
    PEA     3.W
    MOVE.L  A3,-(A7)
    PEA     -25(A5)
    JSR     LAB_1955(PC)

    LEA     12(A7),A7
    CLR.B   -22(A5)
    MOVE.B  -25(A5),D0
    MOVEQ   #63,D1
    CMP.B   D1,D0
    BNE.S   .LAB_18EB

    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVE.L  #(-999),12(A1)
    BRA.S   .LAB_18EC

.LAB_18EB:
    MOVE.L  D4,D0
    MOVEQ   #20,D1
    JSR     LAB_1A06(PC)

    LEA     LAB_2197,A0
    ADDA.L  D0,A0
    PEA     -25(A5)
    MOVE.L  A0,24(A7)
    JSR     LAB_1A23(PC)

    ADDQ.W  #4,A7
    MOVEA.L 20(A7),A0
    MOVE.L  D0,12(A0)

.LAB_18EC:
    ADDQ.L  #3,A3
    MOVE.B  (A3)+,D5
    BRA.W   .LAB_18E2

.LAB_18ED:
    ADDQ.L  #7,A3
    MOVE.B  (A3)+,D5
    BRA.W   .LAB_18E2

.return:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_18EF   (Validate checksum and dispatch to LAB_18D7)
; ARGS:
;   stack +8: D7 = ?? (byte parameter)
; RET:
;   D0: ?? (pass/fail via side effects)
; CLOBBERS:
;   D0-D7 ??
; CALLS:
;   LAB_1900, JMPTBL_GENERATE_CHECKSUM_BYTE_INTO_D0_2, LAB_18D7
; READS:
;   LAB_229A, LAB_2253, DATACErrs
; WRITES:
;   LAB_2285, LAB_2232, DATACErrs
; DESC:
;   Computes a checksum and, on success, invokes LAB_18D7; otherwise bumps error count.
; NOTES:
;   Uses stack param byte at 11(A7).
;------------------------------------------------------------------------------
LAB_18EF:
    MOVE.L  D7,-(A7)

    MOVE.B  11(A7),D7
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_229A,-(A7)
    JSR     LAB_1900(PC)

    MOVE.W  D0,LAB_2232
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    MOVE.L  D1,(A7)
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMPTBL_GENERATE_CHECKSUM_BYTE_INTO_D0_2(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BNE.S   .LAB_18F0

    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_18D7

    ADDQ.W  #4,A7
    BRA.S   .return

.LAB_18F0:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_18F2   (Validate checksum and dispatch to LAB_18DD)
; ARGS:
;   stack +8: D7 = ?? (byte parameter)
; RET:
;   D0: ?? (pass/fail via side effects)
; CLOBBERS:
;   D0-D7 ??
; CALLS:
;   LAB_1900, JMPTBL_GENERATE_CHECKSUM_BYTE_INTO_D0_2, LAB_18DD
; READS:
;   LAB_229A, LAB_2253, DATACErrs
; WRITES:
;   LAB_2285, LAB_2232, DATACErrs
; DESC:
;   Computes a checksum and, on success, invokes LAB_18DD; otherwise bumps error count.
; NOTES:
;   Uses stack param byte at 11(A7).
;------------------------------------------------------------------------------
LAB_18F2:
    MOVE.L  D7,-(A7)

    MOVE.B  11(A7),D7
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_229A,-(A7)
    JSR     LAB_1900(PC)

    MOVE.W  D0,LAB_2232
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_2232,D1
    MOVE.L  D1,(A7)
    MOVE.L  LAB_229A,-(A7)
    MOVE.L  D0,-(A7)
    JSR     JMPTBL_GENERATE_CHECKSUM_BYTE_INTO_D0_2(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D1
    MOVE.B  LAB_2253,D1
    CMP.L   D1,D0
    BNE.S   .LAB_18F3

    MOVE.L  LAB_229A,-(A7)
    BSR.W   LAB_18DD

    ADDQ.W  #4,A7
    BRA.S   .return

.LAB_18F3:
    MOVE.W  DATACErrs,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATACErrs

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_18F5   (Parse digit + label, update globals, and display??)
; ARGS:
;   stack +8: A3 = input buffer pointer??
; RET:
;   D0: ?? (pass/fail via side effects)
; CLOBBERS:
;   D0-D2/D7/A0-A3 ??
; CALLS:
;   LAB_1905, JMPTBL_DISPLAY_TEXT_AT_POSITION_2
; READS:
;   LAB_1DD9, LAB_2252, GLOB_REF_RASTPORT_1
; WRITES:
;   LAB_229D, LAB_1DD9, LAB_2245
; DESC:
;   Parses a digit plus a short label string, stores it, and optionally redraws text.
; NOTES:
;   Clamps digit to '0'..'9'; uses 0x12 sentinel and max length 10 for label.
;------------------------------------------------------------------------------
LAB_18F5:
    LINK.W  A5,#-16
    MOVEM.L D2/D7/A3,-(A7)
    MOVEA.L 8(A5),A3

    MOVEQ   #0,D0
    MOVE.B  (A3)+,D0
    MOVE.W  D0,LAB_229D
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BLT.S   .LAB_18F6

    MOVEQ   #57,D2
    CMP.W   D2,D0
    BLE.S   .LAB_18F7

.LAB_18F6:
    MOVE.W  D1,LAB_229D

.LAB_18F7:
    MOVEQ   #0,D7

.LAB_18F8:
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-13(A5,D7.W)
    MOVEQ   #18,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_18F9

    MOVEQ   #10,D0
    CMP.W   D0,D7
    BGE.S   .LAB_18F9

    ADDQ.W  #1,D7
    BRA.S   .LAB_18F8

.LAB_18F9:
    CLR.B   -13(A5,D7.W)
    LEA     -13(A5),A0
    LEA     LAB_2245,A1

.LAB_18FA:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_18FA

    MOVE.L  LAB_1DD9,-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_1905(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_1DD9
    TST.W   LAB_2252
    BEQ.S   .return

    MOVE.L  D0,-(A7)
    PEA     172.W
    CLR.L   -(A7)
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     JMPTBL_DISPLAY_TEXT_AT_POSITION_2(PC)

    LEA     16(A7),A7

.return:
    MOVEM.L (A7)+,D2/D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_18FC   (Copy short label into LAB_2246)
; ARGS:
;   stack +8: A3 = input buffer pointer??
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   none
; READS:
;   (none)
; WRITES:
;   LAB_2246
; DESC:
;   Copies a short label string from the input buffer into LAB_2246.
; NOTES:
;   Uses 0x12 sentinel and max length 10 for label.
;------------------------------------------------------------------------------
LAB_18FC:
    LINK.W  A5,#-16
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D7

.LAB_18FD:
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-13(A5,D7.W)
    MOVEQ   #18,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_18FE

    MOVEQ   #10,D0
    CMP.W   D0,D7
    BGE.S   .LAB_18FE

    ADDQ.W  #1,D7
    BRA.S   .LAB_18FD

.LAB_18FE:
    CLR.B   -13(A5,D7.W)
    LEA     -13(A5),A0
    LEA     LAB_2246,A1

.LAB_18FF:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_18FF

    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_1900   (JumpStub_LAB_0B0E)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   LAB_0B0E
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Jump stub to LAB_0B0E.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
LAB_1900:
    JMP     LAB_0B0E

;------------------------------------------------------------------------------
; FUNC: JMPTBL_DISPLAY_TEXT_AT_POSITION_2   (JumpStub_DISPLAY_TEXT_AT_POSITION)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   DISPLAY_TEXT_AT_POSITION
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Jump stub to DISPLAY_TEXT_AT_POSITION.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_DISPLAY_TEXT_AT_POSITION_2:
    JMP     DISPLAY_TEXT_AT_POSITION

;------------------------------------------------------------------------------
; FUNC: LAB_1902   (JumpStub_ESQ_WildcardMatch)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   ESQ_WildcardMatch
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Jump stub to ESQ_WildcardMatch.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
LAB_1902:
    JMP     ESQ_WildcardMatch

;------------------------------------------------------------------------------
; FUNC: LAB_1903   (JumpStub_LAB_0631)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   LAB_0631
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Jump stub to LAB_0631.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
LAB_1903:
    JMP     LAB_0631

;------------------------------------------------------------------------------
; FUNC: JMPTBL_GENERATE_CHECKSUM_BYTE_INTO_D0_2   (JumpStub_GENERATE_CHECKSUM_BYTE_INTO_D0)
; ARGS:
;   ??
; RET:
;   D0: checksum byte
; CLOBBERS:
;   ??
; CALLS:
;   GENERATE_CHECKSUM_BYTE_INTO_D0
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Jump stub to GENERATE_CHECKSUM_BYTE_INTO_D0.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_GENERATE_CHECKSUM_BYTE_INTO_D0_2:
    JMP     GENERATE_CHECKSUM_BYTE_INTO_D0

;------------------------------------------------------------------------------
; FUNC: LAB_1905   (JumpStub_LAB_0B44)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   LAB_0B44
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Jump stub to LAB_0B44.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
LAB_1905:
    JMP     LAB_0B44

;!======

    ; Alignment
    RTS
    DC.W    $0000
