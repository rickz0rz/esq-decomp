typedef long LONG;

enum {
    BRUSH_NULL = 0,
    BRUSH_NODE_NEXT_OFFSET = 368
};

LONG GROUP_AA_JMPTBL_STRING_CompareNoCase(void *a, void *b);

void *BRUSH_FindBrushByPredicate(void *key, void *listHeadPtr)
{
    unsigned char *nodeCursor;

    nodeCursor = *(unsigned char **)listHeadPtr;
    while (nodeCursor != (unsigned char *)BRUSH_NULL) {
        if (GROUP_AA_JMPTBL_STRING_CompareNoCase((void *)nodeCursor, key) == BRUSH_NULL) {
            return (void *)nodeCursor;
        }
        nodeCursor = *(unsigned char **)(nodeCursor + BRUSH_NODE_NEXT_OFFSET);
    }

    return (void *)BRUSH_NULL;
}
