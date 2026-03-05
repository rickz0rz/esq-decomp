typedef unsigned char UBYTE;
typedef long LONG;

extern UBYTE Global_STR_BRUSH_C_9[];

void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, LONG line, void *ptr, LONG bytes);

void BRUSH_FreeBrushResources(void **head_ptr)
{
    UBYTE *node;

    node = (UBYTE *)*head_ptr;
    while (node != (UBYTE *)0) {
        UBYTE *next;

        next = *(UBYTE **)(node + 234);
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_BRUSH_C_9, 887, (void *)node, 238);
        node = next;
    }

    *head_ptr = (void *)0;
}
