#include "prealloc_handle_node.h"

extern UBYTE Global_PreallocHandleNode0;

extern LONG DOS_WriteByIndex(LONG handle, void *buf, LONG len);
extern LONG HANDLE_CloseAllAndReturnWithCode(LONG code);

LONG BUFFER_FlushAllAndCloseWithCode(LONG code)
{
    PreallocHandleNode *node;

    node = (PreallocHandleNode *)&Global_PreallocHandleNode0;
    while (node != (PreallocHandleNode *)0) {
        UBYTE state;

        state = *((UBYTE *)&node->OpenFlags + 3);
        if ((state & (1U << 2)) == 0U && (state & (1U << 1)) != 0U) {
            LONG pending;

            pending = (LONG)(node->BufferCursor - node->BufferBase);
            if (pending != 0) {
                (void)DOS_WriteByIndex(node->HandleIndex, (void *)node->BufferBase, pending);
            }
        }
        node = node->Next;
    }

    return HANDLE_CloseAllAndReturnWithCode(code);
}
