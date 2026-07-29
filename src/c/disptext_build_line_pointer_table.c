/* RESTORES: _DISPTEXT_BuildLinePointerTable
 * MODULE:   modules/groups/a/i/disptext_p0_disptext_buildlinepointertable.s
 * STATUS:   behavioural
 *
 * Fills the line-pointer table: each entry is the text buffer for that line
 * plus the line's own start offset. Entry 0 needs no offset, so it is copied
 * straight across before the loop begins, and the loop starts at 1.
 *
 * DISPTEXT_CurrentLineIndex is an array of words, not a single index. Element 0
 * holds the line count. Elements 1 upward hold per-line offsets. That is why the
 * same symbol is read both as a count and through the loop counter. The singular
 * name from the disassembly stays, so that the two builds agree on the symbol.
 *
 * The count gets one extra line when the current line already has text in it --
 * a partly-typed line still needs a pointer.
 *
 * The lock flag is written LAST, from the argument, and the function does
 * nothing at all when it is already set.
 *
 * THE WORD ARRAYS ARE UNSIGNED, and that is measured rather than assumed. The
 * original widens both of them with MOVEQ #0 followed by MOVE.W, which is a zero
 * extension. Signed arrays make SAS/C emit EXT.L and ADDA.W instead. The unsigned
 * spelling takes the function from 124 bytes to 132 against 134. It also takes it
 * from 6 differing regions to 4. That is larger AND closer, which is the case
 * AGENTS.md warns about.
 *
 * 132 bytes against 134, every byte itemised by tools/casm.py.
 *
 * SASC-MISMATCH: reload-vs-widen
 *   ref:     7200 3239000080ce   MOVEQ #0,D1 / MOVE.W sym,D1 -- a second
 *                                zero-extending load straight from memory
 *   got:     4840 4240 4840 3200 SWAP / CLR.W / SWAP / MOVE.W D0,D1 -- the
 *                                cached word widened in place
 *   summary: the source reads the line count from the same global twice. The
 *            original re-reads it, which costs nothing, because the load
 *            zero-extends on the way. 6.51 keeps the first read in a register,
 *            then clears the high word by hand. Net +4 bytes.
 *   tried:   a long local for the count, and reading the array into a local
 *            before the subscript. Both let 6.51 do the same common
 *            subexpression elimination.
 *   scope:   any function that reads one unsigned word global twice.
 *   retest:  a compiler that prefers a reload to a widen for an unsigned word.
 *
 * SASC-MISMATCH: index-scaling
 *   ref:     2006 e580   MOVE.L D6,D0 / ASL.L #2,D0 for the long-array index
 *   got:     (folded into the effective address)
 *   summary: the original scales the loop counter into a scratch register for
 *            each of the three arrays. 6.51 folds the scale into the addressing
 *            mode. That saves 4 bytes, and it is the reason the total lands
 *            below 134 rather than above.
 *   tried:   nothing. This is an addressing-mode choice, not a source shape.
 *   scope:   every indexed loop over a global array.
 *   retest:  a compiler that materialises the scaled index.
 */
extern long   DISPTEXT_LineTableLockFlag;
extern char  *DISPTEXT_TextBufferPtr[];
extern unsigned short DISPTEXT_CurrentLineIndex[];
extern char  *DISPTEXT_LinePtrTable[];
extern unsigned short DISPTEXT_LineLengthTable[];

void DISPTEXT_BuildLinePointerTable(long lock)
{
    long count, i, extra;

    if (DISPTEXT_LineTableLockFlag != 0)
        return;

    DISPTEXT_LinePtrTable[0] = DISPTEXT_TextBufferPtr[0];

    if (DISPTEXT_LineLengthTable[DISPTEXT_CurrentLineIndex[0]] != 0)
        extra = 1;
    else
        extra = 0;
    count = DISPTEXT_CurrentLineIndex[0] + extra;

    for (i = 1; i < count; i++)
        DISPTEXT_LinePtrTable[i] =
            DISPTEXT_TextBufferPtr[i] + DISPTEXT_CurrentLineIndex[i];

    DISPTEXT_LineTableLockFlag = lock;
}
