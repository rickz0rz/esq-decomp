/* RESTORES: _ALLOC_AllocFromFreeList
 * MODULE:   modules/submodules/unknown12.s
 * STATUS:   behavioural
 *
 * SAS/C library code: the small-block allocator behind the stream layer. It
 * walks a free list looking for a block big enough, splitting one if the
 * remainder is worth keeping, and asks the tracked allocator for a fresh slab
 * when nothing fits.
 *
 * THE CURSOR IS A POINTER TO THE LINK SLOT, NOT TO THE NODE. A2 starts as
 * `LEA Global_AllocListHead(A4),A2` -- the ADDRESS of the head variable -- and
 * the advance is `MOVEA.L A3,A2`, which makes it the node itself, whose first
 * field is `next`. So `*A2` is always the slot that points at the current node,
 * and unlinking is one store whether the node is first or not. `struct FreeNode
 * **prev` is that, and writing the walk with a `prev` NODE pointer instead needs
 * a special case for the head that the original does not have.
 *
 * A NODE IS `next` THEN `size`, both longs, in the block's own first eight bytes.
 * That is why the minimum request is 8: a block smaller than a node cannot be
 * put back on the list.
 *
 * THE SIZE COMPARE IS SIGNED AND THE SPLIT REMAINDER TEST IS UNSIGNED. `BLT`
 * against the node size, `BCS` against 8. Both are reproduced; swapping either
 * changes which blocks are considered usable.
 *
 * A SPLIT LEAVES THE TAIL ON THE LIST AND RETURNS THE HEAD. The new node is
 * placed at `node + size`, inherits `node->next`, and takes the remainder as its
 * size. A remainder under 8 is refused and the whole node is skipped rather than
 * handed over -- so the allocator never returns more than was asked for, and
 * never creates a fragment too small to be a node.
 *
 * `ANDI.W #$fffc` IS A WORD OPERATION ON A LONG REGISTER and it is still exactly
 * `& ~3`. It clears bits 0 and 1 and leaves bits 16..31 alone, which is what
 * rounding down to a longword means. There is no size at which the word width
 * matters.
 *
 * THE SLAB PATH ROUNDS UP TO A WHOLE NUMBER OF BLOCKS, adds 8 for the node
 * header, rounds that to a longword, and then RECURSES rather than carving the
 * slab directly. So a failure to insert would loop; the original accepts that.
 *
 * SASC-MISMATCH: division-helper
 *   ref:     JSR _MATH_DivS32(PC) then JSR _MATH_Mulu32(PC)
 *   got:     `/` and `*`, which 6.51 routes through its own __CXD33 / __CXM33
 *   summary: the original calls the program's own arithmetic helpers, which are
 *            the SAME code -- __CXD33 and _MATH_DivS32 are two labels on one
 *            address in modules/submodules/unknown22.s. Same arithmetic, reached
 *            by the compiler's name instead of the program's.
 *   scope:   every long divide in a restoration.
 *   retest:  not a compiler question; the two names are the same function.
 *
 * SASC-MISMATCH: near-data-addressing
 *   ref:     LEA Global_AllocListHead(A4),A2
 *   got:     an absolute address through the enclosing array
 *   scope:   every A4 reference in modules/submodules/.
 *   retest:  a build using SAS/C near data.
 */
#include "esq-neardata.h"

struct FreeNode {
    struct FreeNode *next;      /* +0 */
    long             size;      /* +4 */
};

extern void *MEMLIST_AllocTracked(long size);
extern void  ALLOC_InsertFreeBlock(void *block, long size);

void *ALLOC_AllocFromFreeList(long size)
{
    struct FreeNode **prev;
    struct FreeNode *node;

    if (size <= 0)
        return 0;

    if ((unsigned long)size < 8)
        size = 8;
    size = (size + 3) & ~3L;

    prev = (struct FreeNode **)Global_AllocListHead_A4_ADDR;
    node = *prev;

    while (node != 0) {
        if (node->size >= size) {               /* BLT: signed */
            if (node->size == size) {
                *prev = node->next;             /* exact fit: unlink */
                Global_AllocBytesTotal_A4 -= size;
                return node;
            }
            {
                long rem = node->size - size;

                if ((unsigned long)rem >= 8) {  /* BCS: unsigned */
                    struct FreeNode *tail =
                        (struct FreeNode *)((char *)node + size);

                    *prev = tail;
                    tail->next = node->next;
                    tail->size = rem;
                    Global_AllocBytesTotal_A4 -= size;
                    return node;
                }
            }
        }
        prev = &node->next;                     /* the LINK SLOT, not the node */
        node = node->next;
    }

    {
        long block = Global_AllocBlockSize_A4;
        long want  = (size + block - 1) / block * block;

        want += 8;
        want = (want + 3) & ~3L;

        {
            void *slab = MEMLIST_AllocTracked(want);

            if (slab == 0)
                return 0;

            ALLOC_InsertFreeBlock(slab, want);
            return ALLOC_AllocFromFreeList(size);
        }
    }
}
