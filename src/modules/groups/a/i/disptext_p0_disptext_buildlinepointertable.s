    XDEF    _DISPTEXT_BuildLinePointerTable

;------------------------------------------------------------------------------
; FUNC: _DISPTEXT_BuildLinePointerTable   (Build display line pointer tableuncertain)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A7/D0/D1/D5/D6/D7
; CALLS:
;   none
; READS:
;   _DISPTEXT_TextBufferPtr/21D4/21D6/21D7/21DB
; WRITES:
;   _DISPTEXT_LinePtrTable, _DISPTEXT_LineTableLockFlag
; DESC:
;   Builds per-line pointer table based on offsets when not locked.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DISPTEXT_BuildLinePointerTable:
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVE.L  24(A7),D7
    TST.L   _DISPTEXT_LineTableLockFlag
    BNE.S   .return

    MOVE.L  _DISPTEXT_TextBufferPtr,_DISPTEXT_LinePtrTable
    MOVEQ   #0,D0
    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    ADD.L   D0,D0
    LEA     _DISPTEXT_LineLengthTable,A0
    ADDA.L  D0,A0
    TST.W   (A0)
    BEQ.S   .has_header_line

    MOVEQ   #1,D0
    BRA.S   .init_line_count

.has_header_line:
    MOVEQ   #0,D0

.init_line_count:
    MOVEQ   #0,D1
    MOVE.W  _DISPTEXT_CurrentLineIndex,D1
    ADD.L   D0,D1
    MOVE.L  D1,D5
    MOVEQ   #1,D6

.build_ptrs_loop:
    CMP.L   D5,D6
    BGE.S   .set_locked

    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     _DISPTEXT_LinePtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     _DISPTEXT_TextBufferPtr,A1
    ADDA.L  D0,A1
    MOVE.L  D6,D0
    ADD.L   D0,D0
    LEA     _DISPTEXT_CurrentLineIndex,A2
    ADDA.L  D0,A2
    MOVEA.L (A1),A3
    MOVEQ   #0,D0
    MOVE.W  (A2),D0
    ADDA.L  D0,A3
    MOVE.L  A3,(A0)
    ADDQ.L  #1,D6
    BRA.S   .build_ptrs_loop

.set_locked:
    MOVE.L  D7,_DISPTEXT_LineTableLockFlag

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3
    RTS

;!======