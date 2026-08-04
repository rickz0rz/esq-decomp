/* RESTORES: P_TYPE_AllocateEntry
 * MODULE:   modules/groups/b/a/p_type.s
 * STATUS:   behavioural
 *
 * Allocates a promo-type entry: a ten-byte header carrying a kind byte and a
 * length, plus a separately allocated payload the caller's bytes are copied into.
 * Every failure path returns null with nothing leaked -- if the payload allocation
 * fails the header is freed again before returning.
 *
 * The payload is allocated only when strlen(src) equals the requested length, so a
 * string shorter than the count is rejected rather than read past its terminator.
 * That test is also what makes the copy loop safe: it runs `len` bytes with no
 * terminator check of its own.
 *
 * 216 bytes in the original, 188 emitted (186 plus one alignment NOP). The -28 is
 * itemised exactly by `tools/casm.py src/c/p_type_allocate_entry.c
 * P_TYPE_AllocateEntry`, which aligns the two instruction streams and sums each
 * hunk; nothing is unattributed. This is the largest frame-class saving measured
 * so far, because the entry pointer is live across the whole function.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fff8 ... 4e5d       LINK.W A5,#-8 / UNLK A5
 *   got:     (neither)               no frame at all
 *   summary: The A5-frame class. -6 on its own.
 *   scope:   program-wide; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: entry-pointer-in-frame
 *   ref:     42adfffc / 2b40fffc / 206dfffc x2 / 226dfffc / 2f2dfffc / 2b48fffc
 *            / 202dfffc                  eight accesses to the -4(A5) slot
 *   got:     97cb / 2640 / 2f0b / 200b    the same pointer held in A3 throughout
 *   summary: A consequence of the frame class. Every use of the entry pointer in
 *            the original goes through the frame; with A5 free, 6.51 keeps it in
 *            an address register and folds the struct stores into (d16,A3). The
 *            eight sites give -2, -6, -8, -2, -4, -4 and -8 across the two exit
 *            paths, which is the bulk of the -28.
 *   retest:  a compiler that reserves A5 should put it back in the slot.
 *
 * SASC-MISMATCH: return-through-frame-slot
 *   ref:     6f0000b0 / 6700008a        both early exits branch to the common
 *                                       MOVE.L -4(A5),D0 tail
 *   got:     6e06 200b 6000009a         each exit materialises A3 into D0 first
 *   summary: The mirror image of the entry above: holding the value in a register
 *            makes the shared return tail cost more, not less. +4 at each of the
 *            two early exits, which is why the total is -28 and not -36.
 *
 * SASC-MISMATCH: byte-copy-fusion
 *   ref:     10335800 1080              MOVE.B (A3,D5.L),D0 / MOVE.B D0,(A0)
 *   got:     10b55800                   MOVE.B (A5,D5.L),(A0)
 *   summary: The original routes the copied byte through D0; 6.51 emits the
 *            memory-to-memory form. -2, once.
 *
 * SASC-MISMATCH: block-ordering
 *   summary: The original branches forward to the deallocate-and-fail block and
 *            places it after the copy loop; 6.51 emits it inline and branches
 *            around. Same instructions, different order -- casm.py reports this as
 *            a +28/-36 pair whose net is the frame-slot saving above, not a real
 *            size difference.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the three cross-unit calls.
 */
#include <string.h>

extern char *MEMORY_AllocateMemory(char *who, long line, long size,
                                                 long flags);
extern void MEMORY_DeallocateMemory(char *who, long line, void *p,
                                                  long size);

extern char Global_STR_P_TYPE_C_1[];
extern char Global_STR_P_TYPE_C_2[];
extern char Global_STR_P_TYPE_C_3[];

struct PromoEntry {
    char  kind;         /* 0 */
    long  length;       /* 2 */
    char *payload;      /* 6 */
};                      /* 10 */

struct PromoEntry *P_TYPE_AllocateEntry(char kind, long length, char *src)
{
    struct PromoEntry *entry;
    long i;

    entry = 0;
    if (length <= 0)
        return entry;

    entry = (struct PromoEntry *)
            MEMORY_AllocateMemory(Global_STR_P_TYPE_C_1, 47L, 10L,
                                                0x00010001L);
    if (entry == 0)
        return entry;

    entry->kind = kind;
    entry->length = length;

    if (strlen(src) == length)
        entry->payload = MEMORY_AllocateMemory(Global_STR_P_TYPE_C_2,
                                                             58L, length,
                                                             0x00010001L);
    else
        entry->payload = 0;

    if (entry->payload == 0) {
        MEMORY_DeallocateMemory(Global_STR_P_TYPE_C_3, 77L, entry, 10L);
        entry = 0;
    } else {
        for (i = 0; i < length; i++)
            entry->payload[i] = src[i];
    }

    return entry;
}
