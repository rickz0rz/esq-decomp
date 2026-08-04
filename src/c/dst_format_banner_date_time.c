/* RESTORES: DST_FormatBannerDateTime
 * MODULE:   modules/groups/a/j/dst2.s
 * STATUS:   behavioural
 *
 * 200 bytes in the original and 200 emitted -- the FIFTH size coincidence of the
 * run, with 18 differing regions. Not a near-match.
 *
 * Reproduces: the three ternary string selections (PM/AM, DST/STD, leap/normal),
 * the two jump-table lookups indexing the short day and month name tables by
 * scaled word fields, and the thirteen-argument format call with its exact
 * argument order -- note the record's field at +16 is passed THIRD among the
 * numerics, out of address order, which is the sort of thing that would silently
 * transpose two format fields if reconstructed from the struct layout instead of
 * from the push sequence.
 *
 * SASC-MISMATCH: expression-scheduling
 *   summary: The original loads all the numeric fields into registers first and
 *            then evaluates the three string ternaries; SAS/C evaluates the
 *            ternaries first and loads the fields as it pushes them. Same
 *            operations, same operands, same total size -- reordered. That is why
 *            18 regions differ despite the byte count matching exactly.
 *   scope:   any function with several independent subexpressions feeding one
 *            call.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ffd8                   LINK.W A5,#-40
 *   got:     514f                       SUBQ.W #4,A7
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the cross-unit format call.
 */
struct DstBanner {
    short dayIdx;    /*  0 */
    short monthIdx;  /*  2 */
    short f4;        /*  4 */
    short f6;        /*  6 */
    short f8;        /*  8 */
    short f10;       /* 10 */
    short f12;       /* 12 */
    short zoneFlag;  /* 14 */
    short f16;       /* 16 */
    short pmFlag;    /* 18 */
    short leapFlag;  /* 20 */
};

extern void FORMAT_RawDoFmtWithScratchBuffer();
extern char *Global_JMPTBL_SHORT_DAYS_OF_WEEK[];
extern char *Global_JMPTBL_SHORT_MONTHS[];
extern char DST_TAG_PM[], DST_TAG_AM[];
extern char DST_TAG_DST[], DST_TAG_STD[];
extern char DST_STR_LEAP_YEAR[], DST_STR_NORM_YEAR[];
extern char DST_FMT_PCT_S_COLON_PCT_S_PCT_S_PCT_02D_PCT_[];

void DST_FormatBannerDateTime(char *out, struct DstBanner *r)
{
    char *ampm;
    char *zone;
    char *yearKind;

    ampm = r->pmFlag ? DST_TAG_PM : DST_TAG_AM;
    zone = (r->zoneFlag == 1) ? DST_TAG_DST : DST_TAG_STD;
    yearKind = r->leapFlag ? DST_STR_LEAP_YEAR : DST_STR_NORM_YEAR;

    FORMAT_RawDoFmtWithScratchBuffer(
        DST_FMT_PCT_S_COLON_PCT_S_PCT_S_PCT_02D_PCT_,
        out,
        Global_JMPTBL_SHORT_DAYS_OF_WEEK[r->dayIdx],
        Global_JMPTBL_SHORT_MONTHS[r->monthIdx],
        (long)r->f4, (long)r->f6, (long)r->f16,
        (long)r->f8, (long)r->f10, (long)r->f12,
        ampm, zone, yearKind);
}
