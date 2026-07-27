    XDEF    _FLIB2_LoadDigitalMplexDefaults


;------------------------------------------------------------------------------
; FUNC: _FLIB2_LoadDigitalMplexDefaults   (Routine at _FLIB2_LoadDigitalMplexDefaults)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1/D2/D3
; CALLS:
;   _ESQPARS_ReplaceOwnedString
; READS:
;   _FLIB_STR_DIGITAL_MULTIPLEX_LISTINGS, _FLIB_FMT_DIGITAL_MULTIPLEX_AT_PCT_S, _GCOMMAND_MplexListingsTemplatePtr, _GCOMMAND_MplexAtTemplatePtr
; WRITES:
;   _GCOMMAND_DigitalMplexEnabledFlag, _GCOMMAND_MplexModeCycleCount, _GCOMMAND_MplexSearchRowLimit, _GCOMMAND_MplexClockOffsetMinutes, _GCOMMAND_MplexMessageTextPen, _GCOMMAND_MplexMessageFramePen, _GCOMMAND_MplexEditorLayoutPen, _GCOMMAND_MplexEditorRowPen, _GCOMMAND_MplexDetailLayoutPen, _GCOMMAND_MplexDetailInitialLineIndex, _GCOMMAND_MplexDetailRowPen, _GCOMMAND_MplexWorkflowMode, _GCOMMAND_MplexDetailLayoutFlag, _GCOMMAND_MplexListingsTemplatePtr, _GCOMMAND_MplexAtTemplatePtr
; DESC:
;   Seeds Digital Mplex defaults and refreshes both owned template pointers
;   (listings text and "at %s" format).
; NOTES:
;   Both template pointers are independently replaced via _ESQPARS_ReplaceOwnedString.
;------------------------------------------------------------------------------
_FLIB2_LoadDigitalMplexDefaults:
    MOVEM.L D2-D3,-(A7)
    MOVEQ   #78,D0
    MOVE.B  D0,_GCOMMAND_DigitalMplexEnabledFlag
    MOVEQ   #0,D1
    MOVE.L  D1,_GCOMMAND_MplexModeCycleCount
    MOVE.L  D1,_GCOMMAND_MplexSearchRowLimit
    MOVEQ   #10,D1
    MOVE.L  D1,_GCOMMAND_MplexClockOffsetMinutes
    MOVEQ   #3,D1
    MOVE.L  D1,_GCOMMAND_MplexMessageTextPen
    MOVEQ   #6,D2
    MOVE.L  D2,_GCOMMAND_MplexMessageFramePen
    MOVEQ   #1,D2
    MOVE.L  D2,_GCOMMAND_MplexEditorLayoutPen
    MOVEQ   #4,D3
    MOVE.L  D3,_GCOMMAND_MplexEditorRowPen
    MOVE.L  D2,_GCOMMAND_MplexDetailLayoutPen
    MOVE.L  D1,_GCOMMAND_MplexDetailInitialLineIndex
    MOVE.L  D3,_GCOMMAND_MplexDetailRowPen
    MOVE.B  #'B',_GCOMMAND_MplexWorkflowMode
    MOVE.B  D0,_GCOMMAND_MplexDetailLayoutFlag
    MOVE.L  _GCOMMAND_MplexListingsTemplatePtr,-(A7)
    PEA     _FLIB_STR_DIGITAL_MULTIPLEX_LISTINGS
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,_GCOMMAND_MplexListingsTemplatePtr
    MOVE.L  _GCOMMAND_MplexAtTemplatePtr,(A7)
    PEA     _FLIB_FMT_DIGITAL_MULTIPLEX_AT_PCT_S
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    LEA     12(A7),A7
    MOVE.L  D0,_GCOMMAND_MplexAtTemplatePtr
    MOVEM.L (A7)+,D2-D3
    RTS

;!======