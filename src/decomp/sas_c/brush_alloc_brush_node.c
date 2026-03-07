typedef unsigned char UBYTE;
typedef unsigned long ULONG;
typedef long LONG;

enum {
    BRUSH_NULL = 0,
    BRUSH_TRUE = 1,
    BRUSH_ALLOC_LINE = 1352,
    BRUSH_DESCRIPTOR_NODE_SIZE = 238,
    BRUSH_NODE_TYPE_OFFSET = 190,
    BRUSH_NODE_LOADCOLOR_OFFSET = 194,
    BRUSH_NODE_ALIGN_H_OFFSET = 222,
    BRUSH_NODE_ALIGN_V_OFFSET = 226,
    BRUSH_NODE_NEXT_OFFSET = 234,
    MEMF_PUBLIC_CLEAR = 0x10001UL
};

extern const UBYTE Global_STR_BRUSH_C_19[];
extern void *BRUSH_LastAllocatedNode;

void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const void *tag, LONG line, LONG bytes, ULONG flags);

void *BRUSH_AllocBrushNode(const char *label, void *prevTail)
{
    UBYTE *node;
    const UBYTE *labelCursor;
    UBYTE *nodeCursor;

    node = (UBYTE *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_BRUSH_C_19,
        BRUSH_ALLOC_LINE,
        BRUSH_DESCRIPTOR_NODE_SIZE,
        MEMF_PUBLIC_CLEAR
    );
    BRUSH_LastAllocatedNode = (void *)node;
    if (node == (UBYTE *)BRUSH_NULL) {
        return BRUSH_LastAllocatedNode;
    }

    labelCursor = (const UBYTE *)label;
    nodeCursor = node;
    do {
        *nodeCursor++ = *labelCursor;
    } while (*labelCursor++ != (UBYTE)BRUSH_NULL);

    *(LONG *)(node + BRUSH_NODE_LOADCOLOR_OFFSET) = BRUSH_TRUE;
    *(UBYTE *)(node + BRUSH_NODE_TYPE_OFFSET) = BRUSH_NULL;
    *(ULONG *)(node + BRUSH_NODE_ALIGN_H_OFFSET) = BRUSH_NULL;
    *(ULONG *)(node + BRUSH_NODE_ALIGN_V_OFFSET) = BRUSH_NULL;
    if (prevTail != (void *)BRUSH_NULL) {
        *(void **)((UBYTE *)prevTail + BRUSH_NODE_NEXT_OFFSET) = (void *)node;
    }
    *(void **)(node + BRUSH_NODE_NEXT_OFFSET) = (void *)BRUSH_NULL;

    return BRUSH_LastAllocatedNode;
}
