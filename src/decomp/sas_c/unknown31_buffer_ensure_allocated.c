typedef signed long LONG;

typedef struct PreallocHandleNode {
    LONG unk0;
    LONG unk4;
    LONG BufferBase;      /* +8 */
    LONG BufferCursor;    /* +12 */
    LONG ReadRemaining;   /* +16 */
    LONG WriteRemaining;  /* +20 */
    LONG OpenFlags;       /* +24 */
    LONG BufferCapacity;  /* +28 */
} PreallocHandleNode;

extern LONG Global_StreamBufferAllocSize;
extern LONG Global_AppErrorCode;

extern void *ALLOC_AllocFromFreeList(LONG size);

LONG BUFFER_EnsureAllocated(PreallocHandleNode *node)
{
    if (node->BufferCapacity == 0 || (node->OpenFlags & (1L << 3)) != 0) {
        LONG p = (LONG)ALLOC_AllocFromFreeList(Global_StreamBufferAllocSize);
        node->BufferCursor = p;
        node->BufferBase = p;

        if (p == 0) {
            Global_AppErrorCode = 12;
            return -1;
        }

        node->BufferCapacity = Global_StreamBufferAllocSize;
        node->OpenFlags &= -13;
        node->WriteRemaining = 0;
        node->ReadRemaining = 0;
    }

    return 0;
}
