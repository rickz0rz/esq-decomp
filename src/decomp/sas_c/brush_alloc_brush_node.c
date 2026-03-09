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
    BRUSH_NODE_NEXT_OFFSET = 234
};

static const ULONG MEMF_PUBLIC_CLEAR = 0x10001UL;

extern const UBYTE Global_STR_BRUSH_C_19[];
extern void *BRUSH_LastAllocatedNode;

void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const void *tag, LONG line, LONG bytes, ULONG flags);

typedef struct BRUSH_Node {
    UBYTE name[BRUSH_NODE_TYPE_OFFSET];
    UBYTE type190;
    UBYTE pad191[3];
    LONG loadColor194;
    UBYTE pad198[24];
    ULONG alignH222;
    ULONG alignV226;
    UBYTE pad230[4];
    struct BRUSH_Node *next;
} BRUSH_Node;

void *BRUSH_AllocBrushNode(const char *brushLabel, void *prevTail)
{
    BRUSH_Node *node;
    const UBYTE *labelCursor;
    UBYTE *nodeCursor;

    node = (BRUSH_Node *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_BRUSH_C_19,
        BRUSH_ALLOC_LINE,
        BRUSH_DESCRIPTOR_NODE_SIZE,
        MEMF_PUBLIC_CLEAR
    );
    BRUSH_LastAllocatedNode = (void *)node;
    if (node == (BRUSH_Node *)BRUSH_NULL) {
        return BRUSH_LastAllocatedNode;
    }

    labelCursor = (const UBYTE *)brushLabel;
    nodeCursor = node->name;
    do {
        *nodeCursor++ = *labelCursor;
    } while (*labelCursor++ != (UBYTE)BRUSH_NULL);

    node->loadColor194 = BRUSH_TRUE;
    node->type190 = BRUSH_NULL;
    node->alignH222 = BRUSH_NULL;
    node->alignV226 = BRUSH_NULL;
    if (prevTail != (void *)BRUSH_NULL) {
        ((BRUSH_Node *)prevTail)->next = node;
    }
    node->next = (BRUSH_Node *)BRUSH_NULL;

    return BRUSH_LastAllocatedNode;
}
