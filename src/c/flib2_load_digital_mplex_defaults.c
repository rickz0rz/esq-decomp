/* RESTORES: FLIB2_LoadDigitalMplexDefaults
 * MODULE:   modules/groups/a/s/flib2.s
 * STATUS:   behavioural
 *
 * 152 bytes in the original and 152 emitted, with only TWO differing regions --
 * the closest restoration in the project outside the exact set.
 *
 * Both differences are the cross-unit call encoding (4EBA against 6100) and the
 * cleanup reorder that follows the second one. Everything else is byte-identical:
 * the byte flag written from D0 and reused twelve instructions later for a second
 * byte flag, the chained zero across the two counters, the whole run of pen and
 * index constants with their register sharing, the literal 'B', and both
 * ReplaceOwnedString calls with the stack slot reused between them.
 *
 * That makes this function a strong candidate to go byte-exact the moment the
 * call encoding is right -- there is nothing else wrong with it. On the corrected
 * bracket (Lattice 5.10 < ORIGINAL < SAS/C 6.00) a compiler emitting 4EBA for
 * cross-unit calls should close it outright.
 *
 * Notable that the register sharing reproduced without any source hints. The
 * chained assignment was needed only for the pair of counters that share a zero;
 * the rest of the constant reuse (D1 across 10 and 3, D2 across 6 and 1, D3
 * across two stores of 4) SAS/C worked out by itself from plain sequential
 * assignments. Worth knowing: the chained-assignment rule is for shared ZEROS
 * specifically, not for constant reuse generally.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: The only divergence. Both calls were cross-unit in the original.
 */
extern char *ESQPARS_ReplaceOwnedString(char *newstr, char *old);
extern unsigned char GCOMMAND_DigitalMplexEnabledFlag;
extern long GCOMMAND_MplexModeCycleCount;
extern long GCOMMAND_MplexSearchRowLimit;
extern long GCOMMAND_MplexClockOffsetMinutes;
extern long GCOMMAND_MplexMessageTextPen;
extern long GCOMMAND_MplexMessageFramePen;
extern long GCOMMAND_MplexEditorLayoutPen;
extern long GCOMMAND_MplexEditorRowPen;
extern long GCOMMAND_MplexDetailLayoutPen;
extern long GCOMMAND_MplexDetailInitialLineIndex;
extern long GCOMMAND_MplexDetailRowPen;
extern unsigned char GCOMMAND_MplexWorkflowMode;
extern unsigned char GCOMMAND_MplexDetailLayoutFlag;
extern char *GCOMMAND_MplexListingsTemplatePtr;
extern char *GCOMMAND_MplexAtTemplatePtr;
extern char FLIB_STR_DIGITAL_MULTIPLEX_LISTINGS[];
extern char FLIB_FMT_DIGITAL_MULTIPLEX_AT_PCT_S[];

void FLIB2_LoadDigitalMplexDefaults(void)
{
    GCOMMAND_DigitalMplexEnabledFlag = 78;

    GCOMMAND_MplexSearchRowLimit = GCOMMAND_MplexModeCycleCount = 0;
    GCOMMAND_MplexClockOffsetMinutes = 10;
    GCOMMAND_MplexMessageTextPen = 3;
    GCOMMAND_MplexMessageFramePen = 6;
    GCOMMAND_MplexEditorLayoutPen = 1;
    GCOMMAND_MplexEditorRowPen = 4;
    GCOMMAND_MplexDetailLayoutPen = 1;
    GCOMMAND_MplexDetailInitialLineIndex = 3;
    GCOMMAND_MplexDetailRowPen = 4;

    GCOMMAND_MplexWorkflowMode = 'B';
    GCOMMAND_MplexDetailLayoutFlag = 78;

    GCOMMAND_MplexListingsTemplatePtr =
        ESQPARS_ReplaceOwnedString(FLIB_STR_DIGITAL_MULTIPLEX_LISTINGS,
                                   GCOMMAND_MplexListingsTemplatePtr);
    GCOMMAND_MplexAtTemplatePtr =
        ESQPARS_ReplaceOwnedString(FLIB_FMT_DIGITAL_MULTIPLEX_AT_PCT_S,
                                   GCOMMAND_MplexAtTemplatePtr);
}
