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

void *BRUSH_FindType3Brush(void *list_head_ptr)
{
    UBYTE *cur;
    LONG found;

    cur = *(UBYTE **)list_head_ptr;
    found = BRUSH_FALSE;

    while (cur != (UBYTE *)BRUSH_NULL && found == BRUSH_FALSE) {
        if (cur[BRUSH_NODE_TYPE_OFFSET] == BRUSH_NODE_TYPE_3) {
            found = BRUSH_TRUE;
        }
        if (found == BRUSH_FALSE) {
            cur = *(UBYTE **)(cur + BRUSH_NODE_NEXT_OFFSET);
        }
    }

    if (found != BRUSH_FALSE) {
        return (void *)cur;
    }
    return (void *)BRUSH_NULL;
}
