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
    ULONG mode_state_flags;  /* +24 (mode/state bytes at +26/+27) */
    LONG handle_index;       /* +28 */
    UBYTE inline_byte;       /* +32 */
} PreallocHandleNode;

enum {
    CHAR_CTRL_Z = 0x1a,
    CHAR_CR = 0x0d,
    MODE_TEXT_TRANSLATE_BIT = 7,
    STATE_READ_REFILL_ISSUED_BIT = 0,
    STATE_WRITE_PENDING_BIT = 1,
    STATE_UNBUFFERED_BIT = 2,
    STATE_EOF_OR_SHORT_BIT = 4,
    STATE_IO_ERROR_BIT = 5,
    STATE_PREREAD_FLUSH_GATE_LO_BIT = 6,
    STATE_PREREAD_FLUSH_GATE_HI_BIT = 7,
    OPEN_MASK_FLUSH_REJECT = 0x30,
    OPEN_MASK_READ_REJECT = 0x32
};

extern LONG STREAM_BufferedPutcOrFlush(LONG ch, PreallocHandleNode *node);
extern LONG BUFFER_EnsureAllocated(PreallocHandleNode *node);
extern LONG DOS_ReadByIndex(LONG handleIndex, void *buffer, LONG length);

static UBYTE *mode_flags_ptr(PreallocHandleNode *n) { return ((UBYTE *)&n->mode_state_flags) + 2; }
static UBYTE *state_flags_ptr(PreallocHandleNode *n) { return ((UBYTE *)&n->mode_state_flags) + 3; }

LONG STREAM_BufferedGetc(PreallocHandleNode *node)
{
    LONG textMode;
    LONG readCount;
    LONG c;
    UBYTE *state;
    UBYTE *mode;

    mode = mode_flags_ptr(node);
    state = state_flags_ptr(node);
    textMode = ((*mode & (1u << MODE_TEXT_TRANSLATE_BIT)) != 0) ? 1 : 0;

    if ((node->mode_state_flags & OPEN_MASK_FLUSH_REJECT) != 0) {
        node->read_remaining = 0;
        return -1;
    }

    if (((*state & (1u << STATE_PREREAD_FLUSH_GATE_HI_BIT)) != 0) &&
        ((*state & (1u << STATE_PREREAD_FLUSH_GATE_LO_BIT)) != 0)) {
        (void)STREAM_BufferedPutcOrFlush(-1, node);
    }

    if (node->buffer_capacity == 0) {
        node->read_remaining = 0;
        if ((*state & (1u << STATE_UNBUFFERED_BIT)) != 0) {
            node->buffer_capacity = 1;
            node->buffer_base = &node->inline_byte;
        } else {
            if (BUFFER_EnsureAllocated(node) != 0) {
                *state |= (1u << STATE_IO_ERROR_BIT);
                return -1;
            }
        }
    } else if (textMode != 0) {
        node->read_remaining += 2;
        if (node->read_remaining <= 0) {
            node->buffer_cursor += 1;
            c = (LONG)(unsigned char)node->buffer_cursor[-1];
            if (c == CHAR_CTRL_Z) {
                *state |= (1u << STATE_EOF_OR_SHORT_BIT);
                return -1;
            }
            if (c == CHAR_CR) {
                node->read_remaining -= 1;
                if (node->read_remaining < 0) {
                    return STREAM_BufferedGetc(node);
                }
                node->buffer_cursor += 1;
                return (LONG)(unsigned char)node->buffer_cursor[-1];
            }
            return c;
        }
    }

    if ((*state & (1u << STATE_WRITE_PENDING_BIT)) == 0) {
        *state |= (1u << STATE_READ_REFILL_ISSUED_BIT);
        readCount = DOS_ReadByIndex(node->handle_index, node->buffer_base, node->buffer_capacity);
        if (readCount < 0) {
            *state |= (1u << STATE_IO_ERROR_BIT);
        }
        if (readCount == 0) {
            *state |= (1u << STATE_EOF_OR_SHORT_BIT);
        }
        if (readCount > 0) {
            node->read_remaining = (textMode != 0) ? -readCount : readCount;
            node->buffer_cursor = node->buffer_base;
        }
    }

    if ((node->mode_state_flags & OPEN_MASK_READ_REJECT) != 0) {
        node->read_remaining = (textMode != 0) ? -1 : 0;
        return -1;
    }

    node->read_remaining -= 1;
    if (node->read_remaining < 0) {
        return STREAM_BufferedGetc(node);
    }

    node->buffer_cursor += 1;
    return (LONG)(unsigned char)node->buffer_cursor[-1];
}
