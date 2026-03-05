typedef unsigned char UBYTE;
typedef unsigned long ULONG;
typedef long LONG;

extern UBYTE Global_STR_BRUSH_C_19[];
extern void *BRUSH_LastAllocatedNode;

void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const void *tag, LONG line, LONG bytes, ULONG flags);

void *BRUSH_AllocBrushNode(const char *label, void *prev_tail)
{
    UBYTE *node;
    const UBYTE *src;
    UBYTE *dst;

    node = (UBYTE *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(Global_STR_BRUSH_C_19, 1352, 238, 0x10001UL);
    BRUSH_LastAllocatedNode = (void *)node;
    if (node == (UBYTE *)0) {
        return BRUSH_LastAllocatedNode;
    }

    src = (const UBYTE *)label;
    dst = node;
    do {
        *dst++ = *src;
    } while (*src++ != (UBYTE)0);

    *(LONG *)(node + 194) = 1;
    *(UBYTE *)(node + 190) = 0;
    *(ULONG *)(node + 222) = 0;
    *(ULONG *)(node + 226) = 0;
    if (prev_tail != (void *)0) {
        *(void **)((UBYTE *)prev_tail + 234) = (void *)node;
    }
    *(void **)(node + 234) = (void *)0;

    return BRUSH_LastAllocatedNode;
}
