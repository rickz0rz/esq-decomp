/* RESTORES: _STREAM_BufferedWriteString
 * MODULE:   modules/submodules/unknown2b_stream_bufferedwritestring.s
 * STATUS:   behavioural
 *
 * Writes a NUL-terminated string to the standard output stream and returns its
 * length. This is SAS/C's `puts` over the prealloc handle node, and it is the
 * fast path: each character goes straight into the buffer, and only when the
 * buffer runs out does it fall back to the general putc.
 *
 * THE LENGTH IS MEASURED BEFORE ANYTHING IS WRITTEN, and it is the value
 * returned even though the write loop walks the same string again. The original
 * scans once with `TST.B (A0)+` / `BNE`, then `SUBQ.L #1,A0` to step back onto
 * the NUL and `SUBA.L A3,A0` to get the count. Nothing observes a short write:
 * the return is the string length, not the number of bytes accepted.
 *
 * THE BUFFER TEST IS DECREMENT-THEN-BRANCH. `SUBQ.L #1,WriteRemaining(A4)`
 * followed by `BLT` writes the decremented value back and takes the slow path
 * when it goes NEGATIVE, so the fast path runs while the count is still zero or
 * more. Writing this as a pre-test would be off by one and would overrun the
 * buffer by a byte.
 *
 * THE SLOW PATH DOES NOT RETRY. `STREAM_BufferedPutcOrFlush` is given the
 * character and takes responsibility for it -- flushing, reallocating or
 * failing -- and the loop then moves on to the next character. The original's
 * label reads `.flush_and_retry`, which is misleading: it branches back to the
 * top of the loop with the source pointer ALREADY advanced past the character
 * it just handed over, so nothing is re-sent.
 *
 * A final `STREAM_BufferedPutcOrFlush(-1, node)` closes the run. -1 is the
 * flush sentinel, the same one `UNKNOWN36_FinalizeRequest` uses.
 *
 * SPLIT OUT OF unknown2b.s. That module held nine labels, and the three that
 * remain -- `STREAM_BufferedPutcOrFlush`, `DOS_MovepWordReadCallback` and
 * `STREAM_BufferedGetc` -- are several hundred lines of SAS/C stdio that are not
 * restored yet. `tools/split_module.py` cut this onto its own `;!======`
 * boundary, byte-neutral, so it links while they stay in assembly.
 *
 * SASC-MISMATCH: near-data-addressing
 *   ref:     SUBQ.L #1,Global_PreallocHandleNode1_WriteRemaining(A4)
 *   got:     an absolute reference through the accessor macro
 *   summary: a 16-bit displacement off A4 becomes an absolute reference, which
 *            is what DATA=FAR means. Two bytes a site.
 *   scope:   every A4 reference in modules/submodules/.
 *   retest:  a build using SAS/C near data.
 */
#include "esq-neardata.h"

extern long STREAM_BufferedPutcOrFlush(long ch, void *node);

long STREAM_BufferedWriteString(char *text)
{
    char *p;
    long  len;
    long  ch;

    p = text;
    while (*p != 0)
        p++;
    len = (long)(p - text);

    for (;;) {
        ch = (long)(unsigned char)*text++;
        if (ch == 0)
            break;

        if (--Global_PreallocHandleNode1_WriteRemaining_A4 < 0) {
            STREAM_BufferedPutcOrFlush(ch, Global_PreallocHandleNode1_A4_ADDR);
        } else {
            char *cur = (char *)Global_PreallocHandleNode1_BufferCursor_A4;

            Global_PreallocHandleNode1_BufferCursor_A4 = (long)(cur + 1);
            *cur = (char)ch;
        }
    }

    STREAM_BufferedPutcOrFlush(-1L, Global_PreallocHandleNode1_A4_ADDR);

    return len;
}
