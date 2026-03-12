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

extern ULONG Global_DefaultHandleFlags;

extern LONG UNKNOWN36_FinalizeRequest(PreallocHandleNode *node);
extern LONG HANDLE_OpenEntryWithFlags(const char *name, ULONG flags, LONG size);

PreallocHandleNode *HANDLE_OpenFromModeString(const char *name, const char *mode, PreallocHandleNode *node)
{
    ULONG defaultFlags;
    ULONG idx;
    LONG plus;
    LONG openHandle;
    ULONG handleModeBits;
    ULONG finalOpenFlagsBase;

    if (node->OpenFlags != 0UL) {
        (void)UNKNOWN36_FinalizeRequest(node);
    }

    defaultFlags = Global_DefaultHandleFlags;
    idx = 1;

    if ((UBYTE)mode[idx] == (UBYTE)'b') {
        defaultFlags = 0x8000UL;
        idx++;
    } else if ((UBYTE)mode[idx] == (UBYTE)'a') {
        defaultFlags = 0;
        idx++;
    }

    plus = ((UBYTE)mode[idx] == (UBYTE)'+') ? -1 : 0;

    if ((UBYTE)mode[0] == (UBYTE)'a') {
        openHandle = HANDLE_OpenEntryWithFlags(name, 0x8102UL, 12);
        if (openHandle == -1) {
            return (PreallocHandleNode *)0;
        }
        handleModeBits = (plus != 0) ? 128UL : 2UL;
        handleModeBits |= 0x4000UL;
    } else if ((UBYTE)mode[0] == (UBYTE)'r') {
        ULONG flags;
        flags = ((plus != 0) ? 2UL : 0UL) | 0x8000UL;
        openHandle = HANDLE_OpenEntryWithFlags(name, flags, 12);
        if (openHandle == -1) {
            return (PreallocHandleNode *)0;
        }
        handleModeBits = (plus != 0) ? 128UL : 1UL;
    } else if ((UBYTE)mode[0] == (UBYTE)'w') {
        ULONG flags;
        flags = ((plus != 0) ? 2UL : 1UL) | 0x8000UL | 0x100UL | 0x200UL;
        openHandle = HANDLE_OpenEntryWithFlags(name, flags, 12);
        if (openHandle == -1) {
            return (PreallocHandleNode *)0;
        }
        handleModeBits = (plus != 0) ? 128UL : 2UL;
    } else {
        return (PreallocHandleNode *)0;
    }

    node->BufferBase = (UBYTE *)0;
    node->BufferCapacity = 0;
    node->HandleIndex = openHandle;
    node->BufferCursor = node->BufferBase;
    node->WriteRemaining = 0;
    node->ReadRemaining = 0;

    finalOpenFlagsBase = (defaultFlags == 0UL) ? 0x8000UL : 0UL;
    node->OpenFlags = handleModeBits | finalOpenFlagsBase;

    return node;
}
