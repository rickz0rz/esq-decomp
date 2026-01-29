LAB_198E:
    DC.W    $3031
    DC.W    $3233
    DC.W    $3435
    MOVE.W  57(A7,D3.L),D3
    BSR.S   LAB_1995

    BLS.S   LAB_1996+2

    BCS.S   LAB_1998

LAB_198F:
    MOVE.L  8(A7),D0
    MOVEA.L 4(A7),A0
    LEA     4(A7),A1

.LAB_1990:
    MOVE.W  D0,D1
    ANDI.W  #15,D1
    MOVE.B  LAB_198E(PC,D1.W),(A1)+
    LSR.L   #4,D0
    BNE.S   .LAB_1990

    MOVE.L  A1,D0
    MOVE.L  A7,D1
    ADDQ.L  #4,D1

.LAB_1991:
    MOVE.B  -(A1),(A0)+
    CMP.L   A1,D1
    BNE.S   .LAB_1991

    CLR.B   (A0)
    SUB.L   D1,D0
    RTS

;!======

LAB_1992:
    MOVEA.L 4(A7),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D1
    MOVEQ   #0,D0
    MOVE.L  D2,-(A7)
    CMPI.B  #$2b,(A0)
    BEQ.S   .LAB_1993

    CMPI.B  #$2d,(A0)
    BNE.S   LAB_1994

.LAB_1993:
    ADDQ.W  #1,A0

LAB_1994:
    MOVE.B  (A0)+,D0
    SUBI.B  #$30,D0
    BLT.S   LAB_1996

    CMPI.B  #$9,D0
    BGT.S   LAB_1996

    MOVE.L  D1,D2
    ASL.L   #2,D1
    ADD.L   D2,D1
    ADD.L   D1,D1
    ADD.L   D0,D1

LAB_1995:
    BRA.S   LAB_1994

LAB_1996:
    CMPI.B  #$2d,(A1)
    BNE.S   LAB_1999

LAB_1998:
    NEG.L   D1

LAB_1999:
    MOVE.L  (A7)+,D2
    MOVE.L  A0,D0
    SUBQ.L  #1,D0
    MOVEA.L 8(A7),A0
    MOVE.L  D1,(A0)
    SUB.L   A1,D0
    RTS

;!======

LAB_199A:
    MOVEA.L 4(A7),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D1
    MOVEQ   #0,D0
    MOVE.L  D2,-(A7)
    CMPI.B  #$2b,(A0)
    BEQ.S   LAB_199B

    CMPI.B  #$2d,(A0)
    BNE.S   LAB_199C

LAB_199B:
    ADDQ.W  #1,A0

LAB_199C:
    MOVE.B  (A0)+,D0
    SUBI.B  #$30,D0
    BLT.S   LAB_199D

    CMPI.B  #$9,D0
    BGT.S   LAB_199D

    MOVE.L  D1,D2
    ASL.L   #2,D1
    ADD.L   D2,D1
    ADD.L   D1,D1
    ADD.L   D0,D1
    BRA.S   LAB_199C

LAB_199D:
    CMPI.B  #$2d,(A1)
    BNE.S   LAB_199E

    NEG.L   D1

LAB_199E:
    MOVE.L  (A7)+,D2
    MOVE.L  A0,D0
    SUBQ.L  #1,D0
    MOVEA.L 8(A7),A0
    MOVE.L  D1,(A0)
    SUB.L   A1,D0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: WDISP_PrintfPutc   (PrintfPutcToBuffer)
; ARGS:
;   D0.b: character to append
; RET:
;   (none)
; CLOBBERS:
;   D0, D7
; CALLS:
;   (none)
; READS:
;   22812(A4), 22816(A4)
; WRITES:
;   22812(A4), 22816(A4), [buffer]
; DESC:
;   Appends one byte to the current printf output buffer and advances the cursor.
; NOTES:
;   Uses A4-relative globals for the buffer pointer and byte count.
;------------------------------------------------------------------------------
WDISP_PrintfPutc:
LAB_199F:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7

    ADDQ.L  #1,22816(A4)
    MOVE.L  D7,D0
    MOVEA.L 22812(A4),A0
    MOVE.B  D0,(A0)+
    MOVE.L  A0,22812(A4)

    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: WDISP_SPrintf   (SPrintfToBuffer)
; ARGS:
;   stack +4: outBuf
;   stack +8: formatStr
;   stack +12+: varargs
; RET:
;   D0: bytes written (excluding terminator)
; CLOBBERS:
;   D0, A0, A2-A3
; CALLS:
;   WDISP_FormatWithCallback (core formatter), WDISP_PrintfPutc
; READS:
;   (none)
; WRITES:
;   outBuf, 22812(A4), 22816(A4)
; DESC:
;   Formats into the provided buffer using the local printf core and returns length.
; NOTES:
;   Zero-terminates the output.
;------------------------------------------------------------------------------
WDISP_SPrintf:
PRINTF:
    LINK.W  A5,#0
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEA.L 20(A7),A2

    CLR.L   22816(A4)       ; Clear 22816(A4)
    MOVE.L  A3,22812(A4)
    PEA     16(A5)
    MOVE.L  A2,-(A7)
    PEA     WDISP_PrintfPutc(PC)
    JSR     WDISP_FormatWithCallback(PC)

    MOVEA.L 22812(A4),A0
    CLR.B   (A0)
    MOVE.L  22816(A4),D0    ; Store 22816(A4) in D0

    MOVEM.L -8(A5),A2-A3
    UNLK    A5
    RTS

;!======

LAB_19A1:
    LINK.W  A5,#-26
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVEA.L 58(A7),A3
    MOVE.L  62(A7),D7

    CLR.B   -1(A5)
    CLR.L   -640(A4)
    MOVE.L  22828(A4),-14(A5)
    MOVEQ   #3,D5

.LAB_19A2:
    CMP.L   -1148(A4),D5
    BGE.S   .LAB_19A3

    MOVE.L  D5,D0
    ASL.L   #3,D0
    LEA     22492(A4),A0
    TST.L   0(A0,D0.L)
    BEQ.S   .LAB_19A3

    ADDQ.L  #1,D5
    BRA.S   .LAB_19A2

.LAB_19A3:
    MOVE.L  -1148(A4),D0
    CMP.L   D5,D0
    BNE.S   .LAB_19A4

    MOVEQ   #24,D0
    MOVE.L  D0,22828(A4)
    MOVEQ   #-1,D0
    BRA.W   .return

.LAB_19A4:
    MOVE.L  D5,D0
    ASL.L   #3,D0
    LEA     22492(A4),A0
    ADDA.L  D0,A0
    MOVEA.L A0,A2
    TST.L   16(A5)
    BEQ.S   .LAB_19A5

    BTST    #2,19(A5)
    BEQ.S   .LAB_19A6

.LAB_19A5:
    MOVE.L  #$3ec,-18(A5)
    BRA.S   .LAB_19A7

.LAB_19A6:
    MOVE.L  #$3ee,-18(A5)

.LAB_19A7:
    MOVE.L  #$8000,D0
    AND.L   -1124(A4),D0
    EOR.L   D0,D7
    BTST    #3,D7
    BEQ.S   .LAB_19A8

    MOVE.L  D7,D0
    ANDI.W  #$fffc,D0
    MOVE.L  D0,D7
    ORI.W   #2,D7

.LAB_19A8:
    MOVE.L  D7,D0
    MOVEQ   #3,D1
    AND.L   D1,D0
    CMPI.L  #$2,D0
    BEQ.S   .LAB_19A9

    CMPI.L  #$1,D0
    BEQ.S   .LAB_19A9

    TST.L   D0
    BNE.S   .LAB_19AA

.LAB_19A9:
    MOVE.L  D7,D6
    ADDQ.L  #1,D6
    BRA.S   .LAB_19AB

.LAB_19AA:
    MOVEQ   #22,D0
    MOVE.L  D0,22828(A4)
    MOVEQ   #-1,D0
    BRA.W   .return

.LAB_19AB:
    MOVE.L  D7,D0
    ANDI.L  #$300,D0
    BEQ.W   .LAB_19AF

    BTST    #10,D7
    BEQ.S   .LAB_19AC

    MOVE.B  #$1,-1(A5)
    MOVE.L  -18(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_19FA(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D4
    BRA.S   .LAB_19AE

.LAB_19AC:
    BTST    #9,D7
    BNE.S   .LAB_19AD

    PEA     1005.W
    MOVE.L  A3,-(A7)
    JSR     LAB_19F3(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D4
    TST.L   D4
    BPL.S   .LAB_19AD

    BSET    #9,D7

.LAB_19AD:
    BTST    #9,D7
    BEQ.S   .LAB_19AE

    MOVE.B  #$1,-1(A5)
    MOVE.L  -14(A5),22828(A4)
    MOVE.L  -18(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_19FF(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D4

.LAB_19AE:
    TST.B   -1(A5)
    BEQ.S   .LAB_19B0

    MOVE.L  D7,D0
    MOVEQ   #120,D1
    ADD.L   D1,D1
    AND.L   D1,D0
    TST.L   D0
    BEQ.S   .LAB_19B0

    TST.L   D4
    BMI.S   .LAB_19B0

    MOVE.L  D4,-(A7)
    JSR     LAB_1A04(PC)

    PEA     1005.W
    MOVE.L  A3,-(A7)
    JSR     LAB_19F3(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D4
    BRA.S   .LAB_19B0

.LAB_19AF:
    PEA     1005.W
    MOVE.L  A3,-(A7)
    JSR     LAB_19F3(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D4

.LAB_19B0:
    TST.L   -640(A4)
    BEQ.S   .LAB_19B1

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_19B1:
    MOVE.L  D6,(A2)
    MOVE.L  D4,4(A2)
    MOVE.L  D5,D0

.return:
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000
    MOVEQ   #97,D0
