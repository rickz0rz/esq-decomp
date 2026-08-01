    XDEF    _DISPTEXT_LayoutSourceToLines

;------------------------------------------------------------------------------
; FUNC: _DISPTEXT_LayoutSourceToLines   (Layout source text into lines)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +264: arg_3 (via 268(A5))
; RET:
;   D0: boolean success (0/-1)
; CLOBBERS:
;   A0/A1/A2/A3/A6/A7/D0/D1/D2/D5/D6/D7
; CALLS:
;   _DISPTEXT_BuildLineWithWidth, _LVOTextLength
; READS:
;   _DISPTEXT_TextBufferPtr/21D4/21D5/21D6/21D7/21D9/21DA/21DB
; WRITES:
;   _DISPTEXT_CurrentLineIndex
; DESC:
;   Iterates over lines, measuring and formatting text into the line buffer.
; NOTES:
;   Uses line offset tables _DISPTEXT_LinePtrTable/_DISPTEXT_LineLengthTable.
;------------------------------------------------------------------------------
_DISPTEXT_LayoutSourceToLines:
    LINK.W  A5,#-276
    MOVEM.L D2/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEQ   #0,D7
    TST.L   _DISPTEXT_LineTableLockFlag
    BNE.W   .return_status

    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    MOVE.W  _DISPTEXT_TargetLineIndex,D1
    CMP.W   D1,D0
    BCC.W   .return_status

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ADD.L   D1,D1
    LEA     _DISPTEXT_LineLengthTable,A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    TST.W   (A1)
    BEQ.S   .no_prefix_line

    MOVEQ   #0,D2
    MOVE.W  D0,D2
    ASL.L   #2,D2
    LEA     _DISPTEXT_LinePtrTable,A1
    ADDA.L  D2,A1
    ADDA.L  D1,A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    MOVE.L  A1,28(A7)
    MOVEA.L A3,A1
    MOVEA.L 28(A7),A0
    MOVEA.L (A0),A0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  _DISPTEXT_LineWidthPx,D1
    MOVE.L  D1,D2
    SUB.L   D0,D2
    MOVE.L  D2,D6
    BRA.S   .adjust_for_prefix

.no_prefix_line:
    MOVE.L  _DISPTEXT_LineWidthPx,D6

.adjust_for_prefix:
    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCC.S   .maybe_subtract_markers

    SUB.L   _DISPTEXT_ControlMarkerWidthPx,D6

.maybe_subtract_markers:
    MOVEQ   #0,D2
    MOVE.W  D0,D2
    ADD.L   D2,D2
    LEA     _DISPTEXT_LineLengthTable,A0
    ADDA.L  D2,A0
    TST.W   (A0)
    BEQ.S   .try_build_line

    MOVEA.L A3,A1
    LEA     _DISPTEXT_STR_SINGLE_SPACE_PREFIX_1,A0
    MOVEQ   #1,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D5
    CMP.L   D5,D6
    BLE.S   .reset_width_for_next

    SUB.L   D5,D6
    BRA.S   .try_build_line

.reset_width_for_next:
    ADDQ.L  #1,D7
    MOVEQ   #0,D0
    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    ADD.L   D7,D0
    MOVEQ   #0,D1
    MOVE.W  _DISPTEXT_TargetLineIndex,D1
    CMP.L   D1,D0
    BGE.S   .try_build_line

    MOVE.L  _DISPTEXT_LineWidthPx,D6

.try_build_line:
    MOVE.L  A2,D0
    BEQ.S   .return_status

    TST.B   (A2)
    BEQ.S   .return_status

    MOVEQ   #0,D0
    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    ADD.L   D7,D0
    MOVEQ   #0,D1
    MOVE.W  _DISPTEXT_TargetLineIndex,D1
    CMP.L   D1,D0
    BGE.S   .return_status

    MOVE.L  D6,-(A7)
    PEA     -268(A5)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _DISPTEXT_BuildLineWithWidth

    LEA     16(A7),A7
    MOVEA.L D0,A2
    MOVE.L  _DISPTEXT_LineWidthPx,D6
    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCC.S   .after_build_line

    SUB.L   _DISPTEXT_ControlMarkerWidthPx,D6

.after_build_line:
    MOVE.L  A2,D0
    BEQ.S   .try_build_line

    ADDQ.L  #1,D7
    BRA.S   .try_build_line

.return_status:
    MOVE.L  A2,D1
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVEM.L (A7)+,D2/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======