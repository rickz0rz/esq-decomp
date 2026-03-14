#include <exec/types.h>

enum {
    BRUSH_NULL = 0,
    BRUSH_TRUE = 1,
    BRUSH_NODE_TYPE_OFFSET = 32,
    BRUSH_NODE_NEXT_OFFSET = 368,
    BRUSH_NODE_TYPE_3 = 3
};

void *BRUSH_FindType3Brush(void *listHeadPtr)
{
    typedef struct BRUSH_Node {
        UBYTE pad0[BRUSH_NODE_TYPE_OFFSET];
        UBYTE type32;
        UBYTE pad33[BRUSH_NODE_NEXT_OFFSET - BRUSH_NODE_TYPE_OFFSET - 1];
        struct BRUSH_Node *next;
    } BRUSH_Node;

    BRUSH_Node *nodeCursor;
    LONG matchFound;

    nodeCursor = *(BRUSH_Node **)listHeadPtr;
    matchFound = 0;

    while (nodeCursor != (BRUSH_Node *)BRUSH_NULL && matchFound == 0) {
        if (nodeCursor->type32 == BRUSH_NODE_TYPE_3) {
            matchFound = BRUSH_TRUE;
        }
        if (matchFound == 0) {
            nodeCursor = nodeCursor->next;
        }
    }

    if (matchFound != 0) {
        return (void *)nodeCursor;
    }
    return (void *)BRUSH_NULL;
}
