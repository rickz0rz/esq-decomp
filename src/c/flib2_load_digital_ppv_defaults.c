/* RESTORES: FLIB2_LoadDigitalPpvDefaults
 * MODULE:   modules/groups/a/s/flib2.s
 * STATUS:   behavioural
 *
 * 158 bytes in the original and 158 emitted, with only TWO differing regions --
 * matching its sibling flib2_load_digital_mplex_defaults.c exactly in both size
 * agreement and residual.
 *
 * Both differences are the cross-unit call encoding (4EBA against 6100) and the
 * cleanup reorder after the second. Everything else is byte-identical, including
 * the register sharing that reuses D0 across 3 and the showtimes line index, D1
 * across 1 and the showtimes layout pen, and D2 across both stores of 7 --
 * reproduced from plain sequential assignments with no source hints.
 *
 * The pair is worth having together: two defaults-loaders from the same module,
 * both landing at exact size with the call encoding as the sole divergence.
 * Whatever the original compiler was, this shape of function is fully within
 * reach of it, and both should go byte-exact once the call encoding is right.
 *
 * Note the mode flags are ASCII: 'N' for the enabled flag (the Mplex sibling uses
 * 'N' = 78 too, written there as the decimal), 'B' for the workflow mode and 'Y'
 * for the detail layout flag. Writing them as characters rather than numbers
 * makes the config semantics legible without changing a byte.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: The only divergence. Both calls were cross-unit in the original.
 */
extern char *ESQPARS_ReplaceOwnedString(char *newstr, char *old);
extern unsigned char GCOMMAND_DigitalPpvEnabledFlag;
extern long GCOMMAND_PpvModeCycleCount;
extern long GCOMMAND_PpvSelectionWindowMinutes;
extern long GCOMMAND_PpvSelectionToleranceMinutes;
extern long GCOMMAND_PpvMessageTextPen;
extern long GCOMMAND_PpvMessageFramePen;
extern long GCOMMAND_PpvEditorLayoutPen;
extern long GCOMMAND_PpvEditorRowPen;
extern long GCOMMAND_PpvShowtimesLayoutPen;
extern long GCOMMAND_PpvShowtimesInitialLineIndex;
extern long GCOMMAND_PpvShowtimesRowPen;
extern long GCOMMAND_PpvShowtimesRowSpan;
extern unsigned char GCOMMAND_PpvShowtimesWorkflowMode;
extern unsigned char GCOMMAND_PpvDetailLayoutFlag;
extern char *GCOMMAND_PPVListingsTemplatePtr;
extern char *GCOMMAND_PPVPeriodTemplatePtr;
extern char FLIB_STR_DIGITAL_PPV_LISTINGS[];
extern char Global_STR_DIGITAL_PPV_PERIOD[];

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
    GCOMMAND_PpvDetailLayoutFlag = 'Y';

    GCOMMAND_PPVListingsTemplatePtr =
        ESQPARS_ReplaceOwnedString(FLIB_STR_DIGITAL_PPV_LISTINGS,
                                   GCOMMAND_PPVListingsTemplatePtr);
    GCOMMAND_PPVPeriodTemplatePtr =
        ESQPARS_ReplaceOwnedString(Global_STR_DIGITAL_PPV_PERIOD,
                                   GCOMMAND_PPVPeriodTemplatePtr);
}
