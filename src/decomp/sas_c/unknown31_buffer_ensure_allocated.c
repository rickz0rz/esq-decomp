typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned char UBYTE;

typedef struct PreallocHandleNode {
    struct PreallocHandleNode *Next; /* +0  */
    UBYTE *BufferCursor;             /* +4  */
    LONG ReadRemaining;              /* +8  */
    LONG WriteRemaining;             /* +12 */
    UBYTE *BufferBase;               /* +16 */
    LONG BufferCapacity;             /* +20 */
    ULONG OpenFlags;                 /* +24 (mode/state bytes at +26/+27) */
    LONG HandleIndex;                /* +28 */
    UBYTE InlineByte;                /* +32 */
} PreallocHandleNode;

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
