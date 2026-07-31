/* RESTORES: DST_HandleBannerCommand32_33
 * MODULE:   modules/groups/a/j/dst2.s
 * STATUS:   behavioural
 *
 * Handles the two banner date commands '2' and '3'. Both parse the same text
 * twice -- once from offset 4 and once from offset 19 -- and hand the pair to
 * the recalculator; they differ only in which banner window they target, and
 * '3' additionally refreshes the queue.
 *
 * The two windows are POINTER globals, and the two ways they are used prove it:
 * DATETIME_CopyPairAndRecalc receives MOVE.L global (the value) while
 * DST_UpdateBannerQueue receives PEA global (the address). Declaring them as
 * arrays would make the first call pass the wrong thing.
 *
 * The dispatch is a chained subtract at word width (SUBI.W #$32 / BEQ /
 * SUBQ.W #1 / BEQ), which is the `switch` shape, and the command arrives as a
 * byte at 11(A5).
 *
 * The two 22-byte parse buffers are the same size DATETIME_CopyPairAndRecalc
 * copies, which is the cross-check that they are date records.
 *
 * 154 ref vs 156 got. Both command arms, all four PEA offsets (4 and 19 twice),
 * all four parse calls, both recalculate calls, both LEA 36(A7),A7 cleanups and
 * the queue refresh match in kind and size.
 *
 * OPTIONS: SHORTINT (per-file, and load-bearing).
 *
 * SHORTINT takes this from 156 bytes to 154 against the original's 154, and the
 * dispatch chain becomes VERBATIM:
 *
 *     ref  1007 4880 04400032 6706 5340 6736
 *     got  1007 4880 04400032 6706 5340 6736
 *
 * Without it the chain widens to long (48c0 7232 9081 ... 5380) -- same
 * structure, wrong width. This is the fifth sighting of the AGENTS.md pairing:
 * a chained-subtract dispatch wants `switch` and `SHORTINT` together. It was
 * initially reasoned NOT to apply here, on the grounds that the selector is
 * already a char and the labels are character constants and so there is no int
 * width to narrow. That reasoning was wrong -- the comparison is promoted to
 * int before the chain is built, and SHORTINT is what makes that int a word.
 * Reason about the emitted width, not about the declared types.
 */
struct DateTimePair {
    char *first;
    char *second;
    long  firstSeconds;
    long  secondSeconds;
};

extern void DATETIME_ParseString(char *out, char *text, long offset);
extern void DATETIME_CopyPairAndRecalc(struct DateTimePair *p, char *a, char *b);
extern long DST_UpdateBannerQueue(struct DateTimePair **window);

extern struct DateTimePair *DST_BannerWindowPrimary;
extern struct DateTimePair *DST_BannerWindowSecondary;

void DST_HandleBannerCommand32_33(char cmd, char *text)
{
    char a[22];
    char b[22];

    switch (cmd) {
    case '2':
        DATETIME_ParseString(a, text, 4L);
        DATETIME_ParseString(b, text, 19L);
        DATETIME_CopyPairAndRecalc(DST_BannerWindowSecondary, a, b);
        break;

    case '3':
        DATETIME_ParseString(a, text, 4L);
        DATETIME_ParseString(b, text, 19L);
        DATETIME_CopyPairAndRecalc(DST_BannerWindowPrimary, a, b);
        DST_UpdateBannerQueue(&DST_BannerWindowPrimary);
        break;
    }
}
