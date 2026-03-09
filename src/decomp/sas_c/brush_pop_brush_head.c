enum {
    BRUSH_NULL = 0,
    BRUSH_FREE_ONE = 1,
    BRUSH_NODE_NEXT_OFFSET = 368
};

void BRUSH_FreeBrushList(void **head_ptr, long free_one);

typedef struct BRUSH_Node {
    unsigned char pad0[BRUSH_NODE_NEXT_OFFSET];
    struct BRUSH_Node *next;
} BRUSH_Node;

void *BRUSH_PopBrushHead(void *head)
{
    BRUSH_Node *next;
    void *singleNodeHead;

    if (head == (void *)BRUSH_NULL) {
        next = (BRUSH_Node *)BRUSH_NULL;
    } else {
        next = ((BRUSH_Node *)head)->next;
        singleNodeHead = head;
        BRUSH_FreeBrushList(&singleNodeHead, BRUSH_FREE_ONE);
    }

    return (void *)next;
}
