    XDEF    _DISPTEXT_FinalizeLineTable

;------------------------------------------------------------------------------
; FUNC: _DISPTEXT_FinalizeLineTable   (Finalize pending line tableuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0/D1
; CALLS:
;   _DISPTEXT_BuildLinePointerTable
; READS:
;   _DISPTEXT_LineTableLockFlag, _DISPTEXT_CurrentLineIndex, _DISPTEXT_LineLengthTable
; WRITES:
;   _DISPTEXT_TargetLineIndex, _DISPTEXT_CurrentLineIndex
; DESC:
;   Ensures line table state is current and clears _DISPTEXT_CurrentLineIndex when needed.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DISPTEXT_FinalizeLineTable:
    TST.L   _DISPTEXT_LineTableLockFlag
    BNE.S   .return

    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    MOVE.W  D0,_DISPTEXT_TargetLineIndex
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ADD.L   D1,D1
    LEA     _DISPTEXT_LineLengthTable,A0
    ADDA.L  D1,A0
    TST.W   (A0)
    BEQ.S   .check_extra_line

    ADDQ.W  #1,D0
    MOVE.W  D0,_DISPTEXT_TargetLineIndex

.check_extra_line:
    PEA     1.W
    BSR.W   _DISPTEXT_BuildLinePointerTable

    ADDQ.W  #4,A7
    CLR.W   _DISPTEXT_CurrentLineIndex

.return:
    RTS

;!======