enum {
    BRUSH_NODE_NEXT_OFFSET = 368
};

void *BRUSH_AppendBrushNode(void *head, void *node)
{
    unsigned char *cur;

    if (head == 0) {
        return node;
    }

    cur = (unsigned char *)head;
    while (*(void **)(cur + BRUSH_NODE_NEXT_OFFSET) != 0) {
        cur = *(unsigned char **)(cur + BRUSH_NODE_NEXT_OFFSET);
    }

    *(void **)(cur + BRUSH_NODE_NEXT_OFFSET) = node;
    return head;
}
