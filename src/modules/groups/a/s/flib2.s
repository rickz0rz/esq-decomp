;------------------------------------------------------------------------------
; FUNC: FLIB2_LoadDigitalNicheDefaults   (Routine at FLIB2_LoadDigitalNicheDefaults)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1
; CALLS:
;   ESQPARS_ReplaceOwnedString
; READS:
;   DATA_FLIB_STR_DIGITAL_NICHE_LISTINGS_1F61, GCOMMAND_DigitalNicheListingsTemplatePtr
; WRITES:
;   GCOMMAND_DigitalNicheEnabledFlag, GCOMMAND_NicheTextPen, GCOMMAND_NicheFramePen, GCOMMAND_NicheEditorLayoutPen, GCOMMAND_NicheEditorRowPen, GCOMMAND_NicheModeCycleCount, GCOMMAND_NicheForceMode5Flag, GCOMMAND_NicheWorkflowMode, GCOMMAND_DigitalNicheListingsTemplatePtr
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
FLIB2_LoadDigitalNicheDefaults:
    MOVE.B  #$4e,GCOMMAND_DigitalNicheEnabledFlag
    MOVEQ   #1,D0
    MOVE.L  D0,GCOMMAND_NicheTextPen
    MOVEQ   #5,D1
    MOVE.L  D1,GCOMMAND_NicheFramePen
    MOVE.L  D0,GCOMMAND_NicheEditorLayoutPen
    MOVE.L  D1,GCOMMAND_NicheEditorRowPen
    MOVEQ   #0,D0
    MOVE.L  D0,GCOMMAND_NicheModeCycleCount
    MOVE.L  D0,GCOMMAND_NicheForceMode5Flag
    MOVE.B  #$42,GCOMMAND_NicheWorkflowMode
    MOVE.L  GCOMMAND_DigitalNicheListingsTemplatePtr,-(A7)
    PEA     DATA_FLIB_STR_DIGITAL_NICHE_LISTINGS_1F61
    JSR     ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,GCOMMAND_DigitalNicheListingsTemplatePtr
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
;   ESQPARS_ReplaceOwnedString
; READS:
;   DATA_FLIB_STR_DIGITAL_MULTIPLEX_LISTINGS_1F62, DATA_FLIB_FMT_DIGITAL_MULTIPLEX_AT_PCT_S_1F63, GCOMMAND_MplexListingsTemplatePtr, GCOMMAND_MplexAtTemplatePtr
; WRITES:
;   GCOMMAND_DigitalMplexEnabledFlag, GCOMMAND_MplexModeCycleCount, GCOMMAND_MplexSearchRowLimit, GCOMMAND_MplexClockOffsetMinutes, GCOMMAND_MplexMessageTextPen, GCOMMAND_MplexMessageFramePen, GCOMMAND_MplexEditorLayoutPen, GCOMMAND_MplexEditorRowPen, GCOMMAND_MplexDetailLayoutPen, GCOMMAND_MplexDetailInitialLineIndex, GCOMMAND_MplexDetailRowPen, GCOMMAND_MplexWorkflowMode, GCOMMAND_MplexDetailLayoutFlag, GCOMMAND_MplexListingsTemplatePtr, GCOMMAND_MplexAtTemplatePtr
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
FLIB2_LoadDigitalMplexDefaults:
    MOVEM.L D2-D3,-(A7)
    MOVEQ   #78,D0
    MOVE.B  D0,GCOMMAND_DigitalMplexEnabledFlag
    MOVEQ   #0,D1
    MOVE.L  D1,GCOMMAND_MplexModeCycleCount
    MOVE.L  D1,GCOMMAND_MplexSearchRowLimit
    MOVEQ   #10,D1
    MOVE.L  D1,GCOMMAND_MplexClockOffsetMinutes
    MOVEQ   #3,D1
    MOVE.L  D1,GCOMMAND_MplexMessageTextPen
    MOVEQ   #6,D2
    MOVE.L  D2,GCOMMAND_MplexMessageFramePen
    MOVEQ   #1,D2
    MOVE.L  D2,GCOMMAND_MplexEditorLayoutPen
    MOVEQ   #4,D3
    MOVE.L  D3,GCOMMAND_MplexEditorRowPen
    MOVE.L  D2,GCOMMAND_MplexDetailLayoutPen
    MOVE.L  D1,GCOMMAND_MplexDetailInitialLineIndex
    MOVE.L  D3,GCOMMAND_MplexDetailRowPen
    MOVE.B  #$42,GCOMMAND_MplexWorkflowMode
    MOVE.B  D0,GCOMMAND_MplexDetailLayoutFlag
    MOVE.L  GCOMMAND_MplexListingsTemplatePtr,-(A7)
    PEA     DATA_FLIB_STR_DIGITAL_MULTIPLEX_LISTINGS_1F62
    JSR     ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,GCOMMAND_MplexListingsTemplatePtr
    MOVE.L  GCOMMAND_MplexAtTemplatePtr,(A7)
    PEA     DATA_FLIB_FMT_DIGITAL_MULTIPLEX_AT_PCT_S_1F63
    JSR     ESQPARS_ReplaceOwnedString(PC)

    LEA     12(A7),A7
    MOVE.L  D0,GCOMMAND_MplexAtTemplatePtr
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
;   ESQPARS_ReplaceOwnedString
; READS:
;   GLOB_STR_DIGITAL_PPV_PERIOD, DATA_FLIB_STR_DIGITAL_PPV_LISTINGS_1F64, GCOMMAND_PPVListingsTemplatePtr, GCOMMAND_PPVPeriodTemplatePtr
; WRITES:
;   GCOMMAND_DigitalPpvEnabledFlag, GCOMMAND_PpvModeCycleCount, GCOMMAND_PpvSelectionWindowMinutes, GCOMMAND_PpvSelectionToleranceMinutes, GCOMMAND_PpvMessageTextPen, GCOMMAND_PpvMessageFramePen, GCOMMAND_PpvEditorLayoutPen, GCOMMAND_PpvEditorRowPen, GCOMMAND_PpvShowtimesLayoutPen, GCOMMAND_PpvShowtimesInitialLineIndex, GCOMMAND_PpvShowtimesRowPen, GCOMMAND_PpvShowtimesWorkflowMode, GCOMMAND_PpvDetailLayoutFlag, GCOMMAND_PPVListingsTemplatePtr, GCOMMAND_PPVPeriodTemplatePtr, GCOMMAND_PpvShowtimesRowSpan
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
FLIB2_LoadDigitalPpvDefaults:
    MOVE.L  D2,-(A7)
    MOVE.B  #$4e,GCOMMAND_DigitalPpvEnabledFlag
    CLR.L   GCOMMAND_PpvModeCycleCount
    MOVEQ   #60,D0
    MOVE.L  D0,GCOMMAND_PpvSelectionWindowMinutes
    MOVEQ   #30,D0
    MOVE.L  D0,GCOMMAND_PpvSelectionToleranceMinutes
    MOVEQ   #3,D0
    MOVE.L  D0,GCOMMAND_PpvMessageTextPen
    MOVEQ   #4,D1
    MOVE.L  D1,GCOMMAND_PpvMessageFramePen
    MOVEQ   #1,D1
    MOVE.L  D1,GCOMMAND_PpvEditorLayoutPen
    MOVEQ   #7,D2
    MOVE.L  D2,GCOMMAND_PpvEditorRowPen
    MOVE.L  D1,GCOMMAND_PpvShowtimesLayoutPen
    MOVE.L  D0,GCOMMAND_PpvShowtimesInitialLineIndex
    MOVE.L  D2,GCOMMAND_PpvShowtimesRowPen
    MOVEQ   #24,D0
    MOVE.L  D0,GCOMMAND_PpvShowtimesRowSpan
    MOVE.B  #$42,GCOMMAND_PpvShowtimesWorkflowMode
    MOVE.B  #$59,GCOMMAND_PpvDetailLayoutFlag
    MOVE.L  GCOMMAND_PPVListingsTemplatePtr,-(A7)
    PEA     DATA_FLIB_STR_DIGITAL_PPV_LISTINGS_1F64
    JSR     ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,GCOMMAND_PPVListingsTemplatePtr
    MOVE.L  GCOMMAND_PPVPeriodTemplatePtr,(A7)
    PEA     GLOB_STR_DIGITAL_PPV_PERIOD
    JSR     ESQPARS_ReplaceOwnedString(PC)

    LEA     12(A7),A7
    MOVE.L  D0,GCOMMAND_PPVPeriodTemplatePtr
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
;   GCOMMAND_DigitalNicheListingsTemplatePtr, GCOMMAND_MplexListingsTemplatePtr, GCOMMAND_MplexAtTemplatePtr, GCOMMAND_PPVListingsTemplatePtr, GCOMMAND_PPVPeriodTemplatePtr
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
FLIB2_ResetAndLoadListingTemplates:
    SUBA.L  A0,A0
    MOVE.L  A0,GCOMMAND_DigitalNicheListingsTemplatePtr
    MOVE.L  A0,GCOMMAND_MplexListingsTemplatePtr
    MOVE.L  A0,GCOMMAND_MplexAtTemplatePtr
    MOVE.L  A0,GCOMMAND_PPVListingsTemplatePtr
    MOVE.L  A0,GCOMMAND_PPVPeriodTemplatePtr
    BSR.W   FLIB2_LoadDigitalNicheDefaults

    BSR.W   FLIB2_LoadDigitalMplexDefaults

    BSR.W   FLIB2_LoadDigitalPpvDefaults

    BSR.W   GCOMMAND_LoadDefaultTable

    BSR.W   GCOMMAND_LoadMplexTemplate

    BSR.W   GCOMMAND_LoadPPV3Template

    RTS
