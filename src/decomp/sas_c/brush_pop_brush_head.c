enum {
    BRUSH_NODE_NEXT_OFFSET = 368
};

void BRUSH_FreeBrushList(void **head_ptr, long free_one);

void *BRUSH_PopBrushHead(void *head)
{
    void *next;
    void *local_head;

    if (head == 0) {
        next = (void *)0;
    } else {
        next = *(void **)((unsigned char *)head + BRUSH_NODE_NEXT_OFFSET);
        local_head = head;
        BRUSH_FreeBrushList(&local_head, 1);
    }

    return next;
}
