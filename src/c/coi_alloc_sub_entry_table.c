/* RESTORES: COI_AllocSubEntryTable
 * MODULE:   modules/groups/a/e/coi.s
 * STATUS:   behavioural
 *
 * Allocates the sub-entry pointer table for an entry's AnimOb and hands it to
 * SCRIPT_AllocateBufferArray to fill with 30-byte buffers, one per sub-entry.
 *
 * A null entry yields a null AnimOb rather than an early return, so the null test
 * that follows covers both cases -- which is why the source computes the pointer
 * through a conditional and tests it afterwards.
 *
 * 100 bytes in the original, 94 emitted plus one alignment NOP. All of the -6 is
 * the frame class: the AnimOb pointer lives at -4(A5) in the original and in a
 * register here, and the argument pop moves into the epilogue.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fffc 2f0b / 2b48fffc / 206dfffc / 4e5d
 *   got:     no frame, the pointer in a register throughout
 *   summary: -2, -4 and -4, against +2 and +2 for the moved pop and the NOP.
 *   scope:   program-wide; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the two cross-unit calls.
 */

extern void *MEMORY_AllocateMemory(char *who, long line, long size,
                                                   long flags);
extern void SCRIPT_AllocateBufferArray(void *table, long size,
                                                       long count);

extern char Global_STR_COI_C_5[];

struct CoiAnimOb {
    char   pad[36];
    short  subEntryCount;   /* 36 */
    void  *subEntryTable;   /* 38 */
};

struct CoiEntry {
    char pad[48];
    struct CoiAnimOb *anim; /* 48 */
};

void COI_AllocSubEntryTable(struct CoiEntry *entry)
{
    struct CoiAnimOb *anim;

    if (entry)
        anim = entry->anim;
    else
        anim = 0;

    if (anim == 0)
        return;
    if (anim->subEntryCount <= 0)
        return;

    anim->subEntryTable =
        MEMORY_AllocateMemory(Global_STR_COI_C_5, 1123L,
                                              (long)anim->subEntryCount * 4,
                                              0x00010001L);
    SCRIPT_AllocateBufferArray(anim->subEntryTable, 30L,
                                               (long)anim->subEntryCount);
}
