    XDEF    _FLIB2_LoadDigitalNicheDefaults


;------------------------------------------------------------------------------
; FUNC: _FLIB2_LoadDigitalNicheDefaults   (Routine at _FLIB2_LoadDigitalNicheDefaults)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1
; CALLS:
;   _ESQPARS_ReplaceOwnedString
; READS:
;   _FLIB_STR_DIGITAL_NICHE_LISTINGS, _GCOMMAND_DigitalNicheListingsTemplatePtr
; WRITES:
;   _GCOMMAND_DigitalNicheEnabledFlag, _GCOMMAND_NicheTextPen, _GCOMMAND_NicheFramePen, _GCOMMAND_NicheEditorLayoutPen, _GCOMMAND_NicheEditorRowPen, _GCOMMAND_NicheModeCycleCount, _GCOMMAND_NicheForceMode5Flag, _GCOMMAND_NicheWorkflowMode, _GCOMMAND_DigitalNicheListingsTemplatePtr
; DESC:
;   Seeds Digital Niche defaults, then replaces the owned listings-template
;   pointer with the built-in fallback string.
; NOTES:
;   Template ownership always flows through _ESQPARS_ReplaceOwnedString.
;------------------------------------------------------------------------------
_FLIB2_LoadDigitalNicheDefaults:
    MOVE.B  #'N',_GCOMMAND_DigitalNicheEnabledFlag
    MOVEQ   #1,D0
    MOVE.L  D0,_GCOMMAND_NicheTextPen
    MOVEQ   #5,D1
    MOVE.L  D1,_GCOMMAND_NicheFramePen
    MOVE.L  D0,_GCOMMAND_NicheEditorLayoutPen
    MOVE.L  D1,_GCOMMAND_NicheEditorRowPen
    MOVEQ   #0,D0
    MOVE.L  D0,_GCOMMAND_NicheModeCycleCount
    MOVE.L  D0,_GCOMMAND_NicheForceMode5Flag
    MOVE.B  #'B',_GCOMMAND_NicheWorkflowMode
    MOVE.L  _GCOMMAND_DigitalNicheListingsTemplatePtr,-(A7)
    PEA     _FLIB_STR_DIGITAL_NICHE_LISTINGS
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_GCOMMAND_DigitalNicheListingsTemplatePtr
    RTS

;!======