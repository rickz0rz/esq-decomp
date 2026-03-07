typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned char UBYTE;

typedef struct PreallocHandleNode {
    ULONG owner_or_link;     /* +0  */
    UBYTE *buffer_cursor;    /* +4  */
    LONG read_remaining;     /* +8  */
    LONG write_remaining;    /* +12 */
    UBYTE *buffer_base;      /* +16 */
    LONG buffer_capacity;    /* +20 */
    ULONG open_flags;        /* +24 */
    LONG handle_index;       /* +28 */
    UBYTE inline_byte;       /* +32 */
} PreallocHandleNode;

enum {
    MODE_TEXT_TRANSLATE_BIT = 7,
    MODE_PREWRITE_SCAN_BIT = 6,
    STATE_WRITE_PENDING_BIT = 1,
    STATE_UNBUFFERED_BIT = 2,
    STATE_EOF_OR_SHORT_BIT = 4,
    STATE_IO_ERROR_BIT = 5,
    OPEN_MASK_WRITE_REJECT = 0x31,
    OPEN_MASK_FLUSH_REJECT = 0x30
};

extern LONG Global_DosIoErr;

extern LONG BUFFER_EnsureAllocated(PreallocHandleNode *node);
extern LONG DOS_SeekByIndex(LONG handleIndex, LONG offset, LONG mode);
extern LONG DOS_ReadByIndex(LONG handleIndex, void *buffer, LONG length);
extern LONG DOS_WriteByIndex(LONG handleIndex, void *buffer, LONG length);

static UBYTE *mode_flags_ptr(PreallocHandleNode *n) { return ((UBYTE *)&n->open_flags) + 2; }
static UBYTE *state_flags_ptr(PreallocHandleNode *n) { return ((UBYTE *)&n->open_flags) + 3; }

LONG STREAM_BufferedPutcOrFlush(LONG ch, PreallocHandleNode *node)
{
    LONG textMode;
    LONG written;
    LONG pendingBytes;
    UBYTE outByte;
    UBYTE *state;
    UBYTE *mode;

    mode = mode_flags_ptr(node);
    state = state_flags_ptr(node);
    textMode = ((*mode & (1u << MODE_TEXT_TRANSLATE_BIT)) != 0) ? 1 : 0;

    if ((node->open_flags & OPEN_MASK_WRITE_REJECT) != 0) {
        return -1;
    }

    if (node->buffer_capacity == 0 && ((*state & (1u << STATE_UNBUFFERED_BIT)) == 0)) {
        node->write_remaining = 0;
        if (ch == -1) {
            return -1;
        }
        if (BUFFER_EnsureAllocated(node) != 0) {
            *state |= (1u << STATE_IO_ERROR_BIT);
            return -1;
        }
        *state |= (1u << STATE_WRITE_PENDING_BIT);
        node->write_remaining = (textMode != 0) ? -node->buffer_capacity : node->buffer_capacity;
        node->write_remaining -= 1;
        if (node->write_remaining < 0) {
            return STREAM_BufferedPutcOrFlush((LONG)(UBYTE)ch, node);
        }
        *node->buffer_cursor++ = (UBYTE)ch;
        return (LONG)(UBYTE)ch;
    }

    if ((*state & (1u << STATE_UNBUFFERED_BIT)) != 0) {
        if (ch == -1) {
            return 0;
        }

        outByte = (UBYTE)ch;
        if (textMode != 0 && ch == 10) {
            UBYTE crlf[2];
            crlf[0] = 13;
            crlf[1] = 10;
            written = DOS_WriteByIndex(node->handle_index, crlf, 2);
        } else {
            written = DOS_WriteByIndex(node->handle_index, &outByte, 1);
        }
        ch = -1;
    } else {
        *state |= (1u << STATE_WRITE_PENDING_BIT);
        if (textMode != 0 && ch != -1) {
            node->write_remaining += 2;
            if (ch == 10) {
                *node->buffer_cursor++ = 13;
                if (node->write_remaining >= 0) {
                    (void)STREAM_BufferedPutcOrFlush(0, node);
                }
                node->write_remaining += 1;
            }
            *node->buffer_cursor++ = (UBYTE)ch;
            if (node->write_remaining < 0) {
                return (LONG)(UBYTE)ch;
            }
            ch = -1;
        }

        pendingBytes = (LONG)(node->buffer_cursor - node->buffer_base);
        written = 0;
        if (pendingBytes != 0) {
            if (((*mode & (1u << MODE_PREWRITE_SCAN_BIT)) != 0)) {
                LONG scan;
                (void)DOS_SeekByIndex(node->handle_index, 0, 2);
                if (textMode != 0) {
                    for (scan = pendingBytes - 1; scan >= 0; scan -= 1) {
                        UBYTE probe;
                        (void)DOS_SeekByIndex(node->handle_index, scan, 0);
                        (void)DOS_ReadByIndex(node->handle_index, &probe, 1);
                        if (Global_DosIoErr != 0 || probe != 26) {
                            break;
                        }
                    }
                }
            }
            written = DOS_WriteByIndex(node->handle_index, node->buffer_base, pendingBytes);
        }

        if (written == -1) {
            *state |= (1u << STATE_IO_ERROR_BIT);
        } else if (written != pendingBytes) {
            *state |= (1u << STATE_EOF_OR_SHORT_BIT);
        }

        if (textMode != 0) {
            node->write_remaining = -node->buffer_capacity;
        } else if ((*state & (1u << STATE_UNBUFFERED_BIT)) != 0) {
            node->write_remaining = 0;
        } else {
            node->write_remaining = node->buffer_capacity;
        }
        node->buffer_cursor = node->buffer_base;

        if (ch != -1) {
            node->write_remaining -= 1;
            if (node->write_remaining < 0) {
                return STREAM_BufferedPutcOrFlush((LONG)(UBYTE)ch, node);
            }
            *node->buffer_cursor++ = (UBYTE)ch;
        }
    }

    if ((node->open_flags & OPEN_MASK_FLUSH_REJECT) != 0) {
        return -1;
    }
    return (ch == -1) ? 0 : (LONG)(UBYTE)ch;
}
