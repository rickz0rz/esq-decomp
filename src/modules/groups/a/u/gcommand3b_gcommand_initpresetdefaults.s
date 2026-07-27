    XDEF    _GCOMMAND_InitPresetDefaults

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_InitPresetDefaults   (Initialize default preset table from palette constants)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0-A3
; CALLS:
;   _GCOMMAND_InitPresetTableFromPalette
; READS:
;   _GCOMMAND_DefaultPresetTable
; WRITES:
;   _GCOMMAND_DefaultPresetTable
; DESC:
;   Initializes the default preset table at _GCOMMAND_DefaultPresetTable.
; NOTES:
;   Wrapper around _GCOMMAND_InitPresetTableFromPalette.
;------------------------------------------------------------------------------
_GCOMMAND_InitPresetDefaults:
    PEA     _GCOMMAND_DefaultPresetTable
    BSR.S   _GCOMMAND_InitPresetTableFromPalette

    ADDQ.W  #4,A7
    RTS

;!======