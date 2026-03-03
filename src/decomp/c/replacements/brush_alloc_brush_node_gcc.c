#include "esq_types.h"

/*
 * Target 696 GCC trial function.
 * Allocate and initialize a brush node; optionally link from previous tail.
 */
extern u8 Global_STR_BRUSH_C_19[];
extern void *BRUSH_LastAllocatedNode;

void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const void *tag, s32 line, s32 bytes, u32 flags) __attribute__((noinline));

void *BRUSH_AllocBrushNode(const char *label, void *prev_tail) __attribute__((noinline, used));

void *BRUSH_AllocBrushNode(const char *label, void *prev_tail)
{
    u8 *node;
    const u8 *src;
    u8 *dst;

    node = (u8 *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(Global_STR_BRUSH_C_19, 1352, 238, 0x10001u);
    BRUSH_LastAllocatedNode = node;
    if (node == 0) {
        return BRUSH_LastAllocatedNode;
    }

    src = (const u8 *)label;
    dst = node;
    do {
        *dst++ = *src;
    } while (*src++ != 0);

    *(s32 *)(node + 194) = 1;
    *(u8 *)(node + 190) = 0;
    *(u32 *)(node + 222) = 0;
    *(u32 *)(node + 226) = 0;
    if (prev_tail != 0) {
        *(void **)((u8 *)prev_tail + 234) = node;
    }
    *(void **)(node + 234) = 0;

    return BRUSH_LastAllocatedNode;
}
