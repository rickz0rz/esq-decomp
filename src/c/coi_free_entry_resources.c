/* RESTORES: COI_FreeEntryResources
 * MODULE:   modules/groups/a/e/coi.s
 * STATUS:   behavioural
 *
 * The reference extract is 62 bytes and stops early: the epilogue is branched
 * to from the null test at the top, so the disassembly gives it its own label
 * (COI_FreeEntryResources_Return) and refbytes stops there. The epilogue is
 * MOVEM.L (A7)+,A2-A3 / RTS, 6 bytes, so the real function is 68. A C
 * restoration always carries its own epilogue; add the 6 back before judging
 * any delta against this one.
 *
 * With the epilogue added back it is 68 against 68, in TWO regions, and
 * neither costs a byte.
 *
 * The offset 48 is read straight off the reference (MOVEA.L 48(A3),A2) and
 * matches the CoiEntry model already used by coi_alloc_sub_entry_table.c and
 * coi_ensure_anim_object_allocated.c.
 *
 * SASC-MISMATCH: callee-saved-address-register
 *   ref:     266f000c 246b0030 2f0b ... 42ab0030    entry in A3, anim in A2
 *   got:     2a6f000c 266d0030 2f0d ... 42ad0030    entry in A5, anim in A3
 *   summary: same instructions, same sizes, the whole allocation shifted one
 *            register. No locals means no LINK, so A5 is free and SAS/C 6.51
 *            takes it first. The original took A3.
 *   scope:   program-wide, every LINK-less function that caches a pointer.
 *   retest:  a compiler that allocates A3 before A5 matches.
 *
 * SASC-MISMATCH: cross-unit-call-opcode
 *   ref:     4eba37b0      JSR (d16,PC)
 *   got:     61000000      BSR.W
 *   summary: same size, same semantics, different opcode, on the one call the
 *            original made across a translation unit. SAS/C 6.51 emits BSR.W
 *            for every call. The other two calls are BSR.W in both.
 *   scope:   the whole cross-unit bucket, and none of it is exact.
 *   retest:  a compiler that picks the opcode from the callee's translation
 *            unit matches.
 */
struct CoiEntry {
    char  pad[48];
    void *anim;    /* 48 */
};


extern void COI_FreeSubEntryTableEntries(struct CoiEntry *entry);
extern void COI_ClearAnimObjectStrings(struct CoiEntry *entry);
extern void MEMORY_DeallocateMemory(char *who, long line,
                                                    void *p, long size);

void COI_FreeEntryResources(struct CoiEntry *entry)
{
    void *anim;

    if (entry == 0)
        return;

    anim = entry->anim;
    COI_FreeSubEntryTableEntries(entry);
    COI_ClearAnimObjectStrings(entry);
    if (anim)
        MEMORY_DeallocateMemory("COI.c", 815L,
                                                anim, 42L);
    entry->anim = 0;
}
