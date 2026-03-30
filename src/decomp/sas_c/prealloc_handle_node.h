#ifndef PREALLOC_HANDLE_NODE_H
#define PREALLOC_HANDLE_NODE_H

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

#endif
