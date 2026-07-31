/* RESTORES: TEXTDISP_ApplySourceConfigToEntry
 * MODULE:   modules/groups/b/a/textdisp_p2_p1.s
 * STATUS:   behavioural
 *
 * Clears the source-config bits on an entry and sets whichever ones its name
 * prefix matches.
 *
 * The clear is AND with the COMPLEMENT of the mask -- MOVE.B mask,D0 / NOT.B /
 * AND.B D0,40(A3) -- so the mask names the bits this function owns and nothing
 * else is disturbed.
 *
 * The comparison is length-limited to the CONFIG entry's own name, not the
 * entry's: the original strlens table[i]->name and passes that length. So a
 * config name is a PREFIX test against the entry's field at +12.
 *
 * The match is the ZERO result (BNE skips the flag store), which is the
 * ordinary strcmp sense.
 *
 * The config table is an array of POINTERS to records; the name is at +0 and
 * the bits to OR in are a byte at +4.
 *
 * 118 ref vs 120 got. The NOT.B / AND.B clear, the ASL.L #2 table indexing at
 * both sites, the inline strlen (4a18 66fc 5388), the three argument pushes,
 * the LEA 12(A7),A7 cleanup, the byte load from +4 and the OR.B into +40 all
 * match exactly.
 *
 * SASC-MISMATCH: a3-vs-a5-register-allocation
 *   ref:     48e70132 266f0014 c12b0028 2c50 2056 91d6   A2/A3/A6
 *   got:     48e70134 2a6f0014 c12d0028 2650 2053 91c0   A2/A3/A5
 *   summary: the entry pointer and the table cursor land in a different
 *            register set, and 6.51 reaches the name through A3 where the
 *            original borrows A6. Same instructions, same sizes; the 2 bytes
 *            are object alignment padding.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause".
 *   retest:  a compiler that reserves A5; the same doc gives the probe.
 */
#include <string.h>

struct TextDispSourceConfig {
    char         *name;         /* +0 */
    unsigned char bits;         /* +4 */
};

struct TextDispConfigEntry {
    char          pad0[12];
    char          name12[28];   /* +12 */
    unsigned char flags40;      /* +40 */
};

extern long STRING_CompareNoCaseN(char *a, char *b, long n);

extern unsigned char TEXTDISP_SourceConfigFlagMask;
extern long          TEXTDISP_SourceConfigEntryCount;
extern struct TextDispSourceConfig *TEXTDISP_SourceConfigEntryTable[];

void TEXTDISP_ApplySourceConfigToEntry(struct TextDispConfigEntry *e)
{
    long i;

    if (e == 0)
        return;

    e->flags40 &= ~TEXTDISP_SourceConfigFlagMask;

    for (i = 0; i < TEXTDISP_SourceConfigEntryCount; i++) {
        if (STRING_CompareNoCaseN(TEXTDISP_SourceConfigEntryTable[i]->name,
                                  e->name12,
                                  (long)strlen(TEXTDISP_SourceConfigEntryTable[i]->name))
            == 0)
            e->flags40 |= TEXTDISP_SourceConfigEntryTable[i]->bits;
    }
}
