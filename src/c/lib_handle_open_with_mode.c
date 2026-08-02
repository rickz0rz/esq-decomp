/* RESTORES: HANDLE_OpenWithMode
 * MODULE:   modules/submodules/unknown35.s
 * STATUS:   behavioural
 *
 * SAS/C library code: fopen's front half. It finds a free stream node -- reusing
 * one from the preallocated chain, or extending the chain -- and hands it to
 * HANDLE_OpenFromModeString to do the actual open.
 *
 * A NODE IS FREE WHEN ITS OpenFlags ARE ZERO. The scan stops on the first such
 * node, so nodes are reused in list order and a program that opens and closes
 * repeatedly never grows the chain.
 *
 * THE HEAD IS THE NODE ITSELF, NOT A POINTER TO ONE. The original does
 * `LEA Global_PreallocHandleNode0(A4),A3`, so the walk starts AT node zero. The
 * `_A4_ADDR` accessor is what says so; reading the value would start from that
 * node's `next` field interpreted as a node. This is the distinction
 * tools/data_shape_audit.py exists to catch.
 *
 * THE NEW NODE IS LINKED TO THE LAST ONE VISITED, not to the head. The scan keeps
 * the previous node in A2 for exactly that, so the chain stays singly linked in
 * order.
 *
 * IT IS CLEARED WITH 34 BYTES, one per `DBF` iteration from 33 -- the size of the
 * struct. ALLOC_AllocFromFreeList does not zero what it returns, so without this
 * a reused block would arrive with someone else's flags set and read as an open
 * handle.
 *
 * THE RETURN VALUE IS WHATEVER HANDLE_OpenFromModeString RETURNED. The original
 * falls straight through to the epilogue after the call, so nothing here inspects
 * or normalises it.
 *
 * SASC-MISMATCH: near-data-addressing
 *   ref:     LEA Global_PreallocHandleNode0(A4),A3
 *   got:     an absolute address through the enclosing array
 *   scope:   every A4 reference in modules/submodules/.
 *   retest:  a build using SAS/C near data.
 */
#include "esq-neardata.h"

#ifndef ESQ_PREALLOCHANDLENODE_DEFINED
#define ESQ_PREALLOCHANDLENODE_DEFINED
/* src/Prevue.asm, Struct_PreallocHandleNode__*. Size 34. */
struct PreallocHandleNode {
    struct PreallocHandleNode *next;    /* +0  */
    char *bufferCursor;                 /* +4  */
    long  readRemaining;                /* +8  */
    long  writeRemaining;               /* +12 */
    char *bufferBase;                   /* +16 */
    long  bufferCapacity;               /* +20 */
    long  openFlags;                    /* +24 */
    long  handleIndex;                  /* +28 */
    unsigned char inlineByte;           /* +32 */
    unsigned char pad33;                /* +33 */
};
#endif

extern void *ALLOC_AllocFromFreeList(long size);
extern long HANDLE_OpenFromModeString(char *path, char *mode,
                                      struct PreallocHandleNode *node);

long HANDLE_OpenWithMode(char *path, char *mode)
{
    struct PreallocHandleNode *node =
        (struct PreallocHandleNode *)Global_PreallocHandleNode0_A4_ADDR;
    struct PreallocHandleNode *prev = 0;

    while (node != 0 && node->openFlags != 0) {
        prev = node;
        node = node->next;
    }

    if (node == 0) {
        node = (struct PreallocHandleNode *)ALLOC_AllocFromFreeList(34);
        if (node == 0)
            return 0;

        prev->next = node;              /* the LAST node visited, not the head */

        {
            char *p = (char *)node;
            long i;
            for (i = 0; i < 34; i++)    /* MOVEQ #33 then DBF: 34 bytes */
                p[i] = 0;
        }
    }

    return HANDLE_OpenFromModeString(path, mode, node);
}
