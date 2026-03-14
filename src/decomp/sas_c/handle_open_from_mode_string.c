#include <exec/types.h>
struct PreallocHandleNode {
    struct PreallocHandleNode *Next;
    void *BufferCursor;
    LONG ReadRemaining;
    LONG WriteRemaining;
    void *BufferBase;
    LONG BufferCapacity;
    ULONG OpenFlags;
    LONG HandleIndex;
    UBYTE InlineByte;
    UBYTE Pad33;
};

extern ULONG Global_DefaultHandleFlags;

extern LONG UNKNOWN36_FinalizeRequest(struct PreallocHandleNode *node);
extern LONG HANDLE_OpenEntryWithFlags(const char *name, ULONG flags, LONG size);

struct PreallocHandleNode *HANDLE_OpenFromModeString(
    const char *path,
    const char *mode,
    struct PreallocHandleNode *node)
{
    ULONG defaultHandleFlags;
    LONG modeIndex;
    LONG plusMode;
    LONG openHandle;
    ULONG openFlags;
    ULONG finalFlags;

    if (node->OpenFlags != 0) {
        UNKNOWN36_FinalizeRequest(node);
    }

    defaultHandleFlags = Global_DefaultHandleFlags;
    modeIndex = 1;

    if ((UBYTE)mode[modeIndex] == (UBYTE)'b') {
        defaultHandleFlags = 0x8000;
        modeIndex += 1;
    } else if ((UBYTE)mode[modeIndex] == (UBYTE)'a') {
        defaultHandleFlags = 0;
        modeIndex += 1;
    }

    plusMode = ((UBYTE)mode[modeIndex] == (UBYTE)'+') ? -1 : 0;

    if ((UBYTE)mode[0] == (UBYTE)'w') {
        openFlags = (plusMode != 0) ? 2 : 1;
        openFlags |= 0x8000;
        openFlags |= 0x100;
        openFlags |= 0x200;
        openHandle = HANDLE_OpenEntryWithFlags(path, openFlags, 12);
        if (openHandle == -1) {
            return (struct PreallocHandleNode *)0;
        }

        finalFlags = (plusMode != 0) ? 128 : 2;
    } else if ((UBYTE)mode[0] == (UBYTE)'r') {
        openFlags = (plusMode != 0) ? 2 : 0;
        openFlags |= 0x8000;
        openHandle = HANDLE_OpenEntryWithFlags(path, openFlags, 12);
        if (openHandle == -1) {
            return (struct PreallocHandleNode *)0;
        }

        finalFlags = (plusMode != 0) ? 128 : 1;
    } else if ((UBYTE)mode[0] == (UBYTE)'a') {
        openHandle = HANDLE_OpenEntryWithFlags(path, 0x8102, 12);
        if (openHandle == -1) {
            return (struct PreallocHandleNode *)0;
        }

        finalFlags = (plusMode != 0) ? 128 : 2;
        finalFlags |= 0x4000;
    } else {
        return (struct PreallocHandleNode *)0;
    }

    node->BufferBase = (void *)0;
    node->BufferCapacity = 0;
    node->HandleIndex = openHandle;
    node->BufferCursor = node->BufferBase;
    node->WriteRemaining = 0;
    node->ReadRemaining = 0;

    openFlags = 0;
    if (defaultHandleFlags == 0) {
        openFlags = 0x8000;
    }

    node->OpenFlags = finalFlags | openFlags;

    return node;
}
