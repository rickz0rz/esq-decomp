typedef unsigned char UBYTE;
typedef long LONG;

enum {
    BRUSH_NODE_TYPE_OFFSET = 32,
    BRUSH_NODE_NEXT_OFFSET = 368,
    BRUSH_NODE_TYPE_3 = 3
};

void *BRUSH_FindType3Brush(void *list_head_ptr)
{
    UBYTE *cur;
    LONG found;

    cur = *(UBYTE **)list_head_ptr;
    found = 0;

    while (cur != (UBYTE *)0 && found == 0) {
        if (cur[BRUSH_NODE_TYPE_OFFSET] == BRUSH_NODE_TYPE_3) {
            found = 1;
        }
        if (found == 0) {
            cur = *(UBYTE **)(cur + BRUSH_NODE_NEXT_OFFSET);
        }
    }

    if (found != 0) {
        return (void *)cur;
    }
    return (void *)0;
}
