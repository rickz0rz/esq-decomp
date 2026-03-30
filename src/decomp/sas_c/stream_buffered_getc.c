#include "prealloc_handle_node.h"

enum {
    CH_EOF = -1,
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

static UBYTE *mode_flags_ptr(PreallocHandleNode *n) { return ((UBYTE *)&n->OpenFlags) + 2; }
static UBYTE *state_flags_ptr(PreallocHandleNode *n) { return ((UBYTE *)&n->OpenFlags) + 3; }

LONG STREAM_BufferedGetc(PreallocHandleNode *node)
{
    LONG isTextMode;
    LONG bytesRead;
    LONG ch;
    UBYTE *state;
    UBYTE *mode;

    mode = mode_flags_ptr(node);
    state = state_flags_ptr(node);
    isTextMode = ((*mode & (1u << MODE_TEXT_TRANSLATE_BIT)) != 0) ? 1 : 0;

    if ((node->OpenFlags & OPEN_MASK_FLUSH_REJECT) != 0) {
        node->ReadRemaining = 0;
        return CH_EOF;
    }

    if (((*state & (1u << STATE_PREREAD_FLUSH_GATE_HI_BIT)) != 0) &&
        ((*state & (1u << STATE_PREREAD_FLUSH_GATE_LO_BIT)) != 0)) {
        (void)STREAM_BufferedPutcOrFlush(-1, node);
    }

    if (node->BufferCapacity == 0) {
        node->ReadRemaining = 0;
        if ((*state & (1u << STATE_UNBUFFERED_BIT)) != 0) {
            node->BufferCapacity = 1;
            node->BufferBase = &node->InlineByte;
        } else {
            if (BUFFER_EnsureAllocated(node) != 0) {
                *state |= (1u << STATE_IO_ERROR_BIT);
                return CH_EOF;
            }
        }
    } else if (isTextMode != 0) {
        node->ReadRemaining += 2;
        if (node->ReadRemaining <= 0) {
            node->BufferCursor += 1;
            ch = (LONG)(unsigned char)node->BufferCursor[-1];
            if (ch == CHAR_CTRL_Z) {
                *state |= (1u << STATE_EOF_OR_SHORT_BIT);
                return CH_EOF;
            }
            if (ch == CHAR_CR) {
                node->ReadRemaining -= 1;
                if (node->ReadRemaining < 0) {
                    return STREAM_BufferedGetc(node);
                }
                node->BufferCursor += 1;
                return (LONG)(unsigned char)node->BufferCursor[-1];
            }
            return ch;
        }
    }

    if ((*state & (1u << STATE_WRITE_PENDING_BIT)) == 0) {
        *state |= (1u << STATE_READ_REFILL_ISSUED_BIT);
        bytesRead = DOS_ReadByIndex(node->HandleIndex, node->BufferBase, node->BufferCapacity);
        if (bytesRead < 0) {
            *state |= (1u << STATE_IO_ERROR_BIT);
        }
        if (bytesRead == 0) {
            *state |= (1u << STATE_EOF_OR_SHORT_BIT);
        }
        if (bytesRead > 0) {
            node->ReadRemaining = (isTextMode != 0) ? -bytesRead : bytesRead;
            node->BufferCursor = node->BufferBase;
        }
    }

    if ((node->OpenFlags & OPEN_MASK_READ_REJECT) != 0) {
        node->ReadRemaining = (isTextMode != 0) ? -1 : 0;
        return CH_EOF;
    }

    node->ReadRemaining -= 1;
    if (node->ReadRemaining < 0) {
        return STREAM_BufferedGetc(node);
    }

    node->BufferCursor += 1;
    return (LONG)(unsigned char)node->BufferCursor[-1];
}
