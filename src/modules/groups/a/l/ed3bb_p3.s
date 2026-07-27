    XDEF    _ED_DrawCursorChar
    XDEF    ED_UpdateCursorPosFromIndex


;------------------------------------------------------------------------------
; FUNC: _ED_DrawCursorChar   (Draw cursor characteruncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A6/A7/D0/D1
; CALLS:
;   _GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble, _GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble, ED_UpdateCursorPosFromIndex, ESQIFF_JMPTBL_MATH_Mulu32,
;   _LVOSetAPen, _LVOSetBPen, _LVOMove, _LVOText
; READS:
;   _ED_EditCursorOffset, ED_ViewportOffset, ED_CursorColumnIndex, _ED_EditBufferScratch, _ED_EditBufferLive, _Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the character at the current cursor position.
; NOTES:
;   Updates pen colors based on character mapping tables.
;------------------------------------------------------------------------------
_ED_DrawCursorChar:
    LINK.W  A5,#-4
    LEA     _ED_EditBufferLive,A0
    ADDA.L  _ED_EditCursorOffset,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    JSR     _GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    LEA     _ED_EditBufferLive,A0
    ADDA.L  _ED_EditCursorOffset,A0
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.L  D0,(A7)
    JSR     _GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetBPen(A6)

    MOVE.L  _ED_EditCursorOffset,(A7)
    BSR.W   ED_UpdateCursorPosFromIndex

    ADDQ.W  #4,A7
    MOVE.L  ED_CursorColumnIndex,D0
    LSL.L   #4,D0
    SUB.L   ED_CursorColumnIndex,D0
    MOVEQ   #40,D1
    ADD.L   D1,D0
    MOVE.L  D0,0(A7)
    MOVE.L  ED_ViewportOffset,D0
    MOVEQ   #30,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVEQ   #90,D1
    ADD.L   D1,D0
    MOVE.L  D0,D1
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVE.L  0(A7),D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    LEA     _ED_EditBufferScratch,A0
    ADDA.L  _ED_EditCursorOffset,A0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOText(A6)

    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ED_UpdateCursorPosFromIndex   (Update cursor row/col from indexuncertain)
; ARGS:
;   stack +4: u32 index
; RET:
;   (none)
; CLOBBERS:
;   A7/D0/D1/D7
; CALLS:
;   ESQIFF_JMPTBL_MATH_DivS32
; READS:
;   _ED_TextLimit
; WRITES:
;   ED_CursorColumnIndex, ED_ViewportOffset, _ED_EditCursorOffset
; DESC:
;   Computes row/column indices from a linear cursor index.
; NOTES:
;   Clamps ED_ViewportOffset and _ED_EditCursorOffset to visible ranges.
;------------------------------------------------------------------------------
ED_UpdateCursorPosFromIndex:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    MOVE.L  D7,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D1,ED_CursorColumnIndex
    MOVE.L  D7,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D0,ED_ViewportOffset

.clamp_cursor_loop:
    MOVE.L  ED_ViewportOffset,D0
    CMP.L   _ED_TextLimit,D0
    BLT.S   .return

    SUBQ.L  #1,ED_ViewportOffset
    MOVEQ   #40,D0
    SUB.L   D0,_ED_EditCursorOffset
    BRA.S   .clamp_cursor_loop

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======