enum {
    BRUSH_NULL = 0,
    BRUSH_NODE_NEXT_OFFSET = 368
};

void *BRUSH_AppendBrushNode(void *head, void *node)
{
    unsigned char *tailCursor;

    if (head == (void *)BRUSH_NULL) {
        return node;
    }

    tailCursor = (unsigned char *)head;
    while (*(void **)(tailCursor + BRUSH_NODE_NEXT_OFFSET) != (void *)BRUSH_NULL) {
        tailCursor = *(unsigned char **)(tailCursor + BRUSH_NODE_NEXT_OFFSET);
    }

    *(void **)(tailCursor + BRUSH_NODE_NEXT_OFFSET) = node;
    return head;
}
