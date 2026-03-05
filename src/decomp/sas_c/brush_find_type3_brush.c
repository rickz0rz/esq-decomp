typedef unsigned char UBYTE;
typedef long LONG;

void *BRUSH_FindType3Brush(void *list_head_ptr)
{
    UBYTE *cur;
    LONG found;

    cur = *(UBYTE **)list_head_ptr;
    found = 0;

    while (cur != (UBYTE *)0 && found == 0) {
        if (cur[32] == 3) {
            found = 1;
        }
        if (found == 0) {
            cur = *(UBYTE **)(cur + 368);
        }
    }

    if (found != 0) {
        return (void *)cur;
    }
    return (void *)0;
}
