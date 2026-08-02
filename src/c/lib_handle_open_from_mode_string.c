/* RESTORES: _HANDLE_OpenFromModeString
 * MODULE:   modules/submodules/unknown14.s
 * STATUS:   behavioural
 *
 * SAS/C library code: the back half of fopen. It parses the mode string, opens
 * the file with the matching DOS flags, and initialises the stream node.
 *
 * A NODE THAT IS STILL OPEN IS FINALISED FIRST. `TST.L OpenFlags / BEQ` then
 * UNKNOWN36_FinalizeRequest -- so reopening a node flushes and closes whatever it
 * held rather than leaking it. HANDLE_OpenWithMode only ever passes a free node,
 * but a direct caller need not.
 *
 * THE MODE STRING IS PARSED IN AN ORDER THAT LOOKS BACKWARDS. Character ONE is
 * examined before character ZERO: 'b' or 'a' at index 1 sets the buffering
 * default and moves the cursor on, and only then is index 0 read to choose
 * read/write/append. So "rb" and "r+" are both understood, and the '+' test uses
 * whatever index the first step left.
 *
 * 'b' AT INDEX 1 SETS 0x8000 AND 'a' CLEARS THE DEFAULT TO ZERO. Those are the
 * buffering bits, not the access bits, and they are OR'd into the final flags at
 * the very end -- with a fallback: if the accumulated value is zero, 0x8000 is
 * used instead. So an explicit 'a' at index 1 still ends up buffered.
 *
 * THE '+' FLAG IS BUILT WITH SEQ/NEG, which yields 0 or 1 rather than 0 or -1.
 * It is only ever tested for zero here, so `== '+'` is faithful.
 *
 * `MOVEQ #64,D0 / ADD.L D0,D0` IS 128, NOT 64. It appears in all three arms as
 * the update-mode handle flag; reading the MOVEQ alone gives half the value.
 *
 * THE THREE ARMS SHARE A SHAPE: open with mode-specific DOS flags, return 0 if
 * the open gave -1, then pick the handle flags from the '+' state. Only the DOS
 * flags and the non-plus handle flag differ:
 *
 *     'a'  DOS 0x8102, handle 128 or 2, then OR 0x4000
 *     'r'  DOS 0x8000 or 0x8002, handle 128 or 1
 *     'w'  DOS 0x8300 or 0x8302, handle 128 or 2
 *
 * AN UNRECOGNISED FIRST CHARACTER RETURNS 0 without opening anything.
 *
 * THE BUFFER FIELDS ARE CLEARED BEFORE THE FLAGS ARE STORED, and BufferCursor is
 * copied FROM BufferBase after that has been zeroed rather than set to zero
 * directly -- the same value by a different route, and reproduced.
 *
 * SASC-MISMATCH: near-data-addressing
 *   ref:     MOVE.L Global_DefaultHandleFlags(A4),D5
 *   got:     an absolute read through the enclosing symbol
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

extern void UNKNOWN36_FinalizeRequest(struct PreallocHandleNode *node);
extern long HANDLE_OpenEntryWithFlags(char *path, long dosFlags, long slot);

struct PreallocHandleNode *HANDLE_OpenFromModeString(
        char *path, char *mode, struct PreallocHandleNode *node)
{
    long bufferDefault;
    long index;
    long plus;
    long handleFlags;
    long slot;
    long c;

    if (node->openFlags != 0)
        UNKNOWN36_FinalizeRequest(node);         /* reopen: finalise first */

    bufferDefault = Global_DefaultHandleFlags_A4;

    /* Character ONE is examined before character zero -- see the header. */
    index = 1;
    c = (unsigned char)mode[index];
    if (c == 'b') {
        bufferDefault = 0x8000;
        index++;
    } else if (c == 'a') {
        bufferDefault = 0;
        index++;
    }

    plus = (mode[index] == '+');

    c = (unsigned char)mode[0];

    if (c == 'a') {
        slot = HANDLE_OpenEntryWithFlags(path, 0x8102L, 12L);
        if (slot == -1)
            return 0;
        handleFlags = (plus ? 128L : 2L) | 0x4000L;
    } else if (c == 'r') {
        slot = HANDLE_OpenEntryWithFlags(path, (plus ? 2L : 0L) | 0x8000L, 12L);
        if (slot == -1)
            return 0;
        handleFlags = plus ? 128L : 1L;
    } else if (c == 'w') {
        slot = HANDLE_OpenEntryWithFlags(path,
                   (plus ? 2L : 1L) | 0x8000L | 0x100L | 0x200L, 12L);
        if (slot == -1)
            return 0;
        handleFlags = plus ? 128L : 2L;
    } else {
        return 0;                                /* unrecognised mode */
    }

    node->bufferBase = 0;
    node->bufferCapacity = 0;
    node->handleIndex = slot;
    node->bufferCursor = node->bufferBase;       /* copied FROM the zeroed field */
    node->writeRemaining = 0;
    node->readRemaining = 0;

    if (bufferDefault == 0)
        bufferDefault = 0x8000;                  /* the fallback -- see the header */

    node->openFlags = handleFlags | bufferDefault;

    return node;
}
