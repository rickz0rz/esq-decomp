/* RESTORES: GCOMMAND_InitPresetWorkEntry
 * MODULE:   modules/groups/a/u/gcommand3b_p1_p1.s
 * STATUS:   behavioural
 *
 * Fills a six-longword preset work entry, with three distinct outcomes.
 *
 * An index outside 0..15 is NOT just rejected: the entry is stamped with index
 * 6, every other field is cleared, and GCOMMAND_SetPresetEntry(6, 1365) is
 * called. That is a fallback, not an error path, and skipping the call would
 * leave the preset table inconsistent.
 *
 * For a valid index the span decides the rest. A span above 4 loads the real
 * defaults -- the value into +12, the default-table entry MINUS ONE into +4,
 * and the constants 2 and 1 into +20 and +8. A span of 0..4 clears those four
 * fields instead. A NEGATIVE span leaves them untouched, because the BMI at
 * 0x1BDDE jumps past the clearing block.
 *
 * The default table is indexed by word (ADD.L D1,D1) and the entry is
 * EXT.L-widened, so it holds signed shorts.
 *
 * Every clearing run comes from ONE zeroed register, and the store order fixes
 * the chain direction: the invalid path writes +16, +12, +4, +20, +8 and the
 * small-span path writes +12, +4, +20, +8, so both chains are written
 * right-to-left against those orders.
 *
 * 150 ref vs 152 got. The range guard, the MOVEQ #4 span test, the word-indexed
 * default-table lookup with its EXT.L and SUBQ.L #1, the constants 6, 2, 1 and
 * 1365, the SetPresetEntry call and all three field-clearing runs match in kind
 * and size.
 *
 * SASC-MISMATCH: case-body-layout
 *   ref:     the invalid arm sits LAST, after both valid arms
 *   got:     the invalid arm is emitted FIRST and the valid path branches over it
 *   summary: same three outcomes and same conditions; 6.51 places the early
 *            return at the top. That plus the A3/A5 allocation is the 2 bytes.
 *   scope:   program-wide. docs/compiler-version.md, "Parameter and case
 *            layout".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct GCommandPresetWork {
    long index;                 /* +0  */
    long f4;                    /* +4  */
    long f8;                    /* +8  */
    long f12;                   /* +12 */
    long f16;                   /* +16 */
    long f20;                   /* +20 */
};

extern void  GCOMMAND_SetPresetEntry(long index, long line);
extern short GCOMMAND_DefaultPresetTable[];

void GCOMMAND_InitPresetWorkEntry(struct GCommandPresetWork *w, long index,
                                  long span, long value)
{
    if (index < 0 || index >= 16) {
        w->index = 6;
        w->f8 = w->f20 = w->f4 = w->f12 = w->f16 = 0;
        GCOMMAND_SetPresetEntry(6L, 1365L);
        return;
    }

    w->index = index;
    w->f16   = 0;

    if (span > 4) {
        w->f12 = value;
        w->f4  = (long)GCOMMAND_DefaultPresetTable[index] - 1;
        w->f20 = 2;
        w->f8  = 1;
    } else if (span >= 0) {
        w->f8 = w->f20 = w->f4 = w->f12 = 0;
    }
}
