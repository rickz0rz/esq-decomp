typedef unsigned char UBYTE;
typedef long LONG;

enum {
    BRUSH_NULL = 0,
    BRUSH_FALSE = 0,
    BRUSH_TRUE = 1,
    BRUSH_NODE_TYPE_OFFSET = 32,
    BRUSH_NODE_NEXT_OFFSET = 368,
    BRUSH_NODE_TYPE_3 = 3
};

void *BRUSH_FindType3Brush(void *listHeadPtr)
{
    UBYTE *nodeCursor;
    LONG matchFound;

    nodeCursor = *(UBYTE **)listHeadPtr;
    matchFound = BRUSH_FALSE;

    while (nodeCursor != (UBYTE *)BRUSH_NULL && matchFound == BRUSH_FALSE) {
        if (nodeCursor[BRUSH_NODE_TYPE_OFFSET] == BRUSH_NODE_TYPE_3) {
            matchFound = BRUSH_TRUE;
        }
        if (matchFound == BRUSH_FALSE) {
            nodeCursor = *(UBYTE **)(nodeCursor + BRUSH_NODE_NEXT_OFFSET);
        }
    }

    if (matchFound != BRUSH_FALSE) {
        return (void *)nodeCursor;
    }
    return (void *)BRUSH_NULL;
}
