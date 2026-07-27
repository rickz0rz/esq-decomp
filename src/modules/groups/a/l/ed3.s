    XDEF    _ED_GetEscMenuActionCode


;------------------------------------------------------------------------------
; FUNC: _ED_GetEscMenuActionCode   (Get ESC menu action codeuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/D0/D1
; CALLS:
;   (none)
; READS:
;   _ED_LastKeyCode, _ED_EditCursorOffset, _ED_LastMenuInputChar, _ED_StateRingIndex, _ED_StateRingTable
; WRITES:
;   _ED_LastMenuInputChar
; DESC:
;   Decodes the current ESC-menu key/selection into an action code.
; NOTES:
;   Uses a small switch table when _ED_LastKeyCode matches the menu-mode case.
;------------------------------------------------------------------------------
_ED_GetEscMenuActionCode:
    MOVE.L  _ED_StateRingIndex,D0
    LSL.L   #2,D0
    ADD.L   _ED_StateRingIndex,D0
    LEA     _ED_StateRingTable,A0
    ADDA.L  D0,A0
    MOVE.B  1(A0),_ED_LastMenuInputChar
    MOVEQ   #0,D0
    MOVE.B  _ED_LastKeyCode,D0
    SUBQ.W  #3,D0
    BEQ.S   .case_return_8

    SUBI.W  #10,D0
    BEQ.S   .case_index_dispatch

    SUBI.W  #14,D0
    BEQ.S   .case_return_zero

    SUBI.W  #$80,D0
    BEQ.S   .case_check_alpha

    BRA.S   .case_default_10

.case_return_zero:
    MOVEQ   #0,D0
    BRA.S   .return

.case_index_dispatch:
    MOVE.L  _ED_EditCursorOffset,D0
    CMPI.L  #$6,D0
    BCC.S   .case_return_8

    ADD.W   D0,D0
    MOVE.W  .dispatch_table(PC,D0.W),D0
    JMP     .dispatch_table+2(PC,D0.W)

; Another jump table for switch
.dispatch_table:
    DC.W    .select_code1-.dispatch_table-2
    DC.W    .select_code2-.dispatch_table-2
	DC.W    .select_code3-.dispatch_table-2
    DC.W    .select_code4-.dispatch_table-2
	DC.W    .select_code5-.dispatch_table-2
    DC.W    .select_code6-.dispatch_table-2

.select_code1:
    MOVEQ   #1,D0
    BRA.S   .return

.select_code2:
    MOVEQ   #2,D0
    BRA.S   .return

.select_code3:
    MOVEQ   #3,D0
    BRA.S   .return

.select_code4:
    MOVEQ   #4,D0
    BRA.S   .return

.select_code5:
    MOVEQ   #5,D0
    BRA.S   .return

.select_code6:
    MOVEQ   #6,D0
    BRA.S   .return

.case_return_8:
    MOVEQ   #8,D0
    BRA.S   .return

.case_check_alpha:
    MOVE.B  _ED_LastMenuInputChar,D0
    MOVEQ   #65,D1
    CMP.B   D1,D0
    BNE.S   .case_default_10

    MOVEQ   #9,D0
    BRA.S   .return

.case_default_10:
    MOVEQ   #10,D0

.return:
    RTS

;!======
