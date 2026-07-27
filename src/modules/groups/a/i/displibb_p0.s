    XDEF    _DISPLIB_CommitCurrentLinePenAndAdvance


;------------------------------------------------------------------------------
; FUNC: _DISPLIB_CommitCurrentLinePenAndAdvance   (Routine at _DISPLIB_CommitCurrentLinePenAndAdvance)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0/D1/D7
; CALLS:
;   (none)
; READS:
;   _DISPTEXT_TargetLineIndex, _DISPTEXT_CurrentLineIndex, _DISPTEXT_LineLengthTable, _DISPTEXT_LinePenTable
; WRITES:
;   _DISPTEXT_CurrentLineIndex
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_DISPLIB_CommitCurrentLinePenAndAdvance:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    MOVEQ   #0,D0
    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    ADD.L   D0,D0
    LEA     _DISPTEXT_LineLengthTable,A0
    ADDA.L  D0,A0
    TST.W   (A0)
    BEQ.S   .lab_0568

    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    MOVE.L  D0,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,_DISPTEXT_CurrentLineIndex

.lab_0568:
    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    MOVE.W  _DISPTEXT_TargetLineIndex,D1
    CMP.W   D1,D0
    BCC.S   .lab_0569

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ASL.L   #2,D1
    LEA     _DISPTEXT_LinePenTable,A0
    ADDA.L  D1,A0
    MOVE.L  D7,(A0)

.lab_0569:
    MOVE.L  (A7)+,D7
    RTS
