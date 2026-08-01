    XDEF    _DISPTEXT_LayoutAndAppendToBuffer

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
;   _DISPTEXT_BuildLineWithWidth, _DISPLIB_CommitCurrentLinePenAndAdvance, _GROUP_AI_JMPTBL_STRING_AppendAtNull, _LVOTextLength
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
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
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
    LEA     _DISPTEXT_STR_SINGLE_SPACE_PREFIX_2,A0
    MOVEQ   #1,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D6
    CMP.L   D6,D7
    BLE.S   .fallback_layout

    LEA     _DISPTEXT_STR_SINGLE_SPACE_COPY_PREFIX,A0
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
    BSR.W   _DISPTEXT_BuildLineWithWidth

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