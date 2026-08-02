/* RESTORES: STREAM_ReadLineWithLimit
 * MODULE:   modules/submodules/unknown15.s
 * STATUS:   behavioural
 *
 * SAS/C library code: fgets. Reads up to `limit - 1` bytes into `buf`, stopping
 * at a newline or end of file, and terminates the result.
 *
 * THE NEWLINE IS KEPT. It is stored before the loop breaks, exactly as fgets
 * does, so a caller that wants the bare line has to trim it.
 *
 * IT RETURNS NULL WHEN NOTHING WAS READ and the buffer pointer otherwise. The
 * test is `left == room` -- the counter untouched -- not a check of the first
 * byte, so a file ending exactly at a line boundary returns NULL on the next
 * call rather than an empty string.
 *
 * THE BUFFER IS ALWAYS TERMINATED, including on the NULL return, so the caller's
 * buffer is left in a defined state either way.
 *
 * THE FAST PATH IS THE getc MACRO WRITTEN OUT. `SUBQ.L #1,8(A2) / BLT` decrements
 * the node's byte count IN MEMORY and only calls STREAM_BufferedGetc when it goes
 * negative. The decrement happens BEFORE the test and is NOT undone on the slow
 * path -- the refill is what resets the count -- so `--node->readRemaining >= 0`
 * is the faithful form and a pre-test like `if (node->readRemaining > 0)` is not.
 *
 * THE LIMIT IS DECREMENTED ONCE UP FRONT to leave room for the terminator, and
 * the loop runs while the remaining count is >= 0. So a limit of 1 stores no
 * bytes and returns NULL, and a limit of 0 makes `room` -1 and does the same.
 *
 * SASC-MISMATCH: cross-unit-call-encoding
 *   ref:     4eba  JSR (d16,PC)
 *   got:     6100  BSR.W
 *   scope:   program-wide.
 *   retest:  a compiler that picks the encoding per callee.
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
    long  openFlags;                    /* +24 */
    long  handleIndex;                  /* +28 */
    unsigned char inlineByte;           /* +32 */
    unsigned char pad33;                /* +33 */
};
#endif

extern long STREAM_BufferedGetc(struct PreallocHandleNode *node);

char *STREAM_ReadLineWithLimit(char *buf, long limit,
                               struct PreallocHandleNode *node)
{
    char *out = buf;
    long room = limit - 1;
    long left = room;

    while (left >= 0) {
        long c;

        /* The getc macro: decrement in memory, refill only when it goes
         * negative. The decrement is not undone on the slow path. */
        if (--node->readRemaining >= 0)
            c = (unsigned char)*node->bufferCursor++;
        else
            c = STREAM_BufferedGetc(node);

        if (c == -1)
            break;

        left--;
        *out++ = (char)c;

        if (c == 10)                    /* the newline is KEPT */
            break;
    }

    *out = 0;

    if (left == room)                   /* nothing was read at all */
        return 0;

    return buf;
}
