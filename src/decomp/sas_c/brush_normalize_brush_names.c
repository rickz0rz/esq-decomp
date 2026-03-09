typedef unsigned char UBYTE;

enum {
    BRUSH_NULL = 0,
    BRUSH_NAME_SCRATCH_SIZE = 40,
    BRUSH_NODE_NEXT_OFFSET = 368
};

UBYTE *GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator(UBYTE *path);

typedef struct BRUSH_Node {
    UBYTE name[BRUSH_NODE_NEXT_OFFSET];
    struct BRUSH_Node *next;
} BRUSH_Node;

void BRUSH_NormalizeBrushNames(void **headPtr)
{
    BRUSH_Node *node;

    node = (BRUSH_Node *)*headPtr;
    while (node != (BRUSH_Node *)BRUSH_NULL) {
        UBYTE scratch[BRUSH_NAME_SCRATCH_SIZE];
        UBYTE *sourceCursor;
        UBYTE *destCursor;

        sourceCursor = node->name;
        destCursor = scratch;
        do {
            *destCursor++ = *sourceCursor;
        } while (*sourceCursor++ != (UBYTE)BRUSH_NULL);

        sourceCursor = GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator(scratch);
        destCursor = node->name;
        do {
            *destCursor++ = *sourceCursor;
        } while (*sourceCursor++ != (UBYTE)BRUSH_NULL);

        node = node->next;
    }
}
