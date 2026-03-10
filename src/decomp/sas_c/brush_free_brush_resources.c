typedef unsigned char UBYTE;
typedef long LONG;

enum {
    BRUSH_NULL = 0,
    BRUSH_RESOURCE_NEXT_OFFSET = 234,
    BRUSH_RESOURCE_NODE_SIZE = 238
};

extern const char Global_STR_BRUSH_C_9[];

void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const char *tag, LONG line, void *ptr, LONG bytes);

void BRUSH_FreeBrushResources(void **headPtr)
{
    UBYTE *resourceNode;

    resourceNode = (UBYTE *)*headPtr;
    while (resourceNode != (UBYTE *)BRUSH_NULL) {
        UBYTE *nextNode;

        nextNode = *(UBYTE **)(resourceNode + BRUSH_RESOURCE_NEXT_OFFSET);
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_BRUSH_C_9, 887, (void *)resourceNode, BRUSH_RESOURCE_NODE_SIZE);
        resourceNode = nextNode;
    }

    *headPtr = (void *)BRUSH_NULL;
}
