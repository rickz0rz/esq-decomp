typedef unsigned char UBYTE;
typedef long LONG;

enum {
    BRUSH_RESOURCE_NEXT_OFFSET = 234,
    BRUSH_RESOURCE_NODE_SIZE = 238
};

extern const UBYTE Global_STR_BRUSH_C_9[];

void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, LONG line, void *ptr, LONG bytes);

void BRUSH_FreeBrushResources(void **head_ptr)
{
    UBYTE *node;

    node = (UBYTE *)*head_ptr;
    while (node != (UBYTE *)0) {
        UBYTE *next;

        next = *(UBYTE **)(node + BRUSH_RESOURCE_NEXT_OFFSET);
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_BRUSH_C_9, 887, (void *)node, BRUSH_RESOURCE_NODE_SIZE);
        node = next;
    }

    *head_ptr = (void *)0;
}
