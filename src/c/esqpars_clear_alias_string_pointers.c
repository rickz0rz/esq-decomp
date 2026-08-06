/* RESTORES: ESQPARS_ClearAliasStringPointers
 * MODULE:   modules/groups/a/o/esqpars.s
 * STATUS:   behavioural
 *
 * Releases both owned strings of every alias record, frees the record, and
 * clears its table slot.
 *
 * THE TABLE SLOT IS CLEARED ONLY FOR A NON-NULL ENTRY. The null test branches
 * PAST the CLR.L, not to it -- the BEQ at 0x16E7E lands on the ADDQ.W that
 * bumps the counter. A restoration that clears unconditionally would be
 * writing to slots the original leaves alone; here it makes no observable
 * difference because the slot is already null, but the shape is the record.
 *
 * ReplaceOwnedString takes the NEW string first and the old second; both calls
 * pass a literal 0, so this is the release direction.
 *
 * The record is 8 bytes -- two pointers -- which is what the free is told.
 *
 * The alias count is a word compared with CMP.W, so it and the counter are
 * signed shorts, while the table index is EXT.L-widened before scaling.
 *
 * 124 ref vs 112 got. Both ReplaceOwnedString calls with their CLR.L pushes,
 * the PEA 8 record size, the PEA 945 line number, the LEA 28(A7),A7 cleanup,
 * the second ASL.L #2 index recomputation and the CLR.L of the slot all match
 * exactly -- including the fact that the original RECOMPUTES the table index
 * rather than reusing the one it already has.
 *
 * SASC-MISMATCH: link-frame-and-spill
 *   ref:     4e55fff8 ... 2b49fffa ... 206dfffa (x2) ... 4e5d
 *            LINK / MOVE.L A1,-6(A5) / MOVEA.L -6(A5),A0 twice / UNLK
 *   got:     2a50 ... 2a80 2b400004
 *            the record pointer stays in A5 throughout
 *   summary: the original spills the alias record pointer to a frame slot and
 *            reloads it after each of the two calls; 6.51 keeps it in an
 *            address register. The frame plus the store and two reloads is the
 *            12 bytes.
 *   scope:   program-wide. docs/compiler-version.md, "The same property, seen
 *            from the local-variable side".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: widen-before-vs-after-copy
 *   ref:     2007 48c0 e580     MOVE.L D7,D0 / EXT.L D0 / ASL.L #2,D0
 *   got:     48c7 2007 e580     EXT.L D7 / MOVE.L D7,D0 / ASL.L #2,D0
 *   summary: same three instructions, same size, reordered. Both sites.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct EsqParsAlias {
    char *first;                /* +0 */
    char *second;               /* +4 */
};

extern char *ESQPARS_ReplaceOwnedString(char *newStr, char *old);
extern void  MEMORY_DeallocateMemory(char *who, long line,
                                                   void *p, long size);

extern short TEXTDISP_AliasCount;
extern struct EsqParsAlias *TEXTDISP_AliasPtrTable[];

void ESQPARS_ClearAliasStringPointers(void)
{
    short i;
    struct EsqParsAlias *a;

    for (i = 0; i < TEXTDISP_AliasCount; i++) {
        a = TEXTDISP_AliasPtrTable[i];
        if (a != 0) {
            a->first  = ESQPARS_ReplaceOwnedString(0, a->first);
            a->second = ESQPARS_ReplaceOwnedString(0, a->second);

            MEMORY_DeallocateMemory("ESQPARS.c", 945L,
                                                  a, 8L);
            TEXTDISP_AliasPtrTable[i] = 0;
        }
    }
}
