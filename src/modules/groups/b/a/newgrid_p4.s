    XDEF    _NEWGRID_DrawGridFrame
    XDEF    _NEWGRID_ShouldOpenEditor



;------------------------------------------------------------------------------
; FUNC: _NEWGRID_DrawGridFrame   (Draw grid frame sections)
; ARGS:
;   stack +8: A3 = grid struct/rastport
;   stack +16: D7 = pen for first fill
;   stack +20: D6 = pen for second fill
;   stack +24: D5 = y2 for first fill
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID_SetRowColor, _NEWGRID_FillGridRects (_NEWGRID_FillGridRects)
; READS:
;   _NEWGRID_ColumnStartXPx
; WRITES:
;   none
; DESC:
;   Draws header frame segments using pens and coordinates.
; NOTES:
;   Uses _NEWGRID_SetRowColor to set pens before filling.
;------------------------------------------------------------------------------
_NEWGRID_DrawGridFrame:
    LINK.W  A5,#-8
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  16(A5),D7
    MOVE.L  20(A5),D6
    MOVE.L  24(A5),D5

    LEA     60(A3),A0
    MOVE.L  D7,-(A7)
    PEA     -1.W
    MOVE.L  A3,-(A7)
    MOVE.L  A0,28(A7)
    JSR     _NEWGRID_SetRowColor(PC)

    MOVE.L  D6,(A7)
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D0,40(A7)
    JSR     _NEWGRID_SetRowColor(PC)

    MOVE.L  D5,(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  44(A7),-(A7)
    MOVE.L  44(A7),-(A7)
    BSR.W   _NEWGRID_FillGridRects

    MOVEM.L -24(A5),D5-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_ShouldOpenEditor   (Check if entry can open editor)
; ARGS:
;   stack +8: A3 = entry pointer
; RET:
;   D0: 1 if editable, 0 otherwise
; CLOBBERS:
;   D0/D7/A0-A3
; CALLS:
;   _NEWGRID2_JMPTBL_STR_SkipClass3Chars
; READS:
;   entry fields at 1(A3)/19(A3), bit 5 at 27(A3)
; WRITES:
;   none
; DESC:
;   Checks text fields and flags to decide whether to open the editor.
; NOTES:
;   Returns true when both strings are empty and flag bit 5 is set.
;------------------------------------------------------------------------------
_NEWGRID_ShouldOpenEditor:
    LINK.W  A5,#-12
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D7
    MOVE.L  A3,D0
    BEQ.S   .return_open_flag

    LEA     19(A3),A0
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-12(A5)
    JSR     _NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    LEA     1(A3),A0
    MOVE.L  A0,(A7)
    MOVE.L  D0,-12(A5)
    MOVE.L  A0,-8(A5)
    JSR     _NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,-8(A5)
    TST.L   -12(A5)
    BEQ.S   .check_primary_text

    MOVEA.L -12(A5),A0
    TST.B   (A0)
    BNE.S   .reject_open

.check_primary_text:
    TST.L   D0
    BEQ.S   .check_editor_flag

    MOVEA.L D0,A0
    TST.B   (A0)
    BNE.S   .reject_open

.check_editor_flag:
    BTST    #5,27(A3)
    BEQ.S   .reject_open

    MOVEQ   #1,D0
    BRA.S   .store_open_decision

.reject_open:
    MOVEQ   #0,D0

.store_open_decision:
    MOVE.L  D0,D7

.return_open_flag:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======