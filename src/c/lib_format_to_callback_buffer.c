/* RESTORES: FORMAT_CallbackWriteChar, FORMAT_FormatToCallbackBuffer
 * MODULE:   modules/submodules/unknown13.s
 * STATUS:   behavioural
 *
 * SAS/C library code: fprintf. It formats into a stream node one character at a
 * time through a callback, then flushes, and returns the number of characters
 * emitted.
 *
 * THE ORIGINAL RETURNS ITS RESULT IN D1, WHICH C CANNOT DO -- AND IT DOES NOT
 * MATTER HERE. FORMAT_CallbackWriteChar ends `MOVE.L D0,D1` on one path and
 * `MOVE.B D0,D1` on the other, so the character or the putc result comes back in
 * D1 rather than D0. That is the same shape as __CXD22, which is a PROVEN
 * BLOCKER (see AGENTS.md).
 *
 * It is not a blocker here because the value is DEAD. The only invocation is
 * `JSR (A3)` in WDISP_FormatWithCallback, which discards it -- `ADDQ.W #4,A7`
 * and straight back to the loop -- and a search over src/modules and src/c finds
 * no other reference to the symbol at all. So the restoration returns in D0 and
 * nothing can tell.
 *
 * **Check the CALLERS before accepting a D1 return as a blocker.** The
 * distinction is whether anything reads it, not whether C can produce it.
 *
 * THE FAST PATH IS THE putc MACRO, mirroring the getc in
 * lib_stream_read_line_with_limit.c: `SUBQ.L #1,12(A0) / BLT` decrements
 * writeRemaining IN MEMORY and calls the flush only when it goes negative. The
 * decrement is not undone on the slow path.
 *
 * THE BYTE COUNT IS INCREMENTED BEFORE THE WRITE, and on BOTH paths, so it counts
 * characters offered rather than characters stored. A flush that fails still
 * counts them, and the returned length can therefore exceed what reached the
 * file.
 *
 * THE FINAL FLUSH IS putc(-1), the same call the buffer-full path makes with a
 * real character. -1 is the sentinel that means "flush what you have".
 *
 * SASC-MISMATCH: near-data-addressing
 *   ref:     ADDQ.L #1,Global_FormatCallbackByteCount(A4)
 *   got:     an absolute reference through the enclosing array
 *   scope:   every A4 reference in modules/submodules/.
 *   retest:  a build using SAS/C near data.
 */
#include <stdarg.h>
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

extern long STREAM_BufferedPutcOrFlush(long ch, struct PreallocHandleNode *node);
extern void WDISP_FormatWithCallback(long (*put)(long ch), char *fmt, void *args);

long FORMAT_CallbackWriteChar(long ch)
{
    struct PreallocHandleNode *node =
        (struct PreallocHandleNode *)Global_FormatCallbackBufferPtr_A4;

    Global_FormatCallbackByteCount_A4++;    /* counted before the write */

    /* The putc macro: decrement in memory, flush only when it goes negative. */
    if (--node->writeRemaining >= 0) {
        *node->bufferCursor++ = (char)ch;
        return (long)(unsigned char)ch;
    }

    return STREAM_BufferedPutcOrFlush((long)(unsigned char)ch, node);
}

long FORMAT_FormatToCallbackBuffer(struct PreallocHandleNode *node,
                                   char *fmt, ...)
{
    va_list ap;

    Global_FormatCallbackByteCount_A4 = 0;
    Global_FormatCallbackBufferPtr_A4 = (long)node;

    va_start(ap, fmt);
    WDISP_FormatWithCallback(FORMAT_CallbackWriteChar, fmt, (void *)ap);
    va_end(ap);

    STREAM_BufferedPutcOrFlush(-1, node);   /* -1 means "flush" */

    return Global_FormatCallbackByteCount_A4;
}
