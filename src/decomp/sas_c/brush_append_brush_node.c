void *BRUSH_AppendBrushNode(void *head, void *node)
{
    unsigned char *cur;

    if (head == 0) {
        return node;
    }

    cur = (unsigned char *)head;
    while (*(void **)(cur + 368) != 0) {
        cur = *(unsigned char **)(cur + 368);
    }

    *(void **)(cur + 368) = node;
    return head;
}
