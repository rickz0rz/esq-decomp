    XDEF    _DISPLIB_ResetLineTables

;------------------------------------------------------------------------------
; FUNC: _DISPLIB_ResetLineTables   (Routine at _DISPLIB_ResetLineTables)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0/D1/D7
; CALLS:
;   (none)
; READS:
;   _DISPTEXT_LinePtrTable, _DISPTEXT_LineLengthTable, _DISPTEXT_LinePenTable
; WRITES:
;   _DISPTEXT_TargetLineIndex, _DISPTEXT_CurrentLineIndex, _DISPTEXT_LineWidthPx, _DISPTEXT_ControlMarkerWidthPx, _DISPTEXT_LineTableLockFlag, _DISPTEXT_ControlMarkersEnabledFlag
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_DISPLIB_ResetLineTables:
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D0
    MOVE.W  D0,_DISPTEXT_TargetLineIndex
    MOVE.W  D0,_DISPTEXT_CurrentLineIndex
    MOVEQ   #0,D1
    MOVE.L  D1,_DISPTEXT_LineWidthPx
    MOVE.L  D1,_DISPTEXT_ControlMarkerWidthPx
    MOVE.L  D1,_DISPTEXT_LineTableLockFlag
    MOVE.W  D0,_DISPTEXT_ControlMarkersEnabledFlag
    MOVE.L  D1,D7

.lab_0564:
    MOVEQ   #20,D0
    CMP.L   D0,D7
    BGE.S   .lab_0565

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _DISPTEXT_LinePtrTable,A0
    ADDA.L  D0,A0
    CLR.L   (A0)
    MOVE.L  D7,D1
    ADD.L   D1,D1
    LEA     _DISPTEXT_LineLengthTable,A0
    ADDA.L  D1,A0
    CLR.W   (A0)
    LEA     _DISPTEXT_LinePenTable,A0
    ADDA.L  D0,A0
    MOVEQ   #1,D0
    MOVE.L  D0,(A0)
    ADDQ.L  #1,D7
    BRA.S   .lab_0564

.lab_0565:
    MOVE.L  (A7)+,D7
    RTS

;!======
