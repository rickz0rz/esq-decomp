/* RESTORES: TLIBA1_BuildClockFormatEntryIfVisible
 * MODULE:   modules/groups/b/a/tliba1_p1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a5-frame-locals
 *   ref:     4e55ffe048e707103e2d000a3c2d000e266d00103a2d0016426dffe23039000076e85340662a200748c0487800012f004eba0366220748c1487800012f012b40fffc4eba03484fef00102b40fff86028200748c0487800022f004eba033c220748c1487800022f012b40fffc4eba031e4fef00102b40fff8220648c1487800052f012f2dfffc4eba02fe220648c1487800032f012f2dfffc2b40fff44eba02e8220648c1487800022f012f2dfffc2b40fff04eba02d2220648c1487800042f012f2dfffc2b40ffec4eba02bc220648c1487800012f012f2dfffc2b40ffe84eba02a64fef003c2b40ffe470ffbc406724200648c02f390000060c487805a02f002f2dfff82f2dfffc4eba02944fef00144a80674e4aadfff466184aadfff066124aadffec660c4aadffe866064aadffe46730200b6724200548c02f002f2dffe42f2dffe82f2dffec2f2dfff02f2dfff42f0b610000264fef001c3b7c0001ffe2600c200b6702421370003b40ffe2302dffe24cdf08e04e5d4e75
 *   got:     9efc001848e73f343a2f004e3c2f00463e2f00422a6f0048426f002630390000000053406626300748c0487800012f00610000002640300748c0487800012f006100000024404fef00106024300748c0487800022f00610000002640300748c0487800022f006100000024404fef0010300648c0487800052f002f0b61000000320648c1487800032f012f0b2f40005061000000320648c1487800022f012f0b2f40005861000000320648c1487800042f012f0b2f40006061000000320648c1487800012f012f0b2f400068610000004fef003c2f40002870ffbc406720300648c02f3900000000487805a02f002f0a2f0b610000004fef00144a806748202f00386618222f00346612242f0030660c262f002c6606282f0028672a220d6722320548c12f012f2f002c2f2f00342f2f003c2f2f00442f002f0d610000004fef001c70016008200d6702421570004cdf2cfcdefc00184e75
 *   summary: 344 got vs 378 ref, 34 bytes short. The original spills all five animation-field pointers and both entry pointers to negative A5 displacements and reloads them for the null chain and for the seven-argument format call; 6.51 keeps several in registers and reloads fewer. The active-group selection between mode 1 and mode 2, all five field lookups in their original order (5, 3, 2, 4, 1), the slot==-1 shortcut past the time-window test, the five-term null chain and the out==0 arm that still reports success all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short TEXTDISP_ActiveGroupId;
extern long  CONFIG_TimeWindowMinutes;

extern char *ESQDISP_GetEntryPointerByMode(long row, long kind);
extern char *ESQDISP_GetEntryAuxPointerByMode(long row, long kind);
extern char *COI_GetAnimFieldPointerByMode(char *entry, long slot,
                                                         long mode);
extern long  COI_TestEntryWithinTimeWindow(char *entry, char *aux,
                 long slot, long window, long fallback);
extern void  TLIBA1_FormatClockFormatEntry(char *out, char *f5, char *f3,
                 char *f2, char *f4, char *f1, long mode);

short TLIBA1_BuildClockFormatEntryIfVisible(short row, short slot, char *out,
                                            short mode)
{
    char *entry;
    char *aux;
    char *f5;
    char *f3;
    char *f2;
    char *f4;
    char *f1;
    short result;

    result = 0;

    if (TEXTDISP_ActiveGroupId == 1) {
        entry = ESQDISP_GetEntryPointerByMode((long)row, 1);
        aux   = ESQDISP_GetEntryAuxPointerByMode((long)row, 1);
    } else {
        entry = ESQDISP_GetEntryPointerByMode((long)row, 2);
        aux   = ESQDISP_GetEntryAuxPointerByMode((long)row, 2);
    }

    f5 = COI_GetAnimFieldPointerByMode(entry, (long)slot, 5);
    f3 = COI_GetAnimFieldPointerByMode(entry, (long)slot, 3);
    f2 = COI_GetAnimFieldPointerByMode(entry, (long)slot, 2);
    f4 = COI_GetAnimFieldPointerByMode(entry, (long)slot, 4);
    f1 = COI_GetAnimFieldPointerByMode(entry, (long)slot, 1);

    if (slot == -1
        || COI_TestEntryWithinTimeWindow(entry, aux, (long)slot,
               1440, CONFIG_TimeWindowMinutes) != 0) {
        if (f5 != 0 || f3 != 0 || f2 != 0 || f4 != 0 || f1 != 0) {
            if (out != 0)
                TLIBA1_FormatClockFormatEntry(out, f5, f3, f2, f4, f1,
                                              (long)mode);
            result = 1;
            return result;
        }
    }

    if (out != 0)
        *out = 0;
    result = 0;
    return result;
}
