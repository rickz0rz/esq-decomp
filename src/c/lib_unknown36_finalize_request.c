/* RESTORES: _UNKNOWN36_FinalizeRequest
 * MODULE:   modules/submodules/unknown36_unknown36_finalizerequest.s
 * STATUS:   behavioural
 *
 * Closes a stream: flush any pending write, hand the buffer back to the free
 * list, clear the flags and close the underlying handle.
 *
 * THE MODULE WAS SPLIT FIRST, AND THE REASON MATTERS. `unknown36.s` held this
 * function, `UNKNOWN36_ShowAbortRequester`, and FIVE STRING CONSTANTS --
 * "** User Abort Requested **", "CONTINUE", "ABORT", "*** Break: " and
 * "intuition.library". Those strings live in the CODE section, where the
 * original addresses them PC-relative. Converting the whole module to C would
 * have moved every one of them into the DATA hunk, and AGENTS.md records that
 * even four bytes of DATA growth shifts every symbol after it and freezes the
 * display. `tools/split_module.py` cut this function out on the `;!======`
 * separators, which is byte-neutral -- both gates stayed green -- and left the
 * strings in assembly where they belong.
 *
 * THE FLAG FIELDS ARE ONE LONGWORD UNDER THREE NAMES. `src/Prevue.asm` gives
 * `Struct_PreallocHandleNode__OpenFlags = 24` as a longword and
 * `__StateFlags = 27` as "OpenFlags byte at +3". On a big-endian 68000 that is
 * the LOW byte of the same longword, so the original's `BTST #1,27(A3)` is
 * bit 1 of `openFlags`, which is the mask 2 -- not a separate byte field. This
 * file uses the project's existing `struct PreallocHandleNode`, which models it
 * as one `long`, and tests the mask.
 *
 * THE RETURN VALUE IS A TWO-WAY OR, and the original computes it backwards.
 * `MOVEQ #-1,D0` is loaded BEFORE the two tests, so both early exits return -1
 * and only the fall-through reaches `MOVEQ #0,D0`:
 *
 *     flush result == -1   -> -1
 *     close result != 0    -> -1
 *     otherwise            ->  0
 *
 * Reading that as "return the close result" would be wrong: the close result is
 * only ever tested, never returned.
 *
 * SASC-MISMATCH: deferred-stack-cleanup
 *   ref:     each call pushes and pops its own block with ADDQ.W
 *   got:     the same, but 6.51 chooses its own pop instruction
 *   summary: cosmetic. Recorded so the small delta is attributed.
 *   scope:   this function.
 *   retest:  not applicable.
 */

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

extern long STREAM_BufferedPutcOrFlush(long ch, struct PreallocHandleNode *node);
extern void ALLOC_InsertFreeBlock(void *block, long size);
extern long HANDLE_CloseByIndex(long index);

long UNKNOWN36_FinalizeRequest(struct PreallocHandleNode *node)
{
    long flushed;
    long closed;

    if (node->openFlags & 2)
        flushed = STREAM_BufferedPutcOrFlush(-1L, node);
    else
        flushed = 0;

    if ((node->openFlags & 12) == 0 && node->bufferCapacity != 0)
        ALLOC_InsertFreeBlock(node->bufferBase, node->bufferCapacity);

    node->openFlags = 0;
    closed = HANDLE_CloseByIndex(node->handleIndex);

    if (flushed == -1 || closed != 0)
        return -1;

    return 0;
}
