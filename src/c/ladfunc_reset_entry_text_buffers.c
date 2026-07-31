/* RESTORES: LADFUNC_ResetEntryTextBuffers
 * MODULE:   modules/groups/a/w/ladfunc_p0.s
 * STATUS:   behavioural
 *
 * Releases every entry's owned text and the 212-byte buffer that goes with it,
 * then clears the banner rectangles.
 *
 * The free is conditional on THREE things: the entry exists, its text at +6 is
 * non-null, and the text is non-empty. An entry with an empty string still gets
 * its text replaced but keeps its buffer -- the length test guards only the
 * DeallocateMemory, not the replace.
 *
 * The buffer at +10 has its own null test inside that, so four conditions in
 * all before the free happens.
 *
 * The length passed to the free is the STRING LENGTH, not the 212 the buffer
 * was allocated with; 212 is the source-line argument. That is what the push
 * order says -- PEA 212 is the line number and D6 is the size.
 *
 * The original re-indexes the table on every access rather than holding the
 * entry pointer -- five separate ASL.L #2 / LEA / ADDA.L runs in one iteration.
 * The C below indexes each time for the same reason.
 *
 * 200 ref vs 192 got. All five table re-indexings, both null guards, the inline
 * strlen, the TST.L length guard, the PEA 212 line number, the
 * LEA 16(A7),A7 cleanup, the CLR.L replace argument and the closing clear call
 * match in kind and size.
 *
 * SASC-MISMATCH: widen-before-vs-after-copy
 *   ref:     2007 48c0 e580     MOVE.L D7,D0 / EXT.L D0 / ASL.L #2,D0
 *   got:     48c7 2007 e580     EXT.L D7 / MOVE.L D7,D0 / ASL.L #2,D0
 *   summary: same three instructions reordered, at all five index sites.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: link-frame-vs-none
 *   ref:     4e55fff8 ... 4e5d  LINK.W A5,#-8 / UNLK
 *   got:     (nothing)
 *   summary: the original opens an 8-byte frame it uses only as the argument
 *            slot the replace call reads back through 16(A7); 6.51 addresses
 *            the same slot from A7 and needs no frame. The rest of the 8 bytes.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  a compiler that reserves A5; the same doc gives the probe.
 */
#include <string.h>

struct LadfuncTextEntry {
    char  pad0[6];
    char *text6;                /* +6  */
    void *buf10;                /* +10 */
};

extern void  NEWGRID_JMPTBL_MEMORY_DeallocateMemory(char *who, long line,
                                                    void *p, long size);
extern char *ESQPARS_ReplaceOwnedString(char *newStr, char *old);
extern void  LADFUNC_ClearBannerRectEntries(void);

extern struct LadfuncTextEntry *LADFUNC_EntryPtrTable[];
extern char Global_STR_LADFUNC_C_4[];

void LADFUNC_ResetEntryTextBuffers(void)
{
    short i;
    long  len;

    for (i = 0; i < 46; i++) {
        if (LADFUNC_EntryPtrTable[i] != 0
            && LADFUNC_EntryPtrTable[i]->text6 != 0) {

            len = (long)strlen(LADFUNC_EntryPtrTable[i]->text6);

            if (len > 0 && LADFUNC_EntryPtrTable[i]->buf10 != 0)
                NEWGRID_JMPTBL_MEMORY_DeallocateMemory(
                    Global_STR_LADFUNC_C_4, 212L,
                    LADFUNC_EntryPtrTable[i]->buf10, len);

            LADFUNC_EntryPtrTable[i]->text6 =
                ESQPARS_ReplaceOwnedString(0, LADFUNC_EntryPtrTable[i]->text6);
        }
    }

    LADFUNC_ClearBannerRectEntries();
}
