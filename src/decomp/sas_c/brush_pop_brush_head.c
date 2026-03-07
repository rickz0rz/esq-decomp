enum {
    BRUSH_NULL = 0,
    BRUSH_FREE_ONE = 1,
    BRUSH_NODE_NEXT_OFFSET = 368
};

void BRUSH_FreeBrushList(void **head_ptr, long free_one);

void *BRUSH_PopBrushHead(void *head)
{
    void *next;
    void *local_head;

    if (head == (void *)BRUSH_NULL) {
        next = (void *)BRUSH_NULL;
    } else {
        next = *(void **)((unsigned char *)head + BRUSH_NODE_NEXT_OFFSET);
        local_head = head;
        BRUSH_FreeBrushList(&local_head, BRUSH_FREE_ONE);
    }

    return next;
}
