    XDEF    FLIB2_LoadDigitalMplexDefaults
    XDEF    FLIB2_LoadDigitalNicheDefaults
    XDEF    FLIB2_LoadDigitalPpvDefaults
    XDEF    FLIB2_ResetAndLoadListingTemplates

;------------------------------------------------------------------------------
; FUNC: FLIB2_LoadDigitalNicheDefaults   (Routine at FLIB2_LoadDigitalNicheDefaults)
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
FLIB2_LoadDigitalNicheDefaults:
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

;------------------------------------------------------------------------------
; FUNC: FLIB2_LoadDigitalMplexDefaults   (Routine at FLIB2_LoadDigitalMplexDefaults)
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
FLIB2_LoadDigitalMplexDefaults:
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

;------------------------------------------------------------------------------
; FUNC: FLIB2_LoadDigitalPpvDefaults   (Routine at FLIB2_LoadDigitalPpvDefaults)
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
FLIB2_LoadDigitalPpvDefaults:
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

;------------------------------------------------------------------------------
; FUNC: FLIB2_ResetAndLoadListingTemplates   (Routine at FLIB2_ResetAndLoadListingTemplates)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0
; CALLS:
;   GCOMMAND_LoadDefaultTable, GCOMMAND_LoadMplexTemplate, GCOMMAND_LoadPPV3Template, FLIB2_LoadDigitalNicheDefaults, FLIB2_LoadDigitalMplexDefaults, FLIB2_LoadDigitalPpvDefaults
; READS:
;   (none observed)
; WRITES:
;   _GCOMMAND_DigitalNicheListingsTemplatePtr, _GCOMMAND_MplexListingsTemplatePtr, _GCOMMAND_MplexAtTemplatePtr, _GCOMMAND_PPVListingsTemplatePtr, _GCOMMAND_PPVPeriodTemplatePtr
; DESC:
;   Clears template pointers, loads fallback defaults, then loads disk-backed
;   templates for Niche/Mplex/PPV.
; NOTES:
;   This is the top-level population entry point for listing-template globals.
;------------------------------------------------------------------------------
FLIB2_ResetAndLoadListingTemplates:
    SUBA.L  A0,A0
    MOVE.L  A0,_GCOMMAND_DigitalNicheListingsTemplatePtr
    MOVE.L  A0,_GCOMMAND_MplexListingsTemplatePtr
    MOVE.L  A0,_GCOMMAND_MplexAtTemplatePtr
    MOVE.L  A0,_GCOMMAND_PPVListingsTemplatePtr
    MOVE.L  A0,_GCOMMAND_PPVPeriodTemplatePtr
    BSR.W   FLIB2_LoadDigitalNicheDefaults

    BSR.W   FLIB2_LoadDigitalMplexDefaults

    BSR.W   FLIB2_LoadDigitalPpvDefaults

    BSR.W   GCOMMAND_LoadDefaultTable

    BSR.W   GCOMMAND_LoadMplexTemplate

    BSR.W   GCOMMAND_LoadPPV3Template

    RTS
