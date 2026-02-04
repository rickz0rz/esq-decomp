;------------------------------------------------------------------------------
; FUNC: HANDLE_CloseAllAndReturnWithCode   (Close all handles, then return w/ code.)
; ARGS:
;   stack +4: D7 = return code passed to ESQ_ReturnWithStackCode
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D7/A0
; CALLS:
;   DOS_CloseWithSignalCheck (close handle), ESQ_ReturnWithStackCode
; READS:
;   Global_HandleTableCount, Global_HandleTableBase
; DESC:
;   Iterates the handle table and closes entries not flagged with bit 4,
;   then tail-calls ESQ_ReturnWithStackCode with the provided code.
;------------------------------------------------------------------------------
HANDLE_CloseAllAndReturnWithCode:
    MOVEM.L D5-D7,-(A7)

    SetOffsetForStack 3
    UseStackLong    MOVE.L,1,D7

    MOVE.L  Global_HandleTableCount(A4),D0
    SUBQ.L  #1,D0
    MOVE.L  D0,D6

.loop:
    TST.W   D6
    BMI.S   .after_close

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #3,D0
    LEA     Global_HandleTableBase(A4),A0
    MOVE.L  0(A0,D0.L),D5
    TST.B   D5
    BEQ.S   .next_entry

    BTST    #4,D5
    BNE.S   .next_entry

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #3,D0
    LEA     Global_HandleTableBase(A4),A0
    MOVE.L  4(A0,D0.L),-(A7)
    JSR     DOS_CloseWithSignalCheck(PC)

    ADDQ.W  #4,A7

.next_entry:
    SUBQ.W  #1,D6
    BRA.S   .loop

.after_close:
    MOVE.L  D7,-(A7)
    JSR     WDISP_JMPTBL_ESQ_ReturnWithStackCode(PC)

    ADDQ.W  #4,A7
    MOVEM.L (A7)+,D5-D7
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

;------------------------------------------------------------------------------
; FUNC: WDISP_JMPTBL_ESQ_ReturnWithStackCode   (Jump stub to ESQ_ReturnWithStackCode)
;------------------------------------------------------------------------------
WDISP_JMPTBL_ESQ_ReturnWithStackCode:
    JMP     ESQ_ReturnWithStackCode

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000
