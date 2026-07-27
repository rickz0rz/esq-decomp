    XDEF    _ED1_UpdateEscMenuSelection


;------------------------------------------------------------------------------
; FUNC: _ED1_UpdateEscMenuSelection   (Update ESC menu selection stateuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/D0/D1
; CALLS:
;   _ED_DrawESCMenuBottomHelp
; READS:
;   _ED_StateRingIndex, _ED_StateRingTable
; WRITES:
;   _ED_LastKeyCode, _ED_DiagnosticsScreenActive
; DESC:
;   Loads a menu selection value from table and refreshes bottom help.
; NOTES:
;   Clears _ED_DiagnosticsScreenActive when selection is not the first entry.
;------------------------------------------------------------------------------
_ED1_UpdateEscMenuSelection:
    MOVE.L  _ED_StateRingIndex,D0
    LSL.L   #2,D0
    ADD.L   _ED_StateRingIndex,D0
    LEA     _ED_StateRingTable,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),D0
    MOVE.B  D0,_ED_LastKeyCode
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    SUBI.W  #$31,D1
    BEQ.S   .return

    JSR     _ED_DrawESCMenuBottomHelp(PC)

    CLR.W   _ED_DiagnosticsScreenActive

.return:
    RTS

;!======