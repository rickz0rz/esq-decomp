;!======
;------------------------------------------------------------------------------
; FUNC: LAB_19C4   (Parse mode string, open/prepare handle??)
; ARGS:
;   stack +8: A3 = mode string?? (expects 'r'/'w'/'a', optional 'b', '+')
;   stack +12: A2 = handle/struct pointer??
; RET:
;   D0: A2 on success, 0 on failure
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   UNKNOWN36_FinalizeRequest, LAB_19A1
; READS:
;   A4-1016 = ?? (default flags/state)
;   A3 (mode string bytes)
;   A2+24 (existing handle flags/state)
; WRITES:
;   A2+4/8/12/16/20/24/28 = ?? (handle fields)
; DESC:
;   Parses a mode string (r/w/a with optional b/+), builds flags, calls LAB_19A1,
;   then initializes the handle/struct on success.
; NOTES:
;   Booleanize pattern: SEQ/NEG/EXT. Returns 0 on failure.
;------------------------------------------------------------------------------
LAB_19C4:
    LINK.W  A5,#-16
    MOVEM.L D4-D7/A2-A3,-(A7)

    MOVEA.L 52(A7),A3
    MOVEA.L 56(A7),A2

    TST.L   24(A2)
    BEQ.S   .LAB_19C5

    MOVE.L  A2,-(A7)
    JSR     UNKNOWN36_FinalizeRequest(PC)

    ADDQ.W  #4,A7

.LAB_19C5:
    MOVE.L  -1016(A4),D5
    MOVEQ   #1,D7
    MOVEQ   #0,D0
    MOVE.B  0(A3,D7.L),D0
    CMPI.W  #$62,D0
    BEQ.S   .LAB_19C6

    CMPI.W  #$61,D0
    BNE.S   .LAB_19C8

    MOVEQ   #0,D5
    BRA.S   .LAB_19C7

.LAB_19C6:
    MOVE.L  #$8000,D5

.LAB_19C7:
    ADDQ.L  #1,D7

.LAB_19C8:
    MOVEQ   #43,D1
    CMP.B   0(A3,D7.L),D1
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    CMPI.W  #$77,D0
    BEQ.W   .LAB_19D2

    CMPI.W  #$72,D0
    BEQ.S   .LAB_19CC

    CMPI.W  #$61,D0
    BNE.W   .LAB_19D8

    PEA     12.W
    MOVE.L  #$8102,-(A7)
    MOVE.L  8(A5),-(A7)
    JSR     LAB_19A1(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D6
    MOVEQ   #-1,D0
    CMP.L   D0,D6
    BNE.S   .LAB_19C9

    MOVEQ   #0,D0
    BRA.W   .return

.LAB_19C9:
    TST.L   D4
    BEQ.S   .LAB_19CA

    MOVEQ   #64,D0
    ADD.L   D0,D0
    BRA.S   .LAB_19CB

.LAB_19CA:
    MOVEQ   #2,D0

.LAB_19CB:
    MOVE.L  D0,D7
    ORI.W   #$4000,D7
    BRA.W   .LAB_19D9

.LAB_19CC:
    TST.L   D4
    BEQ.S   .LAB_19CD

    MOVEQ   #2,D0
    BRA.S   .LAB_19CE

.LAB_19CD:
    MOVEQ   #0,D0

.LAB_19CE:
    ORI.W   #$8000,D0
    PEA     12.W
    MOVE.L  D0,-(A7)
    MOVE.L  8(A5),-(A7)
    JSR     LAB_19A1(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D6
    MOVEQ   #-1,D0
    CMP.L   D0,D6
    BNE.S   .LAB_19CF

    MOVEQ   #0,D0
    BRA.W   .return

.LAB_19CF:
    TST.L   D4
    BEQ.S   .LAB_19D0

    MOVEQ   #64,D0
    ADD.L   D0,D0
    BRA.S   .LAB_19D1

.LAB_19D0:
    MOVEQ   #1,D0

.LAB_19D1:
    MOVE.L  D0,D7
    BRA.S   .LAB_19D9

.LAB_19D2:
    TST.L   D4
    BEQ.S   .LAB_19D3

    MOVEQ   #2,D0
    BRA.S   .LAB_19D4

.LAB_19D3:
    MOVEQ   #1,D0

.LAB_19D4:
    ORI.W   #$8000,D0
    ORI.W   #$100,D0
    ORI.W   #$200,D0
    PEA     12.W
    MOVE.L  D0,-(A7)
    MOVE.L  8(A5),-(A7)
    JSR     LAB_19A1(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D6
    MOVEQ   #-1,D0
    CMP.L   D0,D6
    BNE.S   .LAB_19D5

    MOVEQ   #0,D0
    BRA.S   .return

.LAB_19D5:
    TST.L   D4
    BEQ.S   .LAB_19D6

    MOVEQ   #64,D0
    ADD.L   D0,D0
    BRA.S   .LAB_19D7

.LAB_19D6:
    MOVEQ   #2,D0

.LAB_19D7:
    MOVE.L  D0,D7
    BRA.S   .LAB_19D9

.LAB_19D8:
    MOVEQ   #0,D0
    BRA.S   .return

.LAB_19D9:
    SUBA.L  A0,A0
    MOVE.L  A0,16(A2)
    MOVEQ   #0,D0
    MOVE.L  D0,20(A2)
    MOVE.L  D6,28(A2)
    MOVE.L  16(A2),4(A2)
    MOVE.L  D0,12(A2)
    MOVE.L  D0,8(A2)
    TST.L   D5
    BNE.S   .LAB_19DA

    MOVE.L  #$8000,D0

.LAB_19DA:
    MOVE.L  D7,D1
    OR.L    D0,D1
    MOVE.L  D1,24(A2)
    MOVE.L  A2,D0

.return:
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD
