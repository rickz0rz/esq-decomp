/* RESTORES: FLIB2_LoadDigitalNicheDefaults
 * MODULE:   modules/groups/a/s/flib2.s
 * STATUS:   behavioural
 *
 * Resets the Digital Niche block to its built-in defaults: feature off, pens 1
 * and 5, no mode cycling, workflow mode 'B', and the listings template string
 * reset to the built-in text.
 *
 * The template pointer is reassigned through ESQPARS_ReplaceOwnedString, which
 * frees the old string and returns the new one, so the store must take that
 * return value rather than the literal.
 *
 * 84 bytes in the original, 84 emitted, and only the store-order habit differs
 * (+6 / -6, no cost). Worth noting what did NOT need forcing: the original holds
 * 1 in D0 and 5 in D1 and stores each twice, interleaved, and SAS/C does the same
 * from four plain assignments -- no chained form needed. The chained-assignment
 * rule is for the ZERO stores, and those are written as a chain here.
 *
 * SASC-MISMATCH: alloc-result-store-order
 *   summary: JSR then pop then store, against BSR then store then pop. +6/-6.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the one cross-unit call.
 */

extern char *ESQPARS_ReplaceOwnedString(char *newText, char *old);

extern char GCOMMAND_DigitalNicheEnabledFlag;
extern long GCOMMAND_NicheTextPen;
extern long GCOMMAND_NicheFramePen;
extern long GCOMMAND_NicheEditorLayoutPen;
extern long GCOMMAND_NicheEditorRowPen;
extern long GCOMMAND_NicheModeCycleCount;
extern long GCOMMAND_NicheForceMode5Flag;
extern char GCOMMAND_NicheWorkflowMode;
extern char *GCOMMAND_DigitalNicheListingsTemplatePtr;
extern char FLIB_STR_DIGITAL_NICHE_LISTINGS[];

void FLIB2_LoadDigitalNicheDefaults(void)
{
    GCOMMAND_DigitalNicheEnabledFlag = 'N';
    GCOMMAND_NicheTextPen = 1;
    GCOMMAND_NicheFramePen = 5;
    GCOMMAND_NicheEditorLayoutPen = 1;
    GCOMMAND_NicheEditorRowPen = 5;
    GCOMMAND_NicheForceMode5Flag = GCOMMAND_NicheModeCycleCount = 0;
    GCOMMAND_NicheWorkflowMode = 'B';
    GCOMMAND_DigitalNicheListingsTemplatePtr =
        ESQPARS_ReplaceOwnedString(FLIB_STR_DIGITAL_NICHE_LISTINGS,
                                   GCOMMAND_DigitalNicheListingsTemplatePtr);
}
