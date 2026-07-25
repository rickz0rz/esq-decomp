/* RESTORES: TEXTDISP_ResetSelectionState
 * MODULE:   modules/groups/b/a/textdisp.s
 * STATUS:   behavioural
 *
 * Resets a selection record to defaults. Display path. 36 bytes both ways;
 * the ONLY difference is A3 vs A5 -- every other byte is identical.
 *
 * SASC-MISMATCH: register-allocation-order
 *   summary: SAS/C 6.51 allocates A5 for the first pointer local where the
 *            original always uses A3, and D6 before D7 where the original uses
 *            D7 first. Every other byte matches. Not the data model (reproduces
 *            with and without DATA=FAR, and these touch no globals) and not an
 *            option: NOAUTOREG, OPTIMIZE and SHORTINT all leave it in place.
 *            Consistent across every function with a pointer local, so it is a
 *            code-generator difference, not a source-form one.
 *   tried:   DATA=FAR on/off, NOAUTOREG, OPTIMIZE, SHORTINT.
 *   retest:  a compiler that picks A3 before A5, and D7 before D6, should match
 *            these sources unchanged.
 */
struct TextDispSelection {
    char  pad[210];
    long  mode;
    long  index;
    short match;
    char  flag;
};

void TEXTDISP_ResetSelectionState(struct TextDispSelection *sel)
{
    if (sel != 0) {
        sel->mode  = 3;
        sel->index = -1;
        sel->match = -1;
        sel->flag  = 0;
    }
}
