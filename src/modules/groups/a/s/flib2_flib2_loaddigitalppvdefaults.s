    XDEF    _FLIB2_LoadDigitalPpvDefaults


;------------------------------------------------------------------------------
; FUNC: _FLIB2_LoadDigitalPpvDefaults   (Routine at _FLIB2_LoadDigitalPpvDefaults)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1/D2
; CALLS:
;   _ESQPARS_ReplaceOwnedString
; READS:
;   _Global_STR_DIGITAL_PPV_PERIOD, _FLIB_STR_DIGITAL_PPV_LISTINGS, _GCOMMAND_PPVListingsTemplatePtr, _GCOMMAND_PPVPeriodTemplatePtr
; WRITES:
;   _GCOMMAND_DigitalPpvEnabledFlag, _GCOMMAND_PpvModeCycleCount, _GCOMMAND_PpvSelectionWindowMinutes, _GCOMMAND_PpvSelectionToleranceMinutes, _GCOMMAND_PpvMessageTextPen, _GCOMMAND_PpvMessageFramePen, _GCOMMAND_PpvEditorLayoutPen, _GCOMMAND_PpvEditorRowPen, _GCOMMAND_PpvShowtimesLayoutPen, _GCOMMAND_PpvShowtimesInitialLineIndex, _GCOMMAND_PpvShowtimesRowPen, _GCOMMAND_PpvShowtimesWorkflowMode, _GCOMMAND_PpvDetailLayoutFlag, _GCOMMAND_PPVListingsTemplatePtr, _GCOMMAND_PPVPeriodTemplatePtr, _GCOMMAND_PpvShowtimesRowSpan
; DESC:
;   Seeds Digital PPV defaults and refreshes both owned PPV template pointers
;   (listings text and period-format text).
; NOTES:
;   Pointer ownership remains centralized through _ESQPARS_ReplaceOwnedString.
;------------------------------------------------------------------------------
_FLIB2_LoadDigitalPpvDefaults:
    MOVE.L  D2,-(A7)
    MOVE.B  #'N',_GCOMMAND_DigitalPpvEnabledFlag
    CLR.L   _GCOMMAND_PpvModeCycleCount
    MOVEQ   #60,D0
    MOVE.L  D0,_GCOMMAND_PpvSelectionWindowMinutes
    MOVEQ   #30,D0
    MOVE.L  D0,_GCOMMAND_PpvSelectionToleranceMinutes
    MOVEQ   #3,D0
    MOVE.L  D0,_GCOMMAND_PpvMessageTextPen
    MOVEQ   #4,D1
    MOVE.L  D1,_GCOMMAND_PpvMessageFramePen
    MOVEQ   #1,D1
    MOVE.L  D1,_GCOMMAND_PpvEditorLayoutPen
    MOVEQ   #7,D2
    MOVE.L  D2,_GCOMMAND_PpvEditorRowPen
    MOVE.L  D1,_GCOMMAND_PpvShowtimesLayoutPen
    MOVE.L  D0,_GCOMMAND_PpvShowtimesInitialLineIndex
    MOVE.L  D2,_GCOMMAND_PpvShowtimesRowPen
    MOVEQ   #24,D0
    MOVE.L  D0,_GCOMMAND_PpvShowtimesRowSpan
    MOVE.B  #'B',_GCOMMAND_PpvShowtimesWorkflowMode
    MOVE.B  #$59,_GCOMMAND_PpvDetailLayoutFlag
    MOVE.L  _GCOMMAND_PPVListingsTemplatePtr,-(A7)
    PEA     _FLIB_STR_DIGITAL_PPV_LISTINGS
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,_GCOMMAND_PPVListingsTemplatePtr
    MOVE.L  _GCOMMAND_PPVPeriodTemplatePtr,(A7)
    PEA     _Global_STR_DIGITAL_PPV_PERIOD
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    LEA     12(A7),A7
    MOVE.L  D0,_GCOMMAND_PPVPeriodTemplatePtr
    MOVE.L  (A7)+,D2
    RTS

;!======