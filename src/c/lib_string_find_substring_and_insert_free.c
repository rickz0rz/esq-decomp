/* RESTORES: STRING_FindSubstring, _ALLOC_InsertFreeBlock
 * MODULE:   modules/submodules/unknown33.s
 * STATUS:   behavioural
 *
 * SAS/C library code: strstr, and the coalescing insert that pairs with
 * ALLOC_AllocFromFreeList.
 *
 * STRING_FindSubstring GIVES UP EARLY WHEN THE HAYSTACK RUNS OUT MID-COMPARE.
 * The restart checks the position the comparison REACHED, not the position it
 * started from -- `CMPI.B #0,(A2)` where A2 walked forward -- so a partial match
 * that hits the end of the haystack fails immediately instead of rescanning. An
 * empty needle matches at once, because the terminator is tested before the
 * first character.
 *
 * ALLOC_InsertFreeBlock KEEPS THE LIST SORTED BY ADDRESS AND COALESCES BOTH WAYS.
 * It walks to the first node at or above the end of the incoming block, then
 * takes one of four paths:
 *
 *   node > end            insert before it, no merge
 *   node == end           merge FORWARD: the new block absorbs that node
 *   block == node's end   merge BACKWARD into that node, and if the node after
 *                         it starts exactly at `end`, absorb that one too
 *   otherwise             keep walking
 *
 * The three-way merge is what stops the list fragmenting: freeing a run of
 * adjacent blocks in any order ends with one node.
 *
 * IT DETECTS OVERLAP AND REFUSES, RETURNING -1. Two cases: the incoming block
 * starting below the current node's end, and the block after a backward merge
 * reaching past its successor. Both UNDO the byte count that was added on entry
 * -- `SUB.L D7,Global_AllocBytesTotal(A4)` -- so a rejected insert leaves the
 * accounting where it was. Dropping either undo makes the total drift by the
 * size of every bad free.
 *
 * THE BYTE COUNT IS ADDED BEFORE THE WALK, not after a successful insert, which
 * is why the two failure paths have to undo it.
 *
 * THE SIZE IS ROUNDED THE SAME WAY THE ALLOCATOR ROUNDS IT -- minimum 8, then up
 * to a longword. The two have to agree or a block freed at one size would be
 * reinserted at another and the list would drift out of step with the arena.
 *
 * SASC-MISMATCH: near-data-addressing
 *   ref:     LEA Global_AllocListHead(A4),A0
 *   got:     an absolute address through the enclosing array
 *   scope:   every A4 reference in modules/submodules/.
 *   retest:  a build using SAS/C near data.
 */
#include "esq-neardata.h"

struct FreeNode {
    struct FreeNode *next;      /* +0 */
    long             size;      /* +4 */
};

char *STRING_FindSubstring(char *hay, char *needle)
{
    for (;;) {
        char *h = hay;
        char *n = needle;

        while (*n != 0) {
            if (*h++ != *n++)
                break;
        }
        if (*n == 0)
            return hay;                 /* the needle ran out: matched */

        /* The restart tests where the comparison REACHED, not where it began. */
        if (*h == 0)
            return 0;
        hay++;
        if (*hay == 0)
            return 0;
    }
}

long ALLOC_InsertFreeBlock(void *block, long size)
{
    struct FreeNode *nb = (struct FreeNode *)block;
    struct FreeNode **prev;
    struct FreeNode *node;
    char *end;

    if (size <= 0)
        return -1;

    if ((unsigned long)size < 8)
        size = 8;
    size = (size + 3) & ~3L;

    end = (char *)block + size;
    Global_AllocBytesTotal_A4 += size;      /* added BEFORE the walk */

    prev = (struct FreeNode **)Global_AllocListHead_A4_ADDR;
    node = *prev;

    while (node != 0) {
        char *nodeEnd = (char *)node + node->size;

        if ((char *)node > end) {           /* insert before, no merge */
            nb->next = node;
            nb->size = size;
            *prev = nb;
            return 0;
        }

        if ((char *)node == end) {          /* merge FORWARD */
            nb->next = node->next;
            nb->size = node->size + size;
            *prev = nb;
            return 0;
        }

        if ((char *)block < nodeEnd) {      /* overlaps this node */
            Global_AllocBytesTotal_A4 -= size;
            return -1;
        }

        if ((char *)block == nodeEnd) {     /* merge BACKWARD */
            if (node->next != 0 && (char *)node->next < end) {
                Global_AllocBytesTotal_A4 -= size;
                return -1;                  /* would overlap the successor */
            }
            node->size += size;
            if (node->next != 0 && (char *)node->next == end) {
                struct FreeNode *after = node->next;
                node->size += after->size;  /* absorb the successor too */
                node->next = after->next;
            }
            return 0;
        }

        prev = &node->next;
        node = node->next;
    }

    *prev = nb;                             /* append at the tail */
    nb->next = 0;
    nb->size = size;
    return 0;
}
