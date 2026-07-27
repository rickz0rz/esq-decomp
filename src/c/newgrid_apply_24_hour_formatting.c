/* RESTORES: NEWGRID_Apply24HourFormatting
 * MODULE:   modules/groups/b/a/newgrid1.s
 * STATUS:   behavioural
 *
 * 168 bytes in the original, 148 emitted, 7 differing regions.
 *
 * Reproduces: the four-way guard cascade (24-hour clock enabled, non-null string,
 * an open paren present, and a colon three bytes past it), and the in-place
 * rewrite of the two hour digits from the half-hour format table.
 *
 * The schedule offset is computed TWICE -- once for each character written --
 * with identical arguments. Hoisting it into a local would be the obvious
 * simplification and would halve the calls; the original does not, and neither
 * does this. Worth stating because it looks like an oversight rather than a
 * choice, and a reviewer might "correct" it.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fffc                   LINK.W A5,#-4
 *   got:     (none)                     MOVEM only
 *   summary: The A5-frame class. The single paren pointer stays in a register for
 *            SAS/C where the original spills and reloads it four times, which is
 *            the whole -20.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the three cross-unit calls.
 */
extern char *PARSEINI_JMPTBL_STR_FindCharPtr(char *s, long ch);
extern short NEWGRID2_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow(long row, long code);
extern char *Global_JMPTBL_HALF_HOURS_24_HR_FMT[];
extern char  Global_REF_STR_USE_24_HR_CLOCK[];

void NEWGRID_Apply24HourFormatting(char *s, short row, char code)
{
    char *p;

    if (Global_REF_STR_USE_24_HR_CLOCK[0] != 'Y')
        return;
    if (s == 0)
        return;

    p = PARSEINI_JMPTBL_STR_FindCharPtr(s, '(');
    if (p == 0)
        return;
    if (p[3] != ':')
        return;

    p[1] = Global_JMPTBL_HALF_HOURS_24_HR_FMT[
               NEWGRID2_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow((long)row,
                                                                   (long)(unsigned char)code)][0];
    p[2] = Global_JMPTBL_HALF_HOURS_24_HR_FMT[
               NEWGRID2_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow((long)row,
                                                                   (long)(unsigned char)code)][1];
}
