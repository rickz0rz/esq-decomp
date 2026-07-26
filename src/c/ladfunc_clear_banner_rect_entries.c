/* RESTORES: LADFUNC_ClearBannerRectEntries
 * MODULE:   modules/groups/a/w/ladfunc.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-allocation-order
 *   ref:     48e701107e00702ebe406c2a200748c0e58041f900009fc4d1c0265070003680374000023740000491c8274800062748000a524760d0700033c00000a34e33c00000a2e033c00000a35233c00000a34433c00000a34670001039000028d57230908123c0000085ca4cdf08804e75
 *   got:     48e701047e00702ebe406c2648c72007e58041f900000000d1c02a504255426d0002426d000442ad000642ad000a524760d4700033c00000000033c00000000033c00000000033c00000000033c00000000070001039000000007230908123c0000000004cdf20804e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct LadfuncEntry { short a; short b; short c; long p; long q; };
extern struct LadfuncEntry *LADFUNC_EntryPtrTable[];
extern short LADFUNC_HighlightCycleCountdown, LADFUNC_EntryCount, LADFUNC_ParsedEntryCount;
extern short WDISP_HighlightActive, WDISP_HighlightIndex;
extern unsigned char ED_DiagScrollSpeedChar;
extern long ED_TextLimit;

void LADFUNC_ClearBannerRectEntries(void)
{
    short i;

    for (i = 0; i < 46; i++) {
        struct LadfuncEntry *e = LADFUNC_EntryPtrTable[i];
        e->a = 0;
        e->b = 0;
        e->c = 0;
        e->p = 0;
        e->q = 0;
    }
    WDISP_HighlightIndex = WDISP_HighlightActive = LADFUNC_ParsedEntryCount =
        LADFUNC_EntryCount = LADFUNC_HighlightCycleCountdown = 0;
    ED_TextLimit = (long)ED_DiagScrollSpeedChar - 48;
}
