#include <exec/types.h>

enum {
    BRUSH_NULL = 0,
    BRUSH_NODE_NEXT_OFFSET = 368
};

LONG STRING_CompareNoCase(const char *a, const char *b);

typedef struct BRUSH_Node {
    unsigned char pad0[BRUSH_NODE_NEXT_OFFSET];
    struct BRUSH_Node *next;
} BRUSH_Node;

void *BRUSH_FindBrushByPredicate(void *searchKey, void *listHeadPtr)
{
    BRUSH_Node *nodeCursor;

    nodeCursor = *(BRUSH_Node **)listHeadPtr;
    while (nodeCursor != (BRUSH_Node *)BRUSH_NULL) {
        if (STRING_CompareNoCase((const char *)nodeCursor, (const char *)searchKey) == BRUSH_NULL) {
            return (void *)nodeCursor;
        }
        nodeCursor = nodeCursor->next;
    }

    return (void *)BRUSH_NULL;
}
