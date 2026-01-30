; Given a valid ClockData struct pushed to the stack, return the number of
; seconds from Amiga epoch, or 0 if illegal and store in D0.
GET_LEGAL_OR_SECONDS_FROM_EPOCH:
    MOVE.L  A6,-(A7)

    SetOffsetForStack 1

    MOVEA.L GLOB_REF_UTILITY_LIBRARY,A6
    MOVEA.L .stackOffsetBytes+4(A7),A0
    JSR     _LVOCheckDate(A6)

    MOVEA.L (A7)+,A6
    RTS

;!======

; Given a valid ClockData struct in 8(A7) return the number of
; seconds from Amiga epoch.
GET_SECONDS_FROM_EPOCH:
    MOVE.L  A6,-(A7)

    MOVEA.L GLOB_REF_UTILITY_LIBRARY,A6
    MOVEA.L 8(A7),A0
    JSR     _LVODate2Amiga(A6)

    MOVEA.L (A7)+,A6        ;33a6c: 2c5f
    RTS

;!======

    MOVE.L  4(A7),D0

;!======

LAB_1AE3:
    JSR     LAB_1AEB

    RTS

;!======

    MOVEA.L 4(A7),A0

;!======

LAB_1AE4:
    MOVE.B  (A0)+,D0
    BEQ.S   .return

    BSR.S   LAB_1AE3

    BRA.S   LAB_1AE4

.return:
    RTS

;!======

LAB_1AE6:
    BSR.S   LAB_1AE7

    TST.L   D0
    BMI.S   LAB_1AE6

    RTS

;!======

LAB_1AE7:
    JSR     LAB_1AEF

    RTS

;!======
; Below seems to be dead code...
;!======

    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    BRA.S   LAB_1AE9

LAB_1AE8:
    MOVEA.L 4(A7),A0
    LEA     8(A7),A1

LAB_1AE9:
    MOVEM.L A2,-(A7)
    LEA     LAB_1AE3(PC),A2
    BSR.S   JMP_TBL_RAW_DO_FMT_AGAINST_LAB_1AEB

    MOVEM.L (A7)+,A2
    RTS

;!======

JMP_TBL_RAW_DO_FMT_AGAINST_LAB_1AEB:
    JSR     RAW_DO_FMT_AGAINST_LAB_1AEB

    RTS

;!======

    MOVEM.L A2-A3,-(A7)
    MOVEM.L 12(A7),A0-A3
    BSR.S   JMP_TBL_RAW_DO_FMT_AGAINST_LAB_1AEB

    MOVEM.L (A7)+,A2-A3
    RTS

;!======

    ; ???
    DC.W    $0000
    MOVE.L  4(A7),D0

LAB_1AEB:
    MOVE.B  D0,-(A7)
    CMPI.B  #$a,D0
    BNE.S   LAB_1AEC

    MOVEQ   #13,D0
    BSR.S   LAB_1AED

LAB_1AEC:
    MOVE.B  (A7)+,D0

LAB_1AED:
    MOVE.B  CIAB_PRA,D1
    BTST    #0,D1
    BNE.S   LAB_1AED

    MOVE.B  #$ff,CIAA_DDRB
    MOVE.B  D0,CIAA_PRB
    RTS

;!======

RAW_DO_FMT_AGAINST_LAB_1AEB:
    MOVEM.L A2/A6,-(A7)

    LEA     LAB_1AEB(PC),A2
    MOVEA.L AbsExecBase,A6
    JSR     _LVORawDoFmt(A6)

    MOVEM.L (A7)+,A2/A6
    RTS

;!======

LAB_1AEF:
    MOVEQ   #-1,D0
    RTS

;!======

    ; Alignment
    ALIGN_WORD
