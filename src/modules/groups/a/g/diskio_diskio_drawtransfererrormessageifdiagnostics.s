    XDEF    _DISKIO_DrawTransferErrorMessageIfDiagnostics


;------------------------------------------------------------------------------
; FUNC: _DISKIO_DrawTransferErrorMessageIfDiagnostics   (Routine at _DISKIO_DrawTransferErrorMessageIfDiagnostics)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/A7/D0/D7
; CALLS:
;   _DISPLIB_DisplayTextAtPosition, _LVOSetAPen
; READS:
;   _Global_REF_GRAPHICS_LIBRARY, _Global_REF_RASTPORT_1, _CTASKS_TerminationReasonPtrTable, _ED_DiagnosticsScreenActive
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_DISKIO_DrawTransferErrorMessageIfDiagnostics:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    TST.W   _ED_DiagnosticsScreenActive
    BEQ.S   .return

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #4,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.L  D7,D0
    ASL.L   #2,D0
    ; Layout-coupled table anchor: _CTASKS_TerminationReasonPtrTable is
    ; followed by a termination-reason pointer table.
    LEA     (_CTASKS_TerminationReasonPtrTable-4),A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    PEA     240.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======