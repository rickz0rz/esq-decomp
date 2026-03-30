#include "prealloc_handle_node.h"

extern LONG Global_StreamBufferAllocSize;
extern LONG Global_AppErrorCode;

extern void *ALLOC_AllocFromFreeList(LONG size);

LONG BUFFER_EnsureAllocated(PreallocHandleNode *node)
{
    UBYTE *state;

    state = ((UBYTE *)&node->OpenFlags) + 3;

    if (node->BufferCapacity == 0 || (*state & (1u << 3)) != 0) {
        UBYTE *p;

        p = (UBYTE *)ALLOC_AllocFromFreeList(Global_StreamBufferAllocSize);
        node->BufferCursor = p;
        node->BufferBase = p;

        if (p == 0) {
            Global_AppErrorCode = 12;
            return -1;
        }

        node->BufferCapacity = Global_StreamBufferAllocSize;
        node->OpenFlags &= ~12UL;
        node->WriteRemaining = 0;
        node->ReadRemaining = 0;
    }

    return 0;
}
