/* RESTORES: BUFFER_EnsureAllocated
 * MODULE:   modules/submodules/unknown31.s
 * STATUS:   behavioural
 *
 * SAS/C library code. Gives a stream node its I/O buffer, unless it already has
 * one. Returns 0 on success and -1 if the allocation failed.
 *
 * IT REALLOCATES WHEN BIT 3 OF THE STATE FLAGS IS SET even though a buffer is
 * already present. src/Prevue.asm names that bit
 * `OpenFlagsLowBit3_ForceRealloc_Bit` and comments that it is reserved and dead
 * in the stock image -- no producer sets it. The test is reproduced anyway,
 * because "no producer today" is not the same as "cannot happen", and dropping
 * it would silently change a path that a future INI or command could reach.
 *
 * THE OLD BUFFER IS NOT FREED on that path. The original overwrites BufferBase
 * with the new allocation and leaks the old one. That is the original's
 * behaviour and is left alone.
 *
 * BOTH CURSOR AND BASE ARE SET FROM THE SAME ALLOCATION, in that order, BEFORE
 * the null test -- so a failed allocation leaves both fields zero rather than
 * stale.
 *
 * THE FLAG CLEAR IS `AND #-13`, which is ~0x0C: it clears bits 2 and 3 of the
 * OpenFlags longword, the Unbuffered and ForceRealloc bits. It is written as the
 * mask rather than as two bit clears because that is one instruction in the
 * original and because ~0x0C says what it does.
 *
 * SASC-MISMATCH: near-data-addressing
 *   ref:     MOVE.L Global_StreamBufferAllocSize(A4),-(A7)
 *   got:     an absolute read through the enclosing array
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
    long  openFlags;                    /* +24, low bytes aliased as mode/state */
    long  handleIndex;                  /* +28 */
    unsigned char inlineByte;           /* +32 */
    unsigned char pad33;                /* +33 */
};
#endif

extern void *ALLOC_AllocFromFreeList(long size);

long BUFFER_EnsureAllocated(struct PreallocHandleNode *node)
{
    long size;

    if (node->bufferCapacity != 0 && !(node->openFlags & 8))
        return 0;

    size = Global_StreamBufferAllocSize_A4;
    node->bufferCursor = (char *)ALLOC_AllocFromFreeList(size);
    node->bufferBase = node->bufferCursor;

    if (node->bufferBase == 0) {
        Global_AppErrorCode_A4 = 12;
        return -1;
    }

    node->bufferCapacity = size;
    node->openFlags &= ~0x0CL;          /* clear Unbuffered and ForceRealloc */
    node->writeRemaining = 0;
    node->readRemaining = 0;

    return 0;
}
