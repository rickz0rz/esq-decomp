enum {
    BRUSH_NULL = 0,
    BRUSH_NODE_NEXT_OFFSET = 368
};

void *BRUSH_AppendBrushNode(void *head, void *node)
{
    unsigned char *cur;

    if (head == (void *)BRUSH_NULL) {
        return node;
    }

    cur = (unsigned char *)head;
    while (*(void **)(cur + BRUSH_NODE_NEXT_OFFSET) != (void *)BRUSH_NULL) {
        cur = *(unsigned char **)(cur + BRUSH_NODE_NEXT_OFFSET);
    }

    *(void **)(cur + BRUSH_NODE_NEXT_OFFSET) = node;
    return head;
}
