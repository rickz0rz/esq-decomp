/* RESTORES: LADFUNC_FreeBannerRectEntries
 * MODULE:   modules/groups/a/w/ladfunc.s
 * STATUS:   behavioural
 *
 * Walks the 46-slot banner entry table, releasing each entry's owned text and
 * its pixel buffer before freeing the 14-byte entry itself and clearing the slot.
 *
 * Two shapes here are deliberate and both come from the source-shapes table in
 * AGENTS.md:
 *   - the table subscript is written out at every access rather than hoisted into
 *     a pointer local, because the original recomputes MOVE.L D7,D0 / ASL.L #2,D0
 *     / LEA table,A0 for each one;
 *   - the length is strlen(), which SAS/C inlines to the original's
 *     TST.B (A0)+ / BNE.S scan followed by SUBQ.L #1 / SUBA.L.
 *
 * 216 bytes against 216, in four differing regions, three of which are the call
 * encoding. The size agreement is checked, not assumed -- every structural count
 * matches the reference exactly:
 *
 *     LEA (abs).L,An      5 : 5        ASL.L #2,D0     6 : 6
 *     LEA (d16,An),Am     0 : 0        ADDA.L D0,An    8 : 8
 *
 * so the table subscript is recomputed at the same eight places the original
 * recomputes it, and no address is materialised that the original folds. Only
 * one real divergence remains, and it is a same-size register choice:
 *
 * SASC-MISMATCH: strlen-base-register
 *   ref:     4a1866fc538891e90006  TST.B (A0)+ / BNE.S / SUBQ.L #1,A0
 *                                  / SUBA.L 6(A1),A0
 *   got:     20084a1866fc538891c0  MOVE.L A0,D0 / TST.B (A0)+ / BNE.S
 *                                  / SUBQ.L #1,A0 / SUBA.L D0,A0
 *   summary: to turn the scan end-pointer into a length both subtract the start,
 *            but the original re-reads the struct field it started from while
 *            SAS/C keeps a copy in D0. Ten bytes either way.
 *   tried:   strlen() is already the form that produces the original's scan loop;
 *            the difference is only in how the subtraction sources its operand.
 *   retest:  a compiler that re-reads the base operand rather than caching it.
 *
 * SASC-MISMATCH: cross-unit-call
 *   ref:     4eba9a72 / 4eba3dbe / 4eba3d9a    JSR (d16,PC), 3 sites
 *   got:     61000000                          BSR.W
 *   summary: the standard call-encoding class. Both 4 bytes.
 */
#include <string.h>

struct BannerEntry {
    char  pad0[6];
    char *text;                 /* +6  */
    void *buf;                  /* +10 */
};                              /* 14 bytes */

extern struct BannerEntry *LADFUNC_EntryPtrTable[];
extern char *ESQPARS_ReplaceOwnedString(char *newstr, char *old);
extern void  MEMORY_DeallocateMemory(char *who, long line,
                                                    void *ptr, long size);

void LADFUNC_FreeBannerRectEntries(void)
{
    register long i;
    long len;

    for (i = 0; i < 46; i++) {
        if (LADFUNC_EntryPtrTable[i] == 0)
            continue;

        if (LADFUNC_EntryPtrTable[i]->text) {
            len = strlen(LADFUNC_EntryPtrTable[i]->text);
            ESQPARS_ReplaceOwnedString(0, LADFUNC_EntryPtrTable[i]->text);
        } else {
            len = 0;
        }

        if (len > 0 && LADFUNC_EntryPtrTable[i]->buf)
            MEMORY_DeallocateMemory("LADFUNC.c", 147,
                                                   LADFUNC_EntryPtrTable[i]->buf, len);

        MEMORY_DeallocateMemory("LADFUNC.c", 150,
                                               LADFUNC_EntryPtrTable[i], 14);
        LADFUNC_EntryPtrTable[i] = 0;
    }
}
