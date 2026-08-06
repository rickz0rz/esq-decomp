/* RESTORES: COI_EnsureAnimObjectAllocated
 * MODULE:   modules/groups/a/e/coi.s
 * STATUS:   behavioural
 *
 * Attaches an AnimOb to an entry if it has none, seeded with the default token
 * template and a -1 sentinel. Idempotent: an entry that already has one is left
 * alone, which is why the caller can invoke it freely.
 *
 * Nothing checks the allocation, and the very next thing the code does is read
 * 28(A0) through the returned pointer. That is the original's behaviour.
 *
 * 100 bytes in the original, 100 emitted. Itemises to zero: -2 and -4 of frame
 * class against +6 for the argument pop moving into the epilogue.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fff8 2f0b / 2b48fffc / 4e5d
 *   got:     594f 48e70014, the pointer in a register
 *   summary: The A5-frame class, and note the stack slot is still allocated in
 *            both -- only what lives in it differs.
 *   scope:   program-wide; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: argument-pop-position
 *   summary: The original pops after the second call; 6.51 folds it into the
 *            epilogue. -4 then +6.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the two cross-unit calls.
 */

extern void *MEMORY_AllocateMemory(char *who, long line, long size,
                                                   long flags);
extern char *ESQPARS_ReplaceOwnedString(char *newText, char *old);

extern char COI_STR_DEFAULT_TOKEN_TEMPLATE_B[];

struct CoiAnimOb {
    char  pad[28];
    char *tokenTemplate;    /* 28 */
    long  sentinel;         /* 32 */
};

struct CoiEntry {
    char pad[48];
    struct CoiAnimOb *anim; /* 48 */
};

void COI_EnsureAnimObjectAllocated(struct CoiEntry *entry)
{
    struct CoiAnimOb *anim;

    if (entry == 0)
        return;

    anim = entry->anim;
    if (anim)
        return;

    entry->anim = (struct CoiAnimOb *)
        MEMORY_AllocateMemory("COI.c", 1458L, 42L,
                                              0x00010001L);
    entry->anim->tokenTemplate =
        ESQPARS_ReplaceOwnedString(COI_STR_DEFAULT_TOKEN_TEMPLATE_B,
                                                   entry->anim->tokenTemplate);
    entry->anim->sentinel = -1;
}
