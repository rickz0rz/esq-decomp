typedef signed long LONG;
typedef unsigned char UBYTE;

extern UBYTE GCOMMAND_DigitalNicheEnabledFlag;
extern LONG GCOMMAND_NicheTextPen;
extern LONG GCOMMAND_NicheFramePen;
extern LONG GCOMMAND_NicheEditorLayoutPen;
extern LONG GCOMMAND_NicheEditorRowPen;
extern LONG GCOMMAND_NicheModeCycleCount;
extern LONG GCOMMAND_NicheForceMode5Flag;
extern UBYTE GCOMMAND_NicheWorkflowMode;
extern char *GCOMMAND_DigitalNicheListingsTemplatePtr;

extern UBYTE GCOMMAND_DigitalMplexEnabledFlag;
extern LONG GCOMMAND_MplexModeCycleCount;
extern LONG GCOMMAND_MplexSearchRowLimit;
extern LONG GCOMMAND_MplexClockOffsetMinutes;
extern LONG GCOMMAND_MplexMessageTextPen;
extern LONG GCOMMAND_MplexMessageFramePen;
extern LONG GCOMMAND_MplexEditorLayoutPen;
extern LONG GCOMMAND_MplexEditorRowPen;
extern LONG GCOMMAND_MplexDetailLayoutPen;
extern LONG GCOMMAND_MplexDetailInitialLineIndex;
extern LONG GCOMMAND_MplexDetailRowPen;
extern UBYTE GCOMMAND_MplexWorkflowMode;
extern UBYTE GCOMMAND_MplexDetailLayoutFlag;
extern char *GCOMMAND_MplexListingsTemplatePtr;
extern char *GCOMMAND_MplexAtTemplatePtr;

extern UBYTE GCOMMAND_DigitalPpvEnabledFlag;
extern LONG GCOMMAND_PpvModeCycleCount;
extern LONG GCOMMAND_PpvSelectionWindowMinutes;
extern LONG GCOMMAND_PpvSelectionToleranceMinutes;
extern LONG GCOMMAND_PpvMessageTextPen;
extern LONG GCOMMAND_PpvMessageFramePen;
extern LONG GCOMMAND_PpvEditorLayoutPen;
extern LONG GCOMMAND_PpvEditorRowPen;
extern LONG GCOMMAND_PpvShowtimesLayoutPen;
extern LONG GCOMMAND_PpvShowtimesInitialLineIndex;
extern LONG GCOMMAND_PpvShowtimesRowPen;
extern LONG GCOMMAND_PpvShowtimesRowSpan;
extern UBYTE GCOMMAND_PpvShowtimesWorkflowMode;
extern UBYTE GCOMMAND_PpvDetailLayoutFlag;
extern char *GCOMMAND_PPVListingsTemplatePtr;
extern char *GCOMMAND_PPVPeriodTemplatePtr;

extern const char FLIB_STR_DIGITAL_NICHE_LISTINGS[];
extern const char FLIB_STR_DIGITAL_MULTIPLEX_LISTINGS[];
extern const char FLIB_FMT_DIGITAL_MULTIPLEX_AT_PCT_S[];
extern const char FLIB_STR_DIGITAL_PPV_LISTINGS[];
extern const char Global_STR_DIGITAL_PPV_PERIOD[];

extern char *ESQPARS_ReplaceOwnedString(const char *newValue, char *oldValue);
extern LONG GCOMMAND_LoadDefaultTable(void);
extern LONG GCOMMAND_LoadMplexTemplate(void);
extern LONG GCOMMAND_LoadPPV3Template(void);

void FLIB2_LoadDigitalNicheDefaults(void)
{
    GCOMMAND_DigitalNicheEnabledFlag = 'N';
    GCOMMAND_NicheTextPen = 1;
    GCOMMAND_NicheFramePen = 5;
    GCOMMAND_NicheEditorLayoutPen = 1;
    GCOMMAND_NicheEditorRowPen = 5;
    GCOMMAND_NicheModeCycleCount = 0;
    GCOMMAND_NicheForceMode5Flag = 0;
    GCOMMAND_NicheWorkflowMode = 'B';
    GCOMMAND_DigitalNicheListingsTemplatePtr = ESQPARS_ReplaceOwnedString(
        FLIB_STR_DIGITAL_NICHE_LISTINGS,
        GCOMMAND_DigitalNicheListingsTemplatePtr
    );
}

void FLIB2_LoadDigitalMplexDefaults(void)
{
    GCOMMAND_DigitalMplexEnabledFlag = 'N';
    GCOMMAND_MplexModeCycleCount = 0;
    GCOMMAND_MplexSearchRowLimit = 0;
    GCOMMAND_MplexClockOffsetMinutes = 10;
    GCOMMAND_MplexMessageTextPen = 3;
    GCOMMAND_MplexMessageFramePen = 6;
    GCOMMAND_MplexEditorLayoutPen = 1;
    GCOMMAND_MplexEditorRowPen = 4;
    GCOMMAND_MplexDetailLayoutPen = 1;
    GCOMMAND_MplexDetailInitialLineIndex = 10;
    GCOMMAND_MplexDetailRowPen = 4;
    GCOMMAND_MplexWorkflowMode = 'B';
    GCOMMAND_MplexDetailLayoutFlag = 'N';
    GCOMMAND_MplexListingsTemplatePtr = ESQPARS_ReplaceOwnedString(
        FLIB_STR_DIGITAL_MULTIPLEX_LISTINGS,
        GCOMMAND_MplexListingsTemplatePtr
    );
    GCOMMAND_MplexAtTemplatePtr = ESQPARS_ReplaceOwnedString(
        FLIB_FMT_DIGITAL_MULTIPLEX_AT_PCT_S,
        GCOMMAND_MplexAtTemplatePtr
    );
}

void FLIB2_LoadDigitalPpvDefaults(void)
{
    GCOMMAND_DigitalPpvEnabledFlag = 'N';
    GCOMMAND_PpvModeCycleCount = 0;
    GCOMMAND_PpvSelectionWindowMinutes = 60;
    GCOMMAND_PpvSelectionToleranceMinutes = 30;
    GCOMMAND_PpvMessageTextPen = 3;
    GCOMMAND_PpvMessageFramePen = 4;
    GCOMMAND_PpvEditorLayoutPen = 1;
    GCOMMAND_PpvEditorRowPen = 7;
    GCOMMAND_PpvShowtimesLayoutPen = 1;
    GCOMMAND_PpvShowtimesInitialLineIndex = 3;
    GCOMMAND_PpvShowtimesRowPen = 7;
    GCOMMAND_PpvShowtimesRowSpan = 24;
    GCOMMAND_PpvShowtimesWorkflowMode = 'B';
    GCOMMAND_PpvDetailLayoutFlag = 0x59;
    GCOMMAND_PPVListingsTemplatePtr = ESQPARS_ReplaceOwnedString(
        FLIB_STR_DIGITAL_PPV_LISTINGS,
        GCOMMAND_PPVListingsTemplatePtr
    );
    GCOMMAND_PPVPeriodTemplatePtr = ESQPARS_ReplaceOwnedString(
        Global_STR_DIGITAL_PPV_PERIOD,
        GCOMMAND_PPVPeriodTemplatePtr
    );
}

void FLIB2_ResetAndLoadListingTemplates(void)
{
    GCOMMAND_DigitalNicheListingsTemplatePtr = (char *)0;
    GCOMMAND_MplexListingsTemplatePtr = (char *)0;
    GCOMMAND_MplexAtTemplatePtr = (char *)0;
    GCOMMAND_PPVListingsTemplatePtr = (char *)0;
    GCOMMAND_PPVPeriodTemplatePtr = (char *)0;

    FLIB2_LoadDigitalNicheDefaults();
    FLIB2_LoadDigitalMplexDefaults();
    FLIB2_LoadDigitalPpvDefaults();

    GCOMMAND_LoadDefaultTable();
    GCOMMAND_LoadMplexTemplate();
    GCOMMAND_LoadPPV3Template();
}
