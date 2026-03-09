enum {
    BRUSH_NULL = 0,
    BRUSH_NODE_NEXT_OFFSET = 368
};

typedef struct BRUSH_Node {
    unsigned char pad0[BRUSH_NODE_NEXT_OFFSET];
    struct BRUSH_Node *next;
} BRUSH_Node;

void *BRUSH_AppendBrushNode(void *head, void *node)
{
    BRUSH_Node *tailCursor;

    if (head == (void *)BRUSH_NULL) {
        return node;
    }

    tailCursor = (BRUSH_Node *)head;
    while (tailCursor->next != (BRUSH_Node *)BRUSH_NULL) {
        tailCursor = tailCursor->next;
    }

    tailCursor->next = (BRUSH_Node *)node;
    return head;
}
