#include <exec/types.h>
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
