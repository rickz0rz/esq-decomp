/* RESTORES: _MEMLIST_AllocTracked, MEMLIST_FreeAll,
 *           PARSE_ReadSignedLongSkipClass3, _PARSE_ReadSignedLongSkipClass3_Alt
 * MODULE:   modules/submodules/unknown24.s
 * STATUS:   behavioural
 *
 * SAS/C library code: the tracked-allocation list that backs the arena, and two
 * whitespace-skipping wrappers on the integer parser.
 *
 * THE NODE IS next, prev, size, THEN THE DATA at +12, and the caller is handed
 * `node + 12`. The size STORED is the size ALLOCATED -- header included -- which
 * is what MEMLIST_FreeAll passes back to FreeMem, so the two agree without
 * either having to remember the header size.
 *
 * IT ALLOCATES WITH REQUIREMENTS ZERO, NOT MEMF_CLEAR. The returned block is not
 * zeroed. That is why HANDLE_OpenWithMode clears 34 bytes by hand after taking a
 * node from ALLOC_AllocFromFreeList, which is fed from here.
 *
 * THE HEAD AND TAIL ARE ADJACENT AND THE ORIGINAL RELIES ON IT. It takes the
 * address of Global_MemListHead into A2 and reaches the tail as `4(A2)`.
 * Resolving the two A4 displacements confirms it -- 22836 and 22840, exactly four
 * apart. The C names them separately, which is the same two addresses; the
 * adjacency is an addressing convenience in the assembly, not a layout
 * requirement the C has to preserve.
 *
 * THE LINKING IS DELIBERATELY ORDERED so an empty list and a non-empty one share
 * one path: prev is set from the old tail before anything is written, the head is
 * only filled if it was null, and the old tail's `next` is only written if there
 * was one. Reordering these merges the two cases wrongly.
 *
 * Global_MemListFirstAllocNode REMEMBERS THE VERY FIRST ALLOCATION EVER and is
 * never cleared -- not even by MEMLIST_FreeAll, which zeroes only the head and
 * the tail. So after a free-all it points at released memory. That is the
 * original's behaviour; nothing here reads it back.
 *
 * THE TWO PARSE WRAPPERS DIFFER ONLY IN WHICH PARSER THEY CALL --
 * PARSE_ReadSignedLong against PARSE_ReadSignedLong_NoBranch. Both skip
 * class-3 characters first, both return zero for a null input, and both take the
 * result through an out-parameter rather than the callee's return value.
 *
 * SASC-MISMATCH: near-data-addressing
 *   ref:     LEA Global_MemListHead(A4),A2 and 4(A2) for the tail
 *   got:     two absolute references through the enclosing array
 *   scope:   every A4 reference in modules/submodules/.
 *   retest:  a build using SAS/C near data.
 */
#include "esq-exec.h"
#include "esq-neardata.h"

struct MemNode {
    struct MemNode *next;       /* +0  */
    struct MemNode *prev;       /* +4  */
    long            size;       /* +8, the size ALLOCATED, header included */
};                              /* the caller's data starts at +12 */

extern char *STR_SkipClass3Chars(char *s);
extern long  PARSE_ReadSignedLong(char *s, long *out);
extern long  PARSE_ReadSignedLong_NoBranch(char *s, long *out);

void *MEMLIST_AllocTracked(long size)
{
    struct MemNode *node;

    size += 12;

    node = (struct MemNode *)AllocMem((ULONG)size, 0L);   /* NOT MEMF_CLEAR */
    if (node == 0)
        return 0;

    node->size = size;
    node->prev = (struct MemNode *)Global_MemListTail_A4;
    node->next = 0;

    if (Global_MemListHead_A4 == 0)
        Global_MemListHead_A4 = (long)node;

    if (Global_MemListTail_A4 != 0)
        ((struct MemNode *)Global_MemListTail_A4)->next = node;

    Global_MemListTail_A4 = (long)node;

    if (Global_MemListFirstAllocNode_A4 == 0)
        Global_MemListFirstAllocNode_A4 = (long)node;

    return (char *)node + 12;
}

void MEMLIST_FreeAll(void)
{
    struct MemNode *node = (struct MemNode *)Global_MemListHead_A4;

    while (node != 0) {
        struct MemNode *next = node->next;

        FreeMem((APTR)node, (ULONG)node->size);
        node = next;
    }

    Global_MemListTail_A4 = 0;
    Global_MemListHead_A4 = 0;
    /* Global_MemListFirstAllocNode is deliberately NOT cleared -- see header. */
}

long PARSE_ReadSignedLongSkipClass3(char *s)
{
    long value;

    if (s == 0)
        return 0;

    PARSE_ReadSignedLong(STR_SkipClass3Chars(s), &value);
    return value;
}

long PARSE_ReadSignedLongSkipClass3_Alt(char *s)
{
    long value;

    if (s == 0)
        return 0;

    PARSE_ReadSignedLong_NoBranch(STR_SkipClass3Chars(s), &value);
    return value;
}
