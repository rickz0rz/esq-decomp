/* RESTORES: SCRIPT_SelectPlaybackCursorFromSearchText
 * MODULE:   modules/groups/b/a/script2.s
 * STATUS:   behavioural
 *
 * 246 bytes in the original, 248 emitted -- +2, one of the tightest large
 * restorations in the project.
 *
 * Reproduces: the scan from index 3 for the 0x12 terminator with its 30-byte
 * bound, the NUL written at wherever the scan stopped (including the
 * out-of-bounds case where it stopped at 30), the three-way search order in which
 * the secondary text is tried FIRST or LAST depending on
 * SCRIPT_PrimarySearchFirstFlag with the primary always in the middle, the
 * distinct cursor values 7 / 6 / 7 written on each hit, and the failure tail that
 * clears the armed flag and parks the cursor at 1.
 *
 * The two secondary probes are separately emitted rather than shared -- the
 * original does not factor them into a helper or a loop, so neither should this.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fffc                   LINK.W A5,#-4
 *   got:     (none)                     MOVEM only
 *   summary: The A5-frame class. With no true locals the original's four-byte
 *            frame buys nothing and SAS/C omits it, which is most of the small
 *            delta.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the three cross-unit calls.
 */
extern short TEXTDISP_SelectGroupAndEntry(char *p, char *text, long code);
extern long  SCRIPT_SearchMatchCountOrIndex;
extern short SCRIPT_ChannelRangeArmedFlag;
extern short SCRIPT_PrimarySearchFirstFlag;
extern long  SCRIPT_PlaybackCursor;
extern short TEXTDISP_PrimaryChannelCode;
extern short TEXTDISP_SecondaryChannelCode;
extern char  TEXTDISP_PrimarySearchText[];
extern char  TEXTDISP_SecondarySearchText[];

long SCRIPT_SelectPlaybackCursorFromSearchText(long arg, char *buf)
{
    register long ok;
    register short i;

    ok = 1;
    SCRIPT_SearchMatchCountOrIndex = arg;
    SCRIPT_ChannelRangeArmedFlag = 1;

    for (i = 3; buf[i] != 18 && i < 30; i++)
        ;
    buf[i] = 0;

    if (SCRIPT_PrimarySearchFirstFlag == 0) {
        if (TEXTDISP_SelectGroupAndEntry(&buf[i + 1], TEXTDISP_SecondarySearchText,
                                         (long)TEXTDISP_SecondaryChannelCode) == 1) {
            SCRIPT_PlaybackCursor = 7;
            return ok;
        }
    }

    if (TEXTDISP_SelectGroupAndEntry(buf + 2, TEXTDISP_PrimarySearchText,
                                     (long)TEXTDISP_PrimaryChannelCode) == 1) {
        SCRIPT_PlaybackCursor = 6;
        return ok;
    }

    if (SCRIPT_PrimarySearchFirstFlag) {
        if (TEXTDISP_SelectGroupAndEntry(&buf[i + 1], TEXTDISP_SecondarySearchText,
                                         (long)TEXTDISP_SecondaryChannelCode) == 1) {
            SCRIPT_PlaybackCursor = 7;
            return ok;
        }
    }

    ok = 0;
    SCRIPT_ChannelRangeArmedFlag = 0;
    SCRIPT_PlaybackCursor = 1;
    return ok;
}
