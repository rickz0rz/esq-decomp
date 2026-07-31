    XDEF    _DISPTEXT_MeasureCurrentLineLength


;------------------------------------------------------------------------------
; FUNC: _DISPTEXT_MeasureCurrentLineLength   (Measure current line text length)
; ARGS:
;   (none observed)
; RET:
;   D0: text length
; CLOBBERS:
;   A0/A1/A3/A6/A7/D0
; CALLS:
;   _DISPTEXT_FinalizeLineTable, _LVOTextLength
; READS:
;   _DISPTEXT_LinePtrTable/21D6/21D7
; WRITES:
;   (none observed)
; DESC:
;   Measures text length for the current line.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DISPTEXT_MeasureCurrentLineLength:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    BSR.W   _DISPTEXT_FinalizeLineTable

    MOVEQ   #0,D0
    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    ASL.L   #2,D0
    LEA     _DISPTEXT_LinePtrTable,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    ADD.L   D0,D0
    LEA     _DISPTEXT_LineLengthTable,A1
    ADDA.L  D0,A1
    MOVEQ   #0,D0
    MOVE.W  (A1),D0
    MOVEA.L A3,A1
    MOVEA.L (A0),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVEA.L (A7)+,A3
    RTS

;!======