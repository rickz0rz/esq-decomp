/* RESTORES: _STREAM_BufferedGetc
 * MODULE:   modules/submodules/unknown2b_p1_stream_bufferedgetc.s
 * STATUS:   behavioural
 *
 * SAS/C's buffered `getc`. It returns the next byte of a handle node, refilling
 * from the file when the buffer runs out, and -1 on end of file or error.
 *
 * THE FLAG WORD IS ONE LONG WITH TWO BYTE ALIASES, exactly as in
 * `lib_stream_buffered_putc_or_flush.c`: a StateFlags bit N is long bit N, and a
 * ModeFlags bit N is long bit N+8, because the assembly reaches +27 and +26 of a
 * big-endian long at +24.
 *
 * IT FLUSHES BEFORE IT READS, AND BOTH GATE BITS MUST BE SET. The entry tests
 * StateFlags bit 7 and bit 6 and calls the putc side with the flush sentinel
 * only when BOTH are set. That is a read-after-write on the same handle. Bit 6
 * is marked reserved in `src/Prevue.asm` with no in-tree producer, so this path
 * is believed dead in the stock image -- it is kept because the original keeps
 * it, and dropping it would be a behaviour change nothing measured.
 *
 * THE COUNTER IS DECREMENT-THEN-BRANCH. `SUBQ.L #1,readRemaining` then `BLT`
 * writes the decremented value back and refills when it goes NEGATIVE, so a
 * byte is taken while the count is still zero or more. A pre-test would be off
 * by one and would read one byte past the buffer.
 *
 * A NEGATIVE `readRemaining` IS THE TEXT-MODE STATE. On a refill the count is
 * seeded to MINUS the byte count in text mode and to plus it otherwise, which is
 * the mirror of the write side. The `+= 2` then `> 0` test at the top is how
 * text mode decides it must refill rather than serve from the buffer.
 *
 * CTRL-Z ENDS THE FILE, IN TEXT MODE ONLY. 0x1A sets the EOF flag and returns
 * -1. A bare 0x0D is DROPPED and the byte after it is returned, which is the
 * CRLF folding this layer is named for. Both tests sit inside the text-mode
 * branch, so a binary read returns 0x1A and 0x0D unchanged.
 *
 * THE UNBUFFERED CASE READS INTO THE NODE ITSELF. When no buffer is allocated
 * and the Unbuffered bit is set, the capacity becomes 1 and the base points at
 * `inlineByte` at +32, inside the node. So a one-byte read needs no allocation.
 *
 * THE REFILL IS SKIPPED WHEN A WRITE IS PENDING. `fill_buffer` first tests the
 * WritePending bit and jumps past the whole DOS read when it is set, leaving the
 * counters alone. The reject test after it then decides the result.
 *
 * SASC-MISMATCH: call-encoding
 *   ref:     4EBA<d16>                 JSR (d16,PC)
 *   got:     6100<d16>                 BSR.W
 *   summary: same size, same displacement, same semantics, different opcode.
 *            6.51 emits BSR.W for every callee.
 *   scope:   program-wide, 255 restorations.
 *   retest:  a compiler that picks the call encoding per translation unit.
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

#define HN_STATE_READ_REFILL    0x01L
#define HN_STATE_WRITE_PENDING  0x02L
#define HN_STATE_UNBUFFERED     0x04L
#define HN_STATE_EOF_OR_SHORT   0x10L
#define HN_STATE_IO_ERROR       0x20L
#define HN_STATE_PREREAD_LO     0x40L
#define HN_STATE_PREREAD_HI     0x80L

#define HN_MODE_TEXT_TRANSLATE  0x8000L

#define HN_OPEN_FLUSH_REJECT    0x30L
#define HN_OPEN_READ_REJECT     0x32L

extern long BUFFER_EnsureAllocated(struct PreallocHandleNode *node);
extern long DOS_ReadByIndex(long index, char *buf, long len);
extern long STREAM_BufferedPutcOrFlush(long ch, struct PreallocHandleNode *node);

long STREAM_BufferedGetc(struct PreallocHandleNode *node)
{
    long textMode;              /* D7 */
    long got;                   /* D5 */
    long c;                     /* D6 */

    textMode = (node->openFlags & HN_MODE_TEXT_TRANSLATE) ? 1 : 0;

    if ((node->openFlags & HN_OPEN_FLUSH_REJECT) != 0) {
        node->readRemaining = 0;
        return -1;
    }

    /* Read after write on the same handle: both gate bits, then flush. */
    if ((node->openFlags & HN_STATE_PREREAD_HI)
        && (node->openFlags & HN_STATE_PREREAD_LO))
        STREAM_BufferedPutcOrFlush(-1L, node);

    if (node->bufferCapacity == 0) {
        node->readRemaining = 0;
        if (node->openFlags & HN_STATE_UNBUFFERED) {
            /* One byte, read into the node itself -- no allocation. */
            node->bufferCapacity = 1;
            node->bufferBase = (char *)&node->inlineByte;
        } else if (BUFFER_EnsureAllocated(node) != 0) {
            node->openFlags |= HN_STATE_IO_ERROR;
            return -1;
        }
    } else if (textMode) {
        node->readRemaining += 2;
        if (node->readRemaining <= 0) {
            c = (long)(unsigned char)*node->bufferCursor++;

            if (c == 0x1a) {
                node->openFlags |= HN_STATE_EOF_OR_SHORT;
                return -1;
            }
            if (c != 0x0d)
                return c;

            /* Drop the CR and serve what follows it. */
            if (--node->readRemaining < 0)
                return STREAM_BufferedGetc(node);
            return (long)(unsigned char)*node->bufferCursor++;
        }
    }

    if (!(node->openFlags & HN_STATE_WRITE_PENDING)) {
        node->openFlags |= HN_STATE_READ_REFILL;
        got = DOS_ReadByIndex(node->handleIndex, node->bufferBase,
                              node->bufferCapacity);
        if (got < 0)
            node->openFlags |= HN_STATE_IO_ERROR;
        if (got == 0)
            node->openFlags |= HN_STATE_EOF_OR_SHORT;
        if (got > 0) {
            if (textMode)
                node->readRemaining = -got;
            else
                node->readRemaining = got;
            node->bufferCursor = node->bufferBase;
        }
    }

    if ((node->openFlags & HN_OPEN_READ_REJECT) != 0) {
        if (textMode)
            node->readRemaining = -1;
        else
            node->readRemaining = 0;
        return -1;
    }

    if (--node->readRemaining < 0)
        return STREAM_BufferedGetc(node);
    return (long)(unsigned char)*node->bufferCursor++;
}
