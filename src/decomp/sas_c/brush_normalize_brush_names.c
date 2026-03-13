typedef unsigned char UBYTE;

enum {
    BRUSH_NULL = 0,
    BRUSH_NAME_SCRATCH_SIZE = 40,
    BRUSH_NODE_NEXT_OFFSET = 368
};

char *GCOMMAND_FindPathSeparator(const char *path);

typedef struct BRUSH_Node {
    char name[BRUSH_NODE_NEXT_OFFSET];
    struct BRUSH_Node *next;
} BRUSH_Node;

void BRUSH_NormalizeBrushNames(void **headPtr)
{
    BRUSH_Node *node;

    node = (BRUSH_Node *)*headPtr;
    while (node != (BRUSH_Node *)BRUSH_NULL) {
        char scratch[BRUSH_NAME_SCRATCH_SIZE];
        char *sourceCursor;
        char *destCursor;

        sourceCursor = node->name;
        destCursor = scratch;
        do {
            *destCursor++ = *sourceCursor;
        } while (*sourceCursor++ != BRUSH_NULL);

        sourceCursor = GCOMMAND_FindPathSeparator(scratch);
        destCursor = node->name;
        do {
            *destCursor++ = *sourceCursor;
        } while (*sourceCursor++ != BRUSH_NULL);

        node = node->next;
    }
}
