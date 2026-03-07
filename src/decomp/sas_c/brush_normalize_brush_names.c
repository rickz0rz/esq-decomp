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
        UBYTE *sourceCursor;
        UBYTE *destCursor;

        sourceCursor = node;
        destCursor = scratch;
        do {
            *destCursor++ = *sourceCursor;
        } while (*sourceCursor++ != (UBYTE)BRUSH_NULL);

        sourceCursor = GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator(scratch);
        destCursor = node;
        do {
            *destCursor++ = *sourceCursor;
        } while (*sourceCursor++ != (UBYTE)BRUSH_NULL);

        node = *(UBYTE **)(node + BRUSH_NODE_NEXT_OFFSET);
    }
}
