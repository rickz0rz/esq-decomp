typedef unsigned char UBYTE;

enum {
    BRUSH_NODE_NEXT_OFFSET = 368
};

UBYTE *GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator(UBYTE *path);

void BRUSH_NormalizeBrushNames(void **head_ptr)
{
    UBYTE *node;

    node = (UBYTE *)*head_ptr;
    while (node != (UBYTE *)0) {
        UBYTE scratch[40];
        UBYTE *src;
        UBYTE *dst;

        src = node;
        dst = scratch;
        do {
            *dst++ = *src;
        } while (*src++ != (UBYTE)0);

        src = GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator(scratch);
        dst = node;
        do {
            *dst++ = *src;
        } while (*src++ != (UBYTE)0);

        node = *(UBYTE **)(node + BRUSH_NODE_NEXT_OFFSET);
    }
}
