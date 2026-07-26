/* RESTORES: ESQSHARED_ApplyProgramTitleTextFilters
 * MODULE:   modules/groups/a/p/esqshared.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: argument-slot-reuse
 *   ref:     48e70110266f000c2e2f00102f0b6100001e2e872f0b6100006a2e8b610001242e8b610001b2504f4cdf08804e75
 *   got:     48e701042e2f00102a6f000c2f0d610000002e872f0d610000002e8d610000002e8d61000000504f4cdf20804e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern void ESQSHARED_CompressClosedCaptionedTag(char *s);
extern void ESQSHARED_NormalizeInStereoTag(char *s, long flag);
extern void ESQSHARED_ReplaceMovieRatingToken(char *s);
extern void ESQSHARED_ReplaceTvRatingToken(char *s);
void ESQSHARED_ApplyProgramTitleTextFilters(char *s, long flag)
{
    ESQSHARED_CompressClosedCaptionedTag(s);
    ESQSHARED_NormalizeInStereoTag(s, flag);
    ESQSHARED_ReplaceMovieRatingToken(s);
    ESQSHARED_ReplaceTvRatingToken(s);
}
