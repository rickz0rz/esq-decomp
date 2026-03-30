#include "prealloc_handle_node.h"

enum {
    CHAR_LF = 10,
    CHAR_CR = 13,
    CHAR_CTRL_Z = 26,
    CH_FLUSH = -1,
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
extern LONG DOS_MovepWordReadCallback(void);

LONG STREAM_BufferedPutcOrFlush(LONG ch, PreallocHandleNode *node)
{
    LONG originalCh;
    LONG isTextMode;
    LONG bytesWritten;
    LONG pendingByteCount;
    UBYTE singleByte;
    UBYTE *state;
    UBYTE *mode;

    originalCh = ch;
    mode = ((UBYTE *)&node->OpenFlags) + 2;
    state = mode + 1;
    isTextMode = ((*mode & (1u << MODE_TEXT_TRANSLATE_BIT)) != 0) ? 1 : 0;

    if ((node->OpenFlags & OPEN_MASK_WRITE_REJECT) != 0) {
        return -1;
    }

    if (node->BufferCapacity == 0 && ((*state & (1u << STATE_UNBUFFERED_BIT)) == 0)) {
        node->WriteRemaining = 0;
        if (ch == CH_FLUSH) {
            return -1;
        }
        if (BUFFER_EnsureAllocated(node) != 0) {
            *state |= (1u << STATE_IO_ERROR_BIT);
            return -1;
        }
        *state |= (1u << STATE_WRITE_PENDING_BIT);
        node->WriteRemaining = (isTextMode != 0) ? -node->BufferCapacity : node->BufferCapacity;
        node->WriteRemaining -= 1;
        if (node->WriteRemaining < 0) {
            return STREAM_BufferedPutcOrFlush((LONG)(UBYTE)ch, node);
        }
        *node->BufferCursor++ = (UBYTE)ch;
        return (LONG)(UBYTE)ch;
    }

    if ((*state & (1u << STATE_UNBUFFERED_BIT)) != 0) {
        if (ch == CH_FLUSH) {
            return 0;
        }

        singleByte = (UBYTE)ch;
        if (isTextMode != 0 && ch == CHAR_LF) {
            bytesWritten = DOS_WriteByIndex(
                node->HandleIndex,
                (void *)&DOS_MovepWordReadCallback,
                2
            );
        } else {
            bytesWritten = DOS_WriteByIndex(node->HandleIndex, &singleByte, 1);
        }
        ch = CH_FLUSH;
    } else {
        *state |= (1u << STATE_WRITE_PENDING_BIT);
        if (isTextMode != 0 && ch != CH_FLUSH) {
            node->WriteRemaining += 2;
            if (ch == CHAR_LF) {
                *node->BufferCursor++ = CHAR_CR;
                if (node->WriteRemaining >= 0) {
                    (void)STREAM_BufferedPutcOrFlush(0, node);
                }
                node->WriteRemaining += 1;
            }
            *node->BufferCursor++ = (UBYTE)ch;
            if (node->WriteRemaining < 0) {
                return (LONG)(UBYTE)ch;
            }
            ch = CH_FLUSH;
        }

        pendingByteCount = (LONG)(node->BufferCursor - node->BufferBase);
        bytesWritten = 0;
        if (pendingByteCount != 0) {
            if (((*mode & (1u << MODE_PREWRITE_SCAN_BIT)) != 0)) {
                LONG scan;
                (void)DOS_SeekByIndex(node->HandleIndex, 0, 2);
                if (isTextMode != 0) {
                    for (scan = pendingByteCount - 1; scan >= 0; scan -= 1) {
                        UBYTE probe;
                        (void)DOS_SeekByIndex(node->HandleIndex, scan, 0);
                        (void)DOS_ReadByIndex(node->HandleIndex, &probe, 1);
                        if (Global_DosIoErr != 0 || probe != CHAR_CTRL_Z) {
                            break;
                        }
                    }
                }
            }
            bytesWritten = DOS_WriteByIndex(node->HandleIndex, node->BufferBase, pendingByteCount);
        }

        if (bytesWritten == -1) {
            *state |= (1u << STATE_IO_ERROR_BIT);
        } else if (bytesWritten != pendingByteCount) {
            *state |= (1u << STATE_EOF_OR_SHORT_BIT);
        }

        if (isTextMode != 0) {
            node->WriteRemaining = -node->BufferCapacity;
        } else if ((*state & (1u << STATE_UNBUFFERED_BIT)) != 0) {
            node->WriteRemaining = 0;
        } else {
            node->WriteRemaining = node->BufferCapacity;
        }
        node->BufferCursor = node->BufferBase;

        if (ch != CH_FLUSH) {
            node->WriteRemaining -= 1;
            if (node->WriteRemaining < 0) {
                return STREAM_BufferedPutcOrFlush((LONG)(UBYTE)ch, node);
            }
            *node->BufferCursor++ = (UBYTE)ch;
        }
    }

    if ((node->OpenFlags & OPEN_MASK_FLUSH_REJECT) != 0) {
        return -1;
    }
    return (originalCh == CH_FLUSH) ? 0 : (LONG)(UBYTE)originalCh;
}
