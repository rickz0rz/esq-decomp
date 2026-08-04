/* RESTORES: DST_AllocateBannerStruct
 * MODULE:   modules/groups/a/j/dst_p1.s
 * STATUS:   behavioural
 *
 * Frees whatever banner record the caller passes, allocates a fresh 18-byte
 * record with two 22-byte date buffers, and frees the lot again if any of the
 * three allocations fails.
 *
 * The three sizes and three source-line numbers (798, 803, 807) match
 * dst_free_banner_struct.c exactly, which is the cross-check that the record
 * layout is right: 18 bytes holding two pointers, and 22 bytes each for the
 * buffers.
 *
 * The parameter is REUSED as the result. The original loads the caller's
 * pointer into A3, frees through it, and then overwrites A3 with the new
 * allocation -- so the same variable carries both, and the failure path frees
 * the NEW record rather than the old one.
 *
 * The word at +16 is cleared only on FULL success: the three failure branches
 * all jump past the CLR.W to the success test.
 *
 * The first free reuses its own argument slot for the following allocation
 * (MOVE.L #flags,(A7) rather than a fresh push).
 * 146 ref vs 144 got. All three MEMF words, all three sizes (18, 22, 22), all
 * three line numbers (798, 803, 807), all three LEA 16(A7),A7 cleanups, the
 * argument-slot reuse (2ebc), the CLR.W at +16 and both free calls match
 * exactly. The 2 bytes are the A3/A5 class -- docs/compiler-version.md, "The
 * A3/A5 divergence has a single root cause".
 */
#include <exec/memory.h>

struct DstBanner {
    char *first;                /* +0  */
    char *second;               /* +4  */
    char  pad8[8];
    short f16;                  /* +16, record is 18 bytes */
};

extern void  DST_FreeBannerStruct(struct DstBanner *b);
extern void *MEMORY_AllocateMemory(char *who, long line,
                                                   long size, long flags);
extern char Global_STR_DST_C_4[];
extern char Global_STR_DST_C_5[];
extern char Global_STR_DST_C_6[];

void *DST_AllocateBannerStruct(struct DstBanner *b)
{
    long ok = 0;

    DST_FreeBannerStruct(b);

    b = (struct DstBanner *)MEMORY_AllocateMemory(
        Global_STR_DST_C_4, 798L, 18L, MEMF_PUBLIC | MEMF_CLEAR);

    if (b != 0) {
        b->first = (char *)MEMORY_AllocateMemory(
            Global_STR_DST_C_5, 803L, 22L, MEMF_PUBLIC | MEMF_CLEAR);

        if (b->first != 0) {
            b->second = (char *)MEMORY_AllocateMemory(
                Global_STR_DST_C_6, 807L, 22L, MEMF_PUBLIC | MEMF_CLEAR);

            if (b->second != 0) {
                ok = 1;
                b->f16 = 0;
            }
        }
    }

    if (!ok)
        DST_FreeBannerStruct(b);

    return b;
}
