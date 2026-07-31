    XDEF    _GCOMMAND_SetPresetEntry
    XDEF    GCOMMAND_SetPresetEntry_Return

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_SetPresetEntry   (Update the preset table entry for row D7 with the supplied value D6.)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0/D6/D7
; CALLS:
;   (none)
; READS:
;   _GCOMMAND_PresetValueTable
; WRITES:
;   (none observed)
; DESC:
;   Update the preset table entry for row D7 with the supplied value D6.
; NOTES:
;   Guarded to rows `1..15` and values `0..$0FFF`.
;------------------------------------------------------------------------------

; Update the preset table entry for row D7 with the supplied value D6.
_GCOMMAND_SetPresetEntry:
    MOVEM.L D6-D7,-(A7)
    MOVE.L  12(A7),D7
    MOVE.L  16(A7),D6
    TST.L   D7
    BLE.S   GCOMMAND_SetPresetEntry_Return

    MOVEQ   #16,D0
    CMP.L   D0,D7
    BGE.S   GCOMMAND_SetPresetEntry_Return

    TST.L   D6
    BMI.S   GCOMMAND_SetPresetEntry_Return

    CMPI.L  #$1000,D6
    BGE.S   GCOMMAND_SetPresetEntry_Return

    MOVE.L  D7,D0
    ASL.L   #7,D0
    LEA     _GCOMMAND_PresetValueTable,A0
    ADDA.L  D0,A0
    MOVE.L  D6,D0
    MOVE.W  D0,(A0)

;------------------------------------------------------------------------------
; FUNC: GCOMMAND_SetPresetEntry_Return   (Routine at GCOMMAND_SetPresetEntry_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D6
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
GCOMMAND_SetPresetEntry_Return:
    MOVEM.L (A7)+,D6-D7
    RTS

;!======