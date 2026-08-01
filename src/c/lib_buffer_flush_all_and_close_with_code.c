/* RESTORES: BUFFER_FlushAllAndCloseWithCode
 * MODULE:   modules/submodules/unknown16.s
 * STATUS:   behavioural
 *
 * SAS/C library code: the exit path. It walks the stream-node list, writes out
 * every buffer that still holds unflushed data, then closes every handle and
 * leaves the program with the code it was given. It does not return.
 *
 * A NODE IS FLUSHED ONLY IF ALL THREE HOLD, and the order of the tests is the
 * order of the branches:
 *
 *   the Unbuffered bit (2) is CLEAR   -- an unbuffered stream has nothing staged
 *   the WritePending bit (1) is SET   -- it was written to, not just read
 *   cursor != base                    -- there is actually something in it
 *
 * Dropping the third would write a zero-length record to every write handle at
 * exit; dropping the first would flush a buffer that was never filled.
 *
 * THE LENGTH IS `cursor - base`, the fill mark, not the capacity.
 *
 * THE LIST IS WALKED FROM Global_PreallocHandleNode0, which is an ADDRESS, not a
 * value -- the original does `LEA Global_PreallocHandleNode0(A4),A3`, so node 0
 * is the head node ITSELF rather than a pointer to it. Reading it as a value and
 * chasing that would start the walk from the node's `next` field interpreted as a
 * node. `_A4_ADDR` is the accessor that says so.
 *
 * A FAILED WRITE IS IGNORED. The result of DOS_WriteByIndex is discarded, so a
 * full disk at exit loses the tail of the file silently. That is the original's
 * behaviour and nothing here changes it.
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
    long  openFlags;                    /* +24, low bytes aliased as mode/state */
    long  handleIndex;                  /* +28 */
    unsigned char inlineByte;           /* +32 */
    unsigned char pad33;                /* +33 */
};
#endif

extern long DOS_WriteByIndex(long index, char *buf, long len);
extern void HANDLE_CloseAllAndReturnWithCode(long code);

void BUFFER_FlushAllAndCloseWithCode(long code)
{
    struct PreallocHandleNode *node =
        (struct PreallocHandleNode *)Global_PreallocHandleNode0_A4_ADDR;

    while (node != 0) {
        if (!(node->openFlags & 4) && (node->openFlags & 2)) {
            long len = (long)(node->bufferCursor - node->bufferBase);
            if (len != 0)
                DOS_WriteByIndex(node->handleIndex, node->bufferBase, len);
        }
        node = node->next;
    }

    HANDLE_CloseAllAndReturnWithCode(code);
}
