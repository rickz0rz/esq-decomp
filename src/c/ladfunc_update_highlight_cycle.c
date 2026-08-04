/* RESTORES: LADFUNC_UpdateHighlightCycle
 * MODULE:   modules/groups/a/w/ladfunc_p0.s
 * STATUS:   behavioural
 *
 * Advances the highlight to the next eligible entry, rebuilds its lines, ticks
 * the countdown, and reloads the countdown when it runs out.
 *
 * The search is a DO-WHILE, not a while: the original enters at the wrap
 * (0x1D796) and the back-branch from the state test lands there, so the entry
 * index is advanced BEFORE the first test. Writing it as a leading `while`
 * would leave the current entry selected when it already qualifies.
 *
 * The wrap takes the REMAINDER of MATH_DivS32 (D1 is stored back, not D0), so
 * it is `% 46`. Same class as textdisp_draw_next_entry_preview.c, which walks
 * the same table.
 *
 * The eligibility test is `state == 1` on the word at +4, and the text pointer
 * is at +6 -- an unaligned long that lands there because SAS/C aligns a long to
 * 2 bytes on the 68000.
 *
 * The tail re-reads BOTH WDISP_HighlightActive and the countdown from memory
 * rather than reusing what it just wrote; the C below does the same, because
 * the rebuild call sits in between.
 *
 * The reload is a memory-to-memory word move (33f9), and it fires when the
 * countdown drops BELOW 1 -- so a countdown of exactly 1 still gets used once
 * more before reloading.
 * 148 ref vs 152 got. The do-while search, the MOVEQ #46 wrap divisor, the
 * ASL.L #2 table indexing at both sites, the MOVEQ #1 state test against 4(A1),
 * the 6(A1) text push, the SUBQ.W #1 countdown tick, the MOVEQ #1 reload
 * threshold and the memory-to-memory reload (33f9) all match in kind and size.
 *
 * SASC-MISMATCH: index-shift-needs-a-copy
 *   ref:     48c0 e580          EXT.L D0 / ASL.L #2,D0
 *   got:     48c0 2200 e581     EXT.L D0 / MOVE.L D0,D1 / ASL.L #2,D1
 *   summary: the original shifts the widened index in place; 6.51 copies it to
 *            a second register first. +2 at each of the two table lookups, and
 *            the same 2 again at the countdown copy (2200 against 3200). Same
 *            item as generate_grid_date_string.c.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct LadfuncHighlightEntry {
    char  pad0[4];
    short state;                /* +4 */
    char *text;                 /* +6, 2-byte aligned */
};

extern void LADFUNC_BuildHighlightLinesFromText(char *text);

extern short WDISP_HighlightActive;
extern short LADFUNC_HighlightCycleCountdown;
extern short LADFUNC_HighlightCycleCountdownReload;
extern short LADFUNC_EntryCount;
extern struct LadfuncHighlightEntry *LADFUNC_EntryPtrTable[];

void LADFUNC_UpdateHighlightCycle(void)
{
    if (WDISP_HighlightActive == 1 && LADFUNC_HighlightCycleCountdown > 0) {

        do {
            LADFUNC_EntryCount = (short)((((long)LADFUNC_EntryCount + 1) - (((long)LADFUNC_EntryCount + 1) / 46) * 46));
        } while (LADFUNC_EntryPtrTable[LADFUNC_EntryCount]->state != 1);

        LADFUNC_BuildHighlightLinesFromText(
            LADFUNC_EntryPtrTable[LADFUNC_EntryCount]->text);

        LADFUNC_HighlightCycleCountdown--;
    }

    if (WDISP_HighlightActive == 1 && LADFUNC_HighlightCycleCountdown < 1)
        LADFUNC_HighlightCycleCountdown = LADFUNC_HighlightCycleCountdownReload;
}
