/* RESTORES: _STREAM_BufferedPutcOrFlush
 * MODULE:   modules/submodules/unknown2b_p1_stream_bufferedputcorflush.s
 * STATUS:   behavioural
 *
 * SAS/C's buffered `putc`, and its flush. One call either buffers a byte,
 * writes it straight through, or empties the buffer to the file. `ch` of -1 is
 * the FLUSH SENTINEL, the same one `UNKNOWN36_FinalizeRequest` and
 * `STREAM_BufferedWriteString` use.
 *
 * THE FLAG WORD IS ONE LONG WITH TWO BYTE ALIASES. `openFlags` is a long at
 * +24. The assembly reaches +27 as `StateFlags` and +26 as `ModeFlags`, and on
 * a big-endian 68000 those are the low byte and the second-lowest byte. So a
 * StateFlags bit N is long bit N, and a ModeFlags bit N is long bit N+8. That is
 * why `HN_MODE_TEXT_TRANSLATE` is 0x8000 and not 0x80.
 *
 * `textMode` IS A BOOLEAN, AND THE ORIGINAL BUILDS IT AS ONE. The entry does
 * `BTST / SNE / NEG.B / EXT.W / EXT.L`, which is the booleanize idiom: 1 when
 * the bit is set, 0 otherwise. It is tested with `TST.B` afterwards, never
 * re-read from the node, so a local is faithful rather than a convenience.
 *
 * THE COUNTER IS DECREMENT-THEN-BRANCH, in three places. `SUBQ.L #1,count` then
 * `BLT` writes the decremented value back and takes the slow path when it goes
 * NEGATIVE, so the fast path runs while the count is still zero or more.
 * Written as a pre-test every one of them would be off by one and would overrun
 * the buffer by a byte. `STREAM_BufferedWriteString` records the same shape.
 *
 * A NEGATIVE `writeRemaining` IS THE TEXT-MODE STATE, NOT AN ERROR. In text
 * mode the count is seeded to MINUS the capacity, so it stays negative for the
 * whole buffer and the `BMI` after a store means "buffered, nothing to do".
 * That is also why the flush path adds 2 and then 1 back around the CR: it is
 * reserving room for the second byte of the pair without letting the count go
 * positive and trigger a flush mid-pair.
 *
 * THE RETURN VALUE COMES FROM THE SAVED ORIGINAL ARGUMENT, NOT FROM THE WORK.
 * `D4` holds `ch` from entry and is never touched. The tail returns 0 for the
 * flush sentinel and `ch` otherwise, discarding the `D1` byte value the store
 * paths computed. Only the early `.return_byte` path returns `D1`. Returning
 * the recursive call's result instead would be wrong on a full buffer.
 *
 * DOS_STR_CRLF IS TWO BYTES BUILT INTO A LOCAL. It used to be an assembly
 * symbol in the CODE section, reached by address, because a C string literal
 * would emit a DATA hunk -- and AGENTS.md records that four bytes of DATA
 * growth shifts every symbol after it and freezes the display. Writing the two
 * bytes into a stack local keeps them in CODE and needs no symbol at all, which
 * is what lets modules/submodules/unknown2b_p1_p0.s contribute nothing to the
 * maximum-C build. Same treatment as console_name() in
 * lib_parse_command_line_and_run.c. The assembly module STAYS, because it is
 * what the byte-exact build assembles.
 *
 * SASC-MISMATCH: near-data-addressing
 *   ref:     TST.L Global_DosIoErr(A4)
 *   got:     an absolute read through the accessor macro
 *   summary: a 16-bit displacement off A4 becomes an absolute reference, which
 *            is what DATA=FAR means. Two bytes a site.
 *   scope:   every A4 reference in modules/submodules/.
 *   retest:  a build using SAS/C near data.
 *
 * SASC-MISMATCH: reserved-a5-frame
 *   ref:     LINK.W A5,#-20 with five named slots
 *   got:     ordinary locals, which 6.51 lays out in its own order
 *   summary: the original reserves A5 as a frame pointer. This is the
 *            project's central divergence and it is not option-selectable.
 *   scope:   program-wide.
 *   retest:  a compiler that emits 2f0b on the acceptance test.
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

/* StateFlags is the LOW byte of openFlags, so its bit N is long bit N. */
#define HN_STATE_WRITE_PENDING  0x02L
#define HN_STATE_UNBUFFERED     0x04L
#define HN_STATE_EOF_OR_SHORT   0x10L
#define HN_STATE_IO_ERROR       0x20L

/* ModeFlags is the byte ABOVE it, so its bit N is long bit N+8. */
#define HN_MODE_PREWRITE_SCAN   0x4000L
#define HN_MODE_TEXT_TRANSLATE  0x8000L

/* Struct_PreallocHandleNode_OpenMask_*, tested against the whole long. */
#define HN_OPEN_WRITE_REJECT    0x31L
#define HN_OPEN_FLUSH_REJECT    0x30L

extern long  BUFFER_EnsureAllocated(struct PreallocHandleNode *node);
extern long  DOS_WriteByIndex(long index, char *buf, long len);
extern long  DOS_ReadByIndex(long index, char *buf, long len);
extern long  DOS_SeekByIndex(long index, long pos, long mode);

long STREAM_BufferedPutcOrFlush(long ch, struct PreallocHandleNode *node)
{
    char  outByte;              /* -1(A5)  */
    char  crlf[2];              /* DOS_STR_CRLF, built here -- see header */
    char  scanByte;             /* -3(A5)  */
    long  pending;              /* -16(A5) */
    long  scanPos;              /* -20(A5) */
    long  written;              /* D5 */
    long  textMode;             /* D6 */
    long  cur;                  /* D7, becomes -1 once the byte is placed */
    long  original;             /* D4, the argument as it arrived */
    long  result;               /* D1 */

    cur = ch;
    original = ch;

    if ((node->openFlags & HN_OPEN_WRITE_REJECT) != 0)
        return -1;

    textMode = (node->openFlags & HN_MODE_TEXT_TRANSLATE) ? 1 : 0;

    if (node->bufferCapacity == 0
        && !(node->openFlags & HN_STATE_UNBUFFERED)) {
        /* First write on a node with no buffer yet. */
        node->writeRemaining = 0;
        if (cur == -1)
            return 0;

        if (BUFFER_EnsureAllocated(node) != 0) {
            node->openFlags |= HN_STATE_IO_ERROR;
            return -1;
        }

        node->openFlags |= HN_STATE_WRITE_PENDING;
        if (textMode)
            node->writeRemaining = -node->bufferCapacity;
        else
            node->writeRemaining = node->bufferCapacity;

        if (--node->writeRemaining < 0) {
            result = STREAM_BufferedPutcOrFlush((long)(unsigned char)cur, node);
        } else {
            *node->bufferCursor++ = (char)cur;
            result = (long)(unsigned char)cur;
        }
        return result;
    }

    if (node->openFlags & HN_STATE_UNBUFFERED) {
        /* Unbuffered: one DOS write per call, and nothing is held. */
        if (cur == -1)
            return 0;

        outByte = (char)cur;
        if (textMode && cur == 10) {
            pending = 2;
            crlf[0] = 13;
            crlf[1] = 10;
            written = DOS_WriteByIndex(node->handleIndex, crlf, 2L);
        } else {
            pending = 1;
            written = DOS_WriteByIndex(node->handleIndex, &outByte, 1L);
        }
        cur = -1;
    } else {
        node->openFlags |= HN_STATE_WRITE_PENDING;

        if (textMode && cur != -1) {
            /* Reserve room for the pair, so the CR cannot flush mid-pair. */
            node->writeRemaining += 2;
            if (cur == 10) {
                *node->bufferCursor++ = 13;
                if (node->writeRemaining >= 0)
                    STREAM_BufferedPutcOrFlush(-1L, node);
                node->writeRemaining += 1;
            }
            *node->bufferCursor++ = (char)cur;
            if (node->writeRemaining < 0)
                return cur;
            cur = -1;
        }

        pending = (long)(node->bufferCursor - node->bufferBase);
        if (pending == 0) {
            written = 0;
        } else {
            if (node->openFlags & HN_MODE_PREWRITE_SCAN) {
                /* Back over any Ctrl-Z padding before appending. */
                scanPos = DOS_SeekByIndex(node->handleIndex, 0L, 2L);
                if (textMode) {
                    while (--scanPos >= 0) {
                        DOS_SeekByIndex(node->handleIndex, scanPos, 0L);
                        DOS_ReadByIndex(node->handleIndex, &scanByte, 1L);
                        if (Global_DosIoErr_A4 != 0)
                            break;
                        if (scanByte != 26)
                            break;
                    }
                }
            }
            written = DOS_WriteByIndex(node->handleIndex, node->bufferBase,
                                       pending);
        }
    }

    if (written == -1)
        node->openFlags |= HN_STATE_IO_ERROR;
    else if (written != pending)
        node->openFlags |= HN_STATE_EOF_OR_SHORT;

    if (textMode)
        node->writeRemaining = -node->bufferCapacity;
    else if (node->openFlags & HN_STATE_UNBUFFERED)
        node->writeRemaining = 0;
    else
        node->writeRemaining = node->bufferCapacity;

    node->bufferCursor = node->bufferBase;

    if (cur != -1) {
        /* The byte that did not fit before the flush goes in now. */
        if (--node->writeRemaining < 0)
            result = STREAM_BufferedPutcOrFlush((long)(unsigned char)cur, node);
        else
            *node->bufferCursor++ = (char)cur;
    }

    if ((node->openFlags & HN_OPEN_FLUSH_REJECT) != 0)
        return -1;

    /* The saved argument, not the work above -- see the header. */
    if (original == -1)
        return 0;
    return original;
}
