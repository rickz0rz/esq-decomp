    XDEF    _LADFUNC_BuildHighlightLinesFromText


;------------------------------------------------------------------------------
; FUNC: _LADFUNC_BuildHighlightLinesFromText   (Build highlight lines from textuncertain)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +85: arg_2 (via 89(A5))
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D2/D3/D5/D6/D7
; CALLS:
;   _GROUP_AW_JMPTBL_DISPLIB_ApplyInlineAlignmentPadding, _LVOTextLength
; READS:
;   _LADFUNC_LineSlotWriteIndex, _LADFUNC_LineTextBufferPtrs, _LADFUNC_LineControlCodeTable, _Global_REF_RASTPORT_1
; WRITES:
;   _LADFUNC_LineSlotWriteIndex, _LADFUNC_LineTextBufferPtrs, _LADFUNC_LineControlCodeTable, stack buffer (-89)
; DESC:
;   Splits a text string into displayable segments and populates line buffers.
; NOTES:
;   Treats bytes 24/25/26 as control codes and hard line breaks.
;------------------------------------------------------------------------------
_LADFUNC_BuildHighlightLinesFromText:
    LINK.W  A5,#-92
    MOVEM.L D2-D3/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D0
    MOVE.W  _LADFUNC_LineSlotWriteIndex,D0
    ADD.L   D0,D0
    LEA     _LADFUNC_LineControlCodeTable,A0
    ADDA.L  D0,A0
    MOVE.W  #4,(A0)
    MOVE.W  _LADFUNC_LineSlotWriteIndex,D0
    MOVE.L  D0,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,_LADFUNC_LineSlotWriteIndex
    MOVEQ   #20,D0
    CMP.W   D0,D1
    BCS.S   .init_parse

    MOVEQ   #0,D0
    MOVE.W  D0,_LADFUNC_LineSlotWriteIndex

.init_parse:
    MOVEQ   #0,D6
    MOVE.L  #624,D7
    MOVE.B  (A3),D5
    MOVEQ   #24,D0
    CMP.B   D0,D5
    BEQ.S   .skip_control_prefix

    MOVEQ   #25,D0
    CMP.B   D0,D5
    BEQ.S   .skip_control_prefix

    MOVEQ   #26,D0
    CMP.B   D0,D5
    BNE.S   .next_char

.skip_control_prefix:
    ADDQ.L  #1,A3

.next_char:
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-7(A5)
    TST.B   D0
    BEQ.W   .flush_final

    MOVEQ   #13,D1
    CMP.B   D1,D0
    BEQ.S   .next_char

    MOVEQ   #10,D1
    CMP.B   D1,D0
    BNE.S   .check_flush_or_control

    BRA.S   .next_char

.check_flush_or_control:
    TST.L   D7
    BLE.S   .flush_segment

    MOVEQ   #24,D1
    CMP.B   D1,D0
    BEQ.S   .flush_segment

    MOVEQ   #25,D1
    CMP.B   D1,D0
    BEQ.S   .flush_segment

    MOVEQ   #26,D1
    CMP.B   D1,D0
    BNE.S   .append_char

.flush_segment:
    MOVEQ   #0,D0
    MOVE.W  D6,D0
    CLR.B   -89(A5,D0.L)
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVE.L  D0,-(A7)
    PEA     -89(A5)
    JSR     _GROUP_AW_JMPTBL_DISPLIB_ApplyInlineAlignmentPadding(PC)

    ADDQ.W  #8,A7
    MOVEQ   #0,D0
    MOVE.W  _LADFUNC_LineSlotWriteIndex,D0
    ASL.L   #2,D0
    LEA     _LADFUNC_LineTextBufferPtrs,A0
    ADDA.L  D0,A0
    LEA     -89(A5),A1
    MOVEA.L (A0),A2

.copy_segment:
    MOVE.B  (A1)+,(A2)+
    BNE.S   .copy_segment

    MOVEQ   #0,D0
    MOVE.W  _LADFUNC_LineSlotWriteIndex,D0
    ADD.L   D0,D0
    LEA     _LADFUNC_LineControlCodeTable,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.W  D0,(A0)
    MOVE.W  _LADFUNC_LineSlotWriteIndex,D1
    MOVE.L  D1,D2
    ADDQ.W  #1,D2
    MOVE.W  D2,_LADFUNC_LineSlotWriteIndex
    MOVEQ   #20,D1
    CMP.W   D1,D2
    BCS.S   .segment_done

    MOVE.W  D0,_LADFUNC_LineSlotWriteIndex

.segment_done:
    MOVE.L  D0,D6
    MOVE.L  #624,D7
    MOVE.B  -7(A5),D5
    BRA.W   .next_char

.append_char:
    MOVE.L  D6,D1
    ADDQ.W  #1,D6
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.B  D0,-89(A5,D2.L)
    MOVEA.L _Global_REF_RASTPORT_1,A1
    LEA     -7(A5),A0
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    SUB.L   D0,D7
    BRA.W   .next_char

.flush_final:
    MOVEQ   #0,D0
    MOVE.W  D6,D0
    CLR.B   -89(A5,D0.L)
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVE.L  D0,-(A7)
    PEA     -89(A5)
    JSR     _GROUP_AW_JMPTBL_DISPLIB_ApplyInlineAlignmentPadding(PC)

    ADDQ.W  #8,A7
    MOVEQ   #0,D0
    MOVE.W  _LADFUNC_LineSlotWriteIndex,D0
    ASL.L   #2,D0
    LEA     _LADFUNC_LineTextBufferPtrs,A0
    ADDA.L  D0,A0
    LEA     -89(A5),A1
    MOVEA.L (A0),A2

.copy_final:
    MOVE.B  (A1)+,(A2)+
    BNE.S   .copy_final

    MOVEQ   #0,D0
    MOVE.W  _LADFUNC_LineSlotWriteIndex,D0
    ADD.L   D0,D0
    LEA     _LADFUNC_LineControlCodeTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #0,D0
    MOVE.W  D0,(A1)
    MOVE.W  _LADFUNC_LineSlotWriteIndex,D1
    MOVE.L  D1,D2
    ADDQ.W  #1,D2
    MOVE.W  D2,_LADFUNC_LineSlotWriteIndex
    MOVEQ   #20,D1
    CMP.W   D1,D2
    BCS.S   .advance_slot

    MOVE.W  D0,_LADFUNC_LineSlotWriteIndex

.advance_slot:
    MOVEQ   #0,D2
    MOVE.W  _LADFUNC_LineSlotWriteIndex,D2
    ADD.L   D2,D2
    ADDA.L  D2,A0
    MOVE.W  #4,(A0)
    MOVE.W  _LADFUNC_LineSlotWriteIndex,D2
    MOVE.L  D2,D3
    ADDQ.W  #1,D3
    MOVE.W  D3,_LADFUNC_LineSlotWriteIndex
    CMP.W   D1,D3
    BCS.S   .return

    MOVE.W  D0,_LADFUNC_LineSlotWriteIndex

.return:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======