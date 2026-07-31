    XDEF    DISPTEXT_ComputeMarkerWidths
    XDEF    _DISPTEXT_LayoutAndAppendToBuffer
    XDEF    DISPTEXT_LayoutSourceToLines

;------------------------------------------------------------------------------
; FUNC: DISPTEXT_ComputeMarkerWidths   (Compute padding widthsuncertain)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A6/A7/D0/D4/D5/D6/D7
; CALLS:
;   _GROUP_AI_JMPTBL_NEWGRID_SetSelectionMarkers, _LVOTextLength
; READS:
;   _DISPTEXT_ControlMarkerWidthPx
; WRITES:
;   _DISPTEXT_ControlMarkerWidthPx
; DESC:
;   Computes combined text lengths for two optional markers and stores in _DISPTEXT_ControlMarkerWidthPx.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
DISPTEXT_ComputeMarkerWidths:
    LINK.W  A5,#-12
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    PEA     -4(A5)
    PEA     -3(A5)
    PEA     -2(A5)
    PEA     -1(A5)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    JSR     _GROUP_AI_JMPTBL_NEWGRID_SetSelectionMarkers(PC)

    LEA     24(A7),A7
    TST.B   -1(A5)
    BEQ.S   .no_prefix1

    MOVEA.L A3,A1
    LEA     -1(A5),A0
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    BRA.S   .check_prefix2

.no_prefix1:
    MOVEQ   #0,D0

.check_prefix2:
    MOVE.L  D0,D5
    TST.B   -3(A5)
    BEQ.S   .no_prefix2

    MOVEA.L A3,A1
    LEA     -3(A5),A0
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    BRA.S   .store_combined

.no_prefix2:
    MOVEQ   #0,D0

.store_combined:
    MOVE.L  D0,D4
    MOVE.L  D5,D0
    ADD.L   D4,D0
    MOVE.L  D0,_DISPTEXT_ControlMarkerWidthPx
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DISPTEXT_LayoutSourceToLines   (Layout source text into lines)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +264: arg_3 (via 268(A5))
; RET:
;   D0: boolean success (0/-1)
; CLOBBERS:
;   A0/A1/A2/A3/A6/A7/D0/D1/D2/D5/D6/D7
; CALLS:
;   DISPTEXT_BuildLineWithWidth, _LVOTextLength
; READS:
;   _DISPTEXT_TextBufferPtr/21D4/21D5/21D6/21D7/21D9/21DA/21DB
; WRITES:
;   _DISPTEXT_CurrentLineIndex
; DESC:
;   Iterates over lines, measuring and formatting text into the line buffer.
; NOTES:
;   Uses line offset tables _DISPTEXT_LinePtrTable/_DISPTEXT_LineLengthTable.
;------------------------------------------------------------------------------
DISPTEXT_LayoutSourceToLines:
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
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
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
    LEA     DISPTEXT_STR_SINGLE_SPACE_PREFIX_1,A0
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
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
    BSR.W   DISPTEXT_BuildLineWithWidth

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
;------------------------------------------------------------------------------
; FUNC: _DISPTEXT_LayoutAndAppendToBuffer   (Layout and append into output buffer)
; ARGS:
;   stack +4: A3 = target RastPort/context pointer
;   stack +8: A2 = source text pointer
;   stack +264: arg_3 ?? (frame-local forwarding)
; RET:
;   D0: boolean success (0/-1)
; CLOBBERS:
;   A0/A1/A2/A3/A6/A7/D0/D1/D2/D5/D6/D7
; CALLS:
;   DISPTEXT_BuildLineWithWidth, _DISPLIB_CommitCurrentLinePenAndAdvance, _GROUP_AI_JMPTBL_STRING_AppendAtNull, _LVOTextLength
; READS:
;   _DISPTEXT_TextBufferPtr/21D4/21D5/21D6/21D7/21D8/21D9/21DA/21DB
; WRITES:
;   _DISPTEXT_CurrentLineIndex, _DISPTEXT_LineLengthTable, _Global_REF_1000_BYTES_ALLOCATED_2
; DESC:
;   Builds line segments into the scratch buffer and appends to global text.
; NOTES:
;   Returns early if source text pointer is NULL or points at an empty string.
;------------------------------------------------------------------------------
_DISPTEXT_LayoutAndAppendToBuffer:
    LINK.W  A5,#-276
    MOVEM.L D2/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
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
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  _DISPTEXT_LineWidthPx,D1
    MOVE.L  D1,D2
    SUB.L   D0,D2
    MOVE.L  D2,D7
    BRA.S   .adjust_for_prefix

.no_prefix_line:
    MOVE.L  _DISPTEXT_LineWidthPx,D7

.adjust_for_prefix:
    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCC.S   .init_scratch

    SUB.L   _DISPTEXT_ControlMarkerWidthPx,D7

.init_scratch:
    MOVEA.L _Global_REF_1000_BYTES_ALLOCATED_2,A0
    CLR.B   (A0)
    MOVEQ   #0,D0
    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    ADD.L   D0,D0
    LEA     _DISPTEXT_LineLengthTable,A1
    ADDA.L  D0,A1
    TST.W   (A1)
    BEQ.S   .line_loop

    MOVEA.L A3,A1
    LEA     DISPTEXT_STR_SINGLE_SPACE_PREFIX_2,A0
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D6
    CMP.L   D6,D7
    BLE.S   .fallback_layout

    LEA     DISPTEXT_STR_SINGLE_SPACE_COPY_PREFIX,A0
    MOVEA.L _Global_REF_1000_BYTES_ALLOCATED_2,A1

.copy_prefix:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_prefix

    SUB.L   D6,D7
    MOVEQ   #0,D0
    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    ADD.L   D0,D0
    LEA     _DISPTEXT_LineLengthTable,A0
    ADDA.L  D0,A0
    ADDQ.W  #1,(A0)
    BRA.S   .line_loop

.fallback_layout:
    MOVEQ   #0,D0
    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    ASL.L   #2,D0
    LEA     _DISPTEXT_LinePenTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    BSR.W   _DISPLIB_CommitCurrentLinePenAndAdvance

    ADDQ.W  #4,A7
    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    MOVE.W  _DISPTEXT_TargetLineIndex,D1
    CMP.W   D1,D0
    BCC.S   .line_loop

    MOVE.L  _DISPTEXT_LineWidthPx,D7

.line_loop:
    ; Guard source pointer before probing bytes.
    MOVE.L  A2,D0
    BEQ.W   .flush_remaining

    ; Empty string also exits through flush path.
    TST.B   (A2)
    BEQ.W   .flush_remaining

    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    MOVE.W  _DISPTEXT_TargetLineIndex,D1
    CMP.W   D1,D0
    BCC.W   .flush_remaining

    MOVE.L  D7,-(A7)
    PEA     -268(A5)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   DISPTEXT_BuildLineWithWidth

    MOVEA.L D0,A2
    LEA     -268(A5),A0
    MOVEA.L A0,A1

.append_scratch:
    TST.B   (A1)+
    BNE.S   .append_scratch

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D5
    MOVE.L  A0,(A7)
    MOVE.L  _Global_REF_1000_BYTES_ALLOCATED_2,-(A7)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D0
    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    ADD.L   D0,D0
    LEA     _DISPTEXT_LineLengthTable,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.W  (A0),D0
    MOVE.L  D0,D1
    ADD.L   D5,D1
    MOVE.W  D1,(A0)
    MOVE.L  _DISPTEXT_LineWidthPx,D7
    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCC.S   .after_append

    SUB.L   _DISPTEXT_ControlMarkerWidthPx,D7

.after_append:
    MOVE.L  A2,D1
    BEQ.W   .line_loop

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ASL.L   #2,D1
    LEA     _DISPTEXT_LinePenTable,A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-(A7)
    BSR.W   _DISPLIB_CommitCurrentLinePenAndAdvance

    ADDQ.W  #4,A7
    BRA.W   .line_loop

.flush_remaining:
    MOVEA.L _Global_REF_1000_BYTES_ALLOCATED_2,A0
    TST.B   (A0)
    BEQ.S   .return_status

    MOVE.L  A0,-(A7)
    BSR.W   _DISPTEXT_AppendToBuffer

    CLR.L   (A7)
    BSR.W   _DISPTEXT_BuildLinePointerTable

    ADDQ.W  #4,A7

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