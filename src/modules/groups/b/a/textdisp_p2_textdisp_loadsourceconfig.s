    XDEF    _TEXTDISP_LoadSourceConfig


;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_LoadSourceConfig   (Load SourceCfg.ini)
; ARGS:
;   none
; RET:
;   none
; CLOBBERS:
;   D0-D7/A0
; CALLS:
;   _PARSEINI_ParseIniBufferAndDispatch
; READS:
;   _Global_STR_DF0_SOURCECFG_INI_2
; WRITES:
;   _TEXTDISP_SourceConfigEntryTable, _TEXTDISP_SourceConfigEntryCount, _TEXTDISP_SourceConfigFlagMask
; DESC:
;   Clears the SourceCfg table and parses df0:SourceCfg.ini.
; NOTES:
;   Table size is 0x12e entries.
;------------------------------------------------------------------------------
_TEXTDISP_LoadSourceConfig:
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7

.clear_table_loop:
    CMPI.L  #$12e,D7
    BGE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SourceConfigEntryTable,A0
    ADDA.L  D0,A0
    CLR.L   (A0)
    ADDQ.L  #1,D7
    BRA.S   .clear_table_loop

.return:
    CLR.L   _TEXTDISP_SourceConfigEntryCount
    CLR.B   _TEXTDISP_SourceConfigFlagMask
    PEA     _Global_STR_DF0_SOURCECFG_INI_2
    JSR     _PARSEINI_ParseIniBufferAndDispatch(PC)

    ADDQ.W  #4,A7
    MOVE.L  (A7)+,D7
    RTS

;!======