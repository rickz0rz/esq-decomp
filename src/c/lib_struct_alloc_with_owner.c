/* RESTORES: STRUCT_AllocWithOwner, STRUCT_FreeWithSizeField
 * MODULE:   modules/submodules/unknown25.s
 * STATUS:   behavioural
 *
 * SAS/C library code: an allocator that records its own size and owner inside the
 * block, so the matching free needs only the pointer.
 *
 * THE SIZE IS STORED AS A WORD AT +18 AND READ BACK FROM THERE. That is the whole
 * point of the pair, and it caps a block at 65535 bytes: `MOVE.W D0,18(A2)`
 * truncates silently, and the free then passes the truncated value to FreeMem.
 * Allocating 65536 bytes through this would free zero and leak the lot. The
 * original has no guard and none is added -- adding one would change behaviour
 * the program may depend on.
 *
 * THE SIZE IS READ BACK ZERO-EXTENDED (`MOVEQ #0,D0 / MOVE.W 18(A3),D0`), so it
 * is an unsigned word.
 *
 * A NULL OWNER IS REJECTED BEFORE ANY ALLOCATION. The owner is not optional
 * metadata; the function returns 0 without calling AllocMem.
 *
 * THE FREE PATH POISONS THE BLOCK BEFORE RELEASING IT: type byte to 0xFF, and
 * both longs at +20 and +24 to 0xFFFFFFFF. `MOVEA.W #$ffff,A0` sign-extends to a
 * full -1, which is why one instruction serves both stores. This is a
 * use-after-free tripwire and it is reproduced.
 *
 * MEMF_CLEAR IS SET, so every field the allocator does not write is zero. The
 * explicit `CLR.B 9(A2)` after it is therefore redundant in the original too, and
 * is kept.
 *
 * SASC-MISMATCH: reload-vs-cache
 *   ref:     MOVEA.L AbsExecBase,A6 once per function
 *   got:     a reload before the call, because esq-exec.h declares the base
 *            volatile
 *   summary: the extra load costs 6 bytes. It is what makes every other exec
 *            call in this program safe -- see esq-libbase.md.
 *   scope:   program-wide.
 *   retest:  not a compiler question; it is the header contract.
 */
#include "esq-exec.h"
#include <exec/memory.h>

#ifndef ESQ_OWNEDBLOCK_DEFINED
#define ESQ_OWNEDBLOCK_DEFINED
/* Offsets taken from the instructions, not from a struct definition: the
 * original writes 8, 9, 14 and 18 and reads 18, 20 and 24. */
struct OwnedBlock {
    char           pad0[8];     /* +0  */
    unsigned char  type;        /* +8  */
    unsigned char  pri;         /* +9  */
    char           pad10[4];    /* +10 */
    void          *owner;       /* +14 */
    unsigned short size;        /* +18 */
    long           poison20;    /* +20 */
    long           poison24;    /* +24 */
};
#endif

void *STRUCT_AllocWithOwner(void *owner, long size)
{
    struct OwnedBlock *p;

    if (owner == 0)
        return 0;

    p = (struct OwnedBlock *)AllocMem((ULONG)size, MEMF_PUBLIC | MEMF_CLEAR);
    if (p != 0) {
        p->type = 5;
        p->pri = 0;                     /* redundant under MEMF_CLEAR, as in the original */
        p->owner = owner;
        p->size = (unsigned short)size; /* truncates above 65535 -- see the header */
    }

    return p;
}

void STRUCT_FreeWithSizeField(void *block)
{
    struct OwnedBlock *p = (struct OwnedBlock *)block;

    p->type = 0xff;
    p->poison20 = -1;
    p->poison24 = -1;

    FreeMem((APTR)p, (ULONG)p->size);
}
