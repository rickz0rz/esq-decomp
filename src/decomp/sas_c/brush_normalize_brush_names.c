typedef unsigned char UBYTE;

enum {
    BRUSH_NULL = 0,
    BRUSH_NAME_SCRATCH_SIZE = 40,
    BRUSH_NODE_NEXT_OFFSET = 368
};

UBYTE *GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator(UBYTE *path);

void BRUSH_NormalizeBrushNames(void **head_ptr)
{
    UBYTE *node;

    node = (UBYTE *)*head_ptr;
    while (node != (UBYTE *)BRUSH_NULL) {
        UBYTE scratch[BRUSH_NAME_SCRATCH_SIZE];
        UBYTE *src;
        UBYTE *dst;

        src = node;
        dst = scratch;
        do {
            *dst++ = *src;
        } while (*src++ != (UBYTE)BRUSH_NULL);

        src = GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator(scratch);
        dst = node;
        do {
            *dst++ = *src;
        } while (*src++ != (UBYTE)BRUSH_NULL);

        node = *(UBYTE **)(node + BRUSH_NODE_NEXT_OFFSET);
    }
}
