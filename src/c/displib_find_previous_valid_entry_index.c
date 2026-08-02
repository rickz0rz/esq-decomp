/* RESTORES: DISPLIB_FindPreviousValidEntryIndex
 * MODULE:   modules/groups/a/i/displib.s
 * STATUS:   behavioural
 *
 * Scans BACKWARDS from `index` for the first non-empty entry in the table, and
 * returns its index. It returns 0 when the scan runs out of room.
 *
 * THE SCAN DISTANCE DEPENDS ON BIT 5 OF ctx[27]: 48 entries when the bit is set
 * and 7 when it is clear. That is the grid view against the list view -- a grid
 * page holds many more rows, so a search that would be reasonable in a list has
 * to reach further.
 *
 * THE FLOOR IS CLAMPED TO 1, NOT TO 0. `MOVEQ #1,D0 / CMP.L D0,D6 / BGE` keeps
 * the lower bound at least 1, so entry 0 is never returned by the scan itself.
 * It is only ever returned by the give-up path, which sets the index to 0
 * explicitly. Entry 0 is therefore a sentinel rather than data.
 *
 * THE WRAPPED FLAG IS WRITTEN ON EVERY ITERATION, NOT ONCE. In the bit-5-clear
 * case the loop stores 1 each time round, and the give-up path stores 0. Setting
 * it once outside the loop would be tidier and is NOT what the original does, so
 * it is reproduced as written -- a caller that clears the flag between reads
 * would see a different sequence.
 *
 * The flag is a WORD: `MOVE.W #1` and `CLR.W`, so it is declared `short`. See
 * AGENTS.md, "a byte-wide extern on a word-wide global", for why the width of an
 * extern is not something to infer from the data section.
 */

extern short DISPLIB_PreviousSearchWrappedFlag;

long DISPLIB_FindPreviousValidEntryIndex(unsigned char *ctx, void *table,
                                         long index)
{
    long *entries = (long *)((char *)table + 56);
    long reach = (ctx[27] & 0x20) ? 48 : 7;
    long floorIndex = index - reach;
    long i = index;

    if (floorIndex < 1)
        floorIndex = 1;

    for (;;) {
        if (entries[i] != 0)
            return i;
        i--;
        if (i < floorIndex) {
            DISPLIB_PreviousSearchWrappedFlag = 0;
            return 0;
        }
        if (!(ctx[27] & 0x20))
            DISPLIB_PreviousSearchWrappedFlag = 1;
    }
}
